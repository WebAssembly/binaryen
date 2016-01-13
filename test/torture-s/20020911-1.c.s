	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020911-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load16_s	$1=, c($0)
	block
	i32.const	$push2=, -1
	i32.gt_s	$push3=, $1, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push1=, 65535
	i32.and 	$push0=, $1, $pop1
	i32.const	$push4=, -32768
	i32.add 	$push5=, $pop0, $pop4
	i32.const	$push6=, 32768
	i32.ge_s	$push7=, $pop5, $pop6
	br_if   	$pop7, 0        # 0: down to label0
# BB#2:                                 # %if.end
	return  	$0
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.align	1
c:
	.int16	32768                   # 0x8000
	.size	c, 2


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
