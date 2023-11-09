;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --experimental-type-generalizing -all -S -o - | filecheck %s

(module

 ;; CHECK:      (type $void (func))
 (type $void (func))

 ;; CHECK:      (type $1 (func (result eqref)))

 ;; CHECK:      (type $2 (func (param eqref)))

 ;; CHECK:      (type $3 (func (param eqref anyref)))

 ;; CHECK:      (type $4 (func (param anyref)))

 ;; CHECK:      (type $5 (func (param i31ref)))

 ;; CHECK:      (type $6 (func (param anyref eqref)))

 ;; CHECK:      (type $7 (func (result i32)))

 ;; CHECK:      (type $8 (func (result nullref)))

 ;; CHECK:      (type $9 (func (result structref)))

 ;; CHECK:      (type $10 (func (param anyref anyref)))

 ;; CHECK:      (global $global-eq (mut eqref) (ref.null none))
 (global $global-eq (mut eqref) (ref.null none))

 ;; CHECK:      (global $global-i32 (mut i32) (i32.const 0))
 (global $global-i32 (mut i32) (i32.const 0))

 ;; CHECK:      (table $func-table 0 0 funcref)
 (table $func-table 0 0 funcref)

 ;; CHECK:      (table $eq-table 0 0 eqref)
 (table $eq-table 0 0 eqref)

 ;; CHECK:      (elem declare func $ref-func)

 ;; CHECK:      (func $unconstrained (type $void)
 ;; CHECK-NEXT:  (local $x i32)
 ;; CHECK-NEXT:  (local $y anyref)
 ;; CHECK-NEXT:  (local $z (anyref i32))
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT: )
 (func $unconstrained
  ;; This non-ref local should be unmodified
  (local $x i32)
  ;; There is no constraint on the type of this local, so make it top.
  (local $y i31ref)
  ;; We cannot optimize tuple locals yet, so leave it unchanged.
  (local $z (anyref i32))
 )

 ;; CHECK:      (func $implicit-return (type $1) (result eqref)
 ;; CHECK-NEXT:  (local $var eqref)
 ;; CHECK-NEXT:  (local.get $var)
 ;; CHECK-NEXT: )
 (func $implicit-return (result eqref)
  ;; This will be optimized, but only to eqref because of the constraint from the
  ;; implicit return.
  (local $var i31ref)
  (local.get $var)
 )

 ;; CHECK:      (func $implicit-return-unreachable (type $1) (result eqref)
 ;; CHECK-NEXT:  (local $var anyref)
 ;; CHECK-NEXT:  (unreachable)
 ;; CHECK-NEXT: )
 (func $implicit-return-unreachable (result eqref)
  ;; We will optimize this all the way to anyref because we don't analyze
  ;; unreachable code. This would not validate if we didn't run DCE first.
  (local $var i31ref)
  (unreachable)
  (local.get $var)
 )

 ;; CHECK:      (func $if (type $1) (result eqref)
 ;; CHECK-NEXT:  (local $x eqref)
 ;; CHECK-NEXT:  (local $y eqref)
 ;; CHECK-NEXT:  (if (result eqref)
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:   (local.get $y)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $if (result eqref)
  (local $x i31ref)
  (local $y i31ref)
  (if (result i31ref)
   (i32.const 0)
   ;; Require that typeof($x) <: eqref.
   (local.get $x)
   ;; Require that typeof($y) <: eqref.
   (local.get $y)
  )
 )

 ;; CHECK:      (func $loop (type $1) (result eqref)
 ;; CHECK-NEXT:  (local $var eqref)
 ;; CHECK-NEXT:  (loop $loop-in (result eqref)
 ;; CHECK-NEXT:   (local.get $var)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $loop (result eqref)
  (local $var i31ref)
  ;; Require that typeof($var) <: eqref.
  (loop (result i31ref)
   (local.get $var)
  )
 )

 ;; CHECK:      (func $br-sent (type $1) (result eqref)
 ;; CHECK-NEXT:  (local $var1 anyref)
 ;; CHECK-NEXT:  (local $var2 eqref)
 ;; CHECK-NEXT:  (block $l (result eqref)
 ;; CHECK-NEXT:   (block
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (local.get $var1)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (br $l
 ;; CHECK-NEXT:     (local.get $var2)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br-sent (result eqref)
  (local $var1 i31ref)
  (local $var2 i31ref)
  (block $l (result i31ref)
   (call $helper-any_any
    ;; No requirements on $var1
    (local.get $var1)
    ;; Require that typeof($var2) <: eqref.
    (br $l
     (local.get $var2)
    )
   )
  )
 )

 ;; CHECK:      (func $br-no-sent (type $void)
 ;; CHECK-NEXT:  (local $var anyref)
 ;; CHECK-NEXT:  (block $l
 ;; CHECK-NEXT:   (block
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (local.get $var)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (br $l)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br-no-sent
  (local $var i31ref)
  (block $l
   (call $helper-any_any
    ;; No requirements on $var
    (local.get $var)
    (br $l)
   )
  )
 )

 ;; CHECK:      (func $br_table-sent (type $3) (param $eq eqref) (param $any anyref)
 ;; CHECK-NEXT:  (local $var eqref)
 ;; CHECK-NEXT:  (local.set $eq
 ;; CHECK-NEXT:   (block $l1 (result eqref)
 ;; CHECK-NEXT:    (local.set $any
 ;; CHECK-NEXT:     (block $l2 (result eqref)
 ;; CHECK-NEXT:      (br_table $l1 $l2
 ;; CHECK-NEXT:       (local.get $var)
 ;; CHECK-NEXT:       (i32.const 0)
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (unreachable)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_table-sent (param $eq eqref) (param $any anyref)
  (local $var i31ref)
  ;; Require typeof($var) <: eqref.
  (local.set $eq
   (block $l1 (result i31ref)
    ;; Require typeof($var) <: anyref.
    (local.set $any
     (block $l2 (result i31ref)
      (br_table $l1 $l2
       (local.get $var)
       (i32.const 0)
      )
     )
    )
    (unreachable)
   )
  )
 )

 ;; CHECK:      (func $br_table-sent-reversed (type $3) (param $eq eqref) (param $any anyref)
 ;; CHECK-NEXT:  (local $var eqref)
 ;; CHECK-NEXT:  (local.set $any
 ;; CHECK-NEXT:   (block $l1 (result eqref)
 ;; CHECK-NEXT:    (local.set $eq
 ;; CHECK-NEXT:     (block $l2 (result eqref)
 ;; CHECK-NEXT:      (br_table $l1 $l2
 ;; CHECK-NEXT:       (local.get $var)
 ;; CHECK-NEXT:       (i32.const 0)
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (unreachable)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_table-sent-reversed (param $eq eqref) (param $any anyref)
  ;; Same as above, but with the sources of requirements flipped.
  (local $var i31ref)
  ;; Require typeof($var) <: anyref.
  (local.set $any
   (block $l1 (result i31ref)
    ;; Require typeof($var) <: eqref.
    (local.set $eq
     (block $l2 (result i31ref)
      (br_table $l1 $l2
       (local.get $var)
       (i32.const 0)
      )
     )
    )
    (unreachable)
   )
  )
 )

 ;; CHECK:      (func $local-set (type $void)
 ;; CHECK-NEXT:  (local $var anyref)
 ;; CHECK-NEXT:  (local.set $var
 ;; CHECK-NEXT:   (ref.i31
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $local-set
  ;; This will be optimized to anyref.
  (local $var i31ref)
  ;; Require that (ref i31) <: typeof($var).
  (local.set $var
   (i31.new
    (i32.const 0)
   )
  )
 )

 ;; CHECK:      (func $local-get-set (type $4) (param $dest anyref)
 ;; CHECK-NEXT:  (local $var anyref)
 ;; CHECK-NEXT:  (local.set $dest
 ;; CHECK-NEXT:   (local.get $var)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $local-get-set (param $dest anyref)
  ;; This will be optimized to anyref.
  (local $var i31ref)
  ;; Require that typeof($var) <: typeof($dest).
  (local.set $dest
   (local.get $var)
  )
 )

 ;; CHECK:      (func $local-get-set-unreachable (type $5) (param $dest i31ref)
 ;; CHECK-NEXT:  (local $var anyref)
 ;; CHECK-NEXT:  (unreachable)
 ;; CHECK-NEXT: )
 (func $local-get-set-unreachable (param $dest i31ref)
  ;; This is not constrained by reachable code, so we will optimize it.
  (local $var i31ref)
  (unreachable)
  ;; This would require that typeof($var) <: typeof($dest), except it is
  ;; unreachable. This would not validate if we didn't run DCE first.
  (local.set $dest
   (local.tee $var
    (local.get $var)
   )
  )
 )

 ;; CHECK:      (func $local-get-set-join (type $6) (param $dest1 anyref) (param $dest2 eqref)
 ;; CHECK-NEXT:  (local $var eqref)
 ;; CHECK-NEXT:  (local.set $dest1
 ;; CHECK-NEXT:   (local.get $var)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (local.set $dest2
 ;; CHECK-NEXT:   (local.get $var)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $local-get-set-join (param $dest1 anyref) (param $dest2 eqref)
  ;; This wll be optimized to eqref.
  (local $var i31ref)
  ;; Require that typeof($var) <: typeof($dest1).
  (local.set $dest1
   (local.get $var)
  )
  ;; Also require that typeof($var) <: typeof($dest2).
  (local.set $dest2
   (local.get $var)
  )
 )

 ;; CHECK:      (func $local-get-set-chain (type $1) (result eqref)
 ;; CHECK-NEXT:  (local $a eqref)
 ;; CHECK-NEXT:  (local $b eqref)
 ;; CHECK-NEXT:  (local $c eqref)
 ;; CHECK-NEXT:  (local.set $b
 ;; CHECK-NEXT:   (local.get $a)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (local.set $c
 ;; CHECK-NEXT:   (local.get $b)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (local.get $c)
 ;; CHECK-NEXT: )
 (func $local-get-set-chain (result eqref)
  (local $a i31ref)
  (local $b i31ref)
  (local $c i31ref)
  ;; Require that typeof($a) <: typeof($b).
  (local.set $b
   (local.get $a)
  )
  ;; Require that typeof($b) <: typeof($c).
  (local.set $c
   (local.get $b)
  )
  ;; Require that typeof($c) <: eqref.
  (local.get $c)
 )

 ;; CHECK:      (func $local-get-set-chain-out-of-order (type $1) (result eqref)
 ;; CHECK-NEXT:  (local $a eqref)
 ;; CHECK-NEXT:  (local $b eqref)
 ;; CHECK-NEXT:  (local $c eqref)
 ;; CHECK-NEXT:  (local.set $c
 ;; CHECK-NEXT:   (local.get $b)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (local.set $b
 ;; CHECK-NEXT:   (local.get $a)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (local.get $c)
 ;; CHECK-NEXT: )
 (func $local-get-set-chain-out-of-order (result eqref)
  (local $a i31ref)
  (local $b i31ref)
  (local $c i31ref)
  ;; Require that typeof($b) <: typeof($c).
  (local.set $c
   (local.get $b)
  )
  ;; Require that typeof($a) <: typeof($b). We don't know until we evaluate the
  ;; set above that this will constrain $a to eqref.
  (local.set $b
   (local.get $a)
  )
  ;; Require that typeof($c) <: eqref.
  (local.get $c)
 )

 ;; CHECK:      (func $local-tee (type $2) (param $dest eqref)
 ;; CHECK-NEXT:  (local $var eqref)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (local.tee $dest
 ;; CHECK-NEXT:    (local.tee $var
 ;; CHECK-NEXT:     (ref.i31
 ;; CHECK-NEXT:      (i32.const 0)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $local-tee (param $dest eqref)
  ;; This will be optimized to eqref.
  (local $var i31ref)
  (drop
   (local.tee $dest
    (local.tee $var
     (i31.new
      (i32.const 0)
     )
    )
   )
  )
 )

 ;; CHECK:      (func $i31-get (type $void)
 ;; CHECK-NEXT:  (local $nullable i31ref)
 ;; CHECK-NEXT:  (local $nonnullable i31ref)
 ;; CHECK-NEXT:  (local.set $nonnullable
 ;; CHECK-NEXT:   (ref.i31
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (i31.get_s
 ;; CHECK-NEXT:    (local.get $nullable)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (i31.get_u
 ;; CHECK-NEXT:    (local.get $nonnullable)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $i31-get
  ;; This must stay an i31ref.
  (local $nullable i31ref)
  ;; We relax this one to be nullable i31ref as well.
  (local $nonnullable (ref i31))
  ;; Initialize the non-nullable local for validation purposes.
  (local.set $nonnullable
   (i31.new
    (i32.const 0)
   )
  )
  (drop
   ;; Require that typeof($nullable) <: i31ref.
   (i31.get_s
    (local.get $nullable)
   )
  )
  (drop
   ;; Require that typeof($nonnullable) <: i31ref.
   (i31.get_u
    (local.get $nonnullable)
   )
  )
 )

 ;; CHECK:      (func $call (type $2) (param $x eqref)
 ;; CHECK-NEXT:  (local $var eqref)
 ;; CHECK-NEXT:  (call $call
 ;; CHECK-NEXT:   (local.get $var)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $call (param $x eqref)
  ;; This will be optimized to eqref.
  (local $var i31ref)
  ;; Requires typeof($var) <: eqref.
  (call $call
   (local.get $var)
  )
 )

 ;; CHECK:      (func $call_indirect (type $2) (param $x eqref)
 ;; CHECK-NEXT:  (local $var eqref)
 ;; CHECK-NEXT:  (call_indirect $func-table (type $2)
 ;; CHECK-NEXT:   (local.get $var)
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $call_indirect (param $x eqref)
  ;; This will be optimized to eqref.
  (local $var i31ref)
  ;; Requires typeof($var) <: eqref.
  (call_indirect (param eqref)
   (local.get $var)
   (i32.const 0)
  )
 )

 ;; CHECK:      (func $global-get (type $void)
 ;; CHECK-NEXT:  (local $var anyref)
 ;; CHECK-NEXT:  (local $i32 i32)
 ;; CHECK-NEXT:  (local.set $var
 ;; CHECK-NEXT:   (global.get $global-eq)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (local.set $i32
 ;; CHECK-NEXT:   (global.get $global-i32)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $global-get
  (local $var eqref)
  (local $i32 i32)
  ;; The global type will remain unchanged and the local will be generalized.
  (local.set $var
   (global.get $global-eq)
  )
  ;; Non-reference typed globals are ok, too.
  (local.set $i32
   (global.get $global-i32)
  )
 )

 ;; CHECK:      (func $global-set (type $void)
 ;; CHECK-NEXT:  (local $var eqref)
 ;; CHECK-NEXT:  (local $i32 i32)
 ;; CHECK-NEXT:  (global.set $global-eq
 ;; CHECK-NEXT:   (local.get $var)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (global.set $global-i32
 ;; CHECK-NEXT:   (local.get $i32)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $global-set
  (local $var i31ref)
  (local $i32 i32)
  ;; Requires typeof($var) <: eqref.
  (global.set $global-eq
   (local.get $var)
  )
  ;; Non-reference typed globals are ok, too.
  (global.set $global-i32
   (local.get $i32)
  )
 )

 ;; CHECK:      (func $select (type $1) (result eqref)
 ;; CHECK-NEXT:  (local $var1 eqref)
 ;; CHECK-NEXT:  (local $var2 eqref)
 ;; CHECK-NEXT:  (select (result eqref)
 ;; CHECK-NEXT:   (local.get $var1)
 ;; CHECK-NEXT:   (local.get $var2)
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $select (result eqref)
  ;; Both of these will be generalized to eqref.
  (local $var1 i31ref)
  (local $var2 i31ref)
  ;; Requires typeof($var1) <: eqref and typeof($var2) <: eqref.
  (select (result i31ref)
   (local.get $var1)
   (local.get $var2)
   (i32.const 0)
  )
 )

 ;; CHECK:      (func $ref-null (type $void)
 ;; CHECK-NEXT:  (local $var anyref)
 ;; CHECK-NEXT:  (local.set $var
 ;; CHECK-NEXT:   (ref.null none)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $ref-null
  (local $var i31ref)
  ;; No constraints on $var.
  (local.set $var
   (ref.null none)
  )
 )

 ;; CHECK:      (func $ref-is-null (type $void)
 ;; CHECK-NEXT:  (local $var anyref)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (ref.is_null
 ;; CHECK-NEXT:    (local.get $var)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $ref-is-null
  (local $var i31ref)
  (drop
   ;; No constraints on $var.
   (ref.is_null
    (local.get $var)
   )
  )
 )

 ;; CHECK:      (func $ref-func (type $void)
 ;; CHECK-NEXT:  (local $var funcref)
 ;; CHECK-NEXT:  (local.set $var
 ;; CHECK-NEXT:   (ref.func $ref-func)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $ref-func
  (local $var (ref null $void))
  ;; No constraints on $var.
  (local.set $var
   (ref.func $ref-func)
  )
 )

 ;; CHECK:      (func $ref-eq (type $void)
 ;; CHECK-NEXT:  (local $var1 eqref)
 ;; CHECK-NEXT:  (local $var2 eqref)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (ref.eq
 ;; CHECK-NEXT:    (local.get $var1)
 ;; CHECK-NEXT:    (local.get $var2)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $ref-eq
  (local $var1 i31ref)
  (local $var2 i31ref)
  (drop
   ;; Require that typeof($var1) <: eqref and that typeof($var2) <: eqref.
   (ref.eq
    (local.get $var1)
    (local.get $var2)
   )
  )
 )

 ;; CHECK:      (func $table-get (type $void)
 ;; CHECK-NEXT:  (local $var anyref)
 ;; CHECK-NEXT:  (local.set $var
 ;; CHECK-NEXT:   (table.get $eq-table
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $table-get
  (local $var eqref)
  ;; No constraints on $var.
  (local.set $var
   (table.get $eq-table
    (i32.const 0)
   )
  )
 )

 ;; CHECK:      (func $table-set (type $void)
 ;; CHECK-NEXT:  (local $var eqref)
 ;; CHECK-NEXT:  (table.set $eq-table
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:   (local.get $var)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $table-set
  (local $var i31ref)
  ;; Require typeof($var) <: eqref.
  (table.set $eq-table
   (i32.const 0)
   (local.get $var)
  )
 )

 ;; CHECK:      (func $table-fill (type $void)
 ;; CHECK-NEXT:  (local $var eqref)
 ;; CHECK-NEXT:  (table.fill $eq-table
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:   (local.get $var)
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $table-fill
  (local $var i31ref)
  ;; Require typeof($var) <: eqref.
  (table.fill $eq-table
   (i32.const 0)
   (local.get $var)
   (i32.const 0)
  )
 )

 ;; CHECK:      (func $ref-test (type $7) (result i32)
 ;; CHECK-NEXT:  (local $var anyref)
 ;; CHECK-NEXT:  (ref.test nullref
 ;; CHECK-NEXT:   (local.get $var)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $ref-test (result i32)
  (local $var i31ref)
  ;; No constraint on $var.
  (ref.test structref
   (local.get $var)
  )
 )

 ;; CHECK:      (func $ref-cast (type $void)
 ;; CHECK-NEXT:  (local $var anyref)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (ref.cast i31ref
 ;; CHECK-NEXT:    (local.get $var)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $ref-cast
  (local $var i31ref)
  ;; No constraint on $var.
  (drop
   (ref.cast i31ref
    (local.get $var)
   )
  )
 )

 ;; CHECK:      (func $ref-cast-limited (type $1) (result eqref)
 ;; CHECK-NEXT:  (local $var eqref)
 ;; CHECK-NEXT:  (ref.cast i31ref
 ;; CHECK-NEXT:   (local.get $var)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $ref-cast-limited (result eqref)
  (local $var i31ref)
  ;; Require that typeof($var) <: eqref so the cast can still be elimintated.
  (ref.cast i31ref
   (local.get $var)
  )
 )

 ;; CHECK:      (func $ref-cast-more-limited (type $8) (result nullref)
 ;; CHECK-NEXT:  (local $var i31ref)
 ;; CHECK-NEXT:  (ref.cast nullref
 ;; CHECK-NEXT:   (local.get $var)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $ref-cast-more-limited (result nullref)
  (local $var i31ref)
  ;; Require that typeof($var) <: i31ref for montonicity, even though it would
  ;; be nice if we could require nothing of it since we will not be able to
  ;; eliminate this cast.
  (ref.cast nullref
   (local.get $var)
  )
 )

 ;; CHECK:      (func $ref-cast-lub (type $9) (result structref)
 ;; CHECK-NEXT:  (local $var eqref)
 ;; CHECK-NEXT:  (ref.cast nullref
 ;; CHECK-NEXT:   (local.get $var)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $ref-cast-lub (result structref)
  (local $var i31ref)
  ;; Require that typeof($var) <: LUB(structref, i31ref).
  (ref.cast structref
   (local.get $var)
  )
 )

 ;; CHECK:      (func $helper-any_any (type $10) (param $0 anyref) (param $1 anyref)
 ;; CHECK-NEXT:  (unreachable)
 ;; CHECK-NEXT: )
 (func $helper-any_any (param anyref anyref)
  (unreachable)
 )
)

(module
 ;; CHECK:      (type $top (sub (func (param i31ref) (result anyref))))
 (type $top (sub (func (param i31ref) (result anyref))))
 ;; CHECK:      (type $mid (sub $top (func (param eqref) (result anyref))))
 (type $mid (sub $top (func (param eqref) (result anyref))))
 ;; CHECK:      (type $2 (func (result eqref)))

 ;; CHECK:      (type $bot (sub $mid (func (param eqref) (result eqref))))
 (type $bot (sub $mid (func (param eqref) (result eqref))))

 ;; CHECK:      (type $4 (func (result anyref)))

 ;; CHECK:      (func $call-ref-params-limited (type $4) (result anyref)
 ;; CHECK-NEXT:  (local $f (ref null $mid))
 ;; CHECK-NEXT:  (local $arg eqref)
 ;; CHECK-NEXT:  (call_ref $mid
 ;; CHECK-NEXT:   (local.get $arg)
 ;; CHECK-NEXT:   (local.get $f)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $call-ref-params-limited (result anyref)
  (local $f (ref null $bot))
  (local $arg i31ref)
  ;; Require that typeof($f) <: $mid and that typeof($arg) <: eqref. In
  ;; principle we could generalize $f up to $top, but then we wouldn't be able
  ;; to generalize $arg at all.
  (call_ref $bot
   (local.get $arg)
   (local.get $f)
  )
 )

 ;; CHECK:      (func $call-ref-results-limited (type $2) (result eqref)
 ;; CHECK-NEXT:  (local $f (ref null $bot))
 ;; CHECK-NEXT:  (local $arg eqref)
 ;; CHECK-NEXT:  (call_ref $bot
 ;; CHECK-NEXT:   (local.get $arg)
 ;; CHECK-NEXT:   (local.get $f)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $call-ref-results-limited (result eqref)
  (local $f (ref null $bot))
  (local $arg i31ref)
  ;; Require that typeof($f) <: $bot because anything better would require a
  ;; cast on the output. Also require that typeof($arg) <: eqref.
  (call_ref $bot
   (local.get $arg)
   (local.get $f)
  )
 )

 ;; CHECK:      (func $call-ref-impossible (type $2) (result eqref)
 ;; CHECK-NEXT:  (local $arg anyref)
 ;; CHECK-NEXT:  (block ;; (replaces something unreachable we can't emit)
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (local.get $arg)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (ref.null nofunc)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $call-ref-impossible (result eqref)
  (local $arg i31ref)
  ;; No constraint on $arg because the call_ref will not be reached.
  (call_ref $bot
   (local.get $arg)
   (ref.null nofunc)
  )
 )
)

(module
 ;; CHECK:      (type $top (sub (func (result anyref))))
 (type $top (sub (func (result anyref))))
 (type $mid (sub $top (func (result eqref))))
 (type $bot (sub $mid (func (result i31ref))))

 ;; CHECK:      (type $1 (func (result anyref)))

 ;; CHECK:      (func $call-ref-no-limit (type $1) (result anyref)
 ;; CHECK-NEXT:  (local $f (ref null $top))
 ;; CHECK-NEXT:  (call_ref $top
 ;; CHECK-NEXT:   (local.get $f)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $call-ref-no-limit (result anyref)
  (local $f (ref null $bot))
  ;; Require that typeof($f) <: $top because that does not limit us in any way
  ;; and we cannot possibly do better.
  (call_ref $bot
   (local.get $f)
  )
 )
)

(module
 ;; CHECK:      (type $0 (func (result anyref)))

 ;; CHECK:      (type $struct (struct (field anyref) (field eqref)))
 (type $struct (struct (field anyref) (field eqref)))

 ;; CHECK:      (func $struct-new (type $0) (result anyref)
 ;; CHECK-NEXT:  (local $var1 anyref)
 ;; CHECK-NEXT:  (local $var2 eqref)
 ;; CHECK-NEXT:  (struct.new $struct
 ;; CHECK-NEXT:   (local.get $var1)
 ;; CHECK-NEXT:   (local.get $var2)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $struct-new (result anyref)
  (local $var1 i31ref)
  (local $var2 i31ref)
  ;; Require that typeof($var1) <: anyref and that typeof($var2) <: eqref.
  (struct.new $struct
   (local.get $var1)
   (local.get $var2)
  )
 )
)
