import { FileData, ScriptData } from "./ts/interfaces";
import { checkRequierements, generatePowershellCode } from "./ts/generate";
import { getLocalPathScripts } from "./ts/nodejs";
import * as fs from "fs"
import { resolve } from "path";

const ini = require("ini");


function readFile(file: string): null | string {
  var result: null | string = null;
  result = fs.readFileSync(file, "utf-8");

  if (result.length == 0) {
    return null;
  } else {
    return result;
  }
}

function extractRawMetadata(content: string): string | null {
  const regex = /# \[Script\](.|\n)*(?=^(\W|)*function )/gm;
  const resultRegex = regex.exec(content);

  if (resultRegex === null) return null;

  const removeCommentSymbol = /^(\W|)*#( )*/gm;
  return resultRegex[0].replace(removeCommentSymbol, "").trim();
}

function convertRawMetadata(
  rawMetadata: string | null,
  fileData: FileData
): ScriptData | null {
  if (!rawMetadata) return null;

  const metadata = ini.parse(rawMetadata);

  const name: string | null = metadata.Script.Name;
  if (name === null) {
    console.error(`Invalid metadata name. ${fileData.path}`);
    return null;
  }

  const description: string | null = metadata.Script.Description;
  if (description === null) {
    console.error(`Invalid metadata description. ${fileData.path}`);
    return null;
  }

  var requires: string | null;

  try {
    requires = metadata.Script.Requires;
  } catch {
    requires = null;
  }

  return {
    path: fileData.path,
    name: name,
    description: description,
    requires: requires,
    data: fileData.data,
  };
}

function getListOfLocalScripts(): ScriptData[] {
  const filesData: FileData[] = getLocalPathScripts()
    .map((file) => {
      const data = readFile(file);

      if (!data) return null;
      return {
        path: file,
        data: data,
      };
    })
    .filter((value): value is FileData => value !== null);

  const scriptData = filesData
    .map((fileData) => {
      return convertRawMetadata(extractRawMetadata(fileData.data), fileData);
    })
    .filter((value): value is ScriptData => value !== null);

  return scriptData;
}

const generatedPs1 = resolve("./Win11-PostInstallation-Script.ps1")
fs.writeFileSync(generatedPs1, generatePowershellCode(getListOfLocalScripts()))

console.log(`Script is generated and written in ${generatedPs1} file`)