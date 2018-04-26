	.text
	.file	"930719-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	br_if   	0, $0           # 0: down to label2
# %bb.1:                                # %if.end
	i32.const	$push0=, 1
	i32.ne  	$push1=, $1, $pop0
	br_if   	1, $pop1        # 1: down to label1
# %bb.2:                                # %sw.bb.split
	i32.eqz 	$push3=, $2
	br_if   	2, $pop3        # 2: down to label0
.LBB0_3:                                # %cleanup
	end_block                       # label2:
	i32.const	$push2=, 0
	return  	$pop2
.LBB0_4:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	end_block                       # label1:
	loop    	                # label3:
	br      	0               # 0: up to label3
.LBB0_5:                                # %if.end2
	end_loop
	end_block                       # label0:
	unreachable
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
	.functype	exit, void, i32
