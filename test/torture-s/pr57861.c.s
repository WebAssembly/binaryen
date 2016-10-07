	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57861.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.store	c($pop23), $pop22
	i32.const	$push21=, 0
	i32.load16_u	$push20=, a($pop21)
	tee_local	$push19=, $0=, $pop20
	copy_local	$1=, $pop19
	block   	
	i32.const	$push18=, 0
	i32.load	$push7=, e($pop18)
	i32.const	$push4=, 24
	i32.shl 	$push5=, $0, $pop4
	i32.const	$push17=, 24
	i32.shr_s	$push6=, $pop5, $pop17
	i32.ge_u	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %if.then.i.1
	i32.const	$push32=, 0
	i32.const	$push31=, 0
	i32.load	$push2=, d($pop31)
	i32.const	$push30=, 0
	i32.ne  	$push3=, $pop2, $pop30
	i32.const	$push29=, 0
	i32.load	$push0=, h($pop29)
	i32.const	$push28=, 0
	i32.ne  	$push1=, $pop0, $pop28
	i32.and 	$push27=, $pop3, $pop1
	tee_local	$push26=, $1=, $pop27
	i32.store16	a($pop32), $pop26
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.store16	f($pop25), $pop24
.LBB0_2:                                # %for.inc.i.1
	end_block                       # label0:
	i32.const	$push39=, 0
	i32.const	$push9=, 2
	i32.store	c($pop39), $pop9
	i32.const	$push38=, 0
	i32.const	$push10=, 255
	i32.and 	$push11=, $0, $pop10
	i32.const	$push37=, 0
	i32.ne  	$push12=, $pop11, $pop37
	i32.store	i($pop38), $pop12
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.store	j($pop36), $pop35
	i32.const	$push34=, 0
	i32.load	$push13=, g($pop34)
	i32.const	$push33=, 0
	i32.store	0($pop13), $pop33
	block   	
	i32.const	$push14=, 65535
	i32.and 	$push15=, $1, $pop14
	br_if   	0, $pop15       # 0: down to label1
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
