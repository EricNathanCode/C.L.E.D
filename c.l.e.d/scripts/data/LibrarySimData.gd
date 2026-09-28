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
		"problem_template": "Hi, I'd like to register as a borrower. I'm {first_name} {last_name}, a {membership_type}.",
		"variables": {
			"first_name_male":   ["Diego", "Paolo"],
			"first_name_female": ["Sofia", "Elena", "Grace"],
			"last_name": ["Mendez", "Bautista", "Fernandez", "Santos", "Garcia"],
			"membership_type": ["Student", "Faculty"],
		},
		"gender_field": "first_name",
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
		"problem_template": "New borrower sign-up: {first_name} {last_name}, membership type {membership_type}.",
		"variables": {
			"first_name_male":   ["Marco", "Ben", "Liam"],
			"first_name_female": ["Iris", "Nora"],
			"last_name": ["Villanueva", "Dela Cruz", "Hernandez", "Rivera", "Kim"],
			"membership_type": ["Student", "Faculty"],
		},
		"gender_field": "first_name",
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

	# ── IS NULL / IS NOT NULL (unlocks after Lesson 6, position-wise) | table: borrow_log ──
	{
		"requires_lesson_index": 6, "kind": "select_where_null", "folder": "filtering",
		"table": "borrow_log",
		"table_headers": ["id", "borrower", "book", "return_date"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria Santos", "SQL Basics", "June 10"], [2, "Mr. Tan", "The Universe", null],
			[3, "Sofia Mendez", "Brief History", "June 20"], [4, "Carlos Reyes", "Clean Code", null],
			[5, "Ana Torres", "Design Patterns", "June 25"], [6, "Kim Park", "Cosmos", null],
		],
		"column": "return_date", "mode": "IS NULL",
		"problem": "Books still out have no return date in the system. Can you find all borrows with no return date?",
		"role": "staff",
	},
	{
		"requires_lesson_index": 6, "kind": "select_where_null", "folder": "filtering",
		"table": "borrow_log",
		"table_headers": ["id", "borrower", "book", "return_date"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Maria Santos", "SQL Basics", "June 10"], [2, "Mr. Tan", "The Universe", null],
			[3, "Sofia Mendez", "Brief History", "June 20"], [4, "Carlos Reyes", "Clean Code", null],
			[5, "Ana Torres", "Design Patterns", "June 25"], [6, "Kim Park", "Cosmos", null],
		],
		"column": "return_date", "mode": "IS NOT NULL",
		"problem": "Now show me the borrows that HAVE already been returned, for the completed log.",
		"role": "staff",
	},

	# ── SELECT DISTINCT (unlocks after Lesson 7, position-wise) | table: book_catalog ──
	{
		"requires_lesson_index": 7, "kind": "select_distinct", "folder": "filtering",
		"table": "book_catalog",
		"table_headers": ["id", "title", "author", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Herbert", "Sci-Fi"], [2, "1984", "Orwell", "Fiction"],
			[3, "The Hobbit", "Tolkien", "Fantasy"], [4, "Foundation", "Asimov", "Sci-Fi"],
			[5, "Hamlet", "Shakespeare", "Drama"], [6, "Neuromancer", "Gibson", "Sci-Fi"],
			[7, "Sherlock Holmes", "Doyle", "Mystery"], [8, "Brave New World", "Huxley", "Fiction"],
		],
		"column": "genre",
		"problem": "We have hundreds of books but I want each genre listed only once. No duplicates.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 7, "kind": "select_distinct", "folder": "filtering",
		"table": "book_catalog",
		"table_headers": ["id", "title", "author", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Herbert", "Sci-Fi"], [2, "1984", "Orwell", "Fiction"],
			[3, "The Hobbit", "Tolkien", "Fantasy"], [4, "Foundation", "Asimov", "Sci-Fi"],
			[5, "Hamlet", "Shakespeare", "Drama"], [6, "Neuromancer", "Gibson", "Sci-Fi"],
			[7, "Sherlock Holmes", "Doyle", "Mystery"], [8, "Brave New World", "Huxley", "Fiction"],
		],
		"column": "genre",
		"problem": "For the genre catalogue display, list each unique genre once — nothing repeated.",
		"role": "staff",
	},

	# ── AND / OR (unlocks after Lesson 8, position-wise) | table: shelf_index ──
	{
		"requires_lesson_index": 8, "kind": "where_and_or", "folder": "filtering",
		"table": "shelf_index",
		"table_headers": ["id", "title", "genre", "status"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Sci-Fi", "Available"], [2, "1984", "Fiction", "Available"],
			[3, "Foundation", "Sci-Fi", "Borrowed"], [4, "Neuromancer", "Sci-Fi", "Available"],
			[5, "Hamlet", "Drama", "Available"],
		],
		"col1": "genre", "val1": "Sci-Fi", "col2": "status", "val2": "Available", "connector": "AND",
		"problem": "I need books where genre is Sci-Fi AND status is Available. Both conditions together.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 8, "kind": "where_and_or", "folder": "filtering",
		"table": "shelf_index",
		"table_headers": ["id", "title", "genre", "status"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Sci-Fi", "Available"], [2, "1984", "Fiction", "Available"],
			[3, "Foundation", "Sci-Fi", "Borrowed"], [4, "Neuromancer", "Sci-Fi", "Available"],
			[5, "Hamlet", "Drama", "Available"],
		],
		"col1": "genre", "val1": "Sci-Fi", "col2": "status", "val2": "Available", "connector": "OR",
		"problem": "Now show me every book that's Sci-Fi OR already Available — either one gets a shelf tag.",
		"role": "staff",
	},

	# ── BETWEEN (unlocks after Lesson 9, position-wise) | table: book_years ──
	{
		"requires_lesson_index": 9, "kind": "where_between", "folder": "filtering",
		"table": "book_years",
		"table_headers": ["id", "title", "author", "year_published"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "INTEGER"],
		"seed_rows": [
			[1, "Dune", "Herbert", 1965], [2, "Hamlet", "Shakespeare", 1603],
			[3, "1984", "Orwell", 1949], [4, "Foundation", "Asimov", 1951],
			[5, "Neuromancer", "Gibson", 1984], [6, "Brave New World", "Huxley", 1932],
		],
		"column": "year_published",
		"range_pool": [[1950, 1990], [1900, 1960], [1940, 2000]],
		"problem_template": "I want all books published between {low} and {high}, including those exact years.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 9, "kind": "where_between", "folder": "filtering",
		"table": "book_years",
		"table_headers": ["id", "title", "author", "year_published"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "INTEGER"],
		"seed_rows": [
			[1, "Dune", "Herbert", 1965], [2, "Hamlet", "Shakespeare", 1603],
			[3, "1984", "Orwell", 1949], [4, "Foundation", "Asimov", 1951],
			[5, "Neuromancer", "Gibson", 1984], [6, "Brave New World", "Huxley", 1932],
		],
		"column": "year_published",
		"range_pool": [[1950, 1990], [1900, 1960], [1940, 2000]],
		"problem_template": "For the era display, pull books published between {low} and {high}, inclusive.",
		"role": "staff",
	},

	# ── LIKE (unlocks after Lesson 10, position-wise) | table: book_titles ──
	{
		"requires_lesson_index": 10, "kind": "where_like", "folder": "filtering",
		"table": "book_titles",
		"table_headers": ["id", "title", "author"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "The Hobbit", "Tolkien"], [2, "Dune", "Herbert"],
			[3, "The Name of the Wind", "Rothfuss"], [4, "1984", "Orwell"],
			[5, "The Martian", "Weir"], [6, "Foundation", "Asimov"],
		],
		"column": "title",
		"letter_pool": ["T", "D", "F"],
		"problem_template": "A visitor partially remembers a title — can you find every book whose title starts with {letter}?",
		"role": "staff",
	},
	{
		"requires_lesson_index": 10, "kind": "where_like", "folder": "filtering",
		"table": "book_titles",
		"table_headers": ["id", "title", "author"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "The Hobbit", "Tolkien"], [2, "Dune", "Herbert"],
			[3, "The Name of the Wind", "Rothfuss"], [4, "1984", "Orwell"],
			[5, "The Martian", "Weir"], [6, "Foundation", "Asimov"],
		],
		"column": "title",
		"letter_pool": ["T", "D", "F"],
		"problem_template": "For the display shelf, pull every title that starts with {letter}.",
		"role": "staff",
	},

	# ── IN (unlocks after Lesson 11, position-wise) | table: genre_list ──
	{
		"requires_lesson_index": 11, "kind": "where_in", "folder": "filtering",
		"table": "genre_list",
		"table_headers": ["id", "title", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Sci-Fi"], [2, "Hamlet", "Drama"], [3, "The Hobbit", "Fantasy"],
			[4, "1984", "Fiction"], [5, "Sherlock Holmes", "Mystery"], [6, "Foundation", "Sci-Fi"],
			[7, "Neuromancer", "Sci-Fi"], [8, "Macbeth", "Drama"],
		],
		"column": "genre",
		"value_pool": ["Sci-Fi", "Fantasy", "Mystery"],
		"problem_template": "I need books from {val1} or {val2} only — is there a cleaner way than writing OR conditions?",
		"role": "staff",
	},
	{
		"requires_lesson_index": 11, "kind": "where_in", "folder": "filtering",
		"table": "genre_list",
		"table_headers": ["id", "title", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Sci-Fi"], [2, "Hamlet", "Drama"], [3, "The Hobbit", "Fantasy"],
			[4, "1984", "Fiction"], [5, "Sherlock Holmes", "Mystery"], [6, "Foundation", "Sci-Fi"],
			[7, "Neuromancer", "Sci-Fi"], [8, "Macbeth", "Drama"],
		],
		"column": "genre",
		"value_pool": ["Sci-Fi", "Fantasy", "Mystery"],
		"problem_template": "For the reading club, pull every book that's {val1} or {val2}.",
		"role": "staff",
	},

	# ── ORDER BY (unlocks after Lesson 12, position-wise) | table: book_catalog ──
	{
		"requires_lesson_index": 12, "kind": "order_by", "folder": "sorting",
		"table": "book_catalog",
		"table_headers": ["id", "title", "author", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Herbert", "Sci-Fi"], [2, "1984", "Orwell", "Fiction"],
			[3, "The Hobbit", "Tolkien", "Fantasy"], [4, "Foundation", "Asimov", "Sci-Fi"],
			[5, "Hamlet", "Shakespeare", "Drama"], [6, "Neuromancer", "Gibson", "Sci-Fi"],
			[7, "Sherlock Holmes", "Doyle", "Mystery"], [8, "Brave New World", "Huxley", "Fiction"],
		],
		"column": "title", "direction": "ASC",
		"problem": "Can you pull all books sorted alphabetically by title, A to Z? I need to verify the shelf order.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 12, "kind": "order_by", "folder": "sorting",
		"table": "book_catalog",
		"table_headers": ["id", "title", "author", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Herbert", "Sci-Fi"], [2, "1984", "Orwell", "Fiction"],
			[3, "The Hobbit", "Tolkien", "Fantasy"], [4, "Foundation", "Asimov", "Sci-Fi"],
			[5, "Hamlet", "Shakespeare", "Drama"], [6, "Neuromancer", "Gibson", "Sci-Fi"],
			[7, "Sherlock Holmes", "Doyle", "Mystery"], [8, "Brave New World", "Huxley", "Fiction"],
		],
		"column": "title", "direction": "DESC",
		"problem": "For the printed shelf guide, flip that — sort titles Z to A this time.",
		"role": "staff",
	},

	# ── LIMIT (unlocks after Lesson 13, position-wise) | table: book_catalog ──
	{
		"requires_lesson_index": 13, "kind": "limit", "folder": "sorting",
		"table": "book_catalog",
		"table_headers": ["id", "title", "author", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Herbert", "Sci-Fi"], [2, "1984", "Orwell", "Fiction"],
			[3, "The Hobbit", "Tolkien", "Fantasy"], [4, "Foundation", "Asimov", "Sci-Fi"],
			[5, "Hamlet", "Shakespeare", "Drama"], [6, "Neuromancer", "Gibson", "Sci-Fi"],
			[7, "Sherlock Holmes", "Doyle", "Mystery"], [8, "Brave New World", "Huxley", "Fiction"],
		],
		"count_pool": [3, 5, 7],
		"problem_template": "The website needs a 'Recently Added' preview — just the first {n} books, not the whole catalog.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 13, "kind": "limit", "folder": "sorting",
		"table": "book_catalog",
		"table_headers": ["id", "title", "author", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Herbert", "Sci-Fi"], [2, "1984", "Orwell", "Fiction"],
			[3, "The Hobbit", "Tolkien", "Fantasy"], [4, "Foundation", "Asimov", "Sci-Fi"],
			[5, "Hamlet", "Shakespeare", "Drama"], [6, "Neuromancer", "Gibson", "Sci-Fi"],
			[7, "Sherlock Holmes", "Doyle", "Mystery"], [8, "Brave New World", "Huxley", "Fiction"],
		],
		"count_pool": [3, 5, 7],
		"problem_template": "For a quick preview, cap it at the first {n} books only.",
		"role": "staff",
	},

	# ── GROUP BY (unlocks after Lesson 14, position-wise) | table: genre_list ──
	{
		"requires_lesson_index": 14, "kind": "group_by", "folder": "sorting",
		"table": "genre_list",
		"table_headers": ["id", "title", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Sci-Fi"], [2, "Hamlet", "Drama"], [3, "The Hobbit", "Fantasy"],
			[4, "1984", "Fiction"], [5, "Sherlock Holmes", "Mystery"], [6, "Foundation", "Sci-Fi"],
			[7, "Neuromancer", "Sci-Fi"], [8, "Macbeth", "Drama"],
		],
		"column": "genre",
		"problem": "I need a count of how many books we have per genre. It's for the annual budget proposal.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 14, "kind": "group_by", "folder": "sorting",
		"table": "genre_list",
		"table_headers": ["id", "title", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Sci-Fi"], [2, "Hamlet", "Drama"], [3, "The Hobbit", "Fantasy"],
			[4, "1984", "Fiction"], [5, "Sherlock Holmes", "Mystery"], [6, "Foundation", "Sci-Fi"],
			[7, "Neuromancer", "Sci-Fi"], [8, "Macbeth", "Drama"],
		],
		"column": "genre",
		"problem": "For the acquisition report, group the catalog by genre and show me the count for each.",
		"role": "staff",
	},

	# ── COUNT / SUM / AVG (unlocks after Lesson 15, position-wise) ──────
	{
		"requires_lesson_index": 15, "kind": "aggregate", "folder": "sorting",
		"table": "book_catalog",
		"table_headers": ["id", "title", "author", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Herbert", "Sci-Fi"], [2, "1984", "Orwell", "Fiction"],
			[3, "The Hobbit", "Tolkien", "Fantasy"], [4, "Foundation", "Asimov", "Sci-Fi"],
			[5, "Hamlet", "Shakespeare", "Drama"],
		],
		"func": "COUNT", "column": "id",
		"problem": "How many books do we have total? I need a single number for the board of trustees.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 15, "kind": "aggregate", "folder": "sorting",
		"table": "book_years",
		"table_headers": ["id", "title", "author", "year_published"],
		"table_types":   ["INTEGER", "TEXT", "TEXT", "INTEGER"],
		"seed_rows": [
			[1, "Dune", "Herbert", 1965], [2, "Hamlet", "Shakespeare", 1603],
			[3, "1984", "Orwell", 1949], [4, "Foundation", "Asimov", 1951],
			[5, "Neuromancer", "Gibson", 1984], [6, "Brave New World", "Huxley", 1932],
		],
		"func": "AVG", "column": "year_published",
		"problem": "What's the average publication year across our catalog? I need it for a history display.",
		"role": "staff",
	},

	# ── HAVING (unlocks after Lesson 16, position-wise) | table: genre_list ──
	{
		"requires_lesson_index": 16, "kind": "having", "folder": "sorting",
		"table": "genre_list",
		"table_headers": ["id", "title", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Sci-Fi"], [2, "Hamlet", "Drama"], [3, "The Hobbit", "Fantasy"],
			[4, "1984", "Fiction"], [5, "Sherlock Holmes", "Mystery"], [6, "Foundation", "Sci-Fi"],
			[7, "Neuromancer", "Sci-Fi"], [8, "Macbeth", "Drama"],
		],
		"group_col": "genre",
		"threshold_pool": [1, 2],
		"problem_template": "I grouped by genre already, but now I need genres with more than {threshold} book(s). WHERE cannot filter on a group count.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 16, "kind": "having", "folder": "sorting",
		"table": "genre_list",
		"table_headers": ["id", "title", "genre"],
		"table_types":   ["INTEGER", "TEXT", "TEXT"],
		"seed_rows": [
			[1, "Dune", "Sci-Fi"], [2, "Hamlet", "Drama"], [3, "The Hobbit", "Fantasy"],
			[4, "1984", "Fiction"], [5, "Sherlock Holmes", "Mystery"], [6, "Foundation", "Sci-Fi"],
			[7, "Neuromancer", "Sci-Fi"], [8, "Macbeth", "Drama"],
		],
		"group_col": "genre",
		"threshold_pool": [1, 2],
		"problem_template": "For the display shelves, show only genres with more than {threshold} book(s).",
		"role": "staff",
	},

	# ── AS / Alias (unlocks after Lesson 17, position-wise) | table: fee_log ──
	{
		"requires_lesson_index": 17, "kind": "select_alias", "folder": "sorting",
		"table": "fee_log",
		"table_headers": ["id", "name", "overdue_days"],
		"table_types":   ["INTEGER", "TEXT", "INTEGER"],
		"seed_rows": [
			[1, "Mendez", 10], [2, "Santos", 4], [3, "Reyes", 0],
		],
		"base_col": "overdue_days", "multiplier": "0.50", "alias": "late_fee",
		"problem": "The borrower report needs overdue fees in a clearly labeled column. Rename it to 'late_fee'.",
		"role": "staff",
	},
	{
		"requires_lesson_index": 17, "kind": "select_alias", "folder": "sorting",
		"table": "fee_log",
		"table_headers": ["id", "name", "overdue_days"],
		"table_types":   ["INTEGER", "TEXT", "INTEGER"],
		"seed_rows": [
			[1, "Mendez", 10], [2, "Santos", 4], [3, "Reyes", 0],
		],
		"base_col": "overdue_days", "multiplier": "1.5", "alias": "rush_fee",
		"problem": "For expedited notices, apply the rush penalty rate — but label the column 'rush_fee'.",
		"role": "staff",
	},
]
