# ollama-docker-with-default-model
ollama-docker-with-default-model


docker run --rm -d \
  --name ollama-container \
  -v ollama:/root/.ollama \
  -e OLLAMA_ORIGINS="*" \
  -e OLLAMA_MODEL="qwen2.5-coder:1.5b" \
  -p 11434:11434 \
  my-ollama-model:latest

docker build -t my-ollama-model:latest .


 curl -X POST "http://0.0.0.0:11434/api/generate"   -H "Content-Type: application/json"   -d '{
        "model": "qwen2.5-coder:1.5b",
        "prompt": "Explain the difference between HTTP and HTTPS."
      }'