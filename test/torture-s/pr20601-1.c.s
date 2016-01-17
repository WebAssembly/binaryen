	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr20601-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	br      	0               # 0: up to label0
.LBB0_2:
	end_loop                        # label1:
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
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
.LBB2_1:                                # %land.rhs.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.load	$5=, 0($0)
	i32.const	$4=, 45
	i32.load8_u	$push10=, 0($5)
	i32.ne  	$push11=, $pop10, $4
	br_if   	$pop11, 1       # 1: down to label4
# BB#2:                                 # %while.body.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_s	$7=, 1($5)
	block
	i32.const	$push48=, 0
	i32.eq  	$push49=, $7, $pop48
	br_if   	$pop49, 0       # 0: down to label5
# BB#3:                                 # %land.lhs.true.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push12=, 2($5)
	i32.const	$push50=, 0
	i32.eq  	$push51=, $pop12, $pop50
	br_if   	$pop51, 0       # 0: down to label5
# BB#4:                                 # %if.then.i
	call    	abort@FUNCTION
	unreachable
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label5:
	block
	block
	i32.const	$push13=, 80
	i32.eq  	$push14=, $7, $pop13
	br_if   	$pop14, 0       # 0: down to label7
# BB#6:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.const	$push15=, 117
	i32.eq  	$push16=, $7, $pop15
	br_if   	$pop16, 0       # 0: down to label8
# BB#7:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.ne  	$push17=, $7, $4
	br_if   	$pop17, 2       # 2: down to label6
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
	br      	5               # 5: down to label2
.LBB2_9:                                # %sw.bb.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	block
	i32.load	$push26=, 4($0)
	i32.const	$push52=, 0
	i32.eq  	$push53=, $pop26, $pop52
	br_if   	$pop53, 0       # 0: down to label9
# BB#10:                                # %if.end19.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push28=, -1
	i32.add 	$push1=, $6, $pop28
	i32.store	$6=, d($2), $pop1
	i32.const	$push25=, 4
	i32.add 	$push0=, $0, $pop25
	i32.store	$push27=, t+4100($2), $pop0
	i32.store	$0=, e($2), $pop27
	br      	2               # 2: down to label6
.LBB2_11:                               # %if.then18.i
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB2_12:                               # %sw.bb21.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label7:
	i32.const	$push24=, 4096
	i32.or  	$1=, $1, $pop24
.LBB2_13:                               # %sw.epilog.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label6:
	i32.const	$push31=, 1
	i32.gt_s	$7=, $6, $pop31
	i32.const	$push29=, -1
	i32.add 	$push4=, $6, $pop29
	i32.store	$6=, d($2), $pop4
	i32.const	$push30=, 4
	i32.add 	$push5=, $0, $pop30
	i32.store	$0=, e($2), $pop5
	br_if   	$7, 0           # 0: up to label3
.LBB2_14:                               # %while.end.i
	end_loop                        # label4:
	i32.const	$7=, 1
	i32.lt_s	$push33=, $6, $7
	br_if   	$pop33, 0       # 0: down to label2
# BB#15:                                # %while.end.i
	i32.and 	$push32=, $1, $7
	br_if   	$pop32, 0       # 0: down to label2
# BB#16:                                # %if.then36.i
	call    	abort@FUNCTION
	unreachable
.LBB2_17:                               # %setup2.exit
	end_block                       # label2:
	block
	i32.const	$push34=, .L.str.4
	i32.store	$7=, t($2), $pop34
	i32.const	$push35=, 512
	i32.and 	$push36=, $1, $pop35
	i32.const	$push54=, 0
	i32.eq  	$push55=, $pop36, $pop54
	br_if   	$pop55, 0       # 0: down to label10
# BB#18:                                # %if.then6.i
	i32.const	$push37=, 1
	i32.add 	$push38=, $6, $pop37
	i32.store	$discard=, d($2), $pop38
	i32.store	$discard=, f($2), $7
	i32.const	$push39=, f
	i32.store	$5=, e($2), $pop39
	copy_local	$7=, $3
.LBB2_19:                               # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label11:
	i32.add 	$push44=, $5, $7
	i32.add 	$push40=, $0, $7
	i32.const	$push41=, -4
	i32.add 	$push42=, $pop40, $pop41
	i32.load	$push43=, 0($pop42)
	i32.store	$6=, 0($pop44), $pop43
	i32.add 	$7=, $7, $3
	br_if   	$6, 0           # 0: up to label11
.LBB2_20:                               # %setup1.exit
	end_loop                        # label12:
	end_block                       # label10:
	block
	i32.const	$push46=, 1024
	i32.and 	$push47=, $1, $pop46
	i32.const	$push56=, 0
	i32.eq  	$push57=, $pop47, $pop56
	br_if   	$pop57, 0       # 0: down to label13
# BB#21:                                # %setup1.exit
	i32.load	$push45=, a+16($2)
	br_if   	$pop45, 0       # 0: down to label13
# BB#22:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB2_23:                               # %if.end
	end_block                       # label13:
	call    	exit@FUNCTION, $2
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"a"
	.size	.L.str, 2

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"-u"
	.size	.L.str.1, 3

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"b"
	.size	.L.str.2, 2

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"c"
	.size	.L.str.3, 2

	.hidden	g                       # @g
	.type	g,@object
	.section	.data.g,"aw",@progbits
	.globl	g
	.align	4
g:
	.int32	.L.str
	.int32	.L.str.1
	.int32	.L.str.2
	.int32	.L.str.3
	.size	g, 16

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.align	2
c:
	.int32	0
	.size	c, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.type	.L.str.4,@object        # @.str.4
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.4:
	.asciz	"/bin/sh"
	.size	.L.str.4, 8

	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
	.align	2
t:
	.skip	4104
	.size	t, 4104

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	4
a:
	.skip	20
	.size	a, 20

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.align	2
e:
	.int32	0
	.size	e, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.align	4
f:
	.skip	64
	.size	f, 64


	.ident	"clang version 3.9.0 "
