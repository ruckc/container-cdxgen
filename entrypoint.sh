#!/bin/bash

git clone $GIT_URL repo
cdxgen -o bom.xml repo
if [ "${BOM_UPLOAD_URL}" != "" ]; then
  curl -v -XPOST "$BOM_UPLOAD_URL"
fi
