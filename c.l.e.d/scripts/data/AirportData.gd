extends Node
# ═══════════════════════════════════════════════════════
#  AIRPORT DATA  |  scripts/data/AirportData.gd
#
#  NPC assignments (Airport World | unique to this world):
#    adult_2  = Passenger asking about available seats (A1)
#    adult_4  = Elena Cruz, first-time check-in (A2)
#    adult_11 = Mr. Bautista, lost boarding pass (A3)
#    adult_15 = Mrs. Fernandez, misspelled name (A4)
#    adult_18 = Mr. Tan, cancelling his flight (A5)
#    NPC_occupations/pilot = Captain (boss) — stops by the
#      check-in counter before departure to review the
#      passenger manifest with the ground staff (the player).
#
#  Curriculum trimmed to query-only lessons (Basic SQL,
#  Filtering Rows, Sorting & Aggregates) per panel feedback,
#  same scope as every other world.
#
#  Rule: "you" and "scene" always idle | NPC looks at you.
# ═══════════════════════════════════════════════════════

const LESSONS: Dictionary = {

# ─────────────────────────────────────────────
#  LESSON A1 | SELECT (sql_choice)
#  Topic: Responding professionally to a passenger
# ─────────────────────────────────────────────
"A1": [
	{ "type": "dialogue", "char": "scene",     "name": "SCENE",
	  "npc": "adult_2/idle",
	  "text": "The morning rush at the check-in counter. A passenger steps up, glancing at the departure board." },
	{ "type": "dialogue", "char": "passenger", "name": "PASSENGER",
	  "npc": "adult_2/talk",
	  "text": "Hi! Do you happen to have any window seats left on this flight?" },
	{ "type": "dialogue", "char": "you",       "name": "YOU",
	  "npc": "adult_2/idle",
	  "text": "Let me check the seat map before responding..." },
	{ "type": "sql_choice",
	  "desc": "Three responses are in the table below. Type the id of the most professional and helpful answer.",
	  "options": [
	  	[1, "Yes! We have a few window seats left. Would you like me to assign one for you?"],
	  	[2, "I don't know, ask at the gate."],
	  	[3, "Just take whatever seat you're given."]
	  ],
	  "correct_id": 1,
	  "hint": "A good check-in agent checks the system and offers options. Answer: id = 1",
	  "fail": [
		{ "type": "dialogue", "char": "passenger", "name": "PASSENGER", "npc": "adult_2/shock", "text": "Excuse me?! That is NOT a helpful response!" },
		{ "type": "dialogue", "char": "scene",     "name": "SCENE",     "npc": "adult_2/idle",  "text": "The passenger frowns and glances toward the supervisor's desk." },
		{ "type": "dialogue", "char": "you",       "name": "YOU",       "npc": "adult_2/idle",  "text": "That did not go well. Let me choose the correct response this time." }
	  ] },
	{ "type": "dialogue", "char": "you",       "name": "YOU",
	  "npc": "adult_2/idle",
	  "text": "Yes! We have a few window seats left. Would you like me to assign one for you?" },
	{ "type": "dialogue", "char": "passenger", "name": "PASSENGER",
	  "npc": "adult_2/talk",
	  "text": "That would be perfect! You're so helpful, thank you!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A2 | INSERT INTO
#  Topic: Checking in a new passenger
# ─────────────────────────────────────────────
"A2": [
	{ "type": "dialogue", "char": "scene",     "name": "SCENE",
	  "npc": "adult_4/idle",
	  "text": "A young woman rolls her suitcase up to the counter, checking her phone for her flight time." },
	{ "type": "dialogue", "char": "passenger", "name": "ELENA",
	  "npc": "adult_4/confuse",
	  "text": "Hi, this is my first time flying alone. I need to check in, I think?" },
	{ "type": "dialogue", "char": "you",       "name": "YOU",
	  "npc": "adult_4/idle",
	  "text": "You're in the right place! May I have your full name?" },
	{ "type": "dialogue", "char": "passenger", "name": "ELENA",
	  "npc": "adult_4/talk",
	  "text": "Elena Cruz. Economy class, if that helps." },
	{ "type": "dialogue", "char": "you",       "name": "YOU",
	  "npc": "adult_4/idle",
	  "text": "Perfect! Let me register that in our system right now." },
	{ "type": "sql_fill",
	  "gamemode": "insert_into",
	  "desc": "Check in Elena Cruz. Fill in her first_name, last_name, and seat_class.",
	  "table": "passengers",
	  "columns": ["first_name", "last_name", "seat_class"],
	  "table_headers": ["id", "first_name", "last_name", "seat_class"],
	  "table_rows": [],
	  "answers": ["Elena", "Cruz", "Economy"],
	  "hint": "First: Elena Last: Cruz Class: Economy",
	  "fail": [
		{ "type": "dialogue", "char": "passenger", "name": "ELENA",  "npc": "adult_4/confuse", "text": "That doesn't look right at all. Did you type my name correctly?" },
		{ "type": "dialogue", "char": "scene",     "name": "SCENE",  "npc": "adult_4/idle",    "text": "Elena looks uneasy. The line behind her is starting to grow." },
		{ "type": "dialogue", "char": "you",       "name": "YOU",    "npc": "adult_4/idle",    "text": "I am so sorry! Let me re-enter that correctly." }
	  ],
	  "result_headers": ["id", "first_name", "last_name", "seat_class"],
	  "result_rows": [["1", "Elena", "Cruz", "Economy"]],
	  "result_msg": "1 record inserted into passengers." },
	{ "type": "dialogue", "char": "you",       "name": "YOU",
	  "npc": "adult_4/idle",
	  "text": "You're all checked in, Ms. Cruz! Gate 14, boarding in an hour. Have a safe flight!" },
	{ "type": "dialogue", "char": "passenger", "name": "ELENA",
	  "npc": "adult_4/talk",
	  "text": "That was so easy, thank you! I feel much better now." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A3 | SELECT WHERE
#  Topic: Finding a passenger who lost their boarding pass
# ─────────────────────────────────────────────
"A3": [
	{ "type": "dialogue", "char": "scene",     "name": "SCENE",
	  "npc": "adult_11/idle",
	  "text": "A nervous man pats down his jacket pockets, clearly searching for something he can't find." },
	{ "type": "dialogue", "char": "passenger", "name": "MR. BAUTISTA",
	  "npc": "adult_11/confuse",
	  "text": "I... I think I lost my boarding pass. I checked in online, I swear!" },
	{ "type": "dialogue", "char": "passenger", "name": "MR. BAUTISTA",
	  "npc": "adult_11/shock",
	  "text": "What if I miss my flight?? I have a meeting I cannot miss!!" },
	{ "type": "dialogue", "char": "you",       "name": "YOU",
	  "npc": "adult_11/idle",
	  "text": "Hey, no worries, I can look you up in the system. What's your last name?" },
	{ "type": "dialogue", "char": "passenger", "name": "MR. BAUTISTA",
	  "npc": "adult_11/talk",
	  "text": "Bautista. B-A-U-T-I-S-T-A." },
	{ "type": "sql_fill",
	  "gamemode": "select_where",
	  "desc": "Search the passengers table for Mr. Bautista's last name. Fill in the WHERE clause.",
	  "table": "passengers",
	  "column": "last_name",
	  "table_headers": ["id", "first_name", "last_name", "seat_no"],
	  "table_rows": [
	  	["1", "Elena",  "Cruz",      "14A"],
	  	["2", "Marco",  "Bautista",  "22C"],
	  	["3", "Jose",   "Hernandez", "9B"],
	  	["4", "Carla",  "Garcia",    "17D"],
	  	["5", "Linda",  "Lim",       "3A"],
	  	["6", "Miguel", "Reyes",     "11C"],
	  	["7", "Sofia",  "Torres",    "20B"],
	  	["8", "Ana",    "Villanueva","5D"]
	  ],
	  "answer": "Bautista",
	  "hint": "Type his last name exactly: Bautista",
	  "fail": [
		{ "type": "dialogue", "char": "passenger", "name": "MR. BAUTISTA", "npc": "adult_11/shock", "text": "That is not my name! What if my seat is given away?!" },
		{ "type": "dialogue", "char": "scene",      "name": "SCENE",       "npc": "adult_11/idle",  "text": "Mr. Bautista starts checking his watch. Boarding closes soon." },
		{ "type": "dialogue", "char": "you",        "name": "YOU",         "npc": "adult_11/idle",  "text": "My apologies! I typed the wrong name. Let me search again." }
	  ],
	  "result_headers": ["id", "first_name", "last_name", "seat_no"],
	  "result_rows": [["2", "Marco", "Bautista", "22C"]],
	  "result_msg": "1 record found." },
	{ "type": "dialogue", "char": "you",       "name": "YOU",
	  "npc": "adult_11/idle",
	  "text": "Found you! Seat 22C, already checked in. I'll print you a new boarding pass." },
	{ "type": "dialogue", "char": "passenger", "name": "MR. BAUTISTA",
	  "npc": "adult_11/talk",
	  "text": "Oh THANK GOODNESS! You're a lifesaver, thank you so much!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A4 | UPDATE SET
#  Topic: Fixing a misspelled name on a ticket
# ─────────────────────────────────────────────
"A4": [
	{ "type": "dialogue", "char": "scene",     "name": "SCENE",
	  "npc": "adult_15/idle",
	  "text": "A woman marches up to the counter, ticket held out, clearly unhappy." },
	{ "type": "dialogue", "char": "passenger", "name": "MRS. FERNANDEZ",
	  "npc": "adult_15/shock",
	  "text": "EXCUSE ME. My name is spelled WRONG on this ticket and I am NOT happy about it!!" },
	{ "type": "sql_choice",
	  "desc": "An upset passenger is in front of you. Choose the most professional response.",
	  "options": [
	  	[1, "Please calm down, ma'am, you're disturbing other passengers."],
	  	[2, "I'm very sorry to hear that. I'll fix it right away."],
	  	[3, "Not my problem, take it up with the airline."]
	  ],
	  "correct_id": 2,
	  "hint": "De-escalate calmly and offer to help. Answer: id = 2",
	  "fail": [
		{ "type": "dialogue", "char": "passenger", "name": "MRS. FERNANDEZ", "npc": "adult_15/shock", "text": "ARE YOU SERIOUS?! I want your supervisor THIS INSTANT!!" },
		{ "type": "dialogue", "char": "scene",      "name": "SCENE",         "npc": "adult_15/idle",  "text": "The whole terminal goes quiet. Heads turn toward the counter." },
		{ "type": "dialogue", "char": "you",        "name": "YOU",           "npc": "adult_15/idle",  "text": "I need to handle this better. Let me choose the right response." }
	  ] },
	{ "type": "dialogue", "char": "you",       "name": "YOU",
	  "npc": "adult_15/idle",
	  "text": "I'm very sorry to hear that. I'll fix it right away. May I have your booking id?" },
	{ "type": "dialogue", "char": "passenger", "name": "MRS. FERNANDEZ",
	  "npc": "adult_15/shock",
	  "text": "The name is Fernandez! F-E-R-N-A-N-D-E-Z!! You have it as Fernandes NO Z!! Booking id is 3." },
	{ "type": "sql_fill",
	  "gamemode": "update_set",
	  "desc": "Fix the last_name from Fernandes to Fernandez for record id = 3.",
	  "table": "passengers",
	  "column": "last_name",
	  "table_headers": ["id", "first_name", "last_name", "seat_no"],
	  "table_rows": [
	  	["1", "Elena",  "Cruz",       "14A"],
	  	["2", "Marco",  "Bautista",   "22C"],
	  	["3", "Rosa",   "Fernandes",  "9B"],
	  	["4", "Carla",  "Garcia",     "17D"],
	  	["5", "Linda",  "Lim",        "3A"],
	  	["6", "Miguel", "Reyes",      "11C"]
	  ],
	  "answer_value": "Fernandez",
	  "answer_id": "3",
	  "hint": "Correct spelling: Fernandez Record id: 3",
	  "fail": [
		{ "type": "dialogue", "char": "passenger", "name": "MRS. FERNANDEZ", "npc": "adult_15/shock", "text": "THAT IS STILL WRONG! Fernandez with a Z! Are you even listening?!" },
		{ "type": "dialogue", "char": "scene",      "name": "SCENE",         "npc": "adult_15/idle",  "text": "Mrs. Fernandez taps the counter impatiently. Other passengers are staring." },
		{ "type": "dialogue", "char": "you",        "name": "YOU",           "npc": "adult_15/idle",  "text": "My sincerest apologies. Let me fix that correctly this time." }
	  ],
	  "result_headers": ["id", "first_name", "last_name", "seat_no"],
	  "result_rows": [["3", "Rosa", "Fernandez", "9B"]],
	  "result_msg": "1 record updated." },
	{ "type": "dialogue", "char": "you",       "name": "YOU",
	  "npc": "adult_15/idle",
	  "text": "Done! Corrected to Fernandez, ma'am. I sincerely apologize for the error." },
	{ "type": "dialogue", "char": "passenger", "name": "MRS. FERNANDEZ",
	  "npc": "adult_15/confuse",
	  "text": "...Hmph. At least you fixed it quickly. Don't let it happen again." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A5 | DELETE
#  Topic: Cancelling a passenger's flight booking
# ─────────────────────────────────────────────
"A5": [
	{ "type": "dialogue", "char": "scene",     "name": "SCENE",
	  "npc": "adult_18/idle",
	  "text": "The counter phone rings. You pick it up — it's a passenger calling to cancel his flight." },
	{ "type": "dialogue", "char": "passenger", "name": "MR. TAN",
	  "npc": "adult_18/confuse",
	  "text": "Hello... I'm so sorry, but I need to cancel my flight. Something came up at work." },
	{ "type": "dialogue", "char": "you",       "name": "YOU",
	  "npc": "adult_18/idle",
	  "text": "I understand completely. Could I have your name and booking id?" },
	{ "type": "dialogue", "char": "passenger", "name": "MR. TAN",
	  "npc": "adult_18/talk",
	  "text": "Kevin Tan. My booking id is 5." },
	{ "type": "dialogue", "char": "you",       "name": "YOU",
	  "npc": "adult_18/idle",
	  "text": "Let me pull that up and process the cancellation for you right now." },
	{ "type": "sql_fill",
	  "gamemode": "delete",
	  "desc": "Remove Mr. Tan's booking from the database. His booking id = 5.",
	  "table": "passengers",
	  "table_headers": ["id", "first_name", "last_name", "seat_no"],
	  "table_rows": [
	  	["1", "Elena",  "Cruz",       "14A"],
	  	["2", "Marco",  "Bautista",   "22C"],
	  	["3", "Rosa",   "Fernandez",  "9B"],
	  	["4", "Carla",  "Garcia",     "17D"],
	  	["5", "Kevin",  "Tan",        "3A"],
	  	["6", "Miguel", "Reyes",      "11C"],
	  	["7", "Sofia",  "Torres",     "20B"],
	  	["8", "Ana",    "Villanueva", "5D"]
	  ],
	  "answer_id": "5",
	  "hint": "Delete the record where id = 5",
	  "fail": [
		{ "type": "dialogue", "char": "passenger", "name": "MR. TAN", "npc": "adult_18/confuse", "text": "That is the wrong record. That is someone else's booking!" },
		{ "type": "dialogue", "char": "scene",      "name": "SCENE",  "npc": "adult_18/idle",   "text": "A long pause on the phone line. This could be a serious data error." },
		{ "type": "dialogue", "char": "you",        "name": "YOU",    "npc": "adult_18/idle",   "text": "I am so sorry, let me double check the correct id." }
	  ],
	  "result_headers": ["STATUS"],
	  "result_rows": [["Record with id = 5 has been removed."]],
	  "result_msg": "1 record deleted." },
	{ "type": "dialogue", "char": "you",       "name": "YOU",
	  "npc": "adult_18/idle",
	  "text": "Done, Mr. Tan! Your booking has been cancelled. We hope to see you fly with us again soon!" },
	{ "type": "dialogue", "char": "passenger", "name": "MR. TAN",
	  "npc": "adult_18/talk",
	  "text": "Thank you so much for being so understanding. I'll rebook next time!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A6 | ORDER BY  |  NPC: pilot (boss)
# ─────────────────────────────────────────────
"A6": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/pilot/idle",
	  "text": "The captain for today's flight stops by the check-in counter before heading to the cockpit." },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN",
	  "npc": "NPC_occupations/pilot/talk",
	  "text": "I need the passenger manifest sorted alphabetically by last name before we finalize boarding. A to Z, please." },
	{ "type": "dialogue", "char": "you",   "name": "YOU",
	  "npc": "NPC_occupations/pilot/idle",
	  "text": "Of course, Captain. I'll sort the manifest right now." },
	{ "type": "sql_fill",
	  "gamemode": "order_by",
	  "desc": "Retrieve all passengers sorted A to Z by last_name. Type ASC or DESC.",
	  "table": "passengers",
	  "column": "last_name",
	  "table_headers": ["id", "first_name", "last_name", "seat_no"],
	  "table_rows": [
	  	["1", "Elena",  "Cruz",       "14A"],
	  	["2", "Marco",  "Bautista",   "22C"],
	  	["3", "Rosa",   "Fernandez",  "9B"],
	  	["4", "Carla",  "Garcia",     "17D"],
	  	["5", "Linda",  "Lim",        "3A"],
	  	["6", "Miguel", "Reyes",      "11C"],
	  	["7", "Sofia",  "Torres",     "20B"],
	  	["8", "Ana",    "Villanueva", "5D"]
	  ],
	  "answer": "ASC",
	  "hint": "A to Z is Ascending order. Type: ASC",
	  "fail": [
		{ "type": "dialogue", "char": "pilot",  "name": "CAPTAIN", "npc": "NPC_occupations/pilot/shock", "text": "This is sorted Z to A! That is backwards! We board in ten minutes!" },
		{ "type": "dialogue", "char": "scene",  "name": "SCENE",   "npc": "NPC_occupations/pilot/idle",  "text": "The captain checks his watch. You feel your face go red." },
		{ "type": "dialogue", "char": "you",    "name": "YOU",     "npc": "NPC_occupations/pilot/idle",  "text": "I apologize, Captain. Let me re-run that with the correct order." }
	  ],
	  "result_headers": ["id", "first_name", "last_name", "seat_no"],
	  "result_rows": [
	  	["2", "Marco",  "Bautista",   "22C"],
	  	["1", "Elena",  "Cruz",       "14A"],
	  	["3", "Rosa",   "Fernandez",  "9B"],
	  	["4", "Carla",  "Garcia",     "17D"],
	  	["5", "Linda",  "Lim",        "3A"],
	  	["6", "Miguel", "Reyes",      "11C"],
	  	["7", "Sofia",  "Torres",     "20B"],
	  	["8", "Ana",    "Villanueva", "5D"]
	  ],
	  "result_msg": "Records sorted by last_name ASC." },
	{ "type": "dialogue", "char": "you",   "name": "YOU",
	  "npc": "NPC_occupations/pilot/idle",
	  "text": "Here you go, Captain — the full manifest sorted A to Z by last name!" },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN",
	  "npc": "NPC_occupations/pilot/think",
	  "text": "Excellent. Bautista, Cruz, Fernandez. Perfect order. Well done." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A7 | GROUP BY  |  NPC: pilot (boss)
# ─────────────────────────────────────────────
"A7": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/pilot/idle",
	  "text": "Before takeoff, the captain needs a weight-and-balance style breakdown of today's flight." },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN",
	  "npc": "NPC_occupations/pilot/talk",
	  "text": "I need a breakdown: how many passengers do we have per seat class? For the load report." },
	{ "type": "dialogue", "char": "you",   "name": "YOU",
	  "npc": "NPC_occupations/pilot/idle",
	  "text": "On it, Captain. I'll group the data by seat class and count them up right now." },
	{ "type": "sql_fill",
	  "gamemode": "group_by",
	  "desc": "Count how many passengers are in each seat class. Fill in the GROUP BY column name.",
	  "table": "passengers",
	  "column": "seat_class",
	  "table_headers": ["id", "first_name", "seat_class"],
	  "table_rows": [
	  	["1",  "Elena",  "Economy"],
	  	["2",  "Marco",  "Business"],
	  	["3",  "Rosa",   "First"],
	  	["4",  "Carla",  "Economy"],
	  	["5",  "Linda",  "Business"],
	  	["6",  "Miguel", "First"],
	  	["7",  "Sofia",  "Economy"],
	  	["8",  "Ana",    "Business"],
	  	["9",  "Diego",  "First"],
	  	["10", "Rosario","Economy"]
	  ],
	  "answer": "seat_class",
	  "hint": "You want to count per seat class. Type: seat_class",
	  "fail": [
		{ "type": "dialogue", "char": "pilot",  "name": "CAPTAIN", "npc": "NPC_occupations/pilot/shock", "text": "What is this? These numbers are completely off. It is not grouped by seat class!" },
		{ "type": "dialogue", "char": "scene",  "name": "SCENE",   "npc": "NPC_occupations/pilot/idle",  "text": "The captain sets down the report. We push back from the gate in ten minutes." },
		{ "type": "dialogue", "char": "you",    "name": "YOU",     "npc": "NPC_occupations/pilot/idle",  "text": "I will fix the GROUP BY column right now, Captain." }
	  ],
	  "result_headers": ["seat_class", "COUNT(*)"],
	  "result_rows": [
	  	["Economy",  "4"],
	  	["Business", "3"],
	  	["First",    "3"]
	  ],
	  "result_msg": "Data grouped successfully." },
	{ "type": "dialogue", "char": "you",   "name": "YOU",
	  "npc": "NPC_occupations/pilot/idle",
	  "text": "Report ready, Captain! Economy: 4, Business: 3, First: 3." },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN",
	  "npc": "NPC_occupations/pilot/talk",
	  "text": "Perfect. Exactly what I needed for the load sheet. You're a natural at this." },
	{ "type": "dialogue", "char": "you",   "name": "YOU",
	  "npc": "NPC_occupations/pilot/idle",
	  "text": "Just doing my job, Captain. One query at a time." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A8 | IS NULL  |  NPC: pilot
#  Topic: Find passengers with no meal preference on file
# ─────────────────────────────────────────────
"A8": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/pilot/idle",
	  "text": "Catering is loading the galley. The captain double-checks with you before the cart is sealed." },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN",
	  "npc": "NPC_occupations/pilot/talk",
	  "text": "Catering needs to know who still has no meal preference on file before we close the doors. Can you find them?" },
	{ "type": "dialogue", "char": "you",   "name": "YOU",
	  "npc": "NPC_occupations/pilot/idle",
	  "text": "On it. In SQL, a missing value is called NULL. I can filter for IS NULL to find them." },
	{
		"type": "sql_fill",
		"gamemode": "select_where_null",
		"desc": "Find all passengers with no meal preference. The missing fields show as NULL. Type NULL after IS.",
		"table": "passengers",
		"column": "meal_pref",
		"table_headers": ["id", "first_name", "last_name", "meal_pref"],
		"table_rows": [
			["1", "Elena", "Cruz",      "Vegetarian"],
			["2", "Marco", "Bautista",  ""],
			["3", "Rosa",  "Fernandez", "Chicken"],
			["4", "Carla", "Garcia",    ""],
			["5", "Linda", "Lim",       "Beef"],
			["6", "Miguel","Reyes",     ""]
		],
		"answer": "NULL",
		"hint": "Missing values are NULL. Type: NULL",
		"result_headers": ["id", "first_name", "last_name", "meal_pref"],
		"result_rows": [
			["2", "Marco",  "Bautista", "NULL"],
			["4", "Carla",  "Garcia",   "NULL"],
			["6", "Miguel", "Reyes",    "NULL"]
		],
		"result_msg": "3 passengers have no meal preference on file.",
		"fail": [
			{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/shock", "text": "That is not right. NULL means the value is missing, it is not a regular word to search for." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE",   "npc": "NPC_occupations/pilot/idle",  "text": "The captain glances toward the jet bridge, waiting." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",     "npc": "NPC_occupations/pilot/idle",  "text": "Right, I need to type NULL after IS to check for missing values." }
		]
	},
	{ "type": "dialogue", "char": "you",   "name": "YOU",
	  "npc": "NPC_occupations/pilot/idle",
	  "text": "Found them, Captain! Bautista, Garcia, and Reyes have no meal preference. Catering can default them to chicken." },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN",
	  "npc": "NPC_occupations/pilot/talk",
	  "text": "Perfect. IS NULL is a powerful tool for finding gaps in our data. Good thinking." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A16 | SELECT DISTINCT  |  NPC: pilot
# ─────────────────────────────────────────────
"A16": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/pilot/idle",
	  "text": "The captain is reviewing the day's schedule and wants a clean list of destinations." },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "We have dozens of bookings today, but I just want each destination listed once. No duplicates." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "SELECT DISTINCT returns only unique values in a column — duplicates are automatically removed." },
	{ "type": "sql_fill", "gamemode": "select_distinct",
	  "desc": "Return only the unique destinations from the bookings table. Fill in the column name after SELECT DISTINCT.",
	  "table": "bookings",
	  "column": "destination",
	  "table_headers": ["id","passenger_id","destination","flight_no"],
	  "table_rows": [["1","1","Manila","PR101"],["2","2","Cebu","PR202"],["3","3","Manila","PR101"],["4","4","Davao","PR303"],["5","5","Cebu","PR202"],["6","6","Manila","PR101"]],
	  "hint": "The column with repeating values to deduplicate: destination",
	  "result_headers": ["destination"],
	  "result_rows": [["Manila"],["Cebu"],["Davao"]],
	  "result_msg": "3 unique destinations found. DISTINCT removed the duplicate 'Manila' and 'Cebu' entries.",
	  "fail": [
		{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/shock", "text": "That column does not exist in the bookings table!" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle", "text": "The column with repeated destination names is: destination." }
	  ]
	},
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "Manila, Cebu, Davao. DISTINCT is perfect when I only want to know what routes exist today." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "Exactly. Without DISTINCT you would see 'Manila' three times. DISTINCT returns each value once." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A17 | AND/OR  |  NPC: pilot
# ─────────────────────────────────────────────
"A17": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/pilot/idle",
	  "text": "The captain wants to find Business class passengers who have already checked in — both conditions must be true." },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "I need passengers who are Business class AND already checked in. Not just one or the other — both must apply." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "AND requires both conditions to be true at the same time. OR would include passengers with either condition." },
	{ "type": "sql_fill", "gamemode": "where_and_or",
	  "desc": "Find passengers who are Business class AND checked in. Fill in AND or OR.",
	  "table": "passengers",
	  "condition1": "seat_class = 'Business'",
	  "condition2": "checked_in = 'Yes'",
	  "answer": "AND",
	  "table_headers": ["id","first_name","seat_class","checked_in"],
	  "table_rows": [["1","Elena","Business","Yes"],["2","Marco","Economy","Yes"],["3","Rosa","Business","No"],["4","Carla","Business","Yes"],["5","Linda","Economy","No"]],
	  "hint": "Both conditions must be true simultaneously: AND",
	  "result_headers": ["id","first_name","seat_class","checked_in"],
	  "result_rows": [["1","Elena","Business","Yes"],["4","Carla","Business","Yes"]],
	  "result_msg": "2 Business class passengers already checked in. AND requires BOTH conditions. OR would return 4 rows.",
	  "fail": [
		{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/shock", "text": "Wrong connector! That gave too many results. I need BOTH conditions true at once." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle", "text": "For both conditions required: AND." }
	  ]
	},
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "Only Elena and Carla — Business class and already checked in. AND is strict." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "Right. OR would include Rosa, who is Business but not checked in, and Marco, who is checked in but Economy." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A18 | BETWEEN  |  NPC: pilot
# ─────────────────────────────────────────────
"A18": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/pilot/idle",
	  "text": "The captain wants to review mid-range fares — not the cheapest seats, not the most expensive." },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "I need bookings where the ticket price is between 200 and 500. Both 200 and 500 should be included." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "BETWEEN filters a range inclusively. 'BETWEEN 200 AND 500' means price >= 200 AND price <= 500." },
	{ "type": "sql_fill", "gamemode": "where_between",
	  "desc": "Find bookings where ticket_price is between 200 and 500. Fill in the range keyword.",
	  "table": "bookings",
	  "column": "ticket_price",
	  "low": "200", "high": "500",
	  "answer": "BETWEEN",
	  "table_headers": ["id","destination","ticket_price"],
	  "table_rows": [["1","Manila","150"],["2","Cebu","320"],["3","Davao","650"],["4","Manila","180"],["5","Cebu","480"],["6","Davao","720"],["7","Manila","250"]],
	  "hint": "The range filtering keyword is: BETWEEN",
	  "result_headers": ["id","destination","ticket_price"],
	  "result_rows": [["2","Cebu","320"],["5","Cebu","480"],["7","Manila","250"]],
	  "result_msg": "3 bookings in the 200-500 range. BETWEEN is inclusive — 200 and 500 themselves would also match.",
	  "fail": [
		{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/shock", "text": "That is not the range keyword! I need BETWEEN to filter inclusive ranges." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle", "text": "The inclusive range keyword is BETWEEN." }
	  ]
	},
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "3 mid-range bookings. BETWEEN is much cleaner than writing 'price >= 200 AND price <= 500'." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "Exactly. BETWEEN also works with dates: WHERE departure BETWEEN '2024-01-01' AND '2024-12-31'." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A19 | LIKE  |  NPC: pilot
# ─────────────────────────────────────────────
"A19": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/pilot/idle",
	  "text": "A family group with surnames starting with D has made multiple bookings. The captain wants them found for a group seating request." },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "Can you find all passengers whose last name starts with the letter D? LIKE can help with partial text matching." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "LIKE uses % as a wildcard. 'D%' means starts with D, followed by any characters." },
	{ "type": "sql_fill", "gamemode": "where_like",
	  "desc": "Find all passengers whose last_name starts with 'D'. Fill in the LIKE pattern.",
	  "table": "passengers",
	  "column": "last_name",
	  "answer": "'D%'",
	  "table_headers": ["id","first_name","last_name"],
	  "table_rows": [["1","Elena","Dizon"],["2","Marco","Bautista"],["3","Jose","Delacruz"],["4","Carla","Garcia"],["5","Linda","Diaz"],["6","Miguel","Reyes"]],
	  "hint": "Starts with D then any characters: 'D%'",
	  "result_headers": ["id","first_name","last_name"],
	  "result_rows": [["1","Elena","Dizon"],["3","Jose","Delacruz"],["5","Linda","Diaz"]],
	  "result_msg": "3 passengers found. 'D%' = starts with D, then anything. Dizon, Delacruz, and Diaz all match.",
	  "fail": [
		{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/shock", "text": "That pattern did not match the right passengers. Remember % means any characters." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle", "text": "For names starting with D: 'D%'" }
	  ]
	},
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "Dizon, Delacruz, and Diaz. The % wildcard is powerful for partial text searches." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "And '_iaz' would match exactly one character before 'iaz'. 'Diaz' would match, but 'Deniaz' would not." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A20 | IN  |  NPC: pilot
# ─────────────────────────────────────────────
"A20": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/pilot/idle",
	  "text": "The captain wants bookings for the three domestic routes flown today only — no international routes in this report." },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "I need bookings to Manila, Cebu, or Davao. Instead of writing three OR conditions, is there a shorter way?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "Yes — IN lets you check if a value matches any item in a list. It is cleaner than multiple OR conditions." },
	{ "type": "sql_fill", "gamemode": "where_in",
	  "desc": "Find bookings where destination is Manila, Cebu, or Davao. Fill in the list membership keyword.",
	  "table": "bookings",
	  "column": "destination",
	  "in_list": "('Manila', 'Cebu', 'Davao')",
	  "answer": "IN",
	  "table_headers": ["id","destination","ticket_price"],
	  "table_rows": [["1","Manila","250"],["2","Cebu","320"],["3","Tokyo","900"],["4","Manila","180"],["5","Davao","410"],["6","Singapore","1100"]],
	  "hint": "The list membership keyword is: IN",
	  "result_headers": ["id","destination","ticket_price"],
	  "result_rows": [["1","Manila","250"],["2","Cebu","320"],["4","Manila","180"],["5","Davao","410"]],
	  "result_msg": "4 bookings found. IN ('Manila','Cebu','Davao') equals: destination='Manila' OR destination='Cebu' OR destination='Davao'.",
	  "fail": [
		{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/shock", "text": "That keyword is wrong. The list matching keyword is IN." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle", "text": "The keyword for list matching is IN." }
	  ]
	},
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "4 domestic bookings. IN with a list is much cleaner than chaining OR conditions." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "IN also works with numbers: WHERE id IN (1, 3, 5). You can also use NOT IN to exclude values." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A21 | LIMIT  |  NPC: pilot
# ─────────────────────────────────────────────
"A21": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/pilot/idle",
	  "text": "The captain wants a quick preview of priority boarding passengers — not the whole manifest, just the first few." },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "I just need a sample of the passengers table to verify the data format. Show me only the first 5 rows." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "LIMIT restricts how many rows a query returns. It is especially useful for previewing large tables." },
	{ "type": "sql_fill", "gamemode": "limit",
	  "desc": "Return only the first 5 rows from the passengers table. Type the number after LIMIT.",
	  "table": "passengers",
	  "answer": "5",
	  "table_headers": ["id","first_name","last_name","seat_no"],
	  "table_rows": [["1","Elena","Cruz","14A"],["2","Marco","Bautista","22C"],["3","Rosa","Fernandez","9B"],["4","Carla","Garcia","17D"],["5","Linda","Lim","3A"],["6","Miguel","Reyes","11C"],["7","Ana","Torres","20B"]],
	  "hint": "Show only 5 rows — type the number: 5",
	  "result_headers": ["id","first_name","last_name","seat_no"],
	  "result_rows": [["1","Elena","Cruz","14A"],["2","Marco","Bautista","22C"],["3","Rosa","Fernandez","9B"],["4","Carla","Garcia","17D"],["5","Linda","Lim","3A"]],
	  "result_msg": "5 rows returned. Rows 6 and 7 were not fetched. LIMIT saves time on large tables.",
	  "fail": [
		{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/shock", "text": "That is not 5 rows. Type the number 5." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle", "text": "Type the number 5 after LIMIT." }
	  ]
	},
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "5 rows only — much faster. LIMIT is great with ORDER BY to get the top or bottom N records." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "For example: SELECT * FROM passengers ORDER BY id DESC LIMIT 3 gives the 3 most recently checked-in passengers." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A22 | COUNT/SUM/AVG  |  NPC: pilot
# ─────────────────────────────────────────────
"A22": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/pilot/idle",
	  "text": "Final headcount time. The captain needs a total count of all checked-in passengers before push-back." },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "How many passengers do we have checked in? I need a single number, not a list." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "COUNT is an aggregate function — it collapses many rows into a single calculated value." },
	{ "type": "sql_fill", "gamemode": "aggregate",
	  "desc": "Count the total number of passengers. Fill in the aggregate function name.",
	  "table": "passengers",
	  "column": "id",
	  "answer": "COUNT",
	  "table_headers": ["id","first_name","last_name"],
	  "table_rows": [["1","Elena","Cruz"],["2","Marco","Bautista"],["3","Rosa","Fernandez"],["4","Carla","Garcia"],["5","Linda","Lim"],["6","Miguel","Reyes"]],
	  "hint": "To count the number of rows: COUNT",
	  "result_headers": ["COUNT(id)"],
	  "result_rows": [["6"]],
	  "result_msg": "6 passengers total.\n\nOther aggregate functions:\n- SUM(price) adds all values\n- AVG(price) calculates the average\n- MIN/MAX finds smallest or largest value",
	  "fail": [
		{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/shock", "text": "That is not a valid aggregate function. To count rows use COUNT." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle", "text": "The counting aggregate function is COUNT." }
	  ]
	},
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "6 passengers. Aggregate functions like COUNT, SUM, and AVG are essential for load reports and analysis." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "Right. SELECT SUM(ticket_price) FROM bookings gives total revenue. AVG gives the average fare." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A23 | HAVING  |  NPC: pilot
# ─────────────────────────────────────────────
"A23": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/pilot/idle",
	  "text": "The captain wants to know which destinations have more than one booking today — a quick overbooking check." },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "I need destinations with more than 1 booking. But WHERE cannot filter on GROUP BY results. What do I use?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "HAVING filters AFTER grouping. WHERE filters individual rows before grouping. HAVING works on group results." },
	{ "type": "sql_fill", "gamemode": "having",
	  "desc": "Show only destinations booked more than once. Fill in the aggregate function in HAVING.",
	  "table": "bookings",
	  "group_col": "destination",
	  "answer": "COUNT",
	  "table_headers": ["id","destination","passenger_id"],
	  "table_rows": [["1","Manila","1"],["2","Cebu","2"],["3","Manila","3"],["4","Davao","4"],["5","Cebu","5"],["6","Manila","6"]],
	  "hint": "HAVING uses the aggregate function: COUNT",
	  "result_headers": ["destination","COUNT(*)"],
	  "result_rows": [["Manila","3"],["Cebu","2"]],
	  "result_msg": "Manila (3) and Cebu (2) appear more than once. Davao had only 1 booking so it was filtered out.",
	  "fail": [
		{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/shock", "text": "Wrong function. HAVING uses COUNT here to check group size." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle", "text": "HAVING filters groups using COUNT." }
	  ]
	},
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "Manila and Cebu are the busiest routes today! HAVING is just like WHERE but it runs after GROUP BY." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "Exactly. WHERE cannot reference COUNT(*) because groups do not exist yet when WHERE runs." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON A24 | AS (Aliases)  |  NPC: pilot
# ─────────────────────────────────────────────
"A24": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/pilot/idle",
	  "text": "The captain wants a report showing fares with tax, but the column name should be readable." },
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "The column 'ticket_price * 1.12' shows up as just that expression in the report. Can we rename it?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "AS gives a column a friendly display name called an alias. The table itself is unchanged." },
	{ "type": "sql_fill", "gamemode": "select_alias",
	  "desc": "Rename the calculated column to 'price_with_tax'. Fill in the alias name after AS.",
	  "table": "bookings",
	  "col_expr": "ticket_price * 1.12",
	  "answer": "price_with_tax",
	  "table_headers": ["id","destination","ticket_price"],
	  "table_rows": [["1","Manila","200"],["2","Cebu","300"],["3","Davao","400"]],
	  "hint": "The alias name for the tax column: price_with_tax",
	  "result_headers": ["price_with_tax"],
	  "result_rows": [["224.0"],["336.0"],["448.0"]],
	  "result_msg": "Column now displays as 'price_with_tax' in results. AS only affects output — the table is unchanged.",
	  "fail": [
		{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/shock", "text": "That alias is not right. The alias should be: price_with_tax" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle", "text": "Type the alias: price_with_tax" }
	  ]
	},
	{ "type": "dialogue", "char": "pilot", "name": "CAPTAIN", "npc": "NPC_occupations/pilot/talk",
	  "text": "Clean! AS also works on table names in JOINs: FROM bookings AS b — useful in long queries." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/pilot/idle",
	  "text": "Right. Short aliases like 'b' or 'p' keep JOIN queries readable when referencing multiple tables." },
	{ "type": "end" }
]

} # end LESSONS
