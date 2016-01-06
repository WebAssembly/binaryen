        .data
        .type   pad,@object
        .globl  pad
        .align  2
pad:
        .int32  0
        .type   arr,@object
        .globl  arr
        .align  4
arr:
        .zero   400
        .size   arr, 400

        .type   ptr,@object
        .globl  ptr
        .align  2
ptr:
        .int32  arr+80
        .size   ptr, 4
