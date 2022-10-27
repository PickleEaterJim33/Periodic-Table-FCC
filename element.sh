#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 1
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1")
else
  ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol = '$1' OR name = '$1'")
fi

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit 1
fi

echo "$ELEMENT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
do
  PROPERTIES=$($PSQL "SELECT atomic_number, type, ROUND(weight, 3), melting_point, boiling_point FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  echo "$PROPERTIES" | while read ATOMIC_MUMBER BAR TYPE BAR WEIGHT BAR MELTING_POINT BAR BOILING_POINT
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. Hydrogen has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
done
