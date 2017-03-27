#!/usr/bin/env python
# 
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2


def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    return psycopg2.connect("dbname=tournament")

def deleteMatches():
    """Remove all the match records from the database."""
    conn = connect()
    cursor = conn.cursor()
    cursor.execute(
        "DELETE FROM matches")
    cursor.execute(
        "UPDATE players SET matchcount = 0")
    conn.commit()
    conn.close()

def deletePlayers():
    """Remove all the player records from the database."""
    conn = connect()
    cursor = conn.cursor()
    cursor.execute(
        "DELETE FROM players")
    conn.commit()
    conn.close()

def countPlayers():
    """Returns the number of players currently registered."""
    conn = connect()
    cursor = conn.cursor()
    cursor.execute(
        "SELECT COUNT(*) FROM players")
    results = cursor.fetchall()
    return results[0][0]
    conn.close()

def registerPlayer(name):
    """Adds a player to the tournament database.
  
    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)
  
    Args:
      name: the player's full name (need not be unique).
    """
    conn = connect()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO players (name) VALUES (%s)",
        (name,))
    conn.commit()
    conn.close()

def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    conn = connect()
    cursor = conn.cursor()
    cursor.execute(
        "SELECT * FROM standings ORDER BY wins DESC")

    results = cursor.fetchall()
    standings_list = []
    for row in results:
        # row[0]=name, 1=id, 2=matches, 3=wins
        standings_list.append([row[1],row[0],row[3],row[2]])
    return standings_list

def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    conn = connect()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE players SET matchcount = matchcount+1 WHERE id = (%s)",
        (winner,))
    cursor.execute(
        "UPDATE players SET matchcount = matchcount+1 WHERE id = (%s)",
        (loser,))
    cursor.execute(
        "INSERT INTO matches (winner) VALUES (%s)",
        (winner,))

    conn.commit()
    conn.close()
 
def swissPairings():
    """Returns a list of pairs of players for the next round of a match.
  
    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.
  
    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    conn = connect()
    cursor = conn.cursor()
    cursor.execute(
        "SELECT * FROM standings ORDER BY wins;")
    results = cursor.fetchall()
    pair_list1 = []
    pair_list2 = []
    fin_list=[]
    i = 0

    for row in results:
        i += 1
        if i % 2 != 0:
            pair_list1.append([row[1], row[0]])
        else:
            pair_list2.append([row[1], row[0]])
    for l in range(0,len(pair_list1)):
        fin_list.append(pair_list1[l]+pair_list2[l])
    return fin_list







