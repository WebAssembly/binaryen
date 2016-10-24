	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49419.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
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
	loop    	                # label3:
	i32.const	$push28=, 1
	i32.add 	$push27=, $5, $pop28
	tee_local	$push26=, $5=, $pop27
	i32.ge_s	$push10=, $pop26, $3
	br_if   	1, $pop10       # 1: down to label2
# BB#5:                                 # %for.body
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$push32=, 12
	i32.mul 	$push11=, $6, $pop32
	i32.add 	$push12=, $4, $pop11
	i32.load	$push31=, 4($pop12)
	tee_local	$push30=, $6=, $pop31
	i32.const	$push29=, 12
	i32.mul 	$push13=, $pop30, $pop29
	i32.add 	$push14=, $4, $pop13
	i32.load	$push9=, 0($pop14)
	i32.eq  	$push15=, $pop9, $1
	br_if   	0, $pop15       # 0: up to label3
.LBB0_6:                                # %for.end
	end_loop
	end_block                       # label2:
	i32.eq  	$push16=, $5, $3
	br_if   	1, $pop16       # 1: down to label0
# BB#7:                                 # %if.end7
	block   	
	i32.const	$push33=, 1
	i32.lt_s	$push17=, $5, $pop33
	br_if   	0, $pop17       # 0: down to label4
# BB#8:                                 # %for.body10.preheader
	i32.const	$push34=, 1
	i32.add 	$3=, $5, $pop34
	i32.const	$push18=, 2
	i32.shl 	$push19=, $5, $pop18
	i32.add 	$6=, $2, $pop19
.LBB0_9:                                # %for.body10
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.const	$push42=, 12
	i32.mul 	$push20=, $0, $pop42
	i32.add 	$push41=, $4, $pop20
	tee_local	$push40=, $0=, $pop41
	i32.load	$push21=, 8($pop40)
	i32.store	0($6), $pop21
	i32.const	$push39=, -4
	i32.add 	$6=, $6, $pop39
	i32.load	$0=, 4($0)
	i32.const	$push38=, -1
	i32.add 	$push37=, $3, $pop38
	tee_local	$push36=, $3=, $pop37
	i32.const	$push35=, 1
	i32.gt_s	$push22=, $pop36, $pop35
	br_if   	0, $pop22       # 0: up to label5
.LBB0_10:                               # %for.end16
	end_loop
	end_block                       # label4:
	i32.store	0($2), $0
	i32.const	$push43=, 1
	i32.add 	$push24=, $5, $pop43
	return  	$pop24
.LBB0_11:
	end_block                       # label1:
	i32.const	$push23=, 0
	return  	$pop23
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
	i32.const	$push31=, 0
	i32.const	$push28=, 0
	i32.load	$push29=, __stack_pointer($pop28)
	i32.const	$push30=, 48
	i32.sub 	$push44=, $pop29, $pop30
	tee_local	$push43=, $0=, $pop44
	i32.store	__stack_pointer($pop31), $pop43
	i32.const	$1=, 0
	i32.const	$push42=, 0
	i32.const	$push0=, 36
	i32.call	$push41=, memset@FUNCTION, $0, $pop42, $pop0
	tee_local	$push40=, $0=, $pop41
	i32.const	$push39=, 2
	i32.store	8($pop40), $pop39
	i64.const	$push1=, 4294967297
	i64.store	0($0), $pop1
	i32.const	$push38=, 0
	i32.store	t($pop38), $0
	i32.const	$3=, 1
	block   	
	i32.load	$push2=, 12($0)
	i32.const	$push37=, 1
	i32.ne  	$push3=, $pop2, $pop37
	br_if   	0, $pop3        # 0: down to label6
# BB#1:                                 # %for.body.i.for.body.i_crit_edge.preheader
	i32.const	$4=, 0
	i32.const	$3=, 1
.LBB1_2:                                # %for.body.i.for.body.i_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label8:
	i32.const	$push47=, 1
	i32.add 	$1=, $4, $pop47
	i32.const	$push46=, 2
	i32.add 	$push5=, $4, $pop46
	i32.const	$push45=, 2
	i32.gt_s	$push6=, $pop5, $pop45
	br_if   	1, $pop6        # 1: down to label7
# BB#3:                                 # %for.body.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB1_2 Depth=1
	copy_local	$4=, $1
	i32.const	$push52=, 12
	i32.mul 	$push7=, $3, $pop52
	i32.add 	$push8=, $0, $pop7
	i32.load	$push51=, 4($pop8)
	tee_local	$push50=, $3=, $pop51
	i32.const	$push49=, 12
	i32.mul 	$push9=, $pop50, $pop49
	i32.add 	$push10=, $0, $pop9
	i32.load	$push4=, 0($pop10)
	i32.const	$push48=, 1
	i32.eq  	$push11=, $pop4, $pop48
	br_if   	0, $pop11       # 0: up to label8
.LBB1_4:                                # %for.end.i.loopexit
	end_loop
	end_block                       # label7:
	i32.const	$push12=, 1
	i32.add 	$3=, $1, $pop12
.LBB1_5:                                # %for.end.i
	end_block                       # label6:
	block   	
	block   	
	block   	
	i32.const	$push13=, 3
	i32.eq  	$push14=, $3, $pop13
	br_if   	0, $pop14       # 0: down to label11
# BB#6:                                 # %if.end7.i
	i32.const	$push53=, 0
	i32.lt_s	$push15=, $1, $pop53
	br_if   	1, $pop15       # 1: down to label10
# BB#7:                                 # %for.body10.i.preheader
	i32.const	$push35=, 36
	i32.add 	$push36=, $0, $pop35
	i32.const	$push16=, 2
	i32.shl 	$push17=, $3, $pop16
	i32.add 	$push57=, $pop36, $pop17
	tee_local	$push56=, $4=, $pop57
	i32.const	$push55=, 2
	i32.store	0($pop56), $pop55
	i32.const	$5=, 1
	block   	
	i32.const	$push54=, 2
	i32.lt_s	$push18=, $3, $pop54
	br_if   	0, $pop18       # 0: down to label12
# BB#8:                                 # %for.body10.i.for.body10.i_crit_edge.preheader
	i32.const	$push58=, -4
	i32.add 	$4=, $4, $pop58
	i32.const	$5=, 1
.LBB1_9:                                # %for.body10.i.for.body10.i_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label13:
	i32.const	$push66=, 12
	i32.mul 	$push19=, $5, $pop66
	i32.add 	$push65=, $0, $pop19
	tee_local	$push64=, $2=, $pop65
	i32.load	$5=, 4($pop64)
	i32.load	$push20=, 8($2)
	i32.store	0($4), $pop20
	i32.const	$push63=, -4
	i32.add 	$4=, $4, $pop63
	i32.const	$push62=, -1
	i32.add 	$push61=, $3, $pop62
	tee_local	$push60=, $3=, $pop61
	i32.const	$push59=, 1
	i32.gt_s	$push21=, $pop60, $pop59
	br_if   	0, $pop21       # 0: up to label13
.LBB1_10:                               # %foo.exit
	end_loop
	end_block                       # label12:
	i32.store	36($0), $5
	br_if   	2, $1           # 2: down to label9
# BB#11:                                # %if.end
	i32.const	$push22=, 1
	i32.ne  	$push23=, $5, $pop22
	br_if   	2, $pop23       # 2: down to label9
# BB#12:                                # %lor.lhs.false
	i32.load	$push25=, 40($0)
	i32.const	$push24=, 2
	i32.ne  	$push26=, $pop25, $pop24
	br_if   	2, $pop26       # 2: down to label9
# BB#13:                                # %if.end6
	i32.const	$push34=, 0
	i32.const	$push32=, 48
	i32.add 	$push33=, $0, $pop32
	i32.store	__stack_pointer($pop34), $pop33
	i32.const	$push27=, 0
	return  	$pop27
.LBB1_14:                               # %if.then6.i
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB1_15:                               # %foo.exit.thread
	end_block                       # label10:
	i32.const	$push67=, 0
	i32.store	36($0), $pop67
.LBB1_16:                               # %if.then5
	end_block                       # label9:
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
