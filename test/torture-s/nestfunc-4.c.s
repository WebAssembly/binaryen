	.text
	.file	"nestfunc-4.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %if.then
	i32.const	$push0=, 0
	i32.load	$0=, level($pop0)
	i32.const	$push8=, 0
	i32.const	$push1=, 1024
	i32.const	$push7=, 1024
	i32.gt_s	$push2=, $0, $pop7
	i32.select	$push3=, $0, $pop1, $pop2
	i32.const	$push4=, 1
	i32.add 	$push5=, $pop3, $pop4
	i32.store	level($pop8), $pop5
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$0=, level($pop0)
	i32.const	$push8=, 0
	i32.const	$push1=, 1024
	i32.const	$push7=, 1024
	i32.gt_s	$push2=, $0, $pop7
	i32.select	$push3=, $0, $pop1, $pop2
	i32.const	$push4=, 1
	i32.add 	$push5=, $pop3, $pop4
	i32.store	level($pop8), $pop5
	i32.const	$push6=, -42
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$0=, level($pop0)
	i32.const	$1=, -42
	block   	
	i32.const	$push1=, 1024
	i32.gt_s	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %cond.false
	i32.call	$1=, foo@FUNCTION
.LBB2_2:                                # %cond.end
	end_block                       # label0:
	i32.sub 	$push3=, $1, $0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar
                                        # -- End function
	.hidden	level                   # @level
	.type	level,@object
	.section	.bss.level,"aw",@nobits
	.globl	level
	.p2align	2
level:
	.int32	0                       # 0x0
	.size	level, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
