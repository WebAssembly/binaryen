	.text
	.file	"pr44164.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($0)
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.store	a($pop0), $pop3
	i32.load	$push1=, 0($0)
	i32.add 	$push2=, $1, $pop1
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
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push0=, 1
	i32.store	a($pop5), $pop0
	block   	
	i32.const	$push1=, a
	i32.call	$push2=, foo@FUNCTION, $pop1
	i32.const	$push4=, 1
	i32.ne  	$push3=, $pop2, $pop4
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	4
	.size	a, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
