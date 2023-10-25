;; Test that we do not error out on rec group members of public function types
;; with --closed-world

;; RUN: wasm-opt -all --closed-world %s

(module
 (rec
  ;; This type is directly public because it is used on an exported function.
  (type $0 (func))
  ;; This type is not used anywhere, but it is public because $0 is public,
  ;; which makes this entire rec group public.
  (type $1 (func))
  ;; The same for a non-function type.
  (type $2 (struct))
 )
 (export "export-import-A" (func $0))
 (func $0 (type $0)
  (nop)
 )
)
