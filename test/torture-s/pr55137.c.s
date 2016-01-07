	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr55137.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2147483645
	i32.gt_s	$push1=, $0, $pop0
	return  	$pop1
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.add 	$push1=, $0, $pop0
	return  	$pop1
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.add 	$push1=, $0, $pop0
	return  	$pop1
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
