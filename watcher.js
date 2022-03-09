const path = require("path");
const os = require("os");
// const fs = require("fs"); // node-stream-zip implementation

const chokidar = require("chokidar");
const sevenBin = require("7zip-bin");
const sevenZip = require("node-7z");
// const nodeStreamZip = require("node-stream-zip");
const admZip = require("adm-zip");

const watchDirectory = `${os.homedir()}${path.sep}Downloads${path.sep}`;

console.log("Monitoring", watchDirectory, "for new .7z, .zip or .rar files...");

chokidar
  .watch(watchDirectory, {
    ignoreInitial: true,
  })
  .on("add", (filename) => {
    try {
      const output = `${watchDirectory}${path.basename(
        filename,
        path.extname(filename)
      )}`;
      if ([".7z", ".rar"].includes(path.extname(filename).toLowerCase())) {
        const pathTo7zip = sevenBin.path7za;
        console.log("Extracting", filename);
        const seven = sevenZip.extractFull(filename, output, {
          $bin: pathTo7zip,
        });
      } else if ([".zip"].includes(path.extname(filename).toLowerCase())) { // 7z does not like zip
        const extract = async (asyncFilename, asyncOutput) => {
          const zip = new admZip(asyncFilename);
          await zip.extractAllTo(asyncOutput, true);
          // node-stream-zip implementation, slow
          // const zip = new nodeStreamZip.async({ file: asyncFilename });
          // fs.mkdirSync(asyncOutput);
          // const count = await zip.extract(null, asyncOutput);
          // await zip.close();
        };
        console.log("Extracting", filename);
        extract(filename, output); // node-stream-zip implementation, slow
      }
    } catch (e) {
      console.log(e);
    }
  });
