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
			["1", "Marco",  "Reyes",  "Theft"],
			["2", "Luis",   "Santos", "Vandalism"],
			["3", "Ana",    "Cruz",   "Fraud"]
		],
		"answer": "Santos",
		"hint": "Type the last name exactly: Santos",
		"result_headers": ["id", "first_name", "last_name", "case_type"],
		"result_rows": [["2", "Luis", "Santos", "Vandalism"]],
		"result_msg": "1 record found.",
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
		"text": "Found it! Luis Santos, linked to a Vandalism case. Pulling the full file now, Chief."
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
		"table_rows": [["2", "Ana Cruz", "Vandalism", "Open"]],
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
		"table_rows": [["3", "Marco Reyes", "Fraud", "Cleared"]],
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
			["4", "Assault",   "Open", "3"]
		],
		"answer": "DESC",
		"hint": "Highest first = largest number first = Descending. Type: DESC",
		"result_headers": ["id", "case_type", "status", "priority_level"],
		"result_rows": [
			["4", "Assault",   "Open", "3"],
			["1", "Theft",     "Open", "2"],
			["2", "Vandalism", "Open", "1"]
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
			["1", "Theft",     "Open"],
			["2", "Vandalism", "Closed"],
			["3", "Theft",     "Open"],
			["4", "Assault",   "Open"],
			["5", "Vandalism", "Open"],
			["6", "Theft",     "Closed"]
		],
		"answer": "case_type",
		"hint": "Group by the crime type column. Type: case_type",
		"result_headers": ["case_type", "COUNT(*)"],
		"result_rows": [
			["Theft",     "3"],
			["Vandalism", "2"],
			["Assault",   "1"]
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
]

} # end LESSONS
