	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57860.c"
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
BB0_1:                                  # %for.cond1thread-pre-split
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_5
	block   	BB0_3
	i32.load	$push0=, c($5)
	i32.const	$push15=, 0
	i32.eq  	$push16=, $pop0, $pop15
	br_if   	$pop16, BB0_3
# BB#2:                                 # %for.inc.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.store	$discard=, c($5), $5
BB0_3:                                  # %for.end
                                        #   in Loop: Header=BB0_1 Depth=1
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
	br_if   	$pop12, BB0_5
# BB#4:                                 # %for.inc6
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push13=, 1
	i32.add 	$push14=, $0, $pop13
	i32.store	$discard=, g($5), $pop14
	br      	BB0_1
BB0_5:                                  # %if.then
	return  	$5
func_end0:
	.size	foo, func_end0-foo

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
BB1_1:                                  # %for.cond1thread-pre-split.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB1_5
	block   	BB1_3
	i32.load	$push0=, c($4)
	i32.const	$push18=, 0
	i32.eq  	$push19=, $pop0, $pop18
	br_if   	$pop19, BB1_3
# BB#2:                                 # %for.inc.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.store	$discard=, c($4), $4
BB1_3:                                  # %for.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
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
	br_if   	$pop12, BB1_5
# BB#4:                                 # %for.inc6.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push16=, 1
	i32.add 	$push17=, $3, $pop16
	i32.store	$discard=, g($4), $pop17
	br      	BB1_1
BB1_5:                                  # %foo.exit
	block   	BB1_7
	i32.load	$push13=, d($4)
	i32.const	$push14=, 1
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	$pop15, BB1_7
# BB#6:                                 # %if.end
	return  	$4
BB1_7:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.type	b,@object               # @b
	.data
	.globl	b
	.align	2
b:
	.int32	a
	.size	b, 4

	.type	e,@object               # @e
	.bss
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.type	f,@object               # @f
	.data
	.globl	f
	.align	2
f:
	.int32	e
	.size	f, 4

	.type	d,@object               # @d
	.bss
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.type	h,@object               # @h
	.data
	.globl	h
	.align	2
h:
	.int32	d
	.size	h, 4

	.type	k,@object               # @k
	.globl	k
	.align	2
k:
	.int32	1                       # 0x1
	.size	k, 4

	.type	c,@object               # @c
	.bss
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.type	g,@object               # @g
	.globl	g
	.align	2
g:
	.int32	0                       # 0x0
	.size	g, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
