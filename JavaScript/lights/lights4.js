const LIGHT_OFF = "_";
const LIGHT_ON = "#";

/* N = rows * cols */
const ROWS = 18;
const COLS = 24;
const TOTAL = 432;

console.log([...Array(TOTAL + 1).keys()].map((_, i, mainArr) => mainArr[i] = i == 0 ? Array(TOTAL + 1).fill(false) : mainArr[i - 1].map((_, j) => ((j + 1) % i == 0) != mainArr[i - 1][j])).map((e, i) => e.map(b => b ? LIGHT_ON : LIGHT_OFF).join("").match(new RegExp(`.{${COLS}}`, "g")).join("\n")).map((e, i) => [i == 0 ? "Initial state" : `\nPerson ${i}`, e]).flat().join("\n"));