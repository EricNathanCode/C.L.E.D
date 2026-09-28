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

	# ── IS NULL / IS NOT NULL (unlocks after Lesson 6, position-wise) ──
	{
		"requires_lesson_index": 6, "kind": "select_where_null", "folder": "filtering",
		"table": "flight_manifest",
		"table_headers": ["id", "first_name", "last_name", "meal_pref"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Elena", "Cruz", "Vegetarian"], [2, "Marco", "Bautista", null],
			[3, "Rosa", "Fernandez", "Chicken"], [4, "Carla", "Garcia", null],
			[5, "Linda", "Lim", "Beef"], [6, "Miguel", "Reyes", null],
		],
		"column": "meal_pref", "mode": "IS NULL",
		"problem": "Catering needs to know who still has no meal preference on file before we close the doors.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 6, "kind": "select_where_null", "folder": "filtering",
		"table": "flight_manifest",
		"table_headers": ["id", "first_name", "last_name", "meal_pref"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Elena", "Cruz", "Vegetarian"], [2, "Marco", "Bautista", null],
			[3, "Rosa", "Fernandez", "Chicken"], [4, "Carla", "Garcia", null],
			[5, "Linda", "Lim", "Beef"], [6, "Miguel", "Reyes", null],
		],
		"column": "meal_pref", "mode": "IS NOT NULL",
		"problem": "Now show me who DOES have a meal preference on file, so catering can prep those trays first.",
		"role": "staff",
	},

	# ── SELECT DISTINCT (unlocks after Lesson 7, position-wise) ────────
	{
		"requires_lesson_index": 7, "kind": "select_distinct", "folder": "filtering",
		"table": "route_log",
		"table_headers": ["id", "passenger_id", "destination", "flight_no"],
		"table_types":   ["INTEGER", "INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, 1, "Manila", "PR101"], [2, 2, "Cebu", "PR202"],
			[3, 3, "Manila", "PR101"], [4, 4, "Davao", "PR303"],
			[5, 5, "Cebu", "PR202"], [6, 6, "Manila", "PR101"],
		],
		"column": "destination",
		"problem": "We have dozens of bookings today, but I just want each destination listed once. No duplicates.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 7, "kind": "select_distinct", "folder": "filtering",
		"table": "route_log",
		"table_headers": ["id", "passenger_id", "destination", "flight_no"],
		"table_types":   ["INTEGER", "INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, 1, "Manila", "PR101"], [2, 2, "Cebu", "PR202"],
			[3, 3, "Manila", "PR101"], [4, 4, "Davao", "PR303"],
			[5, 5, "Cebu", "PR202"], [6, 6, "Manila", "PR101"],
		],
		"column": "destination",
		"problem": "For the schedule board, list each destination we fly today once — nothing repeated.",
		"role": "staff",
	},

	# ── AND / OR (unlocks after Lesson 8, position-wise) ────────────────
	{
		"requires_lesson_index": 8, "kind": "where_and_or", "folder": "filtering",
		"table": "gate_status",
		"table_headers": ["id", "first_name", "seat_class", "checked_in"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Elena", "Business", "Yes"], [2, "Marco", "Economy", "Yes"],
			[3, "Rosa", "Business", "No"], [4, "Carla", "Business", "Yes"],
			[5, "Linda", "Economy", "No"],
		],
		"col1": "seat_class", "val1": "Business", "col2": "checked_in", "val2": "Yes", "connector": "AND",
		"problem": "I need passengers who are Business class AND already checked in. Not just one or the other — both must apply.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 8, "kind": "where_and_or", "folder": "filtering",
		"table": "gate_status",
		"table_headers": ["id", "first_name", "seat_class", "checked_in"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Elena", "Business", "Yes"], [2, "Marco", "Economy", "Yes"],
			[3, "Rosa", "Business", "No"], [4, "Carla", "Business", "Yes"],
			[5, "Linda", "Economy", "No"],
		],
		"col1": "seat_class", "val1": "Business", "col2": "checked_in", "val2": "Yes", "connector": "OR",
		"problem": "Now show me every passenger who is Business class OR already checked in — either one gets priority boarding.",
		"role": "staff",
	},

	# ── BETWEEN (unlocks after Lesson 9, position-wise) ─────────────────
	{
		"requires_lesson_index": 9, "kind": "where_between", "folder": "filtering",
		"table": "fare_log",
		"table_headers": ["id", "destination", "ticket_price"],
		"table_types":   ["INTEGER", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Manila", 250], [2, "Cebu", 320], [3, "Tokyo", 900],
			[4, "Manila", 180], [5, "Davao", 410], [6, "Singapore", 1100],
		],
		"column": "ticket_price",
		"range_pool": [[200, 500], [100, 400], [400, 1000]],
		"problem_template": "Show me all bookings where the ticket price is between {low} and {high} for the fare review.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 9, "kind": "where_between", "folder": "filtering",
		"table": "fare_log",
		"table_headers": ["id", "destination", "ticket_price"],
		"table_types":   ["INTEGER", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Manila", 250], [2, "Cebu", 320], [3, "Tokyo", 900],
			[4, "Manila", 180], [5, "Davao", 410], [6, "Singapore", 1100],
		],
		"column": "ticket_price",
		"range_pool": [[200, 500], [100, 400], [400, 1000]],
		"problem_template": "For the mid-fare report, pull bookings priced between {low} and {high}, inclusive.",
		"role": "staff",
	},

	# ── LIKE (unlocks after Lesson 10, position-wise) ───────────────────
	{
		"requires_lesson_index": 10, "kind": "where_like", "folder": "filtering",
		"table": "crew_roster",
		"table_headers": ["id", "first_name", "last_name"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Elena", "Dizon"], [2, "Marco", "Bautista"], [3, "Rosa", "Delacruz"],
			[4, "Carla", "Garcia"], [5, "Linda", "Diaz"], [6, "Miguel", "Reyes"],
		],
		"column": "last_name",
		"letter_pool": ["D", "B", "G"],
		"problem_template": "Can you find all passengers whose last name starts with the letter {letter}?",
		"role": "staff",
	},
	{
		"requires_lesson_index": 10, "kind": "where_like", "folder": "filtering",
		"table": "crew_roster",
		"table_headers": ["id", "first_name", "last_name"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Elena", "Dizon"], [2, "Marco", "Bautista"], [3, "Rosa", "Delacruz"],
			[4, "Carla", "Garcia"], [5, "Linda", "Diaz"], [6, "Miguel", "Reyes"],
		],
		"column": "last_name",
		"letter_pool": ["D", "B", "G"],
		"problem_template": "A family group is asking — pull every passenger whose last name starts with {letter}.",
		"role": "staff",
	},

	# ── IN (unlocks after Lesson 11, position-wise) ─────────────────────
	{
		"requires_lesson_index": 11, "kind": "where_in", "folder": "filtering",
		"table": "fare_log",
		"table_headers": ["id", "destination", "ticket_price"],
		"table_types":   ["INTEGER", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Manila", 250], [2, "Cebu", 320], [3, "Tokyo", 900],
			[4, "Manila", 180], [5, "Davao", 410], [6, "Singapore", 1100],
		],
		"column": "destination",
		"value_pool": ["Manila", "Cebu", "Davao"],
		"problem_template": "I need bookings to {val1} and {val2} only — instead of writing two OR conditions, use a list.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 11, "kind": "where_in", "folder": "filtering",
		"table": "fare_log",
		"table_headers": ["id", "destination", "ticket_price"],
		"table_types":   ["INTEGER", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Manila", 250], [2, "Cebu", 320], [3, "Tokyo", 900],
			[4, "Manila", 180], [5, "Davao", 410], [6, "Singapore", 1100],
		],
		"column": "destination",
		"value_pool": ["Manila", "Cebu", "Davao"],
		"problem_template": "For the domestic-routes report, pull every booking to {val1} or {val2}.",
		"role": "staff",
	},

	# ── ORDER BY (unlocks after Lesson 12, position-wise) ───────────────
	{
		"requires_lesson_index": 12, "kind": "order_by", "folder": "sorting",
		"table": "flight_roster",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Elena", "Cruz", "14A"], [2, "Marco", "Bautista", "22C"],
			[3, "Rosa", "Fernandez", "9B"], [4, "Carla", "Garcia", "17D"],
			[5, "Linda", "Lim", "3A"], [6, "Miguel", "Reyes", "11C"],
			[7, "Sofia", "Torres", "20B"], [8, "Ana", "Villanueva", "5D"],
		],
		"column": "last_name", "direction": "ASC",
		"problem": "I need the passenger manifest sorted alphabetically by last name before we finalize boarding. A to Z, please.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 12, "kind": "order_by", "folder": "sorting",
		"table": "flight_roster",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Elena", "Cruz", "14A"], [2, "Marco", "Bautista", "22C"],
			[3, "Rosa", "Fernandez", "9B"], [4, "Carla", "Garcia", "17D"],
			[5, "Linda", "Lim", "3A"], [6, "Miguel", "Reyes", "11C"],
			[7, "Sofia", "Torres", "20B"], [8, "Ana", "Villanueva", "5D"],
		],
		"column": "last_name", "direction": "DESC",
		"problem": "For the printed handout, flip that — sort passengers Z to A by last name this time.",
		"role": "staff",
	},

	# ── LIMIT (unlocks after Lesson 13, position-wise) ──────────────────
	{
		"requires_lesson_index": 13, "kind": "limit", "folder": "sorting",
		"table": "flight_roster",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Elena", "Cruz", "14A"], [2, "Marco", "Bautista", "22C"],
			[3, "Rosa", "Fernandez", "9B"], [4, "Carla", "Garcia", "17D"],
			[5, "Linda", "Lim", "3A"], [6, "Miguel", "Reyes", "11C"],
			[7, "Sofia", "Torres", "20B"], [8, "Ana", "Villanueva", "5D"],
		],
		"count_pool": [3, 5, 7],
		"problem_template": "I just need a sample of the passengers table to verify the data format. Show me only the first {n} rows.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 13, "kind": "limit", "folder": "sorting",
		"table": "flight_roster",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Elena", "Cruz", "14A"], [2, "Marco", "Bautista", "22C"],
			[3, "Rosa", "Fernandez", "9B"], [4, "Carla", "Garcia", "17D"],
			[5, "Linda", "Lim", "3A"], [6, "Miguel", "Reyes", "11C"],
			[7, "Sofia", "Torres", "20B"], [8, "Ana", "Villanueva", "5D"],
		],
		"count_pool": [3, 5, 7],
		"problem_template": "For a quick preview, cap it at the first {n} passengers only.",
		"role": "staff",
	},

	# ── GROUP BY (unlocks after Lesson 14, position-wise) ───────────────
	{
		"requires_lesson_index": 14, "kind": "group_by", "folder": "sorting",
		"table": "cabin_roster",
		"table_headers": ["id", "first_name", "seat_class"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Elena", "Economy"], [2, "Marco", "Business"], [3, "Rosa", "First"],
			[4, "Carla", "Economy"], [5, "Linda", "Business"], [6, "Miguel", "First"],
			[7, "Sofia", "Economy"], [8, "Ana", "Business"], [9, "Diego", "First"], [10, "Rosario", "Economy"],
		],
		"column": "seat_class",
		"problem": "I need a breakdown: how many passengers do we have per seat class? For the load report.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 14, "kind": "group_by", "folder": "sorting",
		"table": "cabin_roster",
		"table_headers": ["id", "first_name", "seat_class"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Elena", "Economy"], [2, "Marco", "Business"], [3, "Rosa", "First"],
			[4, "Carla", "Economy"], [5, "Linda", "Business"], [6, "Miguel", "First"],
			[7, "Sofia", "Economy"], [8, "Ana", "Business"], [9, "Diego", "First"], [10, "Rosario", "Economy"],
		],
		"column": "seat_class",
		"problem": "For the weight-and-balance report, group passengers by seat class and show me the count for each.",
		"role": "staff",
	},

	# ── COUNT / SUM / AVG (unlocks after Lesson 15, position-wise) ──────
	{
		"requires_lesson_index": 15, "kind": "aggregate", "folder": "sorting",
		"table": "flight_roster",
		"table_headers": ["id", "first_name", "last_name", "seat_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Elena", "Cruz", "14A"], [2, "Marco", "Bautista", "22C"],
			[3, "Rosa", "Fernandez", "9B"], [4, "Carla", "Garcia", "17D"],
			[5, "Linda", "Lim", "3A"], [6, "Miguel", "Reyes", "11C"],
		],
		"func": "COUNT", "column": "id",
		"problem": "How many passengers do we have checked in? I need a single number, not a list.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 15, "kind": "aggregate", "folder": "sorting",
		"table": "fare_log",
		"table_headers": ["id", "destination", "ticket_price"],
		"table_types":   ["INTEGER", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Manila", 250], [2, "Cebu", 320], [3, "Tokyo", 900],
			[4, "Manila", 180], [5, "Davao", 410], [6, "Singapore", 1100],
		],
		"func": "SUM", "column": "ticket_price",
		"problem": "I need today's total ticket revenue — add up every ticket_price across all bookings.",
		"role": "staff",
	},

	# ── HAVING (unlocks after Lesson 16, position-wise) ─────────────────
	{
		"requires_lesson_index": 16, "kind": "having", "folder": "sorting",
		"table": "route_log",
		"table_headers": ["id", "passenger_id", "destination", "flight_no"],
		"table_types":   ["INTEGER", "INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, 1, "Manila", "PR101"], [2, 2, "Cebu", "PR202"],
			[3, 3, "Manila", "PR101"], [4, 4, "Davao", "PR303"],
			[5, 5, "Cebu", "PR202"], [6, 6, "Manila", "PR101"],
		],
		"group_col": "destination",
		"threshold_pool": [1, 2],
		"problem_template": "I need destinations with more than {threshold} booking(s) — a quick overbooking check. WHERE can't filter on a group count.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 16, "kind": "having", "folder": "sorting",
		"table": "route_log",
		"table_headers": ["id", "passenger_id", "destination", "flight_no"],
		"table_types":   ["INTEGER", "INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, 1, "Manila", "PR101"], [2, 2, "Cebu", "PR202"],
			[3, 3, "Manila", "PR101"], [4, 4, "Davao", "PR303"],
			[5, 5, "Cebu", "PR202"], [6, 6, "Manila", "PR101"],
		],
		"group_col": "destination",
		"threshold_pool": [1, 2],
		"problem_template": "For the busiest-routes report, show only destinations booked more than {threshold} time(s).",
		"role": "staff",
	},

	# ── AS / Alias (unlocks after Lesson 17, position-wise) ─────────────
	{
		"requires_lesson_index": 17, "kind": "select_alias", "folder": "sorting",
		"table": "fare_log",
		"table_headers": ["id", "destination", "ticket_price"],
		"table_types":   ["INTEGER", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Manila", 200], [2, "Cebu", 300], [3, "Davao", 400],
		],
		"base_col": "ticket_price", "multiplier": "1.12", "alias": "price_with_tax",
		"problem": "The report needs fares with tax, but the column name should be readable. Rename it to 'price_with_tax'.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 17, "kind": "select_alias", "folder": "sorting",
		"table": "fare_log",
		"table_headers": ["id", "destination", "ticket_price"],
		"table_types":   ["INTEGER", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Manila", 200], [2, "Cebu", 300], [3, "Davao", 400],
		],
		"base_col": "ticket_price", "multiplier": "2", "alias": "round_trip_price",
		"problem": "For a round-trip quote, double the one-way fare — but label the column 'round_trip_price'.",
		"role": "staff",
	},
]
