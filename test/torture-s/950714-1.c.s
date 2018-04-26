	.text
	.file	"950714-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$9=, 0
	i32.const	$push21=, 0
	i32.load	$8=, array+32($pop21)
	i32.const	$push20=, 0
	i32.load	$7=, array+28($pop20)
	i32.const	$push19=, 0
	i32.load	$6=, array+24($pop19)
	i32.const	$push18=, 0
	i32.load	$5=, array+20($pop18)
	i32.const	$push17=, 0
	i32.load	$4=, array+16($pop17)
	i32.const	$push16=, 0
	i32.load	$3=, array+12($pop16)
	i32.const	$push15=, 0
	i32.load	$2=, array+8($pop15)
	i32.const	$push14=, 0
	i32.load	$1=, array+4($pop14)
	i32.const	$push13=, 0
	i32.load	$0=, array($pop13)
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	loop    	                # label2:
	i32.eq  	$push0=, $0, $9
	br_if   	1, $pop0        # 1: down to label1
# %bb.2:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push1=, $1, $9
	br_if   	1, $pop1        # 1: down to label1
# %bb.3:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push2=, $2, $9
	br_if   	1, $pop2        # 1: down to label1
# %bb.4:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push3=, $3, $9
	br_if   	1, $pop3        # 1: down to label1
# %bb.5:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push4=, $4, $9
	br_if   	1, $pop4        # 1: down to label1
# %bb.6:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push5=, $5, $9
	br_if   	1, $pop5        # 1: down to label1
# %bb.7:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push6=, $6, $9
	br_if   	1, $pop6        # 1: down to label1
# %bb.8:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push7=, $7, $9
	br_if   	1, $pop7        # 1: down to label1
# %bb.9:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push8=, $8, $9
	br_if   	1, $pop8        # 1: down to label1
# %bb.10:                               # %for.cond1.8
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push23=, 1
	i32.add 	$9=, $9, $pop23
	i32.const	$push22=, 10
	i32.lt_u	$push9=, $9, $pop22
	br_if   	0, $pop9        # 0: up to label2
	br      	2               # 2: down to label0
.LBB0_11:                               # %label
	end_loop
	end_block                       # label1:
	i32.const	$push10=, 1
	i32.ne  	$push11=, $9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.12:                               # %if.end9
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
.LBB0_13:                               # %if.then8
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	array                   # @array
	.type	array,@object
	.section	.data.array,"aw",@progbits
	.globl	array
	.p2align	4
array:
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.size	array, 40


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
