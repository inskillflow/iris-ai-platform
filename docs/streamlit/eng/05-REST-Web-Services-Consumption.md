<a id="top"></a>

# REST Web Services Consumption — Python `requests` & Streamlit

**Module 05 — Full-Stack ML with Streamlit**  
**Audience:** Developers learning to consume REST APIs from Python and Streamlit UIs.

---

## Table of Contents

| # | Topic |
|---|--------|
| [1](#section-1) | [What is a Web Service?](#section-1) |
| &nbsp;&nbsp;&nbsp;↳ | [Types of web services](#section-1-1) · [Why consume APIs from Streamlit?](#section-1-2) |
| [2](#section-2) | [REST Architecture in Depth (six constraints)](#section-2) |
| &nbsp;&nbsp;&nbsp;↳ | [Client–server](#section-2-1) · [Stateless](#section-2-2) · [Cache](#section-2-3) · [Uniform interface](#section-2-4) · [Layered system](#section-2-5) · [Code on demand](#section-2-6) |
| [3](#section-3) | [The HTTP Protocol](#section-3) |
| &nbsp;&nbsp;&nbsp;↳ | [Request/response model (Mermaid)](#section-3-1) · [Headers & body](#section-3-2) |
| [4](#section-4) | [HTTP Methods](#section-4) |
| [5](#section-5) | [HTTP Status Codes (1xx–5xx)](#section-5) |
| [6](#section-6) | [Data Formats: JSON, XML, YAML](#section-6) |
| [7](#section-7) | [Consuming an API with Python `requests` (main)](#section-7) |
| &nbsp;&nbsp;&nbsp;↳ | [Verbs](#section-7-1) · [Headers](#section-7-2) · [Authentication](#section-7-3) · [Sessions](#section-7-4) · [Error handling](#section-7-5) · [Response object](#section-7-6) · [Uploads, SSL, proxies](#section-7-7) · [Prepared requests & hooks](#section-7-8) |
| [8](#section-8) | [Consuming an API in Streamlit](#section-8) |
| &nbsp;&nbsp;&nbsp;↳ | [Calling `requests`](#section-8-1) · [`st.spinner`](#section-8-2) · [`st.metric` / `st.progress` / `st.dataframe`](#section-8-3) · [Caching with `st.cache_data`](#section-8-4) · [Secrets & session state](#section-8-5) |
| [9](#section-9) | [Consuming an API with JavaScript (brief)](#section-9) |
| [10](#section-10) | [curl and Postman](#section-10) |
| [11](#section-11) | [Authentication in REST APIs](#section-11) |
| [12](#section-12) | [CORS](#section-12) |
| [13](#section-13) | [REST API Design Best Practices](#section-13) |
| [14](#section-14) | [Testing an API](#section-14) |
| [15](#section-15) | [Case Study: Iris Application (Streamlit → FastAPI)](#section-15) |
| [16](#section-16) | [Glossary (55+ terms)](#section-16) |
| [17](#section-17) | [Conclusion](#section-17) |

---

<a id="section-1"></a>

## 1. What is a Web Service?

A **web service** is a software component exposed over a network (typically the Internet or an intranet) so that other programs can **invoke it remotely** using standard protocols—most often **HTTP** or **HTTPS**. Instead of linking a library into your process, your application sends a **request** and receives a **response**, usually encoded as **JSON** or **XML**.

Web services enable **loose coupling**: the consumer (client) and provider (server) can be implemented in different languages, deployed on different machines, and upgraded independently—as long as the **contract** (URLs, methods, payloads, and status semantics) remains compatible.

<details>
<summary><strong>Expand: Typical characteristics of web services</strong></summary>

| Characteristic | Explanation |
|----------------|-------------|
| **Network-accessible** | Reachable via IP/DNS; not limited to local function calls. |
| **Machine-readable contracts** | Often described by OpenAPI/Swagger, WSDL (SOAP), or documentation. |
| **Interoperability** | Any client that speaks HTTP can participate. |
| **Scalability** | Stateless REST APIs scale horizontally behind load balancers. |
| **Security boundary** | Authentication, TLS, and rate limiting protect exposed capabilities. |

</details>

<a id="section-1-1"></a>

### 1.1 Types of web services (high level)

| Style | Transport / format | Typical use |
|-------|-------------------|-------------|
| **REST over HTTP** | HTTP + JSON (common) | Public APIs, microservices, SPAs, mobile apps. |
| **SOAP** | HTTP + XML envelopes | Enterprise integrations, strict contracts (WSDL). |
| **gRPC** | HTTP/2 + Protobuf | Low-latency internal RPC between services. |
| **GraphQL** | HTTP POST + query language | Flexible client-driven data fetching. |
| **WebSockets** | Persistent TCP connection | Real-time feeds, chats, live dashboards. |

This course focuses on **REST** consumption from **Python** and **Streamlit**.

<a id="section-1-2"></a>

### 1.2 Why consume APIs from Streamlit?

Streamlit excels at **rapid data apps**. Calling REST APIs lets you:

- **Separate concerns**: ML inference stays in FastAPI; the UI stays thin.
- **Reuse one backend** for Streamlit, mobile, or other clients.
- **Scale independently**: add replicas of the API tier without redeploying the UI.
- **Centralize secrets** (API keys) on the server side when using Streamlit’s secrets manager.

---

<a id="section-2"></a>

## 2. REST Architecture in Depth (Six Constraints)

**REST** (Representational State Transfer) is an **architectural style** defined by Roy Fielding. A RESTful system is not a single technology—it is a set of **constraints** that, when followed, yield desirable properties: scalability, simplicity, and evolvability.

The **six constraints** are:

1. **Client–server**  
2. **Stateless**  
3. **Cache**  
4. **Uniform interface**  
5. **Layered system**  
6. **Code on demand** *(optional)*  

```mermaid
flowchart TB
    subgraph REST["REST constraints"]
        C1["1. Client–server"]
        C2["2. Stateless"]
        C3["3. Cache"]
        C4["4. Uniform interface"]
        C5["5. Layered system"]
        C6["6. Code on demand (optional)"]
    end
    C1 --> C2 --> C3 --> C4 --> C5 --> C6
```

<a id="section-2-1"></a>

### 2.1 Client–server

**Separation of concerns**: the **user interface** (Streamlit) is independent from **data storage and business logic** (FastAPI + database). They communicate through a **resource-oriented** interface over HTTP.

<a id="section-2-2"></a>

### 2.2 Stateless

Each request from client to server must contain **all information** needed to understand and process it. The server does not store **session state** between requests (though the *client* may hold tokens or cookies).  

**Implication for API consumers:** every call might need **Authorization** headers; you cannot assume hidden server-side session memory (unless the API explicitly uses cookies with server sessions—still, treat it as an implementation detail).

<a id="section-2-3"></a>

### 2.3 Cache

Responses must be **explicitly labeled** as cacheable or not (via **HTTP cache headers** like `Cache-Control`, `ETag`, `Last-Modified`). Caching reduces latency and load.

**Consumer tip:** `requests` respects some caching only if you add middleware (e.g., `requests-cache`); by default it does not cache.

<a id="section-2-4"></a>

### 2.4 Uniform interface

This is the richest constraint. It includes:

| Sub-constraint | Meaning for REST APIs |
|----------------|------------------------|
| **Resource identification** | Resources are identified in requests (e.g., `/users/42`). |
| **Manipulation through representations** | Clients send representations (JSON) to change state. |
| **Self-descriptive messages** | Each message includes metadata (`Content-Type`, `Accept`, etc.). |
| **HATEOAS** *(hypermedia as the engine of application state)* | Responses may include links to next actions (less common in minimal JSON APIs). |

<a id="section-2-5"></a>

### 2.5 Layered system

A client cannot ordinarily tell whether it is connected **directly** to the end server or through intermediaries (**proxies**, **gateways**, **load balancers**, **CDNs**). Layers can enforce security, caching, and transformation.

<a id="section-2-6"></a>

### 2.6 Code on demand (optional)

Servers may **extend client functionality** by sending executable code (historically Java applets; today occasionally scripts). This constraint is **optional** and **rare** in typical REST JSON APIs.

<details>
<summary><strong>Expand: REST vs “REST-like” APIs</strong></summary>

Many public APIs are described as REST but use **RPC-style** paths (`/doSomething`) or always return `200 OK` with errors in the body. Strict REST advocates prefer **nouns for resources**, correct **HTTP verbs**, and **meaningful status codes**. As a **consumer**, read the provider’s documentation and test edge cases—**pragmatism beats purity** when integrating.

</details>

---

<a id="section-3"></a>

## 3. The HTTP Protocol

**HTTP** (Hypertext Transfer Protocol) is an **application-layer** request/response protocol. **HTTPS** is HTTP over **TLS**, providing encryption and server authentication.

<a id="section-3-1"></a>

### 3.1 Request/response model (Mermaid)

```mermaid
sequenceDiagram
    participant C as Client (Streamlit / requests)
    participant S as Server (FastAPI)
    C->>S: HTTP Request (method, path, headers, body)
    Note over C,S: Optional: DNS lookup, TCP/TLS handshake
    S->>S: Routing, validation, business logic
    S-->>C: HTTP Response (status, headers, body)
    C->>C: Parse JSON / handle errors
```

<a id="section-3-2"></a>

### 3.2 Anatomy of an HTTP message

**Request line** (HTTP/1.1 example):

```http
POST /predict HTTP/1.1
Host: localhost:8000
Content-Type: application/json
Accept: application/json
Content-Length: 86

{"sepal_length":5.1,"sepal_width":3.5,"petal_length":1.4,"petal_width":0.2}
```

**Response** (simplified):

```http
HTTP/1.1 200 OK
content-type: application/json

{"species":"setosa","confidence":0.98,"probabilities":{"setosa":0.98,...}}
```

| Part | Role |
|------|------|
| **Method** | Verb: GET, POST, etc. |
| **Path & query** | Resource locator + `?key=value`. |
| **Headers** | Metadata: auth, caching, content negotiation. |
| **Body** | Payload (often JSON for POST/PUT/PATCH). |
| **Status code** | Outcome class: 2xx success, 4xx client error, 5xx server error. |

---

<a id="section-4"></a>

## 4. HTTP Methods

HTTP methods (verbs) express **intent**. **Idempotent** methods are safe to repeat without changing the outcome beyond the first successful application (ideal for retries). **Safe** methods should not change server state.

| Method | Safe | Idempotent | Typical body | Common use |
|--------|------|------------|--------------|------------|
| **GET** | Yes | Yes | No | Read resource(s), list, search (`?q=`). |
| **HEAD** | Yes | Yes | No | Like GET but **no body** (check existence, headers). |
| **OPTIONS** | Yes | Yes | No | Discover allowed methods (CORS preflight). |
| **POST** | No | No | Yes | Create sub-resource, actions, non-idempotent operations. |
| **PUT** | No | Yes | Yes | Replace entire resource at a known URI. |
| **PATCH** | No | No* | Yes | Partial update (*idempotency depends on implementation). |
| **DELETE** | No | Yes | Optional | Remove resource. |

<details>
<summary><strong>Expand: Practical nuances for API consumers</strong></summary>

- Some APIs misuse **POST** for reads for complex queries—still valid HTTP, but not “pure REST.”
- **PUT vs PATCH:** consumers must send the **shape the server expects** (full object vs JSON Patch/Merge Patch).
- **Idempotency keys:** payment APIs often require `Idempotency-Key` on POST to prevent duplicate charges.

</details>

---

<a id="section-5"></a>

## 5. HTTP Status Codes (1xx–5xx)

Status codes are **three-digit** numbers grouped by the **first digit**.

### 5.1 Overview by class

| Class | Range | Meaning |
|-------|-------|---------|
| **Informational** | 1xx | Provisional; rarely seen in simple `requests` flows. |
| **Success** | 2xx | Request understood and accepted. |
| **Redirection** | 3xx | Further action needed (new URL, caching). |
| **Client error** | 4xx | Fix the request or permissions. |
| **Server error** | 5xx | Server-side failure; retry may help. |

### 5.2 Common codes (consumer-focused)

| Code | Name | When you see it | Typical consumer action |
|------|------|-----------------|-------------------------|
| **200** | OK | GET/PUT/PATCH success | Parse body. |
| **201** | Created | POST created resource | Read `Location` header if present. |
| **204** | No Content | Success, empty body | Stop; nothing to parse. |
| **301** | Moved Permanently | URL changed | Update configured base URL. |
| **302/307/308** | Redirects | Temporary/permanent redirect | Follow with care; preserve method where required. |
| **400** | Bad Request | Validation failed | Fix JSON/schema; show field errors. |
| **401** | Unauthorized | Missing/invalid auth | Refresh token / prompt login. |
| **403** | Forbidden | Authenticated but not allowed | Do not retry blindly. |
| **404** | Not Found | Wrong path or ID | Check URL and resource lifecycle. |
| **409** | Conflict | Version/state conflict | Merge or refetch latest. |
| **422** | Unprocessable Entity | Semantic validation (common in FastAPI) | Fix payload per `detail`. |
| **429** | Too Many Requests | Rate limited | Backoff, respect `Retry-After`. |
| **500** | Internal Server Error | Bug/infrastructure | Retry with exponential backoff. |
| **502/503/504** | Bad Gateway / Unavailable / Gateway Timeout | Upstream issues | Retry; check health endpoints. |

<details>
<summary><strong>Expand: FastAPI + validation errors (422)</strong></summary>

FastAPI often returns **422 Unprocessable Entity** when Pydantic validation fails. The JSON body typically includes a `detail` array listing **loc** (field path) and **msg**. Streamlit apps should surface these messages to help users correct inputs.

</details>

### 5.3 Informational and redirection codes (reference)

<details>
<summary><strong>Expand: 1xx informational responses</strong></summary>

| Code | Name | Meaning for consumers |
|------|------|------------------------|
| **100** | Continue | Client may continue sending body (rare in `requests`). |
| **101** | Switching Protocols | Upgrade to WebSocket, etc. |
| **102** | Processing | Server still working (WebDAV / long operations). |
| **103** | Early Hints | Hints for preloading linked resources (HTTP/2+). |

Most Python clients only observe 1xx when using **low-level** APIs or specific servers; `requests` typically follows the final status after any intermediate responses.

</details>

<details>
<summary><strong>Expand: 3xx redirection family</strong></summary>

| Code | Typical meaning | Consumer note |
|------|-----------------|---------------|
| **300** | Multiple Choices | Disambiguate resource. |
| **301** | Moved Permanently | Update bookmarks/config; future requests should use new URI. |
| **302** | Found | Temporary redirect; historically clients sometimes changed POST→GET. |
| **303** | See Other | After POST, GET the `Location` resource. |
| **304** | Not Modified | Conditional GET matched `ETag`/date; **no body** (use cache). |
| **307** | Temporary Redirect | **Preserve method** when following. |
| **308** | Permanent Redirect | **Preserve method**; like 301 but method-safe. |

`requests` follows redirects by default for **GET/HEAD**; for **POST**, behavior depends on status and `requests` version/settings—**verify** in integration tests.

</details>

---

<a id="section-6"></a>

## 6. Data Formats (JSON vs XML vs YAML)

| Aspect | **JSON** | **XML** | **YAML** |
|--------|----------|---------|----------|
| **Verbosity** | Compact | Verbose | Moderate |
| **Types** | string, number, bool, null, array, object | Everything is text; schema via XSD | Rich scalars, anchors, multi-line strings |
| **Web API usage** | Dominant for REST | Common in SOAP/legacy | Config files (Docker Compose, K8s), not usually on the wire |
| **Parsing in Python** | `response.json()` / `json` module | `xml.etree` / `lxml` | `PyYAML` (safe load!) |
| **Comments** | Not allowed | Allowed | Allowed |

**Recommendation for Streamlit + `requests`:** prefer **JSON** (`Content-Type: application/json`). For XML/SOAP APIs, parse text explicitly and consider dedicated clients.

<details>
<summary><strong>Expand: Content negotiation with Accept</strong></summary>

Send `Accept: application/json` to express preference. Some APIs return **406 Not Acceptable** if they cannot satisfy `Accept`. If an API supports multiple formats, it may choose based on `Accept` or a `?format=` query parameter.

</details>

---

<a id="section-7"></a>

## 7. Consuming an API with Python `requests` (Main Section)

The **`requests`** library provides a **human-friendly** API on top of `urllib3`. Install:

```bash
pip install requests
```

<a id="section-7-1"></a>

### 7.1 Verbs in practice: GET, POST, PUT, PATCH, DELETE

#### GET — retrieve representations

```python
import requests

url = "https://api.example.com/v1/items"
params = {"page": 2, "page_size": 25}
headers = {"Accept": "application/json"}

resp = requests.get(url, params=params, headers=headers, timeout=10)
resp.raise_for_status()
data = resp.json()
```

**Notes:**

- `params` is encoded into the query string safely.
- Always set **`timeout`** to avoid hanging forever.

#### POST — create resources or trigger processing

```python
payload = {"name": "iris-demo", "tags": ["ml", "edu"]}
resp = requests.post(
    "https://api.example.com/v1/projects",
    json=payload,          # sets Content-Type: application/json and serializes
    headers={"Authorization": "Bearer <token>"},
    timeout=10,
)
resp.raise_for_status()
created = resp.json()
```

Using `json=` is preferred over manual `data=json.dumps(...)` because it configures headers correctly.

#### PUT — replace a resource

```python
item_url = "https://api.example.com/v1/items/42"
full_item = {"id": 42, "name": "updated", "quantity": 10}
resp = requests.put(item_url, json=full_item, timeout=10)
resp.raise_for_status()
```

#### PATCH — partial update (server-dependent format)

```python
patch_url = "https://api.example.com/v1/items/42"
resp = requests.patch(patch_url, json={"quantity": 11}, timeout=10)
resp.raise_for_status()
```

#### DELETE — remove a resource

```python
resp = requests.delete("https://api.example.com/v1/items/42", timeout=10)
if resp.status_code not in (200, 204):
    resp.raise_for_status()
```

<a id="section-7-2"></a>

### 7.2 Headers: essentials for consumers

| Header | Purpose |
|--------|---------|
| **`Accept`** | Desired response format (`application/json`). |
| **`Content-Type`** | Format of outgoing body (`application/json`). |
| **`Authorization`** | Credentials (Bearer, Basic, custom schemes). |
| **`User-Agent`** | Identify your app (helpful for API owners). |
| **`If-None-Match` / `If-Modified-Since`** | Conditional GET for caching. |
| **`X-Request-ID`** | Correlation for distributed tracing (if supported). |

Example:

```python
headers = {
    "Accept": "application/json",
    "User-Agent": "streamlit-iris-demo/1.0",
}
requests.get(url, headers=headers, timeout=5)
```

<a id="section-7-3"></a>

### 7.3 Authentication patterns

#### API key in header or query (discouraged in query for secrets)

```python
h = {"X-API-Key": "your-secret-key"}
requests.get(url, headers=h, timeout=10)
```

#### Bearer token (JWT or opaque)

```python
h = {"Authorization": "Bearer eyJhbGciOi..."}
requests.get(url, headers=h, timeout=10)
```

#### HTTP Basic (username/password)

```python
from requests.auth import HTTPBasicAuth

requests.get(url, auth=HTTPBasicAuth("user", "pass"), timeout=10)
```

#### OAuth2 client credentials (conceptual)

Typically you **POST** to a token endpoint, receive an `access_token`, then call APIs with `Authorization: Bearer ...`. Use well-maintained libraries (e.g., **`authlib`**, **`requests-oauthlib`**) for full OAuth flows.

<a id="section-7-4"></a>

### 7.4 Sessions: persistent settings and connection pooling

`requests.Session()` reuses **TCP connections** (performance) and persists **default headers** and **authentication**.

```python
import requests

s = requests.Session()
s.headers.update({"Accept": "application/json", "User-Agent": "my-app/1.0"})
s.headers.update({"Authorization": "Bearer <token>"})

r1 = s.get("https://api.example.com/v1/me", timeout=10)
r2 = s.post("https://api.example.com/v1/items", json={"name": "a"}, timeout=10)
```

**Cookies:** a session jar automatically stores cookies if the API uses them.

<a id="section-7-5"></a>

### 7.5 Error handling: robust client code

#### Pattern A — `raise_for_status()` + parse JSON errors

```python
import requests

def fetch_item(item_id: int) -> dict:
    url = f"https://api.example.com/v1/items/{item_id}"
    resp = requests.get(url, timeout=10)
    try:
        resp.raise_for_status()
    except requests.HTTPError:
        # Try to extract structured error details
        try:
            detail = resp.json()
        except ValueError:
            detail = resp.text
        raise RuntimeError(f"HTTP {resp.status_code}: {detail}") from None
    return resp.json()
```

#### Pattern B — classify errors for UI messaging

```python
import requests

def call_api():
    try:
        resp = requests.post("http://localhost:8000/predict", json=payload, timeout=5)
    except requests.Timeout:
        return "error", "The server took too long to respond."
    except requests.ConnectionError:
        return "error", "Cannot connect — is the API running?"
    except requests.RequestException as exc:
        return "error", f"Request failed: {exc}"

    if resp.status_code == 422:
        return "validation", resp.json()
    if resp.status_code >= 500:
        return "error", "Server error — try again later."
    if resp.status_code >= 400:
        return "error", resp.text

    return "ok", resp.json()
```

#### Pattern C — streaming large downloads

```python
with requests.get("https://example.com/large.csv", stream=True, timeout=30) as resp:
    resp.raise_for_status()
    for chunk in resp.iter_content(chunk_size=64 * 1024):
        if chunk:
            # process chunk
            pass
```

<details>
<summary><strong>Expand: retries and backoff</strong></summary>

For transient **5xx** or **429**, exponential backoff helps. Libraries like **`urllib3.Retry`** (via **`requests.adapters.HTTPAdapter`**) or **`tenacity`** can wrap calls. Always cap retries and respect **`Retry-After`**.

</details>

<a id="section-7-6"></a>

### 7.6 The `Response` object: what you actually get back

Every call returns a **`requests.Response`**. Important attributes and methods:

| Member | Purpose |
|--------|---------|
| **`status_code`** | Integer HTTP status (e.g., `200`). |
| **`headers`** | Case-insensitive mapping (`resp.headers["content-type"]`). |
| **`encoding`** | Guessed text encoding; set manually if wrong. |
| **`text`** | Body decoded as Unicode string. |
| **`content`** | Raw **bytes** (images, PDFs, protobuf). |
| **`json()`** | Parse JSON body; raises `JSONDecodeError` if invalid. |
| **`url`** | Final URL after redirects. |
| **`history`** | Tuple of prior responses when redirects were followed. |
| **`elapsed`** | `timedelta` for round-trip time. |
| **`raise_for_status()`** | Raises `HTTPError` if status is 4xx/5xx. |
| **`iter_lines()` / `iter_content()`** | Stream large bodies. |

```python
import requests

resp = requests.get("https://httpbin.org/json", timeout=10)
print(resp.status_code, resp.reason)          # 200 OK
print(resp.headers.get("Content-Type"))
print(resp.elapsed.total_seconds())

data = resp.json()  # may raise requests.exceptions.JSONDecodeError
```

**Encoding pitfalls:** if `text` looks garbled, inspect `resp.encoding`, set `resp.encoding = "utf-8"` (or use `content.decode("utf-8")`).

<a id="section-7-7"></a>

### 7.7 File uploads, form data, SSL/TLS, and proxies

#### Multipart file upload

```python
files = {"file": ("report.csv", open("report.csv", "rb"), "text/csv")}
data = {"note": "monthly"}
resp = requests.post("https://api.example.com/v1/uploads", files=files, data=data, timeout=60)
resp.raise_for_status()
```

Prefer **context managers** so files close reliably:

```python
with open("report.csv", "rb") as f:
    files = {"file": ("report.csv", f, "text/csv")}
    resp = requests.post(url, files=files, timeout=60)
```

#### `application/x-www-form-urlencoded`

```python
resp = requests.post(url, data={"user": "alice", "token": "abc"}, timeout=10)
```

#### SSL certificate verification

- Default: **`verify=True`** (uses system CA bundle).  
- Corporate proxies with custom CAs: pass **`verify="/path/to/ca-bundle.crt"`**.  
- **Never** disable TLS verification in production (`verify=False`) unless you fully understand the risk (testing only).

```python
resp = requests.get("https://self-signed.bad", verify=False)  # insecure — dev only
```

#### HTTP(S) proxies

```python
proxies = {
    "http": "http://user:pass@proxy.corp:8080",
    "https": "http://user:pass@proxy.corp:8080",
}
resp = requests.get("https://api.example.com/v1/ping", proxies=proxies, timeout=15)
```

Environment variables **`HTTP_PROXY` / `HTTPS_PROXY`** are also honored by default.

<a id="section-7-8"></a>

### 7.8 Prepared requests, event hooks, and custom adapters

#### `PreparedRequest` — build once, send many

Useful for **signing** payloads or repeating identical requests with minor tweaks:

```python
import requests

req = requests.Request("POST", "https://api.example.com/v1/echo", json={"a": 1})
prepped = req.prepare()

s = requests.Session()
# prepped.headers["X-Signature"] = sign(prepped.body)
resp = s.send(prepped, timeout=10)
```

#### Hooks — observe every response

```python
import requests

def print_url(resp, *args, **kwargs):
    print("Final URL:", resp.url)
    return resp

hooks = {"response": [print_url]}
requests.get("https://httpbin.org/redirect/1", hooks=hooks, timeout=10)
```

#### Mounting an adapter (retries, custom TLS)

```python
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
import requests

retry = Retry(
    total=3,
    backoff_factor=0.5,
    status_forcelist=[502, 503, 504],
    allowed_methods=["GET", "POST"],
)
adapter = HTTPAdapter(max_retries=retry)

s = requests.Session()
s.mount("https://", adapter)
s.mount("http://", adapter)
```

<details>
<summary><strong>Expand: `requests` vs `httpx`</strong></summary>

**`httpx`** supports **HTTP/2**, **async** clients, and a similar API to `requests`. Choose `httpx` when you need **async** Streamlit patterns or HTTP/2; this course standardizes on **`requests`** for simplicity and ubiquity.

</details>

---

<a id="section-8"></a>

## 8. Consuming an API in Streamlit

Streamlit runs **Python on the server**; each interaction may rerun your script. **Network I/O** should be wrapped to avoid blocking the UI without feedback, and **expensive GETs** can be cached.

<a id="section-8-1"></a>

### 8.1 Calling `requests` inside Streamlit

```python
import streamlit as st
import requests

API_BASE_URL = st.secrets.get("API_BASE_URL", "http://localhost:8000")

def health_ok() -> bool:
    try:
        r = requests.get(f"{API_BASE_URL}/health", timeout=3)
        return r.ok and r.json().get("status") == "healthy"
    except requests.RequestException:
        return False

if not health_ok():
    st.error("API offline — start the backend.")
    st.stop()

payload = {"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}

with st.spinner("Calling prediction endpoint..."):
    resp = requests.post(f"{API_BASE_URL}/predict", json=payload, timeout=15)
```

<a id="section-8-2"></a>

### 8.2 `st.spinner` — user feedback during I/O

Use a spinner around any call that may take noticeable time (model inference, remote aggregation).

<a id="section-8-3"></a>

### 8.3 Displaying results: `st.metric`, `st.progress`, `st.dataframe`

```python
import streamlit as st

result = resp.json()
species = result["species"]
confidence = float(result["confidence"])
probs = result["probabilities"]

c1, c2, c3 = st.columns(3)
c1.metric("Predicted species", species.upper())
c2.metric("Confidence", f"{confidence*100:.1f}%")
c3.metric("Classes", len(probs))

st.subheader("Class probabilities")
for name, p in probs.items():
    st.write(f"**{name}**")
    st.progress(float(p))

st.subheader("Raw JSON")
st.dataframe(
    [{"species": species, "confidence": confidence, **{f"p_{k}": v for k, v in probs.items()}}],
    use_container_width=True,
    hide_index=True,
)
```

<a id="section-8-4"></a>

### 8.4 Caching safe GET requests

```python
import streamlit as st
import requests

@st.cache_data(ttl=60)
def get_model_info(base_url: str) -> dict:
    r = requests.get(f"{base_url}/model/info", timeout=10)
    r.raise_for_status()
    return r.json()
```

**Caution:** do not cache endpoints that return **user-specific** or **fast-changing** secrets unless you understand the privacy implications.

<a id="section-8-5"></a>

### 8.5 Secrets, environment configuration, and `st.session_state`

**Secrets (local dev):** create `.streamlit/secrets.toml` (never commit it):

```toml
API_BASE_URL = "http://localhost:8000"
API_KEY = "your-key-if-needed"
```

Read in the app:

```python
import streamlit as st

API_BASE_URL = st.secrets["API_BASE_URL"]
```

On **Streamlit Community Cloud**, configure the same keys in the app settings UI.

**Session state** stores values across reruns within a user session—useful for the **last API response**, pagination cursors, or avoiding duplicate POSTs:

```python
import streamlit as st
import requests

API_BASE_URL = "http://localhost:8000"  # replace with st.secrets["API_BASE_URL"] in production
payload = {"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}

if "last_prediction" not in st.session_state:
    st.session_state.last_prediction = None

if st.button("Predict"):
    with st.spinner("Working..."):
        r = requests.post(f"{API_BASE_URL}/predict", json=payload, timeout=15)
        r.raise_for_status()
        st.session_state.last_prediction = r.json()

if st.session_state.last_prediction:
    st.json(st.session_state.last_prediction)
```

<details>
<summary><strong>Expand: mapping to this repository’s Streamlit app</strong></summary>

The project’s `frontend-streamlit/app.py` uses:

- **`check_api()`** with `GET /health` and a short timeout.  
- **`st.spinner`** during `POST /predict`.  
- **`st.metric`** for model accuracy and dataset stats.  
- **`st.progress`** for per-class probabilities and feature importances.  
- **`st.dataframe`** for tabular stats and random samples from `GET /dataset/stats` and `GET /dataset/samples`.

</details>

---

<a id="section-9"></a>

## 9. Consuming an API with JavaScript (Brief)

Browser or Node.js clients typically use **`fetch`**:

```javascript
const res = await fetch("http://localhost:8000/predict", {
  method: "POST",
  headers: { "Content-Type": "application/json", "Accept": "application/json" },
  body: JSON.stringify({
    sepal_length: 5.1,
    sepal_width: 3.5,
    petal_length: 1.4,
    petal_width: 0.2,
  }),
});
if (!res.ok) throw new Error(`HTTP ${res.status}`);
const data = await res.json();
```

**Note:** browsers enforce **CORS**; server must allow your origin. Streamlit server-side Python calls **are not** subject to browser CORS rules.

---

<a id="section-10"></a>

## 10. Consuming with curl and Postman

### 10.1 curl examples

**GET:**

```bash
curl -sS -H "Accept: application/json" http://localhost:8000/health
```

**POST JSON:**

```bash
curl -sS -X POST "http://localhost:8000/predict" \
  -H "Content-Type: application/json" \
  -d "{\"sepal_length\":5.1,\"sepal_width\":3.5,\"petal_length\":1.4,\"petal_width\":0.2}"
```

**Verbose (debug headers):**

```bash
curl -v http://localhost:8000/
```

### 10.2 Postman / Insomnia / Bruno

GUI clients help you:

- Organize requests in **collections**
- Save **environments** (`base_url`, `api_key`)
- Inspect **timing**, **headers**, and **pretty-printed JSON**
- Generate **code snippets** (including Python `requests`)

---

<a id="section-11"></a>

## 11. Authentication in REST APIs (API Keys, JWT, OAuth2)

| Mechanism | How it works | Pros | Cons |
|-----------|--------------|------|------|
| **API keys** | Shared secret per client/project | Simple | Leak = full access unless scoped & rotated |
| **JWT** | Signed token with claims; often short-lived | Stateless validation; mobile-friendly | Key management; revocation complexity |
| **OAuth2** | Delegated authorization; access + refresh tokens | Fine-grained consent; enterprise IdPs | More moving parts |

**Streamlit tip:** store keys in **`.streamlit/secrets.toml`** (never commit secrets). Read via `st.secrets["API_KEY"]`.

<details>
<summary><strong>Expand: JWT structure (high level)</strong></summary>

A JWT has three Base64URL segments: **header.algorithm**, **payload.claims**, **signature**. APIs verify the signature with a **public key** (asymmetric) or **shared secret** (symmetric HS256). Claims often include **`exp`** (expiry) and **`sub`** (subject).

</details>

---

<a id="section-12"></a>

## 12. CORS (Cross-Origin Resource Sharing)

**Browsers** block JavaScript from reading responses to cross-origin requests unless the **server** opts in with CORS headers.

**Simple requests** (e.g., GET without custom headers) may proceed without preflight; **non-simple** requests trigger an **`OPTIONS` preflight**.

Typical headers set by servers:

| Header | Meaning |
|--------|---------|
| **`Access-Control-Allow-Origin`** | Which origins may read responses (`*` or specific). |
| **`Access-Control-Allow-Methods`** | Allowed verbs for preflight. |
| **`Access-Control-Allow-Headers`** | Allowed request headers. |
| **`Access-Control-Allow-Credentials`** | Whether cookies may be sent. |

**FastAPI example (permissive dev setup):**

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # tighten in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**Key idea:** your **Streamlit** app calling FastAPI from **Python** is **server-side** and **not** limited by browser CORS. CORS matters for **browser** frontends (Flutter web, React) and **public JS** snippets.

---

<a id="section-13"></a>

## 13. REST API Design Best Practices

| Practice | Rationale |
|----------|-----------|
| **Nouns for resources** (`/orders`, `/orders/{id}`) | Clear model; verbs via HTTP methods. |
| **Consistent pluralization** | Predictable URLs. |
| **Use proper status codes** | Machines and humans understand outcomes. |
| **Versioning** (`/v1/...`, header) | Evolve without breaking clients. |
| **Pagination** (`limit`, `cursor`) | Protect server and clients. |
| **Idempotency** for risky POSTs | Prevent duplicate side effects. |
| **OpenAPI documentation** | Auto-generate clients and test UIs. |
| **Rate limiting + clear errors** | Fair use, operational safety. |
| **HATEOAS (when feasible)** | Discoverability for evolving APIs. |

---

<a id="section-14"></a>

## 14. Testing an API

| Level | Tools / ideas |
|-------|----------------|
| **Manual** | curl, Postman, FastAPI `/docs` (Swagger UI) |
| **Automated Python** | `pytest` + `requests` or **`httpx`** + **`pytest` fixtures** |
| **Contract testing** | Schemathesis, Dredd against OpenAPI |
| **Load testing** | k6, Locust |
| **Security** | OWASP ZAP, fuzzing inputs |

**Minimal pytest sketch:**

```python
import requests

BASE = "http://127.0.0.1:8000"

def test_health():
    r = requests.get(f"{BASE}/health", timeout=5)
    assert r.status_code == 200
    assert r.json()["status"] == "healthy"
```

---

<a id="section-15"></a>

## 15. Case Study: Our Iris Application (Streamlit → FastAPI)

This repository implements a **full-stack Iris classifier**:

- **Backend:** `backend/main.py` — **FastAPI** app exposing REST endpoints.  
- **Frontend:** `frontend-streamlit/app.py` — **Streamlit** consuming the API with **`requests`**.

### 15.1 End-to-end sequence (Mermaid)

```mermaid
sequenceDiagram
    participant U as User
    participant ST as Streamlit (app.py)
    participant API as FastAPI (main.py)
    participant M as Model (joblib)

    U->>ST: Adjust sliders, click Predict
    ST->>API: GET /health (timeout 3s)
    API-->>ST: {status, model_loaded}
    ST->>API: POST /predict JSON features
    API->>M: predict + predict_proba
    M-->>API: class index + probabilities
    API-->>ST: {species, confidence, probabilities}
    ST-->>U: st.metric / st.progress / styled output
```

### 15.2 Backend endpoints (summary)

| Method | Path | Role |
|--------|------|------|
| GET | `/` | Root health message |
| GET | `/health` | Liveness + `model_loaded` |
| POST | `/predict` | Classify Iris features (Pydantic body) |
| GET | `/model/info` | Model metadata (accuracy, importances) |
| GET | `/dataset/samples` | Random rows |
| GET | `/dataset/stats` | Aggregated statistics |

### 15.3 Streamlit integration highlights

- **Configuration:** `API_BASE_URL = "http://localhost:8000"` (override with secrets in production).  
- **Resilience:** `check_api()` gates UI actions; exceptions surfaced with `st.error`.  
- **UX:** `st.spinner` during inference; **probabilities** as `st.progress`; **model/dataset** summaries as `st.metric` and `st.dataframe`.

### 15.4 Sample `POST /predict` payload

```json
{
  "sepal_length": 5.1,
  "sepal_width": 3.5,
  "petal_length": 1.4,
  "petal_width": 0.2
}
```

### 15.5 Sample response shape

```json
{
  "species": "setosa",
  "confidence": 0.98,
  "probabilities": {
    "setosa": 0.98,
    "versicolor": 0.01,
    "virginica": 0.01
  }
}
```

This case study ties together **HTTP methods**, **JSON**, **status codes**, **timeouts**, **error handling**, and **Streamlit presentation**—the full consumption lifecycle.

---

<a id="section-16"></a>

## 16. Glossary (55+ terms)

| Term | Definition |
|------|------------|
| **API** | Application Programming Interface — rules and endpoints for programmatic access. |
| **API key** | Secret token identifying a client to an API. |
| **Authentication** | Proving identity (who you are). |
| **Authorization** | Determining allowed actions (what you may do). |
| **Bearer token** | Token sent in `Authorization: Bearer ...`. |
| **Base URL** | Scheme + host + optional port + API prefix for all requests. |
| **Body** | Payload of an HTTP message (e.g., JSON). |
| **Cache** | Stored copy of a response to avoid recomputation or network. |
| **Client** | Initiator of HTTP requests (browser, Streamlit server, mobile app). |
| **Content negotiation** | Choosing representation via `Accept` / `Content-Type`. |
| **Content-Type** | Header describing the format of the request/response body. |
| **CORS** | Browser security model for cross-origin HTTP from JavaScript. |
| **CRUD** | Create, Read, Update, Delete — maps loosely to POST/GET/PUT/PATCH/DELETE. |
| **Endpoint** | A concrete URL + method combination exposed by a server. |
| **Header** | Metadata line in an HTTP message. |
| **HATEOAS** | Hypermedia as the Engine of Application State — responses include navigable links. |
| **HTTP** | Application protocol for distributed hypermedia systems. |
| **HTTPS** | HTTP secured with TLS encryption. |
| **Idempotency** | Repeating a request has the same effect as doing it once (for successful application). |
| **JSON** | Lightweight text format for structured data. |
| **JWT** | JSON Web Token — compact, signed representation of claims. |
| **Latency** | Time delay between request and response. |
| **Middleware** | Pluggable processing layer (e.g., CORS) around an app. |
| **OAuth2** | Authorization framework for delegated access. |
| **OpenAPI** | Machine-readable API description (formerly Swagger). |
| **Payload** | Data carried in a message body. |
| **Pagination** | Splitting large result sets across pages or cursors. |
| **PATCH** | HTTP method for partial updates. |
| **POST** | HTTP method often used to create resources or submit data. |
| **PUT** | HTTP method to replace a resource at a URI. |
| **Query string** | `?key=value&...` appended to a URL. |
| **Rate limit** | Policy restricting request frequency per client/key. |
| **Representation** | Serialized form of a resource (e.g., JSON object). |
| **Resource** | Conceptual entity addressed by URLs (nouns). |
| **REST** | Architectural style for networked systems using HTTP semantics. |
| **Retry-After** | Header suggesting wait time before another request. |
| **Server** | Program accepting HTTP connections and returning responses. |
| **Session (`requests.Session`)** | Object that persists settings and connection pooling. |
| **SOAP** | XML-based messaging protocol often associated with WSDL. |
| **SSL/TLS** | Cryptographic protocols securing HTTPS. |
| **Status code** | Numeric HTTP outcome indicator (e.g., 404). |
| **Streamlit** | Python framework for building data apps quickly. |
| **Timeout** | Maximum time to wait for a network operation. |
| **URI/URL** | Identifiers/locators for resources on the Web. |
| **XML** | Extensible Markup Language — structured, verbose text format. |
| **YAML** | Human-friendly serialization language common in configs. |
| **422 Unprocessable Entity** | Validation failed — common with FastAPI/Pydantic. |
| **Webhook** | HTTP callback invoked by a server on events (push model). |
| **Circuit breaker** | Pattern to stop calling a failing dependency until it recovers. |
| **Correlation ID** | Unique id carried in headers to trace a request across services. |
| **Deprecation** | Marking an API surface as scheduled for removal; consumers should migrate. |
| **ETag** | Opaque validator for a representation; enables conditional GETs (`If-None-Match`). |
| **Exponential backoff** | Retry strategy increasing delay between attempts to reduce load. |
| **FastAPI** | Modern Python web framework; automatic OpenAPI docs and Pydantic validation. |
| **Idempotency-Key** | Client-supplied header so duplicate POSTs are deduplicated server-side. |
| **MIME type** | Media type label (e.g., `application/json`) describing message format. |
| **Pydantic** | Data validation library used heavily by FastAPI for request/response models. |
| **Reverse proxy** | Intermediary facing clients, forwarding to upstream app servers (e.g., Nginx). |
| **RPC** | Remote Procedure Call style—functions over the network; contrast with pure REST nouns. |
| **SLA** | Service Level Agreement — promised availability/latency targets. |
| **Snake_case** | JSON field naming convention common in Python APIs (`petal_length`). |
| **Streaming response** | Body delivered in chunks (`iter_content`) for large downloads. |
| **TLS handshake** | Cryptographic negotiation establishing HTTPS session keys. |
| **urllib3** | Low-level HTTP library underlying `requests`. |

---

<a id="section-17"></a>

## 17. Conclusion

Consuming **REST** APIs is a foundational skill for **Streamlit** developers building serious applications. Master the **HTTP method semantics**, **status codes**, and **JSON** payloads; wrap **`requests`** calls with **timeouts**, **session defaults**, and **clear error handling**; and craft **responsive UIs** using **`st.spinner`**, **`st.metric`**, **`st.progress`**, and **`st.dataframe`**. Understand **authentication** and **CORS** in context—server-side Streamlit calls bypass browser CORS, but browser clients do not. Finally, treat **OpenAPI docs** and **automated tests** as part of the contract between your UI and backend—your **Iris** demo is a concise blueprint for this end-to-end pattern.

[⬆ Back to top](#top)
