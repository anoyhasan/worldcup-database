#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Get unique teams and insert them into teams table
cat games.csv | tail -n +2 | cut -d',' -f3 | sort -u | while read team
do
  $PSQL "INSERT INTO teams(name) VALUES('$team');"
done

cat games.csv | tail -n +2 | cut -d',' -f4 | sort -u | while read team
do
  $PSQL "INSERT INTO teams(name) VALUES('$team') ON CONFLICT (name) DO NOTHING;"
done

# Insert unique teams
cat games.csv | tail -n +2 | cut -d',' -f3 | sort -u | while read team
do
  $PSQL "INSERT INTO teams(name) VALUES('$team') ON CONFLICT (name) DO NOTHING"
done

cat games.csv | tail -n +2 | cut -d',' -f4 | sort -u | while read team
do
  $PSQL "INSERT INTO teams(name) VALUES('$team') ON CONFLICT (name) DO NOTHING"
done

# Insert games
cat games.csv | tail -n +2 | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

  $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
  VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)"
done