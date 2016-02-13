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
	i32.const	$push54=, 0
	i32.load	$0=, a+4($pop54)
	i32.const	$push53=, 0
	i32.load	$1=, a($pop53):p2align=4
	i32.const	$push52=, 0
	i32.load	$2=, a+12($pop52)
	i32.const	$push51=, 0
	i32.load	$3=, a+8($pop51):p2align=3
	i32.const	$push50=, 0
	i32.load	$4=, a+20($pop50)
	i32.const	$push49=, 0
	i32.load	$5=, a+16($pop49):p2align=4
.LBB1_1:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label3:
	i32.const	$push58=, 3
	i32.shl 	$push6=, $6, $pop58
	tee_local	$push57=, $8=, $pop6
	i32.const	$push56=, a+4
	i32.add 	$7=, $pop57, $pop56
	i32.const	$push55=, a
	i32.add 	$8=, $8, $pop55
	block
	block
	block
	block
	i32.const	$push72=, 0
	i32.eq  	$push73=, $6, $pop72
	br_if   	0, $pop73       # 0: down to label8
# BB#2:                                 # %if.end14
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push59=, 1
	i32.lt_s	$push7=, $6, $pop59
	br_if   	1, $pop7        # 1: down to label7
# BB#3:                                 # %land.lhs.true16
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	block
	i32.load	$push0=, 0($7)
	tee_local	$push60=, $9=, $pop0
	i32.gt_s	$push8=, $pop60, $0
	br_if   	0, $pop8        # 0: down to label10
# BB#4:                                 # %if.end.i45
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push9=, $9, $0
	br_if   	1, $pop9        # 1: down to label9
# BB#5:                                 # %if.end6.i49
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push10=, 0($8):p2align=3
	i32.le_u	$push11=, $pop10, $1
	br_if   	1, $pop11       # 1: down to label9
.LBB1_6:                                # %if.end.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label10:
	block
	i32.const	$push62=, 1
	i32.ne  	$push12=, $6, $pop62
	br_if   	0, $pop12       # 0: down to label11
# BB#7:                                 # %land.lhs.true8.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push31=, 0($7)
	i32.ne  	$push32=, $pop31, $2
	br_if   	9, $pop32       # 9: down to label1
# BB#8:                                 # %if.end6.i63.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push33=, 0($8):p2align=3
	i32.eq  	$push34=, $pop33, $3
	br_if   	4, $pop34       # 4: down to label6
	br      	9               # 9: down to label1
.LBB1_9:                                # %if.end14.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label11:
	i32.const	$push63=, 2
	i32.lt_s	$push13=, $6, $pop63
	br_if   	3, $pop13       # 3: down to label6
# BB#10:                                # %land.lhs.true16.1
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	i32.load	$push2=, 0($7)
	tee_local	$push64=, $9=, $pop2
	i32.gt_s	$push14=, $pop64, $2
	br_if   	0, $pop14       # 0: down to label12
# BB#11:                                # %if.end.i45.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push15=, $9, $2
	br_if   	1, $pop15       # 1: down to label9
# BB#12:                                # %if.end6.i49.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push16=, 0($8):p2align=3
	i32.le_u	$push17=, $pop16, $3
	br_if   	1, $pop17       # 1: down to label9
.LBB1_13:                               # %if.end.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label12:
	block
	i32.const	$push66=, 2
	i32.ne  	$push18=, $6, $pop66
	br_if   	0, $pop18       # 0: down to label13
# BB#14:                                # %land.lhs.true8.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push27=, 0($7)
	i32.ne  	$push28=, $pop27, $4
	br_if   	9, $pop28       # 9: down to label1
# BB#15:                                # %if.end6.i63.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$6=, 3
	i32.load	$push29=, 0($8):p2align=3
	i32.eq  	$push30=, $pop29, $5
	br_if   	6, $pop30       # 6: up to label3
	br      	9               # 9: down to label1
.LBB1_16:                               # %if.end14.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label13:
	i32.const	$push67=, 3
	i32.lt_s	$push19=, $6, $pop67
	br_if   	4, $pop19       # 4: down to label5
# BB#17:                                # %land.lhs.true16.2
	i32.load	$push4=, 0($7)
	tee_local	$push69=, $6=, $pop4
	i32.const	$push20=, 0
	i32.load	$push5=, a+20($pop20)
	tee_local	$push68=, $7=, $pop5
	i32.gt_s	$push21=, $pop69, $pop68
	br_if   	6, $pop21       # 6: down to label4
# BB#18:                                # %if.end.i45.2
	i32.lt_s	$push22=, $6, $7
	br_if   	0, $pop22       # 0: down to label9
# BB#19:                                # %if.end6.i49.2
	i32.load	$push23=, 0($8):p2align=3
	i32.const	$push24=, 0
	i32.load	$push25=, a+16($pop24):p2align=4
	i32.gt_u	$push26=, $pop23, $pop25
	br_if   	6, $pop26       # 6: down to label4
.LBB1_20:                               # %if.then21
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_21:                               # %land.lhs.true8
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.load	$push35=, 0($7)
	i32.ne  	$push36=, $pop35, $0
	br_if   	6, $pop36       # 6: down to label1
# BB#22:                                # %if.end6.i63
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push37=, 0($8):p2align=3
	i32.ne  	$push38=, $pop37, $1
	br_if   	6, $pop38       # 6: down to label1
.LBB1_23:                               # %land.lhs.true.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.load	$push1=, 0($7)
	tee_local	$push61=, $9=, $pop1
	i32.gt_s	$push39=, $pop61, $2
	br_if   	4, $pop39       # 4: down to label2
# BB#24:                                # %if.end.i.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push40=, $9, $2
	br_if   	0, $pop40       # 0: down to label6
# BB#25:                                # %if.end6.i.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push41=, 0($8):p2align=3
	i32.ge_u	$push42=, $pop41, $3
	br_if   	4, $pop42       # 4: down to label2
.LBB1_26:                               # %land.lhs.true.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.load	$push3=, 0($7)
	tee_local	$push65=, $7=, $pop3
	i32.gt_s	$push43=, $pop65, $4
	br_if   	3, $pop43       # 3: down to label2
# BB#27:                                # %if.end.i.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push44=, $7, $4
	br_if   	0, $pop44       # 0: down to label5
# BB#28:                                # %if.end6.i.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push45=, 0($8):p2align=3
	i32.ge_u	$push46=, $pop45, $5
	br_if   	3, $pop46       # 3: down to label2
.LBB1_29:                               # %for.inc.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.const	$push71=, 1
	i32.add 	$6=, $6, $pop71
	i32.const	$push70=, 4
	i32.lt_s	$push47=, $6, $pop70
	br_if   	0, $pop47       # 0: up to label3
.LBB1_30:                               # %for.end25
	end_loop                        # label4:
	i32.const	$push48=, 0
	return  	$pop48
.LBB1_31:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_32:                               # %if.then13
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
