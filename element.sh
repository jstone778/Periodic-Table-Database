#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER_CHECK=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$1")
    if [[ $ATOMIC_NUMBER_CHECK ]]
    then
      IFS='|' 
      read -r TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE <<< "$ATOMIC_NUMBER_CHECK"
    fi
  elif [[ $1 =~ ^[A-Za-z]{1,2}$ ]]
  then
    SYMBOL_CHECK=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol='$1'")
    if [[ $SYMBOL_CHECK ]]
    then
      IFS='|' 
      read -r TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE <<< "$SYMBOL_CHECK"
    fi
  else
    NAME_CHECK=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name='$1'")
    if [[ $NAME_CHECK ]]
    then
      IFS='|' 
      read -r TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE <<< "$NAME_CHECK"
    fi
  fi

  if [[ $ATOMIC_NUMBER ]]
  then
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  else
    echo -e "I could not find that element in the database."
  fi
else
  echo -e "Please provide an element as an argument."
fi