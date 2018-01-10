	.text
	.file	"20000605-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %for.body.lr.ph.i
	i32.const	$0=, 256
.LBB0_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push1=, -1
	i32.add 	$0=, $0, $pop1
	br_if   	0, $0           # 0: up to label0
# %bb.2:                                # %render_image_rgb_a.exit
	end_loop
	block   	
	br_if   	0, $0           # 0: down to label1
# %bb.3:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.LBB0_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
