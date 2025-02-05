;; Test the flag to preserve imports and exports in fuzzer generation.

;; Generate fuzz output using this wat as initial contents, and with the flag to
;; preserve imports and exports. There should be no new imports or exports, and
;; old ones must stay the same.

;; RUN: wasm-opt %s.ttf --initial-fuzz=%s -all -ttf --fuzz-preserve-imports-exports --metrics -S -o - | filecheck %s --check-prefix=PRESERVE

;; PRESERVE: [exports]      : 1
;; PRESERVE: [imports]      : 5
;; PRESERVE:  (import "a" "b" (global $ig i32))
;; [sic] - we do not close the tag import as it has a type mentioned, which we
;; do not care about.
;; PRESERVE:  (import "a" "c" (tag $tag
;; PRESERVE:  (export "foo" (func $foo))

;; And, without the flag, we do generate both imports and exports.

;; RUN: wasm-opt %s.ttf --initial-fuzz=%s -all -ttf                                 --metrics -S -o - | filecheck %s --check-prefix=NORMAL

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
  (import "a" "b" (global $ig i32))
  (import "a" "c" (tag $tag))
  (import "a" "d" (memory 10 20))
  (import "a" "e" (table 10 20 funcref))
  (import "a" "f" (func $if))

  ;; One existing export.
  (func $foo (export "foo")
  )
)

