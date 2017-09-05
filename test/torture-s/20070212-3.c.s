	.text
	.file	"20070212-3.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.add 	$push1=, $0, $pop0
	i32.select	$push5=, $0, $pop1, $2
	tee_local	$push4=, $4=, $pop5
	i32.load	$2=, 0($pop4)
	i32.const	$push2=, 1
	i32.store	0($0), $pop2
	block   	
	i32.eqz 	$push6=, $3
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.then3
	i32.load	$1=, 0($4)
.LBB0_2:                                # %if.end5
	end_block                       # label0:
	i32.add 	$push3=, $1, $2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
