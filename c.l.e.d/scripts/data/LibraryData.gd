extends Node
# ═══════════════════════════════════════════════════════
#  LIBRARY DATA  |  scripts/data/LibraryData.gd
#
#  NPC assignments (Library World | unique to this world):
#    adult_7  = Visitor (L1 | gender-neutral)
#    adult_16 = Sofia Mendez, female student (L2)
#    adult_8  = Borrower (L4)
#    NPC_occupations/librarian = Head librarian (boss)
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
#  LESSON L1 | SELECT
#  Topic: Pulling every book record on your first day
# ─────────────────────────────────────────────
"L1": [
	{
		"type": "dialogue",
		"char": "scene",
		"name": "SCENE",
		"npc":  "adult_7/idle",
		"text": "It's your first morning at the front desk. Before the doors open, a coworker walks you through the catalog system."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "COWORKER",
		"npc":  "adult_7/talk",
		"text": "Let's start with the basics. Pull up every book in the catalog every column, every row."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_7/idle",
		"text": "Sure! Let me query the books table and show you everything."
	},
	{
		"type": "sql_fill",
		"gamemode": "select_basic",
		"desc": "Retrieve every column and every row from the books table.",
		"table": "books",
		"table_headers": ["id", "title", "author", "genre"],
		"table_rows": [
			["1", "SQL Basics",      "Rivera",  "Technology"],
			["2", "The Universe",    "Hawking", "Science"],
			["3", "Brief History",   "Sagan",   "Science"],
			["4", "Design Patterns", "GoF",     "Technology"],
			["5", "Animal Farm",     "Orwell",  "Fiction"]
		],
		"answer": "*",
		"hint": "To select every column, type the wildcard: *",
		"fail": [
			{ "type": "dialogue", "char": "visitor", "name": "COWORKER", "npc": "adult_7/shock", "text": "That's not right. To grab every column at once, use the wildcard character." },
			{ "type": "dialogue", "char": "scene",    "name": "SCENE",    "npc": "adult_7/idle",  "text": "The coworker points at the terminal, waiting patiently." },
			{ "type": "dialogue", "char": "you",      "name": "YOU",      "npc": "adult_7/idle",  "text": "Right the wildcard for 'everything' is: *" }
		],
		"result_headers": ["id", "title", "author", "genre"],
		"result_rows": [
			["1", "SQL Basics",      "Rivera",  "Technology"],
			["2", "The Universe",    "Hawking", "Science"],
			["3", "Brief History",   "Sagan",   "Science"],
			["4", "Design Patterns", "GoF",     "Technology"],
			["5", "Animal Farm",     "Orwell",  "Fiction"]
		],
		"result_msg": "5 books retrieved. SELECT * returns every column for every row in the table."
	},
	{
		"type": "dialogue",
		"char": "you",
		"name": "YOU",
		"npc":  "adult_7/idle",
		"text": "There you go all 5 books, every column."
	},
	{
		"type": "dialogue",
		"char": "visitor",
		"name": "COWORKER",
		"npc":  "adult_7/talk",
		"text": "Perfect. SELECT * is the most basic query there is, and you'll type it constantly. Good start!"
	},
	{
		"type": "end"
	}
],

# ─────────────────────────────────────────────
#  LESSON L2 | INSERT INTO
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
		"table_rows": [
			["1", "Carlos", "Reyes",  "Faculty"],
			["2", "Ana",    "Torres", "Student"],
			["3", "Miguel", "Cruz",   "Student"],
			["4", "Rosa",   "Lim",    "Faculty"]
		],
		"answers": ["Sofia", "Mendez", "Student"],
		"hint": "First: Sofia Last: Mendez Type: Student",
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
#  LESSON L3 | SELECT WHERE
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
		"text": "Found 4 Science books The Universe, Brief History, Cosmos, and Physics 101. All on shelf C3."
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
#  LESSON L4 | UPDATE SET
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
		"hint": "New return date: June 30 Record id: 2",
		"result_headers": ["id", "borrower_name", "book_title", "return_date"],
		"result_rows": [["2", "Mr. Tan", "The Universe", "June 30"]],
		"result_msg": "1 record updated.",
		"fail": [
			{ "type": "dialogue", "char": "visitor",  "name": "BORROWER", "npc": "adult_8/shock",   "text": "That is still June 15! Nothing changed did the system even update?" },
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
#  LESSON L5 | DELETE
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
#  LESSON L6 | ORDER BY
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
		"text": "Sorted! Animal Farm to The Universe all 10 books in A to Z order."
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
#  LESSON L7 | GROUP BY
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
#  LESSON L8 | IS NULL  |  NPC: librarian
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
		"text": "Books still out have no return date in the system that field is NULL. Can you find all borrows with no return date?"
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
			{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "That is not right! NULL means the value is absent no return date has been recorded." },
			{ "type": "dialogue", "char": "scene",     "name": "SCENE",     "npc": "NPC_occupations/librarian/idle",  "text": "The librarian points at the blank cells in the return_date column." },
			{ "type": "dialogue", "char": "you",       "name": "YOU",       "npc": "NPC_occupations/librarian/idle",  "text": "I see IS NULL checks for missing values. Let me use it correctly." }
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
#  LESSON L16 | SELECT DISTINCT  |  NPC: librarian
# ─────────────────────────────────────────────
"L16": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "The head librarian needs a clean list of every genre available in the library's catalog." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "We have hundreds of books but I want each genre listed only once. No duplicates just the distinct categories." },
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
#  LESSON L17 | AND/OR  |  NPC: librarian
# ─────────────────────────────────────────────
"L17": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "A display shelf needs to show available books in the Sci-Fi genre only." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "I need books where genre is Sci-Fi AND status is Available. Both conditions together." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "AND requires both conditions true. OR would return Sci-Fi books OR any available book too broad." },
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
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "Too many results! I need Sci-Fi AND Available both at once." },
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
#  LESSON L18 | BETWEEN  |  NPC: librarian
# ─────────────────────────────────────────────
"L18": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "The librarian is creating a display for books published in a specific era." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "I want all books published between 1950 and 1990. Including those exact years." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "BETWEEN is perfect it is inclusive at both ends, so 1950 and 1990 are included." },
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
	  "text": "Dune, Foundation, Neuromancer the mid-century shelf is ready." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "BETWEEN also works with dates: WHERE borrow_date BETWEEN '2024-01-01' AND '2024-06-30'." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L19 | LIKE  |  NPC: librarian
# ─────────────────────────────────────────────
"L19": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "A visitor partially remembers a book title it starts with 'The' but they cannot recall the rest." },
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
#  LESSON L20 | IN  |  NPC: librarian
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
	  "text": "NOT IN ('Drama','Fiction') would give the same result by exclusion both approaches work." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L21 | LIMIT  |  NPC: librarian
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
	  "hint": "Show only 5 rows type: 5",
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
#  LESSON L22 | COUNT  |  NPC: librarian
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
	  "text": "5 books though in reality we have thousands. COUNT(*) counts all rows including NULLs." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "COUNT(column) skips NULL values. COUNT(*) counts every row regardless of NULLs." },
	{ "type": "end" }
],

# ─────────────────────────────────────────────
#  LESSON L23 | HAVING  |  NPC: librarian
# ─────────────────────────────────────────────
"L23": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "The librarian wants to find genres that have more than 2 books to plan the display shelves." },
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
#  LESSON L24 | AS (Aliases)  |  NPC: librarian
# ─────────────────────────────────────────────
"L24": [
	{ "type": "dialogue", "char": "scene", "name": "SCENE", "npc": "NPC_occupations/librarian/idle",
	  "text": "A borrower report needs to show overdue fees in a clearly labeled column." },
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "The calculated column shows 'overdue_days * 0.50' that is not user-friendly at all." },
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
	  "result_msg": "Column displays as 'late_fee'. AS is cosmetic overdue_days is unchanged in the table.",
	  "fail": [
		{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/shock", "text": "Wrong alias. The alias should be: late_fee" },
		{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle", "text": "Type the alias: late_fee" }
	  ]
	},
	{ "type": "dialogue", "char": "librarian", "name": "LIBRARIAN", "npc": "NPC_occupations/librarian/talk",
	  "text": "late_fee is clear and readable. AS makes reports professional without touching the schema." },
	{ "type": "dialogue", "char": "you", "name": "YOU", "npc": "NPC_occupations/librarian/idle",
	  "text": "You can also alias table names in joins: FROM borrowers AS b saves typing in long queries." },
	{ "type": "end" }
],


} # end LESSONS

