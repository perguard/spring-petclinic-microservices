# Distributed version of the Spring PetClinic Sample Application built with Spring Cloud

This project is forked from and extends
[spring-petclinic/spring-petclinic-microservices](https://github.com/spring-petclinic/spring-petclinic-microservices).
It serves as an automated performance test environment.

* We use [Apache JMeter](https://jmeter.apache.org/) to generate load on the PetClinic and execute performance tests.
* We use [Zikpin](https://zipkin.io/) to derive software traces and monitor application performance.
* We use [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) to derive system traces and monitor
  system performance.

Please have a look at the original
[README](https://github.com/spring-petclinic/spring-petclinic-microservices/blob/master/README.md)
for general instructions.

## Modifications and extensions

We modified and extended the distributed version of the PetClinic in several ways.

### Collecting software traces using Zipkin and Apache Kafka

We instrumented the API Gateway, Vets Service, Customers Service and Visits Service, so they send
[Zikpin](https://zipkin.io/) traces to an [Apache Kafka](https://kafka.apache.org/) topic called `pg-traces-software`.

This allows us to consume traces for further stream processing in a comfortable way.

### Collecting system traces using Telegraf and Apache Kafka

We added [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/)
to [Docker Compose](https://docs.docker.com/compose/). It monitors cpu, disk, disk IO, kernel, mem, processes, swap,
and system metrics of the entire docker host (see configuration file `telegraf.conf`). The collected metrics are sent to
an [Apache Kafka](https://kafka.apache.org/) topic called `pg-traces-system`.

### Updating Docker Compose

We added [Apache Kafka](https://kafka.apache.org/) to [Docker Compose](https://docs.docker.com/compose/) as described
above and adapted corresponding configurations.

We added [profiles with Compose](https://docs.docker.com/compose/profiles/). This prevents the need to start all
services such as [Grafana](https://grafana.com/) and [Prometheus](https://prometheus.io/) by default, which may not be
required, and demands less resources.

We added [Kafdrop](https://github.com/obsidiandynamics/kafdrop) to Compose to provide a point-and-click way of examining
Kafka broker topics and messages at [http://localhost:9000](http://localhost:9000/).

## Run the PetClinic

The easiest way to run the project is to use [Docker Compose](https://docs.docker.com/compose/).

Please make sure to have the following technologies installed:

* Java / JDK (e.g., [AdoptOpenJDK](https://adoptopenjdk.net/))
* [Docker](https://www.docker.com/) (>= 3.2 to support *profiles*)

Build the required [Docker](https://www.docker.com/) images by running the following:

```
./mvnw clean install -P buildDocker
```

To start all default containers, run of the following command:

```
docker-compose up
```

Alternatively, use the `debug` profile to additionally start
[Spring Boot Admin](https://github.com/codecentric/spring-boot-admin), [Grafana](https://grafana.com/),
[Prometheus](https://prometheus.io/) and [Kafdrop](https://github.com/obsidiandynamics/kafdrop):

```
docker-compose --profile debug up
```

To stop and remove everything, we recommend using the following command to prevent future errors
with [Apache Kafka](https://kafka.apache.org/).

```
docker-compose rm -sfv
```

