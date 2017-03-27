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
	playerid serial PRIMARY KEY,
	name text,
	--wins integer DEFAULT 0, 
	matchcount integer DEFAULT 0
);

CREATE TABLE matches (
	matchid serial,
	winner serial REFERENCES players (playerid)
	--loser serial REFERENCES players (playerid)
);

CREATE VIEW standings AS SELECT players.name, players.playerid, players.matchcount, count(matches.winner) as wins from players left join matches on players.playerid = matches.winner group by players.playerid;


