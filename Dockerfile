FROM debian:stable

# Install gcc + required packages
RUN apt-get update && \
    apt-get install -y gcc && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy files
COPY hello.c .
COPY test.sh .

# Compile C program
RUN gcc hello.c -o hello

# Make test script executable
RUN chmod +x test.sh

# Default command when container runs
CMD ["./hello"]
