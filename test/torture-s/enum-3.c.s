	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/enum-3.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, __stack_pointer
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push8=, $pop3, $pop4
	i32.store	$push11=, 0($pop5), $pop8
	tee_local	$push10=, $0=, $pop11
	i32.const	$push0=, -2147483648
	i32.store	$discard=, 12($pop10), $pop0
	i32.const	$push1=, 0
	i32.const	$push6=, 12
	i32.add 	$push7=, $0, $pop6
	i32.store	$discard=, q($pop1), $pop7
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	q                       # @q
	.type	q,@object
	.section	.bss.q,"aw",@nobits
	.globl	q
	.p2align	2
q:
	.int32	0
	.size	q, 4

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4


	.ident	"clang version 3.9.0 "
