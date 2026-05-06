extends Node
# ═══════════════════════════════════════════════════════
#  LIBRARY DATA  —  scripts/data/LibraryData.gd
#
#  NPC path format:
#    "adult_N/expr"                    → NPC_adults/adult_N/expr.png
#    "NPC_occupations/librarian/expr"  → NPC_occupations/librarian/expr.png
#
#  Character assignments:
#    NPC_occupations/librarian = Librarian (boss)
#    adult_6                   = Adult visitor / student
#    adult_7                   = Another visitor
#
#  Rule: "you" and "scene" always idle — NPC looks at you.
# ═══════════════════════════════════════════════════════

const LESSONS: Dictionary = {

# ─────────────────────────────────────────────
#  LESSON L1 — SELECT (sql_choice)
#  Topic: Responding professionally to a library visitor
# ─────────────────────────────────────────────
"L1": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_6/idle",
		"text": "A quiet Tuesday morning at the library. A visitor approaches your desk looking lost."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "VISITOR",
		"npc":  "adult_6/confuse",
		"text": "Excuse me... I'm looking for books about SQL and databases. I have no idea where to start."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_6/idle",
		"text": "Let me think of the best way to help this visitor."
	},
	{
		"type": "sql_choice",
		"desc": "A visitor needs help finding books. Choose the most helpful librarian response.",
		"options": [
			[1, "Great choice! I can check our database and show you exactly where those books are."],
			[2, "Try looking in the science section. Somewhere over there."],
			[3, "We only have fiction books here."]
		],
		"correct_id": 1,
		"hint": "A good librarian uses the system and gives direct help. Answer: id = 1"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_6/idle",
		"text": "Great choice! Let me check our database and show you exactly where those books are."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "VISITOR",
		"npc":  "adult_6/idle",
		"text": "Oh wonderful! You're so much more helpful than I expected. Thank you!"
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L2 — INSERT INTO
#  Topic: Registering a new borrower
# ─────────────────────────────────────────────
"L2": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_6/idle",
		"text": "A student walks up to the desk wanting to borrow books for the first time."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "STUDENT",
		"npc":  "adult_6/talk",
		"text": "Hi! I'd like to register as a borrower. My name is Sofia Mendez."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_6/idle",
		"text": "Welcome, Sofia! Let me add you to our borrower database right now."
	},
	{
		"type": "sql_fill",
		"gamemode": "insert_into",
		"desc": "Register Sofia Mendez as a new borrower. Fill in first_name, last_name, and membership_type.",
		"table": "borrowers",
		"columns": ["first_name", "last_name", "membership_type"],
		"table_headers": ["id", "first_name", "last_name", "membership_type"],
		"table_rows": [],
		"answers": ["Sofia", "Mendez", "Student"],
		"hint": "First: Sofia | Last: Mendez | Type: Student",
		"result_headers": ["id", "first_name", "last_name", "membership_type"],
		"result_rows": [["5", "Sofia", "Mendez", "Student"]],
		"result_msg": "1 record inserted into borrowers."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_6/idle",
		"text": "You're all set, Sofia! Your borrower ID is 5. You can borrow up to 5 books at a time."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "STUDENT",
		"npc":  "adult_6/idle",
		"text": "That's amazing! I'm going to borrow so many books. Thank you!"
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L3 — SELECT WHERE
#  Topic: Finding a specific book record
# ─────────────────────────────────────────────
"L3": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "The head librarian approaches you with a request from a faculty member."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/talk",
		"text": "A professor is looking for books in the Science genre. Can you search the catalog for them?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Of course! Searching the catalog by genre right now."
	},
	{
		"type": "sql_fill",
		"gamemode": "select_where",
		"desc": "Search the books table for all books in the Science genre. Fill in the WHERE clause.",
		"table": "books",
		"column": "genre",
		"table_headers": ["id", "title", "author", "genre"],
		"table_rows": [
			["1", "SQL Basics",         "Rivera",  "Technology"],
			["2", "The Universe",       "Hawking",  "Science"],
			["3", "Brief History",      "Sagan",    "Science"],
			["4", "Design Patterns",    "GoF",      "Technology"]
		],
		"answer": "Science",
		"hint": "Type the genre exactly: Science",
		"result_headers": ["id", "title", "author", "genre"],
		"result_rows": [
			["2", "The Universe",  "Hawking", "Science"],
			["3", "Brief History", "Sagan",   "Science"]
		],
		"result_msg": "2 records found."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Found 2 Science books — The Universe by Hawking and Brief History by Sagan. Both are on shelf C3."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Perfect. That's exactly what the professor needed. Good database work."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L4 — UPDATE SET
#  Topic: Updating a book's return date
# ─────────────────────────────────────────────
"L4": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_7/idle",
		"text": "A borrower calls in requesting a return date extension for their borrowed book."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "BORROWER",
		"npc":  "adult_7/confuse",
		"text": "Hi, this is Mr. Tan. I borrowed book id 2 but I need more time. Can you extend it to June 30?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_7/idle",
		"text": "Sure, Mr. Tan! Let me update the return date in the system for you."
	},
	{
		"type": "sql_fill",
		"gamemode": "update_set",
		"desc": "Update the return_date for borrow record id = 2 to June 30.",
		"table": "borrows",
		"column": "return_date",
		"table_headers": ["id", "borrower_name", "book_title", "return_date"],
		"table_rows": [
			["2", "Mr. Tan", "The Universe", "June 15"]
		],
		"answer_value": "June 30",
		"answer_id": "2",
		"hint": "New return date: June 30 | Record id: 2",
		"result_headers": ["id", "borrower_name", "book_title", "return_date"],
		"result_rows": [["2", "Mr. Tan", "The Universe", "June 30"]],
		"result_msg": "1 record updated."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_7/idle",
		"text": "Done, Mr. Tan! Your return date has been extended to June 30. Enjoy the book!"
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "BORROWER",
		"npc":  "adult_7/idle",
		"text": "Oh thank you so much! You've been incredibly helpful."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L5 — DELETE
#  Topic: Removing an overdue record after resolution
# ─────────────────────────────────────────────
"L5": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "The head librarian reviews the overdue list and flags a resolved record for removal."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/talk",
		"text": "Borrow record id 3 has been settled and the book returned. Please remove it from the overdue list."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Understood! Removing record id 3 from the overdue list now."
	},
	{
		"type": "sql_fill",
		"gamemode": "delete",
		"desc": "Remove the settled overdue record from the overdue table. Record id = 3.",
		"table": "overdue",
		"table_headers": ["id", "borrower_name", "book_title", "days_overdue"],
		"table_rows": [
			["3", "Sofia Mendez", "SQL Basics", "14"]
		],
		"answer_id": "3",
		"hint": "Delete the record where id = 3",
		"result_headers": ["STATUS"],
		"result_rows": [["Record with id = 3 has been removed."]],
		"result_msg": "1 record deleted from overdue."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Done! Sofia Mendez's overdue record has been cleared from the list."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Thank you. A clean overdue list helps us track real problems. Well done."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L6 — ORDER BY
#  Topic: Sorting books alphabetically by title
# ─────────────────────────────────────────────
"L6": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "The librarian is reorganizing the digital catalog and needs the books in order."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/talk",
		"text": "Can you pull all books sorted alphabetically by title, A to Z? I need to verify the shelf order."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Sure! Sorting the catalog alphabetically by title now."
	},
	{
		"type": "sql_fill",
		"gamemode": "order_by",
		"desc": "Sort all books A to Z by title. Type ASC or DESC.",
		"table": "books",
		"column": "title",
		"table_headers": ["id", "title", "author", "genre"],
		"table_rows": [
			["1", "SQL Basics",      "Rivera",  "Technology"],
			["2", "The Universe",    "Hawking",  "Science"],
			["3", "Brief History",   "Sagan",    "Science"],
			["4", "Design Patterns", "GoF",      "Technology"]
		],
		"answer": "ASC",
		"hint": "A to Z = Ascending. Type: ASC",
		"result_headers": ["id", "title", "author", "genre"],
		"result_rows": [
			["3", "Brief History",   "Sagan",   "Science"],
			["4", "Design Patterns", "GoF",     "Technology"],
			["1", "SQL Basics",      "Rivera",  "Technology"],
			["2", "The Universe",    "Hawking", "Science"]
		],
		"result_msg": "Records sorted by title ASC."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Sorted! Brief History, Design Patterns, SQL Basics, The Universe — all A to Z."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/think",
		"text": "Perfect alphabetical order. That matches the shelves exactly. Excellent work."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L7 — GROUP BY
#  Topic: Books count grouped by genre
# ─────────────────────────────────────────────
"L7": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Budget meeting week. The head librarian needs a genre breakdown for the acquisition report."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/talk",
		"text": "I need a count of how many books we have per genre. It's for the annual budget proposal."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "On it! Grouping the catalog by genre and counting right now."
	},
	{
		"type": "sql_fill",
		"gamemode": "group_by",
		"desc": "Count how many books are in each genre. Fill in the GROUP BY column name.",
		"table": "books",
		"column": "genre",
		"table_headers": ["id", "title", "genre"],
		"table_rows": [
			["1", "SQL Basics",         "Technology"],
			["2", "The Universe",       "Science"],
			["3", "Brief History",      "Science"],
			["4", "Design Patterns",    "Technology"],
			["5", "The Great Gatsby",   "Fiction"],
			["6", "Clean Code",         "Technology"]
		],
		"answer": "genre",
		"hint": "Group by the genre column. Type: genre",
		"result_headers": ["genre", "COUNT(*)"],
		"result_rows": [
			["Technology", "3"],
			["Science",    "2"],
			["Fiction",    "1"]
		],
		"result_msg": "Books grouped by genre."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Report done! Technology: 3, Science: 2, Fiction: 1."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/think",
		"text": "We're heavy on Technology and light on Fiction. That helps me plan next year's budget. Excellent."
	},
	{
		"type": "end"
	}
]

} # end LESSONS
