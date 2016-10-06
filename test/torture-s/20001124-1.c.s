	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001124-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 9
	i32.store8	s+4($pop1), $pop0
	i32.const	$push10=, 0
	i32.const	$push2=, 512
	i32.store	s($pop10), $pop2
	i32.const	$push9=, 0
	i64.const	$push3=, 2048
	i64.store	i($pop9), $pop3
	i32.const	$push8=, 0
	i32.const	$push4=, s
	i32.store	i+8($pop8), $pop4
	i32.const	$push7=, 0
	i64.const	$push5=, 0
	i64.store	f($pop7), $pop5
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	2
s:
	.skip	12
	.size	s, 12

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	3
i:
	.skip	16
	.size	i, 16

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	3
f:
	.skip	8
	.size	f, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
