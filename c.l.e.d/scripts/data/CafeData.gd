extends Node
# ═══════════════════════════════════════════════════════
#  CAFE DATA  —  scripts/data/CafeData.gd
#
#  Each dialogue step has an "npc" field that controls
#  exactly which character and expression shows on screen.
#  Format:  "npc": "adult_N/expr"
#  Folders: adult_1, adult_2, adult_3
#  Exprs:   idle, talk, think, confuse, shock
#
#  Character assignments (Cafe World):
#    adult_1 = Cafe customer / Carlos (C1, C2)
#    adult_2 = Cafe supervisor (C3)
#
#  Rule: "you" and "scene" always use idle — NPC looks at you.
#        NPCs use talk/think/shock/confuse when they speak.
# ═══════════════════════════════════════════════════════

const LESSONS: Dictionary = {

# ─────────────────────────────────────────────
#  LESSON C1 — SELECT (sql_choice)
#  Topic: Taking a customer's order at the cafe counter
# ─────────────────────────────────────────────
"C1": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "The morning rush begins. A customer steps up to the counter and glances at the menu."
	},
	{
		"type": "dialogue",
		"char": "cafe_customer",
		"name": "CUSTOMER",
		"npc":  "adult_1/talk",                  # customer ordering
		"text": "Hi! I'd like a latte, please."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "Let me choose the right response for this customer..."
	},
	{
		"type": "sql_choice",
		"desc": "A customer just placed a coffee order. Choose the most professional response for a cafe staff member.",
		"options": [
			[1, "Of course! What size would you like — small, medium, or large?"],
			[2, "We're out of lattes."],
			[3, "Just stand over there and wait."]
		],
		"correct_id": 1,
		"hint": "Confirm the order and ask a helpful follow-up. Answer: id = 1"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "Of course! What size would you like — small, medium, or large?"
	},
	{
		"type": "dialogue",
		"char": "cafe_customer",
		"name": "CUSTOMER",
		"npc":  "adult_1/idle",                  # customer happy and relaxed
		"text": "Medium please! You're so helpful, thank you!"
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON C2 — INSERT INTO
#  Topic: Logging a new order into the system
# ─────────────────────────────────────────────
"C2": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "A customer walks up to the counter ready to order."
	},
	{
		"type": "dialogue",
		"char": "cafe_customer",
		"name": "CUSTOMER",
		"npc":  "adult_1/talk",                  # Carlos placing order
		"text": "Hi, I'd like a cappuccino and a blueberry muffin, please. Name's Carlos."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "Got it, Carlos! Let me log that order into our system."
	},
	{
		"type": "sql_fill",
		"gamemode": "insert_into",
		"desc": "Log Carlos's order into the orders table. Fill in the customer_name, drink, and food.",
		"table": "orders",
		"columns": ["customer_name", "drink", "food"],
		"table_headers": ["id", "customer_name", "drink", "food"],
		"table_rows": [],
		"answers": ["Carlos", "Cappuccino", "Blueberry Muffin"],
		"hint": "Name: Carlos | Drink: Cappuccino | Food: Blueberry Muffin",
		"result_headers": ["id", "customer_name", "drink", "food"],
		"result_rows": [["5", "Carlos", "Cappuccino", "Blueberry Muffin"]],
		"result_msg": "1 record inserted into orders."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "Order logged! Your cappuccino and blueberry muffin will be ready shortly, Carlos!"
	},
	{
		"type": "dialogue",
		"char": "cafe_customer",
		"name": "CUSTOMER",
		"npc":  "adult_1/idle",                  # Carlos grateful and happy
		"text": "Wonderful, thank you so much!"
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON C3 — GROUP BY
#  Topic: End-of-day sales report by category
# ─────────────────────────────────────────────
"C3": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_2/idle",                  # looking at you — idle
		"text": "The cafe is closing up. Your supervisor comes over with today's order sheet."
	},
	{
		"type": "dialogue",
		"char": "cafe_supervisor",
		"name": "SUPERVISOR",
		"npc":  "adult_2/talk",                  # supervisor requesting report
		"text": "Before you go, can you pull a count of today's orders grouped by category?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_2/idle",                  # looking at you — idle
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
			["1", "Latte",           "Drinks"],
			["2", "Cappuccino",      "Drinks"],
			["3", "Blueberry Muffin","Pastries"],
			["4", "Croissant",       "Pastries"],
			["5", "Espresso",        "Drinks"]
		],
		"answer": "category",
		"hint": "You want to count per category. Type: category",
		"result_headers": ["category", "COUNT(*)"],
		"result_rows": [
			["Drinks",   "3"],
			["Pastries", "2"]
		],
		"result_msg": "Orders grouped by category."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_2/idle",                  # looking at you — idle
		"text": "Report done! Drinks: 3, Pastries: 2."
	},
	{
		"type": "dialogue",
		"char": "cafe_supervisor",
		"name": "SUPERVISOR",
		"npc":  "adult_2/think",                 # supervisor reviewing results
		"text": "Great numbers today! Drinks always lead. Nice work — see you tomorrow."
	},
	{
		"type": "end"
	}
]

} # end LESSONS
