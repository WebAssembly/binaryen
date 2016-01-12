	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/packed-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load16_u	$push0=, x1($0)
	i32.store16	$push1=, t($0), $pop0
	i32.const	$push2=, 17
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
	i32.load16_u	$push0=, x1($0)
	i32.store16	$push1=, t($0), $pop0
	i32.const	$push2=, 17
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB1_2
# BB#1:                                 # %f.exit
	call    	exit@FUNCTION, $0
	unreachable
.LBB1_2:                                # %if.then.i
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	x1                      # @x1
	.type	x1,@object
	.section	.data.x1,"aw",@progbits
	.globl	x1
	.align	1
x1:
	.int16	17                      # 0x11
	.size	x1, 2

	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
	.align	1
t:
	.skip	2
	.size	t, 2


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
