	.text
	.file	"pr34768-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, x($pop4)
	i32.sub 	$push2=, $pop5, $pop1
	i32.store	x($pop0), $pop2
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
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
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.load	$push4=, x($pop3)
	i32.const	$push1=, foo@FUNCTION
	i32.const	$push0=, bar@FUNCTION
	i32.select	$push2=, $pop1, $pop0, $0
	i32.call_indirect	$push5=, $pop2
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push9=, 0
	i32.load	$push7=, x($pop9)
	i32.add 	$push8=, $pop6, $pop7
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end2:
	.size	test, .Lfunc_end2-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.const	$push0=, 1
	i32.store	x($pop3), $pop0
	block   	
	i32.const	$push2=, 1
	i32.call	$push1=, test@FUNCTION, $pop2
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB3_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.int32	0                       # 0x0
	.size	x, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
