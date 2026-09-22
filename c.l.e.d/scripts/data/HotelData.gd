extends Node
# ═══════════════════════════════════════════════════════
#  HOTEL DATA  |  scripts/data/HotelData.gd
#
#  Curriculum trimmed to query-only lessons (Basic SQL,
#  Filtering Rows, Sorting & Aggregates) per panel feedback.
#  Joins/Subqueries, Functions, and all schema/DDL chapters
#  (Creating Tables, Constraints & Keys, Schema Management,
#  Advanced Concepts) were removed.
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
#  Rule: "you" / "scene" always use idle | NPC looks at you.
# ═══════════════════════════════════════════════════════

const LESSONS: Dictionary = {

# ─────────────────────────────────────────────
#  LESSON 1 | SELECT  |  NPC: adult_1
# ─────────────────────────────────────────────
1: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "adult_1/idle",
	  "text": "It's your first morning at the front desk. Before guests start arriving, a coworker walks you through the system." },
	{ "type": "dialogue", "char": "guest",  "name": "TRAINER",
	  "npc": "adult_1/talk",
	  "text": "Let's start with the basics. Pull up every guest currently in our system every column, every row." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_1/idle",
	  "text": "Sure! Let me query the guests table and show you everything." },
	{ "type": "sql_fill",
	  "gamemode": "select_basic",
	  "desc": "Retrieve every column and every row from the guests table.",
	  "table": "guests",
	  "table_headers": ["id", "first_name", "last_name", "room_no"],
	  "table_rows": [
	  	["1", "Alex",   "Santos",     "101"],
	  	["2", "Maya",   "Dela Cruz",  "204"],
	  	["3", "Jose",   "Hernandez",  "312"],
	  	["4", "Carlos", "Garcia",     "412"],
	  	["5", "Linda",  "Lim",        "205"]
	  ],
	  "answer": "*",
	  "hint": "There's a single symbol that means 'every column' — you won't need to type each column name out.",
	  "fail": [
		{ "type": "dialogue", "char": "guest", "name": "TRAINER", "npc": "adult_1/shock", "text": "That's not right. To grab every column at once, use the wildcard character." },
		{ "type": "dialogue", "char": "scene", "name": "SCENE",   "npc": "adult_1/idle",  "text": "The trainer taps the keyboard, waiting patiently." },
		{ "type": "dialogue", "char": "you",   "name": "YOU",     "npc": "adult_1/idle",  "text": "Right the wildcard for 'everything' is: *" }
	  ],
	  "result_headers": ["id", "first_name", "last_name", "room_no"],
	  "result_rows": [
	  	["1", "Alex",   "Santos",     "101"],
	  	["2", "Maya",   "Dela Cruz",  "204"],
	  	["3", "Jose",   "Hernandez",  "312"],
	  	["4", "Carlos", "Garcia",     "412"],
	  	["5", "Linda",  "Lim",        "205"]
	  ],
	  "result_msg": "5 guests retrieved. SELECT * returns every column for every row in the table." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_1/idle",
	  "text": "There you go all 5 guests, every column." },
	{ "type": "dialogue", "char": "guest",  "name": "TRAINER",
	  "npc": "adult_1/talk",
	  "text": "Perfect. SELECT * is the most basic query there is, and you'll type it constantly. Good start!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 2 | INSERT INTO  |  NPC: adult_13
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
	  "table_rows": [
	  	["1", "Maya",   "Dela",  "Cruz"],
	  	["2", "Jose",   "R.",    "Hernandez"],
	  	["3", "Carlos", "M.",    "Garcia"],
	  	["4", "Linda",  "P.",    "Lim"]
	  ],
	  "answers": ["Alex", "Rivera", "Santos"],
	  "hint": "Match the three blanks to the order Alex gave his name in — first name first.",
	  "fail": [
		{ "type": "dialogue", "char": "guest", "name": "ALEX",  "npc": "adult_13/confuse", "text": "That is not my name at all. Are you sure you typed it right?" },
		{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "adult_13/idle",   "text": "Alex looks uncomfortable. The guest in line behind him sighs." },
		{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "adult_13/idle",   "text": "I am so sorry! Let me re-enter that correctly." }
	  ],
	  "result_headers": ["id", "first_name", "middle_name", "last_name"],
	  "result_rows": [["5", "Alex", "Rivera", "Santos"]],
	  "result_msg": "1 record inserted into customers Alex is now guest id 5." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_13/idle",
	  "text": "You're all set, Mr. Santos! Room 101 is confirmed. Enjoy your stay!" },
	{ "type": "dialogue", "char": "guest",  "name": "ALEX",
	  "npc": "adult_13/talk",
	  "text": "That was so fast, thank you! You're amazing!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 3 | SELECT WHERE  |  NPC: adult_12
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
	  "hint": "WHERE needs the exact spelling Maya just gave you, space included.",
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
	  "text": "Found you! Room 204, Deluxe Queen all confirmed, Ms. Dela Cruz!" },
	{ "type": "dialogue", "char": "guest2", "name": "MAYA",
	  "npc": "adult_12/talk",
	  "text": "Oh THANK GOODNESS!! You're literally a lifesaver, thank you!!" },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 4 | UPDATE SET  |  NPC: adult_9
# ─────────────────────────────────────────────
4: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "adult_9/idle",
	  "text": "A stocky man storms up to the front desk, arms crossed, red-faced. You take a deep breath." },
	{ "type": "dialogue", "char": "guest3", "name": "MR. H",
	  "npc": "adult_9/shock",
	  "text": "EXCUSE ME. There is a MISTAKE in my booking and I am NOT happy about it!!" },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "adult_9/idle",
	  "text": "I'm very sorry to hear that. I'll fix it right away. May I have your booking id?" },
	{ "type": "dialogue", "char": "guest3", "name": "MR. H",
	  "npc": "adult_9/shock",
	  "text": "The name is Hernandez! H-E-R-N-A-N-D-E-Z!! You have it as Hernandes NO Z!! Booking id is 3." },
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
	  "hint": "Use the spelling Mr. Hernandez corrected you with, and match it to the id he gave you a moment ago.",
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
#  LESSON 5 | DELETE  |  NPC: adult_14
# ─────────────────────────────────────────────
5: [
	{ "type": "dialogue", "char": "scene",  "name": "SCENE",
	  "npc": "adult_14/idle",
	  "text": "The front desk phone rings. You pick it up it's a guest calling in to cancel her reservation." },
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
	  "hint": "The id you need was mentioned earlier in the conversation — scroll back if you lost track of the number.",
	  "fail": [
		{ "type": "dialogue", "char": "guest2", "name": "MS. LIM", "npc": "adult_14/confuse", "text": "That is the wrong record. That is someone else's booking!" },
		{ "type": "dialogue", "char": "scene",  "name": "SCENE",   "npc": "adult_14/idle",   "text": "A long pause on the phone line. This could be a serious data error." },
		{ "type": "dialogue", "char": "you",    "name": "YOU",     "npc": "adult_14/idle",   "text": "I am so sorry let me double check the correct id." }
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
#  LESSON 6 | ORDER BY  |  NPC: hotel_manager (boss)
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
	  "hint": "Alphabetical A-to-Z, or lowest-to-highest, is the 'normal' sort direction — one of the two keywords means exactly that.",
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
	  "text": "Here you go, sir all guests sorted A to Z by last name!" },
	{ "type": "dialogue", "char": "mgr",    "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/think",
	  "text": "Excellent. Dela Cruz, Hernandez, Santos. Perfect order. Well done." },
	{ "type": "dialogue", "char": "mgr",    "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Actually, flip that for the printed handout Z to A, so the newest last names are on top." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Z to A is Descending order. I'll change ASC to DESC." },
	{ "type": "sql_fill",
	  "gamemode": "order_by",
	  "desc": "Sort all guests Z to A by last_name. Type ASC or DESC.",
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
	  "answer": "DESC",
	  "hint": "This is the opposite direction from what you just used — the other keyword reverses the order.",
	  "fail": [
		{ "type": "dialogue", "char": "mgr",   "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "This is still A to Z! I asked for the reverse order for the handout!" },
		{ "type": "dialogue", "char": "scene", "name": "SCENE",   "npc": "NPC_occupations/hotel_manager/idle",  "text": "The manager taps the paper impatiently." },
		{ "type": "dialogue", "char": "you",   "name": "YOU",     "npc": "NPC_occupations/hotel_manager/idle",  "text": "Sorry! Z to A means DESC." }
	  ],
	  "result_headers": ["id", "first_name", "last_name", "room_no"],
	  "result_rows": [
	  	["8", "Ana",    "Villanueva", "217"],
	  	["7", "Sofia",  "Torres",     "310"],
	  	["1", "Alex",   "Santos",     "101"],
	  	["6", "Marco",  "Reyes",      "108"],
	  	["5", "Linda",  "Lim",        "205"],
	  	["3", "Jose",   "Hernandez",  "312"],
	  	["4", "Carlos", "Garcia",     "412"],
	  	["2", "Maya",   "Dela Cruz",  "204"]
	  ],
	  "result_msg": "Records sorted by last_name DESC." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "There you go Villanueva, Torres, Santos on top now." },
	{ "type": "dialogue", "char": "mgr",    "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Perfect. ASC for A-to-Z, DESC for Z-to-A. Now you've got both directions down." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 7 | GROUP BY  |  NPC: hotel_manager (boss)
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
	  "hint": "GROUP BY needs the column the manager wants the counts broken down by — check what category the report is split into.",
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
#  LESSON 8 | IS NULL  |  NPC: hotel_manager
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
		"hint": "A blank/missing value in SQL isn't an empty string — it has its own keyword you check for right after IS.",
		"result_headers": ["id", "first_name", "last_name", "email"],
		"result_rows": [
			["2", "Maya",   "Dela Cruz", "NULL"],
			["4", "Carlos", "Garcia",    "NULL"],
			["6", "Marco",  "Reyes",     "NULL"]
		],
		"result_msg": "3 guests have no email on file.",
		"fail": [
			{ "type": "dialogue", "char": "mgr",  "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That is not right. NULL means the value is missing it is not a regular word to search for." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE",  "npc": "NPC_occupations/hotel_manager/idle",  "text": "The manager turns back to his desk, waiting." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",    "npc": "NPC_occupations/hotel_manager/idle",  "text": "Right I need to type NULL after IS to check for missing values." }
		]
	},
	{ "type": "dialogue", "char": "you",   "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Found them! Maya Dela Cruz, Carlos Garcia, and Marco Reyes have no email. We can reach them by phone." },
	{ "type": "dialogue", "char": "mgr",   "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Perfect. IS NULL is a powerful tool for finding gaps in our data. Good thinking." },
	{ "type": "dialogue", "char": "mgr",    "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Now the opposite show me guests who DO have an email on file, so I can send the newsletter." },
	{ "type": "dialogue", "char": "you",    "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "That's IS NOT NULL this time it finds rows where the value is actually filled in." },
	{
		"type": "sql_fill",
		"gamemode": "select_where_null",
		"desc": "Find all guests who DO have an email on file. Type NOT NULL after IS.",
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
		"answer": "NOT NULL",
		"hint": "You want the opposite of 'missing' this time — the phrasing for 'a value is actually present.'",
		"result_headers": ["id", "first_name", "last_name", "email"],
		"result_rows": [
			["1", "Alex",  "Santos",    "alex@mail.com"],
			["3", "Jose",  "Hernandez", "jose@mail.com"],
			["5", "Linda", "Lim",       "linda@mail.com"]
		],
		"result_msg": "3 guests have an email on file. IS NOT NULL finds the opposite of IS NULL.",
		"fail": [
			{ "type": "dialogue", "char": "mgr",  "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That's the empty ones again! I need the guests who DO have an email this time." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE",  "npc": "NPC_occupations/hotel_manager/idle",  "text": "The manager waits, tapping the newsletter draft." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",    "npc": "NPC_occupations/hotel_manager/idle",  "text": "Right for values that ARE present: NOT NULL." }
		]
	},
	{ "type": "dialogue", "char": "you",   "name": "YOU",
	  "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Here you go Alex, Jose, and Linda all have emails on file." },
	{ "type": "dialogue", "char": "mgr",   "name": "MANAGER",
	  "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Perfect. IS NULL for missing data, IS NOT NULL for what's actually there. Both are useful." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 16 | SELECT DISTINCT  |  NPC: hotel_manager
# ─────────────────────────────────────────────
16: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The hotel manager is preparing a room availability report and needs a list of unique room types." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Our bookings table has hundreds of rows but only three room types. I need each type listed once no duplicates." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "SELECT DISTINCT returns only unique values in a column duplicates are automatically removed." },
	{ "type": "sql_fill", "gamemode": "select_distinct",
	  "desc": "Return only the unique room types from the bookings table. Fill in the column name after SELECT DISTINCT.",
	  "table": "bookings",
	  "column": "room_type",
	  "table_headers": ["id","guest_id","room_type","check_in"],
	  "table_rows": [["1","1","Standard","June 1"],["2","2","Deluxe","June 3"],["3","3","Standard","June 4"],["4","4","Suite","June 5"],["5","5","Deluxe","June 6"],["6","6","Standard","June 7"]],
	  "hint": "DISTINCT needs the column that has repeated values — think about which column would show duplicates without it.",
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
#  LESSON 17 | AND/OR  |  NPC: hotel_manager
# ─────────────────────────────────────────────
17: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager needs to find VIP guests who also have an active booking both conditions must be true." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "I need guests who are VIP status AND have a booking. Not just one or the other both must apply." },
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
	  "hint": "Ask yourself: does the manager need BOTH conditions true at once, or is just one enough? That decides the connector.",
	  "result_headers": ["id","first_name","status","has_booking"],
	  "result_rows": [["1","Alex","VIP","Yes"],["4","Carlos","VIP","Yes"]],
	  "result_msg": "2 VIP guests with active bookings. AND requires BOTH conditions. OR would return 4 rows.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "Wrong connector! That gave too many results. I need BOTH conditions true at once." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "For both conditions required: AND." }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Only Alex and Carlos the ones who are both VIP and have a booking. AND is strict." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Right. OR would include Jose who is VIP but has no booking, and Maya who has a booking but is not VIP." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Actually, now I need the opposite. Show me every guest who is VIP status OR has a booking — either one qualifies for the front-desk priority list." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "That's OR instead of AND. OR only needs ONE condition to be true, so it'll return more guests." },
	{ "type": "sql_fill", "gamemode": "where_and_or",
	  "desc": "Find guests who are VIP status OR have a booking. Fill in AND or OR.",
	  "table": "guests",
	  "condition1": "status = 'VIP'",
	  "condition2": "has_booking = 'Yes'",
	  "answer": "OR",
	  "table_headers": ["id","first_name","status","has_booking"],
	  "table_rows": [["1","Alex","VIP","Yes"],["2","Maya","Regular","Yes"],["3","Jose","VIP","No"],["4","Carlos","VIP","Yes"],["5","Linda","Regular","No"]],
	  "hint": "This time only one of the two conditions needs to be true — the other logical connector fits that.",
	  "result_headers": ["id","first_name","status","has_booking"],
	  "result_rows": [["1","Alex","VIP","Yes"],["2","Maya","Regular","Yes"],["3","Jose","VIP","No"],["4","Carlos","VIP","Yes"]],
	  "result_msg": "4 guests match. OR only needs ONE condition true, so only Linda (neither VIP nor booked) is excluded.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That's too few! I need either condition to count, not both at once." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "Right for either condition being enough: OR." }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Perfect four guests for the priority list. OR is much more inclusive than AND." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Exactly. AND narrows results down both conditions must hold. OR widens them either one will do." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 18 | BETWEEN  |  NPC: hotel_manager
# ─────────────────────────────────────────────
18: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager wants to find mid-range bookings not the cheapest rooms, not the most expensive." },
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
	  "hint": "There's a keyword built for 'anywhere within this range, inclusive on both ends' — it always pairs with AND.",
	  "result_headers": ["id","room_type","price_per_night"],
	  "result_rows": [["2","Deluxe","150"],["5","Deluxe","220"],["7","Standard","110"]],
	  "result_msg": "3 bookings in the 100-300 range. BETWEEN is inclusive 100 and 300 themselves would also match.",
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
#  LESSON 19 | LIKE  |  NPC: hotel_manager
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
	  "hint": "LIKE uses a wildcard symbol for 'anything after this point' — pair it with the first letter you're matching.",
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
#  LESSON 20 | IN  |  NPC: hotel_manager
# ─────────────────────────────────────────────
20: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager wants bookings for Standard and Deluxe rooms only Suite rooms are excluded from this report." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "I need bookings for Standard and Deluxe. Instead of writing two OR conditions, is there a shorter way?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Yes IN lets you check if a value matches any item in a list. It is cleaner than multiple OR conditions." },
	{ "type": "sql_fill", "gamemode": "where_in",
	  "desc": "Find bookings where room_type is Standard or Deluxe. Fill in the list membership keyword.",
	  "table": "bookings",
	  "column": "room_type",
	  "in_list": "('Standard', 'Deluxe')",
	  "answer": "IN",
	  "table_headers": ["id","room_type","price_per_night"],
	  "table_rows": [["1","Standard","85"],["2","Deluxe","150"],["3","Suite","350"],["4","Standard","95"],["5","Deluxe","220"],["6","Suite","400"]],
	  "hint": "One keyword checks a column against a whole list of values at once, instead of writing OR three times.",
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
#  LESSON 21 | LIMIT  |  NPC: hotel_manager
# ─────────────────────────────────────────────
21: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager wants a quick preview of recent guest records not all 500 rows, just the first few." },
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
	  "hint": "The number goes right after the keyword that caps how many rows come back — reread how many the manager asked for.",
	  "result_headers": ["id","first_name","last_name","email"],
	  "result_rows": [["1","Alex","Santos","alex@mail.com"],["2","Maya","Dela Cruz","maya@mail.com"],["3","Jose","Hernandez","jose@mail.com"],["4","Carlos","Garcia","carlos@mail.com"],["5","Linda","Lim","linda@mail.com"]],
	  "result_msg": "5 rows returned. Rows 6 and 7 were not fetched. LIMIT saves time on large tables.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That is not 5 rows. Type the number 5." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "Type the number 5 after LIMIT." }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "5 rows only much faster. LIMIT is great with ORDER BY to get the top or bottom N records." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "For example: SELECT * FROM guests ORDER BY id DESC LIMIT 3 gives the 3 most recently added guests." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 22 | COUNT/SUM/AVG  |  NPC: hotel_manager
# ─────────────────────────────────────────────
22: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Quarter-end report time. The manager needs a total count of all registered guests." },
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "How many guests do we have in the system? I need a single number not a list." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "COUNT is an aggregate function it collapses many rows into a single calculated value." },
	{ "type": "sql_fill", "gamemode": "aggregate",
	  "desc": "Count the total number of guests. Fill in the aggregate function name.",
	  "table": "guests",
	  "column": "id",
	  "answer": "COUNT",
	  "table_headers": ["id","first_name","last_name"],
	  "table_rows": [["1","Alex","Santos"],["2","Maya","Dela Cruz"],["3","Jose","Hernandez"],["4","Carlos","Garcia"],["5","Linda","Lim"],["6","Marco","Reyes"]],
	  "hint": "One aggregate function's entire job is collapsing many rows into a single row-count.",
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
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Now I need our total revenue add up every price_per_night across all bookings." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "That's SUM instead of COUNT. SUM adds together every value in a column instead of counting rows." },
	{ "type": "sql_fill", "gamemode": "aggregate",
	  "desc": "Find the total revenue from all bookings. Fill in the aggregate function name.",
	  "table": "bookings",
	  "column": "price_per_night",
	  "answer": "SUM",
	  "table_headers": ["id","room_type","price_per_night"],
	  "table_rows": [["1","Standard","85"],["2","Deluxe","150"],["3","Suite","350"],["4","Standard","95"],["5","Deluxe","220"],["6","Suite","400"],["7","Standard","110"]],
	  "hint": "You need the aggregate function that totals a column's values together — not the one that just counts rows.",
	  "result_headers": ["SUM(price_per_night)"],
	  "result_rows": [["1410"]],
	  "result_msg": "Total revenue: 1410. SUM adds every value in the column together, unlike COUNT which just counts rows.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That's not adding anything up! I need the total revenue, not a row count." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "Right to add values together: SUM." }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "1410 in total revenue. Now I have both the count and the total." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Right. SELECT SUM(price_per_night) FROM bookings gives total revenue. AVG gives the average nightly rate." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON 23 | HAVING  |  NPC: hotel_manager
# ─────────────────────────────────────────────
23: [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "The manager wants to know which room types have been booked more than once popular rooms for promotions." },
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
	  "hint": "HAVING filters on a calculated number from the GROUP BY — think about which aggregate function produced group sizes.",
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
#  LESSON 24 | AS (Aliases)  |  NPC: hotel_manager
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
	  "hint": "AS just needs a short, readable name for the calculated column — check what the manager's request called it.",
	  "result_headers": ["price_with_tax"],
	  "result_rows": [["112.0"],["224.0"],["336.0"]],
	  "result_msg": "Column now displays as 'price_with_tax' in results. AS only affects output the table is unchanged.",
	  "fail": [
		{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/shock", "text": "That alias is not right. The alias should be: price_with_tax" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle", "text": "Type the alias: price_with_tax" }
	  ]
	},
	{ "type": "dialogue", "char": "manager", "name": "MANAGER", "npc": "NPC_occupations/hotel_manager/talk",
	  "text": "Clean! AS also works on table names in JOINs: FROM bookings AS b useful in long queries." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/hotel_manager/idle",
	  "text": "Right. Short aliases like 'b' or 'g' keep JOIN queries readable when referencing multiple tables." },
	{ "type": "end" }
],

} # end LESSONS
