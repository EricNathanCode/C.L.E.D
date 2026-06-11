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
],

# ─────────────────────────────────────────────
#  LESSON L16 — SELECT DISTINCT  |  NPC: librarian
# ─────────────────────────────────────────────
"L16": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "The head librarian needs a clean list of every genre available in the library's catalog." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "We have hundreds of books but I want each genre listed only once. No duplicates — just the distinct categories." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "SELECT DISTINCT removes duplicate values. Each unique genre appears exactly once in the result." },
	{ "type": "sql_fill", "gamemode": "select_distinct",
	  "desc": "Return only the unique genres from the books table. Fill in the column name after SELECT DISTINCT.",
	  "table": "books",
	  "column": "genre",
	  "table_headers": ["id","title","author","genre"],
	  "table_rows": [["1","Dune","Herbert","Sci-Fi"],["2","1984","Orwell","Fiction"],["3","Foundation","Asimov","Sci-Fi"],["4","Hamlet","Shakespeare","Drama"],["5","Neuromancer","Gibson","Sci-Fi"],["6","Macbeth","Shakespeare","Drama"]],
	  "hint": "The column with repeating genres: genre",
	  "result_headers": ["genre"],
	  "result_rows": [["Sci-Fi"],["Fiction"],["Drama"]],
	  "result_msg": "3 unique genres. DISTINCT collapsed 3 Sci-Fi and 2 Drama entries into one each.",
	  "fail": [
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "That column does not exist in the books table!" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle", "text": "The column is: genre" }
	  ]
	},
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "Sci-Fi, Fiction, Drama. DISTINCT is exactly what I needed for the genre catalogue display." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "Without DISTINCT you would see Sci-Fi three times and Drama twice, which looks unprofessional." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L17 — AND/OR  |  NPC: librarian
# ─────────────────────────────────────────────
"L17": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "A display shelf needs to show available books in the Sci-Fi genre only." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "I need books where genre is Sci-Fi AND status is Available. Both conditions together." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "AND requires both conditions true. OR would return Sci-Fi books OR any available book — too broad." },
	{ "type": "sql_fill", "gamemode": "where_and_or",
	  "desc": "Find available Sci-Fi books. Fill in AND or OR.",
	  "table": "books",
	  "condition1": "genre = 'Sci-Fi'",
	  "condition2": "status = 'Available'",
	  "answer": "AND",
	  "table_headers": ["id","title","genre","status"],
	  "table_rows": [["1","Dune","Sci-Fi","Available"],["2","1984","Fiction","Available"],["3","Foundation","Sci-Fi","Borrowed"],["4","Neuromancer","Sci-Fi","Available"],["5","Hamlet","Drama","Available"]],
	  "hint": "Both conditions required: AND",
	  "result_headers": ["id","title","genre","status"],
	  "result_rows": [["1","Dune","Sci-Fi","Available"],["4","Neuromancer","Sci-Fi","Available"]],
	  "result_msg": "2 available Sci-Fi books. Foundation (Sci-Fi but Borrowed) and 1984 (Available but not Sci-Fi) are excluded.",
	  "fail": [
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "Too many results! I need Sci-Fi AND Available — both at once." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle", "text": "Both conditions required: AND." }
	  ]
	},
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "Dune and Neuromancer only. AND ensures both conditions apply simultaneously." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "OR would include every available book and every Sci-Fi book regardless of the other condition." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L18 — BETWEEN  |  NPC: librarian
# ─────────────────────────────────────────────
"L18": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "The librarian is creating a display for books published in a specific era." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "I want all books published between 1950 and 1990. Including those exact years." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "BETWEEN is perfect — it is inclusive at both ends, so 1950 and 1990 are included." },
	{ "type": "sql_fill", "gamemode": "where_between",
	  "desc": "Find books published between 1950 and 1990. Fill in the range keyword.",
	  "table": "books",
	  "column": "year_published",
	  "low": "1950", "high": "1990",
	  "answer": "BETWEEN",
	  "table_headers": ["id","title","author","year_published"],
	  "table_rows": [["1","Dune","Herbert","1965"],["2","Hamlet","Shakespeare","1603"],["3","1984","Orwell","1949"],["4","Foundation","Asimov","1951"],["5","Neuromancer","Gibson","1984"],["6","Brave New World","Huxley","1932"]],
	  "hint": "The inclusive range keyword: BETWEEN",
	  "result_headers": ["id","title","author","year_published"],
	  "result_rows": [["1","Dune","Herbert","1965"],["4","Foundation","Asimov","1951"],["5","Neuromancer","Gibson","1984"]],
	  "result_msg": "3 books found. 1984 (Orwell, 1949) and Hamlet (1603) and Brave New World (1932) are outside the range.",
	  "fail": [
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "Wrong keyword! The inclusive range keyword is BETWEEN." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle", "text": "The range keyword is BETWEEN." }
	  ]
	},
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "Dune, Foundation, Neuromancer — the mid-century shelf is ready." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "BETWEEN also works with dates: WHERE borrow_date BETWEEN '2024-01-01' AND '2024-06-30'." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L19 — LIKE  |  NPC: librarian
# ─────────────────────────────────────────────
"L19": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "A visitor partially remembers a book title — it starts with 'The' but they cannot recall the rest." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "How do we search for books when we only know part of the title?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "LIKE with a wildcard. 'The%' matches any title starting with 'The' followed by anything." },
	{ "type": "sql_fill", "gamemode": "where_like",
	  "desc": "Find books whose title starts with 'The'. Fill in the LIKE pattern.",
	  "table": "books",
	  "column": "title",
	  "answer": "'The%'",
	  "table_headers": ["id","title","author"],
	  "table_rows": [["1","The Hobbit","Tolkien"],["2","Dune","Herbert"],["3","The Name of the Wind","Rothfuss"],["4","1984","Orwell"],["5","The Martian","Weir"],["6","Foundation","Asimov"]],
	  "hint": "Starts with 'The' then anything: 'The%'",
	  "result_headers": ["id","title","author"],
	  "result_rows": [["1","The Hobbit","Tolkien"],["3","The Name of the Wind","Rothfuss"],["5","The Martian","Weir"]],
	  "result_msg": "3 books found. Dune, 1984, and Foundation do not start with 'The'.",
	  "fail": [
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "Wrong pattern. For titles starting with 'The': 'The%'" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle", "text": "The pattern is: 'The%'" }
	  ]
	},
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "The Hobbit, The Name of the Wind, The Martian. LIKE is essential for partial-title searches." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "'%wind%' would find any title containing the word 'wind' anywhere in the title." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L20 — IN  |  NPC: librarian
# ─────────────────────────────────────────────
"L20": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "A reading club needs books only from certain specific genres for their next meeting." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "I need books from Sci-Fi, Fantasy, or Mystery only. Is there a cleaner way than three OR conditions?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "IN lets you match against a list of values in one clean expression." },
	{ "type": "sql_fill", "gamemode": "where_in",
	  "desc": "Find books in Sci-Fi, Fantasy, or Mystery. Fill in the list membership keyword.",
	  "table": "books",
	  "column": "genre",
	  "in_list": "('Sci-Fi', 'Fantasy', 'Mystery')",
	  "answer": "IN",
	  "table_headers": ["id","title","genre"],
	  "table_rows": [["1","Dune","Sci-Fi"],["2","Hamlet","Drama"],["3","The Hobbit","Fantasy"],["4","1984","Fiction"],["5","Sherlock Holmes","Mystery"],["6","Foundation","Sci-Fi"]],
	  "hint": "The list membership keyword is: IN",
	  "result_headers": ["id","title","genre"],
	  "result_rows": [["1","Dune","Sci-Fi"],["3","The Hobbit","Fantasy"],["5","Sherlock Holmes","Mystery"],["6","Foundation","Sci-Fi"]],
	  "result_msg": "4 books found. Hamlet (Drama) and 1984 (Fiction) not in the specified genres.",
	  "fail": [
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "Wrong keyword. Use IN to match against a list." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle", "text": "The keyword is IN." }
	  ]
	},
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "4 books for the reading club. IN is cleaner than genre='Sci-Fi' OR genre='Fantasy' OR genre='Mystery'." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "NOT IN ('Drama','Fiction') would give the same result by exclusion — both approaches work." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L21 — LIMIT  |  NPC: librarian
# ─────────────────────────────────────────────
"L21": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "The library website needs a 'Recently Added' section showing only the top 5 books." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "We cannot display all 5000 books on the homepage. I just need the first 5 for the preview." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "LIMIT restricts how many rows are returned. LIMIT 5 returns at most 5 rows." },
	{ "type": "sql_fill", "gamemode": "limit",
	  "desc": "Return only the first 5 books from the catalog. Type the number after LIMIT.",
	  "table": "books",
	  "answer": "5",
	  "table_headers": ["id","title","author","genre"],
	  "table_rows": [["1","Dune","Herbert","Sci-Fi"],["2","1984","Orwell","Fiction"],["3","The Hobbit","Tolkien","Fantasy"],["4","Foundation","Asimov","Sci-Fi"],["5","Hamlet","Shakespeare","Drama"],["6","Neuromancer","Gibson","Sci-Fi"],["7","Sherlock Holmes","Doyle","Mystery"]],
	  "hint": "Show only 5 rows — type: 5",
	  "result_headers": ["id","title","author","genre"],
	  "result_rows": [["1","Dune","Herbert","Sci-Fi"],["2","1984","Orwell","Fiction"],["3","The Hobbit","Tolkien","Fantasy"],["4","Foundation","Asimov","Sci-Fi"],["5","Hamlet","Shakespeare","Drama"]],
	  "result_msg": "5 books shown. Neuromancer and Sherlock Holmes not fetched. LIMIT keeps queries fast.",
	  "fail": [
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "That is not 5 books. Type the number 5." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle", "text": "Type the number 5 after LIMIT." }
	  ]
	},
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "5 books for the homepage. LIMIT with ORDER BY date_added DESC would give the newest books." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "LIMIT is also used for pagination: LIMIT 10 OFFSET 20 returns books 21–30." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L22 — COUNT  |  NPC: librarian
# ─────────────────────────────────────────────
"L22": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "The annual report needs the total number of books in the library's collection." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "How many books do we have total? I need a single number for the board of trustees." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "COUNT is an aggregate function that counts the number of rows in the result." },
	{ "type": "sql_fill", "gamemode": "aggregate",
	  "desc": "Count the total number of books. Fill in the aggregate function name.",
	  "table": "books",
	  "column": "id",
	  "answer": "COUNT",
	  "table_headers": ["id","title","author","genre"],
	  "table_rows": [["1","Dune","Herbert","Sci-Fi"],["2","1984","Orwell","Fiction"],["3","The Hobbit","Tolkien","Fantasy"],["4","Foundation","Asimov","Sci-Fi"],["5","Hamlet","Shakespeare","Drama"]],
	  "hint": "To count rows: COUNT",
	  "result_headers": ["COUNT(id)"],
	  "result_rows": [["5"]],
	  "result_msg": "5 books in the catalog.\n\nOther aggregate functions:\n- SUM(pages) totals all page counts\n- AVG(year_published) finds the average publication year",
	  "fail": [
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "Wrong function. COUNT is used to count rows." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle", "text": "The counting function is COUNT." }
	  ]
	},
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "5 books — though in reality we have thousands. COUNT(*) counts all rows including NULLs." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "COUNT(column) skips NULL values. COUNT(*) counts every row regardless of NULLs." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L23 — HAVING  |  NPC: librarian
# ─────────────────────────────────────────────
"L23": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "The librarian wants to find genres that have more than 2 books — to plan the display shelves." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "I grouped by genre but now I need to filter out genres with only 1 or 2 books. WHERE cannot do that." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "HAVING filters after GROUP BY. It can use aggregate results like COUNT(*) > 2." },
	{ "type": "sql_fill", "gamemode": "having",
	  "desc": "Show genres with more than 2 books. Fill in the aggregate function in HAVING.",
	  "table": "books",
	  "group_col": "genre",
	  "answer": "COUNT",
	  "table_headers": ["id","title","genre"],
	  "table_rows": [["1","Dune","Sci-Fi"],["2","Hamlet","Drama"],["3","Foundation","Sci-Fi"],["4","1984","Fiction"],["5","Neuromancer","Sci-Fi"],["6","Macbeth","Drama"]],
	  "hint": "HAVING filters groups using: COUNT",
	  "result_headers": ["genre","COUNT(*)"],
	  "result_rows": [["Sci-Fi","3"]],
	  "result_msg": "Only Sci-Fi has more than 2 books. Drama has exactly 2 (not more). Fiction has 1.",
	  "fail": [
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "Wrong function in HAVING. COUNT filters by group size." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle", "text": "HAVING uses COUNT." }
	  ]
	},
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "Sci-Fi is the biggest section with 3 books. HAVING is the WHERE for groups." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "Remember: WHERE filters rows, GROUP BY groups them, HAVING filters the groups." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L24 — AS (Aliases)  |  NPC: librarian
# ─────────────────────────────────────────────
"L24": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "A borrower report needs to show overdue fees in a clearly labeled column." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "The calculated column shows 'overdue_days * 0.50' — that is not user-friendly at all." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "AS renames the column in the output. It does not change the table, only the display label." },
	{ "type": "sql_fill", "gamemode": "select_alias",
	  "desc": "Rename the calculated column to 'late_fee'. Fill in the alias name after AS.",
	  "table": "borrowers",
	  "col_expr": "overdue_days * 0.50",
	  "answer": "late_fee",
	  "table_headers": ["id","name","overdue_days"],
	  "table_rows": [["1","Mendez","10"],["2","Santos","4"],["3","Reyes","0"]],
	  "hint": "The alias for the fee column: late_fee",
	  "result_headers": ["late_fee"],
	  "result_rows": [["5.0"],["2.0"],["0.0"]],
	  "result_msg": "Column displays as 'late_fee'. AS is cosmetic — overdue_days is unchanged in the table.",
	  "fail": [
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "Wrong alias. The alias should be: late_fee" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle", "text": "Type the alias: late_fee" }
	  ]
	},
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "late_fee is clear and readable. AS makes reports professional without touching the schema." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "You can also alias table names in joins: FROM borrowers AS b — saves typing in long queries." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L25 — NOT NULL + UNIQUE  |  NPC: adult_7 visitor
# ─────────────────────────────────────────────
"L25": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "adult_7/idle",
	  "text": "A library visitor wonders how the system prevents missing or duplicated borrower card numbers." },
	{ "type": "dialogue", "char": "visitor", "name": "VISITOR", "npc": "adult_7/talk",
	  "text": "Can someone register a library card without giving their name? Or have the same card number twice?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_7/idle",
	  "text": "Database constraints prevent both. NOT NULL blocks empty names. UNIQUE blocks duplicate card numbers." },
	{ "type": "sql_fill", "gamemode": "create_table",
	  "desc": "The borrower_name must always have a value. Add the NOT NULL constraint.",
	  "table": "borrowers",
	  "pk_col": "borrower_name",
	  "columns": [["id","INT PRIMARY KEY"],["borrower_name","TEXT"],["card_number","TEXT"]],
	  "answer": "NOT NULL",
	  "blank_hint": "constraint",
	  "error_hint": "The constraint that prevents empty values is NOT NULL.",
	  "result_msg": "NOT NULL set! Borrowers without a name will be rejected on INSERT.",
	  "hint": "Prevent empty values: NOT NULL",
	  "fail": [
		{ "type": "dialogue", "char": "visitor", "name": "VISITOR", "npc": "adult_7/confuse", "text": "Not right. NOT NULL prevents empty values." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_7/idle", "text": "Type: NOT NULL" }
	  ]
	},
	{ "type": "dialogue", "char": "visitor", "name": "VISITOR", "npc": "adult_7/talk",
	  "text": "And how do we prevent two people from having the same card number?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_7/idle",
	  "text": "UNIQUE ensures no two rows share the same value in that column." },
	{ "type": "sql_fill", "gamemode": "create_table",
	  "desc": "The card_number must be unique per borrower. Add the UNIQUE constraint.",
	  "table": "borrowers",
	  "pk_col": "card_number",
	  "columns": [["id","INT PRIMARY KEY"],["borrower_name","TEXT"],["card_number","TEXT"]],
	  "answer": "UNIQUE",
	  "blank_hint": "constraint",
	  "error_hint": "The constraint that prevents duplicate values is UNIQUE.",
	  "result_msg": "UNIQUE set! Duplicate card numbers will now be rejected.",
	  "hint": "Prevent duplicate values: UNIQUE",
	  "fail": [
		{ "type": "dialogue", "char": "visitor", "name": "VISITOR", "npc": "adult_7/confuse", "text": "Wrong. UNIQUE prevents duplicates." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_7/idle", "text": "Type: UNIQUE" }
	  ]
	},
	{ "type": "dialogue", "char": "visitor", "name": "VISITOR", "npc": "adult_7/talk",
	  "text": "NOT NULL stops blanks and UNIQUE stops duplicates. The rules are built right into the table." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_7/idle",
	  "text": "You can even combine them: card_number TEXT NOT NULL UNIQUE — mandatory and always different." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L26 — ALTER TABLE  |  NPC: librarian
# ─────────────────────────────────────────────
"L26": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "The library is tracking the physical shelf location of books — but the original table has no such column." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "We forgot to include a shelf_location column when we built the books table. Can we add it now?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "ALTER TABLE ADD adds a new column to an existing table without disturbing existing records." },
	{ "type": "sql_fill", "gamemode": "alter_table",
	  "desc": "Add a shelf_location column to the books table. Fill in the keyword that adds a column.",
	  "table": "books",
	  "new_col": "shelf_location",
	  "col_type": "TEXT",
	  "answer": "ADD",
	  "hint": "The keyword to add a column: ADD",
	  "result_msg": "shelf_location column added! All existing book records are preserved.",
	  "fail": [
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "Wrong keyword. The syntax is: ALTER TABLE books ADD shelf_location TEXT" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle", "text": "The keyword is ADD." }
	  ]
	},
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "shelf_location added — all 3000 books still have their original data intact." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "Existing rows get NULL for the new column unless you specify a DEFAULT value." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L27 — DROP TABLE  |  NPC: librarian
# ─────────────────────────────────────────────
"L27": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "The old temporary_holds table from a pilot program is cluttering the database and confusing new staff." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "We do not use the temporary_holds table any more. Can we delete it completely?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "DROP TABLE removes the table structure and all its data permanently. Back it up first." },
	{ "type": "sql_fill", "gamemode": "drop_table",
	  "desc": "Remove the temporary_holds table permanently. Fill in the keyword after DROP.",
	  "table": "temporary_holds",
	  "answer": "TABLE",
	  "hint": "After DROP, the keyword to remove a table: TABLE",
	  "result_msg": "temporary_holds dropped! This is irreversible — always take a backup before DROP TABLE.",
	  "fail": [
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "Wrong keyword. The syntax is: DROP TABLE table_name" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle", "text": "Type TABLE after DROP." }
	  ]
	},
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "Table removed. DROP TABLE is irreversible — we confirmed the backup first." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "DROP TABLE IF EXISTS temporary_holds avoids errors if the table was already removed." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L28 — LEFT JOIN  |  NPC: librarian
# ─────────────────────────────────────────────
"L28": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "The librarian wants to see all books — even those that have never been borrowed." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "A regular JOIN only shows books WITH borrow records. I want every book, borrowed or not." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "LEFT JOIN returns all rows from the left table. Non-matching right table rows show as NULL." },
	{ "type": "sql_fill", "gamemode": "join",
	  "join_type": "LEFT JOIN",
	  "desc": "LEFT JOIN books with borrow_records. All books appear even without borrow entries. Fill in the linking columns.",
	  "table_a": "books", "table_b": "borrow_records",
	  "table_a_headers": ["id","title","genre"],
	  "table_a_rows": [["1","Dune","Sci-Fi"],["2","Hamlet","Drama"],["3","The Hobbit","Fantasy"],["4","Foundation","Sci-Fi"]],
	  "table_b_headers": ["id","book_id","borrower_name"],
	  "table_b_rows": [["1","1","Mendez"],["2","3","Santos"]],
	  "join_col_a": "id", "join_col_b": "book_id",
	  "hint": "books linking column: id | borrow_records linking column: book_id",
	  "result_headers": ["title","genre","borrower_name"],
	  "result_rows": [["Dune","Sci-Fi","Mendez"],["Hamlet","Drama","NULL"],["The Hobbit","Fantasy","Santos"],["Foundation","Sci-Fi","NULL"]],
	  "result_msg": "All 4 books shown. Hamlet and Foundation have never been borrowed — borrower_name is NULL.",
	  "fail": [
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "Wrong linking columns! books.id connects to borrow_records.book_id." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle", "text": "Left: id | Right: book_id" }
	  ]
	},
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "All 4 books visible. Hamlet and Foundation are never borrowed — I should promote those." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "LEFT JOIN WHERE borrow_records.book_id IS NULL would isolate only the never-borrowed books." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L29 — DEFAULT  |  NPC: adult_7 visitor
# ─────────────────────────────────────────────
"L29": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "adult_7/idle",
	  "text": "A visitor notices that every newly added book automatically shows 'Available' as its status." },
	{ "type": "dialogue", "char": "visitor", "name": "VISITOR", "npc": "adult_7/talk",
	  "text": "When a new book is added to the catalog, it already says Available without anyone typing it. How?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_7/idle",
	  "text": "The DEFAULT constraint! It sets an automatic value for a column when no value is provided." },
	{ "type": "sql_fill", "gamemode": "create_table",
	  "desc": "Set books.status to auto-fill with 'Available'. Type: DEFAULT 'Available'",
	  "table": "books",
	  "pk_col": "status",
	  "columns": [["id","INT PRIMARY KEY"],["title","TEXT"],["genre","TEXT"],["status","TEXT"]],
	  "answer": "DEFAULT 'Available'",
	  "blank_hint": "constraint",
	  "error_hint": "The syntax is: DEFAULT 'value'",
	  "result_msg": "DEFAULT set! New books automatically get 'Available' status on INSERT.",
	  "hint": "Auto-fill status: DEFAULT 'Available'",
	  "fail": [
		{ "type": "dialogue", "char": "visitor", "name": "VISITOR", "npc": "adult_7/confuse", "text": "Not quite. DEFAULT sets the fallback value when none is provided." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_7/idle", "text": "Type: DEFAULT 'Available'" }
	  ]
	},
	{ "type": "dialogue", "char": "visitor", "name": "VISITOR", "npc": "adult_7/talk",
	  "text": "So DEFAULT is the starting state — staff only need to update it when someone borrows the book?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_7/idle",
	  "text": "Exactly. DEFAULT reduces manual data entry and prevents missing values at the same time." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L30 — Normalization  |  NPC: adult_7 visitor
# ─────────────────────────────────────────────
"L30": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "adult_7/idle",
	  "text": "A library science student asks about why the old card catalog system was so hard to maintain." },
	{ "type": "dialogue", "char": "visitor", "name": "VISITOR", "npc": "adult_7/talk",
	  "text": "The old system stored the author's full biography in every single book record. When the author updated their biography it had to be changed in hundreds of rows!" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "That is the classic data redundancy problem. Normalization solves it by storing each fact once." },
	{ "type": "sql_choice",
	  "desc": "An old books table stores: title, author_name, author_bio, author_nationality in EVERY row. What is the main design problem?",
	  "options": [
		[1, "Data redundancy — author information repeats in every book row, causing update anomalies."],
		[2, "The table needs more columns — add ISBN and publication year to fix it."],
		[3, "The PRIMARY KEY is wrong — use author_name as the primary key instead of id."]
	  ],
	  "correct_id": 1,
	  "hint": "Repeated data across rows is called redundancy. Answer: id = 1",
	  "fail": [
		{ "type": "dialogue", "char": "visitor", "name": "VISITOR", "npc": "adult_7/confuse", "text": "Not right. The repeated author info in every row is the problem — it is called data redundancy." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_7/idle", "text": "Answer 1 — data redundancy." }
	  ]
	},
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_7/idle",
	  "text": "Normalization creates a separate authors table. Books store only author_id as a reference." },
	{ "type": "dialogue", "char": "visitor", "name": "VISITOR", "npc": "adult_7/talk",
	  "text": "One change to the authors table fixes the biography for all 300 books by that author. Brilliant!" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "adult_7/idle",
	  "text": "That is the core principle of 3NF — third normal form. Every fact stored exactly once." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L31 — Transactions  |  NPC: librarian
# ─────────────────────────────────────────────
"L31": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "A system error mid-process left a book marked as 'Borrowed' but no borrow record was created — the database is inconsistent." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "The status update ran but the borrow record INSERT never completed. How do we prevent partial updates?" },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "Transactions! BEGIN groups multiple statements. COMMIT saves all of them or ROLLBACK cancels all." },
	{ "type": "sql_fill", "gamemode": "transaction",
	  "desc": "The borrow INSERT is done. COMMIT to save both the status update and the borrow record.",
	  "update_line": "INSERT INTO borrow_records (book_id, borrower_id) VALUES (1, 42)",
	  "answer": "COMMIT",
	  "hint": "To save a transaction: COMMIT",
	  "result_msg": "Transaction committed! Both the status update and borrow record saved atomically.\n\nACID guarantee:\n- Atomicity: both statements complete or neither does\n- Consistency: book status always matches borrow records\n- Durability: committed changes survive crashes",
	  "fail": [
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "Wrong! Type COMMIT to save or ROLLBACK to cancel the transaction." },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle", "text": "Type COMMIT to finalize." }
	  ]
	},
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "Both operations committed as one unit. If the INSERT had failed, ROLLBACK would undo the status change too." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "ACID guarantees make databases reliable. Transactions are the foundation of data integrity." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L32 — FOREIGN KEY  |  NPC: librarian
# ─────────────────────────────────────────────
"L32": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "The library has two tables — borrowers and loans. The librarian wants to ensure every loan record belongs to a registered borrower." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "A FOREIGN KEY constraint links a column to the PRIMARY KEY of another table. A loan can't reference a borrower who doesn't exist in our system." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "This prevents ghost records — loans that belong to nobody?" },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "Exactly — referential integrity. The keyword pointing to the other table is REFERENCES." },
	{ "type": "sql_fill", "gamemode": "foreign_key",
	  "desc": "Complete the FOREIGN KEY constraint to link loans.borrower_id to the borrowers table.",
	  "table": "loans", "fk_col": "borrower_id", "ref_table": "borrowers",
	  "answer": "REFERENCES",
	  "hint": "The keyword that points to another table is REFERENCES.",
	  "result_msg": "FOREIGN KEY created! Every borrower_id in loans must now exist in the borrowers table.",
	  "fail": [
	    { "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	      "text": "Not quite. After FOREIGN KEY (borrower_id), type REFERENCES followed by the table and column." }
	  ]
	},
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L33 — Indexes  |  NPC: librarian
# ─────────────────────────────────────────────
"L33": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "The library catalog has grown to tens of thousands of books. Searching by title is noticeably slow." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "An INDEX is like a back-of-book index — it maps values to row locations so the database can jump straight to matches without reading every row." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "It doesn't change what's stored in the table — it just changes how fast we can find things?" },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "Precisely. Create an index on the title column of the books table." },
	{ "type": "sql_fill", "gamemode": "create_index",
	  "desc": "Create an index on the books table to speed up searches by title.",
	  "index_name": "idx_title", "table": "books", "column": "title",
	  "answer": "INDEX",
	  "hint": "The keyword after CREATE is INDEX.",
	  "result_msg": "Index created! Book title searches will now be much faster.",
	  "fail": [
	    { "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	      "text": "Not quite. The syntax is CREATE INDEX name ON table(column)." }
	  ]
	},
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L34 — Views  |  NPC: librarian
# ─────────────────────────────────────────────
"L34": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "Staff check overdue books every day using a long SELECT with a WHERE clause. The librarian wants a simpler way to access this list." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "A VIEW stores a SELECT query as a virtual table. Instead of rewriting the query, staff just SELECT from the view — always getting the current data." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "Like bookmarking a filtered page in the catalog — it updates automatically as books are returned?" },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "Perfect way to think about it. Create the overdue books view." },
	{ "type": "sql_fill", "gamemode": "create_view",
	  "desc": "Create a view called vw_overdue that shows all loans with status 'Overdue'.",
	  "view_name": "vw_overdue", "select_cols": "*", "table": "loans", "condition": "status = 'Overdue'",
	  "answer": "VIEW",
	  "hint": "The keyword after CREATE is VIEW.",
	  "result_msg": "View created! SELECT * FROM vw_overdue now shows all overdue loans instantly.",
	  "fail": [
	    { "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	      "text": "Not quite. The syntax is CREATE VIEW name AS SELECT ... The keyword after CREATE is VIEW." }
	  ]
	},
	{ "type": "end" }
],

} # end LESSONS
