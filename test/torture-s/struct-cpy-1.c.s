	.text
	.file	"struct-cpy-1.c"
	.section	.text.ini,"ax",@progbits
	.hidden	ini                     # -- Begin function ini
	.globl	ini
	.type	ini,@function
ini:                                    # @ini
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, 0
	i64.store	pty+72($pop1), $pop0
	i32.const	$push11=, 0
	i64.const	$push10=, 0
	i64.store	pty+64($pop11), $pop10
	i32.const	$push9=, 0
	i64.const	$push8=, 0
	i64.store	pty+56($pop9), $pop8
	i32.const	$push7=, 0
	i64.const	$push2=, 8589934593
	i64.store	pty+40($pop7), $pop2
	i32.const	$push6=, 0
	i64.const	$push3=, 17179869187
	i64.store	pty+48($pop6), $pop3
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.store	pty+80($pop5), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	ini, .Lfunc_end0-ini
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i64.const	$push0=, 0
	i64.store	pty+72($pop1), $pop0
	i32.const	$push12=, 0
	i64.const	$push11=, 0
	i64.store	pty+64($pop12), $pop11
	i32.const	$push10=, 0
	i64.const	$push9=, 0
	i64.store	pty+56($pop10), $pop9
	i32.const	$push8=, 0
	i64.const	$push2=, 8589934593
	i64.store	pty+40($pop8), $pop2
	i32.const	$push7=, 0
	i64.const	$push3=, 17179869187
	i64.store	pty+48($pop7), $pop3
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.store	pty+80($pop6), $pop5
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	pty,@object             # @pty
	.section	.bss.pty,"aw",@nobits
	.p2align	3
pty:
	.skip	88
	.size	pty, 88


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
