#!/bin/bash

set -e
set -x

echo "===== GIT CLONE ====="
git clone $GIT_URL repo
cd repo

GIT_REFS=$(curl --fail -v -XGET "${BOM_URL}" | jq -r '.hash[]')

for REF in $(echo ${GIT_REFS} | sed "s/,/ /g"); do
  git -c advice.detachedHead=false checkout $REF
  COMMIT_DATE=$(git show -s --format=%cI)
  echo "cdxgen output:" > output.txt
  cdxgen -r -o bom.json . 2>&1 | tee -a output.txt
  ls -latr
  if [ ! -f "bom.json" ]; then
    echo "Unable to find generated bom.json"
    URL="${BOM_BASE_UPLOAD_URL}/${REF}/error"
    SUCCESS=0
    while [ $SUCCESS -ne 1 ]; do
      echo "===== CURL ERR UP ===== $URL"
      echo "${ERRORS}" | curl --fail -v -XPOST "$URL" -G --data-urlencode "commitTimestamp=${COMMIT_DATE}" -H "Content-Type: text/plain" -d @output.txt && SUCCESS=1 || sleep 5
    done
    continue
  fi
  if [ "${BOM_BASE_UPLOAD_URL}" != "" ]; then
    URL="${BOM_BASE_UPLOAD_URL}/${REF}?commitTimestamp=${COMMIT_DATE}"
    SUCCESS=0
    while [ $SUCCESS -ne 1 ]; do
      echo "===== CURL UP     ===== $URL"
      curl --fail -v -XPOST "$URL" -G --data-urlencode "commitTimestamp=${COMMIT_DATE}" -H "Content-Type: application/json" -d @bom.json && SUCCESS=1 || sleep 5
    done
  fi
  rm -rv bom.json bom.xml output.txt
done
