;; RUN: not wasm-opt -all %s 2>&1 | filecheck %s

(module
  (memory $m 1 1)
  (type $arr (array (mut i8)))
  ;; CHECK: Fatal: {{.*}}: error: memory index is not allowed for array load
  (func $load-memidx (param $a (ref $arr))
    (drop (i32.load8_u $m (type $arr) (local.get $a) (i32.const 0)))
  )
)
