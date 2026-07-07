;; RUN: not wasm-opt --enable-reference-types --enable-gc %s 2>&1 | filecheck %s
(module
  (type $struct (struct (field i32)))
  ;; CHECK:      waitqueue.new requires shared-everything [--enable-shared-everything]
  (func
    (drop (waitqueue.new))
  )
)

