	.text
	.file	"int-compare.c"
	.section	.text.gt,"ax",@progbits
	.hidden	gt                      # -- Begin function gt
	.globl	gt
	.type	gt,@function
gt:                                     # @gt
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.gt_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	gt, .Lfunc_end0-gt
                                        # -- End function
	.section	.text.ge,"ax",@progbits
	.hidden	ge                      # -- Begin function ge
	.globl	ge
	.type	ge,@function
ge:                                     # @ge
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.ge_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	ge, .Lfunc_end1-ge
                                        # -- End function
	.section	.text.lt,"ax",@progbits
	.hidden	lt                      # -- Begin function lt
	.globl	lt
	.type	lt,@function
lt:                                     # @lt
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.lt_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	lt, .Lfunc_end2-lt
                                        # -- End function
	.section	.text.le,"ax",@progbits
	.hidden	le                      # -- Begin function le
	.globl	le
	.type	le,@function
le:                                     # @le
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.le_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	le, .Lfunc_end3-le
                                        # -- End function
	.section	.text.true,"ax",@progbits
	.hidden	true                    # -- Begin function true
	.globl	true
	.type	true,@function
true:                                   # @true
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push0=, $0
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB4_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	true, .Lfunc_end4-true
                                        # -- End function
	.section	.text.false,"ax",@progbits
	.hidden	false                   # -- Begin function false
	.globl	false
	.type	false,@function
false:                                  # @false
	.param  	i32
# %bb.0:                                # %entry
	block   	
	br_if   	0, $0           # 0: down to label1
# %bb.1:                                # %if.end
	return
.LBB5_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	false, .Lfunc_end5-false
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# %bb.0:                                # %true.exit
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end6:
	.size	f, .Lfunc_end6-f
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
.Lfunc_end7:
	.size	main, .Lfunc_end7-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
