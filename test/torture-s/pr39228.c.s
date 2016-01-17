	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39228.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	f64.const	$push0=, infinity
	i32.call	$0=, __builtin_isinff@FUNCTION, $pop0
	i32.const	$1=, 0
	block
	i32.le_s	$push1=, $0, $1
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.end
	block
	i32.const	$push2=, 1
	i32.const	$push7=, 0
	i32.eq  	$push8=, $pop2, $pop7
	br_if   	$pop8, 0        # 0: down to label1
# BB#2:                                 # %if.end4
	block
	i64.const	$push4=, 0
	i64.const	$push3=, 9223090561878065152
	i32.call	$push5=, __builtin_isinfl@FUNCTION, $pop4, $pop3
	i32.le_s	$push6=, $pop5, $1
	br_if   	$pop6, 0        # 0: down to label2
# BB#3:                                 # %if.end8
	return  	$1
.LBB0_4:                                # %if.then7
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
