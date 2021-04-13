const worker = require('./worker');
const { describe, it, beforeEach, afterEach } = require('mocha');
const assert = require('assert');
const { loadSeeds, clearAll } = require('./seed')
global.XMLHttpRequest = require('xhr2');

describe("tests", function() {
  // Top-level callback must be `function` syntax.
  // This is because callng this#timeout method requires it to be bounded to Mocha context internally.
  this.timeout(10000)

  const w = worker.Elm.Worker;

  beforeEach(done => {
    loadSeeds().then(() => {
      setTimeout(() => done(), 1500)
    })
  })

  afterEach(done => {
    clearAll().then(() => {
      setTimeout(() => done(), 1500)
    })
  })

  it("TestGet", done => {
    const a = w.init();
    a.ports.testGetResult.subscribe(result => {
      assert.ok(result.success)
      assert.strictEqual(result.value, "user0")
      done()
    })
    a.ports.runTestGet.send(null)
  })

  it("TestListPageSize", done => {
    const a = w.init();
    a.ports.testListPageSizeResult.subscribe(result => {
      assert.ok(result.success)
      assert.strictEqual(result.value, 3)
      done()
    })
    a.ports.runTestListPageSize.send(null)
  })

  it("TestListDesc", done => {
    const a = w.init();
    a.ports.testListDescResult.subscribe(result => {
      assert.ok(result.success)
      assert.strictEqual(result.value, "user4")
      done()
    })
    a.ports.runTestListDesc.send(null)
  })

  it("TestListAsc", done => {
    const a = w.init();
    a.ports.testListAscResult.subscribe(result => {
      assert.ok(result.success)
      assert.strictEqual(result.value, "user0")
      done()
    })
    a.ports.runTestListAsc.send(null)
  })

  it("TestInsert", done => {
    const a = w.init();
    a.ports.testInsertResult.subscribe(result => {
      assert.ok(result.success)
      done()
    })
    a.ports.runTestInsert.send(null)
  })
})
