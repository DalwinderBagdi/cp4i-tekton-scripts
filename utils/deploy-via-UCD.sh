#!/bin/bash
printf "\n
----------------------------------------------------------------------------------------------------------------------------------------
\n 1. Creating component \n
----------------------------------------------------------------------------------------------------------------------------------------\n"

curl -k -u "${UCD_USER}":"${UCD_PASSWORD}" "${UCD_URL}:${UCD_PORT}/cli/version/createVersion?component=${COMPONENT_NAME}&name=${COMPONENT_VERSION}" -X POST

printf "\n
----------------------------------------------------------------------------------------------------------------------------------------
\n 2. Creating snapshot \n
----------------------------------------------------------------------------------------------------------------------------------------\n"

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

printf "\n \n \n
----------------------------------------------------------------------------------------------------------------------------------------
\n 3. Creating json file with application json \n
----------------------------------------------------------------------------------------------------------------------------------------\n"

printf "{
  \"application\": \"%s\",
  \"applicationProcess\": \"%s\",
  \"environment\": \"%s\",
  \"onlyChanged\": \"false\",
  \"snapshot\": \"%s\"
}" "${APPLICATION_NAME}" "${APPLICATION_PROCESS}" "${ENV}" "${SNAPSHOT_ID}" | tee ./deployment.json

printf "\n \n
----------------------------------------------------------------------------------------------------------------------------------------
\n 4. Requesting deployment from snapshot \n
----------------------------------------------------------------------------------------------------------------------------------------\n"
printf "Output from 'curl -k -u %s:%s %s:%s/cli/applicationProcessRequest/request -X PUT -d @deployment.json': ", "${UCD_USER}" "${UCD_PASSWORD}" "${UCD_URL}" "${UCD_PORT}"

REQUEST=$(curl -k -u "${UCD_USER}":"${UCD_PASSWORD}" "${UCD_URL}":"${UCD_PORT}"/cli/applicationProcessRequest/request -X PUT -d @deployment.json)

REQUEST_ID="${REQUEST:14:36}"

printf "Requesting status for request ID %s until request has been completed\n", "${REQUEST_ID}"

until curl -k -u "${UCD_USER}":"${UCD_PASSWORD}" "${UCD_URL}":"${UCD_PORT}"/cli/applicationProcessRequest/requestStatus?request=${REQUEST_ID} | grep -e CLOSED -e FAULTED;
do sleep 5;
done;