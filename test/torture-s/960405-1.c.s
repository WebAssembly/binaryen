	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960405-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i64.load	$push1=, x($0)
	i64.load	$push0=, x+8($0)
	i64.load	$push3=, y($0)
	i64.load	$push2=, y+8($0)
	i32.call	$push4=, __eqtf2@FUNCTION, $pop1, $pop0, $pop3, $pop2
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop4, $pop5
	br_if   	$pop6, 0        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	call    	exit@FUNCTION, $0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.align	4
x:
	.int64	0                       # fp128 +Inf
	.int64	9223090561878065152
	.size	x, 16

	.hidden	y                       # @y
	.type	y,@object
	.section	.data.y,"aw",@progbits
	.globl	y
	.align	4
y:
	.int64	0                       # fp128 +Inf
	.int64	9223090561878065152
	.size	y, 16


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
