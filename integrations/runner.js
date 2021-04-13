const worker = require('./worker');
const test = require("ava")
const { loadSeeds, clearAll } = require('./seed')
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

test.before("Seeds Firestore", () => {
  return loadSeeds()
})

test.after("Cleanup Firestore", () => {
  return clearAll()
})

test("TestGet", t => {
  return runner("runTestGet", "testGetResult").then(result => {
    t.true(result.success)
    t.is(result.value, "user0")
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

test.serial("TestInsert", t => {
  // In order not to break idempotency here uses `serial`. 
  return runner("runTestInsert", "testInsertResult").then(result => {
    t.true(result.success)
  })
})