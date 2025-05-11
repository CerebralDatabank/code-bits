const fs = require("fs");
const qrcode = require("qrcode-terminal");

const FILENAME = "otp-uris.txt";

function waitForKey() {
  return new Promise(resolve => {
    process.stdin.setRawMode(true);
    process.stdin.resume();
    console.log("Press Enter to continue, Backspace to go back, or Q to quit...");
    process.stdin.once("data", data => {
      process.stdin.setRawMode(false);
      const keyCode = data[0];
      // Check for Q or q
      if (keyCode === 81 || keyCode === 113) {
        process.exit(0);
      } else if (keyCode === 127 || keyCode === 8) {
        resolve("backspace");
      } else if (keyCode === 13 || keyCode === 10) {
        resolve("enter");
      } else {
        resolve("other");
      }
    });
  });
}

function parseLabel(uri) {
  try {
    const modifiedUri = uri.replace("otpauth://", "http://");
    const url = new URL(modifiedUri);
    const label = decodeURIComponent(url.pathname.slice(1));
    const parts = label.split(":");
    if (parts.length >= 2) {
      return {
        name: parts[0],
        username: parts.slice(1).join(":")
      };
    }
    return { name: label, username: "" };
  } catch (error) {
    return { name: "", username: "" };
  }
}

async function main() {
  let fileContent;
  try {
    fileContent = await fs.promises.readFile(FILENAME, "utf8");
  } catch (error) {
    console.error("Error reading file:", error.message);
    process.exit(1);
  }

  const lines = fileContent.split(/\r?\n/).filter(line => line.trim() !== "");
  lines.sort((a, b) => {
    const {name: nameA} = parseLabel(a);
    const {name: nameB} = parseLabel(b);
    return nameA.localeCompare(nameB);
  });
  const total = lines.length;

  for (let i = 0; i < total; i++) {
    const line = lines[i];
    process.stdout.write("\x1B[2J\x1B[H");

    const {name, username} = parseLabel(line);
    const displayText = name && username ? `${name} (${username})` : name || line;
    console.log(`\n[${i + 1}/${total}] ${displayText}\n`);
    qrcode.generate(line, {small: true}, qr => console.log(qr));

    const key = await waitForKey();
    if (key === "backspace") {
      i = Math.max(i - 2, -1);
    }
    else if (key === "enter" && i === total - 1) {
      process.exit(0);
    }
  }
}

main();
