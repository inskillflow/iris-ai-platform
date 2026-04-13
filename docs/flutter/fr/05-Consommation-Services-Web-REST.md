<a id="top"></a>

# 05 — Consommation des Services Web REST : De la Théorie à la Pratique

> **Cours de référence** — Ce document constitue le guide exhaustif sur les services web REST : architecture, protocole HTTP, méthodes, codes de statut, formats de données, consommation en Python / Dart / JavaScript, authentification, CORS, bonnes pratiques, tests, et mise en application concrète avec notre projet Iris ML.

---

## Table des matières

| # | Section |
|---|---------|
| 1 | [Qu'est-ce qu'un service web ?](#section-1) |
| &nbsp;&nbsp;&nbsp;↳ | [Définition et principes fondamentaux](#section-1) |
| &nbsp;&nbsp;&nbsp;↳ | [SOAP vs REST — Comparaison historique](#section-1) |
| &nbsp;&nbsp;&nbsp;↳ | [Pourquoi REST a gagné](#section-1) |
| 2 | [L'architecture REST en profondeur](#section-2) |
| &nbsp;&nbsp;&nbsp;↳ | [Les 6 contraintes architecturales](#section-2) |
| &nbsp;&nbsp;&nbsp;↳ | [Le modèle de maturité de Richardson](#section-2) |
| 3 | [Le protocole HTTP](#section-3) |
| &nbsp;&nbsp;&nbsp;↳ | [Cycle requête/réponse](#section-3) |
| &nbsp;&nbsp;&nbsp;↳ | [Anatomie d'une URL](#section-3) |
| &nbsp;&nbsp;&nbsp;↳ | [En-têtes HTTP (Headers)](#section-3) |
| 4 | [Les méthodes HTTP](#section-4) |
| &nbsp;&nbsp;&nbsp;↳ | [GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD](#section-4) |
| &nbsp;&nbsp;&nbsp;↳ | [Tableau comparatif complet](#section-4) |
| 5 | [Les codes de statut HTTP](#section-5) |
| &nbsp;&nbsp;&nbsp;↳ | [1xx, 2xx, 3xx, 4xx, 5xx](#section-5) |
| &nbsp;&nbsp;&nbsp;↳ | [Tableau détaillé avec cas d'usage](#section-5) |
| 6 | [Les formats de données](#section-6) |
| &nbsp;&nbsp;&nbsp;↳ | [JSON vs XML vs YAML](#section-6) |
| &nbsp;&nbsp;&nbsp;↳ | [Sérialisation et désérialisation](#section-6) |
| 7 | [Consommer une API avec Python](#section-7) |
| &nbsp;&nbsp;&nbsp;↳ | [La bibliothèque requests](#section-7) |
| &nbsp;&nbsp;&nbsp;↳ | [GET, POST, PUT, DELETE avec exemples](#section-7) |
| 8 | [Consommer une API avec Dart/Flutter](#section-8) |
| &nbsp;&nbsp;&nbsp;↳ | [Le package http](#section-8) |
| &nbsp;&nbsp;&nbsp;↳ | [Code réel du projet Iris](#section-8) |
| 9 | [Consommer une API avec JavaScript](#section-9) |
| &nbsp;&nbsp;&nbsp;↳ | [Fetch API et Axios](#section-9) |
| 10 | [Consommer une API avec curl et Postman](#section-10) |
| &nbsp;&nbsp;&nbsp;↳ | [Commandes curl](#section-10) |
| &nbsp;&nbsp;&nbsp;↳ | [Utilisation de Postman](#section-10) |
| 11 | [Authentification dans les APIs REST](#section-11) |
| &nbsp;&nbsp;&nbsp;↳ | [API Keys, JWT, OAuth2](#section-11) |
| 12 | [CORS — Cross-Origin Resource Sharing](#section-12) |
| &nbsp;&nbsp;&nbsp;↳ | [Requêtes preflight, configuration](#section-12) |
| 13 | [Bonnes pratiques de conception d'API REST](#section-13) |
| &nbsp;&nbsp;&nbsp;↳ | [Nommage, versioning, pagination, HATEOAS](#section-13) |
| 14 | [Tester une API](#section-14) |
| &nbsp;&nbsp;&nbsp;↳ | [Swagger UI, REST Client, Postman, pytest](#section-14) |
| 15 | [Cas pratique : notre application Iris](#section-15) |
| &nbsp;&nbsp;&nbsp;↳ | [Traçage complet d'une requête Flutter → FastAPI → réponse](#section-15) |
| 16 | [Glossaire des termes](#section-16) |
| 17 | [Conclusion et ressources](#section-17) |

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 1 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-1"></a>

<details>
<summary><strong>1 — Qu'est-ce qu'un service web ?</strong></summary>

### 1.1 Définition

Un **service web** (web service) est un système logiciel conçu pour permettre l'**interopérabilité** entre machines à travers un réseau. Il expose des fonctionnalités accessibles via des protocoles standardisés (principalement HTTP), indépendamment du langage de programmation, du système d'exploitation ou de la plateforme utilisée.

> **En termes simples** : un service web est un programme qui « écoute » sur le réseau et répond à des requêtes envoyées par d'autres programmes (clients).

#### Caractéristiques d'un service web

| Caractéristique | Description |
|----------------|-------------|
| **Interopérable** | Fonctionne entre langages et plateformes différentes |
| **Basé sur des standards** | Utilise HTTP, JSON, XML, URI |
| **Accessible via le réseau** | Communique via Internet ou un réseau local |
| **Auto-descriptif** | Peut décrire ses propres capacités (WSDL, OpenAPI) |
| **Découvrable** | Peut être trouvé via des registres ou de la documentation |

### 1.2 Les deux grandes familles : SOAP et REST

#### SOAP (Simple Object Access Protocol)

SOAP est un protocole de messagerie basé sur **XML** qui définit un format strict pour l'échange de données. Il utilise un **enveloppe XML** contenant un en-tête (optionnel) et un corps (obligatoire).

```xml
<?xml version="1.0"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Header>
    <auth:Token xmlns:auth="http://example.com/auth">abc123</auth:Token>
  </soap:Header>
  <soap:Body>
    <m:GetIrisSpecies xmlns:m="http://example.com/iris">
      <m:SepalLength>5.1</m:SepalLength>
      <m:SepalWidth>3.5</m:SepalWidth>
      <m:PetalLength>1.4</m:PetalLength>
      <m:PetalWidth>0.2</m:PetalWidth>
    </m:GetIrisSpecies>
  </soap:Body>
</soap:Envelope>
```

#### REST (Representational State Transfer)

REST est un **style architectural** (pas un protocole) défini par Roy Fielding dans sa thèse de doctorat en 2000. Il repose sur les standards existants du web (HTTP, URI, JSON/XML).

```json
POST /predict HTTP/1.1
Host: localhost:8000
Content-Type: application/json

{
  "sepal_length": 5.1,
  "sepal_width": 3.5,
  "petal_length": 1.4,
  "petal_width": 0.2
}
```

### 1.3 Tableau comparatif SOAP vs REST

| Critère | SOAP | REST |
|---------|------|------|
| **Type** | Protocole | Style architectural |
| **Format de données** | XML uniquement | JSON, XML, YAML, texte, binaire |
| **Transport** | HTTP, SMTP, TCP, JMS | HTTP principalement |
| **Contrat** | WSDL (obligatoire) | OpenAPI/Swagger (optionnel) |
| **État** | Peut être stateful | Stateless par design |
| **Performance** | Plus lourd (XML + enveloppe) | Plus léger (JSON minimal) |
| **Mise en cache** | Complexe | Native via HTTP |
| **Courbe d'apprentissage** | Élevée | Faible à modérée |
| **Sécurité intégrée** | WS-Security (très robuste) | HTTPS + tokens (flexible) |
| **Transactions** | WS-AtomicTransaction | Non supporté nativement |
| **Cas d'usage typique** | Banques, ERP, systèmes critiques | APIs web, mobile, microservices |

### 1.4 Chronologie historique

```mermaid
timeline
    title Évolution des Services Web
    1998 : XML-RPC
         : Premier protocole d'appel de procédure distant basé sur XML
    2000 : SOAP 1.1
         : Publication par Microsoft, IBM et autres
    2000 : REST
         : Roy Fielding publie sa thèse de doctorat
    2001 : WSDL 1.1
         : Standard de description pour services SOAP
    2004 : SOAP 1.2
         : Recommandation W3C officielle
    2005 : Web 2.0
         : Explosion des APIs REST (Flickr, del.icio.us)
    2006 : Twitter API
         : REST domine les APIs publiques
    2010 : Swagger
         : Outil de documentation pour APIs REST
    2013 : Microservices
         : REST devient le standard de communication inter-services
    2015 : OpenAPI 2.0
         : Swagger devient un standard ouvert
    2017 : OpenAPI 3.0
         : Adoption massive par l'industrie
    2021 : OpenAPI 3.1
         : Alignement avec JSON Schema
    2024 : REST + IA
         : APIs REST pour modèles ML (notre projet !)
```

### 1.5 Pourquoi REST a gagné

REST a surpassé SOAP pour plusieurs raisons fondamentales :

1. **Simplicité** — Pas d'enveloppe XML complexe, pas de WSDL à générer
2. **Légèreté** — JSON est 2 à 10 fois plus compact que XML SOAP
3. **Performance** — Mise en cache HTTP native, moins de bande passante
4. **Flexibilité** — Supporte plusieurs formats (JSON, XML, binaire)
5. **Adoption web** — Utilise les mêmes standards que le web (HTTP, URI)
6. **Mobile-friendly** — Essentiel avec l'explosion des apps mobiles (2007+)
7. **Outillage** — Outils simples : curl, Postman, navigateur web

```mermaid
pie title Adoption des styles d'API (2024)
    "REST" : 83
    "GraphQL" : 10
    "gRPC" : 4
    "SOAP" : 2
    "Autre" : 1
```

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 2 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-2"></a>

<details>
<summary><strong>2 — L'architecture REST en profondeur</strong></summary>

### 2.1 Les 6 contraintes architecturales de REST

Roy Fielding a défini 6 contraintes que doit respecter un système pour être qualifié de « RESTful ». Ces contraintes ne sont pas des recommandations — ce sont des **exigences architecturales**.

```mermaid
graph TD
    REST["🏗️ Architecture REST"]
    C1["1. Client-Serveur"]
    C2["2. Sans état (Stateless)"]
    C3["3. Mise en cache (Cacheable)"]
    C4["4. Interface uniforme"]
    C5["5. Système en couches"]
    C6["6. Code à la demande (optionnel)"]

    REST --> C1
    REST --> C2
    REST --> C3
    REST --> C4
    REST --> C5
    REST --> C6

    style REST fill:#1a73e8,stroke:#fff,color:#fff
    style C1 fill:#34a853,stroke:#fff,color:#fff
    style C2 fill:#34a853,stroke:#fff,color:#fff
    style C3 fill:#34a853,stroke:#fff,color:#fff
    style C4 fill:#34a853,stroke:#fff,color:#fff
    style C5 fill:#34a853,stroke:#fff,color:#fff
    style C6 fill:#fbbc04,stroke:#fff,color:#333
```

#### Contrainte 1 : Client-Serveur (Client-Server)

**Principe** : Le client et le serveur sont séparés et évoluent indépendamment.

- Le **client** gère l'interface utilisateur et l'expérience utilisateur
- Le **serveur** gère le stockage de données, la logique métier et le traitement

**Avantages** :
- Le frontend (Flutter) peut évoluer sans toucher au backend (FastAPI)
- Le backend peut être déployé sur un serveur différent
- Plusieurs clients (mobile, web, CLI) peuvent partager le même backend
- Chaque équipe peut travailler indépendamment

```mermaid
graph LR
    subgraph "Côté Client"
        A["📱 Flutter App"]
        B["🌐 Application Web"]
        C["💻 Script Python"]
    end

    subgraph "Côté Serveur"
        D["⚡ FastAPI"]
        E["🗄️ Base de données"]
        F["🤖 Modèle ML"]
    end

    A -->|HTTP/JSON| D
    B -->|HTTP/JSON| D
    C -->|HTTP/JSON| D
    D --> E
    D --> F
```

**Dans notre projet** : L'application Flutter (`frontend/`) est complètement séparée de l'API FastAPI (`backend/`). Elles communiquent uniquement via HTTP.

#### Contrainte 2 : Sans état (Stateless)

**Principe** : Chaque requête du client contient **toutes** les informations nécessaires pour être comprise par le serveur. Le serveur ne stocke aucun contexte de session entre les requêtes.

**Concrètement** :
- Pas de sessions côté serveur
- Chaque requête est autonome
- L'authentification est transmise à chaque requête (token dans l'en-tête)

```
✅ Requête stateless (correcte)
POST /predict HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
Content-Type: application/json

{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}

❌ Approche stateful (violant REST)
POST /predict HTTP/1.1
Session-Id: abc123
(le serveur doit se souvenir qui est abc123 et quels sont ses droits)
```

**Avantages** :
- **Scalabilité** — N'importe quel serveur peut traiter n'importe quelle requête
- **Fiabilité** — Pas de perte de contexte en cas de redémarrage
- **Simplicité** — Pas de gestion de sessions complexe

#### Contrainte 3 : Mise en cache (Cacheable)

**Principe** : Les réponses doivent se définir implicitement ou explicitement comme **cacheables** ou **non-cacheables**. Si une réponse est cacheable, le client peut réutiliser cette réponse pour des requêtes ultérieures équivalentes.

**Mécanismes HTTP de cache** :

| En-tête | Rôle | Exemple |
|---------|------|---------|
| `Cache-Control` | Directives de mise en cache | `Cache-Control: max-age=3600` |
| `ETag` | Identifiant unique de version | `ETag: "abc123"` |
| `Last-Modified` | Date de dernière modification | `Last-Modified: Mon, 13 Apr 2026 14:00:00 GMT` |
| `Expires` | Date d'expiration absolue | `Expires: Mon, 13 Apr 2026 15:00:00 GMT` |
| `If-None-Match` | Validation conditionnelle (client) | `If-None-Match: "abc123"` |

```
Client                          Serveur
  |                                |
  |-- GET /model/info ------------>|
  |                                |
  |<-- 200 OK --------------------|
  |    ETag: "v1.0"                |
  |    Cache-Control: max-age=600  |
  |                                |
  |   [10 min plus tard]           |
  |                                |
  |-- GET /model/info ------------>|
  |   If-None-Match: "v1.0"       |
  |                                |
  |<-- 304 Not Modified ----------|
  |   (pas de corps, le cache     |
  |    du client est encore bon)   |
```

#### Contrainte 4 : Interface uniforme (Uniform Interface)

C'est la contrainte **la plus fondamentale** de REST. Elle se décompose en 4 sous-contraintes :

**4a. Identification des ressources** — Chaque ressource est identifiée par une URI unique.

```
/predict          → Ressource de prédiction
/model/info       → Informations du modèle
/dataset/samples  → Échantillons du dataset
/dataset/stats    → Statistiques du dataset
```

**4b. Manipulation des ressources par les représentations** — Le client manipule les ressources à travers leurs représentations (JSON, XML). La représentation contient assez d'informations pour modifier ou supprimer la ressource.

**4c. Messages auto-descriptifs** — Chaque message contient suffisamment d'informations pour décrire comment traiter le message (via les en-têtes HTTP, le Content-Type, etc.).

```
POST /predict HTTP/1.1
Content-Type: application/json     ← dit au serveur : "c'est du JSON"
Accept: application/json           ← dit au serveur : "je veux du JSON en retour"
```

**4d. HATEOAS (Hypermedia As The Engine Of Application State)** — Les réponses contiennent des liens vers les actions possibles suivantes. C'est la contrainte la moins implémentée en pratique.

```json
{
  "species": "setosa",
  "confidence": 1.0,
  "_links": {
    "self": { "href": "/predict" },
    "model_info": { "href": "/model/info" },
    "dataset": { "href": "/dataset/samples" }
  }
}
```

#### Contrainte 5 : Système en couches (Layered System)

**Principe** : Le client ne peut pas savoir s'il est connecté directement au serveur final ou à un intermédiaire. Des couches (load balancer, proxy, cache, passerelle API) peuvent être insérées de manière transparente.

```mermaid
graph LR
    Client["📱 Client Flutter"]
    LB["⚖️ Load Balancer<br/>(Nginx)"]
    Cache["📦 Cache<br/>(Redis)"]
    API1["⚡ API Server 1"]
    API2["⚡ API Server 2"]
    API3["⚡ API Server 3"]
    DB["🗄️ Base de données"]

    Client --> LB
    LB --> Cache
    Cache --> API1
    Cache --> API2
    Cache --> API3
    API1 --> DB
    API2 --> DB
    API3 --> DB
```

#### Contrainte 6 : Code à la demande (Code on Demand) — Optionnelle

**Principe** : Le serveur peut envoyer du code exécutable au client (JavaScript, applets) pour étendre ses fonctionnalités. C'est la seule contrainte **optionnelle**.

**Exemple** : Un serveur qui retourne un script JavaScript pour valider un formulaire côté client.

### 2.2 Le modèle de maturité de Richardson

Leonard Richardson a proposé un modèle pour évaluer le niveau de « RESTfulness » d'une API :

```mermaid
graph BT
    L0["Niveau 0 — Le marais du POX<br/>Un seul endpoint, une seule méthode (POST)<br/>Exemple : XML-RPC, SOAP"]
    L1["Niveau 1 — Ressources<br/>Plusieurs URI, mais toujours POST<br/>Exemple : POST /users, POST /orders"]
    L2["Niveau 2 — Verbes HTTP<br/>Utilisation des méthodes HTTP (GET, POST, PUT, DELETE)<br/>+ codes de statut appropriés<br/>🎯 Notre API Iris est ici"]
    L3["Niveau 3 — Contrôles hypermédia<br/>HATEOAS : les réponses contiennent<br/>des liens vers les actions suivantes"]

    L0 --> L1
    L1 --> L2
    L2 --> L3

    style L0 fill:#ea4335,stroke:#fff,color:#fff
    style L1 fill:#fbbc04,stroke:#fff,color:#333
    style L2 fill:#34a853,stroke:#fff,color:#fff
    style L3 fill:#1a73e8,stroke:#fff,color:#fff
```

| Niveau | Nom | Caractéristiques | Exemple |
|--------|-----|-----------------|---------|
| 0 | Le marais du POX | Un seul URI, un seul verbe HTTP | `POST /api` pour tout |
| 1 | Ressources | Plusieurs URI, mais verbes mal utilisés | `POST /users/create`, `POST /users/delete` |
| 2 | Verbes HTTP | URI + verbes HTTP + codes de statut corrects | `GET /users`, `DELETE /users/42` |
| 3 | HATEOAS | Niveau 2 + liens hypermédia dans les réponses | Réponse avec `_links` |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 3 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-3"></a>

<details>
<summary><strong>3 — Le protocole HTTP</strong></summary>

### 3.1 Qu'est-ce que HTTP ?

**HTTP** (HyperText Transfer Protocol) est le protocole de communication fondamental du World Wide Web. C'est un protocole de la **couche application** (couche 7 du modèle OSI) qui fonctionne selon un modèle **requête-réponse**.

| Propriété | Valeur |
|-----------|--------|
| **Port par défaut** | 80 (HTTP), 443 (HTTPS) |
| **Version actuelle** | HTTP/3 (basé sur QUIC) |
| **Transport** | TCP (HTTP/1.1, HTTP/2), UDP (HTTP/3) |
| **Type** | Sans état (stateless) |
| **Sécurité** | HTTPS = HTTP + TLS/SSL |

### 3.2 Le cycle requête-réponse

```mermaid
sequenceDiagram
    participant C as 📱 Client (Flutter)
    participant DNS as 🌐 DNS
    participant S as ⚡ Serveur (FastAPI)

    Note over C: L'utilisateur clique sur "Prédire"

    C->>DNS: Résolution DNS : localhost → 127.0.0.1
    DNS-->>C: 127.0.0.1

    C->>S: 1️⃣ Connexion TCP (3-way handshake)
    S-->>C: Connexion établie

    Note over C,S: Échange HTTP

    C->>S: 2️⃣ Requête HTTP<br/>POST /predict HTTP/1.1<br/>Host: localhost:8000<br/>Content-Type: application/json<br/><br/>{"sepal_length": 5.1, ...}

    Note over S: 3️⃣ Traitement<br/>- Validation des données<br/>- Exécution du modèle ML<br/>- Construction de la réponse

    S-->>C: 4️⃣ Réponse HTTP<br/>HTTP/1.1 200 OK<br/>Content-Type: application/json<br/><br/>{"species": "setosa", ...}

    Note over C: 5️⃣ Traitement de la réponse<br/>- Décodage JSON<br/>- Mise à jour de l'UI
```

### 3.3 Anatomie d'une requête HTTP

Une requête HTTP est composée de 4 parties :

```
┌─────────────────────────────────────────────────────┐
│  POST /predict HTTP/1.1                    ← Ligne de requête
├─────────────────────────────────────────────────────┤
│  Host: localhost:8000                      ← En-têtes
│  Content-Type: application/json            │
│  Accept: application/json                  │
│  Authorization: Bearer eyJhbGci...         │
│  User-Agent: Dart/3.0                      │
│  Content-Length: 82                         │
├─────────────────────────────────────────────────────┤
│                                            ← Ligne vide (séparateur)
├─────────────────────────────────────────────────────┤
│  {                                         ← Corps (Body)
│    "sepal_length": 5.1,                    │
│    "sepal_width": 3.5,                     │
│    "petal_length": 1.4,                    │
│    "petal_width": 0.2                      │
│  }                                         │
└─────────────────────────────────────────────────────┘
```

**Détail de la ligne de requête** :

```
POST       /predict       HTTP/1.1
 │            │               │
 │            │               └── Version du protocole
 │            └────────────────── Chemin de la ressource (URI)
 └─────────────────────────────── Méthode HTTP
```

### 3.4 Anatomie d'une réponse HTTP

```
┌─────────────────────────────────────────────────────┐
│  HTTP/1.1 200 OK                           ← Ligne de statut
├─────────────────────────────────────────────────────┤
│  Content-Type: application/json            ← En-têtes
│  Content-Length: 95                         │
│  Date: Mon, 13 Apr 2026 14:30:00 GMT       │
│  Server: uvicorn                           │
├─────────────────────────────────────────────────────┤
│                                            ← Ligne vide
├─────────────────────────────────────────────────────┤
│  {                                         ← Corps (Body)
│    "species": "setosa",                    │
│    "confidence": 1.0,                      │
│    "probabilities": {                      │
│      "setosa": 1.0,                        │
│      "versicolor": 0.0,                    │
│      "virginica": 0.0                      │
│    }                                       │
│  }                                         │
└─────────────────────────────────────────────────────┘
```

### 3.5 Anatomie d'une URL

```
https://api.example.com:8443/v2/users/42/orders?status=active&page=2#summary
└─┬──┘ └───────┬───────┘└┬─┘└──────────┬──────┘└──────────┬────────┘└──┬───┘
scheme       host      port         path            query string     fragment

  │            │         │            │                  │               │
  │            │         │            │                  │               └── Fragment (côté client)
  │            │         │            │                  └── Paramètres de requête (query params)
  │            │         │            └── Chemin vers la ressource (path)
  │            │         └── Port (optionnel, 443 par défaut pour HTTPS)
  │            └── Nom d'hôte (host)
  └── Protocole (scheme)
```

**Différence entre path params et query params** :

| Type | Syntaxe | Usage | Exemple |
|------|---------|-------|---------|
| **Path param** | `/resource/{id}` | Identifier une ressource spécifique | `/users/42` |
| **Query param** | `?clé=valeur` | Filtrer, trier, paginer | `/users?role=admin&page=2` |

### 3.6 Les en-têtes HTTP courants

#### En-têtes de requête

| En-tête | Description | Exemple |
|---------|-------------|---------|
| `Host` | Nom d'hôte du serveur | `Host: localhost:8000` |
| `Content-Type` | Type MIME du corps | `Content-Type: application/json` |
| `Accept` | Types MIME acceptés en réponse | `Accept: application/json` |
| `Authorization` | Jeton d'authentification | `Authorization: Bearer eyJ...` |
| `User-Agent` | Identité du client | `User-Agent: Dart/3.0` |
| `Accept-Language` | Langues préférées | `Accept-Language: fr-FR, en-US` |
| `Accept-Encoding` | Encodages acceptés | `Accept-Encoding: gzip, deflate` |
| `If-None-Match` | Validation de cache (ETag) | `If-None-Match: "abc123"` |
| `Origin` | Origine de la requête (CORS) | `Origin: http://localhost:3000` |

#### En-têtes de réponse

| En-tête | Description | Exemple |
|---------|-------------|---------|
| `Content-Type` | Type MIME de la réponse | `Content-Type: application/json` |
| `Content-Length` | Taille du corps en octets | `Content-Length: 256` |
| `Cache-Control` | Directives de cache | `Cache-Control: no-cache` |
| `Set-Cookie` | Définir un cookie | `Set-Cookie: session=abc; HttpOnly` |
| `Access-Control-Allow-Origin` | Origines autorisées (CORS) | `Access-Control-Allow-Origin: *` |
| `Location` | URI de redirection | `Location: /users/42` |
| `ETag` | Version de la ressource | `ETag: "v1.0.3"` |
| `X-Request-Id` | Identifiant de traçabilité | `X-Request-Id: 550e8400-e29b...` |

### 3.7 Types MIME courants

| Type MIME | Extension | Usage |
|-----------|-----------|-------|
| `application/json` | `.json` | APIs REST (format dominant) |
| `application/xml` | `.xml` | APIs SOAP, flux RSS |
| `text/html` | `.html` | Pages web |
| `text/plain` | `.txt` | Texte brut |
| `multipart/form-data` | — | Upload de fichiers |
| `application/x-www-form-urlencoded` | — | Formulaires HTML |
| `application/octet-stream` | — | Données binaires |
| `image/png` | `.png` | Images PNG |
| `application/pdf` | `.pdf` | Documents PDF |

### 3.8 HTTP/1.1 vs HTTP/2 vs HTTP/3

| Caractéristique | HTTP/1.1 | HTTP/2 | HTTP/3 |
|----------------|----------|--------|--------|
| **Année** | 1997 | 2015 | 2022 |
| **Multiplexage** | Non (1 requête à la fois par connexion) | Oui (streams multiples) | Oui |
| **Compression des en-têtes** | Non | Oui (HPACK) | Oui (QPACK) |
| **Transport** | TCP | TCP | UDP (QUIC) |
| **Server Push** | Non | Oui | Oui |
| **Texte/Binaire** | Texte | Binaire | Binaire |
| **Head-of-line blocking** | Oui | Partiellement résolu | Résolu |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 4 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-4"></a>

<details>
<summary><strong>4 — Les méthodes HTTP</strong></summary>

### 4.1 Vue d'ensemble

Les méthodes HTTP (aussi appelées « verbes HTTP ») indiquent l'**action souhaitée** à effectuer sur la ressource identifiée par l'URI.

### 4.2 Tableau comparatif complet

| Méthode | Opération CRUD | Idempotente ? | Sûre ? | Corps de requête ? | Corps de réponse ? | Usage typique |
|---------|---------------|---------------|--------|--------------------|--------------------|---------------|
| **GET** | **R**ead | ✅ Oui | ✅ Oui | ❌ Non | ✅ Oui | Récupérer une ressource |
| **POST** | **C**reate | ❌ Non | ❌ Non | ✅ Oui | ✅ Oui | Créer une ressource / déclencher une action |
| **PUT** | **U**pdate (complet) | ✅ Oui | ❌ Non | ✅ Oui | ✅ Optionnel | Remplacer entièrement une ressource |
| **PATCH** | **U**pdate (partiel) | ❌ Non* | ❌ Non | ✅ Oui | ✅ Optionnel | Modifier partiellement une ressource |
| **DELETE** | **D**elete | ✅ Oui | ❌ Non | ❌ Optionnel | ✅ Optionnel | Supprimer une ressource |
| **OPTIONS** | — | ✅ Oui | ✅ Oui | ❌ Non | ✅ Oui | Découvrir les méthodes supportées (CORS) |
| **HEAD** | — | ✅ Oui | ✅ Oui | ❌ Non | ❌ Non | Comme GET mais sans le corps de réponse |

> **Idempotente** : Exécuter la même requête N fois produit toujours le même résultat.
> **Sûre** : La requête ne modifie pas l'état du serveur.
> *PATCH peut être idempotente si l'opération est déterministe.

### 4.3 Détail de chaque méthode

#### GET — Lire une ressource

```http
GET /model/info HTTP/1.1
Host: localhost:8000
Accept: application/json
```

Réponse :
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "model_type": "RandomForestClassifier",
  "accuracy": 0.9667,
  "feature_names": ["sepal length (cm)", "sepal width (cm)", "petal length (cm)", "petal width (cm)"],
  "target_names": ["setosa", "versicolor", "virginica"]
}
```

**Règles** :
- Ne doit jamais modifier l'état du serveur
- Le résultat peut être mis en cache
- Les paramètres passent dans l'URL (query string)
- Pas de corps de requête

#### POST — Créer une ressource ou déclencher une action

```http
POST /predict HTTP/1.1
Host: localhost:8000
Content-Type: application/json

{
  "sepal_length": 5.1,
  "sepal_width": 3.5,
  "petal_length": 1.4,
  "petal_width": 0.2
}
```

Réponse :
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "species": "setosa",
  "confidence": 1.0,
  "probabilities": {"setosa": 1.0, "versicolor": 0.0, "virginica": 0.0}
}
```

**Règles** :
- Utilisé pour créer une nouvelle ressource ou déclencher un traitement
- Non idempotent — chaque appel peut créer un nouvel enregistrement
- Lors d'une création, le serveur devrait retourner `201 Created` avec un en-tête `Location`
- Le corps de requête contient les données de la nouvelle ressource

#### PUT — Remplacer entièrement une ressource

```http
PUT /users/42 HTTP/1.1
Content-Type: application/json

{
  "id": 42,
  "name": "Jean Dupont",
  "email": "jean@example.com",
  "role": "admin"
}
```

**Règles** :
- Remplace **toute** la ressource (pas de mise à jour partielle)
- Idempotent — envoyer la même requête 10 fois a le même effet
- Si la ressource n'existe pas, peut la créer (comportement optionnel)
- Toutes les propriétés doivent être fournies

#### PATCH — Modifier partiellement une ressource

```http
PATCH /users/42 HTTP/1.1
Content-Type: application/json

{
  "role": "superadmin"
}
```

**Règles** :
- Modifie **seulement** les champs fournis
- Les champs non fournis restent inchangés
- Plus économe en bande passante que PUT

**Différence PUT vs PATCH** :

```
Ressource actuelle :
{ "id": 42, "name": "Jean", "email": "jean@ex.com", "role": "admin" }

PUT /users/42 avec { "role": "superadmin" }
→ Résultat : { "role": "superadmin" }           ← Les autres champs sont PERDUS !

PATCH /users/42 avec { "role": "superadmin" }
→ Résultat : { "id": 42, "name": "Jean", "email": "jean@ex.com", "role": "superadmin" }
                                                  ← Seul le champ modifié change
```

#### DELETE — Supprimer une ressource

```http
DELETE /users/42 HTTP/1.1
Host: api.example.com
Authorization: Bearer eyJ...
```

Réponse :
```http
HTTP/1.1 204 No Content
```

**Règles** :
- Supprime la ressource identifiée
- Idempotent — supprimer deux fois la même ressource donne le même résultat
- Retourne `204 No Content` (succès sans corps) ou `200 OK` (avec confirmation)

#### OPTIONS — Découvrir les capacités

```http
OPTIONS /predict HTTP/1.1
Host: localhost:8000
Origin: http://localhost:5000
```

Réponse :
```http
HTTP/1.1 200 OK
Allow: GET, POST, OPTIONS
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE
Access-Control-Allow-Headers: Content-Type, Authorization
```

**Usage principal** : Requête **preflight** CORS (voir section 12).

#### HEAD — Métadonnées sans le corps

```http
HEAD /dataset/samples HTTP/1.1
Host: localhost:8000
```

Réponse :
```http
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 1523
```

**Usage** : Vérifier si une ressource existe, connaître sa taille, sans télécharger le contenu.

### 4.4 Correspondance avec les opérations CRUD

```mermaid
graph LR
    subgraph "CRUD"
        CR["Create"]
        RE["Read"]
        UP["Update"]
        DE["Delete"]
    end

    subgraph "HTTP"
        POST["POST"]
        GET["GET"]
        PUT["PUT"]
        PATCH["PATCH"]
        DELETE["DELETE"]
    end

    CR --> POST
    RE --> GET
    UP --> PUT
    UP --> PATCH
    DE --> DELETE

    style CR fill:#34a853,stroke:#fff,color:#fff
    style RE fill:#1a73e8,stroke:#fff,color:#fff
    style UP fill:#fbbc04,stroke:#fff,color:#333
    style DE fill:#ea4335,stroke:#fff,color:#fff
```

### 4.5 Exemples concrets avec notre API Iris

| Action | Méthode | Endpoint | Corps |
|--------|---------|----------|-------|
| Vérifier la santé | `GET` | `/health` | — |
| Faire une prédiction | `POST` | `/predict` | `{"sepal_length": 5.1, ...}` |
| Infos du modèle | `GET` | `/model/info` | — |
| Échantillons | `GET` | `/dataset/samples` | — |
| Statistiques | `GET` | `/dataset/stats` | — |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 5 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-5"></a>

<details>
<summary><strong>5 — Les codes de statut HTTP</strong></summary>

### 5.1 Les 5 familles de codes

```mermaid
graph LR
    HTTP["Codes HTTP"]
    C1["1xx<br/>Informationnel"]
    C2["2xx<br/>Succès ✅"]
    C3["3xx<br/>Redirection ↪️"]
    C4["4xx<br/>Erreur client ❌"]
    C5["5xx<br/>Erreur serveur 💥"]

    HTTP --> C1
    HTTP --> C2
    HTTP --> C3
    HTTP --> C4
    HTTP --> C5

    style C1 fill:#9aa0a6,stroke:#fff,color:#fff
    style C2 fill:#34a853,stroke:#fff,color:#fff
    style C3 fill:#1a73e8,stroke:#fff,color:#fff
    style C4 fill:#fbbc04,stroke:#fff,color:#333
    style C5 fill:#ea4335,stroke:#fff,color:#fff
```

### 5.2 Codes 1xx — Informationnel

| Code | Nom | Quand l'utiliser | Exemple |
|------|-----|-----------------|---------|
| `100` | Continue | Le serveur a reçu les en-têtes, le client peut envoyer le corps | Upload de gros fichier |
| `101` | Switching Protocols | Changement de protocole accepté | HTTP → WebSocket |
| `102` | Processing | Le serveur traite, réponse pas encore prête | Opération longue (WebDAV) |
| `103` | Early Hints | Envoyer des en-têtes préliminaires | Précharger des ressources |

### 5.3 Codes 2xx — Succès

| Code | Nom | Quand l'utiliser | Exemple |
|------|-----|-----------------|---------|
| `200` | OK | Requête réussie (cas général) | `GET /model/info` → 200 avec les données |
| `201` | Created | Ressource créée avec succès | `POST /users` → 201 + `Location: /users/42` |
| `202` | Accepted | Requête acceptée, traitement asynchrone | Lancement d'un entraînement ML en arrière-plan |
| `204` | No Content | Succès, mais pas de corps en réponse | `DELETE /users/42` → 204 |
| `206` | Partial Content | Réponse partielle (pagination/range) | Téléchargement partiel d'un fichier |

### 5.4 Codes 3xx — Redirection

| Code | Nom | Quand l'utiliser | Exemple |
|------|-----|-----------------|---------|
| `301` | Moved Permanently | Ressource déplacée définitivement | Ancienne URL redirige vers nouvelle |
| `302` | Found | Redirection temporaire | Maintenance temporaire |
| `304` | Not Modified | Ressource non modifiée (cache valide) | `GET` avec `If-None-Match` → cache OK |
| `307` | Temporary Redirect | Comme 302 mais préserve la méthode HTTP | POST redirigé reste POST |
| `308` | Permanent Redirect | Comme 301 mais préserve la méthode HTTP | Changement d'URL permanent |

### 5.5 Codes 4xx — Erreur du client

| Code | Nom | Quand l'utiliser | Exemple |
|------|-----|-----------------|---------|
| `400` | Bad Request | Requête mal formée ou données invalides | JSON invalide, champ manquant |
| `401` | Unauthorized | Authentification requise ou invalide | Token manquant ou expiré |
| `403` | Forbidden | Authentifié mais pas autorisé | Utilisateur sans les droits admin |
| `404` | Not Found | Ressource non trouvée | `GET /users/99999` → n'existe pas |
| `405` | Method Not Allowed | Méthode HTTP non supportée pour cette URI | `DELETE /predict` → non autorisé |
| `408` | Request Timeout | Le client a mis trop de temps | Connexion réseau lente |
| `409` | Conflict | Conflit avec l'état actuel de la ressource | Création d'un utilisateur avec email existant |
| `413` | Payload Too Large | Corps de requête trop volumineux | Upload d'un fichier trop gros |
| `415` | Unsupported Media Type | Content-Type non supporté | Envoi de XML à une API JSON-only |
| `422` | Unprocessable Entity | Données syntaxiquement correctes mais sémantiquement invalides | `sepal_length: -5` (valeur négative) |
| `429` | Too Many Requests | Limite de requêtes dépassée (rate limiting) | Plus de 100 requêtes/minute |

### 5.6 Codes 5xx — Erreur du serveur

| Code | Nom | Quand l'utiliser | Exemple |
|------|-----|-----------------|---------|
| `500` | Internal Server Error | Erreur générique du serveur | Exception non gérée dans le code |
| `502` | Bad Gateway | Le proxy/gateway a reçu une réponse invalide | Nginx ne peut pas joindre FastAPI |
| `503` | Service Unavailable | Service temporairement indisponible | Modèle ML pas encore chargé |
| `504` | Gateway Timeout | Le proxy/gateway n'a pas reçu de réponse à temps | FastAPI met trop longtemps à répondre |

### 5.7 Codes utilisés dans notre API Iris

```python
# main.py — Codes de statut dans notre API

@app.post("/predict")
async def predict(request: PredictionRequest):
    if model is None:
        raise HTTPException(status_code=503, detail="Le modèle n'est pas chargé")
        #                              ^^^
        #                     503 Service Unavailable
    # ...
    return PredictionResponse(...)  # 200 OK (implicite)

@app.get("/model/info")
async def model_info():
    if metadata is None:
        raise HTTPException(status_code=503, detail="Les métadonnées ne sont pas chargées")
    return ModelInfoResponse(**metadata)  # 200 OK

# FastAPI génère automatiquement :
# 422 Unprocessable Entity → si les données ne passent pas la validation Pydantic
# 405 Method Not Allowed   → si la méthode HTTP est incorrecte
# 404 Not Found            → si l'endpoint n'existe pas
```

### 5.8 Arbre de décision du code de statut

```mermaid
graph TD
    Start["La requête est arrivée"]
    Q1{"Requête valide ?"}
    Q2{"Authentifié ?"}
    Q3{"Autorisé ?"}
    Q4{"Ressource trouvée ?"}
    Q5{"Type d'opération ?"}

    R400["400 Bad Request"]
    R401["401 Unauthorized"]
    R403["403 Forbidden"]
    R404["404 Not Found"]
    R200["200 OK"]
    R201["201 Created"]
    R204["204 No Content"]
    R500["500 Internal Server Error"]

    Start --> Q1
    Q1 -->|Non| R400
    Q1 -->|Oui| Q2
    Q2 -->|Non| R401
    Q2 -->|Oui| Q3
    Q3 -->|Non| R403
    Q3 -->|Oui| Q4
    Q4 -->|Non| R404
    Q4 -->|Oui| Q5
    Q5 -->|GET| R200
    Q5 -->|POST| R201
    Q5 -->|DELETE| R204
    Q5 -->|Erreur serveur| R500
```

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 6 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-6"></a>

<details>
<summary><strong>6 — Les formats de données</strong></summary>

### 6.1 Les trois formats principaux

#### JSON (JavaScript Object Notation)

Le format **dominant** des APIs REST modernes. Lisible, léger, nativement supporté par JavaScript et la plupart des langages.

```json
{
  "species": "setosa",
  "confidence": 1.0,
  "probabilities": {
    "setosa": 1.0,
    "versicolor": 0.0,
    "virginica": 0.0
  },
  "features": [5.1, 3.5, 1.4, 0.2],
  "is_reliable": true,
  "notes": null
}
```

#### XML (eXtensible Markup Language)

Format historique, plus verbeux, encore utilisé dans les systèmes d'entreprise (SOAP, RSS, SVG).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<prediction>
  <species>setosa</species>
  <confidence>1.0</confidence>
  <probabilities>
    <setosa>1.0</setosa>
    <versicolor>0.0</versicolor>
    <virginica>0.0</virginica>
  </probabilities>
  <features>
    <feature>5.1</feature>
    <feature>3.5</feature>
    <feature>1.4</feature>
    <feature>0.2</feature>
  </features>
  <is_reliable>true</is_reliable>
  <notes/>
</prediction>
```

#### YAML (YAML Ain't Markup Language)

Format très lisible, utilisé principalement pour la configuration (Docker, Kubernetes, CI/CD) plutôt que les échanges API.

```yaml
species: setosa
confidence: 1.0
probabilities:
  setosa: 1.0
  versicolor: 0.0
  virginica: 0.0
features:
  - 5.1
  - 3.5
  - 1.4
  - 0.2
is_reliable: true
notes: null
```

### 6.2 Tableau comparatif détaillé

| Critère | JSON | XML | YAML |
|---------|------|-----|------|
| **Lisibilité humaine** | ⭐⭐⭐⭐ Bonne | ⭐⭐ Verbeux | ⭐⭐⭐⭐⭐ Excellente |
| **Taille** | Compact | 2-3x plus gros que JSON | Similaire à JSON |
| **Parsing** | Très rapide | Plus lent | Lent |
| **Types de données natifs** | string, number, boolean, null, array, object | Texte uniquement (tout est string) | string, number, boolean, null, array, object, date |
| **Commentaires** | ❌ Non supportés | ✅ `<!-- commentaire -->` | ✅ `# commentaire` |
| **Schéma de validation** | JSON Schema | XSD, DTD, RelaxNG | JSON Schema (via conversion) |
| **Espaces de noms** | ❌ Non | ✅ Oui (xmlns) | ❌ Non |
| **Support navigateur** | ✅ Natif (`JSON.parse`) | ✅ Via DOM Parser | ❌ Nécessite une bibliothèque |
| **Usage principal** | APIs REST, config | SOAP, RSS, config enterprise | Config (Docker, K8s, CI/CD) |
| **Content-Type** | `application/json` | `application/xml` | `application/x-yaml` |

### 6.3 Structure JSON en détail

#### Les 6 types de données JSON

```json
{
  "string": "Bonjour le monde",
  "number_int": 42,
  "number_float": 3.14159,
  "boolean": true,
  "null_value": null,
  "array": [1, 2, 3, "texte", true],
  "object": {
    "clé": "valeur",
    "imbriqué": {
      "profond": true
    }
  }
}
```

| Type | Description | Exemples |
|------|-------------|----------|
| **string** | Chaîne entre guillemets doubles | `"hello"`, `"5.1"`, `""` |
| **number** | Entier ou décimal (pas de distinction) | `42`, `3.14`, `-7`, `1.0e10` |
| **boolean** | Vrai ou faux | `true`, `false` |
| **null** | Absence de valeur | `null` |
| **array** | Liste ordonnée de valeurs | `[1, "a", true, null]` |
| **object** | Collection de paires clé-valeur | `{"name": "Iris", "count": 150}` |

#### Règles de syntaxe JSON

- Les clés sont **toujours** des chaînes entre guillemets doubles (`"clé"`, pas `'clé'` ni `clé`)
- Pas de virgule après le dernier élément (trailing comma interdit)
- Pas de commentaires
- Les chaînes utilisent `\"` pour les guillemets internes et `\\` pour les backslashes

### 6.4 Sérialisation et désérialisation

```mermaid
graph LR
    OBJ["🏗️ Objet en mémoire<br/>(Python dict, Dart Map,<br/>JS Object)"]
    JSON["📄 Chaîne JSON<br/>(texte transmis<br/>sur le réseau)"]

    OBJ -->|"Sérialisation<br/>(json.dumps, json.encode,<br/>JSON.stringify)"| JSON
    JSON -->|"Désérialisation<br/>(json.loads, json.decode,<br/>JSON.parse)"| OBJ
```

#### En Python

```python
import json

# Sérialisation : objet Python → chaîne JSON
data = {"species": "setosa", "confidence": 1.0}
json_string = json.dumps(data, indent=2)
# '{\n  "species": "setosa",\n  "confidence": 1.0\n}'

# Désérialisation : chaîne JSON → objet Python
parsed = json.loads(json_string)
print(parsed["species"])  # "setosa"
print(type(parsed))       # <class 'dict'>
```

#### En Dart

```dart
import 'dart:convert';

// Sérialisation : Map Dart → chaîne JSON
Map<String, dynamic> data = {"species": "setosa", "confidence": 1.0};
String jsonString = json.encode(data);

// Désérialisation : chaîne JSON → Map Dart
Map<String, dynamic> parsed = json.decode(jsonString);
print(parsed["species"]); // "setosa"
```

#### En JavaScript

```javascript
// Sérialisation : objet JS → chaîne JSON
const data = { species: "setosa", confidence: 1.0 };
const jsonString = JSON.stringify(data, null, 2);

// Désérialisation : chaîne JSON → objet JS
const parsed = JSON.parse(jsonString);
console.log(parsed.species); // "setosa"
```

#### Correspondance des types entre JSON et les langages

| JSON | Python | Dart | JavaScript |
|------|--------|------|------------|
| `string` | `str` | `String` | `string` |
| `number` (entier) | `int` | `int` | `number` |
| `number` (décimal) | `float` | `double` | `number` |
| `boolean` | `bool` | `bool` | `boolean` |
| `null` | `None` | `null` | `null` |
| `array` | `list` | `List` | `Array` |
| `object` | `dict` | `Map<String, dynamic>` | `Object` |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 7 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-7"></a>

<details>
<summary><strong>7 — Consommer une API avec Python</strong></summary>

### 7.1 La bibliothèque `requests`

`requests` est la bibliothèque HTTP la plus populaire en Python. Elle est simple, élégante, et gère automatiquement l'encodage, les cookies, les redirections, etc.

```bash
pip install requests
```

### 7.2 Requête GET

```python
import requests

# GET simple
response = requests.get("http://localhost:8000/health")

print(response.status_code)    # 200
print(response.headers)        # {'content-type': 'application/json', ...}
print(response.json())         # {'status': 'healthy', 'model_loaded': True}
print(response.text)           # '{"status":"healthy","model_loaded":true}'
print(response.elapsed)        # 0:00:00.015234

# GET avec query parameters
response = requests.get(
    "http://localhost:8000/dataset/samples",
    params={"n": 5, "species": "setosa"}
)
# Equivalent à : GET /dataset/samples?n=5&species=setosa
```

### 7.3 Requête POST

```python
import requests

# POST avec données JSON
payload = {
    "sepal_length": 5.1,
    "sepal_width": 3.5,
    "petal_length": 1.4,
    "petal_width": 0.2,
}

response = requests.post(
    "http://localhost:8000/predict",
    json=payload,  # Sérialise automatiquement en JSON et définit Content-Type
)

if response.status_code == 200:
    result = response.json()
    print(f"Espèce prédite : {result['species']}")
    print(f"Confiance : {result['confidence']:.2%}")
    for species, prob in result["probabilities"].items():
        print(f"  {species}: {prob:.4f}")
else:
    print(f"Erreur {response.status_code}: {response.text}")
```

**Sortie** :
```
Espèce prédite : setosa
Confiance : 100.00%
  setosa: 1.0000
  versicolor: 0.0000
  virginica: 0.0000
```

### 7.4 Requête PUT

```python
import requests

# PUT — Remplacement complet d'une ressource
user_data = {
    "id": 42,
    "name": "Jean Dupont",
    "email": "jean.dupont@example.com",
    "role": "admin",
}

response = requests.put(
    "http://api.example.com/users/42",
    json=user_data,
    headers={"Authorization": "Bearer mon_token_jwt"},
)

if response.status_code == 200:
    print("Utilisateur mis à jour avec succès")
elif response.status_code == 404:
    print("Utilisateur non trouvé")
```

### 7.5 Requête PATCH

```python
import requests

# PATCH — Mise à jour partielle
response = requests.patch(
    "http://api.example.com/users/42",
    json={"role": "superadmin"},
    headers={"Authorization": "Bearer mon_token_jwt"},
)
```

### 7.6 Requête DELETE

```python
import requests

response = requests.delete(
    "http://api.example.com/users/42",
    headers={"Authorization": "Bearer mon_token_jwt"},
)

if response.status_code == 204:
    print("Utilisateur supprimé")
elif response.status_code == 404:
    print("Utilisateur non trouvé")
```

### 7.7 Gestion des en-têtes personnalisés

```python
import requests

headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "X-Request-Id": "550e8400-e29b-41d4-a716-446655440000",
    "Accept-Language": "fr-FR",
}

response = requests.get(
    "http://localhost:8000/model/info",
    headers=headers,
)
```

### 7.8 Gestion des erreurs robuste

```python
import requests
from requests.exceptions import (
    ConnectionError,
    Timeout,
    HTTPError,
    RequestException,
)

def predict_species(sepal_l, sepal_w, petal_l, petal_w):
    """Effectue une prédiction avec gestion complète des erreurs."""
    url = "http://localhost:8000/predict"
    payload = {
        "sepal_length": sepal_l,
        "sepal_width": sepal_w,
        "petal_length": petal_l,
        "petal_width": petal_w,
    }

    try:
        response = requests.post(url, json=payload, timeout=10)
        response.raise_for_status()  # Lève HTTPError si status >= 400
        return response.json()

    except ConnectionError:
        print("Impossible de se connecter au serveur. Est-il démarré ?")
    except Timeout:
        print("La requête a pris trop de temps (> 10 secondes)")
    except HTTPError as e:
        status = e.response.status_code
        if status == 422:
            print(f"Données invalides : {e.response.json()['detail']}")
        elif status == 503:
            print("Le modèle n'est pas encore chargé")
        else:
            print(f"Erreur HTTP {status}: {e.response.text}")
    except RequestException as e:
        print(f"Erreur inattendue : {e}")

    return None

result = predict_species(5.1, 3.5, 1.4, 0.2)
if result:
    print(f"Prédiction : {result['species']} ({result['confidence']:.2%})")
```

### 7.9 Utilisation de sessions

```python
import requests

# Les sessions persistent les cookies et réutilisent les connexions TCP
session = requests.Session()
session.headers.update({
    "Authorization": "Bearer mon_token",
    "Accept": "application/json",
})

# Toutes les requêtes de la session utilisent ces en-têtes
r1 = session.get("http://localhost:8000/health")
r2 = session.get("http://localhost:8000/model/info")
r3 = session.post("http://localhost:8000/predict", json={...})

session.close()
```

### 7.10 Upload de fichier

```python
import requests

with open("data.csv", "rb") as f:
    response = requests.post(
        "http://api.example.com/upload",
        files={"file": ("data.csv", f, "text/csv")},
        data={"description": "Données d'entraînement"},
    )
```

### 7.11 Récapitulatif des méthodes `requests`

| Méthode Python | Méthode HTTP | Paramètre données | Usage |
|---------------|-------------|-------------------|-------|
| `requests.get(url, params=...)` | GET | `params` (query string) | Lire |
| `requests.post(url, json=...)` | POST | `json` ou `data` | Créer |
| `requests.put(url, json=...)` | PUT | `json` ou `data` | Remplacer |
| `requests.patch(url, json=...)` | PATCH | `json` ou `data` | Modifier |
| `requests.delete(url)` | DELETE | — | Supprimer |
| `requests.head(url)` | HEAD | — | Métadonnées |
| `requests.options(url)` | OPTIONS | — | Capacités |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 8 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-8"></a>

<details>
<summary><strong>8 — Consommer une API avec Dart/Flutter</strong></summary>

### 8.1 Le package `http`

En Flutter, le package standard pour les requêtes HTTP est `http`. Il est simple, asynchrone, et bien intégré avec le système `Future`/`async`/`await` de Dart.

```yaml
# pubspec.yaml
dependencies:
  http: ^1.2.0
```

```bash
flutter pub get
```

### 8.2 Concepts clés Dart pour les APIs

#### async / await

En Dart, les opérations réseau sont **asynchrones**. Elles retournent un `Future<T>` — une promesse de valeur future.

```dart
// ❌ Synchrone (bloquant) — À NE PAS FAIRE
String result = fetchData(); // Bloquerait l'UI

// ✅ Asynchrone (non bloquant) — LA BONNE APPROCHE
Future<String> result = fetchData();
// ou avec await :
String result = await fetchData();
```

#### json.encode / json.decode

```dart
import 'dart:convert';

// Sérialiser (Map → String JSON)
Map<String, dynamic> data = {"sepal_length": 5.1, "sepal_width": 3.5};
String jsonStr = json.encode(data);
// '{"sepal_length":5.1,"sepal_width":3.5}'

// Désérialiser (String JSON → Map)
Map<String, dynamic> parsed = json.decode(jsonStr);
print(parsed["sepal_length"]); // 5.1
```

### 8.3 Code réel de notre projet — `api_service.dart`

Voici le code **réel** de notre application Iris, avec des explications détaillées :

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/iris_models.dart';

class ApiService {
  // URL de base — pointe vers notre serveur FastAPI local
  static const String baseUrl = 'http://localhost:8000';

  /// Vérifie si l'API est accessible et en bonne santé
  Future<bool> healthCheck() async {
    try {
      // 1. Envoyer une requête GET à /health
      final response = await http.get(Uri.parse('$baseUrl/health'));

      // 2. Vérifier le code de statut
      if (response.statusCode == 200) {
        // 3. Décoder la réponse JSON
        final data = json.decode(response.body);
        // 4. Vérifier que le statut est "healthy"
        return data['status'] == 'healthy';
      }
      return false;
    } catch (e) {
      // Erreur de connexion (serveur non démarré, réseau, etc.)
      return false;
    }
  }

  /// Envoie les mesures d'une fleur et reçoit la prédiction
  Future<PredictionResponse> predict(PredictionRequest request) async {
    // 1. Construire et envoyer la requête POST
    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},  // En-tête obligatoire
      body: json.encode(request.toJson()),             // Sérialisation du modèle
    );

    // 2. Traiter la réponse
    if (response.statusCode == 200) {
      // Succès : désérialiser le JSON en objet Dart
      return PredictionResponse.fromJson(json.decode(response.body));
    } else {
      // Erreur : lancer une exception avec le code de statut
      throw Exception('Erreur de prédiction: ${response.statusCode}');
    }
  }

  /// Récupère les informations du modèle ML
  Future<ModelInfo> getModelInfo() async {
    final response = await http.get(Uri.parse('$baseUrl/model/info'));

    if (response.statusCode == 200) {
      return ModelInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  }

  /// Récupère des échantillons aléatoires du dataset
  Future<List<DatasetSample>> getDatasetSamples() async {
    final response = await http.get(Uri.parse('$baseUrl/dataset/samples'));

    if (response.statusCode == 200) {
      // Décoder le tableau JSON en liste d'objets Dart
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => DatasetSample.fromJson(e)).toList();
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  }

  /// Récupère les statistiques du dataset
  Future<Map<String, dynamic>> getDatasetStats() async {
    final response = await http.get(Uri.parse('$baseUrl/dataset/stats'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  }
}
```

### 8.4 Les modèles Dart — `iris_models.dart`

Les modèles Dart structurent les données échangées avec l'API :

```dart
/// Modèle pour la requête de prédiction (envoi vers l'API)
class PredictionRequest {
  final double sepalLength;
  final double sepalWidth;
  final double petalLength;
  final double petalWidth;

  PredictionRequest({
    required this.sepalLength,
    required this.sepalWidth,
    required this.petalLength,
    required this.petalWidth,
  });

  /// Sérialisation : objet Dart → Map (puis → JSON)
  Map<String, dynamic> toJson() => {
    'sepal_length': sepalLength,   // snake_case pour l'API Python
    'sepal_width': sepalWidth,
    'petal_length': petalLength,
    'petal_width': petalWidth,
  };
}

/// Modèle pour la réponse de prédiction (reçu de l'API)
class PredictionResponse {
  final String species;
  final double confidence;
  final Map<String, double> probabilities;

  PredictionResponse({
    required this.species,
    required this.confidence,
    required this.probabilities,
  });

  /// Désérialisation : Map (du JSON) → objet Dart
  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      species: json['species'],
      confidence: (json['confidence'] as num).toDouble(),
      probabilities: (json['probabilities'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
    );
  }
}
```

### 8.5 Pattern de sérialisation Dart

```mermaid
graph TD
    subgraph "Envoi (Client → Serveur)"
        A["PredictionRequest<br/>(objet Dart)"]
        B["Map&lt;String, dynamic&gt;<br/>(via toJson())"]
        C["String JSON<br/>(via json.encode)"]
        D["Corps HTTP<br/>(body de la requête POST)"]
    end

    A -->|".toJson()"| B
    B -->|"json.encode()"| C
    C -->|"http.post(body:)"| D

    subgraph "Réception (Serveur → Client)"
        E["Corps HTTP<br/>(body de la réponse)"]
        F["String JSON<br/>(response.body)"]
        G["Map&lt;String, dynamic&gt;<br/>(via json.decode)"]
        H["PredictionResponse<br/>(objet Dart)"]
    end

    E -->|"response.body"| F
    F -->|"json.decode()"| G
    G -->|".fromJson()"| H
```

### 8.6 Gestion des erreurs complète en Flutter

```dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000';
  static const Duration timeout = Duration(seconds: 10);

  Future<PredictionResponse> predictWithErrorHandling(
    PredictionRequest request,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/predict'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(request.toJson()),
          )
          .timeout(timeout);

      switch (response.statusCode) {
        case 200:
          return PredictionResponse.fromJson(json.decode(response.body));
        case 422:
          throw ApiException('Données invalides', response.statusCode);
        case 503:
          throw ApiException('Le modèle n\'est pas chargé', response.statusCode);
        default:
          throw ApiException(
            'Erreur inattendue',
            response.statusCode,
          );
      }
    } on SocketException {
      throw ApiException('Pas de connexion réseau', 0);
    } on HttpException {
      throw ApiException('Erreur HTTP', 0);
    } on FormatException {
      throw ApiException('Réponse JSON invalide', 0);
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
```

### 8.7 Tableau comparatif Python `requests` vs Dart `http`

| Opération | Python (`requests`) | Dart (`http`) |
|-----------|-------------------|---------------|
| Import | `import requests` | `import 'package:http/http.dart' as http;` |
| GET | `requests.get(url)` | `await http.get(Uri.parse(url))` |
| POST JSON | `requests.post(url, json=data)` | `await http.post(Uri.parse(url), body: json.encode(data), headers: {...})` |
| Lire le corps | `response.json()` | `json.decode(response.body)` |
| Code statut | `response.status_code` | `response.statusCode` |
| En-têtes | `response.headers` | `response.headers` |
| Timeout | `requests.get(url, timeout=10)` | `http.get(url).timeout(Duration(seconds: 10))` |
| Async | Non (par défaut) | Oui (toujours) |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 9 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-9"></a>

<details>
<summary><strong>9 — Consommer une API avec JavaScript</strong></summary>

### 9.1 Fetch API (navigateur et Node.js)

L'API `fetch` est native dans les navigateurs modernes et disponible dans Node.js 18+.

#### GET

```javascript
// GET simple
const response = await fetch("http://localhost:8000/health");
const data = await response.json();
console.log(data); // { status: "healthy", model_loaded: true }
```

#### POST

```javascript
// POST avec JSON
const response = await fetch("http://localhost:8000/predict", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    sepal_length: 5.1,
    sepal_width: 3.5,
    petal_length: 1.4,
    petal_width: 0.2,
  }),
});

if (!response.ok) {
  throw new Error(`Erreur HTTP: ${response.status}`);
}

const result = await response.json();
console.log(`Espèce: ${result.species}, Confiance: ${result.confidence}`);
```

#### PUT et DELETE

```javascript
// PUT
const putResponse = await fetch("http://api.example.com/users/42", {
  method: "PUT",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ name: "Jean", email: "jean@ex.com", role: "admin" }),
});

// DELETE
const deleteResponse = await fetch("http://api.example.com/users/42", {
  method: "DELETE",
  headers: { "Authorization": "Bearer mon_token" },
});
```

#### Gestion des erreurs avec fetch

```javascript
async function predictSpecies(features) {
  try {
    const response = await fetch("http://localhost:8000/predict", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(features),
    });

    if (!response.ok) {
      const errorBody = await response.json().catch(() => null);
      switch (response.status) {
        case 422:
          throw new Error(`Données invalides: ${errorBody?.detail}`);
        case 503:
          throw new Error("Le modèle n'est pas chargé");
        default:
          throw new Error(`Erreur ${response.status}`);
      }
    }

    return await response.json();
  } catch (error) {
    if (error instanceof TypeError) {
      console.error("Erreur réseau — le serveur est-il démarré ?");
    } else {
      console.error(error.message);
    }
    return null;
  }
}
```

### 9.2 Axios (bibliothèque tierce)

Axios est une alternative populaire à `fetch` avec des fonctionnalités supplémentaires : intercepteurs, annulation, transformation automatique JSON.

```bash
npm install axios
```

#### GET

```javascript
import axios from "axios";

const { data } = await axios.get("http://localhost:8000/health");
console.log(data); // { status: "healthy", model_loaded: true }
```

#### POST

```javascript
import axios from "axios";

const { data } = await axios.post("http://localhost:8000/predict", {
  sepal_length: 5.1,
  sepal_width: 3.5,
  petal_length: 1.4,
  petal_width: 0.2,
});

console.log(`Espèce: ${data.species}`);
```

#### Intercepteurs (fonctionnalité unique d'Axios)

```javascript
import axios from "axios";

const api = axios.create({
  baseURL: "http://localhost:8000",
  timeout: 10000,
});

// Intercepteur de requête — ajouter le token automatiquement
api.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Intercepteur de réponse — gestion globale des erreurs
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      window.location.href = "/login";
    }
    return Promise.reject(error);
  }
);
```

### 9.3 Comparaison fetch vs axios

| Critère | fetch | axios |
|---------|-------|-------|
| **Installation** | Native (rien à installer) | `npm install axios` |
| **JSON auto** | Manuel (`response.json()`) | Automatique (`response.data`) |
| **Erreurs HTTP** | Ne lance pas d'erreur pour 4xx/5xx | Lance une erreur pour 4xx/5xx |
| **Intercepteurs** | ❌ Non | ✅ Oui |
| **Annulation** | `AbortController` | `CancelToken` / `AbortController` |
| **Timeout** | Via `AbortController` + `setTimeout` | Option `timeout` native |
| **Upload progress** | ❌ Non | ✅ Oui |
| **Node.js** | v18+ seulement | Toutes versions |
| **Taille** | 0 KB (natif) | ~13 KB (minifié) |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 10 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-10"></a>

<details>
<summary><strong>10 — Consommer une API avec curl et Postman</strong></summary>

### 10.1 curl — L'outil en ligne de commande

`curl` (Client URL) est un outil en ligne de commande pour transférer des données via divers protocoles. C'est l'outil de référence pour tester rapidement une API.

#### GET

```bash
# GET simple
curl http://localhost:8000/health

# GET avec en-têtes détaillés (-v pour verbose)
curl -v http://localhost:8000/health

# GET avec en-têtes personnalisés
curl -H "Accept: application/json" \
     -H "Authorization: Bearer mon_token" \
     http://localhost:8000/model/info

# GET avec formatage JSON (nécessite jq)
curl -s http://localhost:8000/model/info | jq .
```

#### POST

```bash
# POST avec corps JSON
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}'

# POST avec données depuis un fichier
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d @request.json

# POST avec formatage de la réponse
curl -s -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}' \
  | jq .
```

#### PUT

```bash
curl -X PUT http://api.example.com/users/42 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer mon_token" \
  -d '{"name": "Jean Dupont", "email": "jean@ex.com", "role": "admin"}'
```

#### PATCH

```bash
curl -X PATCH http://api.example.com/users/42 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer mon_token" \
  -d '{"role": "superadmin"}'
```

#### DELETE

```bash
curl -X DELETE http://api.example.com/users/42 \
  -H "Authorization: Bearer mon_token"
```

#### OPTIONS (preflight CORS)

```bash
curl -X OPTIONS http://localhost:8000/predict \
  -H "Origin: http://localhost:3000" \
  -H "Access-Control-Request-Method: POST" \
  -v
```

### 10.2 Options curl essentielles

| Option | Description | Exemple |
|--------|-------------|---------|
| `-X` | Méthode HTTP | `-X POST` |
| `-H` | Ajouter un en-tête | `-H "Content-Type: application/json"` |
| `-d` | Corps de la requête (données) | `-d '{"key": "value"}'` |
| `-d @file` | Corps depuis un fichier | `-d @request.json` |
| `-v` | Mode verbose (affiche tout) | `curl -v http://...` |
| `-s` | Mode silencieux (pas de progression) | `curl -s http://...` |
| `-o` | Enregistrer dans un fichier | `-o response.json` |
| `-w` | Afficher des informations | `-w "%{http_code}\n"` |
| `-i` | Afficher les en-têtes de réponse | `curl -i http://...` |
| `-L` | Suivre les redirections | `curl -L http://...` |
| `-k` | Ignorer les erreurs SSL | `curl -k https://...` |
| `--connect-timeout` | Timeout de connexion | `--connect-timeout 5` |
| `-u` | Authentification Basic | `-u user:password` |

### 10.3 Postman — L'interface graphique

Postman est l'outil graphique le plus populaire pour concevoir, tester et documenter des APIs.

#### Étapes pour tester notre API Iris avec Postman

**Étape 1 : Créer une collection**
- Cliquer sur "New" → "Collection"
- Nommer : "Iris Prediction API"

**Étape 2 : Ajouter un test Health Check**
- Méthode : `GET`
- URL : `http://localhost:8000/health`
- Cliquer "Send"
- Vérifier la réponse : `{"status": "healthy", "model_loaded": true}`

**Étape 3 : Tester la prédiction**
- Méthode : `POST`
- URL : `http://localhost:8000/predict`
- Onglet "Headers" : ajouter `Content-Type: application/json`
- Onglet "Body" → "raw" → "JSON" :

```json
{
  "sepal_length": 5.1,
  "sepal_width": 3.5,
  "petal_length": 1.4,
  "petal_width": 0.2
}
```

- Cliquer "Send"
- Vérifier la réponse

**Étape 4 : Créer des variables d'environnement**
- Créer un environnement "Local" avec :
  - `base_url` = `http://localhost:8000`
- Utiliser `{{base_url}}/predict` dans les requêtes

**Étape 5 : Ajouter des tests automatiques (onglet "Tests")**

```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Response has species field", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property("species");
    pm.expect(jsonData).to.have.property("confidence");
    pm.expect(jsonData).to.have.property("probabilities");
});

pm.test("Confidence is between 0 and 1", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.confidence).to.be.within(0, 1);
});
```

### 10.4 Collection Postman complète pour notre API

| Requête | Méthode | URL | Corps |
|---------|---------|-----|-------|
| Health Check | GET | `{{base_url}}/health` | — |
| Root | GET | `{{base_url}}/` | — |
| Predict Setosa | POST | `{{base_url}}/predict` | `{"sepal_length":5.1,"sepal_width":3.5,"petal_length":1.4,"petal_width":0.2}` |
| Predict Versicolor | POST | `{{base_url}}/predict` | `{"sepal_length":5.9,"sepal_width":2.8,"petal_length":4.5,"petal_width":1.3}` |
| Predict Virginica | POST | `{{base_url}}/predict` | `{"sepal_length":6.3,"sepal_width":3.3,"petal_length":6.0,"petal_width":2.5}` |
| Model Info | GET | `{{base_url}}/model/info` | — |
| Dataset Samples | GET | `{{base_url}}/dataset/samples` | — |
| Dataset Stats | GET | `{{base_url}}/dataset/stats` | — |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 11 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-11"></a>

<details>
<summary><strong>11 — Authentification dans les APIs REST</strong></summary>

### 11.1 Pourquoi l'authentification ?

Les APIs REST étant **stateless**, chaque requête doit prouver l'identité du client. Il existe plusieurs mécanismes, chacun avec ses avantages et inconvénients.

### 11.2 Les principaux mécanismes

#### 1. API Key (Clé d'API)

Le mécanisme le plus simple : une clé unique attribuée à chaque client.

```http
GET /model/info HTTP/1.1
Host: api.example.com
X-API-Key: sk_live_abc123def456ghi789
```

Ou dans l'URL (déconseillé car visible dans les logs) :
```
GET /model/info?api_key=sk_live_abc123def456ghi789
```

```python
# Python
response = requests.get(
    "http://api.example.com/model/info",
    headers={"X-API-Key": "sk_live_abc123def456ghi789"},
)
```

```dart
// Dart
final response = await http.get(
  Uri.parse('http://api.example.com/model/info'),
  headers: {'X-API-Key': 'sk_live_abc123def456ghi789'},
);
```

#### 2. Bearer Token / JWT (JSON Web Token)

Un **JWT** est un token auto-contenu qui contient les informations de l'utilisateur, signé cryptographiquement.

**Structure d'un JWT** :

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkplYW4gRHVwb250Iiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzEzMDAwMDAwLCJleHAiOjE3MTMwMDM2MDB9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
└──────────┬──────────┘.└─────────────────────────────────┬─────────────────────────────────┘.└──────────────┬──────────────┘
         Header                                        Payload                                          Signature
```

```mermaid
sequenceDiagram
    participant C as 📱 Client
    participant A as 🔐 Auth Server
    participant API as ⚡ API Server

    C->>A: 1️⃣ POST /auth/login<br/>{"email": "jean@ex.com", "password": "***"}
    A-->>C: 2️⃣ 200 OK<br/>{"access_token": "eyJhbG...", "expires_in": 3600}

    Note over C: Le client stocke le token

    C->>API: 3️⃣ GET /model/info<br/>Authorization: Bearer eyJhbG...
    API-->>C: 4️⃣ 200 OK<br/>{"model_type": "RandomForest", ...}

    Note over C: 1 heure plus tard, le token expire

    C->>API: 5️⃣ GET /model/info<br/>Authorization: Bearer eyJhbG...
    API-->>C: 6️⃣ 401 Unauthorized<br/>{"detail": "Token expiré"}

    C->>A: 7️⃣ POST /auth/refresh<br/>{"refresh_token": "..."}
    A-->>C: 8️⃣ 200 OK<br/>{"access_token": "nouveau_token"}
```

```python
# Python — Authentification JWT
# 1. Login
login_response = requests.post(
    "http://api.example.com/auth/login",
    json={"email": "jean@example.com", "password": "secret"},
)
token = login_response.json()["access_token"]

# 2. Utiliser le token
response = requests.get(
    "http://api.example.com/model/info",
    headers={"Authorization": f"Bearer {token}"},
)
```

```dart
// Dart — Authentification JWT
// 1. Login
final loginResponse = await http.post(
  Uri.parse('http://api.example.com/auth/login'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode({'email': 'jean@example.com', 'password': 'secret'}),
);
final token = json.decode(loginResponse.body)['access_token'];

// 2. Utiliser le token
final response = await http.get(
  Uri.parse('http://api.example.com/model/info'),
  headers: {'Authorization': 'Bearer $token'},
);
```

#### 3. OAuth 2.0

OAuth 2.0 est un **framework d'autorisation** qui permet à une application tierce d'accéder à des ressources au nom d'un utilisateur, sans exposer ses identifiants.

```mermaid
sequenceDiagram
    participant U as 👤 Utilisateur
    participant App as 📱 Application
    participant Auth as 🔐 Serveur OAuth<br/>(Google, GitHub...)
    participant API as ⚡ Resource Server

    U->>App: 1️⃣ Clic "Se connecter avec Google"
    App->>Auth: 2️⃣ Redirection vers la page de consentement Google
    U->>Auth: 3️⃣ Accepte les permissions demandées
    Auth->>App: 4️⃣ Code d'autorisation (via redirect_uri)
    App->>Auth: 5️⃣ Échange code → access_token<br/>(+ client_secret côté serveur)
    Auth-->>App: 6️⃣ access_token + refresh_token
    App->>API: 7️⃣ GET /api/data<br/>Authorization: Bearer access_token
    API-->>App: 8️⃣ 200 OK + données
```

**Les 4 flux OAuth 2.0** :

| Flux | Usage | Sécurité |
|------|-------|----------|
| **Authorization Code** | Applications web serveur | ⭐⭐⭐⭐⭐ (le plus sûr) |
| **Authorization Code + PKCE** | Applications mobiles/SPA | ⭐⭐⭐⭐ |
| **Client Credentials** | Communication serveur-à-serveur | ⭐⭐⭐⭐ |
| **Implicit** (déprécié) | ~~SPA~~ (remplacé par PKCE) | ⭐⭐ |

### 11.3 Tableau comparatif des mécanismes d'authentification

| Critère | API Key | JWT (Bearer Token) | OAuth 2.0 |
|---------|---------|-------------------|-----------|
| **Complexité** | ⭐ Très simple | ⭐⭐⭐ Modérée | ⭐⭐⭐⭐⭐ Complexe |
| **Sécurité** | ⭐⭐ Basique | ⭐⭐⭐⭐ Bonne | ⭐⭐⭐⭐⭐ Excellente |
| **Auto-contenu** | ❌ Non (lookup serveur) | ✅ Oui (payload dans le token) | Dépend du token |
| **Expiration** | ❌ Généralement non | ✅ Oui (champ `exp`) | ✅ Oui |
| **Révocation** | ✅ Facile (supprimer la clé) | ❌ Difficile (attendre l'expiration) | ✅ Via le serveur OAuth |
| **Granularité** | Limitée (par clé) | Rôles et permissions dans le payload | Scopes détaillés |
| **Cas d'usage** | APIs internes, services tiers | APIs mobiles, SPAs | Login social, APIs tierces |
| **Stockage** | Serveur (base de données) | Client (localStorage, mémoire) | Client + serveur |
| **Exemple** | OpenWeather, Google Maps | Notre API si on ajoutait l'auth | Google, GitHub, Facebook |

### 11.4 Authentification HTTP Basic

Mécanisme natif HTTP, simple mais peu sécurisé (credentials en base64, pas chiffrés).

```http
GET /api/data HTTP/1.1
Authorization: Basic amVhbjpzZWNyZXQ=
```

```python
# Python
response = requests.get(
    "http://api.example.com/data",
    auth=("jean", "secret"),  # requests encode automatiquement en base64
)
```

> **Important** : HTTP Basic ne devrait être utilisé qu'avec HTTPS, car les identifiants ne sont encodés qu'en base64 (pas chiffrés).

### 11.5 Notre API Iris — Pas d'authentification (et pourquoi)

Notre API Iris ne nécessite pas d'authentification car :
- C'est une API de **démonstration** locale
- Pas de données sensibles
- Pas de notion d'utilisateurs

En production, on ajouterait au minimum une API Key :

```python
# Exemple d'ajout d'authentification à notre API FastAPI
from fastapi import Security
from fastapi.security import APIKeyHeader

api_key_header = APIKeyHeader(name="X-API-Key")

@app.post("/predict")
async def predict(
    request: PredictionRequest,
    api_key: str = Security(api_key_header),
):
    if api_key != "ma_cle_secrete":
        raise HTTPException(status_code=401, detail="Clé API invalide")
    # ... logique de prédiction
```

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 12 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-12"></a>

<details>
<summary><strong>12 — CORS — Cross-Origin Resource Sharing</strong></summary>

### 12.1 Qu'est-ce que CORS ?

**CORS** (Cross-Origin Resource Sharing) est un mécanisme de sécurité des navigateurs qui contrôle quelles origines (domaines) peuvent accéder aux ressources d'un serveur.

#### Qu'est-ce qu'une « origine » ?

Une origine est définie par le triplet : **protocole + domaine + port**.

```
http://localhost:3000    ← Origine A (frontend React)
http://localhost:8000    ← Origine B (backend FastAPI)
https://example.com      ← Origine C
https://example.com:443  ← Même que C (443 est le port par défaut de HTTPS)
http://example.com       ← Origine D (protocole différent de C)
```

Deux URL ont la **même origine** uniquement si les trois composants sont identiques.

### 12.2 Pourquoi CORS existe ?

Sans CORS, la **Same-Origin Policy** (politique de même origine) du navigateur empêche un script d'une page web de faire des requêtes vers une autre origine. C'est une protection contre les attaques **CSRF** (Cross-Site Request Forgery).

```mermaid
graph TD
    subgraph "Sans CORS"
        A["📱 Frontend<br/>http://localhost:3000"]
        B["⚡ Backend<br/>http://localhost:8000"]
        A -->|"❌ Requête bloquée<br/>par le navigateur<br/>(origines différentes)"| B
    end

    subgraph "Avec CORS"
        C["📱 Frontend<br/>http://localhost:3000"]
        D["⚡ Backend<br/>http://localhost:8000<br/>Access-Control-Allow-Origin: *"]
        C -->|"✅ Requête autorisée<br/>grâce aux en-têtes CORS"| D
    end
```

### 12.3 Comment CORS fonctionne

#### Requêtes simples (Simple Requests)

Pour les requêtes GET simples avec des en-têtes standards, le navigateur envoie directement la requête et vérifie l'en-tête CORS dans la réponse.

```
Client (navigateur)                    Serveur
      |                                    |
      |--- GET /health ------------------->|
      |    Origin: http://localhost:3000    |
      |                                    |
      |<-- 200 OK ------------------------|
      |    Access-Control-Allow-Origin: *   |
      |    {"status": "healthy"}           |
      |                                    |
      | ✅ Navigateur autorise l'accès     |
```

#### Requêtes avec preflight (Preflight Requests)

Pour les requêtes POST avec `Content-Type: application/json` (ou toute requête « non simple »), le navigateur envoie d'abord une requête **OPTIONS** automatique.

```mermaid
sequenceDiagram
    participant B as 🌐 Navigateur
    participant S as ⚡ Serveur FastAPI

    Note over B: L'utilisateur clique "Prédire"

    B->>S: 1️⃣ OPTIONS /predict (Preflight)<br/>Origin: http://localhost:3000<br/>Access-Control-Request-Method: POST<br/>Access-Control-Request-Headers: Content-Type

    S-->>B: 2️⃣ 200 OK<br/>Access-Control-Allow-Origin: *<br/>Access-Control-Allow-Methods: GET, POST, PUT, DELETE<br/>Access-Control-Allow-Headers: Content-Type<br/>Access-Control-Max-Age: 600

    Note over B: ✅ Preflight OK, on envoie la vraie requête

    B->>S: 3️⃣ POST /predict<br/>Origin: http://localhost:3000<br/>Content-Type: application/json<br/><br/>{"sepal_length": 5.1, ...}

    S-->>B: 4️⃣ 200 OK<br/>Access-Control-Allow-Origin: *<br/><br/>{"species": "setosa", ...}
```

### 12.4 Les en-têtes CORS

#### En-têtes de réponse (serveur → navigateur)

| En-tête | Description | Exemple |
|---------|-------------|---------|
| `Access-Control-Allow-Origin` | Origines autorisées | `*` ou `http://localhost:3000` |
| `Access-Control-Allow-Methods` | Méthodes HTTP autorisées | `GET, POST, PUT, DELETE` |
| `Access-Control-Allow-Headers` | En-têtes autorisés | `Content-Type, Authorization` |
| `Access-Control-Max-Age` | Durée de cache du preflight (secondes) | `600` (10 minutes) |
| `Access-Control-Allow-Credentials` | Autorise les cookies/auth | `true` |
| `Access-Control-Expose-Headers` | En-têtes lisibles par le client | `X-Request-Id, X-Total-Count` |

### 12.5 Configuration CORS dans notre API FastAPI

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Iris Flower Prediction API")

# Configuration CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],          # Autorise toutes les origines
    allow_credentials=True,       # Autorise les cookies
    allow_methods=["*"],          # Autorise toutes les méthodes HTTP
    allow_headers=["*"],          # Autorise tous les en-têtes
)
```

#### Configuration restrictive (recommandée en production)

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",       # Frontend React dev
        "http://localhost:5000",       # Frontend Flutter web dev
        "https://mon-app.example.com", # Production
    ],
    allow_credentials=True,
    allow_methods=["GET", "POST"],     # Seules méthodes nécessaires
    allow_headers=["Content-Type", "Authorization"],
)
```

### 12.6 Quand CORS ne s'applique pas

CORS est une protection **côté navigateur uniquement**. Les outils suivants ne sont pas affectés :

| Outil | Affecté par CORS ? | Raison |
|-------|--------------------|--------|
| Navigateur (fetch, XMLHttpRequest) | ✅ Oui | Politique de sécurité du navigateur |
| curl | ❌ Non | Pas un navigateur |
| Postman | ❌ Non | Pas un navigateur |
| Python `requests` | ❌ Non | Pas un navigateur |
| Dart `http` (non-web) | ❌ Non | Pas un navigateur |
| Flutter Web | ✅ Oui | S'exécute dans un navigateur |
| Flutter Mobile/Desktop | ❌ Non | Pas un navigateur |
| Serveur à serveur | ❌ Non | Pas un navigateur |

### 12.7 Erreur CORS typique

Si CORS n'est pas configuré, vous verrez dans la console du navigateur :

```
Access to fetch at 'http://localhost:8000/predict' from origin
'http://localhost:3000' has been blocked by CORS policy: No
'Access-Control-Allow-Origin' header is present on the requested
resource.
```

**Solutions** :
1. Configurer CORS sur le serveur (meilleure solution)
2. Utiliser un proxy en développement (`proxy` dans `package.json`)
3. Extension navigateur « CORS Unblock » (développement uniquement, **jamais en production**)

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 13 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-13"></a>

<details>
<summary><strong>13 — Bonnes pratiques de conception d'API REST</strong></summary>

### 13.1 Conventions de nommage des URL

#### Règles fondamentales

| Règle | ✅ Bon | ❌ Mauvais |
|-------|--------|-----------|
| Utiliser des **noms** (pas des verbes) | `/users` | `/getUsers` |
| Utiliser le **pluriel** | `/users`, `/products` | `/user`, `/product` |
| Utiliser le **kebab-case** | `/model-info` | `/modelInfo`, `/model_info` |
| Utiliser des **minuscules** | `/dataset/samples` | `/Dataset/Samples` |
| Pas d'extension de fichier | `/users/42` | `/users/42.json` |
| Pas de slash final | `/users` | `/users/` |
| Hiérarchie via la structure URL | `/users/42/orders` | `/getUserOrders?userId=42` |

#### Exemples de nommage RESTful

```
# Ressource "utilisateurs"
GET    /users              → Liste des utilisateurs
GET    /users/42           → Utilisateur #42
POST   /users              → Créer un utilisateur
PUT    /users/42           → Remplacer l'utilisateur #42
PATCH  /users/42           → Modifier l'utilisateur #42
DELETE /users/42           → Supprimer l'utilisateur #42

# Ressource imbriquée
GET    /users/42/orders    → Commandes de l'utilisateur #42
POST   /users/42/orders    → Créer une commande pour l'utilisateur #42
GET    /users/42/orders/7  → Commande #7 de l'utilisateur #42

# Actions non-CRUD (exceptions acceptées)
POST   /predict            → Déclencher une prédiction (action)
POST   /auth/login         → Se connecter
POST   /orders/42/cancel   → Annuler une commande (action)
```

### 13.2 Versioning d'API

Quand votre API évolue, vous devez gérer la rétrocompatibilité.

| Méthode | Exemple | Avantages | Inconvénients |
|---------|---------|-----------|---------------|
| **URL path** | `/v1/users`, `/v2/users` | Simple, explicite, cacheable | Duplique les routes |
| **Query param** | `/users?version=2` | Flexible | Facile à oublier |
| **Header** | `Accept: application/vnd.api.v2+json` | URL propre | Moins visible, plus complexe |
| **Content negotiation** | `Accept: application/vnd.iris.v2+json` | Standard HTTP | Très complexe |

**Recommandation** : Utiliser le versioning par URL path — c'est le plus clair et le plus courant.

```python
# FastAPI avec versioning
from fastapi import APIRouter

v1_router = APIRouter(prefix="/v1")
v2_router = APIRouter(prefix="/v2")

@v1_router.post("/predict")
async def predict_v1(request: PredictionRequestV1):
    ...

@v2_router.post("/predict")
async def predict_v2(request: PredictionRequestV2):
    ...

app.include_router(v1_router)
app.include_router(v2_router)
```

### 13.3 Pagination

Pour les collections volumineuses, la pagination est essentielle.

#### Pagination par offset

```
GET /dataset/samples?page=2&per_page=10

Réponse :
{
  "data": [...],
  "pagination": {
    "page": 2,
    "per_page": 10,
    "total_items": 150,
    "total_pages": 15,
    "has_next": true,
    "has_prev": true
  }
}
```

#### Pagination par curseur (plus performante pour les grandes collections)

```
GET /dataset/samples?cursor=eyJpZCI6MTB9&limit=10

Réponse :
{
  "data": [...],
  "next_cursor": "eyJpZCI6MjB9",
  "has_more": true
}
```

| Méthode | Avantages | Inconvénients |
|---------|-----------|---------------|
| **Offset** | Simple, permet d'aller à la page N | Lent sur les grandes tables, résultats incohérents si les données changent |
| **Curseur** | Performant, résultats cohérents | Pas de saut à une page précise |

### 13.4 Filtrage et tri

```
# Filtrage
GET /dataset/samples?species=setosa
GET /dataset/samples?species=setosa&min_sepal_length=5.0

# Tri
GET /dataset/samples?sort=sepal_length        → Croissant
GET /dataset/samples?sort=-sepal_length       → Décroissant
GET /dataset/samples?sort=species,-confidence  → Multi-critères

# Sélection de champs
GET /dataset/samples?fields=species,sepal_length

# Recherche
GET /dataset/samples?search=setosa
```

### 13.5 Format d'erreur standardisé

Toujours retourner un format d'erreur cohérent :

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Les données fournies sont invalides",
    "details": [
      {
        "field": "sepal_length",
        "message": "La valeur doit être entre 0 et 10",
        "received": -5.0
      }
    ],
    "timestamp": "2026-04-13T14:30:00Z",
    "request_id": "550e8400-e29b-41d4-a716-446655440000"
  }
}
```

**Format d'erreur RFC 7807 (Problem Details)** :

```json
{
  "type": "https://api.example.com/errors/validation",
  "title": "Validation Error",
  "status": 422,
  "detail": "sepal_length must be between 0 and 10",
  "instance": "/predict"
}
```

### 13.6 HATEOAS (Hypermedia As The Engine Of Application State)

HATEOAS est la contrainte REST la plus avancée : les réponses contiennent des liens vers les actions possibles.

```json
{
  "species": "setosa",
  "confidence": 1.0,
  "_links": {
    "self": {
      "href": "/predict",
      "method": "POST"
    },
    "model_info": {
      "href": "/model/info",
      "method": "GET"
    },
    "similar_samples": {
      "href": "/dataset/samples?species=setosa",
      "method": "GET"
    },
    "documentation": {
      "href": "/docs",
      "method": "GET"
    }
  }
}
```

### 13.7 Résumé des bonnes pratiques

| Catégorie | Bonne pratique |
|-----------|---------------|
| **URL** | Noms au pluriel, kebab-case, minuscules |
| **Méthodes** | Utiliser le bon verbe HTTP pour chaque action |
| **Codes** | Retourner le code de statut approprié |
| **Format** | JSON par défaut, erreurs structurées |
| **Versioning** | Versionner l'API (`/v1/`, `/v2/`) |
| **Pagination** | Toujours paginer les collections |
| **Filtrage** | Permettre le filtrage via query params |
| **Documentation** | OpenAPI/Swagger toujours à jour |
| **Sécurité** | HTTPS, authentification, rate limiting |
| **CORS** | Configurer précisément les origines autorisées |
| **Idempotence** | PUT et DELETE doivent être idempotents |
| **Validation** | Valider toutes les entrées côté serveur |
| **Rate limiting** | Limiter le nombre de requêtes par client |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 14 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-14"></a>

<details>
<summary><strong>14 — Tester une API</strong></summary>

### 14.1 Swagger UI (Documentation interactive)

FastAPI génère automatiquement une documentation interactive via **Swagger UI**. Elle est accessible à `http://localhost:8000/docs`.

**Fonctionnalités** :
- Voir tous les endpoints et leurs paramètres
- Tester les endpoints directement depuis le navigateur
- Voir les schémas de requête et réponse (générés depuis les modèles Pydantic)
- Exporter la spécification OpenAPI (`http://localhost:8000/openapi.json`)

**Pour notre API Iris** :
1. Lancer le serveur : `cd backend && python main.py`
2. Ouvrir `http://localhost:8000/docs` dans le navigateur
3. Cliquer sur un endpoint (ex: `POST /predict`)
4. Cliquer « Try it out »
5. Modifier le JSON d'exemple
6. Cliquer « Execute »
7. Voir la réponse

FastAPI fournit aussi **ReDoc** à `http://localhost:8000/redoc` (documentation alternative plus élégante).

### 14.2 REST Client (Extension VS Code)

L'extension **REST Client** pour VS Code permet de tester des APIs directement depuis l'éditeur.

Créer un fichier `test.http` ou `test.rest` :

```http
### Health Check
GET http://localhost:8000/health

### Prédiction Setosa
POST http://localhost:8000/predict
Content-Type: application/json

{
  "sepal_length": 5.1,
  "sepal_width": 3.5,
  "petal_length": 1.4,
  "petal_width": 0.2
}

### Prédiction Versicolor
POST http://localhost:8000/predict
Content-Type: application/json

{
  "sepal_length": 5.9,
  "sepal_width": 2.8,
  "petal_length": 4.5,
  "petal_width": 1.3
}

### Prédiction Virginica
POST http://localhost:8000/predict
Content-Type: application/json

{
  "sepal_length": 6.3,
  "sepal_width": 3.3,
  "petal_length": 6.0,
  "petal_width": 2.5
}

### Informations du modèle
GET http://localhost:8000/model/info

### Échantillons du dataset
GET http://localhost:8000/dataset/samples

### Statistiques du dataset
GET http://localhost:8000/dataset/stats

### Test d'erreur — données invalides
POST http://localhost:8000/predict
Content-Type: application/json

{
  "sepal_length": -5
}
```

Cliquer sur « Send Request » au-dessus de chaque bloc pour l'exécuter.

### 14.3 Postman — Tests automatisés

Voir section 10 pour la configuration de base. Voici des exemples de tests avancés :

```javascript
// Onglet "Tests" dans Postman pour POST /predict

// Vérifier le code de statut
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

// Vérifier le temps de réponse
pm.test("Response time is less than 500ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(500);
});

// Vérifier la structure de la réponse
pm.test("Response has correct structure", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property("species");
    pm.expect(jsonData).to.have.property("confidence");
    pm.expect(jsonData).to.have.property("probabilities");
});

// Vérifier les valeurs
pm.test("Species is valid", function () {
    var jsonData = pm.response.json();
    pm.expect(["setosa", "versicolor", "virginica"]).to.include(jsonData.species);
});

// Vérifier les probabilités
pm.test("Probabilities sum to approximately 1", function () {
    var jsonData = pm.response.json();
    var sum = Object.values(jsonData.probabilities).reduce((a, b) => a + b, 0);
    pm.expect(sum).to.be.closeTo(1, 0.01);
});
```

### 14.4 pytest — Tests automatisés en Python

```python
# test_api.py
import pytest
import requests

BASE_URL = "http://localhost:8000"


class TestHealthEndpoints:
    def test_root(self):
        response = requests.get(f"{BASE_URL}/")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "ok"

    def test_health_check(self):
        response = requests.get(f"{BASE_URL}/health")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "healthy"
        assert data["model_loaded"] is True


class TestPredictionEndpoint:
    def test_predict_setosa(self):
        payload = {
            "sepal_length": 5.1,
            "sepal_width": 3.5,
            "petal_length": 1.4,
            "petal_width": 0.2,
        }
        response = requests.post(f"{BASE_URL}/predict", json=payload)
        assert response.status_code == 200
        data = response.json()
        assert data["species"] == "setosa"
        assert 0 <= data["confidence"] <= 1

    def test_predict_versicolor(self):
        payload = {
            "sepal_length": 5.9,
            "sepal_width": 2.8,
            "petal_length": 4.5,
            "petal_width": 1.3,
        }
        response = requests.post(f"{BASE_URL}/predict", json=payload)
        assert response.status_code == 200
        assert response.json()["species"] == "versicolor"

    def test_predict_virginica(self):
        payload = {
            "sepal_length": 6.3,
            "sepal_width": 3.3,
            "petal_length": 6.0,
            "petal_width": 2.5,
        }
        response = requests.post(f"{BASE_URL}/predict", json=payload)
        assert response.status_code == 200
        assert response.json()["species"] == "virginica"

    def test_predict_invalid_data(self):
        payload = {"sepal_length": -5}
        response = requests.post(f"{BASE_URL}/predict", json=payload)
        assert response.status_code == 422

    def test_predict_empty_body(self):
        response = requests.post(f"{BASE_URL}/predict", json={})
        assert response.status_code == 422

    def test_probabilities_sum_to_one(self):
        payload = {
            "sepal_length": 5.1,
            "sepal_width": 3.5,
            "petal_length": 1.4,
            "petal_width": 0.2,
        }
        response = requests.post(f"{BASE_URL}/predict", json=payload)
        data = response.json()
        total = sum(data["probabilities"].values())
        assert abs(total - 1.0) < 0.01


class TestModelEndpoint:
    def test_model_info(self):
        response = requests.get(f"{BASE_URL}/model/info")
        assert response.status_code == 200
        data = response.json()
        assert "model_type" in data
        assert "accuracy" in data
        assert "feature_names" in data
        assert "target_names" in data
        assert len(data["feature_names"]) == 4
        assert len(data["target_names"]) == 3


class TestDatasetEndpoints:
    def test_dataset_samples(self):
        response = requests.get(f"{BASE_URL}/dataset/samples")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) == 10
        for sample in data:
            assert "sepal_length" in sample
            assert "species" in sample

    def test_dataset_stats(self):
        response = requests.get(f"{BASE_URL}/dataset/stats")
        assert response.status_code == 200
        data = response.json()
        assert data["total_samples"] == 150
        assert data["species_count"] == 3
```

Exécuter les tests :

```bash
cd backend
pytest test_api.py -v
```

### 14.5 httpx avec pytest (tests avec TestClient FastAPI)

Pour des tests unitaires sans démarrer le serveur :

```python
# test_api_unit.py
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_predict():
    response = client.post(
        "/predict",
        json={
            "sepal_length": 5.1,
            "sepal_width": 3.5,
            "petal_length": 1.4,
            "petal_width": 0.2,
        },
    )
    assert response.status_code == 200
    assert response.json()["species"] == "setosa"
```

### 14.6 Comparaison des outils de test

| Outil | Type | Automatisable | Courbe d'apprentissage | Idéal pour |
|-------|------|--------------|----------------------|------------|
| **Swagger UI** | Interactif (navigateur) | ❌ | ⭐ Très facile | Exploration rapide, documentation |
| **REST Client** | Interactif (VS Code) | ❌ | ⭐ Très facile | Tests ad hoc pendant le développement |
| **Postman** | Interactif + Script | ✅ (Newman) | ⭐⭐ Facile | Tests manuels et automatisés |
| **curl** | Ligne de commande | ✅ (scripts bash) | ⭐⭐⭐ Modérée | CI/CD, scripts, debugging |
| **pytest + requests** | Code Python | ✅ | ⭐⭐⭐ Modérée | Tests d'intégration automatisés |
| **TestClient (FastAPI)** | Code Python | ✅ | ⭐⭐ Facile | Tests unitaires sans serveur |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 15 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-15"></a>

<details>
<summary><strong>15 — Cas pratique : notre application Iris</strong></summary>

### 15.1 Vue d'ensemble de l'architecture

```mermaid
graph LR
    subgraph "Frontend — Flutter"
        UI["🖥️ PredictionScreen<br/>(UI utilisateur)"]
        SVC["📡 ApiService<br/>(client HTTP)"]
        MDL["📦 PredictionRequest<br/>PredictionResponse<br/>(modèles de données)"]
    end

    subgraph "Réseau"
        HTTP["🌐 HTTP / JSON<br/>POST /predict"]
    end

    subgraph "Backend — FastAPI"
        EP["⚡ Endpoint /predict<br/>(route FastAPI)"]
        VAL["✅ Validation Pydantic<br/>(PredictionRequest)"]
        ML["🤖 Modèle ML<br/>(Random Forest)"]
        RES["📤 PredictionResponse<br/>(réponse JSON)"]
    end

    UI --> SVC
    SVC --> MDL
    MDL --> HTTP
    HTTP --> EP
    EP --> VAL
    VAL --> ML
    ML --> RES
    RES --> HTTP
```

### 15.2 Traçage complet d'une requête de prédiction

Suivons le parcours complet d'une requête, depuis le clic de l'utilisateur jusqu'à l'affichage du résultat.

```mermaid
sequenceDiagram
    participant U as 👤 Utilisateur
    participant UI as 🖥️ PredictionScreen
    participant SVC as 📡 ApiService
    participant NET as 🌐 Réseau HTTP
    participant API as ⚡ FastAPI
    participant PYD as ✅ Pydantic
    participant ML as 🤖 Random Forest

    U->>UI: 1. Saisit les mesures<br/>et clique "Prédire"

    UI->>SVC: 2. predict(PredictionRequest)

    Note over SVC: 3. Sérialisation<br/>request.toJson() →<br/>json.encode() →<br/>String JSON

    SVC->>NET: 4. POST /predict<br/>Content-Type: application/json<br/>{"sepal_length":5.1,...}

    NET->>API: 5. Requête HTTP arrive<br/>au serveur FastAPI

    API->>PYD: 6. Validation automatique<br/>des données (Pydantic)

    Note over PYD: Vérifie :<br/>- Types (float)<br/>- Contraintes (0 ≤ val ≤ 10)<br/>- Champs requis

    PYD-->>API: 7. PredictionRequest<br/>validé ✅

    API->>ML: 8. model.predict([[5.1, 3.5, 1.4, 0.2]])<br/>model.predict_proba(...)

    ML-->>API: 9. prediction=0<br/>probabilities=[1.0, 0.0, 0.0]

    Note over API: 10. Construction de<br/>la réponse

    API-->>NET: 11. HTTP 200 OK<br/>{"species":"setosa",<br/>"confidence":1.0,...}

    NET-->>SVC: 12. response.body arrive<br/>au client Dart

    Note over SVC: 13. Désérialisation<br/>json.decode() →<br/>PredictionResponse.fromJson()

    SVC-->>UI: 14. PredictionResponse<br/>(objet Dart)

    UI-->>U: 15. Affiche le résultat :<br/>"Setosa (100%)"
```

### 15.3 Le code côté Flutter (client)

#### Étape 1 : L'utilisateur interagit avec l'UI

L'écran `PredictionScreen` contient des sliders/champs de texte pour saisir les mesures de la fleur.

#### Étape 2 : Appel du service API

```dart
// Dans le widget PredictionScreen (simplifié)
final apiService = ApiService();

void _predict() async {
  setState(() => _isLoading = true);

  try {
    final request = PredictionRequest(
      sepalLength: _sepalLength,   // ex: 5.1
      sepalWidth: _sepalWidth,     // ex: 3.5
      petalLength: _petalLength,   // ex: 1.4
      petalWidth: _petalWidth,     // ex: 0.2
    );

    final response = await apiService.predict(request);

    setState(() {
      _species = response.species;         // "setosa"
      _confidence = response.confidence;   // 1.0
      _probabilities = response.probabilities;
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur: $e')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}
```

#### Étape 3 : Sérialisation et envoi HTTP

```dart
// Dans ApiService.predict()
Future<PredictionResponse> predict(PredictionRequest request) async {
  // request.toJson() produit :
  // {"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}
  //
  // json.encode() convertit la Map en String JSON
  //
  // http.post() envoie la requête HTTP :
  //   POST /predict HTTP/1.1
  //   Host: localhost:8000
  //   Content-Type: application/json
  //
  //   {"sepal_length":5.1,"sepal_width":3.5,"petal_length":1.4,"petal_width":0.2}

  final response = await http.post(
    Uri.parse('$baseUrl/predict'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(request.toJson()),
  );

  if (response.statusCode == 200) {
    return PredictionResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Erreur de prédiction: ${response.statusCode}');
  }
}
```

### 15.4 Le code côté FastAPI (serveur)

#### Étape 4 : Réception et validation

```python
# La requête arrive à FastAPI

# 1. FastAPI lit le corps JSON de la requête
# 2. Pydantic valide automatiquement les données

class PredictionRequest(BaseModel):
    sepal_length: float = Field(..., ge=0, le=10)  # ge=0 : ≥ 0, le=10 : ≤ 10
    sepal_width: float = Field(..., ge=0, le=10)
    petal_length: float = Field(..., ge=0, le=10)
    petal_width: float = Field(..., ge=0, le=10)

# Si la validation échoue → 422 Unprocessable Entity automatiquement
# Exemple d'erreur :
# {
#   "detail": [{
#     "loc": ["body", "sepal_length"],
#     "msg": "ensure this value is greater than or equal to 0",
#     "type": "value_error.number.not_ge"
#   }]
# }
```

#### Étape 5 : Exécution du modèle ML

```python
@app.post("/predict", response_model=PredictionResponse)
async def predict(request: PredictionRequest):
    if model is None:
        raise HTTPException(status_code=503, detail="Le modèle n'est pas chargé")

    # Convertir les données en tableau NumPy
    features = np.array(
        [[request.sepal_length, request.sepal_width,
          request.petal_length, request.petal_width]]
    )
    # features = [[5.1, 3.5, 1.4, 0.2]]

    # Exécuter la prédiction
    prediction = model.predict(features)[0]        # 0 (index de "setosa")
    probabilities = model.predict_proba(features)[0]  # [1.0, 0.0, 0.0]

    # Construire la réponse
    target_names = metadata["target_names"]  # ["setosa", "versicolor", "virginica"]
    species = target_names[prediction]       # "setosa"
    confidence = float(probabilities[prediction])  # 1.0

    prob_dict = {
        name: round(float(p), 4)
        for name, p in zip(target_names, probabilities)
    }
    # {"setosa": 1.0, "versicolor": 0.0, "virginica": 0.0}

    return PredictionResponse(
        species=species,
        confidence=round(confidence, 4),
        probabilities=prob_dict,
    )
    # FastAPI sérialise automatiquement en JSON :
    # {"species": "setosa", "confidence": 1.0, "probabilities": {...}}
```

### 15.5 Le trajet des données en détail

```
┌──────────────────────────────────────────────────────────────────────┐
│                        FLUTTER (CLIENT)                             │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  double sepalLength = 5.1;    ← Variables Dart (double)             │
│  double sepalWidth = 3.5;                                            │
│  double petalLength = 1.4;                                           │
│  double petalWidth = 0.2;                                            │
│                        │                                             │
│                        ▼                                             │
│  PredictionRequest(sepalLength: 5.1, ...)  ← Objet Dart             │
│                        │                                             │
│                        ▼ .toJson()                                   │
│  {"sepal_length": 5.1, "sepal_width": 3.5, ...}  ← Map<String,dyn> │
│                        │                                             │
│                        ▼ json.encode()                               │
│  '{"sepal_length":5.1,"sepal_width":3.5,...}'  ← String JSON        │
│                        │                                             │
│                        ▼ http.post(body: ...)                        │
└──────────────────────────┼───────────────────────────────────────────┘
                           │
              ┌────────────▼────────────┐
              │     RÉSEAU (HTTP)        │
              │  POST /predict HTTP/1.1  │
              │  Content-Type: app/json  │
              │  Body: {...}             │
              └────────────┬────────────┘
                           │
┌──────────────────────────▼───────────────────────────────────────────┐
│                        FASTAPI (SERVEUR)                             │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Corps HTTP brut (bytes)  ← Reçu par Uvicorn                        │
│           │                                                          │
│           ▼ JSON parse (automatique FastAPI)                         │
│  {"sepal_length": 5.1, ...}  ← dict Python                          │
│           │                                                          │
│           ▼ Validation Pydantic (automatique)                        │
│  PredictionRequest(sepal_length=5.1, ...)  ← Objet Pydantic         │
│           │                                                          │
│           ▼ np.array([[5.1, 3.5, 1.4, 0.2]])                        │
│  [[5.1, 3.5, 1.4, 0.2]]  ← NumPy array                             │
│           │                                                          │
│           ▼ model.predict() + model.predict_proba()                  │
│  prediction=0, probabilities=[1.0, 0.0, 0.0]  ← Résultat ML        │
│           │                                                          │
│           ▼ Construction PredictionResponse                          │
│  PredictionResponse(species="setosa", ...)  ← Objet Pydantic        │
│           │                                                          │
│           ▼ Sérialisation JSON (automatique FastAPI)                 │
│  '{"species":"setosa","confidence":1.0,...}'  ← String JSON          │
│           │                                                          │
│           ▼ HTTP Response                                            │
└──────────────────────────┬───────────────────────────────────────────┘
                           │
              ┌────────────▼────────────┐
              │     RÉSEAU (HTTP)        │
              │  HTTP/1.1 200 OK         │
              │  Content-Type: app/json  │
              │  Body: {...}             │
              └────────────┬────────────┘
                           │
┌──────────────────────────▼───────────────────────────────────────────┐
│                        FLUTTER (CLIENT)                             │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  response.body  ← String JSON brute                                  │
│           │                                                          │
│           ▼ json.decode()                                            │
│  {"species": "setosa", "confidence": 1.0, ...}  ← Map<String,dyn>  │
│           │                                                          │
│           ▼ PredictionResponse.fromJson()                            │
│  PredictionResponse(species: "setosa", ...)  ← Objet Dart           │
│           │                                                          │
│           ▼ setState()                                               │
│  🖥️ UI mise à jour : "Setosa (100%)"  ← Affichage à l'écran       │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

### 15.6 Résumé des technologies utilisées

| Couche | Technologie | Rôle |
|--------|-------------|------|
| **UI** | Flutter (Material Design 3) | Interface utilisateur |
| **Client HTTP** | Package `http` (Dart) | Envoi des requêtes |
| **Sérialisation client** | `dart:convert` (json.encode/decode) | Conversion objets ↔ JSON |
| **Protocole** | HTTP/1.1 | Transport des données |
| **Format** | JSON | Format d'échange |
| **Framework serveur** | FastAPI | Routing, middleware, documentation |
| **Validation** | Pydantic | Validation automatique des entrées |
| **ML** | scikit-learn (Random Forest) | Prédiction |
| **Serveur ASGI** | Uvicorn | Serveur web Python asynchrone |
| **CORS** | CORSMiddleware (FastAPI) | Autoriser les requêtes cross-origin |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 16 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-16"></a>

<details>
<summary><strong>16 — Glossaire des termes</strong></summary>

| Terme | Définition |
|-------|-----------|
| **API** | **Application Programming Interface** — Interface permettant à deux logiciels de communiquer entre eux. |
| **REST** | **Representational State Transfer** — Style architectural pour les APIs web, basé sur les standards HTTP. |
| **RESTful** | Adjectif qualifiant une API qui respecte les contraintes de l'architecture REST. |
| **Endpoint** | Point d'accès d'une API, défini par une URL et une méthode HTTP. Ex: `POST /predict`. |
| **Ressource** | Entité manipulée par l'API (utilisateur, produit, prédiction), identifiée par une URI. |
| **URI / URL** | **Uniform Resource Identifier / Locator** — Adresse unique identifiant une ressource sur le web. |
| **Payload** | Données utiles transportées dans le corps d'une requête ou réponse HTTP. |
| **Header (en-tête)** | Métadonnées transmises avec une requête ou réponse HTTP (Content-Type, Authorization, etc.). |
| **Body (corps)** | Partie de la requête/réponse contenant les données (JSON, XML, texte, binaire). |
| **Query Parameter** | Paramètre passé dans l'URL après `?`. Ex: `/users?page=2&role=admin`. |
| **Path Parameter** | Variable dans le chemin de l'URL. Ex: `/users/{id}` où `{id}` est remplacé par `42`. |
| **Sérialisation** | Conversion d'un objet en mémoire en format texte (JSON, XML) pour le transport réseau. |
| **Désérialisation** | Opération inverse de la sérialisation : texte (JSON) → objet en mémoire. |
| **JSON** | **JavaScript Object Notation** — Format de données texte léger, standard des APIs REST. |
| **HTTP** | **HyperText Transfer Protocol** — Protocole de communication du web. |
| **HTTPS** | HTTP sécurisé par chiffrement TLS/SSL. |
| **Méthode HTTP** | Verbe indiquant l'action à effectuer (GET, POST, PUT, PATCH, DELETE). |
| **Code de statut** | Nombre à 3 chiffres indiquant le résultat d'une requête HTTP (200, 404, 500...). |
| **Idempotent** | Propriété d'une opération qui produit le même résultat même si exécutée plusieurs fois. |
| **Stateless** | Sans état — le serveur ne conserve aucune information de session entre les requêtes. |
| **CORS** | **Cross-Origin Resource Sharing** — Mécanisme de sécurité contrôlant les accès entre origines. |
| **Preflight** | Requête OPTIONS automatique envoyée par le navigateur avant certaines requêtes cross-origin. |
| **Middleware** | Couche logicielle intermédiaire qui traite les requêtes/réponses (auth, CORS, logging). |
| **JWT** | **JSON Web Token** — Token d'authentification auto-contenu, signé cryptographiquement. |
| **OAuth 2.0** | Framework d'autorisation permettant l'accès délégué aux ressources. |
| **Bearer Token** | Jeton d'authentification transmis dans l'en-tête `Authorization: Bearer <token>`. |
| **API Key** | Clé unique identifiant un client d'API, transmise dans les en-têtes ou l'URL. |
| **Rate Limiting** | Limitation du nombre de requêtes qu'un client peut effectuer dans un intervalle de temps. |
| **Pagination** | Technique pour diviser une grande collection en pages plus petites. |
| **HATEOAS** | **Hypermedia As The Engine Of Application State** — Contrainte REST où les réponses contiennent des liens. |
| **OpenAPI** | Spécification standard pour décrire les APIs REST (anciennement Swagger). |
| **Swagger UI** | Interface web interactive pour explorer et tester une API documentée en OpenAPI. |
| **Content-Type** | En-tête HTTP spécifiant le type MIME des données (ex: `application/json`). |
| **Accept** | En-tête HTTP indiquant les types MIME que le client peut accepter en réponse. |
| **Timeout** | Durée maximale d'attente avant qu'une requête soit considérée comme échouée. |
| **Proxy** | Serveur intermédiaire qui transmet les requêtes entre le client et le serveur. |
| **Load Balancer** | Répartiteur de charge qui distribue les requêtes entre plusieurs serveurs. |
| **SDK** | **Software Development Kit** — Bibliothèque facilitant l'intégration d'une API dans un langage donné. |
| **Webhook** | Mécanisme où le serveur envoie des données au client quand un événement se produit (push vs pull). |
| **GraphQL** | Alternative à REST où le client spécifie exactement les données souhaitées dans la requête. |
| **gRPC** | Framework RPC haute performance utilisant Protocol Buffers et HTTP/2. |
| **Pydantic** | Bibliothèque Python de validation de données utilisée par FastAPI. |
| **ASGI** | **Asynchronous Server Gateway Interface** — Interface standard pour les serveurs web Python asynchrones. |
| **Uvicorn** | Serveur ASGI haute performance pour Python (utilisé par FastAPI). |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ════════════════════════════════════════════════════════════════════ -->
<!-- SECTION 17 -->
<!-- ════════════════════════════════════════════════════════════════════ -->

<a id="section-17"></a>

<details>
<summary><strong>17 — Conclusion et ressources</strong></summary>

### 17.1 Ce que nous avons appris

Ce cours a couvert de manière exhaustive la consommation des services web REST :

| Chapitre | Concepts clés |
|----------|--------------|
| 1. Services Web | Définition, SOAP vs REST, évolution historique |
| 2. Architecture REST | Les 6 contraintes, modèle de maturité de Richardson |
| 3. Protocole HTTP | Cycle requête/réponse, anatomie URL, en-têtes |
| 4. Méthodes HTTP | GET, POST, PUT, PATCH, DELETE — tableau comparatif |
| 5. Codes de statut | 1xx à 5xx — quand utiliser chaque code |
| 6. Formats de données | JSON vs XML vs YAML, sérialisation/désérialisation |
| 7. Python | Bibliothèque `requests` — tous les verbes HTTP |
| 8. Dart/Flutter | Package `http`, async/await, code du projet réel |
| 9. JavaScript | Fetch API et Axios — comparaison |
| 10. curl & Postman | Tests en ligne de commande et interface graphique |
| 11. Authentification | API Keys, JWT, OAuth 2.0 — comparaison |
| 12. CORS | Mécanisme, preflight, configuration FastAPI |
| 13. Bonnes pratiques | Nommage, versioning, pagination, erreurs |
| 14. Tests | Swagger UI, REST Client, Postman, pytest |
| 15. Cas pratique | Traçage complet Flutter → FastAPI → réponse |
| 16. Glossaire | 40+ termes définis |

### 17.2 Les points essentiels à retenir

1. **REST n'est pas un protocole** — c'est un style architectural qui exploite les standards HTTP
2. **Chaque requête HTTP est autonome** — le serveur ne conserve pas d'état de session
3. **JSON est le format standard** des APIs REST modernes
4. **Les codes de statut comptent** — utilisez toujours le code approprié
5. **La validation des données est cruciale** — côté client ET côté serveur
6. **CORS est une protection navigateur** — curl et Postman ne sont pas affectés
7. **Testez votre API** — avec plusieurs outils (Swagger, Postman, pytest)
8. **Documentez votre API** — OpenAPI/Swagger est indispensable

### 17.3 Ressources pour aller plus loin

#### Documentation officielle

| Ressource | URL |
|-----------|-----|
| FastAPI Documentation | https://fastapi.tiangolo.com/ |
| HTTP/1.1 Specification (RFC 7230-7235) | https://www.rfc-editor.org/rfc/rfc7230 |
| HTTP Status Codes (RFC 7231) | https://www.rfc-editor.org/rfc/rfc7231 |
| JSON Specification (RFC 8259) | https://www.rfc-editor.org/rfc/rfc8259 |
| OpenAPI Specification | https://spec.openapis.org/oas/v3.1.0 |
| REST (thèse de Roy Fielding) | https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm |
| Python `requests` | https://docs.python-requests.org/ |
| Dart `http` package | https://pub.dev/packages/http |
| Flutter HTTP Cookbook | https://docs.flutter.dev/cookbook/networking |
| MDN — HTTP | https://developer.mozilla.org/fr/docs/Web/HTTP |
| MDN — CORS | https://developer.mozilla.org/fr/docs/Web/HTTP/CORS |

#### Outils

| Outil | Description | URL |
|-------|-------------|-----|
| Postman | Client API graphique | https://www.postman.com/ |
| Insomnia | Alternative à Postman (open-source) | https://insomnia.rest/ |
| HTTPie | curl moderne et convivial | https://httpie.io/ |
| jq | Processeur JSON en ligne de commande | https://jqlang.github.io/jq/ |
| JSON Formatter | Extension navigateur pour formater le JSON | Chrome Web Store |
| REST Client | Extension VS Code | VS Code Marketplace |

#### Livres et cours recommandés

| Titre | Auteur | Type |
|-------|--------|------|
| *RESTful Web APIs* | Leonard Richardson, Mike Amundsen | Livre |
| *Designing Web APIs* | Brenda Jin, Saurabh Sahni, Amir Shevat | Livre |
| *HTTP: The Definitive Guide* | David Gourley, Brian Totty | Livre |
| *Building Microservices* | Sam Newman | Livre |

### 17.4 Prochaines étapes

Pour approfondir vos connaissances, voici les sujets à explorer :

- **GraphQL** — Alternative à REST pour des requêtes plus flexibles
- **gRPC** — Communication haute performance pour les microservices
- **WebSockets** — Communication bidirectionnelle en temps réel
- **API Gateway** — Gestion centralisée des APIs (Kong, AWS API Gateway)
- **Rate Limiting et Throttling** — Protection avancée contre les abus
- **Caching avancé** — Redis, CDN, stratégies de cache
- **API Versioning avancé** — Gestion du cycle de vie d'une API
- **Monitoring et Observabilité** — Logs, métriques, traces distribuées
- **Documentation as Code** — Génération automatique de documentation

---

> **Félicitations !** Vous disposez maintenant d'une compréhension complète des services web REST, de la théorie à la pratique. Ce document vous servira de **référence** tout au long de vos projets de développement.

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

> *Document généré pour le projet **Iris ML Demo — Full Stack App** (Flutter + FastAPI + Jupyter)*
> *Dernière mise à jour : avril 2026*
