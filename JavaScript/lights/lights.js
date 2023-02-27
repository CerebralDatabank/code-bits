let N = 432;
let R = 18;
let C = 24;

let switches = [];
for (let i = 0; i < N; i++) {
    switches[i] = "_";
}
function print() {
  for (let i = 0; i < R; i++) {
    let str = "";
    for (let j = 0; j < C; j++) {
      str += switches[(i * R) + j];
    }
    console.log(str);
  }
}

print();

for (let i = 1; i < N; i++) {
  for (let j = i - 1; j < N; j += i) {
    switches[j] = switches[j] == "_" ? "#" : "_";
  }
  console.log(`Person ${i}`);
  print();
}