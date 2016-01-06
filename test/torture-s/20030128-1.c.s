	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030128-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load16_s	$1=, y($0)
	block   	BB0_2
	i32.load8_u	$push0=, x($0)
	i32.div_s	$push1=, $pop0, $1
	i32.store8	$push2=, x($0), $pop1
	i32.const	$push3=, 255
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 246
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, BB0_2
# BB#1:                                 # %if.end
	call    	exit, $0
	unreachable
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	x,@object               # @x
	.data
	.globl	x
x:
	.int8	50                      # 0x32
	.size	x, 1

	.type	y,@object               # @y
	.globl	y
	.align	1
y:
	.int16	65531                   # 0xfffb
	.size	y, 2


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
