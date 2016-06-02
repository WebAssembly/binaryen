	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58831.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	fn2@FUNCTION
	i32.const	$push1=, 0
	i32.const	$push0=, r
	i32.store	$drop=, i($pop1), $pop0
	i32.const	$push4=, 0
	i32.load	$push2=, b($pop4)
	call    	fn1@FUNCTION, $pop2
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.fn2,"ax",@progbits
	.type	fn2,@function
fn2:                                    # @fn2
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 42
	i32.store	$drop=, f($pop1), $pop0
	i32.const	$push3=, 0
	i32.const	$push2=, 0
	i32.store16	$drop=, o($pop3), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	fn2, .Lfunc_end1-fn2

	.section	.text.fn1,"ax",@progbits
	.type	fn1,@function
fn1:                                    # @fn1
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push7=, 0
	i32.load	$push3=, p($pop7)
	i32.eqz 	$push13=, $pop3
	br_if   	0, $pop13       # 0: down to label0
# BB#1:                                 # %for.body.preheader
.LBB2_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push10=, 0
	i32.const	$push9=, 1
	i32.store	$push0=, 0($0), $pop9
	i32.const	$push8=, 0
	i32.load	$push4=, p($pop8)
	i32.add 	$push5=, $pop0, $pop4
	i32.store	$push1=, p($pop10), $pop5
	br_if   	0, $pop1        # 0: up to label1
.LBB2_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i32.const	$push6=, d
	i32.store	$push2=, b($pop11), $pop6
	i32.store	$drop=, r($pop12), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	fn1, .Lfunc_end2-fn1

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0
	.size	i, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0
	.size	b, 4

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

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.int32	0                       # 0x0
	.size	f, 4

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0                       # 0x0
	.size	p, 4

	.hidden	q                       # @q
	.type	q,@object
	.section	.bss.q,"aw",@nobits
	.globl	q
	.p2align	2
q:
	.int32	0                       # 0x0
	.size	q, 4

	.hidden	r                       # @r
	.type	r,@object
	.section	.bss.r,"aw",@nobits
	.globl	r
	.p2align	2
r:
	.int32	0
	.size	r, 4

	.hidden	o                       # @o
	.type	o,@object
	.section	.bss.o,"aw",@nobits
	.globl	o
	.p2align	1
o:
	.int16	0                       # 0x0
	.size	o, 2

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.p2align	1
j:
	.int16	0                       # 0x0
	.size	j, 2


	.ident	"clang version 3.9.0 "
