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
);

CREATE TABLE matches (
	id serial PRIMARY KEY,
	winner INT REFERENCES players (id) ON DELETE CASCADE,
	loser INT REFERENCES players (id) ON DELETE CASCADE
	CHECK (winner <> loser)
);


CREATE VIEW wins AS 
	SELECT players.name, 
		   players.id, 
		   COUNT(matches.winner) AS wins 
	FROM players LEFT JOIN matches ON players.id = matches.winner 
	GROUP BY players.id;

CREATE VIEW losses AS 
	SELECT players.name, 
		   players.id, 
		   COUNT(matches.loser) AS losses
	FROM players LEFT JOIN matches ON players.id = matches.loser 
	GROUP BY players.id;

CREATE VIEW winloss AS 
	SELECT wins.id as id, 
		   wins.name as name, 
		   wins.wins AS wins, 
		   losses.losses AS losses 
	FROM wins, 
		 losses 
	WHERE wins.id = losses.id 
	ORDER BY wins.id;

CREATE VIEW matchcount AS 
	SELECT ID, 
		   SUM(winloss.wins + winloss.losses) AS matchcount 
	FROM winloss 
	GROUP BY winloss.id;

CREATE VIEW standings AS 
	SELECT wins.name, 
		   wins.id, 
		   wins.wins, 
		   matchcount.matchcount
	FROM wins RIGHT JOIN matchcount ON wins.id = matchcount.id 
	GROUP BY wins.id, wins.name, wins.wins, matchcount.matchcount 
	ORDER BY wins.wins DESC;