	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000910-1.c"
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

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	return
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	return
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar

	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB3_2
	i32.ne  	$push0=, $0, $1
	br_if   	$pop0, .LBB3_2
# BB#1:                                 # %if.end
	return
.LBB3_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end3:
	.size	baz, .Lfunc_end3-baz


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
