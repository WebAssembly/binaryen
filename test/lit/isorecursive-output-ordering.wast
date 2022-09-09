;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.

;; RUN: foreach %s %t wasm-opt -all --hybrid -S -o - | filecheck %s
;; RUN: foreach %s %t wasm-opt -all --hybrid --roundtrip -S -o - | filecheck %s

(module
 ;; Test that we order groups by average uses.


 (rec
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $unused-6 (struct_subtype  data))

  ;; CHECK:       (type $used-a-bit (struct_subtype  data))

  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $unused-1 (struct_subtype  data))
  (type $unused-1 (struct_subtype data))
  ;; CHECK:       (type $unused-2 (struct_subtype  data))
  (type $unused-2 (struct_subtype data))
  ;; CHECK:       (type $unused-3 (struct_subtype  data))
  (type $unused-3 (struct_subtype data))
  ;; CHECK:       (type $unused-4 (struct_subtype  data))
  (type $unused-4 (struct_subtype data))
  ;; CHECK:       (type $used-a-lot (struct_subtype  data))
  (type $used-a-lot (struct_subtype data))
  ;; CHECK:       (type $unused-5 (struct_subtype  data))
  (type $unused-5 (struct_subtype data))
 )

 (rec
  (type $unused-6 (struct_subtype data))
  (type $used-a-bit (struct_subtype data))
 )

 ;; CHECK:      (func $use (type $ref|$used-a-lot|_ref|$used-a-lot|_ref|$used-a-lot|_ref|$used-a-lot|_ref|$used-a-lot|_ref|$used-a-lot|_=>_ref|$used-a-bit|_ref|$used-a-bit|_ref|$used-a-bit|_ref|$used-a-bit|) (param $0 (ref $used-a-lot)) (param $1 (ref $used-a-lot)) (param $2 (ref $used-a-lot)) (param $3 (ref $used-a-lot)) (param $4 (ref $used-a-lot)) (param $5 (ref $used-a-lot)) (result (ref $used-a-bit) (ref $used-a-bit) (ref $used-a-bit) (ref $used-a-bit))
 ;; CHECK-NEXT:  (unreachable)
 ;; CHECK-NEXT: )
 (func $use (param (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot)) (result (ref $used-a-bit) (ref $used-a-bit) (ref $used-a-bit) (ref $used-a-bit))
  (unreachable)
 )
)

(module
 ;; Test that we respect dependencies between groups before considering counts.


 (rec
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $leaf (struct_subtype  data))
  (type $leaf (struct_subtype data))
  ;; CHECK:       (type $unused (struct_subtype  data))
  (type $unused (struct_subtype data))
 )

 (rec
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $shrub (struct_subtype  $leaf))

  ;; CHECK:       (type $used-a-ton (struct_subtype  data))

  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $twig (struct_subtype  data))
  (type $twig (struct_subtype data))
  ;; CHECK:       (type $used-a-bit (struct_subtype (field (ref $leaf)) data))
  (type $used-a-bit (struct_subtype (ref $leaf) data))
 )

 (rec
  (type $shrub (struct_subtype $leaf))
  (type $used-a-ton (struct_subtype data))
 )

 (rec
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $root (struct_subtype  data))
  (type $root (struct_subtype data))
  ;; CHECK:       (type $used-a-lot (struct_subtype  $twig))
  (type $used-a-lot (struct_subtype $twig))
 )

 ;; CHECK:      (func $use (type $ref|$used-a-lot|_ref|$used-a-lot|_ref|$used-a-lot|_ref|$used-a-lot|_ref|$used-a-lot|_ref|$used-a-lot|_=>_ref|$used-a-bit|_ref|$used-a-bit|_ref|$used-a-bit|) (param $0 (ref $used-a-lot)) (param $1 (ref $used-a-lot)) (param $2 (ref $used-a-lot)) (param $3 (ref $used-a-lot)) (param $4 (ref $used-a-lot)) (param $5 (ref $used-a-lot)) (result (ref $used-a-bit) (ref $used-a-bit) (ref $used-a-bit))
 ;; CHECK-NEXT:  (local $6 (ref null $used-a-ton))
 ;; CHECK-NEXT:  (local $7 (ref null $used-a-ton))
 ;; CHECK-NEXT:  (local $8 (ref null $used-a-ton))
 ;; CHECK-NEXT:  (local $9 (ref null $used-a-ton))
 ;; CHECK-NEXT:  (local $10 (ref null $used-a-ton))
 ;; CHECK-NEXT:  (local $11 (ref null $used-a-ton))
 ;; CHECK-NEXT:  (local $12 (ref null $used-a-ton))
 ;; CHECK-NEXT:  (unreachable)
 ;; CHECK-NEXT: )
 (func $use (param (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot)) (result (ref $used-a-bit) (ref $used-a-bit) (ref $used-a-bit))
  (local (ref null $used-a-ton) (ref null $used-a-ton) (ref null $used-a-ton) (ref null $used-a-ton) (ref null $used-a-ton) (ref null $used-a-ton) (ref null $used-a-ton))
  (unreachable)
 )
)

(module
 ;; Test that basic heap type children do not trigger assertions.

 (rec
  ;; CHECK:      (type $contains-basic (struct_subtype (field (ref any)) data))
  (type $contains-basic (struct_subtype (ref any) data))
 )

 ;; CHECK:      (func $use (type $ref|$contains-basic|_=>_none) (param $0 (ref $contains-basic))
 ;; CHECK-NEXT:  (unreachable)
 ;; CHECK-NEXT: )
 (func $use (param (ref $contains-basic))
   (unreachable)
 )
)
