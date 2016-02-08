	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041210-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	block
	i32.const	$push13=, 0
	i64.load	$push0=, x($pop13):p2align=4
	tee_local	$push12=, $0=, $pop0
	i32.wrap/i64	$push1=, $pop12
	i64.const	$push11=, 32
	i64.shr_u	$push2=, $0, $pop11
	i32.wrap/i64	$push3=, $pop2
	i32.ge_s	$push4=, $pop1, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push16=, 0
	i64.load	$push5=, x+8($pop16)
	tee_local	$push15=, $0=, $pop5
	i64.const	$push14=, 32
	i64.shr_u	$push6=, $pop15, $pop14
	i64.and 	$push7=, $pop6, $0
	i32.wrap/i64	$push8=, $pop7
	i32.const	$push9=, -1
	i32.gt_s	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB0_3:                                # %if.end3
	end_block                       # label0:
	i32.const	$push17=, 0
	call    	exit@FUNCTION, $pop17
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	4
x:
	.int32	3221225472              # 0xc0000000
	.int32	2147483647              # 0x7fffffff
	.int32	2                       # 0x2
	.int32	4                       # 0x4
	.size	x, 16


	.ident	"clang version 3.9.0 "
