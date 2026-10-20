;; Test that translate-to-fuzz handles uninhabitable types in initial module
;; contents without infinitely recursing in makeCompoundRef.

;; RUN: wasm-opt %s -all -ttf --initial-fuzz=%s -S -o - | filecheck %s

(module
 (rec
  (type $0 (descriptor $1) (struct))
  (type $1 (describes $0) (struct (field (ref (exact $0)))))
 )
 (type $2 (struct (field (ref struct)) (field (ref null (exact $0)))))
 (global $g (import "a" "b") (ref $2))
 (func $f1 (import "a" "c") (result (ref $0)))
 (func $f2 (import "a" "d") (param (ref $0)) (result (ref $0)))
 (func $f3 (import "a" "e") (result (ref $0)))
)

;; CHECK:      (global $g (ref $2) (struct.new $2
;; CHECK-NEXT:  (struct.new{{.*}})
;; CHECK-NEXT:  (ref.null none)
;; CHECK-NEXT: ))

;; CHECK:      (func $f1 (type ${{.*}}) (result (ref $0))
;; CHECK:      (func $f2 (type ${{.*}}) (param $0 (ref $0)) (result (ref $0))
;; CHECK:      (func $f3 (type ${{.*}}) (result (ref $0))
