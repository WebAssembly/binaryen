	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001124-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$push0=, 512
	i32.store	$discard=, s($2), $pop0
	i32.const	$push2=, 9
	i32.store8	$discard=, s+4($2), $pop2
	i32.const	$push1=, s
	i32.store	$discard=, i+8($2), $pop1
	i64.const	$push3=, 2048
	i64.store	$discard=, i($2), $pop3
	i64.const	$push4=, 0
	i64.store	$discard=, f($2), $pop4
	call    	exit, $2
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	s,@object               # @s
	.bss
	.globl	s
	.align	2
s:
	.zero	12
	.size	s, 12

	.type	i,@object               # @i
	.globl	i
	.align	3
i:
	.zero	16
	.size	i, 16

	.type	f,@object               # @f
	.globl	f
	.align	3
f:
	.zero	8
	.size	f, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
