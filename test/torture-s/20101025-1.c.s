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
	i32.store	$drop=, g_3($pop0), $0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f2, .Lfunc_end0-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, g_6($pop0)
	i32.const	$push2=, 1
	i32.store	$drop=, 0($pop1), $pop2
	i32.const	$push5=, 0
	i32.load	$push3=, g_7($pop5)
	call    	f2@FUNCTION, $pop3
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end1:
	.size	f3, .Lfunc_end1-f3

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.call	$drop=, f3@FUNCTION
	block
	i32.const	$push3=, 0
	i32.load	$push0=, g_3($pop3)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
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
	.p2align	2
g_3:
	.int32	0                       # 0x0
	.size	g_3, 4

	.type	g_6,@object             # @g_6
	.section	.data.g_6,"aw",@progbits
	.p2align	2
g_6:
	.int32	g_7
	.size	g_6, 4

	.type	g_7,@object             # @g_7
	.lcomm	g_7,4,2

	.ident	"clang version 3.9.0 "
