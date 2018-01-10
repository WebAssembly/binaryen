	.text
	.file	"dbra-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push2=, -1
	i32.const	$push0=, 10
	i32.lt_u	$push1=, $0, $pop0
	i32.select	$push3=, $0, $pop2, $pop1
                                        # fallthrough-return: $pop3
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
	.result 	i32
# %bb.0:                                # %entry
	i32.eqz 	$push0=, $0
                                        # fallthrough-return: $pop0
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
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -1
	i32.add 	$0=, $0, $pop0
	i32.const	$push4=, -1
	i32.const	$push1=, 10
	i32.lt_u	$push2=, $0, $pop1
	i32.select	$push3=, $0, $pop4, $pop2
                                        # fallthrough-return: $pop3
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
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	i32.eq  	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end3:
	.size	f4, .Lfunc_end3-f4
                                        # -- End function
	.section	.text.f5,"ax",@progbits
	.hidden	f5                      # -- Begin function f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, -10
	i32.lt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %switch.lookup
	i32.const	$push3=, -1
	i32.xor 	$push4=, $0, $pop3
	return  	$pop4
.LBB4_2:                                # %for.inc.9
	end_block                       # label0:
	i32.const	$push2=, -1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end4:
	.size	f5, .Lfunc_end4-f5
                                        # -- End function
	.section	.text.f6,"ax",@progbits
	.hidden	f6                      # -- Begin function f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -1
	i32.eq  	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end5:
	.size	f6, .Lfunc_end5-f6
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end32
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end6:
	.size	main, .Lfunc_end6-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
