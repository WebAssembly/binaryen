	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20140212-1.c"
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
BB0_1:                                  # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_5
	block   	BB0_4
	block   	BB0_3
	i32.const	$push9=, 0
	i32.eq  	$push10=, $3, $pop9
	br_if   	$pop10, BB0_3
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push6=, 1
	i32.store	$discard=, c($5), $pop6
	br      	BB0_4
BB0_3:                                  # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push7=, 9
	i32.store	$push8=, i($5), $pop7
	i32.store	$discard=, h($5), $pop8
BB0_4:                                  # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push11=, 0
	i32.eq  	$push12=, $4, $pop11
	br_if   	$pop12, BB0_1
BB0_5:                                  # %if.then15
	i32.store	$discard=, k($5), $0
	i32.store8	$discard=, j($5), $1
	i32.store8	$discard=, g($5), $2
	return
func_end0:
	.size	fn1, func_end0-fn1

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
BB1_1:                                  # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB1_5
	block   	BB1_4
	block   	BB1_3
	i32.const	$push13=, 0
	i32.eq  	$push14=, $2, $pop13
	br_if   	$pop14, BB1_3
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push6=, 0
	i32.const	$push5=, 1
	i32.store	$5=, c($pop6), $pop5
	br      	BB1_4
BB1_3:                                  # %if.else.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$4=, 0
	i32.const	$push7=, 9
	i32.store	$push8=, i($4), $pop7
	i32.store	$discard=, h($4), $pop8
BB1_4:                                  # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push15=, 0
	i32.eq  	$push16=, $3, $pop15
	br_if   	$pop16, BB1_1
BB1_5:                                  # %fn1.exit
	i32.const	$4=, 0
	i32.store	$discard=, k($4), $0
	i32.store8	$discard=, j($4), $1
	block   	BB1_7
	i32.const	$push9=, 147
	i32.mul 	$push10=, $1, $pop9
	i32.store8	$discard=, g($4), $pop10
	i32.const	$push11=, 1
	i32.ne  	$push12=, $5, $pop11
	br_if   	$pop12, BB1_7
# BB#6:                                 # %if.end
	return  	$4
BB1_7:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	d,@object               # @d
	.data
	.globl	d
	.align	2
d:
	.int32	1                       # 0x1
	.size	d, 4

	.type	f,@object               # @f
	.globl	f
	.align	2
f:
	.int32	1                       # 0x1
	.size	f, 4

	.type	e,@object               # @e
	.bss
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.type	c,@object               # @c
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.type	a,@object               # @a
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.type	k,@object               # @k
	.globl	k
	.align	2
k:
	.int32	0                       # 0x0
	.size	k, 4

	.type	j,@object               # @j
	.globl	j
j:
	.int8	0                       # 0x0
	.size	j, 1

	.type	g,@object               # @g
	.globl	g
g:
	.int8	0                       # 0x0
	.size	g, 1

	.type	i,@object               # @i
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	h,@object               # @h
	.globl	h
	.align	2
h:
	.int32	0                       # 0x0
	.size	h, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
