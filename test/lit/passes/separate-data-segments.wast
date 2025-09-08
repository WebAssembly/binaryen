;; RUN: wasm-opt %s --separate-data-segments=%t.data --pass-arg=separate-data-segments-global-base@1024 -S -o - | filecheck %s
;; RUN: cat %t.data | filecheck %s --check-prefix=CHECK-DATA

(module
  ;; CHECK:      (memory $0 1 1)
  (memory 1 1)

  ;; CHECK-NOT (data
  (data (i32.const 1024) "hello world\n")

  ;; CHECK:      (func $foo
  (func $foo
    (call $bar)
  )

  ;; CHECK:      (func $bar
  (func $bar
    (call $foo)
  )
)

;; CHECK-DATA: {{^}}hello world{{$}}
