	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920501-2.c"
	.section	.text.gcd_ll,"ax",@progbits
	.hidden	gcd_ll
	.globl	gcd_ll
	.type	gcd_ll,@function
gcd_ll:                                 # @gcd_ll
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	block   	
	block   	
	i64.eqz 	$push0=, $1
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %if.end.preheader
.LBB0_2:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i64.rem_u	$push7=, $0, $1
	tee_local	$push6=, $0=, $pop7
	i64.eqz 	$push1=, $pop6
	br_if   	2, $pop1        # 2: down to label0
# BB#3:                                 # %if.end5
                                        #   in Loop: Header=BB0_2 Depth=1
	i64.rem_u	$push10=, $1, $0
	tee_local	$push9=, $1=, $pop10
	i64.const	$push8=, 0
	i64.ne  	$push2=, $pop9, $pop8
	br_if   	0, $pop2        # 0: up to label2
.LBB0_4:                                # %return
	end_loop
	end_block                       # label1:
	i32.wrap/i64	$push4=, $0
	return  	$pop4
.LBB0_5:
	end_block                       # label0:
	copy_local	$push5=, $1
	i32.wrap/i64	$push3=, $pop5
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	gcd_ll, .Lfunc_end0-gcd_ll

	.section	.text.powmod_ll,"ax",@progbits
	.hidden	powmod_ll
	.globl	powmod_ll
	.type	powmod_ll,@function
powmod_ll:                              # @powmod_ll
	.param  	i64, i32, i64
	.result 	i64
	.local  	i32, i32, i64
# BB#0:                                 # %entry
	block   	
	block   	
	i32.eqz 	$push22=, $1
	br_if   	0, $pop22       # 0: down to label4
# BB#1:                                 # %for.body.preheader
	i32.const	$3=, 0
	copy_local	$4=, $1
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.const	$push13=, 1
	i32.add 	$3=, $3, $pop13
	i32.const	$push12=, 1
	i32.shr_u	$push11=, $4, $pop12
	tee_local	$push10=, $4=, $pop11
	br_if   	0, $pop10       # 0: up to label5
# BB#3:                                 # %for.end
	end_loop
	i32.const	$push15=, -1
	i32.add 	$push0=, $3, $pop15
	i32.const	$push14=, 1
	i32.lt_s	$push1=, $pop0, $pop14
	br_if   	1, $pop1        # 1: down to label3
# BB#4:                                 # %for.body4.preheader
	copy_local	$5=, $0
.LBB1_5:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i64.mul 	$push2=, $5, $5
	i64.rem_u	$5=, $pop2, $2
	block   	
	i32.const	$push17=, 1
	i32.const	$push16=, -2
	i32.add 	$push3=, $3, $pop16
	i32.shl 	$push4=, $pop17, $pop3
	i32.and 	$push5=, $pop4, $1
	i32.eqz 	$push23=, $pop5
	br_if   	0, $pop23       # 0: down to label7
# BB#6:                                 # %if.then5
                                        #   in Loop: Header=BB1_5 Depth=1
	i64.mul 	$push6=, $5, $0
	i64.rem_u	$5=, $pop6, $2
.LBB1_7:                                # %for.inc9
                                        #   in Loop: Header=BB1_5 Depth=1
	end_block                       # label7:
	i32.const	$push21=, -1
	i32.add 	$push20=, $3, $pop21
	tee_local	$push19=, $3=, $pop20
	i32.const	$push18=, 1
	i32.gt_s	$push7=, $pop19, $pop18
	br_if   	0, $pop7        # 0: up to label6
# BB#8:                                 # %cleanup
	end_loop
	return  	$5
.LBB1_9:
	end_block                       # label4:
	i64.const	$push9=, 1
	return  	$pop9
.LBB1_10:
	end_block                       # label3:
	copy_local	$push8=, $0
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end1:
	.size	powmod_ll, .Lfunc_end1-powmod_ll

	.section	.text.facts,"ax",@progbits
	.hidden	facts
	.globl	facts
	.type	facts,@function
facts:                                  # @facts
	.param  	i64, i32, i32, i32
	.local  	i64, i64, i64, i32, i64, i64, i32, i32, i64, i64, i64, i32, i32, i32
# BB#0:                                 # %entry
	i64.extend_s/i32	$push40=, $1
	tee_local	$push39=, $4=, $pop40
	i64.const	$push38=, 1
	i64.add 	$5=, $pop39, $pop38
	i32.const	$15=, factab
	i32.const	$17=, 0
	i32.const	$16=, 1
	i32.const	$7=, 1
	i64.const	$8=, 1
	i64.extend_s/i32	$push37=, $2
	tee_local	$push36=, $9=, $pop37
	copy_local	$13=, $pop36
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
                                        #     Child Loop BB2_6 Depth 2
                                        #     Child Loop BB2_11 Depth 2
                                        #     Child Loop BB2_14 Depth 2
                                        #     Child Loop BB2_19 Depth 2
                                        #     Child Loop BB2_22 Depth 2
                                        #     Child Loop BB2_29 Depth 2
	loop    	                # label8:
	copy_local	$6=, $13
	copy_local	$13=, $5
	i64.const	$14=, 1
	block   	
	i32.eqz 	$push106=, $3
	br_if   	0, $pop106      # 0: down to label9
# BB#2:                                 # %for.body.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, -1
	i32.const	$10=, 1
	copy_local	$11=, $3
.LBB2_3:                                # %for.body.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label10:
	copy_local	$push47=, $10
	tee_local	$push46=, $2=, $pop47
	i32.const	$push45=, 1
	i32.add 	$10=, $pop46, $pop45
	i32.const	$push44=, 1
	i32.add 	$1=, $1, $pop44
	i32.const	$push43=, 1
	i32.shr_u	$push42=, $11, $pop43
	tee_local	$push41=, $11=, $pop42
	br_if   	0, $pop41       # 0: up to label10
# BB#4:                                 # %for.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	block   	
	block   	
	i32.const	$push48=, 1
	i32.lt_s	$push0=, $1, $pop48
	br_if   	0, $pop0        # 0: down to label12
# BB#5:                                 # %for.body4.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	copy_local	$12=, $6
.LBB2_6:                                # %for.body4.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label13:
	i64.mul 	$push1=, $12, $12
	i64.rem_u	$12=, $pop1, $0
	block   	
	i32.const	$push50=, 1
	i32.const	$push49=, -2
	i32.add 	$push2=, $2, $pop49
	i32.shl 	$push3=, $pop50, $pop2
	i32.and 	$push4=, $pop3, $3
	i32.eqz 	$push107=, $pop4
	br_if   	0, $pop107      # 0: down to label14
# BB#7:                                 # %if.then5.i
                                        #   in Loop: Header=BB2_6 Depth=2
	i64.mul 	$push5=, $12, $6
	i64.rem_u	$12=, $pop5, $0
.LBB2_8:                                # %for.inc9.i
                                        #   in Loop: Header=BB2_6 Depth=2
	end_block                       # label14:
	i32.const	$push54=, -1
	i32.add 	$push53=, $2, $pop54
	tee_local	$push52=, $2=, $pop53
	i32.const	$push51=, 1
	i32.gt_s	$push6=, $pop52, $pop51
	br_if   	0, $pop6        # 0: up to label13
	br      	2               # 2: down to label11
.LBB2_9:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label12:
	copy_local	$12=, $6
.LBB2_10:                               # %for.body.i114.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label11:
	i64.add 	$13=, $12, $4
	i32.const	$1=, -1
	i32.const	$10=, 1
	copy_local	$11=, $3
.LBB2_11:                               # %for.body.i114
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label15:
	copy_local	$push61=, $10
	tee_local	$push60=, $2=, $pop61
	i32.const	$push59=, 1
	i32.add 	$10=, $pop60, $pop59
	i32.const	$push58=, 1
	i32.add 	$1=, $1, $pop58
	i32.const	$push57=, 1
	i32.shr_u	$push56=, $11, $pop57
	tee_local	$push55=, $11=, $pop56
	br_if   	0, $pop55       # 0: up to label15
# BB#12:                                # %for.end.i116
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	block   	
	block   	
	i32.const	$push62=, 1
	i32.lt_s	$push7=, $1, $pop62
	br_if   	0, $pop7        # 0: down to label17
# BB#13:                                # %for.body4.i125.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	copy_local	$12=, $9
.LBB2_14:                               # %for.body4.i125
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label18:
	i64.mul 	$push8=, $12, $12
	i64.rem_u	$12=, $pop8, $0
	block   	
	i32.const	$push64=, 1
	i32.const	$push63=, -2
	i32.add 	$push9=, $2, $pop63
	i32.shl 	$push10=, $pop64, $pop9
	i32.and 	$push11=, $pop10, $3
	i32.eqz 	$push108=, $pop11
	br_if   	0, $pop108      # 0: down to label19
# BB#15:                                # %if.then5.i128
                                        #   in Loop: Header=BB2_14 Depth=2
	i64.mul 	$push12=, $12, $9
	i64.rem_u	$12=, $pop12, $0
.LBB2_16:                               # %for.inc9.i131
                                        #   in Loop: Header=BB2_14 Depth=2
	end_block                       # label19:
	i32.const	$push68=, -1
	i32.add 	$push67=, $2, $pop68
	tee_local	$push66=, $2=, $pop67
	i32.const	$push65=, 1
	i32.gt_s	$push13=, $pop66, $pop65
	br_if   	0, $pop13       # 0: up to label18
	br      	2               # 2: down to label16
.LBB2_17:                               #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label17:
	copy_local	$12=, $9
.LBB2_18:                               # %for.body.i88.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label16:
	i64.add 	$14=, $12, $4
	i32.const	$1=, -1
	i32.const	$10=, 1
	copy_local	$11=, $3
.LBB2_19:                               # %for.body.i88
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label20:
	copy_local	$push75=, $10
	tee_local	$push74=, $2=, $pop75
	i32.const	$push73=, 1
	i32.add 	$10=, $pop74, $pop73
	i32.const	$push72=, 1
	i32.add 	$1=, $1, $pop72
	i32.const	$push71=, 1
	i32.shr_u	$push70=, $11, $pop71
	tee_local	$push69=, $11=, $pop70
	br_if   	0, $pop69       # 0: up to label20
# BB#20:                                # %for.end.i90
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	i32.const	$push76=, 1
	i32.lt_s	$push14=, $1, $pop76
	br_if   	0, $pop14       # 0: down to label9
# BB#21:                                # %for.body4.i99.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	copy_local	$12=, $14
.LBB2_22:                               # %for.body4.i99
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label21:
	i64.mul 	$push15=, $12, $12
	i64.rem_u	$12=, $pop15, $0
	block   	
	i32.const	$push78=, 1
	i32.const	$push77=, -2
	i32.add 	$push16=, $2, $pop77
	i32.shl 	$push17=, $pop78, $pop16
	i32.and 	$push18=, $pop17, $3
	i32.eqz 	$push109=, $pop18
	br_if   	0, $pop109      # 0: down to label22
# BB#23:                                # %if.then5.i102
                                        #   in Loop: Header=BB2_22 Depth=2
	i64.mul 	$push19=, $12, $14
	i64.rem_u	$12=, $pop19, $0
.LBB2_24:                               # %for.inc9.i105
                                        #   in Loop: Header=BB2_22 Depth=2
	end_block                       # label22:
	i32.const	$push82=, -1
	i32.add 	$push81=, $2, $pop82
	tee_local	$push80=, $2=, $pop81
	i32.const	$push79=, 1
	i32.gt_s	$push20=, $pop80, $pop79
	br_if   	0, $pop20       # 0: up to label21
# BB#25:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop
	copy_local	$14=, $12
.LBB2_26:                               # %powmod_ll.exit107
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label9:
	block   	
	i64.add 	$push86=, $14, $4
	tee_local	$push85=, $9=, $pop86
	i64.sub 	$push23=, $13, $pop85
	i64.sub 	$push22=, $9, $13
	i64.gt_u	$push21=, $13, $9
	i64.select	$push24=, $pop23, $pop22, $pop21
	i64.const	$push84=, 4294967295
	i64.and 	$push25=, $pop24, $pop84
	i64.const	$push83=, 4294967295
	i64.and 	$push26=, $8, $pop83
	i64.mul 	$push27=, $pop25, $pop26
	i64.rem_u	$8=, $pop27, $0
	block   	
	i32.ne  	$push28=, $7, $16
	br_if   	0, $pop28       # 0: down to label24
# BB#27:                                # %if.then19
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$push88=, 4294967295
	i64.and 	$12=, $8, $pop88
	i32.const	$push87=, 1
	i32.add 	$17=, $17, $pop87
	block   	
	i64.eqz 	$push29=, $0
	br_if   	0, $pop29       # 0: down to label25
# BB#28:                                # %if.end.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	copy_local	$14=, $0
.LBB2_29:                               # %if.end.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label27:
	i64.rem_u	$push90=, $12, $14
	tee_local	$push89=, $12=, $pop90
	i64.eqz 	$push30=, $pop89
	br_if   	1, $pop30       # 1: down to label26
# BB#30:                                # %if.end5.i
                                        #   in Loop: Header=BB2_29 Depth=2
	i64.rem_u	$push93=, $14, $12
	tee_local	$push92=, $14=, $pop93
	i64.const	$push91=, 0
	i64.ne  	$push31=, $pop92, $pop91
	br_if   	0, $pop31       # 0: up to label27
	br      	2               # 2: down to label25
.LBB2_31:                               #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label26:
	copy_local	$12=, $14
.LBB2_32:                               # %gcd_ll.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label25:
	i32.add 	$16=, $17, $16
	i32.wrap/i64	$push96=, $12
	tee_local	$push95=, $2=, $pop96
	i32.const	$push94=, 1
	i32.eq  	$push32=, $pop95, $pop94
	br_if   	0, $pop32       # 0: down to label24
# BB#33:                                # %if.then26
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.store	0($15), $2
	i64.const	$push100=, 4294967295
	i64.and 	$push33=, $12, $pop100
	i64.div_u	$push99=, $0, $pop33
	tee_local	$push98=, $0=, $pop99
	i64.const	$push97=, 1
	i64.eq  	$push34=, $pop98, $pop97
	br_if   	1, $pop34       # 1: down to label23
# BB#34:                                #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push101=, 4
	i32.add 	$15=, $15, $pop101
.LBB2_35:                               # %for.inc
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label24:
	i32.const	$push105=, 1
	i32.add 	$push104=, $7, $pop105
	tee_local	$push103=, $7=, $pop104
	i32.const	$push102=, 10000
	i32.lt_s	$push35=, $pop103, $pop102
	br_if   	1, $pop35       # 1: up to label8
.LBB2_36:                               # %cleanup
	end_block                       # label23:
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	facts, .Lfunc_end2-facts

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push5=, 134217727
	i32.const	$push4=, -1
	i32.const	$push3=, 3
	i32.const	$push2=, 27
	call    	facts@FUNCTION, $pop5, $pop4, $pop3, $pop2
	block   	
	i32.const	$push14=, 0
	i32.load	$push6=, factab($pop14)
	i32.const	$push7=, 7
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label28
# BB#1:                                 # %entry
	i32.const	$push15=, 0
	i32.load	$push0=, factab+4($pop15)
	i32.const	$push9=, 73
	i32.ne  	$push10=, $pop0, $pop9
	br_if   	0, $pop10       # 0: down to label28
# BB#2:                                 # %entry
	i32.const	$push16=, 0
	i32.load	$push1=, factab+8($pop16)
	i32.const	$push11=, 262657
	i32.ne  	$push12=, $pop1, $pop11
	br_if   	0, $pop12       # 0: down to label28
# BB#3:                                 # %if.end
	i32.const	$push13=, 0
	call    	exit@FUNCTION, $pop13
	unreachable
.LBB3_4:                                # %if.then
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	factab                  # @factab
	.type	factab,@object
	.section	.bss.factab,"aw",@nobits
	.globl	factab
	.p2align	4
factab:
	.skip	40
	.size	factab, 40


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
