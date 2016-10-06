	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr63659.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push8=, 0
	i32.load	$push0=, a($pop8)
	i32.eqz 	$push23=, $pop0
	br_if   	0, $pop23       # 0: down to label0
# BB#1:                                 # %for.cond
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.store	a($pop10), $pop9
.LBB0_2:                                # %while.end
	end_block                       # label0:
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i32.load8_s	$push2=, c($pop14)
	i32.const	$push13=, 0
	i32.load	$push1=, h($pop13)
	i32.shr_s	$push12=, $pop2, $pop1
	tee_local	$push11=, $0=, $pop12
	i32.store	g($pop15), $pop11
	i32.const	$1=, 255
	block   	
	i32.eqz 	$push24=, $0
	br_if   	0, $pop24       # 0: down to label1
# BB#3:                                 # %cond.false
	i32.const	$push3=, -1
	i32.rem_s	$1=, $pop3, $0
.LBB0_4:                                # %cond.end
	end_block                       # label1:
	i32.const	$push21=, 0
	i32.load	$push5=, d($pop21)
	i32.const	$push20=, 255
	i32.and 	$push4=, $1, $pop20
	i32.store	0($pop5), $pop4
	i32.const	$push19=, 0
	i32.store8	e($pop19), $1
	i32.const	$push18=, 0
	i32.store8	f($pop18), $1
	block   	
	i32.const	$push17=, 0
	i32.load	$push6=, b($pop17)
	i32.const	$push16=, 255
	i32.ne  	$push7=, $pop6, $pop16
	br_if   	0, $pop7        # 0: down to label2
# BB#5:                                 # %if.end23
	i32.const	$push22=, 0
	return  	$pop22
.LBB0_6:                                # %if.then22
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.p2align	2
d:
	.int32	b
	.size	d, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.p2align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
f:
	.int8	0                       # 0x0
	.size	f, 1

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
e:
	.int8	0                       # 0x0
	.size	e, 1


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
