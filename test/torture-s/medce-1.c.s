	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/medce-1.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, 1
	i32.store8	$discard=, ok($pop0), $pop1
	return
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	block   	.LBB1_2
	i32.ne  	$push0=, $0, $1
	br_if   	$pop0, .LBB1_2
# BB#1:                                 # %sw.bb1
	i32.const	$push1=, 0
	i32.store8	$discard=, ok($pop1), $1
.LBB1_2:                                  # %sw.epilog
	return
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, 1
	i32.store8	$discard=, ok($0), $pop0
	return  	$0
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	ok,@object              # @ok
	.lcomm	ok,1

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
