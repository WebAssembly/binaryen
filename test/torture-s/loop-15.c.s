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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, __stack_pointer
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 32
	i32.sub 	$push23=, $pop17, $pop18
	i32.store	$push28=, 0($pop19), $pop23
	tee_local	$push27=, $12=, $pop28
	i32.const	$push1=, 16
	i32.add 	$7=, $pop27, $pop1
	i32.const	$3=, 0
	i32.const	$2=, -1
	i32.const	$push26=, 4
	i32.or  	$push25=, $12, $pop26
	tee_local	$push24=, $11=, $pop25
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
	loop                            # label6:
	i32.const	$push29=, 2
	i32.shl 	$push0=, $3, $pop29
	i32.add 	$4=, $12, $pop0
	copy_local	$5=, $11
	i32.const	$6=, 0
.LBB1_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_6 Depth 3
                                        #       Child Loop BB1_9 Depth 3
                                        #       Child Loop BB1_12 Depth 3
	loop                            # label8:
	i64.const	$push32=, 4294967296
	i64.store	$drop=, 0($12), $pop32
	i64.const	$push31=, 12884901890
	i64.store	$drop=, 8($12), $pop31
	i32.const	$push30=, 4
	i32.store	$0=, 0($7), $pop30
	block
	i32.le_s	$push2=, $6, $3
	br_if   	0, $pop2        # 0: down to label10
# BB#3:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB1_2 Depth=2
	i32.const	$push33=, 2
	i32.shl 	$push3=, $6, $pop33
	i32.add 	$10=, $12, $pop3
.LBB1_4:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label11:
	i32.const	$push36=, -4
	i32.add 	$push35=, $10, $pop36
	tee_local	$push34=, $9=, $pop35
	i32.load	$push4=, 0($pop34)
	i32.store	$drop=, 0($10), $pop4
	copy_local	$10=, $9
	i32.gt_u	$push5=, $9, $4
	br_if   	0, $pop5        # 0: up to label11
.LBB1_5:                                # %for.body11.preheader
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label12:
	end_block                       # label10:
	i32.const	$10=, -1
	copy_local	$9=, $12
.LBB1_6:                                # %for.body11
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label13:
	i32.const	$push37=, 1
	i32.add 	$10=, $10, $pop37
	i32.load	$push6=, 0($9)
	i32.ne  	$push7=, $10, $pop6
	br_if   	6, $pop7        # 6: down to label5
# BB#7:                                 # %for.cond9
                                        #   in Loop: Header=BB1_6 Depth=3
	i32.add 	$9=, $9, $0
	i32.lt_s	$push8=, $10, $3
	br_if   	0, $pop8        # 0: up to label13
# BB#8:                                 #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label14:
	copy_local	$9=, $1
	copy_local	$10=, $2
.LBB1_9:                                # %for.cond17
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label15:
	i32.const	$push38=, 1
	i32.add 	$10=, $10, $pop38
	i32.ge_s	$push9=, $10, $6
	br_if   	1, $pop9        # 1: down to label16
# BB#10:                                # %for.body19
                                        #   in Loop: Header=BB1_9 Depth=3
	i32.load	$8=, 0($9)
	i32.add 	$9=, $9, $0
	i32.eq  	$push15=, $10, $8
	br_if   	0, $pop15       # 0: up to label15
	br      	7               # 7: down to label4
.LBB1_11:                               # %for.end26
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label16:
	i32.const	$push41=, 1
	i32.add 	$6=, $6, $pop41
	copy_local	$9=, $5
	copy_local	$10=, $6
	i32.gt_s	$push40=, $6, $0
	tee_local	$push39=, $8=, $pop40
	br_if   	1, $pop39       # 1: down to label9
.LBB1_12:                               # %for.body30
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label17:
	i32.load	$push10=, 0($9)
	i32.ne  	$push11=, $10, $pop10
	br_if   	8, $pop11       # 8: down to label3
# BB#13:                                # %for.cond28
                                        #   in Loop: Header=BB1_12 Depth=3
	i32.const	$push42=, 1
	i32.add 	$10=, $10, $pop42
	i32.add 	$9=, $9, $0
	i32.le_s	$push12=, $10, $0
	br_if   	0, $pop12       # 0: up to label17
# BB#14:                                # %for.cond1.loopexit
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label18:
	i32.add 	$5=, $5, $0
	i32.eqz 	$push46=, $8
	br_if   	0, $pop46       # 0: up to label8
.LBB1_15:                               # %for.inc41
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label9:
	i32.const	$push45=, 1
	i32.add 	$3=, $3, $pop45
	i32.const	$push44=, 1
	i32.add 	$2=, $2, $pop44
	i32.add 	$1=, $1, $0
	i32.const	$push43=, 5
	i32.lt_s	$push13=, $3, $pop43
	br_if   	0, $pop13       # 0: up to label6
# BB#16:                                # %for.end43
	end_loop                        # label7:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 32
	i32.add 	$push21=, $12, $pop20
	i32.store	$drop=, 0($pop22), $pop21
	i32.const	$push14=, 0
	return  	$pop14
.LBB1_17:                               # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_18:                               # %if.then22
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_19:                               # %if.then33
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
