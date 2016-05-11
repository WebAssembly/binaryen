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
	i64.div_u	$1=, $0, $2
	i64.add 	$push7=, $1, $2
	i64.const	$push19=, 1
	i64.shr_u	$push18=, $pop7, $pop19
	tee_local	$push17=, $2=, $pop18
	i64.lt_u	$push8=, $1, $pop17
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
	.local  	i64, i32, i32, i64, i32
# BB#0:                                 # %entry
	copy_local	$4=, $2
	block
	i64.gt_u	$push1=, $0, $1
	br_if   	0, $pop1        # 0: down to label7
# BB#1:                                 # %for.cond.i.preheader.preheader
	copy_local	$4=, $2
.LBB2_2:                                # %for.cond.i.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
                                        #     Child Loop BB2_5 Depth 2
                                        #     Child Loop BB2_8 Depth 2
	loop                            # label8:
	copy_local	$6=, $0
	i64.const	$3=, 0
.LBB2_3:                                # %for.cond.i
                                        #   Parent Loop BB2_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label10:
	i64.const	$push22=, 1
	i64.add 	$3=, $3, $pop22
	i64.const	$push21=, 1
	i64.shr_u	$6=, $6, $pop21
	i64.const	$push20=, 0
	i64.ne  	$push2=, $6, $pop20
	br_if   	0, $pop2        # 0: up to label10
# BB#4:                                 # %for.end.i
                                        #   in Loop: Header=BB2_2 Depth=1
	end_loop                        # label11:
	i64.const	$push29=, 63
	i64.shl 	$push4=, $3, $pop29
	i64.const	$push28=, 63
	i64.shr_s	$push5=, $pop4, $pop28
	i64.const	$push27=, 1
	i64.const	$push26=, 1
	i64.shr_u	$push3=, $3, $pop26
	i64.shl 	$push25=, $pop27, $pop3
	tee_local	$push24=, $6=, $pop25
	i64.const	$push23=, 1
	i64.shr_u	$push6=, $pop24, $pop23
	i64.and 	$push7=, $pop5, $pop6
	i64.add 	$6=, $pop7, $6
.LBB2_5:                                # %do.body.i
                                        #   Parent Loop BB2_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label12:
	i64.div_u	$3=, $0, $6
	i64.add 	$push8=, $3, $6
	i64.const	$push32=, 1
	i64.shr_u	$push31=, $pop8, $pop32
	tee_local	$push30=, $6=, $pop31
	i64.lt_u	$push9=, $3, $pop30
	br_if   	0, $pop9        # 0: up to label12
# BB#6:                                 # %sqrtllu.exit
                                        #   in Loop: Header=BB2_2 Depth=1
	end_loop                        # label13:
	block
	block
	i32.wrap/i64	$push35=, $6
	tee_local	$push34=, $7=, $pop35
	i32.const	$push33=, 3
	i32.lt_u	$push10=, $pop34, $pop33
	br_if   	0, $pop10       # 0: down to label15
# BB#7:                                 # %for.body3.preheader
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.const	$5=, 3
.LBB2_8:                                # %for.body3
                                        #   Parent Loop BB2_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label16:
	i64.extend_u/i32	$push11=, $5
	i64.rem_u	$push12=, $0, $pop11
	i64.eqz 	$push13=, $pop12
	br_if   	3, $pop13       # 3: down to label14
# BB#9:                                 # %for.cond1
                                        #   in Loop: Header=BB2_8 Depth=2
	i32.const	$push36=, 2
	i32.add 	$5=, $5, $pop36
	i32.le_u	$push14=, $5, $7
	br_if   	0, $pop14       # 0: up to label16
.LBB2_10:                               # %for.end
                                        #   in Loop: Header=BB2_2 Depth=1
	end_loop                        # label17:
	end_block                       # label15:
	i64.store	$discard=, 0($4), $0
	i32.const	$push37=, 8
	i32.add 	$push0=, $4, $pop37
	copy_local	$4=, $pop0
.LBB2_11:                               # %for.inc6
                                        #   in Loop: Header=BB2_2 Depth=1
	end_block                       # label14:
	i64.const	$push38=, 2
	i64.add 	$0=, $0, $pop38
	i64.le_u	$push15=, $0, $1
	br_if   	0, $pop15       # 0: up to label8
.LBB2_12:                               # %for.end8
	end_loop                        # label9:
	end_block                       # label7:
	i64.const	$push16=, 0
	i64.store	$discard=, 0($4), $pop16
	i32.sub 	$push17=, $4, $2
	i32.const	$push18=, 3
	i32.shr_s	$push19=, $pop17, $pop18
	return  	$pop19
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
	.local  	i64, i32, i64, i32, i32, i64, i32
# BB#0:                                 # %for.cond.i.preheader.i.preheader
	i64.const	$4=, 1234111111
	i32.const	$push31=, __stack_pointer
	i32.const	$push28=, __stack_pointer
	i32.load	$push29=, 0($pop28)
	i32.const	$push30=, 80
	i32.sub 	$push32=, $pop29, $pop30
	i32.store	$push34=, 0($pop31), $pop32
	tee_local	$push33=, $6=, $pop34
	copy_local	$3=, $pop33
.LBB3_1:                                # %for.cond.i.preheader.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_2 Depth 2
                                        #     Child Loop BB3_4 Depth 2
                                        #     Child Loop BB3_7 Depth 2
	loop                            # label18:
	copy_local	$7=, $4
	i64.const	$2=, 0
.LBB3_2:                                # %for.cond.i.i
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label20:
	i64.const	$push37=, 1
	i64.add 	$2=, $2, $pop37
	i64.const	$push36=, 1
	i64.shr_u	$7=, $7, $pop36
	i64.const	$push35=, 0
	i64.ne  	$push1=, $7, $pop35
	br_if   	0, $pop1        # 0: up to label20
# BB#3:                                 # %for.end.i.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_loop                        # label21:
	i64.const	$push44=, 63
	i64.shl 	$push3=, $2, $pop44
	i64.const	$push43=, 63
	i64.shr_s	$push4=, $pop3, $pop43
	i64.const	$push42=, 1
	i64.const	$push41=, 1
	i64.shr_u	$push2=, $2, $pop41
	i64.shl 	$push40=, $pop42, $pop2
	tee_local	$push39=, $7=, $pop40
	i64.const	$push38=, 1
	i64.shr_u	$push5=, $pop39, $pop38
	i64.and 	$push6=, $pop4, $pop5
	i64.add 	$7=, $pop6, $7
.LBB3_4:                                # %do.body.i.i
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label22:
	i64.div_u	$2=, $4, $7
	i64.add 	$push7=, $2, $7
	i64.const	$push47=, 1
	i64.shr_u	$push46=, $pop7, $pop47
	tee_local	$push45=, $7=, $pop46
	i64.lt_u	$push8=, $2, $pop45
	br_if   	0, $pop8        # 0: up to label22
# BB#5:                                 # %sqrtllu.exit.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_loop                        # label23:
	block
	block
	i32.wrap/i64	$push50=, $7
	tee_local	$push49=, $8=, $pop50
	i32.const	$push48=, 3
	i32.lt_u	$push9=, $pop49, $pop48
	br_if   	0, $pop9        # 0: down to label25
# BB#6:                                 # %for.body3.i.preheader
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$5=, 3
.LBB3_7:                                # %for.body3.i
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label26:
	i64.extend_u/i32	$push10=, $5
	i64.rem_u	$push11=, $4, $pop10
	i64.eqz 	$push12=, $pop11
	br_if   	3, $pop12       # 3: down to label24
# BB#8:                                 # %for.cond1.i
                                        #   in Loop: Header=BB3_7 Depth=2
	i32.const	$push51=, 2
	i32.add 	$5=, $5, $pop51
	i32.le_u	$push13=, $5, $8
	br_if   	0, $pop13       # 0: up to label26
.LBB3_9:                                # %for.end.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_loop                        # label27:
	end_block                       # label25:
	i64.store	$discard=, 0($3), $4
	i32.const	$push52=, 8
	i32.add 	$push0=, $3, $pop52
	copy_local	$3=, $pop0
.LBB3_10:                               # %for.inc6.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_block                       # label24:
	i64.const	$push54=, 2
	i64.add 	$4=, $4, $pop54
	i64.const	$push53=, 1234111128
	i64.lt_u	$push14=, $4, $pop53
	br_if   	0, $pop14       # 0: up to label18
# BB#11:                                # %plist.exit
	end_loop                        # label19:
	i64.const	$push15=, 0
	i64.store	$discard=, 0($3), $pop15
	block
	i64.load	$push16=, 0($6)
	i64.const	$push17=, 1234111117
	i64.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label28
# BB#12:                                # %lor.lhs.false
	i64.load	$push19=, 8($6)
	i64.const	$push20=, 1234111121
	i64.ne  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label28
# BB#13:                                # %lor.lhs.false5
	i64.load	$push22=, 16($6)
	i64.const	$push23=, 1234111127
	i64.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label28
# BB#14:                                # %lor.lhs.false8
	i64.load	$push25=, 24($6)
	i64.eqz 	$push26=, $pop25
	i32.const	$push55=, 0
	i32.eq  	$push56=, $pop26, $pop55
	br_if   	0, $pop56       # 0: down to label28
# BB#15:                                # %if.end
	i32.const	$push27=, 0
	call    	exit@FUNCTION, $pop27
	unreachable
.LBB3_16:                               # %if.then
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.9.0 "
