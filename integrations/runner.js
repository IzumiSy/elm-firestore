const worker = require('./worker');
const { describe, it, beforeEach, afterEach } = require('mocha');
const assert = require('assert');
const { loadSeeds, clearAll } = require('./seed')
global.XMLHttpRequest = require('xhr2');

describe("tests", () => {
  const w = worker.Elm.Worker;
  const onComplete = (name, cb) => {
    const a = w.init()
    a.ports[name].subscribe(cb)
  }

  beforeEach(async () => {
    await loadSeeds()
  })

  afterEach(async () => {
    await clearAll()
  })

  it("TestGet", done => {
    onComplete("testGetResult", () => {
      done()
    })
  })

  it("TestList", done => {
    onComplete("testListResult", () => {
      done()
    })
  })

  it("TestInsert", () => {
    onComplete("testInsertResult", result => {
      assert.ok(result)
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
