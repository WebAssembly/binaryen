	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010604-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push3=, 255
	i32.and 	$push4=, $6, $pop3
	i32.const	$push8=, 1
	i32.ne  	$push5=, $pop4, $pop8
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push9=, 1
	i32.xor 	$push0=, $3, $pop9
	br_if   	0, $pop0        # 0: down to label0
# BB#2:                                 # %entry
	i32.const	$push10=, 1
	i32.xor 	$push1=, $4, $pop10
	br_if   	0, $pop1        # 0: down to label0
# BB#3:                                 # %entry
	i32.const	$push11=, 1
	i32.xor 	$push2=, $5, $pop11
	br_if   	0, $pop2        # 0: down to label0
# BB#4:                                 # %if.end
	i32.add 	$push6=, $1, $0
	i32.add 	$push7=, $pop6, $2
	return  	$pop7
.LBB0_5:                                # %if.then
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
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
