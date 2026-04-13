<a id="top"></a>

# 05 — Consommation de Services Web REST

> **Objectif pédagogique** : Comprendre en profondeur les services web REST, le protocole HTTP, les formats de données, et savoir consommer des APIs REST avec Python (`requests`), Streamlit, JavaScript, curl et Postman. Appliquer ces connaissances à notre application Iris ML Demo.

---

## Table des matières

| # | Section | Description |
|---|---------|-------------|
| 1 | [Qu'est-ce qu'un service web ?](#section-1) | Définition, historique, SOAP vs REST |
| &nbsp;&nbsp;&nbsp;↳ | [1.1 Définition générale](#section-1) | Interopérabilité entre systèmes |
| &nbsp;&nbsp;&nbsp;↳ | [1.2 Historique des services web](#section-1) | De RPC à REST |
| &nbsp;&nbsp;&nbsp;↳ | [1.3 SOAP vs REST](#section-1) | Comparaison détaillée |
| 2 | [L'architecture REST en profondeur](#section-2) | Les 6 contraintes architecturales |
| &nbsp;&nbsp;&nbsp;↳ | [2.1 Origine et définition](#section-2) | Thèse de Roy Fielding |
| &nbsp;&nbsp;&nbsp;↳ | [2.2 Les 6 contraintes REST](#section-2) | Client-Server, Stateless, Cacheable… |
| &nbsp;&nbsp;&nbsp;↳ | [2.3 Ressources et représentations](#section-2) | URI, représentation, HATEOAS |
| 3 | [Le protocole HTTP](#section-3) | Requêtes, réponses, headers, anatomie d'URL |
| &nbsp;&nbsp;&nbsp;↳ | [3.1 Anatomie d'une requête HTTP](#section-3) | Ligne de requête, headers, body |
| &nbsp;&nbsp;&nbsp;↳ | [3.2 Anatomie d'une réponse HTTP](#section-3) | Ligne de statut, headers, body |
| &nbsp;&nbsp;&nbsp;↳ | [3.3 Anatomie d'une URL](#section-3) | Schéma, hôte, chemin, query string |
| &nbsp;&nbsp;&nbsp;↳ | [3.4 Diagramme de flux HTTP](#section-3) | Séquence client-serveur |
| 4 | [Les méthodes HTTP](#section-4) | GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD |
| &nbsp;&nbsp;&nbsp;↳ | [4.1 Tableau récapitulatif](#section-4) | Méthode, usage, idempotence, corps |
| &nbsp;&nbsp;&nbsp;↳ | [4.2 Safe vs Unsafe, Idempotent vs Non-idempotent](#section-4) | Classification |
| 5 | [Les codes de statut HTTP](#section-5) | 1xx à 5xx — tableau exhaustif |
| &nbsp;&nbsp;&nbsp;↳ | [5.1 Catégories](#section-5) | Informationnel, Succès, Redirection, Erreur |
| &nbsp;&nbsp;&nbsp;↳ | [5.2 Tableau détaillé](#section-5) | Codes courants et rares |
| 6 | [Les formats de données](#section-6) | JSON, XML, YAML — comparaison |
| &nbsp;&nbsp;&nbsp;↳ | [6.1 JSON](#section-6) | Syntaxe, types, exemples |
| &nbsp;&nbsp;&nbsp;↳ | [6.2 XML](#section-6) | Syntaxe, namespaces |
| &nbsp;&nbsp;&nbsp;↳ | [6.3 YAML](#section-6) | Syntaxe, indentation |
| &nbsp;&nbsp;&nbsp;↳ | [6.4 Comparaison](#section-6) | Tableau JSON vs XML vs YAML |
| 7 | [Consommer une API avec Python `requests`](#section-7) | **SECTION PRINCIPALE** — GET, POST, PUT, DELETE, auth, erreurs |
| &nbsp;&nbsp;&nbsp;↳ | [7.1 Installation et import](#section-7) | pip install requests |
| &nbsp;&nbsp;&nbsp;↳ | [7.2 Requête GET](#section-7) | Paramètres, headers |
| &nbsp;&nbsp;&nbsp;↳ | [7.3 Requête POST](#section-7) | JSON, form data |
| &nbsp;&nbsp;&nbsp;↳ | [7.4 Requêtes PUT et PATCH](#section-7) | Mise à jour |
| &nbsp;&nbsp;&nbsp;↳ | [7.5 Requête DELETE](#section-7) | Suppression |
| &nbsp;&nbsp;&nbsp;↳ | [7.6 Headers personnalisés](#section-7) | Content-Type, Authorization |
| &nbsp;&nbsp;&nbsp;↳ | [7.7 Authentification](#section-7) | Basic, Bearer, API Key |
| &nbsp;&nbsp;&nbsp;↳ | [7.8 Gestion des erreurs](#section-7) | try/except, raise_for_status |
| &nbsp;&nbsp;&nbsp;↳ | [7.9 Sessions et timeout](#section-7) | requests.Session, timeout |
| 8 | [Consommer une API dans Streamlit](#section-8) | Code réel de `app.py` — spinner, affichage, erreurs |
| &nbsp;&nbsp;&nbsp;↳ | [8.1 Architecture Streamlit + API](#section-8) | Flux de données |
| &nbsp;&nbsp;&nbsp;↳ | [8.2 Vérification de la connexion API](#section-8) | check_api() |
| &nbsp;&nbsp;&nbsp;↳ | [8.3 Appeler requests dans Streamlit](#section-8) | st.spinner, try/except |
| &nbsp;&nbsp;&nbsp;↳ | [8.4 Afficher les résultats](#section-8) | st.metric, st.progress, st.dataframe |
| 9 | [Consommer une API avec JavaScript](#section-9) | fetch, axios — bref |
| 10 | [Consommer une API avec curl et Postman](#section-10) | Outils de test en ligne de commande et GUI |
| 11 | [Authentification dans les APIs REST](#section-11) | API Keys, JWT, OAuth2 |
| &nbsp;&nbsp;&nbsp;↳ | [11.1 API Keys](#section-11) | Clés simples |
| &nbsp;&nbsp;&nbsp;↳ | [11.2 JWT (JSON Web Tokens)](#section-11) | Structure, flux |
| &nbsp;&nbsp;&nbsp;↳ | [11.3 OAuth 2.0](#section-11) | Flows, scopes |
| 12 | [CORS — Cross-Origin Resource Sharing](#section-12) | Origine, preflight, configuration |
| 13 | [Bonnes pratiques de conception d'API REST](#section-13) | Nommage, versioning, pagination, HATEOAS |
| 14 | [Tester une API](#section-14) | Swagger UI, REST Client, Postman, pytest |
| 15 | [Cas pratique : notre application Iris](#section-15) | Traçabilité complète Slider → API → Modèle → Affichage |
| 16 | [Glossaire des termes](#section-16) | 40+ termes définis |
| 17 | [Conclusion et ressources](#section-17) | Synthèse et liens |

---

<!-- ============================================================ -->
<a id="section-1"></a>

<details>
<summary><strong>1 — Qu'est-ce qu'un service web ?</strong></summary>

### 1.1 Définition générale

Un **service web** (ou *web service*) est un composant logiciel accessible via le réseau (généralement Internet) qui permet à des applications différentes de communiquer entre elles, **indépendamment de leur langage de programmation, de leur système d'exploitation ou de leur plateforme matérielle**.

> **Analogie** : Un service web est comme un serveur de restaurant. Le client (votre application) passe une commande (requête) au serveur (service web) qui va en cuisine (serveur distant) et revient avec le plat (réponse). Le client n'a pas besoin de savoir comment la cuisine fonctionne.

**Caractéristiques fondamentales :**

| Caractéristique | Description |
|----------------|-------------|
| **Interopérabilité** | Communication entre systèmes hétérogènes (Java ↔ Python ↔ C# ↔ JavaScript) |
| **Protocole réseau** | Utilise des protocoles standard (HTTP, HTTPS) |
| **Format structuré** | Échange de données dans un format défini (JSON, XML) |
| **Interface publique** | Contrat d'interface documenté (OpenAPI, WSDL) |
| **Découplage** | Le client et le serveur sont indépendants |
| **Accessibilité** | Accessible depuis n'importe quel point du réseau |

### 1.2 Historique des services web

```mermaid
timeline
    title Évolution des Services Web
    1990 : RPC (Remote Procedure Call)
         : CORBA (Common Object Request Broker Architecture)
    1998 : XML-RPC
         : Apparition du protocole SOAP
    2000 : Thèse de Roy Fielding — REST
         : SOAP 1.1 devient une recommandation W3C
    2004 : Web 2.0 — Explosion des APIs
         : Premiers services RESTful populaires
    2006 : Twitter lance son API REST
         : Amazon S3 API REST
    2010 : Ère des smartphones — APIs mobiles
         : JSON remplace progressivement XML
    2015 : GraphQL (Facebook)
         : OpenAPI Specification (ex-Swagger)
    2018 : gRPC se popularise
         : APIs serverless (AWS Lambda, Cloud Functions)
    2020 : API-first design
         : WebSockets, Server-Sent Events
    2024 : AI APIs (OpenAI, Anthropic)
         : REST demeure le standard dominant
```

**Évolution des paradigmes :**

| Époque | Technologie | Protocole | Format | Complexité |
|--------|------------|-----------|--------|------------|
| 1990s | RPC / CORBA | Propriétaire | Binaire | Très élevée |
| Late 1990s | XML-RPC | HTTP | XML | Élevée |
| 2000s | SOAP | HTTP/SMTP | XML + WSDL | Élevée |
| 2000s+ | **REST** | **HTTP** | **JSON/XML** | **Faible** |
| 2015+ | GraphQL | HTTP | JSON | Moyenne |
| 2016+ | gRPC | HTTP/2 | Protocol Buffers | Moyenne |

### 1.3 SOAP vs REST — Comparaison détaillée

**SOAP** (*Simple Object Access Protocol*) et **REST** (*Representational State Transfer*) sont les deux approches principales des services web.

| Critère | SOAP | REST |
|---------|------|------|
| **Type** | Protocole | Style architectural |
| **Format de données** | XML uniquement | JSON, XML, YAML, texte, binaire |
| **Transport** | HTTP, SMTP, TCP, JMS | HTTP/HTTPS |
| **Contrat** | WSDL obligatoire | OpenAPI optionnel |
| **État** | Peut être stateful | Stateless par design |
| **Mise en cache** | Difficile | Facile (via HTTP caching) |
| **Performances** | Plus lent (verbosité XML) | Plus rapide (JSON léger) |
| **Sécurité** | WS-Security (très robuste) | HTTPS + OAuth2 / JWT |
| **Courbe d'apprentissage** | Raide | Douce |
| **Transactions** | Support natif (WS-AtomicTransaction) | Pas de support natif |
| **Utilisation typique** | Entreprise, banque, assurance | Web, mobile, IoT, ML |
| **Exemple** | Services bancaires SWIFT | Twitter API, GitHub API |

**Exemple SOAP (XML) :**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Header>
    <auth:Authentication xmlns:auth="http://example.com/auth">
      <auth:Token>abc123</auth:Token>
    </auth:Authentication>
  </soap:Header>
  <soap:Body>
    <iris:PredictRequest xmlns:iris="http://example.com/iris">
      <iris:SepalLength>5.1</iris:SepalLength>
      <iris:SepalWidth>3.5</iris:SepalWidth>
      <iris:PetalLength>1.4</iris:PetalLength>
      <iris:PetalWidth>0.2</iris:PetalWidth>
    </iris:PredictRequest>
  </soap:Body>
</soap:Envelope>
```

**Équivalent REST (JSON) :**

```json
POST /predict HTTP/1.1
Host: localhost:8000
Content-Type: application/json
Authorization: Bearer abc123

{
  "sepal_length": 5.1,
  "sepal_width": 3.5,
  "petal_length": 1.4,
  "petal_width": 0.2
}
```

> **Verdict** : REST a gagné la bataille du web moderne grâce à sa simplicité, sa légèreté et son utilisation naturelle du protocole HTTP. SOAP reste pertinent dans certains environnements d'entreprise nécessitant des transactions distribuées et une sécurité renforcée.

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-2"></a>

<details>
<summary><strong>2 — L'architecture REST en profondeur</strong></summary>

### 2.1 Origine et définition

**REST** (*Representational State Transfer*) a été défini par **Roy Thomas Fielding** dans sa thèse de doctorat en 2000 à l'Université de Californie, Irvine. Fielding est l'un des co-auteurs de la spécification HTTP/1.1 et co-fondateur du projet Apache HTTP Server.

REST n'est **pas un protocole** mais un **style architectural** — un ensemble de contraintes et de principes qui, lorsqu'ils sont respectés, produisent un système distribué performant, scalable et maintenable.

> **Citation de Fielding** : *"REST provides a set of architectural constraints that, when applied as a whole, emphasizes scalability of component interactions, generality of interfaces, independent deployment of components, and intermediary components."*

### 2.2 Les 6 contraintes de REST

```mermaid
mindmap
  root((REST))
    1. Client-Server
      Séparation des responsabilités
      Interface utilisateur vs stockage des données
      Évolution indépendante
    2. Stateless
      Chaque requête contient toute l info nécessaire
      Pas de session serveur
      Scalabilité horizontale
    3. Cacheable
      Les réponses doivent indiquer si elles sont cacheables
      Réduit la latence
      Headers Cache-Control ETag
    4. Uniform Interface
      Identification des ressources par URI
      Manipulation via représentations
      Messages auto-descriptifs
      HATEOAS
    5. Layered System
      Architecture en couches
      Load balancers proxys
      Chaque couche ne connaît que sa voisine
    6. Code on Demand optionnel
      Le serveur peut envoyer du code exécutable
      JavaScript applets
      Seule contrainte optionnelle
```

#### Contrainte 1 : Client-Serveur (Client-Server)

**Principe** : Séparer les préoccupations de l'interface utilisateur (client) de celles du stockage et du traitement des données (serveur).

| Aspect | Client | Serveur |
|--------|--------|---------|
| **Responsabilité** | Interface utilisateur, UX | Logique métier, stockage |
| **Exemples** | Streamlit, navigateur, app mobile | FastAPI, Django, Express |
| **Évolution** | Indépendante du serveur | Indépendante du client |
| **Multiplicité** | Plusieurs clients possibles | Un serveur, plusieurs instances |

**Avantages :**
- Le frontend peut évoluer sans modifier le backend (et inversement)
- Plusieurs frontends peuvent utiliser la même API (Streamlit, Flutter, React…)
- Scalabilité indépendante des deux côtés

**Dans notre projet Iris :**
```
┌─────────────────────┐         ┌─────────────────────┐
│   Streamlit (app.py)│  HTTP   │  FastAPI (main.py)   │
│   Port: 8501        │◄───────►│  Port: 8000          │
│   Interface          │  JSON   │  Modèle ML + Données │
└─────────────────────┘         └─────────────────────┘
```

#### Contrainte 2 : Sans état (Stateless)

**Principe** : Chaque requête du client vers le serveur doit contenir **toutes les informations nécessaires** pour être comprise. Le serveur ne stocke aucun contexte de session entre les requêtes.

```mermaid
sequenceDiagram
    participant C as Client Streamlit
    participant S as Serveur FastAPI
    
    Note over C,S: Chaque requête est indépendante
    
    C->>S: POST /predict {sepal_length: 5.1, ...}
    S->>C: 200 {species: "setosa", confidence: 1.0}
    
    Note over S: Le serveur oublie immédiatement cette interaction
    
    C->>S: POST /predict {sepal_length: 6.3, ...}
    S->>C: 200 {species: "virginica", confidence: 0.95}
    
    Note over S: Aucune relation avec la requête précédente
```

**Conséquences :**
- **Scalabilité** : N'importe quel serveur derrière un load balancer peut traiter n'importe quelle requête
- **Fiabilité** : Pas de perte d'état si un serveur tombe
- **Simplicité** : Le serveur n'a pas à gérer de sessions

**Ce qui est stateless vs stateful :**

| Approche | Exemple | Stockage |
|----------|---------|----------|
| **Stateless (REST)** | Token JWT dans chaque requête | Client |
| **Stateful** | Session ID + données côté serveur | Serveur |

#### Contrainte 3 : Mise en cache (Cacheable)

**Principe** : Les réponses du serveur doivent explicitement indiquer si elles peuvent être mises en cache, et pour combien de temps.

**Headers HTTP de cache :**

| Header | Rôle | Exemple |
|--------|------|---------|
| `Cache-Control` | Politique de cache | `Cache-Control: max-age=3600` |
| `ETag` | Empreinte de la ressource | `ETag: "abc123"` |
| `Last-Modified` | Date de dernière modification | `Last-Modified: Mon, 13 Apr 2026 10:00:00 GMT` |
| `Expires` | Date d'expiration absolue | `Expires: Tue, 14 Apr 2026 10:00:00 GMT` |
| `If-None-Match` | Validation conditionnelle (client) | `If-None-Match: "abc123"` |
| `If-Modified-Since` | Validation conditionnelle (client) | `If-Modified-Since: Mon, 13 Apr 2026 10:00:00 GMT` |

**Flux de cache :**

```mermaid
flowchart TD
    A[Client envoie requête] --> B{Réponse en cache ?}
    B -->|Oui, valide| C[Utiliser le cache]
    B -->|Oui, expiré| D[Requête conditionnelle au serveur]
    B -->|Non| E[Requête complète au serveur]
    D --> F{Ressource modifiée ?}
    F -->|Non| G[304 Not Modified → Utiliser le cache]
    F -->|Oui| H[200 OK → Nouvelle réponse → Mettre à jour le cache]
    E --> H
```

#### Contrainte 4 : Interface uniforme (Uniform Interface)

C'est la contrainte **la plus importante** de REST. Elle se décompose en 4 sous-contraintes :

**4a — Identification des ressources par URI**

Chaque ressource est identifiée par un URI unique :

```
GET  /predict           → Ressource de prédiction
GET  /model/info        → Information du modèle
GET  /dataset/samples   → Échantillons du dataset
GET  /dataset/stats     → Statistiques du dataset
GET  /health            → État de santé
```

**4b — Manipulation via représentations**

Le client manipule les ressources via leurs **représentations** (JSON, XML). Il ne manipule jamais directement la ressource serveur.

```
Client envoie (représentation JSON) :
{"sepal_length": 5.1, "sepal_width": 3.5, ...}

Serveur retourne (représentation JSON) :
{"species": "setosa", "confidence": 1.0, ...}
```

**4c — Messages auto-descriptifs**

Chaque message HTTP contient suffisamment d'informations pour être interprété :

```http
POST /predict HTTP/1.1
Host: localhost:8000
Content-Type: application/json    ← Le serveur sait décoder du JSON
Accept: application/json          ← Le client attend du JSON
Content-Length: 85                ← Taille du corps

{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}
```

**4d — HATEOAS (Hypermedia As The Engine Of Application State)**

Les réponses contiennent des liens vers les actions possibles :

```json
{
  "species": "setosa",
  "confidence": 1.0,
  "_links": {
    "self": {"href": "/predict"},
    "model_info": {"href": "/model/info"},
    "dataset": {"href": "/dataset/samples"}
  }
}
```

> **Note** : HATEOAS est rarement implémenté complètement dans la pratique. Notre API Iris ne l'implémente pas, ce qui est typique des APIs REST modernes.

#### Contrainte 5 : Système en couches (Layered System)

**Principe** : L'architecture peut être composée de couches hiérarchiques. Chaque couche ne connaît que la couche immédiatement adjacente.

```mermaid
flowchart LR
    A[Client<br>Streamlit] --> B[CDN / Cache<br>CloudFlare]
    B --> C[Load Balancer<br>Nginx]
    C --> D[API Gateway<br>Kong / Traefik]
    D --> E[Serveur API<br>FastAPI]
    E --> F[Base de données<br>PostgreSQL]
    
    style A fill:#e1f5fe
    style B fill:#fff3e0
    style C fill:#fff3e0
    style D fill:#fff3e0
    style E fill:#e8f5e9
    style F fill:#fce4ec
```

**Avantages :**
- Sécurité (le client ne parle pas directement à la BDD)
- Scalabilité (ajout de load balancers, caches)
- Encapsulation (chaque couche est remplaçable)

#### Contrainte 6 : Code à la demande (Code-on-Demand) — *Optionnelle*

**Principe** : Le serveur peut envoyer du code exécutable au client pour étendre ses fonctionnalités.

**Exemples :**
- JavaScript envoyé dans une page HTML
- Applets Java (obsolète)
- WebAssembly

> C'est la seule contrainte **optionnelle** de REST. La plupart des APIs REST modernes ne l'utilisent pas.

### 2.3 Ressources et représentations

**Ressource** : Toute entité nommable et adressable via une URI.

| Concept | Description | Exemple (Iris API) |
|---------|-------------|-------------------|
| **Ressource** | Entité abstraite | Le modèle ML, le dataset, une prédiction |
| **URI** | Identifiant unique | `/predict`, `/model/info`, `/dataset/stats` |
| **Représentation** | Forme concrète de la ressource | JSON `{"species": "setosa", ...}` |
| **Média-type** | Format de la représentation | `application/json` |
| **État** | Valeur courante de la ressource | Le résultat de prédiction actuel |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-3"></a>

<details>
<summary><strong>3 — Le protocole HTTP</strong></summary>

### 3.1 Anatomie d'une requête HTTP

Une requête HTTP se compose de trois parties :

```
┌─────────────────────────────────────────────────────────┐
│  LIGNE DE REQUÊTE                                       │
│  POST /predict HTTP/1.1                                 │
├─────────────────────────────────────────────────────────┤
│  HEADERS (en-têtes)                                     │
│  Host: localhost:8000                                   │
│  Content-Type: application/json                         │
│  Accept: application/json                               │
│  User-Agent: python-requests/2.31.0                     │
│  Content-Length: 85                                      │
├─────────────────────────────────────────────────────────┤
│  CORPS (body) — optionnel                               │
│  {                                                      │
│    "sepal_length": 5.1,                                 │
│    "sepal_width": 3.5,                                  │
│    "petal_length": 1.4,                                 │
│    "petal_width": 0.2                                   │
│  }                                                      │
└─────────────────────────────────────────────────────────┘
```

**Détail de la ligne de requête :**

| Composant | Valeur | Description |
|-----------|--------|-------------|
| **Méthode** | `POST` | Action à effectuer |
| **URI cible** | `/predict` | Chemin de la ressource |
| **Version HTTP** | `HTTP/1.1` | Version du protocole |

**Headers courants de requête :**

| Header | Rôle | Exemple |
|--------|------|---------|
| `Host` | Nom de domaine du serveur | `localhost:8000` |
| `Content-Type` | Type MIME du corps | `application/json` |
| `Accept` | Types MIME acceptés en réponse | `application/json` |
| `Authorization` | Identifiant d'authentification | `Bearer eyJhbGciOi...` |
| `User-Agent` | Identification du client | `python-requests/2.31.0` |
| `Content-Length` | Taille du corps en octets | `85` |
| `Accept-Encoding` | Encodages acceptés | `gzip, deflate` |
| `Accept-Language` | Langues acceptées | `fr-FR, fr;q=0.9, en;q=0.8` |
| `Connection` | Gestion de la connexion | `keep-alive` |
| `Cookie` | Cookies envoyés au serveur | `session=abc123` |
| `Origin` | Origine de la requête (CORS) | `http://localhost:8501` |
| `Referer` | URL de la page d'origine | `http://localhost:8501/` |
| `X-Request-ID` | Identifiant unique de requête | `550e8400-e29b-41d4-a716-446655440000` |

### 3.2 Anatomie d'une réponse HTTP

```
┌─────────────────────────────────────────────────────────┐
│  LIGNE DE STATUT                                        │
│  HTTP/1.1 200 OK                                        │
├─────────────────────────────────────────────────────────┤
│  HEADERS (en-têtes)                                     │
│  content-type: application/json                         │
│  content-length: 74                                     │
│  date: Mon, 13 Apr 2026 12:00:00 GMT                   │
│  server: uvicorn                                        │
│  access-control-allow-origin: *                         │
├─────────────────────────────────────────────────────────┤
│  CORPS (body)                                           │
│  {                                                      │
│    "species": "setosa",                                 │
│    "confidence": 1.0,                                   │
│    "probabilities": {                                   │
│      "setosa": 1.0,                                     │
│      "versicolor": 0.0,                                 │
│      "virginica": 0.0                                   │
│    }                                                    │
│  }                                                      │
└─────────────────────────────────────────────────────────┘
```

**Headers courants de réponse :**

| Header | Rôle | Exemple |
|--------|------|---------|
| `Content-Type` | Type MIME du corps de réponse | `application/json` |
| `Content-Length` | Taille du corps en octets | `74` |
| `Date` | Date et heure de la réponse | `Mon, 13 Apr 2026 12:00:00 GMT` |
| `Server` | Identification du serveur | `uvicorn` |
| `Access-Control-Allow-Origin` | Origines autorisées (CORS) | `*` |
| `Cache-Control` | Politique de mise en cache | `no-cache` |
| `Set-Cookie` | Cookie à stocker côté client | `session=abc123; Path=/; HttpOnly` |
| `X-Response-Time` | Temps de traitement | `12ms` |
| `Location` | URI de redirection | `/new-resource/42` |
| `ETag` | Identifiant de version de la ressource | `"v1.0-abc123"` |
| `Vary` | Headers qui affectent le cache | `Accept, Accept-Encoding` |

### 3.3 Anatomie d'une URL

```
  https://api.example.com:443/v1/predict?format=json&verbose=true#results
  └─┬──┘ └──────┬────────┘└┬┘└───┬────┘└──────────┬──────────────┘└──┬──┘
 Schéma    Hôte (Host)   Port  Chemin      Query String           Fragment
```

| Composant | Description | Exemple |
|-----------|-------------|---------|
| **Schéma** | Protocole de communication | `https` |
| **Hôte** | Nom de domaine ou adresse IP | `api.example.com` / `localhost` |
| **Port** | Port réseau (optionnel si standard) | `443` (HTTPS), `8000` (dev) |
| **Chemin** | Hiérarchie vers la ressource | `/v1/predict` |
| **Query String** | Paramètres clé-valeur | `?format=json&verbose=true` |
| **Fragment** | Sous-partie de la ressource (côté client uniquement) | `#results` |

**Exemples dans notre API Iris :**

```
http://localhost:8000/                     → Health check (racine)
http://localhost:8000/health               → État de santé
http://localhost:8000/predict              → Endpoint de prédiction
http://localhost:8000/model/info           → Informations du modèle
http://localhost:8000/dataset/samples      → Échantillons
http://localhost:8000/dataset/stats        → Statistiques
http://localhost:8000/docs                 → Documentation Swagger UI
http://localhost:8000/openapi.json         → Spécification OpenAPI
```

### 3.4 Diagramme de flux HTTP complet

```mermaid
sequenceDiagram
    participant C as Client<br>(Streamlit / Navigateur)
    participant DNS as Serveur DNS
    participant S as Serveur HTTP<br>(FastAPI + Uvicorn)
    
    Note over C: L'utilisateur clique sur "Prédire"
    
    C->>DNS: Résolution DNS : localhost → 127.0.0.1
    DNS-->>C: 127.0.0.1
    
    Note over C,S: Établissement connexion TCP (3-way handshake)
    C->>S: SYN
    S-->>C: SYN-ACK
    C->>S: ACK
    
    Note over C,S: Échange HTTP
    C->>S: POST /predict HTTP/1.1<br>Host: localhost:8000<br>Content-Type: application/json<br><br>{"sepal_length": 5.1, ...}
    
    Note over S: FastAPI :<br>1. Parse la requête<br>2. Valide avec Pydantic<br>3. Exécute model.predict()<br>4. Construit la réponse
    
    S-->>C: HTTP/1.1 200 OK<br>Content-Type: application/json<br><br>{"species": "setosa", "confidence": 1.0, ...}
    
    Note over C: Streamlit affiche :<br>- Espèce prédite<br>- Confiance<br>- Probabilités avec st.progress
```

**Versions de HTTP :**

| Version | Année | Caractéristiques clés |
|---------|-------|----------------------|
| HTTP/0.9 | 1991 | GET uniquement, pas de headers |
| HTTP/1.0 | 1996 | Headers, POST, codes de statut |
| **HTTP/1.1** | **1997** | **Keep-alive, chunked, Host header — Standard actuel** |
| HTTP/2 | 2015 | Multiplexage, compression headers, push serveur |
| HTTP/3 | 2022 | QUIC (UDP), 0-RTT, latence réduite |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-4"></a>

<details>
<summary><strong>4 — Les méthodes HTTP</strong></summary>

### 4.1 Tableau récapitulatif des méthodes HTTP

| Méthode | Description | Corps de requête | Corps de réponse | Idempotent | Safe | Usage typique |
|---------|-------------|:----------------:|:----------------:|:----------:|:----:|---------------|
| **GET** | Lire une ressource | ❌ Non | ✅ Oui | ✅ Oui | ✅ Oui | Obtenir des données |
| **POST** | Créer une ressource / Exécuter une action | ✅ Oui | ✅ Oui | ❌ Non | ❌ Non | Envoyer des données, déclencher un traitement |
| **PUT** | Remplacer entièrement une ressource | ✅ Oui | ✅ Oui | ✅ Oui | ❌ Non | Mise à jour complète |
| **PATCH** | Modifier partiellement une ressource | ✅ Oui | ✅ Oui | ❌ Non* | ❌ Non | Mise à jour partielle |
| **DELETE** | Supprimer une ressource | ❌ / ✅ Optionnel | ✅ / ❌ | ✅ Oui | ❌ Non | Suppression |
| **OPTIONS** | Décrire les options de communication | ❌ Non | ✅ Oui | ✅ Oui | ✅ Oui | CORS preflight, découverte |
| **HEAD** | Identique à GET mais sans le corps | ❌ Non | ❌ Non | ✅ Oui | ✅ Oui | Vérifier l'existence, taille |

> \* PATCH **peut** être idempotent selon l'implémentation, mais ne l'est pas par définition.

### 4.2 Safe vs Unsafe, Idempotent vs Non-idempotent

**Définitions :**
- **Safe (sûre)** : La méthode ne modifie pas l'état du serveur. Elle est en lecture seule.
- **Idempotente** : Exécuter la requête N fois produit le même résultat qu'une seule exécution.

```mermaid
quadrantChart
    title Classification des méthodes HTTP
    x-axis "Non-Safe" --> "Safe"
    y-axis "Non-Idempotent" --> "Idempotent"
    GET: [0.95, 0.95]
    HEAD: [0.95, 0.95]
    OPTIONS: [0.95, 0.95]
    PUT: [0.1, 0.9]
    DELETE: [0.1, 0.9]
    POST: [0.1, 0.1]
    PATCH: [0.1, 0.3]
```

**Exemples concrets avec notre API Iris :**

| Méthode | Endpoint | Exemple d'utilisation | Idempotent ? |
|---------|----------|----------------------|:------------:|
| `GET` | `/health` | Vérifier que l'API fonctionne | ✅ |
| `GET` | `/model/info` | Obtenir les infos du modèle | ✅ |
| `GET` | `/dataset/stats` | Obtenir les statistiques | ✅ |
| `GET` | `/dataset/samples` | Obtenir des échantillons aléatoires | ✅* |
| `POST` | `/predict` | Prédire une espèce | ✅** |

> \* Les échantillons sont aléatoires donc le résultat diffère, mais l'état du serveur ne change pas → **safe**.
> \*\* Notre POST `/predict` est en réalité idempotent (mêmes entrées → même sortie), mais POST n'est pas idempotent par définition.

### Détail de chaque méthode

#### GET — Lecture

```python
import requests

response = requests.get("http://localhost:8000/model/info")
print(response.status_code)  # 200
print(response.json())       # {"model_type": "RandomForest", ...}
```

```http
GET /model/info HTTP/1.1
Host: localhost:8000
Accept: application/json
```

**Avec paramètres de requête (query parameters) :**

```python
response = requests.get(
    "http://localhost:8000/dataset/samples",
    params={"n": 5, "species": "setosa"}
)
```

Génère : `GET /dataset/samples?n=5&species=setosa`

#### POST — Création / Action

```python
payload = {
    "sepal_length": 5.1,
    "sepal_width": 3.5,
    "petal_length": 1.4,
    "petal_width": 0.2
}
response = requests.post(
    "http://localhost:8000/predict",
    json=payload
)
print(response.json())  # {"species": "setosa", "confidence": 1.0, ...}
```

```http
POST /predict HTTP/1.1
Host: localhost:8000
Content-Type: application/json

{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}
```

#### PUT — Remplacement complet

```python
updated_config = {
    "model_type": "GradientBoosting",
    "n_estimators": 200,
    "max_depth": 5,
    "learning_rate": 0.1
}
response = requests.put(
    "http://localhost:8000/model/config",
    json=updated_config
)
```

> **PUT vs POST** : PUT remplace **intégralement** la ressource. Si un champ manque dans le corps, il sera supprimé (ou mis à une valeur par défaut).

#### PATCH — Modification partielle

```python
partial_update = {
    "n_estimators": 300
}
response = requests.patch(
    "http://localhost:8000/model/config",
    json=partial_update
)
```

> **PATCH vs PUT** : PATCH ne modifie **que les champs fournis**. Les autres restent inchangés.

#### DELETE — Suppression

```python
response = requests.delete("http://localhost:8000/cache/predictions")
print(response.status_code)  # 204 No Content
```

#### OPTIONS — Découverte

```python
response = requests.options("http://localhost:8000/predict")
print(response.headers["Allow"])  # POST, OPTIONS
print(response.headers.get("Access-Control-Allow-Methods"))  # GET, POST, PUT, DELETE
```

#### HEAD — Vérification sans corps

```python
response = requests.head("http://localhost:8000/dataset/stats")
print(response.status_code)     # 200
print(response.headers)         # Tous les headers, SANS le corps
print(response.content)         # b'' (vide)
```

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-5"></a>

<details>
<summary><strong>5 — Les codes de statut HTTP</strong></summary>

### 5.1 Catégories

Les codes de statut HTTP sont des entiers à 3 chiffres regroupés en 5 catégories :

| Catégorie | Plage | Signification | Couleur mnémonique |
|-----------|-------|---------------|-------------------|
| **1xx** | 100–199 | **Informationnel** — Requête reçue, traitement en cours | 🔵 Bleu |
| **2xx** | 200–299 | **Succès** — Requête traitée avec succès | 🟢 Vert |
| **3xx** | 300–399 | **Redirection** — Action supplémentaire nécessaire | 🟡 Jaune |
| **4xx** | 400–499 | **Erreur client** — La requête est invalide | 🟠 Orange |
| **5xx** | 500–599 | **Erreur serveur** — Le serveur a échoué | 🔴 Rouge |

### 5.2 Tableau détaillé des codes de statut

#### 1xx — Informationnel

| Code | Nom | Description | Usage |
|------|-----|-------------|-------|
| 100 | Continue | Le serveur a reçu les headers, le client peut envoyer le corps | Upload de gros fichiers |
| 101 | Switching Protocols | Le serveur accepte le changement de protocole | Upgrade vers WebSocket |
| 102 | Processing | Le serveur traite la requête (WebDAV) | Requêtes longues |
| 103 | Early Hints | Headers préliminaires pour le preloading | Optimisation de chargement |

#### 2xx — Succès

| Code | Nom | Description | Usage courant |
|------|-----|-------------|---------------|
| **200** | **OK** | **Requête réussie** | **GET, POST, PUT, PATCH réussis** |
| **201** | **Created** | **Ressource créée avec succès** | **POST créant une ressource** |
| 202 | Accepted | Requête acceptée mais traitement asynchrone | Tâches en arrière-plan |
| 203 | Non-Authoritative Information | Réponse modifiée par un proxy | Proxy transformant |
| **204** | **No Content** | **Succès, pas de contenu en réponse** | **DELETE réussi** |
| 205 | Reset Content | Succès, le client doit réinitialiser la vue | Formulaires |
| 206 | Partial Content | Réponse partielle (range request) | Téléchargement, streaming |
| 207 | Multi-Status | Résultats multiples (WebDAV) | Opérations batch |
| 208 | Already Reported | Membre déjà listé (WebDAV) | Collections |
| 226 | IM Used | Instance Manipulation appliquée | Delta encoding |

**Dans notre API Iris :**

```python
# FastAPI retourne automatiquement 200 OK pour nos endpoints
@app.post("/predict", response_model=PredictionResponse)
async def predict(request: PredictionRequest):
    ...
    return PredictionResponse(species=species, confidence=confidence, ...)
    # → HTTP 200 OK avec le JSON de réponse
```

#### 3xx — Redirection

| Code | Nom | Description | Usage |
|------|-----|-------------|-------|
| 300 | Multiple Choices | Plusieurs représentations disponibles | Content negotiation |
| **301** | **Moved Permanently** | **Ressource déplacée définitivement** | **Redirection d'URL permanente** |
| **302** | **Found** | **Ressource temporairement déplacée** | **Redirection temporaire** |
| 303 | See Other | Voir une autre URI (après POST) | Redirect après soumission |
| **304** | **Not Modified** | **Ressource non modifiée (cache valide)** | **Validation de cache** |
| 307 | Temporary Redirect | Redirection temporaire (même méthode) | Préserve la méthode HTTP |
| 308 | Permanent Redirect | Redirection permanente (même méthode) | Préserve la méthode HTTP |

#### 4xx — Erreur client

| Code | Nom | Description | Usage courant |
|------|-----|-------------|---------------|
| **400** | **Bad Request** | **Requête mal formée ou invalide** | **Validation échouée** |
| **401** | **Unauthorized** | **Authentification requise** | **Token manquant ou expiré** |
| 402 | Payment Required | Paiement requis | APIs payantes |
| **403** | **Forbidden** | **Accès interdit même avec authentification** | **Permissions insuffisantes** |
| **404** | **Not Found** | **Ressource introuvable** | **URL invalide** |
| 405 | Method Not Allowed | Méthode HTTP non supportée | GET sur un endpoint POST-only |
| 406 | Not Acceptable | Format de réponse non supporté | Accept header incompatible |
| 407 | Proxy Authentication Required | Authentification proxy requise | Proxy d'entreprise |
| 408 | Request Timeout | Timeout de la requête | Client trop lent |
| 409 | Conflict | Conflit avec l'état actuel | Mise à jour concurrente |
| 410 | Gone | Ressource supprimée définitivement | API dépréciée |
| 411 | Length Required | Content-Length requis | Upload |
| 412 | Precondition Failed | Précondition non satisfaite | Conditional requests |
| 413 | Payload Too Large | Corps de requête trop volumineux | Limite de taille |
| 414 | URI Too Long | URI trop longue | Query string excessive |
| 415 | Unsupported Media Type | Type de contenu non supporté | Envoi de XML à une API JSON-only |
| 418 | I'm a Teapot | Blague RFC 2324 ☕ | Easter egg |
| **422** | **Unprocessable Entity** | **Syntaxe correcte mais sémantique invalide** | **Validation Pydantic FastAPI** |
| 429 | Too Many Requests | Trop de requêtes (rate limiting) | Limitation de débit |
| 451 | Unavailable For Legal Reasons | Contenu censuré/bloqué | RGPD, droits d'auteur |

**Erreurs courantes dans notre API Iris :**

```python
# 422 — Validation Pydantic échouée
response = requests.post("http://localhost:8000/predict", json={
    "sepal_length": -5.0,  # ❌ ge=0 violé
    "sepal_width": 3.5,
    "petal_length": 1.4,
    "petal_width": 0.2
})
print(response.status_code)  # 422 Unprocessable Entity

# 503 — Modèle non chargé
# Si le modèle n'est pas chargé, FastAPI lève HTTPException(status_code=503)
```

#### 5xx — Erreur serveur

| Code | Nom | Description | Usage |
|------|-----|-------------|-------|
| **500** | **Internal Server Error** | **Erreur inattendue du serveur** | **Bug non géré, exception** |
| 501 | Not Implemented | Fonctionnalité non implémentée | Méthode non supportée |
| **502** | **Bad Gateway** | **Réponse invalide d'un serveur en amont** | **Proxy/reverse-proxy** |
| **503** | **Service Unavailable** | **Service temporairement indisponible** | **Maintenance, surcharge** |
| **504** | **Gateway Timeout** | **Timeout d'un serveur en amont** | **API trop lente** |
| 505 | HTTP Version Not Supported | Version HTTP non supportée | Très rare |
| 507 | Insufficient Storage | Stockage insuffisant (WebDAV) | Disque plein |
| 508 | Loop Detected | Boucle infinie détectée (WebDAV) | Configuration récursive |
| 511 | Network Authentication Required | Authentification réseau requise | Portail captif Wi-Fi |

**Résumé visuel :**

```mermaid
pie title Répartition typique des codes de statut dans une API saine
    "2xx Succès" : 85
    "3xx Redirection" : 3
    "4xx Erreur client" : 10
    "5xx Erreur serveur" : 2
```

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-6"></a>

<details>
<summary><strong>6 — Les formats de données</strong></summary>

### 6.1 JSON (JavaScript Object Notation)

**JSON** est le format de données le plus utilisé dans les APIs REST modernes. Inventé par Douglas Crockford, il est léger, lisible et universel.

**Types de données JSON :**

| Type | Description | Exemple |
|------|-------------|---------|
| `string` | Chaîne de caractères (UTF-8) | `"setosa"` |
| `number` | Nombre entier ou décimal | `5.1`, `42`, `-3.14` |
| `boolean` | Valeur booléenne | `true`, `false` |
| `null` | Valeur nulle | `null` |
| `object` | Collection clé-valeur (dictionnaire) | `{"key": "value"}` |
| `array` | Liste ordonnée | `[1, 2, 3]` |

**Exemple complet — Réponse de notre API Iris :**

```json
{
  "species": "setosa",
  "confidence": 1.0,
  "probabilities": {
    "setosa": 1.0,
    "versicolor": 0.0,
    "virginica": 0.0
  }
}
```

**Manipulation en Python :**

```python
import json

# Python dict → JSON string
data = {"species": "setosa", "confidence": 1.0}
json_str = json.dumps(data, indent=2, ensure_ascii=False)
print(json_str)

# JSON string → Python dict
parsed = json.loads(json_str)
print(parsed["species"])  # "setosa"

# Fichier JSON
with open("data.json", "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

with open("data.json", "r", encoding="utf-8") as f:
    loaded = json.load(f)
```

**Correspondance types Python ↔ JSON :**

| Python | JSON |
|--------|------|
| `dict` | `object {}` |
| `list`, `tuple` | `array []` |
| `str` | `string ""` |
| `int`, `float` | `number` |
| `True` / `False` | `true` / `false` |
| `None` | `null` |

### 6.2 XML (eXtensible Markup Language)

**XML** est un format de balisage structuré plus ancien, encore utilisé dans les systèmes d'entreprise et SOAP.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<prediction>
  <species>setosa</species>
  <confidence>1.0</confidence>
  <probabilities>
    <probability species="setosa">1.0</probability>
    <probability species="versicolor">0.0</probability>
    <probability species="virginica">0.0</probability>
  </probabilities>
</prediction>
```

**Caractéristiques :**
- Utilise des balises ouvrantes/fermantes : `<tag>...</tag>`
- Supporte les attributs : `<tag attribut="valeur">`
- Supporte les espaces de noms (namespaces) pour éviter les conflits
- Possède un système de validation par schéma (XSD, DTD)
- Plus verbeux que JSON

**Manipulation en Python :**

```python
import xml.etree.ElementTree as ET

xml_str = """<?xml version="1.0"?>
<prediction>
  <species>setosa</species>
  <confidence>1.0</confidence>
</prediction>"""

root = ET.fromstring(xml_str)
species = root.find("species").text       # "setosa"
confidence = root.find("confidence").text  # "1.0"
```

### 6.3 YAML (YAML Ain't Markup Language)

**YAML** est un format de sérialisation lisible par l'humain, populaire pour les fichiers de configuration.

```yaml
prediction:
  species: setosa
  confidence: 1.0
  probabilities:
    setosa: 1.0
    versicolor: 0.0
    virginica: 0.0
```

**Caractéristiques :**
- Basé sur l'indentation (comme Python)
- Très lisible pour l'humain
- Supporte les commentaires (`#`)
- Supporte les types de données complexes (dates, binaire, références)
- Utilisé pour : Docker Compose, Kubernetes, GitHub Actions, Ansible

**Manipulation en Python :**

```python
import yaml

data = {
    "species": "setosa",
    "confidence": 1.0,
    "probabilities": {"setosa": 1.0, "versicolor": 0.0, "virginica": 0.0}
}

yaml_str = yaml.dump(data, default_flow_style=False, allow_unicode=True)
print(yaml_str)

parsed = yaml.safe_load(yaml_str)
print(parsed["species"])  # "setosa"
```

### 6.4 Comparaison JSON vs XML vs YAML

| Critère | JSON | XML | YAML |
|---------|------|-----|------|
| **Lisibilité humaine** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| **Verbosité** | Faible | Élevée | Très faible |
| **Parsing** | Très rapide | Lent | Moyen |
| **Commentaires** | ❌ Non | ❌ Non (hors processing instructions) | ✅ Oui |
| **Schéma de validation** | JSON Schema | XSD, DTD, RELAX NG | Pas de standard |
| **Types natifs** | string, number, bool, null, object, array | Tout est texte | string, int, float, bool, null, date |
| **Usage API** | ⭐⭐⭐⭐⭐ Standard | ⭐⭐ Legacy / Entreprise | ⭐ Rare pour les APIs |
| **Usage config** | ⭐⭐ | ⭐ | ⭐⭐⭐⭐⭐ Standard |
| **Taille (même donnée)** | 100% (référence) | ~170% | ~80% |
| **Support navigateur** | Natif (`JSON.parse`) | Natif (DOM parser) | Bibliothèque requise |
| **Content-Type** | `application/json` | `application/xml` | `application/yaml` |

**Exemple comparatif — même donnée :**

**JSON (58 caractères) :**
```json
{"species":"setosa","confidence":1.0,"count":150}
```

**XML (120 caractères) :**
```xml
<data><species>setosa</species><confidence>1.0</confidence><count>150</count></data>
```

**YAML (47 caractères) :**
```yaml
species: setosa
confidence: 1.0
count: 150
```

> **Conclusion** : JSON est le format standard pour les APIs REST. XML persiste dans les systèmes legacy. YAML est le roi de la configuration.

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-7"></a>

<details>
<summary><strong>7 — Consommer une API avec Python <code>requests</code> (SECTION PRINCIPALE)</strong></summary>

La bibliothèque **`requests`** est la bibliothèque HTTP la plus populaire en Python. Elle offre une API élégante et intuitive pour effectuer des requêtes HTTP.

> **Pourquoi `requests` ?** C'est la bibliothèque utilisée par Streamlit, FastAPI (client de test), et la grande majorité des projets Python. C'est la compétence fondamentale pour consommer des APIs en Python.

### 7.1 Installation et import

```bash
pip install requests
```

```python
import requests
```

**Vérification de la version :**

```python
import requests
print(requests.__version__)  # 2.31.0 ou plus récent
```

### 7.2 Requête GET — Lire des données

#### GET simple

```python
import requests

response = requests.get("http://localhost:8000/health")

print(response.status_code)    # 200
print(response.headers)        # Headers de réponse
print(response.text)           # Corps brut (string)
print(response.json())         # Corps parsé en dict Python
print(response.url)            # URL finale (après redirections)
print(response.elapsed)        # Temps de réponse
print(response.encoding)       # Encodage détecté
print(response.ok)             # True si status_code < 400
```

#### GET avec paramètres de requête (query params)

```python
params = {
    "n": 5,
    "species": "setosa",
    "sort": "sepal_length"
}
response = requests.get(
    "http://localhost:8000/dataset/samples",
    params=params
)
# URL générée : http://localhost:8000/dataset/samples?n=5&species=setosa&sort=sepal_length
print(response.url)
```

#### GET avec headers personnalisés

```python
headers = {
    "Accept": "application/json",
    "Accept-Language": "fr-FR",
    "X-Request-ID": "abc-123-def"
}
response = requests.get(
    "http://localhost:8000/model/info",
    headers=headers
)
```

#### Exemple complet — Informations du modèle Iris

```python
import requests

def get_model_info():
    """Récupère les informations du modèle ML depuis l'API."""
    url = "http://localhost:8000/model/info"
    
    try:
        response = requests.get(url, timeout=5)
        response.raise_for_status()
        
        info = response.json()
        
        print(f"Type de modèle : {info['model_type']}")
        print(f"Précision      : {info['accuracy'] * 100:.1f}%")
        print(f"Features       : {', '.join(info['feature_names'])}")
        print(f"Classes        : {', '.join(info['target_names'])}")
        print(f"Échantillons   : {info['training_samples']} train / {info['test_samples']} test")
        
        print("\nImportance des features :")
        for feat, imp in sorted(info['feature_importances'].items(), 
                                 key=lambda x: x[1], reverse=True):
            bar = "█" * int(imp * 40)
            print(f"  {feat:25s} {imp*100:5.1f}% {bar}")
        
        return info
        
    except requests.exceptions.ConnectionError:
        print("❌ Impossible de se connecter à l'API. Est-elle démarrée ?")
    except requests.exceptions.Timeout:
        print("⏱️ La requête a expiré (timeout de 5 secondes)")
    except requests.exceptions.HTTPError as e:
        print(f"❌ Erreur HTTP : {e.response.status_code} — {e.response.text}")
    except Exception as e:
        print(f"❌ Erreur inattendue : {e}")

get_model_info()
```

### 7.3 Requête POST — Envoyer des données

#### POST avec JSON

```python
import requests

payload = {
    "sepal_length": 5.1,
    "sepal_width": 3.5,
    "petal_length": 1.4,
    "petal_width": 0.2
}

response = requests.post(
    "http://localhost:8000/predict",
    json=payload  # ← Sérialise automatiquement en JSON + set Content-Type
)

print(response.status_code)  # 200
result = response.json()
print(f"Espèce    : {result['species']}")
print(f"Confiance : {result['confidence'] * 100:.1f}%")
for species, prob in result['probabilities'].items():
    print(f"  {species}: {prob * 100:.1f}%")
```

> **`json=`** vs **`data=`** : Utilisez `json=` pour envoyer du JSON (ajoute automatiquement `Content-Type: application/json`). Utilisez `data=` pour du form-encoded.

#### POST avec form data (application/x-www-form-urlencoded)

```python
response = requests.post(
    "https://example.com/login",
    data={
        "username": "admin",
        "password": "secret"
    }
)
# Content-Type: application/x-www-form-urlencoded
# Body: username=admin&password=secret
```

#### POST avec upload de fichier (multipart/form-data)

```python
with open("data.csv", "rb") as f:
    response = requests.post(
        "https://example.com/upload",
        files={"file": ("data.csv", f, "text/csv")},
        data={"description": "Mon fichier CSV"}
    )
# Content-Type: multipart/form-data; boundary=...
```

#### POST avec données brutes

```python
import json

payload = json.dumps({"sepal_length": 5.1, "sepal_width": 3.5})
response = requests.post(
    "http://localhost:8000/predict",
    data=payload,
    headers={"Content-Type": "application/json"}
)
```

### 7.4 Requêtes PUT et PATCH — Mettre à jour

#### PUT — Remplacement complet

```python
updated_resource = {
    "id": 42,
    "model_type": "GradientBoosting",
    "n_estimators": 200,
    "max_depth": 5,
    "learning_rate": 0.1,
    "features": ["sepal_length", "sepal_width", "petal_length", "petal_width"]
}

response = requests.put(
    "https://api.example.com/models/42",
    json=updated_resource
)
print(response.status_code)  # 200 OK ou 204 No Content
```

#### PATCH — Modification partielle

```python
partial_update = {
    "n_estimators": 300  # Modifie uniquement ce champ
}

response = requests.patch(
    "https://api.example.com/models/42",
    json=partial_update
)
print(response.status_code)  # 200 OK
```

**Différence PUT vs PATCH illustrée :**

```
Ressource actuelle :
{"id": 42, "name": "RF", "accuracy": 0.95, "active": true}

PUT {"id": 42, "name": "GB"} →
Résultat : {"id": 42, "name": "GB"}  ← accuracy et active SUPPRIMÉS

PATCH {"name": "GB"} →
Résultat : {"id": 42, "name": "GB", "accuracy": 0.95, "active": true}  ← Intacts
```

### 7.5 Requête DELETE — Supprimer

```python
response = requests.delete("https://api.example.com/models/42")

if response.status_code == 204:
    print("Ressource supprimée avec succès (pas de contenu)")
elif response.status_code == 200:
    print("Supprimé :", response.json())
elif response.status_code == 404:
    print("Ressource introuvable")
```

**DELETE avec confirmation (body) :**

```python
response = requests.delete(
    "https://api.example.com/models/42",
    json={"confirm": True, "reason": "Modèle obsolète"}
)
```

### 7.6 Headers personnalisés

```python
headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIs...",
    "X-API-Key": "sk-abc123def456",
    "X-Request-ID": "req-550e8400-e29b",
    "User-Agent": "IrisApp/1.0 Python/3.11",
    "Accept-Language": "fr-FR",
    "Cache-Control": "no-cache"
}

response = requests.get(
    "http://localhost:8000/model/info",
    headers=headers
)

# Lire les headers de réponse
print(response.headers["Content-Type"])     # application/json
print(response.headers.get("X-Response-Time"))  # None si absent (pas d'erreur)
```

### 7.7 Authentification

#### Basic Auth (nom d'utilisateur + mot de passe)

```python
from requests.auth import HTTPBasicAuth

response = requests.get(
    "https://api.example.com/protected",
    auth=HTTPBasicAuth("username", "password")
)
# Raccourci :
response = requests.get(
    "https://api.example.com/protected",
    auth=("username", "password")
)
# Header envoyé : Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=
```

#### Bearer Token (JWT)

```python
token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

response = requests.get(
    "https://api.example.com/protected",
    headers={"Authorization": f"Bearer {token}"}
)
```

#### API Key (dans le header)

```python
response = requests.get(
    "https://api.example.com/data",
    headers={"X-API-Key": "sk-abc123def456ghi789"}
)
```

#### API Key (dans les paramètres de requête)

```python
response = requests.get(
    "https://api.example.com/data",
    params={"api_key": "sk-abc123def456ghi789"}
)
# URL : https://api.example.com/data?api_key=sk-abc123def456ghi789
```

#### Digest Auth

```python
from requests.auth import HTTPDigestAuth

response = requests.get(
    "https://api.example.com/protected",
    auth=HTTPDigestAuth("username", "password")
)
```

### 7.8 Gestion des erreurs

#### Méthode 1 : `raise_for_status()` (recommandée)

```python
import requests

try:
    response = requests.post(
        "http://localhost:8000/predict",
        json={"sepal_length": 5.1, "sepal_width": 3.5,
              "petal_length": 1.4, "petal_width": 0.2},
        timeout=5
    )
    response.raise_for_status()  # Lève HTTPError si status >= 400
    result = response.json()
    print(f"Espèce : {result['species']}")

except requests.exceptions.ConnectionError:
    print("❌ Connexion impossible — le serveur est-il démarré ?")
except requests.exceptions.Timeout:
    print("⏱️ Requête expirée — le serveur met trop de temps")
except requests.exceptions.HTTPError as e:
    status = e.response.status_code
    if status == 422:
        detail = e.response.json().get("detail", [])
        print(f"❌ Validation échouée : {detail}")
    elif status == 503:
        print("❌ Service indisponible — modèle non chargé")
    else:
        print(f"❌ Erreur HTTP {status} : {e.response.text}")
except requests.exceptions.RequestException as e:
    print(f"❌ Erreur réseau : {e}")
except ValueError:
    print("❌ Réponse non-JSON")
```

#### Méthode 2 : Vérification manuelle du status_code

```python
response = requests.get("http://localhost:8000/health", timeout=3)

if response.ok:  # True si status_code < 400
    data = response.json()
    print("API en bonne santé :", data["status"])
elif response.status_code == 404:
    print("Endpoint introuvable")
elif response.status_code >= 500:
    print("Erreur serveur :", response.text)
else:
    print(f"Erreur {response.status_code} : {response.text}")
```

#### Hiérarchie des exceptions requests

```mermaid
graph TD
    A[requests.exceptions.RequestException] --> B[ConnectionError]
    A --> C[HTTPError]
    A --> D[URLRequired]
    A --> E[TooManyRedirects]
    A --> F[Timeout]
    F --> G[ConnectTimeout]
    F --> H[ReadTimeout]
    B --> I[ProxyError]
    B --> J[SSLError]
    C --> K[Levée par raise_for_status]
    
    style A fill:#ffcdd2
    style F fill:#fff9c4
    style B fill:#fff9c4
    style C fill:#fff9c4
```

| Exception | Cause | Solution |
|-----------|-------|----------|
| `ConnectionError` | Serveur injoignable | Vérifier que le serveur est démarré |
| `Timeout` | Pas de réponse dans le délai | Augmenter le timeout ou vérifier le serveur |
| `ConnectTimeout` | Connexion TCP échouée | Vérifier host:port |
| `ReadTimeout` | Données pas reçues à temps | Le serveur est lent, augmenter timeout |
| `HTTPError` | Code de statut ≥ 400 | Vérifier la requête, les paramètres |
| `TooManyRedirects` | Boucle de redirection | Vérifier les URLs |
| `SSLError` | Certificat SSL invalide | Vérifier le certificat ou `verify=False` |
| `ProxyError` | Proxy inaccessible | Vérifier la configuration proxy |

### 7.9 Sessions et timeout

#### Sessions — Connexion persistante

Une `Session` réutilise la connexion TCP sous-jacente, ce qui améliore les performances quand on fait plusieurs requêtes vers le même serveur.

```python
import requests

session = requests.Session()

# Configuration globale de la session
session.headers.update({
    "Accept": "application/json",
    "User-Agent": "IrisApp/1.0"
})
session.timeout = 5

# Toutes les requêtes réutilisent la même connexion TCP
health = session.get("http://localhost:8000/health")
info = session.get("http://localhost:8000/model/info")
stats = session.get("http://localhost:8000/dataset/stats")

# La session garde aussi les cookies
session.cookies.set("session_id", "abc123")

# Fermer proprement
session.close()

# Ou avec un context manager
with requests.Session() as s:
    s.headers["Authorization"] = "Bearer token123"
    r = s.get("http://localhost:8000/model/info")
    print(r.json())
```

**Avantages de Session :**

| Sans Session | Avec Session |
|-------------|-------------|
| Nouvelle connexion TCP à chaque requête | Connexion TCP réutilisée (keep-alive) |
| Headers à répéter à chaque requête | Headers configurés une seule fois |
| Pas de persistance de cookies | Cookies conservés automatiquement |
| Plus lent pour les requêtes multiples | Plus rapide pour les requêtes multiples |

#### Timeout — Éviter les requêtes infinies

```python
# Timeout unique (connect + read)
response = requests.get("http://localhost:8000/health", timeout=5)

# Timeout séparé : (connect_timeout, read_timeout)
response = requests.get("http://localhost:8000/predict", timeout=(3, 10))
# 3 secondes max pour la connexion, 10 secondes max pour la lecture

# Sans timeout (DANGEREUX — peut bloquer indéfiniment)
response = requests.get("http://localhost:8000/health")  # ⚠️ Pas de timeout
```

> **Bonne pratique** : Toujours spécifier un `timeout`. Sans timeout, votre application peut rester bloquée indéfiniment si le serveur ne répond pas.

#### Retries — Réessayer automatiquement

```python
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

session = requests.Session()

retry_strategy = Retry(
    total=3,                    # 3 tentatives maximum
    backoff_factor=1,           # Attente exponentielle : 1s, 2s, 4s
    status_forcelist=[500, 502, 503, 504],  # Réessayer sur ces codes
    allowed_methods=["GET", "POST"]
)

adapter = HTTPAdapter(max_retries=retry_strategy)
session.mount("http://", adapter)
session.mount("https://", adapter)

response = session.get("http://localhost:8000/health", timeout=5)
```

#### Récapitulatif complet — Fonction utilitaire robuste

```python
import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

def create_api_client(base_url: str, timeout: int = 5) -> requests.Session:
    """Crée un client API robuste avec retry et timeout."""
    session = requests.Session()
    
    retry = Retry(total=3, backoff_factor=0.5,
                  status_forcelist=[500, 502, 503, 504])
    adapter = HTTPAdapter(max_retries=retry)
    session.mount("http://", adapter)
    session.mount("https://", adapter)
    
    session.headers.update({
        "Accept": "application/json",
        "User-Agent": "IrisApp/1.0"
    })
    session.timeout = timeout
    
    return session

client = create_api_client("http://localhost:8000")
response = client.get("http://localhost:8000/health")
print(response.json())
```

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-8"></a>

<details>
<summary><strong>8 — Consommer une API dans Streamlit</strong></summary>

### 8.1 Architecture Streamlit + API REST

Streamlit utilise la bibliothèque `requests` de Python pour consommer des APIs REST. La différence avec un script Python classique est que Streamlit **ré-exécute tout le script à chaque interaction utilisateur** (chaque clic, chaque modification de slider).

```mermaid
flowchart LR
    subgraph "Frontend Streamlit (port 8501)"
        A[Sliders<br>st.slider] --> B[Bouton<br>st.button]
        B --> C[requests.post]
        G[st.metric] --> H[st.progress]
        H --> I[st.dataframe]
    end
    
    subgraph "Backend FastAPI (port 8000)"
        D[Validation<br>Pydantic] --> E[Prédiction<br>model.predict]
        E --> F[Réponse JSON]
    end
    
    C -->|HTTP POST /predict<br>JSON payload| D
    F -->|HTTP 200 OK<br>JSON response| G
    
    style A fill:#ff7043,color:#fff
    style B fill:#ff7043,color:#fff
    style G fill:#66bb6a,color:#fff
    style H fill:#66bb6a,color:#fff
    style I fill:#66bb6a,color:#fff
    style D fill:#42a5f5,color:#fff
    style E fill:#42a5f5,color:#fff
    style F fill:#42a5f5,color:#fff
```

**Modèle d'exécution de Streamlit :**

```mermaid
flowchart TD
    A[Utilisateur modifie un slider] --> B[Streamlit ré-exécute TOUT app.py]
    B --> C{Interaction détectée ?}
    C -->|Bouton cliqué| D[Appel requests vers API]
    C -->|Autre widget| E[Mise à jour de l'interface]
    D --> F[Affichage du résultat]
    F --> G[Attente prochaine interaction]
    E --> G
```

### 8.2 Vérification de la connexion API

Voici le code de notre application `frontend-streamlit/app.py` pour vérifier que l'API est accessible :

```python
import requests

API_BASE_URL = "http://localhost:8000"

def check_api():
    """Vérifie que l'API FastAPI est accessible."""
    try:
        r = requests.get(f"{API_BASE_URL}/health", timeout=3)
        return r.status_code == 200 and r.json().get("status") == "healthy"
    except Exception:
        return False
```

**Utilisation dans Streamlit :**

```python
import streamlit as st

with st.sidebar:
    api_ok = check_api()
    if api_ok:
        st.success("✅ API connectée")
    else:
        st.error("❌ API hors ligne — Lancez le backend FastAPI sur le port 8000")
```

**Points clés :**
- `timeout=3` : Évite de bloquer l'interface si l'API est hors ligne
- `try/except Exception` : Capture toutes les erreurs (connexion refusée, timeout, DNS…)
- Vérification du contenu de la réponse (pas seulement le status code)

### 8.3 Appeler `requests` dans Streamlit

#### Pattern 1 : Fonction d'appel API + st.spinner

```python
def predict(sepal_length, sepal_width, petal_length, petal_width):
    """Envoie une requête de prédiction à l'API."""
    payload = {
        "sepal_length": sepal_length,
        "sepal_width": sepal_width,
        "petal_length": petal_length,
        "petal_width": petal_width,
    }
    r = requests.post(f"{API_BASE_URL}/predict", json=payload)
    r.raise_for_status()
    return r.json()
```

**Utilisation avec `st.spinner` et `st.button` :**

```python
# Sliders pour les mesures de la fleur
col1, col2 = st.columns(2)

with col1:
    st.subheader("Sépales")
    sepal_length = st.slider("Longueur du sépale (cm)", 4.0, 8.0, 5.1, 0.1)
    sepal_width = st.slider("Largeur du sépale (cm)", 2.0, 4.5, 3.5, 0.1)

with col2:
    st.subheader("Pétales")
    petal_length = st.slider("Longueur du pétale (cm)", 1.0, 7.0, 1.4, 0.1)
    petal_width = st.slider("Largeur du pétale (cm)", 0.1, 2.5, 0.2, 0.1)

# Bouton de prédiction
if st.button("🔮 Prédire l'espèce", type="primary", use_container_width=True):
    if not api_ok:
        st.error("L'API n'est pas accessible. Lancez d'abord le backend.")
    else:
        with st.spinner("Prédiction en cours..."):
            try:
                result = predict(sepal_length, sepal_width, petal_length, petal_width)
                species = result["species"]
                confidence = result["confidence"]
                probabilities = result["probabilities"]

                # Affichage des résultats (voir section suivante)
                st.success(f"Espèce prédite : {species} ({confidence*100:.1f}%)")

            except requests.exceptions.ConnectionError:
                st.error("❌ Connexion impossible à l'API")
            except requests.exceptions.HTTPError as e:
                st.error(f"❌ Erreur API : {e.response.status_code}")
            except Exception as e:
                st.error(f"❌ Erreur : {e}")
```

#### Pattern 2 : Fonctions utilitaires pour chaque endpoint

```python
def get_model_info():
    """Récupère les informations du modèle."""
    r = requests.get(f"{API_BASE_URL}/model/info")
    r.raise_for_status()
    return r.json()

def get_dataset_samples():
    """Récupère des échantillons aléatoires du dataset."""
    r = requests.get(f"{API_BASE_URL}/dataset/samples")
    r.raise_for_status()
    return r.json()

def get_dataset_stats():
    """Récupère les statistiques du dataset."""
    r = requests.get(f"{API_BASE_URL}/dataset/stats")
    r.raise_for_status()
    return r.json()
```

#### Pattern 3 : Cache avec `@st.cache_data`

Pour les données qui ne changent pas souvent, on peut mettre en cache les résultats :

```python
@st.cache_data(ttl=60)  # Cache pendant 60 secondes
def get_model_info_cached():
    """Récupère et cache les informations du modèle."""
    r = requests.get(f"{API_BASE_URL}/model/info", timeout=5)
    r.raise_for_status()
    return r.json()

@st.cache_data(ttl=300)  # Cache pendant 5 minutes
def get_dataset_stats_cached():
    """Récupère et cache les statistiques du dataset."""
    r = requests.get(f"{API_BASE_URL}/dataset/stats", timeout=5)
    r.raise_for_status()
    return r.json()
```

> **Attention** : Ne mettez **pas** en cache les prédictions, car le résultat dépend des paramètres d'entrée qui changent à chaque interaction.

### 8.4 Afficher les résultats de l'API dans Streamlit

#### `st.metric` — Afficher des métriques clés

```python
info = get_model_info()

col1, col2, col3 = st.columns(3)
with col1:
    st.metric("Type de modèle", info["model_type"].replace("Classifier", ""))
with col2:
    st.metric("Précision", f"{info['accuracy']*100:.1f}%")
with col3:
    st.metric(
        "Données",
        f"{info['training_samples'] + info['test_samples']} total",
        f"{info['training_samples']} train / {info['test_samples']} test",
    )
```

#### `st.progress` — Barres de progression pour les probabilités

```python
result = predict(5.1, 3.5, 1.4, 0.2)

st.subheader("Probabilités par espèce")
for name, prob in result["probabilities"].items():
    st.markdown(f"**{name}** — `{prob*100:.1f}%`")
    st.progress(prob)  # Barre de progression 0.0 → 1.0
```

#### `st.dataframe` — Tableau interactif de données

```python
import pandas as pd

samples = get_dataset_samples()
df = pd.DataFrame(samples)
df.columns = ["Sép. Longueur", "Sép. Largeur", "Pét. Longueur", "Pét. Largeur", "Espèce"]

st.dataframe(df, use_container_width=True, hide_index=True)
```

#### `st.json` — Afficher du JSON brut (debugging)

```python
result = predict(5.1, 3.5, 1.4, 0.2)
st.json(result)  # Affiche le JSON formaté et coloré
```

#### `st.success`, `st.error`, `st.warning`, `st.info` — Messages

```python
if result["confidence"] > 0.9:
    st.success(f"✅ Prédiction fiable : {result['species']} ({result['confidence']*100:.1f}%)")
elif result["confidence"] > 0.6:
    st.warning(f"⚠️ Prédiction incertaine : {result['species']} ({result['confidence']*100:.1f}%)")
else:
    st.error(f"❌ Prédiction peu fiable : {result['species']} ({result['confidence']*100:.1f}%)")
```

#### Résumé des widgets Streamlit pour l'affichage API

| Widget | Usage | Exemple |
|--------|-------|---------|
| `st.metric` | Valeur numérique avec label et delta | Précision du modèle |
| `st.progress` | Barre de progression (0.0–1.0) | Probabilités de prédiction |
| `st.dataframe` | Tableau interactif pandas | Échantillons du dataset |
| `st.json` | JSON formaté et coloré | Réponse brute de l'API |
| `st.spinner` | Indicateur de chargement pendant une opération | Pendant l'appel API |
| `st.success` | Message de succès vert | Prédiction réussie |
| `st.error` | Message d'erreur rouge | API hors ligne |
| `st.warning` | Message d'avertissement jaune | Confiance faible |
| `st.info` | Message informatif bleu | Instructions |
| `st.toast` | Notification temporaire | "Prédiction terminée" |
| `st.balloons` | Animation de ballons | Célébration |
| `st.columns` | Disposition en colonnes | Résultats côte à côte |
| `st.expander` | Section dépliable | Détails avancés |
| `st.tabs` | Onglets | Différentes vues |

### 8.5 Code complet annoté de notre `app.py`

Voici le flux complet de notre application Streamlit qui consomme l'API FastAPI :

```python
import streamlit as st
import requests

API_BASE_URL = "http://localhost:8000"

# ─── 1. Configuration de la page ─────────────────────────────────
st.set_page_config(page_title="Iris ML Demo", page_icon="🌸", layout="wide")

# ─── 2. Fonctions d'appel API ────────────────────────────────────
def check_api():
    try:
        r = requests.get(f"{API_BASE_URL}/health", timeout=3)
        return r.status_code == 200 and r.json().get("status") == "healthy"
    except Exception:
        return False

def predict(sl, sw, pl, pw):
    r = requests.post(f"{API_BASE_URL}/predict",
                      json={"sepal_length": sl, "sepal_width": sw,
                            "petal_length": pl, "petal_width": pw})
    r.raise_for_status()
    return r.json()

# ─── 3. Sidebar — Vérification API + Navigation ─────────────────
with st.sidebar:
    api_ok = check_api()
    if api_ok:
        st.success("✅ API connectée")
    else:
        st.error("❌ API hors ligne")

# ─── 4. Sliders → Collecte des données ──────────────────────────
sepal_length = st.slider("Longueur sépale", 4.0, 8.0, 5.1, 0.1)

# ─── 5. Bouton → Appel API avec spinner ─────────────────────────
if st.button("Prédire"):
    with st.spinner("Prédiction en cours..."):
        try:
            result = predict(sepal_length, 3.5, 1.4, 0.2)
            
            # ─── 6. Affichage des résultats ──────────────────────
            st.metric("Espèce", result["species"])
            
            for name, prob in result["probabilities"].items():
                st.progress(prob)
                
        except Exception as e:
            st.error(f"Erreur : {e}")
```

```mermaid
flowchart TD
    A["1. st.set_page_config()"] --> B["2. Définir check_api(), predict()"]
    B --> C["3. Sidebar : check_api() → requests.get(/health)"]
    C --> D["4. st.slider() → Collecte des valeurs"]
    D --> E["5. st.button() cliqué ?"]
    E -->|Oui| F["st.spinner() → predict() → requests.post(/predict)"]
    E -->|Non| G["Attente interaction"]
    F --> H["6. st.metric() + st.progress() → Affichage"]
    H --> G
    
    style F fill:#42a5f5,color:#fff
    style H fill:#66bb6a,color:#fff
```

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-9"></a>

<details>
<summary><strong>9 — Consommer une API avec JavaScript</strong></summary>

Bien que notre application utilise Python/Streamlit, il est utile de connaître la consommation d'API en JavaScript (pour les frontends web classiques comme React, Vue, Angular).

### 9.1 Fetch API (natif)

L'API `fetch` est intégrée dans tous les navigateurs modernes et Node.js 18+.

#### GET

```javascript
// GET simple
const response = await fetch("http://localhost:8000/health");
const data = await response.json();
console.log(data.status); // "healthy"

// GET avec gestion d'erreurs
async function getModelInfo() {
  try {
    const response = await fetch("http://localhost:8000/model/info");
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }
    return await response.json();
  } catch (error) {
    console.error("Erreur:", error.message);
  }
}
```

#### POST

```javascript
async function predict(sepalLength, sepalWidth, petalLength, petalWidth) {
  const response = await fetch("http://localhost:8000/predict", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      sepal_length: sepalLength,
      sepal_width: sepalWidth,
      petal_length: petalLength,
      petal_width: petalWidth,
    }),
  });

  if (!response.ok) {
    throw new Error(`Erreur ${response.status}`);
  }
  return await response.json();
}

const result = await predict(5.1, 3.5, 1.4, 0.2);
console.log(result.species);     // "setosa"
console.log(result.confidence);  // 1.0
```

### 9.2 Axios (bibliothèque populaire)

```bash
npm install axios
```

#### GET

```javascript
import axios from "axios";

const API_BASE = "http://localhost:8000";

// GET simple
const { data } = await axios.get(`${API_BASE}/health`);
console.log(data.status); // "healthy"

// GET avec configuration
const response = await axios.get(`${API_BASE}/model/info`, {
  timeout: 5000,
  headers: { Accept: "application/json" },
});
console.log(response.data);
console.log(response.status);   // 200
console.log(response.headers);
```

#### POST

```javascript
async function predict(measurements) {
  try {
    const { data } = await axios.post(`${API_BASE}/predict`, {
      sepal_length: measurements.sl,
      sepal_width: measurements.sw,
      petal_length: measurements.pl,
      petal_width: measurements.pw,
    });
    return data;
  } catch (error) {
    if (error.response) {
      console.error(`Erreur ${error.response.status}:`, error.response.data);
    } else if (error.request) {
      console.error("Pas de réponse du serveur");
    } else {
      console.error("Erreur:", error.message);
    }
  }
}
```

### 9.3 Fetch vs Axios — Comparaison

| Critère | Fetch (natif) | Axios |
|---------|--------------|-------|
| Installation | Aucune (natif) | `npm install axios` |
| JSON automatique | Non (`.json()` requis) | Oui (automatique) |
| Interception de requêtes | Non | Oui (intercepteurs) |
| Annulation de requête | `AbortController` | `CancelToken` / `AbortController` |
| Timeout | Non natif | Natif (`timeout: 5000`) |
| Gestion d'erreurs | Erreur réseau uniquement | Erreur réseau + HTTP |
| Upload progress | Non | Oui (`onUploadProgress`) |
| Support navigateur | Navigateurs modernes | Tous (avec polyfill) |
| Taille | 0 Ko (natif) | ~13 Ko |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-10"></a>

<details>
<summary><strong>10 — Consommer une API avec curl et Postman</strong></summary>

### 10.1 curl — Outil en ligne de commande

**curl** (*Client URL*) est un outil en ligne de commande pour transférer des données via HTTP et d'autres protocoles. Présent par défaut sur Linux, macOS et Windows 10+.

#### GET

```bash
# GET simple
curl http://localhost:8000/health

# GET avec headers de sortie
curl -i http://localhost:8000/health

# GET uniquement les headers
curl -I http://localhost:8000/health

# GET avec formatage JSON (nécessite jq)
curl -s http://localhost:8000/model/info | jq .

# GET verbose (debug)
curl -v http://localhost:8000/health
```

#### POST

```bash
# POST avec JSON
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}'

# POST depuis un fichier JSON
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d @request.json

# POST avec sortie formatée
curl -s -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}' \
  | jq .
```

#### PUT, PATCH, DELETE

```bash
# PUT
curl -X PUT http://localhost:8000/model/config \
  -H "Content-Type: application/json" \
  -d '{"n_estimators": 200}'

# PATCH
curl -X PATCH http://localhost:8000/model/config \
  -H "Content-Type: application/json" \
  -d '{"n_estimators": 300}'

# DELETE
curl -X DELETE http://localhost:8000/cache/predictions
```

#### Options curl courantes

| Option | Raccourci | Description |
|--------|-----------|-------------|
| `--request` | `-X` | Méthode HTTP |
| `--header` | `-H` | Ajouter un header |
| `--data` | `-d` | Données du corps (implique POST) |
| `--include` | `-i` | Afficher les headers de réponse |
| `--head` | `-I` | Requête HEAD uniquement |
| `--verbose` | `-v` | Mode verbose (debug) |
| `--silent` | `-s` | Mode silencieux (pas de barre de progression) |
| `--output` | `-o` | Sauvegarder dans un fichier |
| `--user` | `-u` | Authentification Basic (`user:pass`) |
| `--cookie` | `-b` | Envoyer un cookie |
| `--location` | `-L` | Suivre les redirections |
| `--max-time` | `-m` | Timeout en secondes |
| `--insecure` | `-k` | Ignorer les erreurs SSL |

### 10.2 Postman — Interface graphique

**Postman** est l'outil GUI le plus populaire pour tester les APIs REST.

#### Fonctionnalités principales

| Fonctionnalité | Description |
|----------------|-------------|
| **Collections** | Organiser les requêtes en dossiers |
| **Environnements** | Variables (`{{base_url}}`, `{{token}}`) par environnement (dev, staging, prod) |
| **Tests** | Scripts JavaScript pour valider les réponses automatiquement |
| **Pre-request scripts** | Code exécuté avant la requête (génération de token, etc.) |
| **Variables** | `{{variable}}` dans les URLs, headers, body |
| **Historique** | Toutes les requêtes passées sont sauvegardées |
| **Mock servers** | Simuler une API sans backend réel |
| **Documentation** | Générer une documentation API depuis les collections |
| **Collaboration** | Partager des collections entre développeurs |

#### Tester notre API Iris dans Postman

**Étape 1 — Health check :**
```
Method: GET
URL: http://localhost:8000/health
```

**Étape 2 — Prédiction :**
```
Method: POST
URL: http://localhost:8000/predict
Headers:
  Content-Type: application/json
Body (raw JSON):
{
  "sepal_length": 5.1,
  "sepal_width": 3.5,
  "petal_length": 1.4,
  "petal_width": 0.2
}
```

**Étape 3 — Test automatisé dans Postman :**

```javascript
// Onglet "Tests" dans Postman
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Response has species", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property("species");
    pm.expect(jsonData.species).to.be.oneOf(["setosa", "versicolor", "virginica"]);
});

pm.test("Confidence is between 0 and 1", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.confidence).to.be.within(0, 1);
});

pm.test("Response time is less than 500ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(500);
});
```

### 10.3 VS Code REST Client

L'extension **REST Client** pour VS Code permet de tester les APIs directement dans l'éditeur avec des fichiers `.http` :

```http
### Health check
GET http://localhost:8000/health

### Informations du modèle
GET http://localhost:8000/model/info

### Prédiction — Setosa
POST http://localhost:8000/predict
Content-Type: application/json

{
  "sepal_length": 5.1,
  "sepal_width": 3.5,
  "petal_length": 1.4,
  "petal_width": 0.2
}

### Prédiction — Virginica
POST http://localhost:8000/predict
Content-Type: application/json

{
  "sepal_length": 6.3,
  "sepal_width": 3.3,
  "petal_length": 6.0,
  "petal_width": 2.5
}

### Statistiques du dataset
GET http://localhost:8000/dataset/stats

### Échantillons du dataset
GET http://localhost:8000/dataset/samples
```

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-11"></a>

<details>
<summary><strong>11 — Authentification dans les APIs REST</strong></summary>

L'authentification est le processus de **vérification de l'identité** d'un client. L'autorisation est le processus de **vérification des permissions** d'un client authentifié.

### 11.1 API Keys — Clés d'API

**Principe** : Le client envoie une clé unique avec chaque requête. La clé identifie le client et ses permissions.

```mermaid
sequenceDiagram
    participant C as Client
    participant S as Serveur API
    
    Note over C: Le développeur obtient une API Key<br>lors de l'inscription
    
    C->>S: GET /data<br>X-API-Key: sk-abc123def456
    S->>S: Vérifier la clé dans la BDD
    S-->>C: 200 OK — données
    
    C->>S: GET /data<br>X-API-Key: INVALIDE
    S-->>C: 401 Unauthorized
```

**Méthodes de transmission :**

| Méthode | Exemple | Sécurité |
|---------|---------|----------|
| **Header** (recommandé) | `X-API-Key: sk-abc123` | ✅ Bonne |
| **Query parameter** | `?api_key=sk-abc123` | ⚠️ Visible dans les logs |
| **Cookie** | `Cookie: api_key=sk-abc123` | ✅ Bonne (avec HttpOnly) |

**Implémentation Python :**

```python
import requests

# Via header (recommandé)
response = requests.get(
    "https://api.example.com/data",
    headers={"X-API-Key": "sk-abc123def456"}
)

# Via query parameter
response = requests.get(
    "https://api.example.com/data",
    params={"api_key": "sk-abc123def456"}
)
```

**Avantages / Inconvénients :**

| ✅ Avantages | ❌ Inconvénients |
|-------------|-----------------|
| Simple à implémenter | Pas de notion d'utilisateur |
| Pas de flux d'authentification complexe | Difficile à renouveler (il faut le communiquer) |
| Bon pour les APIs publiques / machine-to-machine | Si la clé fuite, accès total |

### 11.2 JWT — JSON Web Tokens

**Principe** : Le serveur émet un token signé contenant les informations d'identité du client. Le client envoie ce token avec chaque requête.

**Structure d'un JWT (3 parties séparées par des points) :**

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
└──────────── Header ────────────┘.└────────────── Payload ──────────────┘.└───────────── Signature ───────────────┘
```

| Partie | Contenu | Encodage |
|--------|---------|----------|
| **Header** | Algorithme de signature + type de token | Base64url |
| **Payload** | Claims (données de l'utilisateur) | Base64url |
| **Signature** | HMAC-SHA256(header + payload, secret) | Base64url |

**Payload décodé :**

```json
{
  "sub": "user123",
  "name": "Alice Dupont",
  "email": "alice@example.com",
  "role": "admin",
  "iat": 1713024000,
  "exp": 1713110400
}
```

**Claims standard :**

| Claim | Nom complet | Description |
|-------|------------|-------------|
| `sub` | Subject | Identifiant de l'utilisateur |
| `iat` | Issued At | Date de création du token (timestamp) |
| `exp` | Expiration | Date d'expiration du token (timestamp) |
| `nbf` | Not Before | Le token n'est pas valide avant cette date |
| `iss` | Issuer | Émetteur du token |
| `aud` | Audience | Destinataire du token |
| `jti` | JWT ID | Identifiant unique du token |

**Flux d'authentification JWT :**

```mermaid
sequenceDiagram
    participant C as Client
    participant S as Serveur API
    
    C->>S: POST /auth/login<br>{"email": "alice@ex.com", "password": "secret"}
    S->>S: Vérifier identifiants<br>Générer JWT
    S-->>C: 200 OK<br>{"access_token": "eyJ...", "token_type": "bearer"}
    
    Note over C: Stocker le token localement
    
    C->>S: GET /protected<br>Authorization: Bearer eyJ...
    S->>S: Vérifier la signature du JWT<br>Extraire les claims<br>Vérifier l'expiration
    S-->>C: 200 OK — données protégées
    
    Note over C: Plus tard, le token expire...
    
    C->>S: GET /protected<br>Authorization: Bearer eyJ... (expiré)
    S-->>C: 401 Unauthorized — Token expired
    
    C->>S: POST /auth/refresh<br>{"refresh_token": "eyR..."}
    S-->>C: 200 OK<br>{"access_token": "eyN...", "token_type": "bearer"}
```

**Implémentation Python :**

```python
import requests

# 1. Login — Obtenir le token
login_response = requests.post(
    "https://api.example.com/auth/login",
    json={"email": "alice@example.com", "password": "secret"}
)
token = login_response.json()["access_token"]

# 2. Requête authentifiée
response = requests.get(
    "https://api.example.com/protected",
    headers={"Authorization": f"Bearer {token}"}
)
print(response.json())

# 3. Refresh token (quand le token expire)
refresh_response = requests.post(
    "https://api.example.com/auth/refresh",
    json={"refresh_token": "eyR..."}
)
new_token = refresh_response.json()["access_token"]
```

### 11.3 OAuth 2.0

**OAuth 2.0** est un framework d'autorisation qui permet à une application tierce d'accéder aux ressources d'un utilisateur **sans connaître son mot de passe**.

**Rôles OAuth 2.0 :**

| Rôle | Description | Exemple |
|------|-------------|---------|
| **Resource Owner** | L'utilisateur propriétaire des données | Alice |
| **Client** | L'application tierce | Notre app Iris |
| **Authorization Server** | Émet les tokens | Google, GitHub, Auth0 |
| **Resource Server** | Héberge les données protégées | API Google, API GitHub |

**Principaux flows OAuth 2.0 :**

| Flow | Usage | Sécurité |
|------|-------|----------|
| **Authorization Code** | Apps web avec serveur backend | ✅ Très sécurisé |
| **Authorization Code + PKCE** | Apps mobiles, SPA | ✅ Très sécurisé |
| **Client Credentials** | Machine-to-machine | ✅ Sécurisé |
| **Implicit** (déprécié) | SPA sans backend | ❌ Peu sécurisé |
| **Resource Owner Password** (déprécié) | Apps de confiance uniquement | ⚠️ Moyen |

**Flux Authorization Code (le plus courant) :**

```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant C as Client (App)
    participant A as Authorization Server
    participant R as Resource Server (API)
    
    U->>C: Cliquer sur "Se connecter avec Google"
    C->>A: Redirection vers /authorize<br>?client_id=xxx&redirect_uri=...&scope=read
    A->>U: Page de login Google
    U->>A: Saisir email + mot de passe
    A->>U: "L'app Iris veut accéder à vos données. Autoriser ?"
    U->>A: Accepter
    A->>C: Redirection vers redirect_uri<br>?code=AUTH_CODE_123
    C->>A: POST /token<br>{code=AUTH_CODE_123, client_secret=...}
    A-->>C: {access_token: "eyJ...", refresh_token: "eyR..."}
    C->>R: GET /user/profile<br>Authorization: Bearer eyJ...
    R-->>C: {name: "Alice", email: "alice@gmail.com"}
```

### 11.4 Comparaison des méthodes d'authentification

| Critère | API Key | JWT | OAuth 2.0 |
|---------|---------|-----|-----------|
| **Complexité** | ⭐ Très simple | ⭐⭐⭐ Moyenne | ⭐⭐⭐⭐⭐ Complexe |
| **Sécurité** | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Expiration** | Manuelle | Automatique (exp claim) | Automatique (access + refresh) |
| **Révocation** | Supprimer la clé | Difficile (attendre expiration) | Révoquer le token |
| **Utilisateur identifié** | Non | Oui (claims) | Oui (scopes + profil) |
| **Usage typique** | APIs publiques, M2M | APIs authentifiées | Login tiers (Google, GitHub) |
| **Notre API Iris** | Non utilisé | Non utilisé | Non utilisé |

> **Note** : Notre API Iris n'utilise pas d'authentification car c'est un projet de démonstration. En production, il faudrait ajouter au minimum une API Key ou un JWT.

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-12"></a>

<details>
<summary><strong>12 — CORS — Cross-Origin Resource Sharing</strong></summary>

### 12.1 Qu'est-ce que CORS ?

**CORS** (*Cross-Origin Resource Sharing*) est un mécanisme de sécurité des navigateurs qui **restreint les requêtes HTTP entre origines différentes**. C'est la politique de **Same-Origin Policy** (SOP) qui est à l'origine de CORS.

**Qu'est-ce qu'une « origine » ?**

Une origine est la combinaison de : **schéma + hôte + port**

| URL | Origine |
|-----|---------|
| `http://localhost:8501` | `http://localhost:8501` |
| `http://localhost:8000` | `http://localhost:8000` |
| `https://api.example.com` | `https://api.example.com` |
| `https://api.example.com:443` | `https://api.example.com` (port 443 implicite) |

**Deux URLs ont la même origine ssi les 3 composants sont identiques.**

```
http://localhost:8501  →  Streamlit frontend
http://localhost:8000  →  FastAPI backend

Origines DIFFÉRENTES → Requête cross-origin → CORS nécessaire !
```

### 12.2 Pourquoi CORS existe ?

Sans CORS, un site malveillant pourrait :

```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant M as Site malveillant<br>(evil.com)
    participant B as Banque API<br>(bank.com)
    
    U->>M: Visite evil.com
    M->>U: Page avec JavaScript malveillant
    Note over M,B: Sans CORS, ce serait possible :
    U->>B: fetch("https://bank.com/api/transfer",<br>{method: "POST", body: {to: "hacker", amount: 10000}})
    Note over B: Le navigateur envoie les cookies bank.com<br>de l'utilisateur automatiquement !
    B-->>U: 200 OK — Transfert effectué 😱
```

**Avec CORS :**

```mermaid
sequenceDiagram
    participant U as Navigateur
    participant M as evil.com
    participant B as bank.com API
    
    U->>M: Visite evil.com
    M->>U: JavaScript : fetch("https://bank.com/api/transfer")
    
    Note over U,B: Le navigateur envoie d'abord une requête preflight
    U->>B: OPTIONS /api/transfer<br>Origin: https://evil.com<br>Access-Control-Request-Method: POST
    B-->>U: 200 OK<br>Access-Control-Allow-Origin: https://bank.com<br>❌ evil.com n'est PAS autorisé
    
    Note over U: Le navigateur BLOQUE la requête<br>Erreur CORS dans la console
```

### 12.3 Requête Preflight (OPTIONS)

Pour les requêtes « non simples » (POST avec JSON, headers personnalisés, etc.), le navigateur envoie automatiquement une **requête preflight** (OPTIONS) avant la vraie requête.

**Requête simple (pas de preflight) :**
- Méthodes : GET, HEAD, POST
- Headers : Accept, Accept-Language, Content-Language, Content-Type (si `text/plain`, `multipart/form-data`, ou `application/x-www-form-urlencoded`)

**Requête non simple (preflight nécessaire) :**
- Méthodes : PUT, PATCH, DELETE
- Content-Type : `application/json`
- Headers personnalisés : Authorization, X-API-Key, etc.

```mermaid
sequenceDiagram
    participant C as Navigateur<br>(Streamlit)
    participant S as FastAPI

    Note over C,S: 1. Requête Preflight (automatique)
    C->>S: OPTIONS /predict<br>Origin: http://localhost:8501<br>Access-Control-Request-Method: POST<br>Access-Control-Request-Headers: Content-Type

    S-->>C: 200 OK<br>Access-Control-Allow-Origin: *<br>Access-Control-Allow-Methods: GET, POST, PUT, DELETE<br>Access-Control-Allow-Headers: *<br>Access-Control-Max-Age: 600

    Note over C,S: 2. Vraie requête (après validation)
    C->>S: POST /predict<br>Origin: http://localhost:8501<br>Content-Type: application/json<br><br>{"sepal_length": 5.1, ...}

    S-->>C: 200 OK<br>Access-Control-Allow-Origin: *<br><br>{"species": "setosa", ...}
```

### 12.4 Configuration CORS dans FastAPI

Voici la configuration CORS de notre API Iris dans `backend/main.py` :

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],           # Origines autorisées (* = toutes)
    allow_credentials=True,         # Autoriser les cookies/auth
    allow_methods=["*"],           # Méthodes autorisées (* = toutes)
    allow_headers=["*"],           # Headers autorisés (* = tous)
)
```

**Configuration sécurisée pour la production :**

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:8501",        # Streamlit dev
        "https://iris-app.example.com",  # Production
    ],
    allow_credentials=True,
    allow_methods=["GET", "POST"],       # Seulement GET et POST
    allow_headers=["Content-Type", "Authorization"],
    max_age=600,                         # Cache preflight 10 min
)
```

**Headers CORS :**

| Header de réponse | Description | Exemple |
|-------------------|-------------|---------|
| `Access-Control-Allow-Origin` | Origines autorisées | `*` ou `http://localhost:8501` |
| `Access-Control-Allow-Methods` | Méthodes autorisées | `GET, POST, PUT, DELETE` |
| `Access-Control-Allow-Headers` | Headers de requête autorisés | `Content-Type, Authorization` |
| `Access-Control-Allow-Credentials` | Autoriser les cookies | `true` |
| `Access-Control-Max-Age` | Durée du cache preflight (secondes) | `600` |
| `Access-Control-Expose-Headers` | Headers de réponse accessibles au client | `X-Total-Count` |

### 12.5 CORS et Streamlit

> **Important** : Quand Streamlit utilise `requests` pour appeler l'API, ce n'est **pas** le navigateur qui fait la requête HTTP, c'est le **serveur Python Streamlit**. Donc **CORS ne s'applique pas** dans ce cas.

CORS ne concerne que les requêtes faites **depuis le JavaScript du navigateur** (fetch, XMLHttpRequest). Streamlit fait les requêtes côté serveur (Python), ce qui contourne CORS.

```
Navigateur → JavaScript fetch() → API  ← CORS s'applique
Navigateur → Streamlit (serveur Python) → requests.get() → API  ← CORS NE s'applique PAS
```

Néanmoins, la configuration CORS reste nécessaire dans notre FastAPI pour :
- Les requêtes Swagger UI (`/docs`)
- Un éventuel frontend JavaScript additionnel
- Les tests depuis le navigateur

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-13"></a>

<details>
<summary><strong>13 — Bonnes pratiques de conception d'API REST</strong></summary>

### 13.1 Nommage des endpoints

| Règle | ✅ Bon | ❌ Mauvais |
|-------|--------|-----------|
| Utiliser des **noms** (pas de verbes) | `/users`, `/predictions` | `/getUsers`, `/makePrediction` |
| Utiliser le **pluriel** | `/users`, `/models` | `/user`, `/model` |
| Utiliser des **tirets** (kebab-case) | `/model-info`, `/dataset-stats` | `/modelInfo`, `/dataset_stats` |
| Utiliser des **minuscules** | `/dataset/samples` | `/Dataset/Samples` |
| **Hiérarchiser** les ressources | `/users/42/orders` | `/getUserOrders?id=42` |
| **Pas de trailing slash** | `/users` | `/users/` |
| **Pas d'extension de fichier** | `/users` | `/users.json` |

**Exemples pour notre API Iris :**

| Endpoint actuel | Statut |
|----------------|--------|
| `GET /health` | ✅ Correct |
| `POST /predict` | ✅ Correct (action, pas une ressource CRUD) |
| `GET /model/info` | ✅ Correct (sous-ressource) |
| `GET /dataset/samples` | ✅ Correct |
| `GET /dataset/stats` | ✅ Correct |

### 13.2 Versioning de l'API

| Méthode | Exemple | Avantages | Inconvénients |
|---------|---------|-----------|---------------|
| **URI** (le plus courant) | `/v1/predict`, `/v2/predict` | Simple, visible | Pollue l'URL |
| **Header** | `Accept: application/vnd.iris.v1+json` | URL propre | Moins visible |
| **Query param** | `/predict?version=1` | Simple | Facile à oublier |
| **Pas de versioning** | `/predict` | Simple | Risque de breaking changes |

```python
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

Pour les collections volumineuses, toujours paginer :

```
GET /dataset/samples?page=1&size=20
GET /dataset/samples?offset=0&limit=20
GET /dataset/samples?cursor=abc123&limit=20
```

**Réponse paginée :**

```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "size": 20,
    "total_items": 150,
    "total_pages": 8,
    "has_next": true,
    "has_previous": false
  },
  "_links": {
    "self": "/dataset/samples?page=1&size=20",
    "next": "/dataset/samples?page=2&size=20",
    "last": "/dataset/samples?page=8&size=20"
  }
}
```

### 13.4 Filtrage, tri et recherche

```
GET /dataset/samples?species=setosa                           # Filtrage
GET /dataset/samples?sort=sepal_length&order=desc             # Tri
GET /dataset/samples?search=setosa                            # Recherche
GET /dataset/samples?species=setosa&sort=sepal_length&page=1  # Combinaison
GET /dataset/samples?min_sepal_length=5.0&max_sepal_length=7.0  # Range
GET /dataset/samples?fields=species,sepal_length              # Projection
```

### 13.5 Gestion des erreurs

**Format d'erreur standardisé :**

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "La longueur du sépale doit être entre 0 et 10 cm.",
    "details": [
      {
        "field": "sepal_length",
        "value": -5.0,
        "constraint": "ge=0",
        "message": "ensure this value is greater than or equal to 0"
      }
    ],
    "timestamp": "2026-04-13T12:00:00Z",
    "request_id": "req-550e8400"
  }
}
```

**FastAPI retourne automatiquement des erreurs Pydantic structurées :**

```json
{
  "detail": [
    {
      "type": "greater_than_equal",
      "loc": ["body", "sepal_length"],
      "msg": "Input should be greater than or equal to 0",
      "input": -5.0,
      "ctx": {"ge": 0}
    }
  ]
}
```

### 13.6 Rate Limiting

Limiter le nombre de requêtes par client pour protéger l'API :

| Header de réponse | Description |
|-------------------|-------------|
| `X-RateLimit-Limit` | Nombre max de requêtes par fenêtre |
| `X-RateLimit-Remaining` | Requêtes restantes |
| `X-RateLimit-Reset` | Timestamp de réinitialisation |
| `Retry-After` | Secondes à attendre (si 429) |

### 13.7 Documentation

- **Toujours documenter l'API** avec OpenAPI / Swagger
- FastAPI génère automatiquement `/docs` (Swagger UI) et `/redoc` (ReDoc)
- Ajouter des descriptions, des exemples et des schémas de réponse

### 13.8 Récapitulatif des bonnes pratiques

| Catégorie | Bonne pratique |
|-----------|----------------|
| **URL** | Noms pluriels, minuscules, kebab-case |
| **Méthodes** | Utiliser la bonne méthode HTTP pour chaque action |
| **Codes de statut** | Retourner le bon code (201 pour création, 204 pour suppression…) |
| **Format** | JSON par défaut, Content-Type explicite |
| **Erreurs** | Format standardisé avec code, message et détails |
| **Versioning** | Versionner l'URL (`/v1/`) dès le début |
| **Pagination** | Paginer toutes les collections |
| **Sécurité** | HTTPS, authentification, rate limiting |
| **Documentation** | OpenAPI / Swagger, exemples, descriptions |
| **CORS** | Configurer les origines autorisées |
| **Cache** | Utiliser Cache-Control et ETag |
| **Idempotence** | PUT et DELETE doivent être idempotents |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-14"></a>

<details>
<summary><strong>14 — Tester une API</strong></summary>

### 14.1 Swagger UI (intégré à FastAPI)

FastAPI génère automatiquement une interface Swagger UI accessible à `/docs`.

**Accès :** `http://localhost:8000/docs`

**Fonctionnalités :**
- Liste tous les endpoints avec leur documentation
- Permet de tester chaque endpoint interactivement (« Try it out »)
- Montre les schémas de requête et de réponse (Pydantic models)
- Affiche les codes de statut possibles
- Supporte l'authentification (bouton « Authorize »)

**Endpoints visibles dans notre Swagger :**

| Tag | Méthode | Endpoint | Description |
|-----|---------|----------|-------------|
| Health | GET | `/` | Health check basique |
| Health | GET | `/health` | État de santé de l'API |
| Prediction | POST | `/predict` | Prédire l'espèce d'une fleur |
| Model | GET | `/model/info` | Informations sur le modèle |
| Dataset | GET | `/dataset/samples` | Échantillons aléatoires |
| Dataset | GET | `/dataset/stats` | Statistiques du dataset |

**ReDoc :** `http://localhost:8000/redoc` — Documentation alternative plus lisible.

### 14.2 REST Client (VS Code)

Voir la section 10.3 pour les fichiers `.http`.

### 14.3 Postman

Voir la section 10.2 pour l'utilisation de Postman.

### 14.4 Tests automatisés avec pytest

#### Installation

```bash
pip install pytest httpx
```

#### Tests avec `httpx` et `TestClient` de FastAPI

```python
# tests/test_api.py
import pytest
from fastapi.testclient import TestClient
from backend.main import app

client = TestClient(app)


class TestHealthEndpoints:
    def test_root(self):
        response = client.get("/")
        assert response.status_code == 200
        assert response.json()["status"] == "ok"

    def test_health(self):
        response = client.get("/health")
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
        response = client.post("/predict", json=payload)
        assert response.status_code == 200

        data = response.json()
        assert data["species"] == "setosa"
        assert 0 <= data["confidence"] <= 1
        assert "setosa" in data["probabilities"]
        assert "versicolor" in data["probabilities"]
        assert "virginica" in data["probabilities"]

    def test_predict_versicolor(self):
        payload = {
            "sepal_length": 5.9,
            "sepal_width": 2.8,
            "petal_length": 4.5,
            "petal_width": 1.3,
        }
        response = client.post("/predict", json=payload)
        assert response.status_code == 200
        assert response.json()["species"] == "versicolor"

    def test_predict_virginica(self):
        payload = {
            "sepal_length": 6.3,
            "sepal_width": 3.3,
            "petal_length": 6.0,
            "petal_width": 2.5,
        }
        response = client.post("/predict", json=payload)
        assert response.status_code == 200
        assert response.json()["species"] == "virginica"

    def test_predict_invalid_values(self):
        payload = {
            "sepal_length": -5.0,  # Invalide : ge=0
            "sepal_width": 3.5,
            "petal_length": 1.4,
            "petal_width": 0.2,
        }
        response = client.post("/predict", json=payload)
        assert response.status_code == 422  # Validation error

    def test_predict_missing_fields(self):
        payload = {"sepal_length": 5.1}  # Champs manquants
        response = client.post("/predict", json=payload)
        assert response.status_code == 422

    def test_predict_empty_body(self):
        response = client.post("/predict", json={})
        assert response.status_code == 422

    def test_predict_wrong_types(self):
        payload = {
            "sepal_length": "cinq",  # String au lieu de float
            "sepal_width": 3.5,
            "petal_length": 1.4,
            "petal_width": 0.2,
        }
        response = client.post("/predict", json=payload)
        assert response.status_code == 422


class TestModelEndpoint:
    def test_model_info(self):
        response = client.get("/model/info")
        assert response.status_code == 200

        data = response.json()
        assert "model_type" in data
        assert "accuracy" in data
        assert "feature_names" in data
        assert "target_names" in data
        assert len(data["feature_names"]) == 4
        assert len(data["target_names"]) == 3
        assert 0 <= data["accuracy"] <= 1


class TestDatasetEndpoints:
    def test_dataset_samples(self):
        response = client.get("/dataset/samples")
        assert response.status_code == 200

        data = response.json()
        assert isinstance(data, list)
        assert len(data) == 10
        for sample in data:
            assert "sepal_length" in sample
            assert "species" in sample

    def test_dataset_stats(self):
        response = client.get("/dataset/stats")
        assert response.status_code == 200

        data = response.json()
        assert data["total_samples"] == 150
        assert data["features_count"] == 4
        assert data["species_count"] == 3
```

#### Exécution des tests

```bash
# Lancer tous les tests
pytest tests/ -v

# Lancer un fichier spécifique
pytest tests/test_api.py -v

# Lancer une classe de tests
pytest tests/test_api.py::TestPredictionEndpoint -v

# Lancer un test spécifique
pytest tests/test_api.py::TestPredictionEndpoint::test_predict_setosa -v

# Avec couverture de code
pip install pytest-cov
pytest tests/ -v --cov=backend --cov-report=html
```

#### Tests avec `httpx` (asynchrone)

```python
import pytest
import httpx

BASE_URL = "http://localhost:8000"

@pytest.mark.asyncio
async def test_predict_async():
    async with httpx.AsyncClient(base_url=BASE_URL) as client:
        response = await client.post("/predict", json={
            "sepal_length": 5.1,
            "sepal_width": 3.5,
            "petal_length": 1.4,
            "petal_width": 0.2,
        })
        assert response.status_code == 200
        assert response.json()["species"] == "setosa"
```

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-15"></a>

<details>
<summary><strong>15 — Cas pratique : notre application Iris</strong></summary>

### 15.1 Architecture complète

```mermaid
flowchart TB
    subgraph "Navigateur de l'utilisateur"
        A[Interface Streamlit<br>http://localhost:8501]
    end
    
    subgraph "Serveur Streamlit (Python)"
        B[app.py<br>Logique UI + appels API]
        C[requests library<br>Client HTTP]
    end
    
    subgraph "Serveur FastAPI (Python)"
        D[main.py<br>Routes + Validation]
        E[Pydantic<br>Validation des données]
        F[scikit-learn<br>model.predict]
        G[iris_model.joblib<br>Modèle entraîné]
    end
    
    A <-->|WebSocket<br>Streamlit protocol| B
    B --> C
    C <-->|HTTP/JSON<br>Port 8000| D
    D --> E
    E --> F
    F --> G
    
    style A fill:#ff7043,color:#fff
    style B fill:#ff7043,color:#fff
    style C fill:#ff7043,color:#fff
    style D fill:#42a5f5,color:#fff
    style E fill:#42a5f5,color:#fff
    style F fill:#66bb6a,color:#fff
    style G fill:#66bb6a,color:#fff
```

### 15.2 Traçabilité complète : du slider à l'affichage

Voici le parcours complet d'une requête de prédiction dans notre application :

```mermaid
sequenceDiagram
    actor U as Utilisateur
    participant UI as Streamlit UI<br>(navigateur)
    participant S as Serveur Streamlit<br>(app.py)
    participant R as requests library
    participant F as FastAPI<br>(main.py)
    participant P as Pydantic<br>(validation)
    participant M as scikit-learn<br>(modèle ML)
    
    U->>UI: 1. Ajuste les sliders<br>sepal_length=5.1, sepal_width=3.5<br>petal_length=1.4, petal_width=0.2
    U->>UI: 2. Clique sur "🔮 Prédire l'espèce"
    
    UI->>S: 3. WebSocket : widget interaction<br>Streamlit ré-exécute app.py
    
    Note over S: 4. st.button() retourne True<br>Entre dans le bloc if
    
    S->>S: 5. st.spinner("Prédiction en cours...")
    
    S->>R: 6. predict(5.1, 3.5, 1.4, 0.2)
    
    R->>F: 7. HTTP POST /predict<br>Content-Type: application/json<br><br>{"sepal_length": 5.1,<br>"sepal_width": 3.5,<br>"petal_length": 1.4,<br>"petal_width": 0.2}
    
    F->>P: 8. PredictionRequest(**body)<br>Validation Pydantic
    P-->>F: 9. ✅ Données valides<br>(ge=0, le=10 respecté)
    
    F->>M: 10. features = np.array([[5.1, 3.5, 1.4, 0.2]])<br>model.predict(features)<br>model.predict_proba(features)
    
    M-->>F: 11. prediction=0, probas=[1.0, 0.0, 0.0]
    
    F->>F: 12. species = target_names[0] = "setosa"<br>confidence = 1.0<br>prob_dict = {"setosa": 1.0, ...}
    
    F-->>R: 13. HTTP 200 OK<br>Content-Type: application/json<br><br>{"species": "setosa",<br>"confidence": 1.0,<br>"probabilities": {<br>"setosa": 1.0,<br>"versicolor": 0.0,<br>"virginica": 0.0}}
    
    R->>R: 14. r.raise_for_status() → OK<br>r.json() → dict Python
    
    R-->>S: 15. return {"species": "setosa", ...}
    
    S->>S: 16. result = predict(...)
    S->>S: 17. species = result["species"]<br>confidence = result["confidence"]<br>probabilities = result["probabilities"]
    
    S->>UI: 18. st.metric("Espèce", "SETOSA")<br>st.progress(1.0) pour setosa<br>st.progress(0.0) pour versicolor<br>st.progress(0.0) pour virginica
    
    UI->>U: 19. 🌸 SETOSA<br>Confiance : 100.0%<br>▓▓▓▓▓▓▓▓▓▓ setosa 100%<br>░░░░░░░░░░ versicolor 0%<br>░░░░░░░░░░ virginica 0%
```

### 15.3 Détail de chaque étape

| Étape | Composant | Action | Code |
|-------|-----------|--------|------|
| 1 | Navigateur | L'utilisateur ajuste les 4 sliders | `st.slider("Longueur sépale", 4.0, 8.0, 5.1, 0.1)` |
| 2 | Navigateur | Clic sur le bouton Prédire | `st.button("🔮 Prédire l'espèce")` |
| 3 | Streamlit | Ré-exécution complète de `app.py` | Framework Streamlit |
| 4 | Streamlit | Le bouton retourne `True` | `if st.button(...):` |
| 5 | Streamlit | Affiche un spinner pendant l'opération | `with st.spinner("Prédiction en cours..."):` |
| 6 | app.py | Appelle la fonction `predict()` | `result = predict(sl, sw, pl, pw)` |
| 7 | requests | Envoie HTTP POST avec JSON | `requests.post(url, json=payload)` |
| 8 | FastAPI | Valide le body avec Pydantic | `PredictionRequest(sepal_length=5.1, ...)` |
| 9 | Pydantic | Vérifie les contraintes (ge=0, le=10) | Validation automatique |
| 10 | scikit-learn | Exécute le modèle Random Forest | `model.predict(features)` |
| 11 | scikit-learn | Retourne prédiction + probabilités | `[0]`, `[1.0, 0.0, 0.0]` |
| 12 | FastAPI | Construit la réponse | `PredictionResponse(species=..., ...)` |
| 13 | FastAPI | Retourne HTTP 200 + JSON | Sérialisation automatique |
| 14 | requests | Vérifie le statut et parse le JSON | `r.raise_for_status()`, `r.json()` |
| 15 | app.py | Reçoit le dictionnaire Python | `return r.json()` |
| 16-17 | app.py | Extrait les valeurs du résultat | `result["species"]`, etc. |
| 18 | Streamlit | Affiche les résultats avec les widgets | `st.metric()`, `st.progress()` |
| 19 | Navigateur | L'utilisateur voit le résultat final | Interface mise à jour |

### 15.4 Requête HTTP réelle capturée

**Requête envoyée par `requests` :**

```http
POST /predict HTTP/1.1
Host: localhost:8000
User-Agent: python-requests/2.31.0
Accept-Encoding: gzip, deflate
Accept: */*
Connection: keep-alive
Content-Length: 85
Content-Type: application/json

{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}
```

**Réponse retournée par FastAPI :**

```http
HTTP/1.1 200 OK
date: Mon, 13 Apr 2026 12:00:00 GMT
server: uvicorn
content-length: 74
content-type: application/json
access-control-allow-origin: *
access-control-allow-credentials: true

{"species":"setosa","confidence":1.0,"probabilities":{"setosa":1.0,"versicolor":0.0,"virginica":0.0}}
```

### 15.5 Gestion des erreurs dans le parcours

```mermaid
flowchart TD
    A[Utilisateur clique Prédire] --> B{API accessible ?}
    B -->|Non| C["st.error('API hors ligne')"]
    B -->|Oui| D[requests.post /predict]
    D --> E{Status code ?}
    E -->|200| F[Afficher résultat]
    E -->|422| G["Erreur de validation<br>Valeurs hors limites"]
    E -->|503| H["Modèle non chargé"]
    E -->|500| I["Erreur serveur interne"]
    D --> J{Exception réseau ?}
    J -->|ConnectionError| K["Serveur tombé pendant la requête"]
    J -->|Timeout| L["Serveur trop lent"]
    
    G --> M["st.error(f'Erreur : {e}')"]
    H --> M
    I --> M
    K --> M
    L --> M
    
    style F fill:#66bb6a,color:#fff
    style M fill:#ef5350,color:#fff
```

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-16"></a>

<details>
<summary><strong>16 — Glossaire des termes</strong></summary>

| # | Terme | Définition |
|---|-------|------------|
| 1 | **API** | *Application Programming Interface* — Interface permettant à deux logiciels de communiquer entre eux via un contrat défini. |
| 2 | **REST** | *Representational State Transfer* — Style architectural pour les services web, défini par Roy Fielding en 2000, basé sur 6 contraintes. |
| 3 | **RESTful** | Qualifie une API qui respecte les contraintes REST (stateless, interface uniforme, etc.). |
| 4 | **HTTP** | *HyperText Transfer Protocol* — Protocole de communication client-serveur sur lequel repose le web et les APIs REST. |
| 5 | **HTTPS** | *HTTP Secure* — Version chiffrée de HTTP utilisant TLS/SSL pour sécuriser les échanges. |
| 6 | **URL / URI** | *Uniform Resource Locator / Identifier* — Adresse unique identifiant une ressource sur le réseau. |
| 7 | **Endpoint** | Point d'entrée d'une API, combinaison d'une URL et d'une méthode HTTP (ex: `POST /predict`). |
| 8 | **Ressource** | Entité conceptuelle manipulée par l'API, identifiée par une URI (ex: un utilisateur, une prédiction). |
| 9 | **Représentation** | Forme concrète d'une ressource transmise entre client et serveur (JSON, XML, etc.). |
| 10 | **Méthode HTTP** | Verbe HTTP indiquant l'action à effectuer sur la ressource (GET, POST, PUT, PATCH, DELETE, etc.). |
| 11 | **Header HTTP** | Métadonnée clé-valeur accompagnant une requête ou une réponse HTTP (ex: `Content-Type: application/json`). |
| 12 | **Body (Corps)** | Partie de la requête/réponse HTTP contenant les données transmises (payload). |
| 13 | **Status Code** | Code numérique à 3 chiffres indiquant le résultat d'une requête HTTP (200, 404, 500, etc.). |
| 14 | **JSON** | *JavaScript Object Notation* — Format de données léger basé sur des paires clé-valeur, standard des APIs REST. |
| 15 | **XML** | *eXtensible Markup Language* — Format de balisage structuré, utilisé par SOAP et les systèmes legacy. |
| 16 | **YAML** | *YAML Ain't Markup Language* — Format de sérialisation lisible, populaire pour la configuration. |
| 17 | **SOAP** | *Simple Object Access Protocol* — Protocole de services web basé sur XML, prédécesseur de REST. |
| 18 | **WSDL** | *Web Services Description Language* — Langage XML décrivant les services SOAP (équivalent SOAP d'OpenAPI). |
| 19 | **OpenAPI** | Spécification standard pour décrire les APIs REST (anciennement Swagger Specification). |
| 20 | **Swagger UI** | Interface web interactive pour explorer et tester une API documentée avec OpenAPI. |
| 21 | **CORS** | *Cross-Origin Resource Sharing* — Mécanisme de sécurité du navigateur contrôlant les requêtes entre origines différentes. |
| 22 | **Preflight** | Requête OPTIONS automatique envoyée par le navigateur avant une requête cross-origin non simple. |
| 23 | **Same-Origin Policy** | Politique de sécurité du navigateur interdisant les requêtes entre origines différentes par défaut. |
| 24 | **Idempotent** | Propriété d'une opération qui produit le même résultat, qu'elle soit exécutée une ou plusieurs fois. |
| 25 | **Stateless** | Sans état — chaque requête contient toutes les informations nécessaires, le serveur ne conserve pas de session. |
| 26 | **Cache** | Mécanisme de stockage temporaire des réponses pour éviter des requêtes répétées au serveur. |
| 27 | **ETag** | *Entity Tag* — Identifiant de version d'une ressource, utilisé pour la validation de cache. |
| 28 | **JWT** | *JSON Web Token* — Token auto-contenu signé, utilisé pour l'authentification sans état. |
| 29 | **OAuth 2.0** | Framework d'autorisation permettant à des applications tierces d'accéder aux ressources d'un utilisateur. |
| 30 | **Bearer Token** | Token d'accès transmis dans le header `Authorization: Bearer <token>`. |
| 31 | **API Key** | Clé unique identifiant un client API, transmise dans un header ou un paramètre de requête. |
| 32 | **Rate Limiting** | Limitation du nombre de requêtes par client dans une fenêtre de temps donnée. |
| 33 | **Pagination** | Découpage d'une collection volumineuse en pages de taille fixe pour optimiser les transferts. |
| 34 | **HATEOAS** | *Hypermedia As The Engine Of Application State* — Sous-contrainte REST où les réponses contiennent des liens vers les actions possibles. |
| 35 | **Content-Type** | Header HTTP indiquant le format MIME du corps de la requête/réponse (ex: `application/json`). |
| 36 | **Accept** | Header HTTP indiquant les formats de réponse que le client peut traiter. |
| 37 | **Query String** | Partie de l'URL après `?` contenant des paramètres clé-valeur (ex: `?page=1&size=20`). |
| 38 | **Path Parameter** | Variable dans le chemin de l'URL (ex: `/users/{id}` → `/users/42`). |
| 39 | **Payload** | Données utiles transmises dans le corps d'une requête HTTP. |
| 40 | **Sérialisation** | Conversion d'un objet en mémoire vers un format transmissible (ex: dict Python → JSON string). |
| 41 | **Désérialisation** | Conversion inverse : format transmis → objet en mémoire (ex: JSON string → dict Python). |
| 42 | **Middleware** | Composant logiciel interceptant les requêtes/réponses pour ajouter un traitement transversal (CORS, logging, auth). |
| 43 | **Timeout** | Durée maximale d'attente d'une réponse avant abandon de la requête. |
| 44 | **Retry** | Mécanisme de ré-essai automatique d'une requête échouée, souvent avec backoff exponentiel. |
| 45 | **Backoff exponentiel** | Stratégie de retry où le délai entre les tentatives double à chaque échec (1s, 2s, 4s, 8s…). |
| 46 | **WebSocket** | Protocole de communication bidirectionnelle persistante entre client et serveur. |
| 47 | **GraphQL** | Langage de requête pour APIs permettant au client de spécifier exactement les données souhaitées. |
| 48 | **gRPC** | Framework RPC haute performance de Google utilisant Protocol Buffers et HTTP/2. |
| 49 | **Pydantic** | Bibliothèque Python de validation de données utilisée par FastAPI pour les schémas de requête/réponse. |
| 50 | **FastAPI** | Framework web Python moderne et performant pour construire des APIs REST, basé sur les type hints et Pydantic. |
| 51 | **requests** | Bibliothèque Python la plus populaire pour effectuer des requêtes HTTP (client HTTP). |
| 52 | **Uvicorn** | Serveur ASGI haute performance pour exécuter des applications FastAPI/Starlette. |
| 53 | **Streamlit** | Framework Python pour créer des applications web de données et de ML avec une syntaxe simple et déclarative. |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

<!-- ============================================================ -->
<a id="section-17"></a>

<details>
<summary><strong>17 — Conclusion et ressources</strong></summary>

### 17.1 Ce que nous avons appris

Dans ce cours exhaustif, nous avons couvert l'intégralité de la chaîne de consommation de services web REST :

| # | Thème | Concepts clés |
|---|-------|---------------|
| 1 | Services web | SOAP vs REST, historique, interopérabilité |
| 2 | Architecture REST | 6 contraintes de Fielding, stateless, HATEOAS |
| 3 | Protocole HTTP | Requêtes/réponses, headers, anatomie d'URL |
| 4 | Méthodes HTTP | GET, POST, PUT, PATCH, DELETE, idempotence, safety |
| 5 | Codes de statut | 1xx–5xx, signification détaillée |
| 6 | Formats de données | JSON, XML, YAML — comparaison |
| 7 | **Python requests** | **GET, POST, PUT, DELETE, auth, erreurs, sessions** |
| 8 | **Streamlit + API** | **spinner, metric, progress, dataframe, cache** |
| 9 | JavaScript | fetch, axios — aperçu |
| 10 | curl & Postman | Tests en ligne de commande et GUI |
| 11 | Authentification | API Keys, JWT, OAuth 2.0 |
| 12 | CORS | Same-Origin Policy, preflight, configuration |
| 13 | Bonnes pratiques | Nommage, versioning, pagination, erreurs |
| 14 | Tests | Swagger UI, pytest, REST Client |
| 15 | Cas pratique Iris | Traçabilité slider → API → modèle → affichage |

### 17.2 Compétences acquises

Après ce cours, vous êtes capable de :

- ✅ Expliquer la différence entre SOAP et REST
- ✅ Décrire les 6 contraintes de l'architecture REST
- ✅ Analyser une requête/réponse HTTP (headers, body, status code)
- ✅ Utiliser la bonne méthode HTTP pour chaque opération
- ✅ Interpréter les codes de statut HTTP
- ✅ Manipuler JSON, XML et YAML en Python
- ✅ **Consommer une API REST avec `requests` (GET, POST, PUT, DELETE)**
- ✅ **Intégrer des appels API dans une application Streamlit**
- ✅ Gérer les erreurs réseau et HTTP proprement
- ✅ Configurer CORS dans FastAPI
- ✅ Écrire des tests automatisés pour une API
- ✅ Tracer une requête de bout en bout dans une application full-stack

### 17.3 Ressources

#### Documentation officielle

| Ressource | URL |
|-----------|-----|
| **Python requests** | [docs.python-requests.org](https://docs.python-requests.org/) |
| **FastAPI** | [fastapi.tiangolo.com](https://fastapi.tiangolo.com/) |
| **Streamlit** | [docs.streamlit.io](https://docs.streamlit.io/) |
| **HTTP/1.1 (RFC 9110)** | [httpwg.org/specs/rfc9110](https://httpwg.org/specs/rfc9110.html) |
| **OpenAPI Specification** | [spec.openapis.org](https://spec.openapis.org/oas/latest.html) |
| **JSON (RFC 8259)** | [datatracker.ietf.org/doc/html/rfc8259](https://datatracker.ietf.org/doc/html/rfc8259) |
| **JWT (RFC 7519)** | [datatracker.ietf.org/doc/html/rfc7519](https://datatracker.ietf.org/doc/html/rfc7519) |
| **OAuth 2.0 (RFC 6749)** | [datatracker.ietf.org/doc/html/rfc6749](https://datatracker.ietf.org/doc/html/rfc6749) |

#### Outils

| Outil | Description | URL |
|-------|-------------|-----|
| **Postman** | Client API GUI | [postman.com](https://www.postman.com/) |
| **Insomnia** | Alternative à Postman | [insomnia.rest](https://insomnia.rest/) |
| **httpie** | Client HTTP en ligne de commande (plus lisible que curl) | [httpie.io](https://httpie.io/) |
| **jq** | Processeur JSON en ligne de commande | [jqlang.github.io/jq](https://jqlang.github.io/jq/) |
| **REST Client** | Extension VS Code pour fichiers `.http` | [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) |
| **Swagger Editor** | Éditeur OpenAPI en ligne | [editor.swagger.io](https://editor.swagger.io/) |

#### APIs publiques pour s'entraîner

| API | Description | URL |
|-----|-------------|-----|
| **JSONPlaceholder** | Fake REST API pour prototypage | [jsonplaceholder.typicode.com](https://jsonplaceholder.typicode.com/) |
| **httpbin** | Service de test HTTP | [httpbin.org](https://httpbin.org/) |
| **PokéAPI** | API REST Pokémon | [pokeapi.co](https://pokeapi.co/) |
| **REST Countries** | Informations sur les pays | [restcountries.com](https://restcountries.com/) |
| **OpenWeather** | API météo (API Key requise) | [openweathermap.org/api](https://openweathermap.org/api) |
| **NASA APIs** | APIs de la NASA | [api.nasa.gov](https://api.nasa.gov/) |

#### Thèse fondatrice

> Fielding, R. T. (2000). *Architectural Styles and the Design of Network-based Software Architectures*. Doctoral dissertation, University of California, Irvine.
> [ics.uci.edu/~fielding/pubs/dissertation/top.htm](https://www.ics.uci.edu/~fielding/pubs/dissertation/top.htm)

### 17.4 Prochaines étapes

| Étape | Description |
|-------|-------------|
| 🔐 Ajouter l'authentification | Implémenter JWT dans notre API FastAPI |
| 📊 API de batch prediction | Endpoint acceptant plusieurs fleurs à la fois |
| 🔄 WebSocket | Prédictions en temps réel sans polling |
| 🐳 Docker | Conteneuriser l'application complète |
| ☁️ Déploiement | Déployer sur AWS / GCP / Azure |
| 📈 Monitoring | Ajouter des métriques et du logging structuré |

</details>

<p align="right"><a href="#top">↑ Retour en haut</a></p>

---

> **Cours rédigé pour le projet Iris ML Demo — Full Stack App (Streamlit + FastAPI)**
> Application complète : `frontend-streamlit/app.py` → `backend/main.py` → `backend/models/iris_model.joblib`
