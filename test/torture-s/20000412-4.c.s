	.text
	.file	"20000412-4.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.sub 	$push15=, $0, $2
	tee_local	$push14=, $6=, $pop15
	i32.const	$push0=, 0
	i32.const	$push13=, 0
	i32.gt_s	$push1=, $6, $pop13
	i32.select	$push12=, $pop14, $pop0, $pop1
	tee_local	$push11=, $5=, $pop12
	i32.const	$push2=, 2
	i32.gt_s	$push3=, $pop11, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %for.body.lr.ph
	i32.const	$push17=, -1
	i32.add 	$6=, $5, $pop17
	i32.add 	$push4=, $2, $5
	i32.const	$push16=, -1
	i32.add 	$push5=, $pop4, $pop16
	i32.sub 	$push6=, $pop5, $0
	i32.mul 	$push7=, $3, $pop6
	i32.add 	$push8=, $2, $pop7
	i32.sub 	$2=, $pop8, $1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.add 	$push20=, $2, $3
	tee_local	$push19=, $2=, $pop20
	i32.const	$push18=, -1
	i32.le_s	$push9=, $pop19, $pop18
	br_if   	2, $pop9        # 2: down to label0
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push24=, 1
	i32.add 	$push23=, $6, $pop24
	tee_local	$push22=, $6=, $pop23
	i32.const	$push21=, 1
	i32.le_u	$push10=, $pop22, $pop21
	br_if   	0, $pop10       # 0: up to label2
.LBB0_4:                                # %for.end
	end_loop
	end_block                       # label1:
	return
.LBB0_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %for.body.lr.ph.i
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
