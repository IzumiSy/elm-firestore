#!/usr/bin/env bash
set -Ceux

npx firebase emulators:exec \
  "npx elm-test && curl -s -o /dev/null -X DELETE \"http://localhost:8080/emulator/v1/projects/firestore-integration-test/databases/(default)/documents\"" \
  --only firestore \
  --project firestore-integration-test

