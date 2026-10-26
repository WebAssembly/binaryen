;; Test that translate-to-fuzz handles uninhabitable types in initial and
;; imported modules without infinitely recursing in makeCompoundRef.

;; RUN: wasm-opt %s -all -ttf --initial-fuzz=%s -S -o - | filecheck %s

;; When importing from a module with uninhabitable types, setupHeapTypes records
;; all uninhabitable types from the imported module in uninhabitableHeapTypes so
;; that if an inhabitable imported type (like $2) is randomly selected into
;; interestingHeapTypes and constructed, makeCompoundRef will emit
;; (ref.null none) for its nullable reference to uninhabitable $0 rather than
;; infinitely recursing. We do not check the output here because setupHeapTypes
;; only imports a random subset of heap types and the fuzzer may not choose to
;; construct $2 for every random input seed.

;; RUN: wasm-opt %s -all -ttf --fuzz-import=%s -S -o -

(module
 (rec
  (type $0 (descriptor $1) (struct))
  (type $1 (describes $0) (struct (field (ref (exact $0)))))
 )
 (type $2 (struct (field (ref struct)) (field (ref null (exact $0)))))

 ;; Nullable field referencing uninhabitable $0 in a global. Because imported
 ;; globals in the initial module are initialized directly with makeConst, this
 ;; deterministically constructs $2 with (ref.null none) for the second field.
 (global $g (import "a" "b") (ref $2))

 ;; Functions returning non-nullable uninhabitable (ref $0). In the common case
 ;; when makeCompoundRef is reached directly to produce the result, $no-param
 ;; has no local of type (ref $0) and falls back to
 ;; (ref.as_non_null (ref.null none)), while $with-param uses (local.get $0).
 ;; We only check the function signatures below because make() can wrap or
 ;; replace the body with arbitrary control flow or unreachable instructions and
 ;; processFunctions() can further mutate the bodies depending on the input
 ;; bytes.
 ;;
 ;; Regardless, this test still proves the absence of infinite loops trying to
 ;; materialize values of the uninhabitable types.
 (func $no-param (import "a" "c") (result (ref $0)))
 (func $with-param (import "a" "d") (param (ref $0)) (result (ref $0)))
)

;; CHECK:      (global $g (ref $2) (struct.new $2
;; CHECK-NEXT:  (struct.new{{.*}})
;; CHECK-NEXT:  (ref.null none)
;; CHECK-NEXT: ))

;; CHECK:      (func $no-param (type ${{.*}}) (result (ref $0))
;; CHECK:      (func $with-param (type ${{.*}}) (param $0 (ref $0)) (result (ref $0))
