(module
  (memory 0 4294967295)
  (export "select_i32_bool" $select_i32_bool)
  (export "select_i32_eq" $select_i32_eq)
  (export "select_i32_ne" $select_i32_ne)
  (export "select_i64_bool" $select_i64_bool)
  (export "select_i64_eq" $select_i64_eq)
  (export "select_i64_ne" $select_i64_ne)
  (export "select_f32_bool" $select_f32_bool)
  (export "select_f32_eq" $select_f32_eq)
  (export "select_f32_ne" $select_f32_ne)
  (export "select_f64_bool" $select_f64_bool)
  (export "select_f64_eq" $select_f64_eq)
  (export "select_f64_ne" $select_f64_ne)
  (func $select_i32_bool (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (return
      (i32.select
        (get_local $$1)
        (get_local $$2)
        (get_local $$0)
      )
    )
  )
  (func $select_i32_eq (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (return
      (i32.select
        (get_local $$2)
        (get_local $$1)
        (get_local $$0)
      )
    )
  )
  (func $select_i32_ne (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (return
      (i32.select
        (get_local $$1)
        (get_local $$2)
        (get_local $$0)
      )
    )
  )
  (func $select_i64_bool (param $$0 i32) (param $$1 i64) (param $$2 i64) (result i64)
    (return
      (i64.select
        (get_local $$1)
        (get_local $$2)
        (get_local $$0)
      )
    )
  )
  (func $select_i64_eq (param $$0 i32) (param $$1 i64) (param $$2 i64) (result i64)
    (return
      (i64.select
        (get_local $$2)
        (get_local $$1)
        (get_local $$0)
      )
    )
  )
  (func $select_i64_ne (param $$0 i32) (param $$1 i64) (param $$2 i64) (result i64)
    (return
      (i64.select
        (get_local $$1)
        (get_local $$2)
        (get_local $$0)
      )
    )
  )
  (func $select_f32_bool (param $$0 i32) (param $$1 f32) (param $$2 f32) (result f32)
    (return
      (f32.select
        (get_local $$1)
        (get_local $$2)
        (get_local $$0)
      )
    )
  )
  (func $select_f32_eq (param $$0 i32) (param $$1 f32) (param $$2 f32) (result f32)
    (return
      (f32.select
        (get_local $$2)
        (get_local $$1)
        (get_local $$0)
      )
    )
  )
  (func $select_f32_ne (param $$0 i32) (param $$1 f32) (param $$2 f32) (result f32)
    (return
      (f32.select
        (get_local $$1)
        (get_local $$2)
        (get_local $$0)
      )
    )
  )
  (func $select_f64_bool (param $$0 i32) (param $$1 f64) (param $$2 f64) (result f64)
    (return
      (f64.select
        (get_local $$1)
        (get_local $$2)
        (get_local $$0)
      )
    )
  )
  (func $select_f64_eq (param $$0 i32) (param $$1 f64) (param $$2 f64) (result f64)
    (return
      (f64.select
        (get_local $$2)
        (get_local $$1)
        (get_local $$0)
      )
    )
  )
  (func $select_f64_ne (param $$0 i32) (param $$1 f64) (param $$2 f64) (result f64)
    (return
      (f64.select
        (get_local $$1)
        (get_local $$2)
        (get_local $$0)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
