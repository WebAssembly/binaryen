	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59747.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.load	$push2=, a($pop1)
	return  	$pop2
	.endfunc
.Lfunc_end0:
	.size	fn1, .Lfunc_end0-fn1

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.load	$0=, c($pop15)
	i32.const	$push14=, 0
	i32.load16_u	$1=, e($pop14)
	i32.const	$push13=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, a($pop13), $pop0
	block
	i32.const	$push19=, 0
	i32.eq  	$push20=, $0, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push1=, -1
	i32.add 	$1=, $1, $pop1
	i32.const	$push16=, 0
	i32.store16	$discard=, e($pop16), $1
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push18=, 0
	i32.const	$push2=, 16
	i32.shl 	$push3=, $1, $pop2
	i32.const	$push17=, 16
	i32.shr_s	$push4=, $pop3, $pop17
	i32.store	$discard=, d($pop18), $pop4
	block
	i64.extend_u/i32	$push5=, $1
	i64.const	$push6=, 48
	i64.shl 	$push7=, $pop5, $pop6
	i64.const	$push8=, 63
	i64.shr_u	$push9=, $pop7, $pop8
	i32.wrap/i64	$push10=, $pop9
	i32.call	$push11=, fn1@FUNCTION, $pop10
	br_if   	0, $pop11       # 0: down to label1
# BB#3:                                 # %if.end5
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
.LBB1_4:                                # %if.then4
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	2
c:
	.int32	1                       # 0x1
	.size	c, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	24
	.size	a, 24

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	1
e:
	.int16	0                       # 0x0
	.size	e, 2

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4


	.ident	"clang version 3.9.0 "
