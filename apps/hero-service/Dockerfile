FROM openjdk:11.0.6-jre-slim-buster
COPY target/quarkus-app/ /work/
RUN chmod 775 /work
EXPOSE 8080
CMD ["java", "-jar", "/work/quarkus-run.jar"]
