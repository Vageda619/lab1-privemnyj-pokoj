DROP DATABASE IF EXISTS hospital_3nf;
CREATE DATABASE hospital_3nf CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hospital_3nf;

CREATE TABLE department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(200) NOT NULL UNIQUE,
    head_doctor   VARCHAR(200) NOT NULL,
    phone         VARCHAR(20)
) ENGINE=InnoDB;

CREATE TABLE doctor (
    doctor_id        INT AUTO_INCREMENT PRIMARY KEY,
    personnel_number VARCHAR(50)  NOT NULL UNIQUE,
    full_name        VARCHAR(200) NOT NULL,
    specialization   VARCHAR(100) NOT NULL,
    category         VARCHAR(50)  NOT NULL,
    department_id    INT          NOT NULL,
    FOREIGN KEY (department_id) REFERENCES department(department_id)
) ENGINE=InnoDB;

CREATE TABLE patient (
    patient_id  INT AUTO_INCREMENT PRIMARY KEY,
    oms_policy  VARCHAR(20)  NOT NULL UNIQUE,
    full_name   VARCHAR(200) NOT NULL,
    birth_date  DATE         NOT NULL,
    gender      ENUM('M','F') NOT NULL,
    phone       VARCHAR(20),
    address     VARCHAR(300)
) ENGINE=InnoDB;

CREATE TABLE diagnosis (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    icd_code     VARCHAR(10)  NOT NULL UNIQUE,
    name         VARCHAR(300) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE ward (
    ward_id       INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NOT NULL,
    number        VARCHAR(20) NOT NULL,
    capacity      INT NOT NULL CHECK (capacity > 0),
    UNIQUE KEY uq_ward_dept_number (department_id, number),
    FOREIGN KEY (department_id) REFERENCES department(department_id)
) ENGINE=InnoDB;

CREATE TABLE service (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    code       VARCHAR(20)  NOT NULL UNIQUE,
    name       VARCHAR(200) NOT NULL,
    kind       VARCHAR(50)  NOT NULL,
    price      DECIMAL(10,2) NOT NULL CHECK (price >= 0)
) ENGINE=InnoDB;

CREATE TABLE admission (
    admission_id     INT AUTO_INCREMENT PRIMARY KEY,
    admission_number VARCHAR(30) NOT NULL UNIQUE,
    patient_id       INT NOT NULL,
    doctor_id        INT NOT NULL,
    diagnosis_id     INT NOT NULL,
    admitted_at      DATETIME NOT NULL,
    kind             ENUM('первичное','повторное') NOT NULL,
    complaint        TEXT,
    status           ENUM('осмотрен','госпитализирован','отправлен домой','переведён') NOT NULL DEFAULT 'осмотрен',
    FOREIGN KEY (patient_id)   REFERENCES patient(patient_id),
    FOREIGN KEY (doctor_id)    REFERENCES doctor(doctor_id),
    FOREIGN KEY (diagnosis_id) REFERENCES diagnosis(diagnosis_id)
) ENGINE=InnoDB;

CREATE TABLE hospitalization (
    hospitalization_id INT AUTO_INCREMENT PRIMARY KEY,
    admission_id       INT NOT NULL UNIQUE,
    ward_id            INT NOT NULL,
    started_at         DATETIME NOT NULL,
    ended_at           DATETIME NULL,
    outcome            VARCHAR(100) NULL,
    FOREIGN KEY (admission_id) REFERENCES admission(admission_id),
    FOREIGN KEY (ward_id)      REFERENCES ward(ward_id)
) ENGINE=InnoDB;

CREATE TABLE admission_service (
    admission_service_id INT AUTO_INCREMENT PRIMARY KEY,
    admission_id         INT NOT NULL,
    service_id           INT NOT NULL,
    quantity             INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    UNIQUE KEY uq_adm_service (admission_id, service_id),
    FOREIGN KEY (admission_id) REFERENCES admission(admission_id),
    FOREIGN KEY (service_id)   REFERENCES service(service_id)
) ENGINE=InnoDB;

INSERT INTO department (name, head_doctor, phone) VALUES
 ('Терапевтическое','Иванов И.И.','+7-495-100-10-10'),
 ('Хирургическое','Петров П.П.','+7-495-100-20-20'),
 ('Кардиологическое','Сидоров С.С.','+7-495-100-30-30');

INSERT INTO doctor (personnel_number, full_name, specialization, category, department_id) VALUES
 ('TAB-0001','Смирнов Алексей Владимирович','терапевт','высшая',1),
 ('TAB-0002','Орлова Мария Ивановна','хирург','высшая',2),
 ('TAB-0003','Кузнецов Дмитрий Олегович','кардиолог','первая',3);

INSERT INTO patient (oms_policy, full_name, birth_date, gender, phone, address) VALUES
 ('OMC-1111-2222-3333','Фёдоров Николай Петрович','1980-05-12','M','+7-916-111-22-33','г. Москва, ул. Ленина, 1'),
 ('OMC-4444-5555-6666','Белова Ольга Сергеевна','1992-11-03','F','+7-916-444-55-66','г. Москва, ул. Мира, 15'),
 ('OMC-7777-8888-9999','Гусев Артём Игоревич','2001-02-20','M','+7-916-777-88-99','г. Москва, пр. Вернадского, 42');

INSERT INTO diagnosis (icd_code, name) VALUES
 ('J06.9','Острая респираторная инфекция'),
 ('I20.0','Нестабильная стенокардия'),
 ('K35.8','Острый аппендицит');

INSERT INTO ward (department_id, number, capacity) VALUES
 (1,'101',4),(1,'102',4),(2,'201',2),(3,'301',2);

INSERT INTO service (code, name, kind, price) VALUES
 ('SRV-001','Общий анализ крови','анализ',450.00),
 ('SRV-002','ЭКГ','процедура',800.00),
 ('SRV-003','УЗИ брюшной полости','процедура',1500.00),
 ('SRV-004','Консультация кардиолога','консультация',1200.00);

INSERT INTO admission (admission_number, patient_id, doctor_id, diagnosis_id, admitted_at, kind, complaint, status) VALUES
 ('ADM-2024-0001',1,1,1,'2024-10-01 08:15:00','первичное','Кашель, температура 38.5','отправлен домой'),
 ('ADM-2024-0002',2,3,2,'2024-10-02 14:40:00','первичное','Боль в груди, одышка','госпитализирован'),
 ('ADM-2024-0003',3,2,3,'2024-10-03 22:05:00','первичное','Боль в правом боку','госпитализирован');

INSERT INTO hospitalization (admission_id, ward_id, started_at, ended_at, outcome) VALUES
 (2,4,'2024-10-02 15:20:00',NULL,NULL),
 (3,3,'2024-10-03 23:10:00','2024-10-10 11:00:00','Выписан в удовлетворительном состоянии');

INSERT INTO admission_service (admission_id, service_id, quantity) VALUES
 (1,1,1),(2,2,1),(2,4,1),(3,3,1);