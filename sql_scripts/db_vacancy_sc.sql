CREATE TABLE IF NOT EXISTS db_vacancy_schema.job_formats(
	id SERIAL PRIMARY KEY,
	job_format_title VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS db_vacancy_schema.languages(
	id SERIAL PRIMARY KEY,
	language_title VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS db_vacancy_schema.skills(
	id SERIAL PRIMARY KEY,
	skill_title VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS db_vacancy_schema.job_types(
	id SERIAL PRIMARY KEY,
	job_type_title VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS db_vacancy_schema.specialities(
	id SERIAL PRIMARY KEY,
	spec_title VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS db_vacancy_schema.towns(
	id SERIAL PRIMARY KEY,
	town_title VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS db_vacancy_schema.sources(
	id SERIAL PRIMARY KEY,
	source_title VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS db_vacancy_schema.companies(
	id SERIAL PRIMARY KEY,
	company_title VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS db_vacancy_schema.vacancies(
	id BIGINT PRIMARY KEY,
	"version" INT NOT NULL,
	"url" VARCHAR(2073) NOT NULL,
	vacancy_title VARCHAR(255),
	salary_from INT,
	salary_to INT,
	experience_from SMALLINT,
	experience_to SMALLINT,
	"description" TEXT,
	company_id INT,
	FOREIGN KEY (company_id) REFERENCES db_vacancy_schema.companies (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	source_id INT,
	FOREIGN KEY (source_id) REFERENCES db_vacancy_schema.sources (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	publicated_at DATE
);


CREATE TABLE IF NOT EXISTS db_vacancy_schema.job_formats_vacancies (
	vacancy_id BIGINT,
	job_format_id INT,
	FOREIGN KEY (vacancy_id) REFERENCES db_vacancy_schema.vacancies (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (job_format_id) REFERENCES db_vacancy_schema.job_formats (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS db_vacancy_schema.languages_vacancies (
	vacancy_id BIGINT,
	language_id INT,
	FOREIGN KEY (vacancy_id) REFERENCES db_vacancy_schema.vacancies (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (language_id) REFERENCES db_vacancy_schema.languages (id) ON UPDATE CASCADE ON DELETE RESTRICT	
);

CREATE TABLE IF NOT EXISTS db_vacancy_schema.skills_vacancies (
	vacancy_id BIGINT,
	skill_id INT,
	FOREIGN KEY (vacancy_id) REFERENCES db_vacancy_schema.vacancies (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (skill_id) REFERENCES db_vacancy_schema.skills (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS db_vacancy_schema.job_types_vacancies (
	vacancy_id BIGINT,
	job_type_id INT,
	FOREIGN KEY (vacancy_id) REFERENCES db_vacancy_schema.vacancies (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (job_type_id) REFERENCES db_vacancy_schema.job_types (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS db_vacancy_schema.specialities_vacancies (
	vacancy_id BIGINT,
	spec_id INT,
	FOREIGN KEY (vacancy_id) REFERENCES db_vacancy_schema.vacancies (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (spec_id) REFERENCES db_vacancy_schema.specialities (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS db_vacancy_schema.towns_vacancies (
	vacancy_id BIGINT,
	town_id INT,
	FOREIGN KEY (vacancy_id) REFERENCES db_vacancy_schema.vacancies (id) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (town_id) REFERENCES db_vacancy_schema.towns (id) ON UPDATE CASCADE ON DELETE RESTRICT
);