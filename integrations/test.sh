#!/usr/bin/env bash
set -Ceux

cd `dirname $0`
npx elm make ./src/Worker.elm --output=worker.js
npx firebase emulators:exec \
  "npx mocha --exit runner.js" \
  --only firestore \
  --project firestore-integration-test
