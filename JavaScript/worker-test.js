const {Worker, isMainThread} = require("worker_threads");

async function main() {
  console.log("In main!");
  let worker = new Worker(__filename);
}

async function thread() {
  console.log("In the thread!");
}

isMainThread ? main() : thread();
