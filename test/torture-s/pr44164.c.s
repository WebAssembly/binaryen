	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44164.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($0)
	i32.const	$2=, 0
	i32.store	$discard=, a($2), $2
	i32.load	$push0=, 0($0)
	i32.add 	$push1=, $pop0, $1
	return  	$pop1
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB1_2
	i32.const	$push2=, a
	i32.call	$push3=, foo, $pop2
	i32.const	$push0=, 1
	i32.store	$push1=, a($0), $pop0
	i32.ne  	$push4=, $pop3, $pop1
	br_if   	$pop4, .LBB1_2
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	2
a:
	.zero	4
	.size	a, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
