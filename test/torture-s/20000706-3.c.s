	.text
	.file	"20000706-3.c"
	.section	.text.baz,"ax",@progbits
	.hidden	baz                     # -- Begin function baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, 0($0)
	i32.store	c($pop1), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	baz, .Lfunc_end0-baz
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push1=, 2
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push3=, 0
	i32.load	$push0=, c($pop3)
	i32.const	$push4=, 1
	i32.ne  	$push5=, $pop0, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end
	return
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	c($pop0), $0
	block   	
	i32.const	$push1=, 1
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push3=, 2
	i32.ne  	$push4=, $1, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#2:                                 # %bar.exit
	return
.LBB2_3:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	c($pop1), $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
