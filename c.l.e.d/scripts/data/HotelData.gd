extends Node
# ═══════════════════════════════════════════════════════
#  HOTEL DATA  —  scripts/data/HotelData.gd
#
#  Each dialogue step has an "npc" field that controls
#  exactly which character and expression shows on screen.
#  Format:  "npc": "adult_N/expr"
#  Folders: adult_1, adult_2, adult_3
#  Exprs:   idle, talk, think, confuse, shock
#
#  Character assignments (Hotel World):
#    adult_1 = Male guest / Alex (Lessons 1, 2, 4)
#    adult_2 = Female guest / Maya / Ms. Lim (Lessons 3, 5)
#    adult_3 = Hotel Manager (Lessons 6, 7)
#
#  Step types:
#    "dialogue"   → char, name, text, npc
#    "sql_choice" → desc, options, correct_id, hint
#    "sql_fill"   → gamemode, desc, table, columns, ...
#    "end"        → (no extra fields)
# ═══════════════════════════════════════════════════════

const LESSONS: Dictionary = {

# ─────────────────────────────────────────────
#  LESSON 1 — SELECT (sql_choice)
#  Topic: Choosing the right professional response
# ─────────────────────────────────────────────
1: [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "A guest steps up to the counter with a friendly wave. It's your first interaction of the day."
	},
	{
		"type": "dialogue",
		"char": "guest",
		"name": "GUEST",
		"npc":  "adult_1/talk",
		"text": "Good morning! I was wondering — do you happen to have any rooms available for tonight?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "Let me check my options before responding..."
	},
	{
		"type": "sql_choice",
		"desc": "Three responses are in the table below. Type the id of the most professional and helpful answer.",
		"options": [
			[1, "Yes! We have Deluxe and Standard rooms. Which type would you prefer?"],
			[2, "I don't know, check the board yourself."],
			[3, "Come back later."]
		],
		"correct_id": 1,
		"hint": "A good receptionist informs and offers options. Answer: id = 1"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "Yes! We have Deluxe and Standard rooms available. Which type would you prefer?"
	},
	{
		"type": "dialogue",
		"char": "guest",
		"name": "GUEST",
		"npc":  "adult_1/idle",
		"text": "A Deluxe room would be perfect! You're so helpful, thank you!"
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON 2 — INSERT INTO
#  Topic: Registering a new guest into the database
# ─────────────────────────────────────────────
2: [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "A young man walks in with a rolling suitcase and looks around the lobby, then approaches your desk."
	},
	{
		"type": "dialogue",
		"char": "guest",
		"name": "ALEX",
		"npc":  "adult_1/confuse",
		"text": "Uh, hi... I'd like to book a room, please."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "Good morning! Welcome to Grand Hotel. May I have your full name?"
	},
	{
		"type": "dialogue",
		"char": "guest",
		"name": "ALEX",
		"npc":  "adult_1/talk",
		"text": "My name is Alex Rivera Santos."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "Perfect! Let me register that in our system right now."
	},
	{
		"type": "sql_fill",
		"gamemode": "insert_into",
		"desc": "Add Alex Rivera Santos to the customers table. Fill in his first_name, middle_name, and last_name.",
		"table": "customers",
		"columns": ["first_name", "middle_name", "last_name"],
		"table_headers": ["id", "first_name", "middle_name", "last_name"],
		"table_rows": [],
		"answers": ["Alex", "Rivera", "Santos"],
		"hint": "Alex Rivera Santos — First: Alex | Middle: Rivera | Last: Santos",
		"result_headers": ["id", "first_name", "middle_name", "last_name"],
		"result_rows": [["1", "Alex", "Rivera", "Santos"]],
		"result_msg": "1 record inserted into customers."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "You're all set, Mr. Santos! Room 101 is confirmed. Enjoy your stay!"
	},
	{
		"type": "dialogue",
		"char": "guest",
		"name": "ALEX",
		"npc":  "adult_1/idle",
		"text": "That was so fast, thank you! You're amazing!"
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON 3 — SELECT WHERE
#  Topic: Searching for a guest by last name
# ─────────────────────────────────────────────
3: [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_2/idle",                  # looking at you — idle
		"text": "A nervous young woman approaches, clutching a printed email and looking very worried."
	},
	{
		"type": "dialogue",
		"char": "guest2",
		"name": "MAYA",
		"npc":  "adult_2/confuse",
		"text": "Um... sorry to bother you... I made a reservation online but I can't find my confirmation email..."
	},
	{
		"type": "dialogue",
		"char": "guest2",
		"name": "MAYA",
		"npc":  "adult_2/shock",
		"text": "What if my booking doesn't exist?? I saved up for this for months!!"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_2/idle",                  # looking at you — idle
		"text": "Hey, breathe! I can search for you. What's your last name?"
	},
	{
		"type": "dialogue",
		"char": "guest2",
		"name": "MAYA",
		"npc":  "adult_2/talk",
		"text": "Dela Cruz. D-E-L-A Cruz."
	},
	{
		"type": "sql_fill",
		"gamemode": "select_where",
		"desc": "Search the customers table for Maya's last name. Fill in the WHERE clause.",
		"table": "customers",
		"column": "last_name",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_rows": [
			["1", "Alex", "Santos", "101"],
			["2", "Maya", "Dela Cruz", "204"],
			["3", "Jose", "Hernandez", "312"]
		],
		"answer": "Dela Cruz",
		"hint": "Type her last name exactly: Dela Cruz",
		"result_headers": ["id", "first_name", "last_name", "room_no"],
		"result_rows": [["2", "Maya", "Dela Cruz", "204"]],
		"result_msg": "1 record found."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_2/idle",                  # looking at you — idle
		"text": "Found you! Room 204, Deluxe Queen — all confirmed, Ms. Dela Cruz!"
	},
	{
		"type": "dialogue",
		"char": "guest2",
		"name": "MAYA",
		"npc":  "adult_2/idle",
		"text": "Oh THANK GOODNESS!! You're literally a lifesaver, thank you!!"
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON 4 — UPDATE SET
#  Topic: Fixing a wrong record, handling upset guest
#  Note: has TWO sql steps — sql_choice first, then sql_fill
# ─────────────────────────────────────────────
4: [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "A stocky man storms up to the front desk, arms crossed, red-faced. You take a deep breath."
	},
	{
		"type": "dialogue",
		"char": "guest3",
		"name": "MR. H",
		"npc":  "adult_1/shock",
		"text": "EXCUSE ME. There is a MISTAKE in my booking and I am NOT happy about it!!"
	},
	{
		"type": "sql_choice",
		"desc": "An upset guest is in front of you. Choose the most professional response.",
		"options": [
			[1, "Please calm down, sir, you're disturbing other guests."],
			[2, "I'm very sorry to hear that. I'll fix it right away."],
			[3, "Not my problem."]
		],
		"correct_id": 2,
		"hint": "De-escalate calmly and offer to help. Answer: id = 2"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "I'm very sorry to hear that. I'll fix it right away. May I have your booking id?"
	},
	{
		"type": "dialogue",
		"char": "guest3",
		"name": "MR. H",
		"npc":  "adult_1/shock",
		"text": "The name is Hernandez! H-E-R-N-A-N-D-E-Z!! You have it as Hernandes — NO Z!! Booking id is 3."
	},
	{
		"type": "sql_fill",
		"gamemode": "update_set",
		"desc": "Fix the last_name from Hernandes to Hernandez for record id = 3.",
		"table": "customers",
		"column": "last_name",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_rows": [
			["3", "Jose", "Hernandes", "312"]
		],
		"answer_value": "Hernandez",
		"answer_id": "3",
		"hint": "Correct spelling: Hernandez | Record id: 3",
		"result_headers": ["id", "first_name", "last_name", "room_no"],
		"result_rows": [["3", "Jose", "Hernandez", "312"]],
		"result_msg": "1 record updated."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_1/idle",                  # looking at you — idle
		"text": "Done! Corrected to Hernandez, Mr. Hernandez. I sincerely apologize for the error."
	},
	{
		"type": "dialogue",
		"char": "guest3",
		"name": "MR. H",
		"npc":  "adult_1/confuse",
		"text": "...Hmph. At least you fixed it quickly. Don't let it happen again."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON 5 — DELETE
#  Topic: Cancelling a reservation
# ─────────────────────────────────────────────
5: [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_2/idle",                  # looking at you — idle
		"text": "The front desk phone rings. You pick it up — it's a guest calling in to cancel her reservation."
	},
	{
		"type": "dialogue",
		"char": "guest2",
		"name": "MS. LIM",
		"npc":  "adult_2/confuse",
		"text": "Hello... I'm so sorry, but I need to cancel my reservation. Something came up at work."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_2/idle",                  # looking at you — idle
		"text": "I understand completely. Could I have your name and booking id?"
	},
	{
		"type": "dialogue",
		"char": "guest2",
		"name": "MS. LIM",
		"npc":  "adult_2/talk",
		"text": "Linda Lim. My booking id is 5."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_2/idle",                  # looking at you — idle
		"text": "Let me pull that up and process the cancellation for you right now."
	},
	{
		"type": "sql_fill",
		"gamemode": "delete",
		"desc": "Remove Ms. Lim's reservation from the database. Her booking id = 5.",
		"table": "customers",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_rows": [
			["5", "Linda", "Lim", "205"]
		],
		"answer_id": "5",
		"hint": "Delete the record where id = 5",
		"result_headers": ["STATUS"],
		"result_rows": [["Record with id = 5 has been removed."]],
		"result_msg": "1 record deleted."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_2/idle",                  # looking at you — idle
		"text": "Done, Ms. Lim! Your reservation has been cancelled. We hope to see you again soon!"
	},
	{
		"type": "dialogue",
		"char": "guest2",
		"name": "MS. LIM",
		"npc":  "adult_2/idle",
		"text": "Thank you so much for being so understanding. I'll rebook next time!"
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON 6 — ORDER BY
#  Topic: Sorting the guest list alphabetically
# ─────────────────────────────────────────────
6: [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/hotel_manager/idle",                  # looking at you — idle
		"text": "The hotel manager walks over with his clipboard, scanning the guest registry."
	},
	{
		"type": "dialogue",
		"char": "mgr",
		"name": "MANAGER",
		"npc":  "NPC_occupations/hotel_manager/talk",
		"text": "I need you to pull up all current guests sorted alphabetically by last name. A to Z, please."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/hotel_manager/idle",                  # looking at you — idle
		"text": "Of course, sir. I'll sort the records right now."
	},
	{
		"type": "sql_fill",
		"gamemode": "order_by",
		"desc": "Retrieve all guests sorted A to Z by last_name. Type ASC for ascending or DESC for descending.",
		"table": "customers",
		"column": "last_name",
		"table_headers": ["id", "first_name", "last_name", "room_no"],
		"table_rows": [
			["1", "Alex", "Santos", "101"],
			["2", "Maya", "Dela Cruz", "204"],
			["3", "Jose", "Hernandez", "312"]
		],
		"answer": "ASC",
		"hint": "A to Z is Ascending order. Type: ASC",
		"result_headers": ["id", "first_name", "last_name", "room_no"],
		"result_rows": [
			["2", "Maya", "Dela Cruz", "204"],
			["3", "Jose", "Hernandez", "312"],
			["1", "Alex", "Santos", "101"]
		],
		"result_msg": "Records sorted by last_name ASC."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/hotel_manager/idle",                  # looking at you — idle
		"text": "Here you go, sir — all guests sorted A to Z by last name!"
	},
	{
		"type": "dialogue",
		"char": "mgr",
		"name": "MANAGER",
		"npc":  "NPC_occupations/hotel_manager/think",
		"text": "Excellent. Dela Cruz, Hernandez, Santos. Perfect alphabetical order. Well done."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON 7 — GROUP BY
#  Topic: Generating a room type report
# ─────────────────────────────────────────────
7: [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/hotel_manager/idle",                  # looking at you — idle
		"text": "Friday afternoon. The manager walks in looking serious, carrying his weekly report clipboard."
	},
	{
		"type": "dialogue",
		"char": "mgr",
		"name": "MANAGER",
		"npc":  "NPC_occupations/hotel_manager/talk",
		"text": "I need a breakdown: how many bookings do we have per room type? For the board meeting."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/hotel_manager/idle",                  # looking at you — idle
		"text": "On it, sir. I'll group the data by room type and count them up right now."
	},
	{
		"type": "sql_fill",
		"gamemode": "group_by",
		"desc": "Count how many customers booked each room type. Fill in the GROUP BY column name.",
		"table": "customers",
		"column": "room_type",
		"table_headers": ["id", "first_name", "room_type"],
		"table_rows": [
			["1", "Alex", "Standard"],
			["2", "Maya", "Deluxe"],
			["3", "Jose", "Suite"],
			["4", "Linda", "Deluxe"],
			["5", "Marco", "Standard"]
		],
		"answer": "room_type",
		"hint": "You want to count per room type. Type: room_type",
		"result_headers": ["room_type", "COUNT(*)"],
		"result_rows": [
			["Standard", "2"],
			["Deluxe",   "2"],
			["Suite",    "1"]
		],
		"result_msg": "Data grouped successfully."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/hotel_manager/idle",                  # looking at you — idle
		"text": "Report ready! Standard: 2, Deluxe: 2, Suite: 1."
	},
	{
		"type": "dialogue",
		"char": "mgr",
		"name": "MANAGER",
		"npc":  "NPC_occupations/hotel_manager/idle",
		"text": "Perfect. This is exactly what I needed. You're a natural at this database work."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/hotel_manager/idle",                  # looking at you — idle
		"text": "Just doing my job, sir. One query at a time."
	},
	{
		"type": "end"
	}
]

} # end LESSONS
