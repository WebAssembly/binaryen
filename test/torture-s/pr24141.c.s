	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr24141.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, i($pop0), $pop1
	return
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push2=, 0
	i32.eq  	$push3=, $0, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %entry
	br_if   	$1, 0           # 0: down to label0
# BB#2:                                 # %if.then10
	i32.const	$push0=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, i($pop0), $pop1
.LBB1_3:                                # %cleanup
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, i($pop1), $pop0
	i32.const	$push2=, 0
	return  	$pop2
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 3.9.0 "
