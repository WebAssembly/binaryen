	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49419.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
	block
	i32.const	$push0=, -1
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.cond.preheader
	i32.const	$5=, 0
	i32.const	$push26=, 0
	i32.load	$4=, t($pop26)
	block
	i32.const	$push6=, 1
	i32.lt_s	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label1
# BB#2:                                 # %for.cond.preheader
	copy_local	$6=, $0
	i32.const	$push3=, 12
	i32.mul 	$push4=, $0, $pop3
	i32.add 	$push5=, $4, $pop4
	i32.load	$push2=, 0($pop5)
	i32.ne  	$push8=, $pop2, $1
	br_if   	0, $pop8        # 0: down to label1
.LBB0_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push13=, 1
	i32.add 	$5=, $5, $pop13
	i32.ge_s	$push16=, $5, $3
	br_if   	1, $pop16       # 1: down to label3
# BB#4:                                 # %for.body
                                        #   in Loop: Header=BB0_3 Depth=1
	i32.const	$push10=, 12
	i32.mul 	$push11=, $6, $pop10
	i32.add 	$push12=, $4, $pop11
	i32.load	$6=, 4($pop12)
	i32.const	$push27=, 12
	i32.mul 	$push14=, $6, $pop27
	i32.add 	$push15=, $4, $pop14
	i32.load	$push9=, 0($pop15)
	i32.eq  	$push17=, $pop9, $1
	br_if   	0, $pop17       # 0: up to label2
.LBB0_5:                                # %for.end
	end_loop                        # label3:
	end_block                       # label1:
	block
	i32.eq  	$push18=, $5, $3
	br_if   	0, $pop18       # 0: down to label4
# BB#6:                                 # %if.end7
	block
	i32.const	$push28=, 1
	i32.lt_s	$push19=, $5, $pop28
	br_if   	0, $pop19       # 0: down to label5
# BB#7:                                 # %for.body10.preheader
	i32.const	$push20=, 2
	i32.shl 	$push21=, $5, $pop20
	i32.add 	$6=, $2, $pop21
	i32.const	$push29=, 1
	i32.add 	$3=, $5, $pop29
.LBB0_8:                                # %for.body10
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$push34=, 12
	i32.mul 	$push22=, $0, $pop34
	i32.add 	$push23=, $4, $pop22
	tee_local	$push33=, $0=, $pop23
	i32.load	$push24=, 8($pop33)
	i32.store	$discard=, 0($6), $pop24
	i32.load	$0=, 4($0)
	i32.const	$push32=, -1
	i32.add 	$3=, $3, $pop32
	i32.const	$push31=, -4
	i32.add 	$6=, $6, $pop31
	i32.const	$push30=, 1
	i32.gt_s	$push25=, $3, $pop30
	br_if   	0, $pop25       # 0: up to label6
.LBB0_9:                                # %for.end16
	end_loop                        # label7:
	end_block                       # label5:
	i32.store	$discard=, 0($2), $0
	i32.const	$push35=, 1
	i32.add 	$6=, $5, $pop35
	br      	1               # 1: down to label0
.LBB0_10:                               # %if.then6
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %cleanup
	end_block                       # label0:
	return  	$6
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
# BB#0:                                 # %for.body.i.preheader
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 48
	i32.sub 	$11=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$11=, 0($7), $11
	i32.const	$2=, 0
	i32.const	$push39=, 0
	i32.const	$push1=, 36
	i32.call	$discard=, memset@FUNCTION, $11, $pop39, $pop1
	i32.const	$push3=, 4
	i32.or  	$push4=, $11, $pop3
	i32.const	$push0=, 1
	i32.store	$push2=, 0($11):p2align=4, $pop0
	i32.store	$0=, 0($pop4), $pop2
	i32.const	$push38=, 12
	i32.or  	$push8=, $11, $pop38
	i32.load	$1=, 0($pop8)
	i32.const	$push5=, 8
	i32.or  	$push6=, $11, $pop5
	i32.const	$push7=, 2
	i32.store	$5=, 0($pop6):p2align=3, $pop7
	i32.const	$push37=, 0
	i32.store	$discard=, t($pop37), $11
	copy_local	$4=, $0
	copy_local	$3=, $0
	block
	i32.ne  	$push9=, $1, $0
	br_if   	0, $pop9        # 0: down to label8
.LBB1_1:                                # %for.body.i.for.body.i_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label9:
	i32.add 	$3=, $2, $5
	i32.add 	$2=, $2, $0
	i32.gt_s	$push15=, $3, $5
	br_if   	1, $pop15       # 1: down to label10
# BB#2:                                 # %for.body.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push41=, 12
	i32.mul 	$push11=, $4, $pop41
	i32.add 	$push12=, $11, $pop11
	i32.load	$4=, 4($pop12)
	i32.const	$push40=, 12
	i32.mul 	$push13=, $4, $pop40
	i32.add 	$push14=, $11, $pop13
	i32.load	$push10=, 0($pop14)
	i32.const	$push16=, 1
	i32.eq  	$push17=, $pop10, $pop16
	br_if   	0, $pop17       # 0: up to label9
.LBB1_3:                                # %for.end.i
	end_loop                        # label10:
	end_block                       # label8:
	block
	i32.const	$push18=, 3
	i32.eq  	$push19=, $3, $pop18
	br_if   	0, $pop19       # 0: down to label11
# BB#4:                                 # %if.end7.i
	block
	block
	i32.const	$push42=, 0
	i32.lt_s	$push20=, $2, $pop42
	br_if   	0, $pop20       # 0: down to label13
# BB#5:                                 # %for.body10.i.preheader
	i32.const	$5=, 1
	i32.const	$push21=, 2
	i32.shl 	$push22=, $3, $pop21
	tee_local	$push44=, $4=, $pop22
	i32.const	$9=, 36
	i32.add 	$9=, $11, $9
	block
	i32.add 	$push23=, $9, $pop44
	i32.const	$push43=, 2
	i32.store	$push24=, 0($pop23), $pop43
	i32.lt_s	$push25=, $3, $pop24
	br_if   	0, $pop25       # 0: down to label14
# BB#6:                                 # %for.body10.i.for.body10.i_crit_edge.preheader
	i32.const	$10=, 36
	i32.add 	$10=, $11, $10
	i32.add 	$push26=, $4, $10
	i32.const	$push45=, -4
	i32.add 	$4=, $pop26, $pop45
	i32.const	$5=, 1
.LBB1_7:                                # %for.body10.i.for.body10.i_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label15:
	i32.const	$push51=, 12
	i32.mul 	$push27=, $5, $pop51
	i32.add 	$push28=, $11, $pop27
	tee_local	$push50=, $5=, $pop28
	i32.load	$push29=, 8($pop50)
	i32.store	$discard=, 0($4), $pop29
	i32.load	$5=, 4($5)
	i32.const	$push49=, -1
	i32.add 	$3=, $3, $pop49
	i32.const	$push48=, -4
	i32.add 	$4=, $4, $pop48
	i32.const	$push47=, 1
	i32.gt_s	$push30=, $3, $pop47
	br_if   	0, $pop30       # 0: up to label15
.LBB1_8:                                # %foo.exit
	end_loop                        # label16:
	end_block                       # label14:
	i32.store	$3=, 36($11), $5
	br_if   	1, $2           # 1: down to label12
# BB#9:                                 # %if.end
	block
	i32.const	$push31=, 1
	i32.ne  	$push32=, $3, $pop31
	br_if   	0, $pop32       # 0: down to label17
# BB#10:                                # %lor.lhs.false
	i32.load	$push33=, 40($11)
	i32.const	$push34=, 2
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label17
# BB#11:                                # %if.end6
	i32.const	$push36=, 0
	i32.const	$8=, 48
	i32.add 	$11=, $11, $8
	i32.const	$8=, __stack_pointer
	i32.store	$11=, 0($8), $11
	return  	$pop36
.LBB1_12:                               # %if.then5
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB1_13:                               # %foo.exit.thread
	end_block                       # label13:
	i32.const	$push46=, 0
	i32.store	$discard=, 36($11), $pop46
.LBB1_14:                               # %if.then
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB1_15:                               # %if.then6.i
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
	.p2align	2
t:
	.int32	0
	.size	t, 4


	.ident	"clang version 3.9.0 "
