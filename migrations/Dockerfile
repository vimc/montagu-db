FROM openjdk:8-jre-alpine

RUN apk --no-cache add openssl
RUN apk add --no-cache bash

WORKDIR /flyway

ENV FLYWAY_VERSION 8.5.10

RUN wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && tar -xzf flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && mv flyway-${FLYWAY_VERSION}/* . \
  && rm flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && ln -s /flyway/flyway /usr/local/bin/flyway

COPY migrations/sql /sql
COPY migrations/sql-annex /sql-annex
COPY migrations/flyway.conf /flyway/conf/flyway.conf
COPY migrations/flyway-annex.conf /flyway/conf/flyway-annex.conf

ENTRYPOINT ["flyway"]
CMD ["migrate"]
