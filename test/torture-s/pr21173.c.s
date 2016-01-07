	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr21173.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$2=, a+4($1)
	i32.const	$push0=, q
	i32.sub 	$0=, $0, $pop0
	i32.load	$push1=, a($1)
	i32.add 	$push2=, $pop1, $0
	i32.store	$discard=, a($1), $pop2
	i32.add 	$push3=, $2, $0
	i32.store	$discard=, a+4($1), $pop3
	return
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
	i32.load	$push0=, a($0)
	i32.load	$push1=, a+4($0)
	i32.or  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB1_2
# BB#1:                                 # %for.cond.1
	return  	$0
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	q,@object               # @q
	.bss
	.globl	q
q:
	.int8	0                       # 0x0
	.size	q, 1

	.type	a,@object               # @a
	.globl	a
	.align	2
a:
	.zero	8
	.size	a, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
