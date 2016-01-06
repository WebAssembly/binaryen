	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr20601-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
BB0_1:                                  # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_2
	br      	BB0_1
BB0_2:
func_end0:
	.size	foo, func_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	bar, func_end1-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$push8=, g
	i32.store	$discard=, c($2), $pop8
	i32.const	$push9=, 4
	i32.store	$3=, b($2), $pop9
	i32.const	$push7=, g+4
	i32.store	$0=, e($2), $pop7
	i32.const	$push6=, 3
	i32.store	$6=, d($2), $pop6
	i32.const	$1=, 1
BB2_1:                                  # %land.rhs.i
                                        # =>This Inner Loop Header: Depth=1
	block   	BB2_17
	loop    	BB2_14
	i32.load	$5=, 0($0)
	i32.const	$4=, 45
	i32.load8_u	$push10=, 0($5)
	i32.ne  	$push11=, $pop10, $4
	br_if   	$pop11, BB2_14
# BB#2:                                 # %while.body.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_s	$7=, 1($5)
	block   	BB2_5
	i32.const	$push48=, 0
	i32.eq  	$push49=, $7, $pop48
	br_if   	$pop49, BB2_5
# BB#3:                                 # %land.lhs.true.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push12=, 2($5)
	i32.const	$push50=, 0
	i32.eq  	$push51=, $pop12, $pop50
	br_if   	$pop51, BB2_5
# BB#4:                                 # %if.then.i
	call    	abort
	unreachable
BB2_5:                                  # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	BB2_13
	block   	BB2_12
	i32.const	$push13=, 80
	i32.eq  	$push14=, $7, $pop13
	br_if   	$pop14, BB2_12
# BB#6:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	BB2_9
	i32.const	$push15=, 117
	i32.eq  	$push16=, $7, $pop15
	br_if   	$pop16, BB2_9
# BB#7:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.ne  	$push17=, $7, $4
	br_if   	$pop17, BB2_13
# BB#8:                                 # %sw.bb22.i
	i32.const	$push20=, 1
	i32.eq  	$push21=, $1, $pop20
	i32.const	$push22=, 1536
	i32.or  	$push23=, $1, $pop22
	i32.select	$1=, $pop21, $pop23, $1
	i32.const	$push18=, -1
	i32.add 	$push2=, $6, $pop18
	i32.store	$6=, d($2), $pop2
	i32.const	$push19=, 4
	i32.add 	$push3=, $0, $pop19
	i32.store	$0=, e($2), $pop3
	br      	BB2_17
BB2_9:                                  # %sw.bb.i
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	BB2_11
	i32.load	$push26=, 4($0)
	i32.const	$push52=, 0
	i32.eq  	$push53=, $pop26, $pop52
	br_if   	$pop53, BB2_11
# BB#10:                                # %if.end19.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push28=, -1
	i32.add 	$push1=, $6, $pop28
	i32.store	$6=, d($2), $pop1
	i32.const	$push25=, 4
	i32.add 	$push0=, $0, $pop25
	i32.store	$push27=, t+4100($2), $pop0
	i32.store	$0=, e($2), $pop27
	br      	BB2_13
BB2_11:                                 # %if.then18.i
	call    	abort
	unreachable
BB2_12:                                 # %sw.bb21.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push24=, 4096
	i32.or  	$1=, $1, $pop24
BB2_13:                                 # %sw.epilog.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push31=, 1
	i32.gt_s	$7=, $6, $pop31
	i32.const	$push29=, -1
	i32.add 	$push4=, $6, $pop29
	i32.store	$6=, d($2), $pop4
	i32.const	$push30=, 4
	i32.add 	$push5=, $0, $pop30
	i32.store	$0=, e($2), $pop5
	br_if   	$7, BB2_1
BB2_14:                                 # %while.end.i
	i32.const	$7=, 1
	i32.lt_s	$push33=, $6, $7
	br_if   	$pop33, BB2_17
# BB#15:                                # %while.end.i
	i32.and 	$push32=, $1, $7
	br_if   	$pop32, BB2_17
# BB#16:                                # %if.then36.i
	call    	abort
	unreachable
BB2_17:                                 # %setup2.exit
	block   	BB2_20
	i32.const	$push34=, .str.4
	i32.store	$7=, t($2), $pop34
	i32.const	$push35=, 512
	i32.and 	$push36=, $1, $pop35
	i32.const	$push54=, 0
	i32.eq  	$push55=, $pop36, $pop54
	br_if   	$pop55, BB2_20
# BB#18:                                # %if.then6.i
	i32.const	$push37=, 1
	i32.add 	$push38=, $6, $pop37
	i32.store	$discard=, d($2), $pop38
	i32.store	$discard=, f($2), $7
	i32.const	$push39=, f
	i32.store	$5=, e($2), $pop39
	copy_local	$7=, $3
BB2_19:                                 # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB2_20
	i32.add 	$push44=, $5, $7
	i32.add 	$push40=, $0, $7
	i32.const	$push41=, -4
	i32.add 	$push42=, $pop40, $pop41
	i32.load	$push43=, 0($pop42)
	i32.store	$6=, 0($pop44), $pop43
	i32.add 	$7=, $7, $3
	br_if   	$6, BB2_19
BB2_20:                                 # %setup1.exit
	block   	BB2_23
	i32.const	$push46=, 1024
	i32.and 	$push47=, $1, $pop46
	i32.const	$push56=, 0
	i32.eq  	$push57=, $pop47, $pop56
	br_if   	$pop57, BB2_23
# BB#21:                                # %setup1.exit
	i32.load	$push45=, a+16($2)
	br_if   	$pop45, BB2_23
# BB#22:                                # %if.then
	call    	abort
	unreachable
BB2_23:                                 # %if.end
	call    	exit, $2
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"a"
	.size	.str, 2

	.type	.str.1,@object          # @.str.1
.str.1:
	.asciz	"-u"
	.size	.str.1, 3

	.type	.str.2,@object          # @.str.2
.str.2:
	.asciz	"b"
	.size	.str.2, 2

	.type	.str.3,@object          # @.str.3
.str.3:
	.asciz	"c"
	.size	.str.3, 2

	.type	g,@object               # @g
	.data
	.globl	g
	.align	4
g:
	.int32	.str
	.int32	.str.1
	.int32	.str.2
	.int32	.str.3
	.size	g, 16

	.type	c,@object               # @c
	.bss
	.globl	c
	.align	2
c:
	.int32	0
	.size	c, 4

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.type	.str.4,@object          # @.str.4
	.section	.rodata.str1.1,"aMS",@progbits,1
.str.4:
	.asciz	"/bin/sh"
	.size	.str.4, 8

	.type	t,@object               # @t
	.bss
	.globl	t
	.align	2
t:
	.zero	4104
	.size	t, 4104

	.type	a,@object               # @a
	.globl	a
	.align	4
a:
	.zero	20
	.size	a, 20

	.type	d,@object               # @d
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.type	e,@object               # @e
	.globl	e
	.align	2
e:
	.int32	0
	.size	e, 4

	.type	f,@object               # @f
	.globl	f
	.align	4
f:
	.zero	64
	.size	f, 64


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
