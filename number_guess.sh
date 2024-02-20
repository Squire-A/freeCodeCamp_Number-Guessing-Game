#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Generate random number
RANDOM_NUMBER=$((1 + $RANDOM % 1000))
# Set guesses for game to 0
GUESS_COUNT=0

echo "Enter your username:"
read USERNAME

# Check username is not too long or blank
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

USERNAME_CHECK=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")

if [[ -z $USERNAME_CHECK ]]
then
  # If user not found, add user to database.
  INSERT_USERNAME=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  # If returning user, get the games played and best game info.
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id = $USERNAME_CHECK")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id = $USERNAME_CHECK")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

