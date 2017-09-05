	.text
	.file	"20010224-1.c"
	.section	.text.ba_compute_psd,"ax",@progbits
	.hidden	ba_compute_psd          # -- Begin function ba_compute_psd
	.globl	ba_compute_psd
	.type	ba_compute_psd,@function
ba_compute_psd:                         # @ba_compute_psd
	.param  	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push22=, 1
	i32.shl 	$push21=, $0, $pop22
	tee_local	$push20=, $2=, $pop21
	i32.const	$push1=, masktab
	i32.add 	$push2=, $pop20, $pop1
	i32.load16_s	$push3=, 0($pop2)
	i32.const	$push19=, 1
	i32.shl 	$push4=, $pop3, $pop19
	i32.const	$push5=, bndpsd
	i32.add 	$push18=, $pop4, $pop5
	tee_local	$push17=, $1=, $pop18
	i32.const	$push6=, psd
	i32.add 	$push7=, $2, $pop6
	i32.load16_u	$push16=, 0($pop7)
	tee_local	$push15=, $4=, $pop16
	i32.store16	0($pop17), $pop15
	block   	
	i32.const	$push14=, 2
	i32.gt_s	$push8=, $0, $pop14
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push9=, -1
	i32.add 	$3=, $0, $pop9
	i32.const	$push10=, psd+2
	i32.add 	$0=, $2, $pop10
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load16_u	$push12=, 0($0)
	i32.const	$push28=, 65535
	i32.and 	$push11=, $4, $pop28
	i32.add 	$4=, $pop12, $pop11
	i32.const	$push27=, 2
	i32.add 	$push0=, $0, $pop27
	copy_local	$0=, $pop0
	i32.const	$push26=, 1
	i32.add 	$push25=, $3, $pop26
	tee_local	$push24=, $3=, $pop25
	i32.const	$push23=, 2
	i32.lt_s	$push13=, $pop24, $pop23
	br_if   	0, $pop13       # 0: up to label1
# BB#3:                                 # %for.cond.for.end_crit_edge
	end_loop
	i32.store16	0($1), $4
.LBB0_4:                                # %for.end
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	ba_compute_psd, .Lfunc_end0-ba_compute_psd
                                        # -- End function
	.section	.text.logadd,"ax",@progbits
	.hidden	logadd                  # -- Begin function logadd
	.globl	logadd
	.type	logadd,@function
logadd:                                 # @logadd
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load16_u	$push1=, 0($1)
	i32.load16_u	$push0=, 0($0)
	i32.add 	$push2=, $pop1, $pop0
	i32.const	$push3=, 16
	i32.shl 	$push4=, $pop2, $pop3
	i32.const	$push6=, 16
	i32.shr_s	$push5=, $pop4, $pop6
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end1:
	.size	logadd, .Lfunc_end1-logadd
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.load16_s	$push0=, masktab($pop20)
	i32.const	$push1=, 1
	i32.shl 	$push2=, $pop0, $pop1
	i32.const	$push3=, bndpsd
	i32.add 	$push4=, $pop2, $pop3
	i32.const	$push19=, 0
	i32.load16_u	$push6=, psd+2($pop19)
	i32.const	$push18=, 0
	i32.load16_u	$push5=, psd($pop18)
	i32.add 	$push7=, $pop6, $pop5
	i32.const	$push17=, 0
	i32.load16_u	$push8=, psd+4($pop17)
	i32.add 	$push9=, $pop7, $pop8
	i32.const	$push16=, 0
	i32.load16_u	$push10=, psd+6($pop16)
	i32.add 	$push11=, $pop9, $pop10
	i32.store16	0($pop4), $pop11
	block   	
	i32.const	$push15=, 0
	i32.load16_u	$push12=, bndpsd+2($pop15)
	i32.const	$push13=, 140
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push21=, 0
	return  	$pop21
.LBB2_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	masktab                 # @masktab
	.type	masktab,@object
	.section	.data.masktab,"aw",@progbits
	.globl	masktab
	.p2align	1
masktab:
	.int16	1                       # 0x1
	.int16	2                       # 0x2
	.int16	3                       # 0x3
	.int16	4                       # 0x4
	.int16	5                       # 0x5
	.int16	0                       # 0x0
	.size	masktab, 12

	.hidden	psd                     # @psd
	.type	psd,@object
	.section	.data.psd,"aw",@progbits
	.globl	psd
	.p2align	1
psd:
	.int16	50                      # 0x32
	.int16	40                      # 0x28
	.int16	30                      # 0x1e
	.int16	20                      # 0x14
	.int16	10                      # 0xa
	.int16	0                       # 0x0
	.size	psd, 12

	.hidden	bndpsd                  # @bndpsd
	.type	bndpsd,@object
	.section	.data.bndpsd,"aw",@progbits
	.globl	bndpsd
	.p2align	1
bndpsd:
	.int16	1                       # 0x1
	.int16	2                       # 0x2
	.int16	3                       # 0x3
	.int16	4                       # 0x4
	.int16	5                       # 0x5
	.int16	0                       # 0x0
	.size	bndpsd, 12


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
