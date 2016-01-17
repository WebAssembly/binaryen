	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120427-2.c"
	.section	.text.sreal_compare,"ax",@progbits
	.hidden	sreal_compare
	.globl	sreal_compare
	.type	sreal_compare,@function
sreal_compare:                          # @sreal_compare
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$2=, 4($0)
	i32.load	$3=, 4($1)
	i32.const	$4=, 1
	copy_local	$5=, $4
	block
	i32.gt_s	$push0=, $2, $3
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$5=, -1
	i32.lt_s	$push1=, $2, $3
	br_if   	$pop1, 0        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.load	$2=, 0($0)
	i32.load	$3=, 0($1)
	copy_local	$5=, $4
	i32.gt_u	$push2=, $2, $3
	br_if   	$pop2, 0        # 0: down to label0
# BB#3:                                 # %if.end10
	i32.lt_u	$push3=, $2, $3
	i32.const	$push5=, -1
	i32.const	$push4=, 0
	i32.select	$5=, $pop3, $pop5, $pop4
.LBB0_4:                                # %return
	end_block                       # label0:
	return  	$5
	.endfunc
.Lfunc_end0:
	.size	sreal_compare, .Lfunc_end0-sreal_compare

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
	i32.load	$0=, a+4($6)
	i32.load	$1=, a($6)
	i32.load	$2=, a+12($6)
	i32.load	$3=, a+8($6)
	i32.load	$4=, a+20($6)
	i32.load	$5=, a+16($6)
.LBB1_1:                                # %for.cond1.preheader
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label2:
	i32.const	$10=, 3
	i32.const	$push1=, a
	i32.shl 	$push0=, $6, $10
	i32.add 	$8=, $pop1, $pop0
	i32.const	$11=, 4
	i32.add 	$7=, $8, $11
	block
	block
	block
	block
	i32.const	$push2=, -1
	i32.le_s	$push3=, $6, $pop2
	br_if   	$pop3, 0        # 0: down to label7
# BB#2:                                 # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$9=, 0($7)
	block
	block
	i32.const	$push44=, 0
	i32.eq  	$push45=, $6, $pop44
	br_if   	$pop45, 0       # 0: down to label9
# BB#3:                                 # %land.lhs.true16
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	block
	i32.gt_s	$push4=, $9, $0
	br_if   	$pop4, 0        # 0: down to label11
# BB#4:                                 # %if.end.i45
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push5=, $9, $0
	br_if   	$pop5, 1        # 1: down to label10
# BB#5:                                 # %if.end6.i49
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push6=, 0($8)
	i32.le_u	$push7=, $pop6, $1
	br_if   	$pop7, 1        # 1: down to label10
.LBB1_6:                                # %if.end.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label11:
	i32.load	$9=, 0($7)
	block
	i32.const	$push8=, 1
	i32.ne  	$push9=, $6, $pop8
	br_if   	$pop9, 0        # 0: down to label12
# BB#7:                                 # %land.lhs.true8.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.ne  	$push23=, $9, $2
	br_if   	$pop23, 3       # 3: down to label8
# BB#8:                                 # %if.end6.i63.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push24=, 0($8)
	i32.eq  	$push25=, $pop24, $3
	br_if   	$pop25, 6       # 6: down to label5
	br      	3               # 3: down to label8
.LBB1_9:                                # %land.lhs.true16.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label12:
	block
	i32.gt_s	$push10=, $9, $2
	br_if   	$pop10, 0       # 0: down to label13
# BB#10:                                # %if.end.i45.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push11=, $9, $2
	br_if   	$pop11, 1       # 1: down to label10
# BB#11:                                # %if.end6.i49.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push12=, 0($8)
	i32.le_u	$push13=, $pop12, $3
	br_if   	$pop13, 1       # 1: down to label10
.LBB1_12:                               # %if.end.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label13:
	i32.load	$7=, 0($7)
	block
	i32.const	$push14=, 2
	i32.ne  	$push15=, $6, $pop14
	br_if   	$pop15, 0       # 0: down to label14
# BB#13:                                # %land.lhs.true8.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.ne  	$push20=, $7, $4
	br_if   	$pop20, 3       # 3: down to label8
# BB#14:                                # %if.end6.i63.2
                                        #   in Loop: Header=BB1_1 Depth=1
	copy_local	$6=, $10
	i32.load	$push21=, 0($8)
	i32.eq  	$push22=, $pop21, $5
	br_if   	$pop22, 8       # 8: up to label2
	br      	3               # 3: down to label8
.LBB1_15:                               # %land.lhs.true16.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label14:
	i32.gt_s	$push16=, $7, $4
	br_if   	$pop16, 6       # 6: down to label4
# BB#16:                                # %if.end.i45.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push17=, $7, $4
	br_if   	$pop17, 0       # 0: down to label10
# BB#17:                                # %if.end6.i49.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push18=, 0($8)
	i32.gt_u	$push19=, $pop18, $5
	br_if   	$pop19, 6       # 6: down to label4
.LBB1_18:                               # %if.then21
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_19:                               # %land.lhs.true8
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.ne  	$push26=, $9, $0
	br_if   	$pop26, 0       # 0: down to label8
# BB#20:                                # %if.end6.i63
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push27=, 0($8)
	i32.eq  	$push28=, $pop27, $1
	br_if   	$pop28, 2       # 2: down to label6
.LBB1_21:                               # %if.then13
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_22:                               # %land.lhs.true
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.load	$10=, 0($7)
	i32.gt_s	$push29=, $10, $0
	br_if   	$pop29, 5       # 5: down to label1
# BB#23:                                # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push30=, $10, $0
	br_if   	$pop30, 0       # 0: down to label6
# BB#24:                                # %if.end6.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push31=, 0($8)
	i32.ge_u	$push32=, $pop31, $1
	br_if   	$pop32, 5       # 5: down to label1
.LBB1_25:                               # %land.lhs.true.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.load	$10=, 0($7)
	i32.gt_s	$push33=, $10, $2
	br_if   	$pop33, 4       # 4: down to label1
# BB#26:                                # %if.end.i.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push34=, $10, $2
	br_if   	$pop34, 0       # 0: down to label5
# BB#27:                                # %if.end6.i.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push35=, 0($8)
	i32.ge_u	$push36=, $pop35, $3
	br_if   	$pop36, 4       # 4: down to label1
.LBB1_28:                               # %land.lhs.true.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.load	$7=, 0($7)
	i32.gt_s	$push37=, $7, $4
	br_if   	$pop37, 3       # 3: down to label1
# BB#29:                                # %if.end.i.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push38=, $7, $4
	br_if   	$pop38, 0       # 0: down to label4
# BB#30:                                # %if.end6.i.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push39=, 0($8)
	i32.ge_u	$push40=, $pop39, $5
	br_if   	$pop40, 3       # 3: down to label1
.LBB1_31:                               # %for.inc.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label4:
	i32.const	$push41=, 1
	i32.add 	$6=, $6, $pop41
	i32.lt_s	$push42=, $6, $11
	br_if   	$pop42, 0       # 0: up to label2
# BB#32:                                # %for.end25
	end_loop                        # label3:
	i32.const	$push43=, 0
	return  	$pop43
.LBB1_33:                               # %if.then
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
	.align	4
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
