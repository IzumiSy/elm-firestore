#!/usr/bin/env bash
set -Ceux

cd `dirname $0`
npx elm make ./src/Worker.elm --output=worker.js
npx firebase emulators:exec "npx ava --verbose" --only firestore --project firestore-integration-test
