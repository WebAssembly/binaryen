	.text
	.file	"pr47925.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
                                        # fallthrough-return
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
	.result 	i32
# BB#0:                                 # %entry
	call    	bar@FUNCTION, $1, $1
	block   	
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.preheader
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load	$0=, 0($0)
	i32.const	$push4=, -1
	i32.add 	$push3=, $1, $pop4
	tee_local	$push2=, $1=, $pop3
	br_if   	0, $pop2        # 0: up to label1
.LBB1_3:                                # %for.end
	end_loop
	end_block                       # label0:
	copy_local	$push5=, $1
                                        # fallthrough-return: $pop5
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$push14=, $pop2, $pop4
	tee_local	$push13=, $0=, $pop14
	i32.store	__stack_pointer($pop5), $pop13
	i32.const	$push9=, 8
	i32.add 	$push10=, $0, $pop9
	i32.store	8($0), $pop10
	i32.const	$push11=, 8
	i32.add 	$push12=, $0, $pop11
	i32.const	$push0=, 10
	i32.call	$drop=, foo@FUNCTION, $pop12, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.store	__stack_pointer($pop8), $pop7
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
