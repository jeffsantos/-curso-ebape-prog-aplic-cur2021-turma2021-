------------------------------------------------------------------------------
-- Lista Acumulativa de Comandos usados em Aula
------------------------------------------------------------------------------


CREATE DATABASE flightsdb;

CREATE TABLE flights (
    id SERIAL PRIMARY KEY,
    origin VARCHAR NOT NULL,
    destination VARCHAR NOT NULL,
    duration INTEGER NOT NULL
);

INSERT INTO flights (origin, destination, duration) VALUES ('New York', 'London', 415);
INSERT INTO flights (origin, destination, duration) VALUES ('Shangai', 'Paris', 760);
INSERT INTO flights (origin, destination, duration) VALUES ('Istanbul', 'Tokyo', 700);
INSERT INTO flights (origin, destination, duration) VALUES ('New York', 'Paris', 435);
INSERT INTO flights (origin, destination, duration) VALUES ('Moscow', 'Paris', 245);
INSERT INTO flights (origin, destination, duration) VALUES ('Lima', 'New York', 455);

SELECT * FROM flights;

SELECT origin, destination FROM flights;

SELECT * FROM flights WHERE id = 3;

SELECT * FROM flights WHERE origin = 'New York';

SELECT * FROM flights WHERE duration > 700;

SELECT * FROM flights WHERE destination = 'Paris' AND duration > 700;

SELECT * FROM flights WHERE destination = 'Paris' OR duration >= 700;

SELECT AVG(duration) FROM flights;

SELECT AVG(duration) FROM flights WHERE origin = 'New York';

SELECT COUNT(duration) FROM flights;

SELECT COUNT(duration) FROM flights WHERE origin = 'New York';

SELECT * FROM flights WHERE origin IN ('New York', 'Lima');

SELECT * FROM flights WHERE origin LIKE 'New%';

SELECT UPPER(origin), UPPER(destination) FROM flights WHERE destination = 'Paris';

SELECT UPPER(origin), UPPER(destination) FROM flights WHERE UPPER(destination) = 'PARIS';

SELECT UPPER(origin), UPPER(destination) FROM flights WHERE LOWER(destination) = 'paris';

--------------------------
SELECT * FROM flights LIMIT 3;

SELECT * FROM flights ORDER BY duration ASC;


SELECT destination, COUNT(destination) FROM flights
GROUP BY destination;

SELECT destination, COUNT(*) FROM flights
GROUP BY destination;

-- Vai dar erro (o campo origin aparece no SELECT, mas não no GROUP BY):
SELECT destination, origin, count(*) FROM flights
GROUP BY destination;


SELECT destination, COUNT(*), SUM(duration) FROM flights
GROUP BY destination;


SELECT destination, COUNT(*) FROM flights
GROUP BY destination
HAVING COUNT(*) > 1;

SELECT destination, COUNT(*) FROM flights GROUP BY destination HAVING COUNT(*) > 1;

--------------------------
-- 09/08/2021

UPDATE flights
  SET duration = 430
  WHERE origin = 'New York'
  AND destination = 'London';

DELETE FROM flights WHERE origin = 'New York';

-- Não confundir o DELETE com o DROP
-- DELETE age sobre os dados
-- DROP age sobra a estrutura (serve para remover um objeto (uma tabela, o próprio banco de dados)
-- Exemplo: 

DROP TABLE flights;

DROP DATABASE flightdb; 

--------------------------
-- 12/08/2021

CREATE TABLE locations (
    id_location SERIAL PRIMARY KEY,
    code VARCHAR NOT NULL,
    name VARCHAR NOT NULL
);

select * from locations;

INSERT INTO locations (code, name) VALUES ('JFK', 'New York');
INSERT INTO locations (code, name) VALUES ('PVG', 'Shanghai');
INSERT INTO locations (code, name) VALUES ('IST', 'Instanbul');
INSERT INTO locations (code, name) VALUES ('LHR', 'London');
INSERT INTO locations (code, name) VALUES ('SVO', 'Moscow');
INSERT INTO locations (code, name) VALUES ('LIM', 'Lima');
INSERT INTO locations (code, name) VALUES ('CDG', 'Paris');
INSERT INTO locations (code, name) VALUES ('NRT', 'Shanghai');
INSERT INTO locations (code, name) VALUES ('GIG', 'Rio de Janeiro');
INSERT INTO locations (code, name) VALUES ('DEL', 'New Delhi');


CREATE TABLE flights (
    id_flight SERIAL PRIMARY KEY,
    id_location_orig INTEGER NOT NULL REFERENCES locations,
    id_location_dest INTEGER NOT NULL REFERENCES locations,
    duration INTEGER NOT NULL    

);

select * from flights;

INSERT INTO flights (id_location_orig, id_location_dest, duration) VALUES (1, 4, 415);
INSERT INTO flights (id_location_orig, id_location_dest, duration) VALUES (2, 7, 760);
INSERT INTO flights (id_location_orig, id_location_dest, duration) VALUES (3, 8, 700);
INSERT INTO flights (id_location_orig, id_location_dest, duration) VALUES (1, 7, 435);
INSERT INTO flights (id_location_orig, id_location_dest, duration) VALUES (5, 7, 245);
INSERT INTO flights (id_location_orig, id_location_dest, duration) VALUES (6, 1, 455);

-- Vai dar erro porque um dos ids n:
INSERT INTO flights (id_location_orig, id_location_dest, duration) VALUES (2, 11, 455);

--------------------------
-- 16/08/2021

CREATE TABLE passengers (
    id_passenger SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    id_flight INTEGER NULL REFERENCES flights
);

INSERT INTO passengers (name, id_flight) VALUES ('Alice', 1);
INSERT INTO passengers (name, id_flight) VALUES ('Bob', 1);
INSERT INTO passengers (name, id_flight) VALUES ('Charlie', 2);
INSERT INTO passengers (name, id_flight) VALUES ('Dave', 2);
INSERT INTO passengers (name, id_flight) VALUES ('Erin', 4);
INSERT INTO passengers (name, id_flight) VALUES ('Frank', 6);
INSERT INTO passengers (name, id_flight) VALUES ('Grace', 6);


-- INNER JOINs

-- Estrutura do Comando SELECT com JOIN:
--
-- SELECT <lista-de-colunas-separadas-por-virgula-ou-*>
-- FROM <nome-de-uma-tabela>
-- INNER JOIN <nome-de-outra-tabela> ON <chave-primeira-tabela> = <chave-segunda-tabela>

-- Passageiros e seus vôos:
select * from passengers
INNER JOIN flights on passengers.id_flight = flights.id_flight;

select passengers.*, flights.duration from passengers
INNER JOIN flights on passengers.id_flight = flights.id_flight;

select passengers.name, flights.duration from passengers
INNER JOIN flights on passengers.id_flight = flights.id_flight;

-- Usando alias:

select p.name, f.duration 
from passengers p
INNER JOIN flights f on p.id_flight = f.id_flight;


-- Removendo resultados duplicados com DISTINCT:

select DISTINCT id_flight from passengers ORDER BY id_flight;

select DISTINCT id_flight from passengers ORDER BY 1;

-- Vôos e suas localizações

SELECT *
FROM flights f
INNER JOIN locations lo ON f.id_location_orig = lo.id_location
INNER JOIN locations ld ON f.id_location_dest = ld.id_location;

SELECT f.id_flight, lo.name, ld.name, f.duration
FROM flights f
INNER JOIN locations lo ON f.id_location_orig = lo.id_location
INNER JOIN locations ld ON f.id_location_dest = ld.id_location;

-- Vai dar erro, porque a coluna nome está duplicada. CREATE
-- Precisa usar alias, como no exemplo acima.
SELECT f.id_flight, name, f.duration
FROM flights f
INNER JOIN locations lo ON f.id_location_orig = lo.id_location
INNER JOIN locations ld ON f.id_location_dest = ld.id_location;