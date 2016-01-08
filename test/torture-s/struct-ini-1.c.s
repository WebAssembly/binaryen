	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-ini-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_4
	i32.load8_u	$push2=, object($0)
	i32.const	$push3=, 88
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, .LBB0_4
# BB#1:                                 # %entry
	i32.load	$push0=, object+4($0)
	i32.const	$push5=, 8
	i32.ne  	$push6=, $pop0, $pop5
	br_if   	$pop6, .LBB0_4
# BB#2:                                 # %entry
	i32.load	$push1=, object+8($0)
	i32.const	$push7=, 9
	i32.ne  	$push8=, $pop1, $pop7
	br_if   	$pop8, .LBB0_4
# BB#3:                                 # %if.end
	call    	exit, $0
	unreachable
.LBB0_4:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	object                  # @object
	.type	object,@object
	.section	.data.object,"aw",@progbits
	.globl	object
	.align	2
object:
	.int8	88                      # 0x58
	.skip	3
	.int32	8                       # 0x8
	.int32	9                       # 0x9
	.size	object, 12


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
