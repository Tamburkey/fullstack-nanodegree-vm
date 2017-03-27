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
	name text, 
	matchcount integer DEFAULT 0
);

CREATE TABLE matches (
	id serial,
	winner serial REFERENCES players (id)
);

CREATE VIEW standings AS SELECT players.name, players.id, players.matchcount, count(matches.winner) as wins from players left join matches on players.id = matches.winner group by players.id;


