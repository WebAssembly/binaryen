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
	i32.const	$push5=, -4
	i32.add 	$push4=, $1, $pop5
	tee_local	$push3=, $2=, $pop4
	i32.load	$push1=, 0($pop3)
	i32.store	$discard=, 0($1), $pop1
	copy_local	$1=, $2
	i32.gt_u	$push2=, $2, $0
	br_if   	0, $pop2        # 0: up to label1
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push35=, __stack_pointer
	i32.load	$push36=, 0($pop35)
	i32.const	$push37=, 32
	i32.sub 	$13=, $pop36, $pop37
	i32.const	$push38=, __stack_pointer
	i32.store	$discard=, 0($pop38), $13
	i32.const	$push1=, 16
	i32.add 	$7=, $13, $pop1
	i32.const	$push18=, 4
	i32.or  	$0=, $13, $pop18
	i32.const	$3=, 0
	i32.const	$2=, -1
	copy_local	$1=, $0
.LBB1_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_5 Depth 3
                                        #       Child Loop BB1_8 Depth 3
                                        #       Child Loop BB1_11 Depth 3
	block
	block
	block
	loop                            # label6:
	i32.const	$push19=, 2
	i32.shl 	$push0=, $3, $pop19
	i32.add 	$4=, $13, $pop0
	copy_local	$5=, $0
	i32.const	$6=, 0
.LBB1_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_5 Depth 3
                                        #       Child Loop BB1_8 Depth 3
                                        #       Child Loop BB1_11 Depth 3
	loop                            # label8:
	i64.const	$push22=, 4294967296
	i64.store	$discard=, 0($13):p2align=4, $pop22
	i64.const	$push21=, 12884901890
	i64.store	$discard=, 8($13), $pop21
	i32.const	$push20=, 4
	i32.store	$8=, 0($7):p2align=4, $pop20
	i32.const	$11=, -1
	copy_local	$10=, $13
	block
	i32.le_s	$push2=, $6, $3
	br_if   	0, $pop2        # 0: down to label10
# BB#3:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB1_2 Depth=2
	i32.const	$push23=, 2
	i32.shl 	$push3=, $6, $pop23
	i32.add 	$9=, $13, $pop3
.LBB1_4:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label11:
	i32.const	$push26=, -4
	i32.add 	$push25=, $9, $pop26
	tee_local	$push24=, $12=, $pop25
	i32.load	$push4=, 0($pop24)
	i32.store	$discard=, 0($9), $pop4
	copy_local	$9=, $12
	copy_local	$10=, $13
	i32.gt_u	$push5=, $12, $4
	br_if   	0, $pop5        # 0: up to label11
.LBB1_5:                                # %for.body11
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	end_loop                        # label12:
	end_block                       # label10:
	loop                            # label13:
	i32.const	$push27=, 1
	i32.add 	$11=, $11, $pop27
	i32.load	$push6=, 0($10)
	i32.ne  	$push7=, $11, $pop6
	br_if   	6, $pop7        # 6: down to label5
# BB#6:                                 # %for.cond9
                                        #   in Loop: Header=BB1_5 Depth=3
	i32.add 	$10=, $10, $8
	i32.lt_s	$push8=, $11, $3
	br_if   	0, $pop8        # 0: up to label13
# BB#7:                                 #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label14:
	copy_local	$10=, $1
	copy_local	$11=, $2
.LBB1_8:                                # %for.cond17
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label15:
	i32.const	$push28=, 1
	i32.add 	$11=, $11, $pop28
	i32.ge_s	$push9=, $11, $6
	br_if   	1, $pop9        # 1: down to label16
# BB#9:                                 # %for.body19
                                        #   in Loop: Header=BB1_8 Depth=3
	i32.load	$9=, 0($10)
	i32.add 	$10=, $10, $8
	i32.eq  	$push17=, $11, $9
	br_if   	0, $pop17       # 0: up to label15
	br      	7               # 7: down to label4
.LBB1_10:                               # %for.end26
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label16:
	i32.const	$push30=, 1
	i32.add 	$6=, $6, $pop30
	copy_local	$10=, $5
	copy_local	$11=, $6
	i32.const	$push29=, 5
	i32.ge_s	$push10=, $6, $pop29
	br_if   	1, $pop10       # 1: down to label9
.LBB1_11:                               # %for.body30
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label17:
	i32.load	$push11=, 0($10)
	i32.ne  	$push12=, $11, $pop11
	br_if   	8, $pop12       # 8: down to label3
# BB#12:                                # %for.cond28
                                        #   in Loop: Header=BB1_11 Depth=3
	i32.const	$push31=, 1
	i32.add 	$11=, $11, $pop31
	i32.add 	$10=, $10, $8
	i32.le_s	$push13=, $11, $8
	br_if   	0, $pop13       # 0: up to label17
# BB#13:                                # %for.cond1.loopexit
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label18:
	i32.add 	$5=, $5, $8
	i32.le_s	$push14=, $6, $8
	br_if   	0, $pop14       # 0: up to label8
.LBB1_14:                               # %for.inc41
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label9:
	i32.add 	$1=, $1, $8
	i32.const	$push34=, 1
	i32.add 	$3=, $3, $pop34
	i32.const	$push33=, 1
	i32.add 	$2=, $2, $pop33
	i32.const	$push32=, 5
	i32.lt_s	$push15=, $3, $pop32
	br_if   	0, $pop15       # 0: up to label6
# BB#15:                                # %for.end43
	end_loop                        # label7:
	i32.const	$push16=, 0
	i32.const	$push39=, 32
	i32.add 	$13=, $13, $pop39
	i32.const	$push40=, __stack_pointer
	i32.store	$discard=, 0($pop40), $13
	return  	$pop16
.LBB1_16:                               # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_17:                               # %if.then22
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_18:                               # %if.then33
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
