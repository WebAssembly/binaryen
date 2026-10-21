(module
  (type $struct (struct))

  (type $recurse (func (param $x (ref $recurse))))

  (import "module" "base" (func $foo (param i32) (param f64) (result anyref)))

  (import "module2" "other" (func $bar (result i32 f32)))

  (memory $mem 10 20)

  (table 10 20 funcref)

  (tag $e (param i32))

  (global $g (mut i32) (i32.const 42))

  (export "one" (func $one))

  (export "m" (memory $mem))

  (export "tab" (table 0))

  (export "tag" (tag $e))

  (export "glob" (global $g))

  (func $one (param $x (ref $struct)) (result i32 i32 i32)
    (unreachable)
  )

  (func $recurse (export "recurse") (param $x (ref $recurse))
    ;; We should not error on printing a recursive type.
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
;; CHECK-NEXT:    "name": "recurse",
;; CHECK-NEXT:    "kind": "func",
;; CHECK-NEXT:    "type": {
;; CHECK-NEXT:     "params": [
;; CHECK-NEXT:      "(ref $func.0)"
;; CHECK-NEXT:     ],
;; CHECK-NEXT:     "results": [
;; CHECK-NEXT:     ]
;; CHECK-NEXT:    }
;; CHECK-NEXT:   },
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
;; CHECK-NEXT:    "name": "m",
;; CHECK-NEXT:    "kind": "memory",
;; CHECK-NEXT:    "type": "i32"
;; CHECK-NEXT:   },
;; CHECK-NEXT:   {
;; CHECK-NEXT:    "name": "tab",
;; CHECK-NEXT:    "kind": "table",
;; CHECK-NEXT:    "type": "funcref"
;; CHECK-NEXT:   },
;; CHECK-NEXT:   {
;; CHECK-NEXT:    "name": "tag",
;; CHECK-NEXT:    "kind": "tag",
;; CHECK-NEXT:    "type": {
;; CHECK-NEXT:     "params": [
;; CHECK-NEXT:      "i32"
;; CHECK-NEXT:     ],
;; CHECK-NEXT:     "results": [
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

