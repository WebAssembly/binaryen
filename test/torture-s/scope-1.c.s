	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/scope-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, 0
	i32.load	$push1=, v($pop0)
	i32.const	$push2=, 3
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB0_2
# BB#1:                                 # %if.end
	return  	$0
.LBB0_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB1_2
	i32.load	$push0=, v($0)
	i32.const	$push1=, 3
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB1_2
# BB#1:                                 # %f.exit
	call    	exit@FUNCTION, $0
	unreachable
.LBB1_2:                                # %if.then.i
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.data.v,"aw",@progbits
	.globl	v
	.align	2
v:
	.int32	3                       # 0x3
	.size	v, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
