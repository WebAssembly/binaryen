	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/cmpsi-1.c"
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.sub 	$1=, $0, $1
	block   	BB0_2
	i32.const	$push0=, 0
	i32.ge_s	$push1=, $1, $pop0
	br_if   	$pop1, BB0_2
# BB#1:                                 # %if.end3
	return  	$1
BB0_2:                                  # %if.then2
	call    	abort
	unreachable
func_end0:
	.size	f1, func_end0-f1

	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.sub 	$1=, $0, $1
	block   	BB1_2
	i32.const	$push0=, 0
	i32.ge_s	$push1=, $1, $pop0
	br_if   	$pop1, BB1_2
# BB#1:                                 # %if.end3
	return  	$1
BB1_2:                                  # %if.then2
	call    	abort
	unreachable
func_end1:
	.size	f2, func_end1-f2

	.globl	dummy
	.type	dummy,@function
dummy:                                  # @dummy
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$0
func_end2:
	.size	dummy, func_end2-dummy

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end3:
	.size	main, func_end3-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
