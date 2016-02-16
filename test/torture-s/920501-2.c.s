	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920501-2.c"
	.section	.text.gcd_ll,"ax",@progbits
	.hidden	gcd_ll
	.globl	gcd_ll
	.type	gcd_ll,@function
gcd_ll:                                 # @gcd_ll
	.param  	i64, i64
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	copy_local	$2=, $0
	block
	i64.const	$push5=, 0
	i64.eq  	$push0=, $1, $pop5
	br_if   	0, $pop0        # 0: down to label0
.LBB0_1:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i64.rem_u	$0=, $0, $1
	copy_local	$2=, $1
	i64.const	$push6=, 0
	i64.eq  	$push1=, $0, $pop6
	br_if   	1, $pop1        # 1: down to label2
# BB#2:                                 # %if.end5
                                        #   in Loop: Header=BB0_1 Depth=1
	i64.rem_u	$1=, $1, $0
	copy_local	$2=, $0
	i64.const	$push2=, 0
	i64.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: up to label1
.LBB0_3:                                # %return
	end_loop                        # label2:
	end_block                       # label0:
	i32.wrap/i64	$push4=, $2
	return  	$pop4
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
	i64.const	$5=, 1
	i32.const	$3=, -1
	copy_local	$4=, $1
	block
	i32.const	$push15=, 0
	i32.eq  	$push16=, $1, $pop15
	br_if   	0, $pop16       # 0: down to label3
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push8=, 1
	i32.shr_u	$4=, $4, $pop8
	i32.const	$push7=, 1
	i32.add 	$3=, $3, $pop7
	br_if   	0, $4           # 0: up to label4
# BB#2:                                 # %for.end
	end_loop                        # label5:
	copy_local	$5=, $0
	i32.const	$push9=, 1
	i32.lt_s	$push0=, $3, $pop9
	br_if   	0, $pop0        # 0: down to label3
# BB#3:                                 # %for.body4.preheader
	i32.const	$push10=, 1
	i32.add 	$4=, $3, $pop10
	copy_local	$5=, $0
.LBB1_4:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i64.mul 	$push1=, $5, $5
	i64.rem_u	$5=, $pop1, $2
	block
	i32.const	$push12=, 1
	i32.const	$push11=, -2
	i32.add 	$push2=, $4, $pop11
	i32.shl 	$push3=, $pop12, $pop2
	i32.and 	$push4=, $pop3, $1
	i32.const	$push17=, 0
	i32.eq  	$push18=, $pop4, $pop17
	br_if   	0, $pop18       # 0: down to label8
# BB#5:                                 # %if.then5
                                        #   in Loop: Header=BB1_4 Depth=1
	i64.mul 	$push5=, $5, $0
	i64.rem_u	$5=, $pop5, $2
.LBB1_6:                                # %for.inc9
                                        #   in Loop: Header=BB1_4 Depth=1
	end_block                       # label8:
	i32.const	$push14=, -1
	i32.add 	$4=, $4, $pop14
	i32.const	$push13=, 1
	i32.gt_s	$push6=, $4, $pop13
	br_if   	0, $pop6        # 0: up to label6
.LBB1_7:                                # %cleanup
	end_loop                        # label7:
	end_block                       # label3:
	return  	$5
	.endfunc
.Lfunc_end1:
	.size	powmod_ll, .Lfunc_end1-powmod_ll

	.section	.text.facts,"ax",@progbits
	.hidden	facts
	.globl	facts
	.type	facts,@function
facts:                                  # @facts
	.param  	i64, i32, i32, i32
	.local  	i64, i32, i64, i64, i64, i64, i64, i64, i32, i32, i32, i64
# BB#0:                                 # %entry
	i64.extend_s/i32	$7=, $2
	i64.extend_s/i32	$push38=, $1
	tee_local	$push37=, $15=, $pop38
	i64.const	$push36=, 1
	i64.add 	$4=, $pop37, $pop36
	i64.const	$6=, 1
	copy_local	$8=, $7
	i32.const	$12=, factab
	i32.const	$14=, 0
	i32.const	$13=, 1
	i32.const	$5=, 1
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_5 Depth 2
                                        #     Child Loop BB2_9 Depth 2
                                        #     Child Loop BB2_12 Depth 2
                                        #     Child Loop BB2_16 Depth 2
                                        #     Child Loop BB2_19 Depth 2
                                        #     Child Loop BB2_24 Depth 2
	loop                            # label9:
	copy_local	$10=, $8
	copy_local	$8=, $4
	i64.const	$9=, 1
	i32.const	$1=, -1
	copy_local	$2=, $3
	block
	i32.const	$push78=, 0
	i32.eq  	$push79=, $3, $pop78
	br_if   	0, $pop79       # 0: down to label11
.LBB2_2:                                # %for.body.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label12:
	i32.const	$push40=, 1
	i32.shr_u	$2=, $2, $pop40
	i32.const	$push39=, 1
	i32.add 	$1=, $1, $pop39
	br_if   	0, $2           # 0: up to label12
# BB#3:                                 # %for.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label13:
	copy_local	$9=, $10
	block
	i32.const	$push41=, 1
	i32.lt_s	$push0=, $1, $pop41
	br_if   	0, $pop0        # 0: down to label14
# BB#4:                                 # %for.body4.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push42=, 1
	i32.add 	$2=, $1, $pop42
	copy_local	$9=, $10
.LBB2_5:                                # %for.body4.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label15:
	i64.mul 	$push1=, $9, $9
	i64.rem_u	$9=, $pop1, $0
	block
	i32.const	$push44=, 1
	i32.const	$push43=, -2
	i32.add 	$push2=, $2, $pop43
	i32.shl 	$push3=, $pop44, $pop2
	i32.and 	$push4=, $pop3, $3
	i32.const	$push80=, 0
	i32.eq  	$push81=, $pop4, $pop80
	br_if   	0, $pop81       # 0: down to label17
# BB#6:                                 # %if.then5.i
                                        #   in Loop: Header=BB2_5 Depth=2
	i64.mul 	$push5=, $9, $10
	i64.rem_u	$9=, $pop5, $0
.LBB2_7:                                # %for.inc9.i
                                        #   in Loop: Header=BB2_5 Depth=2
	end_block                       # label17:
	i32.const	$push46=, -1
	i32.add 	$2=, $2, $pop46
	i32.const	$push45=, 1
	i32.gt_s	$push6=, $2, $pop45
	br_if   	0, $pop6        # 0: up to label15
.LBB2_8:                                # %for.body.i114.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label16:
	end_block                       # label14:
	i64.add 	$8=, $9, $15
	i32.const	$1=, -1
	copy_local	$2=, $3
.LBB2_9:                                # %for.body.i114
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label18:
	i32.const	$push48=, 1
	i32.shr_u	$2=, $2, $pop48
	i32.const	$push47=, 1
	i32.add 	$1=, $1, $pop47
	br_if   	0, $2           # 0: up to label18
# BB#10:                                # %for.end.i116
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label19:
	copy_local	$9=, $7
	block
	i32.const	$push49=, 1
	i32.lt_s	$push7=, $1, $pop49
	br_if   	0, $pop7        # 0: down to label20
# BB#11:                                # %for.body4.i125.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push50=, 1
	i32.add 	$2=, $1, $pop50
	copy_local	$9=, $7
.LBB2_12:                               # %for.body4.i125
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label21:
	i64.mul 	$push8=, $9, $9
	i64.rem_u	$9=, $pop8, $0
	block
	i32.const	$push52=, 1
	i32.const	$push51=, -2
	i32.add 	$push9=, $2, $pop51
	i32.shl 	$push10=, $pop52, $pop9
	i32.and 	$push11=, $pop10, $3
	i32.const	$push82=, 0
	i32.eq  	$push83=, $pop11, $pop82
	br_if   	0, $pop83       # 0: down to label23
# BB#13:                                # %if.then5.i128
                                        #   in Loop: Header=BB2_12 Depth=2
	i64.mul 	$push12=, $9, $7
	i64.rem_u	$9=, $pop12, $0
.LBB2_14:                               # %for.inc9.i131
                                        #   in Loop: Header=BB2_12 Depth=2
	end_block                       # label23:
	i32.const	$push54=, -1
	i32.add 	$2=, $2, $pop54
	i32.const	$push53=, 1
	i32.gt_s	$push13=, $2, $pop53
	br_if   	0, $pop13       # 0: up to label21
.LBB2_15:                               # %for.body.i88.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label22:
	end_block                       # label20:
	i64.add 	$10=, $9, $15
	i32.const	$1=, -1
	copy_local	$2=, $3
.LBB2_16:                               # %for.body.i88
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label24:
	i32.const	$push56=, 1
	i32.shr_u	$2=, $2, $pop56
	i32.const	$push55=, 1
	i32.add 	$1=, $1, $pop55
	br_if   	0, $2           # 0: up to label24
# BB#17:                                # %for.end.i90
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label25:
	copy_local	$9=, $10
	i32.const	$push57=, 1
	i32.lt_s	$push14=, $1, $pop57
	br_if   	0, $pop14       # 0: down to label11
# BB#18:                                # %for.body4.i99.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push58=, 1
	i32.add 	$2=, $1, $pop58
	copy_local	$9=, $10
.LBB2_19:                               # %for.body4.i99
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label26:
	i64.mul 	$push15=, $9, $9
	i64.rem_u	$9=, $pop15, $0
	block
	i32.const	$push60=, 1
	i32.const	$push59=, -2
	i32.add 	$push16=, $2, $pop59
	i32.shl 	$push17=, $pop60, $pop16
	i32.and 	$push18=, $pop17, $3
	i32.const	$push84=, 0
	i32.eq  	$push85=, $pop18, $pop84
	br_if   	0, $pop85       # 0: down to label28
# BB#20:                                # %if.then5.i102
                                        #   in Loop: Header=BB2_19 Depth=2
	i64.mul 	$push19=, $9, $10
	i64.rem_u	$9=, $pop19, $0
.LBB2_21:                               # %for.inc9.i105
                                        #   in Loop: Header=BB2_19 Depth=2
	end_block                       # label28:
	i32.const	$push62=, -1
	i32.add 	$2=, $2, $pop62
	i32.const	$push61=, 1
	i32.gt_s	$push20=, $2, $pop61
	br_if   	0, $pop20       # 0: up to label26
.LBB2_22:                               # %powmod_ll.exit107
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label27:
	end_block                       # label11:
	i64.add 	$7=, $9, $15
	i64.sub 	$push22=, $8, $7
	i64.sub 	$push23=, $7, $8
	i64.gt_u	$push21=, $8, $7
	i64.select	$push24=, $pop22, $pop23, $pop21
	i64.const	$push64=, 4294967295
	i64.and 	$push26=, $pop24, $pop64
	i64.const	$push63=, 4294967295
	i64.and 	$push25=, $6, $pop63
	i64.mul 	$push27=, $pop26, $pop25
	i64.rem_u	$6=, $pop27, $0
	block
	i32.ne  	$push28=, $5, $13
	br_if   	0, $pop28       # 0: down to label29
# BB#23:                                # %if.then19
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$push67=, 4294967295
	i64.and 	$9=, $6, $pop67
	i32.const	$push66=, 1
	i32.add 	$14=, $14, $pop66
	copy_local	$10=, $0
	copy_local	$11=, $9
	block
	i64.const	$push65=, 0
	i64.eq  	$push29=, $0, $pop65
	br_if   	0, $pop29       # 0: down to label30
.LBB2_24:                               # %if.end.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label31:
	i64.rem_u	$9=, $9, $10
	copy_local	$11=, $10
	i64.const	$push68=, 0
	i64.eq  	$push30=, $9, $pop68
	br_if   	1, $pop30       # 1: down to label32
# BB#25:                                # %if.end5.i
                                        #   in Loop: Header=BB2_24 Depth=2
	i64.rem_u	$10=, $10, $9
	copy_local	$11=, $9
	i64.const	$push69=, 0
	i64.ne  	$push31=, $10, $pop69
	br_if   	0, $pop31       # 0: up to label31
.LBB2_26:                               # %gcd_ll.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label32:
	end_block                       # label30:
	i32.add 	$13=, $14, $13
	i32.wrap/i64	$push72=, $11
	tee_local	$push71=, $2=, $pop72
	i32.const	$push70=, 1
	i32.eq  	$push32=, $pop71, $pop70
	br_if   	0, $pop32       # 0: down to label29
# BB#27:                                # %if.then26
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.store	$discard=, 0($12), $2
	i32.const	$push75=, 4
	i32.add 	$2=, $12, $pop75
	i64.const	$push74=, 4294967295
	i64.and 	$push33=, $11, $pop74
	i64.div_u	$0=, $0, $pop33
	copy_local	$12=, $2
	i64.const	$push73=, 1
	i64.eq  	$push34=, $0, $pop73
	br_if   	2, $pop34       # 2: down to label10
.LBB2_28:                               # %for.inc
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label29:
	i32.const	$push77=, 1
	i32.add 	$5=, $5, $pop77
	i32.const	$push76=, 10000
	i32.lt_s	$push35=, $5, $pop76
	br_if   	0, $pop35       # 0: up to label9
.LBB2_29:                               # %cleanup
	end_loop                        # label10:
	return
	.endfunc
.Lfunc_end2:
	.size	facts, .Lfunc_end2-facts

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	i64.const	$push5=, 134217727
	i32.const	$push4=, -1
	i32.const	$push3=, 3
	i32.const	$push2=, 27
	call    	facts@FUNCTION, $pop5, $pop4, $pop3, $pop2
	block
	i32.const	$push17=, 0
	i64.load	$push16=, factab($pop17):p2align=4
	tee_local	$push15=, $0=, $pop16
	i32.wrap/i64	$push6=, $pop15
	i32.const	$push7=, 7
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label33
# BB#1:                                 # %entry
	i64.const	$push9=, -4294967296
	i64.and 	$push0=, $0, $pop9
	i64.const	$push10=, 313532612608
	i64.ne  	$push11=, $pop0, $pop10
	br_if   	0, $pop11       # 0: down to label33
# BB#2:                                 # %entry
	i32.const	$push18=, 0
	i32.load	$push1=, factab+8($pop18):p2align=3
	i32.const	$push12=, 262657
	i32.ne  	$push13=, $pop1, $pop12
	br_if   	0, $pop13       # 0: down to label33
# BB#3:                                 # %if.end
	i32.const	$push14=, 0
	call    	exit@FUNCTION, $pop14
	unreachable
.LBB3_4:                                # %if.then
	end_block                       # label33:
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


	.ident	"clang version 3.9.0 "
