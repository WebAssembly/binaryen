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
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push1=, -4
	i32.add 	$push5=, $1, $pop1
	tee_local	$push4=, $2=, $pop5
	i32.load	$push2=, 0($pop4)
	i32.store	$discard=, 0($1), $pop2
	copy_local	$1=, $2
	i32.gt_u	$push3=, $2, $0
	br_if   	0, $pop3        # 0: up to label1
.LBB0_2:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$14=, __stack_pointer
	i32.load	$14=, 0($14)
	i32.const	$15=, 32
	i32.sub 	$17=, $14, $15
	i32.const	$15=, __stack_pointer
	i32.store	$17=, 0($15), $17
	i32.const	$push1=, 8
	i32.or  	$7=, $17, $pop1
	i32.const	$push2=, 16
	i32.add 	$8=, $17, $pop2
	i32.const	$push19=, 4
	i32.or  	$0=, $17, $pop19
	i32.const	$3=, 0
	i32.const	$2=, -1
	copy_local	$1=, $0
.LBB1_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_5 Depth 3
                                        #       Child Loop BB1_7 Depth 3
                                        #       Child Loop BB1_10 Depth 3
	block
	block
	block
	loop                            # label6:
	i32.const	$push20=, 2
	i32.shl 	$push0=, $3, $pop20
	i32.add 	$4=, $17, $pop0
	copy_local	$5=, $0
	i32.const	$6=, 0
.LBB1_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_5 Depth 3
                                        #       Child Loop BB1_7 Depth 3
                                        #       Child Loop BB1_10 Depth 3
	loop                            # label8:
	i64.const	$push23=, 4294967296
	i64.store	$discard=, 0($17):p2align=4, $pop23
	i64.const	$push22=, 12884901890
	i64.store	$discard=, 0($7), $pop22
	i32.const	$push21=, 4
	i32.store	$9=, 0($8):p2align=4, $pop21
	i32.const	$11=, -1
	copy_local	$10=, $17
	block
	i32.le_s	$push3=, $6, $3
	br_if   	0, $pop3        # 0: down to label10
# BB#3:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB1_2 Depth=2
	i32.const	$push24=, 2
	i32.shl 	$push4=, $6, $pop24
	i32.add 	$13=, $17, $pop4
.LBB1_4:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label11:
	i32.const	$push27=, -4
	i32.add 	$push26=, $13, $pop27
	tee_local	$push25=, $12=, $pop26
	i32.load	$push5=, 0($pop25)
	i32.store	$discard=, 0($13), $pop5
	copy_local	$13=, $12
	copy_local	$10=, $17
	i32.gt_u	$push6=, $12, $4
	br_if   	0, $pop6        # 0: up to label11
.LBB1_5:                                # %for.body11
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	end_loop                        # label12:
	end_block                       # label10:
	loop                            # label13:
	i32.const	$push28=, 1
	i32.add 	$11=, $11, $pop28
	i32.load	$push7=, 0($10)
	i32.ne  	$push8=, $11, $pop7
	br_if   	6, $pop8        # 6: down to label5
# BB#6:                                 # %for.cond9
                                        #   in Loop: Header=BB1_5 Depth=3
	i32.add 	$10=, $10, $9
	copy_local	$12=, $1
	copy_local	$13=, $2
	i32.lt_s	$push9=, $11, $3
	br_if   	0, $pop9        # 0: up to label13
.LBB1_7:                                # %for.cond17
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	end_loop                        # label14:
	loop                            # label15:
	i32.const	$push29=, 1
	i32.add 	$13=, $13, $pop29
	i32.ge_s	$push10=, $13, $6
	br_if   	1, $pop10       # 1: down to label16
# BB#8:                                 # %for.body19
                                        #   in Loop: Header=BB1_7 Depth=3
	i32.load	$11=, 0($12)
	i32.add 	$12=, $12, $9
	i32.eq  	$push18=, $13, $11
	br_if   	0, $pop18       # 0: up to label15
	br      	7               # 7: down to label4
.LBB1_9:                                # %for.end26
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label16:
	i32.const	$push31=, 1
	i32.add 	$6=, $6, $pop31
	copy_local	$11=, $5
	copy_local	$13=, $6
	i32.const	$push30=, 5
	i32.ge_s	$push11=, $6, $pop30
	br_if   	1, $pop11       # 1: down to label9
.LBB1_10:                               # %for.body30
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label17:
	i32.load	$push12=, 0($11)
	i32.ne  	$push13=, $13, $pop12
	br_if   	8, $pop13       # 8: down to label3
# BB#11:                                # %for.cond28
                                        #   in Loop: Header=BB1_10 Depth=3
	i32.const	$push32=, 1
	i32.add 	$13=, $13, $pop32
	i32.add 	$11=, $11, $9
	i32.le_s	$push14=, $13, $9
	br_if   	0, $pop14       # 0: up to label17
# BB#12:                                # %for.cond1.loopexit
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label18:
	i32.add 	$5=, $5, $9
	i32.le_s	$push15=, $6, $9
	br_if   	0, $pop15       # 0: up to label8
.LBB1_13:                               # %for.inc41
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label9:
	i32.add 	$1=, $1, $9
	i32.const	$push35=, 1
	i32.add 	$3=, $3, $pop35
	i32.const	$push34=, 1
	i32.add 	$2=, $2, $pop34
	i32.const	$push33=, 5
	i32.lt_s	$push16=, $3, $pop33
	br_if   	0, $pop16       # 0: up to label6
# BB#14:                                # %for.end43
	end_loop                        # label7:
	i32.const	$push17=, 0
	i32.const	$16=, 32
	i32.add 	$17=, $17, $16
	i32.const	$16=, __stack_pointer
	i32.store	$17=, 0($16), $17
	return  	$pop17
.LBB1_15:                               # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_16:                               # %if.then22
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_17:                               # %if.then33
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
