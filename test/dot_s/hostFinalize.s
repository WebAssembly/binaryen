    .text
    .type _main, @function
_main:
    current_memory $push0=
    i32.const $push1=, 1
    i32.add $push2=, $pop0, $pop1
    grow_memory $pop2
    .endfunc
    .size _main
