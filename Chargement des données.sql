SHOW TABLES IN SCHEMA linkedin.raw;
USE SCHEMA linkedin.raw;

COPY INTO linkedin.raw.job_postings
FROM @linkedin.public.s3_linkedin_stage/job_postings.csv
FILE_FORMAT = (FORMAT_NAME = 'linkedin.public.csv_format')
ON_ERROR = 'CONTINUE';

COPY INTO linkedin.raw.benefits
FROM @linkedin.public.s3_linkedin_stage/benefits.csv
FILE_FORMAT = (FORMAT_NAME = 'linkedin.public.csv_format')
ON_ERROR = 'CONTINUE';

COPY INTO linkedin.raw.employee_counts
FROM @linkedin.public.s3_linkedin_stage/employee_counts.csv
FILE_FORMAT = (FORMAT_NAME = 'linkedin.public.csv_format')
ON_ERROR = 'CONTINUE';

COPY INTO linkedin.raw.job_skills
FROM @linkedin.public.s3_linkedin_stage/job_skills.csv
FILE_FORMAT = (FORMAT_NAME = 'linkedin.public.csv_format')
ON_ERROR = 'CONTINUE';

COPY INTO linkedin.raw.companies
FROM (
  SELECT
    $1:company_id::NUMBER   AS company_id,
    $1:name::VARCHAR        AS name,
    $1:description::TEXT    AS description,
    $1:company_size::NUMBER AS company_size,
    $1:state::VARCHAR       AS state,
    $1:country::VARCHAR     AS country,
    $1:city::VARCHAR        AS city,
    $1:zip_code::VARCHAR    AS zip_code,
    $1:address::VARCHAR     AS address,
    $1:url::VARCHAR         AS url
  FROM @linkedin.public.s3_linkedin_stage/companies.json
  (FILE_FORMAT => 'linkedin.public.json_format')
)
ON_ERROR = 'CONTINUE';


COPY INTO linkedin.raw.job_industries
FROM (
  SELECT
    $1:job_id::NUMBER      AS job_id,
    $1:industry_id::NUMBER AS industry_id
  FROM @linkedin.public.s3_linkedin_stage/job_industries.json
  (FILE_FORMAT => 'linkedin.public.json_format')
)
ON_ERROR = 'CONTINUE';

COPY INTO linkedin.raw.company_specialities
FROM (
  SELECT
    $1:company_id::NUMBER  AS company_id,
    $1:speciality::VARCHAR AS speciality
  FROM @linkedin.public.s3_linkedin_stage/company_specialities.json
  (FILE_FORMAT => 'linkedin.public.json_format')
)
ON_ERROR = 'CONTINUE';

COPY INTO linkedin.raw.company_industries
FROM (
  SELECT
    $1:company_id::NUMBER AS company_id,
    $1:industry::VARCHAR  AS industry
  FROM @linkedin.public.s3_linkedin_stage/company_industries.json
  (FILE_FORMAT => 'linkedin.public.json_format')
)
ON_ERROR = 'CONTINUE';

--Vérification :
USE SCHEMA linkedin.raw;

SELECT 'job_postings'         AS table_name, COUNT(*) AS nb_lignes FROM linkedin.raw.job_postings        UNION ALL
SELECT 'benefits'             AS table_name, COUNT(*) AS nb_lignes FROM linkedin.raw.benefits            UNION ALL
SELECT 'companies'            AS table_name, COUNT(*) AS nb_lignes FROM linkedin.raw.companies           UNION ALL
SELECT 'employee_counts'      AS table_name, COUNT(*) AS nb_lignes FROM linkedin.raw.employee_counts     UNION ALL
SELECT 'job_skills'           AS table_name, COUNT(*) AS nb_lignes FROM linkedin.raw.job_skills          UNION ALL
SELECT 'job_industries'       AS table_name, COUNT(*) AS nb_lignes FROM linkedin.raw.job_industries      UNION ALL
SELECT 'company_specialities' AS table_name, COUNT(*) AS nb_lignes FROM linkedin.raw.company_specialities UNION ALL
SELECT 'company_industries'   AS table_name, COUNT(*) AS nb_lignes FROM linkedin.raw.company_industries;
