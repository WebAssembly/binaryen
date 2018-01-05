	.text
	.file	"951115-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	var($pop1), $pop0
	copy_local	$push2=, $0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	var($pop1), $pop0
	copy_local	$push2=, $0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	var($pop1), $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	var                     # @var
	.type	var,@object
	.section	.bss.var,"aw",@nobits
	.globl	var
	.p2align	2
var:
	.int32	0                       # 0x0
	.size	var, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
