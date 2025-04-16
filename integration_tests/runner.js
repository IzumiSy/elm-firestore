import Seed from "./seed.js";
import test, { registerCompletionHandler } from "ava";
import xhr2 from "xhr2";
import { loadElmWorker } from "./loader.js";

//
// The reason why integration uses AVA as a runner is that it supports concurrent testing.
// Firestore integration heaviliy depends on IO performance of Firestore which is really slow.
// So cuncurrency is a key to reduce time to run integration tests.
//

// Http module in Platform.worker in Elm internally calls XMLHttpRequest in requesting remote data.
// Node.js itself basically does not provide XMLHttpRequest, so here injects "xhr2" instead.
global.XMLHttpRequest = xhr2;

const config = {
  apiKey: "test-api-key",
  projectId: "firestore-integration-test",
  host: "localhost",
  port: 8080,
};

const seed = new Seed({
  apiKey: config.apiKey,
  projectId: config.projectId,
  host: config.host,
  port: config.port,
});

const worker = loadElmWorker();
const runner = (triggerName, resultName) => {
  const app = worker.init({
    flags: {
      apiKey: config.apiKey,
      project: config.projectId,
      host: `http://${config.host}`,
      port_: config.port,
    },
  });
  return new Promise((resolve) => {
    app.ports[resultName].subscribe(resolve);
    app.ports[triggerName].send(null);
  });
};

// Resets Firestore contents to the initial
const reset = async () => {
  await seed.clear();
  return seed.populate();
};

test.before("Seeds Firestore", () => {
  return seed.populate();
});

test.after("Cleanup Firestore", () => {
  return seed.clear();
});

registerCompletionHandler(() => {
  process.exit();
});

//
// In order not to break idempotency by updating operation,
// Tests that does updating/creating/deleting data on Firestore are marked as `serial`.
//

test.serial("TestInsert", async (t) => {
  await runner("runTestInsert", "testInsertResult").then((result) => {
    t.true(result.success);
  });
  return reset();
});

test.serial("TestCreate", async (t) => {
  await runner("runTestCreate", "testCreateResult").then((result) => {
    t.true(result.success);
    t.is(result.value, "jessy");
  });
  return reset();
});

test.serial("TestUpsert", async (t) => {
  await runner("runTestUpsert", "testUpsertResult").then((result) => {
    t.true(result.success);
  });
  return reset();
});

test.serial("TestUpsertExisting", async (t) => {
  await runner("runTestUpsertExisting", "testUpsertExistingResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, "user0updated");
    }
  );
  return reset();
});

test.serial("TestPatch", async (t) => {
  await runner("runTestPatch", "testPatchResult").then((result) => {
    t.true(result.success);
    t.is(result.value, "user0patched");
  });
  return reset();
});

test.serial("TestDelete", async (t) => {
  await runner("runTestDelete", "testDeleteResult").then((result) => {
    t.true(result.success);
  });
  return reset();
});

test.serial("TestDeleteExisting", async (t) => {
  await runner("runTestDeleteExisting", "testDeleteExistingResult").then(
    (result) => {
      t.true(result.success);
    }
  );
  return reset();
});

test.serial("TestDeleteExistingFail", async (t) => {
  await runner(
    "runTestDeleteExistingFail",
    "testDeleteExistingFailResult"
  ).then((result) => {
    t.true(result.success);
  });
  return reset();
});

test("TestTransaction", async (t) => {
  await runner("runTestTransaction", "testTransactionResult").then((result) => {
    t.true(result.success);
  });
  return reset();
});

// Skips this test due to issue firebase-tools#3293
test.skip("TestGetTx", async (t) => {
  await runner("runTestGetTx", "testGetTxResult").then((result) => {
    t.true(result.success);
  });
  return reset();
});

// Skips this test due to issue firebase-tools#3293
test.skip("TestListTx", async (t) => {
  await runner("runTestListTx", "testListTxResult").then((result) => {
    t.true(result.success);
  });
  return reset();
});

test.serial("TestQueryTx", async (t) => {
  await runner("runTestQueryTx", "testQueryTxResult").then((result) => {
    t.true(result.success);
  });
  return reset();
});

test("TestGet", (t) => {
  return runner("runTestGet", "testGetResult").then((result) => {
    t.true(result.success);
    t.is(result.value, "user0");
  });
});

// Skip: ListDocuments with a pageToken and an orderBy clause is not supported
test.skip("TestListPageToken", (t) => {
  return runner("runTestListPageToken", "testListPageTokenResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, "user3");
    }
  );
});

test("TestListPageSize", (t) => {
  return runner("runTestListPageSize", "testListPageSizeResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, 3);
    }
  );
});

test("TestListDesc", (t) => {
  return runner("runTestListDesc", "testListDescResult").then((result) => {
    t.true(result.success);
    t.is(result.value, "user4");
  });
});

test("TestListAsc", (t) => {
  return runner("runTestListAsc", "testListAscResult").then((result) => {
    t.true(result.success);
    t.is(result.value, "user0");
  });
});

test("TestQueryFieldOp", (t) => {
  return runner("runTestQueryFieldOp", "testQueryFieldOpResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, 3);
    }
  );
});

test("TestQueryCompositeOp", (t) => {
  return runner("runTestQueryCompositeOp", "testQueryCompositeOpResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, 2);
    }
  );
});

test("TestQueryUnaryOp", (t) => {
  return runner("runTestQueryUnaryOp", "testQueryUnaryOpResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, 0);
    }
  );
});

test("TestQueryOrderBy", (t) => {
  return runner("runTestQueryOrderBy", "testQueryOrderByResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, "user4");
    }
  );
});

test("TestQueryEmpty", (t) => {
  return runner("runTestQueryEmpty", "testQueryEmptyResult").then((result) => {
    t.true(result.success);
    t.is(result.value, 0);
  });
});

test("TestQueryComplex", (t) => {
  return runner("runTestQueryComplex", "testQueryComplexResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, "user2");
    }
  );
});

test("TestQuerySubCollection", (t) => {
  return runner(
    "runTestQuerySubCollection",
    "testQuerySubCollectionResult"
  ).then((result) => {
    t.true(result.success);
    t.is(result.value, 3);
  });
});

test("TestQueryCollectionGroup", (t) => {
  return runner(
    "runTestQueryCollectionGroup",
    "testQueryCollectionGroupResult"
  ).then((result) => {
    t.true(result.success);
    t.is(result.value, 4);
  });
});
