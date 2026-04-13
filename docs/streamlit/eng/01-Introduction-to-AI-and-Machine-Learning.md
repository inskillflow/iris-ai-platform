<a id="top"></a>

# Introduction to Artificial Intelligence and Machine Learning

This module introduces core ideas in artificial intelligence (AI) and machine learning (ML): how systems learn from data, which families of algorithms exist, how models are evaluated, and how a trained model can move from experiment to a simple deployed service—with **Streamlit** as a practical choice for interactive visualization and lightweight apps.

---

## Table of contents

| # | Section | Jump |
|---|---------|------|
| 1 | [What is Artificial Intelligence?](#what-is-artificial-intelligence) | [↑](#what-is-artificial-intelligence) |
| 2 | [What is Machine Learning?](#what-is-machine-learning) | [↑](#what-is-machine-learning) |
| 3 | [Types of Learning](#types-of-learning-supervised-unsupervised-reinforcement) | [↑](#types-of-learning-supervised-unsupervised-reinforcement) |
| 4 | [Classic ML Algorithms](#classic-ml-algorithms) | [↑](#classic-ml-algorithms) |
| 5 | [The ML Pipeline from A to Z](#the-ml-pipeline-from-a-to-z) | [↑](#the-ml-pipeline-from-a-to-z) |
| 6 | [Evaluation Metrics](#evaluation-metrics-accuracy-precision-recall-f1-confusion-matrix) | [↑](#evaluation-metrics-accuracy-precision-recall-f1-confusion-matrix) |
| 7 | [Overfitting vs Underfitting](#overfitting-vs-underfitting) | [↑](#overfitting-vs-underfitting) |
| 8 | [Python Libraries for ML](#python-libraries-for-ml) | [↑](#python-libraries-for-ml) |
| 9 | [Concrete Example: Iris Classification](#concrete-example-iris-classification) | [↑](#concrete-example-iris-classification) |
| 10 | [From Model to Deployment](#from-model-to-deployment-joblib-fastapi-streamlit) | [↑](#from-model-to-deployment-joblib-fastapi-streamlit) |
| 11 | [ML Glossary](#ml-glossary) | [↑](#ml-glossary) |
| 12 | [Conclusion](#conclusion) | [↑](#conclusion) |

[Back to top](#top)

---

<a id="what-is-artificial-intelligence"></a>

## 1. What is Artificial Intelligence?

**Artificial Intelligence (AI)** is the field of computing focused on building systems that perform tasks that typically require human-like judgment: perception, reasoning, planning, language understanding, and decision-making under uncertainty.

Modern AI spans:

| Area | Typical tasks |
|------|----------------|
| **Symbolic / rule-based AI** | Expert systems, planners, knowledge bases |
| **Machine learning** | Predict labels, cluster data, recommend items |
| **Deep learning** | Images, speech, text at scale (neural networks) |
| **Generative AI** | Text, images, code synthesis from learned patterns |

AI does not imply “consciousness”; it means **automating useful behavior** using data, algorithms, and compute.

<details>
<summary>Why ML became central to AI</summary>

Many real-world problems are too messy for hand-written rules. **Machine learning** lets systems **infer patterns from examples** (data) instead of encoding every case explicitly. That shift made AI practical for spam filters, fraud detection, medical imaging aids, recommendation engines, and more.

</details>

[Back to top](#top)

---

<a id="what-is-machine-learning"></a>

## 2. What is Machine Learning?

**Machine learning** is a subset of AI where a **model** is built or adjusted using **data** so that it can make **predictions or decisions** on new, unseen inputs.

Key ingredients:

| Ingredient | Role |
|------------|------|
| **Data** | Examples the system learns from |
| **Features** | Measurable inputs (columns, pixels, tokens) |
| **Model** | Mathematical mapping from inputs to outputs |
| **Training** | Adjusting model parameters to reduce error |
| **Evaluation** | Measuring quality on held-out data |
| **Deployment** | Using the model in production (API, app, batch job) |

The goal is **generalization**: good performance on **new** data, not memorizing the training set.

[Back to top](#top)

---

<a id="types-of-learning-supervised-unsupervised-reinforcement"></a>

## 3. Types of Learning (Supervised, Unsupervised, Reinforcement)

### 3.1 Supervised learning

You have **input–output pairs** $(x, y)$. The model learns to predict $y$ from $x$.

| Task type | Output $y$ | Example |
|-----------|--------------|---------|
| **Classification** | Discrete label | Spam / not spam |
| **Regression** | Continuous value | House price |

### 3.2 Unsupervised learning

You have **inputs only** (no labels). The model finds **structure**: groups, low-dimensional representations, or anomalies.

| Task type | Goal | Example |
|-----------|------|---------|
| **Clustering** | Group similar points | Customer segments |
| **Dimensionality reduction** | Compress features | Visualization (2D projections) |

### 3.3 Reinforcement learning

An **agent** acts in an **environment**, receives **rewards** or penalties, and learns a **policy** (what action to take in each state) to maximize long-term reward. Common in games, robotics, and some recommendation/control settings.

```text
Supervised:     (x, y) pairs  →  learn f(x) ≈ y
Unsupervised:   x only        →  learn structure in x
Reinforcement:  states, actions, rewards  →  learn policy π(state) → action
```

[Back to top](#top)

---

<a id="classic-ml-algorithms"></a>

## 4. Classic ML Algorithms

The table below summarizes seven widely taught algorithms, typical problem types, and intuition.

| Algorithm | Learning type | Typical use | Core idea |
|-----------|---------------|-------------|-----------|
| **Linear regression** | Supervised (regression) | Predict continuous values | Fit a linear relationship between features and target |
| **Logistic regression** | Supervised (classification) | Binary / multiclass labels | Model class probabilities with a sigmoid / softmax |
| **k-Nearest Neighbors (k-NN)** | Supervised | Classification / regression | Predict from the $k$ closest training examples |
| **Decision tree** | Supervised | Classification / regression | Recursive splits on features (if–else rules) |
| **Random forest** | Supervised | Classification / regression | Ensemble of trees; reduces variance vs single tree |
| **Support Vector Machine (SVM)** | Supervised | Classification (often binary) | Find a margin-maximizing boundary (with kernels for non-linear data) |
| **k-Means** | Unsupervised | Clustering | Assign points to $k$ centroids; iterate until stable |

<details>
<summary><strong>Expand: What is "Supervised Learning"? (beginner-friendly)</strong></summary>

Imagine you are a child learning to recognize animals. Your parent **shows you pictures** and tells you: "this is a cat", "this is a dog". Over time, you learn to recognize them on your own. That is **supervised learning** &mdash; the model learns from **labeled examples** (data with known answers).

**Analogy**: A student studying with an answer key. They see the question, check the answer, and adjust their understanding.

The opposite &mdash; **unsupervised learning** &mdash; is like sorting a pile of random toys into groups without anyone telling you what the groups should be. The model discovers patterns on its own.

</details>

<details>
<summary><strong>Expand: Each algorithm explained like you're 10 years old</strong></summary>

#### Linear regression &mdash; Drawing the best straight line

You're at a fair. You notice: the taller the person, the more they weigh (roughly). **Linear regression** draws the **best straight line** through those points so you can guess someone's weight just by knowing their height.

> Real life: Predict apartment price from square meters, estimate electricity bill from consumption.

#### Logistic regression &mdash; Yes or no?

Despite the word "regression", this one **answers yes/no questions**. Should this email go to spam or not? Is this tumor benign or malignant?

It gives you a **probability** (e.g., 87 % chance it's spam) and then picks a side.

> Real life: Credit card approval (yes/no), disease screening (positive/negative).

#### Decision tree &mdash; Playing 20 questions

Remember the game "20 questions"? You ask yes/no questions to narrow down the answer. A decision tree does exactly that:

- Is the petal longer than 2.5 cm? &rarr; **No** &rarr; It's a **Setosa**
- **Yes** &rarr; Is the petal longer than 4.8 cm? &rarr; **Yes** &rarr; It's **Virginica**, etc.

> Real life: A doctor's diagnostic flowchart, a bank's loan approval process.

#### Random forest &mdash; Asking 100 friends and taking a vote

One friend might give you bad advice. But if you ask **100 friends** the same question and take the **majority vote**, you'll almost always get the right answer. A **random forest** is just that: many decision trees voting together.

> Real life: Fraud detection, recommendation systems, medical diagnosis.

#### k-NN (k-Nearest Neighbors) &mdash; Look at your neighbors

You move to a new neighborhood. You don't know if it's a quiet area. So you **look at the 5 nearest houses** &mdash; if 4 out of 5 are quiet families, you conclude it's probably a quiet area. k-NN does the same: it classifies new data by looking at the **k closest known examples**.

> Real life: "Customers who bought this also bought&hellip;", handwriting recognition.

#### SVM (Support Vector Machine) &mdash; Drawing the widest possible road

Imagine red dots and blue dots on a table. You want to draw a line separating them. SVM draws the line that leaves the **widest gap** (margin) between the two groups, making it the most robust separator.

> Real life: Text classification (positive vs negative reviews), image classification.

#### Neural networks &mdash; A brain made of math

Inspired by the human brain. Thousands of tiny "neurons" connected in **layers**. Each neuron does a simple calculation, but together they can learn incredibly complex things: recognize faces, translate languages, drive cars.

> Real life: Voice assistants (Siri, Alexa), self-driving cars, ChatGPT.

</details>

<details>
<summary>How to choose among them (high level)</summary>

- **Interpretability**: Trees and linear/logistic models are often easier to explain than deep nets or opaque ensembles.
- **Data size**: k-NN can be slow at prediction time on large datasets; linear models scale well.
- **Non-linearity**: Kernels (SVM), tree ensembles, or neural networks handle non-linear patterns; linear models need feature engineering.
- **No labels**: Use **k-Means** or other clustering when you only have $x$.

</details>

[Back to top](#top)

---

<a id="the-ml-pipeline-from-a-to-z"></a>

## 5. The ML Pipeline from A to Z

An end-to-end ML workflow connects business goals, data work, modeling, validation, and release.

```mermaid
flowchart LR
  A[Problem framing] --> B[Data collection]
  B --> C[Exploration and cleaning]
  C --> D[Feature engineering]
  D --> E[Train / validation / test split]
  E --> F[Model selection and training]
  F --> G[Evaluation and error analysis]
  G --> H{Good enough?}
  H -->|No| D
  H -->|Yes| I[Deployment and monitoring]
  I --> J[Retrain / iterate]
  J --> B
```

| Stage | What you do |
|-------|-------------|
| **Problem framing** | Define the target, constraints, and success metrics |
| **Data** | Collect, document, clean, handle missing values and outliers |
| **Features** | Scale, encode categories, create derived variables |
| **Split** | Hold out test data; use validation for tuning |
| **Training** | Fit models; tune hyperparameters |
| **Evaluation** | Metrics, confusion matrix, calibration, fairness checks as needed |
| **Deployment** | Package model, expose API or UI, log predictions, monitor drift |

[Back to top](#top)

---

<a id="evaluation-metrics-accuracy-precision-recall-f1-confusion-matrix"></a>

## 6. Evaluation Metrics (Accuracy, Precision, Recall, F1, Confusion Matrix)

For **binary classification**, start from the **confusion matrix**:

| | Predicted positive | Predicted negative |
|--|-------------------|-------------------|
| **Actual positive** | True Positive (TP) | False Negative (FN) |
| **Actual negative** | False Positive (FP) | True Negative (TN) |

Definitions (binary case):

| Metric | Formula | Meaning |
|--------|---------|---------|
| **Accuracy** | $\frac{TP + TN}{TP + TN + FP + FN}$ | Fraction of all correct predictions |
| **Precision** | $\frac{TP}{TP + FP}$ | Of predicted positives, how many were correct |
| **Recall** (sensitivity) | $\frac{TP}{TP + FN}$ | Of actual positives, how many were found |
| **F1-score** | $2 \cdot \frac{\text{Precision} \cdot \text{Recall}}{\text{Precision} + \text{Recall}}$ | Harmonic mean of precision and recall |

<details>
<summary><strong>Expand: Understanding metrics with a real-life COVID testing example</strong></summary>

Imagine a clinic tests **8 people** for COVID. Here's the reality and what the test says:

| Person | Actually has COVID? | Test result |
|--------|-------------------|-------------|
| Alice | **Yes** | **Positive** &check; |
| Bob | **Yes** | **Positive** &check; |
| Carol | **Yes** | **Negative** &cross; |
| Dave | No | Negative &check; |
| Eve | No | Negative &check; |
| Frank | No | Negative &check; |
| Grace | No | **Positive** &cross; |
| Hank | No | Negative &check; |

From these 8 results:

| | Predicted Positive | Predicted Negative |
|--|---|---|
| **Actually Positive** | **TP = 2** (Alice, Bob) | **FN = 1** (Carol) |
| **Actually Negative** | **FP = 1** (Grace) | **TN = 4** (Dave, Eve, Frank, Hank) |

**What does each cell mean in plain English?**

- **TP (True Positive) = 2** &mdash; Alice and Bob really have COVID and the test correctly says "positive". The test **got it right**.
- **TN (True Negative) = 4** &mdash; Dave, Eve, Frank, and Hank don't have COVID and the test correctly says "negative". The test **got it right** again.
- **FP (False Positive) = 1** &mdash; Grace does **NOT** have COVID, but the test wrongly says "positive". This is a **false alarm**. Think of it like a pregnancy test saying "pregnant" when the woman is **not** pregnant. Scary and stressful for nothing!
- **FN (False Negative) = 1** &mdash; Carol **DOES** have COVID, but the test wrongly says "negative". This is the **most dangerous** error: Carol thinks she's healthy, goes out, and infects others.

**Now let's compute the metrics:**

- **Accuracy** = (2 + 4) / 8 = **75 %** &mdash; 6 out of 8 results are correct. Sounds OK, but is it good enough?
- **Precision** = 2 / (2 + 1) = **66.7 %** &mdash; Of the 3 people the test flagged as positive, only 2 actually had COVID. 1 in 3 positive results is a false alarm.
- **Recall** = 2 / (2 + 1) = **66.7 %** &mdash; Of the 3 people who actually had COVID, the test only caught 2. It **missed** Carol.
- **F1-score** = 2 &times; (0.667 &times; 0.667) / (0.667 + 0.667) = **66.7 %** &mdash; The balance between precision and recall.

**Why does this matter?**

| Situation | What's worse? | Which metric to watch? |
|-----------|--------------|----------------------|
| **COVID / disease screening** | Missing a sick person (FN) | **Recall** must be very high |
| **Spam filter** | Sending important email to spam (FP) | **Precision** must be high |
| **Pregnancy test** | Saying "pregnant" when not (FP) = anxiety; Saying "not pregnant" when pregnant (FN) = missed care | Both matter, use **F1** |
| **Airport security** | Letting a threat through (FN) | **Recall** is critical |

> **Key insight**: A model with 99 % accuracy can still be terrible. If only 1 % of people have a disease and your model always says "healthy", it's 99 % accurate but **catches zero sick people** (recall = 0 %).

</details>

**When accuracy misleads**: Imbalanced classes (e.g., 99% negatives) can yield high accuracy with a useless model. Prefer **precision/recall/F1** or **ROC-AUC / PR-AUC**, and always inspect the **confusion matrix**.

For **multiclass** problems, metrics are often averaged per class (**macro**), weighted by support (**weighted**), or computed **per class** then summarized.

[Back to top](#top)

---

<a id="overfitting-vs-underfitting"></a>

## 7. Overfitting vs Underfitting

| Concept | What happens | Typical signals | Mitigations |
|---------|--------------|-----------------|-------------|
| **Underfitting** | Model too simple to capture patterns | High error on train and test | Richer model, better features, train longer (if under-trained) |
| **Overfitting** | Model memorizes noise in training data | Low train error, high test error | More data, regularization, simpler model, cross-validation, early stopping |

```text
Underfitting:  high bias  — oversimplified
Overfitting:   high variance — too sensitive to training noise
```

**Bias–variance tradeoff**: Reducing bias often increases variance and vice versa; the aim is a model that **generalizes**.

<details>
<summary><strong>Expand: Overfitting &amp; Underfitting explained for complete beginners</strong></summary>

Think of a **student studying for an exam**.

#### Underfitting &mdash; The student who barely opened the book

They glanced at the chapter titles but never read the content. On exam day, they can't answer **anything** &mdash; neither the questions from the textbook nor the new ones.

> **In ML terms**: the model is too simple. It hasn't learned the patterns in the training data, so it performs badly on everything.

#### Overfitting &mdash; The student who memorized the answer key

They memorized every single answer from past exams **word for word**, including the typos. When the professor changes even a small detail, they're lost.

> **In ML terms**: the model is too complex. It memorized the training data (including the noise and outliers), so it scores perfectly on training data but fails on new data.

#### The sweet spot &mdash; The student who truly understands

They studied the concepts and can answer questions they've **never seen before**, because they learned the underlying logic, not just the examples.

**Real-world analogy**:

| Situation | Underfitting | Overfitting | Good fit |
|-----------|-------------|-------------|----------|
| **Learning to cook** | Only knows "heat food" | Memorized one exact recipe to the gram &mdash; can't adapt if an ingredient is missing | Understands cooking principles &mdash; can improvise |
| **GPS navigation** | Always says "go straight" | Memorized one exact route &mdash; crashes if there's a detour | Knows the road network &mdash; finds alternatives |
| **Spam filter** | Lets all emails through | Blocks everything that has the word "free" (even legitimate emails) | Detects real spam patterns without blocking normal emails |

</details>

<details>
<summary>Practical checks</summary>

- Compare **train vs validation** curves.
- Use **cross-validation** for more stable estimates than a single split.
- Keep a **held-out test set** untouched until final reporting.

</details>

[Back to top](#top)

---

<a id="python-libraries-for-ml"></a>

## 8. Python Libraries for ML

| Library | Role |
|---------|------|
| **NumPy** | N-dimensional arrays, linear algebra |
| **pandas** | Tabular data, cleaning, aggregation |
| **scikit-learn** | Classical ML algorithms, preprocessing, pipelines, metrics |
| **matplotlib / seaborn** | Static plots and statistical visuals |
| **Streamlit** | **Rapid interactive web apps** for dashboards, model demos, and **visual exploration of data and predictions** without building a full front-end |
| **joblib** | Efficient serialization of Python objects (common for saving sklearn models) |
| **FastAPI** | Modern API framework to serve predictions behind HTTP |

**Streamlit** is especially useful when you want stakeholders to **upload a CSV, tweak a threshold, or see metrics and charts** in the browser while your model logic stays in Python.

<details>
<summary><strong>Expand: Model saving formats &mdash; joblib, pickle, .h5, .keras, ONNX, SavedModel, safetensors, PMML</strong></summary>

After training a model, you need to **save it to disk** so you can reload it later for predictions without retraining. There are many formats &mdash; here's a complete comparison for 2026:

### Quick comparison table

| Format | Extension | Framework | Best for | Still relevant in 2026? |
|--------|-----------|-----------|----------|------------------------|
| **joblib** | `.joblib` `.pkl` | scikit-learn | Small/medium sklearn models | **Yes** &mdash; standard for sklearn |
| **pickle** | `.pkl` `.pickle` | Python (any) | Any Python object | Yes, but security risks |
| **ONNX** | `.onnx` | Cross-framework | Production, multi-language deployment | **Yes** &mdash; growing fast |
| **HDF5 (legacy Keras)** | `.h5` | Old Keras/TF1 | Legacy projects | **Deprecated** &mdash; avoid for new projects |
| **.keras** | `.keras` | Keras 3+ / TF 2.16+ | Keras models (new standard) | **Yes** &mdash; official Keras format |
| **SavedModel** | folder | TensorFlow | TF Serving, TFLite, TF.js | **Yes** &mdash; TF ecosystem standard |
| **safetensors** | `.safetensors` | Hugging Face / PyTorch | LLMs, large models, safe loading | **Yes** &mdash; rapidly becoming the standard for LLMs |
| **TorchScript** | `.pt` `.pth` | PyTorch | PyTorch production | **Yes** &mdash; PyTorch standard |
| **PMML** | `.pmml` | Cross-platform (XML) | Enterprise / Java systems | Niche &mdash; mostly legacy enterprise |

### Detailed breakdown

#### joblib &mdash; The sklearn standard

```python
import joblib

# Save
joblib.dump(model, "model.joblib")

# Load
model = joblib.load("model.joblib")
```

| Pros | Cons |
|------|------|
| Extremely simple (2 lines) | Python-only (can't load in Java, C++, etc.) |
| Efficient with large NumPy arrays | Not secure with untrusted files (arbitrary code execution) |
| De facto standard for scikit-learn | No cross-framework support |

#### pickle &mdash; Python's built-in serialization

```python
import pickle

with open("model.pkl", "wb") as f:
    pickle.dump(model, f)
```

| Pros | Cons |
|------|------|
| Built into Python, no extra dependency | **Security risk**: loading a pickle can execute arbitrary code |
| Works with any Python object | Not portable across Python versions |
| | Slower than joblib for large arrays |

> **Warning**: Never load a pickle file from an untrusted source. It can run malicious code on your machine.

#### .h5 (HDF5) &mdash; Legacy Keras format

```python
# OLD way (Keras < 3 / TF < 2.16)
model.save("model.h5")
model = keras.models.load_model("model.h5")
```

| Pros | Cons |
|------|------|
| Was the standard for years | **Deprecated since Keras 3** (2024) |
| Widely documented in tutorials | Doesn't support all new Keras features |
| | Large file sizes for big models |

> **In 2026**: Only use `.h5` if you're maintaining a legacy project. For new projects, use `.keras`.

#### .keras &mdash; The new Keras 3 standard

```python
# NEW way (Keras 3+ / TF 2.16+)
model.save("model.keras")
model = keras.models.load_model("model.keras")
```

| Pros | Cons |
|------|------|
| Official format since Keras 3 | Relatively new, fewer tutorials |
| Supports all Keras 3 features | Keras-specific |
| ZIP-based, includes config + weights | |

#### ONNX &mdash; The universal translator

```python
# Convert sklearn model to ONNX
from skl2onnx import convert_sklearn
from skl2onnx.common.data_types import FloatTensorType

initial_type = [("input", FloatTensorType([None, 4]))]
onnx_model = convert_sklearn(model, initial_types=initial_type)

with open("model.onnx", "wb") as f:
    f.write(onnx_model.SerializeToString())
```

| Pros | Cons |
|------|------|
| **Cross-language**: load in Python, C++, Java, C#, JavaScript | Conversion step needed |
| **Cross-framework**: from sklearn, PyTorch, TF, etc. | Not all operations supported |
| Optimized inference (ONNX Runtime) | Less flexible than native formats |
| Hardware acceleration (GPU, edge devices) | |

> **In 2026**: ONNX is the go-to choice for production deployment across different languages and platforms.

#### SavedModel &mdash; TensorFlow's ecosystem format

```python
# TensorFlow
model.save("saved_model_dir")  # saves a folder
model = tf.keras.models.load_model("saved_model_dir")
```

| Pros | Cons |
|------|------|
| TF Serving, TFLite, TF.js integration | TensorFlow-only |
| Supports signatures for serving | Saves a folder, not a single file |
| Production-grade | Large for small models |

#### safetensors &mdash; The safe and fast format for large models

```python
from safetensors.torch import save_file, load_file

# Save
save_file(model.state_dict(), "model.safetensors")

# Load
state_dict = load_file("model.safetensors")
model.load_state_dict(state_dict)
```

| Pros | Cons |
|------|------|
| **Secure**: no arbitrary code execution (unlike pickle) | Stores only tensors (not full model architecture) |
| **Fast**: memory-mapped, zero-copy loading | Need to reconstruct model architecture separately |
| Standard for Hugging Face models / LLMs | Newer, less universal |

> **In 2026**: safetensors has become the default for LLMs and Hugging Face models.

### What should YOU use?

| Your situation | Recommended format |
|---------------|-------------------|
| scikit-learn model (our Iris project) | **joblib** |
| Keras / TensorFlow model | **.keras** (not .h5!) |
| PyTorch model | **safetensors** or `.pt` |
| Deploy to production (multi-language) | **ONNX** |
| Hugging Face / LLM | **safetensors** |
| Legacy project with .h5 files | Keep .h5, migrate when possible |

</details>


[Back to top](#top)

---

<a id="concrete-example-iris-classification"></a>

## 9. Concrete Example: Iris Classification

The **Iris** dataset predicts one of three flower species from four numeric measurements (sepal/petal length and width). It is the standard teaching example for multiclass classification.

```python
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix

X, y = load_iris(return_X_y=True)
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

clf = Pipeline(
    steps=[
        ("scaler", StandardScaler()),
        ("model", LogisticRegression(max_iter=200)),
    ]
)
clf.fit(X_train, y_train)
y_pred = clf.predict(X_test)

print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))
```

This pattern—**split → pipeline (preprocess + model) → fit → predict → report**—applies to many real projects.

[Back to top](#top)

---

<a id="from-model-to-deployment-joblib-fastapi-streamlit"></a>

## 10. From Model to Deployment (joblib, FastAPI, Streamlit)

### 10.1 Saving the model with joblib

```python
import joblib

joblib.dump(clf, "iris_model.joblib")
loaded = joblib.load("iris_model.joblib")
```

### 10.2 Serving predictions with FastAPI (sketch)

```python
from fastapi import FastAPI
import joblib
import numpy as np

app = FastAPI()
model = joblib.load("iris_model.joblib")

@app.post("/predict")
def predict(features: list[float]):
    x = np.array(features, dtype=float).reshape(1, -1)
    pred = int(model.predict(x)[0])
    return {"species_id": pred}
```

### 10.3 Streamlit for a simple UI

**Streamlit** can call the same loaded model (or call your FastAPI endpoint) and display inputs, predictions, and charts in a few dozen lines—ideal for **prototypes, teaching, and internal tools**.

```python
import streamlit as st
import joblib
import numpy as np

st.title("Iris classifier demo")
model = joblib.load("iris_model.joblib")

sepal_l = st.number_input("Sepal length (cm)", value=5.1)
sepal_w = st.number_input("Sepal width (cm)", value=3.5)
petal_l = st.number_input("Petal length (cm)", value=1.4)
petal_w = st.number_input("Petal width (cm)", value=0.2)

if st.button("Predict"):
    x = np.array([[sepal_l, sepal_w, petal_l, petal_w]])
    pred = model.predict(x)[0]
    st.success(f"Predicted class index: {pred}")
```

| Layer | Tool | Purpose |
|-------|------|---------|
| Artifact | **joblib** | Persist trained pipeline |
| API | **FastAPI** | Machine-to-machine predictions |
| UI / viz | **Streamlit** | Human-friendly exploration and demos |

[Back to top](#top)

---

<a id="ml-glossary"></a>

## 11. ML Glossary

<details>
<summary>Expand glossary (A–Z selection)</summary>

| Term | Short definition |
|------|------------------|
| **Algorithm** | Procedure used to train or optimize a model |
| **Batch inference** | Running the model on many inputs at once (offline) |
| **Cross-validation** | Repeated train/validate splits to estimate performance |
| **Feature** | One measurable input to the model |
| **Generalization** | Performance on new data not used in training |
| **Hyperparameter** | Setting chosen before training (e.g., $k$ in k-NN) |
| **Inference** | Using a trained model to make predictions |
| **Label** | Target output in supervised learning |
| **Loss function** | Quantity minimized during training |
| **Model** | Learned mapping from inputs to outputs |
| **Overfitting** | Memorizing training noise; poor test performance |
| **Parameter** | Values learned during training (e.g., weights) |
| **Pipeline** | Chained preprocessing + model steps |
| **Regularization** | Penalty that discourages overly complex fits |
| **Train / validation / test** | Splits for fitting, tuning, and final evaluation |

</details>

[Back to top](#top)

---

<a id="conclusion"></a>

## 12. Conclusion

You now have a map of **AI vs ML**, the three major **learning paradigms**, a set of **classic algorithms**, a full **ML pipeline** mindset, core **evaluation metrics** including the **confusion matrix**, intuition for **overfitting and underfitting**, and a practical Python stack where **Streamlit** complements libraries like **scikit-learn** for **visualization and lightweight deployment**.

Next steps in a course track: dive deeper into **preprocessing and pipelines**, **model selection and cross-validation**, **imbalanced data**, and **responsible ML** (privacy, fairness, monitoring).

[Back to top](#top)

---

_End of module: Introduction to Artificial Intelligence and Machine Learning._
