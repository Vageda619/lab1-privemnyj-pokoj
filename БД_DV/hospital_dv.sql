DROP DATABASE IF EXISTS hospital_dv;
CREATE DATABASE hospital_dv CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hospital_dv;

-- ХАБЫ
CREATE TABLE hub_patient (
    patient_hk CHAR(32) NOT NULL PRIMARY KEY,
    patient_bk VARCHAR(20) NOT NULL,
    load_dts   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rec_src    VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_hub_patient_bk (patient_bk)
) ENGINE=InnoDB;

CREATE TABLE hub_doctor (
    doctor_hk CHAR(32) NOT NULL PRIMARY KEY,
    doctor_bk VARCHAR(50) NOT NULL,
    load_dts  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rec_src   VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_hub_doctor_bk (doctor_bk)
) ENGINE=InnoDB;

CREATE TABLE hub_department (
    department_hk CHAR(32) NOT NULL PRIMARY KEY,
    department_bk VARCHAR(200) NOT NULL,
    load_dts      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rec_src       VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_hub_department_bk (department_bk)
) ENGINE=InnoDB;

CREATE TABLE hub_diagnosis (
    diagnosis_hk CHAR(32) NOT NULL PRIMARY KEY,
    diagnosis_bk VARCHAR(10) NOT NULL,
    load_dts     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rec_src      VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_hub_diagnosis_bk (diagnosis_bk)
) ENGINE=InnoDB;

CREATE TABLE hub_admission (
    admission_hk CHAR(32) NOT NULL PRIMARY KEY,
    admission_bk VARCHAR(30) NOT NULL,
    load_dts     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rec_src      VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_hub_admission_bk (admission_bk)
) ENGINE=InnoDB;

CREATE TABLE hub_ward (
    ward_hk  CHAR(32) NOT NULL PRIMARY KEY,
    ward_bk  VARCHAR(150) NOT NULL,
    load_dts DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rec_src  VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_hub_ward_bk (ward_bk)
) ENGINE=InnoDB;

CREATE TABLE hub_service (
    service_hk CHAR(32) NOT NULL PRIMARY KEY,
    service_bk VARCHAR(20) NOT NULL,
    load_dts   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rec_src    VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_hub_service_bk (service_bk)
) ENGINE=InnoDB;

-- ЛИНКИ
CREATE TABLE link_doctor_department (
    link_doctor_department_hk CHAR(32) NOT NULL PRIMARY KEY,
    doctor_hk                 CHAR(32) NOT NULL,
    department_hk             CHAR(32) NOT NULL,
    load_dts                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rec_src                   VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_ldd (doctor_hk, department_hk),
    FOREIGN KEY (doctor_hk)     REFERENCES hub_doctor(doctor_hk),
    FOREIGN KEY (department_hk) REFERENCES hub_department(department_hk)
) ENGINE=InnoDB;

CREATE TABLE link_patient_admission (
    link_patient_admission_hk CHAR(32) NOT NULL PRIMARY KEY,
    patient_hk                CHAR(32) NOT NULL,
    admission_hk              CHAR(32) NOT NULL,
    load_dts                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rec_src                   VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_lpa (patient_hk, admission_hk),
    FOREIGN KEY (patient_hk)   REFERENCES hub_patient(patient_hk),
    FOREIGN KEY (admission_hk) REFERENCES hub_admission(admission_hk)
) ENGINE=InnoDB;

CREATE TABLE link_doctor_admission (
    link_doctor_admission_hk CHAR(32) NOT NULL PRIMARY KEY,
    doctor_hk                CHAR(32) NOT NULL,
    admission_hk             CHAR(32) NOT NULL,
    load_dts                 DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rec_src                  VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_lda (doctor_hk, admission_hk),
    FOREIGN KEY (doctor_hk)    REFERENCES hub_doctor(doctor_hk),
    FOREIGN KEY (admission_hk) REFERENCES hub_admission(admission_hk)
) ENGINE=InnoDB;

CREATE TABLE link_diagnosis_admission (
    link_diagnosis_admission_hk CHAR(32) NOT NULL PRIMARY KEY,
    diagnosis_hk                CHAR(32) NOT NULL,
    admission_hk                CHAR(32) NOT NULL,
    load_dts                    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rec_src                     VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_ldia (diagnosis_hk, admission_hk),
    FOREIGN KEY (diagnosis_hk) REFERENCES hub_diagnosis(diagnosis_hk),
    FOREIGN KEY (admission_hk) REFERENCES hub_admission(admission_hk)
) ENGINE=InnoDB;

CREATE TABLE link_hospitalization (
    link_hospitalization_hk CHAR(32) NOT NULL PRIMARY KEY,
    admission_hk            CHAR(32) NOT NULL,
    ward_hk                 CHAR(32) NOT NULL,
    load_dts                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rec_src                 VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_lh (admission_hk, ward_hk),
    FOREIGN KEY (admission_hk) REFERENCES hub_admission(admission_hk),
    FOREIGN KEY (ward_hk)      REFERENCES hub_ward(ward_hk)
) ENGINE=InnoDB;

CREATE TABLE link_admission_service (
    link_admission_service_hk CHAR(32) NOT NULL PRIMARY KEY,
    admission_hk              CHAR(32) NOT NULL,
    service_hk                CHAR(32) NOT NULL,
    load_dts                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rec_src                   VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_las (admission_hk, service_hk),
    FOREIGN KEY (admission_hk) REFERENCES hub_admission(admission_hk),
    FOREIGN KEY (service_hk)   REFERENCES hub_service(service_hk)
) ENGINE=InnoDB;

-- САТЕЛЛИТЫ
CREATE TABLE sat_patient (
    patient_hk   CHAR(32) NOT NULL,
    load_dts     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    load_end_dts DATETIME NULL,
    hash_diff    CHAR(32) NOT NULL,
    full_name    VARCHAR(200) NOT NULL,
    birth_date   DATE NOT NULL,
    gender       ENUM('M','F') NOT NULL,
    phone        VARCHAR(20),
    address      VARCHAR(300),
    rec_src      VARCHAR(100) NOT NULL,
    PRIMARY KEY (patient_hk, load_dts),
    FOREIGN KEY (patient_hk) REFERENCES hub_patient(patient_hk)
) ENGINE=InnoDB;

CREATE TABLE sat_doctor (
    doctor_hk      CHAR(32) NOT NULL,
    load_dts       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    load_end_dts   DATETIME NULL,
    hash_diff      CHAR(32) NOT NULL,
    full_name      VARCHAR(200) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    category       VARCHAR(50)  NOT NULL,
    rec_src        VARCHAR(100) NOT NULL,
    PRIMARY KEY (doctor_hk, load_dts),
    FOREIGN KEY (doctor_hk) REFERENCES hub_doctor(doctor_hk)
) ENGINE=InnoDB;

CREATE TABLE sat_department (
    department_hk CHAR(32) NOT NULL,
    load_dts      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    load_end_dts  DATETIME NULL,
    hash_diff     CHAR(32) NOT NULL,
    head_doctor   VARCHAR(200) NOT NULL,
    phone         VARCHAR(20),
    rec_src       VARCHAR(100) NOT NULL,
    PRIMARY KEY (department_hk, load_dts),
    FOREIGN KEY (department_hk) REFERENCES hub_department(department_hk)
) ENGINE=InnoDB;

CREATE TABLE sat_diagnosis (
    diagnosis_hk CHAR(32) NOT NULL,
    load_dts     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    load_end_dts DATETIME NULL,
    hash_diff    CHAR(32) NOT NULL,
    name         VARCHAR(300) NOT NULL,
    rec_src      VARCHAR(100) NOT NULL,
    PRIMARY KEY (diagnosis_hk, load_dts),
    FOREIGN KEY (diagnosis_hk) REFERENCES hub_diagnosis(diagnosis_hk)
) ENGINE=InnoDB;

CREATE TABLE sat_admission (
    admission_hk CHAR(32) NOT NULL,
    load_dts     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    load_end_dts DATETIME NULL,
    hash_diff    CHAR(32) NOT NULL,
    admitted_at  DATETIME NOT NULL,
    kind         ENUM('первичное','повторное') NOT NULL,
    complaint    TEXT,
    status       ENUM('осмотрен','госпитализирован','отправлен домой','переведён') NOT NULL,
    rec_src      VARCHAR(100) NOT NULL,
    PRIMARY KEY (admission_hk, load_dts),
    FOREIGN KEY (admission_hk) REFERENCES hub_admission(admission_hk)
) ENGINE=InnoDB;

CREATE TABLE sat_ward (
    ward_hk      CHAR(32) NOT NULL,
    load_dts     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    load_end_dts DATETIME NULL,
    hash_diff    CHAR(32) NOT NULL,
    capacity     INT NOT NULL,
    rec_src      VARCHAR(100) NOT NULL,
    PRIMARY KEY (ward_hk, load_dts),
    FOREIGN KEY (ward_hk) REFERENCES hub_ward(ward_hk)
) ENGINE=InnoDB;

CREATE TABLE sat_service (
    service_hk   CHAR(32) NOT NULL,
    load_dts     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    load_end_dts DATETIME NULL,
    hash_diff    CHAR(32) NOT NULL,
    name         VARCHAR(200) NOT NULL,
    kind         VARCHAR(50)  NOT NULL,
    price        DECIMAL(10,2) NOT NULL,
    rec_src      VARCHAR(100) NOT NULL,
    PRIMARY KEY (service_hk, load_dts),
    FOREIGN KEY (service_hk) REFERENCES hub_service(service_hk)
) ENGINE=InnoDB;

CREATE TABLE sat_hospitalization (
    link_hospitalization_hk CHAR(32) NOT NULL,
    load_dts                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    load_end_dts            DATETIME NULL,
    hash_diff               CHAR(32) NOT NULL,
    started_at              DATETIME NOT NULL,
    ended_at                DATETIME NULL,
    outcome                 VARCHAR(100) NULL,
    rec_src                 VARCHAR(100) NOT NULL,
    PRIMARY KEY (link_hospitalization_hk, load_dts),
    FOREIGN KEY (link_hospitalization_hk) REFERENCES link_hospitalization(link_hospitalization_hk)
) ENGINE=InnoDB;

CREATE TABLE sat_admission_service (
    link_admission_service_hk CHAR(32) NOT NULL,
    load_dts                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    load_end_dts              DATETIME NULL,
    hash_diff                 CHAR(32) NOT NULL,
    quantity                  INT NOT NULL,
    rec_src                   VARCHAR(100) NOT NULL,
    PRIMARY KEY (link_admission_service_hk, load_dts),
    FOREIGN KEY (link_admission_service_hk) REFERENCES link_admission_service(link_admission_service_hk)
) ENGINE=InnoDB;

-- ЗАГРУЗКА
INSERT INTO hub_patient (patient_hk, patient_bk, rec_src)
SELECT DISTINCT MD5(UPPER(TRIM(oms_policy))), TRIM(oms_policy), 'hospital_3nf.patient'
FROM hospital_3nf.patient;

INSERT INTO hub_doctor (doctor_hk, doctor_bk, rec_src)
SELECT DISTINCT MD5(UPPER(TRIM(personnel_number))), TRIM(personnel_number), 'hospital_3nf.doctor'
FROM hospital_3nf.doctor;

INSERT INTO hub_department (department_hk, department_bk, rec_src)
SELECT DISTINCT MD5(UPPER(TRIM(name))), TRIM(name), 'hospital_3nf.department'
FROM hospital_3nf.department;

INSERT INTO hub_diagnosis (diagnosis_hk, diagnosis_bk, rec_src)
SELECT DISTINCT MD5(UPPER(TRIM(icd_code))), TRIM(icd_code), 'hospital_3nf.diagnosis'
FROM hospital_3nf.diagnosis;

INSERT INTO hub_admission (admission_hk, admission_bk, rec_src)
SELECT DISTINCT MD5(UPPER(TRIM(admission_number))), TRIM(admission_number), 'hospital_3nf.admission'
FROM hospital_3nf.admission;

INSERT INTO hub_service (service_hk, service_bk, rec_src)
SELECT DISTINCT MD5(UPPER(TRIM(code))), TRIM(code), 'hospital_3nf.service'
FROM hospital_3nf.service;

INSERT INTO hub_ward (ward_hk, ward_bk, rec_src)
SELECT DISTINCT
       MD5(CONCAT(UPPER(TRIM(d.name)),'::',UPPER(TRIM(w.number)))),
       CONCAT(TRIM(d.name),'::',TRIM(w.number)),
       'hospital_3nf.ward'
FROM hospital_3nf.ward w
JOIN hospital_3nf.department d ON d.department_id = w.department_id;

INSERT INTO sat_patient (patient_hk, hash_diff, full_name, birth_date, gender, phone, address, rec_src)
SELECT MD5(UPPER(TRIM(oms_policy))),
       MD5(CONCAT_WS('||', UPPER(TRIM(full_name)), birth_date, gender,
           COALESCE(UPPER(TRIM(phone)),''), COALESCE(UPPER(TRIM(address)),''))),
       full_name, birth_date, gender, phone, address, 'hospital_3nf.patient'
FROM hospital_3nf.patient;

INSERT INTO sat_doctor (doctor_hk, hash_diff, full_name, specialization, category, rec_src)
SELECT MD5(UPPER(TRIM(personnel_number))),
       MD5(CONCAT_WS('||', UPPER(TRIM(full_name)), UPPER(TRIM(specialization)), UPPER(TRIM(category)))),
       full_name, specialization, category, 'hospital_3nf.doctor'
FROM hospital_3nf.doctor;

INSERT INTO sat_admission (admission_hk, hash_diff, admitted_at, kind, complaint, status, rec_src)
SELECT MD5(UPPER(TRIM(admission_number))),
       MD5(CONCAT_WS('||', admitted_at, kind, COALESCE(complaint,''), status)),
       admitted_at, kind, complaint, status, 'hospital_3nf.admission'
FROM hospital_3nf.admission;

SELECT 'hub_patient' AS tbl, COUNT(*) AS cnt FROM hub_patient
UNION ALL SELECT 'hub_doctor', COUNT(*) FROM hub_doctor
UNION ALL SELECT 'hub_department', COUNT(*) FROM hub_department
UNION ALL SELECT 'hub_diagnosis', COUNT(*) FROM hub_diagnosis
UNION ALL SELECT 'hub_admission', COUNT(*) FROM hub_admission
UNION ALL SELECT 'hub_ward', COUNT(*) FROM hub_ward
UNION ALL SELECT 'hub_service', COUNT(*) FROM hub_service;