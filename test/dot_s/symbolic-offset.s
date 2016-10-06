        .text
        .globl  f
        .type   f,@function
f:
        .param          i32
        .param          i32
        i32.store       m+4($0), $1
        return
        .endfunc
.Lfunc_end0:
        .size   f, .Lfunc_end0-f

        .type   m,@object
        .data
        .align  2
m:
        .int32  1
        .int32  0
        .int32  0
        .size   m, 12
