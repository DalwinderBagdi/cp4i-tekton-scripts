#!/bin/bash
printf "\nCreating json file with application json"

printf "{
  \"application\": \"%s\",
  \"applicationProcess\": \"%s\",
  \"environment\": \"%s\",
  \"onlyChanged\": \"false\",
  \"snapshot\": \"%s\"
}" "${APPLICATION_NAME}" "${APPLICATION_PROCESS}" "${ENV}" "${SNAPSHOT_ID}" | tee ./deployment.json

printf "\nRequesting deployment from snapshot"

printf "Output from 'curl -k -u %s:%s %s:%s/cli/applicationProcessRequest/request -X PUT -d @deployment.json': ", "${UCD_USER}" "${UCD_PASSWORD}" "${UCD_URL}" "${UCD_PORT}"

REQUEST=$(curl -k -u "${UCD_USER}":"${UCD_PASSWORD}" "${UCD_URL}":"${UCD_PORT}"/cli/applicationProcessRequest/request -X PUT -d @deployment.json)

REQUEST_ID="${REQUEST:14:36}"

printf "Requesting status for request ID %s until request has been completed\n", "${REQUEST_ID}"

until curl -k -u "${UCD_USER}":"${UCD_PASSWORD}" "${UCD_URL}":"${UCD_PORT}"/cli/applicationProcessRequest/requestStatus?request=${REQUEST_ID} | grep -e CLOSED -e FAULTED;
do sleep 5;
done;