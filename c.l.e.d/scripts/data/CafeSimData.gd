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
		"role": "staff",
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
		"role": "staff",
	},
	{
		"requires_lesson_index": 1, "kind": "select_column",
		"table": "orders",
		"table_headers": ["id", "customer_name", "drink", "food"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria", "Latte", "Croissant"], [2, "Rivera", "Iced Tea", "None"],
			[3, "Kim", "Americano", "Bagel"], [4, "Reyes", "Mocha", "Cookie"],
		],
		"problem_template": "Just the {column} column, please — I'm doing a quick headcount.",
		"pick_from_columns": ["customer_name", "drink", "food"],
		"role": "staff",
	},
	{
		"requires_lesson_index": 1, "kind": "select_column",
		"table": "orders",
		"table_headers": ["id", "customer_name", "drink", "food"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria", "Latte", "Croissant"], [2, "Rivera", "Iced Tea", "None"],
			[3, "Kim", "Americano", "Bagel"], [4, "Reyes", "Mocha", "Cookie"],
		],
		"problem_template": "Can you pull up only the {column} for every order so far?",
		"pick_from_columns": ["customer_name", "drink", "food"],
		"role": "staff",
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
		"problem_template": "Hi, I'd like a {drink} and a {food}, please. Name's {customer_name}.",
		"variables": {
			"drink": ["Cappuccino", "Espresso", "Matcha Latte", "Cold Brew"],
			"food":  ["Muffin", "Donut", "Cheesecake", "Toast"],
			"customer_name_male":   ["Carlos", "Diego", "Marco"],
			"customer_name_female": ["Elena", "Sofia"],
		},
		"gender_field": "customer_name",
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
		"problem_template": "Order for {customer_name} — a {drink}, and a {food} on the side.",
		"variables": {
			"drink": ["Hot Chocolate", "Flat White", "Iced Latte", "Green Tea"],
			"food":  ["Brownie", "Bagel", "Waffle", "Cinnamon Roll"],
			"customer_name_male":   ["Miguel", "Paolo"],
			"customer_name_female": ["Ana", "Grace", "Rosa"],
		},
		"gender_field": "customer_name",
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
		"role": "staff",
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
		"role": "staff",
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
		"role": "staff",
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
		"role": "staff",
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
		"role": "staff",
	},

	# ── IS NULL / IS NOT NULL (unlocks after Lesson 6, position-wise) ──
	{
		"requires_lesson_index": 6, "kind": "select_where_null", "folder": "filtering",
		"table": "order_tickets",
		"table_headers": ["id", "customer", "item", "notes"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte", null], [2, "Ben", "Iced Tea", "Less ice"],
			[3, "Cara", "Cappuccino", null], [4, "Dan", "Americano", "Extra shot"],
			[5, "Eve", "Mocha", null], [6, "Fay", "Matcha Latte", "Oat milk"],
		],
		"column": "notes", "mode": "IS NULL",
		"problem": "Can you find which orders have no special notes on the ticket?",
		"role": "staff",
	},
	{
		"requires_lesson_index": 6, "kind": "select_where_null", "folder": "filtering",
		"table": "order_tickets",
		"table_headers": ["id", "customer", "item", "notes"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte", null], [2, "Ben", "Iced Tea", "Less ice"],
			[3, "Cara", "Cappuccino", null], [4, "Dan", "Americano", "Extra shot"],
			[5, "Eve", "Mocha", null], [6, "Fay", "Matcha Latte", "Oat milk"],
		],
		"column": "notes", "mode": "IS NOT NULL",
		"problem": "Now show me the orders that DO have a note, so the barista knows what to customize.",
		"role": "staff",
	},

	# ── SELECT DISTINCT (unlocks after Lesson 7, position-wise) ────────
	{
		"requires_lesson_index": 7, "kind": "select_distinct", "folder": "filtering",
		"table": "order_book",
		"table_headers": ["id", "customer", "item", "price", "paid"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "REAL", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte", 4.50, "Yes"], [2, "Ben", "Espresso", 3.00, "Yes"],
			[3, "Cara", "Cappuccino", 4.00, "No"], [4, "Dan", "Tea", 2.00, "Yes"],
			[5, "Eve", "Latte", 4.50, "No"], [6, "Fay", "Juice", 5.00, "Yes"],
			[7, "Gil", "Espresso", 3.00, "No"], [8, "Hana", "Latte", 4.50, "Yes"],
		],
		"column": "item",
		"problem": "Our order log has tons of rows but I only want to see each unique item ordered today. No repeats.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 7, "kind": "select_distinct", "folder": "filtering",
		"table": "order_book",
		"table_headers": ["id", "customer", "item", "price", "paid"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "REAL", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte", 4.50, "Yes"], [2, "Ben", "Espresso", 3.00, "Yes"],
			[3, "Cara", "Cappuccino", 4.00, "No"], [4, "Dan", "Tea", 2.00, "Yes"],
			[5, "Eve", "Latte", 4.50, "No"], [6, "Fay", "Juice", 5.00, "Yes"],
			[7, "Gil", "Espresso", 3.00, "No"], [8, "Hana", "Latte", 4.50, "Yes"],
		],
		"column": "item",
		"problem": "For the daily summary, list each different item once, nothing repeated.",
		"role": "staff",
	},

	# ── AND / OR (unlocks after Lesson 8, position-wise) ───────────────
	{
		"requires_lesson_index": 8, "kind": "where_and_or", "folder": "filtering",
		"table": "ticket_log",
		"table_headers": ["id", "customer", "item", "price", "paid"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "REAL", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte", 4.50, "Yes"], [2, "Ben", "Espresso", 3.00, "Yes"],
			[3, "Cara", "Cappuccino", 4.00, "No"], [4, "Dan", "Tea", 2.00, "Yes"],
			[5, "Eve", "Latte", 4.50, "No"], [6, "Fay", "Juice", 5.00, "Yes"],
			[7, "Gil", "Espresso", 3.00, "No"], [8, "Hana", "Latte", 4.50, "Yes"],
		],
		"col1": "item", "val1": "Latte", "col2": "paid", "val2": "Yes", "connector": "AND",
		"problem": "I need orders where the item is Latte AND it's already paid. Both conditions must hold.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 8, "kind": "where_and_or", "folder": "filtering",
		"table": "ticket_log",
		"table_headers": ["id", "customer", "item", "price", "paid"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "REAL", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte", 4.50, "Yes"], [2, "Ben", "Espresso", 3.00, "Yes"],
			[3, "Cara", "Cappuccino", 4.00, "No"], [4, "Dan", "Tea", 2.00, "Yes"],
			[5, "Eve", "Latte", 4.50, "No"], [6, "Fay", "Juice", 5.00, "Yes"],
			[7, "Gil", "Espresso", 3.00, "No"], [8, "Hana", "Latte", 4.50, "Yes"],
		],
		"col1": "item", "val1": "Latte", "col2": "paid", "val2": "Yes", "connector": "OR",
		"problem": "Now show me every order that's a Latte OR already paid — either one qualifies for the closing report.",
		"role": "staff",
	},

	# ── BETWEEN (unlocks after Lesson 9, position-wise) ─────────────────
	{
		"requires_lesson_index": 9, "kind": "where_between", "folder": "filtering",
		"table": "menu_prices",
		"table_headers": ["id", "item", "price"],
		"table_types":   ["INTEGER", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Latte", 4.50], [2, "Espresso", 3.00], [3, "Water", 1.50],
			[4, "Cappuccino", 4.00], [5, "Juice", 6.00], [6, "Tea", 2.50],
		],
		"column": "price",
		"range_pool": [[2.50, 5.00], [1.50, 4.00], [3.00, 6.00]],
		"problem_template": "Show me all orders where the price is between {low} and {high} for the discount campaign.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 9, "kind": "where_between", "folder": "filtering",
		"table": "menu_prices",
		"table_headers": ["id", "item", "price"],
		"table_types":   ["INTEGER", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Latte", 4.50], [2, "Espresso", 3.00], [3, "Water", 1.50],
			[4, "Cappuccino", 4.00], [5, "Juice", 6.00], [6, "Tea", 2.50],
		],
		"column": "price",
		"range_pool": [[2.50, 5.00], [1.50, 4.00], [3.00, 6.00]],
		"problem_template": "For the mid-price flyer, pull items priced between {low} and {high}, inclusive.",
		"role": "staff",
	},

	# ── LIKE (unlocks after Lesson 10, position-wise) ───────────────────
	{
		"requires_lesson_index": 10, "kind": "where_like", "folder": "filtering",
		"table": "order_names",
		"table_headers": ["id", "customer", "item"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte"], [2, "Ben", "Espresso"], [3, "Cara", "Latte"],
			[4, "Dan", "Cappuccino"], [5, "Eve", "Espresso"], [6, "Fay", "Latte"],
			[7, "Gil", "Croissant"], [8, "Hana", "Chai"],
		],
		"column": "item",
		"letter_pool": ["L", "C"],
		"problem_template": "Can you find all orders whose item starts with the letter {letter}?",
		"role": "staff",
	},
	{
		"requires_lesson_index": 10, "kind": "where_like", "folder": "filtering",
		"table": "order_names",
		"table_headers": ["id", "customer", "item"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte"], [2, "Ben", "Espresso"], [3, "Cara", "Latte"],
			[4, "Dan", "Cappuccino"], [5, "Eve", "Espresso"], [6, "Fay", "Latte"],
			[7, "Gil", "Croissant"], [8, "Hana", "Chai"],
		],
		"column": "item",
		"letter_pool": ["L", "C"],
		"problem_template": "A customer's asking — pull every item on today's board that starts with {letter}.",
		"role": "staff",
	},

	# ── IN (unlocks after Lesson 11, position-wise) ─────────────────────
	{
		"requires_lesson_index": 11, "kind": "where_in", "folder": "filtering",
		"table": "order_book",
		"table_headers": ["id", "customer", "item", "price", "paid"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "REAL", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte", 4.50, "Yes"], [2, "Ben", "Espresso", 3.00, "Yes"],
			[3, "Cara", "Cappuccino", 4.00, "No"], [4, "Dan", "Tea", 2.00, "Yes"],
			[5, "Eve", "Latte", 4.50, "No"], [6, "Fay", "Juice", 5.00, "Yes"],
			[7, "Gil", "Espresso", 3.00, "No"], [8, "Hana", "Latte", 4.50, "Yes"],
		],
		"column": "item",
		"value_pool": ["Latte", "Espresso", "Tea"],
		"problem_template": "Show me orders for {val1} and {val2} only — instead of writing two OR conditions, use a list.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 11, "kind": "where_in", "folder": "filtering",
		"table": "order_book",
		"table_headers": ["id", "customer", "item", "price", "paid"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "REAL", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte", 4.50, "Yes"], [2, "Ben", "Espresso", 3.00, "Yes"],
			[3, "Cara", "Cappuccino", 4.00, "No"], [4, "Dan", "Tea", 2.00, "Yes"],
			[5, "Eve", "Latte", 4.50, "No"], [6, "Fay", "Juice", 5.00, "Yes"],
			[7, "Gil", "Espresso", 3.00, "No"], [8, "Hana", "Latte", 4.50, "Yes"],
		],
		"column": "item",
		"value_pool": ["Latte", "Espresso", "Tea"],
		"problem_template": "For the combo flyer, pull every order that's {val1} or {val2}.",
		"role": "staff",
	},

	# ── ORDER BY (unlocks after Lesson 12, position-wise) ───────────────
	{
		"requires_lesson_index": 12, "kind": "order_by", "folder": "sorting",
		"table": "menu",
		"table_headers": ["id", "item", "category", "price"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Espresso", "Drinks", 2.50], [2, "Latte", "Drinks", 4.00],
			[3, "Cappuccino", "Drinks", 3.50], [4, "Blueberry Muffin", "Pastries", 3.00],
			[5, "Croissant", "Pastries", 2.75], [6, "Matcha Latte", "Drinks", 4.25],
			[7, "Cheesecake", "Pastries", 3.75], [8, "Cold Brew", "Drinks", 3.25],
			[9, "Donut", "Pastries", 2.00],
		],
		"column": "price", "direction": "ASC",
		"problem": "Can you pull up all menu items sorted by price — cheapest to most expensive? We're updating the board.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 12, "kind": "order_by", "folder": "sorting",
		"table": "menu",
		"table_headers": ["id", "item", "category", "price"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Espresso", "Drinks", 2.50], [2, "Latte", "Drinks", 4.00],
			[3, "Cappuccino", "Drinks", 3.50], [4, "Blueberry Muffin", "Pastries", 3.00],
			[5, "Croissant", "Pastries", 2.75], [6, "Matcha Latte", "Drinks", 4.25],
			[7, "Cheesecake", "Pastries", 3.75], [8, "Cold Brew", "Drinks", 3.25],
			[9, "Donut", "Pastries", 2.00],
		],
		"column": "price", "direction": "DESC",
		"problem": "For the specials board, flip that — most expensive first this time.",
		"role": "staff",
	},

	# ── LIMIT (unlocks after Lesson 13, position-wise) ──────────────────
	{
		"requires_lesson_index": 13, "kind": "limit", "folder": "sorting",
		"table": "order_book",
		"table_headers": ["id", "customer", "item", "price", "paid"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "REAL", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte", 4.50, "Yes"], [2, "Ben", "Espresso", 3.00, "Yes"],
			[3, "Cara", "Cappuccino", 4.00, "No"], [4, "Dan", "Tea", 2.00, "Yes"],
			[5, "Eve", "Latte", 4.50, "No"], [6, "Fay", "Juice", 5.00, "Yes"],
			[7, "Gil", "Espresso", 3.00, "No"], [8, "Hana", "Latte", 4.50, "Yes"],
		],
		"count_pool": [3, 5, 7],
		"problem_template": "Morning rush is over — just show me the first {n} orders. I don't need the whole list.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 13, "kind": "limit", "folder": "sorting",
		"table": "order_book",
		"table_headers": ["id", "customer", "item", "price", "paid"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "REAL", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte", 4.50, "Yes"], [2, "Ben", "Espresso", 3.00, "Yes"],
			[3, "Cara", "Cappuccino", 4.00, "No"], [4, "Dan", "Tea", 2.00, "Yes"],
			[5, "Eve", "Latte", 4.50, "No"], [6, "Fay", "Juice", 5.00, "Yes"],
			[7, "Gil", "Espresso", 3.00, "No"], [8, "Hana", "Latte", 4.50, "Yes"],
		],
		"count_pool": [3, 5, 7],
		"problem_template": "For a quick preview, cap it at the first {n} orders only.",
		"role": "staff",
	},

	# ── GROUP BY (unlocks after Lesson 14, position-wise) ───────────────
	{
		"requires_lesson_index": 14, "kind": "group_by", "folder": "sorting",
		"table": "menu",
		"table_headers": ["id", "item", "category", "price"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Espresso", "Drinks", 2.50], [2, "Latte", "Drinks", 4.00],
			[3, "Cappuccino", "Drinks", 3.50], [4, "Blueberry Muffin", "Pastries", 3.00],
			[5, "Croissant", "Pastries", 2.75], [6, "Matcha Latte", "Drinks", 4.25],
			[7, "Cheesecake", "Pastries", 3.75], [8, "Cold Brew", "Drinks", 3.25],
			[9, "Donut", "Pastries", 2.00],
		],
		"column": "category",
		"problem": "Before you go, can you pull a count of today's orders grouped by category?",
		"role": "staff",
	},
	{
		"requires_lesson_index": 14, "kind": "group_by", "folder": "sorting",
		"table": "menu",
		"table_headers": ["id", "item", "category", "price"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Espresso", "Drinks", 2.50], [2, "Latte", "Drinks", 4.00],
			[3, "Cappuccino", "Drinks", 3.50], [4, "Blueberry Muffin", "Pastries", 3.00],
			[5, "Croissant", "Pastries", 2.75], [6, "Matcha Latte", "Drinks", 4.25],
			[7, "Cheesecake", "Pastries", 3.75], [8, "Cold Brew", "Drinks", 3.25],
			[9, "Donut", "Pastries", 2.00],
		],
		"column": "category",
		"problem": "For the weekly report, group the menu by category and show me the count for each.",
		"role": "staff",
	},

	# ── COUNT / SUM / AVG (unlocks after Lesson 15, position-wise) ──────
	{
		"requires_lesson_index": 15, "kind": "aggregate", "folder": "sorting",
		"table": "order_book",
		"table_headers": ["id", "customer", "item", "price", "paid"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "REAL", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte", 4.50, "Yes"], [2, "Ben", "Espresso", 3.00, "Yes"],
			[3, "Cara", "Cappuccino", 4.00, "No"], [4, "Dan", "Tea", 2.00, "Yes"],
			[5, "Eve", "Latte", 4.50, "No"], [6, "Fay", "Juice", 5.00, "Yes"],
			[7, "Gil", "Espresso", 3.00, "No"], [8, "Hana", "Latte", 4.50, "Yes"],
		],
		"func": "COUNT", "column": "id",
		"problem": "How many orders did we get today? Just give me a single number.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 15, "kind": "aggregate", "folder": "sorting",
		"table": "menu_prices",
		"table_headers": ["id", "item", "price"],
		"table_types":   ["INTEGER", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Latte", 4.50], [2, "Espresso", 3.00], [3, "Water", 1.50],
			[4, "Cappuccino", 4.00], [5, "Juice", 6.00], [6, "Tea", 2.50],
		],
		"func": "SUM", "column": "price",
		"problem": "I need today's total revenue — add up every price across all orders.",
		"role": "staff",
	},

	# ── HAVING (unlocks after Lesson 16, position-wise) ─────────────────
	{
		"requires_lesson_index": 16, "kind": "having", "folder": "sorting",
		"table": "order_names",
		"table_headers": ["id", "customer", "item"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte"], [2, "Ben", "Espresso"], [3, "Cara", "Latte"],
			[4, "Dan", "Cappuccino"], [5, "Eve", "Espresso"], [6, "Fay", "Latte"],
			[7, "Gil", "Croissant"], [8, "Hana", "Chai"],
		],
		"group_col": "item",
		"threshold_pool": [1, 2],
		"problem_template": "I grouped by item already, but how do I filter out items ordered {threshold} time(s) or fewer? WHERE doesn't work after GROUP BY.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 16, "kind": "having", "folder": "sorting",
		"table": "order_names",
		"table_headers": ["id", "customer", "item"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Ana", "Latte"], [2, "Ben", "Espresso"], [3, "Cara", "Latte"],
			[4, "Dan", "Cappuccino"], [5, "Eve", "Espresso"], [6, "Fay", "Latte"],
			[7, "Gil", "Croissant"], [8, "Hana", "Chai"],
		],
		"group_col": "item",
		"threshold_pool": [1, 2],
		"problem_template": "For the popular-items spotlight, show only items ordered more than {threshold} time(s).",
		"role": "staff",
	},

	# ── AS / Alias (unlocks after Lesson 17, position-wise) ─────────────
	{
		"requires_lesson_index": 17, "kind": "select_alias", "folder": "sorting",
		"table": "menu_prices",
		"table_headers": ["id", "item", "price"],
		"table_types":   ["INTEGER", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Latte", 4.50], [2, "Espresso", 3.00], [3, "Water", 1.50],
			[4, "Cappuccino", 4.00], [5, "Juice", 6.00], [6, "Tea", 2.50],
		],
		"base_col": "price", "multiplier": "0.9", "alias": "discounted_price",
		"problem": "For the loyalty promo, apply a 10% discount to every price — but label the column 'discounted_price'.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 17, "kind": "select_alias", "folder": "sorting",
		"table": "menu_prices",
		"table_headers": ["id", "item", "price"],
		"table_types":   ["INTEGER", "TEXT", "REAL"],
		"seed_rows": [
			[1, "Latte", 4.50], [2, "Espresso", 3.00], [3, "Water", 1.50],
			[4, "Cappuccino", 4.00], [5, "Juice", 6.00], [6, "Tea", 2.50],
		],
		"base_col": "price", "multiplier": "1.1", "alias": "price_with_tax",
		"problem": "The report needs prices with tax added, but the column name should be readable — call it 'price_with_tax'.",
		"role": "staff",
	},
]
