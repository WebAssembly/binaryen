	.text
	.file	"loop-11.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 198
	i32.const	$0=, a+792
.LBB0_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.store	0($0), $1
	i32.const	$push9=, -4
	i32.add 	$0=, $0, $pop9
	i32.const	$push8=, -1
	i32.add 	$push7=, $1, $pop8
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, -1
	i32.ne  	$push0=, $pop6, $pop5
	br_if   	0, $pop0        # 0: up to label0
# BB#2:                                 # %for.body.preheader
	end_loop
	i32.const	$1=, -1
	i32.const	$0=, a
.LBB0_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.const	$push12=, 1
	i32.add 	$push11=, $1, $pop12
	tee_local	$push10=, $1=, $pop11
	i32.load	$push1=, 0($0)
	i32.ne  	$push2=, $pop10, $pop1
	br_if   	1, $pop2        # 1: down to label1
# BB#4:                                 # %for.cond
                                        #   in Loop: Header=BB0_3 Depth=1
	i32.const	$push14=, 4
	i32.add 	$0=, $0, $pop14
	i32.const	$push13=, 197
	i32.le_u	$push3=, $1, $pop13
	br_if   	0, $pop3        # 0: up to label2
# BB#5:                                 # %for.end
	end_loop
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_6:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	a,@object               # @a
	.section	.bss.a,"aw",@nobits
	.p2align	4
a:
	.skip	796
	.size	a, 796


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
