	.text
	.file	"920501-2.c"
	.section	.text.gcd_ll,"ax",@progbits
	.hidden	gcd_ll                  # -- Begin function gcd_ll
	.globl	gcd_ll
	.type	gcd_ll,@function
gcd_ll:                                 # @gcd_ll
	.param  	i64, i64
	.result 	i32
# %bb.0:                                # %entry
	block   	
	block   	
	i64.eqz 	$push0=, $1
	br_if   	0, $pop0        # 0: down to label1
# %bb.1:                                # %if.end.preheader
.LBB0_2:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i64.rem_u	$0=, $0, $1
	i64.eqz 	$push1=, $0
	br_if   	2, $pop1        # 2: down to label0
# %bb.3:                                # %if.end5
                                        #   in Loop: Header=BB0_2 Depth=1
	i64.rem_u	$1=, $1, $0
	i64.const	$push6=, 0
	i64.ne  	$push2=, $1, $pop6
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
                                        # -- End function
	.section	.text.powmod_ll,"ax",@progbits
	.hidden	powmod_ll               # -- Begin function powmod_ll
	.globl	powmod_ll
	.type	powmod_ll,@function
powmod_ll:                              # @powmod_ll
	.param  	i64, i32, i64
	.result 	i64
	.local  	i32, i32, i64
# %bb.0:                                # %entry
	block   	
	block   	
	i32.eqz 	$push16=, $1
	br_if   	0, $pop16       # 0: down to label4
# %bb.1:                                # %for.body.preheader
	i32.const	$3=, 0
	copy_local	$4=, $1
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.const	$push10=, 1
	i32.add 	$3=, $3, $pop10
	i32.const	$push9=, 1
	i32.shr_u	$4=, $4, $pop9
	br_if   	0, $4           # 0: up to label5
# %bb.3:                                # %for.end
	end_loop
	i32.const	$push11=, 1
	i32.ne  	$push0=, $3, $pop11
	br_if   	1, $pop0        # 1: down to label3
# %bb.4:
	copy_local	$push7=, $0
	return  	$pop7
.LBB1_5:
	end_block                       # label4:
	i64.const	$push8=, 1
	return  	$pop8
.LBB1_6:                                # %for.body4.preheader
	end_block                       # label3:
	copy_local	$5=, $0
.LBB1_7:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i64.mul 	$push1=, $5, $5
	i64.rem_u	$5=, $pop1, $2
	block   	
	i32.const	$push13=, 1
	i32.const	$push12=, -2
	i32.add 	$push2=, $3, $pop12
	i32.shl 	$push3=, $pop13, $pop2
	i32.and 	$push4=, $pop3, $1
	i32.eqz 	$push17=, $pop4
	br_if   	0, $pop17       # 0: down to label7
# %bb.8:                                # %if.then5
                                        #   in Loop: Header=BB1_7 Depth=1
	i64.mul 	$push5=, $5, $0
	i64.rem_u	$5=, $pop5, $2
.LBB1_9:                                # %for.inc9
                                        #   in Loop: Header=BB1_7 Depth=1
	end_block                       # label7:
	i32.const	$push15=, -1
	i32.add 	$3=, $3, $pop15
	i32.const	$push14=, 1
	i32.gt_s	$push6=, $3, $pop14
	br_if   	0, $pop6        # 0: up to label6
# %bb.10:                               # %cleanup
	end_loop
	copy_local	$push18=, $5
                                        # fallthrough-return: $pop18
	.endfunc
.Lfunc_end1:
	.size	powmod_ll, .Lfunc_end1-powmod_ll
                                        # -- End function
	.section	.text.facts,"ax",@progbits
	.hidden	facts                   # -- Begin function facts
	.globl	facts
	.type	facts,@function
facts:                                  # @facts
	.param  	i64, i32, i32, i32
	.local  	i64, i64, i64, i32, i64, i64, i32, i32, i64, i64, i64, i32, i32, i32
# %bb.0:                                # %entry
	i64.extend_s/i32	$4=, $1
	i64.const	$push33=, 1
	i64.add 	$5=, $4, $pop33
	i64.extend_s/i32	$9=, $2
	i32.const	$15=, factab
	i32.const	$17=, 0
	i32.const	$16=, 1
	i32.const	$7=, 1
	i64.const	$8=, 1
	copy_local	$13=, $9
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
	i32.eqz 	$push66=, $3
	br_if   	0, $pop66       # 0: down to label9
# %bb.2:                                # %for.body.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$11=, -1
	i32.const	$10=, 1
	copy_local	$1=, $3
.LBB2_3:                                # %for.body.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label10:
	copy_local	$2=, $10
	i32.const	$push36=, 1
	i32.add 	$10=, $2, $pop36
	i32.const	$push35=, 1
	i32.add 	$11=, $11, $pop35
	i32.const	$push34=, 1
	i32.shr_u	$1=, $1, $pop34
	br_if   	0, $1           # 0: up to label10
# %bb.4:                                # %for.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	block   	
	block   	
	i32.eqz 	$push67=, $11
	br_if   	0, $pop67       # 0: down to label12
# %bb.5:                                # %for.body4.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	copy_local	$12=, $6
.LBB2_6:                                # %for.body4.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label13:
	i64.mul 	$push0=, $12, $12
	i64.rem_u	$12=, $pop0, $0
	block   	
	i32.const	$push38=, 1
	i32.const	$push37=, -2
	i32.add 	$push1=, $2, $pop37
	i32.shl 	$push2=, $pop38, $pop1
	i32.and 	$push3=, $pop2, $3
	i32.eqz 	$push68=, $pop3
	br_if   	0, $pop68       # 0: down to label14
# %bb.7:                                # %if.then5.i
                                        #   in Loop: Header=BB2_6 Depth=2
	i64.mul 	$push4=, $12, $6
	i64.rem_u	$12=, $pop4, $0
.LBB2_8:                                # %for.inc9.i
                                        #   in Loop: Header=BB2_6 Depth=2
	end_block                       # label14:
	i32.const	$push40=, -1
	i32.add 	$2=, $2, $pop40
	i32.const	$push39=, 1
	i32.gt_s	$push5=, $2, $pop39
	br_if   	0, $pop5        # 0: up to label13
	br      	2               # 2: down to label11
.LBB2_9:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label12:
	copy_local	$12=, $6
.LBB2_10:                               # %for.body.lr.ph.i110
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label11:
	i64.add 	$13=, $12, $4
	i32.const	$11=, -1
	i32.const	$10=, 1
	copy_local	$1=, $3
.LBB2_11:                               # %for.body.i116
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label15:
	copy_local	$2=, $10
	i32.const	$push43=, 1
	i32.add 	$10=, $2, $pop43
	i32.const	$push42=, 1
	i32.add 	$11=, $11, $pop42
	i32.const	$push41=, 1
	i32.shr_u	$1=, $1, $pop41
	br_if   	0, $1           # 0: up to label15
# %bb.12:                               # %for.end.i118
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	block   	
	block   	
	i32.eqz 	$push69=, $11
	br_if   	0, $pop69       # 0: down to label17
# %bb.13:                               # %for.body4.i128.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	copy_local	$12=, $9
.LBB2_14:                               # %for.body4.i128
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label18:
	i64.mul 	$push6=, $12, $12
	i64.rem_u	$12=, $pop6, $0
	block   	
	i32.const	$push45=, 1
	i32.const	$push44=, -2
	i32.add 	$push7=, $2, $pop44
	i32.shl 	$push8=, $pop45, $pop7
	i32.and 	$push9=, $pop8, $3
	i32.eqz 	$push70=, $pop9
	br_if   	0, $pop70       # 0: down to label19
# %bb.15:                               # %if.then5.i131
                                        #   in Loop: Header=BB2_14 Depth=2
	i64.mul 	$push10=, $12, $9
	i64.rem_u	$12=, $pop10, $0
.LBB2_16:                               # %for.inc9.i134
                                        #   in Loop: Header=BB2_14 Depth=2
	end_block                       # label19:
	i32.const	$push47=, -1
	i32.add 	$2=, $2, $pop47
	i32.const	$push46=, 1
	i32.gt_s	$push11=, $2, $pop46
	br_if   	0, $pop11       # 0: up to label18
	br      	2               # 2: down to label16
.LBB2_17:                               #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label17:
	copy_local	$12=, $9
.LBB2_18:                               # %for.body.lr.ph.i82
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label16:
	i64.add 	$14=, $12, $4
	i32.const	$11=, -1
	i32.const	$10=, 1
	copy_local	$1=, $3
.LBB2_19:                               # %for.body.i88
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label20:
	copy_local	$2=, $10
	i32.const	$push50=, 1
	i32.add 	$10=, $2, $pop50
	i32.const	$push49=, 1
	i32.add 	$11=, $11, $pop49
	i32.const	$push48=, 1
	i32.shr_u	$1=, $1, $pop48
	br_if   	0, $1           # 0: up to label20
# %bb.20:                               # %for.end.i90
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	i32.eqz 	$push71=, $11
	br_if   	0, $pop71       # 0: down to label9
# %bb.21:                               # %for.body4.i100.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	copy_local	$12=, $14
.LBB2_22:                               # %for.body4.i100
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label21:
	i64.mul 	$push12=, $12, $12
	i64.rem_u	$12=, $pop12, $0
	block   	
	i32.const	$push52=, 1
	i32.const	$push51=, -2
	i32.add 	$push13=, $2, $pop51
	i32.shl 	$push14=, $pop52, $pop13
	i32.and 	$push15=, $pop14, $3
	i32.eqz 	$push72=, $pop15
	br_if   	0, $pop72       # 0: down to label22
# %bb.23:                               # %if.then5.i103
                                        #   in Loop: Header=BB2_22 Depth=2
	i64.mul 	$push16=, $12, $14
	i64.rem_u	$12=, $pop16, $0
.LBB2_24:                               # %for.inc9.i106
                                        #   in Loop: Header=BB2_22 Depth=2
	end_block                       # label22:
	i32.const	$push54=, -1
	i32.add 	$2=, $2, $pop54
	i32.const	$push53=, 1
	i32.gt_s	$push17=, $2, $pop53
	br_if   	0, $pop17       # 0: up to label21
# %bb.25:                               #   in Loop: Header=BB2_1 Depth=1
	end_loop
	copy_local	$14=, $12
.LBB2_26:                               # %powmod_ll.exit108
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label9:
	block   	
	i64.add 	$9=, $14, $4
	i64.sub 	$push20=, $13, $9
	i64.sub 	$push19=, $9, $13
	i64.gt_u	$push18=, $13, $9
	i64.select	$push21=, $pop20, $pop19, $pop18
	i64.const	$push56=, 4294967295
	i64.and 	$push22=, $pop21, $pop56
	i64.const	$push55=, 4294967295
	i64.and 	$push23=, $8, $pop55
	i64.mul 	$push24=, $pop22, $pop23
	i64.rem_u	$8=, $pop24, $0
	block   	
	i32.ne  	$push25=, $7, $16
	br_if   	0, $pop25       # 0: down to label24
# %bb.27:                               # %if.then18
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$push58=, 4294967295
	i64.and 	$12=, $8, $pop58
	i32.const	$push57=, 1
	i32.add 	$17=, $17, $pop57
	block   	
	i64.eqz 	$push26=, $0
	br_if   	0, $pop26       # 0: down to label25
# %bb.28:                               # %if.end.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	copy_local	$14=, $0
.LBB2_29:                               # %if.end.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label27:
	i64.rem_u	$12=, $12, $14
	i64.eqz 	$push27=, $12
	br_if   	1, $pop27       # 1: down to label26
# %bb.30:                               # %if.end5.i
                                        #   in Loop: Header=BB2_29 Depth=2
	i64.rem_u	$14=, $14, $12
	i64.const	$push59=, 0
	i64.ne  	$push28=, $14, $pop59
	br_if   	0, $pop28       # 0: up to label27
	br      	2               # 2: down to label25
.LBB2_31:                               #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label26:
	copy_local	$12=, $14
.LBB2_32:                               # %gcd_ll.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label25:
	i32.add 	$16=, $17, $16
	i32.wrap/i64	$2=, $12
	i32.const	$push60=, 1
	i32.eq  	$push29=, $2, $pop60
	br_if   	0, $pop29       # 0: down to label24
# %bb.33:                               # %if.then25
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.store	0($15), $2
	i64.const	$push62=, 4294967295
	i64.and 	$push30=, $12, $pop62
	i64.div_u	$0=, $0, $pop30
	i64.const	$push61=, 1
	i64.eq  	$push31=, $0, $pop61
	br_if   	1, $pop31       # 1: down to label23
# %bb.34:                               #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push63=, 4
	i32.add 	$15=, $15, $pop63
.LBB2_35:                               # %for.inc
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label24:
	i32.const	$push65=, 1
	i32.add 	$7=, $7, $pop65
	i32.const	$push64=, 10000
	i32.lt_u	$push32=, $7, $pop64
	br_if   	1, $pop32       # 1: up to label8
.LBB2_36:                               # %cleanup
	end_block                       # label23:
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	facts, .Lfunc_end2-facts
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
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
# %bb.1:                                # %entry
	i32.const	$push15=, 0
	i32.load	$push0=, factab+4($pop15)
	i32.const	$push9=, 73
	i32.ne  	$push10=, $pop0, $pop9
	br_if   	0, $pop10       # 0: down to label28
# %bb.2:                                # %entry
	i32.const	$push16=, 0
	i32.load	$push1=, factab+8($pop16)
	i32.const	$push11=, 262657
	i32.ne  	$push12=, $pop1, $pop11
	br_if   	0, $pop12       # 0: down to label28
# %bb.3:                                # %if.end
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
                                        # -- End function
	.hidden	factab                  # @factab
	.type	factab,@object
	.section	.bss.factab,"aw",@nobits
	.globl	factab
	.p2align	4
factab:
	.skip	40
	.size	factab, 40


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
