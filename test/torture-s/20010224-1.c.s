	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010224-1.c"
	.section	.text.ba_compute_psd,"ax",@progbits
	.hidden	ba_compute_psd
	.globl	ba_compute_psd
	.type	ba_compute_psd,@function
ba_compute_psd:                         # @ba_compute_psd
	.param  	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, 1
	i32.shl 	$push22=, $0, $pop23
	tee_local	$push21=, $4=, $pop22
	i32.const	$push1=, masktab
	i32.add 	$push2=, $pop21, $pop1
	i32.load16_s	$push3=, 0($pop2)
	i32.const	$push20=, 1
	i32.shl 	$push4=, $pop3, $pop20
	i32.const	$push5=, bndpsd
	i32.add 	$push19=, $pop4, $pop5
	tee_local	$push18=, $1=, $pop19
	i32.const	$push17=, psd
	i32.add 	$push6=, $4, $pop17
	i32.load16_u	$push16=, 0($pop6)
	tee_local	$push15=, $4=, $pop16
	i32.store16	0($pop18), $pop15
	block   	
	i32.const	$push14=, 1
	i32.add 	$push13=, $0, $pop14
	tee_local	$push12=, $2=, $pop13
	i32.const	$push11=, 3
	i32.gt_s	$push7=, $pop12, $pop11
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push26=, 3
	i32.sub 	$3=, $pop26, $0
	i32.const	$push25=, 1
	i32.shl 	$push8=, $2, $pop25
	i32.const	$push24=, psd
	i32.add 	$0=, $pop8, $pop24
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load16_u	$push10=, 0($0)
	i32.const	$push31=, 65535
	i32.and 	$push9=, $4, $pop31
	i32.add 	$4=, $pop10, $pop9
	i32.const	$push30=, 2
	i32.add 	$push0=, $0, $pop30
	copy_local	$0=, $pop0
	i32.const	$push29=, -1
	i32.add 	$push28=, $3, $pop29
	tee_local	$push27=, $3=, $pop28
	br_if   	0, $pop27       # 0: up to label1
# BB#3:                                 # %for.cond.for.end_crit_edge
	end_loop
	i32.store16	0($1), $4
.LBB0_4:                                # %for.end
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	ba_compute_psd, .Lfunc_end0-ba_compute_psd

	.section	.text.logadd,"ax",@progbits
	.hidden	logadd
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

	.section	.text.main,"ax",@progbits
	.hidden	main
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
	i32.load16_u	$push10=, psd+6($pop19)
	i32.const	$push18=, 0
	i32.load16_u	$push8=, psd+4($pop18)
	i32.const	$push17=, 0
	i32.load16_u	$push6=, psd+2($pop17)
	i32.const	$push16=, 0
	i32.load16_u	$push5=, psd($pop16)
	i32.add 	$push7=, $pop6, $pop5
	i32.add 	$push9=, $pop8, $pop7
	i32.add 	$push11=, $pop10, $pop9
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
