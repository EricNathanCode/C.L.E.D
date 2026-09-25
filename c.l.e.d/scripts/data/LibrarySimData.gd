extends Node
# ═══════════════════════════════════════════════════════
#  LIBRARY SIMULATION DATA  |  scripts/data/LibrarySimData.gd
#  Template pool for Library World's Simulation mode.
#  Deliberately spans THREE tables (books, borrowers, borrows)
#  as concepts unlock, so longer runs visibly accumulate more
#  floating table windows over time.
# ═══════════════════════════════════════════════════════

const TEMPLATES: Array = [

	# ── SELECT (unlocks after Lesson 1) | table: books ──
	{
		"requires_lesson_index": 1, "kind": "select_basic",
		"table": "books",
		"table_headers": ["id", "title", "author", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "SQL Basics", "Rivera", "Technology"], [2, "The Universe", "Hawking", "Science"],
			[3, "Brief History", "Sagan", "Science"], [4, "Animal Farm", "Orwell", "Fiction"],
		],
		"problem": "Can you show me the full catalog? I want to browse everything.",
	},
	{
		"requires_lesson_index": 1, "kind": "select_basic",
		"table": "books",
		"table_headers": ["id", "title", "author", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "SQL Basics", "Rivera", "Technology"], [2, "The Universe", "Hawking", "Science"],
			[3, "Brief History", "Sagan", "Science"], [4, "Animal Farm", "Orwell", "Fiction"],
		],
		"problem": "The head librarian wants a full listing of the catalog for inventory.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 1, "kind": "select_column",
		"table": "books",
		"table_headers": ["id", "title", "author", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "SQL Basics", "Rivera", "Technology"], [2, "The Universe", "Hawking", "Science"],
			[3, "Brief History", "Sagan", "Science"], [4, "Animal Farm", "Orwell", "Fiction"],
		],
		"problem_template": "I just need the {column} for every book — skip the rest.",
		"pick_from_columns": ["title", "author", "genre"],
	},
	{
		"requires_lesson_index": 1, "kind": "select_column",
		"table": "books",
		"table_headers": ["id", "title", "author", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "SQL Basics", "Rivera", "Technology"], [2, "The Universe", "Hawking", "Science"],
			[3, "Brief History", "Sagan", "Science"], [4, "Animal Farm", "Orwell", "Fiction"],
		],
		"problem_template": "For the shelf labels, can you list just the {column} column?",
		"pick_from_columns": ["title", "author", "genre"],
		"role": "staff",
	},

	# ── INSERT INTO (unlocks after Lesson 2) | table: borrowers ──
	{
		"requires_lesson_index": 2, "kind": "insert_into",
		"table": "borrowers",
		"table_headers": ["id", "first_name", "last_name", "membership_type"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Carlos", "Reyes", "Faculty"], [2, "Ana", "Torres", "Student"],
			[3, "Miguel", "Cruz", "Student"], [4, "Rosa", "Lim", "Faculty"],
		],
		"problem_template": "Hi, I'd like to register as a borrower. I'm {first} {last}, a {membership}.",
		"variables": {
			"first":      ["Sofia", "Elena", "Diego", "Grace", "Paolo"],
			"last":       ["Mendez", "Bautista", "Fernandez", "Santos", "Garcia"],
			"membership": ["Student", "Faculty"],
		},
		"insert_columns": ["first_name", "last_name", "membership_type"],
	},
	{
		"requires_lesson_index": 2, "kind": "insert_into",
		"table": "borrowers",
		"table_headers": ["id", "first_name", "last_name", "membership_type"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Carlos", "Reyes", "Faculty"], [2, "Ana", "Torres", "Student"],
			[3, "Miguel", "Cruz", "Student"], [4, "Rosa", "Lim", "Faculty"],
		],
		"problem_template": "New borrower sign-up: {first} {last}, membership type {membership}.",
		"variables": {
			"first":      ["Marco", "Iris", "Ben", "Nora", "Liam"],
			"last":       ["Villanueva", "Dela Cruz", "Hernandez", "Rivera", "Kim"],
			"membership": ["Student", "Faculty"],
		},
		"insert_columns": ["first_name", "last_name", "membership_type"],
		"role": "staff",
	},

	# ── SELECT WHERE (unlocks after Lesson 3) | table: books ──
	{
		"requires_lesson_index": 3, "kind": "select_where",
		"table": "books",
		"table_headers": ["id", "title", "author", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "SQL Basics", "Rivera", "Technology"], [2, "The Universe", "Hawking", "Science"],
			[3, "Brief History", "Sagan", "Science"], [4, "Animal Farm", "Orwell", "Fiction"],
		],
		"problem_template": "A professor is looking for books in the {value} genre. Can you search for them?",
		"pick_from_column": "genre",
		"role": "staff",
	},
	{
		"requires_lesson_index": 3, "kind": "select_where",
		"table": "books",
		"table_headers": ["id", "title", "author", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "SQL Basics", "Rivera", "Technology"], [2, "The Universe", "Hawking", "Science"],
			[3, "Brief History", "Sagan", "Science"], [4, "Animal Farm", "Orwell", "Fiction"],
		],
		"problem_template": "Do we have anything written by {value}? A student's asking.",
		"pick_from_column": "author",
		"role": "staff",
	},

	# ── UPDATE SET (unlocks after Lesson 4) | table: borrows ──
	{
		"requires_lesson_index": 4, "kind": "update_set",
		"table": "borrows",
		"table_headers": ["id", "borrower_name", "book_title", "return_date"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria Santos", "SQL Basics", "June 10"], [2, "Mr. Tan", "The Universe", "June 15"],
			[3, "Sofia Mendez", "Brief History", "June 20"], [4, "Carlos Reyes", "Animal Farm", "June 18"],
		],
		"problem_template": "I borrowed record id {target_id} but I need more time — can you extend it to {new_value}?",
		"set_column": "return_date",
		"pick_id_from": "id",
		"new_value_pool": ["June 30", "July 2", "July 5", "June 28"],
	},
	{
		"requires_lesson_index": 4, "kind": "update_set",
		"table": "borrows",
		"table_headers": ["id", "borrower_name", "book_title", "return_date"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria Santos", "SQL Basics", "June 10"], [2, "Mr. Tan", "The Universe", "June 15"],
			[3, "Sofia Mendez", "Brief History", "June 20"], [4, "Carlos Reyes", "Animal Farm", "June 18"],
		],
		"problem_template": "Borrow record id {target_id} has the wrong due date — it should be {new_value}.",
		"set_column": "return_date",
		"pick_id_from": "id",
		"new_value_pool": ["June 24", "June 26", "July 1", "June 29"],
		"role": "staff",
	},

	# ── DELETE (unlocks after Lesson 5) | table: borrows ──
	{
		"requires_lesson_index": 5, "kind": "delete",
		"table": "borrows",
		"table_headers": ["id", "borrower_name", "book_title", "return_date"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria Santos", "SQL Basics", "June 10"], [2, "Mr. Tan", "The Universe", "June 15"],
			[3, "Sofia Mendez", "Brief History", "June 20"], [4, "Carlos Reyes", "Animal Farm", "June 18"],
		],
		"problem_template": "Borrow record id {target_id} has been settled and the book returned. Remove it.",
		"pick_id_from": "id",
		"role": "staff",
	},
	{
		"requires_lesson_index": 5, "kind": "delete",
		"table": "borrows",
		"table_headers": ["id", "borrower_name", "book_title", "return_date"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria Santos", "SQL Basics", "June 10"], [2, "Mr. Tan", "The Universe", "June 15"],
			[3, "Sofia Mendez", "Brief History", "June 20"], [4, "Carlos Reyes", "Animal Farm", "June 18"],
		],
		"problem_template": "Record id {target_id} was logged twice by mistake. Delete the duplicate.",
		"pick_id_from": "id",
		"role": "staff",
	},
]
