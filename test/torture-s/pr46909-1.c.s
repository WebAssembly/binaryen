	.text
	.file	"pr46909-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 1
	i32.const	$push12=, 1
	i32.const	$push4=, -1
	i32.const	$push0=, 2
	i32.or  	$push1=, $0, $pop0
	i32.const	$push2=, 6
	i32.ne  	$push3=, $pop1, $pop2
	i32.select	$push6=, $pop12, $pop4, $pop3
	i32.const	$push7=, 4
	i32.or  	$push8=, $0, $pop7
	i32.const	$push11=, 6
	i32.eq  	$push9=, $pop8, $pop11
	i32.select	$push10=, $pop5, $pop6, $pop9
                                        # fallthrough-return: $pop10
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -14
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.const	$push11=, 4
	i32.add 	$push10=, $1, $pop11
	tee_local	$push9=, $0=, $pop10
	i32.call	$push3=, foo@FUNCTION, $pop9
	i32.const	$push8=, 1
	i32.eqz 	$push0=, $1
	i32.const	$push7=, 1
	i32.shl 	$push1=, $pop0, $pop7
	i32.sub 	$push2=, $pop8, $pop1
	i32.ne  	$push4=, $pop3, $pop2
	br_if   	1, $pop4        # 1: down to label0
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push13=, 1
	i32.add 	$1=, $1, $pop13
	i32.const	$push12=, 8
	i32.le_s	$push5=, $0, $pop12
	br_if   	0, $pop5        # 0: up to label1
# BB#3:                                 # %for.end
	end_loop
	i32.const	$push6=, 0
	return  	$pop6
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
