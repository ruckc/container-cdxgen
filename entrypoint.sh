#!/bin/bash

set -e
set -x

echo "===== GIT CLONE ====="
git clone $GIT_URL repo
cd repo
for REF in $(echo ${GIT_REFS} | sed "s/,/ /g"); do
  git checkout $REF
  cdxgen -o bom.json .
  if [ "${BOM_BASE_UPLOAD_URL}" != "" ]; then
    URL="${BOM_BASE_UPLOAD_URL}/${REF}"
    echo "===== CURL UP   ===== $URL"
    curl -v -XPOST "$URL" -H "Content-Type: application/json" -d @bom.json
  fi
  rm bom.json
done
