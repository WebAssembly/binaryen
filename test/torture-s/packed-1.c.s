	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/packed-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB0_2
	i32.load16_u	$push0=, x1($0)
	i32.store16	$push1=, t($0), $pop0
	i32.const	$push2=, 17
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, BB0_2
# BB#1:                                 # %if.end
	return  	$0
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB1_2
	i32.load16_u	$push0=, x1($0)
	i32.store16	$push1=, t($0), $pop0
	i32.const	$push2=, 17
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, BB1_2
# BB#1:                                 # %f.exit
	call    	exit, $0
	unreachable
BB1_2:                                  # %if.then.i
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	x1,@object              # @x1
	.data
	.globl	x1
	.align	1
x1:
	.int16	17                      # 0x11
	.size	x1, 2

	.type	t,@object               # @t
	.bss
	.globl	t
	.align	1
t:
	.zero	2
	.size	t, 2


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
