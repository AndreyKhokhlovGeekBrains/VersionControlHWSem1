CREATE TABLE animals (
class_id INT PRIMARY KEY AUTO_INCREMENT,
description VARCHAR(15) NOT NULL
);

INSERT INTO animals(description) VALUES
('Pets'),
('PackAnimals');

CREATE TABLE pets (
pet_id INT PRIMARY KEY AUTO_INCREMENT,
description VARCHAR(15) NOT NULL
);

INSERT INTO pets (description) VALUES
('Dogs'),
('Cats'),
('Hamsters');

ALTER TABLE pets ADD COLUMN class_id INT NOT NULL;

UPDATE pets SET class_id = (
	SELECT class_id
    FROM animals
    WHERE description = 'Pets'
)
WHERE pet_id > 0;

ALTER TABLE pets ADD CONSTRAINT fk_animal
FOREIGN KEY (class_id) REFERENCES animals(class_id)
ON UPDATE CASCADE
ON DELETE CASCADE;

CREATE TABLE packanimals (
pack_animal_id INT PRIMARY KEY AUTO_INCREMENT,
description VARCHAR(15) NOT NULL
);

INSERT INTO packanimals (description) VALUES
('Horses'),
('Camels'),
('Donkeys');

ALTER TABLE packanimals ADD COLUMN class_id INT NOT NULL;

UPDATE packanimals SET class_id = (
	SELECT class_id 
    FROM animals 
    WHERE description = 'PackAnimals'
    )
WHERE pack_animal_id > 0;

ALTER TABLE packanimals ADD CONSTRAINT fk_animal_pa
FOREIGN KEY (class_id) REFERENCES animals(class_id)
ON UPDATE CASCADE
ON DELETE CASCADE;

# *** *** ***

CREATE TABLE dogs (
dog_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL,
birthdate DATE,
commands VARCHAR(100)
);

INSERT INTO dogs (name, birthdate, commands) VALUES
('Fido', '2020-01-01', 'Sit, Stay, Fetch'),
('Buddy', '2018-12-10', 'Sit, Paw, Bark'),
('Bella', '2019-11-11', 'Sit, Stay, Roll');

ALTER TABLE dogs ADD COLUMN pet_id INT NOT NULL;

UPDATE dogs SET pet_id = (
	SELECT pet_id 
    FROM pets 
    WHERE description = 'Dogs'
    )
WHERE dog_id > 0;

ALTER TABLE dogs ADD CONSTRAINT fk_pets1
FOREIGN KEY (pet_id) REFERENCES pets(pet_id)
ON UPDATE CASCADE
ON DELETE CASCADE;

# *** *** ***

CREATE TABLE cats (
cat_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL,
birthdate DATE,
commands VARCHAR(100)
);

INSERT INTO cats (name, birthdate, commands) VALUES
('Whiskers', '2019-05-15', 'Sit, Pounce'),
('Smudge', '2020-02-20', 'Sit, Pounce, Scratch'),
('Oliver', '2020-06-30', 'Meow, Scratch, Jump');

ALTER TABLE cats ADD COLUMN pet_id INT NOT NULL;

UPDATE cats SET pet_id = (
	SELECT pet_id 
    FROM pets 
    WHERE description = 'Cats'
    )
WHERE cat_id > 0;

ALTER TABLE cats ADD CONSTRAINT fk_pets2
FOREIGN KEY (pet_id) REFERENCES pets(pet_id)
ON UPDATE CASCADE
ON DELETE CASCADE;

# *** *** ***

CREATE TABLE hamsters (
hamster_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL,
birthdate DATE,
commands VARCHAR(100)
);

INSERT INTO hamsters (name, birthdate, commands) VALUES
('Hammy', '2021-03-10', 'Roll, Hide'),
('Peanut', '2021-08-01', 'Roll, Spin');

ALTER TABLE hamsters ADD COLUMN pet_id INT NOT NULL;

UPDATE hamsters SET pet_id = (
	SELECT pet_id 
    FROM pets 
    WHERE description = 'Hamsters'
    )
WHERE hamster_id > 0;

ALTER TABLE hamsters ADD CONSTRAINT fk_pets3
FOREIGN KEY (pet_id) REFERENCES pets(pet_id)
ON UPDATE CASCADE
ON DELETE CASCADE;

# *** *** ***

CREATE TABLE horses (
horse_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL,
birthdate DATE,
commands VARCHAR(100)
);

INSERT INTO horses (name, birthdate, commands) VALUES
('Thunder', '2015-07-21', 'Trot, Canter, Gallop'),
('Storm', '2014-05-05', 'Trot, Canter'),
('Blaze', '2016-02-29', 'Trot, Jump, Gallop');

ALTER TABLE horses ADD COLUMN pack_animal_id INT NOT NULL;

UPDATE horses SET pack_animal_id = (
	SELECT pack_animal_id 
    FROM packanimals 
    WHERE description = 'Horses'
    )
WHERE horse_id > 0;

ALTER TABLE horses ADD CONSTRAINT fk_pets4
FOREIGN KEY (pack_animal_id) REFERENCES packanimals(pack_animal_id)
ON UPDATE CASCADE
ON DELETE CASCADE;

# *** *** ***

CREATE TABLE camels (
camel_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL,
birthdate DATE,
commands VARCHAR(100)
);

INSERT INTO camels (name, birthdate, commands) VALUES
('Sandy', '2016-11-03', 'Walk, Carry Load'),
('Dune', '2018-12-12', 'Walk, Sit'),
('Sahara', '2015-08-14', 'Walk, Run');

ALTER TABLE camels ADD COLUMN pack_animal_id INT NOT NULL;

UPDATE camels SET pack_animal_id = (
	SELECT pack_animal_id 
    FROM packanimals 
    WHERE description = 'Camels'
    )
WHERE camel_id > 0;

ALTER TABLE camels ADD CONSTRAINT fk_pets5
FOREIGN KEY (pack_animal_id) REFERENCES packanimals(pack_animal_id)
ON UPDATE CASCADE
ON DELETE CASCADE;

# *** *** ***

CREATE TABLE donkeys (
donkey_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL,
birthdate DATE,
commands VARCHAR(100)
);

INSERT INTO donkeys (name, birthdate, commands) VALUES
('Eeyore', '2017-09-18', 'Walk, Carry, Load, Bray'),
('Burro', '2019-01-23', 'Walk, Bray, Kick');

ALTER TABLE donkeys ADD COLUMN pack_animal_id INT NOT NULL;

UPDATE donkeys SET pack_animal_id = (
	SELECT pack_animal_id 
    FROM packanimals 
    WHERE description = 'Donkeys'
    )
WHERE donkey_id > 0;

ALTER TABLE donkeys ADD CONSTRAINT fk_pets6
FOREIGN KEY (pack_animal_id) REFERENCES packanimals(pack_animal_id)
ON UPDATE CASCADE
ON DELETE CASCADE;

# *** *** ***

SELECT
	(@row_number:=@row_number + 1) AS id,
    name,
    type,
    birthdate,
    commands
FROM (
SELECT d.name, p1.description as type, d.birthdate, d.commands
FROM dogs d
LEFT JOIN pets p1 ON p1.pet_id = d.pet_id
UNION
SELECT c.name, p2.description as type, c.birthdate, c.commands
FROM cats c
LEFT JOIN pets p2 ON p2.pet_id = c.pet_id
UNION
SELECT h.name, p3.description as type, h.birthdate, h.commands
FROM hamsters h
LEFT JOIN pets p3 ON p3.pet_id = h.pet_id
) AS subquery
CROSS JOIN (SELECT @row_number:=0) AS rn;

# *** *** ***

SET @row_number := 0;

WITH ds AS (
SELECT d.name, p1.description as type, d.birthdate, d.commands
FROM dogs d
LEFT JOIN pets p1 ON p1.pet_id = d.pet_id
UNION
SELECT c.name, p2.description as type, c.birthdate, c.commands
FROM cats c
LEFT JOIN pets p2 ON p2.pet_id = c.pet_id
UNION
SELECT h.name, p3.description as type, h.birthdate, h.commands
FROM hamsters h
LEFT JOIN pets p3 ON p3.pet_id = h.pet_id
)
SELECT
	(@row_number := @row_number + 1) AS id,
	name,
    type,
    birthdate,
    commands
FROM ds;

# *** *** ***

SELECT
	(@row_number:=@row_number + 1) AS id,
    name,
    type,
    birthdate,
    commands
FROM (
SELECT h.name, p1.description as type, h.birthdate, h.commands
FROM horses h
LEFT JOIN packanimals p1 ON p1.pack_animal_id = h.pack_animal_id
UNION
SELECT c.name, p2.description as type, c.birthdate, c.commands
FROM camels c
LEFT JOIN packanimals p2 ON p2.pack_animal_id = c.pack_animal_id
UNION
SELECT d.name, p3.description as type, d.birthdate, d.commands
FROM donkeys d
LEFT JOIN packanimals p3 ON p3.pack_animal_id = d.pack_animal_id
) AS subquery
CROSS JOIN (SELECT @row_number:=0) AS rn;

# *** *** ***
# Удалить записи о верблюдах и объединить таблицы лошадей и ослов.

SELECT horse_id AS id, name, birthdate, commands, pack_animal_id
FROM horses
UNION
SELECT donkey_id AS id, name, birthdate, commands, pack_animal_id
FROM donkeys;

# ИЛИ

SELECT
	(@row_number:=@row_number + 1) AS id,
    name,
    type,
    birthdate,
    commands
FROM (
SELECT h.name, p1.description as type, h.birthdate, h.commands
FROM horses h
LEFT JOIN packanimals p1 ON p1.pack_animal_id = h.pack_animal_id
UNION
SELECT d.name, p3.description as type, d.birthdate, d.commands
FROM donkeys d
LEFT JOIN packanimals p3 ON p3.pack_animal_id = d.pack_animal_id
) AS subquery
CROSS JOIN (SELECT @row_number:=0) AS rn;

# *** *** ***
# Создать новую таблицу для животных в возрасте от 1 до 3 лет и вычислить их возраст с точностью до месяца.

CREATE TABLE IF NOT EXISTS new_table (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(40),
type VARCHAR(15),
birthdate DATE,
age_months INT,
commands VARCHAR(100)
);

INSERT INTO new_table (name, type, birthdate, age_months, commands)
SELECT	
    name,
    type,
    birthdate,
    TIMESTAMPDIFF(MONTH, birthdate, CURRENT_DATE()) as age_months,
    commands
FROM (
SELECT d.name, p1.description as type, d.birthdate, d.commands
FROM dogs d
LEFT JOIN pets p1 ON p1.pet_id = d.pet_id
UNION
SELECT c.name, p2.description as type, c.birthdate, c.commands
FROM cats c
LEFT JOIN pets p2 ON p2.pet_id = c.pet_id
UNION
SELECT h.name, p3.description as type, h.birthdate, h.commands
FROM hamsters h
LEFT JOIN pets p3 ON p3.pet_id = h.pet_id
UNION
SELECT h.name, p1.description as type, h.birthdate, h.commands
FROM horses h
LEFT JOIN packanimals p1 ON p1.pack_animal_id = h.pack_animal_id
UNION
SELECT c.name, p2.description as type, c.birthdate, c.commands
FROM camels c
LEFT JOIN packanimals p2 ON p2.pack_animal_id = c.pack_animal_id
UNION
SELECT d.name, p3.description as type, d.birthdate, d.commands
FROM donkeys d
LEFT JOIN packanimals p3 ON p3.pack_animal_id = d.pack_animal_id
) AS subquery
WHERE 
	TIMESTAMPDIFF(MONTH, birthdate, CURRENT_DATE()) > 12 
AND 
	TIMESTAMPDIFF(MONTH, birthdate, CURRENT_DATE()) <= 3 * 12;

SELECT * FROM new_table;

# *** *** ***
# Объединить все созданные таблицы в одну, сохраняя информацию о принадлежности к исходным таблицам.

SELECT 
	an1.class_id AS animals_class_id, 
    an1.description AS animals_description,
    p1.pet_id AS pets_id, 
    p1.class_id AS pets_class_id, 
    p1.description AS pets_description,
    d.dog_id AS type_id, 
    d.pet_id AS type_pet_id, 
    d.name AS type_name, 
    d.birthdate AS type_birthdate, 
    d.commands AS type_commands  
FROM dogs d
LEFT JOIN pets p1 ON p1.pet_id = d.pet_id
LEFT JOIN animals an1 ON an1.class_id = p1.class_id

UNION
SELECT
	an2.class_id AS animals_class_id, 
    an2.description AS animals_description,
    p2.pet_id AS pets_id, 
    p2.class_id AS pets_class_id, 
    p2.description AS pets_description,
    c.cat_id AS type_id, 
    c.pet_id AS type_pet_id, 
    c.name AS type_name, 
    c.birthdate AS type_birthdate, 
    c.commands AS type_commands
FROM cats c
LEFT JOIN pets p2 ON p2.pet_id = c.pet_id
LEFT JOIN animals an2 ON an2.class_id = p2.class_id

UNION
SELECT 
	an3.class_id AS animals_class_id, 
    an3.description AS animals_description,
    p3.pet_id AS pets_id, 
    p3.class_id AS pets_class_id, 
    p3.description AS pets_description,
    h.hamster_id AS type_id, 
    h.pet_id AS type_pet_id, 
    h.name AS type_name, 
    h.birthdate AS type_birthdate, 
    h.commands AS type_commands
FROM hamsters h
LEFT JOIN pets p3 ON p3.pet_id = h.pet_id
LEFT JOIN animals an3 ON an3.class_id = p3.class_id

UNION
SELECT 
	an4.class_id AS animals_class_id, 
    an4.description AS animals_description,
    pk1.pack_animal_id AS pets_id, 
    pk1.class_id AS pets_class_id, 
    pk1.description AS pets_description,
    hr.horse_id AS type_id, 
    hr.pack_animal_id AS type_pet_id, 
    hr.name AS type_name, 
    hr.birthdate AS type_birthdate, 
    hr.commands AS type_commands
FROM horses hr
LEFT JOIN packanimals pk1 ON pk1.pack_animal_id = hr.pack_animal_id
LEFT JOIN animals an4 ON an4.class_id = pk1.class_id

UNION
SELECT 
	an5.class_id AS animals_class_id, 
    an5.description AS animals_description,
    pk2.pack_animal_id AS pets_id, 
    pk2.class_id AS pets_class_id, 
    pk2.description AS pets_description,
    cm.camel_id AS type_id, 
    cm.pack_animal_id AS type_pet_id, 
    cm.name AS type_name, 
    cm.birthdate AS type_birthdate, 
    cm.commands AS type_commands
FROM camels cm
LEFT JOIN packanimals pk2 ON pk2.pack_animal_id = cm.pack_animal_id
LEFT JOIN animals an5 ON an5.class_id = pk2.class_id

UNION
SELECT 
	an6.class_id AS animals_class_id, 
    an6.description AS animals_description,
    pk3.pack_animal_id AS pets_id, 
    pk3.class_id AS pets_class_id, 
    pk3.description AS pets_description,
    dn.donkey_id AS type_id, 
    dn.pack_animal_id AS type_pet_id, 
    dn.name AS type_name, 
    dn.birthdate AS type_birthdate, 
    dn.commands AS type_commands
FROM donkeys dn
LEFT JOIN packanimals pk3 ON pk3.pack_animal_id = dn.pack_animal_id
LEFT JOIN animals an6 ON an6.class_id = pk3.class_id;
