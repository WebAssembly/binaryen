	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000422-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	block
	i32.const	$push16=, 0
	i32.load	$push15=, num($pop16)
	tee_local	$push14=, $0=, $pop15
	i32.const	$push13=, 1
	i32.lt_s	$push0=, $pop14, $pop13
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %for.cond1.preheader.preheader
	i32.const	$push17=, -1
	i32.add 	$1=, $0, $pop17
	i32.const	$push1=, 2
	i32.shl 	$push2=, $0, $pop1
	i32.const	$push3=, ops-8
	i32.add 	$2=, $pop2, $pop3
	i32.const	$6=, 0
.LBB0_2:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
	loop                            # label2:
	block
	i32.le_s	$push4=, $1, $6
	br_if   	0, $pop4        # 0: down to label4
# BB#3:                                 # %for.body3.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	copy_local	$7=, $2
	copy_local	$8=, $1
.LBB0_4:                                # %for.body3
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label5:
	block
	i32.load	$push24=, 0($7)
	tee_local	$push23=, $3=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push21=, $7, $pop22
	tee_local	$push20=, $5=, $pop21
	i32.load	$push19=, 0($pop20)
	tee_local	$push18=, $4=, $pop19
	i32.ge_s	$push5=, $pop23, $pop18
	br_if   	0, $pop5        # 0: down to label7
# BB#5:                                 # %if.then
                                        #   in Loop: Header=BB0_4 Depth=2
	i32.store	$drop=, 0($7), $4
	i32.store	$drop=, 0($5), $3
.LBB0_6:                                # %for.cond1.backedge
                                        #   in Loop: Header=BB0_4 Depth=2
	end_block                       # label7:
	i32.const	$push28=, -4
	i32.add 	$7=, $7, $pop28
	i32.const	$push27=, -1
	i32.add 	$push26=, $8, $pop27
	tee_local	$push25=, $8=, $pop26
	i32.gt_s	$push6=, $pop25, $6
	br_if   	0, $pop6        # 0: up to label5
.LBB0_7:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label6:
	end_block                       # label4:
	i32.const	$push31=, 1
	i32.add 	$push30=, $6, $pop31
	tee_local	$push29=, $6=, $pop30
	i32.lt_s	$push7=, $pop29, $0
	br_if   	0, $pop7        # 0: up to label2
# BB#8:                                 # %for.cond15.preheader
	end_loop                        # label3:
	i32.const	$push32=, 1
	i32.lt_s	$push8=, $0, $pop32
	br_if   	0, $pop8        # 0: down to label1
# BB#9:                                 # %for.body17.preheader
	i32.const	$7=, 0
	i32.const	$8=, 0
.LBB0_10:                               # %for.body17
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	i32.load	$push10=, ops($7)
	i32.load	$push9=, correct($7)
	i32.ne  	$push11=, $pop10, $pop9
	br_if   	3, $pop11       # 3: down to label0
# BB#11:                                # %for.cond15
                                        #   in Loop: Header=BB0_10 Depth=1
	i32.const	$push36=, 4
	i32.add 	$7=, $7, $pop36
	i32.const	$push35=, 1
	i32.add 	$push34=, $8, $pop35
	tee_local	$push33=, $8=, $pop34
	i32.lt_s	$push12=, $pop33, $0
	br_if   	0, $pop12       # 0: up to label8
.LBB0_12:                               # %for.end25
	end_loop                        # label9:
	end_block                       # label1:
	i32.const	$push37=, 0
	call    	exit@FUNCTION, $pop37
	unreachable
.LBB0_13:                               # %if.then21
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	ops                     # @ops
	.type	ops,@object
	.section	.data.ops,"aw",@progbits
	.globl	ops
	.p2align	4
ops:
	.int32	11                      # 0xb
	.int32	12                      # 0xc
	.int32	46                      # 0x2e
	.int32	3                       # 0x3
	.int32	2                       # 0x2
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	2                       # 0x2
	.int32	1                       # 0x1
	.int32	3                       # 0x3
	.int32	2                       # 0x2
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.size	ops, 52

	.hidden	correct                 # @correct
	.type	correct,@object
	.section	.data.correct,"aw",@progbits
	.globl	correct
	.p2align	4
correct:
	.int32	46                      # 0x2e
	.int32	12                      # 0xc
	.int32	11                      # 0xb
	.int32	3                       # 0x3
	.int32	3                       # 0x3
	.int32	3                       # 0x3
	.int32	2                       # 0x2
	.int32	2                       # 0x2
	.int32	2                       # 0x2
	.int32	2                       # 0x2
	.int32	2                       # 0x2
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.size	correct, 52

	.hidden	num                     # @num
	.type	num,@object
	.section	.data.num,"aw",@progbits
	.globl	num
	.p2align	2
num:
	.int32	13                      # 0xd
	.size	num, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
