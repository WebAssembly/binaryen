	.text
	.file	"20061101-1.c"
	.section	.text.tar,"ax",@progbits
	.hidden	tar                     # -- Begin function tar
	.globl	tar
	.type	tar,@function
tar:                                    # @tar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 36863
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push2=, -1
	return  	$pop2
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	tar, .Lfunc_end0-tar
                                        # -- End function
	.section	.text.bug,"ax",@progbits
	.hidden	bug                     # -- Begin function bug
	.globl	bug
	.type	bug,@function
bug:                                    # @bug
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.const	$push2=, -1
	i32.add 	$push3=, $0, $pop2
	i32.const	$push8=, 1
	i32.gt_s	$push1=, $0, $pop8
	i32.select	$push4=, $pop0, $pop3, $pop1
	i32.mul 	$push5=, $pop4, $1
	i32.const	$push6=, 36863
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label1
# BB#1:                                 # %while.end
	return
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bug, .Lfunc_end1-bug
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
