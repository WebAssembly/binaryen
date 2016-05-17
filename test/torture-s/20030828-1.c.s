	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030828-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, p($pop0)
	i32.load	$push2=, 0($pop1)
	i32.const	$push3=, 1
	i32.add 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

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
	i32.const	$push0=, 5
	i32.store	$drop=, 12($pop10), $pop0
	i32.const	$push1=, 0
	i32.const	$push6=, 12
	i32.add 	$push7=, $0, $pop6
	i32.store	$drop=, p($pop1), $pop7
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4


	.ident	"clang version 3.9.0 "
