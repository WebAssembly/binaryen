	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/wchar_t-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 196
	block   	BB0_5
	i32.load	$push1=, x($0)
	i32.ne  	$push2=, $pop1, $1
	br_if   	$pop2, BB0_5
# BB#1:                                 # %entry
	i32.load	$push0=, x+4($0)
	br_if   	$pop0, BB0_5
# BB#2:                                 # %if.end
	block   	BB0_4
	i32.load	$push3=, y($0)
	i32.ne  	$push4=, $pop3, $1
	br_if   	$pop4, BB0_4
# BB#3:                                 # %if.end4
	call    	exit, $0
	unreachable
BB0_4:                                  # %if.then3
	call    	abort
	unreachable
BB0_5:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	x,@object               # @x
	.data
	.globl	x
	.align	2
x:
	.int32	196                     # 0xc4
	.int32	0                       # 0x0
	.size	x, 8

	.type	y,@object               # @y
	.globl	y
	.align	2
y:
	.int32	196                     # 0xc4
	.size	y, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
