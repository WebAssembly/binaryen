	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930603-1.c"
	.section	.text.fx,"ax",@progbits
	.hidden	fx
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
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end0:
	.size	fx, .Lfunc_end0-fx

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.section	.text.inita,"ax",@progbits
	.hidden	inita
	.globl	inita
	.type	inita,@function
inita:                                  # @inita
	.result 	f32
# BB#0:                                 # %entry
	f32.const	$push0=, 0x1.8p1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	inita, .Lfunc_end2-inita

	.section	.text.initc,"ax",@progbits
	.hidden	initc
	.globl	initc
	.type	initc,@function
initc:                                  # @initc
	.result 	f32
# BB#0:                                 # %entry
	f32.const	$push0=, 0x1p2
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	initc, .Lfunc_end3-initc

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	f, .Lfunc_end4-f


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
