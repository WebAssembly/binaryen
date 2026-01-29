;; RUN: wasm-split %s --instrument --in-secondary-memory --import-namespace=custom_env --secondary-memory-name=custom_name -all -S -o - | filecheck %s

;; RUN: wasm-split %s --instrument --in-secondary-memory --import-namespace= --secondary-memory-name= -all -S -o - | filecheck %s --check-prefix=EMPTY

;; Check that the output round trips and validates as well
;; RUN: wasm-split %s --instrument --in-secondary-memory -all -g -o %t.wasm
;; RUN: wasm-opt -all %t.wasm -S -o -

(module
  (import "env" "foo" (func $foo))
  (export "bar" (func $bar))
  (memory $0 1 1)
  (func $bar
    (call $foo)
  )
  (func $baz (param i32) (result i32)
    (local.get 0)
  )
)

;; Check that a memory import has been added for secondary memory
;; CHECK: (import "custom_env" "custom_name" (memory $custom_name 1 1 shared))

;; And the profiling function exported
;; CHECK: (export "__write_profile" (func $__write_profile))

;; And main memory has been exported
;; CHECK: (export "profile-memory" (memory $0))

;; Check that the function instrumentation uses the correct memory name
;; CHECK:  (i32.atomic.store8 $custom_name
;; CHECK:  (i32.atomic.store8 $custom_name offset=1
;; CHECK:  (i32.atomic.load8_u $custom_name

;; Do the checks for an empty import namespace and empty secondary memory name
;; as well;
;; EMPTY: (import "" "" (memory $"" 1 1 shared))

;; EMPTY:  (i32.atomic.store8 $""
;; EMPTY:  (i32.atomic.store8 $"" offset=1
;; EMPTY:  (i32.atomic.load8_u $""
