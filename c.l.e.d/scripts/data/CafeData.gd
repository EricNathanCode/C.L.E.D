extends Node
# ═══════════════════════════════════════════════════════
#  CAFE DATA  —  scripts/data/CafeData.gd
#
#  Each lesson uses a DIFFERENT NPC (except boss).
#  Format:  "npc": "adult_N/expr"  OR  "NPC_occupations/X/expr"
#
#  Lesson NPC assignments:
#    C1 → adult_6   (latte customer)
#    C2 → adult_7   (Carlos, cappuccino order)
#    C3 → NPC_occupations/coffee_owner  (supervisor/boss)
#    C4 → adult_8   (Rivera, missing order)
#    C5 → adult_9   (Santos, wrong order)
#    C6 → adult_10  (customer canceling)
#    C7 → NPC_occupations/coffee_owner  (supervisor/boss)
#
#  Rule: "you" / "scene" always use idle — NPC looks at you.
# ═══════════════════════════════════════════════════════

const LESSONS: Dictionary = {

# ─────────────────────────────────────────────
#  LESSON C1 — SELECT  |  NPC: adult_6
# ─────────────────────────────────────────────
"C1": [
	{ "type": "dialogue", "char": "scene",        "name": "SCENE",
	  "npc": "adult_6/idle",
	  "text": "The morning rush begins. A customer steps up to the counter and glances at the menu." },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_6/talk",
	  "text": "Hi! I'd like a latte, please." },
	{ "type": "dialogue", "char": "you",           "name": "YOU",
	  "npc": "adult_6/idle",
	  "text": "Let me choose the right response for this customer..." },
	{ "type": "sql_choice",
	  "desc": "A customer just placed a coffee order. Choose the most professional response for a cafe staff member.",
	  "options": [
	  	[1, "Of course! What size would you like — small, medium, or large?"],
	  	[2, "We're out of lattes."],
	  	[3, "Just stand over there and wait."]
	  ],
	  "correct_id": 1,
	  "hint": "Confirm the order and ask a helpful follow-up. Answer: id = 1" },
	{ "type": "dialogue", "char": "you",           "name": "YOU",
	  "npc": "adult_6/idle",
	  "text": "Of course! What size would you like — small, medium, or large?" },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_6/talk",
	  "text": "Medium please! You're so helpful, thank you!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C2 — INSERT INTO  |  NPC: adult_7
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
	  "table_rows": [],
	  "answers": ["Carlos", "Cappuccino", "Blueberry Muffin"],
	  "hint": "Name: Carlos | Drink: Cappuccino | Food: Blueberry Muffin",
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
#  LESSON C3 — GROUP BY  |  NPC: coffee_owner (boss)
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
						{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/shock", "text": "This report makes no sense! You grouped by item not category — this is useless!" },
						{ "type": "dialogue", "char": "scene",          "name": "SCENE",      "npc": "NPC_occupations/coffee_owner/idle",  "text": "Your supervisor shakes their head. You feel the pressure of closing time." },
						{ "type": "dialogue", "char": "you",            "name": "YOU",        "npc": "NPC_occupations/coffee_owner/idle",  "text": "Let me re-run this with the correct GROUP BY column." }
					] },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Report done! Drinks: 3, Pastries: 2." },
	{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "Great numbers today! Drinks always lead. Nice work — see you tomorrow." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C4 — SELECT WHERE  |  NPC: adult_8
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
	  "text": "Found it! Iced Tea and a Croissant — your order is still being prepared. Sorry for the wait!" },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_8/talk",
	  "text": "Oh thank goodness! No worries, thank you for checking!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C5 — UPDATE SET  |  NPC: adult_9
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
	  "hint": "Change drink to: Iced Latte | Record id: 3",
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
	  "text": "Done! Updated to Iced Latte. Your correct order will be out shortly — sorry again!" },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_9/talk",
	  "text": "Thank you! That's all I needed." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C6 — DELETE  |  NPC: adult_10
# ─────────────────────────────────────────────
"C6": [
	{ "type": "dialogue", "char": "scene",        "name": "SCENE",
	  "npc": "adult_10/idle",
	  "text": "A customer hurries back through the door looking apologetic." },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_10/confuse",
	  "text": "Hi, I'm so sorry — I need to cancel my order. I just got a call and I have to leave immediately!" },
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
						{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",  "npc": "adult_10/confuse", "text": "Wait — you cancelled the wrong order! Now someone else's food is gone!" },
						{ "type": "dialogue", "char": "scene",        "name": "SCENE",     "npc": "adult_10/idle",   "text": "An awkward silence falls. A confused customer checks their phone for their order confirmation." },
						{ "type": "dialogue", "char": "you",          "name": "YOU",       "npc": "adult_10/idle",   "text": "My apologies! I need to enter the correct order id." }
					] },
	{ "type": "dialogue", "char": "you",           "name": "YOU",
	  "npc": "adult_10/idle",
	  "text": "Done! Your order has been cancelled. Hope everything is okay — come back soon!" },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_10/talk",
	  "text": "Thank you so much! You're the best!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C7 — ORDER BY  |  NPC: coffee_owner (boss)
# ─────────────────────────────────────────────
"C7": [
	{ "type": "dialogue", "char": "scene",          "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Your supervisor walks over with a tablet, checking the digital menu board." },
	{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Can you pull up all menu items sorted by price — cheapest to most expensive? We're updating the board." },
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
#  LESSON C8 — IS NULL  |  NPC: coffee_owner
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
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/shock", "text": "That is not right! NULL is not a customer name — it means the field is empty." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "A long line of customers forms at the counter. Time is short." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "I need to use IS NULL to check for missing values." }
		]
	},
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Found them! Maria, Santos, and Carlos left no notes — standard recipes for all three." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Perfect. IS NULL is great for catching incomplete data. Nice SQL work." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C9 — CREATE DATABASE  |  NPC: coffee_owner
#  Topic: CREATE DATABASE — setting up the database container first
# ─────────────────────────────────────────────
"C9": [
	{ "type": "dialogue", "char": "scene",           "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "A quiet morning at the café. The owner sits down with you and asks how the entire café system was built from scratch." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "I use SELECT and INSERT every day. But how was this whole system started? Who made the database in the first place?" },
	{ "type": "dialogue", "char": "you",              "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Before any tables or data, you run CREATE DATABASE. It creates the named container where all your tables will be stored." },
	{
		"type": "sql_fill",
		"gamemode": "create_database",
		"desc": "Create the café database. Type the missing keyword between CREATE and CafeDB.",
		"db_name": "CafeDB",
		"answer": "DATABASE",
		"hint": "The keyword after CREATE for a new database container is: DATABASE",
		"result_msg": "CafeDB is now created! All café tables — orders, customers, items — will live inside this database.",
		"fail": [
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/confuse", "text": "That is not right. We are creating a DATABASE, not a table yet." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "The supervisor taps the screen." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "The correct keyword is DATABASE — CREATE DATABASE CafeDB." }
		]
	},
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "So you create the DATABASE first, and then all the tables go inside it. That makes sense — like naming your folder before filing anything in it!" },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Exactly. One database can hold many tables. CafeDB will hold orders, customers — everything for this café." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C10 — CREATE TABLE  |  NPC: coffee_owner
#  Topic: CREATE TABLE — defining the table structure
# ─────────────────────────────────────────────
"C10": [
	{ "type": "dialogue", "char": "scene",           "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "After creating the database, the café owner asks how to actually define the orders table inside it." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "The database is ready. Now how do I build the orders table with its columns? What command do I use?" },
	{ "type": "dialogue", "char": "you",              "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Use CREATE TABLE. You give the table a name and list each column with its data type. The database then knows exactly what shape your data has." },
	{
		"type": "sql_fill",
		"gamemode": "create_table_keyword",
		"desc": "Create the orders table inside CafeDB. Type the missing keyword between CREATE and orders.",
		"table": "orders",
		"columns": [
			["id",       "INT"],
			["customer", "TEXT"],
			["item",     "TEXT"],
			["price",    "REAL"]
		],
		"answer": "TABLE",
		"hint": "The keyword after CREATE for a new table is: TABLE",
		"result_msg": "orders table created! It has 4 columns: id (INT), customer (TEXT), item (TEXT), price (REAL). Every order will follow this structure.",
		"fail": [
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/confuse", "text": "That is not correct. We already have the database — now we are creating a TABLE inside it." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "The supervisor looks at the screen." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "The keyword is TABLE — CREATE TABLE orders." }
		]
	},
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "CREATE TABLE! And you list each column with its type right inside the parentheses. Now I understand the full setup." },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Exactly — first CREATE DATABASE, then CREATE TABLE. Now the structure is ready and you can INSERT orders into it." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C11 — PRIMARY KEY  |  NPC: coffee_owner
#  Topic: CREATE TABLE with PRIMARY KEY constraint
# ─────────────────────────────────────────────
"C11": [
	{ "type": "dialogue", "char": "scene",           "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The café owner wants to understand how the orders table was built from the start." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Can you show me how to create the orders table in SQL? I want to see how the id column is made special." },
	{ "type": "dialogue", "char": "you",              "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Of course! The id column gets a constraint called PRIMARY KEY when we create the table. It makes sure every order id is unique and never blank." },
	{
		"type": "sql_fill",
		"gamemode": "create_table",
		"desc": "Complete the CREATE TABLE statement for the orders table. The 'id' column must be the PRIMARY KEY — type it in the blank.",
		"table": "orders",
		"pk_col": "id",
		"columns": [
			["id",       "INT"],
			["customer", "TEXT"],
			["item",     "TEXT"],
			["price",    "REAL"]
		],
		"answer": "PRIMARY KEY",
		"hint": "The constraint that makes a column unique for every row is: PRIMARY KEY",
		"result_msg": "Table created! The PRIMARY KEY on 'id' means every order gets a unique number — even if two customers order the same thing.",
		"fail": [
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/confuse", "text": "That is not it. The constraint is two words — PRIMARY and KEY together." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "The supervisor leans in to look at the screen." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "Let me type it correctly — PRIMARY KEY." }
		]
	},
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "So PRIMARY KEY goes right after INT! And every id will be different. That is how databases stay organised." },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Exactly. Every table should have a PRIMARY KEY column so records are never confused." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C12 — JOIN  |  NPC: coffee_owner
#  Topic: FOREIGN KEY / JOIN — combining two tables
# ─────────────────────────────────────────────
"C12": [
	{ "type": "dialogue", "char": "scene",           "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The owner wants a full report — customer names beside their ordered items — but the data is in two separate tables." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Can you JOIN the customers and orders tables so I can see each customer with their order in one view?" },
	{ "type": "dialogue", "char": "you",              "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Of course! The customers.id links to orders.customer_id — that linking column is called a Foreign Key. I will JOIN on that." },
	{
		"type": "sql_fill",
		"gamemode": "join",
		"desc": "JOIN the customers table with the orders table. The customers 'id' links to orders 'customer_id'. Fill in both column names.",
		"table_a": "customers",
		"table_b": "orders",
		"table_a_headers": ["id", "name", "loyalty_level"],
		"table_a_rows": [
			["1", "Maria",  "Gold"],
			["2", "Rivera", "Silver"],
			["3", "Santos", "Bronze"],
			["4", "Kim",    "Gold"]
		],
		"table_b_headers": ["id", "customer_id", "item", "price"],
		"table_b_rows": [
			["1", "1", "Latte",      "4.00"],
			["2", "2", "Iced Tea",   "3.50"],
			["3", "3", "Hot Latte",  "4.00"],
			["4", "4", "Americano",  "2.50"]
		],
		"join_col_a": "id",
		"join_col_b": "customer_id",
		"hint": "Table A linking column: id | Table B linking column: customer_id",
		"result_headers": ["name", "loyalty_level", "item", "price"],
		"result_rows": [
			["Maria",  "Gold",   "Latte",     "4.00"],
			["Rivera", "Silver", "Iced Tea",  "3.50"],
			["Santos", "Bronze", "Hot Latte", "4.00"],
			["Kim",    "Gold",   "Americano", "2.50"]
		],
		"result_msg": "4 records joined successfully.",
		"fail": [
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/shock", "text": "The JOIN failed! Match the right columns between the two tables." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "The supervisor points at both table headers." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "I see — customers.id must equal orders.customer_id. Let me correct it." }
		]
	},
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Done! Both tables are joined. You can now see each customer with their order in one clean list." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "That is exactly what I needed. JOIN is incredibly useful for pulling connected data together!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C13 — INT  |  NPC: coffee_owner
#  Topic: Data Type INT — whole numbers
# ─────────────────────────────────────────────
"C13": [
	{ "type": "dialogue", "char": "scene",           "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The supervisor reviews the orders table and asks about the data types used for each column." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "What type should the id column be? Each order needs a number like 1, 2, 3 — no decimals." },
	{ "type": "dialogue", "char": "you",              "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "That is INT — Integer. It stores whole numbers only. Perfect for IDs and counts." },
	{
		"type": "sql_fill",
		"gamemode": "data_type",
		"desc": "Define the orders table. The 'id' column stores a whole number. Fill in the correct data type.",
		"table": "orders",
		"columns": [
			["id",       ""],
			["customer", "TEXT"],
			["item",     "TEXT"],
			["price",    "REAL"]
		],
		"blank_col": "id",
		"answer": "INT",
		"type_hint": "Whole numbers (IDs, counts) use INT.",
		"hint": "A whole number data type (no decimals) is: INT",
		"result_msg": "Correct! INT stores whole numbers — 1, 2, 3. Order #5 will always be order #5, never order #5.5.",
		"fail": [
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/confuse", "text": "That is not right. The id column is a whole number — no letters, no decimals." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "The supervisor points at the id column." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "Whole numbers use INT — Integer." }
		]
	},
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "INT — integer — for whole numbers! Order 7 will never be order 7.3. That makes sense." },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Exactly. INT is the right type whenever the value must be a complete whole number." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C14 — TEXT  |  NPC: coffee_owner
#  Topic: Data Type TEXT — strings / words
# ─────────────────────────────────────────────
"C14": [
	{ "type": "dialogue", "char": "scene",           "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The supervisor looks at the customer and item columns and asks what type they should be." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "The customer name and item name are words — 'Maria', 'Latte'. What data type stores letters?" },
	{ "type": "dialogue", "char": "you",              "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "TEXT — it stores any sequence of letters, words, or characters. Names, descriptions, emails — all TEXT." },
	{
		"type": "sql_fill",
		"gamemode": "data_type",
		"desc": "Define the orders table. The 'customer' column stores a person's name. Fill in the correct data type.",
		"table": "orders",
		"columns": [
			["id",       "INT"],
			["customer", ""],
			["item",     "TEXT"],
			["price",    "REAL"]
		],
		"blank_col": "customer",
		"answer": "TEXT",
		"type_hint": "Names and words use TEXT (also called STRING).",
		"hint": "Letters and words use: TEXT  (also called STRING)",
		"result_msg": "Correct! TEXT stores words and characters — 'Maria', 'Latte', 'no sugar please'. You can also type STRING and it means the same thing.",
		"fail": [
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/confuse", "text": "Not right. customer stores a name — letters, not a number." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "The supervisor thinks." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "Letters and words use TEXT — also called STRING." }
		]
	},
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "TEXT for words! So customer names, item names, notes — all TEXT. INT for numbers only." },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Right. And some databases also call it VARCHAR or STRING — all the same idea." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C15 — REAL  |  NPC: coffee_owner
#  Topic: Data Type REAL — decimal / float numbers
# ─────────────────────────────────────────────
"C15": [
	{ "type": "dialogue", "char": "scene",           "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The supervisor looks at the price column and asks why it is different from the id column." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "A latte costs 4.50, an iced tea 3.75. These are not whole numbers — so they cannot be INT, right?" },
	{ "type": "dialogue", "char": "you",              "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Correct! For decimal numbers we use REAL. It stores values like 4.50 and 3.75 accurately." },
	{
		"type": "sql_fill",
		"gamemode": "data_type",
		"desc": "Define the orders table. The 'price' column stores a decimal price like 4.50. Fill in the correct data type.",
		"table": "orders",
		"columns": [
			["id",       "INT"],
			["customer", "TEXT"],
			["item",     "TEXT"],
			["price",    ""]
		],
		"blank_col": "price",
		"answer": "REAL",
		"type_hint": "Decimal numbers (prices, measurements) use REAL (also called FLOAT).",
		"hint": "Decimal numbers use: REAL  (also called FLOAT)",
		"result_msg": "Correct! REAL stores decimal numbers — 4.50, 3.75, 9.99. You can also type FLOAT and it means the same thing.",
		"fail": [
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/shock", "text": "Not right! price stores decimals like 4.50 — not whole numbers, not text." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "The supervisor points at the price list on the counter." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "Decimal numbers use REAL — also called FLOAT." }
		]
	},
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "REAL for decimals! So the three basic types are: INT for whole numbers, TEXT for words, REAL for decimals." },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "That is exactly it. Choose the right type and your database will store data accurately every time." },
	{ "type": "end" }
]

} # end LESSONS
