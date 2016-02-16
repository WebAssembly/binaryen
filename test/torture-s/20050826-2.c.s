	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050826-2.c"
	.section	.text.inet_check_attr,"ax",@progbits
	.hidden	inet_check_attr
	.globl	inet_check_attr
	.type	inet_check_attr,@function
inet_check_attr:                        # @inet_check_attr
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	i32.load	$push8=, 0($1)
	tee_local	$push7=, $4=, $pop8
	i32.const	$push17=, 0
	i32.eq  	$push18=, $pop7, $pop17
	br_if   	0, $pop18       # 0: down to label2
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$3=, -22
	i32.load16_u	$push0=, 0($4)
	i32.const	$push10=, 65532
	i32.and 	$push1=, $pop0, $pop10
	i32.const	$push9=, 4
	i32.eq  	$push2=, $pop1, $pop9
	br_if   	2, $pop2        # 2: down to label1
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push12=, -2
	i32.and 	$push3=, $2, $pop12
	i32.const	$push11=, 8
	i32.eq  	$push4=, $pop3, $pop11
	br_if   	0, $pop4        # 0: down to label2
# BB#4:                                 # %if.then9
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push13=, 4
	i32.add 	$push5=, $4, $pop13
	i32.store	$discard=, 0($1), $pop5
.LBB0_5:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push16=, 1
	i32.add 	$2=, $2, $pop16
	i32.const	$push15=, 4
	i32.add 	$1=, $1, $pop15
	i32.const	$3=, 0
	i32.const	$push14=, 15
	i32.lt_s	$push6=, $2, $pop14
	br_if   	0, $pop6        # 0: up to label0
.LBB0_6:                                # %cleanup14
	end_loop                        # label1:
	return  	$3
	.endfunc
.Lfunc_end0:
	.size	inet_check_attr, .Lfunc_end0-inet_check_attr

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 64
	i32.sub 	$39=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$39=, 0($6), $39
	i32.const	$push1=, 2
	i32.const	$8=, 56
	i32.add 	$8=, $39, $8
	i32.or  	$push2=, $8, $pop1
	i32.const	$push3=, 0
	i32.store16	$discard=, 0($pop2), $pop3
	i32.const	$push0=, 12
	i32.store16	$1=, 56($39):p2align=3, $pop0
	i32.const	$push4=, 4
	i32.const	$9=, 56
	i32.add 	$9=, $39, $9
	i32.or  	$push104=, $9, $pop4
	tee_local	$push103=, $0=, $pop104
	i32.load	$push5=, 56($39):p2align=3
	i32.store	$discard=, 0($pop103), $pop5
	i32.const	$10=, 56
	i32.add 	$10=, $39, $10
	i32.store	$discard=, 0($39):p2align=4, $10
	i32.const	$push102=, 4
	i32.or  	$push101=, $39, $pop102
	tee_local	$push100=, $2=, $pop101
	i32.const	$11=, 56
	i32.add 	$11=, $39, $11
	i32.store	$discard=, 0($pop100), $11
	i32.const	$push6=, 8
	i32.or  	$push99=, $39, $pop6
	tee_local	$push98=, $3=, $pop99
	i32.const	$12=, 56
	i32.add 	$12=, $39, $12
	i32.store	$discard=, 0($pop98):p2align=3, $12
	i32.or  	$push97=, $39, $1
	tee_local	$push96=, $4=, $pop97
	i32.const	$13=, 56
	i32.add 	$13=, $39, $13
	i32.store	$discard=, 0($pop96), $13
	i32.const	$14=, 56
	i32.add 	$14=, $39, $14
	i32.store	$discard=, 16($39):p2align=4, $14
	i32.const	$15=, 56
	i32.add 	$15=, $39, $15
	i32.store	$discard=, 20($39), $15
	i32.const	$16=, 56
	i32.add 	$16=, $39, $16
	i32.store	$discard=, 24($39):p2align=3, $16
	i32.const	$17=, 56
	i32.add 	$17=, $39, $17
	i32.store	$discard=, 28($39), $17
	i32.const	$18=, 56
	i32.add 	$18=, $39, $18
	i32.store	$discard=, 32($39):p2align=4, $18
	i32.const	$19=, 56
	i32.add 	$19=, $39, $19
	i32.store	$discard=, 36($39), $19
	i32.const	$20=, 56
	i32.add 	$20=, $39, $20
	i32.store	$discard=, 40($39):p2align=3, $20
	i32.const	$21=, 56
	i32.add 	$21=, $39, $21
	i32.store	$discard=, 44($39), $21
	i32.const	$22=, 56
	i32.add 	$22=, $39, $22
	i32.store	$discard=, 48($39):p2align=4, $22
	i32.const	$23=, 56
	i32.add 	$23=, $39, $23
	i32.store	$discard=, 52($39), $23
	block
	block
	block
	i32.call	$push7=, inet_check_attr@FUNCTION, $0, $39
	br_if   	0, $pop7        # 0: down to label5
# BB#1:                                 # %for.body9.preheader
	i32.const	$24=, 56
	i32.add 	$24=, $39, $24
	copy_local	$1=, $24
	i32.load	$push21=, 0($39):p2align=4
	i32.ne  	$push42=, $pop21, $0
	br_if   	1, $pop42       # 1: down to label4
# BB#2:                                 # %for.body9.preheader
	i32.load	$push8=, 0($2)
	i32.ne  	$push43=, $pop8, $0
	br_if   	1, $pop43       # 1: down to label4
# BB#3:                                 # %for.body9.preheader
	i32.load	$push9=, 0($3):p2align=3
	i32.ne  	$push44=, $pop9, $0
	br_if   	1, $pop44       # 1: down to label4
# BB#4:                                 # %for.body9.preheader
	i32.load	$push10=, 0($4)
	i32.ne  	$push45=, $pop10, $0
	br_if   	1, $pop45       # 1: down to label4
# BB#5:                                 # %for.body9.preheader
	i32.const	$push22=, 16
	i32.add 	$push23=, $39, $pop22
	i32.load	$push11=, 0($pop23):p2align=4
	i32.ne  	$push46=, $pop11, $0
	br_if   	1, $pop46       # 1: down to label4
# BB#6:                                 # %for.body9.preheader
	i32.const	$push24=, 20
	i32.add 	$push25=, $39, $pop24
	i32.load	$push12=, 0($pop25)
	i32.ne  	$push47=, $pop12, $0
	br_if   	1, $pop47       # 1: down to label4
# BB#7:                                 # %for.body9.preheader
	i32.const	$push26=, 24
	i32.add 	$push27=, $39, $pop26
	i32.load	$push13=, 0($pop27):p2align=3
	i32.ne  	$push48=, $pop13, $0
	br_if   	1, $pop48       # 1: down to label4
# BB#8:                                 # %for.body9.preheader
	i32.const	$push28=, 28
	i32.add 	$push29=, $39, $pop28
	i32.load	$push14=, 0($pop29)
	i32.ne  	$push49=, $pop14, $1
	br_if   	1, $pop49       # 1: down to label4
# BB#9:                                 # %for.body9.preheader
	i32.const	$push30=, 32
	i32.add 	$push31=, $39, $pop30
	i32.load	$push15=, 0($pop31):p2align=4
	i32.ne  	$push50=, $pop15, $1
	br_if   	1, $pop50       # 1: down to label4
# BB#10:                                # %for.body9.preheader
	i32.const	$push32=, 36
	i32.add 	$push33=, $39, $pop32
	i32.load	$push16=, 0($pop33)
	i32.ne  	$push51=, $pop16, $0
	br_if   	1, $pop51       # 1: down to label4
# BB#11:                                # %for.body9.preheader
	i32.const	$push34=, 40
	i32.add 	$push35=, $39, $pop34
	i32.load	$push17=, 0($pop35):p2align=3
	i32.ne  	$push52=, $pop17, $0
	br_if   	1, $pop52       # 1: down to label4
# BB#12:                                # %for.body9.preheader
	i32.const	$push36=, 44
	i32.add 	$push37=, $39, $pop36
	i32.load	$push18=, 0($pop37)
	i32.ne  	$push53=, $pop18, $0
	br_if   	1, $pop53       # 1: down to label4
# BB#13:                                # %for.body9.preheader
	i32.const	$push38=, 48
	i32.add 	$push39=, $39, $pop38
	i32.load	$push19=, 0($pop39):p2align=4
	i32.ne  	$push54=, $pop19, $0
	br_if   	1, $pop54       # 1: down to label4
# BB#14:                                # %for.body9.preheader
	i32.const	$push40=, 52
	i32.add 	$push41=, $39, $pop40
	i32.load	$push20=, 0($pop41)
	i32.ne  	$push55=, $pop20, $0
	br_if   	1, $pop55       # 1: down to label4
# BB#15:                                # %for.cond7.13
	i32.const	$push78=, 4
	i32.const	$25=, 56
	i32.add 	$25=, $39, $25
	i32.or  	$1=, $25, $pop78
	i32.load16_u	$push80=, 0($1):p2align=2
	i32.const	$push81=, 65528
	i32.add 	$push82=, $pop80, $pop81
	i32.store16	$discard=, 0($1):p2align=2, $pop82
	i32.const	$push56=, 8
	i32.or  	$push57=, $39, $pop56
	i32.const	$26=, 56
	i32.add 	$26=, $39, $26
	i32.store	$discard=, 0($pop57):p2align=3, $26
	i32.const	$push58=, 12
	i32.or  	$push59=, $39, $pop58
	i32.const	$27=, 56
	i32.add 	$27=, $39, $27
	i32.store	$discard=, 0($pop59), $27
	i32.const	$push60=, 16
	i32.add 	$push61=, $39, $pop60
	i32.const	$28=, 56
	i32.add 	$28=, $39, $28
	i32.store	$discard=, 0($pop61):p2align=4, $28
	i32.const	$push62=, 24
	i32.add 	$push63=, $39, $pop62
	i32.const	$29=, 56
	i32.add 	$29=, $39, $29
	i32.store	$discard=, 0($pop63):p2align=3, $29
	i32.const	$push64=, 28
	i32.add 	$push65=, $39, $pop64
	i32.const	$30=, 56
	i32.add 	$30=, $39, $30
	i32.store	$discard=, 0($pop65), $30
	i32.const	$push66=, 32
	i32.add 	$push67=, $39, $pop66
	i32.const	$31=, 56
	i32.add 	$31=, $39, $31
	i32.store	$discard=, 0($pop67):p2align=4, $31
	i32.const	$push68=, 36
	i32.add 	$push69=, $39, $pop68
	i32.const	$32=, 56
	i32.add 	$32=, $39, $32
	i32.store	$discard=, 0($pop69), $32
	i32.const	$push70=, 40
	i32.add 	$push71=, $39, $pop70
	i32.const	$33=, 56
	i32.add 	$33=, $39, $33
	i32.store	$discard=, 0($pop71):p2align=3, $33
	i32.const	$push72=, 44
	i32.add 	$push73=, $39, $pop72
	i32.const	$34=, 56
	i32.add 	$34=, $39, $34
	i32.store	$discard=, 0($pop73), $34
	i32.const	$push74=, 48
	i32.add 	$push75=, $39, $pop74
	i32.const	$35=, 56
	i32.add 	$35=, $39, $35
	i32.store	$discard=, 0($pop75):p2align=4, $35
	i32.const	$push76=, 52
	i32.add 	$push77=, $39, $pop76
	i32.const	$36=, 56
	i32.add 	$36=, $39, $36
	i32.store	$discard=, 0($pop77), $36
	i32.const	$push83=, 20
	i32.add 	$push84=, $39, $pop83
	i32.store	$3=, 0($pop84), $0
	i32.const	$37=, 56
	i32.add 	$37=, $39, $37
	i32.store	$discard=, 0($39):p2align=4, $37
	i32.const	$push112=, 4
	i32.or  	$push111=, $39, $pop112
	tee_local	$push110=, $1=, $pop111
	i32.const	$push79=, 0
	i32.store	$0=, 0($pop110), $pop79
	i32.call	$push85=, inet_check_attr@FUNCTION, $0, $39
	i32.const	$push86=, -22
	i32.ne  	$push87=, $pop85, $pop86
	br_if   	2, $pop87       # 2: down to label3
# BB#16:                                # %for.body43.preheader
	i32.load	$2=, 0($1)
.LBB1_17:                               # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	block
	loop                            # label9:
	block
	i32.const	$push105=, 1
	i32.ne  	$push88=, $0, $pop105
	br_if   	0, $pop88       # 0: down to label11
# BB#18:                                # %land.lhs.true
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.const	$0=, 2
	i32.const	$push113=, 0
	i32.eq  	$push114=, $2, $pop113
	br_if   	1, $pop114      # 1: up to label9
	br      	3               # 3: down to label8
.LBB1_19:                               # %if.else
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label11:
	i32.const	$push107=, 2
	i32.shl 	$push89=, $0, $pop107
	i32.add 	$push90=, $39, $pop89
	i32.load	$1=, 0($pop90)
	block
	block
	i32.const	$push106=, 5
	i32.gt_s	$push91=, $0, $pop106
	br_if   	0, $pop91       # 0: down to label13
# BB#20:                                # %land.lhs.true55
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.eq  	$push93=, $1, $3
	br_if   	1, $pop93       # 1: down to label12
	br      	5               # 5: down to label7
.LBB1_21:                               # %land.lhs.true64
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label13:
	i32.const	$38=, 56
	i32.add 	$38=, $39, $38
	i32.ne  	$push92=, $1, $38
	br_if   	5, $pop92       # 5: down to label6
.LBB1_22:                               # %for.inc73
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label12:
	i32.const	$push109=, 1
	i32.add 	$0=, $0, $pop109
	i32.const	$push108=, 14
	i32.lt_s	$push94=, $0, $pop108
	br_if   	0, $pop94       # 0: up to label9
# BB#23:                                # %for.end75
	end_loop                        # label10:
	i32.const	$push95=, 0
	i32.const	$7=, 64
	i32.add 	$39=, $39, $7
	i32.const	$7=, __stack_pointer
	i32.store	$39=, 0($7), $39
	return  	$pop95
.LBB1_24:                               # %if.then49
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_25:                               # %if.then60
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_26:                               # %if.then69
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_27:                               # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_28:                               # %if.then15
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_29:                               # %if.then38
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
