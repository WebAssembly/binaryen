	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990130-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.load	$0=, dummy($pop7)
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.load	$push4=, count($pop5)
	tee_local	$push3=, $1=, $pop4
	i32.const	$push0=, 1
	i32.add 	$push1=, $pop3, $pop0
	i32.store	$discard=, count($pop6), $pop1
	#APP
	#NO_APP
	i32.const	$push2=, 0
	i32.store	$discard=, dummy($pop2), $0
	block
	br_if   	0, $1           # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	count                   # @count
	.type	count,@object
	.section	.bss.count,"aw",@nobits
	.globl	count
	.p2align	2
count:
	.int32	0                       # 0x0
	.size	count, 4

	.hidden	dummy                   # @dummy
	.type	dummy,@object
	.section	.bss.dummy,"aw",@nobits
	.globl	dummy
	.p2align	2
dummy:
	.int32	0                       # 0x0
	.size	dummy, 4


	.ident	"clang version 3.9.0 "
