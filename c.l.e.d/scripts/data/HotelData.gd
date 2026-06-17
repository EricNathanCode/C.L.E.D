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
#  LESSON 9 — CREATE DATABASE  |  NPC: adult_13 (new trainee)
#  Topic: CREATE DATABASE — setting up the database container first
# ─────────────────────────────────────────────
9: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "adult_13/idle",
	  "text": "A new hotel staff trainee arrives on their first day. Before touching any records, they want to understand where all the data actually lives." },
	{ "type": "dialogue", "char": "guest",  "name": "TRAINEE",
	  "npc": "adult_13/talk",
	  "text": "I know commands like SELECT and INSERT. But how was this whole system set up in the first place? Where does the data actually come from?" },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_13/idle",
	  "text": "It all starts with a DATABASE. Before creating any tables, you run CREATE DATABASE to reserve a named space where all your tables will live." },
	{
		"type": "sql_fill",
		"gamemode": "create_database",
		"desc": "Create the hotel database. Type the missing keyword between CREATE and HotelDB.",
		"db_name": "HotelDB",
		"answer": "DATABASE",
		"hint": "The keyword after CREATE for a new database container is: DATABASE",
		"result_msg": "HotelDB is now created! This container will hold all hotel tables — guests, bookings, and more.",
		"fail": [
			{ "type": "dialogue", "char": "guest",  "name": "TRAINEE", "npc": "adult_13/confuse", "text": "That is not the right keyword. We are creating a DATABASE — not a table yet." },
			{ "type": "dialogue", "char": "scene",  "name": "SCENE",   "npc": "adult_13/idle",    "text": "The trainee looks at the screen curiously." },
			{ "type": "dialogue", "char": "you",    "name": "YOU",     "npc": "adult_13/idle",    "text": "The correct keyword is DATABASE — CREATE DATABASE HotelDB." }
		]
	},
	{ "type": "dialogue", "char": "guest",  "name": "TRAINEE",
	  "npc": "adult_13/talk",
	  "text": "So CREATE DATABASE is the very first step! Everything else — the tables, the rows — all goes inside this database container." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_13/idle",
	  "text": "Exactly. Think of a database as a filing cabinet. You create the cabinet first, then add the folders — the tables — inside it." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 10 — CREATE TABLE  |  NPC: adult_13 (trainee)
#  Topic: CREATE TABLE — defining the table structure
# ─────────────────────────────────────────────
10: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "adult_13/idle",
	  "text": "The trainee continues their onboarding. Now that the database exists, they want to see how the guest table itself was built." },
	{ "type": "dialogue", "char": "guest",  "name": "TRAINEE",
	  "npc": "adult_13/talk",
	  "text": "We created the database. But where do the actual rows of guest data go? How are the columns defined?" },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_13/idle",
	  "text": "Inside the database, we use CREATE TABLE to define a table — giving it a name and listing its columns with their types. Let me show you." },
	{
		"type": "sql_fill",
		"gamemode": "create_table_keyword",
		"desc": "Create the guests table inside HotelDB. Type the missing keyword between CREATE and guests.",
		"table": "guests",
		"columns": [
			["id",         "INT"],
			["first_name", "TEXT"],
			["last_name",  "TEXT"],
			["email",      "TEXT"]
		],
		"answer": "TABLE",
		"hint": "The keyword after CREATE for a new table is: TABLE",
		"result_msg": "guests table created! The table has 4 columns: id, first_name, last_name, and email. Every guest record will follow this structure.",
		"fail": [
			{ "type": "dialogue", "char": "guest",  "name": "TRAINEE", "npc": "adult_13/confuse", "text": "That is not right. We are creating a TABLE inside the database — not a DATABASE again." },
			{ "type": "dialogue", "char": "scene",  "name": "SCENE",   "npc": "adult_13/idle",    "text": "The trainee looks back at their notes." },
			{ "type": "dialogue", "char": "you",    "name": "YOU",     "npc": "adult_13/idle",    "text": "The keyword is TABLE — CREATE TABLE guests." }
		]
	},
	{ "type": "dialogue", "char": "guest",  "name": "TRAINEE",
	  "npc": "adult_13/talk",
	  "text": "So CREATE TABLE defines the columns! And each column has a name and a type — like id is INT and first_name is TEXT." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_13/idle",
	  "text": "Exactly. Once you CREATE TABLE, the structure is fixed and you can INSERT rows into it." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 11 — PRIMARY KEY  |  NPC: adult_13 (new trainee)
#  Topic: CREATE TABLE with PRIMARY KEY constraint
# ─────────────────────────────────────────────
11: [
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
#  LESSON 12 — JOIN  |  NPC: hotel_manager
#  Topic: FOREIGN KEY / JOIN — combining two tables
# ─────────────────────────────────────────────
12: [
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
],

# ─────────────────────────────────────────────
#  LESSON 13 — INT  |  NPC: adult_13 (trainee)
#  Topic: Data Type INT — whole numbers
# ─────────────────────────────────────────────
13: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "adult_13/idle",
	  "text": "The trainee is still curious about the column definitions in the guests table." },
	{ "type": "dialogue", "char": "guest",  "name": "TRAINEE",
	  "npc": "adult_13/talk",
	  "text": "What does INT mean next to the id column? Why not just call everything TEXT?" },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_13/idle",
	  "text": "INT stands for Integer — a whole number, no decimals. We use INT for things like IDs, room numbers, and counts because we never need 2.5 of a guest." },
	{
		"type": "sql_fill",
		"gamemode": "data_type",
		"desc": "Define the guests table. The 'id' column stores a whole number. Fill in the correct data type.",
		"table": "guests",
		"columns": [
			["id",         ""],
			["first_name", "TEXT"],
			["last_name",  "TEXT"],
			["email",      "TEXT"]
		],
		"blank_col": "id",
		"answer": "INT",
		"type_hint": "Whole numbers (IDs, counts) use INT.",
		"hint": "A whole number data type (no decimals) is: INT",
		"result_msg": "Correct! INT stores whole numbers — 1, 2, 42, 100. Perfect for IDs because a guest is always guest #3, never guest #3.5.",
		"fail": [
			{ "type": "dialogue", "char": "guest",  "name": "TRAINEE", "npc": "adult_13/confuse", "text": "That is not right. The id column holds a whole number — no letters, no decimals." },
			{ "type": "dialogue", "char": "scene",  "name": "SCENE",   "npc": "adult_13/idle",    "text": "The trainee taps the id column header." },
			{ "type": "dialogue", "char": "you",    "name": "YOU",     "npc": "adult_13/idle",    "text": "Whole numbers use INT — integer." }
		]
	},
	{ "type": "dialogue", "char": "guest",  "name": "TRAINEE",
	  "npc": "adult_13/talk",
	  "text": "INT means integer — a whole number! So id = 7 is fine, but id = 7.5 would be rejected by the database." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_13/idle",
	  "text": "Exactly. Choosing the right data type protects your data from mistakes." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 14 — TEXT  |  NPC: adult_13 (trainee)
#  Topic: Data Type TEXT — strings / words
# ─────────────────────────────────────────────
14: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "adult_13/idle",
	  "text": "The trainee asks about the other data type they saw in the guests table." },
	{ "type": "dialogue", "char": "guest",  "name": "TRAINEE",
	  "npc": "adult_13/talk",
	  "text": "I see TEXT next to first_name and email. When do I use TEXT instead of INT?" },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_13/idle",
	  "text": "TEXT stores letters, words, or any mix of characters — names, emails, addresses. Anything that is not a pure number." },
	{
		"type": "sql_fill",
		"gamemode": "data_type",
		"desc": "Define the guests table. The 'first_name' column stores a person's name. Fill in the correct data type.",
		"table": "guests",
		"columns": [
			["id",         "INT"],
			["first_name", ""],
			["last_name",  "TEXT"],
			["email",      "TEXT"]
		],
		"blank_col": "first_name",
		"answer": "TEXT",
		"type_hint": "Names and words use TEXT (also called STRING).",
		"hint": "Letters and words use: TEXT  (also called STRING)",
		"result_msg": "Correct! TEXT stores any sequence of characters — 'Alex', 'Santos', 'alex@mail.com'. You can also type STRING and it means the same thing.",
		"fail": [
			{ "type": "dialogue", "char": "guest",  "name": "TRAINEE", "npc": "adult_13/confuse", "text": "That is not right. first_name stores letters — a person's name, not a number." },
			{ "type": "dialogue", "char": "scene",  "name": "SCENE",   "npc": "adult_13/idle",    "text": "The trainee thinks for a moment." },
			{ "type": "dialogue", "char": "you",    "name": "YOU",     "npc": "adult_13/idle",    "text": "Anything with letters uses TEXT — also called STRING in some databases." }
		]
	},
	{ "type": "dialogue", "char": "guest",  "name": "TRAINEE",
	  "npc": "adult_13/talk",
	  "text": "TEXT for words, INT for whole numbers. So 'Alex' is TEXT and 42 is INT. Got it!" },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_13/idle",
	  "text": "Right. Some databases call it VARCHAR or STRING — they all mean the same thing as TEXT." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 15 — REAL  |  NPC: hotel_manager
#  Topic: Data Type REAL — decimal / float numbers
# ─────────────────────────────────────────────
15: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager asks you to create a bookings table that tracks nightly rates — prices with decimal values." },
	{ "type": "dialogue", "char": "mgr",    "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "The price_per_night column needs to store values like 89.50 and 120.00. What data type handles decimals?" },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "REAL handles decimal numbers — prices, measurements, percentages. It stores values like 89.50 accurately, unlike INT which would round them." },
	{
		"type": "sql_fill",
		"gamemode": "data_type",
		"desc": "Define the bookings table. The 'price_per_night' column stores a price with decimals. Fill in the correct data type.",
		"table": "bookings",
		"columns": [
			["id",              "INT"],
			["guest_id",        "INT"],
			["room_type",       "TEXT"],
			["price_per_night", ""]
		],
		"blank_col": "price_per_night",
		"answer": "REAL",
		"type_hint": "Decimal numbers (prices, measurements) use REAL (also called FLOAT).",
		"hint": "Decimal numbers use: REAL  (also called FLOAT)",
		"result_msg": "Correct! REAL stores decimal numbers — 89.50, 120.00, 9.99. You can also type FLOAT and it means the same thing.",
		"fail": [
			{ "type": "dialogue", "char": "mgr",   "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That is wrong! price_per_night stores decimal values like 89.50 — not whole numbers, not text." },
			{ "type": "dialogue", "char": "scene",  "name": "SCENE",  "npc": "NPC_occupations/hotel_manager/idle",  "text": "The manager points at a price list on the desk." },
			{ "type": "dialogue", "char": "you",    "name": "YOU",    "npc": "NPC_occupations/hotel_manager/idle",  "text": "Decimal numbers use REAL — also called FLOAT in some databases." }
		]
	},
	{ "type": "dialogue", "char": "mgr",   "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "REAL for decimals! So INT for room numbers, TEXT for names, REAL for prices. The right type for each kind of data." },
	{ "type": "dialogue", "char": "you",   "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Exactly. Some databases use FLOAT or DOUBLE — they all store decimal numbers. REAL is the most common in SQLite." },
	{ "type": "end" }
]

,

# ─────────────────────────────────────────────
#  LESSON 16 — SELECT DISTINCT  |  NPC: hotel_manager
# ─────────────────────────────────────────────
16: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The hotel manager is preparing a room availability report and needs a list of unique room types." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Our bookings table has hundreds of rows but only three room types. I need each type listed once — no duplicates." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "SELECT DISTINCT returns only unique values in a column — duplicates are automatically removed." },
	{ "type": "sql_fill", "gamemode": "select_distinct",
	  "desc": "Return only the unique room types from the bookings table. Fill in the column name after SELECT DISTINCT.",
	  "table": "bookings",
	  "column": "room_type",
	  "table_headers": ["id","guest_id","room_type","check_in"],
	  "table_rows": [["1","1","Standard","June 1"],["2","2","Deluxe","June 3"],["3","3","Standard","June 4"],["4","4","Suite","June 5"],["5","5","Deluxe","June 6"],["6","6","Standard","June 7"]],
	  "hint": "The column with repeating values to deduplicate: room_type",
	  "result_headers": ["room_type"],
	  "result_rows": [["Standard"],["Deluxe"],["Suite"]],
	  "result_msg": "3 unique room types found. DISTINCT removed duplicate 'Standard' and 'Deluxe' entries.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That column does not exist in the bookings table!" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "The column with repeated room names is: room_type." }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Standard, Deluxe, Suite. DISTINCT is perfect when I only want to know what values exist, not how many times each appears." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Exactly. Without DISTINCT you would get 'Standard' three times. DISTINCT returns each value once." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 17 — AND/OR  |  NPC: hotel_manager
# ─────────────────────────────────────────────
17: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager needs to find VIP guests who also have an active booking — both conditions must be true." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "I need guests who are VIP status AND have a booking. Not just one or the other — both must apply." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "AND requires both conditions to be true at the same time. OR would include guests with either condition." },
	{ "type": "sql_fill", "gamemode": "where_and_or",
	  "desc": "Find guests who are VIP status AND have a booking. Fill in AND or OR.",
	  "table": "guests",
	  "condition1": "status = 'VIP'",
	  "condition2": "has_booking = 'Yes'",
	  "answer": "AND",
	  "table_headers": ["id","first_name","status","has_booking"],
	  "table_rows": [["1","Alex","VIP","Yes"],["2","Maya","Regular","Yes"],["3","Jose","VIP","No"],["4","Carlos","VIP","Yes"],["5","Linda","Regular","No"]],
	  "hint": "Both conditions must be true simultaneously: AND",
	  "result_headers": ["id","first_name","status","has_booking"],
	  "result_rows": [["1","Alex","VIP","Yes"],["4","Carlos","VIP","Yes"]],
	  "result_msg": "2 VIP guests with active bookings. AND requires BOTH conditions. OR would return 4 rows.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "Wrong connector! That gave too many results. I need BOTH conditions true at once." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "For both conditions required: AND." }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Only Alex and Carlos — the ones who are both VIP and have a booking. AND is strict." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Right. OR would include Jose who is VIP but has no booking, and Maya who has a booking but is not VIP." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 18 — BETWEEN  |  NPC: hotel_manager
# ─────────────────────────────────────────────
18: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager wants to find mid-range bookings — not the cheapest rooms, not the most expensive." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "I need bookings where the price per night is between 100 and 300. Both 100 and 300 should be included." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "BETWEEN filters a range inclusively. 'BETWEEN 100 AND 300' means price >= 100 AND price <= 300." },
	{ "type": "sql_fill", "gamemode": "where_between",
	  "desc": "Find bookings where price_per_night is between 100 and 300. Fill in the range keyword.",
	  "table": "bookings",
	  "column": "price_per_night",
	  "low": "100", "high": "300",
	  "answer": "BETWEEN",
	  "table_headers": ["id","room_type","price_per_night"],
	  "table_rows": [["1","Standard","85"],["2","Deluxe","150"],["3","Suite","350"],["4","Standard","95"],["5","Deluxe","220"],["6","Suite","400"],["7","Standard","110"]],
	  "hint": "The range filtering keyword is: BETWEEN",
	  "result_headers": ["id","room_type","price_per_night"],
	  "result_rows": [["2","Deluxe","150"],["5","Deluxe","220"],["7","Standard","110"]],
	  "result_msg": "3 bookings in the 100-300 range. BETWEEN is inclusive — 100 and 300 themselves would also match.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That is not the range keyword! I need BETWEEN to filter inclusive ranges." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "The inclusive range keyword is BETWEEN." }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "3 mid-range bookings. BETWEEN is much cleaner than writing 'price >= 100 AND price <= 300'." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Exactly. BETWEEN also works with dates: WHERE check_in BETWEEN '2024-01-01' AND '2024-12-31'." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 19 — LIKE  |  NPC: hotel_manager
# ─────────────────────────────────────────────
19: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "A family reunion group with surnames starting with S has made multiple bookings. The manager needs to find them all." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Can you find all guests whose last name starts with the letter S? LIKE can help with partial text matching." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "LIKE uses % as a wildcard. 'S%' means starts with S, followed by any characters. '%S%' would find S anywhere." },
	{ "type": "sql_fill", "gamemode": "where_like",
	  "desc": "Find all guests whose last_name starts with 'S'. Fill in the LIKE pattern.",
	  "table": "guests",
	  "column": "last_name",
	  "answer": "'S%'",
	  "table_headers": ["id","first_name","last_name"],
	  "table_rows": [["1","Alex","Santos"],["2","Maya","Dela Cruz"],["3","Jose","Hernandez"],["4","Carlos","Santos"],["5","Linda","Sim"],["6","Marco","Reyes"]],
	  "hint": "Starts with S then any characters: 'S%'",
	  "result_headers": ["id","first_name","last_name"],
	  "result_rows": [["1","Alex","Santos"],["4","Carlos","Santos"],["5","Linda","Sim"]],
	  "result_msg": "3 guests found. 'S%' = starts with S, then anything. Santos and Sim both match.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That pattern did not match the right guests. Remember % means any characters." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "For names starting with S: 'S%'" }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Alex Santos, Carlos Santos, and Linda Sim. The % wildcard is powerful for partial text searches." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "And '_im' would match exactly one character before 'im'. 'Sim' and 'Kim' would match, but 'Slim' would not." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 20 — IN  |  NPC: hotel_manager
# ─────────────────────────────────────────────
20: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager wants bookings for Standard and Deluxe rooms only — Suite rooms are excluded from this report." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "I need bookings for Standard and Deluxe. Instead of writing two OR conditions, is there a shorter way?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Yes — IN lets you check if a value matches any item in a list. It is cleaner than multiple OR conditions." },
	{ "type": "sql_fill", "gamemode": "where_in",
	  "desc": "Find bookings where room_type is Standard or Deluxe. Fill in the list membership keyword.",
	  "table": "bookings",
	  "column": "room_type",
	  "in_list": "('Standard', 'Deluxe')",
	  "answer": "IN",
	  "table_headers": ["id","room_type","price_per_night"],
	  "table_rows": [["1","Standard","85"],["2","Deluxe","150"],["3","Suite","350"],["4","Standard","95"],["5","Deluxe","220"],["6","Suite","400"]],
	  "hint": "The list membership keyword is: IN",
	  "result_headers": ["id","room_type","price_per_night"],
	  "result_rows": [["1","Standard","85"],["2","Deluxe","150"],["4","Standard","95"],["5","Deluxe","220"]],
	  "result_msg": "4 bookings found. IN ('Standard','Deluxe') equals: room_type='Standard' OR room_type='Deluxe'.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That keyword is wrong. The list matching keyword is IN." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "The keyword for list matching is IN." }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "4 non-Suite bookings. IN with a list is much cleaner than chaining OR conditions." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "IN also works with numbers: WHERE id IN (1, 3, 5). You can also use NOT IN to exclude values." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 21 — LIMIT  |  NPC: hotel_manager
# ─────────────────────────────────────────────
21: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager wants a quick preview of recent guest records — not all 500 rows, just the first few." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "I just need a sample of the guests table to verify the data format. Show me only the first 5 rows." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "LIMIT restricts how many rows a query returns. It is especially useful for previewing large tables." },
	{ "type": "sql_fill", "gamemode": "limit",
	  "desc": "Return only the first 5 rows from the guests table. Type the number after LIMIT.",
	  "table": "guests",
	  "answer": "5",
	  "table_headers": ["id","first_name","last_name","email"],
	  "table_rows": [["1","Alex","Santos","alex@mail.com"],["2","Maya","Dela Cruz","maya@mail.com"],["3","Jose","Hernandez","jose@mail.com"],["4","Carlos","Garcia","carlos@mail.com"],["5","Linda","Lim","linda@mail.com"],["6","Marco","Reyes","marco@mail.com"],["7","Ana","Torres","ana@mail.com"]],
	  "hint": "Show only 5 rows — type the number: 5",
	  "result_headers": ["id","first_name","last_name","email"],
	  "result_rows": [["1","Alex","Santos","alex@mail.com"],["2","Maya","Dela Cruz","maya@mail.com"],["3","Jose","Hernandez","jose@mail.com"],["4","Carlos","Garcia","carlos@mail.com"],["5","Linda","Lim","linda@mail.com"]],
	  "result_msg": "5 rows returned. Rows 6 and 7 were not fetched. LIMIT saves time on large tables.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That is not 5 rows. Type the number 5." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "Type the number 5 after LIMIT." }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "5 rows only — much faster. LIMIT is great with ORDER BY to get the top or bottom N records." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "For example: SELECT * FROM guests ORDER BY id DESC LIMIT 3 gives the 3 most recently added guests." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 22 — COUNT/SUM/AVG  |  NPC: hotel_manager
# ─────────────────────────────────────────────
22: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Quarter-end report time. The manager needs a total count of all registered guests." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "How many guests do we have in the system? I need a single number — not a list." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "COUNT is an aggregate function — it collapses many rows into a single calculated value." },
	{ "type": "sql_fill", "gamemode": "aggregate",
	  "desc": "Count the total number of guests. Fill in the aggregate function name.",
	  "table": "guests",
	  "column": "id",
	  "answer": "COUNT",
	  "table_headers": ["id","first_name","last_name"],
	  "table_rows": [["1","Alex","Santos"],["2","Maya","Dela Cruz"],["3","Jose","Hernandez"],["4","Carlos","Garcia"],["5","Linda","Lim"],["6","Marco","Reyes"]],
	  "hint": "To count the number of rows: COUNT",
	  "result_headers": ["COUNT(id)"],
	  "result_rows": [["6"]],
	  "result_msg": "6 guests total.\n\nOther aggregate functions:\n- SUM(price) adds all values\n- AVG(price) calculates the average\n- MIN/MAX finds smallest or largest value",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That is not a valid aggregate function. To count rows use COUNT." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "The counting aggregate function is COUNT." }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "6 guests. Aggregate functions like COUNT, SUM, and AVG are essential for reports and analysis." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Right. SELECT SUM(price_per_night) FROM bookings gives total revenue. AVG gives the average nightly rate." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 23 — HAVING  |  NPC: hotel_manager
# ─────────────────────────────────────────────
23: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager wants to know which room types have been booked more than once — popular rooms for promotions." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "I need room types with more than 1 booking. But WHERE cannot filter on GROUP BY results. What do I use?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "HAVING filters AFTER grouping. WHERE filters individual rows before grouping. HAVING works on group results." },
	{ "type": "sql_fill", "gamemode": "having",
	  "desc": "Show only room types booked more than once. Fill in the aggregate function in HAVING.",
	  "table": "bookings",
	  "group_col": "room_type",
	  "answer": "COUNT",
	  "table_headers": ["id","room_type","guest_id"],
	  "table_rows": [["1","Standard","1"],["2","Deluxe","2"],["3","Standard","3"],["4","Suite","4"],["5","Deluxe","5"],["6","Standard","6"]],
	  "hint": "HAVING uses the aggregate function: COUNT",
	  "result_headers": ["room_type","COUNT(*)"],
	  "result_rows": [["Standard","3"],["Deluxe","2"]],
	  "result_msg": "Standard (3) and Deluxe (2) appear more than once. Suite had only 1 booking so it was filtered out.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "Wrong function. HAVING uses COUNT here to check group size." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "HAVING filters groups using COUNT." }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Standard and Deluxe are most popular! HAVING is just like WHERE but it runs after GROUP BY." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Exactly. WHERE cannot reference COUNT(*) because groups do not exist yet when WHERE runs." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 24 — AS (Aliases)  |  NPC: hotel_manager
# ─────────────────────────────────────────────
24: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager wants a report showing prices with tax, but the column name should be readable." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "The column 'price_per_night * 1.12' shows up as just that expression in the report. Can we rename it?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "AS gives a column a friendly display name called an alias. The table itself is unchanged." },
	{ "type": "sql_fill", "gamemode": "select_alias",
	  "desc": "Rename the calculated column to 'price_with_tax'. Fill in the alias name after AS.",
	  "table": "bookings",
	  "col_expr": "price_per_night * 1.12",
	  "answer": "price_with_tax",
	  "table_headers": ["id","room_type","price_per_night"],
	  "table_rows": [["1","Standard","100"],["2","Deluxe","200"],["3","Suite","300"]],
	  "hint": "The alias name for the tax column: price_with_tax",
	  "result_headers": ["price_with_tax"],
	  "result_rows": [["112.0"],["224.0"],["336.0"]],
	  "result_msg": "Column now displays as 'price_with_tax' in results. AS only affects output — the table is unchanged.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That alias is not right. The alias should be: price_with_tax" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "Type the alias: price_with_tax" }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Clean! AS also works on table names in JOINs: FROM bookings AS b — useful in long queries." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Right. Short aliases like 'b' or 'g' keep JOIN queries readable when referencing multiple tables." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 25 — NOT NULL + UNIQUE  |  NPC: adult_13 trainee
# ─────────────────────────────────────────────
25: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "adult_13/idle",
	  "text": "The new trainee is helping set up the guest registration table and asks about preventing bad data." },
	{ "type": "dialogue", "char": "trainee", "name": "TRAINEE", "npc": "adult_13/talk",
	  "text": "What if someone registers a guest without a phone number? Or two guests with the same email? Can we block that?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_13/idle",
	  "text": "Column constraints! NOT NULL prevents empty values. UNIQUE prevents duplicates. Let me show you." },
	{ "type": "sql_fill", "gamemode": "create_table",
	  "desc": "The phone column must always have a value. Add the NOT NULL constraint.",
	  "table": "contacts",
	  "pk_col": "phone",
	  "columns": [["id","INT PRIMARY KEY"],["name","TEXT"],["phone","TEXT"]],
	  "answer": "NOT NULL",
	  "blank_hint": "constraint",
	  "error_hint": "The constraint that prevents empty values is NOT NULL.",
	  "result_msg": "NOT NULL added! Any INSERT that omits the phone column will now be rejected by the database.",
	  "hint": "Prevent empty values: NOT NULL",
	  "fail": [
		{ "type": "dialogue", "char": "trainee", "name": "TRAINEE", "npc": "adult_13/confuse", "text": "That is not right. The constraint that prevents NULL is NOT NULL." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_13/idle", "text": "Type: NOT NULL" }
	  ]
	},
	{ "type": "dialogue", "char": "trainee", "name": "TRAINEE", "npc": "adult_13/talk",
	  "text": "NOT NULL — phone is mandatory. What about preventing two guests from using the same email?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_13/idle",
	  "text": "That is the UNIQUE constraint — no two rows can have the same value in that column." },
	{ "type": "sql_fill", "gamemode": "create_table",
	  "desc": "The email column must be unique. Add the UNIQUE constraint.",
	  "table": "guests",
	  "pk_col": "email",
	  "columns": [["id","INT PRIMARY KEY"],["first_name","TEXT"],["email","TEXT"]],
	  "answer": "UNIQUE",
	  "blank_hint": "constraint",
	  "error_hint": "The constraint that prevents duplicate values is UNIQUE.",
	  "result_msg": "UNIQUE added! The database will now reject any INSERT that reuses an existing email address.",
	  "hint": "Prevent duplicate values: UNIQUE",
	  "fail": [
		{ "type": "dialogue", "char": "trainee", "name": "TRAINEE", "npc": "adult_13/confuse", "text": "Not right. The constraint that prevents duplicates is UNIQUE." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_13/idle", "text": "Type: UNIQUE" }
	  ]
	},
	{ "type": "dialogue", "char": "trainee", "name": "TRAINEE", "npc": "adult_13/talk",
	  "text": "NOT NULL = must have a value. UNIQUE = no duplicates. Two constraints that keep data clean!" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_13/idle",
	  "text": "You can even combine them: email TEXT NOT NULL UNIQUE — must have a value AND must be unique." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 26 — ALTER TABLE  |  NPC: hotel_manager
# ─────────────────────────────────────────────
26: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The hotel system went live without a check_out column in the bookings table. It needs to be added." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "We forgot the check_out date! Can we add it to the existing table without losing all the current data?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "ALTER TABLE lets you modify a table after creation. The ADD keyword adds a new column safely." },
	{ "type": "sql_fill", "gamemode": "alter_table",
	  "desc": "Add the check_out column to the bookings table. Fill in the keyword that adds a column.",
	  "table": "bookings",
	  "new_col": "check_out",
	  "col_type": "TEXT",
	  "answer": "ADD",
	  "hint": "The keyword to add a column to an existing table: ADD",
	  "result_msg": "check_out column added! All existing rows still have their data — ALTER TABLE is non-destructive.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That keyword is wrong. To add a column use: ALTER TABLE name ADD column type" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "The keyword is ADD." }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Column added and all existing bookings are safe! ALTER TABLE is how we evolve a database over time." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "You can also use ALTER TABLE to RENAME COLUMN or DROP COLUMN to remove a column entirely." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 27 — DROP TABLE  |  NPC: hotel_manager
# ─────────────────────────────────────────────
27: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The renovation is over and the temporary waitlist table is no longer needed." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "The temp_waitlist table was only for the renovation period. Can we remove it completely from the database?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "DROP TABLE permanently deletes a table — every column definition and every row of data. It cannot be undone." },
	{ "type": "sql_fill", "gamemode": "drop_table",
	  "desc": "Delete the temp_waitlist table permanently. Fill in the keyword after DROP.",
	  "table": "temp_waitlist",
	  "answer": "TABLE",
	  "hint": "The keyword after DROP to remove a table: TABLE",
	  "result_msg": "temp_waitlist dropped! The table and all its data are gone permanently. Always back up before dropping.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That keyword is wrong. To delete a table: DROP TABLE name" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "The keyword is TABLE." }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Gone! DROP TABLE is final. DROP DATABASE removes the entire database with all its tables." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Always use IF EXISTS to avoid errors: DROP TABLE IF EXISTS temp_waitlist — safe even if it does not exist." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 28 — LEFT JOIN  |  NPC: hotel_manager
# ─────────────────────────────────────────────
28: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager wants a complete guest list — including guests who have not made any booking yet." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "A regular JOIN only shows guests WITH bookings. I need ALL guests — unbooked ones should show NULL in booking columns." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "LEFT JOIN returns every row from the left table plus matches from the right. Unmatched right rows become NULL." },
	{ "type": "sql_fill", "gamemode": "join",
	  "join_type": "LEFT JOIN",
	  "desc": "LEFT JOIN guests with bookings. All guests appear even if they have no booking. Fill in the linking column names.",
	  "table_a": "guests", "table_b": "bookings",
	  "table_a_headers": ["id","first_name","last_name"],
	  "table_a_rows": [["1","Alex","Santos"],["2","Maya","Dela Cruz"],["3","Jose","Hernandez"],["4","Carlos","Garcia"]],
	  "table_b_headers": ["id","guest_id","room_type"],
	  "table_b_rows": [["1","1","Standard"],["2","3","Deluxe"]],
	  "join_col_a": "id", "join_col_b": "guest_id",
	  "hint": "guests linking column: id | bookings linking column: guest_id",
	  "result_headers": ["first_name","last_name","room_type"],
	  "result_rows": [["Alex","Santos","Standard"],["Maya","Dela Cruz","NULL"],["Jose","Hernandez","Deluxe"],["Carlos","Garcia","NULL"]],
	  "result_msg": "All 4 guests shown. Maya and Carlos have no booking so room_type is NULL. INNER JOIN would hide them.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "Check the linking columns! guests.id connects to bookings.guest_id." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "Left column: id | Right column: guest_id" }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "All 4 guests visible! Maya and Carlos show NULL for room_type — LEFT JOIN keeps the full left table." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "INNER JOIN = only matches. LEFT JOIN = all left rows + matches. RIGHT JOIN = all right rows + matches." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 29 — DEFAULT  |  NPC: adult_13 trainee
# ─────────────────────────────────────────────
29: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "adult_13/idle",
	  "text": "The trainee is setting up the bookings table and asks about automatic values." },
	{ "type": "dialogue", "char": "trainee", "name": "TRAINEE", "npc": "adult_13/talk",
	  "text": "If someone creates a booking without entering a status, what should it be automatically? Can we set that?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_13/idle",
	  "text": "Yes! DEFAULT sets an automatic value that is used when no value is provided on INSERT." },
	{ "type": "sql_fill", "gamemode": "create_table",
	  "desc": "Set status to automatically be 'Pending' when not specified. Type: DEFAULT 'Pending'",
	  "table": "bookings",
	  "pk_col": "status",
	  "columns": [["id","INT PRIMARY KEY"],["guest_id","INT"],["room_type","TEXT"],["status","TEXT"]],
	  "answer": "DEFAULT 'Pending'",
	  "blank_hint": "constraint",
	  "error_hint": "The syntax for a default value is: DEFAULT 'value'",
	  "result_msg": "DEFAULT 'Pending' set! Any INSERT that omits status will automatically store 'Pending'.",
	  "hint": "Auto-value when none given: DEFAULT 'Pending'",
	  "fail": [
		{ "type": "dialogue", "char": "trainee", "name": "TRAINEE", "npc": "adult_13/confuse", "text": "That is not right. DEFAULT sets an automatic value — like DEFAULT 'Pending'." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_13/idle", "text": "Type: DEFAULT 'Pending'" }
	  ]
	},
	{ "type": "dialogue", "char": "trainee", "name": "TRAINEE", "npc": "adult_13/talk",
	  "text": "So DEFAULT is like a fallback — only used when the INSERT does not provide a value for that column." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_13/idle",
	  "text": "Exactly. DEFAULT 0 for numbers, DEFAULT CURRENT_TIMESTAMP for automatic timestamps, DEFAULT 'Unknown' for text." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 30 — Normalization  |  NPC: adult_13 trainee
# ─────────────────────────────────────────────
30: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "adult_13/idle",
	  "text": "The trainee found a messy table and wants to understand what went wrong with its design." },
	{ "type": "dialogue", "char": "trainee", "name": "TRAINEE", "npc": "adult_13/talk",
	  "text": "I found a bookings table that stores the guest's full address in every single booking row. Why is that a problem?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_13/idle",
	  "text": "That is data redundancy — the main problem that database normalization solves. Let me ask you a question." },
	{ "type": "sql_choice",
	  "desc": "A bookings table stores guest_name, guest_address, room_type in EVERY booking row. What is the main problem with this design?",
	  "options": [
		[1, "Data redundancy — the guest's address is repeated in every booking, wasting space and causing update problems."],
		[2, "The table has too many columns. Rename some of them to fix it."],
		[3, "The table is missing a LIMIT clause on the SELECT statement."]
	  ],
	  "correct_id": 1,
	  "hint": "Repeated data across multiple rows is called data redundancy. Answer: id = 1",
	  "fail": [
		{ "type": "dialogue", "char": "trainee", "name": "TRAINEE", "npc": "adult_13/confuse", "text": "Not quite. The problem is the same data being stored over and over — redundancy." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_13/idle", "text": "Answer 1 is correct — data redundancy is the problem." }
	  ]
	},
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_13/idle",
	  "text": "Normalization fixes this by splitting data into related tables. Guest address belongs in the guests table, not bookings." },
	{ "type": "dialogue", "char": "trainee", "name": "TRAINEE", "npc": "adult_13/talk",
	  "text": "So if a guest moves, we update their address in ONE place instead of updating every booking row?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_13/idle",
	  "text": "Exactly! That is 3NF — third normal form. Each piece of data stored once, referenced everywhere else by ID." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 31 — Transactions  |  NPC: hotel_manager
# ─────────────────────────────────────────────
31: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "A system crash happened mid-operation — a guest was being moved between rooms and the data is now inconsistent." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "The old booking was deleted but the new one was never created! The guest has no room. How do we prevent this?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Transactions! BEGIN groups multiple statements together. Either ALL execute (COMMIT) or NONE do (ROLLBACK)." },
	{ "type": "sql_fill", "gamemode": "transaction",
	  "desc": "The booking update is done. Complete the transaction to save the changes permanently.",
	  "update_line": "UPDATE bookings SET room_type = 'Suite' WHERE guest_id = 1",
	  "answer": "COMMIT",
	  "hint": "To save a transaction permanently: COMMIT",
	  "result_msg": "Transaction committed! Both changes are saved as one atomic unit.\n\nACID properties:\n- Atomicity: all or nothing\n- Consistency: rules always maintained\n- Isolation: transactions do not interfere\n- Durability: committed data survives crashes",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That is not right. Type COMMIT to save or ROLLBACK to cancel the transaction." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "Type COMMIT to permanently save the transaction." }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "COMMIT saves everything. If anything fails before COMMIT, ROLLBACK undoes all changes automatically." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "ACID properties make databases reliable for critical operations like banking, medical records, and hotel bookings." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 32 — FOREIGN KEY  |  NPC: hotel_manager
# ─────────────────────────────────────────────
32: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The hotel now has two tables — guests and bookings. The manager wants to make sure every booking belongs to a real guest." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "A FOREIGN KEY links a column in one table to the PRIMARY KEY of another. It prevents orphan rows — bookings that point to guests who don't exist." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "So if I try to insert a booking with a guest_id that isn't in the guests table, the database will reject it?" },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Exactly. The keyword that points to the other table is REFERENCES. Complete the CREATE TABLE statement." },
	{ "type": "sql_fill", "gamemode": "foreign_key",
	  "desc": "Complete the FOREIGN KEY constraint to link bookings.guest_id to the guests table.",
	  "table": "bookings", "fk_col": "guest_id", "ref_table": "guests",
	  "answer": "REFERENCES",
	  "hint": "The keyword that points to another table is REFERENCES.",
	  "result_msg": "FOREIGN KEY created! Every guest_id in bookings must now exist in the guests table.",
	  "fail": [
	    { "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	      "text": "Not quite. After FOREIGN KEY (guest_id), type REFERENCES followed by the table and column you're linking to." }
	  ]
	},
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 33 — Indexes  |  NPC: hotel_manager
# ─────────────────────────────────────────────
33: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The guests table now has thousands of rows. Searching by last name is getting slow." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "An INDEX creates a hidden lookup structure on a column — like a book index. The database skips scanning every row and jumps straight to matches." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Does adding an index change the data in the table?" },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "No — it only affects query speed. The syntax is CREATE INDEX name ON table(column). Try it." },
	{ "type": "sql_fill", "gamemode": "create_index",
	  "desc": "Create an index on the guests table to speed up searches by last_name.",
	  "index_name": "idx_last_name", "table": "guests", "column": "last_name",
	  "answer": "INDEX",
	  "hint": "The keyword after CREATE is INDEX.",
	  "result_msg": "Index created! Searches on last_name will now skip a full table scan.",
	  "fail": [
	    { "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	      "text": "Not quite. The syntax is CREATE INDEX name ON table(column). The keyword after CREATE is INDEX." }
	  ]
	},
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 34 — Views  |  NPC: hotel_manager
# ─────────────────────────────────────────────
34: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The front desk runs the same long SELECT query every morning to list active guests. The manager wants a shortcut." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "A VIEW is a saved SELECT query stored under a name. You query it exactly like a table, but the data always reflects the latest state." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "So it's like an alias for a query — I don't have to rewrite it every time?" },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Exactly. CREATE VIEW name AS SELECT ... — create the view for active guests." },
	{ "type": "sql_fill", "gamemode": "create_view",
	  "desc": "Create a view called vw_active_guests that shows all guests whose status is 'Active'.",
	  "view_name": "vw_active_guests", "select_cols": "*", "table": "guests", "condition": "status = 'Active'",
	  "answer": "VIEW",
	  "hint": "The keyword after CREATE is VIEW.",
	  "result_msg": "View created! SELECT * FROM vw_active_guests now shows all active guests automatically.",
	  "fail": [
	    { "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	      "text": "Not quite. The syntax is CREATE VIEW name AS SELECT ... The keyword after CREATE is VIEW." }
	  ]
	},
	{ "type": "end" }
],


# ─────────────────────────────────────────────
#  LESSON 35 — SUBQUERY  |  NPC: hotel_manager
# ─────────────────────────────────────────────
35: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager pulls up the pricing dashboard. One room stands out but she needs the database to confirm it precisely." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "I need to find the exact booking record that has the highest price — not just sort by it. I want the exact match to the maximum value." },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "That is a subquery — a SELECT nested inside another SELECT. The inner query returns the MAX price, and the outer query uses it as a filter." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/think",
	  "text": "So the database runs the inner part first, gets the number, then uses it in the outer WHERE?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Exactly. WHERE price = (SELECT MAX(price) FROM bookings) — inner runs first, outer filters by the result." },
	{ "type": "sql_fill", "gamemode": "aggregate",
	  "desc": "This inner query runs first and returns the highest price. Fill in the aggregate function.",
	  "hint": "MAX() returns the largest value. The outer query uses this result: WHERE price = (SELECT MAX(price) FROM bookings).",
	  "table": "bookings", "column": "price", "answer": "MAX",
	  "table_headers": ["id", "guest_name", "price"],
	  "table_rows": [["1","Alice","350"],["2","Bob","200"],["3","Carol","350"]],
	  "result_headers": ["MAX(price)"], "result_rows": [["350"]],
	  "result_msg": "MAX(price) = 350. Full subquery: WHERE price = (SELECT MAX(price) FROM bookings) returns every booking that matches the maximum." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Inner query runs first, returns the max value, outer WHERE matches it. Precise and clean." },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Subqueries can also go in the SELECT column list or the FROM clause — any place a value or table is expected." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 36 — CASE WHEN  |  NPC: hotel_manager
# ─────────────────────────────────────────────
36: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The loyalty program needs a tier label on every guest — without adding a new column to the table." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Guests with 5 or more stays are VIP. Two to four stays are Regular. One stay or less is New. Can we add a tier column in the SELECT itself?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Yes — CASE WHEN is SQL's if-else inside a query. It creates a derived column row by row without changing the table." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/think",
	  "text": "So it evaluates each row's stay_count and assigns the matching label dynamically?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Exactly. CASE WHEN condition THEN value WHEN ... ELSE fallback END AS alias — evaluated per row." },
	{ "type": "sql_fill", "gamemode": "select_alias",
	  "desc": "The CASE WHEN expression labels each guest row automatically. Type the alias that names this derived column.",
	  "hint": "Type 'tier' — the alias after AS that gives the CASE WHEN column a readable name.",
	  "table": "guests",
	  "col_expr": "CASE WHEN stay_count >= 5 THEN 'VIP' WHEN stay_count >= 2 THEN 'Regular' ELSE 'New' END",
	  "answer": "tier",
	  "table_headers": ["guest_name", "stay_count"],
	  "table_rows": [["Alice","6"],["Bob","3"],["Carol","1"]],
	  "result_headers": ["guest_name", "tier"],
	  "result_rows": [["Alice","VIP"],["Bob","Regular"],["Carol","New"]],
	  "result_msg": "Each guest gets a tier label — CASE WHEN evaluates every row independently without changing the table." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Each guest row gets its own tier label — no table change needed. CASE WHEN is evaluated fresh per row." },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "CASE WHEN also works inside ORDER BY and UPDATE SET — wherever a value expression is valid in SQL." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 37 — DATE FUNCTIONS  |  NPC: hotel_manager
# ─────────────────────────────────────────────
37: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "End of day. The manager needs a report of guests whose check-out date has already passed but who still have an active status." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "The check_out column stores dates like '2025-06-10'. How do we compare that against today's date in SQL?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "SQL has a built-in date function. In SQLite we use DATE('now') which returns today's date. We compare the column directly against it." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/think",
	  "text": "So WHERE check_out < DATE('now') finds every guest whose due date is in the past?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Exactly. Dates stored as 'YYYY-MM-DD' text compare correctly with < and >. MySQL uses CURDATE(), PostgreSQL uses CURRENT_DATE — same concept." },
	{ "type": "sql_fill", "gamemode": "where_between",
	  "desc": "Date strings in 'YYYY-MM-DD' format compare correctly with SQL range operators. Fill in the keyword that finds check_out dates within a range.",
	  "hint": "BETWEEN checks if a value falls between two bounds. Dates work too: column BETWEEN 'YYYY-MM-DD' AND 'YYYY-MM-DD'.",
	  "table": "bookings", "column": "check_out",
	  "low": "'2025-01-01'", "high": "'2025-06-30'", "answer": "BETWEEN",
	  "table_headers": ["id", "guest_name", "check_out"],
	  "table_rows": [["1","Alice","2025-03-15"],["2","Bob","2025-08-01"],["3","Carol","2025-05-22"]],
	  "result_headers": ["id", "guest_name", "check_out"],
	  "result_rows": [["1","Alice","2025-03-15"],["3","Carol","2025-05-22"]],
	  "result_msg": "BETWEEN filters to dates in the range. Use DATE('now') as the upper bound: WHERE check_out BETWEEN '2025-01-01' AND DATE('now') finds all past check-outs." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "DATE('now', '+3 days') gives three days from now — useful for sending early check-out reminders automatically." },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "And strftime('%Y-%m', check_in) extracts the year-month if you need to group bookings by month." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 38 — GRANT / REVOKE (DCL)  |  NPC: hotel_manager
# ─────────────────────────────────────────────
38: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "A new front-desk clerk starts today. The manager needs to give them limited access to the guest database." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "The clerk should be able to read the guests table — but I do not want them deleting records. How do we control that in SQL?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "That is DCL — Data Control Language. GRANT gives a user a specific permission; REVOKE takes it away. We grant only SELECT." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/think",
	  "text": "So GRANT SELECT lets them read only, and if they misuse it I can REVOKE it later?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Exactly. Permissions are the security layer of a database — each user gets only what their job needs." },
	{ "type": "sql_fill", "gamemode": "sql_blank", "recap": "GRANT / REVOKE",
	  "desc": "Give the clerk permission to read the guests table. Fill in the DCL keyword that grants access.",
	  "hint": "GRANT gives a privilege. REVOKE removes it. We are giving access here.",
	  "prefix": "", "answer": "GRANT", "placeholder": "keyword", "max_length": 8,
	  "suffix": "SELECT ON guests TO clerk;",
	  "err_hint": "To give a permission, the keyword is GRANT.",
	  "result_msg": "Permission granted. The clerk can now read guests. To remove it later: REVOKE SELECT ON guests FROM clerk;" },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "DDL builds the tables, DML changes the data, and DCL controls who is allowed to touch it. Now I see the full picture." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 39 — UNION  |  NPC: hotel_manager
# ─────────────────────────────────────────────
39: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager is planning a mailing list and wants every city the hotel touches — from both guests and staff." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Guest cities are in one table, staff cities in another. Can I get a single combined list of all cities at once?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Yes — UNION stacks the results of two SELECT queries into one list. It even removes duplicate cities automatically." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/think",
	  "text": "And if I wanted to keep duplicates to count overlap?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Then you use UNION ALL. Both queries must return the same number of columns in the same order." },
	{ "type": "sql_fill", "gamemode": "sql_blank", "recap": "UNION / UNION ALL",
	  "desc": "Combine guest cities and staff cities into one list. Fill in the set operator.",
	  "hint": "UNION merges two SELECT results and drops duplicates. UNION ALL keeps them.",
	  "prefix": "SELECT city FROM guests\n", "answer": "UNION", "placeholder": "operator", "max_length": 9,
	  "suffix": "SELECT city FROM staff;",
	  "err_hint": "The operator that merges two result sets is UNION.",
	  "result_headers": ["city"], "result_rows": [["Manila"],["Cebu"],["Davao"]],
	  "result_msg": "UNION merged both lists and removed duplicate cities. Use UNION ALL if you want to keep duplicates." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "One clean list from two tables. UNION removes repeats, UNION ALL keeps them. Perfect for the mailing list." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 40 — CHECK constraint  |  NPC: hotel_manager
# ─────────────────────────────────────────────
40: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Someone typed a guest age of -5 last week. The manager wants the database itself to reject impossible values." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Can the table refuse to store an age below 18 — without us writing extra code every time?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Yes — a CHECK constraint. It attaches a rule to a column, and the database rejects any row that breaks it." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/think",
	  "text": "So CHECK (age >= 18) means an INSERT with age 15 simply fails?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Exactly. NOT NULL, UNIQUE, DEFAULT, and CHECK are all constraints — built-in guards that protect data quality." },
	{ "type": "sql_fill", "gamemode": "sql_blank", "recap": "CHECK",
	  "desc": "Add a rule so the age column only accepts 18 or older. Fill in the constraint keyword.",
	  "hint": "The constraint that validates a value against a condition is CHECK.",
	  "prefix": "CREATE TABLE staff (\n  age INT ", "answer": "CHECK", "placeholder": "constraint", "max_length": 6,
	  "suffix": "(age >= 18)\n);",
	  "err_hint": "The constraint that enforces a condition is CHECK.",
	  "result_msg": "CHECK constraint added. Any INSERT with age < 18 is now rejected by the database itself." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Now bad data is blocked at the door. CHECK keeps the table honest no matter who is typing." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 41 — ER Diagram (theory)  |  NPC: hotel_manager
# ─────────────────────────────────────────────
41: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Before building any tables, the manager sketches the hotel's data on a whiteboard. She asks you to read the diagram." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "This is an ER Diagram — Entity-Relationship model. Boxes are entities, ovals are attributes, lines are relationships. What does it tell us?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Each box becomes a table, each oval becomes a column, and the line between GUEST and BOOKING shows how they connect — its cardinality." },
	{ "type": "sql_choice",
	  "desc": "One GUEST can make many BOOKINGs, but each BOOKING belongs to exactly one GUEST. What cardinality does this relationship have?",
	  "options": [
		[1, "One-to-Many (1:M) — one guest, many bookings; implemented with a guest_id foreign key in bookings."],
		[2, "Many-to-Many (M:N) — needs a junction table between guest and booking."],
		[3, "One-to-One (1:1) — each guest can have only a single booking ever."]
	  ],
	  "correct_id": 1,
	  "hint": "One on one side, many on the other = 1:M. Answer: id = 1",
	  "fail": [
		{ "type": "dialogue", "char": "mgr", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock",
		  "text": "M:N would need a junction table; 1:1 would limit a guest to one booking. Neither fits 'one guest, many bookings'." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
		  "text": "One guest to many bookings is One-to-Many (1:M). Answer: id = 1" }
	  ] },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "A 1:M relationship is built with a FOREIGN KEY on the 'many' side — bookings.guest_id points to guests.id." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "So the ER Diagram is the blueprint — we design relationships on paper first, then turn entities into tables and lines into foreign keys." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 42 — TRUNCATE  |  NPC: hotel_manager
# ─────────────────────────────────────────────
42: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The check-in log table has thousands of old test rows. The manager wants it completely emptied — but kept for new data." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "I want every row gone, but I still need the table itself. What is the fastest way to wipe it clean?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "TRUNCATE TABLE removes all rows at once and keeps the structure. It is faster than DELETE and needs no WHERE." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/think",
	  "text": "So how is it different from DELETE and DROP?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "DELETE removes rows one by one (and can use WHERE). TRUNCATE empties the whole table fast. DROP deletes the table entirely." },
	{ "type": "sql_fill", "gamemode": "sql_blank", "recap": "TRUNCATE",
	  "desc": "Empty the entire checkin_logs table but keep its structure. Fill in the keyword.",
	  "hint": "DELETE = row by row. DROP = remove the table. The fast 'empty everything' keyword is TRUNCATE.",
	  "prefix": "", "answer": "TRUNCATE", "placeholder": "keyword", "max_length": 10,
	  "suffix": "TABLE checkin_logs;",
	  "err_hint": "To empty a whole table fast, the keyword is TRUNCATE.",
	  "result_msg": "All rows removed. The empty checkin_logs table is ready for new data — its columns and structure stayed intact." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "DELETE for some rows, TRUNCATE to empty it, DROP to destroy it. Now I will never mix them up." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 43 — String Functions  |  NPC: hotel_manager
# ─────────────────────────────────────────────
43: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The guest names were entered in mixed casing. The manager wants a clean report with every name in capitals." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Some names are 'alice', some 'ALICE', some 'Alice'. Can SQL force them all to uppercase in the result?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Yes — string functions. UPPER() capitalizes text, LOWER() makes it lowercase, LENGTH() counts characters, SUBSTR() extracts part of it." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/think",
	  "text": "So UPPER(name) gives me every name in capitals without changing the stored data?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Exactly. The function transforms the value only in the output — the table itself stays untouched." },
	{ "type": "sql_fill", "gamemode": "aggregate", "recap": "String Functions",
	  "desc": "Show every guest name in capital letters. Fill in the string function.",
	  "hint": "UPPER() converts text to capitals. LOWER() does the opposite.",
	  "table": "guests", "column": "name", "answer": "UPPER",
	  "table_headers": ["id", "name"],
	  "table_rows": [["1","alice"],["2","Bob"],["3","CAROL"]],
	  "result_headers": ["UPPER(name)"], "result_rows": [["ALICE"],["BOB"],["CAROL"]],
	  "result_msg": "UPPER(name) returned every name in capitals. Try LOWER(), LENGTH(name), or SUBSTR(name, 1, 3) for other transforms." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Clean, consistent names in one query. String functions tidy up messy text without editing the table." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 44 — COALESCE / IFNULL  |  NPC: hotel_manager
# ─────────────────────────────────────────────
44: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Some guests never gave an email, so the contact report shows blank cells. The manager wants a friendlier placeholder." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Where the email is missing, can the report show 'No email' instead of an empty NULL cell?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Yes — COALESCE returns the first value that is not NULL. COALESCE(email, 'No email') uses the email if present, otherwise the fallback." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/think",
	  "text": "I have seen IFNULL too — is it the same thing?" },
	{ "type": "dialogue", "char": "you", "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "IFNULL does the same with two values. COALESCE is the standard one and can take many values, returning the first non-NULL." },
	{ "type": "sql_fill", "gamemode": "sql_blank", "recap": "COALESCE / IFNULL",
	  "desc": "Replace any missing email with 'No email'. Fill in the NULL-handling function.",
	  "hint": "It returns the first non-NULL value. COALESCE(email, 'No email').",
	  "prefix": "SELECT name,\n  ", "answer": "COALESCE", "placeholder": "function", "max_length": 10,
	  "suffix": "(email, 'No email') FROM guests;",
	  "err_hint": "The function that returns the first non-NULL value is COALESCE.",
	  "table": "guests",
	  "table_headers": ["name", "email"],
	  "table_rows": [["Alice","alice@mail.com"],["Bob","NULL"],["Carol","NULL"]],
	  "result_headers": ["name", "contact"],
	  "result_rows": [["Alice","alice@mail.com"],["Bob","No email"],["Carol","No email"]],
	  "result_msg": "COALESCE filled the blank emails with 'No email'. IFNULL(email, 'No email') would do the same for two values." },
	{ "type": "dialogue", "char": "mgr", "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "No more empty cells — every row reads clearly. COALESCE turns missing data into something readable." },
	{ "type": "end" }
],

} # end LESSONS
