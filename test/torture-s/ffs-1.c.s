	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/ffs-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load	$push0=, a($0)
	br_if   	$pop0, .LBB0_2
# BB#1:                                 # %if.end
	call    	exit@FUNCTION, $0
	unreachable
.LBB0_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
