;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --string-gathering -all -S -o - | filecheck %s
;; RUN: foreach %s %t wasm-opt --string-lowering  -all -S -o - | filecheck %s --check-prefix=LOWER

;; All the strings should be collected into globals and used from there. They
;; should also be sorted deterministically (alphabetically).
;;
;; LOWER also lowers away strings entirely, leaving only imports and a custom
;; section (that part is tested in string-lowering.wast). It also removes all
;; uses of the string heap type, leaving extern instead for the imported
;; strings.

(module
  ;; Note that $global will be reused: no new global will be added for "foo".
  ;; $global2 almost can, but it has the wrong type, so it won't.

  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (global $string.const_bar (ref string) (string.const "bar"))

  ;; CHECK:      (global $string.const_other (ref string) (string.const "other"))

  ;; CHECK:      (global $global (ref string) (string.const "foo"))
  (global $global (ref string) (string.const "foo"))

  ;; CHECK:      (global $global2 stringref (global.get $string.const_bar))
  ;; LOWER:      (type $0 (func))

  ;; LOWER:      (type $1 (array (mut i16)))

  ;; LOWER:      (type $2 (func (param (ref null $1) i32 i32) (result (ref extern))))

  ;; LOWER:      (type $3 (func (param i32) (result (ref extern))))

  ;; LOWER:      (type $4 (func (param externref (ref null $1) i32) (result i32)))

  ;; LOWER:      (import "string.const" "0" (global $string.const_bar (ref extern)))

  ;; LOWER:      (import "string.const" "1" (global $string.const_other (ref extern)))

  ;; LOWER:      (import "string.const" "2" (global $global (ref extern)))

  ;; LOWER:      (import "wasm:js-string" "fromCharCodeArray" (func $fromCharCodeArray (type $2) (param (ref null $1) i32 i32) (result (ref extern))))

  ;; LOWER:      (import "wasm:js-string" "fromCodePoint" (func $fromCodePoint (type $3) (param i32) (result (ref extern))))

  ;; LOWER:      (import "wasm:js-string" "intoCharCodeArray" (func $intoCharCodeArray (type $4) (param externref (ref null $1) i32) (result i32)))

  ;; LOWER:      (global $global2 externref (global.get $string.const_bar))
  (global $global2 (ref null string) (string.const "bar"))

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (global.get $string.const_bar)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (global.get $global)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; LOWER:      (func $a (type $0)
  ;; LOWER-NEXT:  (drop
  ;; LOWER-NEXT:   (global.get $string.const_bar)
  ;; LOWER-NEXT:  )
  ;; LOWER-NEXT:  (drop
  ;; LOWER-NEXT:   (global.get $global)
  ;; LOWER-NEXT:  )
  ;; LOWER-NEXT: )
  (func $a
    (drop
      (string.const "bar")
    )
    (drop
      (string.const "foo")
    )
  )

  ;; CHECK:      (func $b (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (global.get $string.const_bar)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (global.get $string.const_other)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (global.get $global)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (global.get $global2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; LOWER:      (func $b (type $0)
  ;; LOWER-NEXT:  (drop
  ;; LOWER-NEXT:   (global.get $string.const_bar)
  ;; LOWER-NEXT:  )
  ;; LOWER-NEXT:  (drop
  ;; LOWER-NEXT:   (global.get $string.const_other)
  ;; LOWER-NEXT:  )
  ;; LOWER-NEXT:  (drop
  ;; LOWER-NEXT:   (global.get $global)
  ;; LOWER-NEXT:  )
  ;; LOWER-NEXT:  (drop
  ;; LOWER-NEXT:   (global.get $global2)
  ;; LOWER-NEXT:  )
  ;; LOWER-NEXT: )
  (func $b
    (drop
      (string.const "bar")
    )
    (drop
      (string.const "other")
    )
    ;; Existing global.gets are not modified (but after this pass,
    ;; SimplifyGlobals could help; though in practice the globals would have
    ;; been propagated here anyhow).
    (drop
      (global.get $global)
    )
    (drop
      (global.get $global2)
    )
  )
)

;; Multiple possible reusable globals. Also test ignoring of imports.
(module
  ;; CHECK:      (import "a" "b" (global $import (ref string)))
  ;; LOWER:      (type $0 (array (mut i16)))

  ;; LOWER:      (type $1 (func (param (ref null $0) i32 i32) (result (ref extern))))

  ;; LOWER:      (type $2 (func (param i32) (result (ref extern))))

  ;; LOWER:      (type $3 (func (param externref (ref null $0) i32) (result i32)))

  ;; LOWER:      (import "a" "b" (global $import (ref extern)))
  (import "a" "b" (global $import (ref string)))

  ;; CHECK:      (global $global1 (ref string) (string.const "foo"))
  (global $global1 (ref string) (string.const "foo"))

  ;; CHECK:      (global $global2 (ref string) (global.get $global1))
  ;; LOWER:      (import "string.const" "0" (global $global1 (ref extern)))

  ;; LOWER:      (import "string.const" "1" (global $global4 (ref extern)))

  ;; LOWER:      (import "wasm:js-string" "fromCharCodeArray" (func $fromCharCodeArray (type $1) (param (ref null $0) i32 i32) (result (ref extern))))

  ;; LOWER:      (import "wasm:js-string" "fromCodePoint" (func $fromCodePoint (type $2) (param i32) (result (ref extern))))

  ;; LOWER:      (import "wasm:js-string" "intoCharCodeArray" (func $intoCharCodeArray (type $3) (param externref (ref null $0) i32) (result i32)))

  ;; LOWER:      (global $global2 (ref extern) (global.get $global1))
  (global $global2 (ref string) (string.const "foo"))

  ;; CHECK:      (global $global3 (ref string) (global.get $global1))
  ;; LOWER:      (global $global3 (ref extern) (global.get $global1))
  (global $global3 (ref string) (string.const "foo"))

  ;; CHECK:      (global $global4 (ref string) (string.const "bar"))
  (global $global4 (ref string) (string.const "bar"))

  ;; CHECK:      (global $global5 (ref string) (global.get $global4))
  ;; LOWER:      (global $global5 (ref extern) (global.get $global4))
  (global $global5 (ref string) (string.const "bar"))

  ;; CHECK:      (global $global6 (ref string) (global.get $global4))
  ;; LOWER:      (global $global6 (ref extern) (global.get $global4))
  (global $global6 (ref string) (string.const "bar"))
)
