let addOne, sqrt;
document.getElementById("container").textContent += "hi\n";
fetch('../out/main.wasm').then(response =>
  response.arrayBuffer()
).then(bytes => WebAssembly.instantiate(bytes)).then(results => {
  instance = results.instance;
  addOne = instance.exports.add_one;
  sqrt = instance.exports.sqrt;
  main();
}).catch(console.error);

function print(msg) {
  document.getElementById("container").textContent += `${msg}\n`;
}

function main() {
  print(addOne(1000000));
  print(sqrt(982007569))
}