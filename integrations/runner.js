const worker = require('./worker');
const test = require("ava")
const { loadSeeds, clearAll } = require('./seed')

// Http module in Platform.worker in Elm internally calls XMLHttpRequest in requesting remote data.
// Node.js itself basically does not provide XMLHttpRequest, so here injects "xhr2" instead.
global.XMLHttpRequest = require('xhr2');

//
// The reason why integration uses AVA as a runner is that it supports concurrent testing.
// Firestore integration heaviliy depends on IO performance of Firestore which is really slow.
// So cuncurrency is a key to reduce time to run integration tests.
//

const w = worker.Elm.Worker;
const runner = (triggerName, resultName) => {
  const app = w.init();
  return new Promise((resolve) => {
    app.ports[resultName].subscribe(result => {
      resolve(result);
    })
    app.ports[triggerName].send(null);
  })
}

// Resets Firestore contents to the initial
const reset = async () => {
  await clearAll()
  return loadSeeds()
}

test.before("Seeds Firestore", () => {
  return loadSeeds()
})

test.after("Cleanup Firestore", () => {
  return clearAll()
})

//
// In order not to break idempotency by updating operation,
// Tests that does updating/creating/deleting data on Firestore are marked as `serial`.
//

test.serial("TestInsert", async t => {
  await runner("runTestInsert", "testInsertResult").then(result => {
    t.true(result.success)
  })
  return reset()
})

test.serial("TestCreate", async t => {
  await runner("runTestCreate", "testCreateResult").then(result => {
    t.true(result.success)
    t.is(result.value, "jessy")
  })
  return reset()
})

test.serial("TestUpsert", async t => {
  await runner("runTestUpsert", "testUpsertResult").then(result => {
    t.true(result.success)
  })
  return reset()
})

test.serial("TestUpsertExisting", async t => {
  await runner("runTestUpsertExisting", "testUpsertExistingResult").then(result => {
    t.true(result.success)
    t.is(result.value, "user0updated")
  })
  return reset()
})

test.serial("TestPatch", async t => {
  await runner("runTestPatch", "testPatchResult").then(result => {
    t.true(result.success)
    t.is(result.value, "user0patched")
  })
  return reset()
})

test.serial("TestDelete", async t => {
  await runner("runTestDelete", "testDeleteResult").then(result => {
    t.true(result.success)
  })
  return reset()
})

test.serial("TestDeleteExisting", async t => {
  await runner("runTestDeleteExisting", "testDeleteExistingResult").then(result => {
    t.true(result.success)
  })
  return reset()
})

test.serial("TestDeleteExistingFail", async t => {
  await runner("runTestDeleteExistingFail", "testDeleteExistingFailResult").then(result => {
    t.true(result.success)
  })
  return reset()
})

test("TestGet", t => {
  return runner("runTestGet", "testGetResult").then(result => {
    t.true(result.success)
    t.is(result.value, "user0")
  })
})

// Due to a possible bug in Firestore Emulator this case is skipped for now.
test.skip("TestListPageToken", t => {
  return runner("runTestListPageToken", "testListPageTokenResult").then(result => {
    t.true(result.success)
    t.is(result.value, "user3")
  })
})

test("TestListPageSize", t => {
  return runner("runTestListPageSize", "testListPageSizeResult").then(result => {
    t.true(result.success)
    t.is(result.value, 3)
  })
})

test("TestListDesc", t => {
  return runner("runTestListDesc", "testListDescResult").then(result => {
    t.true(result.success)
    t.is(result.value, "user4")
  })
})

test("TestListAsc", t => {
  return runner("runTestListAsc", "testListAscResult").then(result => {
    t.true(result.success)
    t.is(result.value, "user0")
  })
})

test("TestQueryFieldOp", t => {
  return runner("runTestQueryFieldOp", "testQueryFieldOpResult").then(result => {
    t.true(result.success)
    t.is(result.value, 3)
  })
})

test("TestQueryEmpty", t => {
  return runner("runTestQueryEmpty", "testQueryEmptyResult").then(result => {
    t.true(result.success)
    t.is(result.value, 0)
  })
})
