;; A large WAST blob which contains the implementations of all the intrinsics
;; that we inject as part of this module. This blob was generated from a Rust
;; program [1] which uses the Rust compiler-builtins project. It's not
;; necessarily perfect but gets the job done! The idea here is that we inject
;; these pretty early so they can continue to be optimized by further passes
;; (aka inlining and whatnot)
;;
;; [1]: https://gist.github.com/alexcrichton/e7ea67bcdd17ce4b6254e66f77165690

(module
 (type $0 (func (param i64 i64) (result i64)))
 (type $1 (func (param f32) (result f32)))
 (type $2 (func (param f64) (result f64)))
 (type $3 (func (param i32) (result i32)))
 (type $4 (func (param i32 i32) (result i32)))
 (import "env" "memory" (memory $0 17))
 (export "__wasm_i64_sdiv" (func $__wasm_i64_sdiv))
 (export "__wasm_i64_udiv" (func $__wasm_i64_udiv))
 (export "__wasm_i64_srem" (func $__wasm_i64_srem))
 (export "__wasm_i64_urem" (func $__wasm_i64_urem))
 (export "__wasm_i64_mul" (func $__wasm_i64_mul))
 (export "__wasm_trunc_f32" (func $__wasm_trunc_f32))
 (export "__wasm_trunc_f64" (func $__wasm_trunc_f64))
 (export "__wasm_ctz_i32" (func $__wasm_ctz_i32))
 (export "__wasm_ctz_i64" (func $__wasm_ctz_i64))
 (export "__wasm_rotl_i32" (func $__wasm_rotl_i32))
 (export "__wasm_rotr_i32" (func $__wasm_rotr_i32))
 (export "__wasm_rotl_i64" (func $__wasm_rotl_i64))
 (export "__wasm_rotr_i64" (func $__wasm_rotr_i64))
 (export "__wasm_nearest_f32" (func $__wasm_nearest_f32))
 (export "__wasm_nearest_f64" (func $__wasm_nearest_f64))
 (export "__wasm_popcnt_i32" (func $__wasm_popcnt_i32))
 (export "__wasm_popcnt_i64" (func $__wasm_popcnt_i64))

 ;; lowering of the i32.popcnt instruction, counts the number of bits set in the
 ;; input and returns the result
 (func $__wasm_popcnt_i32 (param $var$0 i32) (result i32)
  (local $var$1 i32)
  (block $label$1 (result i32)
   (loop $label$2
    (drop
     (br_if $label$1
      (get_local $var$1)
      (i32.eqz
       (get_local $var$0)
      )
     )
    )
    (set_local $var$0
     (i32.and
      (get_local $var$0)
      (i32.sub
       (get_local $var$0)
       (i32.const 1)
      )
     )
    )
    (set_local $var$1
     (i32.add
      (get_local $var$1)
      (i32.const 1)
     )
    )
    (br $label$2)
   )
  )
 )
 ;; lowering of the i64.popcnt instruction, counts the number of bits set in the
 ;; input and returns the result
 (func $__wasm_popcnt_i64 (param $var$0 i64) (result i64)
  (local $var$1 i64)
  (block $label$1 (result i64)
   (loop $label$2
    (drop
     (br_if $label$1
      (get_local $var$1)
      (i64.eqz
       (get_local $var$0)
      )
     )
    )
    (set_local $var$0
     (i64.and
      (get_local $var$0)
      (i64.sub
       (get_local $var$0)
       (i64.const 1)
      )
     )
    )
    (set_local $var$1
     (i64.add
      (get_local $var$1)
      (i64.const 1)
     )
    )
    (br $label$2)
   )
  )
 )
 ;; lowering of the i64.div_s instruction, return $var0 / $var$1
 (func $__wasm_i64_sdiv (; 0 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (call $_ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E
   (get_local $var$0)
   (get_local $var$1)
  )
 )
 ;; lowering of the i64.div_u instruction, return $var0 / $var$1
 (func $__wasm_i64_udiv (; 1 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (call $_ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E
   (get_local $var$0)
   (get_local $var$1)
  )
 )
 ;; lowering of the i64.rem_s instruction, return $var0 % $var$1
 (func $__wasm_i64_srem (; 2 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (call $_ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E
   (get_local $var$0)
   (get_local $var$1)
  )
 )
 ;; lowering of the i64.rem_u instruction, return $var0 % $var$1
 (func $__wasm_i64_urem (; 3 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (drop
   (call $_ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E
    (get_local $var$0)
    (get_local $var$1)
   )
  )
  (i64.load
   (i32.const 1024)
  )
 )
 ;; lowering of the i64.mul instruction, return $var0 * $var$1
 (func $__wasm_i64_mul (; 4 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (call $_ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE
   (get_local $var$0)
   (get_local $var$1)
  )
 )
 ;; lowering of the f32.trunc instruction, rounds to the nearest integer,
 ;; towards zero
 (func $__wasm_trunc_f32 (; 5 ;) (type $1) (param $var$0 f32) (result f32)
  (select
   (f32.ceil
    (get_local $var$0)
   )
   (f32.floor
    (get_local $var$0)
   )
   (f32.lt
    (get_local $var$0)
    (f32.const 0)
   )
  )
 )
 ;; lowering of the f64.trunc instruction, rounds to the nearest integer,
 ;; towards zero
 (func $__wasm_trunc_f64 (; 6 ;) (type $2) (param $var$0 f64) (result f64)
  (select
   (f64.ceil
    (get_local $var$0)
   )
   (f64.floor
    (get_local $var$0)
   )
   (f64.lt
    (get_local $var$0)
    (f64.const 0)
   )
  )
 )
 ;; lowering of the i32.ctz instruction, counting the number of zeros in $var$0
 (func $__wasm_ctz_i32 (; 7 ;) (type $3) (param $var$0 i32) (result i32)
  (if
   (get_local $var$0)
   (return
    (i32.sub
     (i32.const 31)
     (i32.clz
      (i32.xor
       (i32.add
        (get_local $var$0)
        (i32.const -1)
       )
       (get_local $var$0)
      )
     )
    )
   )
  )
  (i32.const 32)
 )
 ;; lowering of the i64.ctz instruction, counting the number of zeros in $var$0
 (func $__wasm_ctz_i64 (; 8 ;) (type $4) (param $var$0 i64) (result i64)
  (if
   (i32.eqz
    (i64.eqz
     (get_local $var$0)
    )
   )
   (return
    (i64.sub
     (i64.const 63)
     (i64.clz
      (i64.xor
       (i64.add
        (get_local $var$0)
        (i64.const -1)
       )
       (get_local $var$0)
      )
     )
    )
   )
  )
  (i64.const 64)
 )
 ;; lowering of the i32.rotl instruction, rotating the first argument, with
 ;; wraparound, by the second argument
 (func $__wasm_rotl_i32 (; 8 ;) (type $4) (param $var$0 i32) (param $var$1 i32) (result i32)
  (local $var$2 i32)
  (i32.or
   (i32.shl
    (i32.and
     (i32.shr_u
      (i32.const -1)
      (tee_local $var$2
       (i32.and
        (get_local $var$1)
        (i32.const 31)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$2)
   )
   (i32.shr_u
    (i32.and
     (i32.shl
      (i32.const -1)
      (tee_local $var$1
       (i32.and
        (i32.sub
         (i32.const 0)
         (get_local $var$1)
        )
        (i32.const 31)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$1)
   )
  )
 )
 ;; lowering of the i32.rotr instruction, rotating the first argument, with
 ;; wraparound, by the second argument
 (func $__wasm_rotr_i32 (; 9 ;) (type $4) (param $var$0 i32) (param $var$1 i32) (result i32)
  (local $var$2 i32)
  (i32.or
   (i32.shr_u
    (i32.and
     (i32.shl
      (i32.const -1)
      (tee_local $var$2
       (i32.and
        (get_local $var$1)
        (i32.const 31)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$2)
   )
   (i32.shl
    (i32.and
     (i32.shr_u
      (i32.const -1)
      (tee_local $var$1
       (i32.and
        (i32.sub
         (i32.const 0)
         (get_local $var$1)
        )
        (i32.const 31)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$1)
   )
  )
 )
 ;; lowering of the i64.rotl instruction, rotating the first argument, with
 ;; wraparound, by the second argument
 (func $__wasm_rotl_i64 (; 10 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (local $var$2 i64)
  (i64.or
   (i64.shl
    (i64.and
     (i64.shr_u
      (i64.const -1)
      (tee_local $var$2
       (i64.and
        (get_local $var$1)
        (i64.const 63)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$2)
   )
   (i64.shr_u
    (i64.and
     (i64.shl
      (i64.const -1)
      (tee_local $var$1
       (i64.and
        (i64.sub
         (i64.const 0)
         (get_local $var$1)
        )
        (i64.const 63)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$1)
   )
  )
 )
 ;; lowering of the i64.rotr instruction, rotating the first argument, with
 ;; wraparound, by the second argument
 (func $__wasm_rotr_i64 (; 11 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (local $var$2 i64)
  (i64.or
   (i64.shr_u
    (i64.and
     (i64.shl
      (i64.const -1)
      (tee_local $var$2
       (i64.and
        (get_local $var$1)
        (i64.const 63)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$2)
   )
   (i64.shl
    (i64.and
     (i64.shr_u
      (i64.const -1)
      (tee_local $var$1
       (i64.and
        (i64.sub
         (i64.const 0)
         (get_local $var$1)
        )
        (i64.const 63)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$1)
   )
  )
 )
 ;; lowering of the f32.nearest instruction, rounding the input to the nearest
 ;; integer while breaking ties by rounding to even
 (func $__wasm_nearest_f32 (; 12 ;) (type $1) (param $var$0 f32) (result f32)
  (local $var$1 f32)
  (local $var$2 f32)
  (if
   (i32.eqz
    (f32.lt
     (tee_local $var$2
      (f32.sub
       (get_local $var$0)
       (tee_local $var$1
        (f32.floor
         (get_local $var$0)
        )
       )
      )
     )
     (f32.const 0.5)
    )
   )
   (block
    (set_local $var$0
     (f32.ceil
      (get_local $var$0)
     )
    )
    (if
     (f32.gt
      (get_local $var$2)
      (f32.const 0.5)
     )
     (return
      (get_local $var$0)
     )
    )
    (set_local $var$1
     (select
      (get_local $var$1)
      (get_local $var$0)
      (f32.eq
       (f32.sub
        (tee_local $var$2
         (f32.mul
          (get_local $var$1)
          (f32.const 0.5)
         )
        )
        (f32.floor
         (get_local $var$2)
        )
       )
       (f32.const 0)
      )
     )
    )
   )
  )
  (get_local $var$1)
 )
 ;; lowering of the f64.nearest instruction, rounding the input to the nearest
 ;; integer while breaking ties by rounding to even
 (func $__wasm_nearest_f64 (; 13 ;) (type $2) (param $var$0 f64) (result f64)
  (local $var$1 f64)
  (local $var$2 f64)
  (if
   (i32.eqz
    (f64.lt
     (tee_local $var$2
      (f64.sub
       (get_local $var$0)
       (tee_local $var$1
        (f64.floor
         (get_local $var$0)
        )
       )
      )
     )
     (f64.const 0.5)
    )
   )
   (block
    (set_local $var$0
     (f64.ceil
      (get_local $var$0)
     )
    )
    (if
     (f64.gt
      (get_local $var$2)
      (f64.const 0.5)
     )
     (return
      (get_local $var$0)
     )
    )
    (set_local $var$1
     (select
      (get_local $var$1)
      (get_local $var$0)
      (f64.eq
       (f64.sub
        (tee_local $var$2
         (f64.mul
          (get_local $var$1)
          (f64.const 0.5)
         )
        )
        (f64.floor
         (get_local $var$2)
        )
       )
       (f64.const 0)
      )
     )
    )
   )
  )
  (get_local $var$1)
 )
 (func $_ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E (; 14 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (local $var$2 i32)
  (local $var$3 i32)
  (local $var$4 i32)
  (local $var$5 i64)
  (local $var$6 i64)
  (local $var$7 i64)
  (local $var$8 i64)
  (block $label$1
   (block $label$2
    (block $label$3
     (block $label$4
      (block $label$5
       (block $label$6
        (block $label$7
         (block $label$8
          (block $label$9
           (block $label$10
            (block $label$11
             (if
              (tee_local $var$2
               (i32.wrap/i64
                (i64.shr_u
                 (get_local $var$0)
                 (i64.const 32)
                )
               )
              )
              (block
               (br_if $label$11
                (i32.eqz
                 (tee_local $var$3
                  (i32.wrap/i64
                   (get_local $var$1)
                  )
                 )
                )
               )
               (br_if $label$9
                (i32.eqz
                 (tee_local $var$4
                  (i32.wrap/i64
                   (i64.shr_u
                    (get_local $var$1)
                    (i64.const 32)
                   )
                  )
                 )
                )
               )
               (br_if $label$8
                (i32.le_u
                 (tee_local $var$2
                  (i32.sub
                   (i32.clz
                    (get_local $var$4)
                   )
                   (i32.clz
                    (get_local $var$2)
                   )
                  )
                 )
                 (i32.const 31)
                )
               )
               (br $label$2)
              )
             )
             (br_if $label$2
              (i64.ge_u
               (get_local $var$1)
               (i64.const 4294967296)
              )
             )
             (i64.store
              (i32.const 1024)
              (i64.extend_u/i32
               (i32.sub
                (tee_local $var$2
                 (i32.wrap/i64
                  (get_local $var$0)
                 )
                )
                (i32.mul
                 (tee_local $var$2
                  (i32.div_u
                   (get_local $var$2)
                   (tee_local $var$3
                    (i32.wrap/i64
                     (get_local $var$1)
                    )
                   )
                  )
                 )
                 (get_local $var$3)
                )
               )
              )
             )
             (return
              (i64.extend_u/i32
               (get_local $var$2)
              )
             )
            )
            (set_local $var$3
             (i32.wrap/i64
              (i64.shr_u
               (get_local $var$1)
               (i64.const 32)
              )
             )
            )
            (br_if $label$7
             (i32.eqz
              (i32.wrap/i64
               (get_local $var$0)
              )
             )
            )
            (br_if $label$6
             (i32.eqz
              (get_local $var$3)
             )
            )
            (br_if $label$6
             (i32.and
              (tee_local $var$4
               (i32.add
                (get_local $var$3)
                (i32.const -1)
               )
              )
              (get_local $var$3)
             )
            )
            (i64.store
             (i32.const 1024)
             (i64.or
              (i64.shl
               (i64.extend_u/i32
                (i32.and
                 (get_local $var$4)
                 (get_local $var$2)
                )
               )
               (i64.const 32)
              )
              (i64.and
               (get_local $var$0)
               (i64.const 4294967295)
              )
             )
            )
            (return
             (i64.extend_u/i32
              (i32.shr_u
               (get_local $var$2)
               (i32.and
                (i32.ctz
                 (get_local $var$3)
                )
                (i32.const 31)
               )
              )
             )
            )
           )
           (unreachable)
          )
          (br_if $label$5
           (i32.eqz
            (i32.and
             (tee_local $var$4
              (i32.add
               (get_local $var$3)
               (i32.const -1)
              )
             )
             (get_local $var$3)
            )
           )
          )
          (set_local $var$3
           (i32.sub
            (i32.const 0)
            (tee_local $var$2
             (i32.sub
              (i32.add
               (i32.clz
                (get_local $var$3)
               )
               (i32.const 33)
              )
              (i32.clz
               (get_local $var$2)
              )
             )
            )
           )
          )
          (br $label$3)
         )
         (set_local $var$3
          (i32.sub
           (i32.const 63)
           (get_local $var$2)
          )
         )
         (set_local $var$2
          (i32.add
           (get_local $var$2)
           (i32.const 1)
          )
         )
         (br $label$3)
        )
        (i64.store
         (i32.const 1024)
         (i64.shl
          (i64.extend_u/i32
           (i32.sub
            (get_local $var$2)
            (i32.mul
             (tee_local $var$4
              (i32.div_u
               (get_local $var$2)
               (get_local $var$3)
              )
             )
             (get_local $var$3)
            )
           )
          )
          (i64.const 32)
         )
        )
        (return
         (i64.extend_u/i32
          (get_local $var$4)
         )
        )
       )
       (br_if $label$4
        (i32.lt_u
         (tee_local $var$2
          (i32.sub
           (i32.clz
            (get_local $var$3)
           )
           (i32.clz
            (get_local $var$2)
           )
          )
         )
         (i32.const 31)
        )
       )
       (br $label$2)
      )
      (i64.store
       (i32.const 1024)
       (i64.extend_u/i32
        (i32.and
         (get_local $var$4)
         (i32.wrap/i64
          (get_local $var$0)
         )
        )
       )
      )
      (br_if $label$1
       (i32.eq
        (get_local $var$3)
        (i32.const 1)
       )
      )
      (return
       (i64.shr_u
        (get_local $var$0)
        (i64.extend_u/i32
         (i32.ctz
          (get_local $var$3)
         )
        )
       )
      )
     )
     (set_local $var$3
      (i32.sub
       (i32.const 63)
       (get_local $var$2)
      )
     )
     (set_local $var$2
      (i32.add
       (get_local $var$2)
       (i32.const 1)
      )
     )
    )
    (set_local $var$5
     (i64.shr_u
      (get_local $var$0)
      (i64.extend_u/i32
       (i32.and
        (get_local $var$2)
        (i32.const 63)
       )
      )
     )
    )
    (set_local $var$0
     (i64.shl
      (get_local $var$0)
      (i64.extend_u/i32
       (i32.and
        (get_local $var$3)
        (i32.const 63)
       )
      )
     )
    )
    (block $label$13
     (if
      (get_local $var$2)
      (block
       (set_local $var$8
        (i64.add
         (get_local $var$1)
         (i64.const -1)
        )
       )
       (loop $label$15
        (set_local $var$5
         (i64.sub
          (tee_local $var$5
           (i64.or
            (i64.shl
             (get_local $var$5)
             (i64.const 1)
            )
            (i64.shr_u
             (get_local $var$0)
             (i64.const 63)
            )
           )
          )
          (i64.and
           (tee_local $var$6
            (i64.shr_s
             (i64.sub
              (get_local $var$8)
              (get_local $var$5)
             )
             (i64.const 63)
            )
           )
           (get_local $var$1)
          )
         )
        )
        (set_local $var$0
         (i64.or
          (i64.shl
           (get_local $var$0)
           (i64.const 1)
          )
          (get_local $var$7)
         )
        )
        (set_local $var$7
         (tee_local $var$6
          (i64.and
           (get_local $var$6)
           (i64.const 1)
          )
         )
        )
        (br_if $label$15
         (tee_local $var$2
          (i32.add
           (get_local $var$2)
           (i32.const -1)
          )
         )
        )
       )
       (br $label$13)
      )
     )
    )
    (i64.store
     (i32.const 1024)
     (get_local $var$5)
    )
    (return
     (i64.or
      (i64.shl
       (get_local $var$0)
       (i64.const 1)
      )
      (get_local $var$6)
     )
    )
   )
   (i64.store
    (i32.const 1024)
    (get_local $var$0)
   )
   (set_local $var$0
    (i64.const 0)
   )
  )
  (get_local $var$0)
 )
 (func $_ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE (; 15 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (local $var$2 i32)
  (local $var$3 i32)
  (local $var$4 i32)
  (local $var$5 i32)
  (local $var$6 i32)
  (i64.or
   (i64.shl
    (i64.extend_u/i32
     (i32.add
      (i32.add
       (i32.add
        (i32.add
         (i32.mul
          (tee_local $var$4
           (i32.shr_u
            (tee_local $var$2
             (i32.wrap/i64
              (get_local $var$1)
             )
            )
            (i32.const 16)
           )
          )
          (tee_local $var$5
           (i32.shr_u
            (tee_local $var$3
             (i32.wrap/i64
              (get_local $var$0)
             )
            )
            (i32.const 16)
           )
          )
         )
         (i32.mul
          (get_local $var$2)
          (i32.wrap/i64
           (i64.shr_u
            (get_local $var$0)
            (i64.const 32)
           )
          )
         )
        )
        (i32.mul
         (i32.wrap/i64
          (i64.shr_u
           (get_local $var$1)
           (i64.const 32)
          )
         )
         (get_local $var$3)
        )
       )
       (i32.shr_u
        (tee_local $var$2
         (i32.add
          (i32.shr_u
           (tee_local $var$6
            (i32.mul
             (tee_local $var$2
              (i32.and
               (get_local $var$2)
               (i32.const 65535)
              )
             )
             (tee_local $var$3
              (i32.and
               (get_local $var$3)
               (i32.const 65535)
              )
             )
            )
           )
           (i32.const 16)
          )
          (i32.mul
           (get_local $var$2)
           (get_local $var$5)
          )
         )
        )
        (i32.const 16)
       )
      )
      (i32.shr_u
       (tee_local $var$2
        (i32.add
         (i32.and
          (get_local $var$2)
          (i32.const 65535)
         )
         (i32.mul
          (get_local $var$4)
          (get_local $var$3)
         )
        )
       )
       (i32.const 16)
      )
     )
    )
    (i64.const 32)
   )
   (i64.extend_u/i32
    (i32.or
     (i32.shl
      (get_local $var$2)
      (i32.const 16)
     )
     (i32.and
      (get_local $var$6)
      (i32.const 65535)
     )
    )
   )
  )
 )
 (func $_ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E (; 16 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (local $var$2 i64)
  (i64.sub
   (i64.xor
    (i64.div_u
     (i64.sub
      (i64.xor
       (tee_local $var$2
        (i64.shr_s
         (get_local $var$0)
         (i64.const 63)
        )
       )
       (get_local $var$0)
      )
      (get_local $var$2)
     )
     (i64.sub
      (i64.xor
       (tee_local $var$2
        (i64.shr_s
         (get_local $var$1)
         (i64.const 63)
        )
       )
       (get_local $var$1)
      )
      (get_local $var$2)
     )
    )
    (tee_local $var$0
     (i64.shr_s
      (i64.xor
       (get_local $var$1)
       (get_local $var$0)
      )
      (i64.const 63)
     )
    )
   )
   (get_local $var$0)
  )
 )
 (func $_ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E (; 17 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (local $var$2 i64)
  (i64.sub
   (i64.xor
    (i64.rem_u
     (i64.sub
      (i64.xor
       (tee_local $var$2
        (i64.shr_s
         (get_local $var$0)
         (i64.const 63)
        )
       )
       (get_local $var$0)
      )
      (get_local $var$2)
     )
     (i64.sub
      (i64.xor
       (tee_local $var$0
        (i64.shr_s
         (get_local $var$1)
         (i64.const 63)
        )
       )
       (get_local $var$1)
      )
      (get_local $var$0)
     )
    )
    (get_local $var$2)
   )
   (get_local $var$2)
  )
 )
 ;; custom section "linking", size 3
)
