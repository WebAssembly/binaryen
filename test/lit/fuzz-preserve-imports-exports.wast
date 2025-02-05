;; Test the flag to preserve imports and exports in fuzzer generation.

;; Generate fuzz output using this wat as initial contents, and with the flag to
;; preserve imports and exports. There should be no imports or exports, as there
;; are none to preserve.

;; RUN: wasm-opt %s.ttf --initial-fuzz=%s -all -ttf --fuzz-preserve-imports-exports -S -o - | filecheck %s --check-prefix=PRESERVE

;; PRESERVE-NOT: (import
;; PRESERVE-NOT: (export

;; And, without the flag, we do generate both imports and exports.

;; RUN: wasm-opt %s.ttf --initial-fuzz=%s -all -ttf                                 -S -o - | filecheck %s --check-prefix=NORMAL

;; NORMAL: (import
;; NORMAL: (export

(module
)

