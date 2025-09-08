;; The data segment here is at an offset too large to fit into the memory.
;; wasm-ctor-eval will flatten memory, and as a result the segment will start
;; at 0 and contain a great many 0's before that one 'a'. We should not report
;; a validation error or other problem due to that. (We also have nothing to
;; optimize here, so this test just checks we do not error.)

;; RUN: wasm-ctor-eval %s --ctors=test --kept-exports=test --quiet -all

(module
 (memory $0 1 1)
 (data (i32.const 123456) "a")

 (export "test" (func $test))

 (func $test
 )
)

