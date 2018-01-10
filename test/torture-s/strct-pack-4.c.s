	.text
	.file	"strct-pack-4.c"
	.section	.text.my_set_a,"ax",@progbits
	.hidden	my_set_a                # -- Begin function my_set_a
	.globl	my_set_a
	.type	my_set_a,@function
my_set_a:                               # @my_set_a
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 171
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	my_set_a, .Lfunc_end0-my_set_a
                                        # -- End function
	.section	.text.my_set_b,"ax",@progbits
	.hidden	my_set_b                # -- Begin function my_set_b
	.globl	my_set_b
	.type	my_set_b,@function
my_set_b:                               # @my_set_b
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 4660
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	my_set_b, .Lfunc_end1-my_set_b
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
