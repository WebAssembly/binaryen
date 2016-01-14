	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58831.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	call    	fn2@FUNCTION
	i32.const	$0=, 0
	i32.load	$1=, b($0)
	i32.const	$push0=, r
	i32.store	$discard=, i($0), $pop0
	call    	fn1@FUNCTION, $1
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.fn2,"ax",@progbits
	.type	fn2,@function
fn2:                                    # @fn2
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.store16	$push0=, o($0), $0
	i32.const	$push1=, 42
	i32.store	$discard=, f($pop0), $pop1
	return
	.endfunc
.Lfunc_end1:
	.size	fn2, .Lfunc_end1-fn2

	.section	.text.fn1,"ax",@progbits
	.type	fn1,@function
fn1:                                    # @fn1
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	i32.load	$push0=, p($1)
	i32.const	$push7=, 0
	i32.eq  	$push8=, $pop0, $pop7
	br_if   	$pop8, 0        # 0: down to label0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push1=, 1
	i32.store	$2=, 0($0), $pop1
	i32.load	$push2=, p($1)
	i32.add 	$push3=, $pop2, $2
	i32.store	$push4=, p($1), $pop3
	br_if   	$pop4, 0        # 0: up to label1
.LBB2_2:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push5=, d
	i32.store	$push6=, r($1), $pop5
	i32.store	$discard=, b($1), $pop6
	return
	.endfunc
.Lfunc_end2:
	.size	fn1, .Lfunc_end2-fn1

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	2
i:
	.int32	0
	.size	i, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0
	.size	b, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.align	2
f:
	.int32	0                       # 0x0
	.size	f, 4

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.align	2
p:
	.int32	0                       # 0x0
	.size	p, 4

	.hidden	q                       # @q
	.type	q,@object
	.section	.bss.q,"aw",@nobits
	.globl	q
	.align	2
q:
	.int32	0                       # 0x0
	.size	q, 4

	.hidden	r                       # @r
	.type	r,@object
	.section	.bss.r,"aw",@nobits
	.globl	r
	.align	2
r:
	.int32	0
	.size	r, 4

	.hidden	o                       # @o
	.type	o,@object
	.section	.bss.o,"aw",@nobits
	.globl	o
	.align	1
o:
	.int16	0                       # 0x0
	.size	o, 2

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.align	1
j:
	.int16	0                       # 0x0
	.size	j, 2


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
