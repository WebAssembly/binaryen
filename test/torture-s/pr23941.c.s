	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr23941.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB0_2
	f64.load	$push0=, d($0)
	f64.const	$push1=, 0x1p-127
	f64.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, BB0_2
# BB#1:                                 # %if.end
	return  	$0
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	d,@object               # @d
	.data
	.globl	d
	.align	3
d:
	.int64	4035225266123964416     # double 5.8774717541114375E-39
	.size	d, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
