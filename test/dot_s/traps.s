    .text
    .file   ""
    .globl  test_traps
    .type   test_traps,@function
test_traps:
    .param      f32, f64
    .result     i32
# BB#0:
    i32.trunc_s/f32 $push0=, $0
    i32.trunc_u/f64 $push1=, $1
    i32.div_u       $push2=, $pop0, $pop1
    .endfunc
.Lfunc_end0:
    .size   test_traps, .Lfunc_end0-test_traps
