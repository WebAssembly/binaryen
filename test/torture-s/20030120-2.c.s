	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030120-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 4
	i32.eq  	$push6=, $0, $pop5
	i32.const	$push9=, 4
	i32.const	$push2=, 3
	i32.eq  	$push3=, $0, $pop2
	i32.const	$push8=, 3
	i32.const	$push0=, 1
	i32.eq  	$push1=, $0, $pop0
	i32.select	$push4=, $pop3, $pop8, $pop1
	i32.select	$push7=, $pop6, $pop9, $pop4
	return  	$pop7
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
