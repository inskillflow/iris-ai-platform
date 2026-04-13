<a id="top"></a>

# Evaluation 1 — Build a Complete REST API with FastAPI

> **Instructions for all subjects:**
> Build a fully functional CRUD REST API using **FastAPI** and **Python**.
> No starter code is provided. You build everything from scratch.
> Your API must run locally with `uvicorn` and be testable through **Swagger UI** at `/docs`.

---

## How to Choose a Subject

Your instructor will assign you a subject number, **or** you may choose one yourself.
Each subject is independent — the domain changes, but the technical requirements are the same.

---

## General Technical Requirements (apply to ALL subjects)

Your API must:

- [ ] Be written in a single file called `main.py`
- [ ] Use **FastAPI** and **Pydantic** (installed via `pip`)
- [ ] Define at least **3 Pydantic models** (one for create/PUT, one for PATCH, one for the response)
- [ ] Use an **in-memory Python dictionary** as the database
- [ ] Pre-load at least **4 sample records** at startup
- [ ] Use an **auto-increment `next_id`** counter for new records
- [ ] Include a **root endpoint** `GET /` that returns a welcome message and the total count
- [ ] Implement all **7 required endpoints** (listed in each subject)
- [ ] Return **correct HTTP status codes**: 200, 201, 204, 404, 422
- [ ] Return a **404** with a descriptive message when a record is not found
- [ ] Start with `uvicorn main:app --reload` without errors
- [ ] Have a working **Swagger UI** at `http://127.0.0.1:8000/docs`
- [ ] Include a `requirements.txt` file

---

## Deliverables

You must submit:

```text
your_project_folder/
├── main.py              ← your API (required)
├── requirements.txt     ← pip dependencies (required)
└── test_requests.http   ← REST Client test file with at least 15 test blocks (required)
```

---

## Grading Rubric (same for all subjects)

| Criteria | Points |
|---|---|
| All 7 endpoints work correctly | 30 |
| Correct HTTP status codes (200, 201, 204, 404, 422) | 15 |
| Pydantic models correctly defined (3 models) | 15 |
| At least 2 query filters work on the list endpoint | 10 |
| 404 errors return a descriptive message | 10 |
| `.http` test file covers all 7 endpoints | 10 |
| Code is readable (meaningful names, no dead code) | 5 |
| Bonus features (see each subject) | +10 |
| **Total** | **95 + 10 bonus** |

---

## Table of Contents — Subjects

| # | Subject | Domain |
|---|---|---|
| [Subject 1](#sub1) | **Book Library** | Books to read / reading list |
| [Subject 2](#sub2) | **Student Grade Manager** | Students and their grades |
| [Subject 3](#sub3) | **Movie Watchlist** | Movies to watch or already watched |
| [Subject 4](#sub4) | **Bug Tracker** | Software bugs and their status |
| [Subject 5](#sub5) | **Recipe Manager** | Cooking recipes |
| [Subject 6](#sub6) | **Workout Log** | Gym exercises and sessions |

---

<a id="sub1"></a>

---

## Subject 1 — Book Library API

<details>
<summary>Click to expand the full subject</summary>

<br/>

### Context

You are building the backend API for a personal book library management app.
Users can track books they own, are reading, or have finished.

---

### The `Book` resource

Your API manages **books**. Each book has the following fields:

| Field | Type | Required? | Default | Description |
|---|---|---|---|---|
| `id` | integer | auto (server) | — | Unique ID assigned by the server |
| `title` | string | **YES** | — | Title of the book |
| `author` | string | **YES** | — | Author's full name |
| `genre` | string | no | `"general"` | Genre: `"fiction"`, `"non-fiction"`, `"science"`, `"history"`, `"general"` |
| `read` | boolean | no | `false` | Has the book been read? |
| `rating` | integer | no | `0` | Rating from 0 to 5 (0 = not rated) |
| `created_at` | string | auto (server) | — | Timestamp set by the server |

---

### Required endpoints

| Method | Route | Description | Success code |
|---|---|---|---|
| GET | `/` | Welcome message + total number of books | 200 |
| GET | `/books` | List all books (with optional filters) | 200 |
| GET | `/books/{book_id}` | Get one book by ID | 200 / 404 |
| POST | `/books` | Add a new book | 201 |
| PUT | `/books/{book_id}` | Replace a book entirely | 200 / 404 |
| PATCH | `/books/{book_id}` | Update specific fields only | 200 / 404 |
| DELETE | `/books/{book_id}` | Remove a book | 204 / 404 |

---

### Required query filters on `GET /books`

Your list endpoint must support these optional filters:

- `?read=true` or `?read=false` → filter by read status
- `?genre=fiction` → filter by genre
- Both filters combined: `?read=false&genre=science`

---

### Sample data to pre-load (4 books)

| id | title | author | genre | read | rating |
|---|---|---|---|---|---|
| 1 | Clean Code | Robert C. Martin | non-fiction | true | 5 |
| 2 | The Pragmatic Programmer | David Thomas | non-fiction | false | 0 |
| 3 | Dune | Frank Herbert | fiction | true | 4 |
| 4 | A Brief History of Time | Stephen Hawking | science | false | 0 |

---

### Validation rules

- `title` and `author` are required for POST and PUT
- `rating` must be an integer — values 0 to 5
- If `rating` is not provided, default to `0`
- `read` must be a boolean — `true` or `false`

---

### What to test in your `.http` file

Your `test_requests.http` must include blocks for:

1. `GET /` — root
2. `GET /books` — all books (no filter)
3. `GET /books?read=true` — only read books
4. `GET /books?genre=fiction` — only fiction
5. `GET /books?read=false&genre=non-fiction` — combined filter
6. `GET /books/1` — one book
7. `GET /books/99` — expect 404
8. `POST /books` — full new book
9. `POST /books` — only required fields
10. `POST /books` with missing `title` — expect 422
11. `GET /books` — verify the new books appear
12. `PUT /books/1` — full replacement
13. `PATCH /books/2` — change only `read` to `true`
14. `PATCH /books/3` — change only `rating`
15. `DELETE /books/4` — delete
16. `GET /books/4` — confirm 404 after deletion
17. `GET /books` — final state

---

### Bonus challenges (+10 points)

Choose **one or more**:

- **Bonus A:** Add a `GET /books/unread` endpoint that returns only unread books (without using query parameters)
- **Bonus B:** Add validation so `rating` must be between 0 and 5 — return a 400 error if it is out of range
- **Bonus C:** Add a `GET /books/stats` endpoint that returns: total books, number read, number unread, average rating of read books

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="sub2"></a>

---

## Subject 2 — Student Grade Manager API

<details>
<summary>Click to expand the full subject</summary>

<br/>

### Context

You are building the backend API for a course management system.
Teachers can add students, record their grades, and track whether they passed a course.

---

### The `Student` resource

| Field | Type | Required? | Default | Description |
|---|---|---|---|---|
| `id` | integer | auto (server) | — | Unique ID |
| `name` | string | **YES** | — | Full name of the student |
| `course` | string | **YES** | — | Course name (e.g. `"Python"`, `"Web Dev"`) |
| `grade` | float | no | `0.0` | Grade from 0.0 to 100.0 |
| `passed` | boolean | no | `false` | Did the student pass? |
| `semester` | string | no | `"fall"` | `"fall"` or `"winter"` |
| `created_at` | string | auto (server) | — | Timestamp |

---

### Required endpoints

| Method | Route | Description | Success code |
|---|---|---|---|
| GET | `/` | Welcome message + total students | 200 |
| GET | `/students` | List all students (with filters) | 200 |
| GET | `/students/{student_id}` | Get one student | 200 / 404 |
| POST | `/students` | Add a new student | 201 |
| PUT | `/students/{student_id}` | Replace student data entirely | 200 / 404 |
| PATCH | `/students/{student_id}` | Update specific fields | 200 / 404 |
| DELETE | `/students/{student_id}` | Remove a student | 204 / 404 |

---

### Required query filters on `GET /students`

- `?passed=true` or `?passed=false` → filter by pass/fail status
- `?course=Python` → filter by course name
- Combined: `?passed=false&course=Python`

---

### Sample data to pre-load (4 students)

| id | name | course | grade | passed | semester |
|---|---|---|---|---|---|
| 1 | Alice Martin | Python | 88.5 | true | fall |
| 2 | Bob Smith | Web Dev | 45.0 | false | fall |
| 3 | Carol Johnson | Python | 72.0 | true | winter |
| 4 | David Lee | Web Dev | 55.5 | false | winter |

---

### Validation rules

- `name` and `course` are required for POST and PUT
- `grade` must be a float — values 0.0 to 100.0
- `passed` must be a boolean
- `semester` can only be `"fall"` or `"winter"`

---

### What to test in your `.http` file

Your `test_requests.http` must include blocks for all 7 endpoints, including:

- Filter by `passed=true`
- Filter by `course`
- Combined filters
- A GET that triggers 404
- A POST with missing `name` — expect 422
- A PATCH that only updates `grade`
- A PATCH that only updates `passed`
- A DELETE and a follow-up GET to confirm the 404

---

### Bonus challenges (+10 points)

Choose **one or more**:

- **Bonus A:** Add a `GET /students/failing` endpoint that returns all students with `passed=false`
- **Bonus B:** Add a `GET /students/stats` endpoint returning: total students, number passed, number failed, class average grade
- **Bonus C:** When doing PATCH to update a `grade` above 60.0, automatically set `passed` to `true`; if the grade is set below 60.0, set `passed` to `false`

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="sub3"></a>

---

## Subject 3 — Movie Watchlist API

<details>
<summary>Click to expand the full subject</summary>

<br/>

### Context

You are building the backend API for a personal movie tracker.
Users can keep a list of movies they want to watch, are watching, or have already seen.

---

### The `Movie` resource

| Field | Type | Required? | Default | Description |
|---|---|---|---|---|
| `id` | integer | auto (server) | — | Unique ID |
| `title` | string | **YES** | — | Movie title |
| `director` | string | no | `""` | Director's name |
| `genre` | string | no | `"other"` | `"action"`, `"drama"`, `"comedy"`, `"horror"`, `"sci-fi"`, `"other"` |
| `watched` | boolean | no | `false` | Has the movie been watched? |
| `rating` | integer | no | `0` | Rating from 0 to 10 (0 = not rated yet) |
| `created_at` | string | auto (server) | — | Timestamp |

---

### Required endpoints

| Method | Route | Description | Success code |
|---|---|---|---|
| GET | `/` | Welcome message + total movies | 200 |
| GET | `/movies` | List all movies (with filters) | 200 |
| GET | `/movies/{movie_id}` | Get one movie | 200 / 404 |
| POST | `/movies` | Add a new movie | 201 |
| PUT | `/movies/{movie_id}` | Replace a movie entirely | 200 / 404 |
| PATCH | `/movies/{movie_id}` | Update specific fields | 200 / 404 |
| DELETE | `/movies/{movie_id}` | Remove a movie | 204 / 404 |

---

### Required query filters on `GET /movies`

- `?watched=true` or `?watched=false`
- `?genre=action`
- Combined: `?watched=false&genre=sci-fi`

---

### Sample data to pre-load (4 movies)

| id | title | director | genre | watched | rating |
|---|---|---|---|---|---|
| 1 | Inception | Christopher Nolan | sci-fi | true | 9 |
| 2 | The Godfather | Francis Ford Coppola | drama | true | 10 |
| 3 | Interstellar | Christopher Nolan | sci-fi | false | 0 |
| 4 | The Dark Knight | Christopher Nolan | action | false | 0 |

---

### Validation rules

- `title` is required for POST and PUT
- `rating` must be integer — 0 to 10
- `watched` must be a boolean

---

### What to test in your `.http` file

Your `test_requests.http` must include blocks for all 7 endpoints, including:

- Filter by `watched=false`
- Filter by `genre=sci-fi`
- Combined filters
- A GET with non-existent ID — expect 404
- A POST with full data → 201
- A POST with title only → 201 with default values
- A POST without title → expect 422
- A PATCH that only marks a movie as watched
- A PATCH that only updates the rating
- A DELETE and confirmation with GET

---

### Bonus challenges (+10 points)

Choose **one or more**:

- **Bonus A:** Add a `GET /movies/unwatched` endpoint that returns only unwatched movies
- **Bonus B:** Add a `GET /movies/top` endpoint that returns movies with a rating of 8 or above
- **Bonus C:** Add a `?director=Nolan` query filter to `GET /movies`

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="sub4"></a>

---

## Subject 4 — Bug Tracker API

<details>
<summary>Click to expand the full subject</summary>

<br/>

### Context

You are building the backend API for a software bug tracking system.
Developers can report bugs, update their status, assign severity levels, and close them when fixed.

---

### The `Bug` resource

| Field | Type | Required? | Default | Description |
|---|---|---|---|---|
| `id` | integer | auto (server) | — | Unique ID |
| `title` | string | **YES** | — | Short description of the bug |
| `description` | string | no | `""` | Detailed explanation |
| `status` | string | no | `"open"` | `"open"`, `"in_progress"`, or `"closed"` |
| `severity` | string | no | `"medium"` | `"low"`, `"medium"`, `"high"`, or `"critical"` |
| `resolved` | boolean | no | `false` | Is the bug fixed? |
| `created_at` | string | auto (server) | — | Timestamp |

---

### Required endpoints

| Method | Route | Description | Success code |
|---|---|---|---|
| GET | `/` | Welcome message + total bugs | 200 |
| GET | `/bugs` | List all bugs (with filters) | 200 |
| GET | `/bugs/{bug_id}` | Get one bug | 200 / 404 |
| POST | `/bugs` | Report a new bug | 201 |
| PUT | `/bugs/{bug_id}` | Replace a bug entirely | 200 / 404 |
| PATCH | `/bugs/{bug_id}` | Update specific fields | 200 / 404 |
| DELETE | `/bugs/{bug_id}` | Remove a bug | 204 / 404 |

---

### Required query filters on `GET /bugs`

- `?status=open` → filter by status (`open`, `in_progress`, `closed`)
- `?severity=critical` → filter by severity
- Combined: `?status=open&severity=high`

---

### Sample data to pre-load (4 bugs)

| id | title | status | severity | resolved |
|---|---|---|---|---|
| 1 | Login page crashes on mobile | open | critical | false |
| 2 | Typo in homepage title | closed | low | true |
| 3 | API returns 500 on empty input | in_progress | high | false |
| 4 | Dark mode toggle not working | open | medium | false |

---

### Validation rules

- `title` is required for POST and PUT
- `status` can only be `"open"`, `"in_progress"`, or `"closed"`
- `severity` can only be `"low"`, `"medium"`, `"high"`, or `"critical"`
- `resolved` must be a boolean

---

### What to test in your `.http` file

Your `test_requests.http` must include blocks for all 7 endpoints, including:

- `GET /bugs?status=open`
- `GET /bugs?severity=critical`
- `GET /bugs?status=in_progress&severity=high`
- A GET with non-existent ID — expect 404
- A POST with only `title` → 201 with defaults
- A POST without `title` → expect 422
- A PATCH that changes `status` from `"open"` to `"in_progress"`
- A PATCH that sets `resolved` to `true` and `status` to `"closed"`
- A DELETE and confirmation

---

### Bonus challenges (+10 points)

Choose **one or more**:

- **Bonus A:** Add a `GET /bugs/open` endpoint that returns all bugs with `status = "open"`
- **Bonus B:** Add a `GET /bugs/stats` endpoint returning: total bugs, open count, in_progress count, closed count, critical count
- **Bonus C:** When doing PATCH to set `resolved=true`, automatically change `status` to `"closed"` as well

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="sub5"></a>

---

## Subject 5 — Recipe Manager API

<details>
<summary>Click to expand the full subject</summary>

<br/>

### Context

You are building the backend API for a personal recipe collection app.
Users can save recipes, mark them as favorites, and organize them by meal type and difficulty.

---

### The `Recipe` resource

| Field | Type | Required? | Default | Description |
|---|---|---|---|---|
| `id` | integer | auto (server) | — | Unique ID |
| `name` | string | **YES** | — | Recipe name |
| `category` | string | no | `"other"` | `"breakfast"`, `"lunch"`, `"dinner"`, `"dessert"`, `"other"` |
| `difficulty` | string | no | `"medium"` | `"easy"`, `"medium"`, or `"hard"` |
| `time_minutes` | integer | no | `30` | Preparation time in minutes |
| `favorite` | boolean | no | `false` | Is this a favorite recipe? |
| `created_at` | string | auto (server) | — | Timestamp |

---

### Required endpoints

| Method | Route | Description | Success code |
|---|---|---|---|
| GET | `/` | Welcome message + total recipes | 200 |
| GET | `/recipes` | List all recipes (with filters) | 200 |
| GET | `/recipes/{recipe_id}` | Get one recipe | 200 / 404 |
| POST | `/recipes` | Add a new recipe | 201 |
| PUT | `/recipes/{recipe_id}` | Replace a recipe entirely | 200 / 404 |
| PATCH | `/recipes/{recipe_id}` | Update specific fields | 200 / 404 |
| DELETE | `/recipes/{recipe_id}` | Remove a recipe | 204 / 404 |

---

### Required query filters on `GET /recipes`

- `?favorite=true` or `?favorite=false`
- `?category=dinner`
- Combined: `?favorite=true&category=dessert`

---

### Sample data to pre-load (4 recipes)

| id | name | category | difficulty | time_minutes | favorite |
|---|---|---|---|---|---|
| 1 | Spaghetti Carbonara | dinner | medium | 25 | true |
| 2 | French Toast | breakfast | easy | 15 | false |
| 3 | Chocolate Lava Cake | dessert | hard | 45 | true |
| 4 | Caesar Salad | lunch | easy | 20 | false |

---

### Validation rules

- `name` is required for POST and PUT
- `difficulty` must be one of: `"easy"`, `"medium"`, `"hard"`
- `category` must be one of: `"breakfast"`, `"lunch"`, `"dinner"`, `"dessert"`, `"other"`
- `time_minutes` must be an integer greater than 0
- `favorite` must be a boolean

---

### What to test in your `.http` file

Your `test_requests.http` must include blocks for all 7 endpoints, including:

- `GET /recipes?favorite=true`
- `GET /recipes?category=dinner`
- Combined filter
- GET with non-existent ID — expect 404
- POST with full data — 201
- POST with only `name` — 201 with defaults
- POST without `name` — 422
- PATCH to mark as favorite
- PATCH to change difficulty
- DELETE and confirmation

---

### Bonus challenges (+10 points)

Choose **one or more**:

- **Bonus A:** Add a `GET /recipes/quick` endpoint that returns all recipes with `time_minutes` ≤ 20
- **Bonus B:** Add a `?difficulty=easy` filter to `GET /recipes`
- **Bonus C:** Add a `GET /recipes/stats` endpoint returning: total recipes, number of favorites, average preparation time, count per category

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="sub6"></a>

---

## Subject 6 — Workout Log API

<details>
<summary>Click to expand the full subject</summary>

<br/>

### Context

You are building the backend API for a personal fitness tracking app.
Users can log their workout sessions, track exercises, and mark sessions as completed.

---

### The `Workout` resource

| Field | Type | Required? | Default | Description |
|---|---|---|---|---|
| `id` | integer | auto (server) | — | Unique ID |
| `exercise` | string | **YES** | — | Name of the exercise (e.g. `"Running"`, `"Push-ups"`) |
| `muscle_group` | string | no | `"full body"` | Target area: `"legs"`, `"chest"`, `"back"`, `"arms"`, `"core"`, `"full body"` |
| `duration_minutes` | integer | no | `30` | Duration of the session in minutes |
| `completed` | boolean | no | `false` | Was the session completed? |
| `intensity` | string | no | `"moderate"` | `"light"`, `"moderate"`, or `"intense"` |
| `created_at` | string | auto (server) | — | Timestamp |

---

### Required endpoints

| Method | Route | Description | Success code |
|---|---|---|---|
| GET | `/` | Welcome message + total workouts | 200 |
| GET | `/workouts` | List all workouts (with filters) | 200 |
| GET | `/workouts/{workout_id}` | Get one workout | 200 / 404 |
| POST | `/workouts` | Log a new workout | 201 |
| PUT | `/workouts/{workout_id}` | Replace a workout entirely | 200 / 404 |
| PATCH | `/workouts/{workout_id}` | Update specific fields | 200 / 404 |
| DELETE | `/workouts/{workout_id}` | Remove a workout | 204 / 404 |

---

### Required query filters on `GET /workouts`

- `?completed=true` or `?completed=false`
- `?intensity=intense`
- Combined: `?completed=false&intensity=moderate`

---

### Sample data to pre-load (4 workouts)

| id | exercise | muscle_group | duration_minutes | completed | intensity |
|---|---|---|---|---|---|
| 1 | Morning Run | legs | 45 | true | moderate |
| 2 | Bench Press | chest | 30 | false | intense |
| 3 | Yoga Session | full body | 60 | true | light |
| 4 | Pull-ups | back | 20 | false | intense |

---

### Validation rules

- `exercise` is required for POST and PUT
- `intensity` must be one of: `"light"`, `"moderate"`, `"intense"`
- `muscle_group` must be one of: `"legs"`, `"chest"`, `"back"`, `"arms"`, `"core"`, `"full body"`
- `duration_minutes` must be an integer greater than 0
- `completed` must be a boolean

---

### What to test in your `.http` file

Your `test_requests.http` must include blocks for all 7 endpoints, including:

- `GET /workouts?completed=false`
- `GET /workouts?intensity=intense`
- Combined filter
- GET with non-existent ID — expect 404
- POST with full data — 201
- POST with only `exercise` — 201 with defaults
- POST without `exercise` — 422
- PATCH to mark a workout as completed
- PATCH to change the intensity
- DELETE and confirmation with a second GET

---

### Bonus challenges (+10 points)

Choose **one or more**:

- **Bonus A:** Add a `GET /workouts/today` endpoint that returns all workouts created today (compare `created_at` date to today's date)
- **Bonus B:** Add a `?muscle_group=legs` filter to `GET /workouts`
- **Bonus C:** Add a `GET /workouts/stats` endpoint returning: total workouts, completed count, not completed count, total minutes logged, average duration

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

## Quick Reference — What Your API Must Have

> This table is a checklist you can use to verify your work before submitting.

### Pydantic models (3 required)

| Model name | Used for | Fields |
|---|---|---|
| `XxxCreate` | POST and PUT body | All fields — required ones without defaults |
| `XxxUpdate` | PATCH body | All fields `Optional[type] = None` |
| `Xxx` | Response model | All fields including `id` and `created_at` |

*(replace `Xxx` with your resource name, e.g. `BookCreate`, `BookUpdate`, `Book`)*

---

### The 7 endpoints pattern

```
GET    /                    → root info
GET    /items               → list all (+ optional filters as query params)
GET    /items/{id}          → get one → 404 if not found
POST   /items               → create → 201 Created
PUT    /items/{id}          → replace entirely → 404 if not found
PATCH  /items/{id}          → partial update → 404 if not found
DELETE /items/{id}          → delete → 204 No Content → 404 if not found
```

---

### The in-memory database pattern

```python
items_db: dict[int, dict] = {
    1: { ... },
    2: { ... },
    3: { ... },
    4: { ... },
}

next_id = 5
```

---

### The PATCH pattern

```python
for field, value in update.model_dump(exclude_none=True).items():
    items_db[item_id][field] = value
```

---

### The 404 pattern

```python
if item_id not in items_db:
    raise HTTPException(
        status_code=404,
        detail=f"Item with ID {item_id} not found"
    )
```

---

<p align="center">
  <strong>Good luck — build something great.</strong><br/>
  <a href="#top">↑ Back to the top</a>
</p>
