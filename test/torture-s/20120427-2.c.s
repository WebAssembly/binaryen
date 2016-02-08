	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120427-2.c"
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
	i32.load	$push0=, 4($0)
	tee_local	$push11=, $4=, $pop0
	i32.load	$push1=, 4($1)
	tee_local	$push10=, $3=, $pop1
	i32.gt_s	$push4=, $pop11, $pop10
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$2=, -1
	i32.lt_s	$push5=, $4, $3
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$2=, 1
	i32.load	$push2=, 0($0)
	tee_local	$push13=, $0=, $pop2
	i32.load	$push3=, 0($1)
	tee_local	$push12=, $1=, $pop3
	i32.gt_u	$push6=, $pop13, $pop12
	br_if   	0, $pop6        # 0: down to label0
# BB#3:                                 # %if.end10
	i32.const	$push9=, -1
	i32.const	$push8=, 0
	i32.lt_u	$push7=, $0, $1
	i32.select	$2=, $pop9, $pop8, $pop7
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
	i32.const	$push60=, 0
	i32.load	$0=, a+4($pop60)
	i32.const	$push59=, 0
	i32.load	$1=, a($pop59):p2align=4
	i32.const	$push58=, 0
	i32.load	$2=, a+12($pop58)
	i32.const	$push57=, 0
	i32.load	$3=, a+8($pop57):p2align=3
	i32.const	$push56=, 0
	i32.load	$4=, a+20($pop56)
	i32.const	$push55=, 0
	i32.load	$5=, a+16($pop55):p2align=4
.LBB1_1:                                # %for.cond1.preheader
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label2:
	i32.const	$push65=, 3
	i32.shl 	$push7=, $6, $pop65
	tee_local	$push64=, $8=, $pop7
	i32.const	$push63=, a+4
	i32.add 	$7=, $pop64, $pop63
	i32.const	$push62=, a
	i32.add 	$8=, $8, $pop62
	block
	block
	block
	block
	i32.const	$push61=, -1
	i32.le_s	$push8=, $6, $pop61
	br_if   	0, $pop8        # 0: down to label7
# BB#2:                                 # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	block
	i32.const	$push80=, 0
	i32.eq  	$push81=, $6, $pop80
	br_if   	0, $pop81       # 0: down to label9
# BB#3:                                 # %if.end14
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push67=, 1
	i32.lt_s	$push9=, $6, $pop67
	br_if   	3, $pop9        # 3: down to label6
# BB#4:                                 # %land.lhs.true16
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	block
	i32.load	$push1=, 0($7)
	tee_local	$push68=, $9=, $pop1
	i32.gt_s	$push10=, $pop68, $0
	br_if   	0, $pop10       # 0: down to label11
# BB#5:                                 # %if.end.i45
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push11=, $9, $0
	br_if   	1, $pop11       # 1: down to label10
# BB#6:                                 # %if.end6.i49
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push12=, 0($8):p2align=3
	i32.le_u	$push13=, $pop12, $1
	br_if   	1, $pop13       # 1: down to label10
.LBB1_7:                                # %if.end.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label11:
	block
	i32.const	$push70=, 1
	i32.ne  	$push14=, $6, $pop70
	br_if   	0, $pop14       # 0: down to label12
# BB#8:                                 # %land.lhs.true8.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push33=, 0($7)
	i32.ne  	$push34=, $pop33, $2
	br_if   	3, $pop34       # 3: down to label8
# BB#9:                                 # %if.end6.i63.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push35=, 0($8):p2align=3
	i32.eq  	$push36=, $pop35, $3
	br_if   	6, $pop36       # 6: down to label5
	br      	3               # 3: down to label8
.LBB1_10:                               # %if.end14.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label12:
	i32.const	$push71=, 2
	i32.lt_s	$push15=, $6, $pop71
	br_if   	5, $pop15       # 5: down to label5
# BB#11:                                # %land.lhs.true16.1
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	i32.load	$push3=, 0($7)
	tee_local	$push72=, $9=, $pop3
	i32.gt_s	$push16=, $pop72, $2
	br_if   	0, $pop16       # 0: down to label13
# BB#12:                                # %if.end.i45.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push17=, $9, $2
	br_if   	1, $pop17       # 1: down to label10
# BB#13:                                # %if.end6.i49.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push18=, 0($8):p2align=3
	i32.le_u	$push19=, $pop18, $3
	br_if   	1, $pop19       # 1: down to label10
.LBB1_14:                               # %if.end.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label13:
	block
	i32.const	$push74=, 2
	i32.ne  	$push20=, $6, $pop74
	br_if   	0, $pop20       # 0: down to label14
# BB#15:                                # %land.lhs.true8.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push29=, 0($7)
	i32.ne  	$push30=, $pop29, $4
	br_if   	3, $pop30       # 3: down to label8
# BB#16:                                # %if.end6.i63.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$6=, 3
	i32.load	$push31=, 0($8):p2align=3
	i32.eq  	$push32=, $pop31, $5
	br_if   	8, $pop32       # 8: up to label2
	br      	3               # 3: down to label8
.LBB1_17:                               # %if.end14.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label14:
	i32.const	$push75=, 3
	i32.lt_s	$push21=, $6, $pop75
	br_if   	6, $pop21       # 6: down to label4
# BB#18:                                # %land.lhs.true16.2
	i32.load	$push5=, 0($7)
	tee_local	$push77=, $6=, $pop5
	i32.const	$push22=, 0
	i32.load	$push6=, a+20($pop22)
	tee_local	$push76=, $7=, $pop6
	i32.gt_s	$push23=, $pop77, $pop76
	br_if   	8, $pop23       # 8: down to label3
# BB#19:                                # %if.end.i45.2
	i32.lt_s	$push24=, $6, $7
	br_if   	0, $pop24       # 0: down to label10
# BB#20:                                # %if.end6.i49.2
	i32.load	$push25=, 0($8):p2align=3
	i32.const	$push26=, 0
	i32.load	$push27=, a+16($pop26):p2align=4
	i32.gt_u	$push28=, $pop25, $pop27
	br_if   	8, $pop28       # 8: down to label3
.LBB1_21:                               # %if.then21
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_22:                               # %land.lhs.true8
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.load	$push37=, 0($7)
	i32.ne  	$push38=, $pop37, $0
	br_if   	0, $pop38       # 0: down to label8
# BB#23:                                # %if.end6.i63
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push39=, 0($8):p2align=3
	i32.eq  	$push40=, $pop39, $1
	br_if   	2, $pop40       # 2: down to label6
.LBB1_24:                               # %if.then13
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_25:                               # %land.lhs.true
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.load	$push0=, 0($7)
	tee_local	$push66=, $9=, $pop0
	i32.gt_s	$push41=, $pop66, $0
	br_if   	5, $pop41       # 5: down to label1
# BB#26:                                # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push42=, $9, $0
	br_if   	0, $pop42       # 0: down to label6
# BB#27:                                # %if.end6.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push43=, 0($8):p2align=3
	i32.ge_u	$push44=, $pop43, $1
	br_if   	5, $pop44       # 5: down to label1
.LBB1_28:                               # %land.lhs.true.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.load	$push2=, 0($7)
	tee_local	$push69=, $9=, $pop2
	i32.gt_s	$push45=, $pop69, $2
	br_if   	4, $pop45       # 4: down to label1
# BB#29:                                # %if.end.i.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push46=, $9, $2
	br_if   	0, $pop46       # 0: down to label5
# BB#30:                                # %if.end6.i.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push47=, 0($8):p2align=3
	i32.ge_u	$push48=, $pop47, $3
	br_if   	4, $pop48       # 4: down to label1
.LBB1_31:                               # %land.lhs.true.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.load	$push4=, 0($7)
	tee_local	$push73=, $7=, $pop4
	i32.gt_s	$push49=, $pop73, $4
	br_if   	3, $pop49       # 3: down to label1
# BB#32:                                # %if.end.i.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push50=, $7, $4
	br_if   	0, $pop50       # 0: down to label4
# BB#33:                                # %if.end6.i.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push51=, 0($8):p2align=3
	i32.ge_u	$push52=, $pop51, $5
	br_if   	3, $pop52       # 3: down to label1
.LBB1_34:                               # %for.inc.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label4:
	i32.const	$push79=, 1
	i32.add 	$6=, $6, $pop79
	i32.const	$push78=, 4
	i32.lt_s	$push53=, $6, $pop78
	br_if   	0, $pop53       # 0: up to label2
.LBB1_35:                               # %for.end25
	end_loop                        # label3:
	i32.const	$push54=, 0
	return  	$pop54
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
