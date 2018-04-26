	.text
	.file	"920501-6.c"
	.section	.text.str2llu,"ax",@progbits
	.hidden	str2llu                 # -- Begin function str2llu
	.globl	str2llu
	.type	str2llu,@function
str2llu:                                # @str2llu
	.param  	i32
	.result 	i64
	.local  	i32, i64
# %bb.0:                                # %entry
	i64.load8_s	$push1=, 0($0)
	i64.const	$push8=, -48
	i64.add 	$2=, $pop1, $pop8
	i32.load8_u	$1=, 1($0)
	block   	
	i32.eqz 	$push14=, $1
	br_if   	0, $pop14       # 0: down to label0
# %bb.1:                                # %if.end.preheader
	i32.const	$push2=, 2
	i32.add 	$0=, $0, $pop2
.LBB0_2:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i64.const	$push13=, 10
	i64.mul 	$push3=, $2, $pop13
	i64.extend_u/i32	$push4=, $1
	i64.const	$push12=, 56
	i64.shl 	$push5=, $pop4, $pop12
	i64.const	$push11=, 56
	i64.shr_s	$push6=, $pop5, $pop11
	i64.add 	$push7=, $pop3, $pop6
	i64.const	$push10=, -48
	i64.add 	$2=, $pop7, $pop10
	i32.load8_u	$1=, 0($0)
	i32.const	$push9=, 1
	i32.add 	$push0=, $0, $pop9
	copy_local	$0=, $pop0
	br_if   	0, $1           # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
	copy_local	$push15=, $2
                                        # fallthrough-return: $pop15
	.endfunc
.Lfunc_end0:
	.size	str2llu, .Lfunc_end0-str2llu
                                        # -- End function
	.section	.text.sqrtllu,"ax",@progbits
	.hidden	sqrtllu                 # -- Begin function sqrtllu
	.globl	sqrtllu
	.type	sqrtllu,@function
sqrtllu:                                # @sqrtllu
	.param  	i64
	.result 	i32
	.local  	i64, i64
# %bb.0:                                # %entry
	copy_local	$2=, $0
	i64.const	$1=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i64.const	$push12=, 1
	i64.add 	$1=, $1, $pop12
	i64.const	$push11=, 1
	i64.shr_u	$2=, $2, $pop11
	i64.const	$push10=, 0
	i64.ne  	$push0=, $2, $pop10
	br_if   	0, $pop0        # 0: up to label2
# %bb.2:                                # %for.end
	end_loop
	i64.const	$push16=, 1
	i64.const	$push15=, 1
	i64.shr_u	$push4=, $1, $pop15
	i64.shl 	$2=, $pop16, $pop4
	i64.const	$push2=, 0
	i64.const	$push14=, 1
	i64.and 	$push1=, $1, $pop14
	i64.sub 	$push3=, $pop2, $pop1
	i64.const	$push13=, 1
	i64.shr_u	$push5=, $2, $pop13
	i64.and 	$push6=, $pop3, $pop5
	i64.add 	$2=, $pop6, $2
.LBB1_3:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i64.div_u	$1=, $0, $2
	i64.add 	$push7=, $1, $2
	i64.const	$push17=, 1
	i64.shr_u	$2=, $pop7, $pop17
	i64.lt_u	$push8=, $1, $2
	br_if   	0, $pop8        # 0: up to label3
# %bb.4:                                # %do.end
	end_loop
	i32.wrap/i64	$push9=, $2
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end1:
	.size	sqrtllu, .Lfunc_end1-sqrtllu
                                        # -- End function
	.section	.text.plist,"ax",@progbits
	.hidden	plist                   # -- Begin function plist
	.globl	plist
	.type	plist,@function
plist:                                  # @plist
	.param  	i64, i64, i32
	.result 	i32
	.local  	i32, i64, i32, i64, i32
# %bb.0:                                # %entry
	copy_local	$5=, $2
	block   	
	i64.gt_u	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label4
# %bb.1:                                # %for.body.preheader
	copy_local	$5=, $2
.LBB2_2:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
                                        #     Child Loop BB2_5 Depth 2
                                        #     Child Loop BB2_8 Depth 2
	loop    	                # label5:
	copy_local	$6=, $0
	i64.const	$4=, 0
.LBB2_3:                                # %for.cond.i
                                        #   Parent Loop BB2_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label6:
	i64.const	$push21=, 1
	i64.add 	$4=, $4, $pop21
	i64.const	$push20=, 1
	i64.shr_u	$6=, $6, $pop20
	i64.const	$push19=, 0
	i64.ne  	$push1=, $6, $pop19
	br_if   	0, $pop1        # 0: up to label6
# %bb.4:                                # %for.end.i
                                        #   in Loop: Header=BB2_2 Depth=1
	end_loop
	i64.const	$push26=, 1
	i64.const	$push25=, 1
	i64.shr_u	$push4=, $4, $pop25
	i64.shl 	$6=, $pop26, $pop4
	i64.const	$push24=, 0
	i64.const	$push23=, 1
	i64.and 	$push2=, $4, $pop23
	i64.sub 	$push3=, $pop24, $pop2
	i64.const	$push22=, 1
	i64.shr_u	$push5=, $6, $pop22
	i64.and 	$push6=, $pop3, $pop5
	i64.add 	$6=, $pop6, $6
.LBB2_5:                                # %do.body.i
                                        #   Parent Loop BB2_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label7:
	i64.div_u	$4=, $0, $6
	i64.add 	$push7=, $4, $6
	i64.const	$push27=, 1
	i64.shr_u	$6=, $pop7, $pop27
	i64.lt_u	$push8=, $4, $6
	br_if   	0, $pop8        # 0: up to label7
# %bb.6:                                # %sqrtllu.exit
                                        #   in Loop: Header=BB2_2 Depth=1
	end_loop
	i32.wrap/i64	$3=, $6
	block   	
	block   	
	i32.const	$push28=, 3
	i32.lt_u	$push9=, $3, $pop28
	br_if   	0, $pop9        # 0: down to label9
# %bb.7:                                # %for.body3.preheader
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
# %bb.9:                                # %for.cond1
                                        #   in Loop: Header=BB2_8 Depth=2
	i32.const	$push29=, 2
	i32.add 	$7=, $7, $pop29
	i32.le_u	$push13=, $7, $3
	br_if   	0, $pop13       # 0: up to label10
.LBB2_10:                               # %for.end
                                        #   in Loop: Header=BB2_2 Depth=1
	end_loop
	end_block                       # label9:
	i64.store	0($5), $0
	i32.const	$push30=, 8
	i32.add 	$5=, $5, $pop30
.LBB2_11:                               # %for.inc6
                                        #   in Loop: Header=BB2_2 Depth=1
	end_block                       # label8:
	i64.const	$push31=, 2
	i64.add 	$0=, $0, $pop31
	i64.le_u	$push14=, $0, $1
	br_if   	0, $pop14       # 0: up to label5
.LBB2_12:                               # %for.end8
	end_loop
	end_block                       # label4:
	i64.const	$push15=, 0
	i64.store	0($5), $pop15
	i32.sub 	$push16=, $5, $2
	i32.const	$push17=, 3
	i32.shr_s	$push18=, $pop16, $pop17
                                        # fallthrough-return: $pop18
	.endfunc
.Lfunc_end2:
	.size	plist, .Lfunc_end2-plist
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i64, i32, i64, i64, i32, i32
# %bb.0:                                # %for.body.lr.ph.i
	i32.const	$push28=, 0
	i32.load	$push27=, __stack_pointer($pop28)
	i32.const	$push29=, 80
	i32.sub 	$8=, $pop27, $pop29
	i32.const	$push30=, 0
	i32.store	__stack_pointer($pop30), $8
	i64.const	$5=, 1234111111
	copy_local	$4=, $8
.LBB3_1:                                # %for.body.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_2 Depth 2
                                        #     Child Loop BB3_4 Depth 2
                                        #     Child Loop BB3_7 Depth 2
	loop    	                # label11:
	copy_local	$6=, $5
	i64.const	$3=, 0
.LBB3_2:                                # %for.cond.i.i
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label12:
	i64.const	$push33=, 1
	i64.add 	$3=, $3, $pop33
	i64.const	$push32=, 1
	i64.shr_u	$6=, $6, $pop32
	i64.const	$push31=, 0
	i64.ne  	$push0=, $6, $pop31
	br_if   	0, $pop0        # 0: up to label12
# %bb.3:                                # %for.end.i.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_loop
	i64.const	$push38=, 1
	i64.const	$push37=, 1
	i64.shr_u	$push3=, $3, $pop37
	i64.shl 	$6=, $pop38, $pop3
	i64.const	$push36=, 0
	i64.const	$push35=, 1
	i64.and 	$push1=, $3, $pop35
	i64.sub 	$push2=, $pop36, $pop1
	i64.const	$push34=, 1
	i64.shr_u	$push4=, $6, $pop34
	i64.and 	$push5=, $pop2, $pop4
	i64.add 	$6=, $pop5, $6
.LBB3_4:                                # %do.body.i.i
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label13:
	i64.div_u	$3=, $5, $6
	i64.add 	$push6=, $3, $6
	i64.const	$push39=, 1
	i64.shr_u	$6=, $pop6, $pop39
	i64.lt_u	$push7=, $3, $6
	br_if   	0, $pop7        # 0: up to label13
# %bb.5:                                # %sqrtllu.exit.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_loop
	i32.wrap/i64	$2=, $6
	block   	
	block   	
	i32.const	$push40=, 3
	i32.lt_u	$push8=, $2, $pop40
	br_if   	0, $pop8        # 0: down to label15
# %bb.6:                                # %for.body3.i.preheader
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$7=, 3
.LBB3_7:                                # %for.body3.i
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label16:
	i64.extend_u/i32	$push9=, $7
	i64.rem_u	$push10=, $5, $pop9
	i64.eqz 	$push11=, $pop10
	br_if   	2, $pop11       # 2: down to label14
# %bb.8:                                # %for.cond1.i
                                        #   in Loop: Header=BB3_7 Depth=2
	i32.const	$push41=, 2
	i32.add 	$7=, $7, $pop41
	i32.le_u	$push12=, $7, $2
	br_if   	0, $pop12       # 0: up to label16
.LBB3_9:                                # %for.end.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_loop
	end_block                       # label15:
	i64.store	0($4), $5
	i32.const	$push42=, 8
	i32.add 	$4=, $4, $pop42
.LBB3_10:                               # %for.inc6.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_block                       # label14:
	i64.const	$push44=, 2
	i64.add 	$5=, $5, $pop44
	i64.const	$push43=, 1234111128
	i64.lt_u	$push13=, $5, $pop43
	br_if   	0, $pop13       # 0: up to label11
# %bb.11:                               # %plist.exit
	end_loop
	i64.const	$push14=, 0
	i64.store	0($4), $pop14
	block   	
	i64.load	$push16=, 0($8)
	i64.const	$push15=, 1234111117
	i64.ne  	$push17=, $pop16, $pop15
	br_if   	0, $pop17       # 0: down to label17
# %bb.12:                               # %lor.lhs.false
	i64.load	$push19=, 8($8)
	i64.const	$push18=, 1234111121
	i64.ne  	$push20=, $pop19, $pop18
	br_if   	0, $pop20       # 0: down to label17
# %bb.13:                               # %lor.lhs.false5
	i64.load	$push22=, 16($8)
	i64.const	$push21=, 1234111127
	i64.ne  	$push23=, $pop22, $pop21
	br_if   	0, $pop23       # 0: down to label17
# %bb.14:                               # %lor.lhs.false8
	i64.load	$push24=, 24($8)
	i64.eqz 	$push25=, $pop24
	i32.eqz 	$push45=, $pop25
	br_if   	0, $pop45       # 0: down to label17
# %bb.15:                               # %if.end
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
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
