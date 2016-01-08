	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59221.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load	$push0=, b($0)
	i32.const	$push9=, 0
	i32.eq  	$push10=, $pop0, $pop9
	br_if   	$pop10, .LBB0_2
# BB#1:                                 # %for.inc.preheader
	i32.store	$discard=, b($0), $0
.LBB0_2:                                # %for.end
	i32.load	$1=, a($0)
	i32.const	$2=, 16
	i32.const	$3=, 65535
	block   	.LBB0_4
	i32.and 	$push3=, $1, $3
	i32.shl 	$push1=, $1, $2
	i32.shr_s	$push2=, $pop1, $2
	i32.const	$push4=, -32768
	i32.select	$1=, $pop3, $pop2, $pop4
	i32.store16	$push6=, e($0), $1
	i32.store	$discard=, d($0), $pop6
	i32.and 	$push5=, $1, $3
	i32.const	$push7=, 1
	i32.ne  	$push8=, $pop5, $pop7
	br_if   	$pop8, .LBB0_4
# BB#3:                                 # %if.end
	return  	$0
.LBB0_4:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.align	2
a:
	.int32	1                       # 0x1
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.align	1
e:
	.int16	0                       # 0x0
	.size	e, 2

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
