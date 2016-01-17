	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-14.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 21
	i32.store	$discard=, 8($0), $pop0
	i32.const	$push1=, 42
	i32.store	$discard=, 4($0), $pop1
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 21
	i32.store	$discard=, a3+8($0), $pop0
	i32.const	$push1=, 42
	i32.store	$discard=, a3+4($0), $pop1
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a3                      # @a3
	.type	a3,@object
	.section	.bss.a3,"aw",@nobits
	.globl	a3
	.align	2
a3:
	.skip	12
	.size	a3, 12


	.ident	"clang version 3.9.0 "
