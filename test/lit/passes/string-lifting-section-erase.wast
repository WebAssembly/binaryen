;; Test that the section vanishes after lifting.

(module
  (func $strings
    ;; These strings cannot appear as magic imports, and will definitely go in
    ;; the strings section.
    (drop
      (string.const "unpaired high surrogate \ED\A0\80 ")
    )
    (drop
      (string.const "unpaired low surrogate \ED\BD\88 ")
    )
  )
)

;; Lower into the section. We should see the section.
;; RUN: wasm-opt %s -all --string-lowering                  -S -o - | filecheck %s --check-prefix=LOWER
;; LOWER: custom section

;; Also lift. Now no section should appear.
;; RUN: wasm-opt %s -all --string-lowering --string-lifting -S -o - | filecheck %s --check-prefix=AND_LIFT
;; AND_LIFT-NOT: custom section

