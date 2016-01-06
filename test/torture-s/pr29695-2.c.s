	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr29695-2.c"
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, a($pop0)
	i32.const	$push2=, 128
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
func_end0:
	.size	f1, func_end0-f1

	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load8_s	$push0=, b($0)
	i32.lt_s	$push1=, $pop0, $0
	i32.const	$push2=, 7
	i32.shl 	$push3=, $pop1, $pop2
	return  	$pop3
func_end1:
	.size	f2, func_end1-f2

	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load8_s	$push1=, b($pop0)
	i32.const	$push2=, 31
	i32.shr_s	$push3=, $pop1, $pop2
	i32.const	$push4=, 896
	i32.and 	$push5=, $pop3, $pop4
	return  	$pop5
func_end2:
	.size	f3, func_end2-f3

	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load8_s	$push1=, b($pop0)
	i32.const	$push2=, 31
	i32.shr_s	$push3=, $pop1, $pop2
	i32.const	$push4=, -128
	i32.and 	$push5=, $pop3, $pop4
	return  	$pop5
func_end3:
	.size	f4, func_end3-f4

	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.result 	i64
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, c($0)
	i32.lt_s	$push1=, $pop0, $0
	i64.extend_u/i32	$push2=, $pop1
	i64.const	$push3=, 31
	i64.shl 	$push4=, $pop2, $pop3
	return  	$pop4
func_end4:
	.size	f5, func_end4-f5

	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.result 	i64
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, d($0)
	i32.lt_s	$push1=, $pop0, $0
	i64.extend_u/i32	$push2=, $pop1
	i64.const	$push3=, 31
	i64.shl 	$push4=, $pop2, $pop3
	return  	$pop4
func_end5:
	.size	f6, func_end5-f6

	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.result 	i64
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, d($0)
	i32.lt_s	$push1=, $pop0, $0
	i64.const	$push3=, 15032385536
	i64.const	$push2=, 0
	i64.select	$push4=, $pop1, $pop3, $pop2
	return  	$pop4
func_end6:
	.size	f7, func_end6-f7

	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.result 	i64
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, d($0)
	i32.lt_s	$push1=, $pop0, $0
	i64.const	$push3=, -2147483648
	i64.const	$push2=, 0
	i64.select	$push4=, $pop1, $pop3, $pop2
	return  	$pop4
func_end7:
	.size	f8, func_end7-f8

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB8_8
	i32.load8_u	$push0=, a($0)
	i32.const	$push1=, 7
	i32.shr_u	$push2=, $pop0, $pop1
	i32.const	$push9=, 0
	i32.eq  	$push10=, $pop2, $pop9
	br_if   	$pop10, BB8_8
# BB#1:                                 # %if.end
	block   	BB8_7
	i32.load8_s	$push3=, b($0)
	i32.ge_s	$push4=, $pop3, $0
	br_if   	$pop4, BB8_7
# BB#2:                                 # %if.end12
	block   	BB8_6
	i32.load	$push5=, c($0)
	i32.ge_s	$push6=, $pop5, $0
	br_if   	$pop6, BB8_6
# BB#3:                                 # %if.end16
	block   	BB8_5
	i32.load	$push7=, d($0)
	i32.ge_s	$push8=, $pop7, $0
	br_if   	$pop8, BB8_5
# BB#4:                                 # %if.end28
	return  	$0
BB8_5:                                  # %if.then19
	call    	abort
	unreachable
BB8_6:                                  # %if.then15
	call    	abort
	unreachable
BB8_7:                                  # %if.then3
	call    	abort
	unreachable
BB8_8:                                  # %if.then
	call    	abort
	unreachable
func_end8:
	.size	main, func_end8-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	2
a:
	.int32	128                     # 0x80
	.size	a, 4

	.type	b,@object               # @b
	.globl	b
b:
	.int8	128                     # 0x80
	.size	b, 1

	.type	c,@object               # @c
	.globl	c
	.align	3
c:
	.int64	2147483648              # 0x80000000
	.size	c, 8

	.type	d,@object               # @d
	.globl	d
	.align	2
d:
	.int32	2147483648              # 0x80000000
	.size	d, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
