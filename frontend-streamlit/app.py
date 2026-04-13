import streamlit as st
import requests
import json

API_BASE_URL = "http://localhost:8000"

st.set_page_config(
    page_title="Iris ML Demo",
    page_icon="🌸",
    layout="wide",
    initial_sidebar_state="expanded",
)


def check_api():
    try:
        r = requests.get(f"{API_BASE_URL}/health", timeout=3)
        return r.status_code == 200 and r.json().get("status") == "healthy"
    except Exception:
        return False


def predict(sepal_length, sepal_width, petal_length, petal_width):
    payload = {
        "sepal_length": sepal_length,
        "sepal_width": sepal_width,
        "petal_length": petal_length,
        "petal_width": petal_width,
    }
    r = requests.post(f"{API_BASE_URL}/predict", json=payload)
    r.raise_for_status()
    return r.json()


def get_model_info():
    r = requests.get(f"{API_BASE_URL}/model/info")
    r.raise_for_status()
    return r.json()


def get_dataset_samples():
    r = requests.get(f"{API_BASE_URL}/dataset/samples")
    r.raise_for_status()
    return r.json()


def get_dataset_stats():
    r = requests.get(f"{API_BASE_URL}/dataset/stats")
    r.raise_for_status()
    return r.json()


SPECIES_COLORS = {
    "setosa": "#4CAF50",
    "versicolor": "#2196F3",
    "virginica": "#9C27B0",
}

SPECIES_EMOJIS = {
    "setosa": "🌸",
    "versicolor": "🌺",
    "virginica": "🌷",
}

# --- Sidebar ---
with st.sidebar:
    st.title("🌸 Iris ML Demo")
    st.caption("Application Full-Stack de classification de fleurs Iris")

    api_ok = check_api()
    if api_ok:
        st.success("✅ API connectée")
    else:
        st.error("❌ API hors ligne — Lancez le backend FastAPI sur le port 8000")

    st.divider()
    page = st.radio(
        "Navigation",
        ["🔬 Prédiction", "🧠 Modèle", "📊 Dataset"],
        label_visibility="collapsed",
    )

# --- Page: Prédiction ---
if page == "🔬 Prédiction":
    st.header("🔬 Prédiction d'espèce")
    st.markdown("Ajustez les mesures de la fleur pour identifier son espèce.")

    col1, col2 = st.columns(2)

    with col1:
        st.subheader("Sépales")
        sepal_length = st.slider("Longueur du sépale (cm)", 4.0, 8.0, 5.1, 0.1)
        sepal_width = st.slider("Largeur du sépale (cm)", 2.0, 4.5, 3.5, 0.1)

    with col2:
        st.subheader("Pétales")
        petal_length = st.slider("Longueur du pétale (cm)", 1.0, 7.0, 1.4, 0.1)
        petal_width = st.slider("Largeur du pétale (cm)", 0.1, 2.5, 0.2, 0.1)

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

                    emoji = SPECIES_EMOJIS.get(species, "🌼")
                    color = SPECIES_COLORS.get(species, "#666")

                    st.divider()

                    res_col1, res_col2 = st.columns([1, 2])

                    with res_col1:
                        st.markdown(
                            f"<div style='text-align:center;padding:20px;'>"
                            f"<span style='font-size:80px;'>{emoji}</span><br/>"
                            f"<span style='font-size:32px;font-weight:bold;color:{color};'>"
                            f"{species.upper()}</span><br/>"
                            f"<span style='background:{color}22;color:{color};"
                            f"padding:6px 16px;border-radius:20px;font-weight:600;'>"
                            f"Confiance : {confidence*100:.1f}%</span>"
                            f"</div>",
                            unsafe_allow_html=True,
                        )

                    with res_col2:
                        st.subheader("Probabilités par espèce")
                        for name, prob in probabilities.items():
                            c = SPECIES_COLORS.get(name, "#666")
                            st.markdown(
                                f"**:{name}** — `{prob*100:.1f}%`"
                            )
                            st.progress(prob)

                except Exception as e:
                    st.error(f"Erreur : {e}")

# --- Page: Modèle ---
elif page == "🧠 Modèle":
    st.header("🧠 Informations sur le modèle")

    if not api_ok:
        st.error("L'API n'est pas accessible.")
    else:
        try:
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

            st.divider()

            left, right = st.columns(2)

            with left:
                st.subheader("Importance des features")
                sorted_features = sorted(
                    info["feature_importances"].items(),
                    key=lambda x: x[1],
                    reverse=True,
                )
                for feat, imp in sorted_features:
                    st.markdown(f"**{feat}** — `{imp*100:.1f}%`")
                    st.progress(imp)

            with right:
                st.subheader("Classes cibles")
                for name in info["target_names"]:
                    emoji = SPECIES_EMOJIS.get(name, "🌼")
                    color = SPECIES_COLORS.get(name, "#666")
                    st.markdown(
                        f"<span style='font-size:24px;'>{emoji}</span> "
                        f"<span style='color:{color};font-weight:bold;font-size:18px;'>"
                        f"{name.capitalize()}</span>",
                        unsafe_allow_html=True,
                    )

                st.divider()
                st.subheader("Features utilisées")
                for feat in info["feature_names"]:
                    st.markdown(f"- `{feat}`")

        except Exception as e:
            st.error(f"Erreur : {e}")

# --- Page: Dataset ---
elif page == "📊 Dataset":
    st.header("📊 Exploration du Dataset")

    if not api_ok:
        st.error("L'API n'est pas accessible.")
    else:
        try:
            stats = get_dataset_stats()

            col1, col2, col3 = st.columns(3)
            with col1:
                st.metric("Échantillons", stats["total_samples"])
            with col2:
                st.metric("Features", stats["features_count"])
            with col3:
                st.metric("Espèces", stats["species_count"])

            st.divider()

            left, right = st.columns(2)

            with left:
                st.subheader("Distribution par espèce")
                dist = stats["species_distribution"]
                total = sum(dist.values())
                for name, count in dist.items():
                    color = SPECIES_COLORS.get(name, "#666")
                    pct = count / total * 100
                    st.markdown(
                        f"<span style='color:{color};font-weight:bold;'>"
                        f"● {name.capitalize()}</span> — {count} ({pct:.0f}%)",
                        unsafe_allow_html=True,
                    )
                    st.progress(count / total)

            with right:
                st.subheader("Statistiques des features")
                feat_stats = stats["feature_stats"]
                import pandas as pd

                df_stats = pd.DataFrame(feat_stats).T
                df_stats.columns = ["Min", "Max", "Moyenne", "Écart-type"]
                st.dataframe(df_stats, use_container_width=True)

            st.divider()

            st.subheader("Échantillons aléatoires")
            if st.button("🔄 Charger de nouveaux échantillons", use_container_width=True):
                st.rerun()

            samples = get_dataset_samples()
            import pandas as pd

            df_samples = pd.DataFrame(samples)
            df_samples.columns = ["Sép. Longueur", "Sép. Largeur", "Pét. Longueur", "Pét. Largeur", "Espèce"]

            st.dataframe(
                df_samples.style.apply(
                    lambda row: [
                        f"color: {SPECIES_COLORS.get(row['Espèce'], '#666')}"
                    ] * len(row),
                    axis=1,
                ),
                use_container_width=True,
                hide_index=True,
            )

        except Exception as e:
            st.error(f"Erreur : {e}")
