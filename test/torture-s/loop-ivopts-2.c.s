	.text
	.file	"loop-ivopts-2.c"
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, -1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.load	$push6=, 0($0)
	i32.const	$push14=, 8
	i32.const	$push13=, 7
	i32.const	$push12=, -255
	i32.add 	$push0=, $1, $pop12
	i32.const	$push11=, 23
	i32.gt_u	$push1=, $pop0, $pop11
	i32.select	$push2=, $pop14, $pop13, $pop1
	i32.const	$push10=, -143
	i32.add 	$push3=, $1, $pop10
	i32.const	$push9=, 112
	i32.lt_u	$push4=, $pop3, $pop9
	i32.add 	$push5=, $pop2, $pop4
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	1, $pop7        # 1: down to label0
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push19=, 4
	i32.add 	$0=, $0, $pop19
	i32.const	$push18=, 1
	i32.add 	$push17=, $1, $pop18
	tee_local	$push16=, $1=, $pop17
	i32.const	$push15=, 286
	i32.le_u	$push8=, $pop16, $pop15
	br_if   	0, $pop8        # 0: up to label1
# BB#3:                                 # %for.end
	end_loop
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push26=, 0
	i32.const	$push24=, 0
	i32.load	$push23=, __stack_pointer($pop24)
	i32.const	$push25=, 1152
	i32.sub 	$push31=, $pop23, $pop25
	tee_local	$push30=, $2=, $pop31
	i32.store	__stack_pointer($pop26), $pop30
	i32.const	$1=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.add 	$push0=, $2, $1
	i32.const	$push36=, 8
	i32.store	0($pop0), $pop36
	i32.const	$push35=, 4
	i32.add 	$push34=, $1, $pop35
	tee_local	$push33=, $1=, $pop34
	i32.const	$push32=, 576
	i32.ne  	$push1=, $pop33, $pop32
	br_if   	0, $pop1        # 0: up to label2
# BB#2:                                 # %for.body3.preheader
	end_loop
	i32.const	$push2=, 576
	i32.add 	$1=, $2, $pop2
	i32.const	$0=, 143
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push42=, 9
	i32.store	0($1), $pop42
	i32.const	$push41=, 4
	i32.add 	$1=, $1, $pop41
	i32.const	$push40=, 1
	i32.add 	$push39=, $0, $pop40
	tee_local	$push38=, $0=, $pop39
	i32.const	$push37=, 255
	i32.lt_s	$push3=, $pop38, $pop37
	br_if   	0, $pop3        # 0: up to label3
# BB#4:                                 # %for.end7
	end_loop
	block   	
	block   	
	i32.const	$push4=, 278
	i32.gt_s	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label5
# BB#5:                                 # %for.body10.preheader
.LBB1_6:                                # %for.body10
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i32.const	$push48=, 7
	i32.store	0($1), $pop48
	i32.const	$push47=, 4
	i32.add 	$1=, $1, $pop47
	i32.const	$push46=, 1
	i32.add 	$push45=, $0, $pop46
	tee_local	$push44=, $0=, $pop45
	i32.const	$push43=, 279
	i32.lt_s	$push6=, $pop44, $pop43
	br_if   	0, $pop6        # 0: up to label6
# BB#7:                                 # %for.end14.loopexit
	end_loop
	i32.const	$push7=, 1
	i32.add 	$1=, $0, $pop7
	br      	1               # 1: down to label4
.LBB1_8:
	end_block                       # label5:
	i32.const	$push49=, 1
	i32.add 	$1=, $0, $pop49
.LBB1_9:                                # %for.end14
	end_block                       # label4:
	block   	
	i32.const	$push50=, 287
	i32.gt_s	$push8=, $1, $pop50
	br_if   	0, $pop8        # 0: down to label7
# BB#10:                                # %for.body17.preheader
	i32.const	$push9=, -1
	i32.add 	$0=, $1, $pop9
	i32.const	$push10=, 2
	i32.shl 	$push11=, $1, $pop10
	i32.add 	$1=, $2, $pop11
.LBB1_11:                               # %for.body17
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	i32.const	$push56=, 8
	i32.store	0($1), $pop56
	i32.const	$push55=, 4
	i32.add 	$1=, $1, $pop55
	i32.const	$push54=, 1
	i32.add 	$push53=, $0, $pop54
	tee_local	$push52=, $0=, $pop53
	i32.const	$push51=, 287
	i32.lt_s	$push12=, $pop52, $pop51
	br_if   	0, $pop12       # 0: up to label8
.LBB1_12:                               # %for.body.i.preheader
	end_loop
	end_block                       # label7:
	copy_local	$0=, $2
	i32.const	$1=, -1
.LBB1_13:                               # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label10:
	i32.load	$push19=, 0($0)
	i32.const	$push62=, 8
	i32.const	$push61=, 7
	i32.const	$push60=, -255
	i32.add 	$push13=, $1, $pop60
	i32.const	$push59=, 23
	i32.gt_u	$push14=, $pop13, $pop59
	i32.select	$push15=, $pop62, $pop61, $pop14
	i32.const	$push58=, -143
	i32.add 	$push16=, $1, $pop58
	i32.const	$push57=, 112
	i32.lt_u	$push17=, $pop16, $pop57
	i32.add 	$push18=, $pop15, $pop17
	i32.ne  	$push20=, $pop19, $pop18
	br_if   	1, $pop20       # 1: down to label9
# BB#14:                                # %for.cond.i
                                        #   in Loop: Header=BB1_13 Depth=1
	i32.const	$push67=, 4
	i32.add 	$0=, $0, $pop67
	i32.const	$push66=, 1
	i32.add 	$push65=, $1, $pop66
	tee_local	$push64=, $1=, $pop65
	i32.const	$push63=, 286
	i32.le_u	$push21=, $pop64, $pop63
	br_if   	0, $pop21       # 0: up to label10
# BB#15:                                # %check.exit
	end_loop
	i32.const	$push29=, 0
	i32.const	$push27=, 1152
	i32.add 	$push28=, $2, $pop27
	i32.store	__stack_pointer($pop29), $pop28
	i32.const	$push22=, 0
	return  	$pop22
.LBB1_16:                               # %if.then.i
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
