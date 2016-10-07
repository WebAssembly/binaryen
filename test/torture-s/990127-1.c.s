	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990127-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %while.end
	i32.const	$push30=, 0
	i32.const	$push27=, 0
	i32.load	$push28=, __stack_pointer($pop27)
	i32.const	$push29=, 16
	i32.sub 	$push65=, $pop28, $pop29
	tee_local	$push64=, $3=, $pop65
	i32.store	__stack_pointer($pop30), $pop64
	i32.const	$0=, 10
	i32.const	$push63=, 10
	i32.store	12($3), $pop63
	i32.const	$push0=, 20
	i32.store	8($3), $pop0
	i32.const	$push1=, 2
	i32.store	8($3), $pop1
	i32.const	$push2=, 9
	i32.store	12($3), $pop2
	i32.const	$2=, 21
.LBB0_1:                                # %while.body.1
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	copy_local	$1=, $2
	i32.const	$push66=, 4
	i32.lt_s	$push3=, $0, $pop66
	br_if   	1, $pop3        # 1: down to label0
# BB#2:                                 # %while.body.1.while.cond.1_crit_edge
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load	$push70=, 8($3)
	tee_local	$push69=, $0=, $pop70
	i32.const	$push68=, -1
	i32.add 	$push4=, $pop69, $pop68
	i32.store	8($3), $pop4
	i32.const	$push67=, 1
	i32.add 	$2=, $1, $pop67
	br_if   	0, $0           # 0: up to label1
.LBB0_3:                                # %while.end.1
	end_loop
	end_block                       # label0:
	i32.const	$push31=, 12
	i32.add 	$push32=, $3, $pop31
	copy_local	$0=, $pop32
.LBB0_4:                                # %while.cond.2
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	i32.load	$push73=, 0($0)
	tee_local	$push72=, $2=, $pop73
	i32.const	$push71=, -1
	i32.add 	$push5=, $pop72, $pop71
	i32.store	0($0), $pop5
	i32.eqz 	$push118=, $2
	br_if   	1, $pop118      # 1: down to label2
# BB#5:                                 # %while.body.2
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$push75=, 1
	i32.add 	$1=, $1, $pop75
	i32.const	$push61=, 8
	i32.add 	$push62=, $3, $pop61
	copy_local	$0=, $pop62
	i32.const	$push74=, 3
	i32.gt_s	$push6=, $2, $pop74
	br_if   	0, $pop6        # 0: up to label3
.LBB0_6:                                # %while.end.2
	end_loop
	end_block                       # label2:
	i32.const	$push76=, 1
	i32.add 	$2=, $1, $pop76
	i32.const	$push33=, 12
	i32.add 	$push34=, $3, $pop33
	copy_local	$1=, $pop34
.LBB0_7:                                # %while.cond.3
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label5:
	i32.load	$push79=, 0($1)
	tee_local	$push78=, $0=, $pop79
	i32.const	$push77=, -1
	i32.add 	$push7=, $pop78, $pop77
	i32.store	0($1), $pop7
	i32.eqz 	$push119=, $0
	br_if   	1, $pop119      # 1: down to label4
# BB#8:                                 # %while.body.3
                                        #   in Loop: Header=BB0_7 Depth=1
	i32.const	$push81=, 1
	i32.add 	$2=, $2, $pop81
	i32.const	$push59=, 8
	i32.add 	$push60=, $3, $pop59
	copy_local	$1=, $pop60
	i32.const	$push80=, 3
	i32.gt_s	$push8=, $0, $pop80
	br_if   	0, $pop8        # 0: up to label5
.LBB0_9:                                # %while.end.3
	end_loop
	end_block                       # label4:
	i32.const	$push82=, 1
	i32.add 	$2=, $2, $pop82
	i32.const	$push35=, 12
	i32.add 	$push36=, $3, $pop35
	copy_local	$1=, $pop36
.LBB0_10:                               # %while.cond.4
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label7:
	i32.load	$push85=, 0($1)
	tee_local	$push84=, $0=, $pop85
	i32.const	$push83=, -1
	i32.add 	$push9=, $pop84, $pop83
	i32.store	0($1), $pop9
	i32.eqz 	$push120=, $0
	br_if   	1, $pop120      # 1: down to label6
# BB#11:                                # %while.body.4
                                        #   in Loop: Header=BB0_10 Depth=1
	i32.const	$push87=, 1
	i32.add 	$2=, $2, $pop87
	i32.const	$push57=, 8
	i32.add 	$push58=, $3, $pop57
	copy_local	$1=, $pop58
	i32.const	$push86=, 3
	i32.gt_s	$push10=, $0, $pop86
	br_if   	0, $pop10       # 0: up to label7
.LBB0_12:                               # %while.end.4
	end_loop
	end_block                       # label6:
	i32.const	$push88=, 1
	i32.add 	$2=, $2, $pop88
	i32.const	$push37=, 12
	i32.add 	$push38=, $3, $pop37
	copy_local	$1=, $pop38
.LBB0_13:                               # %while.cond.5
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label9:
	i32.load	$push91=, 0($1)
	tee_local	$push90=, $0=, $pop91
	i32.const	$push89=, -1
	i32.add 	$push11=, $pop90, $pop89
	i32.store	0($1), $pop11
	i32.eqz 	$push121=, $0
	br_if   	1, $pop121      # 1: down to label8
# BB#14:                                # %while.body.5
                                        #   in Loop: Header=BB0_13 Depth=1
	i32.const	$push93=, 1
	i32.add 	$2=, $2, $pop93
	i32.const	$push55=, 8
	i32.add 	$push56=, $3, $pop55
	copy_local	$1=, $pop56
	i32.const	$push92=, 3
	i32.gt_s	$push12=, $0, $pop92
	br_if   	0, $pop12       # 0: up to label9
.LBB0_15:                               # %while.end.5
	end_loop
	end_block                       # label8:
	i32.const	$push94=, 1
	i32.add 	$2=, $2, $pop94
	i32.const	$push39=, 12
	i32.add 	$push40=, $3, $pop39
	copy_local	$1=, $pop40
.LBB0_16:                               # %while.cond.6
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label11:
	i32.load	$push97=, 0($1)
	tee_local	$push96=, $0=, $pop97
	i32.const	$push95=, -1
	i32.add 	$push13=, $pop96, $pop95
	i32.store	0($1), $pop13
	i32.eqz 	$push122=, $0
	br_if   	1, $pop122      # 1: down to label10
# BB#17:                                # %while.body.6
                                        #   in Loop: Header=BB0_16 Depth=1
	i32.const	$push99=, 1
	i32.add 	$2=, $2, $pop99
	i32.const	$push53=, 8
	i32.add 	$push54=, $3, $pop53
	copy_local	$1=, $pop54
	i32.const	$push98=, 3
	i32.gt_s	$push14=, $0, $pop98
	br_if   	0, $pop14       # 0: up to label11
.LBB0_18:                               # %while.end.6
	end_loop
	end_block                       # label10:
	i32.const	$push100=, 1
	i32.add 	$2=, $2, $pop100
	i32.const	$push41=, 12
	i32.add 	$push42=, $3, $pop41
	copy_local	$1=, $pop42
.LBB0_19:                               # %while.cond.7
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label13:
	i32.load	$push103=, 0($1)
	tee_local	$push102=, $0=, $pop103
	i32.const	$push101=, -1
	i32.add 	$push15=, $pop102, $pop101
	i32.store	0($1), $pop15
	i32.eqz 	$push123=, $0
	br_if   	1, $pop123      # 1: down to label12
# BB#20:                                # %while.body.7
                                        #   in Loop: Header=BB0_19 Depth=1
	i32.const	$push105=, 1
	i32.add 	$2=, $2, $pop105
	i32.const	$push51=, 8
	i32.add 	$push52=, $3, $pop51
	copy_local	$1=, $pop52
	i32.const	$push104=, 3
	i32.gt_s	$push16=, $0, $pop104
	br_if   	0, $pop16       # 0: up to label13
.LBB0_21:                               # %while.end.7
	end_loop
	end_block                       # label12:
	i32.const	$push106=, 1
	i32.add 	$2=, $2, $pop106
	i32.const	$push43=, 12
	i32.add 	$push44=, $3, $pop43
	copy_local	$1=, $pop44
.LBB0_22:                               # %while.cond.8
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label15:
	i32.load	$push109=, 0($1)
	tee_local	$push108=, $0=, $pop109
	i32.const	$push107=, -1
	i32.add 	$push17=, $pop108, $pop107
	i32.store	0($1), $pop17
	i32.eqz 	$push124=, $0
	br_if   	1, $pop124      # 1: down to label14
# BB#23:                                # %while.body.8
                                        #   in Loop: Header=BB0_22 Depth=1
	i32.const	$push111=, 1
	i32.add 	$2=, $2, $pop111
	i32.const	$push49=, 8
	i32.add 	$push50=, $3, $pop49
	copy_local	$1=, $pop50
	i32.const	$push110=, 3
	i32.gt_s	$push18=, $0, $pop110
	br_if   	0, $pop18       # 0: up to label15
.LBB0_24:                               # %while.end.8
	end_loop
	end_block                       # label14:
	i32.const	$push112=, 1
	i32.add 	$2=, $2, $pop112
	i32.const	$push45=, 12
	i32.add 	$push46=, $3, $pop45
	copy_local	$1=, $pop46
.LBB0_25:                               # %while.cond.9
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label17:
	i32.load	$push115=, 0($1)
	tee_local	$push114=, $0=, $pop115
	i32.const	$push113=, -1
	i32.add 	$push19=, $pop114, $pop113
	i32.store	0($1), $pop19
	i32.eqz 	$push125=, $0
	br_if   	1, $pop125      # 1: down to label16
# BB#26:                                # %while.body.9
                                        #   in Loop: Header=BB0_25 Depth=1
	i32.const	$push117=, 1
	i32.add 	$2=, $2, $pop117
	i32.const	$push47=, 8
	i32.add 	$push48=, $3, $pop47
	copy_local	$1=, $pop48
	i32.const	$push116=, 3
	i32.gt_s	$push20=, $0, $pop116
	br_if   	0, $pop20       # 0: up to label17
.LBB0_27:                               # %while.end.9
	end_loop
	end_block                       # label16:
	block   	
	i32.load	$push22=, 8($3)
	i32.const	$push21=, -5
	i32.ne  	$push23=, $pop22, $pop21
	br_if   	0, $pop23       # 0: down to label18
# BB#28:                                # %while.end.9
	i32.const	$push24=, 42
	i32.ne  	$push25=, $2, $pop24
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
