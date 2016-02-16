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
	block
	i32.const	$push0=, -1
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %for.cond.preheader
	i32.const	$5=, 0
	i32.const	$push25=, 0
	i32.load	$4=, t($pop25)
	block
	i32.const	$push6=, 1
	i32.lt_s	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label2
# BB#2:                                 # %for.cond.preheader
	copy_local	$6=, $0
	i32.const	$push3=, 12
	i32.mul 	$push4=, $0, $pop3
	i32.add 	$push5=, $4, $pop4
	i32.load	$push2=, 0($pop5)
	i32.ne  	$push8=, $pop2, $1
	br_if   	0, $pop8        # 0: down to label2
.LBB0_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push13=, 1
	i32.add 	$5=, $5, $pop13
	i32.ge_s	$push16=, $5, $3
	br_if   	1, $pop16       # 1: down to label4
# BB#4:                                 # %for.body
                                        #   in Loop: Header=BB0_3 Depth=1
	i32.const	$push10=, 12
	i32.mul 	$push11=, $6, $pop10
	i32.add 	$push12=, $4, $pop11
	i32.load	$6=, 4($pop12)
	i32.const	$push26=, 12
	i32.mul 	$push14=, $6, $pop26
	i32.add 	$push15=, $4, $pop14
	i32.load	$push9=, 0($pop15)
	i32.eq  	$push17=, $pop9, $1
	br_if   	0, $pop17       # 0: up to label3
.LBB0_5:                                # %for.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.eq  	$push18=, $5, $3
	br_if   	1, $pop18       # 1: down to label0
# BB#6:                                 # %if.end7
	block
	i32.const	$push27=, 1
	i32.lt_s	$push19=, $5, $pop27
	br_if   	0, $pop19       # 0: down to label5
# BB#7:                                 # %for.body10.preheader
	i32.const	$push20=, 2
	i32.shl 	$push21=, $5, $pop20
	i32.add 	$6=, $2, $pop21
	i32.const	$push28=, 1
	i32.add 	$3=, $5, $pop28
.LBB0_8:                                # %for.body10
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$push34=, 12
	i32.mul 	$push22=, $0, $pop34
	i32.add 	$push33=, $4, $pop22
	tee_local	$push32=, $0=, $pop33
	i32.load	$push23=, 8($pop32)
	i32.store	$discard=, 0($6), $pop23
	i32.load	$0=, 4($0)
	i32.const	$push31=, -1
	i32.add 	$3=, $3, $pop31
	i32.const	$push30=, -4
	i32.add 	$6=, $6, $pop30
	i32.const	$push29=, 1
	i32.gt_s	$push24=, $3, $pop29
	br_if   	0, $pop24       # 0: up to label6
.LBB0_9:                                # %for.end16
	end_loop                        # label7:
	end_block                       # label5:
	i32.store	$discard=, 0($2), $0
	i32.const	$push35=, 1
	i32.add 	$6=, $5, $pop35
.LBB0_10:                               # %cleanup
	end_block                       # label1:
	return  	$6
.LBB0_11:                               # %if.then6
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
	i32.const	$push37=, 0
	i32.const	$push1=, 36
	i32.call	$discard=, memset@FUNCTION, $11, $pop37, $pop1
	i32.const	$push3=, 4
	i32.or  	$push4=, $11, $pop3
	i32.const	$push0=, 1
	i32.store	$push2=, 0($11):p2align=4, $pop0
	i32.store	$0=, 0($pop4), $pop2
	i32.const	$push36=, 12
	i32.or  	$push8=, $11, $pop36
	i32.load	$1=, 0($pop8)
	i32.const	$push5=, 8
	i32.or  	$push6=, $11, $pop5
	i32.const	$push7=, 2
	i32.store	$5=, 0($pop6):p2align=3, $pop7
	i32.const	$push35=, 0
	i32.store	$discard=, t($pop35), $11
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
	i32.const	$push39=, 12
	i32.mul 	$push11=, $4, $pop39
	i32.add 	$push12=, $11, $pop11
	i32.load	$4=, 4($pop12)
	i32.const	$push38=, 12
	i32.mul 	$push13=, $4, $pop38
	i32.add 	$push14=, $11, $pop13
	i32.load	$push10=, 0($pop14)
	i32.const	$push16=, 1
	i32.eq  	$push17=, $pop10, $pop16
	br_if   	0, $pop17       # 0: up to label9
.LBB1_3:                                # %for.end.i
	end_loop                        # label10:
	end_block                       # label8:
	block
	block
	block
	i32.const	$push18=, 3
	i32.eq  	$push19=, $3, $pop18
	br_if   	0, $pop19       # 0: down to label13
# BB#4:                                 # %if.end7.i
	i32.const	$push40=, 0
	i32.lt_s	$push20=, $2, $pop40
	br_if   	1, $pop20       # 1: down to label12
# BB#5:                                 # %for.body10.i.preheader
	i32.const	$5=, 1
	i32.const	$push21=, 2
	i32.shl 	$push43=, $3, $pop21
	tee_local	$push42=, $4=, $pop43
	i32.const	$9=, 36
	i32.add 	$9=, $11, $9
	block
	i32.add 	$push22=, $9, $pop42
	i32.const	$push41=, 2
	i32.store	$push23=, 0($pop22), $pop41
	i32.lt_s	$push24=, $3, $pop23
	br_if   	0, $pop24       # 0: down to label14
# BB#6:                                 # %for.body10.i.for.body10.i_crit_edge.preheader
	i32.const	$10=, 36
	i32.add 	$10=, $11, $10
	i32.add 	$push25=, $4, $10
	i32.const	$push44=, -4
	i32.add 	$4=, $pop25, $pop44
	i32.const	$5=, 1
.LBB1_7:                                # %for.body10.i.for.body10.i_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label15:
	i32.const	$push51=, 12
	i32.mul 	$push26=, $5, $pop51
	i32.add 	$push50=, $11, $pop26
	tee_local	$push49=, $5=, $pop50
	i32.load	$push27=, 8($pop49)
	i32.store	$discard=, 0($4), $pop27
	i32.load	$5=, 4($5)
	i32.const	$push48=, -1
	i32.add 	$3=, $3, $pop48
	i32.const	$push47=, -4
	i32.add 	$4=, $4, $pop47
	i32.const	$push46=, 1
	i32.gt_s	$push28=, $3, $pop46
	br_if   	0, $pop28       # 0: up to label15
.LBB1_8:                                # %foo.exit
	end_loop                        # label16:
	end_block                       # label14:
	i32.store	$3=, 36($11), $5
	br_if   	2, $2           # 2: down to label11
# BB#9:                                 # %if.end
	block
	i32.const	$push29=, 1
	i32.ne  	$push30=, $3, $pop29
	br_if   	0, $pop30       # 0: down to label17
# BB#10:                                # %lor.lhs.false
	i32.load	$push31=, 40($11)
	i32.const	$push32=, 2
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label17
# BB#11:                                # %if.end6
	i32.const	$push34=, 0
	i32.const	$8=, 48
	i32.add 	$11=, $11, $8
	i32.const	$8=, __stack_pointer
	i32.store	$11=, 0($8), $11
	return  	$pop34
.LBB1_12:                               # %if.then5
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB1_13:                               # %if.then6.i
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB1_14:                               # %foo.exit.thread
	end_block                       # label12:
	i32.const	$push45=, 0
	i32.store	$discard=, 36($11), $pop45
.LBB1_15:                               # %if.then
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
