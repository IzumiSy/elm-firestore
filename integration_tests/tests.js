import test, { registerCompletionHandler } from "ava";
import xhr2 from "xhr2";
import { runTestApp, seed } from "./helper/runner.js";

//
// The reason why integration uses AVA as a runner is that it supports concurrent testing.
// Firestore integration heaviliy depends on IO performance of Firestore which is really slow.
// So cuncurrency is a key to reduce time to run integration tests.
//

// Http module in Platform.worker in Elm internally calls XMLHttpRequest in requesting remote data.
// Node.js itself basically does not provide XMLHttpRequest, so here injects "xhr2" instead.
global.XMLHttpRequest = xhr2;

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
  await runTestApp("runTestInsert", "testInsertResult").then((result) => {
    t.true(result.success);
  });
  return reset();
});

test.serial("TestCreate", async (t) => {
  await runTestApp("runTestCreate", "testCreateResult").then((result) => {
    t.true(result.success);
    t.is(result.value, "jessy");
  });
  return reset();
});

test.serial("TestUpsert", async (t) => {
  await runTestApp("runTestUpsert", "testUpsertResult").then((result) => {
    t.true(result.success);
  });
  return reset();
});

test.serial("TestUpsertExisting", async (t) => {
  await runTestApp("runTestUpsertExisting", "testUpsertExistingResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, "user0updated");
    }
  );
  return reset();
});

test.serial("TestPatch", async (t) => {
  await runTestApp("runTestPatch", "testPatchResult").then((result) => {
    t.true(result.success);
    t.is(result.value, "user0patched");
  });
  return reset();
});

test.serial("TestDelete", async (t) => {
  await runTestApp("runTestDelete", "testDeleteResult").then((result) => {
    t.true(result.success);
  });
  return reset();
});

test.serial("TestDeleteExisting", async (t) => {
  await runTestApp("runTestDeleteExisting", "testDeleteExistingResult").then(
    (result) => {
      t.true(result.success);
    }
  );
  return reset();
});

test.serial("TestDeleteExistingFail", async (t) => {
  await runTestApp(
    "runTestDeleteExistingFail",
    "testDeleteExistingFailResult"
  ).then((result) => {
    t.true(result.success);
  });
  return reset();
});

test("TestTransaction", async (t) => {
  await runTestApp("runTestTransaction", "testTransactionResult").then(
    (result) => {
      t.true(result.success);
    }
  );
  return reset();
});

// Skips this test due to issue firebase-tools#3293
test.skip("TestGetTx", async (t) => {
  await runTestApp("runTestGetTx", "testGetTxResult").then((result) => {
    t.true(result.success);
  });
  return reset();
});

// Skips this test due to issue firebase-tools#3293
test.skip("TestListTx", async (t) => {
  await runTestApp("runTestListTx", "testListTxResult").then((result) => {
    t.true(result.success);
  });
  return reset();
});

test.serial("TestQueryTx", async (t) => {
  await runTestApp("runTestQueryTx", "testQueryTxResult").then((result) => {
    t.true(result.success);
  });
  return reset();
});

test("TestGet", (t) => {
  return runTestApp("runTestGet", "testGetResult").then((result) => {
    t.true(result.success);
    t.is(result.value, "user0");
  });
});

// Skip: ListDocuments with a pageToken and an orderBy clause is not supported
test.skip("TestListPageToken", (t) => {
  return runTestApp("runTestListPageToken", "testListPageTokenResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, "user3");
    }
  );
});

test("TestListPageSize", (t) => {
  return runTestApp("runTestListPageSize", "testListPageSizeResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, 3);
    }
  );
});

test("TestListDesc", (t) => {
  return runTestApp("runTestListDesc", "testListDescResult").then((result) => {
    t.true(result.success);
    t.is(result.value, "user4");
  });
});

test("TestListAsc", (t) => {
  return runTestApp("runTestListAsc", "testListAscResult").then((result) => {
    t.true(result.success);
    t.is(result.value, "user0");
  });
});

test("TestQueryFieldOp", (t) => {
  return runTestApp("runTestQueryFieldOp", "testQueryFieldOpResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, 3);
    }
  );
});

test("TestQueryCompositeOp", (t) => {
  return runTestApp(
    "runTestQueryCompositeOp",
    "testQueryCompositeOpResult"
  ).then((result) => {
    t.true(result.success);
    t.is(result.value, 2);
  });
});

test("TestQueryUnaryOp", (t) => {
  return runTestApp("runTestQueryUnaryOp", "testQueryUnaryOpResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, 0);
    }
  );
});

test("TestQueryOrderBy", (t) => {
  return runTestApp("runTestQueryOrderBy", "testQueryOrderByResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, "user4");
    }
  );
});

test("TestQueryEmpty", (t) => {
  return runTestApp("runTestQueryEmpty", "testQueryEmptyResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, 0);
    }
  );
});

test("TestQueryComplex", (t) => {
  return runTestApp("runTestQueryComplex", "testQueryComplexResult").then(
    (result) => {
      t.true(result.success);
      t.is(result.value, "user2");
    }
  );
});

test("TestQuerySubCollection", (t) => {
  return runTestApp(
    "runTestQuerySubCollection",
    "testQuerySubCollectionResult"
  ).then((result) => {
    t.true(result.success);
    t.is(result.value, 3);
  });
});

test("TestQueryCollectionGroup", (t) => {
  return runTestApp(
    "runTestQueryCollectionGroup",
    "testQueryCollectionGroupResult"
  ).then((result) => {
    t.true(result.success);
    t.is(result.value, 4);
  });
});
