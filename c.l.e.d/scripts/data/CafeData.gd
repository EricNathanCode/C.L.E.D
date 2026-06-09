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
]

} # end LESSONS
