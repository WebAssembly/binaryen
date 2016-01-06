	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040805-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.call	$push0=, foo
	i32.const	$push1=, 102
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, BB0_2
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	call    	exit, $pop3
	unreachable
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, a($0)
	i32.store	$push1=, a+4($0), $pop0
	i32.call	$push4=, bar, $pop1
	i32.const	$push2=, 100
	i32.call	$push3=, bar, $pop2
	i32.add 	$push5=, $pop4, $pop3
	return  	$pop5
func_end1:
	.size	foo, func_end1-foo

	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$push0=, a($1)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, a($1), $pop2
	return  	$0
func_end2:
	.size	bar, func_end2-bar

	.type	a,@object               # @a
	.data
	.globl	a
	.align	2
a:
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.size	a, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
