#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#TEST_SQL=$($PSQL "SELECT * FROM elements")

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
  if [[ -z $ATOMIC_NUMBER ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  fi
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
  else
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
    ATOMIC_NUMBER_FORMAT=$(echo $ATOMIC_NUMBER | sed 's/ *//g')
    NAME_FORMAT=$(echo $NAME | sed 's/ *//g')
    SYMBOL_FORMAT=$(echo $SYMBOL | sed 's/ *//g')
    TYPE_FORMAT=$(echo $TYPE | sed 's/ *//g')
    MASS_FORMAT=$(echo $MASS | sed 's/ *//g')
    MELTING_FORMAT=$(echo $MELTING | sed 's/ *//g')
    BOILING_FORMAT=$(echo $BOILING | sed 's/ *//g')
    echo -e "The element with atomic number $ATOMIC_NUMBER_FORMAT is $NAME_FORMAT ($SYMBOL_FORMAT). It's a $TYPE_FORMAT, with a mass of $MASS_FORMAT amu. $NAME_FORMAT has a melting point of $MELTING_FORMAT celsius and a boiling point of $BOILING_FORMAT celsius."
  fi
fi