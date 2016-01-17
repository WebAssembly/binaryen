	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030128-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load16_s	$1=, y($0)
	block
	i32.load8_u	$push0=, x($0)
	i32.div_s	$push1=, $pop0, $1
	i32.store8	$push2=, x($0), $pop1
	i32.const	$push3=, 255
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 246
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, 0        # 0: down to label0
# BB#1:                                 # %if.end
	call    	exit@FUNCTION, $0
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
	.align	1
y:
	.int16	65531                   # 0xfffb
	.size	y, 2


	.ident	"clang version 3.9.0 "
