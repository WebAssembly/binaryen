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
	i32.const	$push13=, 0
	i32.load	$push2=, b($pop13)
	i32.eqz 	$push22=, $pop2
	br_if   	0, $pop22       # 0: down to label0
# BB#1:                                 # %for.inc.preheader
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i32.store	$drop=, b($pop15), $pop14
.LBB0_2:                                # %for.end
	end_block                       # label0:
	block
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.const	$push19=, 0
	i32.load	$push18=, a($pop19)
	tee_local	$push17=, $0=, $pop18
	i32.const	$push5=, 16
	i32.shl 	$push6=, $pop17, $pop5
	i32.const	$push16=, 16
	i32.shr_s	$push7=, $pop6, $pop16
	i32.const	$push8=, -32768
	i32.const	$push3=, 65535
	i32.and 	$push4=, $0, $pop3
	i32.select	$push9=, $pop7, $pop8, $pop4
	i32.store16	$push0=, e($pop20), $pop9
	i32.store	$push1=, d($pop21), $pop0
	i32.const	$push10=, 1
	i32.ne  	$push11=, $pop1, $pop10
	br_if   	0, $pop11       # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push12=, 0
	return  	$pop12
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
