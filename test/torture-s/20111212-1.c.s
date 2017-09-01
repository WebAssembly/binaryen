	.text
	.file	"20111212-1.c"
	.section	.text.frob_entry,"ax",@progbits
	.hidden	frob_entry              # -- Begin function frob_entry
	.globl	frob_entry
	.type	frob_entry,@function
frob_entry:                             # @frob_entry
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 0($0):p2align=0
	i32.const	$push1=, 63
	i32.gt_u	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push3=, -1
	i32.store	0($0):p2align=0, $pop3
.LBB0_2:                                # %if.end
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	frob_entry, .Lfunc_end0-frob_entry
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$push14=, $pop4, $pop6
	tee_local	$push13=, $0=, $pop14
	i32.store	__stack_pointer($pop7), $pop13
	i64.const	$push0=, 0
	i64.store	8($0), $pop0
	i32.const	$push11=, 8
	i32.add 	$push12=, $0, $pop11
	i32.const	$push1=, 1
	i32.or  	$push2=, $pop12, $pop1
	call    	frob_entry@FUNCTION, $pop2
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
