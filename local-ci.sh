#!/bin/bash

# Load environment variables from .env file
set -a
source .env
set +a

set -euo pipefail

mkdir -p ./report
chmod o+rw ./report

docker run --rm -ti \
  -v "$(pwd)/report:/archi/report" \
  -e DOWNLOAD_CUSTOM_PLUGINS_GCP="true" \
  -e GOOGLE_APPLICATION_CREDENTIALS_JSON="${GOOGLE_APPLICATION_CREDENTIALS_JSON}" \
  -e GOOGLE_CLOUD_PROJECT="${GOOGLE_CLOUD_PROJECT}" \
  -e GIT_REPOSITORY="${GIT_REPOSITORY}" \
  -e GIT_TOKEN="${GIT_TOKEN}" \
  -e ARCHI_HTML_REPORT_ENABLED="false" \
  -e ARCHI_JASPER_REPORT_ENABLED="false" \
  -e ARCHI_CSV_REPORT_ENABLED="true" \
  -e ARCHI_EXPORT_MODEL_ENABLED="true" \
  -e ARCHI_RUN_SCRIPT_ENABLED="true" \
  -e JARCHI_SCRIPT_PATH="${JARCHI_SCRIPT_PATH}" \
  archimate-ci-image:5.4.3-dev