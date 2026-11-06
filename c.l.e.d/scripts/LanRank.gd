extends Node
# ═══════════════════════════════════════════════════════
#  LAN RANK  |  scripts/LanRank.gd  (Autoload)
#  The Class Ranking on the local network. There is no server and no host:
#  every CLID on the same Wi-Fi shares its player's username, lesson stars
#  and Simulation best scores every few seconds (a small UDP broadcast), and
#  the Rank board (RankOverlay.gd) lists everyone this game hears.
#  Desktop builds only: a web page can't send or receive local network packets.
# ═══════════════════════════════════════════════════════

signal changed   # a classmate appeared, left or has new scores

const PORT := 47823
const APP_TAG := "CLID"
const VERSION := 1
const SEND_EVERY := 3.0           # seconds between broadcasts
const FORGET_AFTER_MS := 90000    # a classmate not heard from for this long leaves the board
const MAX_PEERS := 200
const MAX_PACKET := 2048          # bytes; ours are about 300
const WORLDS := ["hotel", "cafe", "airport", "library"]
const SIM_FOLDERS := ["basic", "filtering", "sorting"]   # "Your Progress" is not ranked
const MAX_STARS := 51             # 17 lessons × 3 stars per world
const MAX_SCORE := 9999
const NAME_PATTERN := "^[A-Za-z0-9_]{3,20}$"   # the same rule as the sign-up form

var supported: bool = not OS.has_feature("web")
var listening: bool = false        # hearing classmates (starts when the Rank board first opens)
var listen_failed: bool = false    # the port was busy, e.g. a second CLID window on this PC

var _peers: Dictionary = {}        # "device id|name" → {name, stars, sim, seen}
var _send_sock: PacketPeerUDP = null
var _recv_sock: PacketPeerUDP = null
var _send_wait: float = 1.0
var _expire_wait: float = 1.0
var _name_regex := RegEx.new()

func _ready() -> void:
	_name_regex.compile(NAME_PATTERN)
	set_process(supported)

func _process(delta: float) -> void:
	if listening:
		_receive()
	_send_wait -= delta
	if _send_wait <= 0.0:
		_send_wait = SEND_EVERY
		_broadcast()
	_expire_wait -= delta
	if _expire_wait <= 0.0:
		_expire_wait = 1.0
		_forget_old()

# Starts hearing classmates. Called when the Rank board opens; on Windows this
# is when the firewall may ask to allow CLID on the network.
func start_listening() -> void:
	if not supported or listening:
		return
	_recv_sock = PacketPeerUDP.new()
	if _recv_sock.bind(PORT, "0.0.0.0") != OK:
		_recv_sock = null
		listen_failed = true
		return
	listening = true
	listen_failed = false
	_send_wait = 0.0   # share right away so the others see this player too

func classmate_count() -> int:
	return _peers.size()

# Everyone for the board: the classmates heard on the network plus this
# player (marked "you"), each as {name, stars: {world: n}, sim: {world: [b, f, s]}}.
func board() -> Array:
	var out: Array = []
	for key in _peers:
		var p: Dictionary = _peers[key]
		out.append({"name": p.name, "stars": p.stars, "sim": p.sim, "you": false})
	if not GameManager.current_user.is_empty():
		var me: Dictionary = my_scores()
		me["you"] = true
		out.append(me)
	return out

# This player's scores, as they are shared.
func my_scores() -> Dictionary:
	var stars: Dictionary = {}
	var sim: Dictionary = {}
	for w in WORLDS:
		stars[w] = mini(GameManager.world_star_total(w), MAX_STARS)
		var best: Array = []
		for f in SIM_FOLDERS:
			best.append(clampi(GameManager.get_sim_best(w + "_" + f), 0, MAX_SCORE))
		sim[w] = best
	return {"name": GameManager.current_user, "stars": stars, "sim": sim}

# ── Sending ────────────────────────────────────────────
func _broadcast() -> void:
	if GameManager.current_user.is_empty() or not GameManager.lan_share_enabled:
		return
	var targets: Array = _broadcast_addresses()
	if targets.is_empty():
		return   # not on a local network (no Wi-Fi / LAN address)
	if GameManager.lan_device_id.is_empty():
		GameManager.lan_device_id = Crypto.new().generate_random_bytes(8).hex_encode()
		GameManager.save_settings()
	var msg: Dictionary = my_scores()
	msg["app"] = APP_TAG
	msg["v"] = VERSION
	msg["id"] = GameManager.lan_device_id
	var data: PackedByteArray = JSON.stringify(msg).to_utf8_buffer()
	if _send_sock == null:
		_send_sock = PacketPeerUDP.new()
		_send_sock.set_broadcast_enabled(true)
	for addr in targets:
		_send_sock.set_dest_address(addr, PORT)
		_send_sock.put_packet(data)

# The whole-network address plus each Wi-Fi/LAN card's own one (assumes the
# usual 255.255.255.0 network, e.g. 192.168.1.x → 192.168.1.255). Windows
# sends 255.255.255.255 out of one network card only, so both are used.
func _broadcast_addresses() -> Array:
	var out: Array = []
	for ip in IP.get_local_addresses():
		if not _is_private_ipv4(ip):
			continue
		var parts: PackedStringArray = ip.split(".")
		var addr: String = "%s.%s.%s.255" % [parts[0], parts[1], parts[2]]
		if not out.has(addr):
			out.append(addr)
	if not out.is_empty():
		out.push_front("255.255.255.255")
	return out

func _is_private_ipv4(ip: String) -> bool:
	if not ip.is_valid_ip_address() or ip.count(".") != 3:
		return false
	var p: PackedStringArray = ip.split(".")
	var a: int = p[0].to_int()
	var b: int = p[1].to_int()
	return a == 10 or (a == 172 and b >= 16 and b <= 31) or (a == 192 and b == 168)

# ── Receiving ──────────────────────────────────────────
func _receive() -> void:
	var dirty: bool = false
	var guard: int = 0
	while _recv_sock.get_available_packet_count() > 0 and guard < 256:
		guard += 1
		var pkt: PackedByteArray = _recv_sock.get_packet()
		if pkt.size() > MAX_PACKET:
			continue
		var entry: Dictionary = _parse(pkt.get_string_from_utf8())
		if entry.is_empty():
			continue
		# Our own broadcast comes back to us too: skip it
		if entry.id == GameManager.lan_device_id and entry.name.to_lower() == GameManager.current_user.to_lower():
			continue
		var key: String = entry.id + "|" + entry.name.to_lower()
		var old = _peers.get(key)
		if old == null:
			if _peers.size() >= MAX_PEERS:
				continue
			dirty = true
		elif old.name != entry.name or old.stars != entry.stars or old.sim != entry.sim:
			dirty = true
		entry["seen"] = Time.get_ticks_msec()
		_peers[key] = entry
	if dirty:
		changed.emit()

# Reads one classmate's packet. Anything unexpected is ignored ({}), and every
# number is kept within the game's real limits.
func _parse(text: String) -> Dictionary:
	var json := JSON.new()
	if json.parse(text) != OK:   # (unlike JSON.parse_string, this doesn't print an error)
		return {}
	var d = json.data
	if typeof(d) != TYPE_DICTIONARY or d.get("app") != APP_TAG:
		return {}
	var v = d.get("v")
	if not (v is float or v is int) or int(v) != VERSION:
		return {}
	var id = d.get("id")
	var player = d.get("name")
	var stars_in = d.get("stars")
	var sim_in = d.get("sim")
	if not (id is String) or id.is_empty() or id.length() > 64:
		return {}
	if not (player is String) or _name_regex.search(player) == null:
		return {}
	if not (stars_in is Dictionary) or not (sim_in is Dictionary):
		return {}
	var stars: Dictionary = {}
	var sim: Dictionary = {}
	for w in WORLDS:
		stars[w] = _num(stars_in.get(w), MAX_STARS)
		var arr = sim_in.get(w)
		var best: Array = []
		for i in SIM_FOLDERS.size():
			best.append(_num(arr[i] if arr is Array and i < arr.size() else 0, MAX_SCORE))
		sim[w] = best
	return {"id": id, "name": player, "stars": stars, "sim": sim}

func _num(value, top: int) -> int:
	if value is float or value is int:
		return clampi(int(value), 0, top)
	return 0

func _forget_old() -> void:
	var now: int = Time.get_ticks_msec()
	var gone: Array = []
	for key in _peers:
		if now - int(_peers[key].seen) > FORGET_AFTER_MS:
			gone.append(key)
	for key in gone:
		_peers.erase(key)
	if not gone.is_empty():
		changed.emit()
