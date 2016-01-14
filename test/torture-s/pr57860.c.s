	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57860.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
	i32.load	$2=, b($5)
	i32.load	$3=, h($5)
	i32.load	$4=, f($5)
	i64.extend_s/i32	$1=, $0
.LBB0_1:                                # %for.cond1thread-pre-split
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	i32.load	$push0=, c($5)
	i32.const	$push15=, 0
	i32.eq  	$push16=, $pop0, $pop15
	br_if   	$pop16, 0       # 0: down to label2
# BB#2:                                 # %for.inc.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.store	$discard=, c($5), $5
.LBB0_3:                                # %for.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i64.load32_s	$push4=, 0($2)
	i64.load32_s	$push1=, a($5)
	i64.const	$push2=, 8589934591
	i64.xor 	$push3=, $pop1, $pop2
	i64.and 	$push5=, $pop4, $pop3
	i64.gt_s	$push6=, $1, $pop5
	i32.store	$push7=, 0($3), $pop6
	i32.store	$discard=, 0($4), $pop7
	i32.load	$0=, g($5)
	i32.const	$push10=, k
	i32.const	$push8=, 2
	i32.shl 	$push9=, $0, $pop8
	i32.add 	$push11=, $pop10, $pop9
	i32.load	$push12=, 0($pop11)
	br_if   	$pop12, 1       # 1: down to label1
# BB#4:                                 # %for.inc6
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push13=, 1
	i32.add 	$push14=, $0, $pop13
	i32.store	$discard=, g($5), $pop14
	br      	0               # 0: up to label0
.LBB0_5:                                # %if.then
	end_loop                        # label1:
	return  	$5
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i64
# BB#0:                                 # %entry
	i32.const	$4=, 0
	i32.load	$0=, b($4)
	i32.load	$1=, h($4)
	i32.load	$2=, f($4)
	i64.const	$5=, 8589934591
.LBB1_1:                                # %for.cond1thread-pre-split.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	block
	i32.load	$push0=, c($4)
	i32.const	$push18=, 0
	i32.eq  	$push19=, $pop0, $pop18
	br_if   	$pop19, 0       # 0: down to label5
# BB#2:                                 # %for.inc.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.store	$discard=, c($4), $4
.LBB1_3:                                # %for.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i64.load32_s	$push3=, 0($0)
	i64.load32_s	$push1=, a($4)
	i64.xor 	$push2=, $pop1, $5
	i64.and 	$push4=, $pop3, $pop2
	i64.const	$push5=, 1
	i64.lt_s	$push6=, $pop4, $pop5
	i32.store	$push7=, 0($1), $pop6
	i32.store	$discard=, 0($2), $pop7
	i32.load	$3=, g($4)
	i32.const	$push10=, k
	i32.const	$push8=, 2
	i32.shl 	$push9=, $3, $pop8
	i32.add 	$push11=, $pop10, $pop9
	i32.load	$push12=, 0($pop11)
	br_if   	$pop12, 1       # 1: down to label4
# BB#4:                                 # %for.inc6.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push16=, 1
	i32.add 	$push17=, $3, $pop16
	i32.store	$discard=, g($4), $pop17
	br      	0               # 0: up to label3
.LBB1_5:                                # %foo.exit
	end_loop                        # label4:
	block
	i32.load	$push13=, d($4)
	i32.const	$push14=, 1
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	$pop15, 0       # 0: down to label6
# BB#6:                                 # %if.end
	return  	$4
.LBB1_7:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

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
	.section	.data.b,"aw",@progbits
	.globl	b
	.align	2
b:
	.int32	a
	.size	b, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.data.f,"aw",@progbits
	.globl	f
	.align	2
f:
	.int32	e
	.size	f, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.data.h,"aw",@progbits
	.globl	h
	.align	2
h:
	.int32	d
	.size	h, 4

	.hidden	k                       # @k
	.type	k,@object
	.section	.data.k,"aw",@progbits
	.globl	k
	.align	2
k:
	.int32	1                       # 0x1
	.size	k, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.align	2
g:
	.int32	0                       # 0x0
	.size	g, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
