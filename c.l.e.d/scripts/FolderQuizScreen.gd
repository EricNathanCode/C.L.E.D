extends Control
const Comic = preload("res://scripts/ComicStyle.gd")
const Fx = preload("res://scripts/ComicFx.gd")
# ═══════════════════════════════════════════════════════
#  FOLDER QUIZ SCREEN  |  scripts/FolderQuizScreen.gd
# ═══════════════════════════════════════════════════════

# Same SQL keyword palette as SimulationScreen.gd's Terminal, reused here
# since question "code" strings are free-form (no per-question table/column
# metadata) — only keywords, string literals, and numbers are safely
# colorable without guessing which bare word is a table/column name.
const SQL_KEYWORDS: Array = [
	"select", "from", "where", "insert", "into", "values", "update", "set", "delete",
	"and", "or", "not", "null", "is", "like", "in", "between", "order", "by", "group",
	"having", "limit", "as", "distinct", "asc", "desc", "count", "sum", "avg", "join", "on",
]

const QUIZ_DATA: Dictionary = {
	# Each world now has 3 genre folders (Basic SQL, Filtering Rows,
	# Sorting & Aggregates). Questions = lessons in folder x 2.
	"hotel": [
		# F0 Basic SQL (5 x 2 = 10)
		[
			{"desc": "Retrieve every column from the guests table.", "code": "[BLANK] * FROM guests;", "answer": "SELECT", "hint": "The keyword that starts a read query."},
			{"desc": "Select all columns from guests.", "code": "SELECT [BLANK] FROM guests;", "answer": "*", "hint": "One character that means all columns."},
			{"desc": "Add a new guest named Alice.", "code": "[BLANK] INTO guests (name)\nVALUES ('Alice');", "answer": "INSERT", "hint": "The keyword that adds a new row."},
			{"desc": "Complete the insert statement.", "code": "INSERT [BLANK] guests (name)\nVALUES ('Bob');", "answer": "INTO", "hint": "INSERT ___ tablename (cols) VALUES ..."},
			{"desc": "Find guests staying in Suite rooms.", "code": "SELECT * FROM guests\n[BLANK] room_type = 'Suite';", "answer": "WHERE", "hint": "Filters rows by a condition."},
			{"desc": "Match the exact status value.", "code": "SELECT * FROM guests\nWHERE status [BLANK] 'Active';", "answer": "=", "hint": "Use = for an exact match."},
			{"desc": "Mark guest 3 as Checked Out.", "code": "[BLANK] guests SET status='Checked Out'\nWHERE id = 3;", "answer": "UPDATE", "hint": "The keyword that changes existing rows."},
			{"desc": "Complete the update statement.", "code": "UPDATE guests [BLANK] status='Active'\nWHERE id = 1;", "answer": "SET", "hint": "UPDATE table ___ column = value."},
			{"desc": "Remove the booking with id 5.", "code": "[BLANK] FROM bookings WHERE id = 5;", "answer": "DELETE", "hint": "The keyword that removes rows."},
			{"desc": "Complete the delete statement.", "code": "DELETE [BLANK] bookings WHERE id = 9;", "answer": "FROM", "hint": "DELETE ___ tablename WHERE ..."},
		],
		# F1 Filtering Rows (6 x 2 = 12)
		[
			{"desc": "Find guests with no email recorded.", "code": "SELECT * FROM guests WHERE email [BLANK] NULL;", "answer": "IS", "hint": "___ NULL detects missing values."},
			{"desc": "Find guests that DO have an email.", "code": "SELECT * FROM guests WHERE email IS [BLANK] NULL;", "answer": "NOT", "hint": "IS ___ NULL means the value is present."},
			{"desc": "Get the unique room types.", "code": "SELECT [BLANK] room_type FROM guests;", "answer": "DISTINCT", "hint": "Removes duplicate values."},
			{"desc": "List each city only once.", "code": "SELECT [BLANK] city FROM guests;", "answer": "DISTINCT", "hint": "Placed right after SELECT."},
			{"desc": "VIP guests who also have a booking.", "code": "SELECT * FROM guests\nWHERE status='VIP' [BLANK] has_booking='Yes';", "answer": "AND", "hint": "Both conditions must be true."},
			{"desc": "Guests who are VIP or Regular.", "code": "SELECT * FROM guests\nWHERE status='VIP' [BLANK] status='Regular';", "answer": "OR", "hint": "At least one condition is true."},
			{"desc": "Bookings priced from 100 to 300.", "code": "SELECT * FROM bookings\nWHERE price [BLANK] 100 AND 300;", "answer": "BETWEEN", "hint": "Inclusive range keyword."},
			{"desc": "Complete the range filter.", "code": "SELECT * FROM bookings\nWHERE price BETWEEN 100 [BLANK] 300;", "answer": "AND", "hint": "BETWEEN low ___ high."},
			{"desc": "Guests whose name starts with S.", "code": "SELECT * FROM guests WHERE name [BLANK] 'S%';", "answer": "LIKE", "hint": "Pattern-matching keyword."},
			{"desc": "Fill the wildcard that matches any characters.", "code": "SELECT * FROM guests WHERE name LIKE 'S[BLANK]';", "answer": "%", "hint": "% matches any sequence of characters."},
			{"desc": "Guests from Manila, Cebu, or Davao.", "code": "SELECT * FROM guests\nWHERE city [BLANK] ('Manila','Cebu','Davao');", "answer": "IN", "hint": "Matches any value in a list."},
			{"desc": "Rooms of type Suite or Deluxe.", "code": "SELECT * FROM guests\nWHERE room_type [BLANK] ('Suite','Deluxe');", "answer": "IN", "hint": "IN (v1, v2, ...)."},
		],
		# F2 Sorting & Aggregates (6 x 2 = 12)
		[
			{"desc": "Sort guests by name A to Z.", "code": "SELECT * FROM guests [BLANK] BY name;", "answer": "ORDER", "hint": "___ BY column."},
			{"desc": "Sort bookings by price high to low.", "code": "SELECT * FROM bookings ORDER BY price [BLANK];", "answer": "DESC", "hint": "Descending order keyword."},
			{"desc": "Show only the first 5 bookings.", "code": "SELECT * FROM bookings [BLANK] 5;", "answer": "LIMIT", "hint": "Restricts the number of rows."},
			{"desc": "Return just the top 10 guests.", "code": "SELECT * FROM guests LIMIT [BLANK];", "answer": "10", "hint": "LIMIT N rows."},
			{"desc": "Count bookings per room type.", "code": "SELECT room_type, COUNT(*) FROM bookings\nGROUP [BLANK] room_type;", "answer": "BY", "hint": "GROUP ___ column."},
			{"desc": "Group guests by status.", "code": "SELECT status, COUNT(*) FROM guests\n[BLANK] BY status;", "answer": "GROUP", "hint": "___ BY groups matching rows."},
			{"desc": "Count the total number of guests.", "code": "SELECT [BLANK](id) FROM guests;", "answer": "COUNT", "hint": "Counts rows."},
			{"desc": "Total revenue from all bookings.", "code": "SELECT [BLANK](price) FROM bookings;", "answer": "SUM", "hint": "Adds up all values."},
			{"desc": "Room types with more than 1 booking.", "code": "SELECT room_type, COUNT(*) FROM bookings\nGROUP BY room_type [BLANK] COUNT(*) > 1;", "answer": "HAVING", "hint": "Filters grouped results."},
			{"desc": "Statuses with over 5 guests.", "code": "SELECT status, COUNT(*) FROM guests\nGROUP BY status [BLANK] COUNT(*) > 5;", "answer": "HAVING", "hint": "Like WHERE, but for groups."},
			{"desc": "Rename the COUNT column to total.", "code": "SELECT COUNT(*) [BLANK] total FROM guests;", "answer": "AS", "hint": "Gives a column an alias."},
			{"desc": "Label the SUM result as revenue.", "code": "SELECT SUM(price) [BLANK] revenue FROM bookings;", "answer": "AS", "hint": "AS renames a result column."},
		],
	],
	"cafe": [
		# F0 Basic SQL
		[
			{"desc": "Retrieve every column from the orders table.", "code": "[BLANK] * FROM orders;", "answer": "SELECT", "hint": "The keyword that starts a read query."},
			{"desc": "Select all columns from orders.", "code": "SELECT [BLANK] FROM orders;", "answer": "*", "hint": "One character that means all columns."},
			{"desc": "Add a new order for a Latte.", "code": "[BLANK] INTO orders (item)\nVALUES ('Latte');", "answer": "INSERT", "hint": "The keyword that adds a new row."},
			{"desc": "Complete the insert statement.", "code": "INSERT [BLANK] orders (item)\nVALUES ('Mocha');", "answer": "INTO", "hint": "INSERT ___ tablename (cols) VALUES ..."},
			{"desc": "Find orders for the item Espresso.", "code": "SELECT * FROM orders\n[BLANK] item = 'Espresso';", "answer": "WHERE", "hint": "Filters rows by a condition."},
			{"desc": "Match the exact status value.", "code": "SELECT * FROM orders\nWHERE status [BLANK] 'Paid';", "answer": "=", "hint": "Use = for an exact match."},
			{"desc": "Mark order 3 as Served.", "code": "[BLANK] orders SET status='Served'\nWHERE id = 3;", "answer": "UPDATE", "hint": "The keyword that changes existing rows."},
			{"desc": "Complete the update statement.", "code": "UPDATE orders [BLANK] status='Paid'\nWHERE id = 1;", "answer": "SET", "hint": "UPDATE table ___ column = value."},
			{"desc": "Remove the order with id 5.", "code": "[BLANK] FROM orders WHERE id = 5;", "answer": "DELETE", "hint": "The keyword that removes rows."},
			{"desc": "Complete the delete statement.", "code": "DELETE [BLANK] orders WHERE id = 9;", "answer": "FROM", "hint": "DELETE ___ tablename WHERE ..."},
		],
		# F1 Filtering Rows
		[
			{"desc": "Find orders with no notes recorded.", "code": "SELECT * FROM orders WHERE notes [BLANK] NULL;", "answer": "IS", "hint": "___ NULL detects missing values."},
			{"desc": "Find orders that DO have notes.", "code": "SELECT * FROM orders WHERE notes IS [BLANK] NULL;", "answer": "NOT", "hint": "IS ___ NULL means the value is present."},
			{"desc": "Get the unique drink categories.", "code": "SELECT [BLANK] category FROM orders;", "answer": "DISTINCT", "hint": "Removes duplicate values."},
			{"desc": "List each item only once.", "code": "SELECT [BLANK] item FROM orders;", "answer": "DISTINCT", "hint": "Placed right after SELECT."},
			{"desc": "Paid orders that are also Dine-in.", "code": "SELECT * FROM orders\nWHERE status='Paid' [BLANK] type='Dine-in';", "answer": "AND", "hint": "Both conditions must be true."},
			{"desc": "Orders that are Latte or Mocha.", "code": "SELECT * FROM orders\nWHERE item='Latte' [BLANK] item='Mocha';", "answer": "OR", "hint": "At least one condition is true."},
			{"desc": "Orders priced from 80 to 150.", "code": "SELECT * FROM orders\nWHERE price [BLANK] 80 AND 150;", "answer": "BETWEEN", "hint": "Inclusive range keyword."},
			{"desc": "Complete the range filter.", "code": "SELECT * FROM orders\nWHERE price BETWEEN 80 [BLANK] 150;", "answer": "AND", "hint": "BETWEEN low ___ high."},
			{"desc": "Items whose name starts with C.", "code": "SELECT * FROM orders WHERE item [BLANK] 'C%';", "answer": "LIKE", "hint": "Pattern-matching keyword."},
			{"desc": "Fill the wildcard that matches any characters.", "code": "SELECT * FROM orders WHERE item LIKE 'C[BLANK]';", "answer": "%", "hint": "% matches any sequence of characters."},
			{"desc": "Orders from the Hot, Cold, or Tea category.", "code": "SELECT * FROM orders\nWHERE category [BLANK] ('Hot','Cold','Tea');", "answer": "IN", "hint": "Matches any value in a list."},
			{"desc": "Items that are Latte or Mocha.", "code": "SELECT * FROM orders\nWHERE item [BLANK] ('Latte','Mocha');", "answer": "IN", "hint": "IN (v1, v2, ...)."},
		],
		# F2 Sorting & Aggregates
		[
			{"desc": "Sort menu items by name A to Z.", "code": "SELECT * FROM orders [BLANK] BY item;", "answer": "ORDER", "hint": "___ BY column."},
			{"desc": "Sort orders by price high to low.", "code": "SELECT * FROM orders ORDER BY price [BLANK];", "answer": "DESC", "hint": "Descending order keyword."},
			{"desc": "Show only the first 5 orders.", "code": "SELECT * FROM orders [BLANK] 5;", "answer": "LIMIT", "hint": "Restricts the number of rows."},
			{"desc": "Return just the top 10 orders.", "code": "SELECT * FROM orders LIMIT [BLANK];", "answer": "10", "hint": "LIMIT N rows."},
			{"desc": "Count orders per item.", "code": "SELECT item, COUNT(*) FROM orders\nGROUP [BLANK] item;", "answer": "BY", "hint": "GROUP ___ column."},
			{"desc": "Group orders by category.", "code": "SELECT category, COUNT(*) FROM orders\n[BLANK] BY category;", "answer": "GROUP", "hint": "___ BY groups matching rows."},
			{"desc": "Count the total number of orders.", "code": "SELECT [BLANK](id) FROM orders;", "answer": "COUNT", "hint": "Counts rows."},
			{"desc": "Total sales from all orders.", "code": "SELECT [BLANK](price) FROM orders;", "answer": "SUM", "hint": "Adds up all values."},
			{"desc": "Items ordered more than 3 times.", "code": "SELECT item, COUNT(*) FROM orders\nGROUP BY item [BLANK] COUNT(*) > 3;", "answer": "HAVING", "hint": "Filters grouped results."},
			{"desc": "Categories with over 5 orders.", "code": "SELECT category, COUNT(*) FROM orders\nGROUP BY category [BLANK] COUNT(*) > 5;", "answer": "HAVING", "hint": "Like WHERE, but for groups."},
			{"desc": "Rename the COUNT column to total.", "code": "SELECT COUNT(*) [BLANK] total FROM orders;", "answer": "AS", "hint": "Gives a column an alias."},
			{"desc": "Label the SUM result as sales.", "code": "SELECT SUM(price) [BLANK] sales FROM orders;", "answer": "AS", "hint": "AS renames a result column."},
		],
	],
	"airport": [
		# F0 Basic SQL
		[
			{"desc": "Retrieve every column from the passengers table.", "code": "[BLANK] * FROM passengers;", "answer": "SELECT", "hint": "The keyword that starts a read query."},
			{"desc": "Select all columns from passengers.", "code": "SELECT [BLANK] FROM passengers;", "answer": "*", "hint": "One character that means all columns."},
			{"desc": "Check in a new passenger named Elena.", "code": "[BLANK] INTO passengers (first_name)\nVALUES ('Elena');", "answer": "INSERT", "hint": "The keyword that adds a new row."},
			{"desc": "Complete the insert statement.", "code": "INSERT [BLANK] passengers (first_name)\nVALUES ('Marco');", "answer": "INTO", "hint": "INSERT ___ tablename (cols) VALUES ..."},
			{"desc": "Find passengers seated in Business class.", "code": "SELECT * FROM passengers\n[BLANK] seat_class = 'Business';", "answer": "WHERE", "hint": "Filters rows by a condition."},
			{"desc": "Match the exact status value.", "code": "SELECT * FROM passengers\nWHERE checked_in [BLANK] 'Yes';", "answer": "=", "hint": "Use = for an exact match."},
			{"desc": "Mark passenger 3 as checked in.", "code": "[BLANK] passengers SET checked_in='Yes'\nWHERE id = 3;", "answer": "UPDATE", "hint": "The keyword that changes existing rows."},
			{"desc": "Complete the update statement.", "code": "UPDATE passengers [BLANK] checked_in='Yes'\nWHERE id = 1;", "answer": "SET", "hint": "UPDATE table ___ column = value."},
			{"desc": "Remove the booking with id 5.", "code": "[BLANK] FROM bookings WHERE id = 5;", "answer": "DELETE", "hint": "The keyword that removes rows."},
			{"desc": "Complete the delete statement.", "code": "DELETE [BLANK] bookings WHERE id = 9;", "answer": "FROM", "hint": "DELETE ___ tablename WHERE ..."},
		],
		# F1 Filtering Rows
		[
			{"desc": "Find passengers with no meal preference recorded.", "code": "SELECT * FROM passengers WHERE meal_pref [BLANK] NULL;", "answer": "IS", "hint": "___ NULL detects missing values."},
			{"desc": "Find passengers that DO have a meal preference.", "code": "SELECT * FROM passengers WHERE meal_pref IS [BLANK] NULL;", "answer": "NOT", "hint": "IS ___ NULL means the value is present."},
			{"desc": "Get the unique seat classes.", "code": "SELECT [BLANK] seat_class FROM passengers;", "answer": "DISTINCT", "hint": "Removes duplicate values."},
			{"desc": "List each destination only once.", "code": "SELECT [BLANK] destination FROM bookings;", "answer": "DISTINCT", "hint": "Placed right after SELECT."},
			{"desc": "Business class passengers who also checked in.", "code": "SELECT * FROM passengers\nWHERE seat_class='Business' [BLANK] checked_in='Yes';", "answer": "AND", "hint": "Both conditions must be true."},
			{"desc": "Passengers who are Business or First class.", "code": "SELECT * FROM passengers\nWHERE seat_class='Business' [BLANK] seat_class='First';", "answer": "OR", "hint": "At least one condition is true."},
			{"desc": "Bookings priced from 200 to 500.", "code": "SELECT * FROM bookings\nWHERE ticket_price [BLANK] 200 AND 500;", "answer": "BETWEEN", "hint": "Inclusive range keyword."},
			{"desc": "Complete the range filter.", "code": "SELECT * FROM bookings\nWHERE ticket_price BETWEEN 200 [BLANK] 500;", "answer": "AND", "hint": "BETWEEN low ___ high."},
			{"desc": "Passengers whose name starts with D.", "code": "SELECT * FROM passengers WHERE last_name [BLANK] 'D%';", "answer": "LIKE", "hint": "Pattern-matching keyword."},
			{"desc": "Fill the wildcard that matches any characters.", "code": "SELECT * FROM passengers WHERE last_name LIKE 'D[BLANK]';", "answer": "%", "hint": "% matches any sequence of characters."},
			{"desc": "Bookings to Manila, Cebu, or Davao.", "code": "SELECT * FROM bookings\nWHERE destination [BLANK] ('Manila','Cebu','Davao');", "answer": "IN", "hint": "Matches any value in a list."},
			{"desc": "Passengers seated in Business or First class.", "code": "SELECT * FROM passengers\nWHERE seat_class [BLANK] ('Business','First');", "answer": "IN", "hint": "IN (v1, v2, ...)."},
		],
		# F2 Sorting & Aggregates
		[
			{"desc": "Sort passengers by last name A to Z.", "code": "SELECT * FROM passengers [BLANK] BY last_name;", "answer": "ORDER", "hint": "___ BY column."},
			{"desc": "Sort bookings by ticket price high to low.", "code": "SELECT * FROM bookings ORDER BY ticket_price [BLANK];", "answer": "DESC", "hint": "Descending order keyword."},
			{"desc": "Show only the first 5 passengers.", "code": "SELECT * FROM passengers [BLANK] 5;", "answer": "LIMIT", "hint": "Restricts the number of rows."},
			{"desc": "Return just the top 10 passengers.", "code": "SELECT * FROM passengers LIMIT [BLANK];", "answer": "10", "hint": "LIMIT N rows."},
			{"desc": "Count passengers per seat class.", "code": "SELECT seat_class, COUNT(*) FROM passengers\nGROUP [BLANK] seat_class;", "answer": "BY", "hint": "GROUP ___ column."},
			{"desc": "Group bookings by destination.", "code": "SELECT destination, COUNT(*) FROM bookings\n[BLANK] BY destination;", "answer": "GROUP", "hint": "___ BY groups matching rows."},
			{"desc": "Count the total number of passengers.", "code": "SELECT [BLANK](id) FROM passengers;", "answer": "COUNT", "hint": "Counts rows."},
			{"desc": "Total revenue from all bookings.", "code": "SELECT [BLANK](ticket_price) FROM bookings;", "answer": "SUM", "hint": "Adds up all values."},
			{"desc": "Destinations with more than 1 booking.", "code": "SELECT destination, COUNT(*) FROM bookings\nGROUP BY destination [BLANK] COUNT(*) > 1;", "answer": "HAVING", "hint": "Filters grouped results."},
			{"desc": "Seat classes with over 3 passengers.", "code": "SELECT seat_class, COUNT(*) FROM passengers\nGROUP BY seat_class [BLANK] COUNT(*) > 3;", "answer": "HAVING", "hint": "Like WHERE, but for groups."},
			{"desc": "Rename the COUNT column to total.", "code": "SELECT COUNT(*) [BLANK] total FROM passengers;", "answer": "AS", "hint": "Gives a column an alias."},
			{"desc": "Label the SUM result as revenue.", "code": "SELECT SUM(ticket_price) [BLANK] revenue FROM bookings;", "answer": "AS", "hint": "AS renames a result column."},
		],
	],
	"library": [
		# F0 Basic SQL
		[
			{"desc": "Retrieve every column from the books table.", "code": "[BLANK] * FROM books;", "answer": "SELECT", "hint": "The keyword that starts a read query."},
			{"desc": "Select all columns from books.", "code": "SELECT [BLANK] FROM books;", "answer": "*", "hint": "One character that means all columns."},
			{"desc": "Register a new book titled Dune.", "code": "[BLANK] INTO books (title)\nVALUES ('Dune');", "answer": "INSERT", "hint": "The keyword that adds a new row."},
			{"desc": "Complete the insert statement.", "code": "INSERT [BLANK] books (title)\nVALUES ('1984');", "answer": "INTO", "hint": "INSERT ___ tablename (cols) VALUES ..."},
			{"desc": "Find books in the Fiction genre.", "code": "SELECT * FROM books\n[BLANK] genre = 'Fiction';", "answer": "WHERE", "hint": "Filters rows by a condition."},
			{"desc": "Match the exact status value.", "code": "SELECT * FROM loans\nWHERE status [BLANK] 'Overdue';", "answer": "=", "hint": "Use = for an exact match."},
			{"desc": "Mark loan 3 as Returned.", "code": "[BLANK] loans SET status='Returned'\nWHERE id = 3;", "answer": "UPDATE", "hint": "The keyword that changes existing rows."},
			{"desc": "Complete the update statement.", "code": "UPDATE loans [BLANK] status='Active'\nWHERE id = 1;", "answer": "SET", "hint": "UPDATE table ___ column = value."},
			{"desc": "Remove the loan record with id 5.", "code": "[BLANK] FROM loans WHERE id = 5;", "answer": "DELETE", "hint": "The keyword that removes rows."},
			{"desc": "Complete the delete statement.", "code": "DELETE [BLANK] loans WHERE id = 9;", "answer": "FROM", "hint": "DELETE ___ tablename WHERE ..."},
		],
		# F1 Filtering Rows
		[
			{"desc": "Find books with no author recorded.", "code": "SELECT * FROM books WHERE author [BLANK] NULL;", "answer": "IS", "hint": "___ NULL detects missing values."},
			{"desc": "Find books that DO have an author.", "code": "SELECT * FROM books WHERE author IS [BLANK] NULL;", "answer": "NOT", "hint": "IS ___ NULL means the value is present."},
			{"desc": "Get the unique genres.", "code": "SELECT [BLANK] genre FROM books;", "answer": "DISTINCT", "hint": "Removes duplicate values."},
			{"desc": "List each author only once.", "code": "SELECT [BLANK] author FROM books;", "answer": "DISTINCT", "hint": "Placed right after SELECT."},
			{"desc": "Books that are Fiction and Available.", "code": "SELECT * FROM books\nWHERE genre='Fiction' [BLANK] status='Available';", "answer": "AND", "hint": "Both conditions must be true."},
			{"desc": "Books that are Mystery or Fantasy.", "code": "SELECT * FROM books\nWHERE genre='Mystery' [BLANK] genre='Fantasy';", "answer": "OR", "hint": "At least one condition is true."},
			{"desc": "Books with borrow_count from 10 to 50.", "code": "SELECT * FROM books\nWHERE borrow_count [BLANK] 10 AND 50;", "answer": "BETWEEN", "hint": "Inclusive range keyword."},
			{"desc": "Complete the range filter.", "code": "SELECT * FROM books\nWHERE borrow_count BETWEEN 10 [BLANK] 50;", "answer": "AND", "hint": "BETWEEN low ___ high."},
			{"desc": "Titles that start with M.", "code": "SELECT * FROM books WHERE title [BLANK] 'M%';", "answer": "LIKE", "hint": "Pattern-matching keyword."},
			{"desc": "Fill the wildcard that matches any characters.", "code": "SELECT * FROM books WHERE title LIKE 'M[BLANK]';", "answer": "%", "hint": "% matches any sequence of characters."},
			{"desc": "Books in Mystery, Fantasy, or Sci-Fi.", "code": "SELECT * FROM books\nWHERE genre [BLANK] ('Mystery','Fantasy','Sci-Fi');", "answer": "IN", "hint": "Matches any value in a list."},
			{"desc": "Loans with status Overdue or Lost.", "code": "SELECT * FROM loans\nWHERE status [BLANK] ('Overdue','Lost');", "answer": "IN", "hint": "IN (v1, v2, ...)."},
		],
		# F2 Sorting & Aggregates
		[
			{"desc": "Sort books by title A to Z.", "code": "SELECT * FROM books [BLANK] BY title;", "answer": "ORDER", "hint": "___ BY column."},
			{"desc": "Sort books by borrow_count high to low.", "code": "SELECT * FROM books ORDER BY borrow_count [BLANK];", "answer": "DESC", "hint": "Descending order keyword."},
			{"desc": "Show only the first 5 books.", "code": "SELECT * FROM books [BLANK] 5;", "answer": "LIMIT", "hint": "Restricts the number of rows."},
			{"desc": "Return just the top 10 books.", "code": "SELECT * FROM books LIMIT [BLANK];", "answer": "10", "hint": "LIMIT N rows."},
			{"desc": "Count books per genre.", "code": "SELECT genre, COUNT(*) FROM books\nGROUP [BLANK] genre;", "answer": "BY", "hint": "GROUP ___ column."},
			{"desc": "Group loans by member.", "code": "SELECT member_id, COUNT(*) FROM loans\n[BLANK] BY member_id;", "answer": "GROUP", "hint": "___ BY groups matching rows."},
			{"desc": "Count the total number of books.", "code": "SELECT [BLANK](id) FROM books;", "answer": "COUNT", "hint": "Counts rows."},
			{"desc": "Average late fee across all loans.", "code": "SELECT [BLANK](late_fee) FROM loans;", "answer": "AVG", "hint": "Computes the average of a column."},
			{"desc": "Genres with more than 10 books.", "code": "SELECT genre, COUNT(*) FROM books\nGROUP BY genre [BLANK] COUNT(*) > 10;", "answer": "HAVING", "hint": "Filters grouped results."},
			{"desc": "Members with more than 3 loans.", "code": "SELECT member_id, COUNT(*) FROM loans\nGROUP BY member_id [BLANK] COUNT(*) > 3;", "answer": "HAVING", "hint": "Like WHERE, but for groups."},
			{"desc": "Rename the COUNT column to total.", "code": "SELECT COUNT(*) [BLANK] total FROM books;", "answer": "AS", "hint": "Gives a column an alias."},
			{"desc": "Label the AVG result as avg_fee.", "code": "SELECT AVG(late_fee) [BLANK] avg_fee FROM loans;", "answer": "AS", "hint": "AS renames a result column."},
		],
	],
}

var _questions: Array = []
var _current_q: int   = 0
var _hint_visible: bool = false

# Persistent UI refs (built once in _ready)
var _container:    VBoxContainer
var _progress_lbl: Label
var _desc_lbl:     Label
var _code_lbl:     RichTextLabel
var _input:        LineEdit
var _result_lbl:   Label
var _hint_btn:     Button
var _hint_lbl:     Label

func _ready() -> void:
	_build_static_ui()

# ── Called by Main when switching to this screen ──────────
func start_quiz() -> void:
	var w: String = GameManager.world
	var fi: int   = GameManager.current_quiz_folder_idx
	var world_data: Array = QUIZ_DATA.get(w, [])
	_questions = (world_data[fi] if fi < world_data.size() else []).duplicate()
	_questions.shuffle()
	_current_q    = 0
	_hint_visible = false
	_v2_refresh()
	# Rebuild question widgets fresh
	for child in _container.get_children():
		child.queue_free()
	await get_tree().process_frame
	_build_question_widgets()
	_show_question()

# ── Static outer shell (built once) ──────────────────────
func _build_static_ui() -> void:
	var bg := ColorRect.new()
	Comic.apply_halftone(bg)
	bg.anchor_right = 1.0; bg.anchor_bottom = 1.0
	bg.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	bg.z_index = -10
	add_child(bg)

	var tb := ColorRect.new()
	tb.color = Comic.INK
	tb.anchor_right = 1.0; tb.offset_bottom = 62.0
	tb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(tb)

	var tb_line := ColorRect.new()
	tb_line.color = Comic.YELLOW
	tb_line.anchor_right = 1.0
	tb_line.offset_top = 62.0; tb_line.offset_bottom = 67.0
	tb_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(tb_line)

	var hdr_lbl := Label.new()
	hdr_lbl.text = "FOLDER CHALLENGE"
	Comic.heading(hdr_lbl, 30, Comic.YELLOW)
	hdr_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hdr_lbl.set_anchors_and_offsets_preset(Control.PRESET_LEFT_WIDE)
	hdr_lbl.anchor_bottom = 0.0
	hdr_lbl.offset_left   = 20
	hdr_lbl.offset_bottom = 62
	add_child(hdr_lbl)

	# Back to Dashboard button | top right
	var back_btn := Button.new()
	back_btn.text = "← Dashboard"
	back_btn.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	back_btn.offset_left   = -230
	back_btn.offset_right  = -14
	back_btn.offset_top    = 7
	back_btn.offset_bottom = 55
	_style_ghost(back_btn)
	back_btn.pressed.connect(func():
		get_tree().root.get_node("Main").show_screen("dashboard")
	)
	add_child(back_btn)

	var center := CenterContainer.new()
	center.anchor_right = 1.0; center.anchor_bottom = 1.0
	center.offset_top   = 76.0
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(700, 0)
	Comic.apply_panel(panel, Comic.PAPER_HI, 20, 9, 46, 38, 5)
	center.add_child(panel)

	_container = VBoxContainer.new()
	_container.add_theme_constant_override("separation", 18)
	panel.add_child(_container)

	_apply_v2(bg, back_btn, panel)

# ── Question widgets (rebuilt per quiz) ──────────────────
func _build_question_widgets() -> void:
	_progress_lbl = Label.new()
	Comic.heading(_progress_lbl, 26, Comic.RED)
	_container.add_child(_progress_lbl)

	_desc_lbl = Label.new()
	_desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	Comic.body(_desc_lbl, 22, Comic.INK)
	_container.add_child(_desc_lbl)

	# SQL code block
	var code_panel := PanelContainer.new()
	code_panel.add_theme_stylebox_override("panel", Comic.box(Color("#211B16"), Comic.INK, 4, 10, 0, 24, 16))
	_container.add_child(code_panel)

	_code_lbl = RichTextLabel.new()
	_code_lbl.bbcode_enabled = true
	_code_lbl.fit_content    = true
	_code_lbl.scroll_active  = false
	_code_lbl.add_theme_font_override("normal_font", Comic.body_font())
	_code_lbl.add_theme_font_size_override("normal_font_size", 21)
	code_panel.add_child(_code_lbl)

	# Input row
	var input_row := HBoxContainer.new()
	input_row.add_theme_constant_override("separation", 10)
	_container.add_child(input_row)

	_input = LineEdit.new()
	_input.placeholder_text = "Type your answer here..."
	_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_input.custom_minimum_size = Vector2(0, 54)
	Comic.apply_input(_input, 21)
	_input.text_submitted.connect(_on_submit)
	input_row.add_child(_input)

	var submit_btn := Button.new()
	submit_btn.text = "Submit"
	submit_btn.custom_minimum_size = Vector2(150, 54)
	_style_primary(submit_btn)
	submit_btn.pressed.connect(func(): _on_submit(_input.text))
	input_row.add_child(submit_btn)

	# Result panel + label
	var result_panel := PanelContainer.new()
	result_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var rps := StyleBoxFlat.new()
	rps.set_corner_radius_all(10)
	rps.set_border_width_all(3)
	rps.border_color = Comic.INK
	rps.content_margin_left = 14; rps.content_margin_right  = 14
	rps.content_margin_top  = 10; rps.content_margin_bottom = 10
	result_panel.add_theme_stylebox_override("panel", rps)
	result_panel.visible = false
	_container.add_child(result_panel)

	_result_lbl = Label.new()
	_result_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	Comic.heading(_result_lbl, 26, Comic.INK)
	result_panel.add_child(_result_lbl)

	# Store panel ref so we can tint it on wrong/correct
	_result_lbl.set_meta("panel", result_panel)
	_result_lbl.set_meta("style", rps)

	# Hint row
	var hint_row := HBoxContainer.new()
	hint_row.add_theme_constant_override("separation", 14)
	_container.add_child(hint_row)

	_hint_btn = Button.new()
	_hint_btn.text = "💡  Show Hint"
	_style_ghost(_hint_btn)
	_hint_btn.pressed.connect(_on_hint)
	hint_row.add_child(_hint_btn)

	_hint_lbl = Label.new()
	_hint_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_hint_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	Comic.body(_hint_lbl, 18, Color("#8A5A00"))
	_hint_lbl.visible = false
	hint_row.add_child(_hint_lbl)

# ── Show current question ─────────────────────────────────
# Colors keywords blue, string literals orange, and numbers green — same
# palette as the Terminal — while leaving bare identifiers (table/column
# names) neutral, since this screen's questions carry no per-question
# table/column metadata to safely tell an identifier from any other word.
# Run BEFORE the "[BLANK]" -> underline replacement so the literal
# "[BLANK]" marker passes through untouched (it matches no keyword).
func _is_letter_or_underscore(c: String) -> bool:
	return (c >= "a" and c <= "z") or (c >= "A" and c <= "Z") or c == "_"

func _is_ident_char(c: String) -> bool:
	return _is_letter_or_underscore(c) or (c >= "0" and c <= "9")

func _colorize_sql_line(code: String) -> String:
	var result: String = ""
	var i: int = 0
	var n: int = code.length()
	while i < n:
		var c: String = code[i]
		if c == "'":
			var j: int = i + 1
			while j < n and code[j] != "'":
				j += 1
			j = min(j, n - 1)
			result += "[color=#CF9178]" + code.substr(i, j - i + 1) + "[/color]"
			i = j + 1
		elif c >= "0" and c <= "9":
			var j: int = i
			while j < n and (code[j] >= "0" and code[j] <= "9"):
				j += 1
			result += "[color=#B5CFA8]" + code.substr(i, j - i) + "[/color]"
			i = j
		elif _is_letter_or_underscore(c):
			var j: int = i
			while j < n and _is_ident_char(code[j]):
				j += 1
			var word: String = code.substr(i, j - i)
			if SQL_KEYWORDS.has(word.to_lower()):
				result += "[color=#6BB0E8]" + word + "[/color]"
			else:
				result += word
			i = j
		else:
			result += c
			i += 1
	return result

func _show_question() -> void:
	if _current_q >= _questions.size():
		_show_complete()
		return

	var q: Dictionary = _questions[_current_q]
	_progress_lbl.text = "Question  %d / %d" % [_current_q + 1, _questions.size()]
	_desc_lbl.text = q["desc"]

	var raw: String = _colorize_sql_line(q["code"]).replace("[BLANK]", "[color=#F59E0B][b] _____ [/b][/color]")
	_code_lbl.text = raw

	_input.text = ""
	_input.grab_focus()
	if _result_lbl.has_meta("panel"):
		(_result_lbl.get_meta("panel") as Control).visible = false
	_hint_lbl.visible   = false
	_hint_visible       = false
	_hint_btn.text      = "💡  Show Hint"
	_hint_lbl.text      = "Hint: " + q.get("hint", "")

# ── Answer submission ─────────────────────────────────────
func _on_submit(text: String) -> void:
	if _questions.is_empty():
		return
	var correct: String = _questions[_current_q]["answer"].strip_edges().to_upper()
	var given: String   = text.strip_edges().to_upper()

	var panel: PanelContainer = _result_lbl.get_meta("panel")
	var sbox:  StyleBoxFlat   = _result_lbl.get_meta("style")

	if given == correct:
		sbox.bg_color = Color("#CDEFD8")
		_result_lbl.add_theme_color_override("font_color", Color("#1E8E4F"))
		_result_lbl.text = "✓  Correct!"
		panel.visible    = true
		_v2_pop_correct(panel)
		GameManager.play_correct()
		_current_q += 1
		await get_tree().create_timer(0.75).timeout
		_show_question()
	else:
		sbox.bg_color = Color("#FFD9D3")
		_result_lbl.add_theme_color_override("font_color", Comic.RED)
		_result_lbl.text = "✗  Wrong answer check the hint and try again."
		panel.visible    = true
		GameManager.play_wrong()
		_input.select_all()
		_shake(panel)

# Quick side-to-side shake so a wrong answer is unmistakable even on a
# repeated miss, not just a color change.
func _shake(node: Control) -> void:
	var base_x: float = node.position.x
	var tw := create_tween()
	tw.tween_property(node, "position:x", base_x - 10, 0.05)
	tw.tween_property(node, "position:x", base_x + 10, 0.05)
	tw.tween_property(node, "position:x", base_x - 8,  0.05)
	tw.tween_property(node, "position:x", base_x + 8,  0.05)
	tw.tween_property(node, "position:x", base_x - 4,  0.05)
	tw.tween_property(node, "position:x", base_x,      0.05)

func _on_hint() -> void:
	_hint_visible      = not _hint_visible
	_hint_lbl.visible  = _hint_visible
	_hint_btn.text     = ("💡  Hide Hint" if _hint_visible else "💡  Show Hint")

# ── Completion screen ─────────────────────────────────────
func _show_complete() -> void:
	GameManager.complete_folder_quiz(GameManager.world, GameManager.current_quiz_folder_idx)

	for child in _container.get_children():
		child.queue_free()
	await get_tree().process_frame

	var icon_lbl := Label.new()
	icon_lbl.text = "⚡"
	icon_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	Comic.title(icon_lbl, 80, Comic.YELLOW, 12)
	_container.add_child(icon_lbl)

	var done_lbl := Label.new()
	done_lbl.text = "Folder Challenge Complete!"
	done_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	Comic.title(done_lbl, 50, Comic.YELLOW, 10)
	_container.add_child(done_lbl)

	var sub_lbl := Label.new()
	sub_lbl.text = "The next chapter is now unlocked."
	sub_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	Comic.heading(sub_lbl, 26, Comic.INK_SOFT)
	_container.add_child(sub_lbl)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 12)
	_container.add_child(spacer)

	var back_btn := Button.new()
	back_btn.text = "← Back to Dashboard"
	back_btn.custom_minimum_size = Vector2(340, 62)
	_style_primary(back_btn)
	back_btn.pressed.connect(func():
		get_tree().root.get_node("Main").show_screen("dashboard")
	)
	_container.add_child(back_btn)

# ── Button styles (comic look, from ComicStyle) ───────────
func _style_primary(btn: Button) -> void:
	Comic.apply_button(btn, "primary", 26, true, 26, 10)

# Cream secondary button (kept under its old name so every call site still works)
func _style_ghost(btn: Button) -> void:
	Comic.apply_button(btn, "secondary", 20, true, 16, 7)

# ── Comic v2: a "CORRECT!" burst pops beside the feedback box ──
func _v2_pop_correct(panel: Control) -> void:
	var b := Fx.sticker("CORRECT!", "", Comic.YELLOW, Comic.RED, Vector2(190, 110), 36, 14, 8.0)
	b.position = panel.global_position - global_position + Vector2(panel.size.x - 40.0, -56.0)
	b.z_index = 30
	add_child(b)
	Fx.pop(b)
	var tw := b.create_tween()
	tw.tween_interval(0.7)
	tw.tween_callback(b.queue_free)

# ── Comic v2 look (decoration only) ───────────────────────
const V2_CHAR: Dictionary = {
	"hotel": "adult_1", "cafe": "adult_3", "airport": "adult_2", "library": "adult_7",
}
var _v2_char: TextureRect = null

func _apply_v2(bg: ColorRect, back_btn: Button, panel: PanelContainer) -> void:
	var rays := Fx.rays_rect(Comic.PAPER, Color("#FBE7B5"), Color(0.9, 0.25, 0.18, 0.22), Vector2(0.5, 0.56))
	bg.material = rays.material
	rays.free()
	Fx.red_shadow(back_btn)

	# The world's character cheering the player on, with a speech bubble
	_v2_char = TextureRect.new()
	_v2_char.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_v2_char.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	Fx.place_right(_v2_char, Rect2(1000, 150, 300, 680))
	_v2_char.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_v2_char.z_index = -5
	add_child(_v2_char)

	var bubble := Fx.Bubble.new()
	bubble.radius = 26
	bubble.outline = 4.0
	bubble.shadow = 5.0
	bubble.tail_side = "bottom"
	bubble.tail_at = 0.62
	bubble.tail_width = 26.0
	bubble.tail_rel = Vector2(0.86, 1.0)
	bubble.tail_px = Vector2(0.0, 34.0)
	bubble.add_theme_constant_override("margin_left", 14)
	bubble.add_theme_constant_override("margin_right", 14)
	bubble.add_theme_constant_override("margin_top", 10)
	bubble.add_theme_constant_override("margin_bottom", 12)
	Fx.place_right(bubble, Rect2(1016, 84, 0, 0))
	var say := Label.new()
	say.text = "Boss fight! Clear every question to unlock the next chapter."
	say.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	say.custom_minimum_size = Vector2(200, 0)
	Comic.body(say, 16, Comic.INK)
	bubble.add_child(say)
	bubble.z_index = -4
	add_child(bubble)

	# "BOSS FIGHT!" burst pinned to the panel's top-left corner
	var boss := Fx.sticker("BOSS FIGHT!", "", Comic.RED, Color.WHITE, Vector2(200, 100), 30, 14, -8.0)
	add_child(boss)
	var pin := func():
		boss.global_position = panel.global_position + Vector2(-96, -62)
	panel.item_rect_changed.connect(pin)
	pin.call()

func _v2_refresh() -> void:
	if _v2_char == null:
		return
	var path: String = "res://images/characters/NPC_adults/%s/talk.png" % V2_CHAR.get(GameManager.world, "adult_1")
	_v2_char.texture = load(path) if ResourceLoader.exists(path) else null
