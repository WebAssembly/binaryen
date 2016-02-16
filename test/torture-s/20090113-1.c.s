	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20090113-1.c"
	.section	.text.msum_i4,"ax",@progbits
	.hidden	msum_i4
	.globl	msum_i4
	.type	msum_i4,@function
msum_i4:                                # @msum_i4
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 64
	i32.sub 	$12=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$12=, 0($9), $12
	i32.load	$push32=, 0($2)
	tee_local	$push31=, $2=, $pop32
	i32.const	$push30=, -1
	i32.add 	$push29=, $pop31, $pop30
	tee_local	$push28=, $6=, $pop29
	i32.const	$push27=, 12
	i32.mul 	$push0=, $pop28, $pop27
	i32.add 	$push26=, $1, $pop0
	tee_local	$push25=, $7=, $pop26
	i32.const	$push24=, 16
	i32.add 	$push1=, $pop25, $pop24
	i32.load	$push2=, 0($pop1)
	i32.const	$push23=, 1
	i32.add 	$push3=, $pop2, $pop23
	i32.const	$push22=, 12
	i32.add 	$push4=, $7, $pop22
	i32.load	$push5=, 0($pop4)
	i32.sub 	$3=, $pop3, $pop5
	block
	i32.const	$push21=, 2
	i32.lt_s	$push6=, $2, $pop21
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push9=, 0
	i32.const	$push35=, 2
	i32.shl 	$push7=, $2, $pop35
	i32.const	$push34=, -4
	i32.add 	$push8=, $pop7, $pop34
	i32.const	$11=, 32
	i32.add 	$11=, $12, $11
	i32.call	$discard=, memset@FUNCTION, $11, $pop9, $pop8
	i32.const	$push33=, 16
	i32.add 	$2=, $1, $pop33
	copy_local	$7=, $12
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$push10=, 0($2)
	i32.const	$push40=, 1
	i32.add 	$push11=, $pop10, $pop40
	i32.const	$push39=, -4
	i32.add 	$push12=, $2, $pop39
	i32.load	$push13=, 0($pop12)
	i32.sub 	$push14=, $pop11, $pop13
	i32.store	$discard=, 0($7), $pop14
	i32.const	$push38=, 4
	i32.add 	$7=, $7, $pop38
	i32.const	$push37=, -1
	i32.add 	$6=, $6, $pop37
	i32.const	$push36=, 12
	i32.add 	$2=, $2, $pop36
	br_if   	0, $6           # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.load	$0=, 0($0)
	i32.load	$1=, 0($1)
	i32.const	$push42=, 2
	i32.shl 	$5=, $3, $pop42
	i32.const	$push41=, 1
	i32.lt_s	$4=, $3, $pop41
.LBB0_4:                                # %do.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_5 Depth 2
	loop                            # label3:
	i32.const	$7=, 0
	copy_local	$2=, $3
	copy_local	$6=, $1
	block
	br_if   	0, $4           # 0: down to label5
.LBB0_5:                                # %for.body18
                                        #   Parent Loop BB0_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label6:
	i32.load	$push15=, 0($6)
	i32.add 	$7=, $pop15, $7
	i32.const	$push44=, 4
	i32.add 	$6=, $6, $pop44
	i32.const	$push43=, -1
	i32.add 	$2=, $2, $pop43
	br_if   	0, $2           # 0: up to label6
# BB#6:                                 # %for.end22.loopexit
                                        #   in Loop: Header=BB0_4 Depth=1
	end_loop                        # label7:
	i32.add 	$1=, $1, $5
.LBB0_7:                                # %for.end22
                                        #   in Loop: Header=BB0_4 Depth=1
	end_block                       # label5:
	i32.store	$discard=, 0($0), $7
	i32.const	$push46=, 4
	i32.add 	$0=, $0, $pop46
	i32.load	$push19=, 0($12):p2align=4
	i32.load	$push16=, 32($12):p2align=4
	i32.const	$push45=, 1
	i32.add 	$push17=, $pop16, $pop45
	i32.store	$push18=, 32($12):p2align=4, $pop17
	i32.ne  	$push20=, $pop19, $pop18
	br_if   	0, $pop20       # 0: up to label3
# BB#8:                                 # %do.end
	end_loop                        # label4:
	i32.const	$10=, 64
	i32.add 	$12=, $12, $10
	i32.const	$10=, __stack_pointer
	i32.store	$12=, 0($10), $12
	return
	.endfunc
.Lfunc_end0:
	.size	msum_i4, .Lfunc_end0-msum_i4

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 112
	i32.sub 	$8=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$8=, 0($5), $8
	copy_local	$2=, $8
	i32.const	$7=, 36
	i32.add 	$7=, $8, $7
	copy_local	$3=, $7
	i32.const	$push0=, 0
	i32.store	$discard=, 80($8):p2align=4, $pop0
	i32.const	$push1=, 3
	i32.store	$discard=, 48($8):p2align=4, $pop1
.LBB1_1:                                # %for.body18.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	i32.load	$0=, 80($8):p2align=4
	i32.load	$1=, 48($8):p2align=4
	i32.const	$push17=, 8
	i32.add 	$push6=, $2, $pop17
	i32.load	$push7=, 0($pop6)
	i32.const	$push16=, 4
	i32.add 	$push3=, $2, $pop16
	i32.load	$push4=, 0($pop3)
	i32.load	$push2=, 0($2)
	i32.add 	$push5=, $pop4, $pop2
	i32.add 	$push8=, $pop7, $pop5
	i32.store	$discard=, 0($3), $pop8
	i32.const	$push15=, 4
	i32.add 	$3=, $3, $pop15
	i32.const	$push14=, 12
	i32.add 	$2=, $2, $pop14
	i32.const	$push13=, 1
	i32.add 	$push9=, $0, $pop13
	i32.store	$push10=, 80($8):p2align=4, $pop9
	i32.ne  	$push11=, $1, $pop10
	br_if   	0, $pop11       # 0: up to label8
# BB#2:                                 # %msum_i4.exit
	end_loop                        # label9:
	i32.const	$push12=, 0
	i32.const	$6=, 112
	i32.add 	$8=, $8, $6
	i32.const	$6=, __stack_pointer
	i32.store	$8=, 0($6), $8
	return  	$pop12
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
