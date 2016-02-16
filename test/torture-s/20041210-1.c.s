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
	i32.const	$push12=, 0
	i64.load	$push11=, x($pop12):p2align=4
	tee_local	$push10=, $0=, $pop11
	i32.wrap/i64	$push0=, $pop10
	i64.const	$push9=, 32
	i64.shr_u	$push1=, $0, $pop9
	i32.wrap/i64	$push2=, $pop1
	i32.ge_s	$push3=, $pop0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push16=, 0
	i64.load	$push15=, x+8($pop16)
	tee_local	$push14=, $0=, $pop15
	i64.const	$push13=, 32
	i64.shr_u	$push4=, $pop14, $pop13
	i64.and 	$push5=, $pop4, $0
	i32.wrap/i64	$push6=, $pop5
	i32.const	$push7=, -1
	i32.gt_s	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
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
