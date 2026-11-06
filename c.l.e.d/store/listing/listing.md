# CLID – Microsoft Store submission text (copy and paste)

## Packages
Upload: `build\msix\CLID.msix` (build it with `store\build_msix.ps1 -Version 1.1.0.0` after exporting the Class Ranking update).

## Properties
- **Category:** Education (subcategory: pick the closest, e.g. Study aids / Reference if offered)
- **Privacy policy URL:** https://ericnathancode.itch.io/clid  (after adding the text from `store/privacy-policy.md` to the itch.io page)
- **Website:** https://ericnathancode.itch.io/clid
- **Support contact info:** the same itch.io link (or your email)
- **Product declarations:** leave the defaults. Do NOT tick anything about accessibility guidelines unless tested.
- **System requirements (optional):** Minimum – Windows 10 version 1809 or newer, 64-bit, 4 GB RAM, keyboard and mouse.

## Age ratings (IARC questionnaire) – answers that match the game
- Category: Educational / reference (if asked "game or app", choose the educational option)
- Violence, blood, fear/horror: **No**
- Sexual content, nudity: **No**
- Crude or offensive language: **No** (checked the lesson dialogue)
- Drugs, alcohol, tobacco: **No**
- Gambling or simulated gambling: **No**
- Users can chat or interact with each other: **Yes, but only the Class Ranking**: the app shares each player's username, lesson stars and Simulation best scores with other CLID players on the same local network (Wi-Fi). There is no chat, no messages and no free text. If the questionnaire asks, also say: usernames are shown to others on the same network; nothing is sent over the internet.
- Shares the user's location: **No**
- In-app or digital purchases: **No**
- Unrestricted internet / web browser: **No**

## Store listing (English)

### Description
CLID is a free, comic-book style game that teaches SQL through story.

Work four jobs (a hotel front desk, a café counter, an airport check-in desk and a library desk) where customers bring real problems, and solve them by writing SQL. Each lesson is a short comic: read the story, then answer the SQL challenge on a live data table. A wrong answer plays a short scene that explains the mistake so you can try again.

What you learn:
• SELECT, INSERT INTO, UPDATE, DELETE and WHERE
• IS NULL, DISTINCT, AND / OR, BETWEEN, LIKE and IN
• ORDER BY, LIMIT, GROUP BY, COUNT / SUM / AVG, HAVING and AS

Features:
• 68 story lessons across 4 worlds, grouped into Basic SQL, Filtering Rows, and Sorting & Aggregates
• Folder Challenges that unlock the next chapter
• Simulation Mode: type full SQL queries from memory on a real SQLite database and beat your best score
• Stars for every lesson, hints, and an SQL Glossary you can open any time
• Class Ranking: see how you rank against classmates on the same Wi-Fi, per world, in lesson stars and Simulation best scores
• Text-to-speech for the dialogue, plus music, sound and dark mode settings
• Works offline. Accounts and progress stay on your computer; no ads, no tracking. The Class Ranking only shares your username and scores with classmates on the same Wi-Fi, and you can turn sharing off

CLID: A Comic-Based Learning Interactive for Database Management System was made by BSIT students of Cavite State University as a capstone project to help students practice SQL.

### Product features (one per line, max 20)
68 story lessons across 4 worlds: hotel, café, airport and library
Learn SELECT, INSERT, UPDATE, DELETE, WHERE, GROUP BY, HAVING and more
SQL challenges on live data tables with instant feedback
Wrong answers play a short scene that explains the mistake
Folder Challenges that unlock the next chapter
Simulation Mode: write full queries on a real SQLite database
Stars for every lesson and a best score in Simulation Mode
Hints and an SQL Glossary you can open any time
Class Ranking with classmates on the same Wi-Fi: lesson stars and Simulation best scores
Text-to-speech for the story dialogue
Works offline; your data stays on your computer

### Short description (if asked)
Learn SQL through comic-style stories: solve real problems at a hotel, café, airport and library.

### Keywords (max 7)
SQL · database · learn SQL · education · comic · programming · students

### Copyright and trademark info
© 2026 Eric Nathan A. Delacruz, Jacent N. De Leus, Jeryl D. Ongpao

### Developed by
EricNathanCode (Eric Nathan A. Delacruz, Jacent N. De Leus, Jeryl D. Ongpao)

### Images
- **Screenshots (required, at least 1; 4 recommended):** maximize the game window (or fullscreen) and press **Win + PrtScn**; files land in Pictures\Screenshots. Use 1366×768 or larger (your laptop's 1920×1080 is ideal). Suggested 4: a lesson dialogue, an SQL challenge, the lesson dashboard, Simulation Mode.
- **Store logo (1:1, if asked):** `store/listing/StoreLogo_300x300.png`

## Submission options
### Restricted capabilities → why you need runFullTrust
CLID is a desktop game built with the Godot Engine and packaged as MSIX with the Desktop Bridge. It needs runFullTrust to run as a full-trust Win32 desktop application. It does not request administrator rights.

### Notes for certification
No internet connection or online account is needed. On first launch, choose "Sign Up" and create a local account (username: 3–20 letters, numbers or underscores; any password), then pick a world and start Lesson 1. Simulation Mode is on the lesson dashboard.
The "Rank" button on the lesson dashboard opens the Class Ranking. It uses UDP broadcast on the local network only (port 47823) to share the username, lesson stars and Simulation best scores with other copies of CLID on the same Wi-Fi; Windows may show a firewall prompt the first time it opens. On a single PC it shows only your own scores. Sharing can be turned off in the same window.
The Windows App Certification Kit passes all required tests. Its optional "Blocked executables" check flags text inside the Godot engine runtime; the app does not launch other programs.

### Publishing hold
Optional: "Don't publish this submission until I select Publish now" if you want to choose the release day.
