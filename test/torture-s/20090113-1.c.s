	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20090113-1.c"
	.section	.text.msum_i4,"ax",@progbits
	.hidden	msum_i4
	.globl	msum_i4
	.type	msum_i4,@function
msum_i4:                                # @msum_i4
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, 0
	i32.const	$push20=, 0
	i32.load	$push21=, __stack_pointer($pop20)
	i32.const	$push22=, 64
	i32.sub 	$push42=, $pop21, $pop22
	tee_local	$push41=, $8=, $pop42
	i32.store	__stack_pointer($pop23), $pop41
	i32.load	$push40=, 0($2)
	tee_local	$push39=, $2=, $pop40
	i32.const	$push38=, -1
	i32.add 	$push37=, $pop39, $pop38
	tee_local	$push36=, $6=, $pop37
	i32.const	$push35=, 12
	i32.mul 	$push1=, $pop36, $pop35
	i32.add 	$push34=, $1, $pop1
	tee_local	$push33=, $7=, $pop34
	i32.const	$push32=, 16
	i32.add 	$push2=, $pop33, $pop32
	i32.load	$push3=, 0($pop2)
	i32.const	$push31=, 1
	i32.add 	$push4=, $pop3, $pop31
	i32.const	$push30=, 12
	i32.add 	$push5=, $7, $pop30
	i32.load	$push6=, 0($pop5)
	i32.sub 	$3=, $pop4, $pop6
	block   	
	i32.const	$push29=, 2
	i32.lt_s	$push7=, $2, $pop29
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push27=, 32
	i32.add 	$push28=, $8, $pop27
	i32.const	$push10=, 0
	i32.const	$push45=, 2
	i32.shl 	$push8=, $2, $pop45
	i32.const	$push44=, -4
	i32.add 	$push9=, $pop8, $pop44
	i32.call	$drop=, memset@FUNCTION, $pop28, $pop10, $pop9
	i32.const	$push43=, 16
	i32.add 	$2=, $1, $pop43
	copy_local	$7=, $8
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load	$push11=, 0($2)
	i32.const	$push52=, 1
	i32.add 	$push12=, $pop11, $pop52
	i32.const	$push51=, -4
	i32.add 	$push13=, $2, $pop51
	i32.load	$push14=, 0($pop13)
	i32.sub 	$push15=, $pop12, $pop14
	i32.store	0($7), $pop15
	i32.const	$push50=, 12
	i32.add 	$2=, $2, $pop50
	i32.const	$push49=, 4
	i32.add 	$7=, $7, $pop49
	i32.const	$push48=, -1
	i32.add 	$push47=, $6, $pop48
	tee_local	$push46=, $6=, $pop47
	br_if   	0, $pop46       # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
	i32.load	$5=, 0($1)
	i32.load	$1=, 0($0)
	i32.const	$push54=, 1
	i32.lt_s	$0=, $3, $pop54
	i32.const	$push53=, 2
	i32.shl 	$4=, $3, $pop53
.LBB0_4:                                # %do.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_6 Depth 2
	loop    	                # label2:
	block   	
	block   	
	br_if   	0, $0           # 0: down to label4
# BB#5:                                 # %for.body18.preheader
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$7=, 0
	copy_local	$6=, $3
	copy_local	$2=, $5
.LBB0_6:                                # %for.body18
                                        #   Parent Loop BB0_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label5:
	i32.load	$push16=, 0($2)
	i32.add 	$7=, $pop16, $7
	i32.const	$push58=, 4
	i32.add 	$push0=, $2, $pop58
	copy_local	$2=, $pop0
	i32.const	$push57=, -1
	i32.add 	$push56=, $6, $pop57
	tee_local	$push55=, $6=, $pop56
	br_if   	0, $pop55       # 0: up to label5
# BB#7:                                 # %for.end22.loopexit
                                        #   in Loop: Header=BB0_4 Depth=1
	end_loop
	i32.add 	$5=, $5, $4
	br      	1               # 1: down to label3
.LBB0_8:                                #   in Loop: Header=BB0_4 Depth=1
	end_block                       # label4:
	i32.const	$7=, 0
.LBB0_9:                                # %for.end22
                                        #   in Loop: Header=BB0_4 Depth=1
	end_block                       # label3:
	i32.store	0($1), $7
	i32.const	$push62=, 4
	i32.add 	$1=, $1, $pop62
	i32.load	$push17=, 32($8)
	i32.const	$push61=, 1
	i32.add 	$push60=, $pop17, $pop61
	tee_local	$push59=, $2=, $pop60
	i32.store	32($8), $pop59
	i32.load	$push18=, 0($8)
	i32.ne  	$push19=, $2, $pop18
	br_if   	0, $pop19       # 0: up to label2
# BB#10:                                # %do.end
	end_loop
	i32.const	$push26=, 0
	i32.const	$push24=, 64
	i32.add 	$push25=, $8, $pop24
	i32.store	__stack_pointer($pop26), $pop25
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


	.ident	"clang version 4.0.0 "
