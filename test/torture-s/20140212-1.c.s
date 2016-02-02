	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20140212-1.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push17=, 0
	i32.store	$push3=, e($pop2), $pop17
	tee_local	$push16=, $5=, $pop3
	i32.store	$push4=, c($pop16), $5
	tee_local	$push15=, $5=, $pop4
	i32.load	$1=, d($pop15)
	i32.load	$2=, f($5)
	i32.load	$push5=, a($5)
	i32.ne  	$push6=, $pop5, $5
	i32.load	$push7=, b($5)
	i32.ne  	$push8=, $pop7, $5
	i32.and 	$push0=, $pop6, $pop8
	tee_local	$push14=, $4=, $pop0
	i32.const	$push9=, 54
	i32.select	$push1=, $pop14, $pop9, $5
	tee_local	$push13=, $3=, $pop1
	i32.const	$push10=, 147
	i32.mul 	$0=, $pop13, $pop10
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	block
	i32.const	$push22=, 0
	i32.eq  	$push23=, $1, $pop22
	br_if   	$pop23, 0       # 0: down to label3
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push18=, 1
	i32.store	$discard=, c($5), $pop18
	br      	1               # 1: down to label2
.LBB0_3:                                # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push19=, 9
	i32.store	$push11=, i($5), $pop19
	i32.store	$discard=, h($5), $pop11
.LBB0_4:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push24=, 0
	i32.eq  	$push25=, $2, $pop24
	br_if   	$pop25, 0       # 0: up to label0
# BB#5:                                 # %if.then15
	end_loop                        # label1:
	i32.const	$push12=, 0
	i32.store	$discard=, k($pop12), $4
	i32.const	$push21=, 0
	i32.store8	$discard=, j($pop21), $3
	i32.const	$push20=, 0
	i32.store8	$discard=, g($pop20), $0
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
	i32.const	$push1=, 0
	i32.const	$push18=, 0
	i32.store	$push2=, e($pop1), $pop18
	tee_local	$push17=, $5=, $pop2
	i32.store	$push3=, c($pop17), $5
	tee_local	$push16=, $5=, $pop3
	i32.load	$1=, d($pop16)
	i32.load	$2=, f($5)
	i32.load	$push4=, a($5)
	i32.ne  	$push5=, $pop4, $5
	i32.load	$push6=, b($5)
	i32.ne  	$push7=, $pop6, $5
	i32.and 	$push0=, $pop5, $pop7
	tee_local	$push15=, $4=, $pop0
	i32.const	$push8=, 54
	i32.select	$0=, $pop15, $pop8, $5
	copy_local	$3=, $5
.LBB1_1:                                # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	block
	block
	i32.const	$push24=, 0
	i32.eq  	$push25=, $1, $pop24
	br_if   	$pop25, 0       # 0: down to label7
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push9=, 1
	i32.store	$3=, c($5), $pop9
	br      	1               # 1: down to label6
.LBB1_3:                                # %if.else.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.const	$push19=, 9
	i32.store	$push10=, i($5), $pop19
	i32.store	$discard=, h($5), $pop10
.LBB1_4:                                # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.const	$push26=, 0
	i32.eq  	$push27=, $2, $pop26
	br_if   	$pop27, 0       # 0: up to label4
# BB#5:                                 # %fn1.exit
	end_loop                        # label5:
	i32.const	$push22=, 0
	i32.store	$discard=, k($pop22), $4
	i32.const	$push21=, 0
	i32.store8	$discard=, j($pop21), $0
	i32.const	$push20=, 0
	i32.const	$push11=, 147
	i32.mul 	$push12=, $0, $pop11
	i32.store8	$discard=, g($pop20), $pop12
	block
	i32.const	$push13=, 1
	i32.ne  	$push14=, $3, $pop13
	br_if   	$pop14, 0       # 0: down to label8
# BB#6:                                 # %if.end
	i32.const	$push23=, 0
	return  	$pop23
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
	.p2align	2
d:
	.int32	1                       # 0x1
	.size	d, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.data.f,"aw",@progbits
	.globl	f
	.p2align	2
f:
	.int32	1                       # 0x1
	.size	f, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	2
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


	.ident	"clang version 3.9.0 "
