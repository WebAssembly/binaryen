(module
  ;; Array types used in tests.
  (type $i8 (array (mut i8)))
  (type $i16 (array (mut i16)))
  (type $i32 (array (mut i32)))
  (type $anyref (array (mut anyref)))
  (type $funcref (array (mut funcref)))
  (type $externref (array (mut externref)))

  ;; Array values used in tests. Reset in between tests with the "reset"
  ;; function.
  (global $i8 (mut (ref null $i8)) (ref.null none))
  (global $i16 (mut (ref null $i16)) (ref.null none))
  (global $i32 (mut (ref null $i32)) (ref.null none))
  (global $anyref (mut (ref null $anyref)) (ref.null none))
  (global $funcref (mut (ref null $funcref)) (ref.null none))
  (global $externref (mut (ref null $externref)) (ref.null none))

  ;; GC objects with distinct identities used in anyref tests.
  (global $g1 (export "g1") (mut anyref) (array.new_fixed $i8))
  (global $g2 (export "g2") (mut anyref) (array.new_fixed $i8))
  (global $g3 (export "g3") (mut anyref) (array.new_fixed $i8))
  (global $g4 (export "g4") (mut anyref) (array.new_fixed $i8))
  (global $g5 (export "g5") (mut anyref) (array.new_fixed $i8))

  ;; Functions with distinct return values used in funcref tests.
  (func $f1 (result i32) (i32.const 0))
  (func $f2 (result i32) (i32.const 1))
  (func $f3 (result i32) (i32.const 2))
  (func $f4 (result i32) (i32.const 3))
  (func $f5 (result i32) (i32.const 4))

  ;; Passive element segment used in array.init_elem tests.
  (elem $elem anyref
    (array.new_fixed $i8)
    (array.new_fixed $i8)
    (array.new_fixed $i8)
    (array.new_fixed $i8)
    (array.new_fixed $i8))

  (table $tab anyref 5 5)

  ;; Resets the array globals to known states.
  (func (export "reset")
    (global.set $i8
      (array.new_fixed $i8
        (i32.const 0)
        (i32.const 1)
        (i32.const 2)
        (i32.const 3)
        (i32.const 4)))
    (global.set $i16
      (array.new_fixed $i16
        (i32.const 0)
        (i32.const 1)
        (i32.const 2)
        (i32.const 3)
        (i32.const 4)))
    (global.set $i32
      (array.new_fixed $i32
        (i32.const 0)
        (i32.const 1)
        (i32.const 2)
        (i32.const 3)
        (i32.const 4)))
    (global.set $anyref
      (array.new_fixed $anyref
        (global.get $g1)
        (global.get $g2)
        (global.get $g3)
        (global.get $g4)
        (global.get $g5)))
    (global.set $funcref
      (array.new_fixed $funcref
        (ref.func $f1)
        (ref.func $f2)
        (ref.func $f3)
        (ref.func $f4)
        (ref.func $f5)))
    (global.set $externref
      (array.new_fixed $externref
        (extern.externalize (global.get $g1))
        (extern.externalize (global.get $g2))
        (extern.externalize (global.get $g3))
        (extern.externalize (global.get $g4))
        (extern.externalize (global.get $g5)))))
)

;; array.fill

;; basic i8
;; basic i16
;; basic i32
;; basic anyref
;; basic funcref
;; basic externref
;; basic ref subtype
;; basic ref nullability subtype

;; zero size in bounds
;; zero size at bounds
;; zero size out of bounds traps

;; out of bounds index traps
;; out of bounds size traps
;; out of bounds index + size traps

;; null destination traps

;; immutable field invalid

;; ref supertype invalid
;; ref nullability supertype invalid

;; array.copy

;; basic i8
;; basic i16
;; basic i32
;; basic anyref
;; basic funcref
;; basic externref
;; basic ref subtype
;; basic ref nullability subtype

;; same i8 no overlap
;; same i8 overlap src first
;; same i8 overlap dest first
;; same i8 overlap complete

;; same i32 no overlap
;; same i32 overlap src first
;; same i32 overlap dest first
;; same i32 overlap complete

;; same anyref no overlap
;; same anyref overloap
;; same anyref src first
;; same anyref dest first
;; same anyref overlap complete

;; zero size in bounds
;; zero size at dest bounds
;; zero size at src bounds
;; zero size out of dest bounds traps
;; zero size out of src bounds traps

;; out of bounds dest index traps
;; out of bounds src index traps
;; out of bounds dest size traps
;; out of bounds src index traps
;; out of bounds dest index + size traps
;; out of bounds src index + size traps

;; null dest traps
;; null src traps

;; immutable dest field invalid
;; immutable src field ok

;; ref supertype invalid
;; ref nullability supertype invalid

;; array.init_data

;; basic i8
;; basic i16
;; basic i32
;; basic f32

;; zero size in bounds
;; zero size at dest bounds
;; zero size at src bounds
;; zero size out of dest bounds traps
;; zero size out of src bounds traps

;; out of bounds dest index traps
;; out of bounds src index traps
;; out of bounds dest size traps
;; out of bounds src size traps
;; out of bounds src multiplied size traps
;; out of bounds dest index + size traps
;; out of bounds src index + size traps
;; out of bounds src index + multiplied size traps

;; null dest traps
;; segment dropped traps

;; immutable dest field invalid

;; ref supertype invalid
;; ref nullability supertype invalid

;; out of bounds segment index invalid

;; array.init_elem

;; basic anyref
;; basic funcref
;; basic externref
;; basic ref subtype
;; basic ref nullability subtype

;; zero size in bounds
;; zero size at dest bounds
;; zero size at src bounds
;; zero size out of dest bounds traps
;; zero size out of src bounds traps

;; out of bounds dest index traps
;; out of bounds src index traps
;; out of bounds dest size traps
;; out of bounds src size traps
;; out of bounds dest index + size traps
;; out of bounds src index + size traps

;; null dest traps
;; segment dropped traps

;; immutable dest field invalid

;; ref supertype invalid
;; ref nullability supertype invalid

;; out of bounds segment index invalid
