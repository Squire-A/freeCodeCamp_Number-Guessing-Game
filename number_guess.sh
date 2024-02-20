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
  USERNAME_CHECK=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
else
  # If returning user, get the games played and best game info.
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id = $USERNAME_CHECK")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id = $USERNAME_CHECK")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Initialise GUESS and ask user for their guess
GUESS=0
echo "Guess the secret number between 1 and 1000:"

# Loop while the guess does not equal the random number and increment guess count appropriately"
while [[ $GUESS -ne $RANDOM_NUMBER ]]
do
  read GUESS
  if [[ $GUESS =~ ^(1000|[1-9][0-9]{0,2})$ ]]
  then
    ((GUESS_COUNT++))
    if [[ $GUESS -gt $RANDOM_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
    elif [[ $GUESS -lt $RANDOM_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
    fi
  else
    echo "That is not an integer, guess again:"
  fi
done

# Add game result to database
ADD_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, secret_number, guesses) VALUES ($USERNAME_CHECK, $RANDOM_NUMBER, $GUESS_COUNT)")

# Print final response now number is guessed
echo "You guessed it in $GUESS_COUNT tries. The secret number was $RANDOM_NUMBER. Nice job!"
