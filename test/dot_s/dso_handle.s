        .text
        .file   "/tmp/tmplu1mMq/a.out.bc"
        .globl  main
        .type   main,@function
main:                                   # @main
        .result         i32
# BB#0:
        i32.const       $push0=, __dso_handle
        return          $pop0
        .endfunc
.Lfunc_end0:
        .size   main, .Lfunc_end0-main
