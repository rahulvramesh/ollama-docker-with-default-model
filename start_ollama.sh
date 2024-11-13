#!/bin/bash

# Default model if OLLAMA_MODEL is not set
MODEL_NAME=${OLLAMA_MODEL:-"llama2-7b"}
ALLOWED_ORIGINS=${OLLAMA_ORIGINS:-"*"}
# Check if the model was pulled successfully
if [ $? -ne 0 ]; then
    echo "Failed to pull the model: $MODEL_NAME"
    exit 1
fi

echo "Model pulled successfully."

# Start the Ollama server in the background
echo "Starting Ollama server in the background..."
OLLAMA_ORIGINS="$ALLOWED_ORIGINS" OLLAMA_HOST="0.0.0.0" ollama serve &

# Wait for the Ollama server to be ready
RETRY_COUNT=0
MAX_RETRIES=10
until curl -s http://localhost:11434/health > /dev/null; do
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ "$RETRY_COUNT" -ge "$MAX_RETRIES" ]; then
        echo "Ollama server did not start in time."
        exit 1
    fi
    echo "Waiting for Ollama server to be ready... ($RETRY_COUNT/$MAX_RETRIES)"
    sleep 2
done

echo "Pulling the model: $MODEL_NAME"
ollama pull "$MODEL_NAME"


echo "Ollama server is ready."

# Test API with a simple request
echo "Testing the model with a sample API call..."
curl -X POST "http://localhost:11434/api/generate" \
  -H "Content-Type: application/json" \
  -d "{
        \"model\": \"$MODEL_NAME\",
        \"prompt\": \"Hello, how are you?\"
      }"

echo ""
echo "API test completed. Keeping Ollama server running..."
wait
