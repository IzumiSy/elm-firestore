const worker = require('./worker');
const { describe, it } = require('mocha');
const assert = require('assert');

describe("tests", () => {
  const w = worker.Elm.Worker;
  const onComplete = (name, cb) => {
    const a = w.init()
    a.ports[name].subscribe(cb)
  }

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

  it("TestInsert", done => {
    onComplete("testInsertResult", () => {
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
