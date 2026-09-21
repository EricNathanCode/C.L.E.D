extends Control
# ═══════════════════════════════════════════════════════
#  FOLDER QUIZ SCREEN  |  scripts/FolderQuizScreen.gd
# ═══════════════════════════════════════════════════════

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
	# Rebuild question widgets fresh
	for child in _container.get_children():
		child.queue_free()
	await get_tree().process_frame
	_build_question_widgets()
	_show_question()

# ── Static outer shell (built once) ──────────────────────
func _build_static_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.07, 0.08, 0.11, 1.0)
	bg.anchor_right = 1.0; bg.anchor_bottom = 1.0
	bg.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	bg.z_index = -10
	add_child(bg)

	var tb := ColorRect.new()
	tb.color = Color(0.05, 0.06, 0.09, 1.0)
	tb.anchor_right = 1.0; tb.offset_bottom = 50.0
	tb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(tb)

	var tb_line := ColorRect.new()
	tb_line.color = Color("#F59E0B")
	tb_line.anchor_right = 1.0
	tb_line.offset_top = 49.0; tb_line.offset_bottom = 51.0
	tb_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(tb_line)

	var hdr_lbl := Label.new()
	hdr_lbl.text = "FOLDER CHALLENGE"
	hdr_lbl.add_theme_font_size_override("font_size", 13)
	hdr_lbl.add_theme_color_override("font_color", Color(0.50, 0.55, 0.65))
	hdr_lbl.set_anchors_and_offsets_preset(Control.PRESET_LEFT_WIDE)
	hdr_lbl.offset_left   = 20
	hdr_lbl.offset_bottom = 50
	add_child(hdr_lbl)

	# Back to Dashboard button | top right
	var back_btn := Button.new()
	back_btn.text = "← Dashboard"
	back_btn.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	back_btn.offset_left   = -160
	back_btn.offset_right  = -12
	back_btn.offset_top    = 8
	back_btn.offset_bottom = 42
	_style_ghost(back_btn)
	back_btn.pressed.connect(func():
		get_tree().root.get_node("Main").show_screen("dashboard")
	)
	add_child(back_btn)

	var center := CenterContainer.new()
	center.anchor_right = 1.0; center.anchor_bottom = 1.0
	center.offset_top   = 52.0
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(700, 0)
	var ps := StyleBoxFlat.new()
	ps.bg_color = Color(0.09, 0.10, 0.15, 1.0)
	ps.border_color = Color("#F59E0B")
	ps.set_border_width_all(2)
	ps.set_corner_radius_all(10)
	ps.content_margin_left = 44; ps.content_margin_right  = 44
	ps.content_margin_top  = 38; ps.content_margin_bottom = 38
	panel.add_theme_stylebox_override("panel", ps)
	center.add_child(panel)

	_container = VBoxContainer.new()
	_container.add_theme_constant_override("separation", 18)
	panel.add_child(_container)

# ── Question widgets (rebuilt per quiz) ──────────────────
func _build_question_widgets() -> void:
	_progress_lbl = Label.new()
	_progress_lbl.add_theme_font_size_override("font_size", 12)
	_progress_lbl.add_theme_color_override("font_color", Color(0.40, 0.45, 0.58))
	_container.add_child(_progress_lbl)

	_desc_lbl = Label.new()
	_desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_desc_lbl.add_theme_font_size_override("font_size", 17)
	_desc_lbl.add_theme_color_override("font_color", Color(0.90, 0.92, 0.97))
	_container.add_child(_desc_lbl)

	# SQL code block
	var code_panel := PanelContainer.new()
	var cps := StyleBoxFlat.new()
	cps.bg_color = Color(0.04, 0.05, 0.09, 1.0)
	cps.border_color = Color(0.22, 0.27, 0.38)
	cps.set_border_width_all(2)
	cps.set_corner_radius_all(6)
	cps.content_margin_left = 20; cps.content_margin_right  = 20
	cps.content_margin_top  = 14; cps.content_margin_bottom = 14
	code_panel.add_theme_stylebox_override("panel", cps)
	_container.add_child(code_panel)

	_code_lbl = RichTextLabel.new()
	_code_lbl.bbcode_enabled = true
	_code_lbl.fit_content    = true
	_code_lbl.scroll_active  = false
	_code_lbl.add_theme_font_size_override("normal_font_size", 16)
	code_panel.add_child(_code_lbl)

	# Input row
	var input_row := HBoxContainer.new()
	input_row.add_theme_constant_override("separation", 10)
	_container.add_child(input_row)

	_input = LineEdit.new()
	_input.placeholder_text = "Type your answer here..."
	_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_input.custom_minimum_size = Vector2(0, 46)
	_input.add_theme_font_size_override("font_size", 16)
	_input.add_theme_color_override("font_color", Color(0.95, 0.97, 1.0))
	var ins := StyleBoxFlat.new()
	ins.bg_color = Color(0.04, 0.07, 0.13, 1.0)
	ins.border_color = Color("#F59E0B")
	ins.border_width_bottom = 2
	ins.content_margin_left = 12; ins.content_margin_right  = 12
	ins.content_margin_top  = 8;  ins.content_margin_bottom = 8
	_input.add_theme_stylebox_override("normal", ins)
	_input.add_theme_stylebox_override("focus",  ins)
	_input.text_submitted.connect(_on_submit)
	input_row.add_child(_input)

	var submit_btn := Button.new()
	submit_btn.text = "Submit"
	submit_btn.custom_minimum_size = Vector2(120, 46)
	_style_primary(submit_btn)
	submit_btn.pressed.connect(func(): _on_submit(_input.text))
	input_row.add_child(submit_btn)

	# Result panel + label
	var result_panel := PanelContainer.new()
	result_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var rps := StyleBoxFlat.new()
	rps.set_corner_radius_all(6)
	rps.content_margin_left = 14; rps.content_margin_right  = 14
	rps.content_margin_top  = 10; rps.content_margin_bottom = 10
	result_panel.add_theme_stylebox_override("panel", rps)
	result_panel.visible = false
	_container.add_child(result_panel)

	_result_lbl = Label.new()
	_result_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_result_lbl.add_theme_font_size_override("font_size", 16)
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
	_hint_lbl.add_theme_font_size_override("font_size", 13)
	_hint_lbl.add_theme_color_override("font_color", Color(0.78, 0.68, 0.30))
	_hint_lbl.visible = false
	hint_row.add_child(_hint_lbl)

# ── Show current question ─────────────────────────────────
func _show_question() -> void:
	if _current_q >= _questions.size():
		_show_complete()
		return

	var q: Dictionary = _questions[_current_q]
	_progress_lbl.text = "Question  %d / %d" % [_current_q + 1, _questions.size()]
	_desc_lbl.text = q["desc"]

	var raw: String = q["code"].replace("[BLANK]", "[color=#F59E0B][b] _____ [/b][/color]")
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
		sbox.bg_color = Color(0.08, 0.28, 0.14, 0.90)
		_result_lbl.add_theme_color_override("font_color", Color(0.40, 0.95, 0.60))
		_result_lbl.text = "✓  Correct!"
		panel.visible    = true
		_current_q += 1
		await get_tree().create_timer(0.75).timeout
		_show_question()
	else:
		sbox.bg_color = Color(0.28, 0.07, 0.07, 0.90)
		_result_lbl.add_theme_color_override("font_color", Color(1.0, 0.45, 0.45))
		_result_lbl.text = "✗  Wrong answer check the hint and try again."
		panel.visible    = true
		_input.select_all()

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
	icon_lbl.add_theme_font_size_override("font_size", 48)
	_container.add_child(icon_lbl)

	var done_lbl := Label.new()
	done_lbl.text = "Folder Challenge Complete!"
	done_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	done_lbl.add_theme_font_size_override("font_size", 26)
	done_lbl.add_theme_color_override("font_color", Color("#F59E0B"))
	_container.add_child(done_lbl)

	var sub_lbl := Label.new()
	sub_lbl.text = "The next chapter is now unlocked."
	sub_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_lbl.add_theme_font_size_override("font_size", 15)
	sub_lbl.add_theme_color_override("font_color", Color(0.55, 0.60, 0.72))
	_container.add_child(sub_lbl)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 12)
	_container.add_child(spacer)

	var back_btn := Button.new()
	back_btn.text = "← Back to Dashboard"
	back_btn.custom_minimum_size = Vector2(280, 52)
	_style_primary(back_btn)
	back_btn.pressed.connect(func():
		get_tree().root.get_node("Main").show_screen("dashboard")
	)
	_container.add_child(back_btn)

# ── Button styles ─────────────────────────────────────────
func _style_primary(btn: Button) -> void:
	btn.add_theme_font_size_override("font_size", 15)
	btn.add_theme_color_override("font_color", Color(0.10, 0.06, 0.00))
	var s := StyleBoxFlat.new()
	s.bg_color = Color("#F59E0B")
	s.set_corner_radius_all(8)
	s.set_border_width_all(0)
	s.content_margin_left = 24; s.content_margin_right  = 24
	s.content_margin_top  = 12; s.content_margin_bottom = 12
	var h := s.duplicate() as StyleBoxFlat
	h.bg_color = Color("#FBBF24")
	var p := s.duplicate() as StyleBoxFlat
	p.bg_color = Color("#D97706")
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", p)

func _style_ghost(btn: Button) -> void:
	btn.add_theme_font_size_override("font_size", 13)
	btn.add_theme_color_override("font_color", Color(0.55, 0.60, 0.70))
	var s := StyleBoxFlat.new()
	s.bg_color     = Color(0, 0, 0, 0)
	s.border_color = Color(0.30, 0.35, 0.46)
	s.set_border_width_all(2)
	s.set_corner_radius_all(6)
	s.content_margin_left = 12; s.content_margin_right  = 12
	s.content_margin_top  = 6;  s.content_margin_bottom = 6
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   s)
	btn.add_theme_stylebox_override("pressed", s)

