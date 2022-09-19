#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

#Insert teams
cat games.csv |while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" && $OPPONENT != "opponent" ]]
  then
    #Get winner team Id
    TEAM_WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #Get opponent team Id
    TEAM_OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #If winner not found
    if [[ -z $TEAM_WIN_ID ]]
    then
      #Insert winner team
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    #If opponent not found
    elif [[ -z $TEAM_OPP_ID ]]
    then
      #Insert opponent team
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi
done

cat games.csv |while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" && $ROUND != "round" ]]
  then 
    #Get winner team Id
    TEAM_WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #Get opponent team Id
    TEAM_OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #Insert games
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$TEAM_WIN_ID', '$TEAM_OPP_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
      if [[ $INSERT_GAME == "INSERT 0 1" ]]
      then
        echo Inserted into GAME, $WINNER - $OPPONENT
      fi
  fi
done