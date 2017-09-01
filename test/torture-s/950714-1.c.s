	.text
	.file	"950714-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push46=, 0
	i32.load	$push1=, array($pop46)
	i32.sub 	$8=, $pop0, $pop1
	i32.const	$push45=, 0
	i32.const	$push44=, 0
	i32.load	$push2=, array+4($pop44)
	i32.sub 	$7=, $pop45, $pop2
	i32.const	$push43=, 0
	i32.const	$push42=, 0
	i32.load	$push3=, array+8($pop42)
	i32.sub 	$6=, $pop43, $pop3
	i32.const	$push41=, 0
	i32.const	$push40=, 0
	i32.load	$push4=, array+12($pop40)
	i32.sub 	$5=, $pop41, $pop4
	i32.const	$push39=, 0
	i32.const	$push38=, 0
	i32.load	$push5=, array+16($pop38)
	i32.sub 	$4=, $pop39, $pop5
	i32.const	$push37=, 0
	i32.const	$push36=, 0
	i32.load	$push6=, array+20($pop36)
	i32.sub 	$3=, $pop37, $pop6
	i32.const	$push35=, 0
	i32.const	$push34=, 0
	i32.load	$push7=, array+24($pop34)
	i32.sub 	$2=, $pop35, $pop7
	i32.const	$push33=, 0
	i32.const	$push32=, 0
	i32.load	$push8=, array+28($pop32)
	i32.sub 	$1=, $pop33, $pop8
	i32.const	$push31=, 0
	i32.const	$push30=, 0
	i32.load	$push9=, array+32($pop30)
	i32.sub 	$0=, $pop31, $pop9
	i32.const	$9=, -1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	loop    	                # label2:
	i32.add 	$push18=, $8, $9
	i32.const	$push47=, -1
	i32.eq  	$push19=, $pop18, $pop47
	br_if   	1, $pop19       # 1: down to label1
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$push10=, $7, $9
	i32.const	$push48=, -1
	i32.eq  	$push20=, $pop10, $pop48
	br_if   	1, $pop20       # 1: down to label1
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$push11=, $6, $9
	i32.const	$push49=, -1
	i32.eq  	$push21=, $pop11, $pop49
	br_if   	1, $pop21       # 1: down to label1
# BB#4:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$push12=, $5, $9
	i32.const	$push50=, -1
	i32.eq  	$push22=, $pop12, $pop50
	br_if   	1, $pop22       # 1: down to label1
# BB#5:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$push13=, $4, $9
	i32.const	$push51=, -1
	i32.eq  	$push23=, $pop13, $pop51
	br_if   	1, $pop23       # 1: down to label1
# BB#6:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$push14=, $3, $9
	i32.const	$push52=, -1
	i32.eq  	$push24=, $pop14, $pop52
	br_if   	1, $pop24       # 1: down to label1
# BB#7:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$push15=, $2, $9
	i32.const	$push53=, -1
	i32.eq  	$push25=, $pop15, $pop53
	br_if   	1, $pop25       # 1: down to label1
# BB#8:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$push16=, $1, $9
	i32.const	$push54=, -1
	i32.eq  	$push26=, $pop16, $pop54
	br_if   	1, $pop26       # 1: down to label1
# BB#9:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$push17=, $0, $9
	i32.const	$push55=, -1
	i32.eq  	$push27=, $pop17, $pop55
	br_if   	1, $pop27       # 1: down to label1
# BB#10:                                # %for.cond1.8
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push59=, 1
	i32.add 	$push58=, $9, $pop59
	tee_local	$push57=, $9=, $pop58
	i32.const	$push56=, 9
	i32.lt_u	$push28=, $pop57, $pop56
	br_if   	0, $pop28       # 0: up to label2
	br      	2               # 2: down to label0
.LBB0_11:                               # %label
	end_loop
	end_block                       # label1:
	br_if   	0, $9           # 0: down to label0
# BB#12:                                # %if.end9
	i32.const	$push29=, 0
	call    	exit@FUNCTION, $pop29
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
