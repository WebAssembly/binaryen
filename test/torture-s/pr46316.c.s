	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr46316.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64
	.result 	i64
	.local  	i64
# BB#0:                                 # %entry
	i64.const	$1=, -4
	i64.lt_s	$push0=, $0, $1
	i64.select	$push1=, $pop0, $0, $1
	i64.const	$push2=, -1
	i64.xor 	$push3=, $pop1, $pop2
	i64.add 	$push4=, $0, $pop3
	i64.const	$push5=, 2
	i64.add 	$push6=, $pop4, $pop5
	i64.const	$push7=, -2
	i64.and 	$push8=, $pop6, $pop7
	i64.sub 	$push9=, $0, $pop8
	return  	$pop9
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	BB1_2
	i64.const	$push0=, 0
	i64.call	$push1=, foo, $pop0
	i64.const	$push2=, -4
	i64.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, BB1_2
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
