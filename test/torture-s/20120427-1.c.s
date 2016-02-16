	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120427-1.c"
	.section	.text.sreal_compare,"ax",@progbits
	.hidden	sreal_compare
	.globl	sreal_compare
	.type	sreal_compare,@function
sreal_compare:                          # @sreal_compare
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 1
	block
	i32.load	$push9=, 4($0)
	tee_local	$push8=, $4=, $pop9
	i32.load	$push7=, 4($1)
	tee_local	$push6=, $3=, $pop7
	i32.gt_s	$push0=, $pop8, $pop6
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$2=, -1
	i32.lt_s	$push1=, $4, $3
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$2=, 1
	i32.load	$push13=, 0($0)
	tee_local	$push12=, $0=, $pop13
	i32.load	$push11=, 0($1)
	tee_local	$push10=, $1=, $pop11
	i32.gt_u	$push2=, $pop12, $pop10
	br_if   	0, $pop2        # 0: down to label0
# BB#3:                                 # %if.end10
	i32.const	$push5=, -1
	i32.const	$push4=, 0
	i32.lt_u	$push3=, $0, $1
	i32.select	$2=, $pop5, $pop4, $pop3
.LBB0_4:                                # %return
	end_block                       # label0:
	return  	$2
	.endfunc
.Lfunc_end0:
	.size	sreal_compare, .Lfunc_end0-sreal_compare

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
	i32.const	$push52=, 0
	i32.load	$0=, a+4($pop52)
	i32.const	$push51=, 0
	i32.load	$1=, a($pop51):p2align=4
	i32.const	$push50=, 0
	i32.load	$2=, a+12($pop50)
	i32.const	$push49=, 0
	i32.load	$3=, a+8($pop49):p2align=3
	i32.const	$push48=, 0
	i32.load	$4=, a+20($pop48)
	i32.const	$push47=, 0
	i32.load	$5=, a+16($pop47):p2align=4
.LBB1_1:                                # %for.cond1.preheader
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label2:
	i32.const	$push58=, 3
	i32.shl 	$push57=, $6, $pop58
	tee_local	$push56=, $8=, $pop57
	i32.const	$push55=, a+4
	i32.add 	$7=, $pop56, $pop55
	i32.const	$push54=, a
	i32.add 	$8=, $8, $pop54
	block
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push53=, -1
	i32.le_s	$push0=, $6, $pop53
	br_if   	0, $pop0        # 0: down to label11
# BB#2:                                 # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push80=, 0
	i32.eq  	$push81=, $6, $pop80
	br_if   	1, $pop81       # 1: down to label10
# BB#3:                                 # %if.end14
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push61=, 1
	i32.lt_s	$push1=, $6, $pop61
	br_if   	2, $pop1        # 2: down to label9
# BB#4:                                 # %land.lhs.true16
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	i32.load	$push63=, 0($7)
	tee_local	$push62=, $9=, $pop63
	i32.gt_s	$push2=, $pop62, $0
	br_if   	0, $pop2        # 0: down to label12
# BB#5:                                 # %if.end.i45
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push3=, $9, $0
	br_if   	6, $pop3        # 6: down to label6
# BB#6:                                 # %if.end6.i49
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push4=, 0($8):p2align=3
	i32.le_u	$push5=, $pop4, $1
	br_if   	6, $pop5        # 6: down to label6
.LBB1_7:                                # %if.end.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label12:
	i32.const	$push66=, 1
	i32.ne  	$push6=, $6, $pop66
	br_if   	3, $pop6        # 3: down to label8
# BB#8:                                 # %land.lhs.true8.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push25=, 0($7)
	i32.ne  	$push26=, $pop25, $2
	br_if   	4, $pop26       # 4: down to label7
# BB#9:                                 # %if.end6.i63.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push27=, 0($8):p2align=3
	i32.eq  	$push28=, $pop27, $3
	br_if   	6, $pop28       # 6: down to label5
	br      	4               # 4: down to label7
.LBB1_10:                               # %land.lhs.true
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label11:
	i32.load	$push60=, 0($7)
	tee_local	$push59=, $9=, $pop60
	i32.gt_s	$push33=, $pop59, $0
	br_if   	9, $pop33       # 9: down to label1
# BB#11:                                # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push34=, $9, $0
	br_if   	1, $pop34       # 1: down to label9
# BB#12:                                # %if.end6.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push35=, 0($8):p2align=3
	i32.lt_u	$push36=, $pop35, $1
	br_if   	1, $pop36       # 1: down to label9
	br      	9               # 9: down to label1
.LBB1_13:                               # %land.lhs.true8
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label10:
	i32.load	$push29=, 0($7)
	i32.ne  	$push30=, $pop29, $0
	br_if   	2, $pop30       # 2: down to label7
# BB#14:                                # %if.end6.i63
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push31=, 0($8):p2align=3
	i32.ne  	$push32=, $pop31, $1
	br_if   	2, $pop32       # 2: down to label7
.LBB1_15:                               # %land.lhs.true.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.load	$push65=, 0($7)
	tee_local	$push64=, $9=, $pop65
	i32.gt_s	$push37=, $pop64, $2
	br_if   	7, $pop37       # 7: down to label1
# BB#16:                                # %if.end.i.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push38=, $9, $2
	br_if   	3, $pop38       # 3: down to label5
# BB#17:                                # %if.end6.i.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push39=, 0($8):p2align=3
	i32.ge_u	$push40=, $pop39, $3
	br_if   	7, $pop40       # 7: down to label1
	br      	3               # 3: down to label5
.LBB1_18:                               # %if.end14.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.const	$push67=, 2
	i32.lt_s	$push7=, $6, $pop67
	br_if   	2, $pop7        # 2: down to label5
# BB#19:                                # %land.lhs.true16.1
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	i32.load	$push69=, 0($7)
	tee_local	$push68=, $9=, $pop69
	i32.gt_s	$push8=, $pop68, $2
	br_if   	0, $pop8        # 0: down to label13
# BB#20:                                # %if.end.i45.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push9=, $9, $2
	br_if   	2, $pop9        # 2: down to label6
# BB#21:                                # %if.end6.i49.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push10=, 0($8):p2align=3
	i32.le_u	$push11=, $pop10, $3
	br_if   	2, $pop11       # 2: down to label6
.LBB1_22:                               # %if.end.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label13:
	block
	i32.const	$push72=, 2
	i32.ne  	$push12=, $6, $pop72
	br_if   	0, $pop12       # 0: down to label14
# BB#23:                                # %land.lhs.true8.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push21=, 0($7)
	i32.ne  	$push22=, $pop21, $4
	br_if   	1, $pop22       # 1: down to label7
# BB#24:                                # %if.end6.i63.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$6=, 3
	i32.load	$push23=, 0($8):p2align=3
	i32.eq  	$push24=, $pop23, $5
	br_if   	5, $pop24       # 5: up to label2
	br      	1               # 1: down to label7
.LBB1_25:                               # %if.end14.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label14:
	i32.const	$push73=, 3
	i32.lt_s	$push13=, $6, $pop73
	br_if   	3, $pop13       # 3: down to label4
# BB#26:                                # %land.lhs.true16.2
	i32.load	$push77=, 0($7)
	tee_local	$push76=, $6=, $pop77
	i32.const	$push14=, 0
	i32.load	$push75=, a+20($pop14)
	tee_local	$push74=, $7=, $pop75
	i32.gt_s	$push15=, $pop76, $pop74
	br_if   	5, $pop15       # 5: down to label3
# BB#27:                                # %if.end.i45.2
	i32.lt_s	$push16=, $6, $7
	br_if   	1, $pop16       # 1: down to label6
# BB#28:                                # %if.end6.i49.2
	i32.load	$push17=, 0($8):p2align=3
	i32.const	$push18=, 0
	i32.load	$push19=, a+16($pop18):p2align=4
	i32.le_u	$push20=, $pop17, $pop19
	br_if   	1, $pop20       # 1: down to label6
	br      	5               # 5: down to label3
.LBB1_29:                               # %if.then13
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_30:                               # %if.then21
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_31:                               # %land.lhs.true.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.load	$push71=, 0($7)
	tee_local	$push70=, $7=, $pop71
	i32.gt_s	$push41=, $pop70, $4
	br_if   	3, $pop41       # 3: down to label1
# BB#32:                                # %if.end.i.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push42=, $7, $4
	br_if   	0, $pop42       # 0: down to label4
# BB#33:                                # %if.end6.i.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push43=, 0($8):p2align=3
	i32.ge_u	$push44=, $pop43, $5
	br_if   	3, $pop44       # 3: down to label1
.LBB1_34:                               # %for.inc.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label4:
	i32.const	$push79=, 1
	i32.add 	$6=, $6, $pop79
	i32.const	$push78=, 4
	i32.lt_s	$push45=, $6, $pop78
	br_if   	0, $pop45       # 0: up to label2
.LBB1_35:                               # %for.end25
	end_loop                        # label3:
	i32.const	$push46=, 0
	return  	$pop46
.LBB1_36:                               # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	4
a:
	.skip	8
	.int32	1                       # 0x1
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.size	a, 32


	.ident	"clang version 3.9.0 "
