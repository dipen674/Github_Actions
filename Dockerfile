# ==============================
# STAGE 1: Build the App
# ==============================
# We use the JDK image because we need to COMPILE code
FROM eclipse-temurin:8-jdk-alpine AS builder

WORKDIR /src

# Copy all project files into the builder container
COPY . .

# Grant execution permission to the Gradle wrapper
RUN chmod +x gradlew

# Run the build inside the container
# This creates the JAR file in /src/build/libs/
RUN ./gradlew build --no-daemon

# ==============================
# STAGE 2: Run the App
# ==============================
# We use the JRE image (lighter) just to RUN the app
FROM eclipse-temurin:8-jre-alpine

WORKDIR /usr/app

EXPOSE 8080

# COPY --from=builder: This pulls the JAR from the previous stage
# We rename it to 'app.jar' so we don't worry about version numbers
COPY --from=builder /src/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]