-- CREATION TABLE LINKEDLN 

USE DATABASE linkedin;
USE SCHEMA raw;

-- 1. job_postings
CREATE OR REPLACE TABLE linkedin.raw.job_postings (
  job_id                     VARCHAR,
  company_name               VARCHAR,
  title                      VARCHAR,
  description                TEXT,
  max_salary                 VARCHAR,
  med_salary                 VARCHAR,
  min_salary                 VARCHAR,
  pay_period                 VARCHAR,
  formatted_work_type        VARCHAR,
  location                   VARCHAR,
  applies                    VARCHAR,
  original_listed_time       VARCHAR,
  remote_allowed             VARCHAR,
  views                      VARCHAR,
  job_posting_url            VARCHAR,
  application_url            VARCHAR,
  application_type           VARCHAR,
  expiry                     VARCHAR,
  closed_time                VARCHAR,
  formatted_experience_level VARCHAR,
  skills_desc                TEXT,
  listed_time                VARCHAR,
  posting_domain             VARCHAR,
  sponsored                  VARCHAR,
  work_type                  VARCHAR,
  currency                   VARCHAR,
  compensation_type          VARCHAR
);

-- 2. benefits
CREATE OR REPLACE TABLE benefits (
    job_id      VARCHAR(50),
    inferred    BOOLEAN,
    type        VARCHAR(100)
);

-- 3. companies
CREATE OR REPLACE TABLE companies (
    company_id      VARCHAR(50),
    name            VARCHAR(255),
    description     TEXT,
    company_size    INT,
    state           VARCHAR(100),
    country         VARCHAR(100),
    city            VARCHAR(100),
    zip_code        VARCHAR(20),
    address         VARCHAR(500),
    url             VARCHAR(500)
);

-- 4. employee_counts
CREATE OR REPLACE TABLE linkedin.raw.employee_counts (
  company_id     VARCHAR,
  employee_count VARCHAR,
  follower_count VARCHAR,
  time_recorded  VARCHAR
);

-- 5. job_skills
CREATE OR REPLACE TABLE job_skills (
    job_id      VARCHAR(50),
    skill_abr   VARCHAR(50)
);

-- 6. job_industries
CREATE OR REPLACE TABLE job_industries (
    job_id          VARCHAR(50),
    industry_id     VARCHAR(50)
);

-- 7. company_specialities
CREATE OR REPLACE TABLE company_specialities (
    company_id  VARCHAR(50),
    speciality  VARCHAR(255)
);

-- 8. company_industries
CREATE OR REPLACE TABLE company_industries (
    company_id  VARCHAR(50),
    industry    VARCHAR(255)
);

-- Ou vider toutes les tables d'un coup
TRUNCATE TABLE linkedin.raw.job_postings;
TRUNCATE TABLE linkedin.raw.benefits;
TRUNCATE TABLE linkedin.raw.companies;
TRUNCATE TABLE linkedin.raw.employee_counts;
TRUNCATE TABLE linkedin.raw.job_skills;
TRUNCATE TABLE linkedin.raw.job_industries;
TRUNCATE TABLE linkedin.raw.company_industries;
TRUNCATE TABLE linkedin.raw.company_specialities;