	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr29695-2.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
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
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
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
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
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
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
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
	.endfunc
.Lfunc_end3:
	.size	f4, .Lfunc_end3-f4

	.section	.text.f5,"ax",@progbits
	.hidden	f5
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
	.endfunc
.Lfunc_end4:
	.size	f5, .Lfunc_end4-f5

	.section	.text.f6,"ax",@progbits
	.hidden	f6
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
	.endfunc
.Lfunc_end5:
	.size	f6, .Lfunc_end5-f6

	.section	.text.f7,"ax",@progbits
	.hidden	f7
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
	.endfunc
.Lfunc_end6:
	.size	f7, .Lfunc_end6-f7

	.section	.text.f8,"ax",@progbits
	.hidden	f8
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
	.endfunc
.Lfunc_end7:
	.size	f8, .Lfunc_end7-f8

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load8_u	$push0=, a($0)
	i32.const	$push1=, 7
	i32.shr_u	$push2=, $pop0, $pop1
	i32.const	$push9=, 0
	i32.eq  	$push10=, $pop2, $pop9
	br_if   	$pop10, 0       # 0: down to label0
# BB#1:                                 # %if.end
	block
	i32.load8_s	$push3=, b($0)
	i32.ge_s	$push4=, $pop3, $0
	br_if   	$pop4, 0        # 0: down to label1
# BB#2:                                 # %if.end12
	block
	i32.load	$push5=, c($0)
	i32.ge_s	$push6=, $pop5, $0
	br_if   	$pop6, 0        # 0: down to label2
# BB#3:                                 # %if.end16
	block
	i32.load	$push7=, d($0)
	i32.ge_s	$push8=, $pop7, $0
	br_if   	$pop8, 0        # 0: down to label3
# BB#4:                                 # %if.end28
	return  	$0
.LBB8_5:                                # %if.then19
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB8_6:                                # %if.then15
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB8_7:                                # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB8_8:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end8:
	.size	main, .Lfunc_end8-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.align	2
a:
	.int32	128                     # 0x80
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
b:
	.int8	128                     # 0x80
	.size	b, 1

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.align	3
c:
	.int64	2147483648              # 0x80000000
	.size	c, 8

	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.align	2
d:
	.int32	2147483648              # 0x80000000
	.size	d, 4


	.ident	"clang version 3.9.0 "
