# Stage 1: Build the application
FROM maven:3.8.4-openjdk-17 AS builder
 
WORKDIR /home/ubuntu/java-app
 
COPY . .
 
RUN mvn clean install
 
# Stage 2: Run the application
FROM amazoncorretto
 
WORKDIR /home/ubuntu/java-app/target
 
COPY --from=builder /home/ubuntu/java-app/target/demo-0.0.1-SNAPSHOT.jar app.jar
 
EXPOSE 8080
 
ENTRYPOINT ["java", "-jar", "app.jar"]