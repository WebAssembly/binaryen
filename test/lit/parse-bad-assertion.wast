;; Check that we properly error when an action is missing from an assertion that
;; requires one. Regression test for #6872.

;; RUN: not wasm-shell %s 2>&1 | filecheck %s

(assert_exhaustion "wrong, lol")

;; CHECK: 6:19: error: expected action
