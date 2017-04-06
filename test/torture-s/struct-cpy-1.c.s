	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-cpy-1.c"
	.section	.text.ini,"ax",@progbits
	.hidden	ini
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

	.type	pty,@object             # @pty
	.section	.bss.pty,"aw",@nobits
	.p2align	3
pty:
	.skip	88
	.size	pty, 88


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
