	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010224-1.c"
	.section	.text.ba_compute_psd,"ax",@progbits
	.hidden	ba_compute_psd
	.globl	ba_compute_psd
	.type	ba_compute_psd,@function
ba_compute_psd:                         # @ba_compute_psd
	.param  	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, 1
	i32.shl 	$push18=, $0, $pop19
	tee_local	$push17=, $4=, $pop18
	i32.load16_s	$push1=, masktab($pop17)
	i32.const	$push16=, 1
	i32.shl 	$push15=, $pop1, $pop16
	tee_local	$push14=, $3=, $pop15
	i32.load16_u	$push13=, psd($4)
	tee_local	$push12=, $4=, $pop13
	i32.store16	$drop=, bndpsd($pop14), $pop12
	block
	i32.const	$push11=, 1
	i32.add 	$push10=, $0, $pop11
	tee_local	$push9=, $2=, $pop10
	i32.const	$push8=, 3
	i32.gt_s	$push3=, $pop9, $pop8
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push2=, bndpsd
	i32.add 	$1=, $3, $pop2
	i32.const	$push21=, 3
	i32.sub 	$3=, $pop21, $0
	i32.const	$push20=, 1
	i32.shl 	$push4=, $2, $pop20
	i32.const	$push5=, psd
	i32.add 	$0=, $pop4, $pop5
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load16_u	$push7=, 0($0)
	i32.const	$push26=, 65535
	i32.and 	$push6=, $4, $pop26
	i32.add 	$4=, $pop7, $pop6
	i32.const	$push25=, 2
	i32.add 	$push0=, $0, $pop25
	copy_local	$0=, $pop0
	i32.const	$push24=, -1
	i32.add 	$push23=, $3, $pop24
	tee_local	$push22=, $3=, $pop23
	br_if   	0, $pop22       # 0: up to label1
# BB#3:                                 # %for.cond.for.end_crit_edge
	end_loop                        # label2:
	i32.store16	$drop=, 0($1), $4
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
	i32.const	$push18=, 0
	i32.load16_s	$push0=, masktab($pop18)
	i32.const	$push1=, 1
	i32.shl 	$push2=, $pop0, $pop1
	i32.const	$push17=, 0
	i32.load16_u	$push8=, psd+6($pop17)
	i32.const	$push16=, 0
	i32.load16_u	$push6=, psd+4($pop16)
	i32.const	$push15=, 0
	i32.load16_u	$push4=, psd+2($pop15)
	i32.const	$push14=, 0
	i32.load16_u	$push3=, psd($pop14)
	i32.add 	$push5=, $pop4, $pop3
	i32.add 	$push7=, $pop6, $pop5
	i32.add 	$push9=, $pop8, $pop7
	i32.store16	$drop=, bndpsd($pop2), $pop9
	block
	i32.const	$push13=, 0
	i32.load16_u	$push10=, bndpsd+2($pop13)
	i32.const	$push11=, 140
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push19=, 0
	return  	$pop19
.LBB2_2:                                # %if.then
	end_block                       # label3:
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
