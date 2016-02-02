	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030128-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.load8_u	$push1=, x($pop9)
	i32.const	$push8=, 0
	i32.load16_s	$push0=, y($pop8)
	i32.div_s	$push2=, $pop1, $pop0
	i32.store8	$push3=, x($pop10), $pop2
	i32.const	$push4=, 255
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push6=, 246
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
x:
	.int8	50                      # 0x32
	.size	x, 1

	.hidden	y                       # @y
	.type	y,@object
	.section	.data.y,"aw",@progbits
	.globl	y
	.p2align	1
y:
	.int16	65531                   # 0xfffb
	.size	y, 2


	.ident	"clang version 3.9.0 "
