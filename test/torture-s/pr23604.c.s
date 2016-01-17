	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr23604.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 1
	block
	block
	i32.gt_u	$push0=, $0, $2
	br_if   	$pop0, 0        # 0: down to label1
# BB#1:                                 # %if.then2
	i32.eq  	$push1=, $0, $1
	br_if   	$pop1, 0        # 0: down to label1
# BB#2:                                 # %if.then2
	i32.const	$0=, 0
	br_if   	$1, 1           # 1: down to label0
.LBB0_3:                                # %if.end9
	end_block                       # label1:
	copy_local	$0=, $2
.LBB0_4:                                # %return
	end_block                       # label0:
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
