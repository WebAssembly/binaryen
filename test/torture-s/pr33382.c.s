	.text
	.file	"pr33382.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	x+4($pop1), $pop0
	i32.const	$push3=, 0
	i32.load	$push2=, x+8($pop3)
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
	i32.const	$push3=, 0
	i32.const	$push0=, 1
	i32.store	x+4($pop3), $pop0
	block   	
	i32.const	$push2=, 0
	i32.load	$push1=, x+8($pop2)
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	2
x:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	0                       # 0x0
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.size	x, 20


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
