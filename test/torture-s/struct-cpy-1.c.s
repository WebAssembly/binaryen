	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-cpy-1.c"
	.section	.text.ini,"ax",@progbits
	.hidden	ini
	.globl	ini
	.type	ini,@function
ini:                                    # @ini
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push13=, 0
	i32.const	$push12=, 0
	i64.const	$push3=, 0
	i64.store	$push0=, pty+72($pop12), $pop3
	i64.store	$push1=, pty+64($pop13), $pop0
	i64.store	$drop=, pty+56($pop4), $pop1
	i32.const	$push11=, 0
	i64.const	$push5=, 8589934593
	i64.store	$drop=, pty+40($pop11), $pop5
	i32.const	$push10=, 0
	i32.const	$push6=, 3
	i32.store	$drop=, pty+48($pop10), $pop6
	i32.const	$push9=, 0
	i32.const	$push8=, 0
	i32.store	$push2=, pty+80($pop9), $pop8
	i32.const	$push7=, 4
	i32.store	$drop=, pty+52($pop2), $pop7
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i64.const	$push2=, 0
	i64.store	$push0=, pty+72($pop13), $pop2
	i64.store	$push1=, pty+64($pop14), $pop0
	i64.store	$drop=, pty+56($pop3), $pop1
	i32.const	$push12=, 0
	i64.const	$push4=, 8589934593
	i64.store	$drop=, pty+40($pop12), $pop4
	i32.const	$push11=, 0
	i32.const	$push5=, 3
	i32.store	$drop=, pty+48($pop11), $pop5
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.store	$push8=, pty+80($pop10), $pop9
	tee_local	$push7=, $0=, $pop8
	i32.const	$push6=, 4
	i32.store	$drop=, pty+52($pop7), $pop6
	copy_local	$push15=, $0
                                        # fallthrough-return: $pop15
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	pty,@object             # @pty
	.section	.bss.pty,"aw",@nobits
	.p2align	3
pty:
	.skip	88
	.size	pty, 88


	.ident	"clang version 4.0.0 "
