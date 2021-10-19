;; Test that em_asm string are extraced correctly when the __start_em_asm
;; and __stop_em_asm globals are exported.

;; RUN: wasm-emscripten-finalize %s -S | filecheck %s

;; Check for the case when __start_em_asm and __stop_em_asm don't define an
;; entire segment. In this case we preserve the segment but zero the data.

;; CHECK: (data (i32.const 512) "xx\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00yy")

;; CHECK:       "asmConsts": {
;; CHECK-NEXT:     "514": "{ console.log('JS hello'); }",
;; CHECK-NEXT:     "543": "{ console.log('hello again'); }"
;; CHECK-NEXT:   },

;; Check that the exports are removed
;; CHECK-NOT: export

(module
 (memory 1 1)
 (global (export "__start_em_asm") i32 (i32.const 514))
 (global (export "__stop_em_asm") i32 (i32.const 575))
 (data (i32.const 512) "xx{ console.log('JS hello'); }\00{ console.log('hello again'); }\00yy")
)
