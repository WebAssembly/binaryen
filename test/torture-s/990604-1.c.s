	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990604-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load	$push0=, b($0)
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %do.body.preheader
	i32.const	$push1=, 9
	i32.store	$discard=, b($0), $pop1
.LBB0_2:                                # %if.end
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$0=, b($1)
	i32.const	$2=, 9
	block
	i32.eq  	$push0=, $0, $2
	br_if   	$pop0, 0        # 0: down to label1
# BB#1:                                 # %entry
	block
	br_if   	$0, 0           # 0: down to label2
# BB#2:                                 # %f.exit.thread
	i32.store	$discard=, b($1), $2
	br      	1               # 1: down to label1
.LBB1_3:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %if.end
	end_block                       # label1:
	return  	$1
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
