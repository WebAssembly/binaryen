	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20091229-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push7=, 0
	i64.const	$push0=, 63
	i64.shr_s	$push1=, $0, $pop0
	i64.const	$push2=, 33
	i64.shr_u	$push3=, $pop1, $pop2
	i64.add 	$push4=, $0, $pop3
	i64.const	$push5=, 31
	i64.shr_s	$push6=, $pop4, $pop5
	i64.sub 	$push8=, $pop7, $pop6
	return  	$pop8
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
