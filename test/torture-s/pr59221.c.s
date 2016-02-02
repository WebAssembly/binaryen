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
	i32.const	$push14=, 0
	i32.load	$push0=, b($pop14)
	i32.const	$push24=, 0
	i32.eq  	$push25=, $pop0, $pop24
	br_if   	$pop25, 0       # 0: down to label0
# BB#1:                                 # %for.inc.preheader
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.store	$discard=, b($pop16), $pop15
.LBB0_2:                                # %for.end
	end_block                       # label0:
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.const	$push21=, 0
	i32.load	$push1=, a($pop21)
	tee_local	$push20=, $0=, $pop1
	i32.const	$push5=, 65535
	i32.and 	$push6=, $pop20, $pop5
	i32.const	$push2=, 16
	i32.shl 	$push3=, $0, $pop2
	i32.const	$push19=, 16
	i32.shr_s	$push4=, $pop3, $pop19
	i32.const	$push7=, -32768
	i32.select	$push8=, $pop6, $pop4, $pop7
	tee_local	$push18=, $0=, $pop8
	i32.store16	$push10=, e($pop22), $pop18
	i32.store	$discard=, d($pop23), $pop10
	block
	i32.const	$push17=, 65535
	i32.and 	$push9=, $0, $pop17
	i32.const	$push11=, 1
	i32.ne  	$push12=, $pop9, $pop11
	br_if   	$pop12, 0       # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push13=, 0
	return  	$pop13
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
