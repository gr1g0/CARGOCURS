CREATE TABLE Clients (
    client_id SERIAL PRIMARY KEY,
    name_client VARCHAR(20) NOT NULL,
	surname_client VARCHAR(50) NOT NULL,
	patronymic_client VARCHAR(50),
	pasport_client NUMERIC(10) NOT NULL UNIQUE,
	

	CONSTRAINT CK_name_client_FORMAT CHECK(
		name_client ~ '^[А-Яа-яЁё\s]+$'
		and name_client !~ '\d'
	),
	CONSTRAINT CK_surname_client_FORMAT CHECK(
		surname_client ~ '^[А-Яа-яЁё\s]+$'
		and surname_client !~ '\d'
	),
	CONSTRAINT CK_patronymic_client_FORMAT CHECK(
		patronymic_client ~ '^[А-Яа-яЁё\s]+$'
		and patronymic_client !~ '\d'
	)
);

INSERT INTO Clients (name_client, surname_client, patronymic_client, pasport_client)
VALUES
    ('Иван', 'Иванов', 'Иванович', 1234567890),
    ('Анна', 'Переведенцева', 'Михайловна', 0987654321),
    ('Дмитрий', 'Илларионов', 'Дмитриевич', 1233211234),
    ('Елена', 'Лукина', 'Леонидовна', 1236541234),
    ('Сергей', 'Пучков', 'Георгиевич', 1357908642);

SELECT * FROM Clients;

CREATE TABLE Workers (
	worker_id SERIAL PRIMARY KEY,
    name_worker VARCHAR(20) NOT NULL,
	surname_worker VARCHAR(50) NOT NULL,
	patronymic_worker VARCHAR(50),
    pasport_worker NUMERIC(10) NOT NULL UNIQUE,
    job_worker VARCHAR(100) NOT NULL,

	CONSTRAINT CK_name_worker_FORMAT CHECK(
		name_worker ~ '^[А-Яа-яЁё\s]+$'
		and name_worker !~ '\d'
	),

	CONSTRAINT CK_surname_worker_FORMAT CHECK(
		surname_worker ~ '^[А-Яа-яЁё\s]+$'
		and surname_worker !~ '\d'
	),

	CONSTRAINT CK_patronymic_worker_FORMAT CHECK(
		patronymic_worker ~ '^[А-Яа-яЁё\s]+$'
		and patronymic_worker !~ '\d'
	),
	CONSTRAINT CK_job_worker_FORMAT CHECK(
		job_worker ~ '^[А-Яа-яЁё\s]+$'
		and job_worker !~ '\d'
	)
);

INSERT INTO Workers (
    name_worker,
    surname_worker,
    patronymic_worker,
	job_worker,
	pasport_worker
)
VALUES
    ('Алексей', 'Иванов', 'Петрович', 'Пилот', 4545454545),
    ('Елена', 'Смирнова', 'Дмитриевна', 'Водитель', 3434343434),
    ('Дмитрий', 'Козлов', 'Александрович', 'Менеджер', 2323232323),
    ('Ольга', 'Попова', 'Владимировна', 'Админ', 2121212121),
    ('Сергей', 'Морозов', 'Николаевич', 'Дальнобойщик', 1212121212);

SELECT * FROM Workers; 

CREATE TABLE Requests (
    request_id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL,
    worker_id INTEGER NOT NULL,
    request_status VARCHAR(20) NOT NULL,
    request_date DATE NOT NULL,
    cargo_info VARCHAR(1000) NOT NULL,
	
    CONSTRAINT FK_client FOREIGN KEY (
	client_id) REFERENCES Clients(client_id
	),
	
    CONSTRAINT FK_worker FOREIGN KEY (
	worker_id) REFERENCES Workers(worker_id
	)
);

INSERT INTO Requests (
    client_id,
    worker_id,
	request_status,
	request_date,
	cargo_info
)
VALUES
    (1, 1, 'Выполнена', '2026-01-20', 'Большая фарфоровая ваза, нужно перевезти из Москвы в Новосибирск'),
    (2, 2, 'Выполнена', '2026-01-21', 'Чёрные кеды, нужно перевезти из Новосибирска в Томск'),
    (3, 3, 'Принята', '2026-01-22', 'Отработанное ядерное топливо, нужно перевезти из Томска в Нью-Йорк'),
    (4, 4, 'Принята', '2026-01-23', 'Обогащённое ядерное топливо, нужно перевезти из Москвы в Томск'),
    (5, 5, 'Принята', '2026-01-23', 'Пачка пельменей "Великосочные", нужно перевезти из Новосибирска в Томск');

SELECT * FROM Requests;

CREATE TABLE Contracts (
    contract_id SERIAL PRIMARY KEY,
    request_id INTEGER NOT NULL UNIQUE,
    contract_status VARCHAR(20) NOT NULL,
    contract_date DATE NOT NULL,
    price NUMERIC(15,2) NOT NULL,
	
    CONSTRAINT FK_request FOREIGN KEY (
	request_id) REFERENCES Requests(request_id
	),

    CONSTRAINT CK_price CHECK (
	price > 0
	)
);

INSERT INTO Contracts (
    request_id,
    contract_status,
	contract_date,
	price
)
VALUES
    (1, 'Выполнен', '2026-01-20', 12000.00),
    (2, 'Выполнен', '2026-01-21', 500.00),
    (3, 'Выполняется', '2026-01-22', 1000000.00),
    (4, 'Выполняется', '2026-01-23', 1000000.00),
    (5, 'Ожидает подписания', '2026-01-23', 999999.99);

SELECT * FROM Contracts;

CREATE TABLE Transport (
	transport_id SERIAL PRIMARY KEY,
	model VARCHAR(500) NOT NULL
);
INSERT INTO Transport (
	model
)
VALUES
	('A001AA тойота хайлюкс'),
	('747 боинг'),
	('B002BB КамАЗ'),
	('G005GG ГАЗ'),
	('A111AA БАЗ');

SELECT * FROM Transport;

CREATE TABLE Delivery (
    delivery_id SERIAL PRIMARY KEY,
    contract_id INTEGER NOT NULL,
	transport_id INTEGER NOT NULL,
    start_point VARCHAR(100) NOT NULL,
	finish_point VARCHAR(100) NOT NULL,
	
    CONSTRAINT FK_contract_id FOREIGN KEY (
	contract_id) REFERENCES Contracts(contract_id
	),

	CONSTRAINT FK_transport_id FOREIGN KEY (
	transport_id) REFERENCES Transport(transport_id
	)
);

INSERT INTO Delivery (
    contract_id,
	transport_id,
	start_point,
	finish_point
)
VALUES
    (1, 1, 'Москва', 'Новосибирск'),
    (2, 4, 'Новосибирск', 'Томск'),
    (3, 2, 'Томск', 'Нью-Йорк'),
    (4, 2, 'Москва', 'Томск'),
    (5, 3, 'Новосибирск', 'Томск');

SELECT * FROM Delivery;

CREATE ROLE manager_role;
CREATE ROLE hr_role;

GRANT SELECT ON Clients TO manager_role;
GRANT SELECT, UPDATE ON Requests TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Contracts TO manager_role;
GRANT SELECT, DELETE ON Delivery TO manager_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON Workers TO hr_role;
GRANT USAGE, SELECT ON SEQUENCE workers_worker_id_seq TO hr_role;

ALTER TABLE Workers ENABLE ROW LEVEL SECURITY;

CREATE POLICY worker_own_data_policy ON Workers
FOR ALL TO manager_role
USING (worker_id = current_setting('app.current_worker_id', true)::INTEGER);

CREATE POLICY hr_data_policy ON Workers
FOR ALL TO hr_role
USING (true);

CREATE USER manager_user WITH PASSWORD 'password123';

GRANT manager_role TO manager_user;

CREATE USER hr_user WITH PASSWORD 'password123';

GRANT hr_role TO hr_user;