	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/align-3.c"
	.section	.text.func,"ax",@progbits
	.hidden	func
	.globl	func
	.p2align	8
	.type	func,@function
func:                                   # @func
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	func, .Lfunc_end0-func

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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
