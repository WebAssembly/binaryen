;; RUN: not wasm-opt -all %s 2>&1 | filecheck %s

;; CHECK: expected array type annotation on array.new_fixed

(module
  (type $struct (struct (field anyref)))

  (global $struct (ref $struct) (array.new_fixed $struct 1
    (i32.const 64)
  ))
)
