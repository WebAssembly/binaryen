	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010106-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 2
	i32.add 	$0=, $0, $1
	block   	BB0_2
	i32.const	$push0=, 7
	i32.ge_u	$push1=, $0, $pop0
	br_if   	$pop1, BB0_2
# BB#1:                                 # %switch.lookup
	i32.const	$push3=, switch.table
	i32.shl 	$push2=, $0, $1
	i32.add 	$push4=, $pop3, $pop2
	i32.load	$push5=, 0($pop4)
	return  	$pop5
BB0_2:                                  # %sw.default
	call    	abort
	unreachable
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	switch.table,@object    # @switch.table
	.section	.rodata,"a",@progbits
	.align	4
switch.table:
	.int32	33                      # 0x21
	.int32	0                       # 0x0
	.int32	7                       # 0x7
	.int32	4                       # 0x4
	.int32	3                       # 0x3
	.int32	15                      # 0xf
	.int32	9                       # 0x9
	.size	switch.table, 28


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
