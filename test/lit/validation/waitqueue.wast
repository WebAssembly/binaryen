;; RUN: not wasm-opt --enable-reference-types --enable-gc %s 2>&1 | filecheck %s

(module
  ;; CHECK:      waitqueue.new requires shared-everything [--enable-shared-everything]
  (func
    (drop (waitqueue.new))
  )
)
