	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000722-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
# BB#0:                                 # %foo.exit
	return
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB2_2
	i32.load	$push0=, 4($0)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB2_2
# BB#1:                                 # %if.end
	i32.const	$push3=, 4
	i32.add 	$push4=, $0, $pop3
	i32.const	$push5=, 2
	i32.store	$discard=, 0($pop4), $pop5
	return
.LBB2_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
