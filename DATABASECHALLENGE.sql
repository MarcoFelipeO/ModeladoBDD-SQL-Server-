create database CHALLENGE;

use CHALLENGE;

USE master;
GO

create table city(
	city_id int primary key identity,
	name nvarchar(80) not null
);

create table stadium(
	stadium_id int primary key identity,
	name nvarchar(80) not null,
	city_id int foreign key references city(city_id)
);

create table teams(
	team_id int primary key identity, 
	name nvarchar(80) not null,
	stadium_id int foreign key references stadium(stadium_id),
	city_id int foreign key references city(city_id)
);

create table players(
	player_id int primary key identity,
	name nvarchar(80) not null,
	number int not null unique,
	hiring_year int not null, /* AÑO CONTRATACION  */
	shirt_number int not null, /* NUMERO POLERA  */
	teams_id int foreign key references teams(team_id)
);

create table matches(
	matche_id int primary key identity,
	match_date date not null,
	team_local_id int foreign key references teams(team_id),
	team_visitor_id int foreign key references teams(team_id),
	result_local int not null,
	result_visitor int not null,
	stadium_id int foreign key references stadium(stadium_id)
);

create table referees(
	referee_id int primary key identity,
	name nvarchar(80) not null,
	hiring_year int not null /* AÑO CONTRATACION */
);

create table match_referee(
	matche_id INT FOREIGN KEY REFERENCES matches(matche_id), /* UNION MUCHOS A MUCHOS ENTRE MATCHES AND REFEREES */
    referee_id INT FOREIGN KEY REFERENCES referees(referee_id),
    rol NVARCHAR(20) CHECK (rol IN ('Main', 'Assistant1', 'Assistant2')),
    PRIMARY KEY (matche_id, referee_id)
);

create table cards(
	card_id int primary key identity,
	matche_id int foreign key references matches(matche_id),
	player_id int foreign key references players(player_id),
	card_type nvarchar(20) check(card_type in ('Yellow','Red')),
	match_minutes int not null
);

create table goals(
	goal_id int primary key identity,
	matche_id int foreign key references matches(matche_id),
	player_id int foreign key references players(player_id),
	match_minutes int not null
);

create table changes(	
	changes_id int primary key identity,
	matche_id int foreign key references matches(matche_id),
	player_exit_id int foreign key references players(player_id),
	player_input_id int foreign key references players(player_id),
	match_minute int not null
);



-- Inserciones en la tabla Ciudad
INSERT INTO city (name) VALUES 
('Madrid'),
('Barcelona'),
('Liverpool'),
('Múnich'),
('Milán'),
('París'),
('Manchester'),
('Turín'),
('Lisboa'),
('Ámsterdam');

-- Inserciones en la tabla Estadio
INSERT INTO stadium (name, city_id) VALUES 
('Santiago Bernabéu', (SELECT city_id FROM city WHERE name = 'Madrid')),
('Camp Nou', (SELECT city_id FROM city WHERE name = 'Barcelona')),
('Anfield', (SELECT city_id FROM city WHERE name = 'Liverpool')),
('Allianz Arena', (SELECT city_id FROM city WHERE name = 'Múnich')),
('San Siro', (SELECT city_id FROM city WHERE name = 'Milán')),
('Parc des Princes', (SELECT city_id FROM city WHERE name = 'París')),
('Old Trafford', (SELECT city_id FROM city WHERE name = 'Manchester')),
('Juventus Stadium', (SELECT city_id FROM city WHERE name = 'Turín')),
('Estádio da Luz', (SELECT city_id FROM city WHERE name = 'Lisboa')),
('Johan Cruyff Arena', (SELECT city_id FROM city WHERE name = 'Ámsterdam'));


-- Inserciones en la tabla Equipos
INSERT INTO teams (name, stadium_id, city_id) VALUES 
('Real Madrid', (SELECT stadium_id FROM stadium WHERE name = 'Santiago Bernabéu'), (SELECT city_id FROM city WHERE name = 'Madrid')),
('FC Barcelona', (SELECT stadium_id FROM stadium WHERE name = 'Camp Nou'), (SELECT city_id FROM city WHERE name = 'Barcelona')),
('Liverpool FC', (SELECT stadium_id FROM stadium WHERE name = 'Anfield'), (SELECT city_id FROM city WHERE name = 'Liverpool')),
('Bayern Múnich', (SELECT stadium_id FROM stadium WHERE name = 'Allianz Arena'), (SELECT city_id FROM city WHERE name = 'Múnich')),
('AC Milan', (SELECT stadium_id FROM stadium WHERE name = 'San Siro'), (SELECT city_id FROM city WHERE name = 'Milán')),
('Paris Saint-Germain', (SELECT stadium_id FROM stadium WHERE name = 'Parc des Princes'), (SELECT city_id FROM city WHERE name = 'París')),
('Manchester United', (SELECT stadium_id FROM stadium WHERE name = 'Old Trafford'), (SELECT city_id FROM city WHERE name = 'Manchester')),
('Juventus', (SELECT stadium_id FROM stadium WHERE name = 'Juventus Stadium'), (SELECT city_id FROM city WHERE name = 'Turín')),
('Benfica', (SELECT stadium_id FROM stadium WHERE name = 'Estádio da Luz'), (SELECT city_id FROM city WHERE name = 'Lisboa')),
('Ajax', (SELECT stadium_id FROM stadium WHERE name = 'Johan Cruyff Arena'), (SELECT city_id FROM city WHERE name = 'Ámsterdam'));


-- Inserciones en la tabla Jugadores
INSERT INTO players (name, number, hiring_year, shirt_number, teams_id) VALUES 
('Vinícius Júnior', 20, 2018, 20, (SELECT team_id FROM teams WHERE name = 'Real Madrid')),
('Lionel Messi', 10, 2000, 10, (SELECT team_id FROM teams WHERE name = 'FC Barcelona')),
('Sergio Busquets', 5, 2008, 5, (SELECT team_id FROM teams WHERE name = 'FC Barcelona')),
('Mohamed Salah', 11, 2017, 11, (SELECT team_id FROM teams WHERE name = 'Liverpool FC')),
('Virgil van Dijk', 4, 2018, 4, (SELECT team_id FROM teams WHERE name = 'Liverpool FC')),
('Robert Lewandowski', 9, 2014, 9, (SELECT team_id FROM teams WHERE name = 'Bayern Múnich')),
('Manuel Neuer', 1, 2011, 1, (SELECT team_id FROM teams WHERE name = 'Bayern Múnich')),
('Cristiano Ronaldo', 7, 2018, 7, (SELECT team_id FROM teams WHERE name = 'Juventus'));

-- Inserciones en la tabla Partidos
INSERT INTO matches (match_date, team_local_id, team_visitor_id, result_local, result_visitor, stadium_id) VALUES 
('2024-08-10', (SELECT team_id FROM teams WHERE name = 'Real Madrid'), (SELECT team_id FROM teams WHERE name = 'FC Barcelona'), 2, 1, (SELECT stadium_id FROM stadium WHERE name = 'Santiago Bernabéu')),
('2024-08-11', (SELECT team_id FROM teams WHERE name = 'Liverpool FC'), (SELECT team_id FROM teams WHERE name = 'Manchester United'), 3, 0, (SELECT stadium_id FROM stadium WHERE name = 'Anfield')),
('2024-08-12', (SELECT team_id FROM teams WHERE name = 'Bayern Múnich'), (SELECT team_id FROM teams WHERE name = 'Paris Saint-Germain'), 1, 1, (SELECT stadium_id FROM stadium WHERE name = 'Allianz Arena')),
('2024-08-13', (SELECT team_id FROM teams WHERE name = 'AC Milan'), (SELECT team_id FROM teams WHERE name = 'Benfica'), 2, 2, (SELECT stadium_id FROM stadium WHERE name = 'San Siro')),
('2024-08-14', (SELECT team_id FROM teams WHERE name = 'Ajax'), (SELECT team_id FROM teams WHERE name = 'Juventus'), 1, 1, (SELECT stadium_id FROM stadium WHERE name = 'Johan Cruyff Arena'));

-- Inserciones en la tabla Árbitros
INSERT INTO referees (name, hiring_year) VALUES 
('César Ramos', 2010),
('Antonio Mateu Lahoz', 2008),
('Sandro Ricci', 2013),
('Michael Oliver', 2015),
('Björn Kuipers', 2006);

-- Inserciones en la tabla Partido_Arbitro
INSERT INTO match_referee (matche_id, referee_id, rol) VALUES 
(1, (SELECT referee_id FROM referees WHERE name = 'César Ramos'), 'Main'),
(1, (SELECT referee_id FROM referees WHERE name = 'Antonio Mateu Lahoz'), 'Assistant1'),
(1, (SELECT referee_id FROM referees WHERE name = 'Sandro Ricci'), 'Assistant2'),
(2, (SELECT referee_id FROM referees WHERE name = 'Michael Oliver'), 'Main'),
(2, (SELECT referee_id FROM referees WHERE name = 'Björn Kuipers'), 'Assistant1'),
(3, (SELECT referee_id FROM referees WHERE name = 'César Ramos'), 'Main'),
(3, (SELECT referee_id FROM referees WHERE name = 'Antonio Mateu Lahoz'), 'Assistant1'),
(4, (SELECT referee_id FROM referees WHERE name = 'Sandro Ricci'), 'Main'),
(4, (SELECT referee_id FROM referees WHERE name = 'Michael Oliver'), 'Assistant1'),
(5, (SELECT referee_id FROM referees WHERE name = 'Björn Kuipers'), 'Main');

-- Inserciones en la tabla Tarjetas
INSERT INTO cards (matche_id, player_id, card_type, match_minutes) VALUES 
(1, (SELECT player_id FROM players WHERE name = 'Karim Benzema'), 'Yellow', 30),
(1, (SELECT player_id FROM players WHERE name = 'Lionel Messi'), 'Red', 75),
(2, (SELECT player_id FROM players WHERE name = 'Mohamed Salah'), 'Yellow', 40),
(2, (SELECT player_id FROM players WHERE name = 'Virgil van Dijk'), 'Yellow', 55),
(3, (SELECT player_id FROM players WHERE name = 'Robert Lewandowski'), 'Red', 70),
(3, (SELECT player_id FROM players WHERE name = 'Manuel Neuer'), 'Yellow', 65),
(4, (SELECT player_id FROM players WHERE name = 'Paolo Dybala'), 'Yellow', 15),
(4, (SELECT player_id FROM players WHERE name = 'Cristiano Ronaldo'), 'Red', 80),
(5, (SELECT player_id FROM players WHERE name = 'Paolo Dybala'), 'Yellow', 50),
(5, (SELECT player_id FROM players WHERE name = 'Cristiano Ronaldo'), 'Red', 90);

-- Inserciones en la tabla Goles
INSERT INTO goals (matche_id, player_id, match_minutes) VALUES 
(1, (SELECT player_id FROM players WHERE name = 'Karim Benzema'), 40),
(1, (SELECT player_id FROM players WHERE name = 'Lionel Messi'), 55),
(1, (SELECT player_id FROM players WHERE name = 'Karim Benzema'), 60),
(2, (SELECT player_id FROM players WHERE name = 'Mohamed Salah'), 50),
(2, (SELECT player_id FROM players WHERE name = 'Virgil van Dijk'), 60),
(3, (SELECT player_id FROM players WHERE name = 'Robert Lewandowski'), 45),
(3, (SELECT player_id FROM players WHERE name = 'Manuel Neuer'), 60),
(4, (SELECT player_id FROM players WHERE name = 'Paolo Dybala'), 20),
(4, (SELECT player_id FROM players WHERE name = 'Cristiano Ronaldo'), 80),
(5, (SELECT player_id FROM players WHERE name = 'Paolo Dybala'), 70);


-- Inserciones en la tabla Cambios
INSERT INTO changes (matche_id, player_exit_id, player_input_id, match_minute) VALUES 
(1, (SELECT player_id FROM players WHERE name = 'Lionel Messi'), (SELECT player_id FROM players WHERE name = 'Vinícius Júnior'), 70),
(2, (SELECT player_id FROM players WHERE name = 'Mohamed Salah'), (SELECT player_id FROM players WHERE name = 'Virgil van Dijk'), 55),
(3, (SELECT player_id FROM players WHERE name = 'Robert Lewandowski'), (SELECT player_id FROM players WHERE name = 'Manuel Neuer'), 65),
(4, (SELECT player_id FROM players WHERE name = 'Cristiano Ronaldo'), (SELECT player_id FROM players WHERE name = 'Paolo Dybala'), 50),
(5, (SELECT player_id FROM players WHERE name = 'Paolo Dybala'), (SELECT player_id FROM players WHERE name = 'Cristiano Ronaldo'), 70);


select * from players;

select * from changes;

select * from cards;

select * from matches;

/*1.- Cantidad de tarjetas rojas por equipo por año  necesito esta consulta */

SELECT
    t.name AS TeamName,
    YEAR(m.match_date) AS Year,
    COUNT(c.card_id) AS RedCards
FROM
    cards c
JOIN
    matches m ON c.matche_id = m.matche_id
JOIN
    players p ON c.player_id = p.player_id
JOIN
    teams t ON p.teams_id = t.team_id
WHERE
    c.card_type = 'Red' GROUP BY t.name, YEAR(m.match_date) ORDER BY t.name, Year;

/*2.- Cantidad de tarjetas amarillas por jugador */

SELECT 
	p.name as NombreJugador,
	COUNT(c.card_id) as YellowCards
FROM
	players p
JOIN
	CARDS c
ON 
	p.player_id = c.player_id
WHERE
	c.card_type = 'Yellow' group by p.name order by YellowCards desc;

/*3.- Equipo que metió más goles en el segundo tiempo */
SELECT 
	t.name as TeamsName,
	count(g.goal_id) as NumberGoalsSecondHalf /* NUMERO DE GOLES EN EL SEGUNDO TIEMPO ;)*/
FROM
	teams t JOIN goals g 
ON 
	t.team_id = g.goal_id 
where 
	g.match_minutes >45 GROUP BY t.name ORDER BY NumberGoalsSecondHalf;

/*4.- Jugador que más ha sido sustituido  */
SELECT 
	p.name as PlayerName,
	count(c.player_exit_id) as CountChanges
FROM 
	players p 
JOIN
	changes c 
ON 
	p.player_id = c.player_exit_id
GROUP BY 
	p.name 
ORDER BY 
	CountChanges DESC;

	select * from changes join matches on changes.changes_id=matches.matche_id;
/*5.-Equipos con más goles de visita  */
SELECT 
    t.name AS TeamName,
    COUNT(g.goal_id) AS GoalsVisitor
FROM 
    goals g
JOIN 
    matches m on g.matche_id = m.matche_id
JOIN 
    players p on g.player_id = p.player_id
JOIN 
    teams t on p.teams_id = t.team_id
WHERE 
    m.team_visitor_id = t.team_id GROUP BY t.name ORDER BY GoalsVisitor DESC;

