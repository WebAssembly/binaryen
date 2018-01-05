	.text
	.file	"divconst-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -2147483648
	i32.eq  	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.r,"ax",@progbits
	.hidden	r                       # -- Begin function r
	.globl	r
	.type	r,@function
r:                                      # @r
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -2147483648
	i32.rem_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	r, .Lfunc_end1-r
                                        # -- End function
	.section	.text.std_eqn,"ax",@progbits
	.hidden	std_eqn                 # -- Begin function std_eqn
	.globl	std_eqn
	.type	std_eqn,@function
std_eqn:                                # @std_eqn
	.param  	i32, i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 31
	i32.shl 	$push1=, $2, $pop0
	i32.add 	$push2=, $pop1, $3
	i32.eq  	$push3=, $pop2, $0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end2:
	.size	std_eqn, .Lfunc_end2-std_eqn
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push20=, 0
	i32.load	$0=, nums($pop20)
	block   	
	i32.const	$push19=, -2147483648
	i32.eq  	$push1=, $0, $pop19
	i32.const	$push18=, 31
	i32.shl 	$push2=, $pop1, $pop18
	i32.const	$push17=, -2147483648
	i32.rem_s	$push0=, $0, $pop17
	i32.add 	$push3=, $pop2, $pop0
	i32.ne  	$push4=, $pop3, $0
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %for.cond
	i32.const	$push24=, 0
	i32.load	$0=, nums+4($pop24)
	i32.const	$push23=, -2147483648
	i32.eq  	$push6=, $0, $pop23
	i32.const	$push22=, 31
	i32.shl 	$push7=, $pop6, $pop22
	i32.const	$push21=, -2147483648
	i32.rem_s	$push5=, $0, $pop21
	i32.add 	$push8=, $pop7, $pop5
	i32.ne  	$push9=, $pop8, $0
	br_if   	0, $pop9        # 0: down to label0
# %bb.2:                                # %for.cond.1
	i32.const	$push26=, 0
	i32.load	$0=, nums+8($pop26)
	i32.const	$push10=, -2147483648
	i32.eq  	$push12=, $0, $pop10
	i32.const	$push13=, 31
	i32.shl 	$push14=, $pop12, $pop13
	i32.const	$push25=, -2147483648
	i32.rem_s	$push11=, $0, $pop25
	i32.add 	$push15=, $pop14, $pop11
	i32.ne  	$push16=, $pop15, $0
	br_if   	0, $pop16       # 0: down to label0
# %bb.3:                                # %for.cond.2
	i32.const	$push27=, 0
	call    	exit@FUNCTION, $pop27
	unreachable
.LBB3_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.hidden	nums                    # @nums
	.type	nums,@object
	.section	.data.nums,"aw",@progbits
	.globl	nums
	.p2align	2
nums:
	.int32	4294967295              # 0xffffffff
	.int32	2147483647              # 0x7fffffff
	.int32	2147483648              # 0x80000000
	.size	nums, 12


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
