#!/bin/bash
printf "\n ./snapshot.json contents:\n"
printf "{
  \"name\": \"%s\",
  \"application\": \"%s\",
  \"description\": \"from tekton pipeline\",
  \"versions\": [{
    \"%s\": \"%s\"
  }]
}" "${SNAPSHOT_ID}" "${APPLICATION_NAME}" "${COMPONENT_NAME}" "${COMPONENT_VERSION}" | tee ./snapshot.json

printf "\n"
curl -k -u "${UCD_USER}":"${UCD_PASSWORD}" "${UCD_URL}:${UCD_PORT}/cli/snapshot/createSnapshot" -X PUT --data @snapshot.json