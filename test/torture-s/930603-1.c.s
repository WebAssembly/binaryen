	.text
	.file	"930603-1.c"
	.section	.text.fx,"ax",@progbits
	.hidden	fx                      # -- Begin function fx
	.globl	fx
	.type	fx,@function
fx:                                     # @fx
	.param  	f64
	.result 	f32
# %bb.0:                                # %entry
	f64.const	$push4=, 0x1.8p1
	f32.demote/f64	$push0=, $0
	f64.promote/f32	$push1=, $pop0
	f64.const	$push2=, 0x1.26bb1bbb58975p1
	f64.mul 	$push3=, $pop1, $pop2
	f64.div 	$push5=, $pop4, $pop3
	f64.const	$push6=, 0x1p0
	f64.add 	$push7=, $pop5, $pop6
	f32.demote/f64	$push8=, $pop7
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end0:
	.size	fx, .Lfunc_end0-fx
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.section	.text.inita,"ax",@progbits
	.hidden	inita                   # -- Begin function inita
	.globl	inita
	.type	inita,@function
inita:                                  # @inita
	.result 	f32
# %bb.0:                                # %entry
	f32.const	$push0=, 0x1.8p1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	inita, .Lfunc_end2-inita
                                        # -- End function
	.section	.text.initc,"ax",@progbits
	.hidden	initc                   # -- Begin function initc
	.globl	initc
	.type	initc,@function
initc:                                  # @initc
	.result 	f32
# %bb.0:                                # %entry
	f32.const	$push0=, 0x1p2
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	initc, .Lfunc_end3-initc
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	f, .Lfunc_end4-f
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
