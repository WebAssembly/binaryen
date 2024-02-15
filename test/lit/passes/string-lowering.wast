;; This file checks the custom section that --string-lowering adds. The other
;; operations are tested in string-gathering.wast (which is auto-updated, unlike
;; this which is manual).

(module
  (func $consts
    (drop
      (string.const "foo")
    )
    (drop
      (string.const "bar")
    )
    (drop
      (string.const "foo")
    )
    (drop
      (string.const "needs\tescaping")
    )
  )
)

;; RUN: foreach %s %t wasm-opt --string-lowering -all -S -o - | filecheck %s

;; The custom section should contain foo and bar, and foo only once, and the
;; string with \t should be escaped.

;; CHECK: custom section "string.consts", size 31, contents: "[\"bar\",\"foo\",\"needs\\tescaping\"]"

