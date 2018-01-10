	.text
	.file	"vla-dealloc-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push10=, 0
	i32.load	$6=, __stack_pointer($pop10)
	copy_local	$drop=, $6
	i32.const	$2=, 1000000
	i32.const	$3=, 0
	i32.const	$4=, 1
	i32.const	$5=, 0
.LBB0_1:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push23=, 1000
	i32.div_u	$0=, $5, $pop23
	i32.const	$push22=, 1000
	i32.mul 	$push0=, $0, $pop22
	i32.sub 	$push1=, $4, $pop0
	i32.const	$push21=, 2
	i32.shl 	$push2=, $pop1, $pop21
	i32.const	$push20=, 15
	i32.add 	$push3=, $pop2, $pop20
	i32.const	$push19=, -16
	i32.and 	$push4=, $pop3, $pop19
	i32.sub 	$1=, $6, $pop4
	copy_local	$drop=, $1
	i32.const	$push18=, 1
	i32.store	0($1), $pop18
	i32.const	$push17=, 0
	i32.store	p($pop17), $1
	i32.const	$push16=, 4000
	i32.mul 	$push6=, $0, $pop16
	i32.sub 	$push7=, $3, $pop6
	i32.add 	$push8=, $1, $pop7
	i32.const	$push15=, 2
	i32.store	0($pop8), $pop15
	i32.const	$push14=, -1
	i32.add 	$2=, $2, $pop14
	i32.const	$push13=, 4
	i32.add 	$3=, $3, $pop13
	i32.const	$push12=, 1
	i32.add 	$4=, $4, $pop12
	i32.const	$push11=, 1
	i32.add 	$5=, $5, $pop11
	copy_local	$push5=, $6
	copy_local	$6=, $pop5
	br_if   	0, $2           # 0: up to label0
# %bb.2:                                # %cleanup5
	end_loop
	i32.const	$push9=, 0
                                        # fallthrough-return: $pop9
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
