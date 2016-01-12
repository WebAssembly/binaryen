	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001124-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
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
	call    	exit@FUNCTION, $2
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.align	2
s:
	.skip	12
	.size	s, 12

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	3
i:
	.skip	16
	.size	i, 16

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.align	3
f:
	.skip	8
	.size	f, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
