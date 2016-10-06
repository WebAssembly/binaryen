	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120427-1.c"
	.section	.text.sreal_compare,"ax",@progbits
	.hidden	sreal_compare
	.globl	sreal_compare
	.type	sreal_compare,@function
sreal_compare:                          # @sreal_compare
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 1
	block   	
	i32.load	$push9=, 4($0)
	tee_local	$push8=, $2=, $pop9
	i32.load	$push7=, 4($1)
	tee_local	$push6=, $3=, $pop7
	i32.gt_s	$push0=, $pop8, $pop6
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$4=, -1
	i32.lt_s	$push1=, $2, $3
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$4=, 1
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
	i32.select	$4=, $pop5, $pop4, $pop3
.LBB0_4:                                # %return
	end_block                       # label0:
	copy_local	$push14=, $4
                                        # fallthrough-return: $pop14
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
	i32.const	$push47=, 0
	i32.load	$5=, a+16($pop47)
	i32.const	$push46=, 0
	i32.load	$4=, a+20($pop46)
	i32.const	$push45=, 0
	i32.load	$3=, a+8($pop45)
	i32.const	$push44=, 0
	i32.load	$2=, a+12($pop44)
	i32.const	$push43=, 0
	i32.load	$1=, a($pop43)
	i32.const	$push42=, 0
	i32.load	$0=, a+4($pop42)
.LBB1_1:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.const	$push52=, 3
	i32.shl 	$push51=, $6, $pop52
	tee_local	$push50=, $7=, $pop51
	i32.const	$push49=, a
	i32.add 	$8=, $pop50, $pop49
	i32.const	$push48=, a+4
	i32.add 	$7=, $7, $pop48
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	i32.eqz 	$push74=, $6
	br_if   	0, $pop74       # 0: down to label11
# BB#2:                                 # %if.end14
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push53=, 1
	i32.lt_s	$push0=, $6, $pop53
	br_if   	1, $pop0        # 1: down to label10
# BB#3:                                 # %land.lhs.true16
                                        #   in Loop: Header=BB1_1 Depth=1
	block   	
	i32.load	$push55=, 0($7)
	tee_local	$push54=, $9=, $pop55
	i32.gt_s	$push1=, $pop54, $0
	br_if   	0, $pop1        # 0: down to label12
# BB#4:                                 # %if.end.i45
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push2=, $9, $0
	br_if   	8, $pop2        # 8: down to label4
# BB#5:                                 # %if.end6.i49
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push3=, 0($8)
	i32.le_u	$push4=, $pop3, $1
	br_if   	8, $pop4        # 8: down to label4
.LBB1_6:                                # %if.end.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label12:
	i32.const	$push56=, 1
	i32.ne  	$push5=, $6, $pop56
	br_if   	2, $pop5        # 2: down to label9
# BB#7:                                 # %land.lhs.true8.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push24=, 0($7)
	i32.ne  	$push25=, $pop24, $2
	br_if   	6, $pop25       # 6: down to label5
# BB#8:                                 # %if.end6.i63.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push26=, 0($8)
	i32.eq  	$push27=, $pop26, $3
	br_if   	3, $pop27       # 3: down to label8
	br      	6               # 6: down to label5
.LBB1_9:                                # %land.lhs.true8
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label11:
	i32.load	$push28=, 0($7)
	i32.ne  	$push29=, $pop28, $0
	br_if   	5, $pop29       # 5: down to label5
# BB#10:                                # %if.end6.i63
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push30=, 0($8)
	i32.ne  	$push31=, $pop30, $1
	br_if   	5, $pop31       # 5: down to label5
.LBB1_11:                               # %land.lhs.true.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label10:
	i32.load	$push58=, 0($7)
	tee_local	$push57=, $9=, $pop58
	i32.gt_s	$push32=, $pop57, $2
	br_if   	3, $pop32       # 3: down to label6
# BB#12:                                # %if.end.i.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push33=, $9, $2
	br_if   	1, $pop33       # 1: down to label8
# BB#13:                                # %if.end6.i.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push34=, 0($8)
	i32.lt_u	$push35=, $pop34, $3
	br_if   	1, $pop35       # 1: down to label8
	br      	3               # 3: down to label6
.LBB1_14:                               # %if.end14.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.const	$push59=, 2
	i32.lt_s	$push6=, $6, $pop59
	br_if   	0, $pop6        # 0: down to label8
# BB#15:                                # %land.lhs.true16.1
                                        #   in Loop: Header=BB1_1 Depth=1
	block   	
	i32.load	$push61=, 0($7)
	tee_local	$push60=, $9=, $pop61
	i32.gt_s	$push7=, $pop60, $2
	br_if   	0, $pop7        # 0: down to label13
# BB#16:                                # %if.end.i45.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push8=, $9, $2
	br_if   	5, $pop8        # 5: down to label4
# BB#17:                                # %if.end6.i49.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push9=, 0($8)
	i32.le_u	$push10=, $pop9, $3
	br_if   	5, $pop10       # 5: down to label4
.LBB1_18:                               # %if.end.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label13:
	i32.const	$push62=, 2
	i32.ne  	$push11=, $6, $pop62
	br_if   	1, $pop11       # 1: down to label7
# BB#19:                                # %land.lhs.true8.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push20=, 0($7)
	i32.ne  	$push21=, $pop20, $4
	br_if   	3, $pop21       # 3: down to label5
# BB#20:                                # %if.end6.i63.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$6=, 3
	i32.load	$push22=, 0($8)
	i32.eq  	$push23=, $pop22, $5
	br_if   	6, $pop23       # 6: up to label2
	br      	3               # 3: down to label5
.LBB1_21:                               # %land.lhs.true.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.load	$push64=, 0($7)
	tee_local	$push63=, $7=, $pop64
	i32.gt_s	$push36=, $pop63, $4
	br_if   	1, $pop36       # 1: down to label6
# BB#22:                                # %if.end.i.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push37=, $7, $4
	br_if   	4, $pop37       # 4: down to label3
# BB#23:                                # %if.end6.i.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push38=, 0($8)
	i32.ge_u	$push39=, $pop38, $5
	br_if   	1, $pop39       # 1: down to label6
	br      	4               # 4: down to label3
.LBB1_24:                               # %if.end14.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.const	$push69=, 3
	i32.lt_s	$push12=, $6, $pop69
	br_if   	3, $pop12       # 3: down to label3
# BB#25:                                # %land.lhs.true16.2
	i32.load	$push73=, 0($7)
	tee_local	$push72=, $6=, $pop73
	i32.const	$push13=, 0
	i32.load	$push71=, a+20($pop13)
	tee_local	$push70=, $7=, $pop71
	i32.gt_s	$push14=, $pop72, $pop70
	br_if   	5, $pop14       # 5: down to label1
# BB#26:                                # %if.end.i45.2
	i32.lt_s	$push15=, $6, $7
	br_if   	2, $pop15       # 2: down to label4
# BB#27:                                # %if.end6.i49.2
	i32.load	$push18=, 0($8)
	i32.const	$push16=, 0
	i32.load	$push17=, a+16($pop16)
	i32.le_u	$push19=, $pop18, $pop17
	br_if   	2, $pop19       # 2: down to label4
	br      	5               # 5: down to label1
.LBB1_28:                               # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_29:                               # %if.then13
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_30:                               # %if.then21
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_31:                               # %for.inc.2
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.const	$push68=, 1
	i32.add 	$push67=, $6, $pop68
	tee_local	$push66=, $6=, $pop67
	i32.const	$push65=, 4
	i32.lt_s	$push40=, $pop66, $pop65
	br_if   	0, $pop40       # 0: up to label2
.LBB1_32:                               # %for.end25
	end_loop
	end_block                       # label1:
	i32.const	$push41=, 0
                                        # fallthrough-return: $pop41
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
