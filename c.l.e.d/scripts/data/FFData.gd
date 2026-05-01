extends Node
# ═══════════════════════════════════════════════════════
#  FAST FOOD DATA  —  scripts/data/FFData.gd
#
#  Contains all dialogue and SQL challenge data
#  for the Fast Food World lessons.
#
#  Same step structure as HotelData.gd.
#  Same gamemode keys map to the same GM_ scenes.
#  (Gamemodes are global — shared across both worlds.)
# ═══════════════════════════════════════════════════════

const LESSONS: Dictionary = {

# ─────────────────────────────────────────────
#  LESSON FF1 — SELECT (sql_choice)
#  Topic: Taking a customer order at the counter
# ─────────────────────────────────────────────
"FF1": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"text": "The lunch rush begins. A customer steps up to the counter and looks at the menu board."
	},
	{
		"type": "dialogue",
		"char": "ff_customer",
		"name": "CUSTOMER",
		"text": "Hi! I'd like to order a burger combo, please."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"text": "Let me choose the right response for this customer..."
	},
	{
		"type": "sql_choice",
		"desc": "A customer just placed an order. Choose the most professional response for a fast food crew member.",
		"options": [
			[1, "Great choice! Would you like that with regular or large fries?"],
			[2, "We're out of burgers."],
			[3, "Just wait over there."]
		],
		"correct_id": 1,
		"hint": "Confirm the order and upsell politely. Answer: id = 1"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"text": "Great choice! Would you like that with regular or large fries?"
	},
	{
		"type": "dialogue",
		"char": "ff_customer",
		"name": "CUSTOMER",
		"text": "Large fries, please! Thanks, you're quick!"
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON FF2 — INSERT INTO
#  Topic: Logging a new order into the system
# ─────────────────────────────────────────────
"FF2": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"text": "A customer walks up to the counter with their order ready."
	},
	{
		"type": "dialogue",
		"char": "ff_customer",
		"name": "CUSTOMER",
		"text": "Hi, I'd like a chicken sandwich and a cola, please. Name's Maria."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"text": "Got it, Maria! Let me log that order into our system."
	},
	{
		"type": "sql_fill",
		"gamemode": "insert_into",
		"desc": "Log Maria's order into the orders table. Fill in the customer_name, item, and drink.",
		"table": "orders",
		"columns": ["customer_name", "item", "drink"],
		"table_headers": ["id", "customer_name", "item", "drink"],
		"table_rows": [],
		"answers": ["Maria", "Chicken Sandwich", "Cola"],
		"hint": "Name: Maria | Item: Chicken Sandwich | Drink: Cola",
		"result_headers": ["id", "customer_name", "item", "drink"],
		"result_rows": [["8", "Maria", "Chicken Sandwich", "Cola"]],
		"result_msg": "1 record inserted into orders."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"text": "Order logged! Your chicken sandwich and cola will be ready shortly, Maria!"
	},
	{
		"type": "dialogue",
		"char": "ff_customer",
		"name": "CUSTOMER",
		"text": "Perfect, thank you!"
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON FF3 — GROUP BY
#  Topic: End-of-day sales report by category
# ─────────────────────────────────────────────
"FF3": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"text": "The shift is ending. Your supervisor walks over with the daily sales sheet."
	},
	{
		"type": "dialogue",
		"char": "ff_supervisor",
		"name": "SUPERVISOR",
		"text": "Before you clock out, I need a count of today's orders grouped by category."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"text": "Sure, I'll run that report right now."
	},
	{
		"type": "sql_fill",
		"gamemode": "group_by",
		"desc": "Count today's orders by category. Fill in the GROUP BY column name.",
		"table": "orders",
		"column": "category",
		"table_headers": ["id", "item", "category"],
		"table_rows": [
			["1", "Burger Combo", "Burgers"],
			["2", "Chicken Sandwich", "Chicken"],
			["3", "Fries", "Sides"],
			["4", "Burger Combo", "Burgers"],
			["5", "Cola", "Drinks"]
		],
		"answer": "category",
		"hint": "You want to count per category. Type: category",
		"result_headers": ["category", "COUNT(*)"],
		"result_rows": [
			["Burgers", "2"],
			["Chicken", "1"],
			["Sides", "1"],
			["Drinks", "1"]
		],
		"result_msg": "Orders grouped by category."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"text": "Report done! Burgers: 2, Chicken: 1, Sides: 1, Drinks: 1."
	},
	{
		"type": "dialogue",
		"char": "ff_supervisor",
		"name": "SUPERVISOR",
		"text": "Good numbers today. Burgers are always the top seller. Nice work, see you tomorrow."
	},
	{
		"type": "end"
	}
]

} # end LESSONS
