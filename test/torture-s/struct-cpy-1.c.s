	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-cpy-1.c"
	.section	.text.ini,"ax",@progbits
	.hidden	ini
	.globl	ini
	.type	ini,@function
ini:                                    # @ini
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, pty+40
	i32.const	$push0=, zero_t
	i32.const	$push1=, 44
	call    	memcpy@FUNCTION, $pop2, $pop0, $pop1
	i32.const	$0=, 0
	i32.const	$push4=, 3
	i32.store	$discard=, pty+48($0), $pop4
	i32.const	$push5=, 4
	i32.store	$discard=, pty+52($0), $pop5
	i64.const	$push3=, 8589934593
	i64.store	$discard=, pty+40($0), $pop3
	return
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
	i32.const	$push2=, pty+40
	i32.const	$push0=, zero_t
	i32.const	$push1=, 44
	call    	memcpy@FUNCTION, $pop2, $pop0, $pop1
	i32.const	$0=, 0
	i32.const	$push4=, 3
	i32.store	$discard=, pty+48($0), $pop4
	i32.const	$push5=, 4
	i32.store	$discard=, pty+52($0), $pop5
	i64.const	$push3=, 8589934593
	i64.store	$discard=, pty+40($0), $pop3
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	pty,@object             # @pty
	.lcomm	pty,88,3
	.type	zero_t,@object          # @zero_t
	.section	.rodata.zero_t,"a",@progbits
	.align	2
zero_t:
	.skip	44
	.size	zero_t, 44


	.ident	"clang version 3.9.0 "
