	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990127-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %while.end
	i32.const	$2=, 10
	i32.const	$push30=, 0
	i32.const	$push27=, 0
	i32.load	$push28=, __stack_pointer($pop27)
	i32.const	$push29=, 16
	i32.sub 	$push63=, $pop28, $pop29
	i32.store	$push66=, __stack_pointer($pop30), $pop63
	tee_local	$push65=, $0=, $pop66
	i32.const	$push64=, 10
	i32.store	$drop=, 12($pop65), $pop64
	i32.const	$push0=, 20
	i32.store	$drop=, 8($0), $pop0
	i32.const	$push1=, 2
	i32.store	$drop=, 8($0), $pop1
	i32.const	$push2=, 9
	i32.store	$drop=, 12($0), $pop2
	i32.const	$1=, 18
.LBB0_1:                                # %while.body.1
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	copy_local	$3=, $1
	i32.const	$push67=, 4
	i32.lt_s	$push3=, $2, $pop67
	br_if   	1, $pop3        # 1: down to label1
# BB#2:                                 # %while.body.1.while.cond.1_crit_edge
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load	$push71=, 8($0)
	tee_local	$push70=, $2=, $pop71
	i32.const	$push69=, -1
	i32.add 	$push4=, $pop70, $pop69
	i32.store	$drop=, 8($0), $pop4
	i32.const	$push68=, 1
	i32.add 	$1=, $3, $pop68
	br_if   	0, $2           # 0: up to label0
.LBB0_3:                                # %while.end.1
	end_loop                        # label1:
	i32.const	$push72=, 3
	i32.add 	$3=, $3, $pop72
	i32.const	$push31=, 12
	i32.add 	$push32=, $0, $pop31
	copy_local	$2=, $pop32
.LBB0_4:                                # %while.cond.2
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.load	$push75=, 0($2)
	tee_local	$push74=, $1=, $pop75
	i32.const	$push73=, -1
	i32.add 	$push5=, $pop74, $pop73
	i32.store	$drop=, 0($2), $pop5
	i32.eqz 	$push120=, $1
	br_if   	1, $pop120      # 1: down to label3
# BB#5:                                 # %while.body.2
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$push77=, 1
	i32.add 	$3=, $3, $pop77
	i32.const	$push61=, 8
	i32.add 	$push62=, $0, $pop61
	copy_local	$2=, $pop62
	i32.const	$push76=, 3
	i32.gt_s	$push6=, $1, $pop76
	br_if   	0, $pop6        # 0: up to label2
.LBB0_6:                                # %while.end.2
	end_loop                        # label3:
	i32.const	$push78=, 1
	i32.add 	$3=, $3, $pop78
	i32.const	$push33=, 12
	i32.add 	$push34=, $0, $pop33
	copy_local	$2=, $pop34
.LBB0_7:                                # %while.cond.3
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load	$push81=, 0($2)
	tee_local	$push80=, $1=, $pop81
	i32.const	$push79=, -1
	i32.add 	$push7=, $pop80, $pop79
	i32.store	$drop=, 0($2), $pop7
	i32.eqz 	$push121=, $1
	br_if   	1, $pop121      # 1: down to label5
# BB#8:                                 # %while.body.3
                                        #   in Loop: Header=BB0_7 Depth=1
	i32.const	$push83=, 1
	i32.add 	$3=, $3, $pop83
	i32.const	$push59=, 8
	i32.add 	$push60=, $0, $pop59
	copy_local	$2=, $pop60
	i32.const	$push82=, 3
	i32.gt_s	$push8=, $1, $pop82
	br_if   	0, $pop8        # 0: up to label4
.LBB0_9:                                # %while.end.3
	end_loop                        # label5:
	i32.const	$push84=, 1
	i32.add 	$3=, $3, $pop84
	i32.const	$push35=, 12
	i32.add 	$push36=, $0, $pop35
	copy_local	$2=, $pop36
.LBB0_10:                               # %while.cond.4
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.load	$push87=, 0($2)
	tee_local	$push86=, $1=, $pop87
	i32.const	$push85=, -1
	i32.add 	$push9=, $pop86, $pop85
	i32.store	$drop=, 0($2), $pop9
	i32.eqz 	$push122=, $1
	br_if   	1, $pop122      # 1: down to label7
# BB#11:                                # %while.body.4
                                        #   in Loop: Header=BB0_10 Depth=1
	i32.const	$push89=, 1
	i32.add 	$3=, $3, $pop89
	i32.const	$push57=, 8
	i32.add 	$push58=, $0, $pop57
	copy_local	$2=, $pop58
	i32.const	$push88=, 3
	i32.gt_s	$push10=, $1, $pop88
	br_if   	0, $pop10       # 0: up to label6
.LBB0_12:                               # %while.end.4
	end_loop                        # label7:
	i32.const	$push90=, 1
	i32.add 	$3=, $3, $pop90
	i32.const	$push37=, 12
	i32.add 	$push38=, $0, $pop37
	copy_local	$2=, $pop38
.LBB0_13:                               # %while.cond.5
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	i32.load	$push93=, 0($2)
	tee_local	$push92=, $1=, $pop93
	i32.const	$push91=, -1
	i32.add 	$push11=, $pop92, $pop91
	i32.store	$drop=, 0($2), $pop11
	i32.eqz 	$push123=, $1
	br_if   	1, $pop123      # 1: down to label9
# BB#14:                                # %while.body.5
                                        #   in Loop: Header=BB0_13 Depth=1
	i32.const	$push95=, 1
	i32.add 	$3=, $3, $pop95
	i32.const	$push55=, 8
	i32.add 	$push56=, $0, $pop55
	copy_local	$2=, $pop56
	i32.const	$push94=, 3
	i32.gt_s	$push12=, $1, $pop94
	br_if   	0, $pop12       # 0: up to label8
.LBB0_15:                               # %while.end.5
	end_loop                        # label9:
	i32.const	$push96=, 1
	i32.add 	$3=, $3, $pop96
	i32.const	$push39=, 12
	i32.add 	$push40=, $0, $pop39
	copy_local	$2=, $pop40
.LBB0_16:                               # %while.cond.6
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.load	$push99=, 0($2)
	tee_local	$push98=, $1=, $pop99
	i32.const	$push97=, -1
	i32.add 	$push13=, $pop98, $pop97
	i32.store	$drop=, 0($2), $pop13
	i32.eqz 	$push124=, $1
	br_if   	1, $pop124      # 1: down to label11
# BB#17:                                # %while.body.6
                                        #   in Loop: Header=BB0_16 Depth=1
	i32.const	$push101=, 1
	i32.add 	$3=, $3, $pop101
	i32.const	$push53=, 8
	i32.add 	$push54=, $0, $pop53
	copy_local	$2=, $pop54
	i32.const	$push100=, 3
	i32.gt_s	$push14=, $1, $pop100
	br_if   	0, $pop14       # 0: up to label10
.LBB0_18:                               # %while.end.6
	end_loop                        # label11:
	i32.const	$push102=, 1
	i32.add 	$3=, $3, $pop102
	i32.const	$push41=, 12
	i32.add 	$push42=, $0, $pop41
	copy_local	$2=, $pop42
.LBB0_19:                               # %while.cond.7
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label12:
	i32.load	$push105=, 0($2)
	tee_local	$push104=, $1=, $pop105
	i32.const	$push103=, -1
	i32.add 	$push15=, $pop104, $pop103
	i32.store	$drop=, 0($2), $pop15
	i32.eqz 	$push125=, $1
	br_if   	1, $pop125      # 1: down to label13
# BB#20:                                # %while.body.7
                                        #   in Loop: Header=BB0_19 Depth=1
	i32.const	$push107=, 1
	i32.add 	$3=, $3, $pop107
	i32.const	$push51=, 8
	i32.add 	$push52=, $0, $pop51
	copy_local	$2=, $pop52
	i32.const	$push106=, 3
	i32.gt_s	$push16=, $1, $pop106
	br_if   	0, $pop16       # 0: up to label12
.LBB0_21:                               # %while.end.7
	end_loop                        # label13:
	i32.const	$push108=, 1
	i32.add 	$3=, $3, $pop108
	i32.const	$push43=, 12
	i32.add 	$push44=, $0, $pop43
	copy_local	$2=, $pop44
.LBB0_22:                               # %while.cond.8
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label14:
	i32.load	$push111=, 0($2)
	tee_local	$push110=, $1=, $pop111
	i32.const	$push109=, -1
	i32.add 	$push17=, $pop110, $pop109
	i32.store	$drop=, 0($2), $pop17
	i32.eqz 	$push126=, $1
	br_if   	1, $pop126      # 1: down to label15
# BB#23:                                # %while.body.8
                                        #   in Loop: Header=BB0_22 Depth=1
	i32.const	$push113=, 1
	i32.add 	$3=, $3, $pop113
	i32.const	$push49=, 8
	i32.add 	$push50=, $0, $pop49
	copy_local	$2=, $pop50
	i32.const	$push112=, 3
	i32.gt_s	$push18=, $1, $pop112
	br_if   	0, $pop18       # 0: up to label14
.LBB0_24:                               # %while.end.8
	end_loop                        # label15:
	i32.const	$push114=, 1
	i32.add 	$3=, $3, $pop114
	i32.const	$push45=, 12
	i32.add 	$push46=, $0, $pop45
	copy_local	$2=, $pop46
.LBB0_25:                               # %while.cond.9
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	i32.load	$push117=, 0($2)
	tee_local	$push116=, $1=, $pop117
	i32.const	$push115=, -1
	i32.add 	$push19=, $pop116, $pop115
	i32.store	$drop=, 0($2), $pop19
	i32.eqz 	$push127=, $1
	br_if   	1, $pop127      # 1: down to label17
# BB#26:                                # %while.body.9
                                        #   in Loop: Header=BB0_25 Depth=1
	i32.const	$push119=, 1
	i32.add 	$3=, $3, $pop119
	i32.const	$push47=, 8
	i32.add 	$push48=, $0, $pop47
	copy_local	$2=, $pop48
	i32.const	$push118=, 3
	i32.gt_s	$push20=, $1, $pop118
	br_if   	0, $pop20       # 0: up to label16
.LBB0_27:                               # %while.end.9
	end_loop                        # label17:
	block
	i32.load	$push22=, 8($0)
	i32.const	$push21=, -5
	i32.ne  	$push23=, $pop22, $pop21
	br_if   	0, $pop23       # 0: down to label18
# BB#28:                                # %while.end.9
	i32.const	$push24=, 42
	i32.ne  	$push25=, $3, $pop24
	br_if   	0, $pop25       # 0: down to label18
# BB#29:                                # %if.end13
	i32.const	$push26=, 0
	call    	exit@FUNCTION, $pop26
	unreachable
.LBB0_30:                               # %if.then12
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
