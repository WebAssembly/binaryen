	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001121-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	f64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	f64.load	$push1=, d($pop0)
	return  	$pop1
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	d,@object               # @d
	.bss
	.globl	d
	.align	3
d:
	.int64	0                       # double 0
	.size	d, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
