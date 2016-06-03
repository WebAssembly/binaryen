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
	i32.const	$push3=, 1
	i32.lt_s	$push4=, $3, $pop3
	br_if   	0, $pop4        # 0: down to label2
# BB#2:                                 # %for.cond.preheader
	i32.const	$push5=, 12
	i32.mul 	$push6=, $0, $pop5
	i32.add 	$push7=, $4, $pop6
	i32.load	$push2=, 0($pop7)
	i32.ne  	$push8=, $pop2, $1
	br_if   	0, $pop8        # 0: down to label2
# BB#3:                                 # %for.body.preheader
	i32.const	$5=, 0
	copy_local	$6=, $0
.LBB0_4:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push26=, 1
	i32.add 	$push25=, $5, $pop26
	tee_local	$push24=, $5=, $pop25
	i32.ge_s	$push10=, $pop24, $3
	br_if   	1, $pop10       # 1: down to label4
# BB#5:                                 # %for.body
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$push30=, 12
	i32.mul 	$push11=, $6, $pop30
	i32.add 	$push12=, $4, $pop11
	i32.load	$push29=, 4($pop12)
	tee_local	$push28=, $6=, $pop29
	i32.const	$push27=, 12
	i32.mul 	$push13=, $pop28, $pop27
	i32.add 	$push14=, $4, $pop13
	i32.load	$push9=, 0($pop14)
	i32.eq  	$push15=, $pop9, $1
	br_if   	0, $pop15       # 0: up to label3
.LBB0_6:                                # %for.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.eq  	$push16=, $5, $3
	br_if   	1, $pop16       # 1: down to label0
# BB#7:                                 # %if.end7
	block
	i32.const	$push31=, 1
	i32.lt_s	$push17=, $5, $pop31
	br_if   	0, $pop17       # 0: down to label5
# BB#8:                                 # %for.body10.preheader
	i32.const	$push32=, 1
	i32.add 	$3=, $5, $pop32
	i32.const	$push18=, 2
	i32.shl 	$push19=, $5, $pop18
	i32.add 	$6=, $2, $pop19
.LBB0_9:                                # %for.body10
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$push40=, 12
	i32.mul 	$push20=, $0, $pop40
	i32.add 	$push39=, $4, $pop20
	tee_local	$push38=, $0=, $pop39
	i32.load	$push21=, 8($pop38)
	i32.store	$drop=, 0($6), $pop21
	i32.const	$push37=, -4
	i32.add 	$6=, $6, $pop37
	i32.load	$0=, 4($0)
	i32.const	$push36=, -1
	i32.add 	$push35=, $3, $pop36
	tee_local	$push34=, $3=, $pop35
	i32.const	$push33=, 1
	i32.gt_s	$push22=, $pop34, $pop33
	br_if   	0, $pop22       # 0: up to label6
.LBB0_10:                               # %for.end16
	end_loop                        # label7:
	end_block                       # label5:
	i32.const	$push41=, 1
	i32.add 	$6=, $5, $pop41
	i32.store	$drop=, 0($2), $0
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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %for.body.i.preheader
	i32.const	$1=, 0
	i32.const	$push34=, 0
	i32.const	$push31=, 0
	i32.load	$push32=, __stack_pointer($pop31)
	i32.const	$push33=, 48
	i32.sub 	$push40=, $pop32, $pop33
	i32.store	$push1=, __stack_pointer($pop34), $pop40
	i32.const	$push47=, 0
	i32.const	$push2=, 36
	i32.call	$push46=, memset@FUNCTION, $pop1, $pop47, $pop2
	tee_local	$push45=, $0=, $pop46
	i32.const	$push3=, 2
	i32.store	$5=, 8($pop45), $pop3
	i64.const	$push4=, 4294967297
	i64.store	$drop=, 0($0), $pop4
	i32.const	$3=, 1
	block
	i32.const	$push44=, 0
	i32.store	$push43=, t($pop44), $0
	tee_local	$push42=, $0=, $pop43
	i32.load	$push5=, 12($pop42)
	i32.const	$push41=, 1
	i32.ne  	$push6=, $pop5, $pop41
	br_if   	0, $pop6        # 0: down to label8
# BB#1:                                 # %for.body.i.for.body.i_crit_edge.preheader
	i32.const	$4=, 0
	i32.const	$3=, 1
.LBB1_2:                                # %for.body.i.for.body.i_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label9:
	i32.const	$push48=, 1
	i32.add 	$1=, $4, $pop48
	i32.add 	$push8=, $4, $5
	i32.gt_s	$push9=, $pop8, $5
	br_if   	1, $pop9        # 1: down to label10
# BB#3:                                 # %for.body.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB1_2 Depth=1
	copy_local	$4=, $1
	i32.const	$push53=, 12
	i32.mul 	$push10=, $3, $pop53
	i32.add 	$push11=, $0, $pop10
	i32.load	$push52=, 4($pop11)
	tee_local	$push51=, $3=, $pop52
	i32.const	$push50=, 12
	i32.mul 	$push12=, $pop51, $pop50
	i32.add 	$push13=, $0, $pop12
	i32.load	$push7=, 0($pop13)
	i32.const	$push49=, 1
	i32.eq  	$push14=, $pop7, $pop49
	br_if   	0, $pop14       # 0: up to label9
.LBB1_4:                                # %for.end.i.loopexit
	end_loop                        # label10:
	i32.const	$push15=, 1
	i32.add 	$3=, $1, $pop15
.LBB1_5:                                # %for.end.i
	end_block                       # label8:
	block
	block
	block
	i32.const	$push16=, 3
	i32.eq  	$push17=, $3, $pop16
	br_if   	0, $pop17       # 0: down to label13
# BB#6:                                 # %if.end7.i
	i32.const	$push54=, 0
	i32.lt_s	$push18=, $1, $pop54
	br_if   	1, $pop18       # 1: down to label12
# BB#7:                                 # %for.body10.i.preheader
	i32.const	$5=, 1
	block
	i32.const	$push38=, 36
	i32.add 	$push39=, $0, $pop38
	i32.const	$push19=, 2
	i32.shl 	$push20=, $3, $pop19
	i32.add 	$push57=, $pop39, $pop20
	tee_local	$push56=, $4=, $pop57
	i32.const	$push55=, 2
	i32.store	$push0=, 0($pop56), $pop55
	i32.lt_s	$push21=, $3, $pop0
	br_if   	0, $pop21       # 0: down to label14
# BB#8:                                 # %for.body10.i.for.body10.i_crit_edge.preheader
	i32.const	$push58=, -4
	i32.add 	$4=, $4, $pop58
	i32.const	$5=, 1
.LBB1_9:                                # %for.body10.i.for.body10.i_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label15:
	i32.const	$push66=, 12
	i32.mul 	$push22=, $5, $pop66
	i32.add 	$push65=, $0, $pop22
	tee_local	$push64=, $2=, $pop65
	i32.load	$5=, 4($pop64)
	i32.load	$push23=, 8($2)
	i32.store	$drop=, 0($4), $pop23
	i32.const	$push63=, -4
	i32.add 	$4=, $4, $pop63
	i32.const	$push62=, -1
	i32.add 	$push61=, $3, $pop62
	tee_local	$push60=, $3=, $pop61
	i32.const	$push59=, 1
	i32.gt_s	$push24=, $pop60, $pop59
	br_if   	0, $pop24       # 0: up to label15
.LBB1_10:                               # %foo.exit
	end_loop                        # label16:
	end_block                       # label14:
	i32.store	$4=, 36($0), $5
	br_if   	2, $1           # 2: down to label11
# BB#11:                                # %if.end
	i32.const	$push25=, 1
	i32.ne  	$push26=, $4, $pop25
	br_if   	2, $pop26       # 2: down to label11
# BB#12:                                # %lor.lhs.false
	i32.load	$push28=, 40($0)
	i32.const	$push27=, 2
	i32.ne  	$push29=, $pop28, $pop27
	br_if   	2, $pop29       # 2: down to label11
# BB#13:                                # %if.end6
	i32.const	$push37=, 0
	i32.const	$push35=, 48
	i32.add 	$push36=, $0, $pop35
	i32.store	$drop=, __stack_pointer($pop37), $pop36
	i32.const	$push30=, 0
	return  	$pop30
.LBB1_14:                               # %if.then6.i
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB1_15:                               # %foo.exit.thread
	end_block                       # label12:
	i32.const	$push67=, 0
	i32.store	$drop=, 36($0), $pop67
.LBB1_16:                               # %if.then5
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
	.functype	abort, void
