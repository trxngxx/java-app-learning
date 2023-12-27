# Stage 1: Build the application
FROM maven:3.8.4-openjdk-17 AS builder
 
WORKDIR /app
 
COPY . .
 
RUN mvn clean install
 
# Stage 2: Run the application
FROM amazoncorretto:8-alpine 
 
WORKDIR /app
 
COPY --from=builder /home/ubuntu/java-app/demo-0.0.1-SNAPSHOT.jar app.jar
 
EXPOSE 8080
 
ENTRYPOINT ["java", "-jar", "app.jar"]