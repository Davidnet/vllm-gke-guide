#!/bin/bash
set -euf -o pipefail
kubectl create secret generic hf-secret --from-literal=hf_api_token="${HF_TOKEN}" --namespace "${NAMESPACE}"