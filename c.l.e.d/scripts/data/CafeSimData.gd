extends Node
# ═══════════════════════════════════════════════════════
#  CAFE SIMULATION DATA  |  scripts/data/CafeSimData.gd
#  Template pool for Cafe World's Simulation mode.
# ═══════════════════════════════════════════════════════

const TEMPLATES: Array = [

	# ── SELECT (unlocks after Lesson 1) ────────────────
	{
		"requires_lesson_index": 1, "kind": "select_basic",
		"table": "orders",
		"table_headers": ["id", "customer_name", "drink", "food"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria", "Latte", "Croissant"], [2, "Rivera", "Iced Tea", "None"],
			[3, "Kim", "Americano", "Bagel"], [4, "Reyes", "Mocha", "Cookie"],
		],
		"problem": "Can you show me every order that's come in so far?",
	},
	{
		"requires_lesson_index": 1, "kind": "select_basic",
		"table": "orders",
		"table_headers": ["id", "customer_name", "drink", "food"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria", "Latte", "Croissant"], [2, "Rivera", "Iced Tea", "None"],
			[3, "Kim", "Americano", "Bagel"], [4, "Reyes", "Mocha", "Cookie"],
		],
		"problem": "The manager wants a printout of every order today.",
	},

	# ── INSERT INTO (unlocks after Lesson 2) ───────────
	{
		"requires_lesson_index": 2, "kind": "insert_into",
		"table": "orders",
		"table_headers": ["id", "customer_name", "drink", "food"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria", "Latte", "Croissant"], [2, "Rivera", "Iced Tea", "None"],
			[3, "Kim", "Americano", "Bagel"], [4, "Reyes", "Mocha", "Cookie"],
		],
		"problem_template": "Hi, I'd like a {drink} and a {food}, please. Name's {name}.",
		"variables": {
			"drink": ["Cappuccino", "Espresso", "Matcha Latte", "Cold Brew"],
			"food":  ["Muffin", "Donut", "Cheesecake", "Toast"],
			"name":  ["Carlos", "Elena", "Diego", "Sofia", "Marco"],
		},
	},
	{
		"requires_lesson_index": 2, "kind": "insert_into",
		"table": "orders",
		"table_headers": ["id", "customer_name", "drink", "food"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria", "Latte", "Croissant"], [2, "Rivera", "Iced Tea", "None"],
			[3, "Kim", "Americano", "Bagel"], [4, "Reyes", "Mocha", "Cookie"],
		],
		"problem_template": "Order for {name} — a {drink}, and a {food} on the side.",
		"variables": {
			"drink": ["Hot Chocolate", "Flat White", "Iced Latte", "Green Tea"],
			"food":  ["Brownie", "Bagel", "Waffle", "Cinnamon Roll"],
			"name":  ["Ana", "Miguel", "Grace", "Paolo", "Rosa"],
		},
	},

	# ── SELECT WHERE (unlocks after Lesson 3) ──────────
	{
		"requires_lesson_index": 3, "kind": "select_where",
		"table": "orders",
		"table_headers": ["id", "customer_name", "drink", "food"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria", "Latte", "Croissant"], [2, "Rivera", "Iced Tea", "None"],
			[3, "Kim", "Americano", "Bagel"], [4, "Reyes", "Mocha", "Cookie"],
		],
		"problem_template": "Hi, can you check my order? It's under the name {value}.",
		"pick_from_column": "customer_name",
	},
	{
		"requires_lesson_index": 3, "kind": "select_where",
		"table": "orders",
		"table_headers": ["id", "customer_name", "drink", "food"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria", "Latte", "Croissant"], [2, "Rivera", "Iced Tea", "None"],
			[3, "Kim", "Americano", "Bagel"], [4, "Reyes", "Mocha", "Cookie"],
		],
		"problem_template": "Did anyone order a {value}? A customer's asking how long it'll take.",
		"pick_from_column": "drink",
	},

	# ── UPDATE SET (unlocks after Lesson 4) ────────────
	{
		"requires_lesson_index": 4, "kind": "update_set",
		"table": "orders",
		"table_headers": ["id", "customer_name", "drink", "food"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria", "Latte", "Croissant"], [2, "Rivera", "Iced Tea", "None"],
			[3, "Kim", "Americano", "Bagel"], [4, "Reyes", "Mocha", "Cookie"],
		],
		"problem_template": "Order id {target_id} actually wanted a {new_value} instead. Can you fix the drink?",
		"set_column": "drink",
		"pick_id_from": "id",
		"new_value_pool": ["Caramel Macchiato", "Chai Latte", "Cold Brew", "Hot Tea"],
	},
	{
		"requires_lesson_index": 4, "kind": "update_set",
		"table": "orders",
		"table_headers": ["id", "customer_name", "drink", "food"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria", "Latte", "Croissant"], [2, "Rivera", "Iced Tea", "None"],
			[3, "Kim", "Americano", "Bagel"], [4, "Reyes", "Mocha", "Cookie"],
		],
		"problem_template": "Order id {target_id}'s food should be {new_value}, not what's on the ticket.",
		"set_column": "food",
		"pick_id_from": "id",
		"new_value_pool": ["Blueberry Muffin", "Chocolate Chip Cookie", "Bagel", "None"],
	},

	# ── DELETE (unlocks after Lesson 5) ────────────────
	{
		"requires_lesson_index": 5, "kind": "delete",
		"table": "orders",
		"table_headers": ["id", "customer_name", "drink", "food"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria", "Latte", "Croissant"], [2, "Rivera", "Iced Tea", "None"],
			[3, "Kim", "Americano", "Bagel"], [4, "Reyes", "Mocha", "Cookie"],
		],
		"problem_template": "Order id {target_id} was cancelled before it got made. Take it off the list.",
		"pick_id_from": "id",
	},
	{
		"requires_lesson_index": 5, "kind": "delete",
		"table": "orders",
		"table_headers": ["id", "customer_name", "drink", "food"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria", "Latte", "Croissant"], [2, "Rivera", "Iced Tea", "None"],
			[3, "Kim", "Americano", "Bagel"], [4, "Reyes", "Mocha", "Cookie"],
		],
		"problem_template": "That's a duplicate — order id {target_id} was rung up twice. Remove one.",
		"pick_id_from": "id",
	},
]
