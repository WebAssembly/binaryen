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
func_end0:
	.size	bar, func_end0-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	block   	BB1_2
	i32.ne  	$push0=, $0, $1
	br_if   	$pop0, BB1_2
# BB#1:                                 # %sw.bb1
	i32.const	$push1=, 0
	i32.store8	$discard=, ok($pop1), $1
BB1_2:                                  # %sw.epilog
	return
func_end1:
	.size	foo, func_end1-foo

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
func_end2:
	.size	main, func_end2-main

	.type	ok,@object              # @ok
	.lcomm	ok,1

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
