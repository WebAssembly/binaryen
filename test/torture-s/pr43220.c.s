	.text
	.file	"pr43220.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push14=, 0
	i32.load	$5=, __stack_pointer($pop14)
	copy_local	$drop=, $5
	i32.const	$3=, 0
	i32.const	$4=, 0
.LBB0_1:                                # %lab
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push32=, 1000
	i32.div_u	$0=, $4, $pop32
	i32.const	$push31=, 1000
	i32.mul 	$push0=, $0, $pop31
	i32.sub 	$push1=, $4, $pop0
	i32.const	$push30=, 2
	i32.shl 	$1=, $pop1, $pop30
	i32.const	$push29=, 19
	i32.add 	$push2=, $1, $pop29
	i32.const	$push28=, -16
	i32.and 	$push3=, $pop2, $pop28
	i32.sub 	$2=, $5, $pop3
	copy_local	$drop=, $2
	i32.const	$push27=, 1
	i32.store	0($2), $pop27
	i32.const	$push26=, 0
	i32.store	p($pop26), $2
	i32.const	$push25=, 4000
	i32.mul 	$push5=, $0, $pop25
	i32.sub 	$0=, $3, $pop5
	i32.add 	$push6=, $2, $0
	i32.const	$push24=, 2
	i32.store	0($pop6), $pop24
	copy_local	$push4=, $5
	copy_local	$5=, $pop4
	i32.const	$push23=, 23
	i32.add 	$push7=, $1, $pop23
	i32.const	$push22=, -16
	i32.and 	$push8=, $pop7, $pop22
	i32.sub 	$2=, $5, $pop8
	copy_local	$drop=, $2
	i32.const	$push21=, 1
	i32.store	0($2), $pop21
	i32.const	$push20=, 0
	i32.store	p($pop20), $2
	i32.add 	$push10=, $2, $0
	i32.const	$push19=, 4
	i32.add 	$push11=, $pop10, $pop19
	i32.const	$push18=, 2
	i32.store	0($pop11), $pop18
	i32.const	$push17=, 8
	i32.add 	$3=, $3, $pop17
	i32.const	$push16=, 2
	i32.add 	$4=, $4, $pop16
	copy_local	$push9=, $5
	copy_local	$5=, $pop9
	i32.const	$push15=, 1000000
	i32.lt_u	$push12=, $4, $pop15
	br_if   	0, $pop12       # 0: up to label0
# %bb.2:                                # %if.end
	end_loop
	i32.const	$push13=, 0
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
