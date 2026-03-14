# Dockerfile for building the Spring PetClinic Docker image
# This is used by Jenkins to create the Docker image from the built artifact

FROM docker.io/eclipse-temurin:17-jdk

# Set working directory
WORKDIR /app

# Copy the JAR file from the build context
# The JAR is copied to app.jar during the Jenkins build stage
COPY target/*.jar /app/spring-petclinic.jar

# Expose the application port
EXPOSE 8080

# Set environment variables
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# Create a non-root user to run the application
RUN groupadd -r spring && useradd -r -g spring spring
USER spring

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar /app/spring-petclinic.jar"]
