	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43438.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	g_9($pop1), $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	g_9,@object             # @g_9
	.section	.bss.g_9,"aw",@nobits
	.p2align	2
g_9:
	.int32	0                       # 0x0
	.size	g_9, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
