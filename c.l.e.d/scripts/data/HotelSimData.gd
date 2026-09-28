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
		"problem_template": "Hi, I'd like to check in. My name is {first_name} {last_name}, room {room_no}.",
		"variables": {
			"first_name_male":   ["Marco", "Miguel"],
			"first_name_female": ["Linda", "Sofia", "Ana"],
			"last_name": ["Lim", "Reyes", "Torres", "Villanueva", "Cruz"],
			"room_no":   ["205", "108", "310", "217", "150"],
		},
		"gender_field": "first_name",
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
		"problem_template": "Checking in — {first_name} {last_name}. They put me in room {room_no}.",
		"variables": {
			"first_name_male":   ["Diego", "Paolo"],
			"first_name_female": ["Elena", "Grace", "Rosa"],
			"last_name": ["Bautista", "Fernandez", "Santos", "Garcia", "Lim"],
			"room_no":   ["220", "115", "330", "240", "160"],
		},
		"gender_field": "first_name",
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

	# ── IS NULL / IS NOT NULL (unlocks after Lesson 6, position-wise) ──
	{
		"requires_lesson_index": 6, "kind": "select_where_null", "folder": "filtering",
		"table": "contacts",
		"table_headers": ["id", "first_name", "last_name", "email"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "alex@mail.com"], [2, "Maya", "Dela Cruz", null],
			[3, "Jose", "Hernandez", "jose@mail.com"], [4, "Carlos", "Garcia", null],
			[5, "Linda", "Lim", "linda@mail.com"],
		],
		"column": "email", "mode": "IS NULL",
		"problem": "I need to send digital invoices, but can you find which guests have no email on file?",
		"role": "staff",
	},
	{
		"requires_lesson_index": 6, "kind": "select_where_null", "folder": "filtering",
		"table": "contacts",
		"table_headers": ["id", "first_name", "last_name", "email"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "alex@mail.com"], [2, "Maya", "Dela Cruz", null],
			[3, "Jose", "Hernandez", "jose@mail.com"], [4, "Carlos", "Garcia", null],
			[5, "Linda", "Lim", "linda@mail.com"],
		],
		"column": "email", "mode": "IS NOT NULL",
		"problem": "For the newsletter blast, I only want guests who DO have an email on file.",
		"role": "staff",
	},

	# ── SELECT DISTINCT (unlocks after Lesson 7, position-wise) ────────
	{
		"requires_lesson_index": 7, "kind": "select_distinct", "folder": "filtering",
		"table": "reservations",
		"table_headers": ["id", "guest_id", "room_type", "check_in"],
		"table_types":   ["INTEGER", "INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, 1, "Standard", "June 1"], [2, 2, "Deluxe", "June 3"],
			[3, 3, "Standard", "June 4"], [4, 4, "Suite", "June 5"],
			[5, 5, "Deluxe", "June 6"], [6, 6, "Standard", "June 7"],
		],
		"column": "room_type",
		"problem": "Our bookings table has hundreds of rows but only a few room types. Can you list each type once — no duplicates?",
		"role": "staff",
	},
	{
		"requires_lesson_index": 7, "kind": "select_distinct", "folder": "filtering",
		"table": "reservations",
		"table_headers": ["id", "guest_id", "room_type", "check_in"],
		"table_types":   ["INTEGER", "INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, 1, "Standard", "June 1"], [2, 2, "Deluxe", "June 3"],
			[3, 3, "Standard", "June 4"], [4, 4, "Suite", "June 5"],
			[5, 5, "Deluxe", "June 6"], [6, 6, "Standard", "June 7"],
		],
		"column": "room_type",
		"problem": "I'm preparing the availability report — give me the unique room types, nothing repeated.",
		"role": "staff",
	},

	# ── AND / OR (unlocks after Lesson 8, position-wise) ───────────────
	{
		"requires_lesson_index": 8, "kind": "where_and_or", "folder": "filtering",
		"table": "vip_list",
		"table_headers": ["id", "first_name", "status", "has_booking"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "VIP", "Yes"], [2, "Maya", "Regular", "Yes"],
			[3, "Jose", "VIP", "No"], [4, "Carlos", "VIP", "Yes"],
			[5, "Linda", "Regular", "No"],
		],
		"col1": "status", "val1": "VIP", "col2": "has_booking", "val2": "Yes", "connector": "AND",
		"problem": "I need guests who are VIP status AND have a booking. Not just one or the other — both must apply.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 8, "kind": "where_and_or", "folder": "filtering",
		"table": "vip_list",
		"table_headers": ["id", "first_name", "status", "has_booking"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "VIP", "Yes"], [2, "Maya", "Regular", "Yes"],
			[3, "Jose", "VIP", "No"], [4, "Carlos", "VIP", "Yes"],
			[5, "Linda", "Regular", "No"],
		],
		"col1": "status", "val1": "VIP", "col2": "has_booking", "val2": "Yes", "connector": "OR",
		"problem": "Now show me every guest who is VIP status OR has a booking — either one qualifies for the priority list.",
		"role": "staff",
	},

	# ── BETWEEN (unlocks after Lesson 9, position-wise) ────────────────
	{
		"requires_lesson_index": 9, "kind": "where_between", "folder": "filtering",
		"table": "room_prices",
		"table_headers": ["id", "room_type", "price_per_night"],
		"table_types":   ["INTEGER", "TEXT", "INTEGER"],
		"seed_rows": [
			[1, "Standard", 85], [2, "Deluxe", 150], [3, "Suite", 350],
			[4, "Standard", 95], [5, "Deluxe", 220], [6, "Suite", 400], [7, "Standard", 110],
		],
		"column": "price_per_night",
		"range_pool": [[100, 300], [50, 150], [150, 400]],
		"problem_template": "I need bookings where the price per night is between {low} and {high}.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 9, "kind": "where_between", "folder": "filtering",
		"table": "room_prices",
		"table_headers": ["id", "room_type", "price_per_night"],
		"table_types":   ["INTEGER", "TEXT", "INTEGER"],
		"seed_rows": [
			[1, "Standard", 85], [2, "Deluxe", 150], [3, "Suite", 350],
			[4, "Standard", 95], [5, "Deluxe", 220], [6, "Suite", 400], [7, "Standard", 110],
		],
		"column": "price_per_night",
		"range_pool": [[100, 300], [50, 150], [150, 400]],
		"problem_template": "For the mid-range report, pull bookings priced between {low} and {high}, inclusive.",
		"role": "staff",
	},

	# ── LIKE (unlocks after Lesson 10, position-wise) ──────────────────
	{
		"requires_lesson_index": 10, "kind": "where_like", "folder": "filtering",
		"table": "directory",
		"table_headers": ["id", "first_name", "last_name"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos"], [2, "Maya", "Dela Cruz"], [3, "Jose", "Hernandez"],
			[4, "Carlos", "Santos"], [5, "Linda", "Sim"], [6, "Marco", "Reyes"],
		],
		"column": "last_name",
		"letter_pool": ["S", "H", "D", "R"],
		"problem_template": "Can you find all guests whose last name starts with the letter {letter}?",
		"role": "staff",
	},
	{
		"requires_lesson_index": 10, "kind": "where_like", "folder": "filtering",
		"table": "directory",
		"table_headers": ["id", "first_name", "last_name"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos"], [2, "Maya", "Dela Cruz"], [3, "Jose", "Hernandez"],
			[4, "Carlos", "Santos"], [5, "Linda", "Sim"], [6, "Marco", "Reyes"],
		],
		"column": "last_name",
		"letter_pool": ["S", "H", "D", "R"],
		"problem_template": "A reunion group is checking in — pull every guest whose last name starts with {letter}.",
		"role": "staff",
	},

	# ── IN (unlocks after Lesson 11, position-wise) ────────────────────
	{
		"requires_lesson_index": 11, "kind": "where_in", "folder": "filtering",
		"table": "room_prices",
		"table_headers": ["id", "room_type", "price_per_night"],
		"table_types":   ["INTEGER", "TEXT", "INTEGER"],
		"seed_rows": [
			[1, "Standard", 85], [2, "Deluxe", 150], [3, "Suite", 350],
			[4, "Standard", 95], [5, "Deluxe", 220], [6, "Suite", 400],
		],
		"column": "room_type",
		"value_pool": ["Standard", "Deluxe", "Suite"],
		"problem_template": "I need bookings for {val1} and {val2} rooms only — instead of writing two OR conditions, use a list.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 11, "kind": "where_in", "folder": "filtering",
		"table": "room_prices",
		"table_headers": ["id", "room_type", "price_per_night"],
		"table_types":   ["INTEGER", "TEXT", "INTEGER"],
		"seed_rows": [
			[1, "Standard", 85], [2, "Deluxe", 150], [3, "Suite", 350],
			[4, "Standard", 95], [5, "Deluxe", 220], [6, "Suite", 400],
		],
		"column": "room_type",
		"value_pool": ["Standard", "Deluxe", "Suite"],
		"problem_template": "For the cleaning schedule, pull every booking that's {val1} or {val2}.",
		"role": "staff",
	},

	# ── ORDER BY (unlocks after Lesson 12, position-wise) ───────────────
	{
		"requires_lesson_index": 12, "kind": "order_by", "folder": "sorting",
		"table": "guest_roster",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "101"], [2, "Maya", "Dela Cruz", "204"],
			[3, "Jose", "Hernandez", "312"], [4, "Carlos", "Garcia", "412"],
			[5, "Linda", "Lim", "205"], [6, "Marco", "Reyes", "108"],
		],
		"column": "last_name", "direction": "ASC",
		"problem": "I need all current guests sorted alphabetically by last name — A to Z, please.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 12, "kind": "order_by", "folder": "sorting",
		"table": "guest_roster",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "101"], [2, "Maya", "Dela Cruz", "204"],
			[3, "Jose", "Hernandez", "312"], [4, "Carlos", "Garcia", "412"],
			[5, "Linda", "Lim", "205"], [6, "Marco", "Reyes", "108"],
		],
		"column": "last_name", "direction": "DESC",
		"problem": "For the printed handout, flip that — sort guests Z to A by last name this time.",
		"role": "staff",
	},

	# ── LIMIT (unlocks after Lesson 13, position-wise) ──────────────────
	{
		"requires_lesson_index": 13, "kind": "limit", "folder": "sorting",
		"table": "guest_log",
		"table_headers": ["id", "first_name", "last_name", "email"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "alex@mail.com"], [2, "Maya", "Dela Cruz", "maya@mail.com"],
			[3, "Jose", "Hernandez", "jose@mail.com"], [4, "Carlos", "Garcia", "carlos@mail.com"],
			[5, "Linda", "Lim", "linda@mail.com"], [6, "Marco", "Reyes", "marco@mail.com"],
			[7, "Ana", "Torres", "ana@mail.com"], [8, "Sofia", "Villanueva", "sofia@mail.com"],
		],
		"count_pool": [3, 5, 7],
		"problem_template": "I just need a sample of the guest log to verify the data format. Show me only the first {n} rows.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 13, "kind": "limit", "folder": "sorting",
		"table": "guest_log",
		"table_headers": ["id", "first_name", "last_name", "email"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos", "alex@mail.com"], [2, "Maya", "Dela Cruz", "maya@mail.com"],
			[3, "Jose", "Hernandez", "jose@mail.com"], [4, "Carlos", "Garcia", "carlos@mail.com"],
			[5, "Linda", "Lim", "linda@mail.com"], [6, "Marco", "Reyes", "marco@mail.com"],
			[7, "Ana", "Torres", "ana@mail.com"], [8, "Sofia", "Villanueva", "sofia@mail.com"],
		],
		"count_pool": [3, 5, 7],
		"problem_template": "For the quick preview, cap it at the first {n} rows only — no need for the whole table.",
		"role": "staff",
	},

	# ── GROUP BY (unlocks after Lesson 14, position-wise) ───────────────
	{
		"requires_lesson_index": 14, "kind": "group_by", "folder": "sorting",
		"table": "room_bookings",
		"table_headers": ["id", "first_name", "room_type"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Standard"], [2, "Maya", "Deluxe"], [3, "Jose", "Suite"],
			[4, "Carlos", "Standard"], [5, "Linda", "Deluxe"], [6, "Marco", "Suite"],
			[7, "Sofia", "Standard"], [8, "Ana", "Deluxe"], [9, "Miguel", "Suite"], [10, "Rosa", "Standard"],
		],
		"column": "room_type",
		"problem": "I need a breakdown for the board meeting — how many bookings do we have per room type?",
		"role": "staff",
	},
	{
		"requires_lesson_index": 14, "kind": "group_by", "folder": "sorting",
		"table": "room_bookings",
		"table_headers": ["id", "first_name", "room_type"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Standard"], [2, "Maya", "Deluxe"], [3, "Jose", "Suite"],
			[4, "Carlos", "Standard"], [5, "Linda", "Deluxe"], [6, "Marco", "Suite"],
			[7, "Sofia", "Standard"], [8, "Ana", "Deluxe"], [9, "Miguel", "Suite"], [10, "Rosa", "Standard"],
		],
		"column": "room_type",
		"problem": "Quarter-end report — group the bookings by room type and show me the count for each.",
		"role": "staff",
	},

	# ── COUNT / SUM / AVG (unlocks after Lesson 15, position-wise) ──────
	{
		"requires_lesson_index": 15, "kind": "aggregate", "folder": "sorting",
		"table": "headcount",
		"table_headers": ["id", "first_name", "last_name"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Alex", "Santos"], [2, "Maya", "Dela Cruz"], [3, "Jose", "Hernandez"],
			[4, "Carlos", "Garcia"], [5, "Linda", "Lim"], [6, "Marco", "Reyes"],
		],
		"func": "COUNT", "column": "id",
		"problem": "How many guests do we have in the system? I need a single number, not a list.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 15, "kind": "aggregate", "folder": "sorting",
		"table": "room_prices",
		"table_headers": ["id", "room_type", "price_per_night"],
		"table_types":   ["INTEGER", "TEXT", "INTEGER"],
		"seed_rows": [
			[1, "Standard", 85], [2, "Deluxe", 150], [3, "Suite", 350],
			[4, "Standard", 95], [5, "Deluxe", 220], [6, "Suite", 400], [7, "Standard", 110],
		],
		"func": "SUM", "column": "price_per_night",
		"problem": "I need our total revenue — add up every price_per_night across all bookings.",
		"role": "staff",
	},

	# ── HAVING (unlocks after Lesson 16, position-wise) ─────────────────
	{
		"requires_lesson_index": 16, "kind": "having", "folder": "sorting",
		"table": "booking_log",
		"table_headers": ["id", "room_type", "guest_id"],
		"table_types":   ["INTEGER", "TEXT", "INTEGER"],
		"seed_rows": [
			[1, "Standard", 1], [2, "Standard", 2], [3, "Standard", 3], [4, "Standard", 4],
			[5, "Deluxe", 5], [6, "Deluxe", 6], [7, "Suite", 7],
		],
		"group_col": "room_type",
		"threshold_pool": [1, 2],
		"problem_template": "I need room types with more than {threshold} booking(s). WHERE can't filter on a group count, so use the keyword that can.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 16, "kind": "having", "folder": "sorting",
		"table": "booking_log",
		"table_headers": ["id", "room_type", "guest_id"],
		"table_types":   ["INTEGER", "TEXT", "INTEGER"],
		"seed_rows": [
			[1, "Standard", 1], [2, "Standard", 2], [3, "Standard", 3], [4, "Standard", 4],
			[5, "Deluxe", 5], [6, "Deluxe", 6], [7, "Suite", 7],
		],
		"group_col": "room_type",
		"threshold_pool": [1, 2],
		"problem_template": "For the promotion list, show only room types booked more than {threshold} time(s).",
		"role": "staff",
	},

	# ── AS / Alias (unlocks after Lesson 17, position-wise) ─────────────
	{
		"requires_lesson_index": 17, "kind": "select_alias", "folder": "sorting",
		"table": "room_prices",
		"table_headers": ["id", "room_type", "price_per_night"],
		"table_types":   ["INTEGER", "TEXT", "INTEGER"],
		"seed_rows": [
			[1, "Standard", 100], [2, "Deluxe", 200], [3, "Suite", 300],
		],
		"base_col": "price_per_night", "multiplier": "1.12", "alias": "price_with_tax",
		"problem": "The report needs prices with tax, but the column name should be readable. Rename it to 'price_with_tax'.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 17, "kind": "select_alias", "folder": "sorting",
		"table": "room_prices",
		"table_headers": ["id", "room_type", "price_per_night"],
		"table_types":   ["INTEGER", "TEXT", "INTEGER"],
		"seed_rows": [
			[1, "Standard", 100], [2, "Deluxe", 200], [3, "Suite", 300],
		],
		"base_col": "price_per_night", "multiplier": "2", "alias": "two_night_total",
		"problem": "For a two-night quote, double the nightly rate — but label the column 'two_night_total'.",
		"role": "staff",
	},
]
