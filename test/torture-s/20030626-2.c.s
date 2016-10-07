	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030626-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i32.load8_u	$push1=, .L.str.2+12($pop9)
	i32.store8	buf+12($pop0), $pop1
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load	$push2=, .L.str.2+8($pop7):p2align=0
	i32.store	buf+8($pop8), $pop2
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i64.load	$push3=, .L.str.2($pop5):p2align=0
	i64.store	buf($pop6), $pop3
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	40
	.size	buf, 40

	.type	.L.str.2,@object        # @.str.2
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.2:
	.asciz	"other string"
	.size	.L.str.2, 13


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
