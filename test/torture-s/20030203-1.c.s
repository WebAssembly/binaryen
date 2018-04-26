	.text
	.file	"20030203-1.c"
	.section	.text.do_layer3,"ax",@progbits
	.hidden	do_layer3               # -- Begin function do_layer3
	.globl	do_layer3
	.type	do_layer3,@function
do_layer3:                              # @do_layer3
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 31
	i32.shr_u	$push1=, $0, $pop0
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	do_layer3, .Lfunc_end0-do_layer3
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# %bb.0:                                # %entry
                                        # fallthrough-return
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
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
