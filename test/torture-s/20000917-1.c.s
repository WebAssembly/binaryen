	.text
	.file	"20000917-1.c"
	.section	.text.one,"ax",@progbits
	.hidden	one                     # -- Begin function one
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
                                        # -- End function
	.section	.text.zero,"ax",@progbits
	.hidden	zero                    # -- Begin function zero
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
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
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
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
