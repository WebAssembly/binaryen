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
	i32.const	$push42=, 0
	i32.const	$push8=, g
	i32.store	$discard=, c($pop42), $pop8
	i32.const	$push41=, 0
	i32.const	$push9=, 4
	i32.store	$2=, b($pop41), $pop9
	i32.const	$push40=, 0
	i32.const	$push7=, g+4
	i32.store	$0=, e($pop40), $pop7
	i32.const	$push39=, 0
	i32.const	$push6=, 3
	i32.store	$4=, d($pop39), $pop6
	i32.const	$1=, 1
.LBB2_1:                                # %land.rhs.i
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	block
	block
	loop                            # label6:
	i32.load	$push45=, 0($0)
	tee_local	$push44=, $5=, $pop45
	i32.load8_u	$push10=, 0($pop44)
	i32.const	$push43=, 45
	i32.ne  	$push11=, $pop10, $pop43
	br_if   	1, $pop11       # 1: down to label7
# BB#2:                                 # %while.body.i
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.load8_s	$push47=, 1($5)
	tee_local	$push46=, $3=, $pop47
	i32.const	$push70=, 0
	i32.eq  	$push71=, $pop46, $pop70
	br_if   	0, $pop71       # 0: down to label8
# BB#3:                                 # %land.lhs.true.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push12=, 2($5)
	br_if   	5, $pop12       # 5: down to label3
.LBB2_4:                                # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	block
	block
	block
	i32.const	$push48=, 80
	i32.eq  	$push13=, $3, $pop48
	br_if   	0, $pop13       # 0: down to label11
# BB#5:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push49=, 117
	i32.eq  	$push14=, $3, $pop49
	br_if   	1, $pop14       # 1: down to label10
# BB#6:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push50=, 45
	i32.ne  	$push15=, $3, $pop50
	br_if   	2, $pop15       # 2: down to label9
	br      	5               # 5: down to label5
.LBB2_7:                                # %sw.bb21.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label11:
	i32.const	$push55=, 4096
	i32.or  	$1=, $1, $pop55
	br      	1               # 1: down to label9
.LBB2_8:                                # %sw.bb.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label10:
	i32.load	$push23=, 4($0)
	i32.const	$push72=, 0
	i32.eq  	$push73=, $pop23, $pop72
	br_if   	6, $pop73       # 6: down to label2
# BB#9:                                 # %if.end19.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push54=, 0
	i32.add 	$push0=, $0, $2
	i32.store	$3=, t+4100($pop54), $pop0
	i32.const	$push53=, 0
	i32.const	$push52=, -1
	i32.add 	$push1=, $4, $pop52
	i32.store	$4=, d($pop53), $pop1
	i32.const	$push51=, 0
	i32.store	$0=, e($pop51), $3
.LBB2_10:                               # %sw.epilog.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label9:
	i32.const	$push60=, 1
	i32.gt_s	$3=, $4, $pop60
	i32.const	$push59=, 0
	i32.const	$push58=, -1
	i32.add 	$push4=, $4, $pop58
	i32.store	$4=, d($pop59), $pop4
	i32.const	$push57=, 0
	i32.add 	$push5=, $0, $2
	i32.store	$0=, e($pop57), $pop5
	br_if   	0, $3           # 0: up to label6
.LBB2_11:                               # %while.end.i
	end_loop                        # label7:
	i32.const	$push61=, 1
	i32.lt_s	$push25=, $4, $pop61
	br_if   	1, $pop25       # 1: down to label4
# BB#12:                                # %while.end.i
	i32.const	$push62=, 1
	i32.and 	$push24=, $1, $pop62
	br_if   	1, $pop24       # 1: down to label4
# BB#13:                                # %if.then36.i
	call    	abort@FUNCTION
	unreachable
.LBB2_14:                               # %sw.bb22.i
	end_block                       # label5:
	i32.const	$push21=, 1536
	i32.or  	$push22=, $1, $pop21
	i32.const	$push19=, 1
	i32.eq  	$push20=, $1, $pop19
	i32.select	$1=, $pop22, $1, $pop20
	i32.const	$push17=, 0
	i32.const	$push16=, -1
	i32.add 	$push2=, $4, $pop16
	i32.store	$4=, d($pop17), $pop2
	i32.const	$push56=, 0
	i32.const	$push18=, 4
	i32.add 	$push3=, $0, $pop18
	i32.store	$0=, e($pop56), $pop3
.LBB2_15:                               # %setup2.exit
	end_block                       # label4:
	i32.const	$push63=, 0
	i32.const	$push26=, .L.str.4
	i32.store	$3=, t($pop63), $pop26
	block
	i32.const	$push27=, 512
	i32.and 	$push28=, $1, $pop27
	i32.const	$push74=, 0
	i32.eq  	$push75=, $pop28, $pop74
	br_if   	0, $pop75       # 0: down to label12
# BB#16:                                # %if.then6.i
	i32.const	$push66=, 0
	i32.const	$push29=, 1
	i32.add 	$push30=, $4, $pop29
	i32.store	$discard=, d($pop66), $pop30
	i32.const	$push65=, 0
	i32.const	$push31=, f
	i32.store	$discard=, e($pop65), $pop31
	i32.const	$push64=, 0
	i32.store	$discard=, f($pop64):p2align=4, $3
	i32.const	$4=, 4
.LBB2_17:                               # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label13:
	i32.add 	$push32=, $0, $4
	i32.const	$push68=, -4
	i32.add 	$push33=, $pop32, $pop68
	i32.load	$push34=, 0($pop33)
	i32.store	$3=, f($4), $pop34
	i32.const	$push67=, 4
	i32.add 	$4=, $4, $pop67
	br_if   	0, $3           # 0: up to label13
.LBB2_18:                               # %setup1.exit
	end_loop                        # label14:
	end_block                       # label12:
	block
	i32.const	$push36=, 1024
	i32.and 	$push37=, $1, $pop36
	i32.const	$push76=, 0
	i32.eq  	$push77=, $pop37, $pop76
	br_if   	0, $pop77       # 0: down to label15
# BB#19:                                # %setup1.exit
	i32.const	$push69=, 0
	i32.load	$push35=, a+16($pop69):p2align=4
	br_if   	0, $pop35       # 0: down to label15
# BB#20:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB2_21:                               # %if.end
	end_block                       # label15:
	i32.const	$push38=, 0
	call    	exit@FUNCTION, $pop38
	unreachable
.LBB2_22:                               # %if.then.i
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB2_23:                               # %if.then18.i
	end_block                       # label2:
	call    	abort@FUNCTION
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
