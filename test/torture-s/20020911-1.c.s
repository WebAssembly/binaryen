	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020911-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push1=, 0
	i32.load16_s	$push2=, c($pop1)
	tee_local	$push11=, $0=, $pop2
	i32.const	$push4=, -1
	i32.gt_s	$push5=, $pop11, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push3=, 65535
	i32.and 	$push0=, $0, $pop3
	i32.const	$push6=, -32768
	i32.add 	$push7=, $pop0, $pop6
	i32.const	$push8=, 32768
	i32.ge_s	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push10=, 0
	return  	$pop10
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	1
c:
	.int16	32768                   # 0x8000
	.size	c, 2


	.ident	"clang version 3.9.0 "
