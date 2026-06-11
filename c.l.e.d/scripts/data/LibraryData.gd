extends Node
# ═══════════════════════════════════════════════════════
#  LIBRARY DATA  —  scripts/data/LibraryData.gd
#
#  NPC assignments (Library World — unique to this world):
#    adult_7  = Visitor (L1 — gender-neutral)
#    adult_16 = Sofia Mendez, female student (L2)
#    adult_8  = Borrower (L4)
#    NPC_occupations/librarian = Head librarian (boss)
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
		"npc":  "adult_7/idle",
		"text": "A quiet Tuesday morning at the library. A visitor approaches your desk looking lost."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "VISITOR",
		"npc":  "adult_7/confuse",
		"text": "Excuse me... I'm looking for books about SQL and databases. I have no idea where to start."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_7/idle",
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
		"hint": "A good librarian uses the system and gives direct help. Answer: id = 1",
		"fail": [
			{ "type": "dialogue", "char": "visitor", "name": "VISITOR", "npc": "adult_7/shock", "text": "That is not helpful at all. I will just go somewhere else." },
			{ "type": "dialogue", "char": "scene",   "name": "SCENE",   "npc": "adult_7/idle",  "text": "The visitor turns and leaves. You notice the librarian watching from across the room." },
			{ "type": "dialogue", "char": "you",     "name": "YOU",     "npc": "adult_7/idle",  "text": "I should have used the database. Let me choose the right response." }
		]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_7/idle",
		"text": "Great choice! Let me check our database and show you exactly where those books are."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "VISITOR",
		"npc":  "adult_7/talk",
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
		"npc":  "adult_16/idle",
		"text": "A student walks up to the desk wanting to borrow books for the first time."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "STUDENT",
		"npc":  "adult_16/talk",
		"text": "Hi! I'd like to register as a borrower. My name is Sofia Mendez."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_16/idle",
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
		"result_msg": "1 record inserted into borrowers.",
		"fail": [
			{ "type": "dialogue", "char": "visitor",  "name": "STUDENT", "npc": "adult_16/confuse", "text": "That is not my name... Are you sure you typed it right?" },
			{ "type": "dialogue", "char": "scene",    "name": "SCENE",   "npc": "adult_16/idle",   "text": "Sofia tilts her head at the screen. Other students waiting in line exchange glances." },
			{ "type": "dialogue", "char": "you",      "name": "YOU",     "npc": "adult_16/idle",   "text": "I am sorry, let me enter your details correctly." }
		]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_16/idle",
		"text": "You're all set, Sofia! Your borrower ID is 5. You can borrow up to 5 books at a time."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "STUDENT",
		"npc":  "adult_16/talk",
		"text": "That's amazing! I'm going to borrow so many books. Thank you!"
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L3 — SELECT WHERE
#  Topic: Finding books by genre
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
			["1",  "SQL Basics",       "Rivera",     "Technology"],
			["2",  "The Universe",     "Hawking",    "Science"],
			["3",  "Brief History",    "Sagan",      "Science"],
			["4",  "Design Patterns",  "GoF",        "Technology"],
			["5",  "The Great Gatsby", "Fitzgerald", "Fiction"],
			["6",  "Clean Code",       "Martin",     "Technology"],
			["7",  "Cosmos",           "Sagan",      "Science"],
			["8",  "Database Design",  "Chen",       "Technology"],
			["9",  "Animal Farm",      "Orwell",     "Fiction"],
			["10", "Physics 101",      "Einstein",   "Science"]
		],
		"answer": "Science",
		"hint": "Type the genre exactly: Science",
		"result_headers": ["id", "title", "author", "genre"],
		"result_rows": [
			["2",  "The Universe",  "Hawking",  "Science"],
			["3",  "Brief History", "Sagan",    "Science"],
			["7",  "Cosmos",        "Sagan",    "Science"],
			["10", "Physics 101",   "Einstein", "Science"]
		],
		"result_msg": "4 records found.",
		"fail": [
			{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "That is not the right genre! The professor needed Science not Technology!" },
			{ "type": "dialogue", "char": "scene",     "name": "SCENE",     "npc": "NPC_occupations/librarian/idle",  "text": "The librarian sighs and glances at the clock. The professor's class starts soon." },
			{ "type": "dialogue", "char": "you",       "name": "YOU",       "npc": "NPC_occupations/librarian/idle",  "text": "I will search with the correct genre value." }
		]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Found 4 Science books — The Universe, Brief History, Cosmos, and Physics 101. All on shelf C3."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/talk",
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
		"npc":  "adult_8/idle",
		"text": "A borrower comes in requesting a return date extension for their borrowed book."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "BORROWER",
		"npc":  "adult_8/confuse",
		"text": "Hi! I borrowed book id 2 but I need more time to finish it. Can you extend my return date to June 30?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_8/idle",
		"text": "Sure! Let me update the return date in the system for you."
	},
	{
		"type": "sql_fill",
		"gamemode": "update_set",
		"desc": "Update the return_date for borrow record id = 2 to June 30.",
		"table": "borrows",
		"column": "return_date",
		"table_headers": ["id", "borrower_name", "book_title", "return_date"],
		"table_rows": [
			["1", "Maria Santos",  "SQL Basics",       "June 10"],
			["2", "Mr. Tan",       "The Universe",     "June 15"],
			["3", "Sofia Mendez",  "Brief History",    "June 20"],
			["4", "Carlos Reyes",  "Clean Code",       "June 18"],
			["5", "Ana Torres",    "Design Patterns",  "June 25"],
			["6", "Kim Park",      "Cosmos",           "June 22"],
			["7", "Rosa Lim",      "Physics 101",      "June 28"]
		],
		"answer_value": "June 30",
		"answer_id": "2",
		"hint": "New return date: June 30 | Record id: 2",
		"result_headers": ["id", "borrower_name", "book_title", "return_date"],
		"result_rows": [["2", "Mr. Tan", "The Universe", "June 30"]],
		"result_msg": "1 record updated.",
		"fail": [
			{ "type": "dialogue", "char": "visitor",  "name": "BORROWER", "npc": "adult_8/shock",   "text": "That is still June 15! Nothing changed — did the system even update?" },
			{ "type": "dialogue", "char": "scene",    "name": "SCENE",    "npc": "adult_8/idle",   "text": "An awkward silence on the call. This is why accurate data entry matters." },
			{ "type": "dialogue", "char": "you",      "name": "YOU",      "npc": "adult_8/idle",   "text": "I apologize! Let me enter the correct date and id this time." }
		]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_8/idle",
		"text": "Done! Your return date has been extended to June 30. Enjoy the book!"
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "BORROWER",
		"npc":  "adult_8/talk",
		"text": "Oh thank you so much! You've been incredibly helpful."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L5 — DELETE
#  Topic: Removing a resolved overdue record
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
		"desc": "Remove the settled overdue record. Record id = 3.",
		"table": "overdue",
		"table_headers": ["id", "borrower_name", "book_title", "days_overdue"],
		"table_rows": [
			["1", "Carlos Reyes",  "SQL Basics",       "7"],
			["2", "Ana Torres",    "The Universe",     "3"],
			["3", "Sofia Mendez",  "SQL Basics",       "14"],
			["4", "Miguel Cruz",   "Design Patterns",  "21"],
			["5", "Rosa Lim",      "Clean Code",       "5"],
			["6", "James Park",    "Brief History",    "9"],
			["7", "Kim Santos",    "Cosmos",           "2"]
		],
		"answer_id": "3",
		"hint": "Delete the record where id = 3",
		"result_headers": ["STATUS"],
		"result_rows": [["Record with id = 3 has been removed."]],
		"result_msg": "1 record deleted from overdue.",
		"fail": [
			{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "You deleted the WRONG record! That borrower still has an overdue book!" },
			{ "type": "dialogue", "char": "scene",     "name": "SCENE",     "npc": "NPC_occupations/librarian/idle",  "text": "The librarian quickly pulls up the database to assess the damage." },
			{ "type": "dialogue", "char": "you",       "name": "YOU",       "npc": "NPC_occupations/librarian/idle",  "text": "My mistake! I will use the correct id this time." }
		]
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
		"npc":  "NPC_occupations/librarian/talk",
		"text": "Thank you. A clean overdue list helps us track real problems. Well done."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L6 — ORDER BY
#  Topic: Sorting books alphabetically
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
			["1",  "SQL Basics",       "Rivera",     "Technology"],
			["2",  "The Universe",     "Hawking",    "Science"],
			["3",  "Brief History",    "Sagan",      "Science"],
			["4",  "Design Patterns",  "GoF",        "Technology"],
			["5",  "The Great Gatsby", "Fitzgerald", "Fiction"],
			["6",  "Clean Code",       "Martin",     "Technology"],
			["7",  "Cosmos",           "Sagan",      "Science"],
			["8",  "Database Design",  "Chen",       "Technology"],
			["9",  "Animal Farm",      "Orwell",     "Fiction"],
			["10", "Physics 101",      "Einstein",   "Science"]
		],
		"answer": "ASC",
		"hint": "A to Z = Ascending. Type: ASC",
		"result_headers": ["id", "title", "author", "genre"],
		"result_rows": [
			["9",  "Animal Farm",      "Orwell",     "Fiction"],
			["3",  "Brief History",    "Sagan",      "Science"],
			["6",  "Clean Code",       "Martin",     "Technology"],
			["7",  "Cosmos",           "Sagan",      "Science"],
			["8",  "Database Design",  "Chen",       "Technology"],
			["10", "Physics 101",      "Einstein",   "Science"],
			["1",  "SQL Basics",       "Rivera",     "Technology"],
			["5",  "The Great Gatsby", "Fitzgerald", "Fiction"],
			["2",  "The Universe",     "Hawking",    "Science"],
			["4",  "Design Patterns",  "GoF",        "Technology"]
		],
		"result_msg": "Records sorted by title ASC.",
		"fail": [
			{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "Z to A?! That is backwards! The whole catalog is upside down now!" },
			{ "type": "dialogue", "char": "scene",     "name": "SCENE",     "npc": "NPC_occupations/librarian/idle",  "text": "The librarian scrolls through the results with an increasingly pained expression." },
			{ "type": "dialogue", "char": "you",       "name": "YOU",       "npc": "NPC_occupations/librarian/idle",  "text": "I will sort it A to Z properly right now." }
		]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Sorted! Animal Farm to The Universe — all 10 books in A to Z order."
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
			["1",  "SQL Basics",       "Technology"],
			["2",  "The Universe",     "Science"],
			["3",  "Brief History",    "Science"],
			["4",  "Design Patterns",  "Technology"],
			["5",  "The Great Gatsby", "Fiction"],
			["6",  "Clean Code",       "Technology"],
			["7",  "Cosmos",           "Science"],
			["8",  "Database Design",  "Technology"],
			["9",  "Animal Farm",      "Fiction"],
			["10", "Physics 101",      "Science"]
		],
		"answer": "genre",
		"hint": "Group by the genre column. Type: genre",
		"result_headers": ["genre", "COUNT(*)"],
		"result_rows": [
			["Technology", "4"],
			["Science",    "4"],
			["Fiction",    "2"]
		],
		"result_msg": "Books grouped by genre.",
		"fail": [
			{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "This is grouped by title not genre! These numbers are meaningless for the budget!" },
			{ "type": "dialogue", "char": "scene",     "name": "SCENE",     "npc": "NPC_occupations/librarian/idle",  "text": "The librarian sets the report down. The budget meeting is tomorrow morning." },
			{ "type": "dialogue", "char": "you",       "name": "YOU",       "npc": "NPC_occupations/librarian/idle",  "text": "I will group by genre correctly right away." }
		]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Report done! Technology: 4, Science: 4, Fiction: 2."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/think",
		"text": "We're balanced on Technology and Science but light on Fiction. That helps me plan next year's budget. Excellent."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L8 — IS NULL  |  NPC: librarian
#  Topic: Find borrow records with no return date (still out)
# ─────────────────────────────────────────────
"L8": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "End of month check. The librarian needs to know which books have not been returned yet."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/talk",
		"text": "Books still out have no return date in the system — that field is NULL. Can you find all borrows with no return date?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Sure! IS NULL will filter for rows where the return_date has no value yet."
	},
	{
		"type": "sql_fill",
		"gamemode": "select_where_null",
		"desc": "Find all borrow records where the book has not been returned. Missing return dates show as NULL. Type NULL after IS.",
		"table": "borrows",
		"column": "return_date",
		"table_headers": ["id", "borrower", "book", "return_date"],
		"table_rows": [
			["1", "Maria Santos",  "SQL Basics",      "June 10"],
			["2", "Mr. Tan",       "The Universe",    ""],
			["3", "Sofia Mendez",  "Brief History",   "June 20"],
			["4", "Carlos Reyes",  "Clean Code",      ""],
			["5", "Ana Torres",    "Design Patterns", "June 25"],
			["6", "Kim Park",      "Cosmos",          ""]
		],
		"answer": "NULL",
		"hint": "No return date = NULL. Type: NULL",
		"result_headers": ["id", "borrower", "book", "return_date"],
		"result_rows": [
			["2", "Mr. Tan",      "The Universe", "NULL"],
			["4", "Carlos Reyes", "Clean Code",   "NULL"],
			["6", "Kim Park",     "Cosmos",       "NULL"]
		],
		"result_msg": "3 books have not been returned yet.",
		"fail": [
			{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "That is not right! NULL means the value is absent — no return date has been recorded." },
			{ "type": "dialogue", "char": "scene",     "name": "SCENE",     "npc": "NPC_occupations/librarian/idle",  "text": "The librarian points at the blank cells in the return_date column." },
			{ "type": "dialogue", "char": "you",       "name": "YOU",       "npc": "NPC_occupations/librarian/idle",  "text": "I see — IS NULL checks for missing values. Let me use it correctly." }
		]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Found them! Mr. Tan, Carlos Reyes, and Kim Park have not returned their books yet."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/talk",
		"text": "Thank you. IS NULL is perfect for finding records where information is still missing."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L9 — CREATE DATABASE  |  NPC: adult_16 (Sofia)
#  Topic: CREATE DATABASE — setting up the database container first
# ─────────────────────────────────────────────
"L9": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_16/idle",
		"text": "Sofia, the student you helped register, comes back to the library with a deeper question about how databases work."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "STUDENT",
		"npc":  "adult_16/talk",
		"text": "I've been practicing SELECT and INSERT at home. But I realized — how do I start from scratch? How do you create the database in the first place?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_16/idle",
		"text": "Great question! Before any tables exist, you run CREATE DATABASE. It reserves a named space — like building a room before filling it with shelves."
	},
	{
		"type": "sql_fill",
		"gamemode": "create_database",
		"desc": "Create the library database. Type the missing keyword between CREATE and LibraryDB.",
		"db_name": "LibraryDB",
		"answer": "DATABASE",
		"hint": "The keyword after CREATE for a new database container is: DATABASE",
		"result_msg": "LibraryDB is now created! All library tables — books, borrowers, borrows — will be stored inside this database.",
		"fail": [
			{ "type": "dialogue", "char": "visitor", "name": "STUDENT", "npc": "adult_16/confuse", "text": "That is not the right keyword. We are creating a DATABASE container, not a table yet." },
			{ "type": "dialogue", "char": "scene",   "name": "SCENE",   "npc": "adult_16/idle",   "text": "Sofia tilts her head, looking at the screen carefully." },
			{ "type": "dialogue", "char": "you",     "name": "YOU",     "npc": "adult_16/idle",   "text": "The correct keyword is DATABASE — CREATE DATABASE LibraryDB." }
		]
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "STUDENT",
		"npc":  "adult_16/talk",
		"text": "So CREATE DATABASE comes first — before any tables! The database is like the library building, and the tables are the bookshelves inside."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_16/idle",
		"text": "That is a perfect way to think about it. LibraryDB now exists. Next, we use CREATE TABLE to build the shelves inside it."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L10 — CREATE TABLE  |  NPC: adult_16 (Sofia)
#  Topic: CREATE TABLE — defining the table structure
# ─────────────────────────────────────────────
"L10": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_16/idle",
		"text": "Sofia comes back to the library again, this time asking about how the borrowers table was built inside the database."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "STUDENT",
		"npc":  "adult_16/talk",
		"text": "We created the database. Now how do we actually define a table inside it — the columns, the structure?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_16/idle",
		"text": "We use CREATE TABLE. You give it a name and list each column with its type. The database then enforces that structure for every row you insert."
	},
	{
		"type": "sql_fill",
		"gamemode": "create_table_keyword",
		"desc": "Create the borrowers table inside LibraryDB. Type the missing keyword between CREATE and borrowers.",
		"table": "borrowers",
		"columns": [
			["id",              "INT"],
			["first_name",      "TEXT"],
			["last_name",       "TEXT"],
			["membership_type", "TEXT"]
		],
		"answer": "TABLE",
		"hint": "The keyword after CREATE for a new table is: TABLE",
		"result_msg": "borrowers table created! It has 4 columns: id (INT), first_name (TEXT), last_name (TEXT), membership_type (TEXT).",
		"fail": [
			{ "type": "dialogue", "char": "visitor", "name": "STUDENT", "npc": "adult_16/confuse", "text": "Not right. The database already exists — now we are creating a TABLE inside it." },
			{ "type": "dialogue", "char": "scene",   "name": "SCENE",   "npc": "adult_16/idle",   "text": "Sofia checks her notebook." },
			{ "type": "dialogue", "char": "you",     "name": "YOU",     "npc": "adult_16/idle",   "text": "The keyword is TABLE — CREATE TABLE borrowers." }
		]
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "STUDENT",
		"npc":  "adult_16/talk",
		"text": "CREATE TABLE — and inside the parentheses you list every column with its type. That is the blueprint for all the rows that follow."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_16/idle",
		"text": "Perfect. Think of it like designing a form — CREATE TABLE defines the fields, and INSERT fills in the actual data."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L11 — PRIMARY KEY  |  NPC: adult_16 (Sofia returns)
#  Topic: CREATE TABLE with PRIMARY KEY constraint
# ─────────────────────────────────────────────
"L11": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_16/idle",
		"text": "Sofia, the student you registered, comes back curious about how the borrowers table was originally built."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "STUDENT",
		"npc":  "adult_16/talk",
		"text": "Can you show me the SQL used to create the borrowers table? I want to know why every borrower gets a unique id."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_16/idle",
		"text": "Sure! The id column gets a special constraint called PRIMARY KEY when we create the table. It ensures every id is unique and can never be blank. Watch."
	},
	{
		"type": "sql_fill",
		"gamemode": "create_table",
		"desc": "Complete the CREATE TABLE statement for the borrowers table. The 'id' column must be the PRIMARY KEY — type it in the blank.",
		"table": "borrowers",
		"pk_col": "id",
		"columns": [
			["id",              "INT"],
			["first_name",      "TEXT"],
			["last_name",       "TEXT"],
			["membership_type", "TEXT"]
		],
		"answer": "PRIMARY KEY",
		"hint": "The constraint that makes a column unique for every row is: PRIMARY KEY",
		"result_msg": "Table created! The PRIMARY KEY on 'id' means no two borrowers share the same id — even if they have the same name.",
		"fail": [
			{ "type": "dialogue", "char": "visitor", "name": "STUDENT", "npc": "adult_16/confuse", "text": "That is not right. The constraint is two words — PRIMARY and KEY together." },
			{ "type": "dialogue", "char": "scene",   "name": "SCENE",   "npc": "adult_16/idle",   "text": "Sofia watches the screen, waiting for the correct answer." },
			{ "type": "dialogue", "char": "you",     "name": "YOU",     "npc": "adult_16/idle",   "text": "Let me type it correctly — PRIMARY KEY." }
		]
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "STUDENT",
		"npc":  "adult_16/talk",
		"text": "Oh! PRIMARY KEY goes right after INT. So my id = 5 will always be unique — no other borrower will ever have id 5. That makes so much sense!"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_16/idle",
		"text": "Exactly. The PRIMARY KEY is what keeps every row in a table distinct from all the others."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L12 — JOIN  |  NPC: librarian
#  Topic: FOREIGN KEY / JOIN — combining two tables
# ─────────────────────────────────────────────
"L12": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "The librarian needs a combined report — borrower names alongside the books they borrowed — from two separate tables."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/talk",
		"text": "Borrower info and borrow records are in different tables. Can you JOIN them so I can see who has which book?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Sure! The borrowers.id links to borrows.borrower_id — that linking column is the Foreign Key. I will JOIN on that."
	},
	{
		"type": "sql_fill",
		"gamemode": "join",
		"desc": "JOIN the borrowers table with the borrows table. The borrowers 'id' links to borrows 'borrower_id'. Fill in both column names.",
		"table_a": "borrowers",
		"table_b": "borrows",
		"table_a_headers": ["id", "first_name", "last_name", "membership_type"],
		"table_a_rows": [
			["1", "Maria",  "Santos", "Regular"],
			["2", "Carlos", "Reyes",  "Student"],
			["3", "Ana",    "Torres", "Regular"],
			["5", "Sofia",  "Mendez", "Student"]
		],
		"table_b_headers": ["id", "borrower_id", "book_title", "return_date"],
		"table_b_rows": [
			["1", "1", "SQL Basics",    "June 10"],
			["2", "5", "The Universe",  "NULL"],
			["3", "3", "Brief History", "June 20"],
			["4", "2", "Clean Code",    "NULL"]
		],
		"join_col_a": "id",
		"join_col_b": "borrower_id",
		"hint": "Table A linking column: id | Table B linking column: borrower_id",
		"result_headers": ["first_name", "last_name", "book_title", "return_date"],
		"result_rows": [
			["Maria",  "Santos", "SQL Basics",    "June 10"],
			["Sofia",  "Mendez", "The Universe",  "NULL"],
			["Ana",    "Torres", "Brief History", "June 20"],
			["Carlos", "Reyes",  "Clean Code",    "NULL"]
		],
		"result_msg": "4 records joined successfully.",
		"fail": [
			{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "The JOIN failed! Match the linking column from each table correctly." },
			{ "type": "dialogue", "char": "scene",     "name": "SCENE",     "npc": "NPC_occupations/librarian/idle",  "text": "The librarian points at the id column in borrowers and the borrower_id column in borrows." },
			{ "type": "dialogue", "char": "you",       "name": "YOU",       "npc": "NPC_occupations/librarian/idle",  "text": "I see — borrowers.id must equal borrows.borrower_id. Let me correct it." }
		]
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Done! Both tables are joined. You can now see each borrower name next to the book they have."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/think",
		"text": "Excellent. JOIN is essential when your data is spread across multiple tables — it brings everything together in one view."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L13 — INT  |  NPC: adult_16 (Sofia)
#  Topic: Data Type INT — whole numbers
# ─────────────────────────────────────────────
"L13": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_16/idle",
		"text": "Sofia has one more question before she leaves — she wants to understand what INT and TEXT mean in the table definition."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "STUDENT",
		"npc":  "adult_16/talk",
		"text": "I see INT next to the id column. What does that mean? Why not use TEXT for everything?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_16/idle",
		"text": "INT stands for Integer — a whole number, no decimals. We use INT for IDs and counts because you can never have half a borrower."
	},
	{
		"type": "sql_fill",
		"gamemode": "data_type",
		"desc": "Define the borrowers table. The 'id' column stores a whole number. Fill in the correct data type.",
		"table": "borrowers",
		"columns": [
			["id",              ""],
			["first_name",      "TEXT"],
			["last_name",       "TEXT"],
			["membership_type", "TEXT"]
		],
		"blank_col": "id",
		"answer": "INT",
		"type_hint": "Whole numbers (IDs, counts) use INT.",
		"hint": "A whole number data type (no decimals) is: INT",
		"result_msg": "Correct! INT stores whole numbers — 1, 2, 3. Borrower #5 will always be borrower #5, never #5.5.",
		"fail": [
			{ "type": "dialogue", "char": "visitor", "name": "STUDENT", "npc": "adult_16/confuse", "text": "That is not right. The id column stores whole numbers only — no letters or decimals." },
			{ "type": "dialogue", "char": "scene",   "name": "SCENE",   "npc": "adult_16/idle",   "text": "Sofia looks at the column definition carefully." },
			{ "type": "dialogue", "char": "you",     "name": "YOU",     "npc": "adult_16/idle",   "text": "Whole numbers use INT — integer." }
		]
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "STUDENT",
		"npc":  "adult_16/talk",
		"text": "INT = integer = whole number! So the database rejects 5.5 as an id because it can only store complete numbers."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_16/idle",
		"text": "Exactly. The database enforces the type so your data stays clean and consistent."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L14 — TEXT  |  NPC: adult_16 (Sofia)
#  Topic: Data Type TEXT — strings / words
# ─────────────────────────────────────────────
"L14": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_16/idle",
		"text": "Sofia asks about the TEXT type she saw next to first_name in the borrowers table."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "STUDENT",
		"npc":  "adult_16/talk",
		"text": "And TEXT means it stores letters? Like a name or a book title — not a number?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_16/idle",
		"text": "Correct! TEXT stores any sequence of characters — letters, words, spaces, symbols. Names, titles, descriptions — all TEXT."
	},
	{
		"type": "sql_fill",
		"gamemode": "data_type",
		"desc": "Define the books table. The 'title' column stores a book title (words). Fill in the correct data type.",
		"table": "books",
		"columns": [
			["id",     "INT"],
			["title",  ""],
			["author", "TEXT"],
			["genre",  "TEXT"]
		],
		"blank_col": "title",
		"answer": "TEXT",
		"type_hint": "Names and words use TEXT (also called STRING).",
		"hint": "Letters and words use: TEXT  (also called STRING)",
		"result_msg": "Correct! TEXT stores words and characters — 'SQL Basics', 'The Universe', 'Fiction'. You can also type STRING and it means the same thing.",
		"fail": [
			{ "type": "dialogue", "char": "visitor", "name": "STUDENT", "npc": "adult_16/confuse", "text": "Not quite. title stores a book title — words, not numbers." },
			{ "type": "dialogue", "char": "scene",   "name": "SCENE",   "npc": "adult_16/idle",   "text": "Sofia looks at a book on the shelf." },
			{ "type": "dialogue", "char": "you",     "name": "YOU",     "npc": "adult_16/idle",   "text": "Letters and words use TEXT — also called STRING in some databases." }
		]
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "STUDENT",
		"npc":  "adult_16/talk",
		"text": "TEXT for words, INT for numbers. Those two cover almost everything in a library catalog!"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_16/idle",
		"text": "Most of the time, yes. There is one more type — for when you need decimal numbers like fees or measurements."
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L15 — REAL  |  NPC: librarian
#  Topic: Data Type REAL — decimal / float numbers
# ─────────────────────────────────────────────
"L15": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "The librarian asks you to create a late_fees table to track overdue fines, which involve decimal amounts."
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/talk",
		"text": "The fee_amount column stores values like 1.50 and 4.25. Those are decimal numbers — INT would round them. What type handles decimals?"
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "REAL — it stores decimal numbers accurately. Perfect for fees, prices, or any measurement that can have a fractional part."
	},
	{
		"type": "sql_fill",
		"gamemode": "data_type",
		"desc": "Define the late_fees table. The 'fee_amount' column stores a decimal value like 1.50. Fill in the correct data type.",
		"table": "late_fees",
		"columns": [
			["id",         "INT"],
			["borrower_id","INT"],
			["book_title", "TEXT"],
			["fee_amount", ""]
		],
		"blank_col": "fee_amount",
		"answer": "REAL",
		"type_hint": "Decimal numbers (prices, measurements) use REAL (also called FLOAT).",
		"hint": "Decimal numbers use: REAL  (also called FLOAT)",
		"result_msg": "Correct! REAL stores decimal numbers — 1.50, 4.25, 0.75. You can also type FLOAT and it means the same thing.",
		"fail": [
			{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "That is wrong! fee_amount stores decimal values — not whole numbers, not text." },
			{ "type": "dialogue", "char": "scene",     "name": "SCENE",     "npc": "NPC_occupations/librarian/idle",  "text": "The librarian shows the overdue fine schedule." },
			{ "type": "dialogue", "char": "you",       "name": "YOU",       "npc": "NPC_occupations/librarian/idle",  "text": "Decimal numbers use REAL — also called FLOAT." }
		]
	},
	{
		"type": "dialogue",
		"char": "librarian",
		"name": "LIBRARIAN",
		"npc":  "NPC_occupations/librarian/think",
		"text": "REAL for decimals. So INT for whole numbers, TEXT for words, REAL for decimals. Three types that cover nearly everything."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "NPC_occupations/librarian/idle",
		"text": "Exactly. Some systems call it FLOAT, DOUBLE, or NUMERIC — same idea, different names."
	},
	{
		"type": "end"
	}
]

} # end LESSONS
