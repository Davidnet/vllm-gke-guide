#!/bin/bash
set -euf -o pipefail
gcloud container clusters create-auto "${CLUSTER_NAME}" --region "${REGION}" || true
kubectl create namespace "${NAMESPACE}"