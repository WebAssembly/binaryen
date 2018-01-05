	.text
	.file	"pr49073.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$2=, 0
	i32.const	$1=, a+4
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	loop    	                # label2:
	i32.load	$0=, 0($1)
	block   	
	i32.const	$push10=, 1
	i32.and 	$push0=, $2, $pop10
	i32.eqz 	$push16=, $pop0
	br_if   	0, $pop16       # 0: down to label3
# %bb.2:                                # %do.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push11=, 4
	i32.eq  	$push1=, $0, $pop11
	br_if   	2, $pop1        # 2: down to label1
.LBB0_3:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push14=, 4
	i32.add 	$1=, $1, $pop14
	i32.const	$push13=, 3
	i32.eq  	$2=, $0, $pop13
	i32.const	$push12=, 7
	i32.lt_s	$push2=, $0, $pop12
	br_if   	0, $pop2        # 0: up to label2
# %bb.4:                                # %do.endthread-pre-split
	end_loop
	i32.const	$push3=, 0
	i32.load	$0=, c($pop3)
	br      	1               # 1: down to label0
.LBB0_5:                                # %if.then
	end_block                       # label1:
	i32.const	$push4=, 0
	i32.load	$push5=, c($pop4)
	i32.const	$push6=, 1
	i32.add 	$0=, $pop5, $pop6
	i32.const	$push15=, 0
	i32.store	c($pop15), $0
.LBB0_6:                                # %do.end
	end_block                       # label0:
	block   	
	i32.const	$push7=, 1
	i32.ne  	$push8=, $0, $pop7
	br_if   	0, $pop8        # 0: down to label4
# %bb.7:                                # %if.end6
	i32.const	$push9=, 0
	return  	$pop9
.LBB0_8:                                # %if.then5
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	4
a:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.int32	5                       # 0x5
	.int32	6                       # 0x6
	.int32	7                       # 0x7
	.size	a, 28

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
