(module
 (type $FUNCSIG$vijji (func (param i32 i64 i64 i32)))
 (import "env" "__ashlti3" (func $__ashlti3 (param i32 i64 i64 i32)))
 (import "env" "__lshrti3" (func $__lshrti3 (param i32 i64 i64 i32)))
 (import "env" "memory" (memory $0 1))
 (table 0 funcref)
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
    (local.get $0)
    (i32.and
     (local.get $1)
     (i32.const 7)
    )
   )
  )
 )
 (func $shl_i53 (; 3 ;) (param $0 i64) (param $1 i64) (param $2 i32) (result i64)
  (return
   (i64.shl
    (local.get $0)
    (i64.and
     (local.get $1)
     (i64.const 9007199254740991)
    )
   )
  )
 )
 (func $sext_in_reg_i32_i64 (; 4 ;) (param $0 i64) (result i64)
  (return
   (i64.shr_s
    (i64.shl
     (local.get $0)
     (i64.const 32)
    )
    (i64.const 32)
   )
  )
 )
 (func $fpext_f32_f64 (; 5 ;) (param $0 i32) (result f64)
  (return
   (f64.promote_f32
    (f32.load
     (local.get $0)
    )
   )
  )
 )
 (func $fpconv_f64_f32 (; 6 ;) (param $0 i32) (result f32)
  (return
   (f32.demote_f64
    (f64.load
     (local.get $0)
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
   (local.tee $52
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
    (local.get $52)
    (i32.const 512)
   )
   (local.get $1)
   (local.get $2)
   (local.tee $33
    (i32.wrap_i64
     (local.get $17)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 528)
   )
   (local.get $3)
   (local.get $4)
   (local.get $33)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 544)
   )
   (local.get $1)
   (local.get $2)
   (local.tee $41
    (i32.sub
     (i32.const 128)
     (local.get $33)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 560)
   )
   (local.get $1)
   (local.get $2)
   (local.tee $42
    (i32.add
     (local.get $33)
     (i32.const -128)
    )
   )
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 736)
   )
   (local.get $1)
   (local.get $2)
   (local.tee $43
    (i32.sub
     (i32.const 384)
     (local.get $33)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 720)
   )
   (local.get $3)
   (local.get $4)
   (local.tee $34
    (i32.add
     (local.get $33)
     (i32.const -256)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 752)
   )
   (local.get $1)
   (local.get $2)
   (local.tee $39
    (i32.add
     (local.get $33)
     (i32.const -384)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 592)
   )
   (local.get $7)
   (local.get $8)
   (local.get $33)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 608)
   )
   (local.get $5)
   (local.get $6)
   (local.get $41)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 624)
   )
   (local.get $5)
   (local.get $6)
   (local.get $42)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 688)
   )
   (local.get $3)
   (local.get $4)
   (local.tee $35
    (i32.sub
     (i32.const 256)
     (local.get $33)
    )
   )
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 640)
   )
   (local.get $1)
   (local.get $2)
   (local.get $35)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 656)
   )
   (local.get $3)
   (local.get $4)
   (local.tee $50
    (i32.sub
     (i32.const 128)
     (local.get $35)
    )
   )
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 672)
   )
   (local.get $3)
   (local.get $4)
   (local.get $41)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 576)
   )
   (local.get $5)
   (local.get $6)
   (local.get $33)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 704)
   )
   (local.get $1)
   (local.get $2)
   (local.get $34)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 480)
   )
   (local.get $1)
   (local.get $2)
   (i32.sub
    (i32.const 896)
    (local.get $33)
   )
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 464)
   )
   (local.get $3)
   (local.get $4)
   (local.tee $36
    (i32.add
     (local.get $33)
     (i32.const -768)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 496)
   )
   (local.get $1)
   (local.get $2)
   (i32.add
    (local.get $33)
    (i32.const -896)
   )
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 352)
   )
   (local.get $5)
   (local.get $6)
   (local.tee $45
    (i32.sub
     (i32.const 640)
     (local.get $33)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 336)
   )
   (local.get $7)
   (local.get $8)
   (local.tee $37
    (i32.add
     (local.get $33)
     (i32.const -512)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 368)
   )
   (local.get $5)
   (local.get $6)
   (local.tee $51
    (i32.add
     (local.get $33)
     (i32.const -640)
    )
   )
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 432)
   )
   (local.get $3)
   (local.get $4)
   (local.tee $38
    (i32.sub
     (i32.const 768)
     (local.get $33)
    )
   )
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 864)
   )
   (local.get $9)
   (local.get $10)
   (local.get $43)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 848)
   )
   (local.get $11)
   (local.get $12)
   (local.get $34)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 880)
   )
   (local.get $9)
   (local.get $10)
   (local.get $39)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 1008)
   )
   (local.get $15)
   (local.get $16)
   (local.get $33)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 960)
   )
   (local.get $13)
   (local.get $14)
   (local.get $41)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 976)
   )
   (local.get $13)
   (local.get $14)
   (local.get $42)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 816)
   )
   (local.get $11)
   (local.get $12)
   (local.get $35)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 240)
   )
   (local.get $7)
   (local.get $8)
   (local.tee $39
    (i32.sub
     (i32.const 512)
     (local.get $33)
    )
   )
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 192)
   )
   (local.get $5)
   (local.get $6)
   (local.get $39)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 208)
   )
   (local.get $7)
   (local.get $8)
   (local.tee $44
    (i32.sub
     (i32.const 128)
     (local.get $39)
    )
   )
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 224)
   )
   (local.get $7)
   (local.get $8)
   (local.get $43)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 768)
   )
   (local.get $9)
   (local.get $10)
   (local.get $35)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 784)
   )
   (local.get $11)
   (local.get $12)
   (local.get $50)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 800)
   )
   (local.get $11)
   (local.get $12)
   (local.get $41)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 992)
   )
   (local.get $13)
   (local.get $14)
   (local.get $33)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 832)
   )
   (local.get $9)
   (local.get $10)
   (local.get $34)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 384)
   )
   (local.get $1)
   (local.get $2)
   (local.get $38)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 400)
   )
   (local.get $3)
   (local.get $4)
   (i32.sub
    (i32.const 128)
    (local.get $38)
   )
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 416)
   )
   (local.get $3)
   (local.get $4)
   (local.get $45)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 320)
   )
   (local.get $5)
   (local.get $6)
   (local.get $37)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 448)
   )
   (local.get $1)
   (local.get $2)
   (local.get $36)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 128)
   )
   (local.get $5)
   (local.get $6)
   (local.get $35)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 144)
   )
   (local.get $7)
   (local.get $8)
   (i32.sub
    (i32.const 384)
    (local.get $39)
   )
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 160)
   )
   (local.get $7)
   (local.get $8)
   (local.get $41)
  )
  (call $__lshrti3
   (local.get $52)
   (local.get $1)
   (local.get $2)
   (local.get $39)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 16)
   )
   (local.get $3)
   (local.get $4)
   (local.get $44)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 32)
   )
   (local.get $3)
   (local.get $4)
   (local.get $43)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 64)
   )
   (local.get $5)
   (local.get $6)
   (local.tee $40
    (i32.sub
     (i32.const 256)
     (local.get $39)
    )
   )
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 896)
   )
   (local.get $9)
   (local.get $10)
   (local.get $33)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 256)
   )
   (local.get $1)
   (local.get $2)
   (local.get $37)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 912)
   )
   (local.get $11)
   (local.get $12)
   (local.get $33)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 928)
   )
   (local.get $9)
   (local.get $10)
   (local.get $41)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 944)
   )
   (local.get $9)
   (local.get $10)
   (local.get $42)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 80)
   )
   (local.get $7)
   (local.get $8)
   (local.get $40)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 96)
   )
   (local.get $5)
   (local.get $6)
   (i32.sub
    (i32.const 128)
    (local.get $40)
   )
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 112)
   )
   (local.get $5)
   (local.get $6)
   (local.get $44)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 48)
   )
   (local.get $3)
   (local.get $4)
   (local.get $39)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 176)
   )
   (local.get $7)
   (local.get $8)
   (local.get $35)
  )
  (call $__lshrti3
   (i32.add
    (local.get $52)
    (i32.const 288)
   )
   (local.get $1)
   (local.get $2)
   (local.get $45)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 272)
   )
   (local.get $3)
   (local.get $4)
   (local.get $37)
  )
  (call $__ashlti3
   (i32.add
    (local.get $52)
    (i32.const 304)
   )
   (local.get $1)
   (local.get $2)
   (local.get $51)
  )
  (i64.store
   (i32.add
    (local.get $0)
    (i32.const 8)
   )
   (select
    (select
     (select
      (i64.load
       (i32.add
        (i32.add
         (local.get $52)
         (i32.const 512)
        )
        (i32.const 8)
       )
      )
      (i64.const 0)
      (local.tee $41
       (i32.lt_u
        (local.get $33)
        (i32.const 128)
       )
      )
     )
     (i64.const 0)
     (local.tee $42
      (i32.lt_u
       (local.get $33)
       (i32.const 256)
      )
     )
    )
    (i64.const 0)
    (local.tee $43
     (i32.lt_u
      (local.get $33)
      (i32.const 512)
     )
    )
   )
  )
  (i64.store
   (local.get $0)
   (select
    (select
     (select
      (i64.load offset=512
       (local.get $52)
      )
      (i64.const 0)
      (local.get $41)
     )
     (i64.const 0)
     (local.get $42)
    )
    (i64.const 0)
    (local.get $43)
   )
  )
  (i64.store
   (i32.add
    (local.get $0)
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
           (local.get $52)
           (i32.const 528)
          )
          (i32.const 8)
         )
        )
        (i64.load
         (i32.add
          (i32.add
           (local.get $52)
           (i32.const 544)
          )
          (i32.const 8)
         )
        )
       )
       (i64.load
        (i32.add
         (i32.add
          (local.get $52)
          (i32.const 560)
         )
         (i32.const 8)
        )
       )
       (local.get $41)
      )
      (local.get $4)
      (local.get $33)
     )
     (i64.const 0)
     (local.get $42)
    )
    (i64.const 0)
    (local.get $43)
   )
  )
  (i64.store
   (i32.add
    (local.get $0)
    (i32.const 16)
   )
   (select
    (select
     (select
      (select
       (i64.or
        (i64.load offset=528
         (local.get $52)
        )
        (i64.load offset=544
         (local.get $52)
        )
       )
       (i64.load offset=560
        (local.get $52)
       )
       (local.get $41)
      )
      (local.get $3)
      (local.get $33)
     )
     (i64.const 0)
     (local.get $42)
    )
    (i64.const 0)
    (local.get $43)
   )
  )
  (i64.store
   (i32.add
    (local.get $0)
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
             (local.get $52)
             (i32.const 592)
            )
            (i32.const 8)
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (local.get $52)
             (i32.const 608)
            )
            (i32.const 8)
           )
          )
         )
         (i64.load
          (i32.add
           (i32.add
            (local.get $52)
            (i32.const 624)
           )
           (i32.const 8)
          )
         )
         (local.get $41)
        )
        (local.get $8)
        (local.get $33)
       )
       (select
        (i64.load
         (i32.add
          (i32.add
           (local.get $52)
           (i32.const 688)
          )
          (i32.const 8)
         )
        )
        (i64.const 0)
        (local.tee $45
         (i32.lt_u
          (local.get $35)
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
            (local.get $52)
            (i32.const 720)
           )
           (i32.const 8)
          )
         )
         (i64.load
          (i32.add
           (i32.add
            (local.get $52)
            (i32.const 736)
           )
           (i32.const 8)
          )
         )
        )
        (i64.load
         (i32.add
          (i32.add
           (local.get $52)
           (i32.const 752)
          )
          (i32.const 8)
         )
        )
        (local.tee $44
         (i32.lt_u
          (local.get $34)
          (i32.const 128)
         )
        )
       )
       (local.get $4)
       (local.get $34)
      )
      (local.get $42)
     )
     (local.get $8)
     (local.get $33)
    )
    (i64.const 0)
    (local.get $43)
   )
  )
  (i64.store
   (i32.add
    (local.get $0)
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
           (local.get $52)
          )
          (i64.load offset=608
           (local.get $52)
          )
         )
         (i64.load offset=624
          (local.get $52)
         )
         (local.get $41)
        )
        (local.get $7)
        (local.get $33)
       )
       (select
        (i64.load offset=688
         (local.get $52)
        )
        (i64.const 0)
        (local.get $45)
       )
      )
      (select
       (select
        (i64.or
         (i64.load offset=720
          (local.get $52)
         )
         (i64.load offset=736
          (local.get $52)
         )
        )
        (i64.load offset=752
         (local.get $52)
        )
        (local.get $44)
       )
       (local.get $3)
       (local.get $34)
      )
      (local.get $42)
     )
     (local.get $7)
     (local.get $33)
    )
    (i64.const 0)
    (local.get $43)
   )
  )
  (i64.store
   (i32.add
    (local.get $0)
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
           (local.get $52)
           (i32.const 576)
          )
          (i32.const 8)
         )
        )
        (i64.const 0)
        (local.get $41)
       )
       (select
        (select
         (i64.or
          (i64.load
           (i32.add
            (i32.add
             (local.get $52)
             (i32.const 640)
            )
            (i32.const 8)
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (local.get $52)
             (i32.const 656)
            )
            (i32.const 8)
           )
          )
         )
         (i64.load
          (i32.add
           (i32.add
            (local.get $52)
            (i32.const 672)
           )
           (i32.const 8)
          )
         )
         (local.get $45)
        )
        (local.get $2)
        (local.get $35)
       )
      )
      (select
       (i64.load
        (i32.add
         (i32.add
          (local.get $52)
          (i32.const 704)
         )
         (i32.const 8)
        )
       )
       (i64.const 0)
       (local.get $44)
      )
      (local.get $42)
     )
     (local.get $6)
     (local.get $33)
    )
    (i64.const 0)
    (local.get $43)
   )
  )
  (i64.store
   (i32.add
    (local.get $0)
    (i32.const 32)
   )
   (select
    (select
     (select
      (i64.or
       (select
        (i64.load offset=576
         (local.get $52)
        )
        (i64.const 0)
        (local.get $41)
       )
       (select
        (select
         (i64.or
          (i64.load offset=640
           (local.get $52)
          )
          (i64.load offset=656
           (local.get $52)
          )
         )
         (i64.load offset=672
          (local.get $52)
         )
         (local.get $45)
        )
        (local.get $1)
        (local.get $35)
       )
      )
      (select
       (i64.load offset=704
        (local.get $52)
       )
       (i64.const 0)
       (local.get $44)
      )
      (local.get $42)
     )
     (local.get $5)
     (local.get $33)
    )
    (i64.const 0)
    (local.get $43)
   )
  )
  (i64.store
   (i32.add
    (local.get $0)
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
               (local.get $52)
               (i32.const 1008)
              )
              (i32.const 8)
             )
            )
            (i64.load
             (i32.add
              (i32.add
               (local.get $52)
               (i32.const 960)
              )
              (i32.const 8)
             )
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (local.get $52)
              (i32.const 976)
             )
             (i32.const 8)
            )
           )
           (local.get $41)
          )
          (local.get $16)
          (local.get $33)
         )
         (select
          (i64.load
           (i32.add
            (i32.add
             (local.get $52)
             (i32.const 816)
            )
            (i32.const 8)
           )
          )
          (i64.const 0)
          (local.get $45)
         )
        )
        (select
         (select
          (i64.or
           (i64.load
            (i32.add
             (i32.add
              (local.get $52)
              (i32.const 848)
             )
             (i32.const 8)
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (local.get $52)
              (i32.const 864)
             )
             (i32.const 8)
            )
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (local.get $52)
             (i32.const 880)
            )
            (i32.const 8)
           )
          )
          (local.get $44)
         )
         (local.get $12)
         (local.get $34)
        )
        (local.get $42)
       )
       (local.get $16)
       (local.get $33)
      )
      (select
       (select
        (i64.load
         (i32.add
          (i32.add
           (local.get $52)
           (i32.const 240)
          )
          (i32.const 8)
         )
        )
        (i64.const 0)
        (local.tee $50
         (i32.lt_u
          (local.get $39)
          (i32.const 128)
         )
        )
       )
       (i64.const 0)
       (local.tee $51
        (i32.lt_u
         (local.get $39)
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
              (local.get $52)
              (i32.const 336)
             )
             (i32.const 8)
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (local.get $52)
              (i32.const 352)
             )
             (i32.const 8)
            )
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (local.get $52)
             (i32.const 368)
            )
            (i32.const 8)
           )
          )
          (local.tee $47
           (i32.lt_u
            (local.get $37)
            (i32.const 128)
           )
          )
         )
         (local.get $8)
         (local.get $37)
        )
        (select
         (i64.load
          (i32.add
           (i32.add
            (local.get $52)
            (i32.const 432)
           )
           (i32.const 8)
          )
         )
         (i64.const 0)
         (local.tee $48
          (i32.lt_u
           (local.get $38)
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
             (local.get $52)
             (i32.const 464)
            )
            (i32.const 8)
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (local.get $52)
             (i32.const 480)
            )
            (i32.const 8)
           )
          )
         )
         (i64.load
          (i32.add
           (i32.add
            (local.get $52)
            (i32.const 496)
           )
           (i32.const 8)
          )
         )
         (local.tee $46
          (i32.lt_u
           (local.get $36)
           (i32.const 128)
          )
         )
        )
        (local.get $4)
        (local.get $36)
       )
       (local.tee $49
        (i32.lt_u
         (local.get $37)
         (i32.const 256)
        )
       )
      )
      (local.get $8)
      (local.get $37)
     )
     (local.get $43)
    )
    (local.get $16)
    (local.get $33)
   )
  )
  (i64.store
   (i32.add
    (local.get $0)
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
             (local.get $52)
            )
            (i64.load offset=960
             (local.get $52)
            )
           )
           (i64.load offset=976
            (local.get $52)
           )
           (local.get $41)
          )
          (local.get $15)
          (local.get $33)
         )
         (select
          (i64.load offset=816
           (local.get $52)
          )
          (i64.const 0)
          (local.get $45)
         )
        )
        (select
         (select
          (i64.or
           (i64.load offset=848
            (local.get $52)
           )
           (i64.load offset=864
            (local.get $52)
           )
          )
          (i64.load offset=880
           (local.get $52)
          )
          (local.get $44)
         )
         (local.get $11)
         (local.get $34)
        )
        (local.get $42)
       )
       (local.get $15)
       (local.get $33)
      )
      (select
       (select
        (i64.load offset=240
         (local.get $52)
        )
        (i64.const 0)
        (local.get $50)
       )
       (i64.const 0)
       (local.get $51)
      )
     )
     (select
      (select
       (i64.or
        (select
         (select
          (i64.or
           (i64.load offset=336
            (local.get $52)
           )
           (i64.load offset=352
            (local.get $52)
           )
          )
          (i64.load offset=368
           (local.get $52)
          )
          (local.get $47)
         )
         (local.get $7)
         (local.get $37)
        )
        (select
         (i64.load offset=432
          (local.get $52)
         )
         (i64.const 0)
         (local.get $48)
        )
       )
       (select
        (select
         (i64.or
          (i64.load offset=464
           (local.get $52)
          )
          (i64.load offset=480
           (local.get $52)
          )
         )
         (i64.load offset=496
          (local.get $52)
         )
         (local.get $46)
        )
        (local.get $3)
        (local.get $36)
       )
       (local.get $49)
      )
      (local.get $7)
      (local.get $37)
     )
     (local.get $43)
    )
    (local.get $15)
    (local.get $33)
   )
  )
  (i64.store
   (i32.add
    (local.get $0)
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
             (local.get $52)
             (i32.const 992)
            )
            (i32.const 8)
           )
          )
          (i64.const 0)
          (local.get $41)
         )
         (select
          (select
           (i64.or
            (i64.load
             (i32.add
              (i32.add
               (local.get $52)
               (i32.const 768)
              )
              (i32.const 8)
             )
            )
            (i64.load
             (i32.add
              (i32.add
               (local.get $52)
               (i32.const 784)
              )
              (i32.const 8)
             )
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (local.get $52)
              (i32.const 800)
             )
             (i32.const 8)
            )
           )
           (local.get $45)
          )
          (local.get $10)
          (local.get $35)
         )
        )
        (select
         (i64.load
          (i32.add
           (i32.add
            (local.get $52)
            (i32.const 832)
           )
           (i32.const 8)
          )
         )
         (i64.const 0)
         (local.get $44)
        )
        (local.get $42)
       )
       (local.get $14)
       (local.get $33)
      )
      (select
       (select
        (select
         (i64.or
          (i64.load
           (i32.add
            (i32.add
             (local.get $52)
             (i32.const 192)
            )
            (i32.const 8)
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (local.get $52)
             (i32.const 208)
            )
            (i32.const 8)
           )
          )
         )
         (i64.load
          (i32.add
           (i32.add
            (local.get $52)
            (i32.const 224)
           )
           (i32.const 8)
          )
         )
         (local.get $50)
        )
        (local.get $6)
        (local.get $39)
       )
       (i64.const 0)
       (local.get $51)
      )
     )
     (select
      (select
       (i64.or
        (select
         (i64.load
          (i32.add
           (i32.add
            (local.get $52)
            (i32.const 320)
           )
           (i32.const 8)
          )
         )
         (i64.const 0)
         (local.get $47)
        )
        (select
         (select
          (i64.or
           (i64.load
            (i32.add
             (i32.add
              (local.get $52)
              (i32.const 384)
             )
             (i32.const 8)
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (local.get $52)
              (i32.const 400)
             )
             (i32.const 8)
            )
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (local.get $52)
             (i32.const 416)
            )
            (i32.const 8)
           )
          )
          (local.get $48)
         )
         (local.get $2)
         (local.get $38)
        )
       )
       (select
        (i64.load
         (i32.add
          (i32.add
           (local.get $52)
           (i32.const 448)
          )
          (i32.const 8)
         )
        )
        (i64.const 0)
        (local.get $46)
       )
       (local.get $49)
      )
      (local.get $6)
      (local.get $37)
     )
     (local.get $43)
    )
    (local.get $14)
    (local.get $33)
   )
  )
  (i64.store
   (i32.add
    (local.get $0)
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
           (local.get $52)
          )
          (i64.const 0)
          (local.get $41)
         )
         (select
          (select
           (i64.or
            (i64.load offset=768
             (local.get $52)
            )
            (i64.load offset=784
             (local.get $52)
            )
           )
           (i64.load offset=800
            (local.get $52)
           )
           (local.get $45)
          )
          (local.get $9)
          (local.get $35)
         )
        )
        (select
         (i64.load offset=832
          (local.get $52)
         )
         (i64.const 0)
         (local.get $44)
        )
        (local.get $42)
       )
       (local.get $13)
       (local.get $33)
      )
      (select
       (select
        (select
         (i64.or
          (i64.load offset=192
           (local.get $52)
          )
          (i64.load offset=208
           (local.get $52)
          )
         )
         (i64.load offset=224
          (local.get $52)
         )
         (local.get $50)
        )
        (local.get $5)
        (local.get $39)
       )
       (i64.const 0)
       (local.get $51)
      )
     )
     (select
      (select
       (i64.or
        (select
         (i64.load offset=320
          (local.get $52)
         )
         (i64.const 0)
         (local.get $47)
        )
        (select
         (select
          (i64.or
           (i64.load offset=384
            (local.get $52)
           )
           (i64.load offset=400
            (local.get $52)
           )
          )
          (i64.load offset=416
           (local.get $52)
          )
          (local.get $48)
         )
         (local.get $1)
         (local.get $38)
        )
       )
       (select
        (i64.load offset=448
         (local.get $52)
        )
        (i64.const 0)
        (local.get $46)
       )
       (local.get $49)
      )
      (local.get $5)
      (local.get $37)
     )
     (local.get $43)
    )
    (local.get $13)
    (local.get $33)
   )
  )
  (i64.store
   (i32.add
    (local.get $0)
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
           (local.get $52)
           (i32.const 896)
          )
          (i32.const 8)
         )
        )
        (i64.const 0)
        (local.get $41)
       )
       (i64.const 0)
       (local.get $42)
      )
      (select
       (select
        (i64.or
         (select
          (select
           (i64.or
            (i64.load
             (i32.add
              (local.get $52)
              (i32.const 8)
             )
            )
            (i64.load
             (i32.add
              (i32.add
               (local.get $52)
               (i32.const 16)
              )
              (i32.const 8)
             )
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (local.get $52)
              (i32.const 32)
             )
             (i32.const 8)
            )
           )
           (local.get $50)
          )
          (local.get $2)
          (local.get $39)
         )
         (select
          (i64.load
           (i32.add
            (i32.add
             (local.get $52)
             (i32.const 64)
            )
            (i32.const 8)
           )
          )
          (i64.const 0)
          (local.tee $34
           (i32.lt_u
            (local.get $40)
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
              (local.get $52)
              (i32.const 128)
             )
             (i32.const 8)
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (local.get $52)
              (i32.const 144)
             )
             (i32.const 8)
            )
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (local.get $52)
             (i32.const 160)
            )
            (i32.const 8)
           )
          )
          (local.get $45)
         )
         (local.get $6)
         (local.get $35)
        )
        (local.get $51)
       )
       (local.get $2)
       (local.get $39)
      )
     )
     (select
      (select
       (i64.load
        (i32.add
         (i32.add
          (local.get $52)
          (i32.const 256)
         )
         (i32.const 8)
        )
       )
       (i64.const 0)
       (local.get $47)
      )
      (i64.const 0)
      (local.get $49)
     )
     (local.get $43)
    )
    (local.get $10)
    (local.get $33)
   )
  )
  (i64.store
   (i32.add
    (local.get $0)
    (i32.const 64)
   )
   (select
    (select
     (i64.or
      (select
       (select
        (i64.load offset=896
         (local.get $52)
        )
        (i64.const 0)
        (local.get $41)
       )
       (i64.const 0)
       (local.get $42)
      )
      (select
       (select
        (i64.or
         (select
          (select
           (i64.or
            (i64.load
             (local.get $52)
            )
            (i64.load offset=16
             (local.get $52)
            )
           )
           (i64.load offset=32
            (local.get $52)
           )
           (local.get $50)
          )
          (local.get $1)
          (local.get $39)
         )
         (select
          (i64.load offset=64
           (local.get $52)
          )
          (i64.const 0)
          (local.get $34)
         )
        )
        (select
         (select
          (i64.or
           (i64.load offset=128
            (local.get $52)
           )
           (i64.load offset=144
            (local.get $52)
           )
          )
          (i64.load offset=160
           (local.get $52)
          )
          (local.get $45)
         )
         (local.get $5)
         (local.get $35)
        )
        (local.get $51)
       )
       (local.get $1)
       (local.get $39)
      )
     )
     (select
      (select
       (i64.load offset=256
        (local.get $52)
       )
       (i64.const 0)
       (local.get $47)
      )
      (i64.const 0)
      (local.get $49)
     )
     (local.get $43)
    )
    (local.get $9)
    (local.get $33)
   )
  )
  (i64.store
   (i32.add
    (local.get $0)
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
             (local.get $52)
             (i32.const 912)
            )
            (i32.const 8)
           )
          )
          (i64.load
           (i32.add
            (i32.add
             (local.get $52)
             (i32.const 928)
            )
            (i32.const 8)
           )
          )
         )
         (i64.load
          (i32.add
           (i32.add
            (local.get $52)
            (i32.const 944)
           )
           (i32.const 8)
          )
         )
         (local.get $41)
        )
        (local.get $12)
        (local.get $33)
       )
       (i64.const 0)
       (local.get $42)
      )
      (select
       (select
        (i64.or
         (select
          (i64.load
           (i32.add
            (i32.add
             (local.get $52)
             (i32.const 48)
            )
            (i32.const 8)
           )
          )
          (i64.const 0)
          (local.get $50)
         )
         (select
          (select
           (i64.or
            (i64.load
             (i32.add
              (i32.add
               (local.get $52)
               (i32.const 80)
              )
              (i32.const 8)
             )
            )
            (i64.load
             (i32.add
              (i32.add
               (local.get $52)
               (i32.const 96)
              )
              (i32.const 8)
             )
            )
           )
           (i64.load
            (i32.add
             (i32.add
              (local.get $52)
              (i32.const 112)
             )
             (i32.const 8)
            )
           )
           (local.get $34)
          )
          (local.get $8)
          (local.get $40)
         )
        )
        (select
         (i64.load
          (i32.add
           (i32.add
            (local.get $52)
            (i32.const 176)
           )
           (i32.const 8)
          )
         )
         (i64.const 0)
         (local.get $45)
        )
        (local.get $51)
       )
       (local.get $4)
       (local.get $39)
      )
     )
     (select
      (select
       (select
        (i64.or
         (i64.load
          (i32.add
           (i32.add
            (local.get $52)
            (i32.const 272)
           )
           (i32.const 8)
          )
         )
         (i64.load
          (i32.add
           (i32.add
            (local.get $52)
            (i32.const 288)
           )
           (i32.const 8)
          )
         )
        )
        (i64.load
         (i32.add
          (i32.add
           (local.get $52)
           (i32.const 304)
          )
          (i32.const 8)
         )
        )
        (local.get $47)
       )
       (local.get $4)
       (local.get $37)
      )
      (i64.const 0)
      (local.get $49)
     )
     (local.get $43)
    )
    (local.get $12)
    (local.get $33)
   )
  )
  (i64.store
   (i32.add
    (local.get $0)
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
           (local.get $52)
          )
          (i64.load offset=928
           (local.get $52)
          )
         )
         (i64.load offset=944
          (local.get $52)
         )
         (local.get $41)
        )
        (local.get $11)
        (local.get $33)
       )
       (i64.const 0)
       (local.get $42)
      )
      (select
       (select
        (i64.or
         (select
          (i64.load offset=48
           (local.get $52)
          )
          (i64.const 0)
          (local.get $50)
         )
         (select
          (select
           (i64.or
            (i64.load offset=80
             (local.get $52)
            )
            (i64.load offset=96
             (local.get $52)
            )
           )
           (i64.load offset=112
            (local.get $52)
           )
           (local.get $34)
          )
          (local.get $7)
          (local.get $40)
         )
        )
        (select
         (i64.load offset=176
          (local.get $52)
         )
         (i64.const 0)
         (local.get $45)
        )
        (local.get $51)
       )
       (local.get $3)
       (local.get $39)
      )
     )
     (select
      (select
       (select
        (i64.or
         (i64.load offset=272
          (local.get $52)
         )
         (i64.load offset=288
          (local.get $52)
         )
        )
        (i64.load offset=304
         (local.get $52)
        )
        (local.get $47)
       )
       (local.get $3)
       (local.get $37)
      )
      (i64.const 0)
      (local.get $49)
     )
     (local.get $43)
    )
    (local.get $11)
    (local.get $33)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (local.get $52)
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
   (local.tee $1
    (i32.and
     (i32.sub
      (i32.load offset=4
       (i32.const 0)
      )
      (local.get $0)
     )
     (i32.const -16)
    )
   )
  )
  (local.get $1)
 )
 (func $stackRestore (; 10 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (local.get $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": ["__ashlti3","__lshrti3"], "externs": [], "implementedFunctions": ["_shl_i3","_shl_i53","_sext_in_reg_i32_i64","_fpext_f32_f64","_fpconv_f64_f32","_bigshift","_stackSave","_stackAlloc","_stackRestore"], "exports": ["shl_i3","shl_i53","sext_in_reg_i32_i64","fpext_f32_f64","fpconv_f64_f32","bigshift","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
