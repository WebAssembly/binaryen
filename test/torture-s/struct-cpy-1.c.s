	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-cpy-1.c"
	.section	.text.ini,"ax",@progbits
	.hidden	ini
	.globl	ini
	.type	ini,@function
ini:                                    # @ini
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, 0
	i64.store	pty+72($pop1), $pop0
	i32.const	$push13=, 0
	i64.const	$push12=, 0
	i64.store	pty+64($pop13), $pop12
	i32.const	$push11=, 0
	i64.const	$push10=, 0
	i64.store	pty+56($pop11), $pop10
	i32.const	$push9=, 0
	i64.const	$push2=, 8589934593
	i64.store	pty+40($pop9), $pop2
	i32.const	$push8=, 0
	i32.const	$push3=, 3
	i32.store	pty+48($pop8), $pop3
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.store	pty+80($pop7), $pop6
	i32.const	$push5=, 0
	i32.const	$push4=, 4
	i32.store	pty+52($pop5), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	ini, .Lfunc_end0-ini

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, 0
	i64.store	pty+72($pop1), $pop0
	i32.const	$push14=, 0
	i64.const	$push13=, 0
	i64.store	pty+64($pop14), $pop13
	i32.const	$push12=, 0
	i64.const	$push11=, 0
	i64.store	pty+56($pop12), $pop11
	i32.const	$push10=, 0
	i64.const	$push2=, 8589934593
	i64.store	pty+40($pop10), $pop2
	i32.const	$push9=, 0
	i32.const	$push3=, 3
	i32.store	pty+48($pop9), $pop3
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.store	pty+80($pop8), $pop7
	i32.const	$push6=, 0
	i32.const	$push4=, 4
	i32.store	pty+52($pop6), $pop4
	i32.const	$push5=, 0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	pty,@object             # @pty
	.section	.bss.pty,"aw",@nobits
	.p2align	3
pty:
	.skip	88
	.size	pty, 88


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
