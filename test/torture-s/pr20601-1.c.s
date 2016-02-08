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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push44=, 0
	i32.const	$push10=, g
	i32.store	$discard=, c($pop44), $pop10
	i32.const	$push43=, 0
	i32.const	$push11=, 4
	i32.store	$2=, b($pop43), $pop11
	i32.const	$push42=, 0
	i32.const	$push9=, g+4
	i32.store	$0=, e($pop42), $pop9
	i32.const	$push41=, 0
	i32.const	$push8=, 3
	i32.store	$4=, d($pop41), $pop8
	i32.const	$1=, 1
.LBB2_1:                                # %land.rhs.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.load	$push0=, 0($0)
	tee_local	$push46=, $5=, $pop0
	i32.load8_u	$push12=, 0($pop46)
	i32.const	$push45=, 45
	i32.ne  	$push13=, $pop12, $pop45
	br_if   	1, $pop13       # 1: down to label4
# BB#2:                                 # %while.body.i
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.load8_s	$push1=, 1($5)
	tee_local	$push47=, $3=, $pop1
	i32.const	$push70=, 0
	i32.eq  	$push71=, $pop47, $pop70
	br_if   	0, $pop71       # 0: down to label5
# BB#3:                                 # %land.lhs.true.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push14=, 2($5)
	i32.const	$push72=, 0
	i32.eq  	$push73=, $pop14, $pop72
	br_if   	0, $pop73       # 0: down to label5
# BB#4:                                 # %if.then.i
	call    	abort@FUNCTION
	unreachable
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label5:
	block
	block
	i32.const	$push48=, 80
	i32.eq  	$push15=, $3, $pop48
	br_if   	0, $pop15       # 0: down to label7
# BB#6:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.const	$push49=, 117
	i32.eq  	$push16=, $3, $pop49
	br_if   	0, $pop16       # 0: down to label8
# BB#7:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push50=, 45
	i32.ne  	$push17=, $3, $pop50
	br_if   	2, $pop17       # 2: down to label6
# BB#8:                                 # %sw.bb22.i
	i32.const	$push23=, 1536
	i32.or  	$push24=, $1, $pop23
	i32.const	$push21=, 1
	i32.eq  	$push22=, $1, $pop21
	i32.select	$1=, $pop24, $1, $pop22
	i32.const	$push19=, 0
	i32.const	$push18=, -1
	i32.add 	$push4=, $4, $pop18
	i32.store	$4=, d($pop19), $pop4
	i32.const	$push56=, 0
	i32.const	$push20=, 4
	i32.add 	$push5=, $0, $pop20
	i32.store	$0=, e($pop56), $pop5
	br      	5               # 5: down to label2
.LBB2_9:                                # %sw.bb.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	block
	i32.load	$push25=, 4($0)
	i32.const	$push74=, 0
	i32.eq  	$push75=, $pop25, $pop74
	br_if   	0, $pop75       # 0: down to label9
# BB#10:                                # %if.end19.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push54=, 0
	i32.add 	$push2=, $0, $2
	i32.store	$3=, t+4100($pop54), $pop2
	i32.const	$push53=, 0
	i32.const	$push52=, -1
	i32.add 	$push3=, $4, $pop52
	i32.store	$4=, d($pop53), $pop3
	i32.const	$push51=, 0
	i32.store	$0=, e($pop51), $3
	br      	2               # 2: down to label6
.LBB2_11:                               # %if.then18.i
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB2_12:                               # %sw.bb21.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label7:
	i32.const	$push55=, 4096
	i32.or  	$1=, $1, $pop55
.LBB2_13:                               # %sw.epilog.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label6:
	i32.const	$push60=, 1
	i32.gt_s	$3=, $4, $pop60
	i32.const	$push59=, 0
	i32.const	$push58=, -1
	i32.add 	$push6=, $4, $pop58
	i32.store	$4=, d($pop59), $pop6
	i32.const	$push57=, 0
	i32.add 	$push7=, $0, $2
	i32.store	$0=, e($pop57), $pop7
	br_if   	0, $3           # 0: up to label3
.LBB2_14:                               # %while.end.i
	end_loop                        # label4:
	i32.const	$push61=, 1
	i32.lt_s	$push27=, $4, $pop61
	br_if   	0, $pop27       # 0: down to label2
# BB#15:                                # %while.end.i
	i32.const	$push62=, 1
	i32.and 	$push26=, $1, $pop62
	br_if   	0, $pop26       # 0: down to label2
# BB#16:                                # %if.then36.i
	call    	abort@FUNCTION
	unreachable
.LBB2_17:                               # %setup2.exit
	end_block                       # label2:
	i32.const	$push63=, 0
	i32.const	$push28=, .L.str.4
	i32.store	$3=, t($pop63), $pop28
	block
	i32.const	$push29=, 512
	i32.and 	$push30=, $1, $pop29
	i32.const	$push76=, 0
	i32.eq  	$push77=, $pop30, $pop76
	br_if   	0, $pop77       # 0: down to label10
# BB#18:                                # %if.then6.i
	i32.const	$push66=, 0
	i32.const	$push31=, 1
	i32.add 	$push32=, $4, $pop31
	i32.store	$discard=, d($pop66), $pop32
	i32.const	$push65=, 0
	i32.const	$push33=, f
	i32.store	$discard=, e($pop65), $pop33
	i32.const	$push64=, 0
	i32.store	$discard=, f($pop64):p2align=4, $3
	i32.const	$4=, 4
.LBB2_19:                               # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label11:
	i32.add 	$push34=, $0, $4
	i32.const	$push68=, -4
	i32.add 	$push35=, $pop34, $pop68
	i32.load	$push36=, 0($pop35)
	i32.store	$3=, f($4), $pop36
	i32.const	$push67=, 4
	i32.add 	$4=, $4, $pop67
	br_if   	0, $3           # 0: up to label11
.LBB2_20:                               # %setup1.exit
	end_loop                        # label12:
	end_block                       # label10:
	block
	i32.const	$push38=, 1024
	i32.and 	$push39=, $1, $pop38
	i32.const	$push78=, 0
	i32.eq  	$push79=, $pop39, $pop78
	br_if   	0, $pop79       # 0: down to label13
# BB#21:                                # %setup1.exit
	i32.const	$push69=, 0
	i32.load	$push37=, a+16($pop69):p2align=4
	br_if   	0, $pop37       # 0: down to label13
# BB#22:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB2_23:                               # %if.end
	end_block                       # label13:
	i32.const	$push40=, 0
	call    	exit@FUNCTION, $pop40
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
	.p2align	4
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
	.p2align	2
c:
	.int32	0
	.size	c, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
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
	.p2align	2
t:
	.skip	4104
	.size	t, 4104

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	20
	.size	a, 20

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0
	.size	e, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	4
f:
	.skip	64
	.size	f, 64


	.ident	"clang version 3.9.0 "
