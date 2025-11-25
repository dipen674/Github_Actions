# Change the FROM line to:
FROM eclipse-temurin:8-jdk-alpine

EXPOSE 8080
COPY ./build/libs/my-app-1.0-SNAPSHOT.jar /usr/app/
WORKDIR /usr/app
ENTRYPOINT ["java", "-jar", "my-app-1.0-SNAPSHOT.jar"]