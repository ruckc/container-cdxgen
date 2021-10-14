#!/bin/bash

git clone $GIT_URL repo
cdxgen -o bom.xml repo

