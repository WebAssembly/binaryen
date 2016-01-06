        .text
        .type   a,@object
        .lcomm  a,4,2
        .type   b,@object
        .lcomm  b,4,2
        .type   c,@object
        .data
        .globl  c
        .align  2
c:
        .int32  b
        .size   c, 4
