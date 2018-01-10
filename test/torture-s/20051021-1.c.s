	.text
	.file	"20051021-1.c"
	.section	.text.foo1,"ax",@progbits
	.hidden	foo1                    # -- Begin function foo1
	.globl	foo1
	.type	foo1,@function
foo1:                                   # @foo1
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, count($pop5)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	count($pop0), $pop3
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	foo1, .Lfunc_end0-foo1
                                        # -- End function
	.section	.text.foo2,"ax",@progbits
	.hidden	foo2                    # -- Begin function foo2
	.globl	foo2
	.type	foo2,@function
foo2:                                   # @foo2
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, count($pop5)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	count($pop0), $pop3
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end1:
	.size	foo2, .Lfunc_end1-foo2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push3=, 0
	i32.load	$0=, count($pop3)
	i32.const	$push2=, 0
	i32.const	$push0=, 2
	i32.add 	$push1=, $0, $pop0
	i32.store	count($pop2), $pop1
	block   	
	br_if   	0, $0           # 0: down to label0
# %bb.1:                                # %if.end7
	i32.const	$push4=, 0
	return  	$pop4
.LBB2_2:                                # %if.then6
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	count                   # @count
	.type	count,@object
	.section	.bss.count,"aw",@nobits
	.globl	count
	.p2align	2
count:
	.int32	0                       # 0x0
	.size	count, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
