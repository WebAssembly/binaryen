	.text
	.file	"nestfunc-4.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.then
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, level($pop10)
	tee_local	$push8=, $0=, $pop9
	i32.const	$push1=, 2040
	i32.const	$push7=, 2040
	i32.gt_s	$push2=, $0, $pop7
	i32.select	$push3=, $pop8, $pop1, $pop2
	i32.const	$push4=, 1
	i32.add 	$push5=, $pop3, $pop4
	i32.store	level($pop0), $pop5
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
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, level($pop10)
	tee_local	$push8=, $0=, $pop9
	i32.const	$push1=, 2040
	i32.const	$push7=, 2040
	i32.gt_s	$push2=, $0, $pop7
	i32.select	$push3=, $pop8, $pop1, $pop2
	i32.const	$push4=, 1
	i32.add 	$push5=, $pop3, $pop4
	i32.store	level($pop0), $pop5
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
# BB#0:                                 # %entry
	i32.const	$1=, -42
	block   	
	i32.const	$push0=, 0
	i32.load	$push5=, level($pop0)
	tee_local	$push4=, $0=, $pop5
	i32.const	$push1=, 2040
	i32.gt_s	$push2=, $pop4, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %cond.false
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
