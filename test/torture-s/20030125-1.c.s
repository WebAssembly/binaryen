	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030125-1.c"
	.globl	t
	.type	t,@function
t:                                      # @t
	.param  	f32
	.result 	f32
# BB#0:                                 # %entry
	f64.promote/f32	$push0=, $0
	f64.call	$push1=, sin, $pop0
	f32.demote/f64	$push2=, $pop1
	return  	$pop2
.Lfunc_end0:
	.size	t, .Lfunc_end0-t

	.globl	sin
	.type	sin,@function
sin:                                    # @sin
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	return  	$0
.Lfunc_end1:
	.size	sin, .Lfunc_end1-sin

	.globl	q
	.type	q,@function
q:                                      # @q
	.param  	f32
	.result 	f32
	.local  	f32
# BB#0:                                 # %entry
	return  	$1
.Lfunc_end2:
	.size	q, .Lfunc_end2-q

	.globl	floor
	.type	floor,@function
floor:                                  # @floor
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	call    	abort
	unreachable
.Lfunc_end3:
	.size	floor, .Lfunc_end3-floor

	.globl	q1
	.type	q1,@function
q1:                                     # @q1
	.param  	f32
	.result 	f64
	.local  	f64
# BB#0:                                 # %entry
	return  	$1
.Lfunc_end4:
	.size	q1, .Lfunc_end4-q1

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	call    	abort
	unreachable
.Lfunc_end5:
	.size	main, .Lfunc_end5-main

	.globl	floorf
	.type	floorf,@function
floorf:                                 # @floorf
	.param  	f32
	.result 	f32
# BB#0:                                 # %entry
	return  	$0
.Lfunc_end6:
	.size	floorf, .Lfunc_end6-floorf

	.globl	sinf
	.type	sinf,@function
sinf:                                   # @sinf
	.param  	f32
	.result 	f32
# BB#0:                                 # %entry
	call    	abort
	unreachable
.Lfunc_end7:
	.size	sinf, .Lfunc_end7-sinf


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
