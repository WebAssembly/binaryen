	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920501-2.c"
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
	i64.const	$push4=, 0
	i64.eq  	$push0=, $1, $pop4
	br_if   	0, $pop0        # 0: down to label1
.LBB0_1:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i64.rem_u	$0=, $0, $1
	i64.const	$push5=, 0
	i64.eq  	$push1=, $0, $pop5
	br_if   	3, $pop1        # 3: down to label0
# BB#2:                                 # %if.end5
                                        #   in Loop: Header=BB0_1 Depth=1
	i64.rem_u	$1=, $1, $0
	i64.const	$push6=, 0
	i64.ne  	$push2=, $1, $pop6
	br_if   	0, $pop2        # 0: up to label2
.LBB0_3:                                # %return
	end_loop                        # label3:
	end_block                       # label1:
	i32.wrap/i64	$push3=, $0
	return  	$pop3
.LBB0_4:
	end_block                       # label0:
	copy_local	$0=, $1
	i32.wrap/i64	$push3=, $0
	return  	$pop3
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
	block
	block
	i32.const	$push15=, 0
	i32.eq  	$push16=, $1, $pop15
	br_if   	0, $pop16       # 0: down to label5
# BB#1:
	i32.const	$3=, -1
	copy_local	$4=, $1
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$push8=, 1
	i32.shr_u	$4=, $4, $pop8
	i32.const	$push7=, 1
	i32.add 	$3=, $3, $pop7
	br_if   	0, $4           # 0: up to label6
# BB#3:                                 # %for.end
	end_loop                        # label7:
	i32.const	$push9=, 1
	i32.lt_s	$push0=, $3, $pop9
	br_if   	1, $pop0        # 1: down to label4
# BB#4:                                 # %for.body4.preheader
	i32.const	$push10=, 1
	i32.add 	$4=, $3, $pop10
	copy_local	$5=, $0
.LBB1_5:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
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
	br_if   	0, $pop18       # 0: down to label10
# BB#6:                                 # %if.then5
                                        #   in Loop: Header=BB1_5 Depth=1
	i64.mul 	$push5=, $5, $0
	i64.rem_u	$5=, $pop5, $2
.LBB1_7:                                # %for.inc9
                                        #   in Loop: Header=BB1_5 Depth=1
	end_block                       # label10:
	i32.const	$push14=, -1
	i32.add 	$4=, $4, $pop14
	i32.const	$push13=, 1
	i32.gt_s	$push6=, $4, $pop13
	br_if   	0, $pop6        # 0: up to label8
.LBB1_8:                                # %cleanup
	end_loop                        # label9:
	end_block                       # label5:
	return  	$5
.LBB1_9:
	end_block                       # label4:
	copy_local	$5=, $0
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
	.local  	i64, i32, i64, i32, i32, i32, i64, i64, i64, i64, i64, i64
# BB#0:                                 # %entry
	i64.extend_s/i32	$11=, $2
	i64.extend_s/i32	$push38=, $1
	tee_local	$push37=, $15=, $pop38
	i64.const	$push36=, 1
	i64.add 	$4=, $pop37, $pop36
	i64.const	$10=, 1
	copy_local	$13=, $11
	i32.const	$5=, factab
	i32.const	$7=, 0
	i32.const	$8=, 1
	i32.const	$9=, 1
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_5 Depth 2
                                        #     Child Loop BB2_10 Depth 2
                                        #     Child Loop BB2_13 Depth 2
                                        #     Child Loop BB2_18 Depth 2
                                        #     Child Loop BB2_21 Depth 2
                                        #     Child Loop BB2_27 Depth 2
	loop                            # label11:
	copy_local	$6=, $13
	copy_local	$13=, $4
	i64.const	$14=, 1
	i32.const	$1=, -1
	copy_local	$2=, $3
	block
	i32.const	$push78=, 0
	i32.eq  	$push79=, $3, $pop78
	br_if   	0, $pop79       # 0: down to label13
.LBB2_2:                                # %for.body.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label14:
	i32.const	$push40=, 1
	i32.shr_u	$2=, $2, $pop40
	i32.const	$push39=, 1
	i32.add 	$1=, $1, $pop39
	br_if   	0, $2           # 0: up to label14
# BB#3:                                 # %for.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label15:
	block
	block
	i32.const	$push41=, 1
	i32.lt_s	$push0=, $1, $pop41
	br_if   	0, $pop0        # 0: down to label17
# BB#4:                                 # %for.body4.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push42=, 1
	i32.add 	$2=, $1, $pop42
	copy_local	$12=, $6
.LBB2_5:                                # %for.body4.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label18:
	i64.mul 	$push1=, $12, $12
	i64.rem_u	$12=, $pop1, $0
	block
	i32.const	$push44=, 1
	i32.const	$push43=, -2
	i32.add 	$push2=, $2, $pop43
	i32.shl 	$push3=, $pop44, $pop2
	i32.and 	$push4=, $pop3, $3
	i32.const	$push80=, 0
	i32.eq  	$push81=, $pop4, $pop80
	br_if   	0, $pop81       # 0: down to label20
# BB#6:                                 # %if.then5.i
                                        #   in Loop: Header=BB2_5 Depth=2
	i64.mul 	$push5=, $12, $6
	i64.rem_u	$12=, $pop5, $0
.LBB2_7:                                # %for.inc9.i
                                        #   in Loop: Header=BB2_5 Depth=2
	end_block                       # label20:
	i32.const	$push46=, -1
	i32.add 	$2=, $2, $pop46
	i32.const	$push45=, 1
	i32.gt_s	$push6=, $2, $pop45
	br_if   	0, $pop6        # 0: up to label18
	br      	3               # 3: down to label16
.LBB2_8:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label19:
	end_block                       # label17:
	copy_local	$12=, $6
.LBB2_9:                                # %for.body.i114.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label16:
	i64.add 	$13=, $12, $15
	i32.const	$1=, -1
	copy_local	$2=, $3
.LBB2_10:                               # %for.body.i114
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label21:
	i32.const	$push48=, 1
	i32.shr_u	$2=, $2, $pop48
	i32.const	$push47=, 1
	i32.add 	$1=, $1, $pop47
	br_if   	0, $2           # 0: up to label21
# BB#11:                                # %for.end.i116
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label22:
	block
	block
	i32.const	$push49=, 1
	i32.lt_s	$push7=, $1, $pop49
	br_if   	0, $pop7        # 0: down to label24
# BB#12:                                # %for.body4.i125.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push50=, 1
	i32.add 	$2=, $1, $pop50
	copy_local	$12=, $11
.LBB2_13:                               # %for.body4.i125
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label25:
	i64.mul 	$push8=, $12, $12
	i64.rem_u	$12=, $pop8, $0
	block
	i32.const	$push52=, 1
	i32.const	$push51=, -2
	i32.add 	$push9=, $2, $pop51
	i32.shl 	$push10=, $pop52, $pop9
	i32.and 	$push11=, $pop10, $3
	i32.const	$push82=, 0
	i32.eq  	$push83=, $pop11, $pop82
	br_if   	0, $pop83       # 0: down to label27
# BB#14:                                # %if.then5.i128
                                        #   in Loop: Header=BB2_13 Depth=2
	i64.mul 	$push12=, $12, $11
	i64.rem_u	$12=, $pop12, $0
.LBB2_15:                               # %for.inc9.i131
                                        #   in Loop: Header=BB2_13 Depth=2
	end_block                       # label27:
	i32.const	$push54=, -1
	i32.add 	$2=, $2, $pop54
	i32.const	$push53=, 1
	i32.gt_s	$push13=, $2, $pop53
	br_if   	0, $pop13       # 0: up to label25
	br      	3               # 3: down to label23
.LBB2_16:                               #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label26:
	end_block                       # label24:
	copy_local	$12=, $11
.LBB2_17:                               # %for.body.i88.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label23:
	i64.add 	$14=, $12, $15
	i32.const	$1=, -1
	copy_local	$2=, $3
.LBB2_18:                               # %for.body.i88
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label28:
	i32.const	$push56=, 1
	i32.shr_u	$2=, $2, $pop56
	i32.const	$push55=, 1
	i32.add 	$1=, $1, $pop55
	br_if   	0, $2           # 0: up to label28
# BB#19:                                # %for.end.i90
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label29:
	i32.const	$push57=, 1
	i32.lt_s	$push14=, $1, $pop57
	br_if   	0, $pop14       # 0: down to label13
# BB#20:                                # %for.body4.i99.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push58=, 1
	i32.add 	$2=, $1, $pop58
	copy_local	$12=, $14
.LBB2_21:                               # %for.body4.i99
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label30:
	i64.mul 	$push15=, $12, $12
	i64.rem_u	$12=, $pop15, $0
	block
	i32.const	$push60=, 1
	i32.const	$push59=, -2
	i32.add 	$push16=, $2, $pop59
	i32.shl 	$push17=, $pop60, $pop16
	i32.and 	$push18=, $pop17, $3
	i32.const	$push84=, 0
	i32.eq  	$push85=, $pop18, $pop84
	br_if   	0, $pop85       # 0: down to label32
# BB#22:                                # %if.then5.i102
                                        #   in Loop: Header=BB2_21 Depth=2
	i64.mul 	$push19=, $12, $14
	i64.rem_u	$12=, $pop19, $0
.LBB2_23:                               # %for.inc9.i105
                                        #   in Loop: Header=BB2_21 Depth=2
	end_block                       # label32:
	i32.const	$push62=, -1
	i32.add 	$2=, $2, $pop62
	i32.const	$push61=, 1
	i32.gt_s	$push20=, $2, $pop61
	br_if   	0, $pop20       # 0: up to label30
# BB#24:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label31:
	copy_local	$14=, $12
.LBB2_25:                               # %powmod_ll.exit107
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label13:
	i64.add 	$11=, $14, $15
	i64.sub 	$push22=, $13, $11
	i64.sub 	$push23=, $11, $13
	i64.gt_u	$push21=, $13, $11
	i64.select	$push24=, $pop22, $pop23, $pop21
	i64.const	$push64=, 4294967295
	i64.and 	$push26=, $pop24, $pop64
	i64.const	$push63=, 4294967295
	i64.and 	$push25=, $10, $pop63
	i64.mul 	$push27=, $pop26, $pop25
	i64.rem_u	$10=, $pop27, $0
	block
	i32.ne  	$push28=, $9, $8
	br_if   	0, $pop28       # 0: down to label33
# BB#26:                                # %if.then19
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push67=, 1
	i32.add 	$7=, $7, $pop67
	i64.const	$push66=, 4294967295
	i64.and 	$12=, $10, $pop66
	copy_local	$14=, $0
	block
	i64.const	$push65=, 0
	i64.eq  	$push29=, $0, $pop65
	br_if   	0, $pop29       # 0: down to label34
.LBB2_27:                               # %if.end.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label35:
	i64.rem_u	$12=, $12, $14
	i64.const	$push68=, 0
	i64.eq  	$push30=, $12, $pop68
	br_if   	1, $pop30       # 1: down to label36
# BB#28:                                # %if.end5.i
                                        #   in Loop: Header=BB2_27 Depth=2
	i64.rem_u	$14=, $14, $12
	i64.const	$push69=, 0
	i64.ne  	$push31=, $14, $pop69
	br_if   	0, $pop31       # 0: up to label35
	br      	2               # 2: down to label34
.LBB2_29:                               #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label36:
	copy_local	$12=, $14
.LBB2_30:                               # %gcd_ll.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label34:
	i32.add 	$8=, $7, $8
	i32.wrap/i64	$push72=, $12
	tee_local	$push71=, $2=, $pop72
	i32.const	$push70=, 1
	i32.eq  	$push32=, $pop71, $pop70
	br_if   	0, $pop32       # 0: down to label33
# BB#31:                                # %if.then26
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.store	$discard=, 0($5), $2
	i64.const	$push74=, 4294967295
	i64.and 	$push33=, $12, $pop74
	i64.div_u	$0=, $0, $pop33
	i64.const	$push73=, 1
	i64.eq  	$push34=, $0, $pop73
	br_if   	2, $pop34       # 2: down to label12
# BB#32:                                #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push75=, 4
	i32.add 	$5=, $5, $pop75
.LBB2_33:                               # %for.inc
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label33:
	i32.const	$push77=, 1
	i32.add 	$9=, $9, $pop77
	i32.const	$push76=, 10000
	i32.lt_s	$push35=, $9, $pop76
	br_if   	0, $pop35       # 0: up to label11
.LBB2_34:                               # %cleanup
	end_loop                        # label12:
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
	br_if   	0, $pop8        # 0: down to label37
# BB#1:                                 # %entry
	i64.const	$push9=, -4294967296
	i64.and 	$push0=, $0, $pop9
	i64.const	$push10=, 313532612608
	i64.ne  	$push11=, $pop0, $pop10
	br_if   	0, $pop11       # 0: down to label37
# BB#2:                                 # %entry
	i32.const	$push18=, 0
	i32.load	$push1=, factab+8($pop18):p2align=3
	i32.const	$push12=, 262657
	i32.ne  	$push13=, $pop1, $pop12
	br_if   	0, $pop13       # 0: down to label37
# BB#3:                                 # %if.end
	i32.const	$push14=, 0
	call    	exit@FUNCTION, $pop14
	unreachable
.LBB3_4:                                # %if.then
	end_block                       # label37:
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
