# ----------- Build stage -----------
FROM openjdk:8-jdk-alpine as builder

RUN apk add --no-cache maven
RUN mkdir -p /app/source
COPY . /app/source
WORKDIR /app/source

RUN ./mvnw clean package -DskipTests

# ----------- Runtime stage -----------
FROM openjdk:8-jdk-alpine

COPY --from=builder /app/source/target/*.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.jar"]
