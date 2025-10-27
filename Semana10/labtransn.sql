-- ==========================================
-- CREACIÓN DE TABLAS DEL ESQUEMA HR
-- ==========================================

CREATE TABLE regions (
  region_id NUMBER PRIMARY KEY,
  region_name VARCHAR2(50)
);

CREATE TABLE countries (
  country_id CHAR(2) PRIMARY KEY,
  country_name VARCHAR2(50),
  region_id NUMBER REFERENCES regions(region_id)
);

CREATE TABLE locations (
  location_id NUMBER PRIMARY KEY,
  street_address VARCHAR2(100),
  postal_code VARCHAR2(12),
  city VARCHAR2(30),
  state_province VARCHAR2(25),
  country_id CHAR(2) REFERENCES countries(country_id)
);

CREATE TABLE departments (
  department_id NUMBER PRIMARY KEY,
  department_name VARCHAR2(30),
  manager_id NUMBER,
  location_id NUMBER REFERENCES locations(location_id)
);

CREATE TABLE jobs (
  job_id VARCHAR2(10) PRIMARY KEY,
  job_title VARCHAR2(35),
  min_salary NUMBER(8,2),
  max_salary NUMBER(8,2)
);

CREATE TABLE employees (
  employee_id NUMBER PRIMARY KEY,
  first_name VARCHAR2(20),
  last_name VARCHAR2(25) NOT NULL,
  email VARCHAR2(25) NOT NULL,
  phone_number VARCHAR2(20),
  hire_date DATE NOT NULL,
  job_id VARCHAR2(10) REFERENCES jobs(job_id),
  salary NUMBER(8,2),
  commission_pct NUMBER(2,2),
  manager_id NUMBER,
  department_id NUMBER REFERENCES departments(department_id)
);

CREATE TABLE job_history (
  employee_id NUMBER REFERENCES employees(employee_id),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  job_id VARCHAR2(10) REFERENCES jobs(job_id),
  department_id NUMBER REFERENCES departments(department_id),
  CONSTRAINT job_history_pk PRIMARY KEY (employee_id, start_date)
);

-- ==========================================
-- INSERCIÓN DE DATOS
-- ==========================================

-- REGIONS
INSERT INTO regions VALUES (1, 'Europe');
INSERT INTO regions VALUES (2, 'Americas');
INSERT INTO regions VALUES (3, 'Asia');
INSERT INTO regions VALUES (4, 'Middle East and Africa');

-- COUNTRIES
INSERT INTO countries VALUES ('US', 'United States', 2);
INSERT INTO countries VALUES ('UK', 'United Kingdom', 1);
INSERT INTO countries VALUES ('IN', 'India', 3);
INSERT INTO countries VALUES ('BR', 'Brazil', 2);
INSERT INTO countries VALUES ('EG', 'Egypt', 4);

-- LOCATIONS
INSERT INTO locations VALUES (1000, '2014 NE 45th Ave', '98121', 'Seattle', 'Washington', 'US');
INSERT INTO locations VALUES (1100, '1987 E Maple St', '02210', 'Boston', 'Massachusetts', 'US');
INSERT INTO locations VALUES (1200, '25 Main Street', 'WC2N', 'London', NULL, 'UK');
INSERT INTO locations VALUES (1300, 'Plot 10, IT Park', '560100', 'Bangalore', 'Karnataka', 'IN');
INSERT INTO locations VALUES (1400, 'Rua das Flores', '04567', 'Sao Paulo', 'SP', 'BR');
INSERT INTO locations VALUES (1500, 'Nile Tower', '11511', 'Cairo', NULL, 'EG');

-- DEPARTMENTS
INSERT INTO departments VALUES (50, 'Sales', NULL, 1400);
INSERT INTO departments VALUES (60, 'IT', NULL, 1000);
INSERT INTO departments VALUES (70, 'Marketing', NULL, 1200);
INSERT INTO departments VALUES (80, 'HR', NULL, 1100);
INSERT INTO departments VALUES (90, 'Finance', NULL, 1300);
INSERT INTO departments VALUES (100, 'Operations', NULL, 1500);
INSERT INTO departments VALUES (110, 'Logistics', NULL, 1400);

-- JOBS
INSERT INTO jobs VALUES ('AD_PRES', 'President', 20000, 40000);
INSERT INTO jobs VALUES ('AD_VP', 'Vice President', 15000, 30000);
INSERT INTO jobs VALUES ('IT_PROG', 'Programmer', 4000, 9000);
INSERT INTO jobs VALUES ('MK_MAN', 'Marketing Manager', 7000, 15000);
INSERT INTO jobs VALUES ('HR_REP', 'HR Representative', 4500, 9000);
INSERT INTO jobs VALUES ('FI_MGR', 'Finance Manager', 9000, 15000);
INSERT INTO jobs VALUES ('SA_REP', 'Sales Representative', 4000, 11000);
INSERT INTO jobs VALUES ('OP_MGR', 'Operations Manager', 8000, 16000);
INSERT INTO jobs VALUES ('LOG_ASST', 'Logistics Assistant', 3000, 7000);

-- EMPLOYEES
INSERT INTO employees VALUES (101, 'John', 'Smith', 'JSMITH', '515.123.4567', DATE '2019-01-10', 'IT_PROG', 6000, NULL, NULL, 60);
INSERT INTO employees VALUES (102, 'Mary', 'Johnson', 'MJOHNSON', '515.234.5678', DATE '2018-04-21', 'HR_REP', 4800, NULL, NULL, 80);
INSERT INTO employees VALUES (103, 'Robert', 'Brown', 'RBROWN', '515.345.6789', DATE '2020-06-15', 'FI_MGR', 10000, NULL, NULL, 90);
INSERT INTO employees VALUES (104, 'Patricia', 'Taylor', 'PTAYLOR', '515.456.7890', DATE '2021-08-01', 'SA_REP', 5000, NULL, NULL, 50);
INSERT INTO employees VALUES (105, 'James', 'Davis', 'JDAVIS', '515.567.8901', DATE '2022-09-20', 'OP_MGR', 9000, NULL, NULL, 100);
INSERT INTO employees VALUES (106, 'Linda', 'Miller', 'LMILLER', '515.678.9012', DATE '2017-11-05', 'LOG_ASST', 3500, NULL, NULL, 110);
INSERT INTO employees VALUES (107, 'David', 'Wilson', 'DWILSON', '515.789.0123', DATE '2020-02-12', 'IT_PROG', 6200, NULL, NULL, 60);
INSERT INTO employees VALUES (108, 'Jennifer', 'Moore', 'JMOORE', '515.890.1234', DATE '2019-07-07', 'SA_REP', 5200, NULL, NULL, 50);
INSERT INTO employees VALUES (109, 'William', 'Anderson', 'WANDER', '515.901.2345', DATE '2021-10-11', 'HR_REP', 4600, NULL, NULL, 80);
INSERT INTO employees VALUES (110, 'Elizabeth', 'Thomas', 'ETHOMAS', '515.012.3456', DATE '2022-01-15', 'FI_MGR', 9800, NULL, NULL, 90);

-- JOB_HISTORY (historial de cargos anteriores)
INSERT INTO job_history VALUES (101, DATE '2018-01-01', DATE '2018-12-31', 'IT_PROG', 60);
INSERT INTO job_history VALUES (102, DATE '2017-03-01', DATE '2018-03-31', 'HR_REP', 80);
INSERT INTO job_history VALUES (103, DATE '2019-01-01', DATE '2019-12-31', 'FI_MGR', 90);
INSERT INTO job_history VALUES (104, DATE '2020-01-01', DATE '2021-07-31', 'SA_REP', 50);
INSERT INTO job_history VALUES (105, DATE '2021-01-01', DATE '2022-08-31', 'OP_MGR', 100);
INSERT INTO job_history VALUES (106, DATE '2016-01-01', DATE '2017-10-31', 'LOG_ASST', 110);

COMMIT;

SELECT * FROM employees;
