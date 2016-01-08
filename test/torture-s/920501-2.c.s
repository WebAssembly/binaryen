	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920501-2.c"
	.section	.text.gcd_ll,"ax",@progbits
	.hidden	gcd_ll
	.globl	gcd_ll
	.type	gcd_ll,@function
gcd_ll:                                 # @gcd_ll
	.param  	i64, i64
	.result 	i32
	.local  	i64, i64
# BB#0:                                 # %entry
	i64.const	$2=, 0
	copy_local	$3=, $0
	block   	.LBB0_3
	i64.eq  	$push0=, $1, $2
	br_if   	$pop0, .LBB0_3
.LBB0_1:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_3
	i64.rem_u	$0=, $0, $1
	copy_local	$3=, $1
	i64.eq  	$push1=, $0, $2
	br_if   	$pop1, .LBB0_3
# BB#2:                                 # %if.end5
                                        #   in Loop: Header=BB0_1 Depth=1
	i64.rem_u	$1=, $1, $0
	copy_local	$3=, $0
	i64.ne  	$push2=, $1, $2
	br_if   	$pop2, .LBB0_1
.LBB0_3:                                # %return
	i32.wrap/i64	$push3=, $3
	return  	$pop3
.Lfunc_end0:
	.size	gcd_ll, .Lfunc_end0-gcd_ll

	.section	.text.powmod_ll,"ax",@progbits
	.hidden	powmod_ll
	.globl	powmod_ll
	.type	powmod_ll,@function
powmod_ll:                              # @powmod_ll
	.param  	i64, i32, i64
	.result 	i64
	.local  	i32, i32, i32, i64
# BB#0:                                 # %entry
	i64.const	$6=, 1
	i32.const	$4=, -1
	copy_local	$5=, $1
	block   	.LBB1_7
	i32.const	$push9=, 0
	i32.eq  	$push10=, $1, $pop9
	br_if   	$pop10, .LBB1_7
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_2
	i32.const	$3=, 1
	i32.shr_u	$5=, $5, $3
	i32.add 	$4=, $4, $3
	br_if   	$5, .LBB1_1
.LBB1_2:                                # %for.end
	copy_local	$6=, $0
	i32.lt_s	$push0=, $4, $3
	br_if   	$pop0, .LBB1_7
# BB#3:                                 # %for.body4.preheader
	i32.add 	$5=, $4, $3
	copy_local	$6=, $0
.LBB1_4:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_7
	block   	.LBB1_6
	i64.mul 	$push1=, $6, $6
	i64.rem_u	$6=, $pop1, $2
	i32.const	$push2=, -2
	i32.add 	$push3=, $5, $pop2
	i32.shl 	$push4=, $3, $pop3
	i32.and 	$push5=, $pop4, $1
	i32.const	$push11=, 0
	i32.eq  	$push12=, $pop5, $pop11
	br_if   	$pop12, .LBB1_6
# BB#5:                                 # %if.then5
                                        #   in Loop: Header=BB1_4 Depth=1
	i64.mul 	$push6=, $6, $0
	i64.rem_u	$6=, $pop6, $2
.LBB1_6:                                # %for.inc9
                                        #   in Loop: Header=BB1_4 Depth=1
	i32.const	$push7=, -1
	i32.add 	$5=, $5, $pop7
	i32.gt_s	$push8=, $5, $3
	br_if   	$pop8, .LBB1_4
.LBB1_7:                                # %cleanup
	return  	$6
.Lfunc_end1:
	.size	powmod_ll, .Lfunc_end1-powmod_ll

	.section	.text.facts,"ax",@progbits
	.hidden	facts
	.globl	facts
	.type	facts,@function
facts:                                  # @facts
	.param  	i64, i32, i32, i32
	.local  	i64, i64, i64, i64, i64, i32, i64, i64, i64, i32, i64, i64, i64, i32, i32, i32
# BB#0:                                 # %entry
	i64.extend_s/i32	$4=, $1
	i64.extend_s/i32	$11=, $2
	i64.const	$6=, 1
	i64.add 	$5=, $4, $6
	copy_local	$10=, $6
	copy_local	$12=, $11
	i32.const	$17=, factab
	i32.const	$18=, 1
	i32.const	$19=, 0
	copy_local	$9=, $18
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_5 Depth 2
                                        #     Child Loop BB2_9 Depth 2
                                        #     Child Loop BB2_12 Depth 2
                                        #     Child Loop BB2_16 Depth 2
                                        #     Child Loop BB2_19 Depth 2
                                        #     Child Loop BB2_24 Depth 2
	loop    	.LBB2_29
	copy_local	$15=, $12
	copy_local	$12=, $5
	copy_local	$14=, $6
	i32.const	$13=, -1
	copy_local	$1=, $3
	block   	.LBB2_22
	i32.const	$push46=, 0
	i32.eq  	$push47=, $3, $pop46
	br_if   	$pop47, .LBB2_22
.LBB2_2:                                # %for.body.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB2_3
	i32.const	$2=, 1
	i32.shr_u	$1=, $1, $2
	i32.add 	$13=, $13, $2
	br_if   	$1, .LBB2_2
.LBB2_3:                                # %for.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	copy_local	$14=, $15
	block   	.LBB2_8
	i32.lt_s	$push0=, $13, $2
	br_if   	$pop0, .LBB2_8
# BB#4:                                 # %for.body4.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$1=, $13, $2
	copy_local	$14=, $15
.LBB2_5:                                # %for.body4.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB2_8
	block   	.LBB2_7
	i64.mul 	$push1=, $14, $14
	i64.rem_u	$14=, $pop1, $0
	i32.const	$push2=, -2
	i32.add 	$push3=, $1, $pop2
	i32.shl 	$push4=, $2, $pop3
	i32.and 	$push5=, $pop4, $3
	i32.const	$push48=, 0
	i32.eq  	$push49=, $pop5, $pop48
	br_if   	$pop49, .LBB2_7
# BB#6:                                 # %if.then5.i
                                        #   in Loop: Header=BB2_5 Depth=2
	i64.mul 	$push6=, $14, $15
	i64.rem_u	$14=, $pop6, $0
.LBB2_7:                                # %for.inc9.i
                                        #   in Loop: Header=BB2_5 Depth=2
	i32.const	$push7=, -1
	i32.add 	$1=, $1, $pop7
	i32.gt_s	$push8=, $1, $2
	br_if   	$pop8, .LBB2_5
.LBB2_8:                                # %for.body.i114.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.add 	$12=, $14, $4
	i32.const	$13=, -1
	copy_local	$1=, $3
.LBB2_9:                                # %for.body.i114
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB2_10
	i32.shr_u	$1=, $1, $2
	i32.add 	$13=, $13, $2
	br_if   	$1, .LBB2_9
.LBB2_10:                               # %for.end.i116
                                        #   in Loop: Header=BB2_1 Depth=1
	copy_local	$14=, $11
	block   	.LBB2_15
	i32.lt_s	$push9=, $13, $2
	br_if   	$pop9, .LBB2_15
# BB#11:                                # %for.body4.i125.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$1=, $13, $2
	copy_local	$14=, $11
.LBB2_12:                               # %for.body4.i125
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB2_15
	block   	.LBB2_14
	i64.mul 	$push10=, $14, $14
	i64.rem_u	$14=, $pop10, $0
	i32.const	$push11=, -2
	i32.add 	$push12=, $1, $pop11
	i32.shl 	$push13=, $2, $pop12
	i32.and 	$push14=, $pop13, $3
	i32.const	$push50=, 0
	i32.eq  	$push51=, $pop14, $pop50
	br_if   	$pop51, .LBB2_14
# BB#13:                                # %if.then5.i128
                                        #   in Loop: Header=BB2_12 Depth=2
	i64.mul 	$push15=, $14, $11
	i64.rem_u	$14=, $pop15, $0
.LBB2_14:                               # %for.inc9.i131
                                        #   in Loop: Header=BB2_12 Depth=2
	i32.const	$push16=, -1
	i32.add 	$1=, $1, $pop16
	i32.gt_s	$push17=, $1, $2
	br_if   	$pop17, .LBB2_12
.LBB2_15:                               # %for.body.i88.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.add 	$15=, $14, $4
	i32.const	$13=, -1
	copy_local	$1=, $3
.LBB2_16:                               # %for.body.i88
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB2_17
	i32.shr_u	$1=, $1, $2
	i32.add 	$13=, $13, $2
	br_if   	$1, .LBB2_16
.LBB2_17:                               # %for.end.i90
                                        #   in Loop: Header=BB2_1 Depth=1
	copy_local	$14=, $15
	i32.lt_s	$push18=, $13, $2
	br_if   	$pop18, .LBB2_22
# BB#18:                                # %for.body4.i99.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$1=, $13, $2
	copy_local	$14=, $15
.LBB2_19:                               # %for.body4.i99
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB2_22
	block   	.LBB2_21
	i64.mul 	$push19=, $14, $14
	i64.rem_u	$14=, $pop19, $0
	i32.const	$push20=, -2
	i32.add 	$push21=, $1, $pop20
	i32.shl 	$push22=, $2, $pop21
	i32.and 	$push23=, $pop22, $3
	i32.const	$push52=, 0
	i32.eq  	$push53=, $pop23, $pop52
	br_if   	$pop53, .LBB2_21
# BB#20:                                # %if.then5.i102
                                        #   in Loop: Header=BB2_19 Depth=2
	i64.mul 	$push24=, $14, $15
	i64.rem_u	$14=, $pop24, $0
.LBB2_21:                               # %for.inc9.i105
                                        #   in Loop: Header=BB2_19 Depth=2
	i32.const	$push25=, -1
	i32.add 	$1=, $1, $pop25
	i32.gt_s	$push26=, $1, $2
	br_if   	$pop26, .LBB2_19
.LBB2_22:                               # %powmod_ll.exit107
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.add 	$11=, $14, $4
	i64.const	$7=, 4294967295
	block   	.LBB2_28
	i64.gt_u	$push27=, $12, $11
	i64.sub 	$push28=, $12, $11
	i64.sub 	$push29=, $11, $12
	i64.select	$push30=, $pop27, $pop28, $pop29
	i64.and 	$push32=, $pop30, $7
	i64.and 	$push31=, $10, $7
	i64.mul 	$push33=, $pop32, $pop31
	i64.rem_u	$10=, $pop33, $0
	i32.ne  	$push34=, $9, $18
	br_if   	$pop34, .LBB2_28
# BB#23:                                # %if.then19
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, 1
	i32.add 	$19=, $19, $2
	i64.and 	$14=, $10, $7
	i64.const	$8=, 0
	copy_local	$15=, $0
	copy_local	$16=, $14
	block   	.LBB2_26
	i64.eq  	$push35=, $0, $8
	br_if   	$pop35, .LBB2_26
.LBB2_24:                               # %if.end.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB2_26
	i64.rem_u	$14=, $14, $15
	copy_local	$16=, $15
	i64.eq  	$push36=, $14, $8
	br_if   	$pop36, .LBB2_26
# BB#25:                                # %if.end5.i
                                        #   in Loop: Header=BB2_24 Depth=2
	i64.rem_u	$15=, $15, $14
	copy_local	$16=, $14
	i64.ne  	$push37=, $15, $8
	br_if   	$pop37, .LBB2_24
.LBB2_26:                               # %gcd_ll.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$18=, $19, $18
	i32.wrap/i64	$1=, $16
	i32.eq  	$push38=, $1, $2
	br_if   	$pop38, .LBB2_28
# BB#27:                                # %if.then26
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.store	$discard=, 0($17), $1
	i32.const	$push39=, 4
	i32.add 	$2=, $17, $pop39
	i64.and 	$push40=, $16, $7
	i64.div_u	$0=, $0, $pop40
	copy_local	$17=, $2
	i64.const	$push41=, 1
	i64.eq  	$push42=, $0, $pop41
	br_if   	$pop42, .LBB2_29
.LBB2_28:                               # %for.inc
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push43=, 1
	i32.add 	$9=, $9, $pop43
	i32.const	$push44=, 10000
	i32.lt_s	$push45=, $9, $pop44
	br_if   	$pop45, .LBB2_1
.LBB2_29:                               # %cleanup
	return
.Lfunc_end2:
	.size	facts, .Lfunc_end2-facts

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# BB#0:                                 # %entry
	i64.const	$push5=, 134217727
	i32.const	$push4=, -1
	i32.const	$push3=, 3
	i32.const	$push2=, 27
	call    	facts, $pop5, $pop4, $pop3, $pop2
	i32.const	$0=, 0
	i64.load	$1=, factab($0)
	block   	.LBB3_4
	i32.wrap/i64	$push6=, $1
	i32.const	$push7=, 7
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, .LBB3_4
# BB#1:                                 # %entry
	i64.const	$push9=, -4294967296
	i64.and 	$push0=, $1, $pop9
	i64.const	$push10=, 313532612608
	i64.ne  	$push11=, $pop0, $pop10
	br_if   	$pop11, .LBB3_4
# BB#2:                                 # %entry
	i32.load	$push1=, factab+8($0)
	i32.const	$push12=, 262657
	i32.ne  	$push13=, $pop1, $pop12
	br_if   	$pop13, .LBB3_4
# BB#3:                                 # %if.end
	call    	exit, $0
	unreachable
.LBB3_4:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	factab                  # @factab
	.type	factab,@object
	.section	.bss.factab,"aw",@nobits
	.globl	factab
	.align	4
factab:
	.skip	40
	.size	factab, 40


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
