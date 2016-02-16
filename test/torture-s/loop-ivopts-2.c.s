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
	i32.load	$push0=, 0($0)
	i32.const	$push17=, 8
	i32.const	$push16=, 7
	i32.const	$push15=, -256
	i32.add 	$push1=, $1, $pop15
	i32.const	$push14=, 23
	i32.gt_u	$push2=, $pop1, $pop14
	i32.select	$push3=, $pop17, $pop16, $pop2
	i32.const	$push13=, -144
	i32.add 	$push4=, $1, $pop13
	i32.const	$push12=, 112
	i32.lt_u	$push5=, $pop4, $pop12
	i32.add 	$push6=, $pop3, $pop5
	i32.ne  	$push7=, $pop0, $pop6
	br_if   	2, $pop7        # 2: down to label0
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push11=, 1
	i32.add 	$1=, $1, $pop11
	i32.const	$push10=, 4
	i32.add 	$0=, $0, $pop10
	i32.const	$push9=, 287
	i32.le_s	$push8=, $1, $pop9
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 1152
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.const	$3=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.add 	$push0=, $7, $3
	i32.const	$push44=, 8
	i32.store	$discard=, 0($pop0), $pop44
	i32.const	$push43=, 4
	i32.add 	$3=, $3, $pop43
	i32.const	$push42=, 576
	i32.ne  	$push1=, $3, $pop42
	br_if   	0, $pop1        # 0: up to label3
# BB#2:                                 # %for.body3.preheader
	end_loop                        # label4:
	i32.const	$push2=, 576
	i32.add 	$2=, $7, $pop2
	i32.const	$3=, 0
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label5:
	i32.add 	$push3=, $2, $3
	i32.const	$push47=, 9
	i32.store	$discard=, 0($pop3), $pop47
	i32.const	$push46=, 4
	i32.add 	$3=, $3, $pop46
	i32.const	$push45=, 448
	i32.ne  	$push4=, $3, $pop45
	br_if   	0, $pop4        # 0: up to label5
# BB#4:                                 # %for.body.i.preheader
	end_loop                        # label6:
	i64.const	$push5=, 30064771079
	i64.store	$push6=, 1024($7):p2align=4, $pop5
	i64.store	$push7=, 1032($7), $pop6
	i64.store	$push8=, 1040($7):p2align=4, $pop7
	i64.store	$push9=, 1048($7), $pop8
	i64.store	$discard=, 1056($7):p2align=4, $pop9
	i32.const	$push10=, 7
	i32.store	$push11=, 1064($7):p2align=3, $pop10
	i32.store	$push12=, 1068($7), $pop11
	i32.store	$push13=, 1072($7):p2align=4, $pop12
	i32.store	$push14=, 1076($7), $pop13
	i32.store	$push15=, 1080($7):p2align=3, $pop14
	i32.store	$push16=, 1084($7), $pop15
	i32.store	$push17=, 1088($7):p2align=4, $pop16
	i32.store	$push18=, 1092($7), $pop17
	i32.store	$push19=, 1096($7):p2align=3, $pop18
	i32.store	$push20=, 1100($7), $pop19
	i32.store	$push21=, 1104($7):p2align=4, $pop20
	i32.store	$push22=, 1108($7), $pop21
	i32.store	$push23=, 1112($7):p2align=3, $pop22
	i32.store	$0=, 1116($7), $pop23
	i32.const	$push24=, 8
	i32.store	$push25=, 1120($7):p2align=4, $pop24
	i32.store	$push26=, 1124($7), $pop25
	i32.store	$push27=, 1128($7):p2align=3, $pop26
	i32.store	$push28=, 1132($7), $pop27
	i32.store	$push29=, 1136($7):p2align=4, $pop28
	i32.store	$push30=, 1140($7), $pop29
	i32.store	$push31=, 1144($7):p2align=3, $pop30
	i32.store	$1=, 1148($7), $pop31
	i32.const	$3=, 0
	copy_local	$2=, $7
.LBB1_5:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label8:
	i32.load	$push32=, 0($2)
	i32.const	$push54=, -256
	i32.add 	$push33=, $3, $pop54
	i32.const	$push53=, 23
	i32.gt_u	$push34=, $pop33, $pop53
	i32.select	$push35=, $1, $0, $pop34
	i32.const	$push52=, -144
	i32.add 	$push36=, $3, $pop52
	i32.const	$push51=, 112
	i32.lt_u	$push37=, $pop36, $pop51
	i32.add 	$push38=, $pop35, $pop37
	i32.ne  	$push39=, $pop32, $pop38
	br_if   	2, $pop39       # 2: down to label7
# BB#6:                                 # %for.cond.i
                                        #   in Loop: Header=BB1_5 Depth=1
	i32.const	$push50=, 1
	i32.add 	$3=, $3, $pop50
	i32.const	$push49=, 4
	i32.add 	$2=, $2, $pop49
	i32.const	$push48=, 287
	i32.le_s	$push40=, $3, $pop48
	br_if   	0, $pop40       # 0: up to label8
# BB#7:                                 # %check.exit
	end_loop                        # label9:
	i32.const	$push41=, 0
	i32.const	$6=, 1152
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return  	$pop41
.LBB1_8:                                # %if.then.i
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
