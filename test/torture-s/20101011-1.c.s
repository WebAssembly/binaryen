	.text
	.file	"20101011-1.c"
	.section	.text.sigfpe,"ax",@progbits
	.hidden	sigfpe                  # -- Begin function sigfpe
	.globl	sigfpe
	.type	sigfpe,@function
sigfpe:                                 # @sigfpe
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	sigfpe, .Lfunc_end0-sigfpe
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.const	$push0=, sigfpe@FUNCTION
	i32.call	$drop=, signal@FUNCTION, $pop1, $pop0
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	2
k:
	.int32	0                       # 0x0
	.size	k, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
	.functype	signal, i32, i32, i32
	.functype	abort, void
