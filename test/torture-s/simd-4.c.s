	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-4.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, -4294967295
	i64.store	s64($pop1), $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	s64                     # @s64
	.type	s64,@object
	.section	.bss.s64,"aw",@nobits
	.globl	s64
	.p2align	3
s64:
	.int64	0                       # 0x0
	.size	s64, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
