extends Node
# ═══════════════════════════════════════════════════════
#  CAFE DATA  |  scripts/data/CafeData.gd
#
#  Curriculum trimmed to query-only lessons (Basic SQL,
#  Filtering Rows, Sorting & Aggregates) per panel feedback.
#  Joins/Subqueries, Functions, and all schema/DDL chapters
#  (Creating Tables, Constraints & Keys, Schema Management,
#  Advanced Concepts) were removed.
#
#  Each lesson uses a DIFFERENT NPC (except boss).
#  Format:  "npc": "adult_N/expr"  OR  "NPC_occupations/X/expr"
#
#  Lesson NPC assignments:
#    C1 -> adult_6   (latte customer)
#    C2 -> adult_7   (Carlos, cappuccino order)
#    C3 -> NPC_occupations/coffee_owner  (supervisor/boss)
#    C4 -> adult_8   (Rivera, missing order)
#    C5 -> adult_9   (Santos, wrong order)
#    C6 -> adult_10  (customer canceling)
#    C7 -> NPC_occupations/coffee_owner  (supervisor/boss)
#
#  Rule: "you" / "scene" always use idle | NPC looks at you.
# ═══════════════════════════════════════════════════════

const LESSONS: Dictionary = {

# ─────────────────────────────────────────────
#  LESSON C1 | SELECT  |  NPC: adult_6
# ─────────────────────────────────────────────
"C1": [
	{ "type": "dialogue", "char": "scene",        "name": "SCENE",
	  "npc": "adult_6/idle",
	  "text": "It's your first morning behind the counter. Before the rush hits, a coworker shows you the order system." },
	{ "type": "dialogue", "char": "cafe_customer", "name": "COWORKER",
	  "npc": "adult_6/talk",
	  "text": "Let's start with the basics. Pull up every order in the system every column, every row." },
	{ "type": "dialogue", "char": "you",           "name": "YOU",
	  "npc": "adult_6/idle",
	  "text": "Sure! Let me query the orders table and show you everything." },
	{ "type": "sql_fill",
	  "gamemode": "select_basic",
	  "desc": "Retrieve every column and every row from the orders table.",
	  "table": "orders",
	  "table_headers": ["id", "customer", "item", "status"],
	  "table_rows": [
	  	["1", "Maria",  "Latte",      "Paid"],
	  	["2", "Rivera", "Iced Tea",   "Paid"],
	  	["3", "Santos", "Cappuccino", "Pending"],
	  	["4", "Kim",    "Americano",  "Paid"],
	  	["5", "Reyes",  "Mocha",      "Pending"]
	  ],
	  "answer": "*",
	  "hint": "To select every column, type the wildcard: *",
	  "fail": [
		{ "type": "dialogue", "char": "cafe_customer", "name": "COWORKER", "npc": "adult_6/shock", "text": "That's not right. To grab every column at once, use the wildcard character." },
		{ "type": "dialogue", "char": "scene",          "name": "SCENE",    "npc": "adult_6/idle",  "text": "The coworker points at the register screen, waiting patiently." },
		{ "type": "dialogue", "char": "you",            "name": "YOU",      "npc": "adult_6/idle",  "text": "Right the wildcard for 'everything' is: *" }
	  ],
	  "result_headers": ["id", "customer", "item", "status"],
	  "result_rows": [
	  	["1", "Maria",  "Latte",      "Paid"],
	  	["2", "Rivera", "Iced Tea",   "Paid"],
	  	["3", "Santos", "Cappuccino", "Pending"],
	  	["4", "Kim",    "Americano",  "Paid"],
	  	["5", "Reyes",  "Mocha",      "Pending"]
	  ],
	  "result_msg": "5 orders retrieved. SELECT * returns every column for every row in the table." },
	{ "type": "dialogue", "char": "you",           "name": "YOU",
	  "npc": "adult_6/idle",
	  "text": "There you go all 5 orders, every column." },
	{ "type": "dialogue", "char": "cafe_customer", "name": "COWORKER",
	  "npc": "adult_6/talk",
	  "text": "Perfect. SELECT * is the most basic query there is, and you'll type it constantly. Good start!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C2 | INSERT INTO  |  NPC: adult_7
# ─────────────────────────────────────────────
"C2": [
	{ "type": "dialogue", "char": "scene",        "name": "SCENE",
	  "npc": "adult_7/idle",
	  "text": "A customer walks up to the counter ready to order." },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CARLOS",
	  "npc": "adult_7/talk",
	  "text": "Hi, I'd like a cappuccino and a blueberry muffin, please. Name's Carlos." },
	{ "type": "dialogue", "char": "you",           "name": "YOU",
	  "npc": "adult_7/idle",
	  "text": "Got it, Carlos! Let me log that order into our system." },
	{ "type": "sql_fill",
	  "gamemode": "insert_into",
	  "desc": "Log Carlos's order into the orders table. Fill in the customer_name, drink, and food.",
	  "table": "orders",
	  "columns": ["customer_name", "drink", "food"],
	  "table_headers": ["id", "customer_name", "drink", "food"],
	  "table_rows": [
	  	["1", "Maria",  "Latte",      "Croissant"],
	  	["2", "Rivera", "Iced Tea",   "None"],
	  	["3", "Kim",    "Americano",  "Bagel"],
	  	["4", "Reyes",  "Mocha",      "Cookie"]
	  ],
	  "answers": ["Carlos", "Cappuccino", "Blueberry Muffin"],
	  "hint": "Name: Carlos Drink: Cappuccino Food: Blueberry Muffin",
	  "result_headers": ["id", "customer_name", "drink", "food"],
	  "result_rows": [["5", "Carlos", "Cappuccino", "Blueberry Muffin"]],
	  "result_msg": "1 record inserted into orders.",
					"fail": [
						{ "type": "dialogue", "char": "cafe_customer", "name": "CARLOS",    "npc": "adult_7/confuse", "text": "Wait... that is not my order at all. Who is Hernandez?!" },
						{ "type": "dialogue", "char": "scene",        "name": "SCENE",     "npc": "adult_7/idle",   "text": "Carlos stares at the screen. The line behind him is growing longer." },
						{ "type": "dialogue", "char": "you",          "name": "YOU",       "npc": "adult_7/idle",   "text": "I am so sorry Carlos! Let me re-enter your order correctly." }
					] },
	{ "type": "dialogue", "char": "you",           "name": "YOU",
	  "npc": "adult_7/idle",
	  "text": "Order logged! Your cappuccino and blueberry muffin will be ready shortly, Carlos!" },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CARLOS",
	  "npc": "adult_7/talk",
	  "text": "Wonderful, thank you so much!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C3 | GROUP BY  |  NPC: coffee_owner (boss)
# ─────────────────────────────────────────────
"C3": [
	{ "type": "dialogue", "char": "scene",          "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The cafe is closing up. Your supervisor comes over with today's order sheet." },
	{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Before you go, can you pull a count of today's orders grouped by category?" },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Sure, I'll run that report right now." },
	{ "type": "sql_fill",
	  "gamemode": "group_by",
	  "desc": "Count today's orders by category. Fill in the GROUP BY column name.",
	  "table": "orders",
	  "column": "category",
	  "table_headers": ["id", "item", "category"],
	  "table_rows": [
	  	["1",  "Latte",            "Drinks"],
	  	["2",  "Cappuccino",       "Drinks"],
	  	["3",  "Blueberry Muffin", "Pastries"],
	  	["4",  "Croissant",        "Pastries"],
	  	["5",  "Espresso",         "Drinks"],
	  	["6",  "Matcha Latte",     "Drinks"],
	  	["7",  "Cheesecake",       "Pastries"],
	  	["8",  "Iced Tea",         "Drinks"],
	  	["9",  "Donut",            "Pastries"],
	  	["10", "Cold Brew",        "Drinks"]
	  ],
	  "answer": "category",
	  "hint": "You want to count per category. Type: category",
	  "result_headers": ["category", "COUNT(*)"],
	  "result_rows": [["Drinks", "6"], ["Pastries", "4"]],
	  "result_msg": "Orders grouped by category.",
					"fail": [
						{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/shock", "text": "This report makes no sense! You grouped by item not category this is useless!" },
						{ "type": "dialogue", "char": "scene",          "name": "SCENE",      "npc": "NPC_occupations/coffee_owner/idle",  "text": "Your supervisor shakes their head. You feel the pressure of closing time." },
						{ "type": "dialogue", "char": "you",            "name": "YOU",        "npc": "NPC_occupations/coffee_owner/idle",  "text": "Let me re-run this with the correct GROUP BY column." }
					] },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Report done! Drinks: 3, Pastries: 2." },
	{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "Great numbers today! Drinks always lead. Nice work see you tomorrow." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C4 | SELECT WHERE  |  NPC: adult_8
# ─────────────────────────────────────────────
"C4": [
	{ "type": "dialogue", "char": "scene",        "name": "SCENE",
	  "npc": "adult_8/idle",
	  "text": "A customer rushes back to the counter, looking worried." },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_8/confuse",
	  "text": "Hi! I placed an order earlier but I haven't received it yet. Can you look it up? Name's Rivera." },
	{ "type": "dialogue", "char": "you",           "name": "YOU",
	  "npc": "adult_8/idle",
	  "text": "Of course! Let me search for your order right now." },
	{ "type": "sql_fill",
	  "gamemode": "select_where",
	  "desc": "Search the orders table for the customer named Rivera. Fill in the WHERE clause.",
	  "table": "orders",
	  "column": "customer_name",
	  "table_headers": ["id", "customer_name", "drink", "food"],
	  "table_rows": [
	  	["1", "Maria",   "Latte",        "Sandwich"],
	  	["2", "Rivera",  "Iced Tea",     "Croissant"],
	  	["3", "Santos",  "Hot Latte",    "None"],
	  	["4", "Kim",     "Americano",    "Cheesecake"],
	  	["5", "Carlos",  "Cappuccino",   "Blueberry Muffin"],
	  	["6", "Reyes",   "Matcha Latte", "None"],
	  	["7", "Cruz",    "Cold Brew",    "Donut"]
	  ],
	  "answer": "Rivera",
	  "hint": "Type the customer name exactly: Rivera",
	  "result_headers": ["id", "customer_name", "drink", "food"],
	  "result_rows": [["2", "Rivera", "Iced Tea", "Croissant"]],
	  "result_msg": "1 record found.",
					"fail": [
						{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",  "npc": "adult_8/shock", "text": "That is not me! You looked up the wrong person! Where is my order?!" },
						{ "type": "dialogue", "char": "scene",        "name": "SCENE",     "npc": "adult_8/idle",  "text": "The customer is getting visibly upset. Other staff are watching." },
						{ "type": "dialogue", "char": "you",          "name": "YOU",       "npc": "adult_8/idle",  "text": "I apologize! Let me search again with the right name." }
					] },
	{ "type": "dialogue", "char": "you",           "name": "YOU",
	  "npc": "adult_8/idle",
	  "text": "Found it! Iced Tea and a Croissant your order is still being prepared. Sorry for the wait!" },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_8/talk",
	  "text": "Oh thank goodness! No worries, thank you for checking!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C5 | UPDATE SET  |  NPC: adult_9
# ─────────────────────────────────────────────
"C5": [
	{ "type": "dialogue", "char": "scene",        "name": "SCENE",
	  "npc": "adult_9/idle",
	  "text": "A customer approaches the counter looking a bit annoyed, holding their cup." },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_9/shock",
	  "text": "Excuse me! I ordered an Iced Latte but the system shows I ordered a Hot Latte. Can you fix that?" },
	{ "type": "dialogue", "char": "you",           "name": "YOU",
	  "npc": "adult_9/idle",
	  "text": "I'm so sorry about that! Let me correct it right now. What's your order id?" },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_9/talk",
	  "text": "It's order id 3." },
	{ "type": "sql_fill",
	  "gamemode": "update_set",
	  "desc": "Fix the drink from 'Hot Latte' to 'Iced Latte' for order id = 3.",
	  "table": "orders",
	  "column": "drink",
	  "table_headers": ["id", "customer_name", "drink", "food"],
	  "table_rows": [
	  	["1", "Maria",   "Latte",        "Sandwich"],
	  	["2", "Rivera",  "Iced Tea",     "Croissant"],
	  	["3", "Santos",  "Hot Latte",    "None"],
	  	["4", "Kim",     "Americano",    "Cheesecake"],
	  	["5", "Carlos",  "Cappuccino",   "Blueberry Muffin"],
	  	["6", "Reyes",   "Matcha Latte", "None"]
	  ],
	  "answer_value": "Iced Latte",
	  "answer_id": "3",
	  "hint": "Change drink to: Iced Latte Record id: 3",
	  "result_headers": ["id", "customer_name", "drink", "food"],
	  "result_rows": [["3", "Santos", "Iced Latte", "None"]],
	  "result_msg": "1 record updated.",
					"fail": [
						{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",  "npc": "adult_9/shock", "text": "It still says Hot Latte! Did you even change anything?!" },
						{ "type": "dialogue", "char": "scene",        "name": "SCENE",     "npc": "adult_9/idle",  "text": "The customer is losing patience. Your coworkers pretend not to notice." },
						{ "type": "dialogue", "char": "you",          "name": "YOU",       "npc": "adult_9/idle",  "text": "I am so sorry! Let me enter the correct values this time." }
					] },
	{ "type": "dialogue", "char": "you",           "name": "YOU",
	  "npc": "adult_9/idle",
	  "text": "Done! Updated to Iced Latte. Your correct order will be out shortly sorry again!" },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_9/talk",
	  "text": "Thank you! That's all I needed." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C6 | DELETE  |  NPC: adult_10
# ─────────────────────────────────────────────
"C6": [
	{ "type": "dialogue", "char": "scene",        "name": "SCENE",
	  "npc": "adult_10/idle",
	  "text": "A customer hurries back through the door looking apologetic." },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_10/confuse",
	  "text": "Hi, I'm so sorry I need to cancel my order. I just got a call and I have to leave immediately!" },
	{ "type": "dialogue", "char": "you",           "name": "YOU",
	  "npc": "adult_10/idle",
	  "text": "No problem at all! What's your order id?" },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_10/talk",
	  "text": "It's order id 2. Thank you so much!" },
	{ "type": "sql_fill",
	  "gamemode": "delete",
	  "desc": "Remove the customer's order from the database. Order id = 2.",
	  "table": "orders",
	  "table_headers": ["id", "customer_name", "drink", "food"],
	  "table_rows": [
	  	["1", "Maria",   "Latte",        "Sandwich"],
	  	["2", "Rivera",  "Iced Tea",     "Croissant"],
	  	["3", "Santos",  "Iced Latte",   "None"],
	  	["4", "Kim",     "Americano",    "Cheesecake"],
	  	["5", "Carlos",  "Cappuccino",   "Blueberry Muffin"],
	  	["6", "Reyes",   "Matcha Latte", "None"],
	  	["7", "Cruz",    "Espresso",     "Donut"]
	  ],
	  "answer_id": "2",
	  "hint": "Delete the record where id = 2",
	  "result_headers": ["STATUS"],
	  "result_rows": [["Record with id = 2 has been removed."]],
	  "result_msg": "1 record deleted.",
					"fail": [
						{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",  "npc": "adult_10/confuse", "text": "Wait you cancelled the wrong order! Now someone else's food is gone!" },
						{ "type": "dialogue", "char": "scene",        "name": "SCENE",     "npc": "adult_10/idle",   "text": "An awkward silence falls. A confused customer checks their phone for their order confirmation." },
						{ "type": "dialogue", "char": "you",          "name": "YOU",       "npc": "adult_10/idle",   "text": "My apologies! I need to enter the correct order id." }
					] },
	{ "type": "dialogue", "char": "you",           "name": "YOU",
	  "npc": "adult_10/idle",
	  "text": "Done! Your order has been cancelled. Hope everything is okay come back soon!" },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_10/talk",
	  "text": "Thank you so much! You're the best!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C7 | ORDER BY  |  NPC: coffee_owner (boss)
# ─────────────────────────────────────────────
"C7": [
	{ "type": "dialogue", "char": "scene",          "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Your supervisor walks over with a tablet, checking the digital menu board." },
	{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Can you pull up all menu items sorted by price cheapest to most expensive? We're updating the board." },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "On it! I'll sort the menu by price right now." },
	{ "type": "sql_fill",
	  "gamemode": "order_by",
	  "desc": "Sort all menu items from cheapest to most expensive by price. Type ASC or DESC.",
	  "table": "menu",
	  "column": "price",
	  "table_headers": ["id", "item", "category", "price"],
	  "table_rows": [
	  	["1", "Espresso",         "Drinks",   "2.50"],
	  	["2", "Latte",            "Drinks",   "4.00"],
	  	["3", "Cappuccino",       "Drinks",   "3.50"],
	  	["4", "Blueberry Muffin", "Pastries", "3.00"],
	  	["5", "Croissant",        "Pastries", "2.75"],
	  	["6", "Matcha Latte",     "Drinks",   "4.25"],
	  	["7", "Cheesecake",       "Pastries", "3.75"],
	  	["8", "Cold Brew",        "Drinks",   "3.25"],
	  	["9", "Donut",            "Pastries", "2.00"]
	  ],
	  "answer": "ASC",
	  "hint": "Cheapest first = lowest to highest = Ascending. Type: ASC",
	  "result_headers": ["id", "item", "category", "price"],
	  "result_rows": [
	  	["9", "Donut",            "Pastries", "2.00"],
	  	["1", "Espresso",         "Drinks",   "2.50"],
	  	["5", "Croissant",        "Pastries", "2.75"],
	  	["4", "Blueberry Muffin", "Pastries", "3.00"],
	  	["8", "Cold Brew",        "Drinks",   "3.25"],
	  	["3", "Cappuccino",       "Drinks",   "3.50"],
	  	["7", "Cheesecake",       "Pastries", "3.75"],
	  	["2", "Latte",            "Drinks",   "4.00"],
	  	["6", "Matcha Latte",     "Drinks",   "4.25"]
	  ],
	  "result_msg": "Records sorted by price ASC.",
					"fail": [
						{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/shock", "text": "The most expensive first?! Customers will think we are overcharging! Fix it!" },
						{ "type": "dialogue", "char": "scene",          "name": "SCENE",      "npc": "NPC_occupations/coffee_owner/idle",  "text": "Your supervisor quickly covers the screen before any customers can see." },
						{ "type": "dialogue", "char": "you",            "name": "YOU",        "npc": "NPC_occupations/coffee_owner/idle",  "text": "I will sort cheapest-first right away!" }
					] },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Done! Sorted cheapest to most expensive: Espresso, Croissant, Muffin, Cappuccino, Latte." },
	{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Perfect. That's exactly what I needed for the menu board update. Great work!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C8 | IS NULL  |  NPC: coffee_owner
#  Topic: Find orders with no special notes
# ─────────────────────────────────────────────
"C8": [
	{ "type": "dialogue", "char": "scene",           "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Mid-morning rush. The supervisor wants to see which orders need no special preparation." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Can you pull up all orders where the customer left no special notes? Those go straight to the standard recipe." },
	{ "type": "dialogue", "char": "you",              "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Sure! In SQL, empty fields are stored as NULL. I'll use IS NULL to find orders with no notes." },
	{
		"type": "sql_fill",
		"gamemode": "select_where_null",
		"desc": "Find all orders that have no special notes. NULL means no note was left. Type NULL after IS.",
		"table": "orders",
		"column": "notes",
		"table_headers": ["id", "customer", "item", "notes"],
		"table_rows": [
			["1", "Maria",  "Latte",        ""],
			["2", "Rivera", "Iced Tea",     "Less ice"],
			["3", "Santos", "Hot Latte",    ""],
			["4", "Kim",    "Americano",    "Extra shot"],
			["5", "Carlos", "Cappuccino",   ""],
			["6", "Reyes",  "Matcha Latte", "Oat milk"]
		],
		"answer": "NULL",
		"hint": "No notes = missing value = NULL. Type: NULL",
		"result_headers": ["id", "customer", "item", "notes"],
		"result_rows": [
			["1", "Maria",  "Latte",      "NULL"],
			["3", "Santos", "Hot Latte",  "NULL"],
			["5", "Carlos", "Cappuccino", "NULL"]
		],
		"result_msg": "3 orders have no special notes.",
		"fail": [
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/shock", "text": "That is not right! NULL is not a customer name it means the field is empty." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "A long line of customers forms at the counter. Time is short." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "I need to use IS NULL to check for missing values." }
		]
	},
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Found them! Maria, Santos, and Carlos left no notes standard recipes for all three." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Perfect. IS NULL is great for catching incomplete data. Nice SQL work." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C16 | SELECT DISTINCT  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C16": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The cafe owner wants to know exactly which menu items have been ordered without listing duplicates." },
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Our orders table has 200 rows but I only want to see each unique item name once. No repeats." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "SELECT DISTINCT removes duplicates from results. You get each unique value exactly once." },
	{ "type": "sql_fill", "gamemode": "select_distinct",
	  "desc": "Return only the unique item names from the orders table. Fill in the column name after SELECT DISTINCT.",
	  "table": "orders",
	  "column": "item",
	  "table_headers": ["id","customer","item","price"],
	  "table_rows": [["1","Ana","Latte","4.50"],["2","Ben","Espresso","3.00"],["3","Cara","Latte","4.50"],["4","Dan","Cappuccino","4.00"],["5","Eve","Espresso","3.00"],["6","Fay","Latte","4.50"]],
	  "hint": "The column with repeating item names: item",
	  "result_headers": ["item"],
	  "result_rows": [["Latte"],["Espresso"],["Cappuccino"]],
	  "result_msg": "3 unique items found. DISTINCT removed repeated 'Latte' and 'Espresso' entries.",
	  "fail": [
		{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/shock", "text": "That column does not exist! The item names are stored in the 'item' column." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle", "text": "Type the column name: item" }
	  ]
	},
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Latte, Espresso, Cappuccino. DISTINCT is great for seeing what we actually sell." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Exactly. Without DISTINCT you would see Latte three times and Espresso twice." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C17 | AND/OR  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C17": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The owner wants to find expensive Latte orders for a loyalty promotion." },
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "I need orders where the item is 'Latte' AND the price is over 3.50. Both conditions must be true." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "AND requires both conditions true at once. OR would match either condition alone." },
	{ "type": "sql_fill", "gamemode": "where_and_or",
	  "desc": "Find orders where item is 'Latte' AND price > 3.50. Fill in AND or OR.",
	  "table": "orders",
	  "condition1": "item = 'Latte'",
	  "condition2": "price > 3.50",
	  "answer": "AND",
	  "table_headers": ["id","customer","item","price"],
	  "table_rows": [["1","Ana","Latte","4.50"],["2","Ben","Espresso","3.00"],["3","Cara","Latte","4.50"],["4","Dan","Cappuccino","4.00"],["5","Eve","Espresso","3.00"],["6","Fay","Latte","4.50"]],
	  "hint": "Both conditions required simultaneously: AND",
	  "result_headers": ["id","customer","item","price"],
	  "result_rows": [["1","Ana","Latte","4.50"],["3","Cara","Latte","4.50"],["6","Fay","Latte","4.50"]],
	  "result_msg": "3 Latte orders over 3.50. AND filters rows where BOTH conditions are true.",
	  "fail": [
		{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/shock", "text": "That returned too many results. I need BOTH conditions true at once." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle", "text": "Use AND to require both conditions." }
	  ]
	},
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "3 high-value Latte orders. AND is strict both conditions must hold." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "OR would also include cheap Lattes and expensive non-Lattes too broad for this report." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C18 | BETWEEN  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C18": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The owner wants to find mid-priced orders for a targeted discount campaign." },
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Show me all orders where price is between 2.50 and 5.00. I want to include both endpoints." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "BETWEEN filters an inclusive range. BETWEEN 2.50 AND 5.00 includes 2.50 and 5.00 themselves." },
	{ "type": "sql_fill", "gamemode": "where_between",
	  "desc": "Find orders where price is between 2.50 and 5.00. Fill in the range keyword.",
	  "table": "orders",
	  "column": "price",
	  "low": "2.50", "high": "5.00",
	  "answer": "BETWEEN",
	  "table_headers": ["id","item","price"],
	  "table_rows": [["1","Latte","4.50"],["2","Espresso","3.00"],["3","Water","1.50"],["4","Cappuccino","4.00"],["5","Juice","6.00"],["6","Tea","2.50"]],
	  "hint": "The inclusive range keyword is: BETWEEN",
	  "result_headers": ["id","item","price"],
	  "result_rows": [["1","Latte","4.50"],["2","Espresso","3.00"],["4","Cappuccino","4.00"],["6","Tea","2.50"]],
	  "result_msg": "4 orders in range. Water (1.50) and Juice (6.00) are outside the range.",
	  "fail": [
		{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/shock", "text": "That is not the right keyword. The range filter is BETWEEN." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle", "text": "Type BETWEEN for range filtering." }
	  ]
	},
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "4 items in the discount range. BETWEEN saved writing price >= 2.50 AND price <= 5.00." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "BETWEEN also works with text ranges and dates. Very flexible for filtering." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C19 | LIKE  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C19": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "A customer complaint mentions all 'Latte' variations. The owner wants to find every order containing the word Latte." },
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Items like 'Iced Latte' and 'Vanilla Latte' also need to show up. The word Latte can be anywhere in the name." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "LIKE with '%Latte%' matches any item that contains Latte anywhere at the start, end, or middle." },
	{ "type": "sql_fill", "gamemode": "where_like",
	  "desc": "Find all items containing 'Latte' anywhere in the name. Fill in the LIKE pattern.",
	  "table": "orders",
	  "column": "item",
	  "answer": "'%Latte%'",
	  "table_headers": ["id","customer","item"],
	  "table_rows": [["1","Ana","Latte"],["2","Ben","Espresso"],["3","Cara","Iced Latte"],["4","Dan","Cappuccino"],["5","Eve","Vanilla Latte"],["6","Fay","Tea"]],
	  "hint": "Contains Latte anywhere: '%Latte%'",
	  "result_headers": ["id","customer","item"],
	  "result_rows": [["1","Ana","Latte"],["3","Cara","Iced Latte"],["5","Eve","Vanilla Latte"]],
	  "result_msg": "3 Latte orders found. % before and after means Latte can appear anywhere in the name.",
	  "fail": [
		{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/shock", "text": "That pattern missed some items. Remember % means any characters before or after." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle", "text": "For Latte anywhere in the name: '%Latte%'" }
	  ]
	},
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "All three Latte variants found. '%Latte%' is more flexible than searching for an exact match." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "'Latte%' would only find items starting with Latte. '%Latte' would only find items ending with Latte." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C20 | IN  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C20": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The owner wants a report covering only the top three coffee drinks." },
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Show me orders for Latte, Cappuccino, or Espresso only. Can I list them without writing three OR conditions?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Yes! IN lets you match against a list. WHERE item IN ('Latte','Cappuccino','Espresso') is much cleaner." },
	{ "type": "sql_fill", "gamemode": "where_in",
	  "desc": "Find orders for Latte, Cappuccino, or Espresso. Fill in the list membership keyword.",
	  "table": "orders",
	  "column": "item",
	  "in_list": "('Latte', 'Cappuccino', 'Espresso')",
	  "answer": "IN",
	  "table_headers": ["id","customer","item","price"],
	  "table_rows": [["1","Ana","Latte","4.50"],["2","Ben","Tea","2.00"],["3","Cara","Espresso","3.00"],["4","Dan","Cappuccino","4.00"],["5","Eve","Juice","5.00"],["6","Fay","Latte","4.50"]],
	  "hint": "The list membership keyword is: IN",
	  "result_headers": ["id","customer","item","price"],
	  "result_rows": [["1","Ana","Latte","4.50"],["3","Cara","Espresso","3.00"],["4","Dan","Cappuccino","4.00"],["6","Fay","Latte","4.50"]],
	  "result_msg": "4 coffee orders found. Tea and Juice excluded. IN matches any value in the list.",
	  "fail": [
		{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/shock", "text": "Wrong keyword. The list matching keyword is IN." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle", "text": "Type: IN" }
	  ]
	},
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "4 coffee orders! IN is so much cleaner than item='Latte' OR item='Cappuccino' OR item='Espresso'." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "You can also use NOT IN to exclude specific items from results." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C21 | LIMIT  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C21": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Morning rush is over. The owner quickly wants to check the first few orders of the day." },
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Just show me the first 5 orders. I do not need the whole list just a quick look." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "LIMIT caps how many rows are returned. It is perfect for quick previews of large tables." },
	{ "type": "sql_fill", "gamemode": "limit",
	  "desc": "Return only the first 5 orders. Type the number after LIMIT.",
	  "table": "orders",
	  "answer": "5",
	  "table_headers": ["id","customer","item","price"],
	  "table_rows": [["1","Ana","Latte","4.50"],["2","Ben","Espresso","3.00"],["3","Cara","Cappuccino","4.00"],["4","Dan","Tea","2.00"],["5","Eve","Latte","4.50"],["6","Fay","Juice","5.00"],["7","Gil","Espresso","3.00"]],
	  "hint": "Show only 5 rows type the number: 5",
	  "result_headers": ["id","customer","item","price"],
	  "result_rows": [["1","Ana","Latte","4.50"],["2","Ben","Espresso","3.00"],["3","Cara","Cappuccino","4.00"],["4","Dan","Tea","2.00"],["5","Eve","Latte","4.50"]],
	  "result_msg": "5 orders returned. Orders 6 and 7 were skipped. LIMIT is great for dashboards.",
	  "fail": [
		{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/shock", "text": "That is not 5. Type the number 5." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle", "text": "Type the number 5 after LIMIT." }
	  ]
	},
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "5 orders quick and clean. LIMIT keeps big queries manageable." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Combine with ORDER BY to get the top N results: ORDER BY price DESC LIMIT 3 finds the 3 priciest orders." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C22 | COUNT  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C22": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "End-of-day review. The owner needs to know the total number of orders served today." },
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "How many orders did we get today? Just give me a single number." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "COUNT is an aggregate function that returns the number of rows matching a query." },
	{ "type": "sql_fill", "gamemode": "aggregate",
	  "desc": "Count the total number of orders. Fill in the aggregate function name.",
	  "table": "orders",
	  "column": "id",
	  "answer": "COUNT",
	  "table_headers": ["id","customer","item","price"],
	  "table_rows": [["1","Ana","Latte","4.50"],["2","Ben","Espresso","3.00"],["3","Cara","Cappuccino","4.00"],["4","Dan","Tea","2.00"],["5","Eve","Latte","4.50"]],
	  "hint": "To count rows use: COUNT",
	  "result_headers": ["COUNT(id)"],
	  "result_rows": [["5"]],
	  "result_msg": "5 orders today.\n\nOther aggregate functions:\n- SUM(price) adds all prices for total revenue\n- AVG(price) finds the average order price",
	  "fail": [
		{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/shock", "text": "That is not right. To count rows use COUNT." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle", "text": "The counting function is COUNT." }
	  ]
	},
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "5 orders! And SELECT SUM(price) would give me today's total revenue." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Exactly. AVG(price) gives the average order value useful for pricing decisions." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C23 | HAVING  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C23": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The owner wants to spotlight popular items those ordered more than once today." },
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "I grouped by item already. But how do I filter out items that only appeared once? WHERE does not work after GROUP BY." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Use HAVING it filters groups after GROUP BY. WHERE filters rows before grouping." },
	{ "type": "sql_fill", "gamemode": "having",
	  "desc": "Show only items ordered more than once. Fill in the aggregate function in HAVING.",
	  "table": "orders",
	  "group_col": "item",
	  "answer": "COUNT",
	  "table_headers": ["id","customer","item"],
	  "table_rows": [["1","Ana","Latte"],["2","Ben","Espresso"],["3","Cara","Latte"],["4","Dan","Cappuccino"],["5","Eve","Espresso"],["6","Fay","Latte"]],
	  "hint": "HAVING filters groups using: COUNT",
	  "result_headers": ["item","COUNT(*)"],
	  "result_rows": [["Latte","3"],["Espresso","2"]],
	  "result_msg": "Latte (3) and Espresso (2) are popular. Cappuccino only had 1 order so it was filtered out.",
	  "fail": [
		{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/shock", "text": "Wrong function. HAVING needs COUNT to filter by group size." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle", "text": "Use COUNT in the HAVING clause." }
	  ]
	},
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Latte and Espresso are our bestsellers! HAVING is like WHERE but for grouped data." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Right. WHERE runs before grouping so it cannot see COUNT(*). HAVING runs after and can." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C24 | AS (Aliases)  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C24": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The owner wants a revenue report but the calculated column shows up with an ugly expression name." },
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "The column 'price * 0.9' shows up as that exact expression. Can we display it as 'discounted_price' instead?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "AS renames a column in the query output. It is called an alias and does not change the stored data." },
	{ "type": "sql_fill", "gamemode": "select_alias",
	  "desc": "Rename the calculated column to 'discounted_price'. Fill in the alias name after AS.",
	  "table": "orders",
	  "col_expr": "price * 0.9",
	  "answer": "discounted_price",
	  "table_headers": ["id","item","price"],
	  "table_rows": [["1","Latte","4.50"],["2","Espresso","3.00"],["3","Cappuccino","4.00"]],
	  "hint": "The alias for the discounted price column: discounted_price",
	  "result_headers": ["discounted_price"],
	  "result_rows": [["4.05"],["2.70"],["3.60"]],
	  "result_msg": "Column now shows as 'discounted_price'. AS only changes the display name the table is unchanged.",
	  "fail": [
		{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/shock", "text": "Wrong alias. The alias should be: discounted_price" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle", "text": "Type the alias: discounted_price" }
	  ]
	},
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Much cleaner! AS makes reports readable without touching the actual table data." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "AS also works on table names: FROM orders AS o very useful in JOIN queries." },
	{ "type": "end" }
],


} # end LESSONS

