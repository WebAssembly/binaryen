	.text
	.file	"pr22630.c"
	.section	.text.bla,"ax",@progbits
	.hidden	bla                     # -- Begin function bla
	.globl	bla
	.type	bla,@function
bla:                                    # @bla
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, j
	i32.select	$push1=, $0, $pop0, $0
	i32.eq  	$push2=, $pop1, $0
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.then1
	i32.const	$push4=, 0
	i32.const	$push3=, 1
	i32.store	j($pop4), $pop3
.LBB0_2:                                # %if.end2
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bla, .Lfunc_end0-bla
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	j($pop1), $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.p2align	2
j:
	.int32	0                       # 0x0
	.size	j, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
