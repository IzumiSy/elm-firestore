import * as vm from "vm";
import * as fs from "fs";
import { fileURLToPath } from "url";
import { dirname, resolve } from "path";

const __dirname = dirname(fileURLToPath(import.meta.url));

/**
 * `elm make` creates a JS file that is not compatible with ESM modules.
 * So this uses `vm` module to run the JS file in a sandbox to export it as a module.
 */
export const loadElmWorker = () => {
  const sandbox = { console };

  vm.createContext(sandbox);
  vm.runInContext(
    fs.readFileSync(resolve(__dirname, "./worker.js"), "utf8"),
    sandbox
  );

  return sandbox.Elm.Worker;
};
