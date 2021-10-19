#!/bin/bash

set -e
set -x

echo "===== GIT CLONE ====="
git clone $GIT_URL repo
echo "===== CDXGEN    ====="
cdxgen -o bom.xml repo
if [ "${BOM_UPLOAD_URL}" != "" ]; then
  echo "===== CURL UP   ===== $BOM_UPLOAD_URL"
  curl -v -XPOST "$BOM_UPLOAD_URL"
fi
