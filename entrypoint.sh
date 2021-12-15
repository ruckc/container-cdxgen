#!/bin/bash

set -e
set -x

echo "===== GIT CLONE ====="
git clone $GIT_URL repo
cd repo
for REF in $(echo ${GIT_REFS} | sed "s/,/ /g"); do
  git checkout $REF
  OTUPUT=$(cdxgen -o bom.json . 2>&1)
  if [ "${BOM_BASE_UPLOAD_URL}" != "" ]; then
    URL="${BOM_BASE_UPLOAD_URL}/${REF}"
    echo "===== CURL UP   ===== $URL"
    curl -v -XPOST "$URL" -H "Content-Type: application/json" -d @bom.json
  else
    URL="${BOM_BASE_UPLOAD_URL}/${REF}/error"
    echo "${ERRORS}" | curl -v -XPOST "$URL" -H "Content-Type: text/plain" -d -
  fi
  rm bom.json
done
