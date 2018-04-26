	.text
	.file	"pr57861.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.store	c($pop21), $pop20
	i32.const	$push19=, 0
	i32.load16_u	$0=, a($pop19)
	copy_local	$1=, $0
	block   	
	i32.const	$push18=, 0
	i32.load	$push3=, e($pop18)
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push17=, 24
	i32.shr_s	$push2=, $pop1, $pop17
	i32.ge_u	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %if.then.1.i
	i32.const	$push28=, 0
	i32.load	$push7=, d($pop28)
	i32.const	$push27=, 0
	i32.ne  	$push8=, $pop7, $pop27
	i32.const	$push26=, 0
	i32.load	$push5=, h($pop26)
	i32.const	$push25=, 0
	i32.ne  	$push6=, $pop5, $pop25
	i32.and 	$1=, $pop8, $pop6
	i32.const	$push24=, 0
	i32.store16	a($pop24), $1
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.store16	f($pop23), $pop22
.LBB0_2:                                # %foo.exit
	end_block                       # label0:
	i32.const	$push35=, 0
	i32.const	$push9=, 2
	i32.store	c($pop35), $pop9
	i32.const	$push34=, 0
	i32.const	$push10=, 255
	i32.and 	$push11=, $0, $pop10
	i32.const	$push33=, 0
	i32.ne  	$push12=, $pop11, $pop33
	i32.store	i($pop34), $pop12
	i32.const	$push32=, 0
	i32.const	$push31=, 0
	i32.store	j($pop32), $pop31
	i32.const	$push30=, 0
	i32.load	$push13=, g($pop30)
	i32.const	$push29=, 0
	i32.store	0($pop13), $pop29
	block   	
	i32.const	$push14=, 65535
	i32.and 	$push15=, $1, $pop14
	br_if   	0, $pop15       # 0: down to label1
# %bb.3:                                # %if.end
	i32.const	$push16=, 0
	return  	$pop16
.LBB0_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
