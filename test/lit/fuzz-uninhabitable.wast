;; Test that translate-to-fuzz handles uninhabitable types in initial and
;; imported modules without infinitely recursing in makeCompoundRef.

;; RUN: wasm-opt %s -all -ttf --initial-fuzz=%s -S -o - | filecheck %s
;; RUN: wasm-opt %s -all -ttf --fuzz-import=%s -S -o - | filecheck %s --check-prefix=IMPORT

(module
 (rec
  (type $0 (descriptor $1) (struct))
  (type $1 (describes $0) (struct (field (ref (exact $0)))))
 )
 (type $2 (struct (field (ref struct)) (field (ref null (exact $0)))))
 ;; Nullable field referencing uninhabitable $0 in a global.
 (global $g (import "a" "b") (ref $2))
 ;; Synthesize uninhabitable (ref $0) with no local via ref.as_non_null.
 (func $no-param (import "a" "c") (result (ref $0)))
 ;; Synthesize uninhabitable (ref $0) from the available parameter local.
 (func $with-param (import "a" "d") (param (ref $0)) (result (ref $0)))
)

;; CHECK:      (global $g (ref $2) (struct.new $2
;; CHECK-NEXT:  (struct.new{{.*}})
;; CHECK-NEXT:  (ref.null none)
;; CHECK-NEXT: ))

;; CHECK:      (func $no-param (type ${{.*}}) (result (ref $0))
;; CHECK:       (ref.as_non_null
;; CHECK-NEXT:   (ref.null none)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $with-param (type ${{.*}}) (param $0 (ref $0)) (result (ref $0))
;; CHECK:       (local.get $0)
;; CHECK-NEXT: )

;; IMPORT:      (type $[[TYPE:.*]] (struct (field (ref struct)) (field (ref null (exact ${{.*}})))))
;; IMPORT:      (struct.new $[[TYPE]]
;; IMPORT-NEXT:  (struct.new{{.*}})
;; IMPORT-NEXT:  (ref.null none)
;; IMPORT-NEXT: )
