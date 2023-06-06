#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU(){

if [[ $1 ]]
then
  echo -e "\n$1\n"
fi

SERVICES=$($PSQL "SELECT service_id, name FROM services;")

echo "$SERVICES" | while read SERVICE_ID BAR NAME 
do
echo -e "$SERVICE_ID) $NAME\n"
done

read SERVICE_ID_SELECTED

IS_AVAIL=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $IS_AVAIL ]]
then
  MAIN_MENU "Please enter a valid selection."
else
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    echo $($PSQL "INSERT INTO customers (phone, name) VAlUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  echo -e "\nWhat time would you like your$SERVICE_NAME,$CUSTOMER_NAME?"
  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  #echo $CUSTOMER_ID
  echo $($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/\s//g' -E)
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/\s//g' -E)

  echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."

fi


}



MAIN_MENU
