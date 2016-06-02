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
	i32.const	$push25=, 0
	i32.const	$push22=, 0
	i32.load	$push23=, __stack_pointer($pop22)
	i32.const	$push24=, 64
	i32.sub 	$push31=, $pop23, $pop24
	i32.store	$3=, __stack_pointer($pop25), $pop31
	i32.load	$push43=, 0($2)
	tee_local	$push42=, $2=, $pop43
	i32.const	$push41=, -1
	i32.add 	$push40=, $pop42, $pop41
	tee_local	$push39=, $7=, $pop40
	i32.const	$push38=, 12
	i32.mul 	$push2=, $pop39, $pop38
	i32.add 	$push37=, $1, $pop2
	tee_local	$push36=, $8=, $pop37
	i32.const	$push35=, 16
	i32.add 	$push3=, $pop36, $pop35
	i32.load	$push4=, 0($pop3)
	i32.const	$push34=, 1
	i32.add 	$push5=, $pop4, $pop34
	i32.const	$push33=, 12
	i32.add 	$push6=, $8, $pop33
	i32.load	$push7=, 0($pop6)
	i32.sub 	$4=, $pop5, $pop7
	block
	i32.const	$push32=, 2
	i32.lt_s	$push8=, $2, $pop32
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push29=, 32
	i32.add 	$push30=, $3, $pop29
	i32.const	$push11=, 0
	i32.const	$push46=, 2
	i32.shl 	$push9=, $2, $pop46
	i32.const	$push45=, -4
	i32.add 	$push10=, $pop9, $pop45
	i32.call	$drop=, memset@FUNCTION, $pop30, $pop11, $pop10
	i32.const	$push44=, 16
	i32.add 	$2=, $1, $pop44
	copy_local	$8=, $3
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$push12=, 0($2)
	i32.const	$push53=, 1
	i32.add 	$push13=, $pop12, $pop53
	i32.const	$push52=, -4
	i32.add 	$push14=, $2, $pop52
	i32.load	$push15=, 0($pop14)
	i32.sub 	$push16=, $pop13, $pop15
	i32.store	$drop=, 0($8), $pop16
	i32.const	$push51=, 12
	i32.add 	$2=, $2, $pop51
	i32.const	$push50=, 4
	i32.add 	$8=, $8, $pop50
	i32.const	$push49=, -1
	i32.add 	$push48=, $7, $pop49
	tee_local	$push47=, $7=, $pop48
	br_if   	0, $pop47       # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.load	$6=, 0($1)
	i32.load	$1=, 0($0)
	i32.const	$push55=, 1
	i32.lt_s	$0=, $4, $pop55
	i32.const	$push54=, 2
	i32.shl 	$5=, $4, $pop54
.LBB0_4:                                # %do.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_6 Depth 2
	loop                            # label3:
	i32.const	$8=, 0
	block
	br_if   	0, $0           # 0: down to label5
# BB#5:                                 # %for.body18.preheader
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$8=, 0
	copy_local	$7=, $4
	copy_local	$2=, $6
.LBB0_6:                                # %for.body18
                                        #   Parent Loop BB0_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label6:
	i32.load	$push17=, 0($2)
	i32.add 	$8=, $pop17, $8
	i32.const	$push59=, 4
	i32.add 	$push1=, $2, $pop59
	copy_local	$2=, $pop1
	i32.const	$push58=, -1
	i32.add 	$push57=, $7, $pop58
	tee_local	$push56=, $7=, $pop57
	br_if   	0, $pop56       # 0: up to label6
# BB#7:                                 # %for.end22.loopexit
                                        #   in Loop: Header=BB0_4 Depth=1
	end_loop                        # label7:
	i32.add 	$6=, $6, $5
.LBB0_8:                                # %for.end22
                                        #   in Loop: Header=BB0_4 Depth=1
	end_block                       # label5:
	i32.store	$drop=, 0($1), $8
	i32.const	$push61=, 4
	i32.add 	$1=, $1, $pop61
	i32.load	$push18=, 32($3)
	i32.const	$push60=, 1
	i32.add 	$push19=, $pop18, $pop60
	i32.store	$push0=, 32($3), $pop19
	i32.load	$push20=, 0($3)
	i32.ne  	$push21=, $pop0, $pop20
	br_if   	0, $pop21       # 0: up to label3
# BB#9:                                 # %do.end
	end_loop                        # label4:
	i32.const	$push28=, 0
	i32.const	$push26=, 64
	i32.add 	$push27=, $3, $pop26
	i32.store	$drop=, __stack_pointer($pop28), $pop27
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	msum_i4, .Lfunc_end0-msum_i4

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %for.body18.i.2
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
