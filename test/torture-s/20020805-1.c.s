	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020805-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, -1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 2
	i32.const	$push0=, 0
	i32.load	$push1=, n($pop0)
	tee_local	$push10=, $0=, $pop1
	i32.sub 	$push3=, $pop2, $pop10
	i32.const	$push9=, 0
	i32.sub 	$push4=, $pop9, $0
	i32.or  	$push5=, $pop3, $pop4
	i32.const	$push6=, 1
	i32.or  	$push7=, $pop5, $pop6
	call    	check@FUNCTION, $pop7
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	n                       # @n
	.type	n,@object
	.section	.data.n,"aw",@progbits
	.globl	n
	.p2align	2
n:
	.int32	1                       # 0x1
	.size	n, 4


	.ident	"clang version 3.9.0 "
