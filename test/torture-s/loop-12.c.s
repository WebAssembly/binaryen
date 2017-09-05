	.text
	.file	"loop-12.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.load	$1=, p($pop3)
.LBB0_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.load8_u	$push10=, 0($1)
	tee_local	$push9=, $0=, $pop10
	i32.const	$push8=, 10
	i32.eq  	$push0=, $pop9, $pop8
	br_if   	1, $pop0        # 1: down to label0
# BB#2:                                 # %while.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push11=, 33
	i32.eq  	$push1=, $0, $pop11
	br_if   	1, $pop1        # 1: down to label0
# BB#3:                                 # %while.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push12=, 59
	i32.eq  	$push2=, $0, $pop12
	br_if   	1, $pop2        # 1: down to label0
# BB#4:                                 # %while.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push7=, 0
	i32.const	$push6=, 1
	i32.add 	$push5=, $1, $pop6
	tee_local	$push4=, $1=, $pop5
	i32.store	p($pop7), $pop4
	br      	0               # 0: up to label1
.LBB0_5:                                # %while.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, .L.str
.LBB1_1:                                # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	i32.const	$push8=, 0
	i32.store	p($pop8), $1
	i32.load8_u	$push7=, 0($1)
	tee_local	$push6=, $0=, $pop7
	i32.const	$push5=, 10
	i32.eq  	$push0=, $pop6, $pop5
	br_if   	1, $pop0        # 1: down to label2
# BB#2:                                 # %while.cond.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push9=, 33
	i32.eq  	$push1=, $0, $pop9
	br_if   	1, $pop1        # 1: down to label2
# BB#3:                                 # %while.cond.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push10=, 59
	i32.eq  	$push2=, $0, $pop10
	br_if   	1, $pop2        # 1: down to label2
# BB#4:                                 # %while.body.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push4=, 1
	i32.add 	$1=, $1, $pop4
	br      	0               # 0: up to label3
.LBB1_5:                                # %foo.exit
	end_loop
	end_block                       # label2:
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"abc\n"
	.size	.L.str, 5


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
