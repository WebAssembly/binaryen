;; This file checks the custom section that --string-lowering adds. The other
;; operations are tested in string-gathering.wast (which is auto-updated, unlike
;; this which is manual).

;; RUN: foreach %s %t wasm-opt --string-lowering -all -S -o - | filecheck %s

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
  )
)

;; The custom section should contain foo and bar, and foo only once.
;; CHECK: custom section "string.consts", size 13, contents: "[\"bar\",\"foo\"]"

