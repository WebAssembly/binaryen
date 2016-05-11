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
# BB#3:                                 # %for.body.preheader
	i32.const	$5=, 0
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
	i32.const	$push28=, 12
	i32.mul 	$push10=, $6, $pop28
	i32.add 	$push11=, $4, $pop10
	i32.load	$push27=, 4($pop11)
	tee_local	$push26=, $6=, $pop27
	i32.const	$push25=, 12
	i32.mul 	$push12=, $pop26, $pop25
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
	i32.const	$push29=, 1
	i32.lt_s	$push17=, $5, $pop29
	br_if   	0, $pop17       # 0: down to label5
# BB#8:                                 # %for.body10.preheader
	i32.const	$push18=, 2
	i32.shl 	$push19=, $5, $pop18
	i32.add 	$6=, $2, $pop19
	i32.const	$push30=, 1
	i32.add 	$3=, $5, $pop30
.LBB0_9:                                # %for.body10
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$push36=, 12
	i32.mul 	$push20=, $0, $pop36
	i32.add 	$push35=, $4, $pop20
	tee_local	$push34=, $0=, $pop35
	i32.load	$push21=, 8($pop34)
	i32.store	$discard=, 0($6), $pop21
	i32.load	$0=, 4($0)
	i32.const	$push33=, -1
	i32.add 	$3=, $3, $pop33
	i32.const	$push32=, -4
	i32.add 	$6=, $6, $pop32
	i32.const	$push31=, 1
	i32.gt_s	$push22=, $3, $pop31
	br_if   	0, $pop22       # 0: up to label6
.LBB0_10:                               # %for.end16
	end_loop                        # label7:
	end_block                       # label5:
	i32.store	$discard=, 0($2), $0
	i32.const	$push37=, 1
	i32.add 	$6=, $5, $pop37
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %for.body.i.preheader
	i32.const	$2=, 0
	i32.const	$push31=, __stack_pointer
	i32.const	$push28=, __stack_pointer
	i32.load	$push29=, 0($pop28)
	i32.const	$push30=, 48
	i32.sub 	$push37=, $pop29, $pop30
	i32.store	$push1=, 0($pop31), $pop37
	i32.const	$push42=, 0
	i32.const	$push2=, 36
	i32.call	$push41=, memset@FUNCTION, $pop1, $pop42, $pop2
	tee_local	$push40=, $1=, $pop41
	i64.const	$push3=, 4294967297
	i64.store	$discard=, 0($pop40), $pop3
	i32.load	$4=, 12($1)
	i32.const	$push4=, 2
	i32.store	$3=, 8($1), $pop4
	i32.const	$push39=, 0
	i32.store	$0=, t($pop39), $1
	i32.const	$1=, 1
	block
	i32.const	$push38=, 1
	i32.ne  	$push5=, $4, $pop38
	br_if   	0, $pop5        # 0: down to label8
# BB#1:                                 # %for.body.i.for.body.i_crit_edge.preheader
	i32.const	$2=, 0
	i32.const	$4=, 1
.LBB1_2:                                # %for.body.i.for.body.i_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label9:
	i32.add 	$1=, $2, $3
	i32.const	$push43=, 1
	i32.add 	$2=, $2, $pop43
	i32.gt_s	$push11=, $1, $3
	br_if   	1, $pop11       # 1: down to label10
# BB#3:                                 # %for.body.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push48=, 12
	i32.mul 	$push7=, $4, $pop48
	i32.add 	$push8=, $0, $pop7
	i32.load	$push47=, 4($pop8)
	tee_local	$push46=, $4=, $pop47
	i32.const	$push45=, 12
	i32.mul 	$push9=, $pop46, $pop45
	i32.add 	$push10=, $0, $pop9
	i32.load	$push6=, 0($pop10)
	i32.const	$push44=, 1
	i32.eq  	$push12=, $pop6, $pop44
	br_if   	0, $pop12       # 0: up to label9
.LBB1_4:                                # %for.end.i
	end_loop                        # label10:
	end_block                       # label8:
	block
	block
	block
	i32.const	$push13=, 3
	i32.eq  	$push14=, $1, $pop13
	br_if   	0, $pop14       # 0: down to label13
# BB#5:                                 # %if.end7.i
	i32.const	$push49=, 0
	i32.lt_s	$push15=, $2, $pop49
	br_if   	1, $pop15       # 1: down to label12
# BB#6:                                 # %for.body10.i.preheader
	i32.const	$4=, 1
	block
	i32.const	$push35=, 36
	i32.add 	$push36=, $0, $pop35
	i32.const	$push16=, 2
	i32.shl 	$push17=, $1, $pop16
	i32.add 	$push52=, $pop36, $pop17
	tee_local	$push51=, $3=, $pop52
	i32.const	$push50=, 2
	i32.store	$push0=, 0($pop51), $pop50
	i32.lt_s	$push18=, $1, $pop0
	br_if   	0, $pop18       # 0: down to label14
# BB#7:                                 # %for.body10.i.for.body10.i_crit_edge.preheader
	i32.const	$push53=, -4
	i32.add 	$3=, $3, $pop53
	i32.const	$4=, 1
.LBB1_8:                                # %for.body10.i.for.body10.i_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label15:
	i32.const	$push59=, 12
	i32.mul 	$push19=, $4, $pop59
	i32.add 	$push58=, $0, $pop19
	tee_local	$push57=, $4=, $pop58
	i32.load	$push20=, 8($pop57)
	i32.store	$discard=, 0($3), $pop20
	i32.load	$4=, 4($4)
	i32.const	$push56=, -1
	i32.add 	$1=, $1, $pop56
	i32.const	$push55=, -4
	i32.add 	$3=, $3, $pop55
	i32.const	$push54=, 1
	i32.gt_s	$push21=, $1, $pop54
	br_if   	0, $pop21       # 0: up to label15
.LBB1_9:                                # %foo.exit
	end_loop                        # label16:
	end_block                       # label14:
	i32.store	$1=, 36($0), $4
	br_if   	2, $2           # 2: down to label11
# BB#10:                                # %if.end
	i32.const	$push22=, 1
	i32.ne  	$push23=, $1, $pop22
	br_if   	2, $pop23       # 2: down to label11
# BB#11:                                # %lor.lhs.false
	i32.load	$push24=, 40($0)
	i32.const	$push25=, 2
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	2, $pop26       # 2: down to label11
# BB#12:                                # %if.end6
	i32.const	$push34=, __stack_pointer
	i32.const	$push32=, 48
	i32.add 	$push33=, $0, $pop32
	i32.store	$discard=, 0($pop34), $pop33
	i32.const	$push27=, 0
	return  	$pop27
.LBB1_13:                               # %if.then6.i
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB1_14:                               # %foo.exit.thread
	end_block                       # label12:
	i32.const	$push60=, 0
	i32.store	$discard=, 36($0), $pop60
.LBB1_15:                               # %if.then5
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
