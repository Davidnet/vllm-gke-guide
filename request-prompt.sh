#!/bin/bash
set -euf -o pipefail
# Get the external IP address of the vllm-service
EXTERNAL_IP=$(kubectl get service "$SERVICE_NAME" -n vllm-serving -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Check if the IP address was successfully retrieved
if [ -z "$EXTERNAL_IP" ]; then
  echo "Error: Unable to retrieve external IP address for vllm-service."
  exit 1
fi

echo "Using external IP: $EXTERNAL_IP"

curl http://"$EXTERNAL_IP":8000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "google/gemma-3n-e2b-it",
    "prompt": "Tonight we ride straight into the fire, this our time to go from zero to hero",
    "max_tokens": 100,
    "temperature": 0
}' | jq '.' -
