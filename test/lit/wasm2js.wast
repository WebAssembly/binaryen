;; RUN: wasm2js %s | filecheck %s

(module
 (import "env" "log" (func $log (result i32)))
 (memory 1 1)
 (func (export "test") (result i32)
  ;; Preserves side-effects in delta when max <= initial
  (memory.grow (call $log))
 )
)

;; CHECK:      function $0() {
;; CHECK-NEXT:  return __wasm_memory_grow(log() | 0 | 0) | 0;
;; CHECK-NEXT: }

;; CHECK:      function __wasm_memory_grow(pagesToAdd) {
;; CHECK-NEXT:  pagesToAdd = pagesToAdd | 0;
;; CHECK-NEXT:  var oldPages = __wasm_memory_size() | 0;
;; CHECK-NEXT:  var newPages = oldPages + pagesToAdd | 0;
;; CHECK-NEXT:  if ((oldPages <= newPages) && (newPages < 65536) && (newPages <= 1)) {
;; CHECK-NEXT:   if (oldPages < newPages) {
;; CHECK-NEXT:    var newBuffer = new ArrayBuffer(newPages << 16);
;; CHECK-NEXT:    var newHEAP8 = new Int8Array(newBuffer);
;; CHECK-NEXT:    newHEAP8.set(HEAP8);
;; CHECK-NEXT:    HEAP8 = new Int8Array(newBuffer);
;; CHECK-NEXT:    HEAP16 = new Int16Array(newBuffer);
;; CHECK-NEXT:    HEAP32 = new Int32Array(newBuffer);
;; CHECK-NEXT:    HEAPU8 = new Uint8Array(newBuffer);
;; CHECK-NEXT:    HEAPU16 = new Uint16Array(newBuffer);
;; CHECK-NEXT:    HEAPU32 = new Uint32Array(newBuffer);
;; CHECK-NEXT:    HEAPF32 = new Float32Array(newBuffer);
;; CHECK-NEXT:    HEAPF64 = new Float64Array(newBuffer);
;; CHECK-NEXT:    buffer = newBuffer;
;; CHECK-NEXT:   }
;; CHECK-NEXT:   return oldPages;
;; CHECK-NEXT:  }
;; CHECK-NEXT:  return -1;
;; CHECK-NEXT: }
