	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040411-1.c"
	.section	.text.sub1,"ax",@progbits
	.hidden	sub1
	.globl	sub1
	.type	sub1,@function
sub1:                                   # @sub1
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.add 	$push1=, $0, $pop0
	tee_local	$push9=, $0=, $pop1
	i32.const	$push8=, 2
	i32.shl 	$push3=, $pop9, $pop8
	i32.const	$push4=, 12
	i32.mul 	$push5=, $0, $pop4
	i32.const	$push7=, 2
	i32.eq  	$push2=, $1, $pop7
	i32.select	$push6=, $pop3, $pop5, $pop2
	return  	$pop6
	.endfunc
.Lfunc_end0:
	.size	sub1, .Lfunc_end0-sub1

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
