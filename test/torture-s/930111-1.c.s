	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930111-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.wwrite,"ax",@progbits
	.hidden	wwrite
	.globl	wwrite
	.type	wwrite,@function
wwrite:                                 # @wwrite
	.param  	i64
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	block
	block
	i64.const	$push0=, 28
	i64.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# BB#1:                                 # %entry
	i64.const	$push2=, 1
	i64.shl 	$push3=, $pop2, $0
	i64.const	$push4=, 276825096
	i64.and 	$push5=, $pop3, $pop4
	i64.const	$push6=, 0
	i64.ne  	$push7=, $pop5, $pop6
	br_if   	1, $pop7        # 1: down to label1
.LBB1_2:                                # %entry
	end_block                       # label2:
	i64.const	$push8=, 47
	i64.ne  	$push9=, $0, $pop8
	br_if   	1, $pop9        # 1: down to label0
.LBB1_3:                                # %return
	end_block                       # label1:
	return  	$1
.LBB1_4:                                # %sw.default
	end_block                       # label0:
	i32.const	$1=, 123
	return  	$1
	.endfunc
.Lfunc_end1:
	.size	wwrite, .Lfunc_end1-wwrite


	.ident	"clang version 3.9.0 "
