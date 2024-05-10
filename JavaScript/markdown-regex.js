function parseMD(str) {
  return str
    .replace(/# (.+?)(?:\n|$)/g, "<h1>$1</h1>\n")
    .replace(/#{2} (.+?)(?:\n|$)/g, "<h2>$1</h2>\n")
    .replace(/#{3} (.+?)(?:\n|$)/g, "<h3>$1</h3>\n")
    .replace(/\*\*(.+?)\*\*/g, "<b>$1</b>")
    .replace(/\*(.+?)\*/g, "<i>$1</i>")
    .replace(/```(?:\n(.*?))?\n```/gs, "<pre><code>$1</code></pre>")
    .replace(/`(.+?)`/g, "<code>$1</code>")
    .replace(/(?<=\n\n|^)- (.+?)(?=\n\n|\n$|$)/g, "<ul><li style='color: rgb(128 64 0);'>$1</li></ul>")
    .replace(/(?<=\n\n|^)- (.+?)(?=\n[^\n]|$)/g, "<ul><li style='color: rgb(128 0 0);'>$1</li>")
    .replace(/(?<=[^\n]\n)- (.+?)(?=\n\n|\n$|$)/g, "<li style='color: rgb(0 0 128);'>$1</li></ul>")
    .replace(/(?<=[^\n]\n)- (.+?)(?=\n[^\n]|$)/g, "<li style='color: rgb(0 128 0);'>$1</li>")
    .replace(/  \n/g, "<br>");
}

// .replace(/(?<=\n)- (.+?)(?=(?:\n[^-]|$))/g, "<ul><li>$1</li></ul>");
