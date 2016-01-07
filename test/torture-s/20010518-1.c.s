	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010518-1.c"
	.globl	add
	.type	add,@function
add:                                    # @add
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.add 	$push0=, $1, $0
	i32.add 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $3
	i32.add 	$push3=, $pop2, $4
	i32.add 	$push4=, $pop3, $5
	i32.add 	$push5=, $pop4, $6
	i32.add 	$push6=, $pop5, $7
	i32.add 	$push7=, $pop6, $8
	i32.add 	$push8=, $pop7, $9
	i32.add 	$push9=, $pop8, $10
	i32.add 	$push10=, $pop9, $11
	i32.add 	$push11=, $pop10, $12
	return  	$pop11
.Lfunc_end0:
	.size	add, .Lfunc_end0-add

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
