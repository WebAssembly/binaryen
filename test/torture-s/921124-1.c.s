	.text
	.file	"921124-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, f64, f64, f64
	.result 	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32, f64, f64, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	f64.const	$push0=, 0x1p0
	f64.ne  	$push1=, $2, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %entry
	f64.const	$push2=, 0x1p1
	f64.ne  	$push3=, $3, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.2:                                # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $4, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.3:                                # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.4:                                # %if.end
	return  	$4
.LBB1_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	g, .Lfunc_end1-g
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %g.exit
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
