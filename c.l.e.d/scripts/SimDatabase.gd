extends RefCounted
class_name SimDatabase
# ═══════════════════════════════════════════════════════
#  SIM DATABASE  |  scripts/SimDatabase.gd
#  Thin wrapper around the godot-sqlite addon for one
#  Simulation run. One real in-memory database per run —
#  seeded once, then genuinely modified by correct answers
#  so changes persist for the rest of that run.
# ═══════════════════════════════════════════════════════

var _db: SQLite = null
var _seeded_tables: Dictionary = {}   # table_name -> Array[String] headers, in column order

func open() -> void:
	_db = SQLite.new()
	_db.path = ":memory:"
	_db.open_db()

func close() -> void:
	if _db:
		_db.close_db()
	_db = null

func has_table(table_name: String) -> bool:
	return _seeded_tables.has(table_name)

func known_tables() -> Array:
	return _seeded_tables.keys()

# types: Array of "TEXT" / "INTEGER" / "REAL", same length/order as headers.
# Safe to call more than once per table — later calls are ignored so a
# table already grown by earlier rounds is never reset mid-run.
func seed_table(table_name: String, headers: Array, types: Array, rows: Array) -> void:
	if _seeded_tables.has(table_name):
		return
	var col_defs: Array = []
	for i in range(headers.size()):
		var t: String = types[i] if i < types.size() else "TEXT"
		col_defs.append("%s %s" % [headers[i], t])
	_db.query("CREATE TABLE %s (%s);" % [table_name, ", ".join(col_defs)])
	for row in rows:
		_insert_raw(table_name, headers, row)
	_seeded_tables[table_name] = headers.duplicate()

func _insert_raw(table_name: String, headers: Array, row: Array) -> void:
	var vals: Array = []
	for v in row:
		vals.append(_sql_literal(v))
	_db.query("INSERT INTO %s (%s) VALUES (%s);" % [table_name, ", ".join(headers), ", ".join(vals)])

func _sql_literal(v) -> String:
	if v is float or v is int:
		return str(v)
	var s: String = str(v)
	if s.is_valid_int() or s.is_valid_float():
		return s
	return "'" + s.replace("'", "''") + "'"

# Runs the player's raw typed query as-is. Returns false if it fails to
# execute at all (syntax error, unknown table, etc.) — a real, honest
# failure, same as a real SQL client would give.
func run(query: String) -> bool:
	return _db.query(query)

func last_error() -> String:
	return _db.error_message

func last_result() -> Array:
	return _db.query_result

# Reads a table's current, live contents back as headers/rows (Strings),
# matching the display format every other table in the game already uses.
func fetch_rows(table_name: String) -> Array:
	if not _seeded_tables.has(table_name):
		return []
	var headers: Array = _seeded_tables[table_name]
	_db.query("SELECT * FROM %s;" % table_name)
	var rows: Array = []
	for row_dict in _db.query_result:
		var row: Array = []
		for h in headers:
			row.append(str(row_dict.get(h, "")))
		rows.append(row)
	return rows

func headers_for(table_name: String) -> Array:
	return _seeded_tables.get(table_name, [])
