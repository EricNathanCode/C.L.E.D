# C.L.E.D.

**C.L.E.D.** (Capstone) is a 2D story-driven learning game built in **Godot 4.6** that teaches SQL through role-play scenarios. Instead of memorizing syntax from a slide deck, players step into everyday jobs — hotel receptionist, café barista, police desk officer, librarian — and write real SQL queries to solve the problems each character brings them.

## Concept

Every lesson opens with a short dialogue scene: an NPC walks up with a request ("I need to check in a new guest," "Can you find every order from last Tuesday?"), and the player has to answer it by typing or building the correct SQL statement in an in-game terminal. Getting it right moves the story forward; getting it wrong costs a star rating and nudges the player toward a hint.

## Worlds

The same 17-lesson SQL curriculum is retold across four settings, so the player practices the same concepts in different narrative contexts:

| World | Setting | Records the player manages |
|---|---|---|
| 🏨 Hotel World | Front desk | Guests, bookings, rooms |
| ☕ Cafe World | Order counter | Customers, orders, menu items |
| 🚓 Police Station | Case desk | Cases, suspects, officers |
| 📚 Library | Front desk | Borrowers, books, genres |

A **Merge Worlds** mode is also available, which threads all four worlds' lessons into a single continuous path.

## Curriculum structure

Each world's 17 lessons are grouped into 3 unlockable chapters ("folders"), focused on core SQL querying (scope trimmed from an earlier, larger curriculum per panel feedback):

1. **Basic SQL** — `SELECT`, `INSERT INTO`, `SELECT WHERE`, `UPDATE SET`, `DELETE`
2. **Filtering Rows** — `IS NULL`, `SELECT DISTINCT`, `AND`/`OR`, `BETWEEN`, `LIKE`, `IN`
3. **Sorting & Aggregates** — `ORDER BY`, `LIMIT`, `GROUP BY`, `COUNT`/`SUM`/`AVG`, `HAVING`, `AS`

Each chapter ends with a **Folder Challenge** — a quiz that must be passed to unlock the next chapter. Lessons within a chapter also unlock sequentially as prior lessons are completed.

## Features

- **Dialogue-driven lessons** — every SQL concept is taught through an in-scene conversation with a world-specific NPC before the player writes any code
- **In-game SQL terminal** — a stylized query console per lesson gamemode, with input validation, execution feedback, and a formatted results table
- **Star scoring** — lessons are rated 1–3 stars based on how many wrong attempts were made, saved per lesson
- **Hint system** — an on-demand hint for players who get stuck
- **Folder Challenges** — gated quizzes that lock the next chapter until passed
- **World Select & Dashboard** — browse worlds, preview a lesson's story as a mini comic strip before starting it, and track completion %
- **Merge Worlds mode** — play all four worlds' lessons as one combined path
- **SQL glossary / recap** — every command learned in a lesson is logged and can be reviewed as a cheat-sheet
- **Accessibility & settings** — text-to-speech narration with per-character voice profiles, toggleable background music, and a dark-mode overlay
- **Persistent save file** — progress and settings are stored locally in `user://cled_save.cfg` via Godot's `ConfigFile`, so play resumes across sessions
- **Reset progress** — a two-tap confirm control lets players wipe save data from Settings

## Tech stack

- **Engine:** Godot 4.6 (GL Compatibility renderer, for broad hardware support)
- **Language:** GDScript
- **Audio:** Original/licensed BGM tracks per world (Hotel Lobby, Cafe, Police Station, Library) plus a menu theme

## Project layout

```
c.l.e.d/
├── project.godot              # Engine config — entry scene, autoloads, viewport
├── scene/                     # Top-level app screens
│   ├── Main.tscn               # Root scene / screen router
│   ├── WorldSelectScreen.tscn  # Choose a world (or Merge Worlds)
│   ├── DashboardScreen.tscn    # Lesson list, chapters, comic-strip previews
│   ├── GameScreen.tscn         # Dialogue + SQL terminal lesson runner
│   ├── FolderQuizScreen.tscn   # End-of-chapter challenge quiz
│   └── CompleteScreen.tscn     # Post-lesson results / star recap
├── scripts/                   # Screen logic (GDScript, one per scene)
│   ├── GameManager.gd          # Autoload — save/load, progress, star scoring, TTS
│   └── data/                   # Per-world lesson content
│       ├── HotelData.gd
│       ├── CafeData.gd
│       ├── PoliceData.gd
│       └── LibraryData.gd
├── gamemode/                   # One reusable mini-scene per SQL concept
│   ├── scene/GM_Select.tscn, GM_Join.tscn, GM_CreateTable.tscn, ...
│   └── scripts/GM_Select.gd, GM_Join.gd, GM_CreateTable.gd, ...
├── images/
│   ├── backgrounds/            # Per-world scene backgrounds
│   └── characters/              # NPC sprite sets (adults, kids, seniors, occupations, plus-size)
└── audio/bgm/                  # Background music per world + menu theme
```

Lesson content (dialogue, NPCs, correct answers) lives in `scripts/data/*.gd` per world; the reusable interaction UI for each SQL concept lives once in `gamemode/`, and is driven by whichever lesson data is loaded.

## Getting started

1. Install [Godot 4.6](https://godotengine.org/download) (GL Compatibility works on most GPUs, including low-end/integrated ones).
2. Open Godot, choose **Import**, and select `c.l.e.d/project.godot`.
3. Press **F5** (or the Play button) to run — the game boots into `scene/Main.tscn`.

No external dependencies or package installs are required; everything ships inside the Godot project.

## Status

This is an active capstone project. Lesson counts, world names, and progression rules above reflect the current state of the codebase and may change as content is added.
