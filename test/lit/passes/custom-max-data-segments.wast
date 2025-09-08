;; RUN: wasm-opt %s --limit-segments --pass-arg=limit-segments@3 -S -o - | filecheck %s

;; Test that the data segments custom limit is respected.
(module
 (memory 256 256)
 ;; CHECK:      (data $0 (i32.const 0) "A")
 (data (i32.const 0) "A")
 ;; CHECK:      (data $"" (i32.const 1) "AAAA")
 (data (i32.const 1) "A")
 (data (i32.const 2) "A")
 (data (i32.const 3) "A")
 (data (i32.const 4) "A")
)
