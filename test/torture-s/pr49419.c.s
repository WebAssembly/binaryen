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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %for.body.i.preheader
	i32.const	$push46=, __stack_pointer
	i32.load	$push47=, 0($pop46)
	i32.const	$push48=, 48
	i32.sub 	$4=, $pop47, $pop48
	i32.const	$push49=, __stack_pointer
	i32.store	$discard=, 0($pop49), $4
	i32.const	$1=, 0
	i32.const	$push29=, 0
	i32.const	$push0=, 36
	i32.call	$discard=, memset@FUNCTION, $4, $pop29, $pop0
	i64.const	$push1=, 4294967297
	i64.store	$discard=, 0($4):p2align=4, $pop1
	i32.load	$2=, 12($4)
	i32.const	$push2=, 2
	i32.store	$3=, 8($4):p2align=3, $pop2
	i32.const	$push28=, 0
	i32.store	$discard=, t($pop28), $4
	i32.const	$0=, 1
	block
	i32.const	$push27=, 1
	i32.ne  	$push3=, $2, $pop27
	br_if   	0, $pop3        # 0: down to label8
# BB#1:                                 # %for.body.i.for.body.i_crit_edge.preheader
	i32.const	$1=, 0
	i32.const	$2=, 1
.LBB1_2:                                # %for.body.i.for.body.i_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label9:
	i32.add 	$0=, $1, $3
	i32.const	$push30=, 1
	i32.add 	$1=, $1, $pop30
	i32.gt_s	$push9=, $0, $3
	br_if   	1, $pop9        # 1: down to label10
# BB#3:                                 # %for.body.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push33=, 12
	i32.mul 	$push5=, $2, $pop33
	i32.add 	$push6=, $4, $pop5
	i32.load	$2=, 4($pop6)
	i32.const	$push32=, 12
	i32.mul 	$push7=, $2, $pop32
	i32.add 	$push8=, $4, $pop7
	i32.load	$push4=, 0($pop8)
	i32.const	$push31=, 1
	i32.eq  	$push10=, $pop4, $pop31
	br_if   	0, $pop10       # 0: up to label9
.LBB1_4:                                # %for.end.i
	end_loop                        # label10:
	end_block                       # label8:
	block
	block
	block
	i32.const	$push11=, 3
	i32.eq  	$push12=, $0, $pop11
	br_if   	0, $pop12       # 0: down to label13
# BB#5:                                 # %if.end7.i
	i32.const	$push34=, 0
	i32.lt_s	$push13=, $1, $pop34
	br_if   	1, $pop13       # 1: down to label12
# BB#6:                                 # %for.body10.i.preheader
	i32.const	$3=, 1
	block
	i32.const	$push53=, 36
	i32.add 	$push54=, $4, $pop53
	i32.const	$push14=, 2
	i32.shl 	$push15=, $0, $pop14
	i32.add 	$push37=, $pop54, $pop15
	tee_local	$push36=, $2=, $pop37
	i32.const	$push35=, 2
	i32.store	$push16=, 0($pop36), $pop35
	i32.lt_s	$push17=, $0, $pop16
	br_if   	0, $pop17       # 0: down to label14
# BB#7:                                 # %for.body10.i.for.body10.i_crit_edge.preheader
	i32.const	$push38=, -4
	i32.add 	$2=, $2, $pop38
	i32.const	$3=, 1
.LBB1_8:                                # %for.body10.i.for.body10.i_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label15:
	i32.const	$push45=, 12
	i32.mul 	$push18=, $3, $pop45
	i32.add 	$push44=, $4, $pop18
	tee_local	$push43=, $3=, $pop44
	i32.load	$push19=, 8($pop43)
	i32.store	$discard=, 0($2), $pop19
	i32.load	$3=, 4($3)
	i32.const	$push42=, -1
	i32.add 	$0=, $0, $pop42
	i32.const	$push41=, -4
	i32.add 	$2=, $2, $pop41
	i32.const	$push40=, 1
	i32.gt_s	$push20=, $0, $pop40
	br_if   	0, $pop20       # 0: up to label15
.LBB1_9:                                # %foo.exit
	end_loop                        # label16:
	end_block                       # label14:
	i32.store	$0=, 36($4), $3
	br_if   	2, $1           # 2: down to label11
# BB#10:                                # %if.end
	i32.const	$push21=, 1
	i32.ne  	$push22=, $0, $pop21
	br_if   	2, $pop22       # 2: down to label11
# BB#11:                                # %lor.lhs.false
	i32.load	$push23=, 40($4)
	i32.const	$push24=, 2
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	2, $pop25       # 2: down to label11
# BB#12:                                # %if.end6
	i32.const	$push26=, 0
	i32.const	$push52=, __stack_pointer
	i32.const	$push50=, 48
	i32.add 	$push51=, $4, $pop50
	i32.store	$discard=, 0($pop52), $pop51
	return  	$pop26
.LBB1_13:                               # %if.then6.i
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB1_14:                               # %foo.exit.thread
	end_block                       # label12:
	i32.const	$push39=, 0
	i32.store	$discard=, 36($4), $pop39
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
