	.text
	.file	"pr46909-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.const	$push0=, 13
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$1=, 1
	br_if   	1, $0           # 1: down to label0
.LBB0_2:                                # %if.end
	end_block                       # label1:
	i32.const	$1=, -1
.LBB0_3:                                # %return
	end_block                       # label0:
	copy_local	$push2=, $1
                                        # fallthrough-return: $pop2
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, -11
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	i32.const	$push15=, 12
	i32.eq  	$0=, $2, $pop15
	i32.const	$push14=, -1
	i32.eq  	$1=, $2, $pop14
	i32.const	$push13=, 1
	i32.add 	$push12=, $2, $pop13
	tee_local	$push11=, $2=, $pop12
	i32.call	$push4=, foo@FUNCTION, $pop11
	i32.const	$push10=, 1
	i32.const	$push9=, 1
	i32.shl 	$push1=, $1, $pop9
	i32.sub 	$push2=, $pop10, $pop1
	i32.const	$push8=, 1
	i32.shl 	$push0=, $0, $pop8
	i32.sub 	$push3=, $pop2, $pop0
	i32.ne  	$push5=, $pop4, $pop3
	br_if   	1, $pop5        # 1: down to label2
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push16=, 28
	i32.le_s	$push6=, $2, $pop16
	br_if   	0, $pop6        # 0: up to label3
# BB#3:                                 # %for.end
	end_loop
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
