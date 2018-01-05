	.text
	.file	"20030125-1.c"
	.section	.text.t,"ax",@progbits
	.hidden	t                       # -- Begin function t
	.globl	t
	.type	t,@function
t:                                      # @t
	.param  	f32
	.result 	f32
# %bb.0:                                # %entry
	f64.promote/f32	$push0=, $0
	f64.call	$push1=, sin@FUNCTION, $pop0
	f32.demote/f64	$push2=, $pop1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	t, .Lfunc_end0-t
                                        # -- End function
	.section	.text.q,"ax",@progbits
	.hidden	q                       # -- Begin function q
	.globl	q
	.type	q,@function
q:                                      # @q
	.param  	f32
	.result 	f32
# %bb.0:                                # %entry
	f32.floor	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	q, .Lfunc_end1-q
                                        # -- End function
	.section	.text.q1,"ax",@progbits
	.hidden	q1                      # -- Begin function q1
	.globl	q1
	.type	q1,@function
q1:                                     # @q1
	.param  	f32
	.result 	f64
# %bb.0:                                # %entry
	f32.floor	$push0=, $0
	f64.promote/f32	$push1=, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	q1, .Lfunc_end2-q1
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end8
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.section	.text.floor,"ax",@progbits
	.hidden	floor                   # -- Begin function floor
	.globl	floor
	.type	floor,@function
floor:                                  # @floor
	.param  	f64
	.result 	f64
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	floor, .Lfunc_end4-floor
                                        # -- End function
	.section	.text.floorf,"ax",@progbits
	.hidden	floorf                  # -- Begin function floorf
	.globl	floorf
	.type	floorf,@function
floorf:                                 # @floorf
	.param  	f32
	.result 	f32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end5:
	.size	floorf, .Lfunc_end5-floorf
                                        # -- End function
	.section	.text.sin,"ax",@progbits
	.hidden	sin                     # -- Begin function sin
	.globl	sin
	.type	sin,@function
sin:                                    # @sin
	.param  	f64
	.result 	f64
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end6:
	.size	sin, .Lfunc_end6-sin
                                        # -- End function
	.section	.text.sinf,"ax",@progbits
	.hidden	sinf                    # -- Begin function sinf
	.globl	sinf
	.type	sinf,@function
sinf:                                   # @sinf
	.param  	f32
	.result 	f32
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	sinf, .Lfunc_end7-sinf
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
