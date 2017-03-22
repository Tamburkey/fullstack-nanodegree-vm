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
	wins integer DEFAULT 0,
	matchcount integer DEFAULT 0
);

CREATE TABLE matches (
	matchid serial,
	winner serial references players (playerid),
	loser serial references players (playerid)
);


