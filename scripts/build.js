const { readFile, writeFile, chmod } = require("fs");

const executable = "index.js";

readFile(executable, "utf-8", (err, data) => {
  if (err) {
    throw err;
  }
  const out = `#!/usr/bin/env node\n`;
  writeFile(executable, `${out}${data}`, err2 => {
    if (err2) {
      throw err2;
    }
    chmod(executable, 0o755, err3 => {
      if (err3) {
        throw err3;
      }
      console.log("Made bundle an executable");
    });
  });
});
