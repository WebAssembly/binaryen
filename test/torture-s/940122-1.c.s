	.text
	.file	"940122-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 0
	i32.load	$push3=, a($pop0)
	i32.const	$push8=, 0
	i32.ne  	$push4=, $pop3, $pop8
	i32.const	$push7=, 0
	i32.load	$push1=, b($pop7)
	i32.const	$push6=, 0
	i32.ne  	$push2=, $pop1, $pop6
	i32.ne  	$push5=, $pop4, $pop2
	br_if   	0, $pop5        # 0: down to label0
# %bb.1:                                # %if.end
	return  	$1
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 0
	i32.load	$push3=, a($pop0)
	i32.const	$push8=, 0
	i32.ne  	$push4=, $pop3, $pop8
	i32.const	$push7=, 0
	i32.load	$push1=, b($pop7)
	i32.const	$push6=, 0
	i32.ne  	$push2=, $pop1, $pop6
	i32.ne  	$push5=, $pop4, $pop2
	br_if   	0, $pop5        # 0: down to label1
# %bb.1:                                # %g.exit
	return  	$1
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
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
# %bb.0:                                # %entry
	i32.const	$push0=, 100
	i32.call	$drop=, f@FUNCTION, $pop0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0
	.size	b, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
