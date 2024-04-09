# Builder
FROM alpine:latest as builder

ARG PB_VERSION=0.22.8

# Install dependencies needed for the build
RUN apk add --no-cache \
    unzip \
    ca-certificates

# Download and unzip PocketBase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/

# Final Image
FROM alpine:latest

# Install ca-certificates for SSL connections (e.g., for external database connections)
RUN apk add --no-cache ca-certificates

# Set default environment variables
ENV PBADMINUSR=admin@example.com
ENV PBADMINPWD=ChangeMe123

# Set the working directory
WORKDIR /pb

# Copy the PocketBase binary and other necessary files from the builder stage
COPY --from=builder /pb .

# Copy the custom run script
COPY run.sh .

# Make the run script executable
RUN chmod +x run.sh

# Copy your migrations and hooks if you have them (optional)
COPY ./pb_migrations ./pb_migrations
# COPY ./pb_hooks ./pb_hooks

# Expose the application port
EXPOSE 8080

# Use your custom run script as the entry point
CMD ["./run.sh"]
