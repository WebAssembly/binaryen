	.text
	.file	"loop-ivopts-2.c"
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$1=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.load	$push6=, 0($0)
	i32.const	$push14=, 8
	i32.const	$push13=, 7
	i32.const	$push12=, -256
	i32.add 	$push0=, $1, $pop12
	i32.const	$push11=, 23
	i32.gt_u	$push1=, $pop0, $pop11
	i32.select	$push2=, $pop14, $pop13, $pop1
	i32.const	$push10=, -144
	i32.add 	$push3=, $1, $pop10
	i32.const	$push9=, 112
	i32.lt_u	$push4=, $pop3, $pop9
	i32.add 	$push5=, $pop2, $pop4
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	1, $pop7        # 1: down to label0
# %bb.2:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push17=, 1
	i32.add 	$1=, $1, $pop17
	i32.const	$push16=, 4
	i32.add 	$0=, $0, $pop16
	i32.const	$push15=, 287
	i32.le_u	$push8=, $1, $pop15
	br_if   	0, $pop8        # 0: up to label1
# %bb.3:                                # %for.end
	end_loop
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push18=, 0
	i32.load	$push17=, __stack_pointer($pop18)
	i32.const	$push19=, 1152
	i32.sub 	$2=, $pop17, $pop19
	i32.const	$push20=, 0
	i32.store	__stack_pointer($pop20), $2
	i32.const	$1=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.add 	$push0=, $2, $1
	i32.const	$push26=, 8
	i32.store	0($pop0), $pop26
	i32.const	$push25=, 4
	i32.add 	$1=, $1, $pop25
	i32.const	$push24=, 576
	i32.ne  	$push1=, $1, $pop24
	br_if   	0, $pop1        # 0: up to label2
# %bb.2:                                # %for.body3.preheader
	end_loop
	i32.const	$push2=, 576
	i32.add 	$0=, $2, $pop2
	i32.const	$1=, 0
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.add 	$push3=, $0, $1
	i32.const	$push29=, 9
	i32.store	0($pop3), $pop29
	i32.const	$push28=, 4
	i32.add 	$1=, $1, $pop28
	i32.const	$push27=, 448
	i32.ne  	$push4=, $1, $pop27
	br_if   	0, $pop4        # 0: up to label3
# %bb.4:                                # %for.body10
	end_loop
	i64.const	$push5=, 30064771079
	i64.store	1024($2), $pop5
	i64.const	$push43=, 30064771079
	i64.store	1032($2), $pop43
	i64.const	$push42=, 30064771079
	i64.store	1040($2), $pop42
	i64.const	$push41=, 30064771079
	i64.store	1048($2), $pop41
	i64.const	$push40=, 30064771079
	i64.store	1056($2), $pop40
	i64.const	$push39=, 30064771079
	i64.store	1064($2), $pop39
	i64.const	$push38=, 30064771079
	i64.store	1072($2), $pop38
	i64.const	$push37=, 30064771079
	i64.store	1080($2), $pop37
	i64.const	$push36=, 30064771079
	i64.store	1088($2), $pop36
	i64.const	$push35=, 30064771079
	i64.store	1096($2), $pop35
	i64.const	$push34=, 30064771079
	i64.store	1104($2), $pop34
	i64.const	$push33=, 30064771079
	i64.store	1112($2), $pop33
	i64.const	$push6=, 34359738376
	i64.store	1120($2), $pop6
	i64.const	$push32=, 34359738376
	i64.store	1128($2), $pop32
	i64.const	$push31=, 34359738376
	i64.store	1136($2), $pop31
	i64.const	$push30=, 34359738376
	i64.store	1144($2), $pop30
	i32.const	$1=, 0
	copy_local	$0=, $2
.LBB1_5:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label5:
	i32.load	$push13=, 0($0)
	i32.const	$push49=, 8
	i32.const	$push48=, 7
	i32.const	$push47=, -256
	i32.add 	$push7=, $1, $pop47
	i32.const	$push46=, 23
	i32.gt_u	$push8=, $pop7, $pop46
	i32.select	$push9=, $pop49, $pop48, $pop8
	i32.const	$push45=, -144
	i32.add 	$push10=, $1, $pop45
	i32.const	$push44=, 112
	i32.lt_u	$push11=, $pop10, $pop44
	i32.add 	$push12=, $pop9, $pop11
	i32.ne  	$push14=, $pop13, $pop12
	br_if   	1, $pop14       # 1: down to label4
# %bb.6:                                # %for.cond.i
                                        #   in Loop: Header=BB1_5 Depth=1
	i32.const	$push52=, 1
	i32.add 	$1=, $1, $pop52
	i32.const	$push51=, 4
	i32.add 	$0=, $0, $pop51
	i32.const	$push50=, 287
	i32.le_u	$push15=, $1, $pop50
	br_if   	0, $pop15       # 0: up to label5
# %bb.7:                                # %check.exit
	end_loop
	i32.const	$push23=, 0
	i32.const	$push21=, 1152
	i32.add 	$push22=, $2, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	i32.const	$push16=, 0
	return  	$pop16
.LBB1_8:                                # %if.then.i
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
