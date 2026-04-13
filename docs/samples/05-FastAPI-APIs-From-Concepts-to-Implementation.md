<a id="top"></a>

# APIs — From Concepts to Implementation

## Table of Contents

| # | Section |
|---|---|
| 1 | [What is an API?](#section-1) |
| 1a | &nbsp;&nbsp;&nbsp;↳ [The 6 REST constraints](#section-1) |
| 2 | [Why use APIs?](#section-2) |
| 3 | [HTTP Protocol and Methods](#section-3) |
| 3a | &nbsp;&nbsp;&nbsp;↳ [What is a route / endpoint?](#section-3) |
| 3b | &nbsp;&nbsp;&nbsp;↳ [Path param vs query param](#section-3) |
| 4 | [HTTP Status Codes](#section-4) |
| 5 | [Making API calls with `requests`](#section-5) |
| 5a | &nbsp;&nbsp;&nbsp;↳ [Virtual environments — always use them](#section-5) |
| 5b | &nbsp;&nbsp;&nbsp;↳ [Complete scripts to run in VS Code](#section-5) |
| 5c | &nbsp;&nbsp;&nbsp;↳ [Test with Postman — public API](#section-5) |
| 6 | [FastAPI — Building an API](#section-6) |
| 6a | &nbsp;&nbsp;&nbsp;↳ [What is `@` — the decorator?](#section-6) |
| 6b | &nbsp;&nbsp;&nbsp;↳ [Complete `fastapi_demo.py` to copy-paste](#section-6) |
| 6c | &nbsp;&nbsp;&nbsp;↳ [Test with Postman — local FastAPI server](#section-6) |
| 7 | [Flask — Building an API](#section-7) |
| 7a | &nbsp;&nbsp;&nbsp;↳ [What is `@app.route()`?](#section-7) |
| 7b | &nbsp;&nbsp;&nbsp;↳ [What is `jsonify()` and `request.get_json()`?](#section-7) |
| 7c | &nbsp;&nbsp;&nbsp;↳ [Complete `flask_demo.py` to copy-paste](#section-7) |
| 8 | [Django REST Framework — Overview](#section-8) |
| 9 | [FastAPI vs Flask vs Django — Comparison](#section-9) |
| 10 | [Authentication in APIs](#section-10) |
| 11 | [Error Handling](#section-11) |
| 12 | [Complete Example — Book API](#section-12) |
| 13 | [Commands Summary](#section-13) |
| 14 | [Conclusion](#section-14) |
| 15 | [Hands-on Project — Task Manager API (FastAPI + Streamlit)](#section-15) |
| 15a | &nbsp;&nbsp;&nbsp;↳ [Clone the repository](#section-15) |
| 15b | &nbsp;&nbsp;&nbsp;↳ [Virtual environment + install](#section-15) |
| 15c | &nbsp;&nbsp;&nbsp;↳ [Run FastAPI + Streamlit](#section-15) |
| 15d | &nbsp;&nbsp;&nbsp;↳ [Test with VS Code REST Client, Postman, curl](#section-15) |
| 16 | [How to Test Your API with Swagger UI — Step by Step for Absolute Beginners](#section-swagger-testing) |
| 16a | &nbsp;&nbsp;&nbsp;↳ [Start your FastAPI server](#section-swagger-testing) |
| 16b | &nbsp;&nbsp;&nbsp;↳ [Open Swagger UI in your browser](#section-swagger-testing) |
| 16c | &nbsp;&nbsp;&nbsp;↳ [Test GET / POST / PUT / DELETE](#section-swagger-testing) |
| 16d | &nbsp;&nbsp;&nbsp;↳ [Status codes summary + Quick recap](#section-swagger-testing) |

---

<a id="section-1"></a>

<details>
<summary>1 - What is an API?</summary>

<br/>

An **API** (Application Programming Interface) is a set of rules that defines how two programs can communicate with each other. It acts as a contract: the API specifies what requests can be made, in what format, and what responses will be returned.

The word "interface" is key. Just as a light switch is an interface between you and the electrical wiring inside the wall — you do not need to understand the wiring to use it — an API lets one program use the capabilities of another program without knowing how it is built internally.

```mermaid
flowchart LR
    A["Client<br/>(your code, app, browser)"] -->|"Request"| B["API<br/>(the contract)"]
    B -->|"Response"| A
    B --> C["Server / Service<br/>(the implementation)"]
```

---

### A concrete example

When you open a weather app on your phone, the app does not store weather data itself. Instead, it sends a request to a weather API (like OpenWeatherMap), which returns the current temperature, humidity, and forecast. The app then displays this data. The app and the weather service are completely separate systems — the API is what connects them.

The same pattern applies everywhere:

* a payment app calls the **Stripe API** to charge a card
* a social media app calls the **Twitter API** to fetch tweets
* a map app calls the **Google Maps API** to show directions
* your FastAPI backend calls the **TensorFlow model** through Python function calls (an internal API)

---

### REST, SOAP, and GraphQL

There are several styles of APIs. The most common today is **REST**.

```mermaid
flowchart TD
    A["API styles"] --> B["REST<br/>Representational State Transfer<br/>Most common today"]
    A --> C["SOAP<br/>Simple Object Access Protocol<br/>Older, XML-based, enterprise systems"]
    A --> D["GraphQL<br/>Query language for APIs<br/>Developed by Facebook"]
    A --> E["gRPC<br/>Google's binary protocol<br/>High performance, microservices"]
```

**REST** (Representational State Transfer) is an architectural style built on top of HTTP. A REST API exposes resources (such as users, products, or predictions) through URLs, and uses HTTP methods to define what action to perform on those resources.

For example:

| URL | Method | Action |
|---|---|---|
| `/users` | GET | Get all users |
| `/users/42` | GET | Get user with ID 42 |
| `/users` | POST | Create a new user |
| `/users/42` | PUT | Update user 42 entirely |
| `/users/42` | PATCH | Update part of user 42 |
| `/users/42` | DELETE | Delete user 42 |

This project focuses on **REST APIs** because they are the industry standard for web services and data exchange between applications.

---

### What makes an API "good"?

A well-designed API has several qualities:

* **Consistency** — the same patterns are used throughout (naming conventions, response structure)
* **Clear documentation** — every endpoint is described, with examples
* **Predictable errors** — error responses follow a standard format
* **Versioning** — changes are managed without breaking existing clients (e.g., `/api/v1/users`)
* **Security** — authentication and authorization are properly implemented

---

### The 6 constraints of REST

REST is not just a style — it is a set of 6 architectural constraints defined by Roy Fielding in his 2000 doctoral dissertation. An API is only truly RESTful if it respects all 6.

```mermaid
flowchart TD
    REST["REST Architecture<br/>6 Constraints"] --> C1["1. Client-Server<br/>UI and data are separated"]
    REST --> C2["2. Stateless<br/>No session stored on server"]
    REST --> C3["3. Cacheable<br/>Responses can be cached"]
    REST --> C4["4. Uniform Interface<br/>Consistent URL and method patterns"]
    REST --> C5["5. Layered System<br/>Client doesn't know about middleware"]
    REST --> C6["6. Code on Demand<br/>(Optional) Server can send code"]
```

**1. Client-Server separation**

The client (frontend) and the server (backend) are completely independent. The client does not know how the server stores data. The server does not know how the client displays data. They communicate only through the API. This separation allows each side to evolve independently.

**2. Stateless**

Each request from the client to the server must contain all the information needed to understand and process it. The server does not store any session information about the client between requests. This is why authentication tokens are sent with every request rather than stored in a server-side session.

```mermaid
sequenceDiagram
    participant C as Client
    participant S as Server

    Note over S: Server remembers NOTHING between requests

    C->>S: GET /profile<br/>Authorization: Bearer token123
    S-->>C: 200 OK — user data

    C->>S: GET /orders<br/>Authorization: Bearer token123
    S-->>C: 200 OK — orders list

    Note over C,S: Token is sent EVERY time — server is stateless
```

**3. Cacheable**

Responses must declare whether they can be cached by the client or intermediaries. Caching reduces server load and improves performance. HTTP headers like `Cache-Control`, `ETag`, and `Expires` control caching behavior.

**4. Uniform Interface**

This is the most important constraint. It requires that all resources are identified by URLs, that they are manipulated through standard HTTP methods, and that responses use standard formats (JSON or XML). This uniformity is what makes REST APIs predictable across different systems.

**5. Layered System**

The client does not need to know whether it is talking directly to the server or through intermediaries such as a load balancer, a cache, or a security gateway. Each layer only knows about the layer directly next to it.

**6. Code on Demand (optional)**

Servers can optionally send executable code to the client (such as JavaScript). This is the only optional constraint.

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-2"></a>

<details>
<summary>2 - Why use APIs?</summary>

<br/>

APIs solve one of the most fundamental problems in software engineering: how to build complex systems from independent, reusable parts. Rather than building monolithic applications where everything is tightly coupled, modern systems are composed of services that communicate through APIs.

---

### Separation of concerns

Without APIs, every part of an application needs to know how every other part works internally. This creates tight coupling — change one thing, and everything else breaks.

With APIs, each service exposes a clear contract. Other services only need to know the contract, not the internal implementation.

```mermaid
flowchart TD
    subgraph WITHOUT["Without APIs — Monolithic"]
        A1["UI code"] --- B1["DB code"]
        B1 --- C1["ML code"]
        C1 --- A1
        A1 --- D1["Auth code"]
        D1 --- B1
    end

    subgraph WITH["With APIs — Service-based"]
        A2["Frontend"] -->|"HTTP"| B2["Auth API"]
        A2 -->|"HTTP"| C2["Data API"]
        A2 -->|"HTTP"| D2["ML API"]
        C2 -->|"internal"| E2["Database"]
        D2 -->|"internal"| F2["Model"]
    end
```

---

### Reusability

An API can be consumed by many different clients simultaneously. The same REST API can serve:

* a web frontend (JavaScript)
* a mobile app (Swift or Kotlin)
* a data pipeline (Python script)
* another backend service
* a third-party integration

Without an API, you would need to rebuild the same logic separately for each client.

---

### Language independence

APIs communicate over HTTP using standard data formats like JSON. This means the client and server can be written in completely different languages. A Python FastAPI backend can serve a JavaScript frontend, a Java mobile app, and a Go microservice — all at the same time.

```mermaid
flowchart LR
    B["REST API<br/>(Python / FastAPI)"]
    A1["JavaScript<br/>frontend"] -->|"JSON"| B
    A2["Swift<br/>iOS app"] -->|"JSON"| B
    A3["Java<br/>Android app"] -->|"JSON"| B
    A4["Go<br/>microservice"] -->|"JSON"| B
```

---

### Scalability

Because services communicate through APIs, each service can be scaled independently. If the prediction service receives more traffic than the authentication service, only the prediction service needs more resources. This is much more efficient than scaling an entire monolithic application.

---

### Enabling ecosystems

Public APIs allow third-party developers to build products on top of existing platforms. Twitter, Stripe, Twilio, and Google Maps all offer APIs that power thousands of other applications. This network effect is one of the most powerful aspects of the API economy.

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-3"></a>

<details>
<summary>3 - HTTP Protocol and Methods</summary>

<br/>

REST APIs are built on top of HTTP (HyperText Transfer Protocol), the same protocol used by web browsers to load pages. Understanding HTTP is essential for working with APIs.

An HTTP exchange always follows the same pattern: a **client** sends a **request**, and a **server** returns a **response**.

```mermaid
sequenceDiagram
    participant C as Client
    participant S as Server

    C->>S: HTTP Request<br/>(method + URL + headers + body)
    S-->>C: HTTP Response<br/>(status code + headers + body)
```

---

### Anatomy of an HTTP request

Every HTTP request has four components:

```text
POST /users HTTP/1.1
Host: jsonplaceholder.typicode.com
Content-Type: application/json
Authorization: Bearer eyJhbGci...

{
  "name": "Alice",
  "email": "alice@example.com"
}
```

| Component | Example | Description |
|---|---|---|
| Method | `POST` | The action to perform |
| URL / Path | `/api/users` | The resource to act upon |
| Headers | `Content-Type: application/json` | Metadata about the request |
| Body | `{"name": "Alice"}` | The data sent to the server (for POST/PUT) |

---

### HTTP Methods

```mermaid
flowchart LR
    A["HTTP Methods"] --> B["GET<br/>Read data<br/>No body"]
    A --> C["POST<br/>Create new resource<br/>Body required"]
    A --> D["PUT<br/>Replace resource entirely<br/>Body required"]
    A --> E["PATCH<br/>Update part of a resource<br/>Body required"]
    A --> F["DELETE<br/>Remove a resource<br/>No body"]
```

#### GET — Read data

GET is used to retrieve data from the server. It should have no side effects — calling GET should not modify anything on the server.

```python
import requests

response = requests.get("https://jsonplaceholder.typicode.com/users")
print(response.json())
```

#### POST — Create a resource

POST is used to send data to the server to create a new resource. The data is included in the request body.

```python
import requests

payload = {"name": "Alice", "email": "alice@example.com"}
response = requests.post("https://jsonplaceholder.typicode.com/users", json=payload)
print(response.status_code)  # 201 Created
```

#### PUT — Replace a resource

PUT replaces the entire resource with the data provided. If any field is missing, it is removed.

```python
import requests

payload = {"name": "Alice Updated", "email": "alice@example.com"}
response = requests.put("https://jsonplaceholder.typicode.com/users/1", json=payload)
```

#### PATCH — Partially update a resource

PATCH only updates the fields that are provided, leaving the rest unchanged.

```python
import requests

payload = {"name": "Alice Renamed"}
response = requests.patch("https://jsonplaceholder.typicode.com/users/1", json=payload)
```

#### DELETE — Remove a resource

DELETE removes the specified resource from the server.

```python
import requests

response = requests.delete("https://jsonplaceholder.typicode.com/users/1")
print(response.status_code)  # 200 OK (JSONPlaceholder simulates deletion)
```

---

### URL structure

A well-designed REST URL identifies a resource clearly:

```text
https://jsonplaceholder.typicode.com/users/1/posts?_limit=10&_page=2
|_____| |____________________________| |___| |_| |___| |_______________|
scheme           host                 resource id sub   query params
```

| Part | Description |
|---|---|
| `https` | Protocol (always HTTPS in production) |
| `jsonplaceholder.typicode.com` | Host (the server address) |
| `/users/1` | Resource path with ID |
| `/posts` | Sub-resource (posts belonging to user 1) |
| `?limit=10&page=2` | Query parameters (filters, pagination) |

---

### What is a route?

A **route** (also called an **endpoint**) is a specific URL address that the server listens to, associated with a particular HTTP method. When a client sends a request that matches a route's method + URL, the server executes the function that is attached to that route.

Think of routes like menu items in a restaurant. Each menu item (route) is a specific combination of what you want (the HTTP method) and what you are asking for (the URL path). The kitchen (server) prepares the correct dish (response) when it receives a matching order.

```mermaid
flowchart LR
    subgraph ROUTES["Routes defined in the server"]
        R1["GET  /students     → list_students()"]
        R2["POST /students     → create_student()"]
        R3["GET  /students/42  → get_student(42)"]
        R4["DELETE /students/42 → delete_student(42)"]
    end

    A["Client request:<br/>GET /students/42"] --> B["Router<br/>matches method + path"]
    B --> R3
    R3 --> C["Response:<br/>{id: 42, name: ...}"]
```

A route is defined by two things:
1. **The HTTP method** — what action is requested (GET, POST, PUT, DELETE...)
2. **The URL path** — which resource is targeted (`/students`, `/students/42`...)

If the client sends `GET /students`, the router matches the first route and calls `list_students()`. If the client sends `GET /students/42`, the router matches the third route and calls `get_student(42)`. The method and the path must both match — sending `DELETE /students` is a different route than `GET /students`.

In **Flask**, routes are declared like this:

```python
@app.route("/students", methods=["GET"])
def list_students():
    ...

@app.route("/students/<int:student_id>", methods=["GET"])
def get_student(student_id):
    ...
```

In **FastAPI**, the method is part of the decorator name:

```python
@app.get("/students")
def list_students():
    ...

@app.get("/students/{student_id}")
def get_student(student_id: int):
    ...
```

Both frameworks achieve the same result — they map a method + path combination to a Python function.

---

### What is a path parameter vs a query parameter?

These are two different ways to pass data through a URL.

**Path parameter** — embedded inside the URL path, identifies a specific resource:

```text
GET /students/42
              ↑
              This is a path parameter — identifies student with id 42
```

**Query parameter** — appended after `?`, used for filtering, sorting, pagination:

```text
GET /students?active=true&limit=10
              ↑_____________________
              These are query parameters — filter and limit results
```

| Type | Location | Used for | Example |
|---|---|---|---|
| Path parameter | Inside the path | Identifying a specific resource | `/students/42` |
| Query parameter | After `?` in the URL | Filtering, sorting, pagination | `/students?active=true` |



Headers carry metadata about the request or response. Common headers include:

| Header | Direction | Purpose |
|---|---|---|
| `Content-Type` | Request | Format of the request body (e.g., `application/json`) |
| `Authorization` | Request | Authentication token |
| `Accept` | Request | Format the client expects in response |
| `Content-Type` | Response | Format of the response body |
| `X-RateLimit-Remaining` | Response | How many requests are left before rate limiting |

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-4"></a>

<details>
<summary>4 - HTTP Status Codes</summary>

<br/>

Every HTTP response includes a **status code** — a 3-digit number that tells the client whether the request succeeded or failed, and why. Status codes are the language that servers use to communicate the outcome of a request. A client that ignores status codes and only looks at the response body is missing critical information.

Status codes are standardized by the IETF (Internet Engineering Task Force). This means a `404` means "not found" in every API on the internet, regardless of who built it or what language it uses.

```mermaid
flowchart LR
    A["Status codes"] --> B["1xx<br/>Informational<br/>Request received, processing"]
    A --> C["2xx<br/>Success<br/>Request completed successfully"]
    A --> D["3xx<br/>Redirection<br/>Further action needed"]
    A --> E["4xx<br/>Client error<br/>Problem with the request"]
    A --> F["5xx<br/>Server error<br/>Problem on the server"]
```

The most important distinction is between **4xx** and **5xx** errors:
* A **4xx** error means the client did something wrong — fix the request and try again
* A **5xx** error means the server is broken — the client did nothing wrong, and retrying may work later

---

### Most important status codes

#### 2xx — Success

| Code | Name | Meaning |
|---|---|---|
| `200` | OK | The request succeeded. Body contains the result. |
| `201` | Created | A new resource was successfully created. |
| `204` | No Content | The request succeeded but there is no body to return (e.g., DELETE). |

#### 4xx — Client errors

These errors mean the request was malformed or unauthorized. The **client** needs to fix something.

| Code | Name | Meaning |
|---|---|---|
| `400` | Bad Request | The request is malformed or missing required fields. |
| `401` | Unauthorized | Authentication is required but missing or invalid. |
| `403` | Forbidden | Authenticated but not allowed to access this resource. |
| `404` | Not Found | The requested resource does not exist. |
| `405` | Method Not Allowed | The HTTP method is not supported for this URL. |
| `422` | Unprocessable Entity | The data is valid JSON but fails validation rules (used by FastAPI). |
| `429` | Too Many Requests | Rate limit exceeded. |

#### 5xx — Server errors

These errors mean something went wrong on the **server**. The client did nothing wrong.

| Code | Name | Meaning |
|---|---|---|
| `500` | Internal Server Error | An unexpected error occurred on the server. |
| `502` | Bad Gateway | The server received an invalid response from an upstream service. |
| `503` | Service Unavailable | The server is temporarily down or overloaded. |

---

### How to check status codes in Python

```python
import requests

response = requests.get("https://jsonplaceholder.typicode.com/users/1")

if response.status_code == 200:
    data = response.json()
    print("Success:", data)
elif response.status_code == 404:
    print("User not found")
elif response.status_code == 401:
    print("Authentication required")
elif response.status_code >= 500:
    print("Server error — try again later")
else:
    print(f"Unexpected status: {response.status_code}")
```

A more robust approach uses exception handling with `raise_for_status()`:

```python
import requests
from requests.exceptions import HTTPError

try:
    response = requests.get("https://jsonplaceholder.typicode.com/users/1")
    response.raise_for_status()  # Raises HTTPError for 4xx and 5xx
    data = response.json()
    print("Success:", data)
except HTTPError as e:
    print(f"HTTP error: {e}")
except requests.exceptions.ConnectionError:
    print("Could not connect to the server")
except requests.exceptions.Timeout:
    print("The request timed out")
```

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-5"></a>

<details>
<summary>5 - Making API calls with `requests`</summary>

<br/>

### Working in a virtual environment — always

Before installing any library, you should create a **virtual environment**. A virtual environment is an isolated Python installation that belongs only to your current project. It keeps your project's dependencies separate from other projects and from the global Python installation.

**Why this matters:** If you install libraries globally, two projects that need different versions of the same library will conflict. Virtual environments solve this completely.

```mermaid
flowchart TD
    subgraph GLOBAL["Without virtual environment — conflicts"]
        G["Global Python<br/>pip install requests==2.28<br/>pip install requests==2.31<br/>❌ Only one version can exist"]
    end

    subgraph VENV["With virtual environments — isolated"]
        V1["Project A<br/>venv_a/<br/>requests==2.28<br/>fastapi==0.95"]
        V2["Project B<br/>venv_b/<br/>requests==2.31<br/>flask==3.0"]
        V3["Project C<br/>venv_c/<br/>requests==2.30<br/>django==4.2"]
    end
```

#### Step-by-step — create and use a virtual environment

**On Windows (VS Code terminal):**

```bash
# 1 — Create the virtual environment (creates a folder named "venv")
python -m venv venv

# 2 — Activate it
venv\Scripts\activate

# 3 — Your prompt changes to show (venv) — you are now inside
(venv) PS C:\my-project>

# 4 — Install packages (only installed inside this venv)
pip install requests fastapi uvicorn flask

# 5 — Save the list of dependencies
pip freeze > requirements.txt

# 6 — When done, deactivate
deactivate
```

**On macOS / Linux:**

```bash
python3 -m venv venv
source venv/bin/activate
pip install requests fastapi uvicorn flask
pip freeze > requirements.txt
deactivate
```

**In VS Code — select the interpreter:**
1. Press `Ctrl+Shift+P`
2. Type `Python: Select Interpreter`
3. Choose the one that shows `venv` in its path
4. VS Code will automatically activate the virtual environment in new terminals

#### What is `requirements.txt`?

When you run `pip freeze > requirements.txt`, it saves all installed packages with their exact versions:

```text
fastapi==0.115.0
requests==2.31.0
uvicorn==0.30.1
pydantic==2.7.4
```

Anyone who clones your project can then recreate the exact same environment with:

```bash
python -m venv venv
venv\Scripts\activate       # Windows
pip install -r requirements.txt
```

This guarantees that the project runs identically on every machine.

---

### Installation

```bash
pip install requests
```

---

### GET request — retrieve data

```python
import requests

# Simple GET
response = requests.get("https://jsonplaceholder.typicode.com/posts")

print(response.status_code)       # 200
print(response.headers["Content-Type"])  # application/json
print(len(response.json()))        # 100 posts
```

**With query parameters:**

```python
# GET with query params: /posts?userId=1&_limit=5
params = {"userId": 1, "_limit": 5}
response = requests.get(
    "https://jsonplaceholder.typicode.com/posts",
    params=params
)
print(response.url)  # https://jsonplaceholder.typicode.com/posts?userId=1&_limit=5
print(response.json())
```

---

### POST request — send data

```python
import requests

payload = {
    "title": "My new post",
    "body": "This is the content of the post.",
    "userId": 1
}

response = requests.post(
    "https://jsonplaceholder.typicode.com/posts",
    json=payload  # automatically sets Content-Type: application/json
)

print(response.status_code)  # 201
print(response.json())       # {"id": 101, "title": "My new post", ...}
```

---

### PUT and PATCH requests — update data

```python
import requests

# PUT — replace the entire resource
response = requests.put(
    "https://jsonplaceholder.typicode.com/posts/1",
    json={"title": "Updated title", "body": "Updated body", "userId": 1}
)
print(response.status_code)  # 200

# PATCH — update only specific fields
response = requests.patch(
    "https://jsonplaceholder.typicode.com/posts/1",
    json={"title": "Only the title changed"}
)
print(response.json())
```

---

### DELETE request — remove data

```python
import requests

response = requests.delete("https://jsonplaceholder.typicode.com/posts/1")
print(response.status_code)  # 200 or 204
```

---

### Sending headers

Headers are often needed for authentication, content negotiation, or custom metadata:

```python
import requests

headers = {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "Content-Type": "application/json",
    "Accept": "application/json"
}

response = requests.get(
    "https://httpbin.org/bearer",
    headers=headers
)
```

---

### Using a Session object

When making multiple requests to the same server, use a `Session` to reuse the TCP connection and share settings like headers and cookies:

```python
import requests

session = requests.Session()
session.headers.update({
    "Authorization": "Bearer my-token",
    "Accept": "application/json"
})

# All requests through this session will include the shared headers
r1 = session.get("https://jsonplaceholder.typicode.com/users")
r2 = session.get("https://jsonplaceholder.typicode.com/posts")
r3 = session.post("https://jsonplaceholder.typicode.com/todos", json={"title": "Buy milk", "completed": False})

session.close()
```

---

### Timeouts

Always set a timeout to prevent your code from hanging indefinitely if the server is slow or unreachable:

```python
import requests

try:
    response = requests.get(
        "https://httpbin.org/delay/2",  # simulates a slow server (2 second delay)
        timeout=5  # wait at most 5 seconds
    )
    response.raise_for_status()
    return response.json()
except requests.exceptions.Timeout:
    print("The request timed out after 5 seconds")
except requests.exceptions.ConnectionError:
    print("Failed to connect to the server")
```

---

### Complete request flow diagram

```mermaid
flowchart LR
    A["requests.get(url,<br/>params=...,<br/>headers=...,<br/>timeout=...)"] --> B["Build HTTP request"]
    B --> C["Send over network"]
    C --> D["Server processes<br/>request"]
    D --> E["HTTP Response<br/>status + headers + body"]
    E --> F["response.status_code<br/>response.headers<br/>response.json()<br/>response.text"]
```

---

## ✏️ Complete scripts — copy, paste, run in VS Code

The scripts below use [JSONPlaceholder](https://jsonplaceholder.typicode.com), a free public test API that accepts GET, POST, PUT, PATCH, and DELETE requests without any registration or API key.

---

### Script 1 — `01_get_demo.py`

Create this file in VS Code, then run it with `python 01_get_demo.py`.

```python
import requests

BASE_URL = "https://jsonplaceholder.typicode.com"

print("=" * 50)
print("GET /posts — retrieve all posts (first 3)")
print("=" * 50)
response = requests.get(f"{BASE_URL}/posts")
print(f"Status: {response.status_code}")
posts = response.json()
for post in posts[:3]:
    print(f"  [{post['id']}] {post['title'][:40]}...")

print()
print("=" * 50)
print("GET /posts/1 — retrieve a single post")
print("=" * 50)
response = requests.get(f"{BASE_URL}/posts/1")
print(f"Status: {response.status_code}")
post = response.json()
print(f"  Title : {post['title']}")
print(f"  Body  : {post['body'][:60]}...")
print(f"  UserId: {post['userId']}")

print()
print("=" * 50)
print("GET /posts?userId=1 — filter with query param")
print("=" * 50)
response = requests.get(f"{BASE_URL}/posts", params={"userId": 1})
print(f"Status: {response.status_code}")
filtered = response.json()
print(f"  Posts by user 1: {len(filtered)}")

print()
print("=" * 50)
print("GET /posts/9999 — resource that does not exist")
print("=" * 50)
response = requests.get(f"{BASE_URL}/posts/9999")
print(f"Status: {response.status_code}")
print(f"  Body: {response.text}")
```

**Expected output:**

```text
==================================================
GET /posts — retrieve all posts (first 3)
==================================================
Status: 200
  [1] sunt aut facere repellat provident occaecati...
  [2] qui est esse...
  [3] ea molestias quasi exercitationem repellat qu...

==================================================
GET /posts/1 — retrieve a single post
==================================================
Status: 200
  Title : sunt aut facere repellat provident occaecati excepturi reprehenderit
  Body  : quia et suscipit suscipit recusandae consequuntur expedita et cum...
  UserId: 1

==================================================
GET /posts?userId=1 — filter with query param
==================================================
Status: 200
  Posts by user 1: 10

==================================================
GET /posts/9999 — resource that does not exist
==================================================
Status: 404
  Body: {}
```

---

### Script 2 — `02_post_put_delete_demo.py`

```python
import requests

BASE_URL = "https://jsonplaceholder.typicode.com"

# ─────────────────────────────────────────────
# POST — create a new post
# ─────────────────────────────────────────────
print("=" * 50)
print("POST /posts — create a new resource")
print("=" * 50)
new_post = {
    "title": "My First API Post",
    "body": "This was created using the requests library in Python.",
    "userId": 1
}
response = requests.post(f"{BASE_URL}/posts", json=new_post)
print(f"Status: {response.status_code}")  # 201
created = response.json()
print(f"  Created ID : {created['id']}")
print(f"  Title      : {created['title']}")

# ─────────────────────────────────────────────
# PUT — replace a resource entirely
# ─────────────────────────────────────────────
print()
print("=" * 50)
print("PUT /posts/1 — replace the entire resource")
print("=" * 50)
updated_post = {
    "id": 1,
    "title": "Updated Title (PUT)",
    "body": "The entire post was replaced by PUT.",
    "userId": 1
}
response = requests.put(f"{BASE_URL}/posts/1", json=updated_post)
print(f"Status: {response.status_code}")  # 200
print(f"  Response: {response.json()}")

# ─────────────────────────────────────────────
# PATCH — update only specific fields
# ─────────────────────────────────────────────
print()
print("=" * 50)
print("PATCH /posts/1 — update only the title")
print("=" * 50)
patch_data = {"title": "Only the title was patched"}
response = requests.patch(f"{BASE_URL}/posts/1", json=patch_data)
print(f"Status: {response.status_code}")  # 200
print(f"  Response: {response.json()}")

# ─────────────────────────────────────────────
# DELETE — remove a resource
# ─────────────────────────────────────────────
print()
print("=" * 50)
print("DELETE /posts/1 — delete a resource")
print("=" * 50)
response = requests.delete(f"{BASE_URL}/posts/1")
print(f"Status: {response.status_code}")  # 200
print(f"  Body (should be empty): '{response.text}'")

# ─────────────────────────────────────────────
# Error handling example
# ─────────────────────────────────────────────
print()
print("=" * 50)
print("Error handling with raise_for_status()")
print("=" * 50)
try:
    response = requests.get(f"{BASE_URL}/posts/99999")
    response.raise_for_status()
    print("Success:", response.json())
except requests.exceptions.HTTPError as e:
    print(f"HTTP Error caught: {e.response.status_code}")
```

---

### 🧪 Test with Postman — section `requests`

Postman lets you send API requests visually, without writing code.

**Step 1 — Install Postman:** [https://www.postman.com/downloads/](https://www.postman.com/downloads/)

**Step 2 — Open Postman and create a new request**

Try the following requests one by one in Postman:

| # | Method | URL | Body (JSON) | Expected status |
|---|---|---|---|---|
| 1 | GET | `https://jsonplaceholder.typicode.com/posts` | — | 200 |
| 2 | GET | `https://jsonplaceholder.typicode.com/posts/1` | — | 200 |
| 3 | GET | `https://jsonplaceholder.typicode.com/posts?userId=2` | — | 200 |
| 4 | POST | `https://jsonplaceholder.typicode.com/posts` | `{"title":"Test","body":"Hello","userId":1}` | 201 |
| 5 | PUT | `https://jsonplaceholder.typicode.com/posts/1` | `{"id":1,"title":"Updated","body":"New body","userId":1}` | 200 |
| 6 | PATCH | `https://jsonplaceholder.typicode.com/posts/1` | `{"title":"Patched only"}` | 200 |
| 7 | DELETE | `https://jsonplaceholder.typicode.com/posts/1` | — | 200 |

**For POST/PUT/PATCH in Postman:**
1. Select the method (POST, PUT, etc.)
2. Enter the URL
3. Click the **Body** tab
4. Select **raw** → **JSON**
5. Paste the JSON body
6. Click **Send**

```mermaid
flowchart LR
    A["Open Postman"] --> B["New Request"]
    B --> C["Choose method<br/>GET / POST / PUT..."]
    C --> D["Enter URL"]
    D --> E["Add Body if needed<br/>raw → JSON"]
    E --> F["Click Send"]
    F --> G["See status code<br/>and response body"]
```

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-6"></a>

<details>
<summary>6 - FastAPI — Building an API</summary>

<br/>

FastAPI is a modern Python web framework for building APIs. It is built on top of **Starlette** (ASGI web framework) and **Pydantic** (data validation), and uses Python type hints to automatically generate request validation and interactive documentation.

FastAPI is one of the fastest Python frameworks available, thanks to its asynchronous design. It has become the preferred choice for ML and data science APIs because it integrates naturally with Python's scientific ecosystem.

```mermaid
flowchart LR
    A["Client<br/>sends request"] --> B["FastAPI<br/>router"]
    B --> C["Pydantic<br/>validation"]
    C --> D["Your function<br/>(endpoint)"]
    D --> E["Response<br/>JSON"]
    C -->|"Invalid data"| F["422 error<br/>automatically"]
```

---

### What is the `@` symbol — the decorator

When you write `@app.get("/students")` above a function in Python, the `@` symbol marks a **decorator**. A decorator is a special function that wraps another function to add behavior to it without modifying its code.

In simple terms: a decorator takes your function and registers it with the framework, associating it with a specific HTTP method and URL path.

```python
# This is what the decorator syntax looks like
@app.get("/students")
def list_students():
    return [{"id": 1, "name": "Alice"}]

# It is EXACTLY equivalent to writing this without the decorator:
def list_students():
    return [{"id": 1, "name": "Alice"}]

list_students = app.get("/students")(list_students)
# app.get("/students") returns a decorator function
# that decorator wraps list_students and registers it
```

The decorator syntax (`@`) is just a cleaner way to write this registration. When FastAPI sees `@app.get("/students")`, it:
1. Takes the function `list_students` that follows it
2. Registers it in its internal routing table as: "when someone sends `GET /students`, call this function"
3. Returns the function unchanged so it can still be called normally in tests

```mermaid
flowchart LR
    A["@app.get('/students')<br/>def list_students():..."] --> B["FastAPI routing table"]
    B --> R1["GET  /students  → list_students"]
    B --> R2["POST /students  → create_student"]
    B --> R3["GET  /students/{id}  → get_student"]

    C["Incoming request<br/>GET /students"] --> B
    B --> D["list_students() called<br/>Response returned"]
```

**The different decorators and what they do:**

| Decorator | HTTP Method | Typical use |
|---|---|---|
| `@app.get("/path")` | GET | Read / retrieve data |
| `@app.post("/path")` | POST | Create new resource |
| `@app.put("/path")` | PUT | Replace resource entirely |
| `@app.patch("/path")` | PATCH | Update specific fields |
| `@app.delete("/path")` | DELETE | Remove resource |

---

### Installation

```bash
pip install fastapi uvicorn
```

`uvicorn` is the ASGI server used to run FastAPI applications.

---

### Minimal FastAPI application

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}
```

Run it:

```bash
uvicorn main:app --reload
```

Then visit `http://127.0.0.1:8000` in your browser.

---

### GET endpoint with path parameter

A path parameter is a variable embedded directly in the URL path:

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/users/{user_id}")
def get_user(user_id: int):
    return {"user_id": user_id, "name": "Alice"}
```

FastAPI automatically:
* extracts `user_id` from the URL
* validates it as an integer
* returns a 422 error if it is not a valid integer

```bash
# Valid request
GET /users/42       → {"user_id": 42, "name": "Alice"}

# Invalid request
GET /users/hello    → 422 Unprocessable Entity
```

---

### GET endpoint with query parameters

Query parameters are defined as function parameters with default values:

```python
from fastapi import FastAPI
from typing import Optional

app = FastAPI()

@app.get("/items")
def list_items(skip: int = 0, limit: int = 10, category: Optional[str] = None):
    return {
        "skip": skip,
        "limit": limit,
        "category": category
    }
```

```bash
GET /items               → skip=0, limit=10, category=None
GET /items?limit=5       → skip=0, limit=5, category=None
GET /items?category=book → skip=0, limit=10, category="book"
```

---

### POST endpoint with Pydantic model

Pydantic models define the expected structure of request bodies. FastAPI uses them to automatically validate incoming JSON:

```python
from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional

app = FastAPI()

class UserCreate(BaseModel):
    name: str
    email: str
    age: Optional[int] = None

@app.post("/users", status_code=201)
def create_user(user: UserCreate):
    # user is already validated and typed
    return {
        "message": "User created",
        "user": user.model_dump()
    }
```

If the client sends invalid JSON (missing required field, wrong type), FastAPI automatically returns:

```json
{
  "detail": [
    {
      "loc": ["body", "email"],
      "msg": "field required",
      "type": "value_error.missing"
    }
  ]
}
```

---

### PUT and DELETE endpoints

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

fake_db = {1: {"name": "Alice", "email": "alice@example.com"}}

class UserUpdate(BaseModel):
    name: str
    email: str

@app.put("/users/{user_id}")
def update_user(user_id: int, user: UserUpdate):
    if user_id not in fake_db:
        raise HTTPException(status_code=404, detail="User not found")
    fake_db[user_id] = user.model_dump()
    return {"message": "User updated", "user": fake_db[user_id]}

@app.delete("/users/{user_id}", status_code=204)
def delete_user(user_id: int):
    if user_id not in fake_db:
        raise HTTPException(status_code=404, detail="User not found")
    del fake_db[user_id]
```

---

### Automatic interactive documentation

FastAPI automatically generates two interactive documentation interfaces:

| URL | Tool | Description |
|---|---|---|
| `http://127.0.0.1:8000/docs` | Swagger UI | Interactive documentation, test endpoints directly |
| `http://127.0.0.1:8000/redoc` | ReDoc | Read-only documentation, cleaner layout |

This is one of FastAPI's most powerful features: as you write code, the documentation is automatically kept up to date.

---

### Complete FastAPI application structure

```mermaid
flowchart TD
    A["main.py<br/>app = FastAPI()"] --> B["@app.get('/users')"]
    A --> C["@app.post('/users')"]
    A --> D["@app.put('/users/{id}')"]
    A --> E["@app.delete('/users/{id}')"]
    B --> F["Pydantic<br/>Response model"]
    C --> G["Pydantic<br/>Request model"]
    D --> G
    A --> H["Auto-generated<br/>/docs<br/>/redoc"]
```

---

### Dependency injection

FastAPI has a powerful dependency injection system. Dependencies are reusable functions that can be injected into endpoints:

```python
from fastapi import FastAPI, Depends, HTTPException, Header
from typing import Optional

app = FastAPI()

def verify_token(authorization: Optional[str] = Header(None)):
    if authorization != "Bearer secret-token":
        raise HTTPException(status_code=401, detail="Invalid token")
    return authorization

@app.get("/protected")
def protected_route(token: str = Depends(verify_token)):
    return {"message": "Access granted"}
```

---

## ✏️ Complete scripts — copy, paste, run in VS Code

### Step 1 — Install the dependencies

Open a terminal in VS Code (`Ctrl + `` ` ``) and run:

```bash
pip install fastapi uvicorn
```

---

### Step 2 — Create `fastapi_demo.py`

Copy and paste the entire file below into VS Code:

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional, List

app = FastAPI(
    title="Student Demo API",
    description="A complete FastAPI demo with GET, POST, PUT, PATCH, DELETE",
    version="1.0.0"
)

# ─────────────────────────────────────────────────────────────────
# In-memory database (a simple Python dict)
# ─────────────────────────────────────────────────────────────────
students_db = {
    1: {"id": 1, "name": "Alice", "grade": 90, "active": True},
    2: {"id": 2, "name": "Bob",   "grade": 75, "active": True},
    3: {"id": 3, "name": "Carol", "grade": 88, "active": False},
}
next_id = 4

# ─────────────────────────────────────────────────────────────────
# Pydantic models — define the shape of request/response bodies
# ─────────────────────────────────────────────────────────────────
class StudentCreate(BaseModel):
    name: str
    grade: float
    active: bool = True

class StudentUpdate(BaseModel):
    name: Optional[str] = None
    grade: Optional[float] = None
    active: Optional[bool] = None

# ─────────────────────────────────────────────────────────────────
# Root endpoint
# ─────────────────────────────────────────────────────────────────
@app.get("/")
def root():
    return {
        "message": "Welcome to the Student Demo API",
        "docs": "Open http://127.0.0.1:8000/docs to explore all endpoints"
    }

# ─────────────────────────────────────────────────────────────────
# GET /students — list all students (optional filter by active)
# ─────────────────────────────────────────────────────────────────
@app.get("/students")
def list_students(active: Optional[bool] = None):
    all_students = list(students_db.values())
    if active is not None:
        all_students = [s for s in all_students if s["active"] == active]
    return {"count": len(all_students), "students": all_students}

# ─────────────────────────────────────────────────────────────────
# GET /students/{student_id} — get one student by ID
# ─────────────────────────────────────────────────────────────────
@app.get("/students/{student_id}")
def get_student(student_id: int):
    if student_id not in students_db:
        raise HTTPException(status_code=404, detail=f"Student {student_id} not found")
    return students_db[student_id]

# ─────────────────────────────────────────────────────────────────
# POST /students — create a new student
# ─────────────────────────────────────────────────────────────────
@app.post("/students", status_code=201)
def create_student(student: StudentCreate):
    global next_id
    new_student = {"id": next_id, **student.model_dump()}
    students_db[next_id] = new_student
    next_id += 1
    return new_student

# ─────────────────────────────────────────────────────────────────
# PUT /students/{student_id} — replace a student entirely
# ─────────────────────────────────────────────────────────────────
@app.put("/students/{student_id}")
def replace_student(student_id: int, student: StudentCreate):
    if student_id not in students_db:
        raise HTTPException(status_code=404, detail=f"Student {student_id} not found")
    students_db[student_id] = {"id": student_id, **student.model_dump()}
    return students_db[student_id]

# ─────────────────────────────────────────────────────────────────
# PATCH /students/{student_id} — update specific fields only
# ─────────────────────────────────────────────────────────────────
@app.patch("/students/{student_id}")
def update_student(student_id: int, update: StudentUpdate):
    if student_id not in students_db:
        raise HTTPException(status_code=404, detail=f"Student {student_id} not found")
    for field, value in update.model_dump(exclude_none=True).items():
        students_db[student_id][field] = value
    return students_db[student_id]

# ─────────────────────────────────────────────────────────────────
# DELETE /students/{student_id} — delete a student
# ─────────────────────────────────────────────────────────────────
@app.delete("/students/{student_id}", status_code=204)
def delete_student(student_id: int):
    if student_id not in students_db:
        raise HTTPException(status_code=404, detail=f"Student {student_id} not found")
    del students_db[student_id]
```

---

### Step 3 — Start the server

In the VS Code terminal:

```bash
uvicorn fastapi_demo:app --reload
```

You should see:

```text
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process
INFO:     Application startup complete.
```

**Keep this terminal open.** The server must stay running while you test.

---

### Step 4 — Open the automatic documentation

Open your browser and go to:

```
http://127.0.0.1:8000/docs
```

You will see the **Swagger UI** — an interactive page that lists every endpoint. You can click any endpoint, click **"Try it out"**, fill in the values, and click **"Execute"** to send a real request without writing any code.

---

### Step 5 — Create `fastapi_client.py` to test with `requests`

```python
import requests

BASE_URL = "http://127.0.0.1:8000"

print("=" * 55)
print("1 — GET /  (root)")
print("=" * 55)
r = requests.get(f"{BASE_URL}/")
print(r.status_code, r.json())

print()
print("=" * 55)
print("2 — GET /students  (list all)")
print("=" * 55)
r = requests.get(f"{BASE_URL}/students")
print(r.status_code)
for s in r.json()["students"]:
    print(f"  {s}")

print()
print("=" * 55)
print("3 — GET /students?active=true  (filter active)")
print("=" * 55)
r = requests.get(f"{BASE_URL}/students", params={"active": True})
print(r.status_code, r.json())

print()
print("=" * 55)
print("4 — GET /students/1  (single student)")
print("=" * 55)
r = requests.get(f"{BASE_URL}/students/1")
print(r.status_code, r.json())

print()
print("=" * 55)
print("5 — GET /students/999  (not found — 404)")
print("=" * 55)
r = requests.get(f"{BASE_URL}/students/999")
print(r.status_code, r.json())

print()
print("=" * 55)
print("6 — POST /students  (create new)")
print("=" * 55)
new_student = {"name": "David", "grade": 92.5, "active": True}
r = requests.post(f"{BASE_URL}/students", json=new_student)
print(r.status_code, r.json())
new_id = r.json()["id"]

print()
print("=" * 55)
print("7 — PUT /students/{id}  (replace entirely)")
print("=" * 55)
replacement = {"name": "David Updated", "grade": 95.0, "active": True}
r = requests.put(f"{BASE_URL}/students/{new_id}", json=replacement)
print(r.status_code, r.json())

print()
print("=" * 55)
print("8 — PATCH /students/{id}  (update grade only)")
print("=" * 55)
r = requests.patch(f"{BASE_URL}/students/{new_id}", json={"grade": 99.0})
print(r.status_code, r.json())

print()
print("=" * 55)
print("9 — DELETE /students/{id}")
print("=" * 55)
r = requests.delete(f"{BASE_URL}/students/{new_id}")
print(f"Status: {r.status_code} (204 = deleted, no body)")

print()
print("=" * 55)
print("10 — POST with invalid data (missing required field)")
print("=" * 55)
r = requests.post(f"{BASE_URL}/students", json={"name": "Incomplete"})
print(r.status_code, r.json())
```

Run it in a **second terminal** (keep the server running in the first):

```bash
python fastapi_client.py
```

---

### 🧪 Test with Postman — FastAPI server

Make sure `uvicorn fastapi_demo:app --reload` is running, then try each request below in Postman.

**How to set a JSON body in Postman:**
1. Click **Body** tab
2. Select **raw**
3. Select **JSON** from the dropdown on the right
4. Paste the JSON

| # | Method | URL | JSON Body | Expected status |
|---|---|---|---|---|
| 1 | GET | `http://127.0.0.1:8000/` | — | 200 |
| 2 | GET | `http://127.0.0.1:8000/students` | — | 200 |
| 3 | GET | `http://127.0.0.1:8000/students?active=true` | — | 200 |
| 4 | GET | `http://127.0.0.1:8000/students/1` | — | 200 |
| 5 | GET | `http://127.0.0.1:8000/students/999` | — | 404 |
| 6 | POST | `http://127.0.0.1:8000/students` | `{"name": "Eve", "grade": 85, "active": true}` | 201 |
| 7 | PUT | `http://127.0.0.1:8000/students/4` | `{"name": "Eve Updated", "grade": 90, "active": true}` | 200 |
| 8 | PATCH | `http://127.0.0.1:8000/students/4` | `{"grade": 95}` | 200 |
| 9 | DELETE | `http://127.0.0.1:8000/students/4` | — | 204 |
| 10 | POST | `http://127.0.0.1:8000/students` | `{"name": "Missing grade field"}` | 422 |

> **Tip:** After test #6 (POST), use the `id` returned in the response for tests #7, #8, and #9.

> **Shortcut:** Instead of Postman, you can also test directly at `http://127.0.0.1:8000/docs` — FastAPI's built-in Swagger UI does the same thing in your browser with no extra tools.

```mermaid
flowchart TD
    A["Start FastAPI server<br/>uvicorn fastapi_demo:app --reload"] --> B{"How to test?"}
    B --> C["Postman<br/>Manual GUI testing<br/>Good for exploring"]
    B --> D["fastapi_client.py<br/>Automatic scripted tests<br/>Good for repeating"]
    B --> E["http://127.0.0.1:8000/docs<br/>Built-in Swagger UI<br/>Instant, no setup"]
    C --> F["Check status code<br/>and response body"]
    D --> F
    E --> F
```

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-7"></a>

<details>
<summary>7 - Flask — Building an API</summary>

<br/>

Flask is a lightweight Python web framework. Unlike FastAPI, Flask does not include data validation, async support, or automatic documentation by default — it is a "micro" framework that gives you the basics and lets you add only what you need.

Flask has been around since 2010 and has a large ecosystem of extensions. It is widely used in web development, prototyping, and API building.

```mermaid
flowchart LR
    A["Client<br/>request"] --> B["Flask<br/>router<br/>@app.route()"]
    B --> C["Your function"]
    C --> D["jsonify()<br/>return JSON response"]
    D --> E["Client<br/>receives JSON"]
```

---

### What is `@app.route()` in Flask?

In Flask, `@app.route("/path", methods=["GET", "POST"])` is a decorator (just like `@app.get()` in FastAPI) that registers a function as the handler for a specific URL path and list of HTTP methods.

The key difference from FastAPI is that in Flask you specify all allowed methods in a single list:

```python
# Flask — method is declared inside the decorator
@app.route("/students", methods=["GET"])
def list_students():
    ...

@app.route("/students", methods=["POST"])
def create_student():
    ...

# Or both methods on the same function:
@app.route("/students", methods=["GET", "POST"])
def students():
    if request.method == "GET":
        return get_all()
    elif request.method == "POST":
        return create_new()
```

In **FastAPI**, the method is part of the decorator name (`@app.get`, `@app.post`, etc.) so each method always has its own function. In **Flask**, the same decorator `@app.route()` handles everything, and you pass the allowed methods as a list.

---

### What is `jsonify()`?

When a Flask function returns data, Python objects like dictionaries and lists cannot be sent directly over HTTP — HTTP only transfers text. `jsonify()` converts a Python dictionary or list into a proper **JSON string** and sets the `Content-Type: application/json` header automatically.

```python
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/example")
def example():
    data = {"name": "Alice", "grade": 90}

    # ❌ Do NOT do this — returns a Python dict as a string, no proper headers
    return str(data)

    # ✅ Do this — returns valid JSON with correct Content-Type header
    return jsonify(data)
```

The difference matters because clients (browsers, `requests`, Postman) expect:
* the body to be valid JSON text (double quotes, not single quotes)
* the `Content-Type: application/json` header so they know how to parse it

`jsonify()` handles both automatically.

```mermaid
flowchart LR
    A["Python dict<br/>{'name': 'Alice', 'grade': 90}"] --> B["jsonify()"]
    B --> C["JSON string<br/>'{\"name\": \"Alice\", \"grade\": 90}'"]
    B --> D["Header set:<br/>Content-Type: application/json"]
    C --> E["HTTP Response<br/>sent to client"]
    D --> E
```

---

### What is `request.get_json()`?

When a client sends a POST or PUT request with a JSON body, Flask does not parse it automatically. You must call `request.get_json()` to read and parse the JSON body into a Python dictionary.

```python
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/students", methods=["POST"])
def create_student():
    # request.get_json() reads the body and converts it to a Python dict
    data = request.get_json()

    # data is now a Python dictionary:
    # {"name": "Alice", "grade": 90}

    if data is None:
        return jsonify({"error": "Body must be JSON"}), 400

    name = data.get("name")   # safe access with .get()
    grade = data.get("grade")

    if not name or grade is None:
        return jsonify({"error": "name and grade are required"}), 400

    return jsonify({"message": "Created", "name": name, "grade": grade}), 201
```

`request.get_json()` returns `None` if:
* the body is empty
* the `Content-Type` header is not `application/json`
* the body is not valid JSON

This is why manual validation is needed in Flask — FastAPI handles this automatically via Pydantic.

| Task | Flask | FastAPI |
|---|---|---|
| Parse JSON body | `request.get_json()` — manual | Pydantic model — automatic |
| Return JSON | `jsonify(data)` — explicit | `return dict` — automatic |
| Validate required fields | Manual `if` checks | Pydantic raises 422 automatically |
| Set status code | `return jsonify(data), 201` | `status_code=201` in decorator |

---

### Installation

```bash
pip install flask
```

---

### Minimal Flask application

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "Hello, World!"

if __name__ == "__main__":
    app.run(debug=True)
```

Run it:

```bash
python app.py
```

Then visit `http://127.0.0.1:5000`.

---

### GET endpoint returning JSON

Flask uses `jsonify()` to return proper JSON responses:

```python
from flask import Flask, jsonify

app = Flask(__name__)

users = [
    {"id": 1, "name": "Alice"},
    {"id": 2, "name": "Bob"}
]

@app.route("/users", methods=["GET"])
def get_users():
    return jsonify(users), 200

@app.route("/users/<int:user_id>", methods=["GET"])
def get_user(user_id):
    user = next((u for u in users if u["id"] == user_id), None)
    if user is None:
        return jsonify({"error": "User not found"}), 404
    return jsonify(user), 200
```

---

### POST endpoint — receive JSON data

```python
from flask import Flask, jsonify, request

app = Flask(__name__)

users = []

@app.route("/users", methods=["POST"])
def create_user():
    data = request.get_json()

    # Manual validation (Flask does not validate automatically)
    if not data or "name" not in data or "email" not in data:
        return jsonify({"error": "name and email are required"}), 400

    new_user = {
        "id": len(users) + 1,
        "name": data["name"],
        "email": data["email"]
    }
    users.append(new_user)
    return jsonify(new_user), 201
```

---

### PUT and DELETE endpoints

```python
from flask import Flask, jsonify, request

app = Flask(__name__)

users = {1: {"name": "Alice", "email": "alice@example.com"}}

@app.route("/users/<int:user_id>", methods=["PUT"])
def update_user(user_id):
    if user_id not in users:
        return jsonify({"error": "User not found"}), 404
    data = request.get_json()
    users[user_id] = {"name": data["name"], "email": data["email"]}
    return jsonify(users[user_id]), 200

@app.route("/users/<int:user_id>", methods=["DELETE"])
def delete_user(user_id):
    if user_id not in users:
        return jsonify({"error": "User not found"}), 404
    del users[user_id]
    return "", 204
```

---

### Flask with `flask-restful` extension

The `flask-restful` extension provides a cleaner, class-based way to build REST APIs in Flask:

```bash
pip install flask-restful
```

```python
from flask import Flask
from flask_restful import Api, Resource, reqparse

app = Flask(__name__)
api = Api(app)

parser = reqparse.RequestParser()
parser.add_argument("name", required=True, help="Name is required")
parser.add_argument("email", required=True, help="Email is required")

users = {}

class UserList(Resource):
    def get(self):
        return list(users.values()), 200

    def post(self):
        args = parser.parse_args()
        user_id = len(users) + 1
        users[user_id] = {"id": user_id, "name": args["name"], "email": args["email"]}
        return users[user_id], 201

class User(Resource):
    def get(self, user_id):
        if user_id not in users:
            return {"error": "Not found"}, 404
        return users[user_id], 200

    def delete(self, user_id):
        if user_id not in users:
            return {"error": "Not found"}, 404
        del users[user_id]
        return "", 204

api.add_resource(UserList, "/users")
api.add_resource(User, "/users/<int:user_id>")

if __name__ == "__main__":
    app.run(debug=True)
```

---

### Flask project structure

A typical Flask API project looks like this:

```text
my_flask_api/
├── app.py              ← application entry point
├── routes/
│   ├── users.py        ← user-related endpoints
│   └── products.py     ← product-related endpoints
├── models/
│   └── user.py         ← data structures
├── requirements.txt
└── README.md
```

---

## ✏️ Complete script — copy, paste, run in VS Code

### Step 1 — Install dependencies

```bash
pip install flask
```

### Step 2 — Create `flask_demo.py`

```python
from flask import Flask, jsonify, request

app = Flask(__name__)

# ─────────────────────────────────────────────────────────────────
# In-memory data store
# ─────────────────────────────────────────────────────────────────
products = {
    1: {"id": 1, "name": "Laptop",  "price": 999.99, "in_stock": True},
    2: {"id": 2, "name": "Mouse",   "price":  29.99, "in_stock": True},
    3: {"id": 3, "name": "Monitor", "price": 349.99, "in_stock": False},
}
next_id = 4

# ─────────────────────────────────────────────────────────────────
# Root
# ─────────────────────────────────────────────────────────────────
@app.route("/")
def root():
    return jsonify({
        "message": "Flask Product API",
        "endpoints": ["/products", "/products/<id>"]
    })

# ─────────────────────────────────────────────────────────────────
# GET /products — list all, with optional ?in_stock=true filter
# ─────────────────────────────────────────────────────────────────
@app.route("/products", methods=["GET"])
def list_products():
    in_stock_param = request.args.get("in_stock")  # query param
    result = list(products.values())
    if in_stock_param is not None:
        in_stock = in_stock_param.lower() == "true"
        result = [p for p in result if p["in_stock"] == in_stock]
    return jsonify({"count": len(result), "products": result}), 200

# ─────────────────────────────────────────────────────────────────
# GET /products/<id> — single product
# ─────────────────────────────────────────────────────────────────
@app.route("/products/<int:product_id>", methods=["GET"])
def get_product(product_id):
    if product_id not in products:
        return jsonify({"error": f"Product {product_id} not found"}), 404
    return jsonify(products[product_id]), 200

# ─────────────────────────────────────────────────────────────────
# POST /products — create new product
# ─────────────────────────────────────────────────────────────────
@app.route("/products", methods=["POST"])
def create_product():
    global next_id
    data = request.get_json()

    if not data:
        return jsonify({"error": "Request body must be JSON"}), 400

    # Manual validation (Flask does not do this automatically)
    missing = [f for f in ["name", "price"] if f not in data]
    if missing:
        return jsonify({"error": f"Missing required fields: {missing}"}), 400

    new_product = {
        "id": next_id,
        "name": data["name"],
        "price": float(data["price"]),
        "in_stock": data.get("in_stock", True)
    }
    products[next_id] = new_product
    next_id += 1
    return jsonify(new_product), 201

# ─────────────────────────────────────────────────────────────────
# PUT /products/<id> — replace entirely
# ─────────────────────────────────────────────────────────────────
@app.route("/products/<int:product_id>", methods=["PUT"])
def replace_product(product_id):
    if product_id not in products:
        return jsonify({"error": "Not found"}), 404
    data = request.get_json()
    if not data:
        return jsonify({"error": "Request body must be JSON"}), 400
    products[product_id] = {
        "id": product_id,
        "name": data["name"],
        "price": float(data["price"]),
        "in_stock": data.get("in_stock", True)
    }
    return jsonify(products[product_id]), 200

# ─────────────────────────────────────────────────────────────────
# PATCH /products/<id> — partial update
# ─────────────────────────────────────────────────────────────────
@app.route("/products/<int:product_id>", methods=["PATCH"])
def update_product(product_id):
    if product_id not in products:
        return jsonify({"error": "Not found"}), 404
    data = request.get_json() or {}
    for key in ["name", "price", "in_stock"]:
        if key in data:
            products[product_id][key] = data[key]
    return jsonify(products[product_id]), 200

# ─────────────────────────────────────────────────────────────────
# DELETE /products/<id>
# ─────────────────────────────────────────────────────────────────
@app.route("/products/<int:product_id>", methods=["DELETE"])
def delete_product(product_id):
    if product_id not in products:
        return jsonify({"error": "Not found"}), 404
    del products[product_id]
    return "", 204

# ─────────────────────────────────────────────────────────────────
# Custom error handlers
# ─────────────────────────────────────────────────────────────────
@app.errorhandler(404)
def not_found(e):
    return jsonify({"error": "Route not found"}), 404

@app.errorhandler(405)
def method_not_allowed(e):
    return jsonify({"error": "Method not allowed on this route"}), 405

if __name__ == "__main__":
    app.run(debug=True, port=5000)
```

### Step 3 — Start the server

```bash
python flask_demo.py
```

You should see:

```text
 * Running on http://127.0.0.1:5000
 * Debug mode: on
 * Restarting with stat
```

### Step 4 — Create `flask_client.py`

```python
import requests

BASE_URL = "http://127.0.0.1:5000"

print("=" * 55)
print("GET / — root")
r = requests.get(f"{BASE_URL}/")
print(r.status_code, r.json())

print("\nGET /products — all products")
r = requests.get(f"{BASE_URL}/products")
print(r.status_code, r.json())

print("\nGET /products?in_stock=false — out of stock only")
r = requests.get(f"{BASE_URL}/products", params={"in_stock": "false"})
print(r.status_code, r.json())

print("\nGET /products/1 — single product")
r = requests.get(f"{BASE_URL}/products/1")
print(r.status_code, r.json())

print("\nGET /products/999 — not found")
r = requests.get(f"{BASE_URL}/products/999")
print(r.status_code, r.json())

print("\nPOST /products — create")
r = requests.post(f"{BASE_URL}/products",
    json={"name": "Keyboard", "price": 79.99, "in_stock": True})
print(r.status_code, r.json())
new_id = r.json()["id"]

print(f"\nPATCH /products/{new_id} — update price only")
r = requests.patch(f"{BASE_URL}/products/{new_id}", json={"price": 69.99})
print(r.status_code, r.json())

print(f"\nDELETE /products/{new_id}")
r = requests.delete(f"{BASE_URL}/products/{new_id}")
print(f"Status: {r.status_code}")  # 204

print("\nPOST with missing fields — validation error")
r = requests.post(f"{BASE_URL}/products", json={"name": "Incomplete"})
print(r.status_code, r.json())
```

---

### 🧪 Test with Postman — Flask server

Make sure `python flask_demo.py` is running, then test these requests:

| # | Method | URL | JSON Body | Expected status |
|---|---|---|---|---|
| 1 | GET | `http://127.0.0.1:5000/` | — | 200 |
| 2 | GET | `http://127.0.0.1:5000/products` | — | 200 |
| 3 | GET | `http://127.0.0.1:5000/products?in_stock=false` | — | 200 |
| 4 | GET | `http://127.0.0.1:5000/products/1` | — | 200 |
| 5 | GET | `http://127.0.0.1:5000/products/999` | — | 404 |
| 6 | POST | `http://127.0.0.1:5000/products` | `{"name":"Headphones","price":149.99,"in_stock":true}` | 201 |
| 7 | PUT | `http://127.0.0.1:5000/products/4` | `{"name":"Headphones Pro","price":199.99,"in_stock":true}` | 200 |
| 8 | PATCH | `http://127.0.0.1:5000/products/4` | `{"price":179.99}` | 200 |
| 9 | DELETE | `http://127.0.0.1:5000/products/4` | — | 204 |
| 10 | POST | `http://127.0.0.1:5000/products` | `{"name":"No price field"}` | 400 |

---

### Differences from FastAPI

| Feature | Flask | FastAPI |
|---|---|---|
| Data validation | Manual (use Marshmallow or WTForms) | Automatic via Pydantic |
| Documentation | No built-in (use Flasgger) | Built-in Swagger + ReDoc |
| Async support | Limited (with async Flask) | Native async support |
| Speed | Moderate | Very fast (ASGI) |
| Learning curve | Lower | Slightly higher |
| Community age | Since 2010, large ecosystem | Since 2018, growing fast |

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-8"></a>

<details>
<summary>8 - Django REST Framework — Overview</summary>

<br/>

**Django** is a full-stack Python web framework that follows the "batteries included" philosophy. It provides an ORM (database layer), authentication, admin panel, template engine, forms, and many other features out of the box. It is one of the most mature and widely used Python web frameworks, powering sites like Instagram, Pinterest, and Disqus.

**Django REST Framework (DRF)** is an extension for Django that adds powerful tools for building REST APIs on top of Django's foundation.

```mermaid
flowchart TD
    A["Django"] --> B["ORM<br/>(Database layer)"]
    A --> C["Auth system<br/>(built-in)"]
    A --> D["Admin panel<br/>(built-in)"]
    A --> E["Django REST<br/>Framework"]
    E --> F["Serializers<br/>(like Pydantic)"]
    E --> G["ViewSets<br/>(CRUD endpoints)"]
    E --> H["Browsable API<br/>(documentation)"]
    E --> I["Permissions<br/>& Throttling"]
```

---

### When to use Django over FastAPI or Flask

| Use case | Recommended framework |
|---|---|
| Large application with complex database models | Django + DRF |
| Microservice or ML API | FastAPI |
| Small prototype or script-based API | Flask |
| Application that needs an admin panel | Django |
| High-performance async API | FastAPI |
| Team already knows Django | Django + DRF |

---

### Installation

```bash
pip install django djangorestframework
```

---

### A minimal DRF API

```python
# settings.py — add to INSTALLED_APPS
INSTALLED_APPS = [
    ...
    'rest_framework',
]
```

```python
# models.py
from django.db import models

class Book(models.Model):
    title = models.CharField(max_length=200)
    author = models.CharField(max_length=100)
    published_year = models.IntegerField()
```

```python
# serializers.py
from rest_framework import serializers
from .models import Book

class BookSerializer(serializers.ModelSerializer):
    class Meta:
        model = Book
        fields = ["id", "title", "author", "published_year"]
```

```python
# views.py
from rest_framework import viewsets
from .models import Book
from .serializers import BookSerializer

class BookViewSet(viewsets.ModelViewSet):
    queryset = Book.objects.all()
    serializer_class = BookSerializer
```

```python
# urls.py
from rest_framework.routers import DefaultRouter
from .views import BookViewSet

router = DefaultRouter()
router.register(r"books", BookViewSet)
urlpatterns = router.urls
```

With these few files, DRF automatically creates all CRUD endpoints:

| Method | URL | Action |
|---|---|---|
| GET | `/books/` | List all books |
| POST | `/books/` | Create a book |
| GET | `/books/1/` | Get book with id=1 |
| PUT | `/books/1/` | Update book id=1 |
| DELETE | `/books/1/` | Delete book id=1 |

---

### Key DRF concepts

**Serializers** in DRF are similar to Pydantic models in FastAPI. They define how data is converted between Python objects and JSON, and they perform validation.

**ViewSets** group related endpoint logic into a single class. A `ModelViewSet` automatically provides list, create, retrieve, update, and destroy actions.

**Routers** automatically generate URL patterns from ViewSets, so you do not need to write URL patterns manually.

**Browsable API** is DRF's built-in HTML interface that lets you interact with the API directly in a browser — similar to FastAPI's Swagger UI but rendered in a more traditional style.

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-9"></a>

<details>
<summary>9 - FastAPI vs Flask vs Django — Comparison</summary>

<br/>

Choosing the right framework depends on the size of the project, the team's experience, performance requirements, and available time.

```mermaid
flowchart TD
    A{"What are<br/>you building?"}
    A -->|"ML / AI API<br/>Microservice<br/>High performance"| B["FastAPI"]
    A -->|"Small prototype<br/>Simple REST API<br/>Minimal dependencies"| C["Flask"]
    A -->|"Full application<br/>Complex DB<br/>Admin panel needed"| D["Django + DRF"]
```

---

### Side-by-side comparison

| Feature | FastAPI | Flask | Django + DRF |
|---|---|---|---|
| **Type** | API framework | Micro web framework | Full-stack web framework |
| **Year created** | 2018 | 2010 | 2005 |
| **Data validation** | Automatic (Pydantic) | Manual | Built-in (Serializers) |
| **ORM (database)** | Not included | Not included | Built-in |
| **Admin panel** | Not included | Not included | Built-in |
| **Authentication** | Not included | Not included | Built-in |
| **Auto docs** | Yes (Swagger + ReDoc) | No (extensions needed) | Yes (Browsable API) |
| **Async support** | Native | Limited | Limited |
| **Performance** | Very high | Moderate | Moderate |
| **Learning curve** | Medium | Low | High |
| **Best for** | APIs, ML services | Prototypes, small APIs | Large applications |

---

### Performance comparison

FastAPI's asynchronous architecture makes it significantly faster than Flask and Django for I/O-bound workloads like database queries or external API calls:

```mermaid
flowchart LR
    subgraph PERF["Relative performance (requests/sec)"]
        F["FastAPI<br/>~50,000 req/s"]
        FL["Flask<br/>~10,000 req/s"]
        D["Django<br/>~8,000 req/s"]
    end
```

Note: performance depends heavily on the specific workload, hardware, and implementation. These are approximate comparisons for simple JSON endpoints.

---

### Code comparison — same POST endpoint

**FastAPI:**

```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):
    name: str
    price: float

@app.post("/items", status_code=201)
def create_item(item: Item):
    return item
```

**Flask:**

```python
from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route("/items", methods=["POST"])
def create_item():
    data = request.get_json()
    if not data or "name" not in data or "price" not in data:
        return jsonify({"error": "Invalid data"}), 400
    return jsonify(data), 201
```

**Django REST Framework:**

```python
from rest_framework import serializers, viewsets
from rest_framework.response import Response
from rest_framework import status

class ItemSerializer(serializers.Serializer):
    name = serializers.CharField()
    price = serializers.FloatField()

class ItemViewSet(viewsets.ViewSet):
    def create(self, request):
        serializer = ItemSerializer(data=request.data)
        if serializer.is_valid():
            return Response(serializer.validated_data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
```

Notice how FastAPI requires the least amount of code for the same level of functionality, while also providing automatic validation and documentation.

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-10"></a>

<details>
<summary>10 - Authentication in APIs</summary>

<br/>

Authentication is how an API verifies the identity of the caller. Most production APIs require some form of authentication to prevent unauthorized access. There are several common authentication methods, each with different trade-offs.

```mermaid
flowchart LR
    A["API Authentication<br/>methods"] --> B["API Key<br/>Simple, static token"]
    A --> C["Bearer Token<br/>JWT — stateless"]
    A --> D["Basic Auth<br/>Username + password<br/>Base64 encoded"]
    A --> E["OAuth 2.0<br/>Third-party authorization"]
```

---

### API Key authentication

An API key is a simple string token that identifies the caller. It is usually sent in the request header.

**Sending an API key with `requests`:**

```python
import requests

headers = {
    "X-API-Key": "your-secret-api-key-here"
}

response = requests.get(
    "https://httpbin.org/get",
    headers=headers
)
```

**Validating an API key in FastAPI:**

```python
from fastapi import FastAPI, Security, HTTPException
from fastapi.security import APIKeyHeader

app = FastAPI()

API_KEY = "my-secret-key"
api_key_header = APIKeyHeader(name="X-API-Key")

def verify_api_key(key: str = Security(api_key_header)):
    if key != API_KEY:
        raise HTTPException(status_code=403, detail="Invalid API key")
    return key

@app.get("/protected")
def protected(key: str = Security(verify_api_key)):
    return {"message": "Access granted"}
```

---

### Bearer Token (JWT)

A **JWT** (JSON Web Token) is a signed token that encodes user information. The server issues the token at login. The client sends it with every subsequent request.

```mermaid
sequenceDiagram
    participant C as Client
    participant A as Auth endpoint
    participant P as Protected endpoint

    C->>A: POST /login {username, password}
    A-->>C: 200 OK {token: "eyJhbGci..."}
    C->>P: GET /profile<br/>Authorization: Bearer eyJhbGci...
    P->>P: Verify JWT signature
    P-->>C: 200 OK {user data}
```

**Sending a Bearer token with `requests`:**

```python
import requests

# Step 1: login to get a token
login_response = requests.post(
    "http://127.0.0.1:8000/login",
    json={"username": "alice", "password": "secret"}
)
token = login_response.json()["access_token"]

# Step 2: use the token for protected endpoints
headers = {"Authorization": f"Bearer {token}"}
response = requests.get("http://127.0.0.1:8000/profile", headers=headers)
print(response.json())
```

**Implementing JWT in FastAPI with `python-jose`:**

```bash
pip install python-jose passlib
```

```python
from fastapi import FastAPI, HTTPException, Depends
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import jwt, JWTError
from datetime import datetime, timedelta

SECRET_KEY = "your-secret-key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

app = FastAPI()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

def create_access_token(data: dict):
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    data.update({"exp": expire})
    return jwt.encode(data, SECRET_KEY, algorithm=ALGORITHM)

@app.post("/token")
def login(form: OAuth2PasswordRequestForm = Depends()):
    if form.username == "alice" and form.password == "secret":
        token = create_access_token({"sub": form.username})
        return {"access_token": token, "token_type": "bearer"}
    raise HTTPException(status_code=401, detail="Invalid credentials")

@app.get("/me")
def get_current_user(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username = payload.get("sub")
        return {"username": username}
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")
```

---

### Basic authentication

Basic Auth sends the username and password encoded in Base64 inside the `Authorization` header. It should only be used over HTTPS.

```python
import requests

response = requests.get(
    "https://httpbin.org/basic-auth/alice/my-password",
    auth=("alice", "my-password")  # requests handles Base64 encoding
)
```

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-11"></a>

<details>
<summary>11 - Error Handling</summary>

<br/>

Proper error handling is a critical part of building and consuming APIs. Errors are unavoidable — networks fail, data is invalid, resources disappear. A well-designed API communicates errors clearly, and a well-written client handles them gracefully.

---

### Error handling on the client side (with `requests`)

```python
import requests
from requests.exceptions import (
    HTTPError,
    ConnectionError,
    Timeout,
    RequestException
)

def call_api(url: str, payload: dict):
    try:
        response = requests.post(url, json=payload, timeout=10)

        # Raise an exception for 4xx and 5xx status codes
        response.raise_for_status()

        return response.json()

    except HTTPError as e:
        status = e.response.status_code
        if status == 400:
            print(f"Bad request: {e.response.json()}")
        elif status == 401:
            print("Authentication required")
        elif status == 403:
            print("Access denied")
        elif status == 404:
            print("Resource not found")
        elif status == 422:
            print(f"Validation error: {e.response.json()['detail']}")
        elif status >= 500:
            print(f"Server error ({status}), try again later")

    except ConnectionError:
        print("Could not connect to the server")

    except Timeout:
        print("Request timed out")

    except RequestException as e:
        print(f"Unexpected error: {e}")

    return None
```

---

### Error handling in FastAPI

FastAPI uses `HTTPException` to return structured error responses:

```python
from fastapi import FastAPI, HTTPException

app = FastAPI()

fake_users = {1: "Alice", 2: "Bob"}

@app.get("/users/{user_id}")
def get_user(user_id: int):
    if user_id not in fake_users:
        raise HTTPException(
            status_code=404,
            detail=f"User {user_id} not found"
        )
    return {"id": user_id, "name": fake_users[user_id]}
```

The error response will look like:

```json
{
  "detail": "User 42 not found"
}
```

---

### Custom exception handlers in FastAPI

For more control, you can define global exception handlers:

```python
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

app = FastAPI()

class InsufficientFundsError(Exception):
    def __init__(self, amount: float):
        self.amount = amount

@app.exception_handler(InsufficientFundsError)
def insufficient_funds_handler(request: Request, exc: InsufficientFundsError):
    return JSONResponse(
        status_code=402,
        content={"error": "Insufficient funds", "required": exc.amount}
    )

@app.post("/transfer")
def transfer(amount: float):
    balance = 50.0
    if amount > balance:
        raise InsufficientFundsError(amount=amount - balance)
    return {"message": "Transfer successful"}
```

---

### Error handling in Flask

```python
from flask import Flask, jsonify

app = Flask(__name__)

@app.errorhandler(404)
def not_found(error):
    return jsonify({"error": "Resource not found"}), 404

@app.errorhandler(400)
def bad_request(error):
    return jsonify({"error": "Bad request"}), 400

@app.errorhandler(500)
def server_error(error):
    return jsonify({"error": "Internal server error"}), 500

@app.route("/users/<int:user_id>")
def get_user(user_id):
    users = {1: "Alice"}
    if user_id not in users:
        return jsonify({"error": "User not found"}), 404
    return jsonify({"id": user_id, "name": users[user_id]})
```

---

### Error handling flow diagram

```mermaid
flowchart TD
    A["Client sends request"] --> B{"Network<br/>reachable?"}
    B -->|"No"| C["ConnectionError<br/>or Timeout"]
    B -->|"Yes"| D["Server receives<br/>request"]
    D --> E{"Valid<br/>data?"}
    E -->|"No"| F["400 or 422<br/>Validation error"]
    E -->|"Yes"| G{"Authenticated?"}
    G -->|"No"| H["401 Unauthorized"]
    G -->|"Yes"| I{"Resource<br/>exists?"}
    I -->|"No"| J["404 Not Found"]
    I -->|"Yes"| K{"Processing<br/>succeeds?"}
    K -->|"No"| L["500 Server Error"]
    K -->|"Yes"| M["2xx Success<br/>Return data"]
```

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-12"></a>

<details>
<summary>12 - Complete Example — Book API</summary>

<br/>

This section presents a complete, working example of a book management API built with FastAPI, and a client script using `requests` to interact with it.

The API supports:
* listing all books
* retrieving a single book by ID
* adding a new book
* updating a book
* deleting a book

```mermaid
flowchart LR
    A["Client<br/>(requests)"] -->|"GET /books"| B["List all books"]
    A -->|"GET /books/1"| C["Get book id=1"]
    A -->|"POST /books"| D["Create new book"]
    A -->|"PUT /books/1"| E["Update book id=1"]
    A -->|"DELETE /books/1"| F["Delete book id=1"]
```

---

### The FastAPI server — `book_api.py`

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional, Dict

app = FastAPI(title="Book API", version="1.0")

# In-memory storage (replace with a real database in production)
books: Dict[int, dict] = {
    1: {"id": 1, "title": "Clean Code", "author": "Robert C. Martin", "year": 2008},
    2: {"id": 2, "title": "The Pragmatic Programmer", "author": "Andrew Hunt", "year": 1999},
}
next_id = 3

class BookCreate(BaseModel):
    title: str
    author: str
    year: int

class BookUpdate(BaseModel):
    title: Optional[str] = None
    author: Optional[str] = None
    year: Optional[int] = None

@app.get("/books")
def list_books():
    return list(books.values())

@app.get("/books/{book_id}")
def get_book(book_id: int):
    if book_id not in books:
        raise HTTPException(status_code=404, detail=f"Book {book_id} not found")
    return books[book_id]

@app.post("/books", status_code=201)
def create_book(book: BookCreate):
    global next_id
    new_book = {"id": next_id, **book.model_dump()}
    books[next_id] = new_book
    next_id += 1
    return new_book

@app.patch("/books/{book_id}")
def update_book(book_id: int, update: BookUpdate):
    if book_id not in books:
        raise HTTPException(status_code=404, detail=f"Book {book_id} not found")
    for field, value in update.model_dump(exclude_none=True).items():
        books[book_id][field] = value
    return books[book_id]

@app.delete("/books/{book_id}", status_code=204)
def delete_book(book_id: int):
    if book_id not in books:
        raise HTTPException(status_code=404, detail=f"Book {book_id} not found")
    del books[book_id]
```

Start the server:

```bash
uvicorn book_api:app --reload
```

---

### The client script — `book_client.py`

```python
import requests

BASE_URL = "http://127.0.0.1:8000"

def list_books():
    response = requests.get(f"{BASE_URL}/books")
    response.raise_for_status()
    books = response.json()
    print(f"All books ({len(books)} total):")
    for book in books:
        print(f"  [{book['id']}] {book['title']} — {book['author']} ({book['year']})")

def get_book(book_id: int):
    response = requests.get(f"{BASE_URL}/books/{book_id}")
    if response.status_code == 404:
        print(f"Book {book_id} not found")
        return
    response.raise_for_status()
    book = response.json()
    print(f"Book found: {book}")

def create_book(title: str, author: str, year: int):
    payload = {"title": title, "author": author, "year": year}
    response = requests.post(f"{BASE_URL}/books", json=payload)
    response.raise_for_status()
    book = response.json()
    print(f"Created: {book}")
    return book["id"]

def update_book(book_id: int, **kwargs):
    response = requests.patch(f"{BASE_URL}/books/{book_id}", json=kwargs)
    response.raise_for_status()
    print(f"Updated: {response.json()}")

def delete_book(book_id: int):
    response = requests.delete(f"{BASE_URL}/books/{book_id}")
    if response.status_code == 204:
        print(f"Book {book_id} deleted successfully")
    elif response.status_code == 404:
        print(f"Book {book_id} not found")

# --- Run the demo ---
if __name__ == "__main__":
    print("=== List all books ===")
    list_books()

    print("\n=== Get book id=1 ===")
    get_book(1)

    print("\n=== Create a new book ===")
    new_id = create_book("Refactoring", "Martin Fowler", 2018)

    print("\n=== Update the new book ===")
    update_book(new_id, year=2019)

    print("\n=== List books after changes ===")
    list_books()

    print("\n=== Delete the new book ===")
    delete_book(new_id)

    print("\n=== Final list ===")
    list_books()
```

---

### Expected output

```text
=== List all books ===
All books (2 total):
  [1] Clean Code — Robert C. Martin (2008)
  [2] The Pragmatic Programmer — Andrew Hunt (1999)

=== Get book id=1 ===
Book found: {'id': 1, 'title': 'Clean Code', 'author': 'Robert C. Martin', 'year': 2008}

=== Create a new book ===
Created: {'id': 3, 'title': 'Refactoring', 'author': 'Martin Fowler', 'year': 2018}

=== Update the new book ===
Updated: {'id': 3, 'title': 'Refactoring', 'author': 'Martin Fowler', 'year': 2019}

=== List books after changes ===
All books (3 total):
  [1] Clean Code — Robert C. Martin (2008)
  [2] The Pragmatic Programmer — Andrew Hunt (1999)
  [3] Refactoring — Martin Fowler (2019)

=== Delete the new book ===
Book 3 deleted successfully

=== Final list ===
All books (2 total):
  [1] Clean Code — Robert C. Martin (2008)
  [2] The Pragmatic Programmer — Andrew Hunt (1999)
```

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-13"></a>

<details>
<summary>13 - Commands Summary</summary>

<br/>

```bash
# Install the libraries
pip install requests fastapi uvicorn flask flask-restful django djangorestframework python-jose passlib

# ─── requests ───────────────────────────────────────────────────
# Simple GET
python -c "import requests; print(requests.get('https://jsonplaceholder.typicode.com/posts/1').json())"

# ─── FastAPI ─────────────────────────────────────────────────────
# Start a FastAPI server
uvicorn main:app --reload

# Start on a custom port
uvicorn main:app --host 0.0.0.0 --port 8080 --reload

# View auto-generated docs
# http://127.0.0.1:8000/docs      ← Swagger UI
# http://127.0.0.1:8000/redoc     ← ReDoc

# ─── Flask ───────────────────────────────────────────────────────
# Start a Flask server
python app.py

# Start with Flask CLI
flask --app app run --debug

# ─── Django ──────────────────────────────────────────────────────
# Create a new Django project
django-admin startproject myproject

# Create a new app inside the project
python manage.py startapp myapp

# Run migrations
python manage.py migrate

# Start the Django development server
python manage.py runserver

# Create a superuser (for admin panel)
python manage.py createsuperuser
```

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-14"></a>

<details>
<summary>14 - Conclusion</summary>

<br/>

APIs are the backbone of modern software development. Whether you are building a machine learning service, a mobile app backend, a data pipeline, or a microservices architecture, understanding how to build and consume APIs is a fundamental skill.

This document covered the full lifecycle of API development in Python:

* the concept of an API and why REST is the dominant style
* the HTTP protocol — methods, headers, status codes, URL structure
* consuming APIs with the `requests` library — GET, POST, PUT, PATCH, DELETE
* building APIs with **FastAPI** — with automatic validation, documentation, and dependency injection
* building APIs with **Flask** — the lightweight micro-framework approach
* building APIs with **Django REST Framework** — the full-stack approach for larger applications
* authentication patterns — API keys, Bearer tokens, Basic auth
* error handling — on both the client side and server side
* a complete working example with a Book API

```mermaid
flowchart LR
    subgraph CLIENT["Client side"]
        R["requests library<br/>GET, POST, PUT, DELETE<br/>Headers, auth, timeout"]
    end
    subgraph SERVER["Server side"]
        F["FastAPI<br/>Fast, modern, type-safe"]
        FL["Flask<br/>Lightweight, flexible"]
        D["Django + DRF<br/>Full-stack, batteries included"]
    end
    R -->|"HTTP"| F
    R -->|"HTTP"| FL
    R -->|"HTTP"| D
```

### What to explore next

* **Database integration** — connect FastAPI to PostgreSQL using SQLAlchemy or async Databases, or Flask to SQLite using Flask-SQLAlchemy
* **OpenAPI specification** — learn how the API contract is formally described and how to generate client code from it automatically
* **Rate limiting** — protect APIs from abuse using tools like `slowapi` for FastAPI
* **CORS** — configure Cross-Origin Resource Sharing for frontend integrations
* **WebSockets** — FastAPI supports real-time bidirectional communication
* **Background tasks** — run async jobs after returning a response using FastAPI's `BackgroundTasks`
* **API versioning** — manage breaking changes cleanly using URL versioning (`/v1/`, `/v2/`) or header versioning
* **Docker** — containerize your API for portable deployment
* **API testing** — write automated tests using `pytest` and FastAPI's `TestClient`

Every ML project, data service, or web application that needs to expose its functionality to the outside world eventually becomes an API. The patterns covered in this document are the foundation for all of that work.

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-15"></a>

<details>
<summary>15 - Hands-on Project — Task Manager API (FastAPI + Streamlit)</summary>

<br/>

This section walks through a complete, ready-to-run project that demonstrates all the concepts covered in this document: **GET, POST, PUT, PATCH, DELETE**, virtual environments, Pydantic validation, Swagger UI, VS Code REST Client, Postman, and a Streamlit frontend.

The project is hosted on GitHub:

```text
https://github.com/inskillflow/demo_api_1_simple_fastapi_app.git
```

---

### Project architecture

```mermaid
flowchart LR
    subgraph CLIENT["Client"]
        ST["Streamlit<br/>frontend.py<br/>localhost:8501"]
        HTTP["test_api.http<br/>VS Code REST Client"]
        PM["Postman / curl"]
    end
    subgraph SERVER["FastAPI Server"]
        FA["main.py<br/>127.0.0.1:8000"]
        DB["In-memory DB<br/>Python dict"]
        DOCS["Swagger UI<br/>/docs"]
    end
    ST -->|"requests"| FA
    HTTP -->|"HTTP"| FA
    PM -->|"HTTP"| FA
    FA --> DB
    FA --> DOCS
```

---

### Files in the project

| File | Purpose |
|---|---|
| `main.py` | FastAPI server — all CRUD routes with Pydantic models |
| `frontend.py` | Streamlit UI — calls the API visually |
| `requirements.txt` | All dependencies with pinned versions |
| `test_api.http` | VS Code REST Client — ready-to-send requests |
| `curl_examples.sh` | curl and PowerShell equivalents |
| `README.md` | Full setup guide with diagrams |

---

### Step 1 — Clone the repository

```bash
git clone https://github.com/inskillflow/demo_api_1_simple_fastapi_app.git
cd demo_api_1_simple_fastapi_app
```

---

### Step 2 — Create the virtual environment

**Windows:**

```powershell
python -m venv venv
venv\Scripts\activate
```

> If you get `running scripts is disabled`, run this once in PowerShell:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

**macOS:**

```bash
python3 -m venv venv
source venv/bin/activate
```

**Linux — Ubuntu 22.04:**

```bash
sudo apt install -y python3-venv
python3 -m venv venv
source venv/bin/activate
```

Verify the venv is active — you will see `(venv)` in your prompt:

```bash
where python     # Windows  → shows path inside venv\Scripts\
which python     # macOS/Linux → shows path inside venv/bin/
```

---

### Step 3 — Install dependencies

```bash
# Upgrade pip first
python -m pip install --upgrade pip

# Install all packages
pip install -r requirements.txt
```

`requirements.txt` contains:

```text
fastapi==0.115.0
uvicorn==0.30.1
pydantic==2.7.4
streamlit==1.35.0
requests==2.31.0
```

Verify:

```bash
pip list
```

---

### Step 4 — Run the FastAPI server

```bash
uvicorn main:app --reload
```

The server starts at `http://127.0.0.1:8000`

| URL | What you see |
|---|---|
| `http://127.0.0.1:8000/` | Root — confirms the API is running |
| `http://127.0.0.1:8000/tasks` | All tasks (JSON) |
| `http://127.0.0.1:8000/docs` | Swagger UI — interactive documentation |
| `http://127.0.0.1:8000/redoc` | ReDoc — clean read-only docs |

---

### Step 5 — Run the Streamlit frontend

Open a **second terminal**, activate the venv again, then:

```bash
# Windows
venv\Scripts\activate
streamlit run frontend.py

# macOS / Linux
source venv/bin/activate
streamlit run frontend.py
```

The interface opens at `http://localhost:8501`

```mermaid
flowchart LR
    subgraph T1["Terminal 1 — FastAPI"]
        A["uvicorn main:app --reload<br/>→ http://127.0.0.1:8000"]
    end
    subgraph T2["Terminal 2 — Streamlit"]
        B["streamlit run frontend.py<br/>→ http://localhost:8501"]
    end
    T2 -->|"HTTP requests"| T1
```

---

### Step 6 — Test the API

#### Option A — Swagger UI (no setup needed)

Go to `http://127.0.0.1:8000/docs` in your browser.
Click any endpoint → **Try it out** → fill in values → **Execute**.

#### Option B — VS Code REST Client

1. Install the extension **REST Client** by Humao (`humao.rest-client`)
2. Open `test_api.http`
3. Click **Send Request** above any `###` block

The file covers all methods and error cases:

```http
### GET — All tasks
GET http://127.0.0.1:8000/tasks

### POST — Create a task
POST http://127.0.0.1:8000/tasks
Content-Type: application/json

{
  "title": "Study Pydantic",
  "priority": "high"
}

### PATCH — Mark as completed
PATCH http://127.0.0.1:8000/tasks/1
Content-Type: application/json

{
  "completed": true
}

### DELETE
DELETE http://127.0.0.1:8000/tasks/4
```

#### Option C — Postman

| Method | URL | Body |
|---|---|---|
| GET | `http://127.0.0.1:8000/tasks` | — |
| GET | `http://127.0.0.1:8000/tasks?completed=false&priority=high` | — |
| GET | `http://127.0.0.1:8000/tasks/1` | — |
| POST | `http://127.0.0.1:8000/tasks` | `{"title": "...", "priority": "high"}` |
| PUT | `http://127.0.0.1:8000/tasks/1` | all fields |
| PATCH | `http://127.0.0.1:8000/tasks/1` | `{"completed": true}` |
| DELETE | `http://127.0.0.1:8000/tasks/4` | — |

#### Option D — curl

```bash
# GET all
curl http://127.0.0.1:8000/tasks

# GET with filters
curl "http://127.0.0.1:8000/tasks?completed=false&priority=high"

# GET one
curl http://127.0.0.1:8000/tasks/1

# POST create
curl -X POST http://127.0.0.1:8000/tasks \
     -H "Content-Type: application/json" \
     -d '{"title": "New task", "priority": "high"}'

# PUT replace
curl -X PUT http://127.0.0.1:8000/tasks/1 \
     -H "Content-Type: application/json" \
     -d '{"title": "Updated", "description": "Full replace", "completed": true, "priority": "high"}'

# PATCH partial update
curl -X PATCH http://127.0.0.1:8000/tasks/1 \
     -H "Content-Type: application/json" \
     -d '{"completed": true}'

# DELETE
curl -X DELETE http://127.0.0.1:8000/tasks/4
```

**Windows PowerShell:**

```powershell
# GET all tasks
Invoke-RestMethod -Uri "http://127.0.0.1:8000/tasks" -Method GET | ConvertTo-Json

# POST create
Invoke-RestMethod -Uri "http://127.0.0.1:8000/tasks" `
  -Method POST `
  -ContentType "application/json" `
  -Body '{"title": "PowerShell task", "priority": "medium"}' | ConvertTo-Json

# PATCH update
Invoke-RestMethod -Uri "http://127.0.0.1:8000/tasks/1" `
  -Method PATCH `
  -ContentType "application/json" `
  -Body '{"completed": true}' | ConvertTo-Json

# DELETE
Invoke-RestMethod -Uri "http://127.0.0.1:8000/tasks/4" -Method DELETE
```

---

### Complete setup — all commands in one block

**Windows:**

```powershell
git clone https://github.com/inskillflow/demo_api_1_simple_fastapi_app.git
cd demo_api_1_simple_fastapi_app
python -m venv venv
venv\Scripts\activate
python -m pip install --upgrade pip
pip install -r requirements.txt

# Terminal 1 — FastAPI
uvicorn main:app --reload

# Terminal 2 — open a new terminal, activate venv again
venv\Scripts\activate
streamlit run frontend.py
```

**macOS / Linux:**

```bash
git clone https://github.com/inskillflow/demo_api_1_simple_fastapi_app.git
cd demo_api_1_simple_fastapi_app
python3 -m venv venv
source venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt

# Terminal 1 — FastAPI
uvicorn main:app --reload

# Terminal 2 — open a new terminal, activate venv again
source venv/bin/activate
streamlit run frontend.py
```

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>

---

<a id="section-swagger-testing"></a>

<details>
<summary><strong>16 — How to Test Your API with Swagger UI — Step by Step for Absolute Beginners</strong></summary>

<br/>

> Swagger UI is a web page that FastAPI generates automatically.  
> It lets you test every endpoint of your API by clicking buttons — no code needed.

---

### Step 1 — Start your FastAPI server

Open a terminal, activate your virtual environment, and run:

```bash
uvicorn main:app --reload
```

You will see something like this:

```
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process
```

Your API is now running locally on your computer.

---

### Step 2 — Open Swagger UI in your browser

Open your browser and go to:

```
http://127.0.0.1:8000/docs
```

You will see a page with all your endpoints listed, grouped by color:

| Color | Method | What it does |
|-------|--------|--------------|
| 🟢 Green | **GET** | Read / retrieve data |
| 🟡 Yellow | **POST** | Create new data |
| 🟠 Orange | **PUT** | Update existing data |
| 🔴 Red | **DELETE** | Delete data |

---

### Step 3 — Test a GET endpoint (read all tasks)

**Goal:** retrieve the list of all tasks.

1. Click on the green **GET** block — for example `GET /tasks`
2. The block expands — click the **"Try it out"** button on the right
3. Click the blue **"Execute"** button
4. Scroll down — you will see:
   - **Request URL** — the full URL that was called
   - **Response body** — the data returned by the API (in JSON format)
   - **Response code** — `200` means success

**Example response:**
```json
[
  { "id": 1, "title": "Buy groceries", "completed": false },
  { "id": 2, "title": "Read a book", "completed": true }
]
```

---

### Step 4 — Test a GET endpoint with a parameter (read one task)

**Goal:** retrieve a single task by its ID.

1. Click on the green **GET** block — for example `GET /tasks/{task_id}`
2. Click **"Try it out"**
3. You will see a field called **task_id** — type a number, for example `1`
4. Click **"Execute"**
5. The response shows only the task with ID 1

> If you type an ID that does not exist, the API returns a `404` error — that is normal.

---

### Step 5 — Test a POST endpoint (create a new task)

**Goal:** send data to the API to create a new task.

1. Click on the yellow **POST** block — for example `POST /tasks`
2. Click **"Try it out"**
3. You will see a large text box called **Request body**
4. Replace the content with your own data, for example:

```json
{
  "title": "Learn FastAPI",
  "completed": false
}
```

5. Click **"Execute"**
6. The response shows the new task that was just created, with its new ID

> **Status code `201`** means the item was created successfully.

---

### Step 6 — Test a PUT endpoint (update an existing task)

**Goal:** modify an existing task.

1. Click on the orange **PUT** block — for example `PUT /tasks/{task_id}`
2. Click **"Try it out"**
3. In the **task_id** field, type the ID of the task you want to update, for example `1`
4. In the **Request body**, write the new values:

```json
{
  "title": "Learn FastAPI — updated",
  "completed": true
}
```

5. Click **"Execute"**
6. The response shows the updated task

> **Status code `200`** means the update was successful.

---

### Step 7 — Test a DELETE endpoint (delete a task)

**Goal:** remove a task from the list.

1. Click on the red **DELETE** block — for example `DELETE /tasks/{task_id}`
2. Click **"Try it out"**
3. In the **task_id** field, type the ID of the task you want to delete, for example `1`
4. Click **"Execute"**
5. The response confirms the task was deleted

> **Status code `200`** or **`204`** means the deletion was successful.  
> If you try to delete the same ID again, you get a `404` — the task no longer exists.

---

### Summary — What each status code means

| Code | Meaning | When you see it |
|------|---------|-----------------|
| `200` | OK — success | GET, PUT, DELETE worked |
| `201` | Created | POST created a new item |
| `204` | No Content | DELETE with no body returned |
| `404` | Not Found | The ID you requested does not exist |
| `422` | Validation Error | You sent wrong or missing data |
| `500` | Server Error | A bug in the code |

---

### Quick recap — The 4 actions in Swagger UI

```
GET    → Try it out → Enter ID (optional) → Execute → Read the response
POST   → Try it out → Fill in the Request Body → Execute → See the new item
PUT    → Try it out → Enter ID + fill Request Body → Execute → See updated item
DELETE → Try it out → Enter ID → Execute → Confirm deletion
```

</details>

<p align="right"><a href="#top">↑ Back to top</a></p>
