;; RUN: not wasm-opt -all %s -o /dev/null > %t 2>&1
;; RUN: filecheck %s < %t

;; CHECK: i31.get_s/u's argument should be i31ref

(module
  (func $f)
  (func (result i32)
    (i31.get_s (ref.func $f))
  )
)
