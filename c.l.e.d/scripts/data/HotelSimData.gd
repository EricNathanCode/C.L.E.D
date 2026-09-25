extends Node
# ═══════════════════════════════════════════════════════
#  HOTEL SIMULATION DATA  |  scripts/data/HotelSimData.gd
#  Template pool for Hotel World's Simulation mode.
#  Each template's problem_template has {placeholders}
#  rolled fresh every time it's drawn. See SimulationScreen.gd
#  for how "kind" drives validation.
# ═══════════════════════════════════════════════════════

const TEMPLATES: Array = [

	# ── SELECT (unlocks after Lesson 1) ────────────────
	{
		"requires_lesson_index": 1, "kind": "select_basic",
		"table": "customers",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "101"], [2, "Maya", "Dela Cruz", "204"],
			[3, "Jose", "Hernandez", "312"], [4, "Carlos", "Garcia", "412"],
		],
		"problem": "Can you pull up every guest we have on file right now?",
		"role": "staff",
	},
	{
		"requires_lesson_index": 1, "kind": "select_basic",
		"table": "customers",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "101"], [2, "Maya", "Dela Cruz", "204"],
			[3, "Jose", "Hernandez", "312"], [4, "Carlos", "Garcia", "412"],
		],
		"problem": "I need the full guest list for the shift handover.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 1, "kind": "select_column",
		"table": "customers",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "101"], [2, "Maya", "Dela Cruz", "204"],
			[3, "Jose", "Hernandez", "312"], [4, "Carlos", "Garcia", "412"],
		],
		"problem_template": "I don't need everything — just show me everyone's {column}.",
		"pick_from_columns": ["first_name", "last_name", "room_no"],
		"role": "staff",
	},
	{
		"requires_lesson_index": 1, "kind": "select_column",
		"table": "customers",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "101"], [2, "Maya", "Dela Cruz", "204"],
			[3, "Jose", "Hernandez", "312"], [4, "Carlos", "Garcia", "412"],
		],
		"problem_template": "For the log book, I only need the {column} column, nothing else.",
		"pick_from_columns": ["first_name", "last_name", "room_no"],
		"role": "staff",
	},

	# ── INSERT INTO (unlocks after Lesson 2) ───────────
	{
		"requires_lesson_index": 2, "kind": "insert_into",
		"table": "customers",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "101"], [2, "Maya", "Dela Cruz", "204"],
			[3, "Jose", "Hernandez", "312"], [4, "Carlos", "Garcia", "412"],
		],
		"problem_template": "Hi, I'd like to check in. My name is {first} {last}, room {room}.",
		"variables": {
			"first": ["Linda", "Marco", "Sofia", "Ana", "Miguel"],
			"last":  ["Lim", "Reyes", "Torres", "Villanueva", "Cruz"],
			"room":  ["205", "108", "310", "217", "150"],
		},
		"insert_columns": ["first_name", "last_name", "room_no"],
	},
	{
		"requires_lesson_index": 2, "kind": "insert_into",
		"table": "customers",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "101"], [2, "Maya", "Dela Cruz", "204"],
			[3, "Jose", "Hernandez", "312"], [4, "Carlos", "Garcia", "412"],
		],
		"problem_template": "Checking in — {first} {last}. They put me in room {room}.",
		"variables": {
			"first": ["Elena", "Diego", "Grace", "Paolo", "Rosa"],
			"last":  ["Bautista", "Fernandez", "Santos", "Garcia", "Lim"],
			"room":  ["220", "115", "330", "240", "160"],
		},
		"insert_columns": ["first_name", "last_name", "room_no"],
	},

	# ── SELECT WHERE (unlocks after Lesson 3) ──────────
	{
		"requires_lesson_index": 3, "kind": "select_where",
		"table": "customers",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "101"], [2, "Maya", "Dela Cruz", "204"],
			[3, "Jose", "Hernandez", "312"], [4, "Carlos", "Garcia", "412"],
		],
		"problem_template": "Can you look up my reservation? Last name {value}.",
		"pick_from_column": "last_name",
	},
	{
		"requires_lesson_index": 3, "kind": "select_where",
		"table": "customers",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "101"], [2, "Maya", "Dela Cruz", "204"],
			[3, "Jose", "Hernandez", "312"], [4, "Carlos", "Garcia", "412"],
		],
		"problem_template": "I'm checking on the guest in room {value}. Can you confirm they're checked in?",
		"pick_from_column": "room_no",
		"role": "staff",
	},

	# ── UPDATE SET (unlocks after Lesson 4) ────────────
	{
		"requires_lesson_index": 4, "kind": "update_set",
		"table": "customers",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "101"], [2, "Maya", "Dela Cruz", "204"],
			[3, "Jose", "Hernandez", "312"], [4, "Carlos", "Garcia", "412"],
		],
		"problem_template": "We need to move guest id {target_id} to room {new_value}. Can you update that?",
		"set_column": "room_no",
		"pick_id_from": "id",
		"new_value_pool": ["500", "501", "502", "503"],
		"role": "staff",
	},
	{
		"requires_lesson_index": 4, "kind": "update_set",
		"table": "customers",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "101"], [2, "Maya", "Dela Cruz", "204"],
			[3, "Jose", "Hernandez", "312"], [4, "Carlos", "Garcia", "412"],
		],
		"problem_template": "Guest id {target_id} says their last name got misspelled — it should be {new_value}.",
		"set_column": "last_name",
		"pick_id_from": "id",
		"new_value_pool": ["Santoz", "DelaCruz", "Hernandes", "Garciah"],
		"role": "staff",
	},

	# ── DELETE (unlocks after Lesson 5) ────────────────
	{
		"requires_lesson_index": 5, "kind": "delete",
		"table": "customers",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "101"], [2, "Maya", "Dela Cruz", "204"],
			[3, "Jose", "Hernandez", "312"], [4, "Carlos", "Garcia", "412"],
		],
		"problem_template": "Guest id {target_id} just cancelled. Please remove their record.",
		"pick_id_from": "id",
		"role": "staff",
	},
	{
		"requires_lesson_index": 5, "kind": "delete",
		"table": "customers",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "101"], [2, "Maya", "Dela Cruz", "204"],
			[3, "Jose", "Hernandez", "312"], [4, "Carlos", "Garcia", "412"],
		],
		"problem_template": "Front office needs record id {target_id} deleted — duplicate entry.",
		"pick_id_from": "id",
		"role": "staff",
	},
]
