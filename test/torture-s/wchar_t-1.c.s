	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/wchar_t-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 196
	block
	i32.load	$push1=, x($0)
	i32.ne  	$push2=, $pop1, $1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %entry
	i32.load	$push0=, x+4($0)
	br_if   	$pop0, 0        # 0: down to label0
# BB#2:                                 # %if.end
	block
	i32.load	$push3=, y($0)
	i32.ne  	$push4=, $pop3, $1
	br_if   	$pop4, 0        # 0: down to label1
# BB#3:                                 # %if.end4
	call    	exit@FUNCTION, $0
	unreachable
.LBB0_4:                                # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %if.then
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
	.align	2
x:
	.int32	196                     # 0xc4
	.int32	0                       # 0x0
	.size	x, 8

	.hidden	y                       # @y
	.type	y,@object
	.section	.data.y,"aw",@progbits
	.globl	y
	.align	2
y:
	.int32	196                     # 0xc4
	.size	y, 4


	.ident	"clang version 3.9.0 "
