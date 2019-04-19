var tempRet0 = 0;

export function setTempRet0(x) {
  tempRet0 = x;
}
export function getTempRet0() {
  return tempRet0;
}

var buffer = new ArrayBuffer(8);
var i32View = new Int32Array(buffer);
var f32View = new Float32Array(buffer);
var f64View = new Float64Array(buffer);

export function wasm2js_scratch_store_i32(index, value) {
  i32View[index] = value;
}
export function wasm2js_scratch_load_i32(index) {
  return i32View[index];
}

export function wasm2js_scratch_store_i64(low, high) {
  i32View[0] = low;
  i32View[1] = high;
}
export function wasm2js_scratch_load_i64() {
  setTempRet0(i32View[1]);
  return i32View[0];
}

export function wasm2js_scratch_store_f32(value) {
  f32View[0] = value;
}
export function wasm2js_scratch_load_f32() {
  return f32View[0];
}

export function wasm2js_scratch_store_f64(value) {
  f64View[0] = value;
}
export function wasm2js_scratch_load_f64() {
  return f64View[0];
}

