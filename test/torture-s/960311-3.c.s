	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/960311-3.c"
	.globl	a1
	.type	a1,@function
a1:                                     # @a1
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, count($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, count($0), $pop2
	return
func_end0:
	.size	a1, func_end0-a1

	.globl	b
	.type	b,@function
b:                                      # @b
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	BB1_2
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	br_if   	$pop1, BB1_2
# BB#1:                                 # %if.then
	i32.const	$1=, 0
	i32.load	$push2=, count($1)
	i32.const	$push3=, 1
	i32.add 	$push4=, $pop2, $pop3
	i32.store	$discard=, count($1), $pop4
BB1_2:                                  # %if.end
	block   	BB1_4
	i32.const	$push5=, 1073741824
	i32.and 	$push6=, $0, $pop5
	i32.const	$push15=, 0
	i32.eq  	$push16=, $pop6, $pop15
	br_if   	$pop16, BB1_4
# BB#3:                                 # %if.then3
	i32.const	$1=, 0
	i32.load	$push7=, count($1)
	i32.const	$push8=, 1
	i32.add 	$push9=, $pop7, $pop8
	i32.store	$discard=, count($1), $pop9
BB1_4:                                  # %if.end4
	block   	BB1_6
	i32.const	$push10=, 536870912
	i32.and 	$push11=, $0, $pop10
	i32.const	$push17=, 0
	i32.eq  	$push18=, $pop11, $pop17
	br_if   	$pop18, BB1_6
# BB#5:                                 # %if.then8
	i32.const	$0=, 0
	i32.load	$push12=, count($0)
	i32.const	$push13=, 1
	i32.add 	$push14=, $pop12, $pop13
	i32.store	$discard=, count($0), $pop14
BB1_6:                                  # %if.end9
	return
func_end1:
	.size	b, func_end1-b

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end21
	i32.const	$0=, 0
	i32.const	$push0=, 3
	i32.store	$discard=, count($0), $pop0
	call    	exit, $0
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	count,@object           # @count
	.bss
	.globl	count
	.align	2
count:
	.int32	0                       # 0x0
	.size	count, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
