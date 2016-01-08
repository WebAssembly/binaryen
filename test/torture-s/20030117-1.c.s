	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030117-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end4
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.add 	$push0=, $1, $0
	i32.add 	$push1=, $pop0, $2
	i32.const	$push2=, 3
	i32.div_s	$push3=, $pop1, $pop2
	return  	$pop3
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.mul 	$push1=, $1, $1
	i32.mul 	$push0=, $0, $0
	i32.add 	$push3=, $pop1, $pop0
	i32.mul 	$push2=, $2, $2
	i32.add 	$push4=, $pop3, $pop2
	i32.const	$push5=, 3
	i32.div_u	$push6=, $pop4, $pop5
	return  	$pop6
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
