	.text
	.file	"930921-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i64.extend_u/i32	$push0=, $0
	i64.const	$push1=, 2863311531
	i64.mul 	$push2=, $pop0, $pop1
	i64.const	$push3=, 33
	i64.shr_u	$push4=, $pop2, $pop3
	i32.wrap/i64	$push5=, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i64.const	$0=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.const	$push7=, 3
	i32.div_u	$push0=, $1, $pop7
	i64.const	$push6=, 33
	i64.shr_u	$push1=, $0, $pop6
	i32.wrap/i64	$push2=, $pop1
	i32.ne  	$push3=, $pop0, $pop2
	br_if   	1, $pop3        # 1: down to label0
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i64.const	$push12=, 2863311531
	i64.add 	$0=, $0, $pop12
	i32.const	$push11=, 1
	i32.add 	$push10=, $1, $pop11
	tee_local	$push9=, $1=, $pop10
	i32.const	$push8=, 9999
	i32.le_u	$push4=, $pop9, $pop8
	br_if   	0, $pop4        # 0: up to label1
# BB#3:                                 # %for.end
	end_loop
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB1_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
