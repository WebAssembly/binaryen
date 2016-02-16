	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59221.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push12=, 0
	i32.load	$push0=, b($pop12)
	i32.const	$push24=, 0
	i32.eq  	$push25=, $pop0, $pop24
	br_if   	0, $pop25       # 0: down to label0
# BB#1:                                 # %for.inc.preheader
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i32.store	$discard=, b($pop14), $pop13
.LBB0_2:                                # %for.end
	end_block                       # label0:
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.const	$push21=, 0
	i32.load	$push20=, a($pop21)
	tee_local	$push19=, $0=, $pop20
	i32.const	$push1=, 16
	i32.shl 	$push2=, $pop19, $pop1
	i32.const	$push18=, 16
	i32.shr_s	$push3=, $pop2, $pop18
	i32.const	$push6=, -32768
	i32.const	$push4=, 65535
	i32.and 	$push5=, $0, $pop4
	i32.select	$push17=, $pop3, $pop6, $pop5
	tee_local	$push16=, $0=, $pop17
	i32.store16	$push8=, e($pop22), $pop16
	i32.store	$discard=, d($pop23), $pop8
	block
	i32.const	$push15=, 65535
	i32.and 	$push7=, $0, $pop15
	i32.const	$push9=, 1
	i32.ne  	$push10=, $pop7, $pop9
	br_if   	0, $pop10       # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push11=, 0
	return  	$pop11
.LBB0_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	1                       # 0x1
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

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
