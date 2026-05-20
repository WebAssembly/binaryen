(module
  (type $struct (struct))

  (import "module" "base" (func $foo (param i32) (param f64) (result anyref)))

  (import "module2" "other" (func $bar (result i32 f32)))

  (global $g (mut i32) (i32.const 42))

  (export "one" (func $one))

  (export "glob" (global $g))

  (func $one (param $x (ref $struct)) (result i32 i32 i32)
    (unreachable)
  )
)

;; RUN: wasm-opt %s -all --print-boundary -S -o - | filecheck %s

;; CHECK:      {
;; CHECK-NEXT:  "imports": [
;; CHECK-NEXT:   {
;; CHECK-NEXT:    "module": "module",
;; CHECK-NEXT:    "base": "base",
;; CHECK-NEXT:    "kind": "func",
;; CHECK-NEXT:    "type": {
;; CHECK-NEXT:     "params": [
;; CHECK-NEXT:      "i32",
;; CHECK-NEXT:      "f64"
;; CHECK-NEXT:     ],
;; CHECK-NEXT:     "results": [
;; CHECK-NEXT:      "anyref"
;; CHECK-NEXT:     ]
;; CHECK-NEXT:    }
;; CHECK-NEXT:   },
;; CHECK-NEXT:   {
;; CHECK-NEXT:    "module": "module2",
;; CHECK-NEXT:    "base": "other",
;; CHECK-NEXT:    "kind": "func",
;; CHECK-NEXT:    "type": {
;; CHECK-NEXT:     "params": [
;; CHECK-NEXT:     ],
;; CHECK-NEXT:     "results": [
;; CHECK-NEXT:      "i32",
;; CHECK-NEXT:      "f32"
;; CHECK-NEXT:     ]
;; CHECK-NEXT:    }
;; CHECK-NEXT:   }
;; CHECK-NEXT:  ],
;; CHECK-NEXT:  "exports": [
;; CHECK-NEXT:   {
;; CHECK-NEXT:    "name": "one",
;; CHECK-NEXT:    "kind": "func",
;; CHECK-NEXT:    "type": {
;; CHECK-NEXT:     "params": [
;; CHECK-NEXT:      "(ref $struct.0)"
;; CHECK-NEXT:     ],
;; CHECK-NEXT:     "results": [
;; CHECK-NEXT:      "i32",
;; CHECK-NEXT:      "i32",
;; CHECK-NEXT:      "i32"
;; CHECK-NEXT:     ]
;; CHECK-NEXT:    }
;; CHECK-NEXT:   },
;; CHECK-NEXT:   {
;; CHECK-NEXT:    "name": "glob",
;; CHECK-NEXT:    "kind": "global",
;; CHECK-NEXT:    "type": "i32"
;; CHECK-NEXT:   }
;; CHECK-NEXT:  ]
;; CHECK-NEXT: }
