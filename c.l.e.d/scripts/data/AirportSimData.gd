extends Node
# ═══════════════════════════════════════════════════════
#  AIRPORT SIMULATION DATA  |  scripts/data/AirportSimData.gd
#  Template pool for Airport World's Simulation mode.
# ═══════════════════════════════════════════════════════

const TEMPLATES: Array = [

	# ── SELECT (unlocks after Lesson 1) ────────────────
	{
		"requires_lesson_index": 1, "kind": "select_basic",
		"table": "passengers",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Liam", "Cruz", "12A"], [2, "Nora", "Santos", "14C"],
			[3, "Ben", "Torres", "7B"], [4, "Iris", "Reyes", "22F"],
		],
		"problem": "Ground control needs the full passenger manifest right now.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 1, "kind": "select_basic",
		"table": "passengers",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Liam", "Cruz", "12A"], [2, "Nora", "Santos", "14C"],
			[3, "Ben", "Torres", "7B"], [4, "Iris", "Reyes", "22F"],
		],
		"problem": "Can you print the boarding list for this flight?",
		"role": "staff",
	},
	{
		"requires_lesson_index": 1, "kind": "select_column",
		"table": "passengers",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Liam", "Cruz", "12A"], [2, "Nora", "Santos", "14C"],
			[3, "Ben", "Torres", "7B"], [4, "Iris", "Reyes", "22F"],
		],
		"problem_template": "Cabin crew just needs the {column} for everyone, nothing more.",
		"pick_from_columns": ["first_name", "last_name", "seat_no"],
		"role": "staff",
	},
	{
		"requires_lesson_index": 1, "kind": "select_column",
		"table": "passengers",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Liam", "Cruz", "12A"], [2, "Nora", "Santos", "14C"],
			[3, "Ben", "Torres", "7B"], [4, "Iris", "Reyes", "22F"],
		],
		"problem_template": "For the gate announcement, just list the {column} column.",
		"pick_from_columns": ["first_name", "last_name", "seat_no"],
		"role": "staff",
	},

	# ── INSERT INTO (unlocks after Lesson 2) ───────────
	{
		"requires_lesson_index": 2, "kind": "insert_into",
		"table": "passengers",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Liam", "Cruz", "12A"], [2, "Nora", "Santos", "14C"],
			[3, "Ben", "Torres", "7B"], [4, "Iris", "Reyes", "22F"],
		],
		"problem_template": "Checking in — {first_name} {last_name}. I was assigned seat {seat_no}.",
		"variables": {
			"first_name_male":   ["Marco", "Diego"],
			"first_name_female": ["Elena", "Sofia", "Grace"],
			"last_name": ["Villanueva", "Bautista", "Fernandez", "Lim", "Garcia"],
			"seat_no":   ["9C", "18A", "3F", "25B", "11D"],
		},
		"gender_field": "first_name",
	},
	{
		"requires_lesson_index": 2, "kind": "insert_into",
		"table": "passengers",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Liam", "Cruz", "12A"], [2, "Nora", "Santos", "14C"],
			[3, "Ben", "Torres", "7B"], [4, "Iris", "Reyes", "22F"],
		],
		"problem_template": "New passenger for the manifest: {first_name} {last_name}, seat {seat_no}.",
		"variables": {
			"first_name_male":   ["Paolo", "Miguel", "Carlos"],
			"first_name_female": ["Rosa", "Ana"],
			"last_name": ["Hernandez", "Dela Cruz", "Mendez", "Rivera", "Kim"],
			"seat_no":   ["6E", "20A", "15C", "2F", "8B"],
		},
		"gender_field": "first_name",
		"role": "staff",
	},

	# ── SELECT WHERE (unlocks after Lesson 3) ──────────
	{
		"requires_lesson_index": 3, "kind": "select_where",
		"table": "passengers",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Liam", "Cruz", "12A"], [2, "Nora", "Santos", "14C"],
			[3, "Ben", "Torres", "7B"], [4, "Iris", "Reyes", "22F"],
		],
		"problem_template": "I lost my boarding pass — my last name is {value}, can you confirm my seat?",
		"pick_from_column": "last_name",
	},
	{
		"requires_lesson_index": 3, "kind": "select_where",
		"table": "passengers",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Liam", "Cruz", "12A"], [2, "Nora", "Santos", "14C"],
			[3, "Ben", "Torres", "7B"], [4, "Iris", "Reyes", "22F"],
		],
		"problem_template": "Who's sitting in seat {value}? Cabin crew needs to confirm before takeoff.",
		"pick_from_column": "seat_no",
		"role": "staff",
	},

	# ── UPDATE SET (unlocks after Lesson 4) ────────────
	{
		"requires_lesson_index": 4, "kind": "update_set",
		"table": "passengers",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Liam", "Cruz", "12A"], [2, "Nora", "Santos", "14C"],
			[3, "Ben", "Torres", "7B"], [4, "Iris", "Reyes", "22F"],
		],
		"problem_template": "Passenger id {target_id} would like to move to seat {new_value} instead.",
		"set_column": "seat_no",
		"pick_id_from": "id",
		"new_value_pool": ["4A", "16C", "21F", "1B"],
		"role": "staff",
	},
	{
		"requires_lesson_index": 4, "kind": "update_set",
		"table": "passengers",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Liam", "Cruz", "12A"], [2, "Nora", "Santos", "14C"],
			[3, "Ben", "Torres", "7B"], [4, "Iris", "Reyes", "22F"],
		],
		"problem_template": "Passenger id {target_id}'s last name was misspelled — it should be {new_value}.",
		"set_column": "last_name",
		"pick_id_from": "id",
		"new_value_pool": ["Cruzz", "Santoz", "Torress", "Reyess"],
		"role": "staff",
	},

	# ── DELETE (unlocks after Lesson 5) ────────────────
	{
		"requires_lesson_index": 5, "kind": "delete",
		"table": "passengers",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Liam", "Cruz", "12A"], [2, "Nora", "Santos", "14C"],
			[3, "Ben", "Torres", "7B"], [4, "Iris", "Reyes", "22F"],
		],
		"problem_template": "Passenger id {target_id} cancelled their booking. Please remove them from the manifest.",
		"pick_id_from": "id",
		"role": "staff",
	},
	{
		"requires_lesson_index": 5, "kind": "delete",
		"table": "passengers",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Liam", "Cruz", "12A"], [2, "Nora", "Santos", "14C"],
			[3, "Ben", "Torres", "7B"], [4, "Iris", "Reyes", "22F"],
		],
		"problem_template": "Record id {target_id} is a duplicate check-in. Delete it before boarding starts.",
		"pick_id_from": "id",
		"role": "staff",
	},
]
