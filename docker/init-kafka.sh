#!/bin/sh

# Create the smat.acidentes topic
echo "Creating kafka topics..."
/opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --if-not-exists --topic smat.acidentes --replication-factor 1 --partitions 1

echo "Kafka initialization complete."
