	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960218-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.store	$discard=, glob($1), $0
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, -1
	block
	i32.eq  	$push0=, $0, $1
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %while.cond.while.end_crit_edge
	i32.const	$push2=, 0
	i32.xor 	$push1=, $0, $1
	i32.store	$discard=, glob($pop2), $pop1
.LBB1_2:                                # %while.end
	end_block                       # label0:
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, -4
	i32.store	$discard=, glob($0), $pop0
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	glob                    # @glob
	.type	glob,@object
	.section	.bss.glob,"aw",@nobits
	.globl	glob
	.align	2
glob:
	.int32	0                       # 0x0
	.size	glob, 4


	.ident	"clang version 3.9.0 "
