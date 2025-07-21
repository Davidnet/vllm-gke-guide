# Serving Gemma on GKE with NVIDIA L4 GPUs

This project provides a set of scripts and configuration files to deploy a [Gemma](https://huggingface.co/google/gemma-3n-E2B-it) model on Google Kubernetes Engine (GKE) using NVIDIA L4 GPUs and [vLLM](https://github.com/vllm-project/vllm).

## Overview

This project facilitates the deployment of a Gemma model on Google Kubernetes Engine (GKE) with GPU acceleration provided by NVIDIA L4 GPUs. It utilizes vLLM for efficient inference and incorporates a custom Docker image to ensure all necessary dependencies are correctly managed.

The primary features of this project include:
- **GPU-Accelerated Inference:** Leverages NVIDIA L4 GPUs for high-performance model serving.
- **Custom Docker Environment:** A pre-configured Dockerfile is provided to build a container with all required libraries and dependencies, simplifying the setup process.
- **Automated Deployment:** A collection of shell scripts is included to streamline the creation of GKE clusters, Kubernetes resources, and the deployment of the model, making the process straightforward and repeatable.

## Directory Structure

```
.
├── create-cluster.sh
├── create-namespace.sh
├── create-sa.sh
├── create-secrets-hf.sh
├── deploy-metrics.yaml
├── deploy-model.yaml
├── docker-image
│   ├── Dockerfile
│   └── entrypoint.sh
├── environment-variables-examples.sh
├── grant-permisions-to-sa.sh
└── request-prompt.sh
```

- `create-cluster.sh`: Creates a GKE Autopilot cluster.
- `create-namespace.sh`: Gets the credentials for the created GKE cluster.
- `create-sa.sh`: Creates a Kubernetes Service Account.
- `create-secrets-hf.sh`: Creates a Kubernetes secret for the Hugging Face token.
- `deploy-metrics.yaml`: Deploys a `PodMonitoring` resource to collect metrics from the vLLM server.
- `deploy-model.yaml`: Deploys the vLLM model server as a Kubernetes Deployment and exposes it with a Service.
- `docker-image/`: Contains the files to build the custom Docker image.
  - `Dockerfile`: The Dockerfile for building the custom vLLM image.
  - `entrypoint.sh`: The entrypoint script for the Docker image.
- `environment-variables-examples.sh`: An example file for setting up the required environment variables.
- `grant-permisions-to-sa.sh`: Grants the necessary IAM permissions to the Kubernetes Service Account.
- `request-prompt.sh`: A script to send a sample request to the deployed model.

## Environment Setup

Before you begin, you need to set up your environment variables.

1.  **Create a copy of the example environment file:**
    ```bash
    cp environment-variables-examples.sh environment-variables.sh
    ```

2.  **Edit `environment-variables.sh` and replace the placeholder values with your own:**

    - `CLUSTER_NAME`: The name for your GKE cluster.
    - `REGION`: The GCP region where you want to create your cluster (e.g., `us-central1`).
    - `NAMESPACE`: The Kubernetes namespace for your resources (e.g., `llm-serving`).
    - `PROJECT_ID`: Your Google Cloud Project ID.
    - `HF_TOKEN`: Your Hugging Face Hub token with read access to the Gemma model.
    - `KSA_NAME`: The name for your Kubernetes Service Account (e.g., `vllm-sa`).
    - `PROJECT_NUMBER`: Your Google Cloud Project Number.
    - `GCS_BUCKET`: The name of your Google Cloud Storage bucket.

3.  **Source the environment variables file:**
    ```bash
    source environment-variables.sh
    ```

## Deployment Process

Follow these steps to deploy the model to GKE:

1.  **Create the GKE Cluster:**
    ```bash
    ./create-cluster.sh
    ```

2.  **Get Cluster Credentials:**
    ```bash
    ./create-namespace.sh
    ```

3.  **Create the Kubernetes Service Account:**
    ```bash
    ./create-sa.sh
    ```

4.  **Create the Hugging Face Secret:**
    ```bash
    ./create-secrets-hf.sh
    ```

5.  **Grant Permissions to the Service Account:**
    ```bash
    ./grant-permisions-to-sa.sh
    ```

6.  **Build and Push the Docker Image:**
    Navigate to the `docker-image` directory and use `gcloud` to build and push the image to Google Container Registry.
    ```bash
    cd docker-image
    gcloud builds submit --tag gcr.io/${PROJECT_ID}/vllm-gemma .
    cd ..
    ```
    *Note: Make sure to update the `image` field in `deploy-model.yaml` to point to your newly pushed image.*

7.  **Deploy the Model:**
    ```bash
    kubectl apply -f deploy-model.yaml -n ${NAMESPACE}
    ```

8.  **Deploy Metrics Collection:**
    ```bash
    kubectl apply -f deploy-metrics.yaml -n ${NAMESPACE}
    ```

## Interacting with the Model

Once the model is deployed and the service is running, you can send requests to it using the `request-prompt.sh` script:

```bash
./request-prompt.sh
```

This will send a sample prompt to the model and print the response. You can modify the `prompt` in the script to test other inputs.

## Monitoring

This project is configured to collect Prometheus metrics from the vLLM server. The `deploy-metrics.yaml` file creates a `PodMonitoring` resource that scrapes the `/metrics` endpoint of the vLLM pods.

You can view these metrics in the [Google Cloud Console's Metrics Explorer](https://console.cloud.google.com/monitoring/metrics-explorer). Use PromQL queries to inspect the collected metrics, for example:

```promql
up{namespace="llm-serving"}
```

This will show you the status of the Prometheus data ingestions.
