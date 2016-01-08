	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001027-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, p($0)
	block   	.LBB0_2
	i32.const	$push0=, 1
	i32.store	$discard=, x($0), $pop0
	i32.const	$push1=, 2
	i32.store	$1=, 0($1), $pop1
	i32.load	$push2=, x($0)
	i32.ne  	$push3=, $pop2, $1
	br_if   	$pop3, .LBB0_2
# BB#1:                                 # %if.end
	call    	exit, $0
	unreachable
.LBB0_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.align	2
x:
	.int32	0                       # 0x0
	.size	x, 4

	.hidden	p                       # @p
	.type	p,@object
	.section	.data.p,"aw",@progbits
	.globl	p
	.align	2
p:
	.int32	x
	.size	p, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
