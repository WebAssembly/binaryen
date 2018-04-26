	.text
	.file	"const-addr-expr-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push9=, 0
	i32.load	$push0=, Upgd_minor_ID($pop9)
	i32.load	$push1=, 0($pop0)
	i32.const	$push2=, 2
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push10=, 0
	i32.load	$push4=, Upgd_minor_ID1($pop10)
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 1
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.2:                                # %if.end3
	i32.const	$push8=, 0
	return  	$pop8
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"1"
	.size	.L.str, 2

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"2"
	.size	.L.str.1, 2

	.hidden	Upgrade_items           # @Upgrade_items
	.type	Upgrade_items,@object
	.section	.data.Upgrade_items,"aw",@progbits
	.globl	Upgrade_items
	.p2align	4
Upgrade_items:
	.int32	1                       # 0x1
	.int32	.L.str
	.int32	2                       # 0x2
	.int32	.L.str.1
	.skip	8
	.size	Upgrade_items, 24

	.hidden	Upgd_minor_ID           # @Upgd_minor_ID
	.type	Upgd_minor_ID,@object
	.section	.data.Upgd_minor_ID,"aw",@progbits
	.globl	Upgd_minor_ID
	.p2align	2
Upgd_minor_ID:
	.int32	Upgrade_items+8
	.size	Upgd_minor_ID, 4

	.hidden	Upgd_minor_ID1          # @Upgd_minor_ID1
	.type	Upgd_minor_ID1,@object
	.section	.data.Upgd_minor_ID1,"aw",@progbits
	.globl	Upgd_minor_ID1
	.p2align	2
Upgd_minor_ID1:
	.int32	Upgrade_items
	.size	Upgd_minor_ID1, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
