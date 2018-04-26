	.text
	.file	"20020418-1.c"
	.section	.text.gcc_crash,"ax",@progbits
	.hidden	gcc_crash               # -- Begin function gcc_crash
	.globl	gcc_crash
	.type	gcc_crash,@function
gcc_crash:                              # @gcc_crash
	.param  	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.load	$2=, 0($0)
	block   	
	i32.const	$push0=, 51
	i32.le_s	$push1=, $2, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push2=, 60
	i32.gt_s	$1=, $2, $pop2
.LBB0_2:                                # %top
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push3=, 1
	i32.add 	$2=, $2, $pop3
	br_if   	0, $1           # 0: up to label1
# %bb.3:                                # %if.end6
	end_loop
	i32.store	0($0), $2
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	unreachable
	unreachable
	.endfunc
.Lfunc_end0:
	.size	gcc_crash, .Lfunc_end0-gcc_crash
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %gcc_crash.exit
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
