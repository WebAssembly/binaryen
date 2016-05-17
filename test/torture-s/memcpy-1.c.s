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
	return  	$pop0
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
	i32.const	$push40=, __stack_pointer
	i32.const	$push37=, __stack_pointer
	i32.load	$push38=, 0($pop37)
	i32.const	$push39=, 696320
	i32.sub 	$push51=, $pop38, $pop39
	i32.store	$push1=, 0($pop40), $pop51
	i32.const	$push53=, 0
	i32.const	$push52=, 348160
	i32.call	$1=, memset@FUNCTION, $pop1, $pop53, $pop52
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push41=, 348160
	i32.add 	$push42=, $1, $pop41
	i32.add 	$push2=, $pop42, $2
	i32.store8	$push0=, 0($pop2), $2
	i32.const	$push57=, 1
	i32.add 	$push56=, $pop0, $pop57
	tee_local	$push55=, $2=, $pop56
	i32.const	$push54=, 348160
	i32.ne  	$push3=, $pop55, $pop54
	br_if   	0, $pop3        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	i32.const	$push43=, 348160
	i32.add 	$push44=, $1, $pop43
	i32.const	$push4=, 2720
	i32.call	$discard=, memcpy@FUNCTION, $1, $pop44, $pop4
	i32.const	$2=, 0
.LBB1_3:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	block
	loop                            # label5:
	i32.add 	$push5=, $1, $2
	i32.load8_u	$push6=, 0($pop5)
	i32.const	$push58=, 255
	i32.and 	$push7=, $2, $pop58
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	2, $pop8        # 2: down to label4
# BB#4:                                 # %for.cond3
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push60=, 1
	i32.add 	$2=, $2, $pop60
	i32.const	$push59=, 2719
	i32.le_u	$push9=, $2, $pop59
	br_if   	0, $pop9        # 0: up to label5
# BB#5:                                 # %for.end15
	end_loop                        # label6:
	i32.const	$push61=, 1
	i32.const	$push10=, 2720
	i32.call	$0=, memset@FUNCTION, $1, $pop61, $pop10
	i32.const	$2=, 1
.LBB1_6:                                # %for.cond18
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label8:
	i32.const	$push62=, 2719
	i32.gt_u	$push11=, $2, $pop62
	br_if   	2, $pop11       # 2: down to label7
# BB#7:                                 # %for.cond18.for.body21_crit_edge
                                        #   in Loop: Header=BB1_6 Depth=1
	i32.add 	$1=, $0, $2
	i32.const	$push64=, 1
	i32.add 	$2=, $2, $pop64
	i32.load8_u	$push35=, 0($1)
	i32.const	$push63=, 1
	i32.eq  	$push36=, $pop35, $pop63
	br_if   	0, $pop36       # 0: up to label8
# BB#8:                                 # %if.then26
	end_loop                        # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_9:                                # %for.end30
	end_block                       # label7:
	i32.const	$push45=, 348160
	i32.add 	$push46=, $0, $pop45
	i32.const	$push12=, 348160
	i32.call	$1=, memcpy@FUNCTION, $0, $pop46, $pop12
	i32.const	$2=, 0
.LBB1_10:                               # %for.body37
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.add 	$push13=, $1, $2
	i32.load8_u	$push14=, 0($pop13)
	i32.const	$push65=, 255
	i32.and 	$push15=, $2, $pop65
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	3, $pop16       # 3: down to label3
# BB#11:                                # %for.cond34
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.const	$push67=, 1
	i32.add 	$2=, $2, $pop67
	i32.const	$push66=, 348159
	i32.le_u	$push17=, $2, $pop66
	br_if   	0, $pop17       # 0: up to label10
# BB#12:                                # %for.end48
	end_loop                        # label11:
	i32.const	$push19=, 0
	i32.const	$push18=, 348160
	i32.call	$0=, memset@FUNCTION, $1, $pop19, $pop18
	i32.const	$2=, 1
.LBB1_13:                               # %for.cond51
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label13:
	i32.const	$push68=, 348159
	i32.gt_u	$push20=, $2, $pop68
	br_if   	2, $pop20       # 2: down to label12
# BB#14:                                # %for.cond51.for.body54_crit_edge
                                        #   in Loop: Header=BB1_13 Depth=1
	i32.add 	$1=, $0, $2
	i32.const	$push69=, 1
	i32.add 	$2=, $2, $pop69
	i32.load8_u	$push34=, 0($1)
	i32.eqz 	$push76=, $pop34
	br_if   	0, $pop76       # 0: up to label13
# BB#15:                                # %if.then59
	end_loop                        # label14:
	call    	abort@FUNCTION
	unreachable
.LBB1_16:                               # %for.end63
	end_block                       # label12:
	i32.const	$push47=, 348160
	i32.add 	$push48=, $0, $pop47
	i32.const	$push21=, 2720
	i32.call	$1=, memcpy@FUNCTION, $0, $pop48, $pop21
	i32.const	$2=, 0
.LBB1_17:                               # %for.body70
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label15:
	i32.add 	$push22=, $1, $2
	i32.load8_u	$push23=, 0($pop22)
	i32.const	$push70=, 255
	i32.and 	$push24=, $2, $pop70
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	4, $pop25       # 4: down to label2
# BB#18:                                # %for.cond67
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.const	$push72=, 1
	i32.add 	$2=, $2, $pop72
	i32.const	$push71=, 2719
	i32.le_u	$push26=, $2, $pop71
	br_if   	0, $pop26       # 0: up to label15
# BB#19:                                # %for.end81
	end_loop                        # label16:
	i32.const	$push49=, 348160
	i32.add 	$push50=, $1, $pop49
	i32.const	$push27=, 348160
	i32.call	$discard=, memcpy@FUNCTION, $1, $pop50, $pop27
	i32.const	$2=, 0
.LBB1_20:                               # %for.body90
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label18:
	i32.add 	$push28=, $1, $2
	i32.load8_u	$push29=, 0($pop28)
	i32.const	$push73=, 255
	i32.and 	$push30=, $2, $pop73
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	2, $pop31       # 2: down to label17
# BB#21:                                # %for.cond87
                                        #   in Loop: Header=BB1_20 Depth=1
	i32.const	$push75=, 1
	i32.add 	$2=, $2, $pop75
	i32.const	$push74=, 348159
	i32.le_u	$push32=, $2, $pop74
	br_if   	0, $pop32       # 0: up to label18
# BB#22:                                # %for.end101
	end_loop                        # label19:
	i32.const	$push33=, 0
	call    	exit@FUNCTION, $pop33
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
