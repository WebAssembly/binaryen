(module
 (import "env" "STACKTOP" (global $STACKTOP$asm2wasm$import i32))
 (global $STACKTOP (mut i32) (get_global $STACKTOP$asm2wasm$import))

 (import "env" "UNUSEDTOP" (global $UNUSEDTOP$asm2wasm$import i32))
 (global $UNUSEDTOP (mut i32) (get_global $UNUSEDTOP$asm2wasm$import))

 (export "stackAlloc" (func $stackAlloc))

 (func $stackAlloc
  (drop (get_global $STACKTOP))
 )
)

