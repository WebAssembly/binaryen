;; Test the flag to preserve imports and exports in fuzzer generation.

;; Generate fuzz output using this wat as initial contents, and with the flag to
;; preserve imports and exports. There should be no new imports or exports, and
;; old ones must stay the same.

;; RUN: wasm-opt %s.ttf --initial-fuzz=%s -all -ttf --fuzz-preserve-imports-exports --metrics -S -o - | filecheck %s --check-prefix=PRESERVE

;; PRESERVE: [exports]      : 1
;; PRESERVE: [imports]      : 1
;; PRESERVE:  (import "a" "b" (global $ig i32))
;; PRESERVE:  (export "foo" (func $foo))

;; And, without the flag, we do generate both imports and exports.

;; RUN: wasm-opt %s.ttf --initial-fuzz=%s -all -ttf                                 --metrics -S -o - | filecheck %s --check-prefix=NORMAL

;; Rather than hardcode the number here, find two of each.
;; NORMAL: (import
;; NORMAL: (import
;; NORMAL: (export
;; NORMAL: (export

(module
  ;; One existing import.
  (import "a" "b" (global $ig i32))

  ;; One existing export.
  (func $foo (export "foo")
  )
)

