	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050111-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.eq  	$push1=, $0, $pop0
	i32.const	$push5=, 0
	i64.const	$push2=, 32
	i64.shr_u	$push3=, $0, $pop2
	i32.wrap/i64	$push4=, $pop3
	i32.select	$push6=, $pop1, $pop5, $pop4
	return  	$pop6
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i64
# BB#0:                                 # %entry
	i64.extend_u/i32	$push0=, $0
	i64.const	$push1=, 32
	i64.shl 	$push2=, $pop0, $pop1
	return  	$pop2
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end16
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
