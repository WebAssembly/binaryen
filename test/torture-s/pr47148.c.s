	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr47148.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push2=, 0
	i32.store	$push0=, b($pop1), $pop2
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	b,@object               # @b
	.section	.data.b,"aw",@progbits
	.p2align	2
b:
	.int32	1                       # 0x1
	.size	b, 4


	.ident	"clang version 3.9.0 "
