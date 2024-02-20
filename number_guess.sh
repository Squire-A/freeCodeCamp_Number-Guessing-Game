#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

RANDOM_NUMBER=$((1 + $RANDOM % 1000))
GUESS_COUNT=0

echo "Enter your username:"
read USERNAME

while [[ ${#USERNAME} -gt 22 ]]
do
  echo "That username is too long, please enter a shorter one:"
  read USERNAME
done