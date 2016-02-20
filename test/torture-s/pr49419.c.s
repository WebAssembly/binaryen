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
	i32.const	$push23=, 0
	i32.load	$4=, t($pop23)
	block
	i32.const	$push6=, 1
	i32.lt_s	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label2
# BB#2:                                 # %for.cond.preheader
	i32.const	$push3=, 12
	i32.mul 	$push4=, $0, $pop3
	i32.add 	$push5=, $4, $pop4
	i32.load	$push2=, 0($pop5)
	i32.ne  	$push8=, $pop2, $1
	br_if   	0, $pop8        # 0: down to label2
# BB#3:
	copy_local	$6=, $0
.LBB0_4:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push24=, 1
	i32.add 	$5=, $5, $pop24
	i32.ge_s	$push14=, $5, $3
	br_if   	1, $pop14       # 1: down to label4
# BB#5:                                 # %for.body
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$push26=, 12
	i32.mul 	$push10=, $6, $pop26
	i32.add 	$push11=, $4, $pop10
	i32.load	$6=, 4($pop11)
	i32.const	$push25=, 12
	i32.mul 	$push12=, $6, $pop25
	i32.add 	$push13=, $4, $pop12
	i32.load	$push9=, 0($pop13)
	i32.eq  	$push15=, $pop9, $1
	br_if   	0, $pop15       # 0: up to label3
.LBB0_6:                                # %for.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.eq  	$push16=, $5, $3
	br_if   	1, $pop16       # 1: down to label0
# BB#7:                                 # %if.end7
	block
	i32.const	$push27=, 1
	i32.lt_s	$push17=, $5, $pop27
	br_if   	0, $pop17       # 0: down to label5
# BB#8:                                 # %for.body10.preheader
	i32.const	$push18=, 2
	i32.shl 	$push19=, $5, $pop18
	i32.add 	$6=, $2, $pop19
	i32.const	$push28=, 1
	i32.add 	$3=, $5, $pop28
.LBB0_9:                                # %for.body10
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$push34=, 12
	i32.mul 	$push20=, $0, $pop34
	i32.add 	$push33=, $4, $pop20
	tee_local	$push32=, $0=, $pop33
	i32.load	$push21=, 8($pop32)
	i32.store	$discard=, 0($6), $pop21
	i32.load	$0=, 4($0)
	i32.const	$push31=, -1
	i32.add 	$3=, $3, $pop31
	i32.const	$push30=, -4
	i32.add 	$6=, $6, $pop30
	i32.const	$push29=, 1
	i32.gt_s	$push22=, $3, $pop29
	br_if   	0, $pop22       # 0: up to label6
.LBB0_10:                               # %for.end16
	end_loop                        # label7:
	end_block                       # label5:
	i32.store	$discard=, 0($2), $0
	i32.const	$push35=, 1
	i32.add 	$6=, $5, $pop35
.LBB0_11:                               # %cleanup
	end_block                       # label1:
	return  	$6
.LBB0_12:                               # %if.then6
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %for.body.i.preheader
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 48
	i32.sub 	$9=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$9=, 0($5), $9
	i32.const	$2=, 0
	i32.const	$push36=, 0
	i32.const	$push1=, 36
	i32.call	$discard=, memset@FUNCTION, $9, $pop36, $pop1
	i32.const	$push3=, 4
	i32.or  	$push4=, $9, $pop3
	i32.const	$push0=, 1
	i32.store	$push2=, 0($9):p2align=4, $pop0
	i32.store	$0=, 0($pop4), $pop2
	i32.const	$push35=, 12
	i32.or  	$push8=, $9, $pop35
	i32.load	$1=, 0($pop8)
	i32.const	$push5=, 8
	i32.or  	$push6=, $9, $pop5
	i32.const	$push7=, 2
	i32.store	$3=, 0($pop6):p2align=3, $pop7
	i32.const	$push34=, 0
	i32.store	$discard=, t($pop34), $9
	block
	block
	i32.ne  	$push9=, $1, $0
	br_if   	0, $pop9        # 0: down to label9
.LBB1_1:                                # %for.body.i.for.body.i_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.add 	$1=, $2, $3
	i32.const	$push37=, 1
	i32.add 	$2=, $2, $pop37
	i32.gt_s	$push15=, $1, $3
	br_if   	3, $pop15       # 3: down to label8
# BB#2:                                 # %for.body.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push40=, 12
	i32.mul 	$push11=, $0, $pop40
	i32.add 	$push12=, $9, $pop11
	i32.load	$0=, 4($pop12)
	i32.const	$push39=, 12
	i32.mul 	$push13=, $0, $pop39
	i32.add 	$push14=, $9, $pop13
	i32.load	$push10=, 0($pop14)
	i32.const	$push38=, 1
	i32.eq  	$push16=, $pop10, $pop38
	br_if   	0, $pop16       # 0: up to label10
	br      	3               # 3: down to label8
.LBB1_3:
	end_loop                        # label11:
	end_block                       # label9:
	copy_local	$1=, $0
.LBB1_4:                                # %for.end.i
	end_block                       # label8:
	block
	block
	block
	i32.const	$push17=, 3
	i32.eq  	$push18=, $1, $pop17
	br_if   	0, $pop18       # 0: down to label14
# BB#5:                                 # %if.end7.i
	i32.const	$push41=, 0
	i32.lt_s	$push19=, $2, $pop41
	br_if   	1, $pop19       # 1: down to label13
# BB#6:                                 # %for.body10.i.preheader
	i32.const	$3=, 1
	i32.const	$push20=, 2
	i32.shl 	$push44=, $1, $pop20
	tee_local	$push43=, $0=, $pop44
	i32.const	$7=, 36
	i32.add 	$7=, $9, $7
	block
	i32.add 	$push21=, $7, $pop43
	i32.const	$push42=, 2
	i32.store	$push22=, 0($pop21), $pop42
	i32.lt_s	$push23=, $1, $pop22
	br_if   	0, $pop23       # 0: down to label15
# BB#7:                                 # %for.body10.i.for.body10.i_crit_edge.preheader
	i32.const	$8=, 36
	i32.add 	$8=, $9, $8
	i32.add 	$push24=, $0, $8
	i32.const	$push45=, -4
	i32.add 	$0=, $pop24, $pop45
	i32.const	$3=, 1
.LBB1_8:                                # %for.body10.i.for.body10.i_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	i32.const	$push52=, 12
	i32.mul 	$push25=, $3, $pop52
	i32.add 	$push51=, $9, $pop25
	tee_local	$push50=, $3=, $pop51
	i32.load	$push26=, 8($pop50)
	i32.store	$discard=, 0($0), $pop26
	i32.load	$3=, 4($3)
	i32.const	$push49=, -1
	i32.add 	$1=, $1, $pop49
	i32.const	$push48=, -4
	i32.add 	$0=, $0, $pop48
	i32.const	$push47=, 1
	i32.gt_s	$push27=, $1, $pop47
	br_if   	0, $pop27       # 0: up to label16
.LBB1_9:                                # %foo.exit
	end_loop                        # label17:
	end_block                       # label15:
	i32.store	$1=, 36($9), $3
	br_if   	2, $2           # 2: down to label12
# BB#10:                                # %if.end
	i32.const	$push28=, 1
	i32.ne  	$push29=, $1, $pop28
	br_if   	2, $pop29       # 2: down to label12
# BB#11:                                # %lor.lhs.false
	i32.load	$push30=, 40($9)
	i32.const	$push31=, 2
	i32.ne  	$push32=, $pop30, $pop31
	br_if   	2, $pop32       # 2: down to label12
# BB#12:                                # %if.end6
	i32.const	$push33=, 0
	i32.const	$6=, 48
	i32.add 	$9=, $9, $6
	i32.const	$6=, __stack_pointer
	i32.store	$9=, 0($6), $9
	return  	$pop33
.LBB1_13:                               # %if.then6.i
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB1_14:                               # %foo.exit.thread
	end_block                       # label13:
	i32.const	$push46=, 0
	i32.store	$discard=, 36($9), $pop46
.LBB1_15:                               # %if.then5
	end_block                       # label12:
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
