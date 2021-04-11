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
  const onComplete = (name, cb) => {
    const a = w.init()
    a.ports[name].subscribe(cb)
  }

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
    onComplete("testGetResult", result => {
      assert.ok(result.success)
      assert.strictEqual(result.value, "user0")
      done()
    })
  })

  it("TestList", done => {
    onComplete("testListResult", result => {
      assert.ok(result.success)
      assert.strictEqual(result.value, 3)
      done()
    })
  })

  it("TestInsert", done => {
    onComplete("testInsertResult", result => {
      assert.ok(result.success)
      done()
    })
  })

  it("TestCreate", done => {
    onComplete("testCreateResult", () => {
      done()
    })
  })

  it("TestUpsert", done => {
    onComplete("testUpsertResult", () => {
      done()
    })
  })
})
