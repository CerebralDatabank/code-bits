const {Worker, isMainThread, parentPort, workerData} = require("worker_threads");

parentPort.on("message", message => {
  if (message === "exit") {
    parentPort.close();
    return;
  }
  let buffer = message;
  let intBuf = new Int32Array(buffer);
  for (let i = 0; i < 10; i++) {
    Atomics.add(intBuf, 0, 1);
  }
});
