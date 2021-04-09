#!/usr/bin/env bash
set -Ceux

cd `dirname $0`
npx elm make ./Worker.elm --output=worker.js
npx firebase emulators:exec \
  "npx mocha runner.js && curl -s -o /dev/null -X DELETE \"http://localhost:8080/emulator/v1/projects/firestore-integration-test/databases/(default)/documents\"" \
  --only firestore \
  --project firestore-integration-test
