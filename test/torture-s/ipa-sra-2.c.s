	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/ipa-sra-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 2000
	i32.gt_s	$push4=, $0, $pop3
	i32.const	$push1=, 1
	i32.const	$push0=, 40
	i32.call	$push2=, calloc@FUNCTION, $pop1, $pop0
	tee_local	$push5=, $0=, $pop2
	i32.call	$2=, foo@FUNCTION, $pop4, $pop5
	call    	free@FUNCTION, $0
	return  	$2
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foo,"ax",@progbits
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 3999996
	i32.add 	$push1=, $1, $pop0
	i32.select	$push2=, $pop1, $1, $0
	i32.load	$push3=, 0($pop2)
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo


	.ident	"clang version 3.9.0 "
