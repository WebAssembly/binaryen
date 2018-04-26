(module
 (type $FUNCSIG$vijji (func (param i32 i64 i64 i32)))
 (import "env" "__ashlti3" (func $__ashlti3 (param i32 i64 i64 i32)))
 (import "env" "__lshrti3" (func $__lshrti3 (param i32 i64 i64 i32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "shl_i3" (func $shl_i3))
 (export "shl_i53" (func $shl_i53))
 (export "sext_in_reg_i32_i64" (func $sext_in_reg_i32_i64))
 (export "fpext_f32_f64" (func $fpext_f32_f64))
 (export "fpconv_f64_f32" (func $fpconv_f64_f32))
 (export "bigshift" (func $bigshift))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $shl_i3 (; 2 ;) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (return
   (i32.shl
    (get_local $0)
    (i32.and
     (get_local $1)
     (i32.const 7)
    )
   )
  )
 )
 (func $shl_i53 (; 3 ;) (param $0 i64) (param $1 i64) (param $2 i32) (result i64)
  (return
   (i64.shl
    (get_local $0)
    (i64.and
     (get_local $1)
     (i64.const 9007199254740991)
    )
   )
  )
 )
 (func $sext_in_reg_i32_i64 (; 4 ;) (param $0 i64) (result i64)
  (return
   (i64.shr_s
    (i64.shl
     (get_local $0)
     (i64.const 32)
    )
    (i64.const 32)
   )
  )
 )
 (func $fpext_f32_f64 (; 5 ;) (param $0 i32) (result f64)
  (return
   (f64.promote/f32
    (f32.load
     (get_local $0)
    )
   )
  )
 )
 (func $fpconv_f64_f32 (; 6 ;) (param $0 i32) (result f32)
  (return
   (f32.demote/f64
    (f64.load
     (get_local $0)
    )
   )
  )
 )
 (func $bigshift (; 7 ;) (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64) (param $5 i64) (param $6 i64) (param $7 i64) (param $8 i64) (param $9 i64) (param $10 i64) (param $11 i64) (param $12 i64) (param $13 i64) (param $14 i64) (param $15 i64) (param $16 i64) (param $17 i64) (param $18 i64) (param $19 i64) (param $20 i64) (param $21 i64) (param $22 i64) (param $23 i64) (param $24 i64) (param $25 i64) (param $26 i64) (param $27 i64) (param $28 i64) (param $29 i64) (param $30 i64) (param $31 i64) (param $32 i64)
  (local $33 i32)
  (local $34 i32)
  (local $35 i32)
  (local $36 i32)
  (local $37 i32)
  (local $38 i32)
  (local $39 i32)
  (local $40 i32)
  (local $41 i32)
  (local $42 i32)
  (local $43 i32)
  (local $44 i32)
  (local $45 i32)
  (local $46 i32)
  (local $47 i32)
  (local $48 i32)
  (local $49 i32)
  (local $50 i32)
  (local $51 i32)
  (local $52 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $52
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 1024)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 512)
   )
   (get_local $1)
   (get_local $2)
   (tee_local $33
    (i32.wrap/i64
     (get_local $17)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 528)
   )
   (get_local $3)
   (get_local $4)
   (get_local $33)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 544)
   )
   (get_local $1)
   (get_local $2)
   (tee_local $41
    (i32.sub
     (i32.const 128)
     (get_local $33)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 560)
   )
   (get_local $1)
   (get_local $2)
   (tee_local $42
    (i32.add
     (get_local $33)
     (i32.const -128)
    )
   )
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 736)
   )
   (get_local $1)
   (get_local $2)
   (tee_local $43
    (i32.sub
     (i32.const 384)
     (get_local $33)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 720)
   )
   (get_local $3)
   (get_local $4)
   (tee_local $34
    (i32.add
     (get_local $33)
     (i32.const -256)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 752)
   )
   (get_local $1)
   (get_local $2)
   (tee_local $39
    (i32.add
     (get_local $33)
     (i32.const -384)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 592)
   )
   (get_local $7)
   (get_local $8)
   (get_local $33)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 608)
   )
   (get_local $5)
   (get_local $6)
   (get_local $41)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 624)
   )
   (get_local $5)
   (get_local $6)
   (get_local $42)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 688)
   )
   (get_local $3)
   (get_local $4)
   (tee_local $35
    (i32.sub
     (i32.const 256)
     (get_local $33)
    )
   )
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 640)
   )
   (get_local $1)
   (get_local $2)
   (get_local $35)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 656)
   )
   (get_local $3)
   (get_local $4)
   (tee_local $50
    (i32.sub
     (i32.const 128)
     (get_local $35)
    )
   )
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 672)
   )
   (get_local $3)
   (get_local $4)
   (get_local $41)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 576)
   )
   (get_local $5)
   (get_local $6)
   (get_local $33)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 704)
   )
   (get_local $1)
   (get_local $2)
   (get_local $34)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 480)
   )
   (get_local $1)
   (get_local $2)
   (i32.sub
    (i32.const 896)
    (get_local $33)
   )
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 464)
   )
   (get_local $3)
   (get_local $4)
   (tee_local $36
    (i32.add
     (get_local $33)
     (i32.const -768)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 496)
   )
   (get_local $1)
   (get_local $2)
   (i32.add
    (get_local $33)
    (i32.const -896)
   )
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 352)
   )
   (get_local $5)
   (get_local $6)
   (tee_local $45
    (i32.sub
     (i32.const 640)
     (get_local $33)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 336)
   )
   (get_local $7)
   (get_local $8)
   (tee_local $37
    (i32.add
     (get_local $33)
     (i32.const -512)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 368)
   )
   (get_local $5)
   (get_local $6)
   (tee_local $51
    (i32.add
     (get_local $33)
     (i32.const -640)
    )
   )
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 432)
   )
   (get_local $3)
   (get_local $4)
   (tee_local $38
    (i32.sub
     (i32.const 768)
     (get_local $33)
    )
   )
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 864)
   )
   (get_local $9)
   (get_local $10)
   (get_local $43)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 848)
   )
   (get_local $11)
   (get_local $12)
   (get_local $34)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 880)
   )
   (get_local $9)
   (get_local $10)
   (get_local $39)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 1008)
   )
   (get_local $15)
   (get_local $16)
   (get_local $33)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 960)
   )
   (get_local $13)
   (get_local $14)
   (get_local $41)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 976)
   )
   (get_local $13)
   (get_local $14)
   (get_local $42)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 816)
   )
   (get_local $11)
   (get_local $12)
   (get_local $35)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 240)
   )
   (get_local $7)
   (get_local $8)
   (tee_local $39
    (i32.sub
     (i32.const 512)
     (get_local $33)
    )
   )
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 192)
   )
   (get_local $5)
   (get_local $6)
   (get_local $39)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 208)
   )
   (get_local $7)
   (get_local $8)
   (tee_local $44
    (i32.sub
     (i32.const 128)
     (get_local $39)
    )
   )
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 224)
   )
   (get_local $7)
   (get_local $8)
   (get_local $43)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 768)
   )
   (get_local $9)
   (get_local $10)
   (get_local $35)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 784)
   )
   (get_local $11)
   (get_local $12)
   (get_local $50)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 800)
   )
   (get_local $11)
   (get_local $12)
   (get_local $41)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 992)
   )
   (get_local $13)
   (get_local $14)
   (get_local $33)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 832)
   )
   (get_local $9)
   (get_local $10)
   (get_local $34)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 384)
   )
   (get_local $1)
   (get_local $2)
   (get_local $38)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 400)
   )
   (get_local $3)
   (get_local $4)
   (i32.sub
    (i32.const 128)
    (get_local $38)
   )
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 416)
   )
   (get_local $3)
   (get_local $4)
   (get_local $45)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 320)
   )
   (get_local $5)
   (get_local $6)
   (get_local $37)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 448)
   )
   (get_local $1)
   (get_local $2)
   (get_local $36)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 128)
   )
   (get_local $5)
   (get_local $6)
   (get_local $35)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 144)
   )
   (get_local $7)
   (get_local $8)
   (i32.sub
    (i32.const 384)
    (get_local $39)
   )
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 160)
   )
   (get_local $7)
   (get_local $8)
   (get_local $41)
  )
  (call $__lshrti3
   (get_local $52)
   (get_local $1)
   (get_local $2)
   (get_local $39)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 16)
   )
   (get_local $3)
   (get_local $4)
   (get_local $44)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 32)
   )
   (get_local $3)
   (get_local $4)
   (get_local $43)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 64)
   )
   (get_local $5)
   (get_local $6)
   (tee_local $40
    (i32.sub
     (i32.const 256)
     (get_local $39)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 896)
   )
   (get_local $9)
   (get_local $10)
   (get_local $33)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 256)
   )
   (get_local $1)
   (get_local $2)
   (get_local $37)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 912)
   )
   (get_local $11)
   (get_local $12)
   (get_local $33)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 928)
   )
   (get_local $9)
   (get_local $10)
   (get_local $41)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 944)
   )
   (get_local $9)
   (get_local $10)
   (get_local $42)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 80)
   )
   (get_local $7)
   (get_local $8)
   (get_local $40)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 96)
   )
   (get_local $5)
   (get_local $6)
   (i32.sub
    (i32.const 128)
    (get_local $40)
   )
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 112)
   )
   (get_local $5)
   (get_local $6)
   (get_local $44)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 48)
   )
   (get_local $3)
   (get_local $4)
   (get_local $39)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 176)
   )
   (get_local $7)
   (get_local $8)
   (get_local $35)
  )
  (call $__lshrti3
   (i32.add
    (get_local $52)
    (i32.const 288)
   )
   (get_local $1)
   (get_local $2)
   (get_local $45)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 272)
   )
   (get_local $3)
   (get_local $4)
   (get_local $37)
  )
  (call $__ashlti3
   (i32.add
    (get_local $52)
    (i32.const 304)
   )
   (get_local $1)
   (get_local $2)
   (get_local $51)
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 8)
   )
   (select
    (select
     (select
      (i64.load
       (i32.add
        (i32.add
         (get_local $52)
         (i32.const 512)
        )
        (i32.const 8)
       )
      )
      (i64.const 0)
      (tee_local $41
       (i32.lt_u
        (get_local $33)
        (i32.const 128)
       )
      )
     )
     (i64.const 0)
     (tee_local $42
      (i32.lt_u
       (get_local $33)
       (i32.const 256)
      )
     )
    )
    (i64.const 0)
    (tee_local $43
     (i32.lt_u
      (get_local $33)
      (i32.const 512)
     )
    )
   )
  )
  (i64.store
   (get_local $0)
   (select
    (select
     (select
      (i64.load offset=512
       (get_local $52)
      )
      (i64.const 0)
      (get_local $41)
     )
     (i64.const 0)
     (get_local $42)
    )
    (i64.const 0)
    (get_local $43)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 24)
   )
   (select
    (select
     (select
      (select
       (i64.or
        (i64.load
         (i32.add
          (i32.add
           (get_local $52)
           (i32.const 528)
          )
          (i32.const 8)
         )
        )
        (i64.load
         (i32.add
          (i32.add
           (get_local $52)
           (i32.const 544)
          )
          (i32.const 8)
         )
        )
       )
       (i64.load
        (i32.add
         (i32.add
          (get_local $52)
          (i32.const 560)
         )
         (i32.const 8)
        )
       )
       (get_local $41)
      )
      (get_local $4)
      (get_local $33)
     )
     (i64.const 0)
     (get_local $42)
    )
    (i64.const 0)
    (get_local $43)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 16)
   )
   (select
    (select
     (select
      (select
       (i64.or
        (i64.load offset=528
         (get_local $52)
        )
        (i64.load offset=544
         (get_local $52)
        )
       )
       (i64.load offset=560
        (get_local $52)
       )
       (get_local $41)
      )
      (get_local $3)
      (get_local $33)
     )
     (i64.const 0)
     (get_local $42)
    )
    (i64.const 0)
    (get_local $43)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 56)
   )
   (select
    (select
     (select
      (i64.or
       (select
        (select
         (i64.or
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 592)
            )
            (i32.const 8)
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 608)
            )
            (i32.const 8)
           )
          )
         )
         (i64.load
          (i32.add
           (i32.add
            (get_local $52)
            (i32.const 624)
           )
           (i32.const 8)
          )
         )
         (get_local $41)
        )
        (get_local $8)
        (get_local $33)
       )
       (select
        (i64.load
         (i32.add
          (i32.add
           (get_local $52)
           (i32.const 688)
          )
          (i32.const 8)
         )
        )
        (i64.const 0)
        (tee_local $45
         (i32.lt_u
          (get_local $35)
          (i32.const 128)
         )
        )
       )
      )
      (select
       (select
        (i64.or
         (i64.load
          (i32.add
           (i32.add
            (get_local $52)
            (i32.const 720)
           )
           (i32.const 8)
          )
         )
         (i64.load
          (i32.add
           (i32.add
            (get_local $52)
            (i32.const 736)
           )
           (i32.const 8)
          )
         )
        )
        (i64.load
         (i32.add
          (i32.add
           (get_local $52)
           (i32.const 752)
          )
          (i32.const 8)
         )
        )
        (tee_local $44
         (i32.lt_u
          (get_local $34)
          (i32.const 128)
         )
        )
       )
       (get_local $4)
       (get_local $34)
      )
      (get_local $42)
     )
     (get_local $8)
     (get_local $33)
    )
    (i64.const 0)
    (get_local $43)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 48)
   )
   (select
    (select
     (select
      (i64.or
       (select
        (select
         (i64.or
          (i64.load offset=592
           (get_local $52)
          )
          (i64.load offset=608
           (get_local $52)
          )
         )
         (i64.load offset=624
          (get_local $52)
         )
         (get_local $41)
        )
        (get_local $7)
        (get_local $33)
       )
       (select
        (i64.load offset=688
         (get_local $52)
        )
        (i64.const 0)
        (get_local $45)
       )
      )
      (select
       (select
        (i64.or
         (i64.load offset=720
          (get_local $52)
         )
         (i64.load offset=736
          (get_local $52)
         )
        )
        (i64.load offset=752
         (get_local $52)
        )
        (get_local $44)
       )
       (get_local $3)
       (get_local $34)
      )
      (get_local $42)
     )
     (get_local $7)
     (get_local $33)
    )
    (i64.const 0)
    (get_local $43)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 40)
   )
   (select
    (select
     (select
      (i64.or
       (select
        (i64.load
         (i32.add
          (i32.add
           (get_local $52)
           (i32.const 576)
          )
          (i32.const 8)
         )
        )
        (i64.const 0)
        (get_local $41)
       )
       (select
        (select
         (i64.or
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 640)
            )
            (i32.const 8)
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 656)
            )
            (i32.const 8)
           )
          )
         )
         (i64.load
          (i32.add
           (i32.add
            (get_local $52)
            (i32.const 672)
           )
           (i32.const 8)
          )
         )
         (get_local $45)
        )
        (get_local $2)
        (get_local $35)
       )
      )
      (select
       (i64.load
        (i32.add
         (i32.add
          (get_local $52)
          (i32.const 704)
         )
         (i32.const 8)
        )
       )
       (i64.const 0)
       (get_local $44)
      )
      (get_local $42)
     )
     (get_local $6)
     (get_local $33)
    )
    (i64.const 0)
    (get_local $43)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 32)
   )
   (select
    (select
     (select
      (i64.or
       (select
        (i64.load offset=576
         (get_local $52)
        )
        (i64.const 0)
        (get_local $41)
       )
       (select
        (select
         (i64.or
          (i64.load offset=640
           (get_local $52)
          )
          (i64.load offset=656
           (get_local $52)
          )
         )
         (i64.load offset=672
          (get_local $52)
         )
         (get_local $45)
        )
        (get_local $1)
        (get_local $35)
       )
      )
      (select
       (i64.load offset=704
        (get_local $52)
       )
       (i64.const 0)
       (get_local $44)
      )
      (get_local $42)
     )
     (get_local $5)
     (get_local $33)
    )
    (i64.const 0)
    (get_local $43)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 120)
   )
   (select
    (select
     (i64.or
      (select
       (select
        (i64.or
         (select
          (select
           (i64.or
            (i64.load
             (i32.add
              (i32.add
               (get_local $52)
               (i32.const 1008)
              )
              (i32.const 8)
             )
            )
            (i64.load
             (i32.add
              (i32.add
               (get_local $52)
               (i32.const 960)
              )
              (i32.const 8)
             )
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (get_local $52)
              (i32.const 976)
             )
             (i32.const 8)
            )
           )
           (get_local $41)
          )
          (get_local $16)
          (get_local $33)
         )
         (select
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 816)
            )
            (i32.const 8)
           )
          )
          (i64.const 0)
          (get_local $45)
         )
        )
        (select
         (select
          (i64.or
           (i64.load
            (i32.add
             (i32.add
              (get_local $52)
              (i32.const 848)
             )
             (i32.const 8)
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (get_local $52)
              (i32.const 864)
             )
             (i32.const 8)
            )
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 880)
            )
            (i32.const 8)
           )
          )
          (get_local $44)
         )
         (get_local $12)
         (get_local $34)
        )
        (get_local $42)
       )
       (get_local $16)
       (get_local $33)
      )
      (select
       (select
        (i64.load
         (i32.add
          (i32.add
           (get_local $52)
           (i32.const 240)
          )
          (i32.const 8)
         )
        )
        (i64.const 0)
        (tee_local $50
         (i32.lt_u
          (get_local $39)
          (i32.const 128)
         )
        )
       )
       (i64.const 0)
       (tee_local $51
        (i32.lt_u
         (get_local $39)
         (i32.const 256)
        )
       )
      )
     )
     (select
      (select
       (i64.or
        (select
         (select
          (i64.or
           (i64.load
            (i32.add
             (i32.add
              (get_local $52)
              (i32.const 336)
             )
             (i32.const 8)
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (get_local $52)
              (i32.const 352)
             )
             (i32.const 8)
            )
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 368)
            )
            (i32.const 8)
           )
          )
          (tee_local $47
           (i32.lt_u
            (get_local $37)
            (i32.const 128)
           )
          )
         )
         (get_local $8)
         (get_local $37)
        )
        (select
         (i64.load
          (i32.add
           (i32.add
            (get_local $52)
            (i32.const 432)
           )
           (i32.const 8)
          )
         )
         (i64.const 0)
         (tee_local $48
          (i32.lt_u
           (get_local $38)
           (i32.const 128)
          )
         )
        )
       )
       (select
        (select
         (i64.or
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 464)
            )
            (i32.const 8)
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 480)
            )
            (i32.const 8)
           )
          )
         )
         (i64.load
          (i32.add
           (i32.add
            (get_local $52)
            (i32.const 496)
           )
           (i32.const 8)
          )
         )
         (tee_local $46
          (i32.lt_u
           (get_local $36)
           (i32.const 128)
          )
         )
        )
        (get_local $4)
        (get_local $36)
       )
       (tee_local $49
        (i32.lt_u
         (get_local $37)
         (i32.const 256)
        )
       )
      )
      (get_local $8)
      (get_local $37)
     )
     (get_local $43)
    )
    (get_local $16)
    (get_local $33)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 112)
   )
   (select
    (select
     (i64.or
      (select
       (select
        (i64.or
         (select
          (select
           (i64.or
            (i64.load offset=1008
             (get_local $52)
            )
            (i64.load offset=960
             (get_local $52)
            )
           )
           (i64.load offset=976
            (get_local $52)
           )
           (get_local $41)
          )
          (get_local $15)
          (get_local $33)
         )
         (select
          (i64.load offset=816
           (get_local $52)
          )
          (i64.const 0)
          (get_local $45)
         )
        )
        (select
         (select
          (i64.or
           (i64.load offset=848
            (get_local $52)
           )
           (i64.load offset=864
            (get_local $52)
           )
          )
          (i64.load offset=880
           (get_local $52)
          )
          (get_local $44)
         )
         (get_local $11)
         (get_local $34)
        )
        (get_local $42)
       )
       (get_local $15)
       (get_local $33)
      )
      (select
       (select
        (i64.load offset=240
         (get_local $52)
        )
        (i64.const 0)
        (get_local $50)
       )
       (i64.const 0)
       (get_local $51)
      )
     )
     (select
      (select
       (i64.or
        (select
         (select
          (i64.or
           (i64.load offset=336
            (get_local $52)
           )
           (i64.load offset=352
            (get_local $52)
           )
          )
          (i64.load offset=368
           (get_local $52)
          )
          (get_local $47)
         )
         (get_local $7)
         (get_local $37)
        )
        (select
         (i64.load offset=432
          (get_local $52)
         )
         (i64.const 0)
         (get_local $48)
        )
       )
       (select
        (select
         (i64.or
          (i64.load offset=464
           (get_local $52)
          )
          (i64.load offset=480
           (get_local $52)
          )
         )
         (i64.load offset=496
          (get_local $52)
         )
         (get_local $46)
        )
        (get_local $3)
        (get_local $36)
       )
       (get_local $49)
      )
      (get_local $7)
      (get_local $37)
     )
     (get_local $43)
    )
    (get_local $15)
    (get_local $33)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 104)
   )
   (select
    (select
     (i64.or
      (select
       (select
        (i64.or
         (select
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 992)
            )
            (i32.const 8)
           )
          )
          (i64.const 0)
          (get_local $41)
         )
         (select
          (select
           (i64.or
            (i64.load
             (i32.add
              (i32.add
               (get_local $52)
               (i32.const 768)
              )
              (i32.const 8)
             )
            )
            (i64.load
             (i32.add
              (i32.add
               (get_local $52)
               (i32.const 784)
              )
              (i32.const 8)
             )
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (get_local $52)
              (i32.const 800)
             )
             (i32.const 8)
            )
           )
           (get_local $45)
          )
          (get_local $10)
          (get_local $35)
         )
        )
        (select
         (i64.load
          (i32.add
           (i32.add
            (get_local $52)
            (i32.const 832)
           )
           (i32.const 8)
          )
         )
         (i64.const 0)
         (get_local $44)
        )
        (get_local $42)
       )
       (get_local $14)
       (get_local $33)
      )
      (select
       (select
        (select
         (i64.or
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 192)
            )
            (i32.const 8)
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 208)
            )
            (i32.const 8)
           )
          )
         )
         (i64.load
          (i32.add
           (i32.add
            (get_local $52)
            (i32.const 224)
           )
           (i32.const 8)
          )
         )
         (get_local $50)
        )
        (get_local $6)
        (get_local $39)
       )
       (i64.const 0)
       (get_local $51)
      )
     )
     (select
      (select
       (i64.or
        (select
         (i64.load
          (i32.add
           (i32.add
            (get_local $52)
            (i32.const 320)
           )
           (i32.const 8)
          )
         )
         (i64.const 0)
         (get_local $47)
        )
        (select
         (select
          (i64.or
           (i64.load
            (i32.add
             (i32.add
              (get_local $52)
              (i32.const 384)
             )
             (i32.const 8)
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (get_local $52)
              (i32.const 400)
             )
             (i32.const 8)
            )
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 416)
            )
            (i32.const 8)
           )
          )
          (get_local $48)
         )
         (get_local $2)
         (get_local $38)
        )
       )
       (select
        (i64.load
         (i32.add
          (i32.add
           (get_local $52)
           (i32.const 448)
          )
          (i32.const 8)
         )
        )
        (i64.const 0)
        (get_local $46)
       )
       (get_local $49)
      )
      (get_local $6)
      (get_local $37)
     )
     (get_local $43)
    )
    (get_local $14)
    (get_local $33)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 96)
   )
   (select
    (select
     (i64.or
      (select
       (select
        (i64.or
         (select
          (i64.load offset=992
           (get_local $52)
          )
          (i64.const 0)
          (get_local $41)
         )
         (select
          (select
           (i64.or
            (i64.load offset=768
             (get_local $52)
            )
            (i64.load offset=784
             (get_local $52)
            )
           )
           (i64.load offset=800
            (get_local $52)
           )
           (get_local $45)
          )
          (get_local $9)
          (get_local $35)
         )
        )
        (select
         (i64.load offset=832
          (get_local $52)
         )
         (i64.const 0)
         (get_local $44)
        )
        (get_local $42)
       )
       (get_local $13)
       (get_local $33)
      )
      (select
       (select
        (select
         (i64.or
          (i64.load offset=192
           (get_local $52)
          )
          (i64.load offset=208
           (get_local $52)
          )
         )
         (i64.load offset=224
          (get_local $52)
         )
         (get_local $50)
        )
        (get_local $5)
        (get_local $39)
       )
       (i64.const 0)
       (get_local $51)
      )
     )
     (select
      (select
       (i64.or
        (select
         (i64.load offset=320
          (get_local $52)
         )
         (i64.const 0)
         (get_local $47)
        )
        (select
         (select
          (i64.or
           (i64.load offset=384
            (get_local $52)
           )
           (i64.load offset=400
            (get_local $52)
           )
          )
          (i64.load offset=416
           (get_local $52)
          )
          (get_local $48)
         )
         (get_local $1)
         (get_local $38)
        )
       )
       (select
        (i64.load offset=448
         (get_local $52)
        )
        (i64.const 0)
        (get_local $46)
       )
       (get_local $49)
      )
      (get_local $5)
      (get_local $37)
     )
     (get_local $43)
    )
    (get_local $13)
    (get_local $33)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 72)
   )
   (select
    (select
     (i64.or
      (select
       (select
        (i64.load
         (i32.add
          (i32.add
           (get_local $52)
           (i32.const 896)
          )
          (i32.const 8)
         )
        )
        (i64.const 0)
        (get_local $41)
       )
       (i64.const 0)
       (get_local $42)
      )
      (select
       (select
        (i64.or
         (select
          (select
           (i64.or
            (i64.load
             (i32.add
              (get_local $52)
              (i32.const 8)
             )
            )
            (i64.load
             (i32.add
              (i32.add
               (get_local $52)
               (i32.const 16)
              )
              (i32.const 8)
             )
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (get_local $52)
              (i32.const 32)
             )
             (i32.const 8)
            )
           )
           (get_local $50)
          )
          (get_local $2)
          (get_local $39)
         )
         (select
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 64)
            )
            (i32.const 8)
           )
          )
          (i64.const 0)
          (tee_local $34
           (i32.lt_u
            (get_local $40)
            (i32.const 128)
           )
          )
         )
        )
        (select
         (select
          (i64.or
           (i64.load
            (i32.add
             (i32.add
              (get_local $52)
              (i32.const 128)
             )
             (i32.const 8)
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (get_local $52)
              (i32.const 144)
             )
             (i32.const 8)
            )
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 160)
            )
            (i32.const 8)
           )
          )
          (get_local $45)
         )
         (get_local $6)
         (get_local $35)
        )
        (get_local $51)
       )
       (get_local $2)
       (get_local $39)
      )
     )
     (select
      (select
       (i64.load
        (i32.add
         (i32.add
          (get_local $52)
          (i32.const 256)
         )
         (i32.const 8)
        )
       )
       (i64.const 0)
       (get_local $47)
      )
      (i64.const 0)
      (get_local $49)
     )
     (get_local $43)
    )
    (get_local $10)
    (get_local $33)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 64)
   )
   (select
    (select
     (i64.or
      (select
       (select
        (i64.load offset=896
         (get_local $52)
        )
        (i64.const 0)
        (get_local $41)
       )
       (i64.const 0)
       (get_local $42)
      )
      (select
       (select
        (i64.or
         (select
          (select
           (i64.or
            (i64.load
             (get_local $52)
            )
            (i64.load offset=16
             (get_local $52)
            )
           )
           (i64.load offset=32
            (get_local $52)
           )
           (get_local $50)
          )
          (get_local $1)
          (get_local $39)
         )
         (select
          (i64.load offset=64
           (get_local $52)
          )
          (i64.const 0)
          (get_local $34)
         )
        )
        (select
         (select
          (i64.or
           (i64.load offset=128
            (get_local $52)
           )
           (i64.load offset=144
            (get_local $52)
           )
          )
          (i64.load offset=160
           (get_local $52)
          )
          (get_local $45)
         )
         (get_local $5)
         (get_local $35)
        )
        (get_local $51)
       )
       (get_local $1)
       (get_local $39)
      )
     )
     (select
      (select
       (i64.load offset=256
        (get_local $52)
       )
       (i64.const 0)
       (get_local $47)
      )
      (i64.const 0)
      (get_local $49)
     )
     (get_local $43)
    )
    (get_local $9)
    (get_local $33)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 88)
   )
   (select
    (select
     (i64.or
      (select
       (select
        (select
         (i64.or
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 912)
            )
            (i32.const 8)
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 928)
            )
            (i32.const 8)
           )
          )
         )
         (i64.load
          (i32.add
           (i32.add
            (get_local $52)
            (i32.const 944)
           )
           (i32.const 8)
          )
         )
         (get_local $41)
        )
        (get_local $12)
        (get_local $33)
       )
       (i64.const 0)
       (get_local $42)
      )
      (select
       (select
        (i64.or
         (select
          (i64.load
           (i32.add
            (i32.add
             (get_local $52)
             (i32.const 48)
            )
            (i32.const 8)
           )
          )
          (i64.const 0)
          (get_local $50)
         )
         (select
          (select
           (i64.or
            (i64.load
             (i32.add
              (i32.add
               (get_local $52)
               (i32.const 80)
              )
              (i32.const 8)
             )
            )
            (i64.load
             (i32.add
              (i32.add
               (get_local $52)
               (i32.const 96)
              )
              (i32.const 8)
             )
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (get_local $52)
              (i32.const 112)
             )
             (i32.const 8)
            )
           )
           (get_local $34)
          )
          (get_local $8)
          (get_local $40)
         )
        )
        (select
         (i64.load
          (i32.add
           (i32.add
            (get_local $52)
            (i32.const 176)
           )
           (i32.const 8)
          )
         )
         (i64.const 0)
         (get_local $45)
        )
        (get_local $51)
       )
       (get_local $4)
       (get_local $39)
      )
     )
     (select
      (select
       (select
        (i64.or
         (i64.load
          (i32.add
           (i32.add
            (get_local $52)
            (i32.const 272)
           )
           (i32.const 8)
          )
         )
         (i64.load
          (i32.add
           (i32.add
            (get_local $52)
            (i32.const 288)
           )
           (i32.const 8)
          )
         )
        )
        (i64.load
         (i32.add
          (i32.add
           (get_local $52)
           (i32.const 304)
          )
          (i32.const 8)
         )
        )
        (get_local $47)
       )
       (get_local $4)
       (get_local $37)
      )
      (i64.const 0)
      (get_local $49)
     )
     (get_local $43)
    )
    (get_local $12)
    (get_local $33)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 80)
   )
   (select
    (select
     (i64.or
      (select
       (select
        (select
         (i64.or
          (i64.load offset=912
           (get_local $52)
          )
          (i64.load offset=928
           (get_local $52)
          )
         )
         (i64.load offset=944
          (get_local $52)
         )
         (get_local $41)
        )
        (get_local $11)
        (get_local $33)
       )
       (i64.const 0)
       (get_local $42)
      )
      (select
       (select
        (i64.or
         (select
          (i64.load offset=48
           (get_local $52)
          )
          (i64.const 0)
          (get_local $50)
         )
         (select
          (select
           (i64.or
            (i64.load offset=80
             (get_local $52)
            )
            (i64.load offset=96
             (get_local $52)
            )
           )
           (i64.load offset=112
            (get_local $52)
           )
           (get_local $34)
          )
          (get_local $7)
          (get_local $40)
         )
        )
        (select
         (i64.load offset=176
          (get_local $52)
         )
         (i64.const 0)
         (get_local $45)
        )
        (get_local $51)
       )
       (get_local $3)
       (get_local $39)
      )
     )
     (select
      (select
       (select
        (i64.or
         (i64.load offset=272
          (get_local $52)
         )
         (i64.load offset=288
          (get_local $52)
         )
        )
        (i64.load offset=304
         (get_local $52)
        )
        (get_local $47)
       )
       (get_local $3)
       (get_local $37)
      )
      (i64.const 0)
      (get_local $49)
     )
     (get_local $43)
    )
    (get_local $11)
    (get_local $33)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (get_local $52)
    (i32.const 1024)
   )
  )
  (return)
 )
 (func $stackSave (; 8 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 9 ;) (param $0 i32) (result i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $1
    (i32.and
     (i32.sub
      (i32.load offset=4
       (i32.const 0)
      )
      (get_local $0)
     )
     (i32.const -16)
    )
   )
  )
  (get_local $1)
 )
 (func $stackRestore (; 10 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": ["__ashlti3","__lshrti3"], "externs": [], "implementedFunctions": ["_shl_i3","_shl_i53","_sext_in_reg_i32_i64","_fpext_f32_f64","_fpconv_f64_f32","_bigshift","_stackSave","_stackAlloc","_stackRestore"], "exports": ["shl_i3","shl_i53","sext_in_reg_i32_i64","fpext_f32_f64","fpconv_f64_f32","bigshift","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
