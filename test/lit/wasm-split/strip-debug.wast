;; RUN: wasm-split %s --keep-funcs=foo -o1 %t.1.wasm -o2 %t.2.wasm -g --strip-debug
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix=PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix=SECONDARY

;; Check that names are stripped from the output.
;; PRIMARY-NOT: $foo
;; SECONDARY-NOT: $bar

(module
  (func $foo
    (call $bar)
  )
  (func $bar
    (nop)
  )
)
