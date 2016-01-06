	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060127-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i64
# BB#0:                                 # %entry
	block   	BB0_2
	i32.wrap/i64	$push0=, $0
	br_if   	$pop0, BB0_2
# BB#1:                                 # %if.end
	return
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB1_2
	i32.load	$push0=, a($0)
	br_if   	$pop0, BB1_2
# BB#1:                                 # %f.exit
	return  	$0
BB1_2:                                  # %if.then.i
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	3
a:
	.int64	1311768464867721216     # 0x1234567800000000
	.size	a, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
