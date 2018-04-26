	.text
	.file	"20090113-1.c"
	.section	.text.msum_i4,"ax",@progbits
	.hidden	msum_i4                 # -- Begin function msum_i4
	.globl	msum_i4
	.type	msum_i4,@function
msum_i4:                                # @msum_i4
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push21=, 0
	i32.load	$push20=, __stack_pointer($pop21)
	i32.const	$push22=, 64
	i32.sub 	$8=, $pop20, $pop22
	i32.const	$push23=, 0
	i32.store	__stack_pointer($pop23), $8
	i32.load	$2=, 0($2)
	i32.const	$push34=, -1
	i32.add 	$6=, $2, $pop34
	i32.const	$push33=, 12
	i32.mul 	$push1=, $6, $pop33
	i32.add 	$7=, $1, $pop1
	i32.const	$push32=, 16
	i32.add 	$push2=, $7, $pop32
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
# %bb.1:                                # %for.body.lr.ph
	i32.const	$push27=, 32
	i32.add 	$push28=, $8, $pop27
	i32.const	$push10=, 0
	i32.const	$push37=, 2
	i32.shl 	$push8=, $2, $pop37
	i32.const	$push36=, -4
	i32.add 	$push9=, $pop8, $pop36
	i32.call	$drop=, memset@FUNCTION, $pop28, $pop10, $pop9
	i32.const	$push35=, 16
	i32.add 	$2=, $1, $pop35
	copy_local	$7=, $8
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load	$push11=, 0($2)
	i32.const	$push42=, 1
	i32.add 	$push12=, $pop11, $pop42
	i32.const	$push41=, -4
	i32.add 	$push13=, $2, $pop41
	i32.load	$push14=, 0($pop13)
	i32.sub 	$push15=, $pop12, $pop14
	i32.store	0($7), $pop15
	i32.const	$push40=, 12
	i32.add 	$2=, $2, $pop40
	i32.const	$push39=, -1
	i32.add 	$6=, $6, $pop39
	i32.const	$push38=, 4
	i32.add 	$7=, $7, $pop38
	br_if   	0, $6           # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
	i32.load	$5=, 0($1)
	i32.load	$1=, 0($0)
	i32.const	$push44=, 1
	i32.lt_s	$0=, $3, $pop44
	i32.const	$push43=, 2
	i32.shl 	$4=, $3, $pop43
.LBB0_4:                                # %do.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_6 Depth 2
	loop    	                # label2:
	block   	
	block   	
	br_if   	0, $0           # 0: down to label4
# %bb.5:                                # %for.body18.preheader
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$7=, 0
	copy_local	$2=, $3
	copy_local	$6=, $5
.LBB0_6:                                # %for.body18
                                        #   Parent Loop BB0_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label5:
	i32.const	$push46=, -1
	i32.add 	$2=, $2, $pop46
	i32.load	$push16=, 0($6)
	i32.add 	$7=, $pop16, $7
	i32.const	$push45=, 4
	i32.add 	$push0=, $6, $pop45
	copy_local	$6=, $pop0
	br_if   	0, $2           # 0: up to label5
# %bb.7:                                # %for.end22.loopexit
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
	i32.const	$push48=, 4
	i32.add 	$1=, $1, $pop48
	i32.load	$push17=, 32($8)
	i32.const	$push47=, 1
	i32.add 	$2=, $pop17, $pop47
	i32.store	32($8), $2
	i32.load	$push18=, 0($8)
	i32.ne  	$push19=, $2, $pop18
	br_if   	0, $pop19       # 0: up to label2
# %bb.10:                               # %do.end
	end_loop
	i32.const	$push26=, 0
	i32.const	$push24=, 64
	i32.add 	$push25=, $8, $pop24
	i32.store	__stack_pointer($pop26), $pop25
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	msum_i4, .Lfunc_end0-msum_i4
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
