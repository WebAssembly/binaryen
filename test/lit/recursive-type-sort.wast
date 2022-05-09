;; Test that multiple recursive types are sorted and emitted properly.
;; Regression test for a bug in TypeComparator that made it fail to properly
;; implement the C++ Compare requirements. See #3648.

;; RUN: wasm-opt %s -all --roundtrip -S -o - | filecheck %s
;; RUN: wasm-opt %s -all --roundtrip --nominal -S -o - | filecheck %s

;; Check that there's no crash.
;; CHECK: module

(module
 (type $a (func (param (ref null $b))))
 (type $b (struct (field (ref null $i))))
 (type $c (struct (field (ref null $l))))
 (type $d (func (param (ref null $b))))
 (type $e (func (result (ref null $g))))
 (type $f (func (result (ref null $c))))
 (type $g (struct (field (ref null $j))))
 (type $h (struct (field (ref null $k))))
 (type $i (struct (field (mut (ref null $a)))))
 (type $j (struct (field (mut (ref null $a))) (field (mut (ref null $a)))))
 (type $k (struct (field (mut (ref null $a))) (field (mut (ref null $a))) (field (mut (ref null $e)))))
 (type $l (struct (field (mut (ref null $a))) (field (mut (ref null $d))) (field (mut (ref null $f)))))

 (func $foo
  (local $1 (ref null $h))
  (local $2 (ref null $b))
  (local $3 (ref null $c))
 )
)
