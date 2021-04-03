FROM quay.io/quarkus/centos-quarkus-maven:21.0.0-java11 AS dependencies
COPY legume-service/pom.xml /usr/src/legume-service/
COPY hero-service/pom.xml /usr/src/hero-service/
COPY pom.xml /usr/src
RUN mvn -Dmaven.repo.local=.m2 -f /usr/src/pom.xml -f /usr/src/legume-service/pom.xml -f /usr/src/hero-service/pom.xml -B de.qaware.maven:go-offline-maven-plugin:1.2.5:resolve-dependencies


FROM quay.io/quarkus/centos-quarkus-maven:21.0.0-java11 as build-vegetables
COPY --from=dependencies /project/.m2 /usr/src/.m2
COPY legume-service/pom.xml /usr/src/legume-service/
COPY pom.xml /usr/src/pom.xml
COPY legume-service/src /usr/src/legume-service/src
USER root
RUN chown -R quarkus /usr/src/legume-service
USER quarkus
RUN mvn -Dmaven.repo.local=/usr/src/.m2 -DskipTests=true -f /usr/src/legume-service/pom.xml package


FROM quay.io/quarkus/centos-quarkus-maven:21.0.0-java11 as build-superheroes
COPY --from=dependencies /project/.m2 /usr/src/.m2
COPY pom.xml /usr/src/pom.xml
COPY hero-service/pom.xml /usr/src/hero-service/
COPY hero-service/src /usr/src/hero-service/src
USER root
RUN chown -R quarkus /usr/src/hero-service
USER quarkus
RUN mvn -Dmaven.repo.local=/usr/src/.m2 -DskipTests=true -f /usr/src/hero-service/pom.xml package

# Building with dependendencies all contained in Docker: docker build --target vegetables .
FROM openjdk:11.0.6-jre-slim-buster as vegetables
COPY --from=build-vegetables /usr/src/legume-service/target/quarkus-app /work/
RUN chmod 775 /work/quarkus-run.jar
EXPOSE 8080
CMD ["java", "-jar", "/work/quarkus-run.jar"]

# Building with dependendencies all contained in Docker: docker build --target superheroes .
FROM openjdk:11.0.6-jre-slim-buster as superheroes
COPY --from=build-superheroes /usr/src/hero-service/target/quarkus-app /work/
RUN chmod 775 /work/quarkus-run.jar
EXPOSE 8080
CMD ["java", "-jar", "/work/quarkus-run.jar"]

# Build with dependencies locally for dev docker build --target vegetablesdev .
FROM openjdk:11.0.6-jre-slim-buster as vegetablesdev
COPY legume-service/target/quarkus-app/ /work/
RUN chmod 775 /work
EXPOSE 8080
CMD ["java", "-jar", "/work/quarkus-run.jar"]

# Build with dependencies locally for dev docker build --target superheroesdev .
FROM openjdk:11.0.6-jre-slim-buster as superheroesdev
COPY hero-service/target/quarkus-app/ /work/
RUN chmod 775 /work
EXPOSE 8080
CMD ["java", "-jar", "/work/quarkus-run.jar"]
