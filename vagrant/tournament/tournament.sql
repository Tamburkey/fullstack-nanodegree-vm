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
 name text
);

CREATE TABLE standings (
 playerid serial references players (playerid),
 wins integer,
 losses integer,
 matchcount integer
);

CREATE TABLE matches (
 matchid serial,
 round integer,
 player1 serial references players (playerid),
 player2 serial references players (playerid),
 winner serial references players (playerid),
 loser serial references players (playerid)
);


