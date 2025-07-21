#!/bin/bash
set -euf -o pipefail
gcloud storage buckets add-iam-policy-binding gs://"${GCS_BUCKET}" \
  --member "principal://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${PROJECT_ID}.svc.id.goog/subject/ns/${NAMESPACE}/sa/${KSA_NAME}" \
  --role "roles/storage.admin"

gcloud projects add-iam-policy-binding projects/"${PROJECT_ID}" \
  --role roles/monitoring.metricWriter \
  --member "principal://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${PROJECT_ID}.svc.id.goog/subject/ns/${NAMESPACE}/sa/${KSA_NAME}"
