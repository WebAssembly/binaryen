;; This file tests validation only, without GC types and subtyping.


;;;;
;;;; WasmFX types
;;;;

(module
  (type $ft1 (func))
  (type $ct1 (cont $ft1))

  (type $ft2 (func (param i32) (result i32)))
  (type $ct2 (cont $ft2))

  (func $test
    (param $p1 (ref cont))
    (param $p2 (ref nocont))
    (param $p3 (ref $ct1))

    (local $x1 (ref cont))
    (local $x2 (ref nocont))
    (local $x3 (ref $ct1))
    (local $x4 (ref $ct2))
    (local $x5 (ref null $ct1))

    ;; nocont <: cont
    (local.set $x1 (local.get $p2))

    ;; nocont <: $ct1
    (local.set $x3 (local.get $p2))

    ;; $ct1 <: $cont
    (local.set $x3 (local.get $p3))

    ;; (ref $ct1) <: (ref null $cont)
    (local.set $x5 (local.get $p3))
   )
)

(assert_invalid
  (module
    (type $ft1 (func))
    (type $ct1 (cont $ft1))

    (type $ft2 (func (param i32) (result i32)))
    (type $ct2 (cont $ft2))

    (func $test
      (param $p1 (ref cont))
      (param $p2 (ref nocont))
      (param $p3 (ref $ct1))

      (local $x1 (ref cont))
      (local $x2 (ref nocont))
      (local $x3 (ref $ct1))
      (local $x4 (ref $ct2))
      (local $x5 (ref null $ct1))

      ;; cont </: nocont
      (local.set $p2 (local.get $p1))
     )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type $ft1 (func))
    (type $ct1 (cont $ft1))

    (type $ft2 (func (param i32) (result i32)))
    (type $ct2 (cont $ft2))

    (func $test
      (param $p1 (ref cont))
      (param $p2 (ref nocont))
      (param $p3 (ref $ct1))

      (local $x1 (ref cont))
      (local $x2 (ref nocont))
      (local $x3 (ref $ct1))
      (local $x4 (ref $ct2))
      (local $x5 (ref null $ct1))

      ;; $ct1 </: nocont
      (local.set $p2 (local.get $p3))
     )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type $ft1 (func))
    (type $ct1 (cont $ft1))

    (type $ft2 (func (param i32) (result i32)))
    (type $ct2 (cont $ft2))

    (func $test
      (param $p1 (ref cont))
      (param $p2 (ref nocont))
      (param $p3 (ref $ct1))

      (local $x1 (ref cont))
      (local $x2 (ref nocont))
      (local $x3 (ref $ct1))
      (local $x4 (ref $ct2))
      (local $x5 (ref null $ct1))

      ;; $cont </: $ct1
      (local.set $p3 (local.get $p1))
     )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type $ft1 (func))
    (type $ct1 (cont $ft1))

    (type $ft2 (func (param i32) (result i32)))
    (type $ct2 (cont $ft2))

    (func $test
      (param $p1 (ref cont))
      (param $p2 (ref nocont))
      (param $p3 (ref $ct1))
      (param $p4 (ref $ct2))
      (param $p5 (ref null $ct1))


      (local $x1 (ref cont))
      (local $x2 (ref nocont))
      (local $x3 (ref $ct1))
      (local $x4 (ref $ct2))
      (local $x5 (ref null $ct1))

      ;; (ref null $ct1) </: (ref $cont)
      (local.set $x3 (local.get $p5))
     )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type $ft1 (func))
    (type $ct1 (cont $ft1))

    (type $ft2 (func (param i32) (result i32)))
    (type $ct2 (cont $ft2))

    (func $test
      (param $p1 (ref cont))
      (param $p2 (ref nocont))
      (param $p3 (ref $ct1))
      (param $p4 (ref $ct2))
      (param $p5 (ref null $ct1))


      (local $x1 (ref cont))
      (local $x2 (ref nocont))
      (local $x3 (ref $ct1))
      (local $x4 (ref $ct2))
      (local $x5 (ref null $ct1))

      ;; (ref $ct1) </: (ref $ct2)
      (local.set $p4 (local.get $p3))
     )
  )
  "type mismatch"
)

;;;;
;;;; cont_bind instructions
;;;;

(module
  (type $ft0 (func (result i32)))
  (type $ct0 (cont $ft0))

  (type $ft1 (func (param i32) (result i32)))
  (type $ct1 (cont $ft1))

  (type $ft2 (func (param i64 i32) (result i32)))
  (type $ct2 (cont $ft2))


  (func $test1
    (param $p_ct1 (ref null $ct1))
    (result (ref $ct0))

    ;; cont.bind takes nullable ref, returns non-nullable one
    (i32.const 123)
    (local.get $p_ct1)
    (cont.bind $ct1 $ct0)
  )

  (func $test2
    (param $p_ct2 (ref $ct2))
    (result (ref $ct1))

    ;; cont.bind does not have to apply continuation fully
    (i64.const 123)
    (local.get $p_ct2)
    (cont.bind $ct2 $ct1)
  )

  (func $test3
    (param $p_ct1 (ref $ct1))
    (result (ref $ct1))

    ;; cont.bind can take same type twice, not actually apply anything
    (local.get $p_ct1)
    (cont.bind $ct1 $ct1)
  )


 )

(assert_invalid

  (module
    (type $ft0 (func (result i32)))
    (type $ct0 (cont $ft0))

    (func $error
      (param $p_ft0 (ref $ft0))
      ;; error: non-continuation type on cont.bind
      (local.get $p_ft0)
      (cont.bind $ft0 $ft0)
      (drop)
    )
  )
  "non-continuation type"
)

  ;; cont.new type mismatch: passing a continuation reference to cont.new instead of function reference
  ;; This is actually just checking type-matching, not cont.new specific:
  ;; (ref null $ct1) is not a subtype of (ref null $ft1)

(assert_invalid

  (module
    (type $ft0 (func (result i32)))
    (type $ct0 (cont $ft0))

    (type $ft1 (func (param i32) (result i32)))
    (type $ct1 (cont $ft1))

    (func $error
      (param $p_ct1 (ref $ct1))
      ;; cont.bind type mismatch: passing wrong kind of continuation.
      ;; This is actually just checking type-matching, not cont.bind specific.
      (local.get $p_ct1)
      (cont.bind $ct0 $ct0)
      (drop)
    )
  )
  "type mismatch"
)

(assert_invalid

  (module
    (type $ft0 (func (result i32)))
    (type $ct0 (cont $ft0))

    (type $ft1 (func (param i32) (result i32)))
    (type $ct1 (cont $ft1))

    (type $ft2 (func (param i64 i32) (result i32)))
    (type $ct2 (cont $ft2))


    (type $ft1_alt (func (param i64) (result i32)))
    (type $ct1_alt (cont $ft1_alt))

    (func $error
      (param $p_ct2 (ref $ct2))
      ;; error: two continuation types not agreeing on arg types
      (i64.const 123)
      (local.get $p_ct2)
      (cont.bind $ct2 $ct1_alt)
      (drop)
    )
  )
  "type mismatch"
)

(assert_invalid

  (module
    (type $ft0 (func (result i32)))
    (type $ct0 (cont $ft0))

    (type $ft1 (func (param i32) (result i32)))
    (type $ct1 (cont $ft1))

    (type $ft2 (func (param i64 i32) (result i32)))
    (type $ct2 (cont $ft2))


    (type $ft1_alt (func (param i32) (result i64)))
    (type $ct1_alt (cont $ft1_alt))

    (func $error
      (param $p_ct2 (ref $ct2))
      ;; error: two continuation types not agreeing on return types
      (i64.const 123)
      (local.get $p_ct2)
      (cont.bind $ct2 $ct1_alt)
      (drop)
    )
  )
  "type mismatch"
)

(assert_invalid

  (module
    (type $ft0 (func (result i32)))
    (type $ct0 (cont $ft0))

    (type $ft1 (func (param i32) (result i32)))
    (type $ct1 (cont $ft1))

    (func $error
      (param $p_ct0 (ref $ct0))
      ;; error: trying to go from 0 to 1 args
      (local.get $p_ct0)
      (cont.bind $ct0 $ct1)
      (drop)
    )
  )
  "type mismatch"
)

(assert_invalid

  (module
    (type $ft0 (func (result i32)))
    (type $ct0 (cont $ft0))

    (type $ft1 (func (param i32) (result i32)))
    (type $ct1 (cont $ft1))


    (func $error
      (param $p_ct1 (ref $ct1))
      ;; error: Insufficient arguments::
      ;; This is really testing the general application of arguments to instructions,
      ;; but trying to trick parsers of the folded form
      (cont.bind $ct1 $ct0 (local.get $p_ct1))
      (drop)
    )
  )
  "type mismatch"
)

(assert_invalid

  (module
    (type $ft0 (func (result i32)))
    (type $ct0 (cont $ft0))

    (type $ft1 (func (param i32) (result i32)))
    (type $ct1 (cont $ft1))

    (func $error
      (param $p_ct1 (ref $ct1))
      ;; error: Too many arguments::
      ;; This is really testing the general application of arguments to instructions,
      ;; but trying to trick parsers of the folded form
      (cont.bind $ct1 $ct0 (i32.const 123) (i32.const 123) (local.get $p_ct1))
      (drop)
    )
  )
  "type mismatch"
)

;;;;
;;;; cont_new instructions
;;;;

(module
  (type $ft1 (func (param i32) (result i32)))
  (type $ct1 (cont $ft1))

  (type $ft2 (func (param i32 i32) (result i32)))
  (type $ct2 (cont $ft2))

  (func $f1 (export "f1") (param i32) (result i32)
    (i32.const 123)
  )

  (func $drop_ct1 (param $c (ref $ct1)))

  ;; simple smoke test
  (func $test_good1 (param $x (ref $ft1)) (result (ref $ct1))
    (local.get $x)
    (cont.new $ct1)
  )

  ;; cont.new takes a nullable function
  (func $test_good2 (param $x (ref null $ft1)) (result (ref $ct1))
    (local.get $x)
    (cont.new $ct1)
  )


)

(assert_invalid
  (module
    (type $ft1 (func (param i32) (result i32)))
    (type $ct1 (cont $ft1))

    (func $bad (param $x (ref null $ct1)) (result (ref $ct1))
      (local.get $x)
      (cont.new $ct1)
    )
  )
  ;; cont.new type mismatch: passing a continuation reference to cont.new instead of function reference
  ;; This is actually just checking type-matching, not cont.new specific:
  ;; (ref null $ct1) is not a subtype of (ref null $ft1)
  "type mismatch"
)

(assert_invalid
  (module
    (type $ft1 (func (param i32) (result i32)))
    (type $ct1 (cont $ft1))

    (type $ft2 (func (param i32 i32) (result i32)))
    (type $ct2 (cont $ft2))

    (func $drop_ct1 (param $c (ref $ct1)))

    (func $bad (param $x (ref null $ft2)) (result (ref $ct1))
      (local.get $x)
      (cont.new $ct1)
    )
  )
  ;; cont.new type mismatch: passing function of wrong type to cont.new
  ;; This is actually just checking type-matching, not cont.new specific:
  ;; (ref null $ft2) is not a subtype of (ref null $ft1)
  "type mismatch"
)

(assert_invalid
  (module
    (type $ft1 (func (param i32) (result i32)))
    (type $ct1 (cont $ft1))

    (func $bad (param $x (ref null $ct1))
      (local.get $x)
      (cont.new $ft1)
      (drop)
    )
  )
  ;; non-continuation type on cont.new
  "non-continuation type 0"
)

;;;;
;;;; resume instructions
;;;;


(module
  (type $ft0 (func))
  (type $ct0 (cont $ft0))

  (type $ft1 (func (param f32) (result f64)))
  (type $ct1 (cont $ft1))

  (type $ft2 (func (param i64) (result f64)))
  (type $ct2 (cont $ft2))

  (type $ft3 (func (param i32) (result f64)))
  (type $ct3 (cont $ft3))

  (tag $t0)
  (tag $t1)
  (tag $t2 (param i32) (result i64))
  (tag $t3 (param i64) (result i32))

  ;; Multiple tags, all types handled correctly
  (func $test0 (param $x (ref $ct1)) (result f64)
    (block $handler0 (result i32 (ref $ct2))
      (block $handler1 (result i64 (ref $ct3))
        (f32.const 1.23)
        (local.get $x)
        (resume $ct1 (on $t2 $handler0) (on $t3 $handler1))
        (return)
      )
      (unreachable)
    )
    (unreachable)
  )

  ;; Same as $test0, but we provide two handlers for the same tag
  (func $test1 (param $x (ref $ct1)) (result f64)
    (block $handler0 (result i32 (ref $ct2))
      (block $handler1 (result i32 (ref $ct2))
        (f32.const 1.23)
        (local.get $x)
        (resume $ct1 (on $t2 $handler0) (on $t2 $handler1))
        (return)
      )
      (unreachable)
    )
    (unreachable)
  )

  ;; resume takes a nullable reference
  (func $test2 (param $x (ref null $ct0))
    (local.get $x)
    (resume $ct0)
  )

  ;; handler blocks take the continuation as nullable ref
  (func $test3 (param $x (ref $ct0))
    (block $handler (result (ref null $ct0))
      (local.get $x)
      (resume $ct0 (on $t0 $handler))
      (return)
    )
    (unreachable)
  )

  ;; Nothing wrong with using the same handler block for multiple tags
  (func $test4 (param $x (ref $ct0))
    (block $handler (result (ref null $ct0))
      (local.get $x)
      (resume $ct0 (on $t0 $handler) (on $t1 $handler))
      (return)
    )
    (unreachable)
  )

  ;; handler block can have params
  (func $test5 (param $x (ref $ct0))
    (local.get $x)
    (block $handler (param (ref $ct0)) (result (ref $ct0))
      (resume $ct0 (on $t0 $handler))
      (return)
    )
    (unreachable)
  )
)

;; tag does not exist
(assert_invalid
  (module
    (type $ft0 (func))
    (type $ct0 (cont $ft0))
    ;;(tag $t0)
    (func $error (param $x (ref $ct0))
      (block $handler (result (ref null $ct0))
        (local.get $x)
        (resume $ct0 (on 0 $handler))
        (return)
      )
      (unreachable)
    )

  )
  "unknown tag"
)

;; non-continuation type on resume
(assert_invalid
  (module
    (type $ft0 (func))
    (type $ct0 (cont $ft0))
    (func $error (param $x (ref $ct0))
      (local.get $x)
      (resume $ft0)
    )

  )
  "non-continuation type"
)

;; non-continuation type on handler
(assert_invalid
  (module
    (type $ft0 (func))
    (type $ct0 (cont $ft0))
    (tag $t0)
    (func $test1 (param $x (ref $ct0))
      (block $handler (result (ref $ft0))
        (local.get $x)
        (resume $ct0 (on $t0 $handler))
        (return)
      )
      (unreachable)
    )

  )
  "non-continuation type"
)

(assert_invalid
  (module
    (type $ft (func (param i32)))
    (type $ct (cont $ft))

    (func $error
      (param $p (ref $ct))
      ;; error: Too many arguments::
      ;; This is really testing the general application of arguments to instructions,
      ;; but trying to trick parsers of the folded form
      (resume $ct (i32.const 123) (i32.const 123) (local.get $p))
    )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type $ft (func (param i32)))
    (type $ct (cont $ft))

    (func $error
      (param $p (ref $ct))
      ;; error: Too few arguments::
      ;; This is really testing the general application of arguments to instructions,
      ;; but trying to trick parsers of the folded form
      (resume $ct (local.get $p))
    )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type $ft0 (func (param i32)))
    (type $ct0 (cont $ft0))

    (type $ft1 (func (param i64)))
    (type $ct1 (cont $ft1))

    (func $error
      (param $p (ref $ct1))
      ;; error: Mismatch between annotation on resume and actual argument
      ;; This is really testing the general application of arguments to instructions.
      (resume $ct0 (i32.const 123) (local.get $p))
    )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type $ft0 (func))
    (type $ct0 (cont $ft0))

    (tag $t (param i32))

    (func $error
      (param $p (ref $ct0))
      (block $handler (result (ref $ct0))
        ;; error: handler block has insufficient number of results
        (local.get $p)
        (resume $ct0 (on $t $handler))
        (return)
      )
      (unreachable)
    )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type $ft0 (func))
    (type $ct0 (cont $ft0))

    (tag $t (param i32))

    (func $error
      (param $p (ref $ct0))
      (block $handler (result i32 i32 (ref $ct0))
        ;; error: handler block has too many results
        (local.get $p)
        (resume $ct0 (on $t $handler))
        (return)
      )
      (unreachable)
    )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type $ft0 (func))
    (type $ct0 (cont $ft0))

    (tag $t (param i32))

    (func $error
      (param $p (ref $ct0))
      (block $handler (result i64 (ref $ct0))
        ;; error: type mismatch in non-continuation handler result type
        (local.get $p)
        (resume $ct0 (on $t $handler))
        (return)
      )
      (unreachable)
    )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type $ft0 (func))
    (type $ct0 (cont $ft0))

    (type $ft1 (func (param i32)))
    (type $ct1 (cont $ft1))

    (tag $t (param i32))

    (func $error
      (param $p (ref $ct0))
      (block $handler (result i32 (ref $ct1))
        ;; error: type mismatch in continuation handler result type
        (local.get $p)
        (resume $ct0 (on $t $handler))
        (return)
      )
      (unreachable)
    )
  )
  "type mismatch"
)

;;;;
;;;; suspend instructions
;;;;

(module
  (tag $t (param i64 i32) (result i32 i64))

  (func $test (result i32 i64)
    (i64.const 123)
    (i32.const 123)
    (suspend $t)
  )
)


(assert_invalid
  (module
    (tag $t (param i64 i32) (result i32 i64))

    (func $test (result i32 i64)
      ;; error: Insufficient arguments::
      ;; This is really testing the general application of arguments to instructions,
      ;; but trying to trick parsers of the folded form

      (suspend $t (i64.const 123))
    )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (tag $t (param i32) (result i32 i64))

    (func $test (result i32 i64)
      ;; error: Too many arguments:
      ;; This is really testing the general application of arguments to instructions,
      ;; but trying to trick parsers of the folded form

      (suspend $t (i64.const 123) (i32.const 123))
    )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (func $test
      ;; error: Tag does not exist
      (suspend 0)
    )
  )
  "unknown tag"
)


;; Illegal casts

(assert_invalid
  (module
    (func (drop (ref.test contref (unreachable))))
  )
  "invalid cast"
)
(assert_invalid
  (module
    (func (drop (ref.test nullcontref (unreachable))))
  )
  "invalid cast"
)
(assert_invalid
  (module
    (type $f (func))
    (type $c (cont $f))
    (func (drop (ref.test (ref $c) (unreachable))))
  )
  "invalid cast"
)

(assert_invalid
  (module
    (func (drop (ref.cast contref (unreachable))))
  )
  "invalid cast"
)
(assert_invalid
  (module
    (func (drop (ref.cast nullcontref (unreachable))))
  )
  "invalid cast"
)
(assert_invalid
  (module
    (type $f (func))
    (type $c (cont $f))
    (func (drop (ref.cast (ref $c) (unreachable))))
  )
  "invalid cast"
)

(assert_invalid
  (module
    (func
      (block (result contref) (br_on_cast 0 contref contref (unreachable)))
      (drop)
    )
  )
  "invalid cast"
)
(assert_invalid
  (module
    (func
      (block (result contref) (br_on_cast 0 nullcontref nullcontref (unreachable)))
      (drop)
    )
  )
  "invalid cast"
)
(assert_invalid
  (module
    (type $f (func))
    (type $c (cont $f))
    (func
      (block (result contref) (br_on_cast 0 (ref $c) (ref $c) (unreachable)))
      (drop)
    )
  )
  "invalid cast"
)

(assert_invalid
  (module
    (func
      (block (result contref) (br_on_cast_fail 0 contref contref (unreachable)))
      (drop)
    )
  )
  "invalid cast"
)
(assert_invalid
  (module
    (func
      (block (result contref) (br_on_cast_fail 0 nullcontref nullcontref (unreachable)))
      (drop)
    )
  )
  "invalid cast"
)
(assert_invalid
  (module
    (type $f (func))
    (type $c (cont $f))
    (func
      (block (result contref) (br_on_cast_fail 0 (ref $c) (ref $c) (unreachable)))
      (drop)
    )
  )
  "invalid cast"
)
