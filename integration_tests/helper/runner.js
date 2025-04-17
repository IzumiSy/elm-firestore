import * as vm from "vm";
import * as fs from "fs";
import { fileURLToPath } from "url";
import { dirname, resolve } from "path";
import Seed from "./seed.js";

const __dirname = dirname(fileURLToPath(import.meta.url));

/**
 * `elm make` creates a JS file that is not compatible with ESM modules.
 * So this uses `vm` module to run the JS file in a sandbox to export it as a module.
 */
const loadElmWorker = () => {
  // Using `globalThis` is not good practice, but this is a workaround to run worker code
  const sandbox = globalThis;

  vm.createContext(sandbox);
  vm.runInContext(
    fs.readFileSync(resolve(__dirname, "../dist/worker.js"), "utf8"),
    sandbox
  );

  return sandbox.Elm.Worker;
};

const config = {
  apiKey: "test-api-key",
  projectId: "firestore-integration-test",
  host: "localhost",
  port: 8080,
};

/**
 * Seed loader for Firestore.
 */
export const seed = new Seed({
  apiKey: config.apiKey,
  projectId: config.projectId,
  host: config.host,
  port: config.port,
});

const worker = loadElmWorker();

/**
 * Runner for Elm worker.
 */
export const runTestApp = (triggerName, resultName) => {
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
