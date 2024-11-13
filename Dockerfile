# Base image
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl wget git python3-pip && \
    apt-get clean

# Install Ollama
RUN curl -L https://ollama.com/install.sh | bash

# Expose Ollama's default port
EXPOSE 11434

# Copy the startup script
COPY start_ollama.sh /start_ollama.sh
RUN chmod +x /start_ollama.sh

# Set the entrypoint to the startup script
ENTRYPOINT ["/start_ollama.sh"]
