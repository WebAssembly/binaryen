	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920501-6.c"
	.section	.text.str2llu,"ax",@progbits
	.hidden	str2llu
	.globl	str2llu
	.type	str2llu,@function
str2llu:                                # @str2llu
	.param  	i32
	.result 	i64
	.local  	i32, i64
# BB#0:                                 # %entry
	i64.load8_s	$push1=, 0($0)
	i64.const	$push10=, -48
	i64.add 	$2=, $pop1, $pop10
	block   	
	i32.load8_u	$push9=, 1($0)
	tee_local	$push8=, $1=, $pop9
	i32.eqz 	$push16=, $pop8
	br_if   	0, $pop16       # 0: down to label0
# BB#1:                                 # %if.end.preheader
	i32.const	$push2=, 2
	i32.add 	$0=, $0, $pop2
.LBB0_2:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i64.const	$push15=, 10
	i64.mul 	$push3=, $2, $pop15
	i64.extend_u/i32	$push4=, $1
	i64.const	$push14=, 56
	i64.shl 	$push5=, $pop4, $pop14
	i64.const	$push13=, 56
	i64.shr_s	$push6=, $pop5, $pop13
	i64.add 	$push7=, $pop3, $pop6
	i64.const	$push12=, -48
	i64.add 	$2=, $pop7, $pop12
	i32.load8_u	$1=, 0($0)
	i32.const	$push11=, 1
	i32.add 	$push0=, $0, $pop11
	copy_local	$0=, $pop0
	br_if   	0, $1           # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
	copy_local	$push17=, $2
                                        # fallthrough-return: $pop17
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
	copy_local	$1=, $0
	i64.const	$2=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i64.const	$push14=, 1
	i64.add 	$2=, $2, $pop14
	i64.const	$push13=, 1
	i64.shr_u	$push12=, $1, $pop13
	tee_local	$push11=, $1=, $pop12
	i64.const	$push10=, 0
	i64.ne  	$push0=, $pop11, $pop10
	br_if   	0, $pop0        # 0: up to label2
# BB#2:                                 # %for.end
	end_loop
	i64.const	$push20=, 1
	i64.const	$push19=, 1
	i64.shr_u	$push4=, $2, $pop19
	i64.shl 	$push18=, $pop20, $pop4
	tee_local	$push17=, $1=, $pop18
	i64.const	$push2=, 0
	i64.const	$push16=, 1
	i64.and 	$push1=, $2, $pop16
	i64.sub 	$push3=, $pop2, $pop1
	i64.const	$push15=, 1
	i64.shr_u	$push5=, $1, $pop15
	i64.and 	$push6=, $pop3, $pop5
	i64.add 	$2=, $pop17, $pop6
.LBB1_3:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i64.div_u	$push25=, $0, $2
	tee_local	$push24=, $1=, $pop25
	i64.add 	$push7=, $1, $2
	i64.const	$push23=, 1
	i64.shr_u	$push22=, $pop7, $pop23
	tee_local	$push21=, $2=, $pop22
	i64.lt_u	$push8=, $pop24, $pop21
	br_if   	0, $pop8        # 0: up to label3
# BB#4:                                 # %do.end
	end_loop
	i32.wrap/i64	$push9=, $2
                                        # fallthrough-return: $pop9
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
	.local  	i32, i32, i64, i64, i32
# BB#0:                                 # %entry
	copy_local	$4=, $2
	block   	
	i64.gt_u	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label4
# BB#1:                                 # %for.cond.i.preheader.preheader
	copy_local	$4=, $2
.LBB2_2:                                # %for.cond.i.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
                                        #     Child Loop BB2_5 Depth 2
                                        #     Child Loop BB2_8 Depth 2
	loop    	                # label5:
	copy_local	$5=, $0
	i64.const	$6=, 0
.LBB2_3:                                # %for.cond.i
                                        #   Parent Loop BB2_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label6:
	i64.const	$push23=, 1
	i64.add 	$6=, $6, $pop23
	i64.const	$push22=, 1
	i64.shr_u	$push21=, $5, $pop22
	tee_local	$push20=, $5=, $pop21
	i64.const	$push19=, 0
	i64.ne  	$push1=, $pop20, $pop19
	br_if   	0, $pop1        # 0: up to label6
# BB#4:                                 # %for.end.i
                                        #   in Loop: Header=BB2_2 Depth=1
	end_loop
	i64.const	$push30=, 0
	i64.const	$push29=, 1
	i64.and 	$push2=, $6, $pop29
	i64.sub 	$push3=, $pop30, $pop2
	i64.const	$push28=, 1
	i64.const	$push27=, 1
	i64.shr_u	$push4=, $6, $pop27
	i64.shl 	$push26=, $pop28, $pop4
	tee_local	$push25=, $6=, $pop26
	i64.const	$push24=, 1
	i64.shr_u	$push5=, $pop25, $pop24
	i64.and 	$push6=, $pop3, $pop5
	i64.add 	$6=, $pop6, $6
.LBB2_5:                                # %do.body.i
                                        #   Parent Loop BB2_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label7:
	i64.div_u	$push35=, $0, $6
	tee_local	$push34=, $5=, $pop35
	i64.add 	$push7=, $5, $6
	i64.const	$push33=, 1
	i64.shr_u	$push32=, $pop7, $pop33
	tee_local	$push31=, $6=, $pop32
	i64.lt_u	$push8=, $pop34, $pop31
	br_if   	0, $pop8        # 0: up to label7
# BB#6:                                 # %sqrtllu.exit
                                        #   in Loop: Header=BB2_2 Depth=1
	end_loop
	block   	
	block   	
	i32.wrap/i64	$push38=, $6
	tee_local	$push37=, $3=, $pop38
	i32.const	$push36=, 3
	i32.lt_u	$push9=, $pop37, $pop36
	br_if   	0, $pop9        # 0: down to label9
# BB#7:                                 # %for.body3.preheader
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.const	$7=, 3
.LBB2_8:                                # %for.body3
                                        #   Parent Loop BB2_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label10:
	i64.extend_u/i32	$push10=, $7
	i64.rem_u	$push11=, $0, $pop10
	i64.eqz 	$push12=, $pop11
	br_if   	2, $pop12       # 2: down to label8
# BB#9:                                 # %for.cond1
                                        #   in Loop: Header=BB2_8 Depth=2
	i32.const	$push41=, 2
	i32.add 	$push40=, $7, $pop41
	tee_local	$push39=, $7=, $pop40
	i32.le_u	$push13=, $pop39, $3
	br_if   	0, $pop13       # 0: up to label10
.LBB2_10:                               # %for.end
                                        #   in Loop: Header=BB2_2 Depth=1
	end_loop
	end_block                       # label9:
	i64.store	0($4), $0
	i32.const	$push42=, 8
	i32.add 	$4=, $4, $pop42
.LBB2_11:                               # %for.inc6
                                        #   in Loop: Header=BB2_2 Depth=1
	end_block                       # label8:
	i64.const	$push45=, 2
	i64.add 	$push44=, $0, $pop45
	tee_local	$push43=, $0=, $pop44
	i64.le_u	$push14=, $pop43, $1
	br_if   	0, $pop14       # 0: up to label5
.LBB2_12:                               # %for.end8
	end_loop
	end_block                       # label4:
	i64.const	$push15=, 0
	i64.store	0($4), $pop15
	i32.sub 	$push16=, $4, $2
	i32.const	$push17=, 3
	i32.shr_s	$push18=, $pop16, $pop17
                                        # fallthrough-return: $pop18
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
	.local  	i32, i32, i64, i64, i64, i32, i32
# BB#0:                                 # %for.cond.i.preheader.i.preheader
	i32.const	$push30=, 0
	i32.const	$push27=, 0
	i32.load	$push28=, __stack_pointer($pop27)
	i32.const	$push29=, 80
	i32.sub 	$push32=, $pop28, $pop29
	tee_local	$push31=, $8=, $pop32
	i32.store	__stack_pointer($pop30), $pop31
	i64.const	$4=, 1234111111
	copy_local	$3=, $8
.LBB3_1:                                # %for.cond.i.preheader.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_2 Depth 2
                                        #     Child Loop BB3_4 Depth 2
                                        #     Child Loop BB3_7 Depth 2
	loop    	                # label11:
	copy_local	$5=, $4
	i64.const	$6=, 0
.LBB3_2:                                # %for.cond.i.i
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label12:
	i64.const	$push37=, 1
	i64.add 	$6=, $6, $pop37
	i64.const	$push36=, 1
	i64.shr_u	$push35=, $5, $pop36
	tee_local	$push34=, $5=, $pop35
	i64.const	$push33=, 0
	i64.ne  	$push0=, $pop34, $pop33
	br_if   	0, $pop0        # 0: up to label12
# BB#3:                                 # %for.end.i.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_loop
	i64.const	$push44=, 0
	i64.const	$push43=, 1
	i64.and 	$push1=, $6, $pop43
	i64.sub 	$push2=, $pop44, $pop1
	i64.const	$push42=, 1
	i64.const	$push41=, 1
	i64.shr_u	$push3=, $6, $pop41
	i64.shl 	$push40=, $pop42, $pop3
	tee_local	$push39=, $6=, $pop40
	i64.const	$push38=, 1
	i64.shr_u	$push4=, $pop39, $pop38
	i64.and 	$push5=, $pop2, $pop4
	i64.add 	$6=, $pop5, $6
.LBB3_4:                                # %do.body.i.i
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label13:
	i64.div_u	$push49=, $4, $6
	tee_local	$push48=, $5=, $pop49
	i64.add 	$push6=, $5, $6
	i64.const	$push47=, 1
	i64.shr_u	$push46=, $pop6, $pop47
	tee_local	$push45=, $6=, $pop46
	i64.lt_u	$push7=, $pop48, $pop45
	br_if   	0, $pop7        # 0: up to label13
# BB#5:                                 # %sqrtllu.exit.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_loop
	block   	
	block   	
	i32.wrap/i64	$push52=, $6
	tee_local	$push51=, $2=, $pop52
	i32.const	$push50=, 3
	i32.lt_u	$push8=, $pop51, $pop50
	br_if   	0, $pop8        # 0: down to label15
# BB#6:                                 # %for.body3.i.preheader
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$7=, 3
.LBB3_7:                                # %for.body3.i
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label16:
	i64.extend_u/i32	$push9=, $7
	i64.rem_u	$push10=, $4, $pop9
	i64.eqz 	$push11=, $pop10
	br_if   	2, $pop11       # 2: down to label14
# BB#8:                                 # %for.cond1.i
                                        #   in Loop: Header=BB3_7 Depth=2
	i32.const	$push55=, 2
	i32.add 	$push54=, $7, $pop55
	tee_local	$push53=, $7=, $pop54
	i32.le_u	$push12=, $pop53, $2
	br_if   	0, $pop12       # 0: up to label16
.LBB3_9:                                # %for.end.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_loop
	end_block                       # label15:
	i64.store	0($3), $4
	i32.const	$push56=, 8
	i32.add 	$3=, $3, $pop56
.LBB3_10:                               # %for.inc6.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_block                       # label14:
	i64.const	$push60=, 2
	i64.add 	$push59=, $4, $pop60
	tee_local	$push58=, $4=, $pop59
	i64.const	$push57=, 1234111128
	i64.lt_u	$push13=, $pop58, $pop57
	br_if   	0, $pop13       # 0: up to label11
# BB#11:                                # %plist.exit
	end_loop
	i64.const	$push14=, 0
	i64.store	0($3), $pop14
	block   	
	i64.load	$push16=, 0($8)
	i64.const	$push15=, 1234111117
	i64.ne  	$push17=, $pop16, $pop15
	br_if   	0, $pop17       # 0: down to label17
# BB#12:                                # %lor.lhs.false
	i64.load	$push19=, 8($8)
	i64.const	$push18=, 1234111121
	i64.ne  	$push20=, $pop19, $pop18
	br_if   	0, $pop20       # 0: down to label17
# BB#13:                                # %lor.lhs.false5
	i64.load	$push22=, 16($8)
	i64.const	$push21=, 1234111127
	i64.ne  	$push23=, $pop22, $pop21
	br_if   	0, $pop23       # 0: down to label17
# BB#14:                                # %lor.lhs.false8
	i64.load	$push24=, 24($8)
	i64.eqz 	$push25=, $pop24
	i32.eqz 	$push61=, $pop25
	br_if   	0, $pop61       # 0: down to label17
# BB#15:                                # %if.end
	i32.const	$push26=, 0
	call    	exit@FUNCTION, $pop26
	unreachable
.LBB3_16:                               # %if.then
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
