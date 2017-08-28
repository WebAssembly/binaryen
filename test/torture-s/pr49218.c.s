	.text
	.file	"pr49218.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push13=, 0
	i32.load	$push12=, __stack_pointer($pop13)
	i32.const	$push14=, 16
	i32.sub 	$push26=, $pop12, $pop14
	tee_local	$push25=, $4=, $pop26
	i32.store	__stack_pointer($pop15), $pop25
	i32.const	$push24=, 0
	f32.load	$push0=, f($pop24)
	call    	__fixsfti@FUNCTION, $4, $pop0
	block   	
	i64.load	$push23=, 0($4)
	tee_local	$push22=, $2=, $pop23
	i64.const	$push4=, 10
	i64.gt_u	$push5=, $pop22, $pop4
	i32.const	$push1=, 8
	i32.add 	$push2=, $4, $pop1
	i64.load	$push21=, 0($pop2)
	tee_local	$push20=, $3=, $pop21
	i64.const	$push19=, 0
	i64.gt_s	$push3=, $pop20, $pop19
	i64.eqz 	$push6=, $3
	i32.select	$push7=, $pop5, $pop3, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %do.body.preheader
.LBB0_2:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i64.const	$push33=, 1
	i64.add 	$push32=, $2, $pop33
	tee_local	$push31=, $0=, $pop32
	i64.lt_u	$1=, $pop31, $2
	#APP
	#NO_APP
	copy_local	$2=, $0
	i64.const	$push30=, 11
	i64.xor 	$push8=, $0, $pop30
	i64.extend_u/i32	$push9=, $1
	i64.add 	$push29=, $3, $pop9
	tee_local	$push28=, $3=, $pop29
	i64.or  	$push10=, $pop8, $pop28
	i64.const	$push27=, 0
	i64.ne  	$push11=, $pop10, $pop27
	br_if   	0, $pop11       # 0: up to label1
.LBB0_3:                                # %if.end
	end_loop
	end_block                       # label0:
	i32.const	$push18=, 0
	i32.const	$push16=, 16
	i32.add 	$push17=, $4, $pop16
	i32.store	__stack_pointer($pop18), $pop17
	i32.const	$push34=, 0
                                        # fallthrough-return: $pop34
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
