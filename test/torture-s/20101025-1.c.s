	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20101025-1.c"
	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$discard=, g_3($pop0), $0
	return
	.endfunc
.Lfunc_end0:
	.size	f2, .Lfunc_end0-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, g_6($0)
	i32.const	$push1=, 1
	i32.store	$discard=, 0($pop0), $pop1
	i32.load	$push2=, g_7($0)
	call    	f2@FUNCTION, $pop2
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	f3, .Lfunc_end1-f3

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.call	$discard=, f3@FUNCTION
	i32.const	$0=, 0
	block
	i32.load	$push0=, g_3($0)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.end
	call    	exit@FUNCTION, $0
	unreachable
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	g_3                     # @g_3
	.type	g_3,@object
	.section	.bss.g_3,"aw",@nobits
	.globl	g_3
	.align	2
g_3:
	.int32	0                       # 0x0
	.size	g_3, 4

	.type	g_6,@object             # @g_6
	.section	.data.g_6,"aw",@progbits
	.align	2
g_6:
	.int32	g_7
	.size	g_6, 4

	.type	g_7,@object             # @g_7
	.lcomm	g_7,4,2

	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
