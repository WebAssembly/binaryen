	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59014-2.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64, i64
	.result 	i64
# BB#0:                                 # %entry
	i64.or  	$push0=, $1, $0
	i32.wrap/i64	$push1=, $pop0
	i64.const	$push3=, 6
	i64.add 	$push2=, $1, $0
	i64.select	$push4=, $pop1, $pop3, $pop2
	return  	$pop4
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	BB1_2
	i64.const	$push1=, 12884901888
	i64.const	$push0=, 21474836480
	i64.call	$push2=, foo, $pop1, $pop0
	i64.const	$push3=, 34359738368
	i64.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, BB1_2
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	return  	$pop5
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
