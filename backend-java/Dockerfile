# syntax=docker/dockerfile:1
# NeuroLearn API — multi-stage build: Maven (JDK 17) → slim JRE 17 runtime.

FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /src
# Dependencies first, so code changes don't re-download them.
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw && ./mvnw -B -q dependency:go-offline
COPY src/ src/
# Tests run in CI (they need Docker for Testcontainers), not inside the image build.
RUN ./mvnw -B -q package -DskipTests && cp target/*.jar /app.jar

FROM eclipse-temurin:17-jre-alpine
RUN addgroup -S app && adduser -S app -G app
USER app
WORKDIR /app
COPY --from=build /app.jar app.jar
EXPOSE 8080
# Real deployments must set JWT_SECRET, DB_* (or SPRING_DATASOURCE_URL) and
# CORS_ALLOWED_ORIGINS — see .env.example and docs/deployment.md.
ENV SPRING_PROFILES_ACTIVE=prod \
    JAVA_OPTS="-XX:MaxRAMPercentage=75 -XX:+ExitOnOutOfMemoryError"
HEALTHCHECK --interval=15s --timeout=5s --start-period=60s --retries=5 \
  CMD wget -qO- http://localhost:8080/api/health >/dev/null || exit 1
ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar /app/app.jar"]
