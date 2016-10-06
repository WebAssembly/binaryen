	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000917-1.c"
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
