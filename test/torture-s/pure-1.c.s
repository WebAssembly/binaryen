	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pure-1.c"
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
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.func0,"ax",@progbits
	.hidden	func0
	.globl	func0
	.type	func0,@function
func0:                                  # @func0
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, i($pop0)
	i32.sub 	$push2=, $0, $pop1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	func0, .Lfunc_end1-func0

	.section	.text.func1,"ax",@progbits
	.hidden	func1
	.globl	func1
	.type	func1,@function
func1:                                  # @func1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	func1, .Lfunc_end2-func1

	.hidden	i                       # @i
	.type	i,@object
	.section	.data.i,"aw",@progbits
	.globl	i
	.p2align	2
i:
	.int32	2                       # 0x2
	.size	i, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
