	.text
	.file	"20000801-2.c"
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push3=, $0
	br_if   	0, $pop3        # 0: down to label0
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load	$push2=, 0($0)
	tee_local	$push1=, $0=, $pop2
	br_if   	0, $pop1        # 0: up to label1
.LBB0_2:                                # %while.end
	end_loop
	end_block                       # label0:
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.baz,"ax",@progbits
	.hidden	baz                     # -- Begin function baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz
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
	i32.sub 	$push11=, $pop2, $pop4
	tee_local	$push10=, $0=, $pop11
	i32.store	__stack_pointer($pop5), $pop10
	i32.const	$push0=, 0
	i32.store	8($0), $pop0
	i32.const	$push6=, 8
	i32.add 	$push7=, $0, $pop6
	i32.store	12($0), $pop7
	i32.const	$push8=, 12
	i32.add 	$push9=, $0, $pop8
	copy_local	$0=, $pop9
.LBB3_1:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.load	$push13=, 0($0)
	tee_local	$push12=, $0=, $pop13
	br_if   	0, $pop12       # 0: up to label2
# BB#2:                                 # %if.end
	end_loop
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
