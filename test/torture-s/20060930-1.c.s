	.text
	.file	"20060930-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	return  	$1
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push3=, 1
	i32.lt_s	$push4=, $1, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %for.body.lr.ph
	i32.const	$push0=, 0
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i32.sub 	$push2=, $pop11, $0
	i32.const	$push10=, 0
	i32.gt_s	$push1=, $0, $pop10
	i32.select	$push9=, $pop2, $0, $pop1
	tee_local	$push8=, $0=, $pop9
	i32.sub 	$push6=, $pop12, $pop8
	i32.const	$push7=, -1
	i32.gt_s	$push5=, $0, $pop7
	i32.select	$0=, $pop0, $pop6, $pop5
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.call	$drop=, bar@FUNCTION, $1, $0
	i32.const	$push15=, -1
	i32.add 	$push14=, $1, $pop15
	tee_local	$push13=, $1=, $pop14
	br_if   	0, $pop13       # 0: up to label2
.LBB1_3:                                # %for.end
	end_loop
	end_block                       # label1:
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.const	$push2=, 1
	call    	foo@FUNCTION, $pop0, $pop2
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
