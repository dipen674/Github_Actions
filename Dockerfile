# ==============================
# STAGE 1: Build the App
# ==============================
# CHANGE: Use standard JDK (not Alpine) to ensure all build tools/libs exist
FROM eclipse-temurin:8-jdk AS builder

WORKDIR /src

# Copy all project files
COPY . .

# FIX: Remove Windows line endings (CRLF) just in case you are on Windows
# This prevents the "interpreter not found" error
RUN sed -i 's/\r$//' gradlew

# Grant execution permission
RUN chmod +x gradlew

# Run the build
RUN ./gradlew build --no-daemon

# ==============================
# STAGE 2: Run the App
# ==============================
# We still use Alpine here to keep the final image SMALL
FROM eclipse-temurin:8-jre-alpine

WORKDIR /usr/app

EXPOSE 8080

# Copy the built jar from the 'builder' stage
COPY --from=builder /src/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]