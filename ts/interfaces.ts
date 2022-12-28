export interface FileData {
  path: string;
  data: string;
}

export interface ScriptData {
  path: string;
  name: string;
  data: string;
  description: string;
  requires: string | null;
}
