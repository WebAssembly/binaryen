	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-7.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$5=, 255
	block
	i32.and 	$push0=, $1, $5
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.end
	block
	i32.and 	$push3=, $2, $5
	i32.const	$push4=, 11
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, 0        # 0: down to label1
# BB#2:                                 # %if.end9
	block
	i32.and 	$push6=, $3, $5
	i32.const	$push7=, 12
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, 0        # 0: down to label2
# BB#3:                                 # %if.end15
	block
	i32.const	$push9=, 123
	i32.ne  	$push10=, $4, $pop9
	br_if   	$pop10, 0       # 0: down to label3
# BB#4:                                 # %if.end19
	return  	$5
.LBB0_5:                                # %if.then18
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then14
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %if.then8
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then
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
