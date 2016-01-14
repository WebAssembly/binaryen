	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr47148.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.store	$push0=, b($0), $0
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	b,@object               # @b
	.section	.data.b,"aw",@progbits
	.align	2
b:
	.int32	1                       # 0x1
	.size	b, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
