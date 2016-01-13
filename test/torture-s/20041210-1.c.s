	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041210-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i64.load	$1=, x($0)
	i64.const	$2=, 32
	block
	i32.wrap/i64	$push0=, $1
	i64.shr_u	$push1=, $1, $2
	i32.wrap/i64	$push2=, $pop1
	i32.ge_s	$push3=, $pop0, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.then
	i64.load	$1=, x+8($0)
	i64.shr_u	$push4=, $1, $2
	i64.and 	$push5=, $pop4, $1
	i32.wrap/i64	$push6=, $pop5
	i32.const	$push7=, -1
	i32.gt_s	$push8=, $pop6, $pop7
	br_if   	$pop8, 0        # 0: down to label0
# BB#2:                                 # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB0_3:                                # %if.end3
	end_block                       # label0:
	call    	exit@FUNCTION, $0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.align	4
x:
	.int32	3221225472              # 0xc0000000
	.int32	2147483647              # 0x7fffffff
	.int32	2                       # 0x2
	.int32	4                       # 0x4
	.size	x, 16


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
