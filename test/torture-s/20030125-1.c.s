	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030125-1.c"
	.section	.text.t,"ax",@progbits
	.hidden	t
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

	.section	.text.sin,"ax",@progbits
	.hidden	sin
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

	.section	.text.q,"ax",@progbits
	.hidden	q
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

	.section	.text.floor,"ax",@progbits
	.hidden	floor
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

	.section	.text.q1,"ax",@progbits
	.hidden	q1
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

	.section	.text.main,"ax",@progbits
	.hidden	main
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

	.section	.text.floorf,"ax",@progbits
	.hidden	floorf
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

	.section	.text.sinf,"ax",@progbits
	.hidden	sinf
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
