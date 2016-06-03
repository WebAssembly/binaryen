	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memcpy-1.c"
	.section	.text.copy,"ax",@progbits
	.hidden	copy
	.globl	copy
	.type	copy,@function
copy:                                   # @copy
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.call	$push0=, memcpy@FUNCTION, $0, $1, $2
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	copy, .Lfunc_end0-copy

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$push42=, 0
	i32.const	$push39=, 0
	i32.load	$push40=, __stack_pointer($pop39)
	i32.const	$push41=, 696320
	i32.sub 	$push53=, $pop40, $pop41
	i32.store	$push1=, __stack_pointer($pop42), $pop53
	i32.const	$push55=, 0
	i32.const	$push54=, 348160
	i32.call	$1=, memset@FUNCTION, $pop1, $pop55, $pop54
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push43=, 348160
	i32.add 	$push44=, $1, $pop43
	i32.add 	$push4=, $pop44, $2
	i32.store8	$push0=, 0($pop4), $2
	i32.const	$push59=, 1
	i32.add 	$push58=, $pop0, $pop59
	tee_local	$push57=, $2=, $pop58
	i32.const	$push56=, 348160
	i32.ne  	$push5=, $pop57, $pop56
	br_if   	0, $pop5        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	i32.const	$push45=, 348160
	i32.add 	$push46=, $1, $pop45
	i32.const	$push6=, 2720
	i32.call	$drop=, memcpy@FUNCTION, $1, $pop46, $pop6
	i32.const	$2=, 0
.LBB1_3:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	block
	loop                            # label5:
	i32.add 	$push8=, $1, $2
	i32.load8_u	$push9=, 0($pop8)
	i32.const	$push60=, 255
	i32.and 	$push7=, $2, $pop60
	i32.ne  	$push10=, $pop9, $pop7
	br_if   	2, $pop10       # 2: down to label4
# BB#4:                                 # %for.cond3
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push64=, 1
	i32.add 	$push63=, $2, $pop64
	tee_local	$push62=, $2=, $pop63
	i32.const	$push61=, 2719
	i32.le_u	$push11=, $pop62, $pop61
	br_if   	0, $pop11       # 0: up to label5
# BB#5:                                 # %for.end15
	end_loop                        # label6:
	i32.const	$push65=, 1
	i32.const	$push12=, 2720
	i32.call	$0=, memset@FUNCTION, $1, $pop65, $pop12
	i32.const	$2=, 1
.LBB1_6:                                # %for.cond18
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label8:
	i32.const	$push66=, 2719
	i32.gt_u	$push13=, $2, $pop66
	br_if   	2, $pop13       # 2: down to label7
# BB#7:                                 # %for.cond18.for.body21_crit_edge
                                        #   in Loop: Header=BB1_6 Depth=1
	i32.add 	$1=, $0, $2
	i32.const	$push68=, 1
	i32.add 	$push2=, $2, $pop68
	copy_local	$2=, $pop2
	i32.load8_u	$push37=, 0($1)
	i32.const	$push67=, 1
	i32.eq  	$push38=, $pop37, $pop67
	br_if   	0, $pop38       # 0: up to label8
# BB#8:                                 # %if.then26
	end_loop                        # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_9:                                # %for.end30
	end_block                       # label7:
	i32.const	$push47=, 348160
	i32.add 	$push48=, $0, $pop47
	i32.const	$push14=, 348160
	i32.call	$1=, memcpy@FUNCTION, $0, $pop48, $pop14
	i32.const	$2=, 0
.LBB1_10:                               # %for.body37
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.add 	$push16=, $1, $2
	i32.load8_u	$push17=, 0($pop16)
	i32.const	$push69=, 255
	i32.and 	$push15=, $2, $pop69
	i32.ne  	$push18=, $pop17, $pop15
	br_if   	3, $pop18       # 3: down to label3
# BB#11:                                # %for.cond34
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.const	$push73=, 1
	i32.add 	$push72=, $2, $pop73
	tee_local	$push71=, $2=, $pop72
	i32.const	$push70=, 348159
	i32.le_u	$push19=, $pop71, $pop70
	br_if   	0, $pop19       # 0: up to label10
# BB#12:                                # %for.end48
	end_loop                        # label11:
	i32.const	$push21=, 0
	i32.const	$push20=, 348160
	i32.call	$0=, memset@FUNCTION, $1, $pop21, $pop20
	i32.const	$2=, 1
.LBB1_13:                               # %for.cond51
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label13:
	i32.const	$push74=, 348159
	i32.gt_u	$push22=, $2, $pop74
	br_if   	2, $pop22       # 2: down to label12
# BB#14:                                # %for.cond51.for.body54_crit_edge
                                        #   in Loop: Header=BB1_13 Depth=1
	i32.add 	$1=, $0, $2
	i32.const	$push75=, 1
	i32.add 	$push3=, $2, $pop75
	copy_local	$2=, $pop3
	i32.load8_u	$push36=, 0($1)
	i32.eqz 	$push86=, $pop36
	br_if   	0, $pop86       # 0: up to label13
# BB#15:                                # %if.then59
	end_loop                        # label14:
	call    	abort@FUNCTION
	unreachable
.LBB1_16:                               # %for.end63
	end_block                       # label12:
	i32.const	$push49=, 348160
	i32.add 	$push50=, $0, $pop49
	i32.const	$push23=, 2720
	i32.call	$1=, memcpy@FUNCTION, $0, $pop50, $pop23
	i32.const	$2=, 0
.LBB1_17:                               # %for.body70
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label15:
	i32.add 	$push25=, $1, $2
	i32.load8_u	$push26=, 0($pop25)
	i32.const	$push76=, 255
	i32.and 	$push24=, $2, $pop76
	i32.ne  	$push27=, $pop26, $pop24
	br_if   	4, $pop27       # 4: down to label2
# BB#18:                                # %for.cond67
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.const	$push80=, 1
	i32.add 	$push79=, $2, $pop80
	tee_local	$push78=, $2=, $pop79
	i32.const	$push77=, 2719
	i32.le_u	$push28=, $pop78, $pop77
	br_if   	0, $pop28       # 0: up to label15
# BB#19:                                # %for.end81
	end_loop                        # label16:
	i32.const	$push51=, 348160
	i32.add 	$push52=, $1, $pop51
	i32.const	$push29=, 348160
	i32.call	$drop=, memcpy@FUNCTION, $1, $pop52, $pop29
	i32.const	$2=, 0
.LBB1_20:                               # %for.body90
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label18:
	i32.add 	$push31=, $1, $2
	i32.load8_u	$push32=, 0($pop31)
	i32.const	$push81=, 255
	i32.and 	$push30=, $2, $pop81
	i32.ne  	$push33=, $pop32, $pop30
	br_if   	2, $pop33       # 2: down to label17
# BB#21:                                # %for.cond87
                                        #   in Loop: Header=BB1_20 Depth=1
	i32.const	$push85=, 1
	i32.add 	$push84=, $2, $pop85
	tee_local	$push83=, $2=, $pop84
	i32.const	$push82=, 348159
	i32.le_u	$push34=, $pop83, $pop82
	br_if   	0, $pop34       # 0: up to label18
# BB#22:                                # %for.end101
	end_loop                        # label19:
	i32.const	$push35=, 0
	call    	exit@FUNCTION, $pop35
	unreachable
.LBB1_23:                               # %if.then97
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB1_24:                               # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_25:                               # %if.then44
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_26:                               # %if.then77
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
