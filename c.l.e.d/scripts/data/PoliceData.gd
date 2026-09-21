extends Node
# ═══════════════════════════════════════════════════════
#  POLICE DATA  |  scripts/data/PoliceData.gd
#
#  NPC assignments (Police World | unique to this world):
#    adult_5 = Male citizen / reporter
#    adult_6 = Female citizen / witness
#    NPC_occupations/police = Officer / Chief (boss)
#
#  Rule: "you" and "scene" always idle | NPC looks at you.
# ═══════════════════════════════════════════════════════

const LESSONS: Dictionary = {
#
#  Curriculum trimmed to query-only lessons (Basic SQL,
#  Filtering Rows, Sorting & Aggregates) per panel feedback.
#  Joins/Subqueries, Functions, and all schema/DDL chapters
#  (Creating Tables, Constraints & Keys, Schema Management,
#  Advanced Concepts) were removed.

# ─────────────────────────────────────────────
#  LESSON P1 | SELECT (sql_choice)
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
#  LESSON P2 | INSERT INTO
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
		"hint": "Reporter: Marco Reyes Type: Theft Status: Open",
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
#  LESSON P3 | SELECT WHERE
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
		"text": "Found 3 suspects with last name Santos Luis (Vandalism), Maria (Theft), Sofia (Assault). Pulling full files now, Chief."
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
#  LESSON P4 | UPDATE SET
#  Topic: Updating a case status after an arrest
# ─────────────────────────────────────────────
"P4": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/police/idle",
		"text": "An officer radios in a suspect from case 2 has been apprehended."
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
		"hint": "Change status to: Closed Record id: 2",
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
		"text": "Good. Keep the database clean accurate records save lives in this job."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON P5 | DELETE
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
#  LESSON P6 | ORDER BY
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
		"text": "Pull all open cases sorted by priority highest first. We tackle the most critical first."
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
#  LESSON P7 | GROUP BY
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
#  LESSON P8 | IS NULL  |  NPC: chief
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
		"text": "Some suspects have no assigned officer yet those fields will show as NULL. Can you find which suspects are unassigned?"
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
			{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "That is wrong! NULL means the officer field is empty nobody is assigned yet." },
			{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",  "text": "The chief taps the blank cells in the assigned_officer column." },
			{ "type": "dialogue", "char": "you",   "name": "YOU",   "npc": "NPC_occupations/police/idle",  "text": "Right IS NULL checks for missing values. Let me use it correctly." }
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
#  LESSON P16 | SELECT DISTINCT  |  NPC: police chief
# ─────────────────────────────────────────────
"P16": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",
	  "text": "The chief wants a summary of what types of cases the station handles without counting each case individually." },
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "I need a list of all distinct case types we have on record. Each type should appear only once." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "SELECT DISTINCT returns unique values from a column. Duplicate entries are automatically removed." },
	{ "type": "sql_fill", "gamemode": "select_distinct",
	  "desc": "Return only the unique case types from the cases table. Fill in the column name after SELECT DISTINCT.",
	  "table": "cases",
	  "column": "case_type",
	  "table_headers": ["id","suspect","case_type","status"],
	  "table_rows": [["1","Santos","Theft","Open"],["2","Cruz","Vandalism","Closed"],["3","Reyes","Theft","Open"],["4","Lim","Assault","Open"],["5","Garcia","Vandalism","Closed"],["6","Torres","Theft","Open"]],
	  "hint": "The column with repeating case categories: case_type",
	  "result_headers": ["case_type"],
	  "result_rows": [["Theft"],["Vandalism"],["Assault"]],
	  "result_msg": "3 unique case types. DISTINCT removed repeated Theft and Vandalism entries.",
	  "fail": [
		{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "That column does not exist in the cases table!" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle", "text": "The column is: case_type" }
	  ]
	},
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "Theft, Vandalism, Assault. DISTINCT gives me a clean category list without manual deduplication." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "Right. Without DISTINCT you would see Theft three times and Vandalism twice in the results." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON P17 | AND/OR  |  NPC: police chief
# ─────────────────────────────────────────────
"P17": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",
	  "text": "The chief needs to find open theft cases specifically not just any theft and not just any open case." },
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "I need cases where type is 'Theft' AND status is 'Open'. Both conditions must apply at the same time." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "AND requires both conditions true simultaneously. OR would include any theft OR any open case." },
	{ "type": "sql_fill", "gamemode": "where_and_or",
	  "desc": "Find cases where case_type is 'Theft' AND status is 'Open'. Fill in AND or OR.",
	  "table": "cases",
	  "condition1": "case_type = 'Theft'",
	  "condition2": "status = 'Open'",
	  "answer": "AND",
	  "table_headers": ["id","suspect","case_type","status"],
	  "table_rows": [["1","Santos","Theft","Open"],["2","Cruz","Vandalism","Open"],["3","Reyes","Theft","Closed"],["4","Lim","Theft","Open"],["5","Garcia","Assault","Open"]],
	  "hint": "Both conditions required: AND",
	  "result_headers": ["id","suspect","case_type","status"],
	  "result_rows": [["1","Santos","Theft","Open"],["4","Lim","Theft","Open"]],
	  "result_msg": "2 open theft cases. AND is strict both conditions must hold. OR would give 4 results.",
	  "fail": [
		{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "Too many results. I need BOTH conditions true not one or the other." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle", "text": "Both conditions required: AND." }
	  ]
	},
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "Only Santos and Lim open theft cases. AND narrows the search precisely." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "OR would include Cruz (open but not theft) and Reyes (theft but closed) too broad." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON P18 | BETWEEN  |  NPC: police chief
# ─────────────────────────────────────────────
"P18": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",
	  "text": "The chief wants a report on mid-range fines to identify payment compliance patterns." },
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "Show me cases where the fine is between 500 and 2000. Include those exact amounts too." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "BETWEEN filters an inclusive range 500 and 2000 are included in the results." },
	{ "type": "sql_fill", "gamemode": "where_between",
	  "desc": "Find cases where fine_amount is between 500 and 2000. Fill in the range keyword.",
	  "table": "cases",
	  "column": "fine_amount",
	  "low": "500", "high": "2000",
	  "answer": "BETWEEN",
	  "table_headers": ["id","suspect","case_type","fine_amount"],
	  "table_rows": [["1","Santos","Theft","2500"],["2","Cruz","Vandalism","800"],["3","Reyes","Theft","500"],["4","Lim","Assault","300"],["5","Garcia","Vandalism","1500"],["6","Torres","Theft","3000"]],
	  "hint": "The inclusive range keyword: BETWEEN",
	  "result_headers": ["id","suspect","case_type","fine_amount"],
	  "result_rows": [["2","Cruz","Vandalism","800"],["3","Reyes","Theft","500"],["5","Garcia","Vandalism","1500"]],
	  "result_msg": "3 cases in range. Santos (2500) and Torres (3000) are too high. Lim (300) is too low.",
	  "fail": [
		{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "Wrong keyword. BETWEEN is used for range filtering." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle", "text": "The range keyword is BETWEEN." }
	  ]
	},
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "3 mid-range fines. BETWEEN is more readable than fine_amount >= 500 AND fine_amount <= 2000." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "BETWEEN also works on dates: WHERE incident_date BETWEEN '2024-01-01' AND '2024-12-31'." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON P19 | LIKE  |  NPC: police chief
# ─────────────────────────────────────────────
"P19": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",
	  "text": "A witness reported a suspect whose last name starts with M. The chief needs all such suspects." },
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "Find all suspects whose last name starts with the letter M. We have a partial name match situation." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "LIKE with 'M%' matches any last name that starts with M, followed by any characters." },
	{ "type": "sql_fill", "gamemode": "where_like",
	  "desc": "Find suspects whose last_name starts with 'M'. Fill in the LIKE pattern.",
	  "table": "suspects",
	  "column": "last_name",
	  "answer": "'M%'",
	  "table_headers": ["id","first_name","last_name"],
	  "table_rows": [["1","Jose","Mendoza"],["2","Ana","Santos"],["3","Carlos","Mallari"],["4","Linda","Reyes"],["5","Marco","Manalo"],["6","Felix","Torres"]],
	  "hint": "Starts with M then anything: 'M%'",
	  "result_headers": ["id","first_name","last_name"],
	  "result_rows": [["1","Jose","Mendoza"],["3","Carlos","Mallari"],["5","Marco","Manalo"]],
	  "result_msg": "3 suspects found. Mendoza, Mallari, Manalo all start with M.",
	  "fail": [
		{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "Wrong pattern. To match names starting with M: 'M%'" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle", "text": "The pattern is: 'M%'" }
	  ]
	},
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "Mendoza, Mallari, Manalo. LIKE handles partial matches that exact WHERE cannot." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "'%doza' would find names ending with doza. '%end%' would find names containing 'end'." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON P20 | IN  |  NPC: police chief
# ─────────────────────────────────────────────
"P20": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",
	  "text": "The chief wants a report covering only theft and vandalism cases for a community meeting." },
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "I only need Theft and Vandalism. Is there a cleaner way than writing two OR conditions?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "IN lets you check if a column value matches any item in a list. Much cleaner than chained OR." },
	{ "type": "sql_fill", "gamemode": "where_in",
	  "desc": "Find cases where case_type is Theft or Vandalism. Fill in the list membership keyword.",
	  "table": "cases",
	  "column": "case_type",
	  "in_list": "('Theft', 'Vandalism')",
	  "answer": "IN",
	  "table_headers": ["id","suspect","case_type","status"],
	  "table_rows": [["1","Santos","Theft","Open"],["2","Cruz","Vandalism","Closed"],["3","Reyes","Assault","Open"],["4","Lim","Theft","Open"],["5","Garcia","Vandalism","Closed"]],
	  "hint": "The list membership keyword is: IN",
	  "result_headers": ["id","suspect","case_type","status"],
	  "result_rows": [["1","Santos","Theft","Open"],["2","Cruz","Vandalism","Closed"],["4","Lim","Theft","Open"],["5","Garcia","Vandalism","Closed"]],
	  "result_msg": "4 cases found. Reyes (Assault) excluded. IN ('Theft','Vandalism') matches either value.",
	  "fail": [
		{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "Wrong keyword. Use IN to match against a list." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle", "text": "The keyword is IN." }
	  ]
	},
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "4 cases for the report. IN is very useful when filtering against several known values." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "NOT IN works too WHERE case_type NOT IN ('Assault') would exclude assault cases." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON P21 | LIMIT  |  NPC: police chief
# ─────────────────────────────────────────────
"P21": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",
	  "text": "The chief wants a quick look at the most recently filed cases without scrolling through hundreds of records." },
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "Just show me the first 5 open cases. I want a quick overview, not the full list." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "LIMIT caps the number of rows returned. It prevents large queries from overwhelming the screen." },
	{ "type": "sql_fill", "gamemode": "limit",
	  "desc": "Return only the first 5 cases. Type the number after LIMIT.",
	  "table": "cases",
	  "answer": "5",
	  "table_headers": ["id","suspect","case_type","status"],
	  "table_rows": [["1","Santos","Theft","Open"],["2","Cruz","Vandalism","Closed"],["3","Reyes","Assault","Open"],["4","Lim","Theft","Open"],["5","Garcia","Vandalism","Closed"],["6","Torres","Theft","Open"],["7","Flores","Assault","Open"]],
	  "hint": "Show only 5 rows type: 5",
	  "result_headers": ["id","suspect","case_type","status"],
	  "result_rows": [["1","Santos","Theft","Open"],["2","Cruz","Vandalism","Closed"],["3","Reyes","Assault","Open"],["4","Lim","Theft","Open"],["5","Garcia","Vandalism","Closed"]],
	  "result_msg": "5 cases shown. Torres and Flores were not fetched. LIMIT is essential for large databases.",
	  "fail": [
		{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "That is not 5 cases. Type the number 5." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle", "text": "Type the number 5 after LIMIT." }
	  ]
	},
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "5 cases only clean overview. LIMIT with ORDER BY id DESC would give the most recent cases first." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "Exactly. TOP 5 most urgent: ORDER BY priority DESC LIMIT 5." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON P22 | COUNT  |  NPC: police chief
# ─────────────────────────────────────────────
"P22": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",
	  "text": "The precinct report requires the total number of suspects currently in the database." },
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "How many suspects do we have on record? Give me a single number for the quarterly report." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "COUNT is an aggregate function that returns the number of matching rows." },
	{ "type": "sql_fill", "gamemode": "aggregate",
	  "desc": "Count the total number of suspects. Fill in the aggregate function name.",
	  "table": "suspects",
	  "column": "id",
	  "answer": "COUNT",
	  "table_headers": ["id","first_name","last_name","case_id"],
	  "table_rows": [["1","Jose","Mendoza","1"],["2","Ana","Santos","2"],["3","Carlos","Mallari","3"],["4","Linda","Reyes","4"],["5","Marco","Manalo","5"]],
	  "hint": "To count rows: COUNT",
	  "result_headers": ["COUNT(id)"],
	  "result_rows": [["5"]],
	  "result_msg": "5 suspects on record.\n\nOther aggregate functions:\n- SUM(fine_amount) totals all fines collected\n- AVG(fine_amount) finds the average fine",
	  "fail": [
		{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "Wrong function. To count rows: COUNT." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle", "text": "The counting function is COUNT." }
	  ]
	},
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "5 suspects. COUNT is my go-to for quick census queries." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "SELECT SUM(fine_amount) gives total fines issued. AVG shows the average fine per case." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON P23 | HAVING  |  NPC: police chief
# ─────────────────────────────────────────────
"P23": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",
	  "text": "The chief wants to identify case types that have more than 2 reported incidents a crime trend report." },
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "I grouped by case_type but need to filter out types with only 1 or 2 cases. WHERE won't work here." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "Use HAVING it filters after GROUP BY. WHERE cannot reference aggregate results like COUNT." },
	{ "type": "sql_fill", "gamemode": "having",
	  "desc": "Show case types with more than 2 incidents. Fill in the aggregate function in HAVING.",
	  "table": "cases",
	  "group_col": "case_type",
	  "answer": "COUNT",
	  "table_headers": ["id","suspect","case_type"],
	  "table_rows": [["1","Santos","Theft"],["2","Cruz","Vandalism"],["3","Reyes","Theft"],["4","Lim","Assault"],["5","Garcia","Theft"],["6","Torres","Vandalism"]],
	  "hint": "HAVING filters groups using: COUNT",
	  "result_headers": ["case_type","COUNT(*)"],
	  "result_rows": [["Theft","3"]],
	  "result_msg": "Only Theft has more than 2 cases. Vandalism has 2 (not more than 2). Assault has 1.",
	  "fail": [
		{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "Wrong function in HAVING. Use COUNT to filter by group size." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle", "text": "HAVING uses COUNT." }
	  ]
	},
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "Theft is the dominant crime type. HAVING let me filter groups that WHERE cannot reach." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "Think of it as: WHERE = filter rows first, GROUP BY = form groups, HAVING = filter the groups." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON P24 | AS (Aliases)  |  NPC: police chief
# ─────────────────────────────────────────────
"P24": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/police/idle",
	  "text": "The chief needs a readable report showing fine discounts but the expression name is messy." },
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "The column shows 'fine_amount * 0.1' instead of a proper label. Can we rename it in the output?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "AS gives a column a display alias. It only changes the label in output the table is untouched." },
	{ "type": "sql_fill", "gamemode": "select_alias",
	  "desc": "Rename the calculated column to 'discount_amount'. Fill in the alias name after AS.",
	  "table": "cases",
	  "col_expr": "fine_amount * 0.1",
	  "answer": "discount_amount",
	  "table_headers": ["id","suspect","fine_amount"],
	  "table_rows": [["1","Santos","2500"],["2","Cruz","800"],["3","Reyes","500"]],
	  "hint": "The alias for the discount column: discount_amount",
	  "result_headers": ["discount_amount"],
	  "result_rows": [["250.0"],["80.0"],["50.0"]],
	  "result_msg": "Column displays as 'discount_amount'. AS is purely cosmetic fine_amount is unchanged in the table.",
	  "fail": [
		{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/shock", "text": "Wrong alias. The alias should be: discount_amount" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle", "text": "Type the alias: discount_amount" }
	  ]
	},
	{ "type": "dialogue", "char": "chief", "name": "CHIEF", "npc": "NPC_occupations/police/talk",
	  "text": "Readable report! AS is useful for any calculated column that would otherwise have an ugly name." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/police/idle",
	  "text": "You can also alias table names: FROM cases AS c shortens long JOIN queries." },
	{ "type": "end" }
],


} # end LESSONS

