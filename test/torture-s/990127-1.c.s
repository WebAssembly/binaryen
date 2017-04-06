	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990127-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %while.end
	i32.const	$push30=, 0
	i32.const	$push28=, 0
	i32.load	$push27=, __stack_pointer($pop28)
	i32.const	$push29=, 16
	i32.sub 	$push65=, $pop27, $pop29
	tee_local	$push64=, $4=, $pop65
	i32.store	__stack_pointer($pop30), $pop64
	i32.const	$3=, 10
	i32.const	$push63=, 10
	i32.store	12($4), $pop63
	i32.const	$push0=, 20
	i32.store	8($4), $pop0
	i32.const	$push1=, 2
	i32.store	8($4), $pop1
	i32.const	$push2=, 9
	i32.store	12($4), $pop2
	i32.const	$1=, 21
	i32.load	$0=, 8($4)
.LBB0_1:                                # %while.body.1
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	loop    	                # label2:
	copy_local	$0=, $0
	copy_local	$2=, $1
	i32.const	$push66=, 4
	i32.lt_s	$push3=, $3, $pop66
	br_if   	1, $pop3        # 1: down to label1
# BB#2:                                 # %while.body.1.while.cond.1_crit_edge
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push71=, 1
	i32.add 	$1=, $2, $pop71
	copy_local	$3=, $0
	i32.const	$push70=, -1
	i32.add 	$push69=, $0, $pop70
	tee_local	$push68=, $0=, $pop69
	i32.const	$push67=, -1
	i32.ne  	$push4=, $pop68, $pop67
	br_if   	0, $pop4        # 0: up to label2
	br      	2               # 2: down to label0
.LBB0_3:
	end_loop
	end_block                       # label1:
	copy_local	$0=, $0
.LBB0_4:                                # %while.end.1
	end_block                       # label0:
	i32.store	8($4), $0
	i32.const	$push31=, 12
	i32.add 	$push32=, $4, $pop31
	copy_local	$0=, $pop32
.LBB0_5:                                # %while.cond.2
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	i32.load	$push74=, 0($0)
	tee_local	$push73=, $3=, $pop74
	i32.const	$push72=, -1
	i32.add 	$push5=, $pop73, $pop72
	i32.store	0($0), $pop5
	i32.eqz 	$push119=, $3
	br_if   	1, $pop119      # 1: down to label3
# BB#6:                                 # %while.body.2
                                        #   in Loop: Header=BB0_5 Depth=1
	i32.const	$push76=, 1
	i32.add 	$2=, $2, $pop76
	i32.const	$push61=, 8
	i32.add 	$push62=, $4, $pop61
	copy_local	$0=, $pop62
	i32.const	$push75=, 3
	i32.gt_s	$push6=, $3, $pop75
	br_if   	0, $pop6        # 0: up to label4
.LBB0_7:                                # %while.end.2
	end_loop
	end_block                       # label3:
	i32.const	$push77=, 1
	i32.add 	$3=, $2, $pop77
	i32.const	$push33=, 12
	i32.add 	$push34=, $4, $pop33
	copy_local	$2=, $pop34
.LBB0_8:                                # %while.cond.3
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label6:
	i32.load	$push80=, 0($2)
	tee_local	$push79=, $0=, $pop80
	i32.const	$push78=, -1
	i32.add 	$push7=, $pop79, $pop78
	i32.store	0($2), $pop7
	i32.eqz 	$push120=, $0
	br_if   	1, $pop120      # 1: down to label5
# BB#9:                                 # %while.body.3
                                        #   in Loop: Header=BB0_8 Depth=1
	i32.const	$push82=, 1
	i32.add 	$3=, $3, $pop82
	i32.const	$push59=, 8
	i32.add 	$push60=, $4, $pop59
	copy_local	$2=, $pop60
	i32.const	$push81=, 3
	i32.gt_s	$push8=, $0, $pop81
	br_if   	0, $pop8        # 0: up to label6
.LBB0_10:                               # %while.end.3
	end_loop
	end_block                       # label5:
	i32.const	$push83=, 1
	i32.add 	$3=, $3, $pop83
	i32.const	$push35=, 12
	i32.add 	$push36=, $4, $pop35
	copy_local	$2=, $pop36
.LBB0_11:                               # %while.cond.4
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label8:
	i32.load	$push86=, 0($2)
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, -1
	i32.add 	$push9=, $pop85, $pop84
	i32.store	0($2), $pop9
	i32.eqz 	$push121=, $0
	br_if   	1, $pop121      # 1: down to label7
# BB#12:                                # %while.body.4
                                        #   in Loop: Header=BB0_11 Depth=1
	i32.const	$push88=, 1
	i32.add 	$3=, $3, $pop88
	i32.const	$push57=, 8
	i32.add 	$push58=, $4, $pop57
	copy_local	$2=, $pop58
	i32.const	$push87=, 3
	i32.gt_s	$push10=, $0, $pop87
	br_if   	0, $pop10       # 0: up to label8
.LBB0_13:                               # %while.end.4
	end_loop
	end_block                       # label7:
	i32.const	$push89=, 1
	i32.add 	$3=, $3, $pop89
	i32.const	$push37=, 12
	i32.add 	$push38=, $4, $pop37
	copy_local	$2=, $pop38
.LBB0_14:                               # %while.cond.5
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label10:
	i32.load	$push92=, 0($2)
	tee_local	$push91=, $0=, $pop92
	i32.const	$push90=, -1
	i32.add 	$push11=, $pop91, $pop90
	i32.store	0($2), $pop11
	i32.eqz 	$push122=, $0
	br_if   	1, $pop122      # 1: down to label9
# BB#15:                                # %while.body.5
                                        #   in Loop: Header=BB0_14 Depth=1
	i32.const	$push94=, 1
	i32.add 	$3=, $3, $pop94
	i32.const	$push55=, 8
	i32.add 	$push56=, $4, $pop55
	copy_local	$2=, $pop56
	i32.const	$push93=, 3
	i32.gt_s	$push12=, $0, $pop93
	br_if   	0, $pop12       # 0: up to label10
.LBB0_16:                               # %while.end.5
	end_loop
	end_block                       # label9:
	i32.const	$push95=, 1
	i32.add 	$3=, $3, $pop95
	i32.const	$push39=, 12
	i32.add 	$push40=, $4, $pop39
	copy_local	$2=, $pop40
.LBB0_17:                               # %while.cond.6
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label12:
	i32.load	$push98=, 0($2)
	tee_local	$push97=, $0=, $pop98
	i32.const	$push96=, -1
	i32.add 	$push13=, $pop97, $pop96
	i32.store	0($2), $pop13
	i32.eqz 	$push123=, $0
	br_if   	1, $pop123      # 1: down to label11
# BB#18:                                # %while.body.6
                                        #   in Loop: Header=BB0_17 Depth=1
	i32.const	$push100=, 1
	i32.add 	$3=, $3, $pop100
	i32.const	$push53=, 8
	i32.add 	$push54=, $4, $pop53
	copy_local	$2=, $pop54
	i32.const	$push99=, 3
	i32.gt_s	$push14=, $0, $pop99
	br_if   	0, $pop14       # 0: up to label12
.LBB0_19:                               # %while.end.6
	end_loop
	end_block                       # label11:
	i32.const	$push101=, 1
	i32.add 	$3=, $3, $pop101
	i32.const	$push41=, 12
	i32.add 	$push42=, $4, $pop41
	copy_local	$2=, $pop42
.LBB0_20:                               # %while.cond.7
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label14:
	i32.load	$push104=, 0($2)
	tee_local	$push103=, $0=, $pop104
	i32.const	$push102=, -1
	i32.add 	$push15=, $pop103, $pop102
	i32.store	0($2), $pop15
	i32.eqz 	$push124=, $0
	br_if   	1, $pop124      # 1: down to label13
# BB#21:                                # %while.body.7
                                        #   in Loop: Header=BB0_20 Depth=1
	i32.const	$push106=, 1
	i32.add 	$3=, $3, $pop106
	i32.const	$push51=, 8
	i32.add 	$push52=, $4, $pop51
	copy_local	$2=, $pop52
	i32.const	$push105=, 3
	i32.gt_s	$push16=, $0, $pop105
	br_if   	0, $pop16       # 0: up to label14
.LBB0_22:                               # %while.end.7
	end_loop
	end_block                       # label13:
	i32.const	$push107=, 1
	i32.add 	$3=, $3, $pop107
	i32.const	$push43=, 12
	i32.add 	$push44=, $4, $pop43
	copy_local	$2=, $pop44
.LBB0_23:                               # %while.cond.8
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label16:
	i32.load	$push110=, 0($2)
	tee_local	$push109=, $0=, $pop110
	i32.const	$push108=, -1
	i32.add 	$push17=, $pop109, $pop108
	i32.store	0($2), $pop17
	i32.eqz 	$push125=, $0
	br_if   	1, $pop125      # 1: down to label15
# BB#24:                                # %while.body.8
                                        #   in Loop: Header=BB0_23 Depth=1
	i32.const	$push112=, 1
	i32.add 	$3=, $3, $pop112
	i32.const	$push49=, 8
	i32.add 	$push50=, $4, $pop49
	copy_local	$2=, $pop50
	i32.const	$push111=, 3
	i32.gt_s	$push18=, $0, $pop111
	br_if   	0, $pop18       # 0: up to label16
.LBB0_25:                               # %while.end.8
	end_loop
	end_block                       # label15:
	i32.const	$push113=, 1
	i32.add 	$3=, $3, $pop113
	i32.const	$push45=, 12
	i32.add 	$push46=, $4, $pop45
	copy_local	$2=, $pop46
.LBB0_26:                               # %while.cond.9
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label18:
	i32.load	$push116=, 0($2)
	tee_local	$push115=, $0=, $pop116
	i32.const	$push114=, -1
	i32.add 	$push19=, $pop115, $pop114
	i32.store	0($2), $pop19
	i32.eqz 	$push126=, $0
	br_if   	1, $pop126      # 1: down to label17
# BB#27:                                # %while.body.9
                                        #   in Loop: Header=BB0_26 Depth=1
	i32.const	$push118=, 1
	i32.add 	$3=, $3, $pop118
	i32.const	$push47=, 8
	i32.add 	$push48=, $4, $pop47
	copy_local	$2=, $pop48
	i32.const	$push117=, 3
	i32.gt_s	$push20=, $0, $pop117
	br_if   	0, $pop20       # 0: up to label18
.LBB0_28:                               # %while.end.9
	end_loop
	end_block                       # label17:
	block   	
	i32.load	$push22=, 8($4)
	i32.const	$push21=, -5
	i32.ne  	$push23=, $pop22, $pop21
	br_if   	0, $pop23       # 0: down to label19
# BB#29:                                # %while.end.9
	i32.const	$push24=, 42
	i32.ne  	$push25=, $3, $pop24
	br_if   	0, $pop25       # 0: down to label19
# BB#30:                                # %if.end13
	i32.const	$push26=, 0
	call    	exit@FUNCTION, $pop26
	unreachable
.LBB0_31:                               # %if.then12
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	exit, void, i32
