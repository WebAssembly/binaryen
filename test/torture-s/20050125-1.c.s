	.text
	.file	"20050125-1.c"
	.section	.text.seterr,"ax",@progbits
	.hidden	seterr                  # -- Begin function seterr
	.globl	seterr
	.type	seterr,@function
seterr:                                 # @seterr
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.store	8($0), $1
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	seterr, .Lfunc_end0-seterr
                                        # -- End function
	.section	.text.bracket_empty,"ax",@progbits
	.hidden	bracket_empty           # -- Begin function bracket_empty
	.globl	bracket_empty
	.type	bracket_empty,@function
bracket_empty:                          # @bracket_empty
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.load	$push9=, 0($0)
	tee_local	$push8=, $1=, $pop9
	i32.load	$push0=, 4($0)
	i32.ge_u	$push1=, $pop8, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %land.lhs.true
	i32.const	$push2=, 1
	i32.add 	$push3=, $1, $pop2
	i32.store	0($0), $pop3
	i32.load8_u	$push4=, 0($1)
	i32.const	$push5=, 93
	i32.eq  	$push6=, $pop4, $pop5
	br_if   	1, $pop6        # 1: down to label0
.LBB1_2:                                # %lor.lhs.false
	end_block                       # label1:
	i32.const	$push7=, 7
	i32.store	8($0), $pop7
.LBB1_3:                                # %if.end
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bracket_empty, .Lfunc_end1-bracket_empty
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
