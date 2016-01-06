	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/bf-sign-2.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i64.load	$0=, x($1)
	i32.const	$2=, 7
	i32.const	$3=, -2
	block   	BB0_2
	i32.wrap/i64	$push0=, $0
	i32.and 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $3
	i32.lt_s	$push3=, $pop2, $1
	br_if   	$pop3, BB0_2
# BB#1:                                 # %if.then
	call    	abort
	unreachable
BB0_2:                                  # %if.end
	block   	BB0_4
	i64.const	$push4=, 31
	i64.shr_u	$push5=, $0, $pop4
	i32.wrap/i64	$push6=, $pop5
	i32.const	$push7=, 1
	i32.shr_s	$push8=, $pop6, $pop7
	i32.add 	$push9=, $pop8, $3
	i32.lt_s	$push10=, $pop9, $1
	br_if   	$pop10, BB0_4
# BB#3:                                 # %if.then4
	call    	abort
	unreachable
BB0_4:                                  # %if.end5
	i64.load	$0=, x+8($1)
	block   	BB0_6
	i32.wrap/i64	$push11=, $0
	i32.add 	$push12=, $pop11, $3
	i32.lt_s	$push13=, $pop12, $1
	br_if   	$pop13, BB0_6
# BB#5:                                 # %if.then12
	call    	abort
	unreachable
BB0_6:                                  # %if.end13
	block   	BB0_8
	i64.load	$push14=, x+24($1)
	i64.const	$push15=, 35
	i64.shr_u	$push16=, $pop14, $pop15
	i32.wrap/i64	$push17=, $pop16
	i32.const	$push18=, 32767
	i32.and 	$push19=, $pop17, $pop18
	i32.add 	$push20=, $pop19, $3
	i32.lt_s	$push21=, $pop20, $1
	br_if   	$pop21, BB0_8
# BB#7:                                 # %if.then19
	call    	abort
	unreachable
BB0_8:                                  # %if.end20
	block   	BB0_10
	i64.const	$push22=, 32
	i64.shr_u	$push23=, $0, $pop22
	i32.wrap/i64	$push24=, $pop23
	i32.const	$push25=, 2147483647
	i32.and 	$push26=, $pop24, $pop25
	i32.add 	$push27=, $pop26, $3
	i32.lt_s	$push28=, $pop27, $1
	br_if   	$pop28, BB0_10
# BB#9:                                 # %if.then27
	call    	abort
	unreachable
BB0_10:                                 # %if.end35
	block   	BB0_12
	i32.load	$push29=, x+20($1)
	i32.and 	$push30=, $pop29, $2
	i32.add 	$push31=, $pop30, $3
	i32.lt_s	$push32=, $pop31, $1
	br_if   	$pop32, BB0_12
# BB#11:                                # %if.then42
	call    	abort
	unreachable
BB0_12:                                 # %if.end50
	call    	exit, $1
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	x,@object               # @x
	.bss
	.globl	x
	.align	3
x:
	.zero	32
	.size	x, 32


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
