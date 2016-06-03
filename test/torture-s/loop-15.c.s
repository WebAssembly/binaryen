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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
	i32.const	$4=, -1
	i32.const	$push20=, 0
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 32
	i32.sub 	$push24=, $pop18, $pop19
	i32.store	$push29=, __stack_pointer($pop20), $pop24
	tee_local	$push28=, $1=, $pop29
	i32.const	$push2=, 16
	i32.add 	$9=, $pop28, $pop2
	i32.const	$push27=, 4
	i32.or  	$push26=, $1, $pop27
	tee_local	$push25=, $2=, $pop26
	copy_local	$3=, $pop25
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
	i32.const	$push30=, 2
	i32.shl 	$push1=, $5, $pop30
	i32.add 	$6=, $1, $pop1
	copy_local	$7=, $2
	i32.const	$8=, 0
.LBB1_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_6 Depth 3
                                        #       Child Loop BB1_9 Depth 3
                                        #       Child Loop BB1_12 Depth 3
	loop                            # label8:
	i32.const	$push33=, 4
	i32.store	$0=, 0($9), $pop33
	i64.const	$push32=, 4294967296
	i64.store	$drop=, 0($1), $pop32
	i64.const	$push31=, 12884901890
	i64.store	$drop=, 8($1), $pop31
	block
	i32.le_s	$push3=, $8, $5
	br_if   	0, $pop3        # 0: down to label10
# BB#3:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB1_2 Depth=2
	i32.const	$push34=, 2
	i32.shl 	$push4=, $8, $pop34
	i32.add 	$12=, $1, $pop4
.LBB1_4:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label11:
	i32.const	$push37=, -4
	i32.add 	$push36=, $12, $pop37
	tee_local	$push35=, $11=, $pop36
	i32.load	$push5=, 0($pop35)
	i32.store	$drop=, 0($12), $pop5
	copy_local	$12=, $11
	i32.gt_u	$push6=, $11, $6
	br_if   	0, $pop6        # 0: up to label11
.LBB1_5:                                # %for.body11.preheader
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label12:
	end_block                       # label10:
	i32.const	$12=, -1
	copy_local	$11=, $1
.LBB1_6:                                # %for.body11
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label13:
	i32.const	$push40=, 1
	i32.add 	$push39=, $12, $pop40
	tee_local	$push38=, $12=, $pop39
	i32.load	$push7=, 0($11)
	i32.ne  	$push8=, $pop38, $pop7
	br_if   	6, $pop8        # 6: down to label5
# BB#7:                                 # %for.cond9
                                        #   in Loop: Header=BB1_6 Depth=3
	i32.add 	$11=, $11, $0
	i32.lt_s	$push9=, $12, $5
	br_if   	0, $pop9        # 0: up to label13
# BB#8:                                 #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label14:
	copy_local	$11=, $3
	copy_local	$12=, $4
.LBB1_9:                                # %for.cond17
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label15:
	i32.const	$push43=, 1
	i32.add 	$push42=, $12, $pop43
	tee_local	$push41=, $12=, $pop42
	i32.ge_s	$push10=, $pop41, $8
	br_if   	1, $pop10       # 1: down to label16
# BB#10:                                # %for.body19
                                        #   in Loop: Header=BB1_9 Depth=3
	i32.load	$10=, 0($11)
	i32.add 	$push0=, $11, $0
	copy_local	$11=, $pop0
	i32.eq  	$push16=, $12, $10
	br_if   	0, $pop16       # 0: up to label15
	br      	7               # 7: down to label4
.LBB1_11:                               # %for.end26
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label16:
	copy_local	$12=, $7
	i32.const	$push48=, 1
	i32.add 	$push47=, $8, $pop48
	tee_local	$push46=, $8=, $pop47
	copy_local	$11=, $pop46
	i32.gt_s	$push45=, $8, $0
	tee_local	$push44=, $10=, $pop45
	br_if   	1, $pop44       # 1: down to label9
.LBB1_12:                               # %for.body30
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label17:
	i32.load	$push11=, 0($12)
	i32.ne  	$push12=, $11, $pop11
	br_if   	8, $pop12       # 8: down to label3
# BB#13:                                # %for.cond28
                                        #   in Loop: Header=BB1_12 Depth=3
	i32.add 	$12=, $12, $0
	i32.const	$push51=, 1
	i32.add 	$push50=, $11, $pop51
	tee_local	$push49=, $11=, $pop50
	i32.le_s	$push13=, $pop49, $0
	br_if   	0, $pop13       # 0: up to label17
# BB#14:                                # %for.cond1.loopexit
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label18:
	i32.add 	$7=, $7, $0
	i32.eqz 	$push57=, $10
	br_if   	0, $pop57       # 0: up to label8
.LBB1_15:                               # %for.inc41
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label9:
	i32.add 	$3=, $3, $0
	i32.const	$push56=, 1
	i32.add 	$4=, $4, $pop56
	i32.const	$push55=, 1
	i32.add 	$push54=, $5, $pop55
	tee_local	$push53=, $5=, $pop54
	i32.const	$push52=, 5
	i32.lt_s	$push14=, $pop53, $pop52
	br_if   	0, $pop14       # 0: up to label6
# BB#16:                                # %for.end43
	end_loop                        # label7:
	i32.const	$push23=, 0
	i32.const	$push21=, 32
	i32.add 	$push22=, $1, $pop21
	i32.store	$drop=, __stack_pointer($pop23), $pop22
	i32.const	$push15=, 0
	return  	$pop15
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
	.functype	abort, void
