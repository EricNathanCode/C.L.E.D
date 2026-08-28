extends Node
# ═══════════════════════════════════════════════════════
#  CAFE DATA  |  scripts/data/CafeData.gd
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
#  Rule: "you" / "scene" always use idle | NPC looks at you.
# ═══════════════════════════════════════════════════════

const LESSONS: Dictionary = {

# ─────────────────────────────────────────────
#  LESSON C1 | SELECT  |  NPC: adult_6
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
	  	[1, "Of course! What size would you like small, medium, or large?"],
	  	[2, "We're out of lattes."],
	  	[3, "Just stand over there and wait."]
	  ],
	  "correct_id": 1,
	  "hint": "Confirm the order and ask a helpful follow-up. Answer: id = 1" },
	{ "type": "dialogue", "char": "you",           "name": "YOU",
	  "npc": "adult_6/idle",
	  "text": "Of course! What size would you like small, medium, or large?" },
	{ "type": "dialogue", "char": "cafe_customer", "name": "CUSTOMER",
	  "npc": "adult_6/talk",
	  "text": "Medium please! You're so helpful, thank you!" },
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
	  "table_rows": [],
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
#  LESSON C9 | CREATE DATABASE  |  NPC: coffee_owner
#  Topic: CREATE DATABASE | setting up the database container first
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
		"result_msg": "CafeDB is now created! All café tables orders, customers, items will live inside this database.",
		"fail": [
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/confuse", "text": "That is not right. We are creating a DATABASE, not a table yet." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "The supervisor taps the screen." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "The correct keyword is DATABASE CREATE DATABASE CafeDB." }
		]
	},
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "So you create the DATABASE first, and then all the tables go inside it. That makes sense like naming your folder before filing anything in it!" },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Exactly. One database can hold many tables. CafeDB will hold orders, customers everything for this café." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C10 | CREATE TABLE  |  NPC: coffee_owner
#  Topic: CREATE TABLE | defining the table structure
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
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/confuse", "text": "That is not correct. We already have the database now we are creating a TABLE inside it." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "The supervisor looks at the screen." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "The keyword is TABLE CREATE TABLE orders." }
		]
	},
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "CREATE TABLE! And you list each column with its type right inside the parentheses. Now I understand the full setup." },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Exactly first CREATE DATABASE, then CREATE TABLE. Now the structure is ready and you can INSERT orders into it." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C11 | PRIMARY KEY  |  NPC: coffee_owner
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
		"desc": "Complete the CREATE TABLE statement for the orders table. The 'id' column must be the PRIMARY KEY type it in the blank.",
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
		"result_msg": "Table created! The PRIMARY KEY on 'id' means every order gets a unique number even if two customers order the same thing.",
		"fail": [
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/confuse", "text": "That is not it. The constraint is two words PRIMARY and KEY together." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "The supervisor leans in to look at the screen." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "Let me type it correctly PRIMARY KEY." }
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
#  LESSON C12 | JOIN  |  NPC: coffee_owner
#  Topic: FOREIGN KEY / JOIN | combining two tables
# ─────────────────────────────────────────────
"C12": [
	{ "type": "dialogue", "char": "scene",           "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The owner wants a full report customer names beside their ordered items but the data is in two separate tables." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Can you JOIN the customers and orders tables so I can see each customer with their order in one view?" },
	{ "type": "dialogue", "char": "you",              "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Of course! The customers.id links to orders.customer_id that linking column is called a Foreign Key. I will JOIN on that." },
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
		"hint": "Table A linking column: id Table B linking column: customer_id",
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
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "I see customers.id must equal orders.customer_id. Let me correct it." }
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
#  LESSON C13 | INT  |  NPC: coffee_owner
#  Topic: Data Type INT | whole numbers
# ─────────────────────────────────────────────
"C13": [
	{ "type": "dialogue", "char": "scene",           "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The supervisor reviews the orders table and asks about the data types used for each column." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "What type should the id column be? Each order needs a number like 1, 2, 3 no decimals." },
	{ "type": "dialogue", "char": "you",              "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "That is INT Integer. It stores whole numbers only. Perfect for IDs and counts." },
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
		"result_msg": "Correct! INT stores whole numbers 1, 2, 3. Order #5 will always be order #5, never order #5.5.",
		"fail": [
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/confuse", "text": "That is not right. The id column is a whole number no letters, no decimals." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "The supervisor points at the id column." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "Whole numbers use INT Integer." }
		]
	},
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "INT integer for whole numbers! Order 7 will never be order 7.3. That makes sense." },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Exactly. INT is the right type whenever the value must be a complete whole number." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C14 | TEXT  |  NPC: coffee_owner
#  Topic: Data Type TEXT | strings / words
# ─────────────────────────────────────────────
"C14": [
	{ "type": "dialogue", "char": "scene",           "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The supervisor looks at the customer and item columns and asks what type they should be." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "The customer name and item name are words 'Maria', 'Latte'. What data type stores letters?" },
	{ "type": "dialogue", "char": "you",              "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "TEXT it stores any sequence of letters, words, or characters. Names, descriptions, emails all TEXT." },
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
		"result_msg": "Correct! TEXT stores words and characters 'Maria', 'Latte', 'no sugar please'. You can also type STRING and it means the same thing.",
		"fail": [
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/confuse", "text": "Not right. customer stores a name letters, not a number." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "The supervisor thinks." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "Letters and words use TEXT also called STRING." }
		]
	},
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "TEXT for words! So customer names, item names, notes all TEXT. INT for numbers only." },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Right. And some databases also call it VARCHAR or STRING all the same idea." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C15 | REAL  |  NPC: coffee_owner
#  Topic: Data Type REAL | decimal / float numbers
# ─────────────────────────────────────────────
"C15": [
	{ "type": "dialogue", "char": "scene",           "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The supervisor looks at the price column and asks why it is different from the id column." },
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "A latte costs 4.50, an iced tea 3.75. These are not whole numbers so they cannot be INT, right?" },
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
		"result_msg": "Correct! REAL stores decimal numbers 4.50, 3.75, 9.99. You can also type FLOAT and it means the same thing.",
		"fail": [
			{ "type": "dialogue", "char": "cafe_supervisor", "name": "SUPERVISOR", "npc": "NPC_occupations/coffee_owner/shock", "text": "Not right! price stores decimals like 4.50 not whole numbers, not text." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle", "text": "The supervisor points at the price list on the counter." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/coffee_owner/idle", "text": "Decimal numbers use REAL also called FLOAT." }
		]
	},
	{ "type": "dialogue", "char": "cafe_supervisor",  "name": "SUPERVISOR",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "REAL for decimals! So the three basic types are: INT for whole numbers, TEXT for words, REAL for decimals." },
	{ "type": "dialogue", "char": "you",             "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "That is exactly it. Choose the right type and your database will store data accurately every time." },
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

# ─────────────────────────────────────────────
#  LESSON C25 | NOT NULL + UNIQUE  |  NPC: adult_14 customer
# ─────────────────────────────────────────────
"C25": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "adult_14/idle",
	  "text": "A regular customer is curious about how the cafe's loyalty system prevents duplicate registrations." },
	{ "type": "dialogue", "char": "customer", "name": "CUSTOMER", "npc": "adult_14/talk",
	  "text": "My friend tried to sign up twice with the same email. And another forgot to put their name. Are there rules that block that?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_14/idle",
	  "text": "Yes column constraints! NOT NULL prevents missing values. UNIQUE prevents duplicates." },
	{ "type": "sql_fill", "gamemode": "create_table",
	  "desc": "The notes column in orders must always have a value. Add the NOT NULL constraint.",
	  "table": "orders",
	  "pk_col": "notes",
	  "columns": [["id","INT PRIMARY KEY"],["customer","TEXT"],["item","TEXT"],["notes","TEXT"]],
	  "answer": "NOT NULL",
	  "blank_hint": "constraint",
	  "error_hint": "The constraint that prevents empty values is NOT NULL.",
	  "result_msg": "NOT NULL set! Any order submitted without notes will now be rejected.",
	  "hint": "Prevent empty values: NOT NULL",
	  "fail": [
		{ "type": "dialogue", "char": "customer", "name": "CUSTOMER", "npc": "adult_14/confuse", "text": "That does not prevent empty values. The constraint is NOT NULL." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_14/idle", "text": "Type: NOT NULL" }
	  ]
	},
	{ "type": "dialogue", "char": "customer", "name": "CUSTOMER", "npc": "adult_14/talk",
	  "text": "NOT NULL stops blanks. Now what about preventing the same email being used twice?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_14/idle",
	  "text": "UNIQUE ensures no two rows share the same value in that column." },
	{ "type": "sql_fill", "gamemode": "create_table",
	  "desc": "The email in customers must be unique. Add the UNIQUE constraint.",
	  "table": "customers",
	  "pk_col": "email",
	  "columns": [["id","INT PRIMARY KEY"],["name","TEXT"],["email","TEXT"]],
	  "answer": "UNIQUE",
	  "blank_hint": "constraint",
	  "error_hint": "The constraint that prevents duplicate values is UNIQUE.",
	  "result_msg": "UNIQUE set! Duplicate emails will now be rejected on INSERT.",
	  "hint": "Prevent duplicate values: UNIQUE",
	  "fail": [
		{ "type": "dialogue", "char": "customer", "name": "CUSTOMER", "npc": "adult_14/confuse", "text": "Not right. UNIQUE prevents duplicates in a column." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_14/idle", "text": "Type: UNIQUE" }
	  ]
	},
	{ "type": "dialogue", "char": "customer", "name": "CUSTOMER", "npc": "adult_14/talk",
	  "text": "NOT NULL and UNIQUE two constraints that keep the loyalty database clean and reliable!" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_14/idle",
	  "text": "Combine them: email TEXT NOT NULL UNIQUE must be present AND must be different for every customer." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C26 | ALTER TABLE  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C26": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The cafe launched a discount program but the orders table has no discount column." },
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "We need a discount column in orders. Can we add it without rebuilding the whole table?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "ALTER TABLE ADD is exactly for this. It adds a new column to an existing table safely." },
	{ "type": "sql_fill", "gamemode": "alter_table",
	  "desc": "Add a discount column to the orders table. Fill in the keyword that adds a column.",
	  "table": "orders",
	  "new_col": "discount",
	  "col_type": "REAL",
	  "answer": "ADD",
	  "hint": "The keyword to add a column: ADD",
	  "result_msg": "discount column added! Existing orders are safe ALTER TABLE is non-destructive.",
	  "fail": [
		{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/shock", "text": "Wrong keyword. To add a column: ALTER TABLE name ADD column type" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle", "text": "The keyword is ADD." }
	  ]
	},
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Discount column added and all previous orders still have their data. ALTER TABLE is flexible." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "You can also DROP COLUMN to remove one, or RENAME COLUMN to change its name later." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C27 | DROP TABLE  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C27": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The seasonal menu is finished and its temporary table is cluttering the database." },
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "The seasonal_menu table was only for summer. Can we remove it completely? It is taking up space." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "DROP TABLE permanently removes a table all its rows and structure. This cannot be undone." },
	{ "type": "sql_fill", "gamemode": "drop_table",
	  "desc": "Remove the seasonal_menu table permanently. Fill in the keyword after DROP.",
	  "table": "seasonal_menu",
	  "answer": "TABLE",
	  "hint": "After DROP, the keyword to remove a table: TABLE",
	  "result_msg": "seasonal_menu dropped! Gone forever. Always back up before using DROP TABLE.",
	  "fail": [
		{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/shock", "text": "Wrong keyword. The full command is: DROP TABLE table_name" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle", "text": "Type TABLE after DROP." }
	  ]
	},
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Table gone! DROP TABLE is the most destructive command use it only when you are absolutely sure." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Use DROP TABLE IF EXISTS seasonal_menu to avoid errors if the table was already removed." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C28 | LEFT JOIN  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C28": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The owner wants to see all registered customers including those who have not ordered yet." },
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "A regular JOIN only shows customers with orders. I need ALL customers new ones with no orders should appear too." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "LEFT JOIN returns all rows from the left table and matching rows from the right. No match means NULL." },
	{ "type": "sql_fill", "gamemode": "join",
	  "join_type": "LEFT JOIN",
	  "desc": "LEFT JOIN customers with orders. All customers appear even without an order. Fill in the linking column names.",
	  "table_a": "customers", "table_b": "orders",
	  "table_a_headers": ["id","name","email"],
	  "table_a_rows": [["1","Ana","ana@mail.com"],["2","Ben","ben@mail.com"],["3","Cara","cara@mail.com"],["4","Dan","dan@mail.com"]],
	  "table_b_headers": ["id","customer_id","item"],
	  "table_b_rows": [["1","1","Latte"],["2","3","Espresso"]],
	  "join_col_a": "id", "join_col_b": "customer_id",
	  "hint": "customers linking column: id orders linking column: customer_id",
	  "result_headers": ["name","email","item"],
	  "result_rows": [["Ana","ana@mail.com","Latte"],["Ben","ben@mail.com","NULL"],["Cara","cara@mail.com","Espresso"],["Dan","dan@mail.com","NULL"]],
	  "result_msg": "All 4 customers shown. Ben and Dan have no orders their item shows NULL. INNER JOIN would hide them.",
	  "fail": [
		{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/shock", "text": "Wrong linking columns! customers.id connects to orders.customer_id." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle", "text": "Left: id Right: customer_id" }
	  ]
	},
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "All 4 customers visible! Ben and Dan are registered but have not ordered yet. Great for follow-up marketing." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "LEFT JOIN keeps every left-table row. INNER JOIN would only show Ana and Cara who have orders." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C29 | DEFAULT  |  NPC: adult_14 customer
# ─────────────────────────────────────────────
"C29": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "adult_14/idle",
	  "text": "A customer notices that new orders always show 'Preparing' without the staff typing it each time." },
	{ "type": "dialogue", "char": "customer", "name": "CUSTOMER", "npc": "adult_14/talk",
	  "text": "Every new order shows 'Preparing' automatically. Does the system type that by itself?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_14/idle",
	  "text": "Yes! The DEFAULT constraint sets an automatic value when no value is provided on INSERT." },
	{ "type": "sql_fill", "gamemode": "create_table",
	  "desc": "Set status to automatically be 'Preparing' when not provided. Type: DEFAULT 'Preparing'",
	  "table": "orders",
	  "pk_col": "status",
	  "columns": [["id","INT PRIMARY KEY"],["customer","TEXT"],["item","TEXT"],["status","TEXT"]],
	  "answer": "DEFAULT 'Preparing'",
	  "blank_hint": "constraint",
	  "error_hint": "The syntax for a default value is: DEFAULT 'value'",
	  "result_msg": "DEFAULT 'Preparing' set! New orders will automatically have status = 'Preparing'.",
	  "hint": "Auto-fill status: DEFAULT 'Preparing'",
	  "fail": [
		{ "type": "dialogue", "char": "customer", "name": "CUSTOMER", "npc": "adult_14/confuse", "text": "That is not right. DEFAULT sets the automatic value like DEFAULT 'Preparing'." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_14/idle", "text": "Type: DEFAULT 'Preparing'" }
	  ]
	},
	{ "type": "dialogue", "char": "customer", "name": "CUSTOMER", "npc": "adult_14/talk",
	  "text": "So DEFAULT is the fallback only used when the INSERT skips that column?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_14/idle",
	  "text": "Exactly. Once served, staff updates it to 'Ready'. DEFAULT just sets the starting value." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C30 | Normalization  |  NPC: adult_14 customer
# ─────────────────────────────────────────────
"C30": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "adult_14/idle",
	  "text": "A customer who studies IT asks about an old orders spreadsheet they saw that repeated customer details everywhere." },
	{ "type": "dialogue", "char": "customer", "name": "CUSTOMER", "npc": "adult_14/talk",
	  "text": "The old system stored the customer's full address in every single order row. If someone moves, you need to update hundreds of rows!" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_14/idle",
	  "text": "That is called data redundancy the main problem normalization solves. Let me ask you about it." },
	{ "type": "sql_choice",
	  "desc": "An orders table stores customer_name, customer_address, and item in EVERY order row. What is the main problem?",
	  "options": [
		[1, "Data redundancy customer address repeats in every order, causing update anomalies and wasted storage."],
		[2, "The table needs more columns to store more data about each order."],
		[3, "The SELECT query needs a LIMIT clause to avoid returning too many rows."]
	  ],
	  "correct_id": 1,
	  "hint": "Repeating data in multiple rows is called redundancy. Answer: id = 1",
	  "fail": [
		{ "type": "dialogue", "char": "customer", "name": "CUSTOMER", "npc": "adult_14/confuse", "text": "Not quite. The problem is repeating the same data over and over redundancy." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_14/idle", "text": "Answer 1 data redundancy is the issue." }
	  ]
	},
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_14/idle",
	  "text": "Normalization splits the data: customer info goes in a customers table, orders just store customer_id." },
	{ "type": "dialogue", "char": "customer", "name": "CUSTOMER", "npc": "adult_14/talk",
	  "text": "One update to the customers table fixes the address for ALL their orders at once. So much better!" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_14/idle",
	  "text": "That is 3NF third normal form. Each piece of data lives in exactly one place." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C31 | Transactions  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C31": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "A system glitch transferred loyalty points from one customer but crashed before giving them to the other." },
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Ana lost 100 points but Ben never received them! The transfer was only half done. How do we prevent this?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Transactions group statements together. BEGIN starts the block. COMMIT saves all, ROLLBACK cancels all." },
	{ "type": "sql_fill", "gamemode": "transaction",
	  "desc": "The loyalty point transfer is complete. COMMIT to save both changes permanently.",
	  "update_line": "UPDATE customers SET points = points - 100 WHERE name = 'Ana'",
	  "answer": "COMMIT",
	  "hint": "To permanently save the transaction: COMMIT",
	  "result_msg": "Transaction committed! Both deduct and credit saved atomically.\n\nACID properties ensure:\n- Atomicity: both operations succeed or neither does\n- Durability: committed data survives system crashes",
	  "fail": [
		{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/shock", "text": "Wrong! Type COMMIT to save or ROLLBACK to cancel." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle", "text": "Type COMMIT to finalize the transaction." }
	  ]
	},
	{ "type": "dialogue", "char": "cafe_owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Both changes saved! If the system crashed before COMMIT, ROLLBACK would undo everything automatically." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "That is atomicity the A in ACID. Transactions are all-or-nothing." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C32 | FOREIGN KEY  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C32": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The café has separate tables for customers and orders. The owner wants to ensure every order belongs to a real customer." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "A FOREIGN KEY enforces that a column in one table must match a PRIMARY KEY in another. No orphan orders allowed." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "So if a customer is deleted, any orders linked to them would be blocked unless we handle that too?" },
	{ "type": "dialogue", "char": "owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Correct referential integrity at work. The keyword that points to the other table is REFERENCES." },
	{ "type": "sql_fill", "gamemode": "foreign_key",
	  "desc": "Complete the FOREIGN KEY constraint to link orders.customer_id to the customers table.",
	  "table": "orders", "fk_col": "customer_id", "ref_table": "customers",
	  "answer": "REFERENCES",
	  "hint": "The keyword that points to another table is REFERENCES.",
	  "result_msg": "FOREIGN KEY created! Every customer_id in orders must now exist in the customers table.",
	  "fail": [
		{ "type": "dialogue", "char": "owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
		  "text": "Not quite. After FOREIGN KEY (customer_id), type REFERENCES followed by the table and column." }
	  ]
	},
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C33 | Indexes  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C33": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The menu table has grown large and searches by item name are slowing down during the morning rush." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "An INDEX speeds up queries by building a lookup structure like tabs in a recipe binder. No change to the data, just faster searching." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Can I add an index to any column?" },
	{ "type": "dialogue", "char": "owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Yes focus on columns you search or filter often. Create an index on item_name now." },
	{ "type": "sql_fill", "gamemode": "create_index",
	  "desc": "Create an index on the menu table to speed up searches by item_name.",
	  "index_name": "idx_item_name", "table": "menu", "column": "item_name",
	  "answer": "INDEX",
	  "hint": "The keyword after CREATE is INDEX.",
	  "result_msg": "Index created! Searches on item_name will now run significantly faster.",
	  "fail": [
		{ "type": "dialogue", "char": "owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
		  "text": "Not quite. The syntax is CREATE INDEX name ON table(column)." }
	  ]
	},
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C34 | Views  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C34": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Every shift the staff prints a list of today's pending orders. They run the same SELECT query each time." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "A VIEW saves that query under a name. Staff can just SELECT from the view it always returns the freshest data." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "So a view is like a named window into the current data?" },
	{ "type": "dialogue", "char": "owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Exactly. CREATE VIEW name AS SELECT ... create the pending orders view now." },
	{ "type": "sql_fill", "gamemode": "create_view",
	  "desc": "Create a view called vw_pending_orders that shows all orders with status 'Pending'.",
	  "view_name": "vw_pending_orders", "select_cols": "*", "table": "orders", "condition": "status = 'Pending'",
	  "answer": "VIEW",
	  "hint": "The keyword after CREATE is VIEW.",
	  "result_msg": "View created! SELECT * FROM vw_pending_orders now always shows live pending orders.",
	  "fail": [
		{ "type": "dialogue", "char": "owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/talk",
		  "text": "Not quite. The syntax is CREATE VIEW name AS SELECT ... The keyword after CREATE is VIEW." }
	  ]
	},
	{ "type": "end" }
],


# ─────────────────────────────────────────────
#  LESSON C35 | SUBQUERY  |  NPC: coffee_owner
# ─────────────────────────────────────────────
# ─────────────────────────────────────────────
#  LESSON C36 | CASE WHEN  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C36": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The owner is setting up a new display board. She wants each order size labelled automatically based on its price." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Orders above 150 are Large, 80 to 150 are Medium, below 80 are Small. Can we add a size label in the SELECT without a new column?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Yes CASE WHEN creates a derived column on the fly. It checks each row's price and returns the matching label." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "CASE WHEN price > 150 THEN 'Large' like that? And ELSE catches everything else?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Exactly. CASE WHEN ... THEN ... WHEN ... THEN ... ELSE ... END AS size_label evaluated row by row." },
	{ "type": "sql_fill", "gamemode": "select_alias",
	  "desc": "The CASE WHEN expression labels each order by size. Type the alias that names this derived column.",
	  "hint": "Type 'size_label' the alias after AS that names the computed column.",
	  "table": "orders",
	  "col_expr": "CASE WHEN price > 150 THEN 'Large' WHEN price >= 80 THEN 'Medium' ELSE 'Small' END",
	  "answer": "size_label",
	  "table_headers": ["item", "price"],
	  "table_rows": [["Latte","160"],["Cappuccino","90"],["Espresso","60"]],
	  "result_headers": ["item", "size_label"],
	  "result_rows": [["Latte","Large"],["Cappuccino","Medium"],["Espresso","Small"]],
	  "result_msg": "Each order gets its size label CASE WHEN runs once per row without changing the orders table." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "So each order row gets evaluated independently and gets its own label. No changes to the table needed." },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "CASE WHEN also works inside ORDER BY and UPDATE SET anywhere SQL expects a value expression." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C37 | DATE FUNCTIONS  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C37": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "A health inspector is visiting tomorrow. The owner needs to pull all orders placed today for the records." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "The order_date column stores dates like '2025-06-16'. How do I filter only today's orders in SQL?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "In SQLite we use DATE('now') which returns today's date. WHERE order_date = DATE('now') matches only today's rows." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "And if I wanted orders from this week? Or older than 30 days?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "DATE('now', '-7 days') gives seven days ago. Use BETWEEN or < / > for ranges. The database handles the arithmetic." },
	{ "type": "sql_fill", "gamemode": "where_between",
	  "desc": "Date strings in 'YYYY-MM-DD' format sort correctly with SQL range operators. Fill in the keyword to find orders within a date range.",
	  "hint": "BETWEEN checks if a value falls between two bounds: column BETWEEN low AND high. Works on date strings too.",
	  "table": "orders", "column": "order_date",
	  "low": "'2025-01-01'", "high": "'2025-06-30'", "answer": "BETWEEN",
	  "table_headers": ["id", "customer", "order_date"],
	  "table_rows": [["1","Alice","2025-03-10"],["2","Bob","2025-09-05"],["3","Carol","2025-05-18"]],
	  "result_headers": ["id", "customer", "order_date"],
	  "result_rows": [["1","Alice","2025-03-10"],["3","Carol","2025-05-18"]],
	  "result_msg": "BETWEEN filters to the date range. Use DATE('now') as the upper bound: WHERE order_date BETWEEN '2025-01-01' AND DATE('now') finds all past orders." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "MySQL calls it CURDATE(), PostgreSQL uses CURRENT_DATE same idea, just different syntax per database engine." },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "strftime('%m', order_date) extracts just the month number if you want to group orders by month of the year." },
	{ "type": "end" }
],

"C35": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "End of the week. The owner pulls you aside with a specific question about the menu data." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "I want to find the customer who placed the order with the single most expensive item. Not just sort by price I want the exact match." },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "That needs a subquery a SELECT inside another SELECT. The inner query finds the MAX price, then the outer query finds the order that matches it." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "So the inner part runs first and feeds its result into the outer WHERE condition?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Exactly. WHERE price = (SELECT MAX(price) FROM orders) the database evaluates the inner SELECT first." },
	{ "type": "sql_fill", "gamemode": "aggregate",
	  "desc": "This inner query finds the highest order price. Fill in the aggregate function.",
	  "hint": "MAX() returns the largest value. The outer query uses this result: WHERE price = (SELECT MAX(price) FROM orders).",
	  "table": "orders", "column": "price", "answer": "MAX",
	  "table_headers": ["id", "customer", "price"],
	  "table_rows": [["1","Alice","180"],["2","Bob","95"],["3","Carol","180"]],
	  "result_headers": ["MAX(price)"], "result_rows": [["180"]],
	  "result_msg": "MAX(price) = 180. Full subquery: WHERE price = (SELECT MAX(price) FROM orders) returns every order that matches the maximum." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "So the inner SELECT MAX(price) runs first, returns the value, then the outer WHERE filters by it. Powerful!" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Subqueries can also appear in SELECT columns or FROM clauses. They are queries inside queries any depth you need." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C38 | GRANT / REVOKE (DCL)  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C38": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "A new barista joins the team. The owner wants them to view orders but never delete sales records." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "The barista should read the orders table only. How do I control who can do what in the database?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "That is DCL Data Control Language. GRANT gives a user a permission; REVOKE removes it. We grant read-only SELECT." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "So GRANT SELECT lets them look, and REVOKE pulls it back if needed?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Exactly. Permissions are the database's security layer each user gets only what their role requires." },
	{ "type": "sql_fill", "gamemode": "sql_blank", "recap": "GRANT / REVOKE",
	  "desc": "Give the barista permission to read the orders table. Fill in the DCL keyword that grants access.",
	  "hint": "GRANT gives a privilege. REVOKE removes it. We are giving access here.",
	  "prefix": "", "answer": "GRANT", "placeholder": "keyword", "max_length": 8,
	  "suffix": "SELECT ON orders TO barista;",
	  "err_hint": "To give a permission, the keyword is GRANT.",
	  "result_msg": "Permission granted. The barista can now read orders. To remove it later: REVOKE SELECT ON orders FROM barista;" },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "The barista just resigned. Now take that permission back what is the opposite of GRANT?" },
	{ "type": "sql_fill", "gamemode": "sql_blank", "recap": "GRANT / REVOKE",
	  "desc": "The barista left. Remove their read access to the orders table. Fill in the DCL keyword.",
	  "hint": "GRANT gives a permission; the keyword that takes it away is REVOKE.",
	  "prefix": "", "answer": "REVOKE", "placeholder": "keyword", "max_length": 8,
	  "suffix": "SELECT ON orders FROM barista;",
	  "err_hint": "To remove a permission, the keyword is REVOKE.",
	  "result_msg": "Permission revoked. The barista can no longer read orders. GRANT gives access, REVOKE takes it back." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "DDL builds the tables, DML changes the data, DCL controls who may touch it. The whole picture finally fits." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C39 | UNION  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C39": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The owner is building a city mailing list and wants every city from both customers and suppliers in one go." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Customer cities are in one table, supplier cities in another. Can I get one combined list of all cities at once?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Yes UNION stacks the results of two SELECTs into a single list and removes duplicate cities automatically." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "And if I wanted to keep duplicates?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Then UNION ALL. Both queries must return the same number of columns in the same order." },
	{ "type": "sql_fill", "gamemode": "sql_blank", "recap": "UNION / UNION ALL",
	  "desc": "Combine customer cities and supplier cities into one list. Fill in the set operator.",
	  "hint": "UNION merges two SELECT results and drops duplicates. UNION ALL keeps them.",
	  "prefix": "SELECT city FROM customers\n", "answer": "UNION", "placeholder": "operator", "max_length": 9,
	  "suffix": "SELECT city FROM suppliers;",
	  "err_hint": "The operator that merges two result sets is UNION.",
	  "result_headers": ["city"], "result_rows": [["Manila"],["Cebu"],["Baguio"]],
	  "result_msg": "UNION merged both lists and removed duplicates. Use UNION ALL to keep duplicate cities." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "Actually, to measure overlap I want to keep the duplicate cities this time. How do I change UNION to keep them?" },
	{ "type": "sql_fill", "gamemode": "sql_blank", "recap": "UNION / UNION ALL",
	  "desc": "Combine both city lists but keep duplicate cities. Fill in the keyword after UNION.",
	  "hint": "UNION removes duplicates; adding ALL keeps every row.",
	  "prefix": "SELECT city FROM customers\nUNION ", "answer": "ALL", "placeholder": "keyword", "max_length": 5,
	  "suffix": "SELECT city FROM suppliers;",
	  "err_hint": "To keep duplicates, the keyword after UNION is ALL.",
	  "result_headers": ["city"], "result_rows": [["Manila"],["Cebu"],["Manila"],["Baguio"]],
	  "result_msg": "UNION ALL kept every row, including the duplicate Manila. Plain UNION would have removed the repeat." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "One clean list from two tables. UNION removes repeats, UNION ALL keeps them. Exactly what I needed." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C40 | CHECK constraint  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C40": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "A typo once saved a drink price of -50. The owner wants the database to reject impossible prices on its own." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Can the menu table refuse any price below zero without us checking it manually every time?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Yes a CHECK constraint. It attaches a rule to a column, and the database rejects any row that breaks it." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "So CHECK (price >= 0) means an INSERT with -50 just fails?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Exactly. NOT NULL, UNIQUE, DEFAULT, and CHECK are all constraints built-in guards that protect data quality." },
	{ "type": "sql_fill", "gamemode": "sql_blank", "recap": "CHECK",
	  "desc": "Add a rule so the price column only accepts values of 0 or more. Fill in the constraint keyword.",
	  "hint": "The constraint that validates a value against a condition is CHECK.",
	  "prefix": "CREATE TABLE menu (\n  price REAL ", "answer": "CHECK", "placeholder": "constraint", "max_length": 6,
	  "suffix": "(price >= 0)\n);",
	  "err_hint": "The constraint that enforces a condition is CHECK.",
	  "result_msg": "CHECK constraint added. Any INSERT with a negative price is now rejected by the database itself." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Now bad prices are blocked at the door. CHECK keeps the menu honest no matter who is typing." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C41 | ER Diagram (theory)  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C41": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Before building tables, the owner sketches the café's data on paper and asks you to read the diagram." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "This is an ER Diagram Entity-Relationship model. Boxes are entities, ovals are attributes, lines are relationships. What does it tell us?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Each box becomes a table, each oval a column, and the line between CUSTOMER and ORDER shows how they connect its cardinality." },
	{ "type": "sql_choice",
	  "desc": "One CUSTOMER can place many ORDERs, but each ORDER belongs to exactly one CUSTOMER. What cardinality does this relationship have?",
	  "options": [
		[1, "One-to-Many (1:M) one customer, many orders; implemented with a customer_id foreign key in orders."],
		[2, "Many-to-Many (M:N) needs a junction table between customer and order."],
		[3, "One-to-One (1:1) each customer can place only a single order ever."]
	  ],
	  "correct_id": 1,
	  "hint": "One on one side, many on the other = 1:M. Answer: id = 1",
	  "fail": [
		{ "type": "dialogue", "char": "owner", "name": "OWNER", "npc": "NPC_occupations/coffee_owner/shock",
		  "text": "M:N would need a junction table; 1:1 would limit a customer to one order. Neither fits 'one customer, many orders'." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/coffee_owner/idle",
		  "text": "One customer to many orders is One-to-Many (1:M). Answer: id = 1" }
	  ] },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "A 1:M relationship is built with a FOREIGN KEY on the 'many' side orders.customer_id points to customers.id." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "So the ER Diagram is the blueprint design relationships on paper first, then turn entities into tables and lines into foreign keys." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C42 | TRUNCATE  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C42": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The order log table is full of old test rows. The owner wants it completely emptied but kept for new data." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "I want every row gone, but I still need the table. What is the fastest way to wipe it clean?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "TRUNCATE TABLE removes all rows at once and keeps the structure. It is faster than DELETE and needs no WHERE." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "How is it different from DELETE and DROP?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "DELETE removes rows one by one (and can use WHERE). TRUNCATE empties the whole table fast. DROP deletes the table entirely." },
	{ "type": "sql_fill", "gamemode": "sql_blank", "recap": "TRUNCATE",
	  "desc": "Empty the entire order_logs table but keep its structure. Fill in the keyword.",
	  "hint": "DELETE = row by row. DROP = remove the table. The fast 'empty everything' keyword is TRUNCATE.",
	  "prefix": "", "answer": "TRUNCATE", "placeholder": "keyword", "max_length": 10,
	  "suffix": "TABLE order_logs;",
	  "err_hint": "To empty a whole table fast, the keyword is TRUNCATE.",
	  "result_msg": "All rows removed. The empty order_logs table is ready for new data its columns and structure stayed intact." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "DELETE for some rows, TRUNCATE to empty it, DROP to destroy it. Now I will never mix them up." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C43 | String Functions  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C43": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "The menu items were typed in mixed casing. The owner wants a clean board with every item in capitals." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Some items are 'latte', some 'LATTE', some 'Latte'. Can SQL force them all to uppercase in the result?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Yes string functions. UPPER() capitalizes text, LOWER() makes it lowercase, LENGTH() counts characters, SUBSTR() extracts part of it." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "So UPPER(item) gives me every item in capitals without changing the stored data?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Exactly. The function transforms the value only in the output the table itself stays untouched." },
	{ "type": "sql_fill", "gamemode": "aggregate", "recap": "String Functions",
	  "desc": "Show every menu item in capital letters. Fill in the string function.",
	  "hint": "UPPER() converts text to capitals. LOWER() does the opposite.",
	  "table": "orders", "column": "item", "answer": "UPPER",
	  "table_headers": ["id", "item"],
	  "table_rows": [["1","latte"],["2","Mocha"],["3","ESPRESSO"]],
	  "result_headers": ["UPPER(item)"], "result_rows": [["LATTE"],["MOCHA"],["ESPRESSO"]],
	  "result_msg": "UPPER(item) returned every item in capitals. Try LOWER(), LENGTH(item), or SUBSTR(item, 1, 3) for other transforms." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "Good. Now the receipt printer needs the items in lowercase instead. Same idea, opposite function?" },
	{ "type": "sql_fill", "gamemode": "aggregate", "recap": "String Functions",
	  "desc": "Now show every menu item in lowercase. Fill in the string function.",
	  "hint": "LOWER() converts text to lowercase the opposite of UPPER().",
	  "table": "orders", "column": "item", "answer": "LOWER",
	  "table_headers": ["id", "item"],
	  "table_rows": [["1","LATTE"],["2","Mocha"],["3","espresso"]],
	  "result_headers": ["LOWER(item)"], "result_rows": [["latte"],["mocha"],["espresso"]],
	  "result_msg": "LOWER(item) returned every item in lowercase. UPPER capitalizes, LENGTH counts characters, SUBSTR extracts part of the text." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Clean, consistent item names in one query. String functions tidy up messy text without editing the table." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON C44 | COALESCE / IFNULL  |  NPC: coffee_owner
# ─────────────────────────────────────────────
"C44": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Many orders have no special notes, so the report shows blank cells. The owner wants a friendlier placeholder." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "Where the note is missing, can the report show 'No notes' instead of an empty NULL cell?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "Yes COALESCE returns the first value that is not NULL. COALESCE(notes, 'No notes') uses the note if present, otherwise the fallback." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "I have seen IFNULL too is it the same thing?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/coffee_owner/idle",
	  "text": "IFNULL does the same with two values. COALESCE is the standard one and can take many values, returning the first non-NULL." },
	{ "type": "sql_fill", "gamemode": "sql_blank", "recap": "COALESCE / IFNULL",
	  "desc": "Replace any missing note with 'No notes'. Fill in the NULL-handling function.",
	  "hint": "It returns the first non-NULL value. COALESCE(notes, 'No notes').",
	  "prefix": "SELECT item,\n  ", "answer": "COALESCE", "placeholder": "function", "max_length": 10,
	  "suffix": "(notes, 'No notes') FROM orders;",
	  "err_hint": "The function that returns the first non-NULL value is COALESCE.",
	  "table": "orders",
	  "table_headers": ["item", "notes"],
	  "table_rows": [["Latte","Extra hot"],["Mocha","NULL"],["Tea","NULL"]],
	  "result_headers": ["item", "note"],
	  "result_rows": [["Latte","Extra hot"],["Mocha","No notes"],["Tea","No notes"]],
	  "result_msg": "COALESCE filled the blank notes with 'No notes'. IFNULL(notes, 'No notes') would do the same for two values." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/think",
	  "text": "Some older reports use IFNULL instead. Show me the same fix on the coupon column with that two-argument version." },
	{ "type": "sql_fill", "gamemode": "sql_blank", "recap": "COALESCE / IFNULL",
	  "desc": "Replace a missing coupon code with 'None' using the two-argument function. Fill in the function.",
	  "hint": "IFNULL(value, fallback) replaces NULL with the fallback the simpler two-argument form.",
	  "prefix": "SELECT item,\n  ", "answer": "IFNULL", "placeholder": "function", "max_length": 10,
	  "suffix": "(coupon, 'None') FROM orders;",
	  "err_hint": "The two-argument NULL replacement function is IFNULL.",
	  "table": "orders",
	  "table_headers": ["item", "coupon"],
	  "table_rows": [["Latte","SAVE10"],["Mocha","NULL"],["Tea","NULL"]],
	  "result_headers": ["item", "coupon"],
	  "result_rows": [["Latte","SAVE10"],["Mocha","None"],["Tea","None"]],
	  "result_msg": "IFNULL replaced the missing coupons with 'None'. COALESCE does the same and also accepts more than two values." },
	{ "type": "dialogue", "char": "owner", "name": "OWNER",
	  "npc": "NPC_occupations/coffee_owner/talk",
	  "text": "No more empty cells every row reads clearly. COALESCE turns missing data into something readable." },
	{ "type": "end" }
],

} # end LESSONS
