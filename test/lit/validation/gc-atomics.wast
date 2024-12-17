;; Test that shared-everything GC instructions require the shared-everything
;; feature.

;; RUN: not wasm-opt -all --disable-shared-everything %s 2>&1 | filecheck %s

(module
  (type $struct (struct (field (mut i32))))

  ;; CHECK: struct.atomic.get requires shared-everything [--enable-shared-everything]
  (func $get-seqcst (result i32)
    (struct.atomic.get seqcst $struct 0
      (struct.new_default $struct)
    )
  )

  ;; CHECK: struct.atomic.get requires shared-everything [--enable-shared-everything]
  (func $get-acqrel (result i32)
    (struct.atomic.get acqrel $struct 0
      (struct.new_default $struct)
    )
  )

  ;; CHECK: struct.atomic.set requires shared-everything [--enable-shared-everything]
  (func $set-seqcst
    (struct.atomic.set seqcst $struct 0
      (struct.new_default $struct)
      (i32.const 0)
    )
  )

  ;; CHECK: struct.atomic.set requires shared-everything [--enable-shared-everything]
  (func $set-acqrel
    (struct.atomic.set acqrel $struct 0
      (struct.new_default $struct)
      (i32.const 0)
    )
  )
)