	.text
	.file	"pr49218.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i32
# %bb.0:                                # %entry
	i32.const	$push14=, 0
	i32.load	$push13=, __stack_pointer($pop14)
	i32.const	$push15=, 16
	i32.sub 	$3=, $pop13, $pop15
	i32.const	$push16=, 0
	i32.store	__stack_pointer($pop16), $3
	i32.const	$push21=, 0
	f32.load	$push0=, f($pop21)
	call    	__fixsfti@FUNCTION, $3, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $3, $pop1
	i64.load	$2=, 0($pop2)
	i64.load	$1=, 0($3)
	block   	
	i64.const	$push4=, 10
	i64.gt_u	$push5=, $1, $pop4
	i64.const	$push20=, 0
	i64.gt_s	$push3=, $2, $pop20
	i64.eqz 	$push6=, $2
	i32.select	$push7=, $pop5, $pop3, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.1:                                # %do.body.preheader
.LBB0_2:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i64.const	$push24=, 1
	i64.add 	$0=, $1, $pop24
	i64.lt_u	$push9=, $0, $1
	i64.extend_u/i32	$push10=, $pop9
	i64.add 	$2=, $2, $pop10
	#APP
	#NO_APP
	copy_local	$1=, $0
	i64.const	$push23=, 11
	i64.xor 	$push8=, $0, $pop23
	i64.or  	$push11=, $pop8, $2
	i64.const	$push22=, 0
	i64.ne  	$push12=, $pop11, $pop22
	br_if   	0, $pop12       # 0: up to label1
.LBB0_3:                                # %if.end
	end_loop
	end_block                       # label0:
	i32.const	$push19=, 0
	i32.const	$push17=, 16
	i32.add 	$push18=, $3, $pop17
	i32.store	__stack_pointer($pop19), $pop18
	i32.const	$push25=, 0
                                        # fallthrough-return: $pop25
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.int32	0                       # float 0
	.size	f, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
