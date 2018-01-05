	.text
	.file	"931004-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 10
	i32.ne  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push2=, 11
	i32.ne  	$push3=, $2, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.2:                                # %if.end6
	i32.const	$push4=, 12
	i32.ne  	$push5=, $3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.3:                                # %if.end10
	i32.const	$push6=, 123
	i32.ne  	$push7=, $4, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.4:                                # %if.end13
	return  	$2
.LBB0_5:                                # %if.then
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
# %bb.0:                                # %entry
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
