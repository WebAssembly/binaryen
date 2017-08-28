	.text
	.file	"930513-2.c"
	.section	.text.sub3,"ax",@progbits
	.hidden	sub3                    # -- Begin function sub3
	.globl	sub3
	.type	sub3,@function
sub3:                                   # @sub3
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	copy_local	$push0=, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	sub3, .Lfunc_end0-sub3
                                        # -- End function
	.section	.text.eq,"ax",@progbits
	.hidden	eq                      # -- Begin function eq
	.globl	eq
	.type	eq,@function
eq:                                     # @eq
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push4=, 0
	i32.load	$push0=, eq.i($pop4)
	i32.ne  	$push1=, $pop0, $0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	i32.const	$push2=, 1
	i32.add 	$push3=, $0, $pop2
	i32.store	eq.i($pop5), $pop3
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	eq, .Lfunc_end1-eq
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push2=, 0
	i32.load	$push0=, eq.i($pop2)
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %eq.exit.3
	i32.const	$push4=, 0
	i32.const	$push1=, 4
	i32.store	eq.i($pop4), $pop1
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
.LBB2_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	eq.i,@object            # @eq.i
	.section	.bss.eq.i,"aw",@nobits
	.p2align	2
eq.i:
	.int32	0                       # 0x0
	.size	eq.i, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
