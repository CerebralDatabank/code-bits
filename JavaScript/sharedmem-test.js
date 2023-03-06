const {Worker, isMainThread, parentPort, workerData} = require("worker_threads");

const NUM_THREADS = 100;

/*
let mem = new WebAssembly.Memory({
  initial: 1,
  maximum: 1,
  shared: true
});
let buffer = mem.buffer;
*/
let buffer = new SharedArrayBuffer(2048);

let workers = [];
for (let i = 0; i < NUM_THREADS; i++) {
  // Removing the "-atomic" results in a value less than 1000
  workers[i] = new Worker("./sharedmem-thread-atomic.js");
}
for (let i = 0; i < NUM_THREADS; i++) {
  workers[i].postMessage(buffer);
}

setTimeout(() => {
  for (let i = 0; i < NUM_THREADS; i++) {
    workers[i].postMessage("exit");
  }
  console.log(new Int32Array(buffer)[0]);
}, 5000);
