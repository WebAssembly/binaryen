	.text
	.file	"loop-12.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push3=, 0
	i32.load	$1=, p($pop3)
.LBB0_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.load8_u	$0=, 0($1)
	i32.const	$push6=, 10
	i32.eq  	$push0=, $0, $pop6
	br_if   	1, $pop0        # 1: down to label0
# %bb.2:                                # %while.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push7=, 33
	i32.eq  	$push1=, $0, $pop7
	br_if   	1, $pop1        # 1: down to label0
# %bb.3:                                # %while.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push8=, 59
	i32.eq  	$push2=, $0, $pop8
	br_if   	1, $pop2        # 1: down to label0
# %bb.4:                                # %while.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push5=, 1
	i32.add 	$1=, $1, $pop5
	i32.const	$push4=, 0
	i32.store	p($pop4), $1
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
# %bb.0:                                # %entry
	i32.const	$1=, .L.str
.LBB1_1:                                # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	i32.const	$push6=, 0
	i32.store	p($pop6), $1
	i32.load8_u	$0=, 0($1)
	i32.const	$push5=, 10
	i32.eq  	$push0=, $0, $pop5
	br_if   	1, $pop0        # 1: down to label2
# %bb.2:                                # %while.cond.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push7=, 33
	i32.eq  	$push1=, $0, $pop7
	br_if   	1, $pop1        # 1: down to label2
# %bb.3:                                # %while.cond.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push8=, 59
	i32.eq  	$push2=, $0, $pop8
	br_if   	1, $pop2        # 1: down to label2
# %bb.4:                                # %while.body.i
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
