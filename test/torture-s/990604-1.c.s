	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990604-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load	$push0=, b($0)
	br_if   	$pop0, .LBB0_2
# BB#1:                                 # %do.body.preheader
	i32.const	$push1=, 9
	i32.store	$discard=, b($0), $pop1
.LBB0_2:                                # %if.end
	return
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$0=, b($1)
	i32.const	$2=, 9
	block   	.LBB1_4
	i32.eq  	$push0=, $0, $2
	br_if   	$pop0, .LBB1_4
# BB#1:                                 # %entry
	block   	.LBB1_3
	br_if   	$0, .LBB1_3
# BB#2:                                 # %f.exit.thread
	i32.store	$discard=, b($1), $2
	br      	.LBB1_4
.LBB1_3:                                # %if.then
	call    	abort
	unreachable
.LBB1_4:                                # %if.end
	return  	$1
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
