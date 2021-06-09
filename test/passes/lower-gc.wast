(module
 (type $empty (struct))
 (type $struct-i32 (struct (mut i32)))
 (type $struct-i64 (struct (mut i64)))
 (type $struct-f32 (struct (field (mut f32))))
 (type $struct-f64 (struct (field (mut f64))))
 (type $struct-ref (struct (field (mut (ref null $empty)))))
 (type $struct-rtt (struct (field (mut (rtt $empty)))))

 (type $many-fields (struct (field (mut i32)) (field (mut f64)) (field (mut f32))))

 (type $bytes (array (mut i8)))
 (type $doubles (array (mut f64)))

 (global $global0 (rtt 0 $empty) (rtt.canon $empty))
 (global $global1 (rtt 1 $struct-i32) (rtt.sub $struct-i32
  (global.get $global0)
 ))

 (func $struct-gets
  (param $ref-i32 (ref $struct-i32))
  (param $ref-i64 (ref $struct-i64))
  (param $ref-f32 (ref $struct-f32))
  (param $ref-f64 (ref $struct-f64))
  (param $ref-ref (ref $struct-ref))
  (param $ref-rtt (ref $struct-rtt))
  (drop
   (struct.get $struct-i32 0 (local.get $ref-i32))
  )
  (drop
   (struct.get $struct-i64 0 (local.get $ref-i64))
  )
  (drop
   (struct.get $struct-f32 0 (local.get $ref-f32))
  )
  (drop
   (struct.get $struct-f64 0 (local.get $ref-f64))
  )
  (drop
   (struct.get $struct-ref 0 (local.get $ref-ref))
  )
  (drop
   (struct.get $struct-rtt 0 (local.get $ref-rtt))
  )
 )

 (func $struct-sets
  (param $ref-i32 (ref $struct-i32))
  (param $ref-i64 (ref $struct-i64))
  (param $ref-f32 (ref $struct-f32))
  (param $ref-f64 (ref $struct-f64))
  (param $ref-ref (ref $struct-ref))
  (param $ref-rtt (ref $struct-rtt))
  (struct.set $struct-i32 0 (local.get $ref-i32) (i32.const 0))
  (struct.set $struct-i64 0 (local.get $ref-i64) (i64.const 0))
  (struct.set $struct-f32 0 (local.get $ref-f32) (f32.const 0))
  (struct.set $struct-f64 0 (local.get $ref-f64) (f64.const 0))
  (struct.set $struct-ref 0 (local.get $ref-ref) (ref.null $empty))
  (struct.set $struct-rtt 0 (local.get $ref-rtt) (rtt.canon $empty))
 )

 (func $many-fields
  (param $ref (ref $many-fields))
  (struct.set $many-fields 0 (local.get $ref) (i32.const 1))
  (struct.set $many-fields 1 (local.get $ref) (f64.const 3.14159))
  (struct.set $many-fields 2 (local.get $ref) (f32.const 2.71828))
 )

 (func $new-struct
  (drop
   (struct.new_with_rtt $struct-i32
    (i32.const 42)
    (rtt.canon $struct-i32)
   )
  )
 )

 (func $new-struct-default
  (drop
   (struct.new_default_with_rtt $many-fields
    (rtt.canon $many-fields)
   )
  )
 )

 (func $array-gets
  (param $ref-bytes (ref $bytes))
  (param $ref-doubles (ref $doubles))
  (drop
   (array.get $bytes (local.get $ref-bytes) (i32.const 7))
  )
  (drop
   (array.get $doubles (local.get $ref-doubles) (i32.const 7))
  )
 )

 (func $array-sets
  (param $ref-bytes (ref $bytes))
  (param $ref-doubles (ref $doubles))
  (array.set $bytes (local.get $ref-bytes) (i32.const 7) (i32.const 42))
  (array.set $doubles (local.get $ref-doubles) (i32.const 7) (f64.const 3.14159))
 )

 (func $new-array
  (drop
   (array.new_with_rtt $bytes
    (i32.const 42)
    (i32.const 11)
    (rtt.canon $bytes)
   )
  )
 )

 (func $new-array-default
  (drop
   (array.new_default_with_rtt $doubles
    (i32.const 11)
    (rtt.canon $doubles)
   )
  )
 )

 (func $rtt.sub
  (drop
   (rtt.sub $struct-i32
    (rtt.canon $empty)
   )
  )
 )

 (func $ref.as (param $x anyref)
  (drop
   (ref.as_non_null (local.get $x))
  )
  (drop
   (ref.as_func (local.get $x))
  )
 )

 (func $ref.is (param $x anyref)
  (drop
   (ref.as_non_null (local.get $x))
  )
  (drop
   (ref.as_data (local.get $x))
  )
 )

 (func $ref.func
  (drop
   (ref.func $ref.func)
  )
  ;; the same ref.func should be the same.
  (drop
   (ref.func $ref.func)
  )
  ;; a different one should be different.
  (drop
   (ref.func $ref.is)
  )
 )

 (func $ref.cast (param $x anyref)
  (drop
   (ref.cast (local.get $x) (rtt.canon $empty))
  )
 )

 (func $ref.test (param $x anyref)
  (drop
   (ref.test (local.get $x) (rtt.canon $empty))
  )
 )
)
