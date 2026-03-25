;; Similar testcase to autobatch.wast, but here we test the JS output and
;; execution.

(module
  ;; This serializes as [i32 id, i32 param, f64 param], which is a total of 16
  ;; bytes. The f64 is aligned properly just by how the offsets work out.
  (import "outside" "foo1" (func $noresult1 (param i32) (param f64)))

  ;; This serializes as [i32 id, i64 param, f32 param], which is a total of 16
  ;; bytes again, but now the 64-bit param must have a 4-byte buffer before it,
  ;; so it is aligned.
  (import "outside" "foo2" (func $noresult2 (param i64) (param f32)))

  ;; This serializes as [i32 id, i32 param, f32 param], which is a total of 12
  ;; bytes. We bump $cmdbufpos by 16, to keep the thing after us aligned.
  (import "outside" "foo3" (func $noresult3 (param i32) (param f32)))

  (import "outside" "bar" (func $result (result f64)))

  (memory $mem 10 20)

  (func $caller
    ;; Two calls and a flush.
    (call $noresult1
      (i32.const 42)
      (f64.const 3.14159)
    )
    (call $noresult2
      (i64.const 1234)
      (f32.const 2.71828)
    )
    (drop (call $result))

    ;; One call and a flush.
    (call $noresult3
      (i32.const -1)
      (f32.const -2.3)
    )
    (drop (call $result))

    ;; Flush.
    (drop (call $result))
  )
)

;; RUN: wasm-opt %s --autobatch -o %t.wasm --pass-arg=autobatch-js@%t.js
;; RUN: cat %t.js

;; CHECK:      function flush(pos, end) {
;; CHECK-NEXT:   while (pos != end) {
;; CHECK-NEXT:     auto funcId = HEAP32[pos >> 2];
;; CHECK-NEXT:     switch (funcId) {
;; CHECK-NEXT:       case 0: {
;; CHECK-NEXT:         imports['outside']['foo1'](HEAP32[pos + 4 >> 2], HEAPF64[pos + 8 >> 3]);
;; CHECK-NEXT:         pos += 16;
;; CHECK-NEXT:         return;
;; CHECK-NEXT:       }
;; CHECK-NEXT:       case 1: {
;; CHECK-NEXT:         imports['outside']['foo2'](HEAP64[pos + 8 >> 3], HEAPF32[pos + 16 >> 2]);
;; CHECK-NEXT:         pos += 24;
;; CHECK-NEXT:         return;
;; CHECK-NEXT:       }
;; CHECK-NEXT:       case 2: {
;; CHECK-NEXT:         imports['outside']['foo3'](HEAP32[pos + 4 >> 2], HEAPF32[pos + 8 >> 2]);
;; CHECK-NEXT:         pos += 16;
;; CHECK-NEXT:         return;
;; CHECK-NEXT:       }
;; CHECK-NEXT:     }
;; CHECK-NEXT:   }
;; CHECK-NEXT: }

