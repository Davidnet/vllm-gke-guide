#!/bin/bash
set -euf -o pipefail
kubectl create serviceaccount "${KSA_NAME}" --namespace "${NAMESPACE}"