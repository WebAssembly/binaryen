	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030626-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 7303014
	i32.store	$discard=, buf($0), $pop0
	return  	$0
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	buf,@object             # @buf
	.bss
	.globl	buf
	.align	2
buf:
	.zero	10
	.size	buf, 10


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
