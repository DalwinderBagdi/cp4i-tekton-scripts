#!/bin/bash
curl -k -u "${UCD_USER}":"${UCD_PASSWORD}" "${UCD_URL}:${UCD_PORT}/cli/version/createVersion?component=${COMPONENT_NAME}&name=${COMPONENT_VERSION}" -X POST

printf "{
  \"component\": \"%s\",
  \"name\": \"helm-release-name\",
  \"value\": \"%s\",
  \"version\": \"%s\"
}" "${COMPONENT_NAME}" "${HELM_RELEASE_NAME}" "${COMPONENT_VERSION}" | tee ./helm-release-properties.json

printf "{
  \"component\": \"%s\",
  \"name\": \"image-stream-name\",
  \"value\": \"%s\",
  \"version\": \"%s\"
}" "${COMPONENT_NAME}" "${IMAGE_STREAM_NAME}" "${COMPONENT_VERSION}" | tee ./image-stream-properties.json


printf "{
  \"component\": \"%s\",
  \"name\": \"configuration-secret\",
  \"value\": \"%s\",
  \"version\": \"%s\"
}" "${COMPONENT_NAME}" "${CONFIGURATION_SECRET}" "${COMPONENT_VERSION}" | tee ./conf-secret-properties.json

printf "{
  \"component\": \"%s\",
  \"name\": \"designer-enabled\",
  \"value\": \"%s\",
  \"version\": \"%s\"
}" "${COMPONENT_NAME}" "${DESIGNER_ENABLED}" "${COMPONENT_VERSION}" | tee ./designer-enabled-properties.json

curl -k -u "${UCD_USER}":"${UCD_PASSWORD}" "${UCD_URL}:${UCD_PORT}/cli/version/versionProperties" -X PUT --data @helm-release-properties.json
curl -k -u "${UCD_USER}":"${UCD_PASSWORD}" "${UCD_URL}:${UCD_PORT}/cli/version/versionProperties" -X PUT --data @image-stream-properties.json
curl -k -u "${UCD_USER}":"${UCD_PASSWORD}" "${UCD_URL}:${UCD_PORT}/cli/version/versionProperties" -X PUT --data @conf-secret-properties.json
curl -k -u "${UCD_USER}":"${UCD_PASSWORD}" "${UCD_URL}:${UCD_PORT}/cli/version/versionProperties" -X PUT --data @designer-enabled-properties.json
