	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr22098-3.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, n($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$push3=, n($0), $pop2
	return  	$pop3
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, n($0)
	block   	.LBB1_2
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i32.store	$discard=, n($0), $pop1
	br_if   	$1, .LBB1_2
# BB#1:                                 # %if.end
	call    	exit, $0
	unreachable
.LBB1_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
	.align	2
n:
	.int32	0                       # 0x0
	.size	n, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
