	.text
	.file	"20071220-2.c"
	.section	.text.baz,"ax",@progbits
	.hidden	baz                     # -- Begin function baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	#APP
	#NO_APP
	i32.load	$push0=, 0($0)
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	baz, .Lfunc_end0-baz
                                        # -- End function
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.result 	i32
# %bb.0:                                # %entry
	i32.call	$drop=, bar@FUNCTION
	i32.const	$push0=, 17
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.type	bar,@function           # -- Begin function bar
bar:                                    # @bar
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, bar.b
	i32.call	$drop=, baz@FUNCTION, $pop0
.Ltmp0:                                 # Block address taken
# %bb.1:                                # %addr
	copy_local	$push1=, $0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.result 	i32
# %bb.0:                                # %entry
	i32.call	$drop=, bar@FUNCTION
	i32.const	$push0=, 17
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	f2, .Lfunc_end3-f2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.call	$drop=, f1@FUNCTION
	i32.call	$drop=, f1@FUNCTION
	i32.call	$drop=, f2@FUNCTION
	i32.call	$drop=, f2@FUNCTION
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function
	.type	bar.b,@object           # @bar.b
	.section	.data.bar.b,"aw",@progbits
	.p2align	2
bar.b:
	.int32	.Ltmp0
	.size	bar.b, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
