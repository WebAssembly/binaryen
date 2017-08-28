	.text
	.file	"loop-7.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -1
	i32.const	$2=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.const	$push7=, 1
	i32.shl 	$push0=, $pop7, $2
	i32.eq  	$push1=, $pop0, $0
	i32.select	$1=, $2, $1, $pop1
	i32.const	$push6=, 8
	i32.gt_u	$push2=, $2, $pop6
	br_if   	1, $pop2        # 1: down to label0
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push9=, 1
	i32.add 	$2=, $2, $pop9
	i32.const	$push8=, 0
	i32.lt_s	$push3=, $1, $pop8
	br_if   	0, $pop3        # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
	block   	
	i32.const	$push4=, -1
	i32.le_s	$push5=, $1, $pop4
	br_if   	0, $pop5        # 0: down to label2
# BB#4:                                 # %if.end5
	return
.LBB0_5:                                # %if.then4
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 64
	call    	foo@FUNCTION, $pop0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
