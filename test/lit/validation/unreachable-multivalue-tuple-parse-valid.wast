;; NOTE: Regression for StackEntry wasmStackType invariants in unreachable
;; multivalue function bodies. Must parse without assertion/crash.
;; RUN: wasm-as %s -all -o /dev/null
;; RUN: wasm-opt %s -all -o /dev/null

(module (type $ret2 (func (result i32 i32)))
 (func (type $ret2)
  i32.const 1
  i32.const 2
  i32.add
  unreachable
  i32.const 3
  i32.const 4
  i32.add
 ))
