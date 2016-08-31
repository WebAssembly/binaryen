	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-15.c"
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
	loop                            # label1:
	i32.const	$push5=, -4
	i32.add 	$push4=, $1, $pop5
	tee_local	$push3=, $2=, $pop4
	i32.load	$push1=, 0($pop3)
	i32.store	$drop=, 0($1), $pop1
	copy_local	$1=, $2
	i32.gt_u	$push2=, $2, $0
	br_if   	0, $pop2        # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop                        # label2:
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push22=, 0
	i32.const	$push19=, 0
	i32.load	$push20=, __stack_pointer($pop19)
	i32.const	$push21=, 32
	i32.sub 	$push30=, $pop20, $pop21
	tee_local	$push29=, $10=, $pop30
	i32.store	$drop=, __stack_pointer($pop22), $pop29
	i32.const	$2=, 0
	i32.const	$push3=, 16
	i32.add 	$6=, $10, $pop3
	i32.const	$push28=, 4
	i32.or  	$push27=, $10, $pop28
	tee_local	$push26=, $0=, $pop27
	copy_local	$1=, $pop26
.LBB1_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_6 Depth 3
                                        #       Child Loop BB1_9 Depth 3
                                        #       Child Loop BB1_12 Depth 3
	block
	block
	loop                            # label5:
	i32.const	$push31=, 2
	i32.shl 	$push2=, $2, $pop31
	i32.add 	$3=, $10, $pop2
	copy_local	$4=, $0
	i32.const	$5=, 0
.LBB1_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_6 Depth 3
                                        #       Child Loop BB1_9 Depth 3
                                        #       Child Loop BB1_12 Depth 3
	loop                            # label7:
	i32.const	$push34=, 4
	i32.store	$drop=, 0($6), $pop34
	i64.const	$push33=, 4294967296
	i64.store	$drop=, 0($10), $pop33
	i64.const	$push32=, 12884901890
	i64.store	$drop=, 8($10), $pop32
	block
	i32.le_s	$push4=, $5, $2
	br_if   	0, $pop4        # 0: down to label9
# BB#3:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB1_2 Depth=2
	i32.const	$push35=, 2
	i32.shl 	$push5=, $5, $pop35
	i32.add 	$9=, $10, $pop5
.LBB1_4:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label10:
	i32.const	$push38=, -4
	i32.add 	$push37=, $9, $pop38
	tee_local	$push36=, $8=, $pop37
	i32.load	$push6=, 0($pop36)
	i32.store	$drop=, 0($9), $pop6
	copy_local	$9=, $8
	i32.gt_u	$push7=, $8, $3
	br_if   	0, $pop7        # 0: up to label10
.LBB1_5:                                # %for.body11.preheader
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label11:
	end_block                       # label9:
	i32.const	$9=, -1
	copy_local	$8=, $10
.LBB1_6:                                # %for.body11
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label12:
	i32.const	$push41=, 1
	i32.add 	$push40=, $9, $pop41
	tee_local	$push39=, $9=, $pop40
	i32.load	$push8=, 0($8)
	i32.ne  	$push9=, $pop39, $pop8
	br_if   	6, $pop9        # 6: down to label4
# BB#7:                                 # %for.cond9
                                        #   in Loop: Header=BB1_6 Depth=3
	i32.const	$push42=, 4
	i32.add 	$8=, $8, $pop42
	i32.lt_s	$push10=, $9, $2
	br_if   	0, $pop10       # 0: up to label12
# BB#8:                                 #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label13:
	copy_local	$8=, $1
	copy_local	$9=, $2
.LBB1_9:                                # %for.cond17
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label14:
	i32.ge_s	$push11=, $9, $5
	br_if   	1, $pop11       # 1: down to label15
# BB#10:                                # %for.body19
                                        #   in Loop: Header=BB1_9 Depth=3
	i32.load	$7=, 0($8)
	i32.const	$push47=, 4
	i32.add 	$push0=, $8, $pop47
	copy_local	$8=, $pop0
	i32.const	$push46=, 1
	i32.add 	$push45=, $9, $pop46
	tee_local	$push44=, $9=, $pop45
	i32.const	$push43=, -1
	i32.add 	$push17=, $pop44, $pop43
	i32.eq  	$push18=, $7, $pop17
	br_if   	0, $pop18       # 0: up to label14
	br      	7               # 7: down to label3
.LBB1_11:                               #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label15:
	copy_local	$8=, $4
	copy_local	$9=, $5
.LBB1_12:                               # %for.cond28
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label16:
	i32.const	$push51=, 1
	i32.add 	$push50=, $9, $pop51
	tee_local	$push49=, $9=, $pop50
	i32.const	$push48=, 4
	i32.gt_s	$push12=, $pop49, $pop48
	br_if   	1, $pop12       # 1: down to label17
# BB#13:                                # %for.body30
                                        #   in Loop: Header=BB1_12 Depth=3
	i32.load	$7=, 0($8)
	i32.const	$push52=, 4
	i32.add 	$push1=, $8, $pop52
	copy_local	$8=, $pop1
	i32.eq  	$push16=, $9, $7
	br_if   	0, $pop16       # 0: up to label16
	br      	6               # 6: down to label4
.LBB1_14:                               # %for.inc38
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label17:
	i32.const	$push57=, 4
	i32.add 	$4=, $4, $pop57
	i32.const	$push56=, 1
	i32.add 	$push55=, $5, $pop56
	tee_local	$push54=, $5=, $pop55
	i32.const	$push53=, 5
	i32.lt_s	$push13=, $pop54, $pop53
	br_if   	0, $pop13       # 0: up to label7
# BB#15:                                # %for.inc41
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label8:
	i32.const	$push62=, 4
	i32.add 	$1=, $1, $pop62
	i32.const	$push61=, 1
	i32.add 	$push60=, $2, $pop61
	tee_local	$push59=, $2=, $pop60
	i32.const	$push58=, 5
	i32.lt_s	$push14=, $pop59, $pop58
	br_if   	0, $pop14       # 0: up to label5
# BB#16:                                # %for.end43
	end_loop                        # label6:
	i32.const	$push25=, 0
	i32.const	$push23=, 32
	i32.add 	$push24=, $10, $pop23
	i32.store	$drop=, __stack_pointer($pop25), $pop24
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
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
