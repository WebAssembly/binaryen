	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-cpy-1.c"
	.section	.text.ini,"ax",@progbits
	.hidden	ini
	.globl	ini
	.type	ini,@function
ini:                                    # @ini
# BB#0:                                 # %entry
	i32.const	$push2=, pty+40
	i32.const	$push1=, 0
	i32.const	$push0=, 44
	i32.call	$drop=, memset@FUNCTION, $pop2, $pop1, $pop0
	i32.const	$push6=, 0
	i64.const	$push3=, 8589934593
	i64.store	$drop=, pty+40($pop6), $pop3
	i32.const	$push5=, 0
	i64.const	$push4=, 17179869187
	i64.store	$drop=, pty+48($pop5), $pop4
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
	i32.const	$push2=, pty+40
	i32.const	$push1=, 0
	i32.const	$push0=, 44
	i32.call	$drop=, memset@FUNCTION, $pop2, $pop1, $pop0
	i32.const	$push7=, 0
	i64.const	$push3=, 8589934593
	i64.store	$drop=, pty+40($pop7), $pop3
	i32.const	$push6=, 0
	i64.const	$push4=, 17179869187
	i64.store	$drop=, pty+48($pop6), $pop4
	i32.const	$push5=, 0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	pty,@object             # @pty
	.lcomm	pty,88,3

	.ident	"clang version 3.9.0 "
