const path = require("path");
const os = require("os");

const chokidar = require("chokidar");
const sevenBin = require("7zip-bin");
const sevenZip = require("node-7z");

const watchDirectory = `${os.homedir()}${path.sep}Downloads${path.sep}`;

console.log("Monitoring", watchDirectory, "for new .7z, .zip or .rar files...");

try {
  chokidar
    .watch(watchDirectory, {
      ignoreInitial: true,
      // need to wait for files to finish being downloaded before extracting
      awaitWriteFinish: {
        stabilityThreshold: 1000,
        pollInterval: 200,
      },
    })
    .on("add", (filename) => {
      try {
        const output = `${watchDirectory}${path.basename(
          filename,
          path.extname(filename)
        )}`;
        if ([".7z", ".rar", ".zip"].includes(path.extname(filename).toLowerCase())) {
          // use node-7z and 7zip-bin
          const pathTo7zip = sevenBin.path7za;
          console.log("Extracting", filename);
          const seven = sevenZip.extractFull(filename, output, {
            $bin: pathTo7zip,
          });
        }
      } catch (e) {
        console.log(e);
      }
    });
} catch (e) {
  console.log(e);
}
