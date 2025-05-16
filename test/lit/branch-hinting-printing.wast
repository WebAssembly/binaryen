;; The branch hint should not cause the later constant to print incorrectly
;; (branch hints are printed in hex, and we should clear that state so later
;; things are not affected).

(module
 (type $0 (func))
 (func $0 (type $0)
  (@metadata.code.inline "\00")
  (call $0)
 )
 (func $1 (type $0)
  (drop
   (i32.const -18428)
  )
 )
)

;; RUN: wasm-opt %s -o %t.wasm -g
;; RUN: wasm-dis %t.wasm | filecheck %s

;; CHECK: (i32.const -18428)
