	.text
	.file	"20030125-1.c"
	.section	.text.t,"ax",@progbits
	.hidden	t                       # -- Begin function t
	.globl	t
	.type	t,@function
t:                                      # @t
	.param  	f32
	.result 	f32
# BB#0:                                 # %entry
	f64.promote/f32	$push0=, $0
	f64.call	$push1=, sin@FUNCTION, $pop0
	f32.demote/f64	$push2=, $pop1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	t, .Lfunc_end0-t
                                        # -- End function
	.section	.text.sin,"ax",@progbits
	.hidden	sin                     # -- Begin function sin
	.globl	sin
	.type	sin,@function
sin:                                    # @sin
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	sin, .Lfunc_end1-sin
                                        # -- End function
	.section	.text.q,"ax",@progbits
	.hidden	q                       # -- Begin function q
	.globl	q
	.type	q,@function
q:                                      # @q
	.param  	f32
	.result 	f32
	.local  	f32
# BB#0:                                 # %entry
	copy_local	$push0=, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	q, .Lfunc_end2-q
                                        # -- End function
	.section	.text.floor,"ax",@progbits
	.hidden	floor                   # -- Begin function floor
	.globl	floor
	.type	floor,@function
floor:                                  # @floor
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	floor, .Lfunc_end3-floor
                                        # -- End function
	.section	.text.q1,"ax",@progbits
	.hidden	q1                      # -- Begin function q1
	.globl	q1
	.type	q1,@function
q1:                                     # @q1
	.param  	f32
	.result 	f64
	.local  	f64
# BB#0:                                 # %entry
	copy_local	$push0=, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	q1, .Lfunc_end4-q1
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	main, .Lfunc_end5-main
                                        # -- End function
	.section	.text.floorf,"ax",@progbits
	.hidden	floorf                  # -- Begin function floorf
	.globl	floorf
	.type	floorf,@function
floorf:                                 # @floorf
	.param  	f32
	.result 	f32
# BB#0:                                 # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end6:
	.size	floorf, .Lfunc_end6-floorf
                                        # -- End function
	.section	.text.sinf,"ax",@progbits
	.hidden	sinf                    # -- Begin function sinf
	.globl	sinf
	.type	sinf,@function
sinf:                                   # @sinf
	.param  	f32
	.result 	f32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	sinf, .Lfunc_end7-sinf
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
