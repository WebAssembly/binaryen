	.text
	.file	"pr56899.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, -214748365
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push2=, 2147483646
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 214748365
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push2=, 2147483646
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %if.end
	return
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, -214748365
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push2=, 2147483646
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label2
# %bb.1:                                # %if.end
	return
.LBB2_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3
                                        # -- End function
	.section	.text.f4,"ax",@progbits
	.hidden	f4                      # -- Begin function f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 214748365
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push2=, 2147483646
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label3
# %bb.1:                                # %if.end
	return
.LBB3_2:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	f4, .Lfunc_end3-f4
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 10
	call    	f1@FUNCTION, $pop0
	i32.const	$push1=, -10
	call    	f2@FUNCTION, $pop1
	i32.const	$push4=, 10
	call    	f3@FUNCTION, $pop4
	i32.const	$push3=, -10
	call    	f4@FUNCTION, $pop3
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
