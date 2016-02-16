	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990127-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %while.end
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$21=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$21=, 0($4), $21
	i32.const	$push1=, 20
	i32.store	$discard=, 8($21), $pop1
	i32.const	$push2=, 2
	i32.store	$discard=, 8($21), $pop2
	i32.const	$push0=, 10
	i32.store	$0=, 12($21), $pop0
	i32.const	$push3=, 9
	i32.store	$discard=, 12($21), $pop3
	i32.const	$2=, 18
.LBB0_1:                                # %while.body.1
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	copy_local	$1=, $2
	i32.const	$push28=, 4
	i32.lt_s	$push4=, $0, $pop28
	br_if   	1, $pop4        # 1: down to label1
# BB#2:                                 # %while.body.1.while.cond.1_crit_edge
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load	$0=, 8($21)
	i32.const	$push30=, -1
	i32.add 	$push5=, $0, $pop30
	i32.store	$discard=, 8($21), $pop5
	i32.const	$push29=, 1
	i32.add 	$2=, $1, $pop29
	br_if   	0, $0           # 0: up to label0
.LBB0_3:                                # %while.end.1
	end_loop                        # label1:
	i32.const	$push31=, 3
	i32.add 	$1=, $1, $pop31
	i32.const	$5=, 12
	i32.add 	$5=, $21, $5
	copy_local	$0=, $5
.LBB0_4:                                # %while.cond.2
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.load	$push34=, 0($0)
	tee_local	$push33=, $2=, $pop34
	i32.const	$push32=, -1
	i32.add 	$push6=, $pop33, $pop32
	i32.store	$discard=, 0($0), $pop6
	i32.const	$push79=, 0
	i32.eq  	$push80=, $2, $pop79
	br_if   	1, $pop80       # 1: down to label3
# BB#5:                                 # %while.body.2
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$push36=, 1
	i32.add 	$1=, $1, $pop36
	i32.const	$20=, 8
	i32.add 	$20=, $21, $20
	copy_local	$0=, $20
	i32.const	$push35=, 3
	i32.gt_s	$push7=, $2, $pop35
	br_if   	0, $pop7        # 0: up to label2
.LBB0_6:                                # %while.end.2
	end_loop                        # label3:
	i32.const	$push37=, 1
	i32.add 	$1=, $1, $pop37
	i32.const	$6=, 12
	i32.add 	$6=, $21, $6
	copy_local	$0=, $6
.LBB0_7:                                # %while.cond.3
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load	$push40=, 0($0)
	tee_local	$push39=, $2=, $pop40
	i32.const	$push38=, -1
	i32.add 	$push8=, $pop39, $pop38
	i32.store	$discard=, 0($0), $pop8
	i32.const	$push81=, 0
	i32.eq  	$push82=, $2, $pop81
	br_if   	1, $pop82       # 1: down to label5
# BB#8:                                 # %while.body.3
                                        #   in Loop: Header=BB0_7 Depth=1
	i32.const	$push42=, 1
	i32.add 	$1=, $1, $pop42
	i32.const	$19=, 8
	i32.add 	$19=, $21, $19
	copy_local	$0=, $19
	i32.const	$push41=, 3
	i32.gt_s	$push9=, $2, $pop41
	br_if   	0, $pop9        # 0: up to label4
.LBB0_9:                                # %while.end.3
	end_loop                        # label5:
	i32.const	$push43=, 1
	i32.add 	$1=, $1, $pop43
	i32.const	$7=, 12
	i32.add 	$7=, $21, $7
	copy_local	$0=, $7
.LBB0_10:                               # %while.cond.4
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.load	$push46=, 0($0)
	tee_local	$push45=, $2=, $pop46
	i32.const	$push44=, -1
	i32.add 	$push10=, $pop45, $pop44
	i32.store	$discard=, 0($0), $pop10
	i32.const	$push83=, 0
	i32.eq  	$push84=, $2, $pop83
	br_if   	1, $pop84       # 1: down to label7
# BB#11:                                # %while.body.4
                                        #   in Loop: Header=BB0_10 Depth=1
	i32.const	$push48=, 1
	i32.add 	$1=, $1, $pop48
	i32.const	$18=, 8
	i32.add 	$18=, $21, $18
	copy_local	$0=, $18
	i32.const	$push47=, 3
	i32.gt_s	$push11=, $2, $pop47
	br_if   	0, $pop11       # 0: up to label6
.LBB0_12:                               # %while.end.4
	end_loop                        # label7:
	i32.const	$push49=, 1
	i32.add 	$1=, $1, $pop49
	i32.const	$8=, 12
	i32.add 	$8=, $21, $8
	copy_local	$0=, $8
.LBB0_13:                               # %while.cond.5
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	i32.load	$push52=, 0($0)
	tee_local	$push51=, $2=, $pop52
	i32.const	$push50=, -1
	i32.add 	$push12=, $pop51, $pop50
	i32.store	$discard=, 0($0), $pop12
	i32.const	$push85=, 0
	i32.eq  	$push86=, $2, $pop85
	br_if   	1, $pop86       # 1: down to label9
# BB#14:                                # %while.body.5
                                        #   in Loop: Header=BB0_13 Depth=1
	i32.const	$push54=, 1
	i32.add 	$1=, $1, $pop54
	i32.const	$17=, 8
	i32.add 	$17=, $21, $17
	copy_local	$0=, $17
	i32.const	$push53=, 3
	i32.gt_s	$push13=, $2, $pop53
	br_if   	0, $pop13       # 0: up to label8
.LBB0_15:                               # %while.end.5
	end_loop                        # label9:
	i32.const	$push55=, 1
	i32.add 	$1=, $1, $pop55
	i32.const	$9=, 12
	i32.add 	$9=, $21, $9
	copy_local	$0=, $9
.LBB0_16:                               # %while.cond.6
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.load	$push58=, 0($0)
	tee_local	$push57=, $2=, $pop58
	i32.const	$push56=, -1
	i32.add 	$push14=, $pop57, $pop56
	i32.store	$discard=, 0($0), $pop14
	i32.const	$push87=, 0
	i32.eq  	$push88=, $2, $pop87
	br_if   	1, $pop88       # 1: down to label11
# BB#17:                                # %while.body.6
                                        #   in Loop: Header=BB0_16 Depth=1
	i32.const	$push60=, 1
	i32.add 	$1=, $1, $pop60
	i32.const	$16=, 8
	i32.add 	$16=, $21, $16
	copy_local	$0=, $16
	i32.const	$push59=, 3
	i32.gt_s	$push15=, $2, $pop59
	br_if   	0, $pop15       # 0: up to label10
.LBB0_18:                               # %while.end.6
	end_loop                        # label11:
	i32.const	$push61=, 1
	i32.add 	$1=, $1, $pop61
	i32.const	$10=, 12
	i32.add 	$10=, $21, $10
	copy_local	$0=, $10
.LBB0_19:                               # %while.cond.7
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label12:
	i32.load	$push64=, 0($0)
	tee_local	$push63=, $2=, $pop64
	i32.const	$push62=, -1
	i32.add 	$push16=, $pop63, $pop62
	i32.store	$discard=, 0($0), $pop16
	i32.const	$push89=, 0
	i32.eq  	$push90=, $2, $pop89
	br_if   	1, $pop90       # 1: down to label13
# BB#20:                                # %while.body.7
                                        #   in Loop: Header=BB0_19 Depth=1
	i32.const	$push66=, 1
	i32.add 	$1=, $1, $pop66
	i32.const	$15=, 8
	i32.add 	$15=, $21, $15
	copy_local	$0=, $15
	i32.const	$push65=, 3
	i32.gt_s	$push17=, $2, $pop65
	br_if   	0, $pop17       # 0: up to label12
.LBB0_21:                               # %while.end.7
	end_loop                        # label13:
	i32.const	$push67=, 1
	i32.add 	$1=, $1, $pop67
	i32.const	$11=, 12
	i32.add 	$11=, $21, $11
	copy_local	$0=, $11
.LBB0_22:                               # %while.cond.8
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label14:
	i32.load	$push70=, 0($0)
	tee_local	$push69=, $2=, $pop70
	i32.const	$push68=, -1
	i32.add 	$push18=, $pop69, $pop68
	i32.store	$discard=, 0($0), $pop18
	i32.const	$push91=, 0
	i32.eq  	$push92=, $2, $pop91
	br_if   	1, $pop92       # 1: down to label15
# BB#23:                                # %while.body.8
                                        #   in Loop: Header=BB0_22 Depth=1
	i32.const	$push72=, 1
	i32.add 	$1=, $1, $pop72
	i32.const	$14=, 8
	i32.add 	$14=, $21, $14
	copy_local	$0=, $14
	i32.const	$push71=, 3
	i32.gt_s	$push19=, $2, $pop71
	br_if   	0, $pop19       # 0: up to label14
.LBB0_24:                               # %while.end.8
	end_loop                        # label15:
	i32.const	$push73=, 1
	i32.add 	$1=, $1, $pop73
	i32.const	$12=, 12
	i32.add 	$12=, $21, $12
	copy_local	$0=, $12
.LBB0_25:                               # %while.cond.9
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	i32.load	$push76=, 0($0)
	tee_local	$push75=, $2=, $pop76
	i32.const	$push74=, -1
	i32.add 	$push20=, $pop75, $pop74
	i32.store	$discard=, 0($0), $pop20
	i32.const	$push93=, 0
	i32.eq  	$push94=, $2, $pop93
	br_if   	1, $pop94       # 1: down to label17
# BB#26:                                # %while.body.9
                                        #   in Loop: Header=BB0_25 Depth=1
	i32.const	$push78=, 1
	i32.add 	$1=, $1, $pop78
	i32.const	$13=, 8
	i32.add 	$13=, $21, $13
	copy_local	$0=, $13
	i32.const	$push77=, 3
	i32.gt_s	$push21=, $2, $pop77
	br_if   	0, $pop21       # 0: up to label16
.LBB0_27:                               # %while.end.9
	end_loop                        # label17:
	block
	i32.load	$push22=, 8($21)
	i32.const	$push23=, -5
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label18
# BB#28:                                # %while.end.9
	i32.const	$push25=, 42
	i32.ne  	$push26=, $1, $pop25
	br_if   	0, $pop26       # 0: down to label18
# BB#29:                                # %if.end13
	i32.const	$push27=, 0
	call    	exit@FUNCTION, $pop27
	unreachable
.LBB0_30:                               # %if.then12
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
