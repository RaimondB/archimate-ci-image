#!/bin/bash

# Load environment variables from .env file
set -a
source .env
set +a

set -euo pipefail

mkdir -p ./report
chmod o+rw ./report

docker run --rm -ti \
  -v "./report:/archi/report" \
  -v "./test:/archi/test" \
  -v "./ci-output:/archi/ci-output" \
  -v "./dist:/archi/plugins" \
  -e DOWNLOAD_CUSTOM_PLUGINS_GCP="false" \
  -e GOOGLE_APPLICATION_CREDENTIALS_JSON="${GOOGLE_APPLICATION_CREDENTIALS_JSON}" \
  -e GOOGLE_CLOUD_PROJECT="${GOOGLE_CLOUD_PROJECT}" \
  -e GOOGLE_CLOUD_STORAGE_SOURCE="${GOOGLE_CLOUD_STORAGE_SOURCE}" \
  -e GIT_REPOSITORY="${GIT_REPOSITORY}" \
  -e GIT_TOKEN="${GIT_TOKEN}" \
  -e ARCHI_HTML_REPORT_ENABLED="false" \
  -e ARCHI_JASPER_REPORT_ENABLED="false" \
  -e ARCHI_CSV_REPORT_ENABLED="true" \
  -e ARCHI_EXPORT_MODEL_ENABLED="false" \
  -e ARCHI_RUN_SCRIPT_ENABLED="true" \
  -e ARCHI_SAVE_REPO_MODEL_ENABLED="true" \
  -e JARCHI_SCRIPT_ROOT="${JARCHI_SCRIPT_ROOT}" \
  -e JARCHI_SCRIPT_PATH="${JARCHI_SCRIPT_PATH}" \
  -e ARCHI_MODEL_MODE="${ARCHI_MODEL_MODE}" \
  -e ARCHI_MODEL_FILE="${ARCHI_MODEL_FILE}" \
  -e ARCHI_COLOUR_PREFS_PATH="${ARCHI_COLOUR_PREFS_PATH}" \
  -e REMOVE_DEFAULT_PLUGINS="true" \
  -e COPY_LOCAL_PLUGINS="true" \
  -e ARCHI_PLUGINS_SOURCE_PATH="/archi/plugins" \
  -e DEBUG="false" \
  -e SHOW_GIT_STATS="true" \
  raimondb/archimate-ci-image:dev

#  -e ARCHI_SCRIPT_CI_CONFIG_PATH="${ARCHI_SCRIPT_CI_CONFIG_PATH}" \
#    archimate-ci-image:5.4.3-dev