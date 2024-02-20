#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

RANDOM_NUMBER=$((1 + $RANDOM % 1000))
GUESS_COUNT=0

echo "Enter your username:"
read USERNAME

while [[ ${#USERNAME} -gt 22 || -z $USERNAME ]] 
do
  if [[ ${#USERNAME} -gt 22 ]]
  then
    echo "That username is too long, please enter a shorter one:"
  else
    echo "Sorry something went wrong, please re-enter your username:" 
  fi
  read USERNAME
done
