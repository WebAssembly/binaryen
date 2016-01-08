	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/zero-struct-2.c"
	.section	.text.one_raw_spinlock,"ax",@progbits
	.hidden	one_raw_spinlock
	.globl	one_raw_spinlock
	.type	one_raw_spinlock,@function
one_raw_spinlock:                       # @one_raw_spinlock
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, ii($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, ii($0), $pop2
	return
.Lfunc_end0:
	.size	one_raw_spinlock, .Lfunc_end0-one_raw_spinlock

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, ii($0)
	block   	.LBB1_2
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i32.store	$discard=, ii($0), $pop1
	br_if   	$1, .LBB1_2
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	ii                      # @ii
	.type	ii,@object
	.section	.bss.ii,"aw",@nobits
	.globl	ii
	.align	2
ii:
	.int32	0                       # 0x0
	.size	ii, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
