;; This file tests validation only, focusing on GC types and subtyping.

;;;;
;;;;; WasmFX types
;;;;


(module
  (type $f (func))

  (type $ft1 (sub (func (param (ref $f)) (result (ref func)))))
  (type $ct1 (sub (cont $ft1)))

  (type $ft2 (func (param (ref any)) (result (ref func))))
  (type $ct2 (cont $ft2))

  (type $ft3 (sub $ft1 (func (param (ref func)) (result (ref $f)))))
  (type $ct3 (cont $ft3))

  ;; Okay: Continuation types are covariant, have declared $ft3 <: $ft1
  (type $ct_sub (sub $ct1 (cont $ft3)))

  (func $test
    (param $p1 (ref $ct1))
    (param $p2 (ref $ct_sub))

    ;; Okay: (ref $ct_sub) <: (ref $ct1)
    (local.set $p1 (local.get $p2))

  )

)

(assert_invalid
  (module
    (type $f (func))

    (type $ft1 (sub (func (param (ref $f)) (result (ref func)))))
    (type $ct1 (sub (cont $ft1)))

    (type $ft2 (func (param (ref func)) (result (ref $f))))

    ;; Error: $ft2 and ft1 have compatible types, but have not declared $ft2 <: ft1
    (type $error (sub $ct1 (cont $ft2)))

  )
  "sub type 4 does not match super type 2"
)

(assert_invalid
  (module
    (type $f (func))

    (type $ft1 (sub (func (param (ref $f)) (result (ref func)))))
    (type $ct1 (sub (cont $ft1)))

    (type $ft2 (func (param (ref func)) (result (ref $f))))
    (type $ct2 (cont $ft2))

   (func $test
    (param $p1 (ref $ct1))
    (param $p2 (ref $ct2))

    ;; Error $ct2 and $ct1 have generally compatible types,
    ;; but have not declared $ft2 <: ft1 or $ct2 <: $ct1
    ;; Thus, $ct2 </: $ct1.
    (local.set $p1 (local.get $p2))

  )

  )
  "type mismatch"
)

(assert_invalid
  (module
    (type $f (func))

    (type $ft1 (sub (func (param (ref $f)) (result (ref func)))))
    (type $ct1 (sub (cont $ft1)))
    (type $ft3 (sub $ft1 (func (param (ref func)) (result (ref $f)))))
    (type $ct3 (cont $ft3))

   (func $error
    (param $p1 (ref $ct1))
    ;;(param $p2 (ref $ct2))
    (param $p3 (ref $ct3))

    ;; Error $ct3 and $ct1 have generally compatible types,
    ;; (in particular: declared $ft3 <: ft1,
    ;; but have not declared $ct3 <: $ct1
    ;; $ct3 </: $ct1
    (local.set $p1 (local.get $p3))

  )

  )
  "type mismatch"
)

(assert_invalid
  (module

    (func $error
      (param $p_any (ref any))
      (param $p_cont (ref cont))

      ;; Error: cont </: any
      (local.set $p_any (local.get $p_cont))
    )
  )

  "type mismatch"
)

;;;;
;;;; cont_bind instructions
;;;;

(module $non_final

  (type $ft1 (func (param i32) (result (ref func))))
  (type $ct1 (sub (cont $ft1)))

  (type $ft0 (func (result (ref func))))
  (type $ct0 (sub (cont $ft0)))

  (func $test1 (param $x (ref $ct1))
    (i32.const 123)
    (local.get $x)
    ;; Smoke test: using non-final types here
    (cont.bind $ct1 $ct0)
    (drop)
  )
)


(module $subtyping0

  (type $f (func))

  (type $ft0_sup (func (result (ref func))))
  (type $ct0_sup (cont $ft0_sup))

  (type $ft1 (func (param i32) (result (ref $f))))
  (type $ct1 (cont $ft1))

  (type $ft0 (func (result (ref $f))))
  (type $ct0 (cont $ft0))


  (func $test2 (param $x (ref $ct1))
    (i32.const 123)
    (local.get $x)
    ;; Okay: The most natural second continuation type would be $ct0.
    ;; But we have (func (result (ref $f))) <: (func (result (ref $func)))
    ;; This holds without us needing to declare any subtyping relations at all.
    (cont.bind $ct1 $ct0_sup)
    (drop)
  )

)

(module $recursive

  (rec
    (type $ft0 (func             (result (ref $ct_rec))))
    (type $ft1 (func (param i32) (result (ref $ct_rec))))
    (type $ct_rec (cont $ft1))
  )
  (type $ct0 (cont $ft0))

  (rec
    (type $ft0' (func             (result (ref $ct_rec'))))
    (type $ft1' (func (param i32) (result (ref $ct_rec'))))
    (type $ct_rec' (cont $ft1'))
  )
  (type $ct1 (cont $ft1'))


  ;; Okay: Some simple test where the types involved in cont.bind
  ;; are part of a recursion group
  ;; (more concretely: two equivalent recursion groups)
  (func $test (param $x (ref $ct1))
    (i32.const 123)
    (local.get $x)
    (cont.bind $ct1 $ct0)
    (drop)
  )

)

(module $recursive_subtyping

  ;; We define types such that $ft0 <: $ft0_sup and $ct_rec <: $ct_rec_sup
  (rec
    (type $ft0_sup (sub          (func             (result (ref $ct_rec_sup)))))
    (type $ft0     (sub $ft0_sup (func             (result (ref $ct_rec)))))
    (type $ft1     (sub          (func (param i32) (result (ref $ct_rec)))))

    (type $ct_rec_sup (sub (cont $ft0_sup)))
    (type $ct_rec     (sub $ct_rec_sup (cont $ft0)))
  )

  (type $ct0_sup (cont $ft0_sup))
  (type $ct0     (cont $ft0))
  (type $ct1     (cont $ft1))


  (func $test (param $x (ref $ct1))
    (i32.const 123)
    (local.get $x)
    (cont.bind $ct1 $ct0)
    (drop)

    (i32.const 123)
    (local.get $x)
    ;; Okay: We have (func (result (ref $ct_rec))) <: (func (result (ref
    ;; $ct_rec_sup)))
    (cont.bind $ct1 $ct0_sup)
    (drop)
  )

)

;;;;
;;;; resume instructions
;;;;


(module $subtyping_resume0

  (type $ft0 (func))
  (type $ct0 (cont $ft0))

  (type $ft_sup (func (param (ref $ft0))))
  (type $ct_sup (cont $ft_sup))

  (type $ft_sub (func (param (ref func))))
  (type $ct_sub (cont $ft_sub)) ;; unused

  (tag $t (result (ref func)))

  (func $test0
    (param $p (ref $ct0))

    ;; Here we test subtyping with respect to the continuations received by handlers.
    ;;
    ;; The most "straightforward" type of the continuation in $handler would be (ref
    ;; $ct_sub). Instead, we use $ct_sup. According to the spec, we neither need
    ;; to declare $ft_sub <: $ft_sup or $ct_sub <: $ct_sup for this to work. We
    ;; have (func (param (ref func))) <: (func (param (ref $ft0))), which is
    ;; sufficient
    (block $handler (result (ref $ct_sup))
      (local.get $p)
      (resume $ct0 (on $t $handler))
      (return)
    )
    (unreachable)
  )
)

(module $subtyping_resume1

  (type $ft0 (func))
  (type $ct0 (cont $ft0))

  (tag $t (param (ref $ft0)))

  (func $test0
    (param $p (ref $ct0))

    ;; Here we test subtyping with respect to the payloads received by handlers.
    ;; Instead of just (ref $ft0), then handler takes func.
    (block $handler (result (ref func) (ref $ct0))
      (local.get $p)
      (resume $ct0 (on $t $handler))
      (return)
    )
    (unreachable)
  )

)

(assert_invalid
  (module

    (type $ft0 (func))
    (type $ct0 (cont $ft0))

    (type $ft_sup (sub (func (param (ref $ft0)))))
    (type $ct_sup (sub (cont $ft_sup)))

    (type $ft_sub (sub $ft_sup (func (param (ref func)))))
    (type $ct_sub (cont $ft_sub))

    (tag $t (param (ref $ct_sub)))

    (func $test0
      (param $p (ref $ct0))

      ;; This is similar to $subtyping1, but this time we use a continuation as payload.
      ;; But we did not actually declare $ct_sub <: $ct_sub.
      ;;
      ;; This is mostly just to check the following:
      ;; For the continuation received by every handler, we see through the
      ;; continuation type and do structural subtyping on the underlying
      ;; function type.
      ;; However, for continuations that are just payloads ($ct_sup here), we do
      ;; ordinary nominal subtyping.
      (block $handler (result (ref $ct_sup) (ref $ct0))
        (local.get $p)
        (resume $ct0 (on $t $handler))
        (return)
      )
      (unreachable)
    )
  )
  "type mismatch"
)
