	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57861.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.store	c($pop26), $pop25
	block   	
	i32.const	$push24=, 0
	i32.load	$push11=, e($pop24)
	i32.const	$push5=, -1
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.load16_u	$push21=, a($pop22)
	tee_local	$push20=, $1=, $pop21
	i32.const	$push4=, 255
	i32.and 	$push19=, $pop20, $pop4
	tee_local	$push18=, $0=, $pop19
	i32.select	$push6=, $pop5, $pop23, $pop18
	i32.const	$push7=, 24
	i32.shl 	$push8=, $1, $pop7
	i32.const	$push17=, 24
	i32.shr_s	$push9=, $pop8, $pop17
	i32.and 	$push10=, $pop6, $pop9
	i32.ge_u	$push12=, $pop11, $pop10
	br_if   	0, $pop12       # 0: down to label0
# BB#1:                                 # %if.then.i.1
	i32.const	$push35=, 0
	i32.const	$push34=, 0
	i32.load	$push2=, d($pop34)
	i32.const	$push33=, 0
	i32.ne  	$push3=, $pop2, $pop33
	i32.const	$push32=, 0
	i32.load	$push0=, h($pop32)
	i32.const	$push31=, 0
	i32.ne  	$push1=, $pop0, $pop31
	i32.and 	$push30=, $pop3, $pop1
	tee_local	$push29=, $1=, $pop30
	i32.store16	a($pop35), $pop29
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.store16	f($pop28), $pop27
.LBB0_2:                                # %for.inc.i.1
	end_block                       # label0:
	i32.const	$push42=, 0
	i32.const	$push13=, 2
	i32.store	c($pop42), $pop13
	i32.const	$push41=, 0
	i32.const	$push40=, 0
	i32.ne  	$push14=, $0, $pop40
	i32.store	i($pop41), $pop14
	i32.const	$push39=, 0
	i32.const	$push38=, 0
	i32.store	j($pop39), $pop38
	i32.const	$push37=, 0
	i32.load	$push15=, g($pop37)
	i32.const	$push36=, 0
	i32.store	0($pop15), $pop36
	block   	
	br_if   	0, $1           # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push16=, 0
	return  	$pop16
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
	.p2align	1
a:
	.int16	1                       # 0x1
	.size	a, 2

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.data.g,"aw",@progbits
	.globl	g
	.p2align	2
g:
	.int32	b
	.size	g, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	1
f:
	.int16	0                       # 0x0
	.size	f, 2

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.p2align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.p2align	2
j:
	.int32	0                       # 0x0
	.size	j, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
