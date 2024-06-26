const LIGHT_OFF = "_";
const LIGHT_ON = "#";

/* Can be changed to get user input for rows & cols, then N = rows * cols */
let N = 432;
let rows = 18;
let cols = 24;

let switches = [];
for (let i = 0; i < N; i++) {
  switches[i] = LIGHT_OFF;
}

function print() {
  for (let i = 0; i < N; i += cols) {
    console.log(switches.slice(i, cols + i).join(""));
  }
}

console.log("Initial state");
print();

for (let i = 1; i <= N; i++) {
  for (let j = i - 1; j < N; j += i) {
    switches[j] = switches[j] == LIGHT_OFF ? LIGHT_ON : LIGHT_OFF;
  }
  console.log(`\nPerson ${i}`);
  print();
}