	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-1.c"
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
	i32.const	$push0=, 10
	i32.ne  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push2=, 11
	i32.ne  	$push3=, $2, $pop2
	br_if   	1, $pop3        # 1: down to label2
# BB#2:                                 # %if.end6
	i32.const	$push4=, 12
	i32.ne  	$push5=, $3, $pop4
	br_if   	2, $pop5        # 2: down to label1
# BB#3:                                 # %if.end10
	i32.const	$push6=, 123
	i32.ne  	$push7=, $4, $pop6
	br_if   	3, $pop7        # 3: down to label0
# BB#4:                                 # %if.end13
	return  	$1
.LBB0_5:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then5
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %if.then9
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then12
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
