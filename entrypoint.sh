#!/bin/bash

set -e
set -x

echo "===== GIT CLONE ====="
git clone $GIT_URL repo
cd repo

GIT_REFS=$(curl --fail -v -XGET "${BOM_URL}" | jq -r '.hash[]')

for REF in $(echo ${GIT_REFS} | sed "s/,/ /g"); do
  git checkout $REF
  cdxgen -r -o bom.json .
  ls -latr
  if [ ! -f "bom.json" ]; then
    echo "Unable to find generated bom.json"
    exit 1
  fi
  if [ "${BOM_BASE_UPLOAD_URL}" != "" ]; then
    URL="${BOM_BASE_UPLOAD_URL}/${REF}"
    SUCCESS=0
    while [ $SUCCESS -ne 1 ]; do
      echo "===== CURL UP   ===== $URL"
      curl --fail -v -XPOST "$URL" -H "Content-Type: application/json" -d @bom.json && SUCCESS=1 || sleep 5
    done
  fi
  rm bom.json
done
