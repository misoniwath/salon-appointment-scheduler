#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

CUSTOMER_NAME=""
CUSTOMER_PHONE=""


CREATE_APPOINTMENT() {

  SERVICE_NAME=$($PSQL "SELECT  name FROM services WHERE service_id=$SERVICE_ID_SELECTION")
  CUST_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUST_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME' AND phone='$CUSTOMER_PHONE'")
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/\s//g' -E)
  CUST_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/\s//g' -E)
  echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED, $CUST_NAME_FORMATTED?"
  read SERVICE_TIME
  INSERTED=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ('$CUST_ID', '$SERVICE_ID_SELECTED')")


  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_SELECTION
  HAVE_SERVICE=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_SELECTION")
  if [[ -z $HAVE_SERVICE ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  fi

  echo -e "\nWhat's your phone number?"
  read PHONE

  HAVE_CUSTOMER=$($PSQL "SELECT customer_id, name FROM customers WHERE phone='$PHONE'")
  if [[ -z $HAVE_CUSTOMER ]]
  then
    echo -e "I don't have a record for that phone number, what's your name?"
    read NAME
    INSERTED=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$NAME', '$PHONE')")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_SELECTION")
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE name='$NAME' AND phone='$PHONE'")
    SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/\s//g' -E)
    CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/\s//g' -E)
    echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED, $CUSTOMER_NAME_FORMATTED?"
    read TIME
    echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED, $CUSTOMER_NAME_FORMATTED?"
    
  fi
}

MAIN_MENU

