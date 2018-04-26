	.text
	.file	"pr48814-2.c"
	.section	.text.incr,"ax",@progbits
	.hidden	incr                    # -- Begin function incr
	.globl	incr
	.type	incr,@function
incr:                                   # @incr
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, count($pop0)
	i32.const	$push2=, 1
	i32.add 	$0=, $pop1, $pop2
	i32.const	$push3=, 0
	i32.store	count($pop3), $0
	copy_local	$push4=, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	incr, .Lfunc_end0-incr
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$1=, count($pop0)
	i32.const	$push13=, 2
	i32.add 	$0=, $1, $pop13
	i32.const	$push12=, 0
	i32.store	count($pop12), $0
	i32.const	$push1=, 1
	i32.add 	$2=, $1, $pop1
	i32.const	$push11=, 2
	i32.shl 	$push2=, $2, $pop11
	i32.const	$push10=, arr
	i32.add 	$push3=, $pop2, $pop10
	i32.store	0($pop3), $2
	block   	
	br_if   	0, $1           # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.const	$push15=, 2
	i32.shl 	$push4=, $0, $pop15
	i32.const	$push14=, arr
	i32.add 	$push5=, $pop4, $pop14
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 3
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.2:                                # %if.end
	i32.const	$push9=, 0
	return  	$pop9
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	arr                     # @arr
	.type	arr,@object
	.section	.data.arr,"aw",@progbits
	.globl	arr
	.p2align	4
arr:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.size	arr, 16

	.hidden	count                   # @count
	.type	count,@object
	.section	.bss.count,"aw",@nobits
	.globl	count
	.p2align	2
count:
	.int32	0                       # 0x0
	.size	count, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
