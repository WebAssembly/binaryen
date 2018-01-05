	.text
	.file	"20001031-1.c"
	.section	.text.t1,"ax",@progbits
	.hidden	t1                      # -- Begin function t1
	.globl	t1
	.type	t1,@function
t1:                                     # @t1
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 4100
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	t1, .Lfunc_end0-t1
                                        # -- End function
	.section	.text.t2,"ax",@progbits
	.hidden	t2                      # -- Begin function t2
	.globl	t2
	.type	t2,@function
t2:                                     # @t2
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 4096
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	t2, .Lfunc_end1-t2
                                        # -- End function
	.section	.text.t3,"ax",@progbits
	.hidden	t3                      # -- Begin function t3
	.globl	t3
	.type	t3,@function
t3:                                     # @t3
	.param  	i64
# %bb.0:                                # %entry
	block   	
	i64.const	$push0=, 2147487743
	i64.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %if.end
	return
.LBB2_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	t3, .Lfunc_end2-t3
                                        # -- End function
	.section	.text.t4,"ax",@progbits
	.hidden	t4                      # -- Begin function t4
	.globl	t4
	.type	t4,@function
t4:                                     # @t4
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push0=, 4096
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	t4, .Lfunc_end3-t4
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
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
