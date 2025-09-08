;; Test the flag to preserve imports and exports in fuzzer generation.

;; Generate fuzz output using this wat as initial contents, and with the flag to
;; preserve imports and exports. There should be no new imports or exports, and
;; old ones must stay the same.

;; RUN: wasm-opt %s.ttf --initial-fuzz=%s -all -ttf --fuzz-preserve-imports-exports \
;; RUN:          --metrics -S -o - | filecheck %s --check-prefix=PRESERVE

;; PRESERVE: [exports]      : 1
;; PRESERVE: [imports]      : 5

;; [sic] - we do not close ("))") some imports, which have info in the wat
;; which we do not care about.
;; PRESERVE:  (import "a" "d" (memory $imemory
;; PRESERVE:  (import "a" "e" (table $itable
;; PRESERVE:  (import "a" "b" (global $iglobal i32))
;; PRESERVE:  (import "a" "f" (func $ifunc
;; PRESERVE:  (import "a" "c" (tag $itag

;; PRESERVE:  (export "foo" (func $foo))

;; And, without the flag, we do generate both imports and exports.

;; RUN: wasm-opt %s.ttf --initial-fuzz=%s -all -ttf \
;; RUN:          --metrics -S -o - | filecheck %s --check-prefix=NORMAL

;; Rather than hardcode the number here, find two of each.
;; NORMAL: (import
;; NORMAL: (import
;; NORMAL: (export
;; NORMAL: (export

(module
  ;; Existing imports. Note that the fuzzer normally turns imported globals etc.
  ;; into normal ones (as the fuzz harness does not know what to provide at
  ;; compile time), so we also test that --fuzz-preserve-imports-exports leaves
  ;; such imports alone.
  (import "a" "b" (global $iglobal i32))
  (import "a" "c" (tag $itag))
  (import "a" "d" (memory $imemory 10 20))
  (import "a" "e" (table $itable 10 20 funcref))
  (import "a" "f" (func $ifunc))

  ;; One existing export.
  (func $foo (export "foo")
  )
)

