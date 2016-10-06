	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/divcmp-5.c"
	.section	.text.always_one_1,"ax",@progbits
	.hidden	always_one_1
	.globl	always_one_1
	.type	always_one_1,@function
always_one_1:                           # @always_one_1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	always_one_1, .Lfunc_end0-always_one_1

	.section	.text.always_one_2,"ax",@progbits
	.hidden	always_one_2
	.globl	always_one_2
	.type	always_one_2,@function
always_one_2:                           # @always_one_2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	always_one_2, .Lfunc_end1-always_one_2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
