	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010915-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.const	$push11=, 0
	i32.load	$push12=, __stack_pointer($pop11)
	i32.const	$push13=, 32
	i32.sub 	$push15=, $pop12, $pop13
	i32.store	$push22=, __stack_pointer($pop14), $pop15
	tee_local	$push21=, $2=, $pop22
	i32.const	$push2=, 16
	i32.add 	$push3=, $pop21, $pop2
	i32.const	$push20=, 0
	i32.load	$push1=, .Lmain.args+16($pop20)
	i32.store	$drop=, 0($pop3), $pop1
	i32.const	$push19=, 0
	i64.load	$push4=, .Lmain.args+8($pop19)
	i64.store	$drop=, 8($2), $pop4
	i32.const	$push18=, 0
	i64.load	$push5=, .Lmain.args($pop18)
	i64.store	$drop=, 0($2), $pop5
	i32.const	$push17=, 5
	i32.call	$drop=, x@FUNCTION, $pop17, $2
	block
	i32.const	$push16=, 0
	i32.load	$push6=, check($pop16)
	i32.const	$push7=, 2
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push24=, 0
	i32.load	$push0=, o($pop24)
	i32.const	$push23=, 5
	i32.ne  	$push9=, $pop0, $pop23
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
	unreachable
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.x,"ax",@progbits
	.hidden	x
	.globl	x
	.type	x,@function
x:                                      # @x
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	block
	i32.const	$push1=, 3
	i32.lt_s	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label2
# BB#1:                                 # %entry
	i32.const	$push3=, 0
	i32.load	$push33=, o($pop3)
	tee_local	$push32=, $5=, $pop33
	i32.ge_s	$push4=, $pop32, $0
	br_if   	0, $pop4        # 0: down to label2
# BB#2:                                 # %land.lhs.true2
	i32.const	$push5=, 2
	i32.shl 	$push6=, $5, $pop5
	i32.add 	$push37=, $1, $pop6
	tee_local	$push36=, $2=, $pop37
	i32.load	$push35=, 0($pop36)
	tee_local	$push34=, $3=, $pop35
	i32.eqz 	$push72=, $pop34
	br_if   	0, $pop72       # 0: down to label2
# BB#3:                                 # %if.then
	block
	i32.const	$push7=, .L.str
	i32.call	$push8=, strcmp@FUNCTION, $3, $pop7
	br_if   	0, $pop8        # 0: down to label3
# BB#4:                                 # %lor.lhs.false.i
	i32.const	$push9=, 0
	i32.const	$push40=, 0
	i32.load	$push39=, check($pop40)
	tee_local	$push38=, $4=, $pop39
	i32.const	$push10=, 1
	i32.add 	$push11=, $pop38, $pop10
	i32.store	$drop=, check($pop9), $pop11
	i32.const	$push12=, 2
	i32.ge_s	$push13=, $4, $pop12
	br_if   	0, $pop13       # 0: down to label3
# BB#5:                                 # %s.exit
	i32.const	$push14=, .L.str
	i32.call	$push15=, strcmp@FUNCTION, $3, $pop14
	br_if   	0, $pop15       # 0: down to label3
# BB#6:                                 # %lor.lhs.false.i45
	i32.const	$push42=, 0
	i32.const	$push16=, 2
	i32.add 	$push17=, $4, $pop16
	i32.store	$drop=, check($pop42), $pop17
	i32.const	$push41=, 1
	i32.ge_s	$push18=, $4, $pop41
	br_if   	0, $pop18       # 0: down to label3
# BB#7:                                 # %s.exit48
	i32.const	$push45=, 0
	i32.const	$push44=, 0
	i32.store	$drop=, u($pop45), $pop44
	i32.load	$push20=, 0($2)
	i32.const	$push43=, 1
	i32.add 	$push19=, $3, $pop43
	i32.eq  	$push21=, $pop20, $pop19
	br_if   	2, $pop21       # 2: down to label1
# BB#8:                                 # %while.cond.preheader
	block
	block
	i32.const	$push51=, 0
	i32.const	$push50=, 1
	i32.add 	$push49=, $5, $pop50
	tee_local	$push48=, $5=, $pop49
	i32.store	$push47=, o($pop51), $pop48
	tee_local	$push46=, $3=, $pop47
	i32.ge_s	$push22=, $pop46, $0
	br_if   	0, $pop22       # 0: down to label5
# BB#9:                                 # %while.body.preheader
	i32.const	$push23=, 2
	i32.shl 	$push24=, $3, $pop23
	i32.add 	$3=, $1, $pop24
	i32.const	$push52=, 0
	i32.load8_u	$4=, r.c.0($pop52)
.LBB1_10:                               # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.load	$push55=, 0($3)
	tee_local	$push54=, $1=, $pop55
	i32.load8_u	$push26=, 0($pop54)
	i32.const	$push53=, 255
	i32.and 	$push25=, $4, $pop53
	i32.ne  	$push27=, $pop26, $pop25
	br_if   	3, $pop27       # 3: down to label4
# BB#11:                                # %lor.lhs.false.i50
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.load8_u	$push28=, 1($1)
	br_if   	3, $pop28       # 3: down to label4
# BB#12:                                # %lor.lhs.false.i50
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.const	$push59=, 0
	i32.load	$push58=, r.cnt($pop59)
	tee_local	$push57=, $1=, $pop58
	i32.const	$push56=, 4
	i32.ge_s	$push29=, $pop57, $pop56
	br_if   	3, $pop29       # 3: down to label4
# BB#13:                                # %r.exit
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.const	$push70=, 0
	i32.const	$push69=, 1
	i32.add 	$push30=, $1, $pop69
	i32.store	$drop=, r.cnt($pop70), $pop30
	i32.const	$push68=, 0
	i32.const	$push67=, 1
	i32.add 	$push66=, $4, $pop67
	tee_local	$push65=, $4=, $pop66
	i32.store8	$drop=, r.c.0($pop68), $pop65
	i32.const	$push64=, 4
	i32.add 	$3=, $3, $pop64
	i32.const	$push63=, 0
	i32.const	$push62=, 1
	i32.add 	$push61=, $5, $pop62
	tee_local	$push60=, $5=, $pop61
	i32.store	$push0=, o($pop63), $pop60
	i32.lt_s	$push31=, $pop0, $0
	br_if   	0, $pop31       # 0: up to label6
.LBB1_14:                               # %cleanup
	end_loop                        # label7:
	end_block                       # label5:
	i32.const	$push71=, 0
	return  	$pop71
.LBB1_15:                               # %if.then.i51
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_16:                               # %if.then.i46
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_17:                               # %if.else
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_18:                               # %if.then15
	end_block                       # label1:
	i32.call	$drop=, m@FUNCTION, $3
	unreachable
	.endfunc
.Lfunc_end1:
	.size	x, .Lfunc_end1-x

	.section	.text.s,"ax",@progbits
	.hidden	s
	.globl	s
	.type	s,@function
s:                                      # @s
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, .L.str
	i32.call	$push1=, strcmp@FUNCTION, $0, $pop0
	br_if   	0, $pop1        # 0: down to label8
# BB#1:                                 # %lor.lhs.false
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.load	$push8=, check($pop9)
	tee_local	$push7=, $2=, $pop8
	i32.const	$push6=, 1
	i32.add 	$push2=, $pop7, $pop6
	i32.store	$drop=, check($pop10), $pop2
	i32.const	$push3=, 2
	i32.ge_s	$push4=, $2, $pop3
	br_if   	0, $pop4        # 0: down to label8
# BB#2:                                 # %if.end
	i32.const	$push12=, 1
	i32.add 	$push5=, $0, $pop12
	i32.store	$drop=, 0($1), $pop5
	i32.const	$push11=, 0
	return  	$pop11
.LBB2_3:                                # %if.then
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	s, .Lfunc_end2-s

	.section	.text.m,"ax",@progbits
	.hidden	m
	.globl	m
	.type	m,@function
m:                                      # @m
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	m, .Lfunc_end3-m

	.section	.text.r,"ax",@progbits
	.hidden	r
	.globl	r
	.type	r,@function
r:                                      # @r
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.load8_u	$push11=, 0($0)
	tee_local	$push10=, $1=, $pop11
	i32.const	$push9=, 0
	i32.load8_u	$push0=, r.c.0($pop9)
	i32.ne  	$push1=, $pop10, $pop0
	br_if   	0, $pop1        # 0: down to label9
# BB#1:                                 # %lor.lhs.false
	i32.load8_u	$push2=, 1($0)
	br_if   	0, $pop2        # 0: down to label9
# BB#2:                                 # %lor.lhs.false
	i32.const	$push14=, 0
	i32.load	$push13=, r.cnt($pop14)
	tee_local	$push12=, $0=, $pop13
	i32.const	$push3=, 4
	i32.ge_s	$push4=, $pop12, $pop3
	br_if   	0, $pop4        # 0: down to label9
# BB#3:                                 # %if.end
	i32.const	$push7=, 0
	i32.const	$push5=, 1
	i32.add 	$push6=, $0, $pop5
	i32.store	$drop=, r.cnt($pop7), $pop6
	i32.const	$push17=, 0
	i32.const	$push16=, 1
	i32.add 	$push8=, $1, $pop16
	i32.store8	$drop=, r.c.0($pop17), $pop8
	i32.const	$push15=, 1
	return  	$pop15
.LBB4_4:                                # %if.then
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	r, .Lfunc_end4-r

	.hidden	check                   # @check
	.type	check,@object
	.section	.bss.check,"aw",@nobits
	.globl	check
	.p2align	2
check:
	.int32	0                       # 0x0
	.size	check, 4

	.hidden	o                       # @o
	.type	o,@object
	.section	.bss.o,"aw",@nobits
	.globl	o
	.p2align	2
o:
	.int32	0                       # 0x0
	.size	o, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"a"
	.size	.L.str, 2

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"b"
	.size	.L.str.1, 2

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"c"
	.size	.L.str.2, 2

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"d"
	.size	.L.str.3, 2

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"e"
	.size	.L.str.4, 2

	.type	.Lmain.args,@object     # @main.args
	.section	.data.rel.ro..Lmain.args,"aw",@progbits
	.p2align	4
.Lmain.args:
	.int32	.L.str
	.int32	.L.str.1
	.int32	.L.str.2
	.int32	.L.str.3
	.int32	.L.str.4
	.size	.Lmain.args, 20

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.p2align	2
h:
	.int32	0
	.size	h, 4

	.hidden	u                       # @u
	.type	u,@object
	.section	.bss.u,"aw",@nobits
	.globl	u
	.p2align	2
u:
	.int32	0
	.size	u, 4

	.type	r.cnt,@object           # @r.cnt
	.lcomm	r.cnt,4,2
	.type	r.c.0,@object           # @r.c.0
	.section	.data.r.c.0,"aw",@progbits
r.c.0:
	.int8	98                      # 0x62
	.size	r.c.0, 1


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
	.functype	strcmp, i32, i32, i32
