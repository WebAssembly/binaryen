;; TODO: Autogenerate these checks! The current script cannot handle `rec`.

;; RUN: foreach %s %t wasm-opt -all --hybrid -S -o - | filecheck %s
;; RUN: foreach %s %t wasm-opt -all --hybrid --roundtrip -S -o - | filecheck %s

(module
 ;; Test that we order groups by average uses.

 ;; CHECK:      (rec
 ;; CHECK-NEXT:  (type $unused-6 (struct_subtype data))
 ;; CHECK-NEXT:  (type $used-a-bit (struct_subtype data))
 ;; CHECK-NEXT: )

 ;; CHECK-NEXT: (rec
 ;; CHECK-NEXT:  (type $unused-1 (struct_subtype data))
 ;; CHECK-NEXT:  (type $unused-2 (struct_subtype data))
 ;; CHECK-NEXT:  (type $unused-3 (struct_subtype data))
 ;; CHECK-NEXT:  (type $unused-4 (struct_subtype data))
 ;; CHECK-NEXT:  (type $used-a-lot (struct_subtype data))
 ;; CHECK-NEXT:  (type $unused-5 (struct_subtype data))
 ;; CHECK-NEXT: )

 (rec
  (type $unused-1 (struct_subtype data))
  (type $unused-2 (struct_subtype data))
  (type $unused-3 (struct_subtype data))
  (type $unused-4 (struct_subtype data))
  (type $used-a-lot (struct_subtype data))
  (type $unused-5 (struct_subtype data))
 )

 (rec
  (type $unused-6 (struct_subtype data))
  (type $used-a-bit (struct_subtype data))
 )

 (func $use (param (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot)) (result (ref $used-a-bit) (ref $used-a-bit) (ref $used-a-bit) (ref $used-a-bit))
  (unreachable)
 )
)

(module
 ;; Test that we respect dependencies between groups before considering counts.

 ;; CHECK:      (rec
 ;; CHECK-NEXT:  (type $leaf (struct_subtype  data))
 ;; CHECK-NEXT:  (type $unused (struct_subtype  data))
 ;; CHECK-NEXT: )

 ;; CHECK-NEXT: (rec
 ;; CHECK-NEXT:  (type $shrub (struct_subtype  $leaf))
 ;; CHECK-NEXT:  (type $used-a-ton (struct_subtype  data))
 ;; CHECK-NEXT: )

 ;; CHECK-NEXT: (rec
 ;; CHECK-NEXT:  (type $twig (struct_subtype  data))
 ;; CHECK-NEXT:  (type $used-a-bit (struct_subtype (field (ref $leaf)) data))
 ;; CHECK-NEXT: )

 ;; CHECK-NEXT: (rec
 ;; CHECK-NEXT:  (type $root (struct_subtype  data))
 ;; CHECK-NEXT:  (type $used-a-lot (struct_subtype  $twig))
 ;; CHECK-NEXT: )

 (rec
  (type $leaf (struct_subtype data))
  (type $unused (struct_subtype data))
 )

 (rec
  (type $twig (struct_subtype data))
  (type $used-a-bit (struct_subtype (ref $leaf) data))
 )

 (rec
  (type $shrub (struct_subtype $leaf))
  (type $used-a-ton (struct_subtype data))
 )

 (rec
  (type $root (struct_subtype data))
  (type $used-a-lot (struct_subtype $twig))
 )

 (func $use (param (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot) (ref $used-a-lot)) (result (ref $used-a-bit) (ref $used-a-bit) (ref $used-a-bit))
  (local (ref null $used-a-ton) (ref null $used-a-ton) (ref null $used-a-ton) (ref null $used-a-ton) (ref null $used-a-ton) (ref null $used-a-ton) (ref null $used-a-ton))
  (unreachable)
 )
)

(module
 ;; Test that basic heap type children do not trigger assertions.

 (rec
  (type $contains-basic (struct_subtype (ref any) data))
 )

 (func $use (param (ref $contains-basic))
   (unreachable)
 )
)
