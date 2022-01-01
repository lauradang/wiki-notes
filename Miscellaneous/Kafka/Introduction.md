# Introduction to Kafka

[Kafka Training Blog](https://data-flair.training/blogs/kafka-architecture/)

![](https://data-flair.training/blogs/wp-content/uploads/sites/2/2018/04/Kafka-Architecture.png)

**Producer**: Push data to brokers. 
* When new broker starts, ALL producers send to new broker once it starts up.

**Consumer**: Reads records from topics

**Broker**: A Kafka *server* that runs in a **Kafka cluster**. Each broker has its own local storage (are stateless).

**Zookeeper**: Managing and coordinating brokers. 

* Notifies producer and consumer about new or failing brokers, then coordinates the next steps with the other brokers.

![](https://www.cloudkarafka.com/img/blog/apache-kafka-partition.png)

**Topic**: Logical channel to which producers publish message and from which the consumers receive messages.

* Think of a topic like a **sequence of events**
* Replicated across brokers
* Defines stream of a particular type/classification of data, in Kafka
* A particular type of messages is published on a particular topic
* Producer/Consumers writes/reads messages to/from the topics
* Identified by **unique** name
* Unlimited # topics allowed
* Can't change or update data once published

![](https://data-flair.training/blogs/wp-content/uploads/sites/2/2018/04/Kafka-topics-and-partitions-relationship.png)

**Partitions**: Topic split into partitions

* Messages written to topics
* Kafka randomly selects which partition to write message to (unless message has key - so we can specify which partition to write to)
* In one partition, messages are ...
  * Stored **sequentially**
  * Assigned an incremental id called **offset**
    * This id is only meaningful in a partition, not the whole topic itself
* no limitation on # of partitions