#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

ASK_UNTIL_INT() {
  while [[ ! $NUMBER_TO_GUESS =~ ^[0-9]+$ ]]
  do
    echo That is not an integer, guess again:
    read NUMBER_TO_GUESS
  done
}

echo Enter your username:
read USERNAME

DIV=$((1000))
R=$(expr $(($RANDOM%$DIV)) + 1)

TEST_USERNAME=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
if [[ -z $TEST_USERNAME ]]
then
  echo Welcome, $USERNAME! It looks like this is your first time here.
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id='$TEST_USERNAME'")
  BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE user_id='$TEST_USERNAME'")
  echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
fi
echo Guess the secret number between 1 and 1000:
read NUMBER_TO_GUESS
if [[ ! $NUMBER_TO_GUESS =~ ^[0-9]+$ ]]
then
  ASK_UNTIL_INT
fi
NUMBER_OF_GUESSES=1
while [[ $NUMBER_TO_GUESS != $R ]]
do 
  if [[ $NUMBER_TO_GUESS > $R ]]
  then
    echo It\'s lower than that, guess again:
  elif [[ $NUMBER_TO_GUESS < $R ]]
  then 
    echo It\'s higher than that, guess again:
  fi
  read NUMBER_TO_GUESS
  if [[ ! $NUMBER_TO_GUESS =~ ^[0-9]+$ ]]
  then
  ASK_UNTIL_INT
  fi
  (( NUMBER_OF_GUESSES++ ))
done 

if [[ -z $TEST_USERNAME ]]
then
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  TEST_USERNAME=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
fi

INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, number_of_guesses, number_to_guess) VALUES($TEST_USERNAME, $NUMBER_OF_GUESSES, $R)")

echo You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $R. Nice job!
