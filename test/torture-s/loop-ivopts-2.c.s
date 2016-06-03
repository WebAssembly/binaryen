	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-ivopts-2.c"
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
	loop                            # label1:
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
	br_if   	2, $pop7        # 2: down to label0
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
	end_loop                        # label2:
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push45=, 0
	i32.const	$push42=, 0
	i32.load	$push43=, __stack_pointer($pop42)
	i32.const	$push44=, 1152
	i32.sub 	$push49=, $pop43, $pop44
	i32.store	$2=, __stack_pointer($pop45), $pop49
	i32.const	$4=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.add 	$push24=, $2, $4
	i32.const	$push54=, 8
	i32.store	$drop=, 0($pop24), $pop54
	i32.const	$push53=, 4
	i32.add 	$push52=, $4, $pop53
	tee_local	$push51=, $4=, $pop52
	i32.const	$push50=, 576
	i32.ne  	$push25=, $pop51, $pop50
	br_if   	0, $pop25       # 0: up to label3
# BB#2:                                 # %for.body3.preheader
	end_loop                        # label4:
	i32.const	$push26=, 576
	i32.add 	$3=, $2, $pop26
	i32.const	$4=, 0
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label5:
	i32.add 	$push27=, $3, $4
	i32.const	$push59=, 9
	i32.store	$drop=, 0($pop27), $pop59
	i32.const	$push58=, 4
	i32.add 	$push57=, $4, $pop58
	tee_local	$push56=, $4=, $pop57
	i32.const	$push55=, 448
	i32.ne  	$push28=, $pop56, $pop55
	br_if   	0, $pop28       # 0: up to label5
# BB#4:                                 # %for.body17
	end_loop                        # label6:
	i64.const	$push29=, 30064771079
	i64.store	$push0=, 1024($2), $pop29
	i64.store	$push1=, 1032($2), $pop0
	i64.store	$push2=, 1040($2), $pop1
	i64.store	$push3=, 1048($2), $pop2
	i64.store	$drop=, 1056($2), $pop3
	i32.const	$push30=, 7
	i32.store	$push4=, 1064($2), $pop30
	i32.store	$push5=, 1068($2), $pop4
	i32.store	$push6=, 1072($2), $pop5
	i32.store	$push7=, 1076($2), $pop6
	i32.store	$push8=, 1080($2), $pop7
	i32.store	$push9=, 1084($2), $pop8
	i32.store	$push10=, 1088($2), $pop9
	i32.store	$push11=, 1092($2), $pop10
	i32.store	$push12=, 1096($2), $pop11
	i32.store	$push13=, 1100($2), $pop12
	i32.store	$push14=, 1104($2), $pop13
	i32.store	$push15=, 1108($2), $pop14
	i32.store	$push16=, 1112($2), $pop15
	i32.store	$0=, 1116($2), $pop16
	i32.const	$push31=, 8
	i32.store	$push17=, 1120($2), $pop31
	i32.store	$push18=, 1124($2), $pop17
	i32.store	$push19=, 1128($2), $pop18
	i32.store	$push20=, 1132($2), $pop19
	i32.store	$push21=, 1136($2), $pop20
	i32.store	$push22=, 1140($2), $pop21
	i32.store	$push23=, 1144($2), $pop22
	i32.store	$1=, 1148($2), $pop23
	i32.const	$4=, 0
	copy_local	$3=, $2
.LBB1_5:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label8:
	i32.load	$push38=, 0($3)
	i32.const	$push63=, -256
	i32.add 	$push32=, $4, $pop63
	i32.const	$push62=, 23
	i32.gt_u	$push33=, $pop32, $pop62
	i32.select	$push34=, $1, $0, $pop33
	i32.const	$push61=, -144
	i32.add 	$push35=, $4, $pop61
	i32.const	$push60=, 112
	i32.lt_u	$push36=, $pop35, $pop60
	i32.add 	$push37=, $pop34, $pop36
	i32.ne  	$push39=, $pop38, $pop37
	br_if   	2, $pop39       # 2: down to label7
# BB#6:                                 # %for.cond.i
                                        #   in Loop: Header=BB1_5 Depth=1
	i32.const	$push68=, 4
	i32.add 	$3=, $3, $pop68
	i32.const	$push67=, 1
	i32.add 	$push66=, $4, $pop67
	tee_local	$push65=, $4=, $pop66
	i32.const	$push64=, 287
	i32.le_s	$push40=, $pop65, $pop64
	br_if   	0, $pop40       # 0: up to label8
# BB#7:                                 # %check.exit
	end_loop                        # label9:
	i32.const	$push48=, 0
	i32.const	$push46=, 1152
	i32.add 	$push47=, $2, $pop46
	i32.store	$drop=, __stack_pointer($pop48), $pop47
	i32.const	$push41=, 0
	return  	$pop41
.LBB1_8:                                # %if.then.i
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
