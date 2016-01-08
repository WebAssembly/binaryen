	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040411-1.c"
	.section	.text.sub1,"ax",@progbits
	.hidden	sub1
	.globl	sub1
	.type	sub1,@function
sub1:                                   # @sub1
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 2
	i32.add 	$0=, $0, $2
	i32.eq  	$push0=, $1, $2
	i32.shl 	$push1=, $0, $2
	i32.const	$push2=, 12
	i32.mul 	$push3=, $0, $pop2
	i32.select	$push4=, $pop0, $pop1, $pop3
	return  	$pop4
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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
