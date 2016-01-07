	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36765.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 16
	i32.call	$1=, __builtin_malloc, $pop0
	i32.const	$push1=, 0
	i32.store	$discard=, 0($1), $pop1
	i32.const	$push2=, 2
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $1, $pop3
	i32.const	$push5=, 1
	i32.store	$discard=, 0($pop4), $pop5
	i32.load	$push6=, 0($1)
	return  	$pop6
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
	i32.call	$push0=, foo, $0
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB1_2
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
