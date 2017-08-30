	.text
	.file	"loop-15.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
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
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push18=, 0
	i32.load	$push17=, __stack_pointer($pop18)
	i32.const	$push19=, 32
	i32.sub 	$push28=, $pop17, $pop19
	tee_local	$push27=, $10=, $pop28
	i32.store	__stack_pointer($pop20), $pop27
	i32.const	$9=, 0
	i32.const	$push1=, 16
	i32.add 	$6=, $10, $pop1
	i32.const	$push26=, 4
	i32.or  	$push25=, $10, $pop26
	tee_local	$push24=, $0=, $pop25
	copy_local	$1=, $pop24
.LBB1_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_6 Depth 3
                                        #       Child Loop BB1_9 Depth 3
                                        #       Child Loop BB1_13 Depth 3
	block   	
	loop    	                # label3:
	copy_local	$push31=, $9
	tee_local	$push30=, $2=, $pop31
	i32.const	$push29=, 2
	i32.shl 	$push0=, $pop30, $pop29
	i32.add 	$3=, $10, $pop0
	copy_local	$4=, $0
	i32.const	$5=, 0
.LBB1_2:                                # %for.body3
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_6 Depth 3
                                        #       Child Loop BB1_9 Depth 3
                                        #       Child Loop BB1_13 Depth 3
	loop    	                # label4:
	i32.const	$push36=, 4
	i32.store	0($6), $pop36
	i64.const	$push35=, 4294967296
	i64.store	0($10), $pop35
	i64.const	$push34=, 12884901890
	i64.store	8($10), $pop34
	block   	
	i32.le_u	$push33=, $5, $2
	tee_local	$push32=, $7=, $pop33
	br_if   	0, $pop32       # 0: down to label5
# BB#3:                                 # %while.body.lr.ph.i
                                        #   in Loop: Header=BB1_2 Depth=2
	i32.const	$push37=, 2
	i32.shl 	$push2=, $5, $pop37
	i32.add 	$9=, $10, $pop2
.LBB1_4:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label6:
	i32.const	$push40=, -4
	i32.add 	$push39=, $9, $pop40
	tee_local	$push38=, $8=, $pop39
	i32.load	$push3=, 0($pop38)
	i32.store	0($9), $pop3
	copy_local	$9=, $8
	i32.gt_u	$push4=, $8, $3
	br_if   	0, $pop4        # 0: up to label6
.LBB1_5:                                # %for.body11.preheader
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	end_block                       # label5:
	i32.const	$9=, -1
	copy_local	$8=, $10
.LBB1_6:                                # %for.body11
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label7:
	i32.const	$push43=, 1
	i32.add 	$push42=, $9, $pop43
	tee_local	$push41=, $9=, $pop42
	i32.load	$push5=, 0($8)
	i32.ne  	$push6=, $pop41, $pop5
	br_if   	3, $pop6        # 3: down to label2
# BB#7:                                 # %for.cond9
                                        #   in Loop: Header=BB1_6 Depth=3
	i32.const	$push44=, 4
	i32.add 	$8=, $8, $pop44
	i32.lt_u	$push7=, $9, $2
	br_if   	0, $pop7        # 0: up to label7
# BB#8:                                 # %for.end16
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	copy_local	$9=, $1
	copy_local	$8=, $2
	block   	
	br_if   	0, $7           # 0: down to label8
.LBB1_9:                                # %for.body19
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label9:
	i32.load	$push8=, 0($9)
	i32.ne  	$push9=, $8, $pop8
	br_if   	4, $pop9        # 4: down to label2
# BB#10:                                # %for.cond17
                                        #   in Loop: Header=BB1_9 Depth=3
	i32.const	$push48=, 4
	i32.add 	$9=, $9, $pop48
	i32.const	$push47=, 1
	i32.add 	$push46=, $8, $pop47
	tee_local	$push45=, $8=, $pop46
	i32.lt_u	$push10=, $pop45, $5
	br_if   	0, $pop10       # 0: up to label9
.LBB1_11:                               # %for.end26
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	end_block                       # label8:
	block   	
	i32.const	$push49=, 3
	i32.gt_u	$push11=, $5, $pop49
	br_if   	0, $pop11       # 0: down to label10
# BB#12:                                #   in Loop: Header=BB1_2 Depth=2
	i32.const	$push50=, 1
	i32.add 	$7=, $5, $pop50
	copy_local	$9=, $4
	copy_local	$8=, $5
.LBB1_13:                               # %for.body30
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label11:
	i32.const	$push53=, 1
	i32.add 	$push52=, $8, $pop53
	tee_local	$push51=, $8=, $pop52
	i32.load	$push12=, 0($9)
	i32.ne  	$push13=, $pop51, $pop12
	br_if   	4, $pop13       # 4: down to label2
# BB#14:                                # %for.cond28
                                        #   in Loop: Header=BB1_13 Depth=3
	i32.const	$push55=, 4
	i32.add 	$9=, $9, $pop55
	i32.const	$push54=, 3
	i32.le_u	$push14=, $8, $pop54
	br_if   	0, $pop14       # 0: up to label11
# BB#15:                                # %for.inc38
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	i32.const	$push57=, 4
	i32.add 	$4=, $4, $pop57
	i32.const	$push56=, 4
	i32.lt_u	$9=, $5, $pop56
	copy_local	$5=, $7
	br_if   	1, $9           # 1: up to label4
.LBB1_16:                               # %for.inc41
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label10:
	end_loop
	i32.const	$push60=, 4
	i32.add 	$1=, $1, $pop60
	i32.const	$push59=, 1
	i32.add 	$9=, $2, $pop59
	i32.const	$push58=, 4
	i32.lt_u	$push15=, $2, $pop58
	br_if   	0, $pop15       # 0: up to label3
# BB#17:                                # %for.end43
	end_loop
	i32.const	$push23=, 0
	i32.const	$push21=, 32
	i32.add 	$push22=, $10, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	i32.const	$push16=, 0
	return  	$pop16
.LBB1_18:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
