const worker = require('./worker');
const w = worker.Elm.Worker.init();
const { describe, it } = require('mocha');
const assert = require('assert');

describe("main", () => {
  it("it", done => {
    done()
  })
})
