	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-15.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.le_u	$push0=, $1, $0
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %while.body.preheader
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push5=, -4
	i32.add 	$push4=, $1, $pop5
	tee_local	$push3=, $2=, $pop4
	i32.load	$push1=, 0($pop3)
	i32.store	0($1), $pop1
	copy_local	$1=, $2
	i32.gt_u	$push2=, $2, $0
	br_if   	0, $pop2        # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 32
	i32.sub 	$push28=, $pop18, $pop19
	tee_local	$push27=, $11=, $pop28
	i32.store	__stack_pointer($pop20), $pop27
	i32.const	$3=, 0
	i32.const	$2=, -1
	i32.const	$push2=, 16
	i32.add 	$7=, $11, $pop2
	i32.const	$push26=, 4
	i32.or  	$push25=, $11, $pop26
	tee_local	$push24=, $0=, $pop25
	copy_local	$1=, $pop24
.LBB1_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_6 Depth 3
                                        #       Child Loop BB1_9 Depth 3
                                        #       Child Loop BB1_12 Depth 3
	block   	
	block   	
	block   	
	loop    	                # label5:
	i32.const	$push29=, 2
	i32.shl 	$push1=, $3, $pop29
	i32.add 	$4=, $11, $pop1
	copy_local	$5=, $0
	i32.const	$6=, 0
.LBB1_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_6 Depth 3
                                        #       Child Loop BB1_9 Depth 3
                                        #       Child Loop BB1_12 Depth 3
	loop    	                # label6:
	i32.const	$push32=, 4
	i32.store	0($7), $pop32
	i64.const	$push31=, 4294967296
	i64.store	0($11), $pop31
	i64.const	$push30=, 12884901890
	i64.store	8($11), $pop30
	block   	
	i32.le_s	$push3=, $6, $3
	br_if   	0, $pop3        # 0: down to label7
# BB#3:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB1_2 Depth=2
	i32.const	$push33=, 2
	i32.shl 	$push4=, $6, $pop33
	i32.add 	$10=, $11, $pop4
.LBB1_4:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label8:
	i32.const	$push36=, -4
	i32.add 	$push35=, $10, $pop36
	tee_local	$push34=, $9=, $pop35
	i32.load	$push5=, 0($pop34)
	i32.store	0($10), $pop5
	copy_local	$10=, $9
	i32.gt_u	$push6=, $9, $4
	br_if   	0, $pop6        # 0: up to label8
.LBB1_5:                                # %for.body11.preheader
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	end_block                       # label7:
	i32.const	$10=, -1
	copy_local	$9=, $11
.LBB1_6:                                # %for.body11
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label9:
	i32.const	$push39=, 1
	i32.add 	$push38=, $10, $pop39
	tee_local	$push37=, $10=, $pop38
	i32.load	$push7=, 0($9)
	i32.ne  	$push8=, $pop37, $pop7
	br_if   	3, $pop8        # 3: down to label4
# BB#7:                                 # %for.cond9
                                        #   in Loop: Header=BB1_6 Depth=3
	i32.const	$push40=, 4
	i32.add 	$9=, $9, $pop40
	i32.lt_s	$push9=, $10, $3
	br_if   	0, $pop9        # 0: up to label9
# BB#8:                                 #   in Loop: Header=BB1_2 Depth=2
	end_loop
	copy_local	$9=, $1
	copy_local	$10=, $2
.LBB1_9:                                # %for.cond17
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	block   	
	loop    	                # label11:
	i32.const	$push43=, 1
	i32.add 	$push42=, $10, $pop43
	tee_local	$push41=, $10=, $pop42
	i32.ge_s	$push10=, $pop41, $6
	br_if   	1, $pop10       # 1: down to label10
# BB#10:                                # %for.body19
                                        #   in Loop: Header=BB1_9 Depth=3
	i32.load	$8=, 0($9)
	i32.const	$push44=, 4
	i32.add 	$push0=, $9, $pop44
	copy_local	$9=, $pop0
	i32.eq  	$push16=, $10, $8
	br_if   	0, $pop16       # 0: up to label11
	br      	5               # 5: down to label3
.LBB1_11:                               # %for.end26
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	end_block                       # label10:
	block   	
	copy_local	$10=, $5
	i32.const	$push50=, 1
	i32.add 	$push49=, $6, $pop50
	tee_local	$push48=, $6=, $pop49
	copy_local	$9=, $pop48
	i32.const	$push47=, 4
	i32.gt_s	$push46=, $6, $pop47
	tee_local	$push45=, $8=, $pop46
	br_if   	0, $pop45       # 0: down to label12
.LBB1_12:                               # %for.body30
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label13:
	i32.load	$push11=, 0($10)
	i32.ne  	$push12=, $9, $pop11
	br_if   	6, $pop12       # 6: down to label2
# BB#13:                                # %for.cond28
                                        #   in Loop: Header=BB1_12 Depth=3
	i32.const	$push55=, 4
	i32.add 	$10=, $10, $pop55
	i32.const	$push54=, 1
	i32.add 	$push53=, $9, $pop54
	tee_local	$push52=, $9=, $pop53
	i32.const	$push51=, 4
	i32.le_s	$push13=, $pop52, $pop51
	br_if   	0, $pop13       # 0: up to label13
# BB#14:                                # %for.cond1.loopexit
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	i32.const	$push56=, 4
	i32.add 	$5=, $5, $pop56
	i32.eqz 	$push63=, $8
	br_if   	1, $pop63       # 1: up to label6
.LBB1_15:                               # %for.inc41
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label12:
	end_loop
	i32.const	$push62=, 4
	i32.add 	$1=, $1, $pop62
	i32.const	$push61=, 1
	i32.add 	$2=, $2, $pop61
	i32.const	$push60=, 1
	i32.add 	$push59=, $3, $pop60
	tee_local	$push58=, $3=, $pop59
	i32.const	$push57=, 5
	i32.lt_s	$push14=, $pop58, $pop57
	br_if   	0, $pop14       # 0: up to label5
# BB#16:                                # %for.end43
	end_loop
	i32.const	$push23=, 0
	i32.const	$push21=, 32
	i32.add 	$push22=, $11, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	i32.const	$push15=, 0
	return  	$pop15
.LBB1_17:                               # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_18:                               # %if.then22
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_19:                               # %if.then33
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
