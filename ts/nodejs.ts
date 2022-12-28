const fs = require("fs");


export function getLocalPathScripts(): string[] {
    return fs.readdirSync("./scripts/").filter((file) => {
        return file.endsWith(".ps1");
      }).map(file => {
        return "./scripts/" + file   
      });
}