	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-ivopts-2.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
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
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push19=, 4
	i32.add 	$0=, $0, $pop19
	i32.const	$push18=, 1
	i32.add 	$push17=, $1, $pop18
	tee_local	$push16=, $1=, $pop17
	i32.const	$push15=, 287
	i32.le_s	$push8=, $pop16, $pop15
	br_if   	0, $pop8        # 0: up to label1
# BB#3:                                 # %for.end
	end_loop
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.const	$push16=, 0
	i32.load	$push17=, __stack_pointer($pop16)
	i32.const	$push18=, 1152
	i32.sub 	$push24=, $pop17, $pop18
	tee_local	$push23=, $2=, $pop24
	i32.store	__stack_pointer($pop19), $pop23
	i32.const	$1=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.add 	$push0=, $2, $1
	i32.const	$push29=, 8
	i32.store	0($pop0), $pop29
	i32.const	$push28=, 4
	i32.add 	$push27=, $1, $pop28
	tee_local	$push26=, $1=, $pop27
	i32.const	$push25=, 576
	i32.ne  	$push1=, $pop26, $pop25
	br_if   	0, $pop1        # 0: up to label2
# BB#2:                                 # %for.body3.preheader
	end_loop
	i32.const	$push2=, 576
	i32.add 	$0=, $2, $pop2
	i32.const	$1=, 0
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.add 	$push3=, $0, $1
	i32.const	$push34=, 9
	i32.store	0($pop3), $pop34
	i32.const	$push33=, 4
	i32.add 	$push32=, $1, $pop33
	tee_local	$push31=, $1=, $pop32
	i32.const	$push30=, 448
	i32.ne  	$push4=, $pop31, $pop30
	br_if   	0, $pop4        # 0: up to label3
# BB#4:                                 # %for.body17
	end_loop
	i64.const	$push5=, 30064771079
	i64.store	1024($2), $pop5
	i64.const	$push60=, 30064771079
	i64.store	1032($2), $pop60
	i64.const	$push59=, 30064771079
	i64.store	1040($2), $pop59
	i64.const	$push58=, 30064771079
	i64.store	1048($2), $pop58
	i64.const	$push57=, 30064771079
	i64.store	1056($2), $pop57
	i32.const	$push56=, 7
	i32.store	1064($2), $pop56
	i32.const	$push55=, 7
	i32.store	1068($2), $pop55
	i32.const	$push54=, 7
	i32.store	1072($2), $pop54
	i32.const	$push53=, 7
	i32.store	1076($2), $pop53
	i32.const	$push52=, 7
	i32.store	1080($2), $pop52
	i32.const	$push51=, 7
	i32.store	1084($2), $pop51
	i32.const	$push50=, 7
	i32.store	1088($2), $pop50
	i32.const	$push49=, 7
	i32.store	1092($2), $pop49
	i32.const	$push48=, 7
	i32.store	1096($2), $pop48
	i32.const	$push47=, 7
	i32.store	1100($2), $pop47
	i32.const	$push46=, 7
	i32.store	1104($2), $pop46
	i32.const	$push45=, 7
	i32.store	1108($2), $pop45
	i32.const	$push44=, 7
	i32.store	1112($2), $pop44
	i32.const	$push43=, 7
	i32.store	1116($2), $pop43
	i32.const	$push42=, 8
	i32.store	1120($2), $pop42
	i32.const	$push41=, 8
	i32.store	1124($2), $pop41
	i32.const	$push40=, 8
	i32.store	1128($2), $pop40
	i32.const	$push39=, 8
	i32.store	1132($2), $pop39
	i32.const	$push38=, 8
	i32.store	1136($2), $pop38
	i32.const	$push37=, 8
	i32.store	1140($2), $pop37
	i32.const	$push36=, 8
	i32.store	1144($2), $pop36
	i32.const	$push35=, 8
	i32.store	1148($2), $pop35
	i32.const	$1=, 0
	copy_local	$0=, $2
.LBB1_5:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label5:
	i32.load	$push12=, 0($0)
	i32.const	$push66=, 8
	i32.const	$push65=, 7
	i32.const	$push64=, -256
	i32.add 	$push6=, $1, $pop64
	i32.const	$push63=, 23
	i32.gt_u	$push7=, $pop6, $pop63
	i32.select	$push8=, $pop66, $pop65, $pop7
	i32.const	$push62=, -144
	i32.add 	$push9=, $1, $pop62
	i32.const	$push61=, 112
	i32.lt_u	$push10=, $pop9, $pop61
	i32.add 	$push11=, $pop8, $pop10
	i32.ne  	$push13=, $pop12, $pop11
	br_if   	1, $pop13       # 1: down to label4
# BB#6:                                 # %for.cond.i
                                        #   in Loop: Header=BB1_5 Depth=1
	i32.const	$push71=, 4
	i32.add 	$0=, $0, $pop71
	i32.const	$push70=, 1
	i32.add 	$push69=, $1, $pop70
	tee_local	$push68=, $1=, $pop69
	i32.const	$push67=, 287
	i32.le_s	$push14=, $pop68, $pop67
	br_if   	0, $pop14       # 0: up to label5
# BB#7:                                 # %check.exit
	end_loop
	i32.const	$push22=, 0
	i32.const	$push20=, 1152
	i32.add 	$push21=, $2, $pop20
	i32.store	__stack_pointer($pop22), $pop21
	i32.const	$push15=, 0
	return  	$pop15
.LBB1_8:                                # %if.then.i
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
