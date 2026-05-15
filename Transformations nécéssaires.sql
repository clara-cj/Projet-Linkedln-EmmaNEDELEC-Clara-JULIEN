-- 1.Modification pour une date plus compréhensible :

UPDATE linkedin.raw.employee_counts
SET time_recorded_date = TO_TIMESTAMP(time_recorded::NUMBER)
WHERE time_recorded IS NOT NULL;
-- Vérification
SELECT time_recorded, time_recorded_date 
FROM linkedin.raw.employee_counts 
LIMIT 5;

-- 2.Associer '1.0','1','True','true' en TRUE et toutes les autres valeurs en FALSE :

ALTER TABLE linkedin.raw.job_postings
  ADD COLUMN is_remote BOOLEAN;

UPDATE linkedin.raw.job_postings
SET is_remote = CASE
  WHEN remote_allowed IN ('1', '1.0', 'True', 'true') THEN TRUE
  ELSE FALSE
END;
-- Vérification
SELECT remote_allowed, is_remote, COUNT(*) FROM linkedin.raw.job_postings
GROUP BY remote_allowed, is_remote;


-- 3.On modifie les colones concernant les salaires pour qu'elles soient des nombres et pas du texte :
-- Ajouter des colonnes numériques pour les salaires
ALTER TABLE linkedin.raw.job_postings ADD COLUMN max_salary_num FLOAT;
ALTER TABLE linkedin.raw.job_postings ADD COLUMN min_salary_num FLOAT;
ALTER TABLE linkedin.raw.job_postings ADD COLUMN med_salary_num FLOAT;

UPDATE linkedin.raw.job_postings
SET
  max_salary_num = TRY_TO_DOUBLE(max_salary),
  min_salary_num = TRY_TO_DOUBLE(min_salary),
  med_salary_num = TRY_TO_DOUBLE(med_salary);

-- Vérification
SELECT max_salary, max_salary_num FROM linkedin.raw.job_postings
WHERE max_salary IS NOT NULL LIMIT 5;

-- 4.Vérifier les valeurs NULL dans la table job_postings, job_industries et companies car ces tables vont être utiles pour les analyses 
-- Job_postings :
SELECT
  COUNT(*)                                                    AS total,
  SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END)             AS null_title,
  SUM(CASE WHEN company_name IS NULL THEN 1 ELSE 0 END)      AS null_company,
  SUM(CASE WHEN location IS NULL THEN 1 ELSE 0 END)          AS null_location,
  SUM(CASE WHEN max_salary_num IS NULL THEN 1 ELSE 0 END)    AS null_salary,
  SUM(CASE WHEN formatted_work_type IS NULL THEN 1 ELSE 0 END) AS null_work_type
FROM linkedin.raw.job_postings;

-- Job_industries:
SELECT
  COUNT(*)                                                    AS total,
  SUM(CASE WHEN job_id IS NULL THEN 1 ELSE 0 END)            AS null_job_id,
  SUM(CASE WHEN industry_id IS NULL THEN 1 ELSE 0 END)       AS null_industry_id
FROM linkedin.raw.job_industries;

-- Companies :
SELECT
  COUNT(*)                                                    AS total,
  SUM(CASE WHEN company_id IS NULL THEN 1 ELSE 0 END)        AS null_company_id,
  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END)              AS null_name,
  SUM(CASE WHEN company_size IS NULL THEN 1 ELSE 0 END)      AS null_company_size,
  SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END)           AS null_country
FROM linkedin.raw.companies;