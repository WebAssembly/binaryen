	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr34130.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push0=, -2
	i32.add 	$push1=, $0, $pop0
	tee_local	$push11=, $1=, $pop1
	i32.const	$push4=, -1
	i32.gt_s	$push5=, $pop11, $pop4
	i32.const	$push2=, 2
	i32.sub 	$push3=, $pop2, $0
	i32.select	$push6=, $pop5, $1, $pop3
	i32.const	$push7=, 1
	i32.shl 	$push8=, $pop6, $pop7
	i32.sub 	$push10=, $pop9, $pop8
	return  	$pop10
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
