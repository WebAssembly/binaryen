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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push94=, __stack_pointer
	i32.load	$push95=, 0($pop94)
	i32.const	$push96=, 64
	i32.sub 	$33=, $pop95, $pop96
	i32.const	$push97=, __stack_pointer
	i32.store	$discard=, 0($pop97), $33
	i32.const	$push0=, 12
	i32.store16	$discard=, 56($33):p2align=3, $pop0
	i32.const	$push1=, 0
	i32.store16	$discard=, 58($33), $pop1
	i32.load	$push3=, 56($33):p2align=3
	i32.store	$discard=, 60($33), $pop3
	i32.const	$4=, 56
	i32.add 	$4=, $33, $4
	i32.store	$discard=, 0($33):p2align=4, $4
	i32.const	$5=, 56
	i32.add 	$5=, $33, $5
	i32.store	$discard=, 4($33), $5
	i32.const	$6=, 56
	i32.add 	$6=, $33, $6
	i32.store	$discard=, 8($33):p2align=3, $6
	i32.const	$7=, 56
	i32.add 	$7=, $33, $7
	i32.store	$discard=, 12($33), $7
	i32.const	$8=, 56
	i32.add 	$8=, $33, $8
	i32.store	$discard=, 16($33):p2align=4, $8
	i32.const	$9=, 56
	i32.add 	$9=, $33, $9
	i32.store	$discard=, 20($33), $9
	i32.const	$10=, 56
	i32.add 	$10=, $33, $10
	i32.store	$discard=, 24($33):p2align=3, $10
	i32.const	$11=, 56
	i32.add 	$11=, $33, $11
	i32.store	$discard=, 28($33), $11
	i32.const	$12=, 56
	i32.add 	$12=, $33, $12
	i32.store	$discard=, 32($33):p2align=4, $12
	i32.const	$13=, 56
	i32.add 	$13=, $33, $13
	i32.store	$discard=, 36($33), $13
	i32.const	$14=, 56
	i32.add 	$14=, $33, $14
	i32.store	$discard=, 40($33):p2align=3, $14
	i32.const	$15=, 56
	i32.add 	$15=, $33, $15
	i32.store	$discard=, 44($33), $15
	i32.const	$16=, 56
	i32.add 	$16=, $33, $16
	i32.store	$discard=, 48($33):p2align=4, $16
	i32.const	$17=, 56
	i32.add 	$17=, $33, $17
	i32.store	$discard=, 52($33), $17
	block
	block
	block
	i32.call	$push4=, inet_check_attr@FUNCTION, $0, $33
	br_if   	0, $pop4        # 0: down to label5
# BB#1:                                 # %for.body9.preheader
	i32.const	$18=, 56
	i32.add 	$18=, $33, $18
	copy_local	$1=, $18
	i32.load	$push18=, 0($33):p2align=4
	i32.const	$push2=, 4
	i32.const	$19=, 56
	i32.add 	$19=, $33, $19
	i32.or  	$push88=, $19, $pop2
	tee_local	$push87=, $0=, $pop88
	i32.ne  	$push39=, $pop18, $pop87
	br_if   	2, $pop39       # 2: down to label3
# BB#2:                                 # %for.body9.preheader
	i32.load	$push5=, 4($33)
	i32.ne  	$push40=, $pop5, $0
	br_if   	2, $pop40       # 2: down to label3
# BB#3:                                 # %for.body9.preheader
	i32.load	$push6=, 8($33):p2align=3
	i32.ne  	$push41=, $pop6, $0
	br_if   	2, $pop41       # 2: down to label3
# BB#4:                                 # %for.body9.preheader
	i32.load	$push7=, 12($33)
	i32.ne  	$push42=, $pop7, $0
	br_if   	2, $pop42       # 2: down to label3
# BB#5:                                 # %for.body9.preheader
	i32.const	$push19=, 16
	i32.add 	$push20=, $33, $pop19
	i32.load	$push8=, 0($pop20):p2align=4
	i32.ne  	$push43=, $pop8, $0
	br_if   	2, $pop43       # 2: down to label3
# BB#6:                                 # %for.body9.preheader
	i32.const	$push21=, 20
	i32.add 	$push22=, $33, $pop21
	i32.load	$push9=, 0($pop22)
	i32.ne  	$push44=, $pop9, $0
	br_if   	2, $pop44       # 2: down to label3
# BB#7:                                 # %for.body9.preheader
	i32.const	$push23=, 24
	i32.add 	$push24=, $33, $pop23
	i32.load	$push10=, 0($pop24):p2align=3
	i32.ne  	$push45=, $pop10, $0
	br_if   	2, $pop45       # 2: down to label3
# BB#8:                                 # %for.body9.preheader
	i32.const	$push25=, 28
	i32.add 	$push26=, $33, $pop25
	i32.load	$push11=, 0($pop26)
	i32.ne  	$push46=, $pop11, $1
	br_if   	2, $pop46       # 2: down to label3
# BB#9:                                 # %for.body9.preheader
	i32.const	$push27=, 32
	i32.add 	$push28=, $33, $pop27
	i32.load	$push12=, 0($pop28):p2align=4
	i32.ne  	$push47=, $pop12, $1
	br_if   	2, $pop47       # 2: down to label3
# BB#10:                                # %for.body9.preheader
	i32.const	$push29=, 36
	i32.add 	$push30=, $33, $pop29
	i32.load	$push13=, 0($pop30)
	i32.ne  	$push48=, $pop13, $0
	br_if   	2, $pop48       # 2: down to label3
# BB#11:                                # %for.body9.preheader
	i32.const	$push31=, 40
	i32.add 	$push32=, $33, $pop31
	i32.load	$push14=, 0($pop32):p2align=3
	i32.ne  	$push49=, $pop14, $0
	br_if   	2, $pop49       # 2: down to label3
# BB#12:                                # %for.body9.preheader
	i32.const	$push33=, 44
	i32.add 	$push34=, $33, $pop33
	i32.load	$push15=, 0($pop34)
	i32.ne  	$push50=, $pop15, $0
	br_if   	2, $pop50       # 2: down to label3
# BB#13:                                # %for.body9.preheader
	i32.const	$push35=, 48
	i32.add 	$push36=, $33, $pop35
	i32.load	$push16=, 0($pop36):p2align=4
	i32.ne  	$push51=, $pop16, $0
	br_if   	2, $pop51       # 2: down to label3
# BB#14:                                # %for.body9.preheader
	i32.const	$push37=, 52
	i32.add 	$push38=, $33, $pop37
	i32.load	$push17=, 0($pop38)
	i32.ne  	$push52=, $pop17, $0
	br_if   	2, $pop52       # 2: down to label3
# BB#15:                                # %for.cond7.13
	i32.const	$push53=, 16
	i32.add 	$push54=, $33, $pop53
	i32.const	$20=, 56
	i32.add 	$20=, $33, $20
	i32.store	$discard=, 0($pop54):p2align=4, $20
	i32.const	$push55=, 24
	i32.add 	$push56=, $33, $pop55
	i32.const	$21=, 56
	i32.add 	$21=, $33, $21
	i32.store	$discard=, 0($pop56):p2align=3, $21
	i32.const	$push57=, 28
	i32.add 	$push58=, $33, $pop57
	i32.const	$22=, 56
	i32.add 	$22=, $33, $22
	i32.store	$discard=, 0($pop58), $22
	i32.const	$push59=, 32
	i32.add 	$push60=, $33, $pop59
	i32.const	$23=, 56
	i32.add 	$23=, $33, $23
	i32.store	$discard=, 0($pop60):p2align=4, $23
	i32.const	$push61=, 36
	i32.add 	$push62=, $33, $pop61
	i32.const	$24=, 56
	i32.add 	$24=, $33, $24
	i32.store	$discard=, 0($pop62), $24
	i32.const	$push63=, 40
	i32.add 	$push64=, $33, $pop63
	i32.const	$25=, 56
	i32.add 	$25=, $33, $25
	i32.store	$discard=, 0($pop64):p2align=3, $25
	i32.const	$push65=, 44
	i32.add 	$push66=, $33, $pop65
	i32.const	$26=, 56
	i32.add 	$26=, $33, $26
	i32.store	$discard=, 0($pop66), $26
	i32.const	$push67=, 48
	i32.add 	$push68=, $33, $pop67
	i32.const	$27=, 56
	i32.add 	$27=, $33, $27
	i32.store	$discard=, 0($pop68):p2align=4, $27
	i32.load16_u	$1=, 60($33):p2align=2
	i32.const	$push69=, 52
	i32.add 	$push70=, $33, $pop69
	i32.const	$28=, 56
	i32.add 	$28=, $33, $28
	i32.store	$discard=, 0($pop70), $28
	i32.const	$push72=, 65528
	i32.add 	$push73=, $1, $pop72
	i32.store16	$discard=, 60($33):p2align=2, $pop73
	i32.const	$push74=, 20
	i32.add 	$push75=, $33, $pop74
	i32.store	$3=, 0($pop75), $0
	i32.const	$29=, 56
	i32.add 	$29=, $33, $29
	i32.store	$discard=, 0($33):p2align=4, $29
	i32.const	$30=, 56
	i32.add 	$30=, $33, $30
	i32.store	$discard=, 8($33):p2align=3, $30
	i32.const	$31=, 56
	i32.add 	$31=, $33, $31
	i32.store	$discard=, 12($33), $31
	i32.const	$push71=, 0
	i32.store	$0=, 4($33), $pop71
	i32.call	$push76=, inet_check_attr@FUNCTION, $0, $33
	i32.const	$push77=, -22
	i32.ne  	$push78=, $pop76, $pop77
	br_if   	2, $pop78       # 2: down to label3
# BB#16:                                # %for.body43.preheader
	i32.load	$2=, 4($33)
.LBB1_17:                               # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label7:
	block
	i32.const	$push89=, 1
	i32.ne  	$push79=, $0, $pop89
	br_if   	0, $pop79       # 0: down to label9
# BB#18:                                # %land.lhs.true
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.const	$0=, 2
	i32.const	$push100=, 0
	i32.eq  	$push101=, $2, $pop100
	br_if   	1, $pop101      # 1: up to label7
	br      	3               # 3: down to label6
.LBB1_19:                               # %if.else
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label9:
	i32.const	$push91=, 2
	i32.shl 	$push80=, $0, $pop91
	i32.add 	$push81=, $33, $pop80
	i32.load	$1=, 0($pop81)
	block
	block
	i32.const	$push90=, 5
	i32.gt_s	$push82=, $0, $pop90
	br_if   	0, $pop82       # 0: down to label11
# BB#20:                                # %land.lhs.true55
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.eq  	$push84=, $1, $3
	br_if   	1, $pop84       # 1: down to label10
	br      	6               # 6: down to label4
.LBB1_21:                               # %land.lhs.true64
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label11:
	i32.const	$32=, 56
	i32.add 	$32=, $33, $32
	i32.ne  	$push83=, $1, $32
	br_if   	4, $pop83       # 4: down to label5
.LBB1_22:                               # %for.inc73
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label10:
	i32.const	$push93=, 1
	i32.add 	$0=, $0, $pop93
	i32.const	$push92=, 14
	i32.lt_s	$push85=, $0, $pop92
	br_if   	0, $pop85       # 0: up to label7
# BB#23:                                # %for.end75
	end_loop                        # label8:
	i32.const	$push86=, 0
	i32.const	$push98=, 64
	i32.add 	$33=, $33, $pop98
	i32.const	$push99=, __stack_pointer
	i32.store	$discard=, 0($pop99), $33
	return  	$pop86
.LBB1_24:                               # %if.then49
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_25:                               # %if.then69
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_26:                               # %if.then60
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_27:                               # %if.then38
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
