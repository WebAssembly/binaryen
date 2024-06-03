;; The data segment here is at an offset too large to fit into the memory due
;; to an overflow. That will cause us to fail during flatten, so there are no
;; changes to output here, but we should not error (if we don't check for
;; overflow, we'd segfault).

;; RUN: wasm-ctor-eval %s --ctors=test --kept-exports=test --quiet -all

(module
 (memory $0 10 10)
 (data $0 (i32.const -1) "a")

 (export "test" (func $test))

 (func $test
 )
)
