import streamlit as st
import pandas as pd

# ANALYSE 1 :

st.title("Analyse 1 : 🏆 Top 10 des titres de postes les plus publiés par industrie")

conn = st.connection("snowflake")
session = conn.session()

queried_data = session.sql("""
    SELECT 
        ji.industry_id AS industry,
        jp.title,
        COUNT(*) AS nb_offres
    FROM linkedin.raw.job_postings jp
    JOIN linkedin.raw.job_industries ji ON jp.job_id = ji.job_id
    WHERE jp.title IS NOT NULL
    GROUP BY ji.industry_id, jp.title
    QUALIFY ROW_NUMBER() OVER (PARTITION BY ji.industry_id ORDER BY COUNT(*) DESC) <= 10
    ORDER BY ji.industry_id, nb_offres DESC
""")

df = queried_data.to_pandas()

industries = df["INDUSTRY"].unique().tolist()
industrie_choisie = st.selectbox("Choisissez une industrie :", industries)

df_filtre = df[df["INDUSTRY"] == industrie_choisie].reset_index(drop=True)

st.subheader(f"Top 10 pour : {industrie_choisie}")
st.bar_chart(data=df_filtre, x="TITLE", y="NB_OFFRES")

st.subheader("Données détaillées")
st.dataframe(df_filtre[["TITLE", "NB_OFFRES"]])

# ANALYSE 2 :
 
st.title("Analyse 2 : 💰 Top 10 des postes les mieux rémunérés par industrie")
 
conn = st.connection("snowflake")
session = conn.session()
 
queried_data = session.sql("""
    SELECT
        ji.industry_id AS industry,
        jp.title,
        ROUND(AVG(jp.med_salary), 0) AS salaire_median_moyen
    FROM linkedin.raw.job_postings jp
    JOIN linkedin.raw.job_industries ji ON jp.job_id = ji.job_id
    WHERE jp.title IS NOT NULL
      AND jp.med_salary IS NOT NULL
      AND jp.pay_period = 'YEARLY'
    GROUP BY ji.industry_id, jp.title
    QUALIFY ROW_NUMBER() OVER (PARTITION BY ji.industry_id ORDER BY AVG(jp.med_salary) DESC) <= 10
    ORDER BY ji.industry_id, salaire_median_moyen DESC
""")
 
df = queried_data.to_pandas()
 
industries = df["INDUSTRY"].unique().tolist()
industrie_choisie = st.selectbox("Choisissez une industrie :", industries)
 
df_filtre = df[df["INDUSTRY"] == industrie_choisie].reset_index(drop=True)
 
st.subheader(f"Top 10 pour : {industrie_choisie}")
st.bar_chart(data=df_filtre, x="TITLE", y="SALAIRE_MEDIAN_MOYEN")
 
st.subheader("Données détaillées")
st.dataframe(df_filtre[["TITLE", "SALAIRE_MEDIAN_MOYEN"]])

# ANALYSE 3 :

import streamlit as st

conn = st.connection("snowflake")
session = conn.session()

st.title("Analyse 3 : 🏢 Répartition des offres d'emploi par taille d'entreprise")

queried_data = session.sql("""
    SELECT 
        CASE c.company_size
            WHEN 0 THEN '0 - 1 employé'
            WHEN 1 THEN '1 - 10 employés'
            WHEN 2 THEN '11 - 50 employés'
            WHEN 3 THEN '51 - 200 employés'
            WHEN 4 THEN '201 - 500 employés'
            WHEN 5 THEN '501 - 1000 employés'
            WHEN 6 THEN '1001 - 5000 employés'
            WHEN 7 THEN '5000+ employés'
            ELSE 'Non renseigné'
        END AS taille_entreprise,
        COUNT(*) AS nb_offres
    FROM linkedin.raw.job_postings jp
    JOIN linkedin.raw.companies c 
        ON TRY_TO_NUMBER(jp.company_name) = c.company_id
    WHERE c.company_size IS NOT NULL
    GROUP BY c.company_size, taille_entreprise
    ORDER BY c.company_size
""")

df = queried_data.to_pandas()

st.subheader("Graphique")
st.bar_chart(data=df, x="TAILLE_ENTREPRISE", y="NB_OFFRES")

st.subheader("Données détaillées")
st.dataframe(df[["TAILLE_ENTREPRISE", "NB_OFFRES"]]) 
 
# Analyse 4 : 

st.title("Analyse 4 : 🏭 Répartition des offres d'emploi par secteur d'activité")

queried_data = session.sql("""
    SELECT
        ci.industry AS secteur,
        COUNT(*) AS nb_offres
    FROM linkedin.raw.job_postings jp
    JOIN linkedin.raw.companies c 
        ON TRY_TO_NUMBER(jp.company_name) = c.company_id
    JOIN linkedin.raw.company_industries ci 
        ON c.company_id = ci.company_id
    WHERE ci.industry IS NOT NULL
    GROUP BY ci.industry
    ORDER BY nb_offres DESC
""")

df = queried_data.to_pandas()

st.subheader("Graphique")
st.bar_chart(data=df, x="SECTEUR", y="NB_OFFRES")

st.subheader("Données détaillées")
st.dataframe(df[["SECTEUR", "NB_OFFRES"]])

# Analyse 5 : 

conn = st.connection("snowflake")
session = conn.session()

st.title("Analyse 5 : 💼 Répartition des offres d'emploi par type d'emploi")

queried_data = session.sql("""
    SELECT 
        formatted_work_type AS type_emploi,
        COUNT(*) AS nb_offres
    FROM linkedin.raw.job_postings
    WHERE formatted_work_type IS NOT NULL
    GROUP BY formatted_work_type
    ORDER BY nb_offres DESC
""")

df = queried_data.to_pandas()

st.subheader("Graphique")
st.bar_chart(data=df, x="TYPE_EMPLOI", y="NB_OFFRES")

st.subheader("Données détaillées")
st.dataframe(df[["TYPE_EMPLOI", "NB_OFFRES"]])