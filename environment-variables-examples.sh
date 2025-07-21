#!/usr/bin/env bash
set -a
# This script should be sourced to use env variables.
# Users should create their own environment-variables.sh based on this example.
export CLUSTER_NAME="<your-cluster-name>"
export REGION="<your-gcp-region>"
export NAMESPACE="<your-namespace>"
export PROJECT_ID="<your-gcp-project-id>"
export HF_TOKEN="<your-hugging-face-token>"
export KSA_NAME="<your-kubernetes-service-account-name>"
export PROJECT_NUMBER="<your-gcp-project-number>"
export GCS_BUCKET="<your-gcs-bucket-name>"
