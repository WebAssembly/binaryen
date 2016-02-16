	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-7.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	block
	block
	block
	i32.const	$push12=, 255
	i32.and 	$push0=, $1, $pop12
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push13=, 255
	i32.and 	$push3=, $2, $pop13
	i32.const	$push4=, 11
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label2
# BB#2:                                 # %if.end9
	i32.const	$push6=, 255
	i32.and 	$push7=, $3, $pop6
	i32.const	$push8=, 12
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	2, $pop9        # 2: down to label1
# BB#3:                                 # %if.end15
	i32.const	$push10=, 123
	i32.ne  	$push11=, $4, $pop10
	br_if   	3, $pop11       # 3: down to label0
# BB#4:                                 # %if.end19
	return  	$1
.LBB0_5:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then8
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %if.then14
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then18
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
