	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-14.c"
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
func_end0:
	.size	f, func_end0-f

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
	call    	exit, $0
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	a3,@object              # @a3
	.bss
	.globl	a3
	.align	2
a3:
	.zero	12
	.size	a3, 12


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
