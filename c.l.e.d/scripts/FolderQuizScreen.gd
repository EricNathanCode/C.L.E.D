extends Control
# ═══════════════════════════════════════════════════════
#  FOLDER QUIZ SCREEN  —  scripts/FolderQuizScreen.gd
# ═══════════════════════════════════════════════════════

const QUIZ_DATA: Dictionary = {
	"hotel": [
		# Folder 0 — Basic SQL (5 lessons × 2 = 10 questions)
		[
			# — SELECT —
			{"desc": "Retrieve every column from the guests table.",
			 "code": "SELECT [BLANK] FROM guests;",
			 "answer": "*",
			 "hint": "Use a single character that means all columns."},
			{"desc": "Retrieve the name and status columns from guests.",
			 "code": "[BLANK] name, status FROM guests;",
			 "answer": "SELECT",
			 "hint": "The keyword that starts a read query."},
			# — INSERT INTO —
			{"desc": "Add a new guest named Alice with room type Deluxe.",
			 "code": "INSERT [BLANK] guests (name, room_type)\nVALUES ('Alice', 'Deluxe');",
			 "answer": "INTO",
			 "hint": "INSERT ___ tablename (columns) VALUES (...)"},
			{"desc": "Log a new booking record for guest id 5.",
			 "code": "[BLANK] INTO bookings (guest_id, room_type)\nVALUES (5, 'Suite');",
			 "answer": "INSERT",
			 "hint": "The keyword that adds a new row to a table."},
			# — SELECT WHERE —
			{"desc": "Find guests whose room type is Suite.",
			 "code": "SELECT * FROM guests\nWHERE room_type [BLANK] 'Suite';",
			 "answer": "=",
			 "hint": "Use = to match an exact value."},
			{"desc": "Find all active guests from the guests table.",
			 "code": "SELECT * FROM guests\n[BLANK] status = 'Active';",
			 "answer": "WHERE",
			 "hint": "WHERE filters rows by a condition."},
			# — UPDATE SET —
			{"desc": "Mark guest id 3 as Checked Out.",
			 "code": "UPDATE guests [BLANK] status = 'Checked Out'\nWHERE id = 3;",
			 "answer": "SET",
			 "hint": "UPDATE table ___ column = value WHERE ..."},
			{"desc": "Change the room type for guest id 7 to Deluxe.",
			 "code": "UPDATE guests SET room_type = 'Deluxe'\n[BLANK] id = 7;",
			 "answer": "WHERE",
			 "hint": "WHERE identifies which row to update."},
			# — DELETE —
			{"desc": "Remove the booking record where id equals 5.",
			 "code": "[BLANK] FROM bookings WHERE id = 5;",
			 "answer": "DELETE",
			 "hint": "The keyword that removes rows from a table."},
			{"desc": "Cancel all bookings where the status is Cancelled.",
			 "code": "DELETE [BLANK] bookings WHERE status = 'Cancelled';",
			 "answer": "FROM",
			 "hint": "DELETE ___ tablename WHERE condition"},
		],
		# Folder 1 — Filtering & Sorting (11 lessons × 2 = 22 questions)
		[
			# — ORDER BY —
			{"desc": "Sort the guest list by last name A to Z.",
			 "code": "SELECT * FROM guests ORDER [BLANK] last_name;",
			 "answer": "BY",
			 "hint": "ORDER ___ column_name"},
			{"desc": "Sort bookings by price from highest to lowest.",
			 "code": "SELECT * FROM bookings\n[BLANK] BY price DESC;",
			 "answer": "ORDER",
			 "hint": "___ BY column DESC sorts descending."},
			# — IS NULL —
			{"desc": "Find guests whose email address is missing.",
			 "code": "SELECT * FROM guests WHERE email IS [BLANK];",
			 "answer": "NULL",
			 "hint": "IS ___ checks for a missing value."},
			{"desc": "Find bookings that have no check-out date.",
			 "code": "SELECT * FROM bookings WHERE check_out [BLANK] NULL;",
			 "answer": "IS",
			 "hint": "___ NULL detects missing values — never use = NULL."},
			# — DISTINCT —
			{"desc": "Get only the unique room types from bookings.",
			 "code": "SELECT [BLANK] room_type FROM bookings;",
			 "answer": "DISTINCT",
			 "hint": "Removes duplicate rows from results."},
			{"desc": "List all unique cities that guests come from.",
			 "code": "SELECT [BLANK] city FROM guests;",
			 "answer": "DISTINCT",
			 "hint": "Place this keyword right after SELECT."},
			# — AND / OR —
			{"desc": "Find guests from Manila who are also Active.",
			 "code": "SELECT * FROM guests\nWHERE city = 'Manila' [BLANK] status = 'Active';",
			 "answer": "AND",
			 "hint": "Use AND to require both conditions to be true."},
			{"desc": "Find guests who are either VIP or have a Suite room.",
			 "code": "SELECT * FROM guests\nWHERE tier = 'VIP' [BLANK] room_type = 'Suite';",
			 "answer": "OR",
			 "hint": "OR returns rows where at least one condition is true."},
			# — BETWEEN —
			{"desc": "Find bookings where price is between 100 and 500.",
			 "code": "SELECT * FROM bookings\nWHERE price [BLANK] 100 AND 500;",
			 "answer": "BETWEEN",
			 "hint": "BETWEEN low AND high"},
			{"desc": "Find guests who checked in between two dates.",
			 "code": "SELECT * FROM guests\nWHERE check_in BETWEEN '2024-01-01' [BLANK] '2024-12-31';",
			 "answer": "AND",
			 "hint": "BETWEEN start ___ end — connects the range."},
			# — LIKE —
			{"desc": "Find guests whose name starts with the letter A.",
			 "code": "SELECT * FROM guests WHERE name [BLANK] 'A%';",
			 "answer": "LIKE",
			 "hint": "LIKE 'pattern%' matches partial text."},
			{"desc": "Find bookings whose notes contain the word Special.",
			 "code": "SELECT * FROM bookings WHERE notes [BLANK] '%Special%';",
			 "answer": "LIKE",
			 "hint": "LIKE '%word%' matches text containing a word."},
			# — IN —
			{"desc": "Get guests from Manila, Cebu, or Davao.",
			 "code": "SELECT * FROM guests\nWHERE city [BLANK] ('Manila', 'Cebu', 'Davao');",
			 "answer": "IN",
			 "hint": "IN (v1, v2, ...) matches any listed value."},
			{"desc": "Find bookings for room types Standard, Deluxe, or Suite.",
			 "code": "SELECT * FROM bookings\nWHERE room_type [BLANK] ('Standard','Deluxe','Suite');",
			 "answer": "IN",
			 "hint": "IN (v1, v2, ...) matches any listed value."},
			# — LIMIT —
			{"desc": "Show only the top 5 most expensive bookings.",
			 "code": "SELECT * FROM bookings\nORDER BY price DESC [BLANK] 5;",
			 "answer": "LIMIT",
			 "hint": "LIMIT N restricts how many rows are returned."},
			{"desc": "Retrieve only the first 10 guest records.",
			 "code": "SELECT * FROM guests [BLANK] 10;",
			 "answer": "LIMIT",
			 "hint": "LIMIT N restricts how many rows are returned."},
			# — DATE FUNCTIONS —
			{"desc": "Find all bookings where the check_out date has already passed.",
			 "code": "SELECT * FROM bookings\nWHERE check_out < [BLANK]('now');",
			 "answer": "DATE",
			 "hint": "DATE('now') returns today's date in SQLite."},
			{"desc": "Get all bookings where check_out matches today.",
			 "code": "SELECT * FROM bookings\nWHERE check_out = DATE([BLANK]);",
			 "answer": "'now'",
			 "hint": "DATE('now') returns today's date."},
			# — STRING FUNCTIONS —
			{"desc": "Show every guest name in capital letters.",
			 "code": "SELECT [BLANK](name) FROM guests;",
			 "answer": "UPPER",
			 "hint": "UPPER() converts text to capitals; LOWER() to lowercase."},
			{"desc": "Count how many characters are in each guest name.",
			 "code": "SELECT [BLANK](name) FROM guests;",
			 "answer": "LENGTH",
			 "hint": "LENGTH() returns the number of characters in a string."},
			# — COALESCE / IFNULL —
			{"desc": "Show the email, or 'No email' when it is missing.",
			 "code": "SELECT name,\n  [BLANK](email, 'No email') FROM guests;",
			 "answer": "COALESCE",
			 "hint": "COALESCE returns the first non-NULL value."},
			{"desc": "Replace a missing phone number with 'N/A'.",
			 "code": "SELECT name,\n  [BLANK](phone, 'N/A') FROM guests;",
			 "answer": "COALESCE",
			 "hint": "COALESCE(value, fallback) returns the first non-NULL value."},
		],
		# Folder 2 — Aggregates & Joins (8 lessons × 2 = 16 questions)
		[
			# — GROUP BY —
			{"desc": "Count how many bookings each room type has.",
			 "code": "SELECT room_type, COUNT(*) FROM bookings\nGROUP [BLANK] room_type;",
			 "answer": "BY",
			 "hint": "GROUP ___ column groups rows together."},
			{"desc": "Get the total price per room type from bookings.",
			 "code": "SELECT room_type, SUM(price) FROM bookings\n[BLANK] BY room_type;",
			 "answer": "GROUP",
			 "hint": "___ BY column aggregates rows into groups."},
			# — JOIN —
			{"desc": "Combine guests with their booking records.",
			 "code": "SELECT * FROM guests\nINNER [BLANK] bookings ON guests.id = bookings.guest_id;",
			 "answer": "JOIN",
			 "hint": "INNER ___ links matching rows from two tables."},
			{"desc": "Join the rooms table with bookings on room id.",
			 "code": "SELECT * FROM rooms\n[BLANK] JOIN bookings ON rooms.id = bookings.room_id;",
			 "answer": "INNER",
			 "hint": "___ JOIN only returns rows that match in both tables."},
			# — COUNT / SUM / AVG —
			{"desc": "Calculate the average booking price.",
			 "code": "SELECT [BLANK](price) FROM bookings;",
			 "answer": "AVG",
			 "hint": "AVG() computes the average value of a column."},
			{"desc": "Count the total number of guest records.",
			 "code": "SELECT [BLANK](id) FROM guests;",
			 "answer": "COUNT",
			 "hint": "COUNT() counts the number of rows."},
			# — HAVING —
			{"desc": "Show room types booked more than 10 times.",
			 "code": "SELECT room_type, COUNT(*) FROM bookings\nGROUP BY room_type [BLANK] COUNT(*) > 10;",
			 "answer": "HAVING",
			 "hint": "HAVING filters grouped results — like WHERE but after GROUP BY."},
			{"desc": "Show cities where total guest count exceeds 50.",
			 "code": "SELECT city, COUNT(*) FROM guests\nGROUP BY city [BLANK] COUNT(*) > 50;",
			 "answer": "HAVING",
			 "hint": "HAVING filters after GROUP BY."},
			# — AS —
			{"desc": "Rename the COUNT result column to total_bookings.",
			 "code": "SELECT COUNT(*) [BLANK] total_bookings FROM bookings;",
			 "answer": "AS",
			 "hint": "AS gives a column a readable alias."},
			{"desc": "Label the average price column avg_price.",
			 "code": "SELECT AVG(price) [BLANK] avg_price FROM bookings;",
			 "answer": "AS",
			 "hint": "AS renames a column in the result."},
			# — LEFT JOIN —
			{"desc": "Show all rooms including those with no bookings.",
			 "code": "SELECT * FROM rooms\n[BLANK] JOIN bookings ON rooms.id = bookings.room_id;",
			 "answer": "LEFT",
			 "hint": "LEFT JOIN keeps all rows from the left table."},
			{"desc": "List all guests and their bookings, even guests with none.",
			 "code": "SELECT * FROM guests\nLEFT [BLANK] bookings ON guests.id = bookings.guest_id;",
			 "answer": "JOIN",
			 "hint": "LEFT ___ links tables but keeps all left-side rows."},
			# — SUBQUERY —
			{"desc": "Find the booking with the highest price using a subquery.",
			 "code": "SELECT * FROM bookings\nWHERE price = (SELECT [BLANK](price) FROM bookings);",
			 "answer": "MAX",
			 "hint": "The inner query finds the highest price. MAX() returns the largest value."},
			{"desc": "Complete the subquery to find the most expensive booking.",
			 "code": "SELECT * FROM bookings\nWHERE price = ([BLANK] MAX(price) FROM bookings);",
			 "answer": "SELECT",
			 "hint": "A subquery starts with SELECT inside the parentheses."},
			# — UNION —
			{"desc": "Combine guest cities and staff cities into one list.",
			 "code": "SELECT city FROM guests\n[BLANK]\nSELECT city FROM staff;",
			 "answer": "UNION",
			 "hint": "UNION merges two SELECT results and removes duplicates."},
			{"desc": "Combine both city lists but keep duplicate rows.",
			 "code": "SELECT city FROM guests\nUNION [BLANK]\nSELECT city FROM staff;",
			 "answer": "ALL",
			 "hint": "UNION ALL keeps duplicates; the keyword after UNION is ALL."},
		],
		# Folder 3 — Database Design (10 lessons × 2 = 20 questions)
		[
			# — CREATE DATABASE —
			{"desc": "Create a new database called hotel_db.",
			 "code": "CREATE [BLANK] hotel_db;",
			 "answer": "DATABASE",
			 "hint": "CREATE ___ database_name"},
			{"desc": "Set up a fresh database for the hotel system.",
			 "code": "[BLANK] DATABASE hotel_system;",
			 "answer": "CREATE",
			 "hint": "___ DATABASE name — the first step in building a DB."},
			# — CREATE TABLE —
			{"desc": "Create a new table called rooms.",
			 "code": "CREATE [BLANK] rooms (\n    id INT PRIMARY KEY\n);",
			 "answer": "TABLE",
			 "hint": "CREATE ___ tablename (columns...)"},
			{"desc": "Define a new table to store staff records.",
			 "code": "[BLANK] TABLE staff (\n    id INT PRIMARY KEY\n);",
			 "answer": "CREATE",
			 "hint": "___ TABLE name (...) defines a new table."},
			# — PRIMARY KEY —
			{"desc": "Make the id column the primary key of guests.",
			 "code": "CREATE TABLE guests (\n    id INT [BLANK] KEY\n);",
			 "answer": "PRIMARY",
			 "hint": "___ KEY uniquely identifies each row."},
			{"desc": "Set the id column as the primary key of rooms.",
			 "code": "CREATE TABLE rooms (\n    id INT PRIMARY [BLANK]\n);",
			 "answer": "KEY",
			 "hint": "PRIMARY ___ marks the unique identifier column."},
			# — INT —
			{"desc": "Set the capacity column to store whole numbers.",
			 "code": "CREATE TABLE rooms (\n    capacity [BLANK]\n);",
			 "answer": "INT",
			 "hint": "INT stores whole numbers with no decimal point."},
			{"desc": "Set the floor_number column to store a whole number.",
			 "code": "CREATE TABLE rooms (\n    floor_number [BLANK]\n);",
			 "answer": "INT",
			 "hint": "Use this type for counting numbers like 1, 2, 3."},
			# — TEXT —
			{"desc": "Set the name column to store text.",
			 "code": "CREATE TABLE guests (\n    name [BLANK]\n);",
			 "answer": "TEXT",
			 "hint": "TEXT stores strings and words."},
			{"desc": "Set the room_type column to store text values.",
			 "code": "CREATE TABLE rooms (\n    room_type [BLANK]\n);",
			 "answer": "TEXT",
			 "hint": "Use this type for words like 'Deluxe' or 'Suite'."},
			# — REAL —
			{"desc": "Set the price column to store decimal numbers.",
			 "code": "CREATE TABLE bookings (\n    price [BLANK]\n);",
			 "answer": "REAL",
			 "hint": "REAL stores decimal numbers like 299.99."},
			{"desc": "Set the discount column to store a decimal value.",
			 "code": "CREATE TABLE bookings (\n    discount [BLANK]\n);",
			 "answer": "REAL",
			 "hint": "Use this type for values like 0.15 or 12.50."},
			# — NOT NULL + UNIQUE —
			{"desc": "Make the email column required and unique.",
			 "code": "CREATE TABLE guests (\n    email TEXT NOT NULL [BLANK]\n);",
			 "answer": "UNIQUE",
			 "hint": "UNIQUE ensures no two rows share the same value."},
			{"desc": "Prevent the name column from storing empty values.",
			 "code": "CREATE TABLE guests (\n    name TEXT [BLANK] NULL\n);",
			 "answer": "NOT",
			 "hint": "___ NULL forces every row to have a value in this column."},
			# — DEFAULT —
			{"desc": "Auto-fill the status column with Available.",
			 "code": "CREATE TABLE rooms (\n    status TEXT [BLANK] 'Available'\n);",
			 "answer": "DEFAULT",
			 "hint": "DEFAULT sets a fallback value when none is given."},
			{"desc": "Set the loyalty_points column to start at 0.",
			 "code": "CREATE TABLE guests (\n    loyalty_points INT [BLANK] 0\n);",
			 "answer": "DEFAULT",
			 "hint": "___ value is used when no value is provided on INSERT."},
			# — FOREIGN KEY —
			{"desc": "Link guest_id in bookings to the guests table.",
			 "code": "FOREIGN KEY (guest_id)\n[BLANK] guests(id);",
			 "answer": "REFERENCES",
			 "hint": "FOREIGN KEY (col) ___ other_table(col)"},
			{"desc": "Declare the relationship between bookings and guests.",
			 "code": "[BLANK] KEY (guest_id)\nREFERENCES guests(id);",
			 "answer": "FOREIGN",
			 "hint": "___ KEY links a column to a primary key in another table."},
			# — CHECK —
			{"desc": "Only allow staff ages of 18 or older.",
			 "code": "age INT [BLANK] (age >= 18)",
			 "answer": "CHECK",
			 "hint": "CHECK (condition) rejects rows that fail the condition."},
			{"desc": "Reject any negative room price with a constraint.",
			 "code": "price REAL [BLANK] (price >= 0)",
			 "answer": "CHECK",
			 "hint": "CHECK (condition) validates each value before it is stored."},
		],
	],
	"cafe": [
		# Folder 0 — Basic SQL (5 lessons × 2 = 10 questions)
		[
			{"desc": "Retrieve every column from the orders table.",
			 "code": "SELECT [BLANK] FROM orders;",
			 "answer": "*", "hint": "Use the character that means all columns."},
			{"desc": "Show the item and price columns from orders.",
			 "code": "[BLANK] item, price FROM orders;",
			 "answer": "SELECT", "hint": "The keyword that starts a read query."},
			{"desc": "Log a new Latte order to the orders table.",
			 "code": "INSERT [BLANK] orders (item, price)\nVALUES ('Latte', 120);",
			 "answer": "INTO", "hint": "INSERT ___ tablename (columns) VALUES (...)"},
			{"desc": "Add a new menu item called Matcha.",
			 "code": "[BLANK] INTO menu (name, price)\nVALUES ('Matcha', 90);",
			 "answer": "INSERT", "hint": "The keyword that adds a new row to a table."},
			{"desc": "Find the order where item is Espresso.",
			 "code": "SELECT * FROM orders\nWHERE item [BLANK] 'Espresso';",
			 "answer": "=", "hint": "Use = to match an exact value."},
			{"desc": "Find all Pending orders in the orders table.",
			 "code": "SELECT * FROM orders\n[BLANK] status = 'Pending';",
			 "answer": "WHERE", "hint": "WHERE filters rows by a condition."},
			{"desc": "Fix the price of order id 4 to 150.",
			 "code": "UPDATE orders [BLANK] price = 150\nWHERE id = 4;",
			 "answer": "SET", "hint": "UPDATE table ___ column = value WHERE ..."},
			{"desc": "Change the status of order id 2 to Completed.",
			 "code": "UPDATE orders SET status = 'Completed'\n[BLANK] id = 2;",
			 "answer": "WHERE", "hint": "WHERE identifies which row to update."},
			{"desc": "Cancel the order where id equals 3.",
			 "code": "[BLANK] FROM orders WHERE id = 3;",
			 "answer": "DELETE", "hint": "The keyword that removes rows from a table."},
			{"desc": "Remove all orders where status is Cancelled.",
			 "code": "DELETE [BLANK] orders WHERE status = 'Cancelled';",
			 "answer": "FROM", "hint": "DELETE ___ tablename WHERE condition"},
		],
		# Folder 1 — Filtering & Sorting (11 lessons × 2 = 22 questions)
		[
			{"desc": "Sort the menu by price from low to high.",
			 "code": "SELECT * FROM menu ORDER [BLANK] price;",
			 "answer": "BY", "hint": "ORDER ___ column_name"},
			{"desc": "Sort orders by order time newest first.",
			 "code": "SELECT * FROM orders\n[BLANK] BY order_time DESC;",
			 "answer": "ORDER", "hint": "___ BY column DESC sorts descending."},
			{"desc": "Find orders that have no special notes.",
			 "code": "SELECT * FROM orders WHERE notes IS [BLANK];",
			 "answer": "NULL", "hint": "IS ___ finds rows with no value stored."},
			{"desc": "Find menu items where allergen info is missing.",
			 "code": "SELECT * FROM menu WHERE allergens [BLANK] NULL;",
			 "answer": "IS", "hint": "___ NULL detects missing values."},
			{"desc": "Get the unique drink categories from the menu.",
			 "code": "SELECT [BLANK] category FROM menu;",
			 "answer": "DISTINCT", "hint": "Removes duplicate values from results."},
			{"desc": "List all unique customer cities from orders.",
			 "code": "SELECT [BLANK] city FROM customers;",
			 "answer": "DISTINCT", "hint": "Place this keyword right after SELECT."},
			{"desc": "Find Hot orders that are also Paid.",
			 "code": "SELECT * FROM orders\nWHERE type = 'Hot' [BLANK] status = 'Paid';",
			 "answer": "AND", "hint": "AND requires both conditions to be true."},
			{"desc": "Find orders that are either Pending or Preparing.",
			 "code": "SELECT * FROM orders\nWHERE status = 'Pending' [BLANK] status = 'Preparing';",
			 "answer": "OR", "hint": "OR returns rows where at least one condition is true."},
			{"desc": "Find menu items priced between 50 and 200.",
			 "code": "SELECT * FROM menu\nWHERE price [BLANK] 50 AND 200;",
			 "answer": "BETWEEN", "hint": "BETWEEN low AND high"},
			{"desc": "Find orders placed between two dates.",
			 "code": "SELECT * FROM orders\nWHERE order_time BETWEEN '2024-01-01' [BLANK] '2024-12-31';",
			 "answer": "AND", "hint": "BETWEEN start ___ end — connects the range."},
			{"desc": "Find menu items whose name contains Coffee.",
			 "code": "SELECT * FROM menu WHERE name [BLANK] '%Coffee%';",
			 "answer": "LIKE", "hint": "LIKE '%word%' matches text containing a word."},
			{"desc": "Find customers whose name starts with J.",
			 "code": "SELECT * FROM customers WHERE name [BLANK] 'J%';",
			 "answer": "LIKE", "hint": "LIKE 'letter%' matches names starting with that letter."},
			{"desc": "Get orders from the Drinks or Pastry category.",
			 "code": "SELECT * FROM orders\nWHERE category [BLANK] ('Drinks', 'Pastry');",
			 "answer": "IN", "hint": "IN (v1, v2, ...) matches any listed value."},
			{"desc": "Find menu items in Small, Medium, or Large size.",
			 "code": "SELECT * FROM menu\nWHERE size [BLANK] ('Small', 'Medium', 'Large');",
			 "answer": "IN", "hint": "IN (v1, v2, ...) matches any listed value."},
			{"desc": "Show only the 5 most recent orders.",
			 "code": "SELECT * FROM orders\nORDER BY order_time DESC [BLANK] 5;",
			 "answer": "LIMIT", "hint": "LIMIT N restricts how many rows are returned."},
			{"desc": "Retrieve only the first 10 menu items.",
			 "code": "SELECT * FROM menu [BLANK] 10;",
			 "answer": "LIMIT", "hint": "LIMIT N restricts how many rows are returned."},
			# — DATE FUNCTIONS —
			{"desc": "Find all orders placed before today.",
			 "code": "SELECT * FROM orders\nWHERE order_date < [BLANK]('now');",
			 "answer": "DATE", "hint": "DATE('now') returns today's date in SQLite."},
			{"desc": "Get all orders placed exactly today.",
			 "code": "SELECT * FROM orders\nWHERE order_date = DATE([BLANK]);",
			 "answer": "'now'", "hint": "DATE('now') returns today's date."},
			# — STRING FUNCTIONS —
			{"desc": "Show every menu item in capital letters.",
			 "code": "SELECT [BLANK](item) FROM orders;",
			 "answer": "UPPER", "hint": "UPPER() converts text to capitals; LOWER() to lowercase."},
			{"desc": "Count how many characters are in each item name.",
			 "code": "SELECT [BLANK](item) FROM orders;",
			 "answer": "LENGTH", "hint": "LENGTH() returns the number of characters in a string."},
			# — COALESCE / IFNULL —
			{"desc": "Show the note, or 'No notes' when it is missing.",
			 "code": "SELECT item,\n  [BLANK](notes, 'No notes') FROM orders;",
			 "answer": "COALESCE", "hint": "COALESCE returns the first non-NULL value."},
			{"desc": "Replace a missing coupon code with 'None'.",
			 "code": "SELECT item,\n  [BLANK](coupon, 'None') FROM orders;",
			 "answer": "COALESCE", "hint": "COALESCE(value, fallback) returns the first non-NULL value."},
		],
		# Folder 2 — Aggregates & Joins (8 lessons × 2 = 16 questions)
		[
			{"desc": "Count orders per category.",
			 "code": "SELECT category, COUNT(*) FROM orders\nGROUP [BLANK] category;",
			 "answer": "BY", "hint": "GROUP ___ column"},
			{"desc": "Get total sales amount per item.",
			 "code": "SELECT item, SUM(price) FROM orders\n[BLANK] BY item;",
			 "answer": "GROUP", "hint": "___ BY column aggregates rows into groups."},
			{"desc": "Combine customers with their orders.",
			 "code": "SELECT * FROM customers\nINNER [BLANK] orders ON customers.id = orders.customer_id;",
			 "answer": "JOIN", "hint": "INNER ___ links matching rows from two tables."},
			{"desc": "Join the menu table with orders on item name.",
			 "code": "SELECT * FROM menu\n[BLANK] JOIN orders ON menu.name = orders.item;",
			 "answer": "INNER", "hint": "___ JOIN only returns matching rows from both tables."},
			{"desc": "Calculate total revenue from all orders.",
			 "code": "SELECT [BLANK](price) FROM orders;",
			 "answer": "SUM", "hint": "SUM() adds up all values in a column."},
			{"desc": "Find the average order price.",
			 "code": "SELECT [BLANK](price) FROM orders;",
			 "answer": "AVG", "hint": "AVG() computes the average of a column."},
			{"desc": "Show items ordered more than 5 times.",
			 "code": "SELECT item, COUNT(*) FROM orders\nGROUP BY item [BLANK] COUNT(*) > 5;",
			 "answer": "HAVING", "hint": "HAVING filters grouped results."},
			{"desc": "Show categories with total sales above 1000.",
			 "code": "SELECT category, SUM(price) FROM orders\nGROUP BY category [BLANK] SUM(price) > 1000;",
			 "answer": "HAVING", "hint": "HAVING filters after GROUP BY."},
			{"desc": "Label the SUM column as total_sales.",
			 "code": "SELECT SUM(price) [BLANK] total_sales FROM orders;",
			 "answer": "AS", "hint": "AS gives a column a readable alias."},
			{"desc": "Rename the COUNT result to order_count.",
			 "code": "SELECT COUNT(*) [BLANK] order_count FROM orders;",
			 "answer": "AS", "hint": "AS renames a column in the result."},
			{"desc": "Show all customers including those with no orders.",
			 "code": "SELECT * FROM customers\n[BLANK] JOIN orders ON customers.id = orders.customer_id;",
			 "answer": "LEFT", "hint": "LEFT JOIN keeps all rows from the left table."},
			{"desc": "List all menu items including those never ordered.",
			 "code": "SELECT * FROM menu\nLEFT [BLANK] orders ON menu.name = orders.item;",
			 "answer": "JOIN", "hint": "LEFT ___ keeps all left-side rows even with no match."},
			# — SUBQUERY —
			{"desc": "Find the order with the highest price using a subquery.",
			 "code": "SELECT * FROM orders\nWHERE price = (SELECT [BLANK](price) FROM orders);",
			 "answer": "MAX", "hint": "MAX() returns the highest value in the column."},
			{"desc": "Complete the subquery to find the priciest order.",
			 "code": "SELECT * FROM orders\nWHERE price = ([BLANK] MAX(price) FROM orders);",
			 "answer": "SELECT", "hint": "A subquery is a SELECT inside parentheses."},
			# — UNION —
			{"desc": "Combine customer cities and supplier cities into one list.",
			 "code": "SELECT city FROM customers\n[BLANK]\nSELECT city FROM suppliers;",
			 "answer": "UNION", "hint": "UNION merges two SELECT results and removes duplicates."},
			{"desc": "Combine both city lists but keep duplicate rows.",
			 "code": "SELECT city FROM customers\nUNION [BLANK]\nSELECT city FROM suppliers;",
			 "answer": "ALL", "hint": "UNION ALL keeps duplicates; the keyword after UNION is ALL."},
		],
		# Folder 3 — Database Design (10 lessons × 2 = 20 questions)
		[
			{"desc": "Create a new database called cafe_db.",
			 "code": "CREATE [BLANK] cafe_db;",
			 "answer": "DATABASE", "hint": "CREATE ___ database_name"},
			{"desc": "Set up a fresh database for the cafe system.",
			 "code": "[BLANK] DATABASE cafe_system;",
			 "answer": "CREATE", "hint": "___ DATABASE name — starts the database creation."},
			{"desc": "Create a new table called orders.",
			 "code": "CREATE [BLANK] orders (\n    id INT PRIMARY KEY\n);",
			 "answer": "TABLE", "hint": "CREATE ___ tablename (columns...)"},
			{"desc": "Define a new table to store menu items.",
			 "code": "[BLANK] TABLE menu (\n    id INT PRIMARY KEY\n);",
			 "answer": "CREATE", "hint": "___ TABLE name (...) defines a new table."},
			{"desc": "Make the id column the primary key of orders.",
			 "code": "CREATE TABLE orders (\n    id INT [BLANK] KEY\n);",
			 "answer": "PRIMARY", "hint": "___ KEY uniquely identifies each row."},
			{"desc": "Set the id column as the primary key of menu.",
			 "code": "CREATE TABLE menu (\n    id INT PRIMARY [BLANK]\n);",
			 "answer": "KEY", "hint": "PRIMARY ___ marks the unique identifier column."},
			{"desc": "Set the quantity column to store whole numbers.",
			 "code": "CREATE TABLE orders (\n    quantity [BLANK]\n);",
			 "answer": "INT", "hint": "INT stores whole numbers."},
			{"desc": "Set the table_number column to store a whole number.",
			 "code": "CREATE TABLE orders (\n    table_number [BLANK]\n);",
			 "answer": "INT", "hint": "Use this type for counting numbers."},
			{"desc": "Set the item column to store text.",
			 "code": "CREATE TABLE orders (\n    item [BLANK]\n);",
			 "answer": "TEXT", "hint": "TEXT stores strings and words."},
			{"desc": "Set the category column to store text values.",
			 "code": "CREATE TABLE menu (\n    category [BLANK]\n);",
			 "answer": "TEXT", "hint": "Use this type for words like 'Drinks' or 'Pastry'."},
			{"desc": "Set the price column to store decimal numbers.",
			 "code": "CREATE TABLE orders (\n    price [BLANK]\n);",
			 "answer": "REAL", "hint": "REAL stores decimal numbers like 99.50."},
			{"desc": "Set the discount column to store a decimal value.",
			 "code": "CREATE TABLE menu (\n    discount [BLANK]\n);",
			 "answer": "REAL", "hint": "Use this type for values like 0.10 or 15.50."},
			{"desc": "Make the receipt_no column required and unique.",
			 "code": "CREATE TABLE orders (\n    receipt_no TEXT NOT NULL [BLANK]\n);",
			 "answer": "UNIQUE", "hint": "UNIQUE ensures no two rows share the same value."},
			{"desc": "Prevent the item column from storing empty values.",
			 "code": "CREATE TABLE orders (\n    item TEXT [BLANK] NULL\n);",
			 "answer": "NOT", "hint": "___ NULL forces every row to have a value."},
			{"desc": "Auto-fill the status column with Pending.",
			 "code": "CREATE TABLE orders (\n    status TEXT [BLANK] 'Pending'\n);",
			 "answer": "DEFAULT", "hint": "DEFAULT sets a fallback value when none is given."},
			{"desc": "Set the points column to start at 0 for new customers.",
			 "code": "CREATE TABLE customers (\n    points INT [BLANK] 0\n);",
			 "answer": "DEFAULT", "hint": "___ value is used when no value is given on INSERT."},
			{"desc": "Link customer_id in orders to the customers table.",
			 "code": "FOREIGN KEY (customer_id)\n[BLANK] customers(id);",
			 "answer": "REFERENCES", "hint": "FOREIGN KEY (col) ___ other_table(col)"},
			{"desc": "Declare the link between orders and customers.",
			 "code": "[BLANK] KEY (customer_id)\nREFERENCES customers(id);",
			 "answer": "FOREIGN", "hint": "___ KEY links a column to another table's primary key."},
			# — CHECK —
			{"desc": "Only allow menu prices of 0 or more.",
			 "code": "price REAL [BLANK] (price >= 0)",
			 "answer": "CHECK", "hint": "CHECK (condition) rejects rows that fail the condition."},
			{"desc": "Reject any order quantity below 1 with a constraint.",
			 "code": "qty INT [BLANK] (qty >= 1)",
			 "answer": "CHECK", "hint": "CHECK (condition) validates each value before it is stored."},
		],
	],
	"police": [
		# Folder 0 — Basic SQL (5 lessons × 2 = 10 questions)
		[
			{"desc": "Retrieve every column from the cases table.",
			 "code": "SELECT [BLANK] FROM cases;",
			 "answer": "*", "hint": "Use the character that means all columns."},
			{"desc": "Show the title and status columns from cases.",
			 "code": "[BLANK] title, status FROM cases;",
			 "answer": "SELECT", "hint": "The keyword that starts a read query."},
			{"desc": "Log a new case titled Theft with status Open.",
			 "code": "INSERT [BLANK] cases (title, status)\nVALUES ('Theft', 'Open');",
			 "answer": "INTO", "hint": "INSERT ___ tablename (columns) VALUES (...)"},
			{"desc": "Add a new officer record to the officers table.",
			 "code": "[BLANK] INTO officers (name, badge_no)\nVALUES ('Santos', 'B-021');",
			 "answer": "INSERT", "hint": "The keyword that adds a new row to a table."},
			{"desc": "Find the case where status is Closed.",
			 "code": "SELECT * FROM cases\nWHERE status [BLANK] 'Closed';",
			 "answer": "=", "hint": "Use = to match an exact value."},
			{"desc": "Find all Open cases from the cases table.",
			 "code": "SELECT * FROM cases\n[BLANK] status = 'Open';",
			 "answer": "WHERE", "hint": "WHERE filters rows by a condition."},
			{"desc": "Update the status of case id 2 to Resolved.",
			 "code": "UPDATE cases [BLANK] status = 'Resolved'\nWHERE id = 2;",
			 "answer": "SET", "hint": "UPDATE table ___ column = value WHERE ..."},
			{"desc": "Reassign case id 5 to officer id 3.",
			 "code": "UPDATE cases SET officer_id = 3\n[BLANK] id = 5;",
			 "answer": "WHERE", "hint": "WHERE identifies which row to update."},
			{"desc": "Remove the case record where id equals 7.",
			 "code": "[BLANK] FROM cases WHERE id = 7;",
			 "answer": "DELETE", "hint": "The keyword that removes rows from a table."},
			{"desc": "Delete all cases where status is Dismissed.",
			 "code": "DELETE [BLANK] cases WHERE status = 'Dismissed';",
			 "answer": "FROM", "hint": "DELETE ___ tablename WHERE condition"},
		],
		# Folder 1 — Filtering & Sorting (11 lessons × 2 = 22 questions)
		[
			{"desc": "Sort cases by priority from highest to lowest.",
			 "code": "SELECT * FROM cases ORDER [BLANK] priority DESC;",
			 "answer": "BY", "hint": "ORDER ___ column_name DESC"},
			{"desc": "Sort officers alphabetically by last name.",
			 "code": "SELECT * FROM officers\n[BLANK] BY last_name;",
			 "answer": "ORDER", "hint": "___ BY column_name"},
			{"desc": "Find cases that have no assigned suspect.",
			 "code": "SELECT * FROM cases WHERE suspect IS [BLANK];",
			 "answer": "NULL", "hint": "IS ___ checks for a missing value."},
			{"desc": "Find cases where the location has not been recorded.",
			 "code": "SELECT * FROM cases WHERE location [BLANK] NULL;",
			 "answer": "IS", "hint": "___ NULL detects missing values."},
			{"desc": "Get the unique crime types from the cases table.",
			 "code": "SELECT [BLANK] crime_type FROM cases;",
			 "answer": "DISTINCT", "hint": "Removes duplicate rows from results."},
			{"desc": "List all unique districts where cases were filed.",
			 "code": "SELECT [BLANK] district FROM cases;",
			 "answer": "DISTINCT", "hint": "Place this keyword right after SELECT."},
			{"desc": "Find cases that are Open and High priority.",
			 "code": "SELECT * FROM cases\nWHERE status = 'Open' [BLANK] priority = 'High';",
			 "answer": "AND", "hint": "AND requires both conditions to be true."},
			{"desc": "Find cases that are either Robbery or Fraud.",
			 "code": "SELECT * FROM cases\nWHERE crime_type = 'Robbery' [BLANK] crime_type = 'Fraud';",
			 "answer": "OR", "hint": "OR returns rows where at least one condition is true."},
			{"desc": "Find cases where the fine is between 500 and 5000.",
			 "code": "SELECT * FROM cases\nWHERE fine [BLANK] 500 AND 5000;",
			 "answer": "BETWEEN", "hint": "BETWEEN low AND high"},
			{"desc": "Find cases filed between two specific dates.",
			 "code": "SELECT * FROM cases\nWHERE filed_date BETWEEN '2024-01-01' [BLANK] '2024-12-31';",
			 "answer": "AND", "hint": "BETWEEN start ___ end — connects the range."},
			{"desc": "Find suspects whose name starts with R.",
			 "code": "SELECT * FROM cases WHERE suspect [BLANK] 'R%';",
			 "answer": "LIKE", "hint": "LIKE 'letter%' matches names starting with that letter."},
			{"desc": "Find cases whose description contains the word Armed.",
			 "code": "SELECT * FROM cases WHERE description [BLANK] '%Armed%';",
			 "answer": "LIKE", "hint": "LIKE '%word%' matches text containing a word."},
			{"desc": "Get cases of type Robbery, Theft, or Fraud.",
			 "code": "SELECT * FROM cases\nWHERE crime_type [BLANK] ('Robbery', 'Theft', 'Fraud');",
			 "answer": "IN", "hint": "IN (v1, v2, ...) matches any listed value."},
			{"desc": "Find officers in Precinct 1, 2, or 3.",
			 "code": "SELECT * FROM officers\nWHERE precinct [BLANK] (1, 2, 3);",
			 "answer": "IN", "hint": "IN (v1, v2, ...) matches any listed value."},
			{"desc": "Show only the 5 most recently filed cases.",
			 "code": "SELECT * FROM cases\nORDER BY filed_date DESC [BLANK] 5;",
			 "answer": "LIMIT", "hint": "LIMIT N restricts how many rows are returned."},
			{"desc": "Retrieve only the first 10 officer records.",
			 "code": "SELECT * FROM officers [BLANK] 10;",
			 "answer": "LIMIT", "hint": "LIMIT N restricts how many rows are returned."},
			# — DATE FUNCTIONS —
			{"desc": "Find all cases where the filed_date has already passed.",
			 "code": "SELECT * FROM cases\nWHERE filed_date < [BLANK]('now');",
			 "answer": "DATE", "hint": "DATE('now') returns today's date in SQLite."},
			{"desc": "Get all cases filed exactly today.",
			 "code": "SELECT * FROM cases\nWHERE filed_date = DATE([BLANK]);",
			 "answer": "'now'", "hint": "DATE('now') returns today's date."},
			# — STRING FUNCTIONS —
			{"desc": "Show every case type in capital letters.",
			 "code": "SELECT [BLANK](case_type) FROM cases;",
			 "answer": "UPPER", "hint": "UPPER() converts text to capitals; LOWER() to lowercase."},
			{"desc": "Count how many characters are in each case type.",
			 "code": "SELECT [BLANK](case_type) FROM cases;",
			 "answer": "LENGTH", "hint": "LENGTH() returns the number of characters in a string."},
			# — COALESCE / IFNULL —
			{"desc": "Show the remark, or 'No remarks' when it is missing.",
			 "code": "SELECT case_type,\n  [BLANK](remarks, 'No remarks') FROM cases;",
			 "answer": "COALESCE", "hint": "COALESCE returns the first non-NULL value."},
			{"desc": "Replace a missing location with 'Unknown'.",
			 "code": "SELECT case_type,\n  [BLANK](location, 'Unknown') FROM cases;",
			 "answer": "COALESCE", "hint": "COALESCE(value, fallback) returns the first non-NULL value."},
		],
		# Folder 2 — Aggregates & Joins (8 lessons × 2 = 16 questions)
		[
			{"desc": "Count how many cases belong to each crime type.",
			 "code": "SELECT crime_type, COUNT(*) FROM cases\nGROUP [BLANK] crime_type;",
			 "answer": "BY", "hint": "GROUP ___ column"},
			{"desc": "Get the total fines collected per district.",
			 "code": "SELECT district, SUM(fine) FROM cases\n[BLANK] BY district;",
			 "answer": "GROUP", "hint": "___ BY column aggregates rows into groups."},
			{"desc": "Combine officers with the cases they handle.",
			 "code": "SELECT * FROM officers\nINNER [BLANK] cases ON officers.id = cases.officer_id;",
			 "answer": "JOIN", "hint": "INNER ___ links matching rows from two tables."},
			{"desc": "Join the suspects table with the cases table.",
			 "code": "SELECT * FROM suspects\n[BLANK] JOIN cases ON suspects.id = cases.suspect_id;",
			 "answer": "INNER", "hint": "___ JOIN only returns rows that match in both tables."},
			{"desc": "Calculate the total fines collected from all cases.",
			 "code": "SELECT [BLANK](fine) FROM cases;",
			 "answer": "SUM", "hint": "SUM() adds up all values in a column."},
			{"desc": "Count the total number of filed cases.",
			 "code": "SELECT [BLANK](id) FROM cases;",
			 "answer": "COUNT", "hint": "COUNT() counts the number of rows."},
			{"desc": "Show crime types with more than 3 reported incidents.",
			 "code": "SELECT crime_type, COUNT(*) FROM cases\nGROUP BY crime_type [BLANK] COUNT(*) > 3;",
			 "answer": "HAVING", "hint": "HAVING filters grouped results."},
			{"desc": "Show districts where total fines exceed 10000.",
			 "code": "SELECT district, SUM(fine) FROM cases\nGROUP BY district [BLANK] SUM(fine) > 10000;",
			 "answer": "HAVING", "hint": "HAVING filters after GROUP BY."},
			{"desc": "Rename the COUNT result column to total_cases.",
			 "code": "SELECT COUNT(*) [BLANK] total_cases FROM cases;",
			 "answer": "AS", "hint": "AS gives a column a readable alias."},
			{"desc": "Label the SUM result as total_fines.",
			 "code": "SELECT SUM(fine) [BLANK] total_fines FROM cases;",
			 "answer": "AS", "hint": "AS renames a column in the result."},
			{"desc": "Show all officers including those with no cases.",
			 "code": "SELECT * FROM officers\n[BLANK] JOIN cases ON officers.id = cases.officer_id;",
			 "answer": "LEFT", "hint": "LEFT JOIN keeps all rows from the left table."},
			{"desc": "List all suspects and their cases if any exist.",
			 "code": "SELECT * FROM suspects\nLEFT [BLANK] cases ON suspects.id = cases.suspect_id;",
			 "answer": "JOIN", "hint": "LEFT ___ keeps all left-side rows even with no match."},
			# — SUBQUERY —
			{"desc": "Find the case with the highest fine using a subquery.",
			 "code": "SELECT * FROM cases\nWHERE fine = (SELECT [BLANK](fine) FROM cases);",
			 "answer": "MAX", "hint": "MAX() returns the highest value in the column."},
			{"desc": "Complete the subquery to find the costliest case.",
			 "code": "SELECT * FROM cases\nWHERE fine = ([BLANK] MAX(fine) FROM cases);",
			 "answer": "SELECT", "hint": "A subquery starts with SELECT inside parentheses."},
			# — UNION —
			{"desc": "Combine suspect cities and witness cities into one list.",
			 "code": "SELECT city FROM suspects\n[BLANK]\nSELECT city FROM witnesses;",
			 "answer": "UNION", "hint": "UNION merges two SELECT results and removes duplicates."},
			{"desc": "Combine both city lists but keep duplicate rows.",
			 "code": "SELECT city FROM suspects\nUNION [BLANK]\nSELECT city FROM witnesses;",
			 "answer": "ALL", "hint": "UNION ALL keeps duplicates; the keyword after UNION is ALL."},
		],
		# Folder 3 — Database Design (10 lessons × 2 = 20 questions)
		[
			{"desc": "Create a new database called police_db.",
			 "code": "CREATE [BLANK] police_db;",
			 "answer": "DATABASE", "hint": "CREATE ___ database_name"},
			{"desc": "Set up a fresh database for the station system.",
			 "code": "[BLANK] DATABASE station_db;",
			 "answer": "CREATE", "hint": "___ DATABASE name — starts the creation."},
			{"desc": "Create a new table called suspects.",
			 "code": "CREATE [BLANK] suspects (\n    id INT PRIMARY KEY\n);",
			 "answer": "TABLE", "hint": "CREATE ___ tablename (columns...)"},
			{"desc": "Define a new table to store evidence records.",
			 "code": "[BLANK] TABLE evidence (\n    id INT PRIMARY KEY\n);",
			 "answer": "CREATE", "hint": "___ TABLE name (...) defines a new table."},
			{"desc": "Make the id column the primary key of cases.",
			 "code": "CREATE TABLE cases (\n    id INT [BLANK] KEY\n);",
			 "answer": "PRIMARY", "hint": "___ KEY uniquely identifies each row."},
			{"desc": "Set the id column as the primary key of officers.",
			 "code": "CREATE TABLE officers (\n    id INT PRIMARY [BLANK]\n);",
			 "answer": "KEY", "hint": "PRIMARY ___ marks the unique identifier column."},
			{"desc": "Set the case_number column to store whole numbers.",
			 "code": "CREATE TABLE cases (\n    case_number [BLANK]\n);",
			 "answer": "INT", "hint": "INT stores whole numbers."},
			{"desc": "Set the precinct column to store a whole number.",
			 "code": "CREATE TABLE officers (\n    precinct [BLANK]\n);",
			 "answer": "INT", "hint": "Use this type for counting numbers."},
			{"desc": "Set the title column to store text.",
			 "code": "CREATE TABLE cases (\n    title [BLANK]\n);",
			 "answer": "TEXT", "hint": "TEXT stores strings and words."},
			{"desc": "Set the crime_type column to store text values.",
			 "code": "CREATE TABLE cases (\n    crime_type [BLANK]\n);",
			 "answer": "TEXT", "hint": "Use this type for words like 'Robbery' or 'Theft'."},
			{"desc": "Set the fine column to store decimal numbers.",
			 "code": "CREATE TABLE cases (\n    fine [BLANK]\n);",
			 "answer": "REAL", "hint": "REAL stores decimal numbers like 2500.75."},
			{"desc": "Set the bail_amount column to store a decimal.",
			 "code": "CREATE TABLE suspects (\n    bail_amount [BLANK]\n);",
			 "answer": "REAL", "hint": "Use this type for monetary decimal values."},
			{"desc": "Make the badge_no column required and unique.",
			 "code": "CREATE TABLE officers (\n    badge_no TEXT NOT NULL [BLANK]\n);",
			 "answer": "UNIQUE", "hint": "UNIQUE ensures no two rows share the same value."},
			{"desc": "Prevent the title column from storing empty values.",
			 "code": "CREATE TABLE cases (\n    title TEXT [BLANK] NULL\n);",
			 "answer": "NOT", "hint": "___ NULL forces every row to have a value."},
			{"desc": "Auto-fill the status column with Open.",
			 "code": "CREATE TABLE cases (\n    status TEXT [BLANK] 'Open'\n);",
			 "answer": "DEFAULT", "hint": "DEFAULT sets a fallback value when none is given."},
			{"desc": "Set the is_solved column to default to 0 (false).",
			 "code": "CREATE TABLE cases (\n    is_solved INT [BLANK] 0\n);",
			 "answer": "DEFAULT", "hint": "___ value is used when no value is given on INSERT."},
			{"desc": "Link officer_id in cases to the officers table.",
			 "code": "FOREIGN KEY (officer_id)\n[BLANK] officers(id);",
			 "answer": "REFERENCES", "hint": "FOREIGN KEY (col) ___ other_table(col)"},
			{"desc": "Declare the link between cases and officers.",
			 "code": "[BLANK] KEY (officer_id)\nREFERENCES officers(id);",
			 "answer": "FOREIGN", "hint": "___ KEY links a column to another table's primary key."},
			# — CHECK —
			{"desc": "Only allow fines of 0 or more.",
			 "code": "fine REAL [BLANK] (fine >= 0)",
			 "answer": "CHECK", "hint": "CHECK (condition) rejects rows that fail the condition."},
			{"desc": "Reject any suspect age below 0 with a constraint.",
			 "code": "age INT [BLANK] (age >= 0)",
			 "answer": "CHECK", "hint": "CHECK (condition) validates each value before it is stored."},
		],
	],
	"library": [
		# Folder 0 — Basic SQL (5 lessons × 2 = 10 questions)
		[
			{"desc": "Retrieve every column from the books table.",
			 "code": "SELECT [BLANK] FROM books;",
			 "answer": "*", "hint": "Use the character that means all columns."},
			{"desc": "Show the title and genre columns from books.",
			 "code": "[BLANK] title, genre FROM books;",
			 "answer": "SELECT", "hint": "The keyword that starts a read query."},
			{"desc": "Register a new borrower named Sara.",
			 "code": "INSERT [BLANK] borrowers (name, contact)\nVALUES ('Sara', '09171234567');",
			 "answer": "INTO", "hint": "INSERT ___ tablename (columns) VALUES (...)"},
			{"desc": "Add a new book record to the books table.",
			 "code": "[BLANK] INTO books (title, genre)\nVALUES ('Dune', 'Sci-Fi');",
			 "answer": "INSERT", "hint": "The keyword that adds a new row to a table."},
			{"desc": "Find the book where genre is Mystery.",
			 "code": "SELECT * FROM books\nWHERE genre [BLANK] 'Mystery';",
			 "answer": "=", "hint": "Use = to match an exact value."},
			{"desc": "Find all Available books from the books table.",
			 "code": "SELECT * FROM books\n[BLANK] status = 'Available';",
			 "answer": "WHERE", "hint": "WHERE filters rows by a condition."},
			{"desc": "Update the return date of loan id 5.",
			 "code": "UPDATE loans [BLANK] return_date = '2025-06-01'\nWHERE id = 5;",
			 "answer": "SET", "hint": "UPDATE table ___ column = value WHERE ..."},
			{"desc": "Mark book id 3 status as Borrowed.",
			 "code": "UPDATE books SET status = 'Borrowed'\n[BLANK] id = 3;",
			 "answer": "WHERE", "hint": "WHERE identifies which row to update."},
			{"desc": "Remove the overdue loan record where id equals 2.",
			 "code": "[BLANK] FROM loans WHERE id = 2;",
			 "answer": "DELETE", "hint": "The keyword that removes rows from a table."},
			{"desc": "Delete all loans where status is Returned.",
			 "code": "DELETE [BLANK] loans WHERE status = 'Returned';",
			 "answer": "FROM", "hint": "DELETE ___ tablename WHERE condition"},
		],
		# Folder 1 — Filtering & Sorting (11 lessons × 2 = 22 questions)
		[
			{"desc": "Sort books alphabetically by title.",
			 "code": "SELECT * FROM books ORDER [BLANK] title;",
			 "answer": "BY", "hint": "ORDER ___ column_name"},
			{"desc": "Sort loans by due date from earliest to latest.",
			 "code": "SELECT * FROM loans\n[BLANK] BY due_date;",
			 "answer": "ORDER", "hint": "___ BY column_name"},
			{"desc": "Find loans that have no return date recorded.",
			 "code": "SELECT * FROM loans WHERE return_date IS [BLANK];",
			 "answer": "NULL", "hint": "IS ___ checks for a missing value."},
			{"desc": "Find books where the author field is missing.",
			 "code": "SELECT * FROM books WHERE author [BLANK] NULL;",
			 "answer": "IS", "hint": "___ NULL detects missing values."},
			{"desc": "Get the unique genres from the books table.",
			 "code": "SELECT [BLANK] genre FROM books;",
			 "answer": "DISTINCT", "hint": "Removes duplicate rows from results."},
			{"desc": "List all unique borrower cities in the system.",
			 "code": "SELECT [BLANK] city FROM borrowers;",
			 "answer": "DISTINCT", "hint": "Place this keyword right after SELECT."},
			{"desc": "Find books that are Available and in Good condition.",
			 "code": "SELECT * FROM books\nWHERE status = 'Available' [BLANK] condition = 'Good';",
			 "answer": "AND", "hint": "AND requires both conditions to be true."},
			{"desc": "Find books that are either Fantasy or Mystery genre.",
			 "code": "SELECT * FROM books\nWHERE genre = 'Fantasy' [BLANK] genre = 'Mystery';",
			 "answer": "OR", "hint": "OR returns rows where at least one condition is true."},
			{"desc": "Find books published between 2000 and 2020.",
			 "code": "SELECT * FROM books\nWHERE year [BLANK] 2000 AND 2020;",
			 "answer": "BETWEEN", "hint": "BETWEEN low AND high"},
			{"desc": "Find loans due between two specific dates.",
			 "code": "SELECT * FROM loans\nWHERE due_date BETWEEN '2025-01-01' [BLANK] '2025-12-31';",
			 "answer": "AND", "hint": "BETWEEN start ___ end — connects the range."},
			{"desc": "Find books whose title contains the word Dragon.",
			 "code": "SELECT * FROM books WHERE title [BLANK] '%Dragon%';",
			 "answer": "LIKE", "hint": "LIKE '%word%' matches text containing a word."},
			{"desc": "Find borrowers whose name starts with the letter M.",
			 "code": "SELECT * FROM borrowers WHERE name [BLANK] 'M%';",
			 "answer": "LIKE", "hint": "LIKE 'letter%' matches names starting with that letter."},
			{"desc": "Get books in the Mystery, Fantasy, or Sci-Fi genre.",
			 "code": "SELECT * FROM books\nWHERE genre [BLANK] ('Mystery', 'Fantasy', 'Sci-Fi');",
			 "answer": "IN", "hint": "IN (v1, v2, ...) matches any listed value."},
			{"desc": "Find loans with status Overdue, Lost, or Damaged.",
			 "code": "SELECT * FROM loans\nWHERE status [BLANK] ('Overdue', 'Lost', 'Damaged');",
			 "answer": "IN", "hint": "IN (v1, v2, ...) matches any listed value."},
			{"desc": "Show only the 5 most recently added books.",
			 "code": "SELECT * FROM books\nORDER BY added_date DESC [BLANK] 5;",
			 "answer": "LIMIT", "hint": "LIMIT N restricts how many rows are returned."},
			{"desc": "Retrieve only the first 10 borrower records.",
			 "code": "SELECT * FROM borrowers [BLANK] 10;",
			 "answer": "LIMIT", "hint": "LIMIT N restricts how many rows are returned."},
			# — DATE FUNCTIONS —
			{"desc": "Find all loans where the return_date has already passed.",
			 "code": "SELECT * FROM loans\nWHERE return_date < [BLANK]('now');",
			 "answer": "DATE", "hint": "DATE('now') returns today's date in SQLite."},
			{"desc": "Get all loans that were due exactly today.",
			 "code": "SELECT * FROM loans\nWHERE return_date = DATE([BLANK]);",
			 "answer": "'now'", "hint": "DATE('now') returns today's date."},
			# — STRING FUNCTIONS —
			{"desc": "Show every book title in capital letters.",
			 "code": "SELECT [BLANK](title) FROM books;",
			 "answer": "UPPER", "hint": "UPPER() converts text to capitals; LOWER() to lowercase."},
			{"desc": "Count how many characters are in each book title.",
			 "code": "SELECT [BLANK](title) FROM books;",
			 "answer": "LENGTH", "hint": "LENGTH() returns the number of characters in a string."},
			# — COALESCE / IFNULL —
			{"desc": "Show the summary, or 'No summary' when it is missing.",
			 "code": "SELECT title,\n  [BLANK](summary, 'No summary') FROM books;",
			 "answer": "COALESCE", "hint": "COALESCE returns the first non-NULL value."},
			{"desc": "Replace a missing author with 'Unknown'.",
			 "code": "SELECT title,\n  [BLANK](author, 'Unknown') FROM books;",
			 "answer": "COALESCE", "hint": "COALESCE(value, fallback) returns the first non-NULL value."},
		],
		# Folder 2 — Aggregates & Joins (8 lessons × 2 = 16 questions)
		[
			{"desc": "Count how many books belong to each genre.",
			 "code": "SELECT genre, COUNT(*) FROM books\nGROUP [BLANK] genre;",
			 "answer": "BY", "hint": "GROUP ___ column"},
			{"desc": "Get total loans per borrower.",
			 "code": "SELECT borrower_id, COUNT(*) FROM loans\n[BLANK] BY borrower_id;",
			 "answer": "GROUP", "hint": "___ BY column aggregates rows into groups."},
			{"desc": "Combine borrowers with the books they have loaned.",
			 "code": "SELECT * FROM borrowers\nINNER [BLANK] loans ON borrowers.id = loans.borrower_id;",
			 "answer": "JOIN", "hint": "INNER ___ links matching rows from two tables."},
			{"desc": "Join the books table with the loans table on book id.",
			 "code": "SELECT * FROM books\n[BLANK] JOIN loans ON books.id = loans.book_id;",
			 "answer": "INNER", "hint": "___ JOIN only returns rows that match in both tables."},
			{"desc": "Count the total number of active loans.",
			 "code": "SELECT [BLANK](id) FROM loans;",
			 "answer": "COUNT", "hint": "COUNT() counts the number of rows."},
			{"desc": "Calculate the average late fee from all loans.",
			 "code": "SELECT [BLANK](late_fee) FROM loans;",
			 "answer": "AVG", "hint": "AVG() computes the average of a column."},
			{"desc": "Show genres that have more than 10 books.",
			 "code": "SELECT genre, COUNT(*) FROM books\nGROUP BY genre [BLANK] COUNT(*) > 10;",
			 "answer": "HAVING", "hint": "HAVING filters grouped results."},
			{"desc": "Show borrowers with more than 3 active loans.",
			 "code": "SELECT borrower_id, COUNT(*) FROM loans\nGROUP BY borrower_id [BLANK] COUNT(*) > 3;",
			 "answer": "HAVING", "hint": "HAVING filters after GROUP BY."},
			{"desc": "Rename the COUNT result column to total_books.",
			 "code": "SELECT COUNT(*) [BLANK] total_books FROM books;",
			 "answer": "AS", "hint": "AS gives a column a readable alias."},
			{"desc": "Label the AVG result as avg_late_fee.",
			 "code": "SELECT AVG(late_fee) [BLANK] avg_late_fee FROM loans;",
			 "answer": "AS", "hint": "AS renames a column in the result."},
			{"desc": "Show all books including those never borrowed.",
			 "code": "SELECT * FROM books\n[BLANK] JOIN loans ON books.id = loans.book_id;",
			 "answer": "LEFT", "hint": "LEFT JOIN keeps all rows from the left table."},
			{"desc": "List all borrowers and their loans if any exist.",
			 "code": "SELECT * FROM borrowers\nLEFT [BLANK] loans ON borrowers.id = loans.borrower_id;",
			 "answer": "JOIN", "hint": "LEFT ___ keeps all left-side rows even with no match."},
			# — SUBQUERY —
			{"desc": "Find the most borrowed book using a subquery.",
			 "code": "SELECT * FROM books\nWHERE borrow_count = (SELECT [BLANK](borrow_count) FROM books);",
			 "answer": "MAX", "hint": "MAX() returns the highest value in the column."},
			{"desc": "Complete the subquery to find the most popular book.",
			 "code": "SELECT * FROM books\nWHERE borrow_count = ([BLANK] MAX(borrow_count) FROM books);",
			 "answer": "SELECT", "hint": "A subquery starts with SELECT inside parentheses."},
			# — UNION —
			{"desc": "Combine member cities and author cities into one list.",
			 "code": "SELECT city FROM members\n[BLANK]\nSELECT city FROM authors;",
			 "answer": "UNION", "hint": "UNION merges two SELECT results and removes duplicates."},
			{"desc": "Combine both city lists but keep duplicate rows.",
			 "code": "SELECT city FROM members\nUNION [BLANK]\nSELECT city FROM authors;",
			 "answer": "ALL", "hint": "UNION ALL keeps duplicates; the keyword after UNION is ALL."},
		],
		# Folder 3 — Database Design (10 lessons × 2 = 20 questions)
		[
			{"desc": "Create a new database called library_db.",
			 "code": "CREATE [BLANK] library_db;",
			 "answer": "DATABASE", "hint": "CREATE ___ database_name"},
			{"desc": "Set up a fresh database for the library system.",
			 "code": "[BLANK] DATABASE library_system;",
			 "answer": "CREATE", "hint": "___ DATABASE name — starts the creation."},
			{"desc": "Create a new table called books.",
			 "code": "CREATE [BLANK] books (\n    id INT PRIMARY KEY\n);",
			 "answer": "TABLE", "hint": "CREATE ___ tablename (columns...)"},
			{"desc": "Define a new table to store loan records.",
			 "code": "[BLANK] TABLE loans (\n    id INT PRIMARY KEY\n);",
			 "answer": "CREATE", "hint": "___ TABLE name (...) defines a new table."},
			{"desc": "Make the id column the primary key of borrowers.",
			 "code": "CREATE TABLE borrowers (\n    id INT [BLANK] KEY\n);",
			 "answer": "PRIMARY", "hint": "___ KEY uniquely identifies each row."},
			{"desc": "Set the id column as the primary key of loans.",
			 "code": "CREATE TABLE loans (\n    id INT PRIMARY [BLANK]\n);",
			 "answer": "KEY", "hint": "PRIMARY ___ marks the unique identifier column."},
			{"desc": "Set the year column to store whole numbers.",
			 "code": "CREATE TABLE books (\n    year [BLANK]\n);",
			 "answer": "INT", "hint": "INT stores whole numbers."},
			{"desc": "Set the copies column to store a whole number.",
			 "code": "CREATE TABLE books (\n    copies [BLANK]\n);",
			 "answer": "INT", "hint": "Use this type for counting numbers."},
			{"desc": "Set the title column to store text.",
			 "code": "CREATE TABLE books (\n    title [BLANK]\n);",
			 "answer": "TEXT", "hint": "TEXT stores strings and words."},
			{"desc": "Set the genre column to store text values.",
			 "code": "CREATE TABLE books (\n    genre [BLANK]\n);",
			 "answer": "TEXT", "hint": "Use this type for words like 'Mystery' or 'Fantasy'."},
			{"desc": "Set the late_fee column to store decimal numbers.",
			 "code": "CREATE TABLE loans (\n    late_fee [BLANK]\n);",
			 "answer": "REAL", "hint": "REAL stores decimal numbers like 12.50."},
			{"desc": "Set the fine_rate column to store a decimal value.",
			 "code": "CREATE TABLE loans (\n    fine_rate [BLANK]\n);",
			 "answer": "REAL", "hint": "Use this type for values like 0.50 or 5.75."},
			{"desc": "Make the isbn column required and unique.",
			 "code": "CREATE TABLE books (\n    isbn TEXT NOT NULL [BLANK]\n);",
			 "answer": "UNIQUE", "hint": "UNIQUE ensures no two rows share the same value."},
			{"desc": "Prevent the title column from storing empty values.",
			 "code": "CREATE TABLE books (\n    title TEXT [BLANK] NULL\n);",
			 "answer": "NOT", "hint": "___ NULL forces every row to have a value."},
			{"desc": "Auto-fill the status column with Available.",
			 "code": "CREATE TABLE books (\n    status TEXT [BLANK] 'Available'\n);",
			 "answer": "DEFAULT", "hint": "DEFAULT sets a fallback value when none is given."},
			{"desc": "Set the loan_count column to start at 0.",
			 "code": "CREATE TABLE books (\n    loan_count INT [BLANK] 0\n);",
			 "answer": "DEFAULT", "hint": "___ value is used when no value is given on INSERT."},
			{"desc": "Link borrower_id in loans to the borrowers table.",
			 "code": "FOREIGN KEY (borrower_id)\n[BLANK] borrowers(id);",
			 "answer": "REFERENCES", "hint": "FOREIGN KEY (col) ___ other_table(col)"},
			{"desc": "Declare the link between loans and borrowers.",
			 "code": "[BLANK] KEY (borrower_id)\nREFERENCES borrowers(id);",
			 "answer": "FOREIGN", "hint": "___ KEY links a column to another table's primary key."},
			# — CHECK —
			{"desc": "Only allow copy counts of 0 or more.",
			 "code": "copies INT [BLANK] (copies >= 0)",
			 "answer": "CHECK", "hint": "CHECK (condition) rejects rows that fail the condition."},
			{"desc": "Reject any late fee below 0 with a constraint.",
			 "code": "late_fee REAL [BLANK] (late_fee >= 0)",
			 "answer": "CHECK", "hint": "CHECK (condition) validates each value before it is stored."},
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

	# Back to Dashboard button — top right
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
		_result_lbl.text = "✗  Wrong answer — check the hint and try again."
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
