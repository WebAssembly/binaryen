	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010224-1.c"
	.section	.text.ba_compute_psd,"ax",@progbits
	.hidden	ba_compute_psd
	.globl	ba_compute_psd
	.type	ba_compute_psd,@function
ba_compute_psd:                         # @ba_compute_psd
	.param  	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 1
	i32.shl 	$5=, $0, $4
	i32.const	$push4=, psd
	i32.add 	$2=, $pop4, $5
	i32.const	$push6=, bndpsd
	i32.const	$push1=, masktab
	i32.add 	$push2=, $pop1, $5
	i32.load16_s	$push3=, 0($pop2)
	i32.shl 	$push5=, $pop3, $4
	i32.add 	$1=, $pop6, $pop5
	i32.load16_u	$push0=, 0($2)
	i32.store16	$5=, 0($1), $pop0
	i32.const	$3=, 3
	block
	i32.add 	$push7=, $0, $4
	i32.gt_s	$push8=, $pop7, $3
	br_if   	$pop8, 0        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.sub 	$4=, $3, $0
	i32.const	$3=, 2
	i32.add 	$0=, $2, $3
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load16_u	$push11=, 0($0)
	i32.const	$push9=, 65535
	i32.and 	$push10=, $5, $pop9
	i32.add 	$5=, $pop11, $pop10
	i32.const	$push12=, -1
	i32.add 	$4=, $4, $pop12
	i32.add 	$0=, $0, $3
	br_if   	$4, 0           # 0: up to label1
# BB#3:                                 # %for.cond.for.end_crit_edge
	end_loop                        # label2:
	i32.store16	$discard=, 0($1), $5
.LBB0_4:                                # %for.end
	end_block                       # label0:
	return
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 16
	i32.load16_u	$push1=, 0($1)
	i32.load16_u	$push0=, 0($0)
	i32.add 	$push2=, $pop1, $pop0
	i32.shl 	$push3=, $pop2, $2
	i32.shr_s	$push4=, $pop3, $2
	return  	$pop4
	.endfunc
.Lfunc_end1:
	.size	logadd, .Lfunc_end1-logadd

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.const	$push3=, bndpsd
	i32.load16_s	$push0=, masktab($0)
	i32.const	$push1=, 1
	i32.shl 	$push2=, $pop0, $pop1
	i32.add 	$push4=, $pop3, $pop2
	i32.load16_u	$push10=, psd+6($0)
	i32.load16_u	$push8=, psd+4($0)
	i32.load16_u	$push6=, psd+2($0)
	i32.load16_u	$push5=, psd($0)
	i32.add 	$push7=, $pop6, $pop5
	i32.add 	$push9=, $pop8, $pop7
	i32.add 	$push11=, $pop10, $pop9
	i32.store16	$discard=, 0($pop4), $pop11
	i32.load16_u	$push12=, bndpsd+2($0)
	i32.const	$push13=, 140
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	$pop14, 0       # 0: down to label3
# BB#1:                                 # %if.end
	return  	$0
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
	.align	1
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
	.align	1
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
	.align	1
bndpsd:
	.int16	1                       # 0x1
	.int16	2                       # 0x2
	.int16	3                       # 0x3
	.int16	4                       # 0x4
	.int16	5                       # 0x5
	.int16	0                       # 0x0
	.size	bndpsd, 12


	.ident	"clang version 3.9.0 "
