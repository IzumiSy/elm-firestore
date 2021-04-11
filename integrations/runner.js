const worker = require('./worker');
const { describe, it, beforeEach, afterEach } = require('mocha');
const assert = require('assert');
const { loadSeeds, clearAll } = require('./seed')
global.XMLHttpRequest = require('xhr2');

describe("tests", function() {
  const w = worker.Elm.Worker;
  const onComplete = function(name, cb) {
    const a = w.init()
    a.ports[name].subscribe(cb)
  }

  beforeEach(function() {
    this.timeout(10000)
    return loadSeeds()
  })

  afterEach(function() {
    this.timeout(10000)
    return clearAll()
  })

  it("TestGet", function(done) {
    onComplete("testGetResult", function() {
      done()
    })
  })

  it("TestList", function(done) {
    onComplete("testListResult", () => {
      done()
    })
  })

  it("TestInsert", function(done) {
    onComplete("testInsertResult", result => {
      assert.ok(result)
      done()
    })
  })

  it("TestCreate", function(done) {
    onComplete("testCreateResult", () => {
      done()
    })
  })

  it("TestUpsert", function(done) {
    onComplete("testUpsertResult", () => {
      done()
    })
  })
})
