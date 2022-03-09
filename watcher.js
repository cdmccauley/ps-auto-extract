const path = require("path");
const os = require("os");

const chokidar = require("chokidar");
const sevenBin = require("7zip-bin");
const sevenZip = require("node-7z");
const admZip = require("adm-zip");

const watchDirectory = `${os.homedir()}${path.sep}Downloads${path.sep}`;

console.log("Monitoring", watchDirectory, "for new .7z, .zip or .rar files...");

try {
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
          // use node-7z and 7zip-bin
          const pathTo7zip = sevenBin.path7za;
          console.log("Extracting", filename);
          const seven = sevenZip.extractFull(filename, output, {
            $bin: pathTo7zip,
          });
        } else if ([".zip"].includes(path.extname(filename).toLowerCase())) {
          // 7z does not like zip, use adm-zip
          const extract = async (asyncFilename, asyncOutput) => {
            const zip = new admZip(asyncFilename);
            await zip.extractAllTo(asyncOutput, true);
          };
          console.log("Extracting", filename);
          extract(filename, output);
        }
      } catch (e) {
        console.log(e);
      }
    });
} catch (e) {
  console.log(e);
}
