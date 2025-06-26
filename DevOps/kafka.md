# Kafka

Start Kafka locally with docker:

```bash
docker network create kafka-net

# Start Zookeeper
docker run -d --name zookeeper --network kafka-net -p 2181:2181 \
  -e ZOOKEEPER_CLIENT_PORT=2181 \
  confluentinc/cp-zookeeper:7.6.0

# Start Kafka
docker run -d --name kafka --network kafka-net -p 9092:9092 \
  -e KAFKA_BROKER_ID=1 \
  -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
  -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092 \
  -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
  confluentinc/cp-kafka:7.6.0
```
Then connect to Kafka at localhost:9092.


## Create topic

```bash
docker exec -it kafka bash
kafka-topics \
  --bootstrap-server localhost:9092 \
  --create \
  --topic my-test-topic \
  --partitions 1 \
  --replication-factor 1
kafka-topics --bootstrap-server localhost:9092 --list
```
