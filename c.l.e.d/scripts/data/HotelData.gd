extends Node
# ═══════════════════════════════════════════════════════
#  HOTEL DATA  —  scripts/data/HotelData.gd
#
#  Each lesson uses a DIFFERENT NPC (except boss/manager).
#  Format:  "npc": "adult_N/expr"  OR  "NPC_occupations/X/expr"
#
#  Lesson NPC assignments:
#    L1 → adult_1   (friendly guest)
#    L2 → adult_13  (Alex, shy guest)
#    L3 → adult_12  (Maya, nervous woman)
#    L4 → adult_9   (Mr. H, angry man)
#    L5 → adult_14  (Ms. Lim, phone cancellation)
#    L6 → NPC_occupations/hotel_manager  (boss)
#    L7 → NPC_occupations/hotel_manager  (boss)
#
#  Rule: "you" / "scene" always use idle — NPC looks at you.
# ═══════════════════════════════════════════════════════

const LESSONS: Dictionary = {

# ─────────────────────────────────────────────
#  LESSON 1 — SELECT  |  NPC: adult_1
# ─────────────────────────────────────────────
1: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "adult_1/idle",
	  "text": "A guest steps up to the counter with a friendly wave. It's your first interaction of the day." },
	{ "type": "dialogue", "char": "guest",  "name": "GUEST",
	  "npc": "adult_1/talk",
	  "text": "Good morning! I was wondering — do you happen to have any rooms available for tonight?" },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_1/idle",
	  "text": "Let me check my options before responding..." },
	{ "type": "sql_choice",
	  "desc": "Three responses are in the table below. Type the id of the most professional and helpful answer.",
	  "options": [
	  	[1, "Yes! We have Deluxe and Standard rooms. Which type would you prefer?"],
	  	[2, "I don't know, check the board yourself."],
	  	[3, "Come back later."]
	  ],
	  "correct_id": 1,
	  "hint": "A good receptionist informs and offers options. Answer: id = 1",
	  "fail": [
		{ "type": "dialogue", "char": "guest", "name": "GUEST", "npc": "adult_1/shock", "text": "Excuse me?! That is NOT a helpful response!" },
		{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "adult_1/idle",  "text": "The guest storms off. Your supervisor sighs from across the lobby." },
		{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "adult_1/idle",  "text": "That did not go well. Let me choose the correct response this time." }
	  ] },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_1/idle",
	  "text": "Yes! We have Deluxe and Standard rooms available. Which type would you prefer?" },
	{ "type": "dialogue", "char": "guest",  "name": "GUEST",
	  "npc": "adult_1/talk",
	  "text": "A Deluxe room would be perfect! You're so helpful, thank you!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 2 — INSERT INTO  |  NPC: adult_13
# ─────────────────────────────────────────────
2: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "adult_13/idle",
	  "text": "A young man walks in with a rolling suitcase and looks around the lobby, then approaches your desk." },
	{ "type": "dialogue", "char": "guest",  "name": "ALEX",
	  "npc": "adult_13/confuse",
	  "text": "Uh, hi... I'd like to book a room, please." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_13/idle",
	  "text": "Good morning! Welcome to Grand Hotel. May I have your full name?" },
	{ "type": "dialogue", "char": "guest",  "name": "ALEX",
	  "npc": "adult_13/talk",
	  "text": "My name is Alex Rivera Santos." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_13/idle",
	  "text": "Perfect! Let me register that in our system right now." },
	{ "type": "sql_fill",
	  "gamemode": "insert_into",
	  "desc": "Add Alex Rivera Santos to the customers table. Fill in his first_name, middle_name, and last_name.",
	  "table": "customers",
	  "columns": ["first_name", "middle_name", "last_name"],
	  "table_headers": ["id", "first_name", "middle_name", "last_name"],
	  "table_rows": [],
	  "answers": ["Alex", "Rivera", "Santos"],
	  "hint": "Alex Rivera Santos — First: Alex | Middle: Rivera | Last: Santos",
	  "fail": [
		{ "type": "dialogue", "char": "guest", "name": "ALEX",  "npc": "adult_13/confuse", "text": "That is not my name at all. Are you sure you typed it right?" },
		{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "adult_13/idle",   "text": "Alex looks uncomfortable. The guest in line behind him sighs." },
		{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "adult_13/idle",   "text": "I am so sorry! Let me re-enter that correctly." }
	  ],
	  "result_headers": ["id", "first_name", "middle_name", "last_name"],
	  "result_rows": [["1", "Alex", "Rivera", "Santos"]],
	  "result_msg": "1 record inserted into customers." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_13/idle",
	  "text": "You're all set, Mr. Santos! Room 101 is confirmed. Enjoy your stay!" },
	{ "type": "dialogue", "char": "guest",  "name": "ALEX",
	  "npc": "adult_13/talk",
	  "text": "That was so fast, thank you! You're amazing!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 3 — SELECT WHERE  |  NPC: adult_12
# ─────────────────────────────────────────────
3: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "adult_12/idle",
	  "text": "A nervous young woman approaches, clutching a printed email and looking very worried." },
	{ "type": "dialogue", "char": "guest2", "name": "MAYA",
	  "npc": "adult_12/confuse",
	  "text": "Um... sorry to bother you... I made a reservation online but I can't find my confirmation email..." },
	{ "type": "dialogue", "char": "guest2", "name": "MAYA",
	  "npc": "adult_12/shock",
	  "text": "What if my booking doesn't exist?? I saved up for this for months!!" },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_12/idle",
	  "text": "Hey, breathe! I can search for you. What's your last name?" },
	{ "type": "dialogue", "char": "guest2", "name": "MAYA",
	  "npc": "adult_12/talk",
	  "text": "Dela Cruz. D-E-L-A Cruz." },
	{ "type": "sql_fill",
	  "gamemode": "select_where",
	  "desc": "Search the customers table for Maya's last name. Fill in the WHERE clause.",
	  "table": "customers",
	  "column": "last_name",
	  "table_headers": ["id", "first_name", "last_name", "room_no"],
	  "table_rows": [
	  	["1", "Alex",   "Santos",     "101"],
	  	["2", "Maya",   "Dela Cruz",  "204"],
	  	["3", "Jose",   "Hernandez",  "312"],
	  	["4", "Carlos", "Garcia",     "412"],
	  	["5", "Linda",  "Lim",        "205"],
	  	["6", "Marco",  "Reyes",      "108"],
	  	["7", "Sofia",  "Torres",     "310"],
	  	["8", "Ana",    "Villanueva", "217"]
	  ],
	  "answer": "Dela Cruz",
	  "hint": "Type her last name exactly: Dela Cruz",
	  "fail": [
		{ "type": "dialogue", "char": "guest2", "name": "MAYA",  "npc": "adult_12/shock",  "text": "That is not my name! What if my booking is really gone?!" },
		{ "type": "dialogue", "char": "scene",  "name": "SCENE", "npc": "adult_12/idle",   "text": "Maya starts to tear up. Someone behind her in the lobby gives you a look." },
		{ "type": "dialogue", "char": "you",    "name": "YOU",   "npc": "adult_12/idle",   "text": "My apologies! I typed the wrong name. Let me search again." }
	  ],
	  "result_headers": ["id", "first_name", "last_name", "room_no"],
	  "result_rows": [["2", "Maya", "Dela Cruz", "204"]],
	  "result_msg": "1 record found." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_12/idle",
	  "text": "Found you! Room 204, Deluxe Queen — all confirmed, Ms. Dela Cruz!" },
	{ "type": "dialogue", "char": "guest2", "name": "MAYA",
	  "npc": "adult_12/talk",
	  "text": "Oh THANK GOODNESS!! You're literally a lifesaver, thank you!!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 4 — UPDATE SET  |  NPC: adult_9
# ─────────────────────────────────────────────
4: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "adult_9/idle",
	  "text": "A stocky man storms up to the front desk, arms crossed, red-faced. You take a deep breath." },
	{ "type": "dialogue", "char": "guest3", "name": "MR. H",
	  "npc": "adult_9/shock",
	  "text": "EXCUSE ME. There is a MISTAKE in my booking and I am NOT happy about it!!" },
	{ "type": "sql_choice",
	  "desc": "An upset guest is in front of you. Choose the most professional response.",
	  "options": [
	  	[1, "Please calm down, sir, you're disturbing other guests."],
	  	[2, "I'm very sorry to hear that. I'll fix it right away."],
	  	[3, "Not my problem."]
	  ],
	  "correct_id": 2,
	  "hint": "De-escalate calmly and offer to help. Answer: id = 2",
	  "fail": [
		{ "type": "dialogue", "char": "guest3", "name": "MR. H", "npc": "adult_9/shock", "text": "ARE YOU SERIOUS?! I want your manager THIS INSTANT!!" },
		{ "type": "dialogue", "char": "scene",  "name": "SCENE", "npc": "adult_9/idle",  "text": "The whole lobby goes quiet. Your supervisor appears looking displeased." },
		{ "type": "dialogue", "char": "you",    "name": "YOU",   "npc": "adult_9/idle",  "text": "I need to handle this better. Let me choose the right response." }
	  ] },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_9/idle",
	  "text": "I'm very sorry to hear that. I'll fix it right away. May I have your booking id?" },
	{ "type": "dialogue", "char": "guest3", "name": "MR. H",
	  "npc": "adult_9/shock",
	  "text": "The name is Hernandez! H-E-R-N-A-N-D-E-Z!! You have it as Hernandes — NO Z!! Booking id is 3." },
	{ "type": "sql_fill",
	  "gamemode": "update_set",
	  "desc": "Fix the last_name from Hernandes to Hernandez for record id = 3.",
	  "table": "customers",
	  "column": "last_name",
	  "table_headers": ["id", "first_name", "last_name", "room_no"],
	  "table_rows": [
	  	["1", "Alex",   "Santos",     "101"],
	  	["2", "Maya",   "Dela Cruz",  "204"],
	  	["3", "Jose",   "Hernandes",  "312"],
	  	["4", "Carlos", "Garcia",     "412"],
	  	["5", "Linda",  "Lim",        "205"],
	  	["6", "Marco",  "Reyes",      "108"]
	  ],
	  "answer_value": "Hernandez",
	  "answer_id": "3",
	  "hint": "Correct spelling: Hernandez | Record id: 3",
	  "fail": [
		{ "type": "dialogue", "char": "guest3", "name": "MR. H", "npc": "adult_9/shock",   "text": "THAT IS STILL WRONG! Hernandez with a Z! Are you even listening?!" },
		{ "type": "dialogue", "char": "scene",  "name": "SCENE", "npc": "adult_9/idle",    "text": "Mr. Hernandez slams his fist on the counter. Other guests are staring." },
		{ "type": "dialogue", "char": "you",    "name": "YOU",   "npc": "adult_9/idle",    "text": "My sincerest apologies. Let me fix that correctly this time." }
	  ],
	  "result_headers": ["id", "first_name", "last_name", "room_no"],
	  "result_rows": [["3", "Jose", "Hernandez", "312"]],
	  "result_msg": "1 record updated." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_9/idle",
	  "text": "Done! Corrected to Hernandez, Mr. Hernandez. I sincerely apologize for the error." },
	{ "type": "dialogue", "char": "guest3", "name": "MR. H",
	  "npc": "adult_9/confuse",
	  "text": "...Hmph. At least you fixed it quickly. Don't let it happen again." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 5 — DELETE  |  NPC: adult_14
# ─────────────────────────────────────────────
5: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "adult_14/idle",
	  "text": "The front desk phone rings. You pick it up — it's a guest calling in to cancel her reservation." },
	{ "type": "dialogue", "char": "guest2", "name": "MS. LIM",
	  "npc": "adult_14/confuse",
	  "text": "Hello... I'm so sorry, but I need to cancel my reservation. Something came up at work." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_14/idle",
	  "text": "I understand completely. Could I have your name and booking id?" },
	{ "type": "dialogue", "char": "guest2", "name": "MS. LIM",
	  "npc": "adult_14/talk",
	  "text": "Linda Lim. My booking id is 5." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_14/idle",
	  "text": "Let me pull that up and process the cancellation for you right now." },
	{ "type": "sql_fill",
	  "gamemode": "delete",
	  "desc": "Remove Ms. Lim's reservation from the database. Her booking id = 5.",
	  "table": "customers",
	  "table_headers": ["id", "first_name", "last_name", "room_no"],
	  "table_rows": [
	  	["1", "Alex",   "Santos",     "101"],
	  	["2", "Maya",   "Dela Cruz",  "204"],
	  	["3", "Jose",   "Hernandez",  "312"],
	  	["4", "Carlos", "Garcia",     "412"],
	  	["5", "Linda",  "Lim",        "205"],
	  	["6", "Marco",  "Reyes",      "108"],
	  	["7", "Sofia",  "Torres",     "310"],
	  	["8", "Ana",    "Villanueva", "217"]
	  ],
	  "answer_id": "5",
	  "hint": "Delete the record where id = 5",
	  "fail": [
		{ "type": "dialogue", "char": "guest2", "name": "MS. LIM", "npc": "adult_14/confuse", "text": "That is the wrong record. That is someone else's booking!" },
		{ "type": "dialogue", "char": "scene",  "name": "SCENE",   "npc": "adult_14/idle",   "text": "A long pause on the phone line. This could be a serious data error." },
		{ "type": "dialogue", "char": "you",    "name": "YOU",     "npc": "adult_14/idle",   "text": "I am so sorry — let me double check the correct id." }
	  ],
	  "result_headers": ["STATUS"],
	  "result_rows": [["Record with id = 5 has been removed."]],
	  "result_msg": "1 record deleted." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_14/idle",
	  "text": "Done, Ms. Lim! Your reservation has been cancelled. We hope to see you again soon!" },
	{ "type": "dialogue", "char": "guest2", "name": "MS. LIM",
	  "npc": "adult_14/talk",
	  "text": "Thank you so much for being so understanding. I'll rebook next time!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 6 — ORDER BY  |  NPC: hotel_manager (boss)
# ─────────────────────────────────────────────
6: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The hotel manager walks over with his clipboard, scanning the guest registry." },
	{ "type": "dialogue", "char": "mgr",    "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "I need you to pull up all current guests sorted alphabetically by last name. A to Z, please." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Of course, sir. I'll sort the records right now." },
	{ "type": "sql_fill",
	  "gamemode": "order_by",
	  "desc": "Retrieve all guests sorted A to Z by last_name. Type ASC or DESC.",
	  "table": "customers",
	  "column": "last_name",
	  "table_headers": ["id", "first_name", "last_name", "room_no"],
	  "table_rows": [
	  	["1", "Alex",   "Santos",     "101"],
	  	["2", "Maya",   "Dela Cruz",  "204"],
	  	["3", "Jose",   "Hernandez",  "312"],
	  	["4", "Carlos", "Garcia",     "412"],
	  	["5", "Linda",  "Lim",        "205"],
	  	["6", "Marco",  "Reyes",      "108"],
	  	["7", "Sofia",  "Torres",     "310"],
	  	["8", "Ana",    "Villanueva", "217"]
	  ],
	  "answer": "ASC",
	  "hint": "A to Z is Ascending order. Type: ASC",
	  "fail": [
		{ "type": "dialogue", "char": "mgr",   "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "This is sorted Z to A! That is backwards! This is for a board meeting!" },
		{ "type": "dialogue", "char": "scene", "name": "SCENE",   "npc": "NPC_occupations/hotel_manager/idle",  "text": "The manager pinches the bridge of his nose. You feel your face go red." },
		{ "type": "dialogue", "char": "you",   "name": "YOU",     "npc": "NPC_occupations/hotel_manager/idle",  "text": "I apologize sir. Let me re-run that with the correct order." }
	  ],
	  "result_headers": ["id", "first_name", "last_name", "room_no"],
	  "result_rows": [
	  	["2", "Maya",   "Dela Cruz",  "204"],
	  	["4", "Carlos", "Garcia",     "412"],
	  	["3", "Jose",   "Hernandez",  "312"],
	  	["5", "Linda",  "Lim",        "205"],
	  	["6", "Marco",  "Reyes",      "108"],
	  	["1", "Alex",   "Santos",     "101"],
	  	["7", "Sofia",  "Torres",     "310"],
	  	["8", "Ana",    "Villanueva", "217"]
	  ],
	  "result_msg": "Records sorted by last_name ASC." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Here you go, sir — all guests sorted A to Z by last name!" },
	{ "type": "dialogue", "char": "mgr",    "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/think",
	  "text": "Excellent. Dela Cruz, Hernandez, Santos. Perfect order. Well done." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 7 — GROUP BY  |  NPC: hotel_manager (boss)
# ─────────────────────────────────────────────
7: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Friday afternoon. The manager walks in looking serious, carrying his weekly report clipboard." },
	{ "type": "dialogue", "char": "mgr",    "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "I need a breakdown: how many bookings do we have per room type? For the board meeting." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "On it, sir. I'll group the data by room type and count them up right now." },
	{ "type": "sql_fill",
	  "gamemode": "group_by",
	  "desc": "Count how many customers booked each room type. Fill in the GROUP BY column name.",
	  "table": "customers",
	  "column": "room_type",
	  "table_headers": ["id", "first_name", "room_type"],
	  "table_rows": [
	  	["1",  "Alex",   "Standard"],
	  	["2",  "Maya",   "Deluxe"],
	  	["3",  "Jose",   "Suite"],
	  	["4",  "Carlos", "Standard"],
	  	["5",  "Linda",  "Deluxe"],
	  	["6",  "Marco",  "Suite"],
	  	["7",  "Sofia",  "Standard"],
	  	["8",  "Ana",    "Deluxe"],
	  	["9",  "Miguel", "Suite"],
	  	["10", "Rosa",   "Standard"]
	  ],
	  "answer": "room_type",
	  "hint": "You want to count per room type. Type: room_type",
	  "fail": [
		{ "type": "dialogue", "char": "mgr",   "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "What is this? These numbers are completely off. It is not grouped by room type!" },
		{ "type": "dialogue", "char": "scene", "name": "SCENE",   "npc": "NPC_occupations/hotel_manager/idle",  "text": "The manager sets down the report. The board meeting is in one hour." },
		{ "type": "dialogue", "char": "you",   "name": "YOU",     "npc": "NPC_occupations/hotel_manager/idle",  "text": "I will fix the GROUP BY column right now sir." }
	  ],
	  "result_headers": ["room_type", "COUNT(*)"],
	  "result_rows": [
	  	["Standard", "4"],
	  	["Deluxe",   "3"],
	  	["Suite",    "3"]
	  ],
	  "result_msg": "Data grouped successfully." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Report ready! Standard: 2, Deluxe: 2, Suite: 1." },
	{ "type": "dialogue", "char": "mgr",    "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Perfect. This is exactly what I needed. You're a natural at this." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Just doing my job, sir. One query at a time." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 8 — IS NULL  |  NPC: hotel_manager
#  Topic: Find guests with no email on file
# ─────────────────────────────────────────────
8: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Billing season. The manager pulls you aside before the morning rush." },
	{ "type": "dialogue", "char": "mgr",    "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "I need to send digital invoices, but some guests never gave us their email. Can you find which guests have no email on file?" },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "On it. In SQL, a missing value is called NULL. I can filter for IS NULL to find them." },
	{
		"type": "sql_fill",
		"gamemode": "select_where_null",
		"desc": "Find all guests with no email address. The missing fields show as NULL. Type NULL after IS.",
		"table": "guests",
		"column": "email",
		"table_headers": ["id", "first_name", "last_name", "email"],
		"table_rows": [
			["1", "Alex",   "Santos",    "alex@mail.com"],
			["2", "Maya",   "Dela Cruz", ""],
			["3", "Jose",   "Hernandez", "jose@mail.com"],
			["4", "Carlos", "Garcia",    ""],
			["5", "Linda",  "Lim",       "linda@mail.com"],
			["6", "Marco",  "Reyes",     ""]
		],
		"answer": "NULL",
		"hint": "Missing values are NULL. Type: NULL",
		"result_headers": ["id", "first_name", "last_name", "email"],
		"result_rows": [
			["2", "Maya",   "Dela Cruz", "NULL"],
			["4", "Carlos", "Garcia",    "NULL"],
			["6", "Marco",  "Reyes",     "NULL"]
		],
		"result_msg": "3 guests have no email on file.",
		"fail": [
			{ "type": "dialogue", "char": "mgr",  "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That is not right. NULL means the value is missing — it is not a regular word to search for." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE",  "npc": "NPC_occupations/hotel_manager/idle",  "text": "The manager turns back to his desk, waiting." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",    "npc": "NPC_occupations/hotel_manager/idle",  "text": "Right — I need to type NULL after IS to check for missing values." }
		]
	},
	{ "type": "dialogue", "char": "you",   "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Found them! Maya Dela Cruz, Carlos Garcia, and Marco Reyes have no email. We can reach them by phone." },
	{ "type": "dialogue", "char": "mgr",   "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Perfect. IS NULL is a powerful tool for finding gaps in our data. Good thinking." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 9 — PRIMARY KEY  |  NPC: adult_13 (new trainee)
#  Topic: CREATE TABLE with PRIMARY KEY constraint
# ─────────────────────────────────────────────
9: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "adult_13/idle",
	  "text": "A new trainee joins you at the front desk. They want to understand how the guest table was originally set up." },
	{ "type": "dialogue", "char": "guest",  "name": "TRAINEE",
	  "npc": "adult_13/talk",
	  "text": "Can you show me how a table is created in SQL? Especially the id column — what makes it different from the others?" },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_13/idle",
	  "text": "Sure! When we CREATE TABLE, we add a special constraint to the id column called PRIMARY KEY. It forces every id to be unique and never empty. Let me show you." },
	{
		"type": "sql_fill",
		"gamemode": "create_table",
		"desc": "Complete the CREATE TABLE statement for the guests table. The 'id' column must be the PRIMARY KEY — type it in the blank.",
		"table": "guests",
		"pk_col": "id",
		"columns": [
			["id",         "INT"],
			["first_name", "TEXT"],
			["last_name",  "TEXT"],
			["email",      "TEXT"]
		],
		"answer": "PRIMARY KEY",
		"hint": "The constraint that makes a column unique for every row is: PRIMARY KEY",
		"result_msg": "Table created! The PRIMARY KEY on 'id' means no two guests can share the same id, and id can never be left empty.",
		"fail": [
			{ "type": "dialogue", "char": "guest",  "name": "TRAINEE", "npc": "adult_13/confuse", "text": "That is not right. The constraint name has two words — PRIMARY and KEY." },
			{ "type": "dialogue", "char": "scene",  "name": "SCENE",   "npc": "adult_13/idle",    "text": "The trainee watches the screen carefully, waiting." },
			{ "type": "dialogue", "char": "you",    "name": "YOU",     "npc": "adult_13/idle",    "text": "Let me type the constraint correctly — PRIMARY KEY." }
		]
	},
	{ "type": "dialogue", "char": "guest",  "name": "TRAINEE",
	  "npc": "adult_13/talk",
	  "text": "So PRIMARY KEY goes right after the column type! And it means that column will always be unique. Got it!" },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_13/idle",
	  "text": "Exactly. Every table should have a PRIMARY KEY so the database can always tell rows apart." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 10 — JOIN  |  NPC: hotel_manager
#  Topic: FOREIGN KEY / JOIN — combining two tables
# ─────────────────────────────────────────────
10: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager needs a combined report of guest names and their room bookings — from two separate tables." },
	{ "type": "dialogue", "char": "mgr",    "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Our guest info and booking info are in different tables. Can you JOIN them so I can see everything in one report?" },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Sure! A JOIN combines two tables using a shared column — the guests.id links to bookings.guest_id. That linking column in bookings is called a Foreign Key." },
	{
		"type": "sql_fill",
		"gamemode": "join",
		"desc": "JOIN the guests table with the bookings table. The guests 'id' column links to the bookings 'guest_id' column. Fill in both column names.",
		"table_a": "guests",
		"table_b": "bookings",
		"table_a_headers": ["id", "first_name", "last_name"],
		"table_a_rows": [
			["1", "Alex",   "Santos"],
			["2", "Maya",   "Dela Cruz"],
			["3", "Jose",   "Hernandez"],
			["4", "Carlos", "Garcia"]
		],
		"table_b_headers": ["id", "guest_id", "room_type", "check_in"],
		"table_b_rows": [
			["1", "1", "Standard", "June 1"],
			["2", "3", "Deluxe",   "June 5"],
			["3", "2", "Suite",    "June 8"],
			["4", "4", "Standard", "June 12"]
		],
		"join_col_a": "id",
		"join_col_b": "guest_id",
		"hint": "Table A linking column: id | Table B linking column: guest_id",
		"result_headers": ["first_name", "last_name", "room_type", "check_in"],
		"result_rows": [
			["Alex",   "Santos",    "Standard", "June 1"],
			["Maya",   "Dela Cruz", "Suite",    "June 8"],
			["Jose",   "Hernandez", "Deluxe",   "June 5"],
			["Carlos", "Garcia",    "Standard", "June 12"]
		],
		"result_msg": "4 records joined successfully.",
		"fail": [
			{ "type": "dialogue", "char": "mgr",   "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "The JOIN failed! Check which column in guests links to which column in bookings." },
			{ "type": "dialogue", "char": "scene",  "name": "SCENE",  "npc": "NPC_occupations/hotel_manager/idle",  "text": "The manager taps the two table headers on the screen with a finger." },
			{ "type": "dialogue", "char": "you",    "name": "YOU",    "npc": "NPC_occupations/hotel_manager/idle",  "text": "I see — guests.id must equal bookings.guest_id. Let me type those correctly." }
		]
	},
	{ "type": "dialogue", "char": "you",   "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Done! The JOIN combined both tables using the guest id. Now you can see each guest's name next to their booking." },
	{ "type": "dialogue", "char": "mgr",   "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Excellent. JOIN is one of the most important SQL tools — it lets us connect data spread across multiple tables." },
	{ "type": "end" }
]

} # end LESSONS
