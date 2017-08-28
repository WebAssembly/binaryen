	.text
	.file	"memcpy-1.c"
	.section	.text.copy,"ax",@progbits
	.hidden	copy                    # -- Begin function copy
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
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push40=, 0
	i32.const	$push38=, 0
	i32.load	$push37=, __stack_pointer($pop38)
	i32.const	$push39=, 696320
	i32.sub 	$push54=, $pop37, $pop39
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
	loop    	                # label2:
	i32.add 	$push6=, $1, $2
	i32.load8_u	$push7=, 0($pop6)
	i32.const	$push59=, 255
	i32.and 	$push5=, $2, $pop59
	i32.ne  	$push8=, $pop7, $pop5
	br_if   	1, $pop8        # 1: down to label1
# BB#4:                                 # %for.cond3
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push63=, 1
	i32.add 	$push62=, $2, $pop63
	tee_local	$push61=, $2=, $pop62
	i32.const	$push60=, 2719
	i32.le_u	$push9=, $pop61, $pop60
	br_if   	0, $pop9        # 0: up to label2
# BB#5:                                 # %for.end15
	end_loop
	i32.const	$push64=, 1
	i32.const	$push10=, 2720
	i32.call	$0=, memset@FUNCTION, $1, $pop64, $pop10
	i32.const	$2=, 1
.LBB1_6:                                # %for.cond17
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	i32.const	$push65=, 2719
	i32.gt_u	$push11=, $2, $pop65
	br_if   	1, $pop11       # 1: down to label3
# BB#7:                                 # %for.cond17.for.body20_crit_edge
                                        #   in Loop: Header=BB1_6 Depth=1
	i32.add 	$1=, $0, $2
	i32.const	$push67=, 1
	i32.add 	$push0=, $2, $pop67
	copy_local	$2=, $pop0
	i32.load8_u	$push35=, 0($1)
	i32.const	$push66=, 1
	i32.eq  	$push36=, $pop35, $pop66
	br_if   	0, $pop36       # 0: up to label4
	br      	2               # 2: down to label1
.LBB1_8:                                # %for.end29
	end_loop
	end_block                       # label3:
	i32.const	$push45=, 348160
	i32.add 	$push46=, $0, $pop45
	i32.const	$push12=, 348160
	i32.call	$1=, memcpy@FUNCTION, $0, $pop46, $pop12
	i32.const	$2=, 0
.LBB1_9:                                # %for.body35
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.add 	$push14=, $1, $2
	i32.load8_u	$push15=, 0($pop14)
	i32.const	$push68=, 255
	i32.and 	$push13=, $2, $pop68
	i32.ne  	$push16=, $pop15, $pop13
	br_if   	1, $pop16       # 1: down to label1
# BB#10:                                # %for.cond32
                                        #   in Loop: Header=BB1_9 Depth=1
	i32.const	$push72=, 1
	i32.add 	$push71=, $2, $pop72
	tee_local	$push70=, $2=, $pop71
	i32.const	$push69=, 348159
	i32.le_u	$push17=, $pop70, $pop69
	br_if   	0, $pop17       # 0: up to label5
# BB#11:                                # %for.end46
	end_loop
	i32.const	$push19=, 0
	i32.const	$push18=, 348160
	i32.call	$0=, memset@FUNCTION, $1, $pop19, $pop18
	i32.const	$2=, 1
.LBB1_12:                               # %for.cond48
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label7:
	i32.const	$push73=, 348159
	i32.gt_u	$push20=, $2, $pop73
	br_if   	1, $pop20       # 1: down to label6
# BB#13:                                # %for.cond48.for.body51_crit_edge
                                        #   in Loop: Header=BB1_12 Depth=1
	i32.add 	$1=, $0, $2
	i32.const	$push74=, 1
	i32.add 	$push1=, $2, $pop74
	copy_local	$2=, $pop1
	i32.load8_u	$push34=, 0($1)
	i32.eqz 	$push85=, $pop34
	br_if   	0, $pop85       # 0: up to label7
	br      	2               # 2: down to label1
.LBB1_14:                               # %for.end60
	end_loop
	end_block                       # label6:
	i32.const	$push47=, 348160
	i32.add 	$push48=, $0, $pop47
	i32.const	$push21=, 2720
	i32.call	$1=, memcpy@FUNCTION, $0, $pop48, $pop21
	i32.const	$2=, 0
.LBB1_15:                               # %for.body66
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	i32.add 	$push23=, $1, $2
	i32.load8_u	$push24=, 0($pop23)
	i32.const	$push75=, 255
	i32.and 	$push22=, $2, $pop75
	i32.ne  	$push25=, $pop24, $pop22
	br_if   	1, $pop25       # 1: down to label1
# BB#16:                                # %for.cond63
                                        #   in Loop: Header=BB1_15 Depth=1
	i32.const	$push79=, 1
	i32.add 	$push78=, $2, $pop79
	tee_local	$push77=, $2=, $pop78
	i32.const	$push76=, 2719
	i32.le_u	$push26=, $pop77, $pop76
	br_if   	0, $pop26       # 0: up to label8
# BB#17:                                # %for.end77
	end_loop
	i32.const	$push49=, 348160
	i32.add 	$push50=, $1, $pop49
	i32.const	$push27=, 348160
	i32.call	$drop=, memcpy@FUNCTION, $1, $pop50, $pop27
	i32.const	$2=, 0
.LBB1_18:                               # %for.body85
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label9:
	i32.add 	$push29=, $1, $2
	i32.load8_u	$push30=, 0($pop29)
	i32.const	$push80=, 255
	i32.and 	$push28=, $2, $pop80
	i32.ne  	$push31=, $pop30, $pop28
	br_if   	1, $pop31       # 1: down to label1
# BB#19:                                # %for.cond82
                                        #   in Loop: Header=BB1_18 Depth=1
	i32.const	$push84=, 1
	i32.add 	$push83=, $2, $pop84
	tee_local	$push82=, $2=, $pop83
	i32.const	$push81=, 348159
	i32.le_u	$push32=, $pop82, $pop81
	br_if   	0, $pop32       # 0: up to label9
# BB#20:                                # %for.end96
	end_loop
	i32.const	$push33=, 0
	call    	exit@FUNCTION, $pop33
	unreachable
.LBB1_21:                               # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
