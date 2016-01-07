	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050106-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load16_s	$push0=, u($0)
	i32.const	$push1=, -1
	i32.le_s	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB0_2
# BB#1:                                 # %if.end
	return  	$0
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	u,@object               # @u
	.bss
	.globl	u
	.align	2
u:
	.int32	0                       # 0x0
	.size	u, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
