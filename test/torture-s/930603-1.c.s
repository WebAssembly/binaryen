	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/930603-1.c"
	.globl	fx
	.type	fx,@function
fx:                                     # @fx
	.param  	f64
	.result 	f32
# BB#0:                                 # %entry
	f64.const	$push4=, 0x1.8p1
	f32.demote/f64	$push0=, $0
	f64.promote/f32	$push1=, $pop0
	f64.const	$push2=, 0x1.26bb1bbb58975p1
	f64.mul 	$push3=, $pop1, $pop2
	f64.div 	$push5=, $pop4, $pop3
	f64.const	$push6=, 0x1p0
	f64.add 	$push7=, $pop5, $pop6
	f32.demote/f64	$push8=, $pop7
	return  	$pop8
.Lfunc_end0:
	.size	fx, .Lfunc_end0-fx

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.globl	inita
	.type	inita,@function
inita:                                  # @inita
	.result 	f32
# BB#0:                                 # %entry
	f32.const	$push0=, 0x1.8p1
	return  	$pop0
.Lfunc_end2:
	.size	inita, .Lfunc_end2-inita

	.globl	initc
	.type	initc,@function
initc:                                  # @initc
	.result 	f32
# BB#0:                                 # %entry
	f32.const	$push0=, 0x1p2
	return  	$pop0
.Lfunc_end3:
	.size	initc, .Lfunc_end3-initc

	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$0
.Lfunc_end4:
	.size	f, .Lfunc_end4-f


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
