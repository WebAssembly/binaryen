	.text
	.file	"20050613-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 0($0)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push1=, 4($0)
	i32.const	$push2=, 5
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %lor.lhs.false2
	i32.load	$push4=, 8($0)
	br_if   	0, $pop4        # 0: down to label0
# BB#3:                                 # %lor.lhs.false4
	i32.load	$push5=, 12($0)
	br_if   	0, $pop5        # 0: down to label0
# BB#4:                                 # %if.end
	return
.LBB0_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
# BB#0:                                 # %foo.exit28
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
