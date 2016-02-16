	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920501-6.c"
	.section	.text.str2llu,"ax",@progbits
	.hidden	str2llu
	.globl	str2llu
	.type	str2llu,@function
str2llu:                                # @str2llu
	.param  	i32
	.result 	i64
	.local  	i64, i64, i32
# BB#0:                                 # %entry
	i64.load8_s	$push0=, 0($0)
	i64.const	$push8=, -48
	i64.add 	$2=, $pop0, $pop8
	block
	i32.load8_u	$push7=, 1($0)
	tee_local	$push6=, $3=, $pop7
	i32.const	$push14=, 0
	i32.eq  	$push15=, $pop6, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#1:                                 # %if.end.preheader
	i32.const	$push1=, 2
	i32.add 	$0=, $0, $pop1
.LBB0_2:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i64.extend_u/i32	$1=, $3
	i32.load8_u	$3=, 0($0)
	i64.const	$push13=, 10
	i64.mul 	$push4=, $2, $pop13
	i64.const	$push12=, 56
	i64.shl 	$push2=, $1, $pop12
	i64.const	$push11=, 56
	i64.shr_s	$push3=, $pop2, $pop11
	i64.add 	$push5=, $pop4, $pop3
	i64.const	$push10=, -48
	i64.add 	$2=, $pop5, $pop10
	i32.const	$push9=, 1
	i32.add 	$0=, $0, $pop9
	br_if   	0, $3           # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$2
	.endfunc
.Lfunc_end0:
	.size	str2llu, .Lfunc_end0-str2llu

	.section	.text.sqrtllu,"ax",@progbits
	.hidden	sqrtllu
	.globl	sqrtllu
	.type	sqrtllu,@function
sqrtllu:                                # @sqrtllu
	.param  	i64
	.result 	i32
	.local  	i64, i64
# BB#0:                                 # %entry
	copy_local	$2=, $0
	i64.const	$1=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i64.const	$push12=, 1
	i64.add 	$1=, $1, $pop12
	i64.const	$push11=, 1
	i64.shr_u	$2=, $2, $pop11
	i64.const	$push10=, 0
	i64.ne  	$push0=, $2, $pop10
	br_if   	0, $pop0        # 0: up to label3
# BB#2:                                 # %for.end
	end_loop                        # label4:
	i64.const	$push16=, 1
	i64.const	$push15=, 1
	i64.shr_u	$push1=, $1, $pop15
	i64.shl 	$2=, $pop16, $pop1
	i64.const	$push2=, 63
	i64.shl 	$push3=, $1, $pop2
	i64.const	$push14=, 63
	i64.shr_s	$push4=, $pop3, $pop14
	i64.const	$push13=, 1
	i64.shr_u	$push5=, $2, $pop13
	i64.and 	$push6=, $pop4, $pop5
	i64.add 	$2=, $2, $pop6
.LBB1_3:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label5:
	i64.div_u	$push19=, $0, $2
	tee_local	$push18=, $1=, $pop19
	i64.add 	$push7=, $pop18, $2
	i64.const	$push17=, 1
	i64.shr_u	$2=, $pop7, $pop17
	i64.lt_u	$push8=, $1, $2
	br_if   	0, $pop8        # 0: up to label5
# BB#4:                                 # %do.end
	end_loop                        # label6:
	i32.wrap/i64	$push9=, $2
	return  	$pop9
	.endfunc
.Lfunc_end1:
	.size	sqrtllu, .Lfunc_end1-sqrtllu

	.section	.text.plist,"ax",@progbits
	.hidden	plist
	.globl	plist
	.type	plist,@function
plist:                                  # @plist
	.param  	i64, i64, i32
	.result 	i32
	.local  	i32, i64, i64, i32, i32
# BB#0:                                 # %entry
	copy_local	$3=, $2
	block
	i64.gt_u	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label7
.LBB2_1:                                # %for.cond.i.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_4 Depth 2
                                        #     Child Loop BB2_6 Depth 2
	loop                            # label8:
	copy_local	$5=, $0
	i64.const	$4=, 0
.LBB2_2:                                # %for.cond.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label10:
	i64.const	$push27=, 1
	i64.add 	$4=, $4, $pop27
	i64.const	$push26=, 1
	i64.shr_u	$5=, $5, $pop26
	i64.const	$push25=, 0
	i64.ne  	$push1=, $5, $pop25
	br_if   	0, $pop1        # 0: up to label10
# BB#3:                                 # %for.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label11:
	i64.const	$push3=, 63
	i64.shl 	$push4=, $4, $pop3
	i64.const	$push33=, 63
	i64.shr_s	$push5=, $pop4, $pop33
	i64.const	$push32=, 1
	i64.const	$push31=, 1
	i64.shr_u	$push2=, $4, $pop31
	i64.shl 	$push30=, $pop32, $pop2
	tee_local	$push29=, $5=, $pop30
	i64.const	$push28=, 1
	i64.shr_u	$push6=, $pop29, $pop28
	i64.and 	$push7=, $pop5, $pop6
	i64.add 	$5=, $pop7, $5
.LBB2_4:                                # %do.body.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label12:
	i64.div_u	$push35=, $0, $5
	tee_local	$push34=, $4=, $pop35
	i64.add 	$push8=, $pop34, $5
	i64.const	$push9=, 1
	i64.shr_u	$5=, $pop8, $pop9
	i64.lt_u	$push10=, $4, $5
	br_if   	0, $pop10       # 0: up to label12
# BB#5:                                 # %sqrtllu.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label13:
	i32.const	$6=, 3
	block
	block
	i32.wrap/i64	$push38=, $5
	tee_local	$push37=, $7=, $pop38
	i32.const	$push36=, 3
	i32.lt_u	$push11=, $pop37, $pop36
	br_if   	0, $pop11       # 0: down to label15
.LBB2_6:                                # %for.body3
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label16:
	i64.extend_u/i32	$push12=, $6
	i64.rem_u	$push13=, $0, $pop12
	i64.const	$push14=, 0
	i64.eq  	$push15=, $pop13, $pop14
	br_if   	3, $pop15       # 3: down to label14
# BB#7:                                 # %for.cond1
                                        #   in Loop: Header=BB2_6 Depth=2
	i32.const	$push16=, 2
	i32.add 	$6=, $6, $pop16
	i32.le_u	$push17=, $6, $7
	br_if   	0, $pop17       # 0: up to label16
.LBB2_8:                                # %for.end
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label17:
	end_block                       # label15:
	i32.const	$push18=, 8
	i32.add 	$6=, $3, $pop18
	i64.store	$discard=, 0($3), $0
	copy_local	$3=, $6
.LBB2_9:                                # %for.inc6
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label14:
	i64.const	$push19=, 2
	i64.add 	$0=, $0, $pop19
	i64.le_u	$push20=, $0, $1
	br_if   	0, $pop20       # 0: up to label8
.LBB2_10:                               # %for.end8
	end_loop                        # label9:
	end_block                       # label7:
	i64.const	$push21=, 0
	i64.store	$discard=, 0($3), $pop21
	i32.sub 	$push22=, $3, $2
	i32.const	$push23=, 3
	i32.shr_s	$push24=, $pop22, $pop23
	return  	$pop24
	.endfunc
.Lfunc_end2:
	.size	plist, .Lfunc_end2-plist

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i64, i64, i64, i32, i32, i32, i32, i32
# BB#0:                                 # %for.cond.i.preheader.i.preheader
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 80
	i32.sub 	$10=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$10=, 0($9), $10
	i64.const	$3=, 1234111111
	copy_local	$2=, $10
.LBB3_1:                                # %for.cond.i.preheader.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_2 Depth 2
                                        #     Child Loop BB3_4 Depth 2
                                        #     Child Loop BB3_6 Depth 2
	loop                            # label18:
	copy_local	$5=, $3
	i64.const	$4=, 0
.LBB3_2:                                # %for.cond.i.i
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label20:
	i64.const	$push32=, 1
	i64.add 	$4=, $4, $pop32
	i64.const	$push31=, 1
	i64.shr_u	$5=, $5, $pop31
	i64.const	$push30=, 0
	i64.ne  	$push0=, $5, $pop30
	br_if   	0, $pop0        # 0: up to label20
# BB#3:                                 # %for.end.i.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_loop                        # label21:
	i64.const	$push39=, 63
	i64.shl 	$push2=, $4, $pop39
	i64.const	$push38=, 63
	i64.shr_s	$push3=, $pop2, $pop38
	i64.const	$push37=, 1
	i64.const	$push36=, 1
	i64.shr_u	$push1=, $4, $pop36
	i64.shl 	$push35=, $pop37, $pop1
	tee_local	$push34=, $5=, $pop35
	i64.const	$push33=, 1
	i64.shr_u	$push4=, $pop34, $pop33
	i64.and 	$push5=, $pop3, $pop4
	i64.add 	$5=, $pop5, $5
.LBB3_4:                                # %do.body.i.i
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label22:
	i64.div_u	$push42=, $3, $5
	tee_local	$push41=, $4=, $pop42
	i64.add 	$push6=, $pop41, $5
	i64.const	$push40=, 1
	i64.shr_u	$5=, $pop6, $pop40
	i64.lt_u	$push7=, $4, $5
	br_if   	0, $pop7        # 0: up to label22
# BB#5:                                 # %sqrtllu.exit.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_loop                        # label23:
	i32.const	$6=, 3
	block
	block
	i32.wrap/i64	$push45=, $5
	tee_local	$push44=, $7=, $pop45
	i32.const	$push43=, 3
	i32.lt_u	$push8=, $pop44, $pop43
	br_if   	0, $pop8        # 0: down to label25
.LBB3_6:                                # %for.body3.i
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label26:
	i64.extend_u/i32	$push9=, $6
	i64.rem_u	$push10=, $3, $pop9
	i64.const	$push47=, 0
	i64.eq  	$push11=, $pop10, $pop47
	br_if   	3, $pop11       # 3: down to label24
# BB#7:                                 # %for.cond1.i
                                        #   in Loop: Header=BB3_6 Depth=2
	i32.const	$push46=, 2
	i32.add 	$6=, $6, $pop46
	i32.le_u	$push12=, $6, $7
	br_if   	0, $pop12       # 0: up to label26
.LBB3_8:                                # %for.end.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_loop                        # label27:
	end_block                       # label25:
	i32.const	$push48=, 8
	i32.add 	$6=, $2, $pop48
	i64.store	$discard=, 0($2), $3
	copy_local	$2=, $6
.LBB3_9:                                # %for.inc6.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_block                       # label24:
	i64.const	$push50=, 2
	i64.add 	$3=, $3, $pop50
	i64.const	$push49=, 1234111128
	i64.lt_u	$push13=, $3, $pop49
	br_if   	0, $pop13       # 0: up to label18
# BB#10:                                # %plist.exit
	end_loop                        # label19:
	i64.const	$push14=, 0
	i64.store	$discard=, 0($2), $pop14
	block
	i64.load	$push15=, 0($10):p2align=4
	i64.const	$push16=, 1234111117
	i64.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label28
# BB#11:                                # %lor.lhs.false
	i32.const	$push18=, 8
	i32.or  	$push19=, $10, $pop18
	i64.load	$push20=, 0($pop19)
	i64.const	$push21=, 1234111121
	i64.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label28
# BB#12:                                # %lor.lhs.false5
	i64.load	$push23=, 16($10):p2align=4
	i64.const	$push24=, 1234111127
	i64.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label28
# BB#13:                                # %lor.lhs.false8
	i64.load	$push26=, 24($10)
	i64.const	$push27=, 0
	i64.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label28
# BB#14:                                # %if.end
	i32.const	$push29=, 0
	call    	exit@FUNCTION, $pop29
	unreachable
.LBB3_15:                               # %if.then
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.9.0 "
