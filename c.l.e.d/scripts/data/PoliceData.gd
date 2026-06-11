extends Node
# ═══════════════════════════════════════════════════════
#  POLICE DATA  —  scripts/data/PoliceData.gd
#
#  NPC assignments (Police World — unique to this world):
#    adult_5 = Male citizen / reporter
#    adult_6 = Female citizen / witness
#    NPC_occupations/police = Officer / Chief (boss)
#
#  Rule: "you" and "scene" always idle — NPC looks at you.
# ═══════════════════════════════════════════════════════

const LESSONS: Dictionary = {

# ─────────────────────────────────────────────
#  LESSON P1 — SELECT (sql_choice)
#  Topic: Responding professionally to a citizen complaint
# ─────────────────────────────────────────────
"P1": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_5/idle",
		"text": "A nervous citizen walks into the police station and approaches the front desk."
	},
	{
		"type": "dialogue",
		"char": "citizen",
		"name": "CITIZEN",
		"npc":  "adult_5/talk",
		"text": "Officer! My bicycle was stolen outside the mall. I saw who did it but they ran away!"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_5/idle",
		"text": "I need to handle this professionally. Let me choose the right response."
	},
	{
		"type": "sql_choice",
		"desc": "A citizen is reporting a theft. Choose the most professional and helpful response.",
		"options": [
			[1, "I'll take your report right away. Can you describe the suspect?"],
			[2, "Bicycles get stolen all the time. Not much we can do."],
			[3, "You should have locked it better."]
		],
		"correct_id": 1,
		"hint": "A good officer takes the report seriously and asks for details. Answer: id = 1",
		"fail": [
			{ "type": "dialogue", "char": "citizen", "name": "CITIZEN", "npc": "adult_5/shock", "text": "Are you KIDDING me?! I came here for help and this is what I get?!" },
			{ "type": "dialogue", "char": "scene",   "name": "SCENE",   "npc": "adult_5/idle",  "text": "The citizen storms out. Your chief appears and gives you a long, silent look." },
			{ "type": "dialogue", "char": "you",     "name": "YOU",     "npc": "adult_5/idle",  "text": "I handled that wrong. Let me choose the correct professional response." }
		]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_5/idle",
		"text": "I'll take your report right away. Can you describe the suspect and the direction they ran?"
	},
	{
		"type": "dialogue",
		"char": "citizen",
		"name": "CITIZEN",
		"npc":  "adult_5/talk",
		"text": "Thank you, officer! I was so worried you wouldn't help. Here's everything I saw..."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P2 — INSERT INTO
#  Topic: Logging a new case into the system
# ─────────────────────────────────────────────
"P2": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_5/idle",
		"text": "After taking the citizen's statement, you need to log the case officially."
	},
	{
		"type": "dialogue",
		"char": "citizen",
		"name": "CITIZEN",
		"npc":  "adult_5/talk",
		"text": "My name is Marco Reyes. The stolen bike is a red mountain bike, case type is Theft."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_5/idle",
		"text": "Got it, Mr. Reyes. Let me log this case into the system right now."
	},
	{
		"type": "sql_fill",
		"gamemode": "insert_into",
		"desc": "Add the new case to the cases table. Fill in reporter_name, case_type, and status.",
		"table": "cases",
		"columns": ["reporter_name", "case_type", "status"],
		"table_headers": ["id", "reporter_name", "case_type", "status"],
		"table_rows": [],
		"answers": ["Marco Reyes", "Theft", "Open"],
		"hint": "Reporter: Marco Reyes | Type: Theft | Status: Open",
		"result_headers": ["id", "reporter_name", "case_type", "status"],
		"result_rows": [["4", "Marco Reyes", "Theft", "Open"]],
		"result_msg": "1 record inserted into cases.",
					"fail": [
						{ "type": "dialogue", "char": "citizen", "name": "CITIZEN", "npc": "adult_5/confuse", "text": "That is not right... that is someone else's case. My info is not even there!" },
						{ "type": "dialogue", "char": "scene",   "name": "SCENE",   "npc": "adult_5/idle",   "text": "Marco Reyes stares at the screen. Inaccurate police records are a serious problem." },
						{ "type": "dialogue", "char": "you",     "name": "YOU",     "npc": "adult_5/idle",   "text": "I apologize Mr. Reyes. Let me enter the correct information." }
					]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_5/idle",
		"text": "Case logged, Mr. Reyes! Your case number is 4. We'll be in touch."
	},
	{
		"type": "dialogue",
		"char": "citizen",
		"name": "CITIZEN",
		"npc":  "adult_5/talk",
		"text": "Thank you so much, officer. I feel better knowing it's on record."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P3 — SELECT WHERE
#  Topic: Searching for a suspect record
# ─────────────────────────────────────────────
"P3": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/police/idle",
		"text": "Your chief walks over with a name on a notepad."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/talk",
		"text": "We got a tip about a suspect named Santos. Pull their record from the database."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "Right away, Chief. Searching the records now."
	},
	{
		"type": "sql_fill",
		"gamemode": "select_where",
		"desc": "Search the suspects table for the last name Santos. Fill in the WHERE clause.",
		"table": "suspects",
		"column": "last_name",
		"table_headers": ["id", "first_name", "last_name", "case_type"],
		"table_rows": [
			["1",  "Marco",   "Reyes",     "Theft"],
			["2",  "Luis",    "Santos",    "Vandalism"],
			["3",  "Ana",     "Cruz",      "Fraud"],
			["4",  "Carlos",  "Dela Cruz", "Assault"],
			["5",  "Maria",   "Santos",    "Theft"],
			["6",  "Jose",    "Lim",       "Vandalism"],
			["7",  "Rosa",    "Garcia",    "Fraud"],
			["8",  "Miguel",  "Torres",    "Theft"],
			["9",  "Sofia",   "Santos",    "Assault"],
			["10", "Pedro",   "Villanueva","Vandalism"]
		],
		"answer": "Santos",
		"hint": "Type the last name exactly: Santos",
		"result_headers": ["id", "first_name", "last_name", "case_type"],
		"result_rows": [["2", "Luis", "Santos", "Vandalism"], ["5", "Maria", "Santos", "Theft"], ["9", "Sofia", "Santos", "Assault"]],
		"result_msg": "3 records found.",
					"fail": [
						{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "That is the WRONG suspect! You could blow the whole investigation!" },
						{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",  "text": "Your chief paces across the room. The tip could go cold if you do not move fast." },
						{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/police/idle",  "text": "My mistake Chief. Let me search with the correct last name." }
					]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "Found 3 suspects with last name Santos — Luis (Vandalism), Maria (Theft), Sofia (Assault). Pulling full files now, Chief."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/think",
		"text": "Good work. That matches our tip. Keep that record flagged."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P4 — UPDATE SET
#  Topic: Updating a case status after an arrest
# ─────────────────────────────────────────────
"P4": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/police/idle",
		"text": "An officer radios in — a suspect from case 2 has been apprehended."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/talk",
		"text": "Update case id 2. Status needs to change from Open to Closed. Suspect is in custody."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "Updating the record right now, Chief."
	},
	{
		"type": "sql_fill",
		"gamemode": "update_set",
		"desc": "Change the status of case id 2 from Open to Closed.",
		"table": "cases",
		"column": "status",
		"table_headers": ["id", "reporter_name", "case_type", "status"],
		"table_rows": [
			["1", "Marco Reyes",  "Theft",     "Open"],
			["2", "Ana Cruz",     "Vandalism", "Open"],
			["3", "Jose Lim",     "Assault",   "Closed"],
			["4", "Rosa Garcia",  "Fraud",     "Open"],
			["5", "Miguel Torres","Theft",      "Closed"],
			["6", "Sofia Santos", "Assault",   "Open"]
		],
		"answer_value": "Closed",
		"answer_id": "2",
		"hint": "Change status to: Closed | Record id: 2",
		"result_headers": ["id", "reporter_name", "case_type", "status"],
		"result_rows": [["2", "Ana Cruz", "Vandalism", "Closed"]],
		"result_msg": "1 record updated.",
					"fail": [
						{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "The status is STILL Open?! The suspect is in custody right now!" },
						{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",  "text": "Your chief pulls out their phone, visibly frustrated. Bad records create legal problems." },
						{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/police/idle",  "text": "I will update it to Closed right now Chief." }
					]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "Done! Case 2 is now marked Closed. Records updated, Chief."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/talk",
		"text": "Good. Keep the database clean — accurate records save lives in this job."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P5 — DELETE
#  Topic: Removing a cleared case from active records
# ─────────────────────────────────────────────
"P5": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/police/idle",
		"text": "End of quarter. The chief wants the active database cleared of fully resolved cases."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/talk",
		"text": "Remove case id 3 from the active records. It's been fully cleared and archived."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "Understood. Deleting case id 3 from active records now."
	},
	{
		"type": "sql_fill",
		"gamemode": "delete",
		"desc": "Remove the cleared case from active records. Case id = 3.",
		"table": "cases",
		"table_headers": ["id", "reporter_name", "case_type", "status"],
		"table_rows": [
			["1", "Marco Reyes",   "Theft",     "Open"],
			["2", "Ana Cruz",      "Vandalism", "Closed"],
			["3", "Marco Reyes",   "Fraud",     "Cleared"],
			["4", "Carlos Dela Cruz", "Assault", "Open"],
			["5", "Maria Santos",  "Theft",     "Open"],
			["6", "Jose Lim",      "Vandalism", "Cleared"],
			["7", "Sofia Santos",  "Assault",   "Closed"]
		],
		"answer_id": "3",
		"hint": "Delete the record where id = 3",
		"result_headers": ["STATUS"],
		"result_rows": [["Record with id = 3 has been removed."]],
		"result_msg": "1 record deleted from active cases.",
					"fail": [
						{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "That is the WRONG case! You just deleted an active investigation!" },
						{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",  "text": "Silence. Your chief stares at you for what feels like forever." },
						{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/police/idle",  "text": "I am sorry Chief! I will select the correct record id this time." }
					]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "Done. Case 3 has been removed from active records, Chief."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/talk",
		"text": "Perfect. A clean database means faster response times. Good discipline."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P6 — ORDER BY
#  Topic: Sorting cases by priority level
# ─────────────────────────────────────────────
"P6": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/police/idle",
		"text": "Morning briefing. The chief needs a priority-sorted case list for the team."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/talk",
		"text": "Pull all open cases sorted by priority — highest first. We tackle the most critical first."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "On it. Sorting by priority highest to lowest now."
	},
	{
		"type": "sql_fill",
		"gamemode": "order_by",
		"desc": "Sort all cases by priority_level from highest to lowest. Type ASC or DESC.",
		"table": "cases",
		"column": "priority_level",
		"table_headers": ["id", "case_type", "status", "priority_level"],
		"table_rows": [
			["1", "Theft",     "Open", "2"],
			["2", "Vandalism", "Open", "1"],
			["4", "Assault",   "Open", "3"],
			["5", "Fraud",     "Open", "2"],
			["6", "Theft",     "Open", "1"],
			["7", "Assault",   "Open", "3"],
			["8", "Vandalism", "Open", "2"],
			["9", "Fraud",     "Open", "3"]
		],
		"answer": "DESC",
		"hint": "Highest first = largest number first = Descending. Type: DESC",
		"result_headers": ["id", "case_type", "status", "priority_level"],
		"result_rows": [
			["4", "Assault",   "Open", "3"],
			["7", "Assault",   "Open", "3"],
			["9", "Fraud",     "Open", "3"],
			["1", "Theft",     "Open", "2"],
			["5", "Fraud",     "Open", "2"],
			["8", "Vandalism", "Open", "2"],
			["2", "Vandalism", "Open", "1"],
			["6", "Theft",     "Open", "1"]
		],
		"result_msg": "Records sorted by priority_level DESC.",
					"fail": [
						{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "Lowest priority first?! We are sending the team to handle vandalism while there is an ASSAULT open?!" },
						{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",  "text": "Your chief grabs the clipboard and looks at you with genuine disbelief." },
						{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/police/idle",  "text": "I will sort highest priority first immediately Chief." }
					]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "Sorted! Assault is highest priority, then Theft, then Vandalism."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/think",
		"text": "Good. Team Alpha takes Assault. Everyone else follows down the list. Let's move."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P7 — GROUP BY
#  Topic: Monthly crime category report
# ─────────────────────────────────────────────
"P7": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/police/idle",
		"text": "End of the month. The chief needs a crime summary report for city council."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/talk",
		"text": "I need a count of cases grouped by case_type. The council needs to know what's most common."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "Running that report now, Chief."
	},
	{
		"type": "sql_fill",
		"gamemode": "group_by",
		"desc": "Count cases by case_type. Fill in the GROUP BY column name.",
		"table": "cases",
		"column": "case_type",
		"table_headers": ["id", "case_type", "status"],
		"table_rows": [
			["1",  "Theft",     "Open"],
			["2",  "Vandalism", "Closed"],
			["3",  "Theft",     "Open"],
			["4",  "Assault",   "Open"],
			["5",  "Vandalism", "Open"],
			["6",  "Theft",     "Closed"],
			["7",  "Assault",   "Closed"],
			["8",  "Fraud",     "Open"],
			["9",  "Theft",     "Open"],
			["10", "Fraud",     "Closed"]
		],
		"answer": "case_type",
		"hint": "Group by the crime type column. Type: case_type",
		"result_headers": ["case_type", "COUNT(*)"],
		"result_rows": [
			["Theft",     "4"],
			["Vandalism", "2"],
			["Assault",   "2"],
			["Fraud",     "2"]
		],
		"result_msg": "Cases grouped by case_type.",
					"fail": [
						{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "These numbers do not add up! You grouped by the WRONG column. The council meets in an hour!" },
						{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",  "text": "Your chief takes a long breath. You can feel the clock ticking." },
						{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/police/idle",  "text": "I will fix the GROUP BY right now and get you the correct report." }
					]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "Report ready! Theft: 3, Vandalism: 2, Assault: 1."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/think",
		"text": "Theft is still our biggest problem. Good data. I'll present this to the council tonight."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P8 — IS NULL  |  NPC: chief
#  Topic: Find suspects with no assigned officer
# ─────────────────────────────────────────────
"P8": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/police/idle",
		"text": "Morning briefing. The chief reviews the suspect database and spots a problem."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/talk",
		"text": "Some suspects have no assigned officer yet — those fields will show as NULL. Can you find which suspects are unassigned?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "Right away Chief. IS NULL will find all rows where the assigned_officer column has no value."
	},
	{
		"type": "sql_fill",
		"gamemode": "select_where_null",
		"desc": "Find all suspects with no assigned officer. Unassigned suspects show as NULL. Type NULL after IS.",
		"table": "suspects",
		"column": "assigned_officer",
		"table_headers": ["id", "name", "case_type", "assigned_officer"],
		"table_rows": [
			["1", "Luis Santos",    "Vandalism", "Officer Cruz"],
			["2", "Ana Cruz",       "Fraud",     ""],
			["3", "Carlos Torres",  "Theft",     "Officer Reyes"],
			["4", "Maria Garcia",   "Assault",   ""],
			["5", "Miguel Lim",     "Vandalism", "Officer Santos"],
			["6", "Rosa Dela Cruz", "Theft",     ""]
		],
		"answer": "NULL",
		"hint": "No assigned officer = NULL. Type: NULL",
		"result_headers": ["id", "name", "case_type", "assigned_officer"],
		"result_rows": [
			["2", "Ana Cruz",       "Fraud",   "NULL"],
			["4", "Maria Garcia",   "Assault", "NULL"],
			["6", "Rosa Dela Cruz", "Theft",   "NULL"]
		],
		"result_msg": "3 suspects have no assigned officer.",
		"fail": [
			{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "That is wrong! NULL means the officer field is empty — nobody is assigned yet." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",  "text": "The chief taps the blank cells in the assigned_officer column." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/police/idle",  "text": "Right — IS NULL checks for missing values. Let me use it correctly." }
		]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "Found them Chief! Ana Cruz, Maria Garcia, and Rosa Dela Cruz are all unassigned."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/think",
		"text": "Good. IS NULL is a critical tool for finding gaps in our records. Assign officers to those three immediately."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P9 — CREATE DATABASE  |  NPC: adult_6 (new officer)
#  Topic: CREATE DATABASE — setting up the database container first
# ─────────────────────────────────────────────
"P9": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_6/idle",
		"text": "A new officer is assigned to the data division. Before reviewing any records, they want to know how the entire police database was first created."
	},
	{
		"type": "dialogue",
		"char": "citizen",
		"name": "OFFICER",
		"npc":  "adult_6/talk",
		"text": "I know how to SELECT and UPDATE records. But where did this database system come from? Who built it at the very start?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_6/idle",
		"text": "The first step is always CREATE DATABASE. You run it once to create a named container, and then all your tables go inside that container."
	},
	{
		"type": "sql_fill",
		"gamemode": "create_database",
		"desc": "Create the police database. Type the missing keyword between CREATE and PoliceDB.",
		"db_name": "PoliceDB",
		"answer": "DATABASE",
		"hint": "The keyword after CREATE for a new database container is: DATABASE",
		"result_msg": "PoliceDB is now created! All police tables — suspects, cases, assignments — will be stored inside this database.",
		"fail": [
			{ "type": "dialogue", "char": "citizen", "name": "OFFICER", "npc": "adult_6/confuse", "text": "That keyword is incorrect. We are creating a DATABASE container, not a table." },
			{ "type": "dialogue", "char": "scene",   "name": "SCENE",   "npc": "adult_6/idle",   "text": "The officer leans forward to check the screen." },
			{ "type": "dialogue", "char": "you",     "name": "YOU",     "npc": "adult_6/idle",   "text": "The correct keyword is DATABASE — CREATE DATABASE PoliceDB." }
		]
	},
	{
		"type": "dialogue",
		"char": "citizen",
		"name": "OFFICER",
		"npc":  "adult_6/talk",
		"text": "So CREATE DATABASE is the first command — it sets up the container before anything else can be stored. Got it."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_6/idle",
		"text": "Correct. PoliceDB now exists. From here, CREATE TABLE will add the individual tables — suspects, cases — inside it."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P10 — CREATE TABLE  |  NPC: adult_6 (new officer)
#  Topic: CREATE TABLE — defining the table structure
# ─────────────────────────────────────────────
"P10": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_6/idle",
		"text": "The new officer continues their training. After creating the database, they want to know how the cases table was built inside it."
	},
	{
		"type": "dialogue",
		"char": "citizen",
		"name": "OFFICER",
		"npc":  "adult_6/talk",
		"text": "We have the database. But how do we actually define the cases table inside it — the columns, the structure?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_6/idle",
		"text": "We use CREATE TABLE. You name the table and list each column along with its data type. The database then knows exactly how to store each record."
	},
	{
		"type": "sql_fill",
		"gamemode": "create_table_keyword",
		"desc": "Create the cases table inside PoliceDB. Type the missing keyword between CREATE and cases.",
		"table": "cases",
		"columns": [
			["id",            "INT"],
			["reporter_name", "TEXT"],
			["case_type",     "TEXT"],
			["status",        "TEXT"]
		],
		"answer": "TABLE",
		"hint": "The keyword after CREATE for a new table is: TABLE",
		"result_msg": "cases table created! It has 4 columns: id (INT), reporter_name (TEXT), case_type (TEXT), status (TEXT). Every case record will follow this structure.",
		"fail": [
			{ "type": "dialogue", "char": "citizen", "name": "OFFICER", "npc": "adult_6/confuse", "text": "That is not right. We already have the database — now we are creating a TABLE inside it." },
			{ "type": "dialogue", "char": "scene",   "name": "SCENE",   "npc": "adult_6/idle",   "text": "The officer checks their notes." },
			{ "type": "dialogue", "char": "you",     "name": "YOU",     "npc": "adult_6/idle",   "text": "The keyword is TABLE — CREATE TABLE cases." }
		]
	},
	{
		"type": "dialogue",
		"char": "citizen",
		"name": "OFFICER",
		"npc":  "adult_6/talk",
		"text": "CREATE TABLE — and the columns are listed inside the parentheses with their types. The database enforces that structure for every row."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_6/idle",
		"text": "Exactly. First CREATE DATABASE, then CREATE TABLE. The structure is set — now you can INSERT cases into it."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P11 — PRIMARY KEY  |  NPC: adult_6 (new officer)
#  Topic: CREATE TABLE with PRIMARY KEY constraint
# ─────────────────────────────────────────────
"P11": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_6/idle",
		"text": "A new officer joins the station and wants to understand how the cases database was built from scratch."
	},
	{
		"type": "dialogue",
		"char": "citizen",
		"name": "OFFICER",
		"npc":  "adult_6/talk",
		"text": "Can you show me the SQL that creates the cases table? I want to understand why every case gets a unique id."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_6/idle",
		"text": "Sure! The id column gets a constraint called PRIMARY KEY when we CREATE TABLE. It ensures every case id is unique and can never be left blank."
	},
	{
		"type": "sql_fill",
		"gamemode": "create_table",
		"desc": "Complete the CREATE TABLE statement for the cases table. The 'id' column must be the PRIMARY KEY — type it in the blank.",
		"table": "cases",
		"pk_col": "id",
		"columns": [
			["id",            "INT"],
			["reporter_name", "TEXT"],
			["case_type",     "TEXT"],
			["status",        "TEXT"]
		],
		"answer": "PRIMARY KEY",
		"hint": "The constraint that makes a column unique for every row is: PRIMARY KEY",
		"result_msg": "Table created! The PRIMARY KEY on 'id' means every case gets a permanent unique number — even if two cases involve the same suspect.",
		"fail": [
			{ "type": "dialogue", "char": "citizen", "name": "OFFICER", "npc": "adult_6/confuse", "text": "That is not correct. The constraint is two words — PRIMARY and KEY together." },
			{ "type": "dialogue", "char": "scene",   "name": "SCENE",   "npc": "adult_6/idle",   "text": "The officer waits, arms crossed." },
			{ "type": "dialogue", "char": "you",     "name": "YOU",     "npc": "adult_6/idle",   "text": "Let me type the constraint correctly — PRIMARY KEY." }
		]
	},
	{
		"type": "dialogue",
		"char": "citizen",
		"name": "OFFICER",
		"npc":  "adult_6/talk",
		"text": "So PRIMARY KEY goes right after INT! That means case id 4 will always be case id 4 — it can never be reused or duplicated."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_6/idle",
		"text": "Exactly. The PRIMARY KEY is what gives every row its own permanent identity in the database."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P12 — JOIN  |  NPC: chief
#  Topic: FOREIGN KEY / JOIN — combining two tables
# ─────────────────────────────────────────────
"P12": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/police/idle",
		"text": "The chief wants a combined report — case details alongside assigned officer names — from two separate tables."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/talk",
		"text": "Case info and officer assignments are in separate tables. Can you JOIN them so I see each case with its officer in one report?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "Understood Chief. The cases.id links to assignments.case_id — that is the Foreign Key. I will JOIN on those two columns."
	},
	{
		"type": "sql_fill",
		"gamemode": "join",
		"desc": "JOIN the cases table with the assignments table. The cases 'id' links to assignments 'case_id'. Fill in both column names.",
		"table_a": "cases",
		"table_b": "assignments",
		"table_a_headers": ["id", "case_type", "status"],
		"table_a_rows": [
			["1", "Theft",     "Open"],
			["2", "Vandalism", "Open"],
			["3", "Assault",   "Closed"],
			["4", "Fraud",     "Open"]
		],
		"table_b_headers": ["id", "case_id", "officer_name", "badge"],
		"table_b_rows": [
			["1", "1", "Officer Cruz",   "B-101"],
			["2", "3", "Officer Reyes",  "B-204"],
			["3", "2", "Officer Santos", "B-312"],
			["4", "4", "Officer Lim",    "B-417"]
		],
		"join_col_a": "id",
		"join_col_b": "case_id",
		"hint": "Table A linking column: id | Table B linking column: case_id",
		"result_headers": ["case_type", "status", "officer_name", "badge"],
		"result_rows": [
			["Theft",     "Open",   "Officer Cruz",   "B-101"],
			["Vandalism", "Open",   "Officer Santos", "B-312"],
			["Assault",   "Closed", "Officer Reyes",  "B-204"],
			["Fraud",     "Open",   "Officer Lim",    "B-417"]
		],
		"result_msg": "4 records joined successfully.",
		"fail": [
			{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "The JOIN failed! You need the linking column from each table — check the headers carefully." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",  "text": "The chief taps the id column in cases and the case_id column in assignments." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/police/idle",  "text": "I see — cases.id must equal assignments.case_id. Let me correct it." }
		]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "Done Chief! Cases and officer assignments are now joined in one report."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/think",
		"text": "Good. JOIN lets us connect data across tables — that is exactly how a real police database works. Well done."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P13 — INT  |  NPC: adult_6 (officer)
#  Topic: Data Type INT — whole numbers
# ─────────────────────────────────────────────
"P13": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_6/idle",
		"text": "The officer reviews the cases table definition and asks about the id column's data type."
	},
	{
		"type": "dialogue",
		"char": "citizen",
		"name": "OFFICER",
		"npc":  "adult_6/talk",
		"text": "The id column stores case numbers — 1, 2, 3. They are always whole numbers. What type handles that?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_6/idle",
		"text": "INT — Integer. It stores whole numbers only. No decimals, no letters. Perfect for IDs and sequential numbers."
	},
	{
		"type": "sql_fill",
		"gamemode": "data_type",
		"desc": "Define the cases table. The 'id' column stores a whole number. Fill in the correct data type.",
		"table": "cases",
		"columns": [
			["id",            ""],
			["reporter_name", "TEXT"],
			["case_type",     "TEXT"],
			["status",        "TEXT"]
		],
		"blank_col": "id",
		"answer": "INT",
		"type_hint": "Whole numbers (IDs, counts) use INT.",
		"hint": "A whole number data type (no decimals) is: INT",
		"result_msg": "Correct! INT stores whole numbers — 1, 2, 100. Case #7 will always be case #7, never case #7.5.",
		"fail": [
			{ "type": "dialogue", "char": "citizen", "name": "OFFICER", "npc": "adult_6/confuse", "text": "That is not the right type. id stores whole numbers — no letters, no decimals." },
			{ "type": "dialogue", "char": "scene",   "name": "SCENE",   "npc": "adult_6/idle",   "text": "The officer points at the id column." },
			{ "type": "dialogue", "char": "you",     "name": "YOU",     "npc": "adult_6/idle",   "text": "Whole numbers use INT — Integer." }
		]
	},
	{
		"type": "dialogue",
		"char": "citizen",
		"name": "OFFICER",
		"npc":  "adult_6/talk",
		"text": "INT for integers — whole numbers! Case IDs, badge numbers, counts — anything that cannot be a fraction."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_6/idle",
		"text": "Exactly. Using INT also makes comparisons and sorting faster for the database."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P14 — TEXT  |  NPC: adult_6 (officer)
#  Topic: Data Type TEXT — strings / words
# ─────────────────────────────────────────────
"P14": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_6/idle",
		"text": "The officer now looks at the other columns in the cases table."
	},
	{
		"type": "dialogue",
		"char": "citizen",
		"name": "OFFICER",
		"npc":  "adult_6/talk",
		"text": "reporter_name holds a person's name like 'Maria Santos'. case_type holds words like 'Theft'. What type is used for those?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_6/idle",
		"text": "TEXT — it stores any sequence of characters. Names, descriptions, categories — anything made of letters."
	},
	{
		"type": "sql_fill",
		"gamemode": "data_type",
		"desc": "Define the cases table. The 'reporter_name' column stores a person's name. Fill in the correct data type.",
		"table": "cases",
		"columns": [
			["id",            "INT"],
			["reporter_name", ""],
			["case_type",     "TEXT"],
			["status",        "TEXT"]
		],
		"blank_col": "reporter_name",
		"answer": "TEXT",
		"type_hint": "Names and words use TEXT (also called STRING).",
		"hint": "Letters and words use: TEXT  (also called STRING)",
		"result_msg": "Correct! TEXT stores words and characters — 'Maria Santos', 'Theft', 'Open'. You can also type STRING and it means the same thing.",
		"fail": [
			{ "type": "dialogue", "char": "citizen", "name": "OFFICER", "npc": "adult_6/confuse", "text": "Not right. reporter_name stores a name — letters, not a number." },
			{ "type": "dialogue", "char": "scene",   "name": "SCENE",   "npc": "adult_6/idle",   "text": "The officer looks at a sample record." },
			{ "type": "dialogue", "char": "you",     "name": "YOU",     "npc": "adult_6/idle",   "text": "Letters and words use TEXT — also called STRING." }
		]
	},
	{
		"type": "dialogue",
		"char": "citizen",
		"name": "OFFICER",
		"npc":  "adult_6/talk",
		"text": "TEXT for words — names, categories, descriptions. INT for numbers. Two types already cover most of what we store."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_6/idle",
		"text": "Right. And there is one more type for when we need decimal numbers."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P15 — REAL  |  NPC: chief
#  Topic: Data Type REAL — decimal / float numbers
# ─────────────────────────────────────────────
"P15": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/police/idle",
		"text": "The chief asks you to create a fines table to track penalty amounts for different offences."
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/talk",
		"text": "The fine_amount column needs to store values like 150.50 and 200.75. INT cannot store decimals — what type do we use?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "REAL — it stores decimal numbers accurately. Perfect for monetary values, measurements, or any number with a decimal point."
	},
	{
		"type": "sql_fill",
		"gamemode": "data_type",
		"desc": "Define the fines table. The 'fine_amount' column stores a decimal value like 150.50. Fill in the correct data type.",
		"table": "fines",
		"columns": [
			["id",          "INT"],
			["case_id",     "INT"],
			["offence",     "TEXT"],
			["fine_amount", ""]
		],
		"blank_col": "fine_amount",
		"answer": "REAL",
		"type_hint": "Decimal numbers (prices, measurements) use REAL (also called FLOAT).",
		"hint": "Decimal numbers use: REAL  (also called FLOAT)",
		"result_msg": "Correct! REAL stores decimal numbers — 150.50, 200.75, 99.99. You can also type FLOAT and it means the same thing.",
		"fail": [
			{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "Wrong type! fine_amount stores decimal values — not whole numbers and not text." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",  "text": "The chief shows the fine schedule on the desk." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/police/idle",  "text": "Decimal numbers use REAL — also called FLOAT." }
		]
	},
	{
		"type": "dialogue",
		"char": "chief",
		"name": "CHIEF",
		"npc":  "NPC_occupations/police/think",
		"text": "REAL for decimals. So the three types are: INT for whole numbers, TEXT for words, REAL for decimals. Simple and complete."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/police/idle",
		"text": "That covers most real-world data. FLOAT and DOUBLE are other names for the same idea in different database systems."
	},
	{
		"type": "end"
	}
]

} # end LESSONS
