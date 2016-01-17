	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20140212-1.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
	i32.store	$discard=, e($5), $5
	i32.store	$discard=, c($5), $5
	i32.load	$push0=, a($5)
	i32.ne  	$push1=, $pop0, $5
	i32.load	$push2=, b($5)
	i32.ne  	$push3=, $pop2, $5
	i32.and 	$0=, $pop1, $pop3
	i32.load	$3=, d($5)
	i32.load	$4=, f($5)
	i32.const	$push4=, 54
	i32.select	$1=, $0, $pop4, $5
	i32.const	$push5=, 147
	i32.mul 	$2=, $1, $pop5
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	block
	i32.const	$push9=, 0
	i32.eq  	$push10=, $3, $pop9
	br_if   	$pop10, 0       # 0: down to label3
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push6=, 1
	i32.store	$discard=, c($5), $pop6
	br      	1               # 1: down to label2
.LBB0_3:                                # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push7=, 9
	i32.store	$push8=, i($5), $pop7
	i32.store	$discard=, h($5), $pop8
.LBB0_4:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push11=, 0
	i32.eq  	$push12=, $4, $pop11
	br_if   	$pop12, 0       # 0: up to label0
# BB#5:                                 # %if.then15
	end_loop                        # label1:
	i32.store	$discard=, k($5), $0
	i32.store8	$discard=, j($5), $1
	i32.store8	$discard=, g($5), $2
	return
	.endfunc
.Lfunc_end0:
	.size	fn1, .Lfunc_end0-fn1

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	i32.store	$discard=, e($4), $4
	i32.store	$5=, c($4), $4
	i32.load	$2=, d($5)
	i32.load	$3=, f($5)
	i32.load	$push0=, a($5)
	i32.ne  	$push1=, $pop0, $5
	i32.load	$push2=, b($5)
	i32.ne  	$push3=, $pop2, $5
	i32.and 	$0=, $pop1, $pop3
	i32.const	$push4=, 54
	i32.select	$1=, $0, $pop4, $5
.LBB1_1:                                # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	block
	block
	i32.const	$push13=, 0
	i32.eq  	$push14=, $2, $pop13
	br_if   	$pop14, 0       # 0: down to label7
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push6=, 0
	i32.const	$push5=, 1
	i32.store	$5=, c($pop6), $pop5
	br      	1               # 1: down to label6
.LBB1_3:                                # %if.else.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.const	$4=, 0
	i32.const	$push7=, 9
	i32.store	$push8=, i($4), $pop7
	i32.store	$discard=, h($4), $pop8
.LBB1_4:                                # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.const	$push15=, 0
	i32.eq  	$push16=, $3, $pop15
	br_if   	$pop16, 0       # 0: up to label4
# BB#5:                                 # %fn1.exit
	end_loop                        # label5:
	i32.const	$4=, 0
	i32.store	$discard=, k($4), $0
	i32.store8	$discard=, j($4), $1
	block
	i32.const	$push9=, 147
	i32.mul 	$push10=, $1, $pop9
	i32.store8	$discard=, g($4), $pop10
	i32.const	$push11=, 1
	i32.ne  	$push12=, $5, $pop11
	br_if   	$pop12, 0       # 0: down to label8
# BB#6:                                 # %if.end
	return  	$4
.LBB1_7:                                # %if.then
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.align	2
d:
	.int32	1                       # 0x1
	.size	d, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.data.f,"aw",@progbits
	.globl	f
	.align	2
f:
	.int32	1                       # 0x1
	.size	f, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.align	2
k:
	.int32	0                       # 0x0
	.size	k, 4

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
j:
	.int8	0                       # 0x0
	.size	j, 1

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
g:
	.int8	0                       # 0x0
	.size	g, 1

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.align	2
h:
	.int32	0                       # 0x0
	.size	h, 4


	.ident	"clang version 3.9.0 "
