	.text
	.file	"930603-3.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$2=, 1
	block   	
	block   	
	i32.const	$push0=, 100
	i32.eq  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$push2=, 107
	i32.ne  	$push3=, $1, $pop2
	br_if   	1, $pop3        # 1: down to label0
# %bb.2:                                # %sw.bb3
	i32.const	$push4=, 3
	i32.add 	$0=, $0, $pop4
	i32.const	$2=, 4
.LBB0_3:                                # %sw.epilog
	end_block                       # label1:
	i32.load8_u	$push5=, 0($0)
	i32.shr_u	$push6=, $pop5, $2
	return  	$pop6
.LBB0_4:                                # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
