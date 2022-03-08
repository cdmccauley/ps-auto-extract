const path = require("path");
const os = require("os");

const chokidar = require("chokidar");
const sevenBin = require("7zip-bin");
const sevenZip = require("node-7z");

const watchDirectory = `${os.homedir()}${path.sep}Downloads${path.sep}`;

console.log("Monitoring", watchDirectory, "for new .7z, .zip or .rar files...");

chokidar
  .watch(watchDirectory, {
    ignoreInitial: true,
  })
  .on("add", (filename) => {
    try {
      if ([".7z", ".zip", ".rar"].includes(path.extname(filename))) {
        const pathTo7zip = sevenBin.path7za;
        const output = `${watchDirectory}${path.basename(
          filename,
          path.extname(filename)
        )}`;
        console.log("Extracting", filename);
        const seven = sevenZip.extractFull(filename, output, {
          $bin: pathTo7zip,
        });
      }
    } catch (e) {
      console.log(e);
    }
  });
