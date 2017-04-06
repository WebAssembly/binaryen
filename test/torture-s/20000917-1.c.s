	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000917-1.c"
	.section	.text.one,"ax",@progbits
	.hidden	one
	.globl	one
	.type	one,@function
one:                                    # @one
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.store	8($0), $pop0
	i64.const	$push1=, 4294967297
	i64.store	0($0):p2align=2, $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	one, .Lfunc_end0-one

	.section	.text.zero,"ax",@progbits
	.hidden	zero
	.globl	zero
	.type	zero,@function
zero:                                   # @zero
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	8($0), $pop0
	i64.const	$push1=, 0
	i64.store	0($0):p2align=2, $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	zero, .Lfunc_end1-zero

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	exit, void, i32
