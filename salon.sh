#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon -t -c"

echo -e "\n~~ Curl Up And Dye Salon ~~\n"
MAIN_MENU () {
  if [[ $1 ]]
  then echo $1
  else echo Welcome! What service are you looking for?
  fi

SERVICES=$($PSQL "SELECT service_id, name, price FROM services ORDER BY service_id")
echo "$SERVICES" | while read ID BAR SERVICE BAR PRICE
do
  echo -e "$ID) $SERVICE $BAR $PRICE\n"
done
echo "Enter the number of the service you're interested in."
read SERVICE_ID_SELECTED
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then MAIN_MENU "Please enter a number."
else SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
if [[ -z $SERVICE_SELECTED ]]
then MAIN_MENU "Please enter the number of a service."
else echo -e "\nWhat is your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]]
then echo -e "\nWhat is your name?"
read CUSTOMER_NAME
INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
fi
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
echo -e "\nHello, $CUSTOMER_NAME. What time would you like your $SERVICE_SELECTED?"
read SERVICE_TIME
APPOINTMENT_MADE=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
echo -e "\nI have put you down for a $SERVICE_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
fi
fi
}
MAIN_MENU
