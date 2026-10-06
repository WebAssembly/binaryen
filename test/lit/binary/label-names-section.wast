;; Check which label names we actually write to the name section. This cannot
;; be checked by disassembling, since reading a binary back generates names for
;; the labels that have none, which then look just like names we had written.
;; This file is manual, not auto-updated, as it checks the output of a script.

;; RUN: wasm-as %s -all -g -o %t.wasm
;; RUN: node %S/label-names.js %t.wasm | filecheck %s

(module
 (func $f (param $p i32)
  ;; Named in the source, so the name is written out.
  (block $explicit
   (br_if $explicit (local.get $p))
  )
  ;; Not named in the source. We do name it `$block` ourselves, as it is
  ;; branched to and Binaryen IR has no other way to refer to it, but a name we
  ;; generated is not worth writing.
  (block
   (br_if 0 (local.get $p))
  )
  ;; Likewise for a loop, which we name `$label`.
  (loop
   (br_if 0 (local.get $p))
  )
 )
)

;; Only the explicit name is there: the names we generated for the other two
;; labels are not written, so nothing refers to them in the binary.
;; CHECK:      function 0, label 0: explicit
;; CHECK-NEXT: 1 label name
