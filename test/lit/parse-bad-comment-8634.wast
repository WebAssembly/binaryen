;; RUN: not wasm-opt %s 2>&1 | filecheck %s

;; CHECK: Fatal: {{.*}}:8:16: error: expected instruction

;; Regression test for #8634: an unterminated block comment after annotations
;; caused the lexer to advance past the comment start without consuming the
;; trailing whitespace, causing mismatched implicit type positions.
(func (@A) (@A)(;        
