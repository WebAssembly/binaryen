	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memcpy-1.c"
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
	i32.const	$push40=, 0
	i32.const	$push37=, 0
	i32.load	$push38=, __stack_pointer($pop37)
	i32.const	$push39=, 696320
	i32.sub 	$push54=, $pop38, $pop39
	tee_local	$push53=, $1=, $pop54
	i32.store	__stack_pointer($pop40), $pop53
	i32.const	$2=, 0
	i32.const	$push52=, 0
	i32.const	$push51=, 348160
	i32.call	$drop=, memset@FUNCTION, $1, $pop52, $pop51
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push41=, 348160
	i32.add 	$push42=, $1, $pop41
	i32.add 	$push2=, $pop42, $2
	i32.store8	0($pop2), $2
	i32.const	$push58=, 1
	i32.add 	$push57=, $2, $pop58
	tee_local	$push56=, $2=, $pop57
	i32.const	$push55=, 348160
	i32.ne  	$push3=, $pop56, $pop55
	br_if   	0, $pop3        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop
	i32.const	$push43=, 348160
	i32.add 	$push44=, $1, $pop43
	i32.const	$push4=, 2720
	i32.call	$drop=, memcpy@FUNCTION, $1, $pop44, $pop4
	i32.const	$2=, 0
.LBB1_3:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	block   	
	loop    	                # label4:
	i32.add 	$push6=, $1, $2
	i32.load8_u	$push7=, 0($pop6)
	i32.const	$push59=, 255
	i32.and 	$push5=, $2, $pop59
	i32.ne  	$push8=, $pop7, $pop5
	br_if   	1, $pop8        # 1: down to label3
# BB#4:                                 # %for.cond3
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push63=, 1
	i32.add 	$push62=, $2, $pop63
	tee_local	$push61=, $2=, $pop62
	i32.const	$push60=, 2719
	i32.le_u	$push9=, $pop61, $pop60
	br_if   	0, $pop9        # 0: up to label4
# BB#5:                                 # %for.end15
	end_loop
	i32.const	$push64=, 1
	i32.const	$push10=, 2720
	i32.call	$0=, memset@FUNCTION, $1, $pop64, $pop10
	i32.const	$2=, 1
.LBB1_6:                                # %for.cond17
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label6:
	i32.const	$push65=, 2719
	i32.gt_u	$push11=, $2, $pop65
	br_if   	1, $pop11       # 1: down to label5
# BB#7:                                 # %for.cond17.for.body20_crit_edge
                                        #   in Loop: Header=BB1_6 Depth=1
	i32.add 	$1=, $0, $2
	i32.const	$push67=, 1
	i32.add 	$push0=, $2, $pop67
	copy_local	$2=, $pop0
	i32.load8_u	$push35=, 0($1)
	i32.const	$push66=, 1
	i32.eq  	$push36=, $pop35, $pop66
	br_if   	0, $pop36       # 0: up to label6
# BB#8:                                 # %if.then25
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB1_9:                                # %for.end29
	end_block                       # label5:
	i32.const	$push45=, 348160
	i32.add 	$push46=, $0, $pop45
	i32.const	$push12=, 348160
	i32.call	$1=, memcpy@FUNCTION, $0, $pop46, $pop12
	i32.const	$2=, 0
.LBB1_10:                               # %for.body35
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label7:
	i32.add 	$push14=, $1, $2
	i32.load8_u	$push15=, 0($pop14)
	i32.const	$push68=, 255
	i32.and 	$push13=, $2, $pop68
	i32.ne  	$push16=, $pop15, $pop13
	br_if   	2, $pop16       # 2: down to label2
# BB#11:                                # %for.cond32
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.const	$push72=, 1
	i32.add 	$push71=, $2, $pop72
	tee_local	$push70=, $2=, $pop71
	i32.const	$push69=, 348159
	i32.le_u	$push17=, $pop70, $pop69
	br_if   	0, $pop17       # 0: up to label7
# BB#12:                                # %for.end46
	end_loop
	i32.const	$push19=, 0
	i32.const	$push18=, 348160
	i32.call	$0=, memset@FUNCTION, $1, $pop19, $pop18
	i32.const	$2=, 1
.LBB1_13:                               # %for.cond48
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label9:
	i32.const	$push73=, 348159
	i32.gt_u	$push20=, $2, $pop73
	br_if   	1, $pop20       # 1: down to label8
# BB#14:                                # %for.cond48.for.body51_crit_edge
                                        #   in Loop: Header=BB1_13 Depth=1
	i32.add 	$1=, $0, $2
	i32.const	$push74=, 1
	i32.add 	$push1=, $2, $pop74
	copy_local	$2=, $pop1
	i32.load8_u	$push34=, 0($1)
	i32.eqz 	$push85=, $pop34
	br_if   	0, $pop85       # 0: up to label9
# BB#15:                                # %if.then56
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB1_16:                               # %for.end60
	end_block                       # label8:
	i32.const	$push47=, 348160
	i32.add 	$push48=, $0, $pop47
	i32.const	$push21=, 2720
	i32.call	$1=, memcpy@FUNCTION, $0, $pop48, $pop21
	i32.const	$2=, 0
.LBB1_17:                               # %for.body66
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label10:
	i32.add 	$push23=, $1, $2
	i32.load8_u	$push24=, 0($pop23)
	i32.const	$push75=, 255
	i32.and 	$push22=, $2, $pop75
	i32.ne  	$push25=, $pop24, $pop22
	br_if   	3, $pop25       # 3: down to label1
# BB#18:                                # %for.cond63
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.const	$push79=, 1
	i32.add 	$push78=, $2, $pop79
	tee_local	$push77=, $2=, $pop78
	i32.const	$push76=, 2719
	i32.le_u	$push26=, $pop77, $pop76
	br_if   	0, $pop26       # 0: up to label10
# BB#19:                                # %for.end77
	end_loop
	i32.const	$push49=, 348160
	i32.add 	$push50=, $1, $pop49
	i32.const	$push27=, 348160
	i32.call	$drop=, memcpy@FUNCTION, $1, $pop50, $pop27
	i32.const	$2=, 0
.LBB1_20:                               # %for.body85
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label12:
	i32.add 	$push29=, $1, $2
	i32.load8_u	$push30=, 0($pop29)
	i32.const	$push80=, 255
	i32.and 	$push28=, $2, $pop80
	i32.ne  	$push31=, $pop30, $pop28
	br_if   	1, $pop31       # 1: down to label11
# BB#21:                                # %for.cond82
                                        #   in Loop: Header=BB1_20 Depth=1
	i32.const	$push84=, 1
	i32.add 	$push83=, $2, $pop84
	tee_local	$push82=, $2=, $pop83
	i32.const	$push81=, 348159
	i32.le_u	$push32=, $pop82, $pop81
	br_if   	0, $pop32       # 0: up to label12
# BB#22:                                # %for.end96
	end_loop
	i32.const	$push33=, 0
	call    	exit@FUNCTION, $pop33
	unreachable
.LBB1_23:                               # %if.then92
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB1_24:                               # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_25:                               # %if.then42
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_26:                               # %if.then73
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
