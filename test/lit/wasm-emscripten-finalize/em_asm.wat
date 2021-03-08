;; Test that em_asm string are extracted correctly when the __start_em_asm
;; and __stop_em_asm globals are exported.

;; RUN: wasm-emscripten-finalize %s -S | filecheck %s

;; Check that the data segment that contains only EM_ASM strings resized to
;; zero, and that the string are extracted into the metadata.

;; CHECK:      (data (i32.const 100) "normal data")
;; CHECK-NEXT: (data (i32.const 512) "")
;; CHECK-NEXT: (data (i32.const 1024) "more data")

;; CHECK:       "asmConsts": {
;; CHECK-NEXT:     "512": "{ console.log('JS hello'); }",
;; CHECK-NEXT:     "541": "{ console.log('hello again'); }"
;; CHECK-NEXT:   },

;; Check that the exports are removed
;; CHECK-NOT: export

(module
 (memory 1 1)
 (global (export "__start_em_asm") i32 (i32.const 512))
 (global (export "__stop_em_asm") i32 (i32.const 573))

 (data (i32.const 100) "normal data")
 (data (i32.const 512) "{ console.log('JS hello'); }\00{ console.log('hello again'); }\00")
 (data (i32.const 1024) "more data")
)
