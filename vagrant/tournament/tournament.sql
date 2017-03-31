-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament;

CREATE TABLE players (
	id serial PRIMARY KEY,
	name text 
	--matchcount integer DEFAULT 0
);

CREATE TABLE matches (
	id serial,
	winner serial REFERENCES players (id),
	loser serial REFERENCES players (id)
);


CREATE VIEW wins AS SELECT players.name, players.id, count(matches.winner) AS wins 
FROM players LEFT JOIN matches ON players.id = matches.winner group by players.id;

CREATE VIEW losses AS SELECT players.name, players.id, count(matches.loser) AS losses
FROM players LEFT JOIN matches ON players.id = matches.loser group by players.id;

CREATE VIEW winloss AS SELECT wins.id as id, wins.name as name, wins.wins AS wins, losses.losses AS losses FROM wins, losses WHERE wins.id = losses.id ORDER BY wins.id;

CREATE VIEW matchcount AS SELECT ID, SUM(winloss.wins + winloss.losses) as matchcount FROM winloss group by winloss.id;

CREATE VIEW standings AS SELECT wins.name, wins.id, wins.wins, matchcount.matchcount
FROM wins RIGHT JOIN matchcount ON wins.id = matchcount.id group by wins.id, wins.name, wins.wins, matchcount.matchcount;