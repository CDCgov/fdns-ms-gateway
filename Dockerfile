# build stage
FROM maven:3-jdk-8 as builder
RUN mkdir -p /usr/src/app
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN mvn clean package

# run stage
FROM openjdk:8-jre-alpine

ARG GATEWAY_PORT
ARG GATEWAY_SSL_PORT
ARG GATEWAY_SSL_CERT
ARG GATEWAY_SSL_KEY

ENV GATEWAY_PORT ${GATEWAY_PORT}
ENV GATEWAY_SSL_PORT ${GATEWAY_SSL_PORT}
ENV GATEWAY_SSL_CERT ${GATEWAY_SSL_CERT}
ENV GATEWAY_SSL_KEY ${GATEWAY_SSL_KEY}

COPY --from=builder /usr/src/app/target/fdns-ms-gateway-*.jar /app.jar
COPY scripts/run.sh /home/run.sh
RUN chmod +x /home/run.sh

# don't run as root user
RUN chown -R 1001:0 /home/run.sh /app.jar /tmp
RUN chmod g+rwx /home/run.sh /app.jar /tmp
USER 1001

CMD ["/home/run.sh"]
