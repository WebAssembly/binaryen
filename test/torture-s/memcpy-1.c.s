	.text
	.file	"memcpy-1.c"
	.section	.text.copy,"ax",@progbits
	.hidden	copy                    # -- Begin function copy
	.globl	copy
	.type	copy,@function
copy:                                   # @copy
	.param  	i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
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
# %bb.0:                                # %entry
	i32.const	$push38=, 0
	i32.load	$push37=, __stack_pointer($pop38)
	i32.const	$push39=, 349536
	i32.sub 	$1=, $pop37, $pop39
	i32.const	$push40=, 0
	i32.store	__stack_pointer($pop40), $1
	i32.const	$2=, 0
	i32.const	$push52=, 0
	i32.const	$push51=, 174762
	i32.call	$drop=, memset@FUNCTION, $1, $pop52, $pop51
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push41=, 174768
	i32.add 	$push42=, $1, $pop41
	i32.add 	$push2=, $pop42, $2
	i32.store8	0($pop2), $2
	i32.const	$push54=, 1
	i32.add 	$2=, $2, $pop54
	i32.const	$push53=, 174762
	i32.ne  	$push3=, $2, $pop53
	br_if   	0, $pop3        # 0: up to label0
# %bb.2:                                # %for.end
	end_loop
	i32.const	$push43=, 174768
	i32.add 	$push44=, $1, $pop43
	i32.const	$push4=, 1365
	i32.call	$drop=, memcpy@FUNCTION, $1, $pop44, $pop4
	i32.const	$2=, 0
.LBB1_3:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.add 	$push6=, $1, $2
	i32.load8_u	$push7=, 0($pop6)
	i32.const	$push55=, 255
	i32.and 	$push5=, $2, $pop55
	i32.ne  	$push8=, $pop7, $pop5
	br_if   	1, $pop8        # 1: down to label1
# %bb.4:                                # %for.cond3
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push57=, 1
	i32.add 	$2=, $2, $pop57
	i32.const	$push56=, 1364
	i32.le_u	$push9=, $2, $pop56
	br_if   	0, $pop9        # 0: up to label2
# %bb.5:                                # %for.end15
	end_loop
	i32.const	$push58=, 1
	i32.const	$push10=, 1365
	i32.call	$0=, memset@FUNCTION, $1, $pop58, $pop10
	i32.const	$2=, 1
.LBB1_6:                                # %for.cond17
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	i32.const	$push59=, 1364
	i32.gt_u	$push11=, $2, $pop59
	br_if   	1, $pop11       # 1: down to label3
# %bb.7:                                # %for.cond17.for.body20_crit_edge
                                        #   in Loop: Header=BB1_6 Depth=1
	i32.add 	$1=, $0, $2
	i32.const	$push61=, 1
	i32.add 	$push0=, $2, $pop61
	copy_local	$2=, $pop0
	i32.load8_u	$push35=, 0($1)
	i32.const	$push60=, 1
	i32.eq  	$push36=, $pop35, $pop60
	br_if   	0, $pop36       # 0: up to label4
	br      	2               # 2: down to label1
.LBB1_8:                                # %for.end29
	end_loop
	end_block                       # label3:
	i32.const	$push45=, 174768
	i32.add 	$push46=, $0, $pop45
	i32.const	$push12=, 174762
	i32.call	$1=, memcpy@FUNCTION, $0, $pop46, $pop12
	i32.const	$2=, 0
.LBB1_9:                                # %for.body35
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.add 	$push14=, $1, $2
	i32.load8_u	$push15=, 0($pop14)
	i32.const	$push62=, 255
	i32.and 	$push13=, $2, $pop62
	i32.ne  	$push16=, $pop15, $pop13
	br_if   	1, $pop16       # 1: down to label1
# %bb.10:                               # %for.cond32
                                        #   in Loop: Header=BB1_9 Depth=1
	i32.const	$push64=, 1
	i32.add 	$2=, $2, $pop64
	i32.const	$push63=, 174761
	i32.le_u	$push17=, $2, $pop63
	br_if   	0, $pop17       # 0: up to label5
# %bb.11:                               # %for.end46
	end_loop
	i32.const	$push19=, 0
	i32.const	$push18=, 174762
	i32.call	$0=, memset@FUNCTION, $1, $pop19, $pop18
	i32.const	$2=, 1
.LBB1_12:                               # %for.cond48
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label7:
	i32.const	$push65=, 174761
	i32.gt_u	$push20=, $2, $pop65
	br_if   	1, $pop20       # 1: down to label6
# %bb.13:                               # %for.cond48.for.body51_crit_edge
                                        #   in Loop: Header=BB1_12 Depth=1
	i32.add 	$1=, $0, $2
	i32.const	$push66=, 1
	i32.add 	$push1=, $2, $pop66
	copy_local	$2=, $pop1
	i32.load8_u	$push34=, 0($1)
	i32.eqz 	$push73=, $pop34
	br_if   	0, $pop73       # 0: up to label7
	br      	2               # 2: down to label1
.LBB1_14:                               # %for.end60
	end_loop
	end_block                       # label6:
	i32.const	$push47=, 174768
	i32.add 	$push48=, $0, $pop47
	i32.const	$push21=, 1365
	i32.call	$1=, memcpy@FUNCTION, $0, $pop48, $pop21
	i32.const	$2=, 0
.LBB1_15:                               # %for.body66
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	i32.add 	$push23=, $1, $2
	i32.load8_u	$push24=, 0($pop23)
	i32.const	$push67=, 255
	i32.and 	$push22=, $2, $pop67
	i32.ne  	$push25=, $pop24, $pop22
	br_if   	1, $pop25       # 1: down to label1
# %bb.16:                               # %for.cond63
                                        #   in Loop: Header=BB1_15 Depth=1
	i32.const	$push69=, 1
	i32.add 	$2=, $2, $pop69
	i32.const	$push68=, 1364
	i32.le_u	$push26=, $2, $pop68
	br_if   	0, $pop26       # 0: up to label8
# %bb.17:                               # %for.end77
	end_loop
	i32.const	$push49=, 174768
	i32.add 	$push50=, $1, $pop49
	i32.const	$push27=, 174762
	i32.call	$drop=, memcpy@FUNCTION, $1, $pop50, $pop27
	i32.const	$2=, 0
.LBB1_18:                               # %for.body85
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label9:
	i32.add 	$push29=, $1, $2
	i32.load8_u	$push30=, 0($pop29)
	i32.const	$push70=, 255
	i32.and 	$push28=, $2, $pop70
	i32.ne  	$push31=, $pop30, $pop28
	br_if   	1, $pop31       # 1: down to label1
# %bb.19:                               # %for.cond82
                                        #   in Loop: Header=BB1_18 Depth=1
	i32.const	$push72=, 1
	i32.add 	$2=, $2, $pop72
	i32.const	$push71=, 174761
	i32.le_u	$push32=, $2, $pop71
	br_if   	0, $pop32       # 0: up to label9
# %bb.20:                               # %for.end96
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

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
