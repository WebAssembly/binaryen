	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20090113-1.c"
	.section	.text.msum_i4,"ax",@progbits
	.hidden	msum_i4
	.globl	msum_i4
	.type	msum_i4,@function
msum_i4:                                # @msum_i4
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push24=, __stack_pointer
	i32.const	$push21=, __stack_pointer
	i32.load	$push22=, 0($pop21)
	i32.const	$push23=, 64
	i32.sub 	$push30=, $pop22, $pop23
	i32.store	$3=, 0($pop24), $pop30
	i32.load	$push42=, 0($2)
	tee_local	$push41=, $2=, $pop42
	i32.const	$push40=, -1
	i32.add 	$push39=, $pop41, $pop40
	tee_local	$push38=, $7=, $pop39
	i32.const	$push37=, 12
	i32.mul 	$push1=, $pop38, $pop37
	i32.add 	$push36=, $1, $pop1
	tee_local	$push35=, $8=, $pop36
	i32.const	$push34=, 16
	i32.add 	$push2=, $pop35, $pop34
	i32.load	$push3=, 0($pop2)
	i32.const	$push33=, 1
	i32.add 	$push4=, $pop3, $pop33
	i32.const	$push32=, 12
	i32.add 	$push5=, $8, $pop32
	i32.load	$push6=, 0($pop5)
	i32.sub 	$4=, $pop4, $pop6
	block
	i32.const	$push31=, 2
	i32.lt_s	$push7=, $2, $pop31
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push28=, 32
	i32.add 	$push29=, $3, $pop28
	i32.const	$push10=, 0
	i32.const	$push45=, 2
	i32.shl 	$push8=, $2, $pop45
	i32.const	$push44=, -4
	i32.add 	$push9=, $pop8, $pop44
	i32.call	$discard=, memset@FUNCTION, $pop29, $pop10, $pop9
	i32.const	$push43=, 16
	i32.add 	$2=, $1, $pop43
	copy_local	$8=, $3
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$push11=, 0($2)
	i32.const	$push50=, 1
	i32.add 	$push12=, $pop11, $pop50
	i32.const	$push49=, -4
	i32.add 	$push13=, $2, $pop49
	i32.load	$push14=, 0($pop13)
	i32.sub 	$push15=, $pop12, $pop14
	i32.store	$discard=, 0($8), $pop15
	i32.const	$push48=, 4
	i32.add 	$8=, $8, $pop48
	i32.const	$push47=, -1
	i32.add 	$7=, $7, $pop47
	i32.const	$push46=, 12
	i32.add 	$2=, $2, $pop46
	br_if   	0, $7           # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.load	$0=, 0($0)
	i32.load	$1=, 0($1)
	i32.const	$push52=, 2
	i32.shl 	$6=, $4, $pop52
	i32.const	$push51=, 1
	i32.lt_s	$5=, $4, $pop51
.LBB0_4:                                # %do.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_6 Depth 2
	loop                            # label3:
	i32.const	$8=, 0
	block
	br_if   	0, $5           # 0: down to label5
# BB#5:                                 # %for.body18.preheader
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$8=, 0
	copy_local	$2=, $4
	copy_local	$7=, $1
.LBB0_6:                                # %for.body18
                                        #   Parent Loop BB0_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label6:
	i32.load	$push16=, 0($7)
	i32.add 	$8=, $pop16, $8
	i32.const	$push54=, 4
	i32.add 	$7=, $7, $pop54
	i32.const	$push53=, -1
	i32.add 	$2=, $2, $pop53
	br_if   	0, $2           # 0: up to label6
# BB#7:                                 # %for.end22.loopexit
                                        #   in Loop: Header=BB0_4 Depth=1
	end_loop                        # label7:
	i32.add 	$1=, $1, $6
.LBB0_8:                                # %for.end22
                                        #   in Loop: Header=BB0_4 Depth=1
	end_block                       # label5:
	i32.store	$discard=, 0($0), $8
	i32.const	$push56=, 4
	i32.add 	$0=, $0, $pop56
	i32.load	$push19=, 0($3)
	i32.load	$push17=, 32($3)
	i32.const	$push55=, 1
	i32.add 	$push18=, $pop17, $pop55
	i32.store	$push0=, 32($3), $pop18
	i32.ne  	$push20=, $pop19, $pop0
	br_if   	0, $pop20       # 0: up to label3
# BB#9:                                 # %do.end
	end_loop                        # label4:
	i32.const	$push27=, __stack_pointer
	i32.const	$push25=, 64
	i32.add 	$push26=, $3, $pop25
	i32.store	$discard=, 0($pop27), $pop26
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 112
	i32.sub 	$push19=, $pop14, $pop15
	tee_local	$push18=, $4=, $pop19
	i32.const	$push1=, 0
	i32.store	$discard=, 80($pop18), $pop1
	i32.const	$push2=, 3
	i32.store	$discard=, 48($4), $pop2
	copy_local	$2=, $4
	i32.const	$push16=, 36
	i32.add 	$push17=, $4, $pop16
	copy_local	$3=, $pop17
.LBB1_1:                                # %for.body18.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	i32.load	$0=, 80($4)
	i32.load	$1=, 48($4)
	i32.const	$push24=, 8
	i32.add 	$push7=, $2, $pop24
	i32.load	$push8=, 0($pop7)
	i32.const	$push23=, 4
	i32.add 	$push4=, $2, $pop23
	i32.load	$push5=, 0($pop4)
	i32.load	$push3=, 0($2)
	i32.add 	$push6=, $pop5, $pop3
	i32.add 	$push9=, $pop8, $pop6
	i32.store	$discard=, 0($3), $pop9
	i32.const	$push22=, 4
	i32.add 	$3=, $3, $pop22
	i32.const	$push21=, 12
	i32.add 	$2=, $2, $pop21
	i32.const	$push20=, 1
	i32.add 	$push10=, $0, $pop20
	i32.store	$push0=, 80($4), $pop10
	i32.ne  	$push11=, $1, $pop0
	br_if   	0, $pop11       # 0: up to label8
# BB#2:                                 # %msum_i4.exit
	end_loop                        # label9:
	i32.const	$push12=, 0
	return  	$pop12
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
