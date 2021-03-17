# Distributed version of the Spring PetClinic Sample Application built with Spring Cloud

This project is forked from and extends
[spring-petclinic/spring-petclinic-microservices](https://github.com/spring-petclinic/spring-petclinic-microservices).

It serves as an automated performance test environment:

* We use [Zikpin](https://zipkin.io/) to derive software traces and monitor application performance.
* We use [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) to derive system traces and monitor
  system performance.
* We use [Apache JMeter](https://jmeter.apache.org/) to generate load on the PetClinic and execute performance tests.

Please have a look at the original
[README](https://github.com/spring-petclinic/spring-petclinic-microservices/blob/master/README.md)
for general instructions.

## Modifications and extensions

We modified and extended the distributed version of the PetClinic in several ways as shown in the following and
described below:

![README](README.svg)

### Collecting software traces using Zipkin and Apache Kafka

We instrumented the API Gateway, Vets Service, Customers Service and Visits Service, so they send
[Zikpin](https://zipkin.io/) traces to an [Apache Kafka](https://kafka.apache.org/) topic called `pg-traces-software`.
In line with this, we adapted Zipkin collector to use Kafka, which is part
of [Docker Compose](https://docs.docker.com/compose/).

This allows us to consume traces for further stream processing in a comfortable way.

### Collecting system traces using Telegraf and Apache Kafka

We added [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/)
to [Docker Compose](https://docs.docker.com/compose/).

Telegraf monitors cpu, disk, disk IO, kernel, mem, processes, swap, and system metrics of the entire docker host (see
configuration file `telegraf.conf`). The collected metrics are sent to an [Apache Kafka](https://kafka.apache.org/)
topic called `pg-traces-system`.

### Performance load testing using Apache JMeter

We added [Apache JMeter](https://jmeter.apache.org/) to [Docker Compose](https://docs.docker.com/compose/) in order to
generate requests and execute performance tests.

The test plan for the dockerized JMeter is located at `jmeter/petclinic_test_plan.jmx` (it is adapted
from `spring-petclinic-api-gateway/src/test/jmeter/petclinic_test_plan.jmx`). It will be started automatically using the
profile `load-test` (see [Run the PetClinic](#run-the-petclinic)). An output csv file we be stored
at `jmeter/test-output.csv`. If you want to open and change the JMeter test plan, please make sure to install the
[Concurrency Thread Group](https://jmeter-plugins.org/wiki/ConcurrencyThreadGroup/) plugin.

#### Provoking performance degradations

We use this project mainly to generate performance traces and provoke different performance bottlenecks. For this
purpose, we implemented two scenarios - one memory leak and one cpu hog. Branch `apm/degradation/memory-leak` leaks
memory in the
[Customers Serivce](https://github.com/perguard/spring-petclinic-microservices/blob/apm/degradation/memory-leak/spring-petclinic-customers-service/src/main/java/org/springframework/samples/petclinic/customers/web/OwnerResource.java#L100)
and branch `apm/degradation/cpu-hog` hogs cpu in the
[API Gateway](https://github.com/perguard/spring-petclinic-microservices/blob/apm/degradation/cpu-hog/spring-petclinic-api-gateway/src/main/java/org/springframework/samples/petclinic/api/boundary/web/ApiGatewayController.java#L91).
If you use perform load testing, you should be able to monitor the performance degradations over time.

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

Alternatively, use [profiles with Compose](https://docs.docker.com/compose/profiles/) to start additional containers:

* `docker-compose --profile debug up` starts [Spring Boot Admin](https://github.com/codecentric/spring-boot-admin),
  [Grafana](https://grafana.com/), [Prometheus](https://prometheus.io/) and
  [Kafdrop](https://github.com/obsidiandynamics/kafdrop)
* `docker-compose --profile load-test up` starts a load test using [Apache JMeter](https://jmeter.apache.org/).

To stop and remove everything, we recommend using the following command to prevent future errors
with [Apache Kafka](https://kafka.apache.org/).

```
docker-compose rm -sfv
```

