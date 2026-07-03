#!/bin/sh

ACTION=$1

echo "Waiting for Debezium Connect to be available..."

# Wait until the Connect API returns a 200 OK
until curl -s -o /dev/null -w "%{http_code}" http://connect:8083/connectors | grep -q "200"; do
  printf '.'
  sleep 2
done

printf "\nDebezium Connect is up!"

if [ "$ACTION" = "DELETE" ]; then
  echo "Deleting existing connector 'smat-connector' if it exists..."
  curl -s -X DELETE http://connect:8083/connectors/smat-connector
  sleep 2
fi

# Check if the specific connector already exists (returns 200 if yes, 404 if no)
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://connect:8083/connectors/smat-connector)

if [ "$status_code" = "200" ]; then
  echo "Connector 'smat-connector' already exists. Skipping registration."
else
  echo "Registering smat-connector..."
  curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" http://connect:8083/connectors/ -d @/init/connector-config.json
  printf "\nConnector registration request sent."
fi
