CREATE TABLE Colors(
    color_id integer PRIMARY KEY AUTOINCREMENT,
    name varchar(20));
INSERT INTO Colors(name) SELECT DISTINCT(temp_table.color) as color from
(SELECT DISTINCT(rtrim(color1)) as color FROM animals where color1 is not NULL
UNION ALL
SELECT DISTINCT(rtrim(color2)) as color FROM animals  where color2 is not NULL) as temp_table;


CREATE TABLE Animals_new(
    `index` integer  PRIMARY KEY UNIQUE,
    animal_id varchar(20),
    name varchar(20),
    date_of_birth date);
INSERT INTO Animals_new(animal_id,`index`,name,date_of_birth) SELECT animal_id, `index`,name,date_of_birth from animals;


CREATE TABLE Animal_colors(
    id integer PRIMARY KEY AUTOINCREMENT,
    animal_id integer,
    color_id integer,
    FOREIGN KEY (animal_id) REFERENCES Animals_new(animal_id) ON DELETE CASCADE,
    FOREIGN KEY (color_id) REFERENCES Colors(color_id) ON DELETE CASCADE);
INSERT INTO Animal_colors(animal_id, color_id) SELECT animal_id, color_id from
(SELECT animal_id, color_id from animals
JOIN Colors ON rtrim(color1) like Colors.name
union all
SELECT animal_id, color_id from animals
JOIN Colors ON rtrim(color2) = Colors.name);


CREATE TABLE outcomes(
    outcome_id integer PRIMARY KEY AUTOINCREMENT,
    animal_id varchar(20),
    outcome_subtype varchar(20),
    outcome_type varchar(20),
    outcome_month varchar(10),
    outcome_year varchar(10),
    age_upon_outcome  varchar(10),
    FOREIGN KEY (animal_id) REFERENCES Animals_new(animal_id) ON DELETE CASCADE
    );
INSERT INTO outcomes(animal_id, outcome_subtype, outcome_type, outcome_month, outcome_year, age_upon_outcome)
SELECT animal_id, outcome_subtype, outcome_type, outcome_month, outcome_year, age_upon_outcome FROM animals;

CREATE TABLE animal_type(
    id integer PRIMARY KEY AUTOINCREMENT,
    name varchar(20));
INSERT INTO animal_type(name) SELECT DISTINCT(animal_type) FROM animals;

ALTER TABLE Animals_new
ADD animal_type_id integer REFERENCES animal_type(id);

UPDATE Animals_new
set animal_type_id = (SELECT id from animal_type
join Animals on animal_type.name=animals.animal_type
where Animals.animal_id = Animals_new.animal_id
);

CREATE TABLE Breeds(
    id integer PRIMARY KEY AUTOINCREMENT,
    name varchar(20));
INSERT INTO Breeds(name) SELECT DISTINCT(breed) FROM animals;


ALTER TABLE Animals_new
ADD breeds_id integer REFERENCES Breeds(id);


UPDATE Animals_new
set breeds_id = (SELECT id from Breeds
join Animals on Breeds.name=animals.breed
where Animals.animal_id = Animals_new.animal_id
);

SELECT Animals_new.`index`, Animals_new.animal_id, Animals_new.name, Animals_new.animal_type_id,Breeds.name as Breeds,date_of_birth, group_concat(distinct colors.name) as colors, outcome_subtype, outcome_type, outcome_month, outcome_year, age_upon_outcome from Animals_new
left join Animal_colors on Animals_new.animal_id = Animal_colors.animal_id
left join  Colors on colors.color_id = Animal_colors.color_id
left join  outcomes on outcomes.animal_id = Animals_new.animal_id
left join Breeds on Breeds.id=breeds_id
group by Animals_new.animal_id
order by Animals_new.`index`


