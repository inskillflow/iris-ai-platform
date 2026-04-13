# Iris ML Demo - Full Stack App (Flutter / Streamlit + FastAPI + Jupyter)

Application full-stack démonstrative de Machine Learning : classification de fleurs Iris.
Deux frontends disponibles : **Flutter** (Dart) et **Streamlit** (Python), partageant le même backend FastAPI.

## Architecture

```
full-app-pandas/
├── venv/                          # Environnement virtuel Python (partagé par tout)
├── requirements.txt               # Dépendances Python (backend + notebook + streamlit)
│
├── notebook/                      # Jupyter Notebook - Entraînement du modèle
│   └── train_model.ipynb
│
├── backend/                       # FastAPI - API REST de prédiction
│   ├── main.py
│   └── models/
│       ├── iris_model.joblib      # Modèle entraîné (généré par le notebook)
│       └── model_metadata.json    # Métadonnées (généré par le notebook)
│
├── frontend-flutter/              # Frontend Flutter (Dart)
│   └── lib/
│       ├── main.dart
│       ├── models/
│       ├── services/
│       ├── screens/
│       └── widgets/
│
├── frontend-streamlit/            # Frontend Streamlit (Python)
│   └── app.py
│
└── docs/                          # Documentation et cours (28 modules + samples)
    ├── flutter/
    │   ├── fr/                    # Cours Flutter en français (7 modules)
    │   └── eng/                   # Cours Flutter en anglais (7 modules)
    ├── streamlit/
    │   ├── fr/                    # Cours Streamlit en français (7 modules)
    │   └── eng/                   # Cours Streamlit en anglais (7 modules)
    └── samples/                   # Exemples de cours FastAPI
```

## Prérequis

- **Python 3.9+**
- **Flutter 3.x+** (uniquement si vous utilisez le frontend Flutter)

## Démarrage rapide

### Étape 1 : Créer et activer l'environnement virtuel

Depuis la racine du projet :

```bash
python -m venv venv
```

Activer le venv :

```bash
# Windows (PowerShell)
.\venv\Scripts\Activate.ps1

# Windows (CMD)
.\venv\Scripts\activate.bat

# Linux / macOS
source venv/bin/activate
```

> Vous verrez `(venv)` apparaître au début de votre invite de commande.

### Étape 2 : Installer toutes les dépendances

Toujours avec le venv activé :

```bash
pip install -r requirements.txt
```

Cela installe **tout** : FastAPI, scikit-learn, pandas, Jupyter, Streamlit.

### Étape 3 : Entraîner le modèle (Notebook)

Toujours avec le venv activé :

```bash
cd notebook
jupyter notebook train_model.ipynb
```

Exécuter toutes les cellules. Le modèle sera sauvegardé dans `backend/models/`.

> **Note** : Le modèle est déjà pré-entraîné. Cette étape est optionnelle.

### Étape 4 : Lancer le Backend (FastAPI)

Toujours avec le venv activé :

```bash
cd backend
python main.py
```

- API : **http://localhost:8000**
- Swagger : **http://localhost:8000/docs**

### Étape 5a : Frontend Streamlit (Python)

Dans un **nouveau terminal**, avec le venv activé :

```bash
cd frontend-streamlit
streamlit run app.py
```

L'application s'ouvre sur **http://localhost:8501**

### Étape 5b : Frontend Flutter (Dart)

Dans un **nouveau terminal** (pas besoin du venv) :

```bash
cd frontend-flutter
flutter pub get
flutter run -d chrome    # Pour le web
flutter run -d windows   # Pour Windows
```

## Endpoints API

| Méthode | Endpoint            | Description                        |
|---------|--------------------|------------------------------------|
| GET     | `/`                | Health check basique               |
| GET     | `/health`          | État de santé de l'API             |
| POST    | `/predict`         | Prédire l'espèce d'une fleur      |
| GET     | `/model/info`      | Informations sur le modèle        |
| GET     | `/dataset/samples` | Échantillons aléatoires du dataset |
| GET     | `/dataset/stats`   | Statistiques du dataset            |

### Exemple de prédiction

```bash
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}'
```

Réponse :

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

## Cours disponibles (28 modules)

Les cours sont disponibles en **français** et en **anglais**, pour chaque parcours frontend.

Tous les cours se trouvent dans le dossier `docs/`.

| # | Module | `docs/flutter/fr/` | `docs/flutter/eng/` | `docs/streamlit/fr/` | `docs/streamlit/eng/` |
|---|--------|--------------------|---------------------|----------------------|-----------------------|
| 00 | Architecture Full-Stack | ✅ | ✅ | ✅ | ✅ |
| 01 | Introduction IA & ML | ✅ | ✅ | ✅ | ✅ |
| 02 | Dataset Iris & Pandas | ✅ | ✅ | ✅ | ✅ |
| 03 | Random Forest | ✅ | ✅ | ✅ | ✅ |
| 04 | FastAPI Backend | ✅ | ✅ | ✅ | ✅ |
| 05 | Services Web REST | ✅ | ✅ | ✅ | ✅ |
| 06 | Frontend spécifique | Flutter | Flutter | Streamlit | Streamlit |

Exemples de cours FastAPI supplémentaires dans `docs/samples/`.

## Stack technique

- **ML** : scikit-learn (Random Forest Classifier)
- **Backend** : FastAPI + Uvicorn
- **Frontend 1** : Streamlit (Python)
- **Frontend 2** : Flutter (Dart, Material Design 3)
- **Dataset** : Iris (150 échantillons, 3 classes, 4 features)
- **Sérialisation** : joblib (modèle), JSON (métadonnées)
- **Env virtuel** : venv Python (partagé par backend + notebook + streamlit)
