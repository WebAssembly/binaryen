// This is the name by which the tests import the wasm table.
export const table = [];

var tempRet0 = 0;

export function setTempRet0(x) {
  tempRet0 = x;
}

export function getTempRet0() {
  return tempRet0;
}

export const memoryBase = 0;
export const tableBase = 0;
