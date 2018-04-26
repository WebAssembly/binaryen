(module
  (type $0 (func (param i32 i32) (result i32)))
  (memory $0 0)
  (func $conditionals (type $0) (param $0 i32) (param $1 i32) (result i32)
    (local $2 i32)
    (local $3 i32)
    (local $4 i32)
    (local $5 i32)
    (local $6 i32)
    (local $7 i32)
    (set_local $0
      (i32.const 0)
    )
    (loop $while-in
      (set_local $3
        (i32.const 0)
      )
      (loop $while-in6
        (set_local $6
          (i32.add
            (get_local $0)
            (i32.const 1)
          )
        )
        (set_local $0
          (if (result i32)
            (i32.or ;; this or is very expensive. we should compute one side, then see if we even need the other
              (i32.eqz
                (i32.rem_s
                  (i32.add
                    (i32.mul
                      (tee_local $7 ;; side effect, so we can't do this one
                        (i32.add
                          (get_local $0)
                          (i32.const 2)
                        )
                      )
                      (get_local $0)
                    )
                    (i32.const 17)
                  )
                  (i32.const 5)
                )
              )
              (i32.eqz
                (i32.rem_u
                  (i32.add
                    (i32.mul
                      (get_local $0)
                      (get_local $0)
                    )
                    (i32.const 11)
                  )
                  (i32.const 3)
                )
              )
            )
            (get_local $7)
            (get_local $6)
          )
        )
        (br_if $while-in6
          (i32.lt_s
            (tee_local $3
              (i32.add
                (get_local $3)
                (i32.const 1)
              )
            )
            (get_local $4)
          )
        )
      )
      (br_if $while-in
        (i32.ne
          (tee_local $1
            (i32.add
              (get_local $1)
              (i32.const 1)
            )
          )
          (i32.const 27000)
        )
      )
    )
    (return
      (get_local $5)
    )
  )
  (func $side-effect (type $0) (param $0 i32) (param $1 i32) (result i32)
    (local $2 i32)
    (local $3 i32)
    (local $4 i32)
    (local $5 i32)
    (local $6 i32)
    (local $7 i32)
    (set_local $0
      (i32.const 0)
    )
    (loop $while-in
      (set_local $3
        (i32.const 0)
      )
      (loop $while-in6
        (set_local $6
          (i32.add
            (get_local $0)
            (i32.const 1)
          )
        )
        (set_local $0
          (if (result i32)
            (i32.or ;; this or is very expensive, but has a side effect on both sides
              (i32.eqz
                (i32.rem_s
                  (i32.add
                    (i32.mul
                      (tee_local $7
                        (i32.add
                          (get_local $0)
                          (i32.const 0)
                        )
                      )
                      (get_local $0)
                    )
                    (i32.const 17)
                  )
                  (i32.const 5)
                )
              )
              (i32.eqz
                (i32.rem_u
                  (i32.add
                    (i32.mul
                      (get_local $0)
                      (get_local $0)
                    )
                    (unreachable)
                  )
                  (i32.const 3)
                )
              )
            )
            (get_local $7)
            (get_local $6)
          )
        )
        (br_if $while-in6
          (i32.lt_s
            (tee_local $3
              (i32.add
                (get_local $3)
                (i32.const 1)
              )
            )
            (get_local $4)
          )
        )
      )
      (br_if $while-in
        (i32.ne
          (tee_local $1
            (i32.add
              (get_local $1)
              (i32.const 1)
            )
          )
          (i32.const 27000)
        )
      )
    )
    (return
      (get_local $5)
    )
  )
  (func $flip (type $0) (param $0 i32) (param $1 i32) (result i32)
    (local $2 i32)
    (local $3 i32)
    (local $4 i32)
    (local $5 i32)
    (local $6 i32)
    (local $7 i32)
    (set_local $0
      (i32.const 0)
    )
    (loop $while-in
      (set_local $3
        (i32.const 0)
      )
      (loop $while-in6
        (set_local $6
          (i32.add
            (get_local $0)
            (i32.const 1)
          )
        )
        (set_local $0
          (if (result i32)
            (i32.or ;; this or is very expensive, and the first side has no side effect
              (i32.eqz
                (i32.rem_s
                  (i32.add
                    (i32.mul
                      (i32.eqz
                        (i32.add
                          (get_local $0)
                          (i32.const 0)
                        )
                      )
                      (get_local $0)
                    )
                    (i32.const 17)
                  )
                  (i32.const 5)
                )
              )
              (i32.eqz
                (i32.rem_u
                  (i32.add
                    (i32.mul
                      (get_local $0)
                      (get_local $0)
                    )
                    (i32.const 100)
                  )
                  (i32.const 3)
                )
              )
            )
            (get_local $7)
            (get_local $6)
          )
        )
        (br_if $while-in6
          (i32.lt_s
            (tee_local $3
              (i32.add
                (get_local $3)
                (i32.const 1)
              )
            )
            (get_local $4)
          )
        )
      )
      (br_if $while-in
        (i32.ne
          (tee_local $1
            (i32.add
              (get_local $1)
              (i32.const 1)
            )
          )
          (i32.const 27000)
        )
      )
    )
    (return
      (get_local $5)
    )
  )
  (func $invalidate-conditionalizeExpensiveOnBitwise (param $0 i32) (param $1 i32) (result i32)
   (if
    (i32.eqz
     (i32.and
      (i32.lt_s
       (i32.and
        (i32.shr_s
         (i32.shl
          (i32.add
           (get_local $1) ;; conflict with tee
           (i32.const -1)
          )
          (i32.const 24)
         )
         (i32.const 24)
        )
        (i32.const 255)
       )
       (i32.const 3)
      )
      (i32.ne
       (tee_local $1
        (i32.const 0)
       )
       (i32.const 0)
      )
     )
    )
    (return (get_local $0))
   )
   (return (get_local $1))
  )
  (func $invalidate-conditionalizeExpensiveOnBitwise-ok (param $0 i32) (param $1 i32) (result i32)
   (if
    (i32.eqz
     (i32.and
      (i32.lt_s
       (i32.and
        (i32.shr_s
         (i32.shl
          (i32.add
           (get_local $0) ;; no conflict
           (i32.const -1)
          )
          (i32.const 24)
         )
         (i32.const 24)
        )
        (i32.const 255)
       )
       (i32.const 3)
      )
      (i32.ne
       (tee_local $1
        (i32.const 0)
       )
       (i32.const 0)
      )
     )
    )
    (return (get_local $0))
   )
   (return (get_local $1))
  )

 (func $conditionalize-if-type-change (result f64)
  (local $0 i32)
  (drop
   (loop $label$1 (result f32)
    (block $label$2 (result f32)
     (drop
      (block $label$3 (result f32)
       (br_if $label$1
        (i32.or ;; this turns into an if, but then the if might not be unreachable
         (f32.gt
          (br_if $label$3
           (f32.const 1)
           (get_local $0)
          )
          (br $label$2
           (f32.const 71)
          )
         )
         (i64.eqz
          (select
           (i64.const 58)
           (i64.const -982757)
           (i64.eqz
            (i64.const 0)
           )
          )
         )
        )
       )
      )
     )
     (f32.const 1)
    )
   )
  )
  (f64.const -nan:0xfffffffffffff)
 )
)

