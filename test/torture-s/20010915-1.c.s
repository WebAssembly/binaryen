	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010915-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 32
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.const	$2=, 0
	i32.const	$push2=, 16
	i32.const	$6=, 0
	i32.add 	$6=, $7, $6
	i32.add 	$push3=, $6, $pop2
	i32.load	$push1=, .Lmain.args+16($2)
	i32.store	$discard=, 0($pop3), $pop1
	i32.const	$push5=, 8
	i32.const	$7=, 0
	i32.add 	$7=, $7, $7
	i32.or  	$push6=, $7, $pop5
	i64.load	$push4=, .Lmain.args+8($2)
	i64.store	$discard=, 0($pop6), $pop4
	i32.const	$3=, 5
	i64.load	$push7=, .Lmain.args($2)
	i64.store	$discard=, 0($7), $pop7
	i32.const	$8=, 0
	i32.add 	$8=, $7, $8
	i32.call	$discard=, x@FUNCTION, $3, $8
	block
	i32.load	$push8=, check($2)
	i32.const	$push9=, 2
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	$pop10, 0       # 0: down to label0
# BB#1:                                 # %entry
	i32.load	$push0=, o($2)
	i32.ne  	$push11=, $pop0, $3
	br_if   	$pop11, 0       # 0: down to label0
# BB#2:                                 # %if.end
	call    	exit@FUNCTION, $2
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
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push3=, 3
	i32.lt_s	$push4=, $0, $pop3
	br_if   	$pop4, 0        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$4=, 0
	i32.load	$6=, o($4)
	i32.ge_s	$push5=, $6, $0
	br_if   	$pop5, 0        # 0: down to label1
# BB#2:                                 # %land.lhs.true2
	i32.const	$3=, 2
	i32.shl 	$push6=, $6, $3
	i32.add 	$2=, $1, $pop6
	i32.load	$8=, 0($2)
	i32.const	$push25=, 0
	i32.eq  	$push26=, $8, $pop25
	br_if   	$pop26, 0       # 0: down to label1
# BB#3:                                 # %if.then
	i32.const	$5=, .L.str
	block
	i32.call	$push7=, strcmp@FUNCTION, $8, $5
	br_if   	$pop7, 0        # 0: down to label2
# BB#4:                                 # %lor.lhs.false.i
	i32.load	$7=, check($4)
	i32.const	$1=, 1
	i32.add 	$push8=, $7, $1
	i32.store	$discard=, check($4), $pop8
	i32.ge_s	$push9=, $7, $3
	br_if   	$pop9, 0        # 0: down to label2
# BB#5:                                 # %s.exit
	block
	i32.call	$push10=, strcmp@FUNCTION, $8, $5
	br_if   	$pop10, 0       # 0: down to label3
# BB#6:                                 # %lor.lhs.false.i45
	i32.add 	$push11=, $7, $3
	i32.store	$discard=, check($4), $pop11
	i32.ge_s	$push12=, $7, $1
	br_if   	$pop12, 0       # 0: down to label3
# BB#7:                                 # %s.exit48
	i32.store	$discard=, u($4), $4
	block
	i32.load	$push14=, 0($2)
	i32.add 	$push13=, $8, $1
	i32.eq  	$push15=, $pop14, $pop13
	br_if   	$pop15, 0       # 0: down to label4
# BB#8:                                 # %while.cond.preheader
	block
	i32.add 	$push0=, $6, $1
	i32.store	$8=, o($4), $pop0
	i32.ge_s	$push16=, $8, $0
	br_if   	$pop16, 0       # 0: down to label5
# BB#9:                                 # %while.body.preheader
	i32.load8_u	$7=, r.c.0($4)
	i32.const	$5=, 4
	i32.add 	$6=, $2, $5
.LBB1_10:                               # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.load	$3=, 0($6)
	i32.load8_u	$push17=, 0($3)
	i32.const	$push18=, 255
	i32.and 	$push19=, $7, $pop18
	i32.ne  	$push20=, $pop17, $pop19
	br_if   	$pop20, 1       # 1: down to label7
# BB#11:                                # %lor.lhs.false.i50
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.load8_u	$push21=, 1($3)
	br_if   	$pop21, 1       # 1: down to label7
# BB#12:                                # %lor.lhs.false.i50
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.load	$3=, r.cnt($4)
	i32.ge_s	$push22=, $3, $5
	br_if   	$pop22, 1       # 1: down to label7
# BB#13:                                # %r.exit
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.add 	$push23=, $3, $1
	i32.store	$discard=, r.cnt($4), $pop23
	i32.add 	$push1=, $7, $1
	i32.store8	$7=, r.c.0($4), $pop1
	i32.add 	$push2=, $8, $1
	i32.store	$8=, o($4), $pop2
	i32.add 	$6=, $6, $5
	i32.lt_s	$push24=, $8, $0
	br_if   	$pop24, 0       # 0: up to label6
	br      	2               # 2: down to label5
.LBB1_14:                               # %if.then.i51
	end_loop                        # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_15:                               # %cleanup
	end_block                       # label5:
	return  	$4
.LBB1_16:                               # %if.then15
	end_block                       # label4:
	i32.call	$discard=, m@FUNCTION, $4
	unreachable
.LBB1_17:                               # %if.then.i46
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_18:                               # %if.then.i
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_19:                               # %if.else
	end_block                       # label1:
	call    	abort@FUNCTION
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, .L.str
	i32.call	$push1=, strcmp@FUNCTION, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label8
# BB#1:                                 # %lor.lhs.false
	i32.const	$2=, 0
	i32.load	$3=, check($2)
	i32.const	$4=, 1
	i32.add 	$push2=, $3, $4
	i32.store	$discard=, check($2), $pop2
	i32.const	$push3=, 2
	i32.ge_s	$push4=, $3, $pop3
	br_if   	$pop4, 0        # 0: down to label8
# BB#2:                                 # %if.end
	i32.add 	$push5=, $0, $4
	i32.store	$discard=, 0($1), $pop5
	return  	$2
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.load8_u	$1=, 0($0)
	i32.const	$3=, 0
	block
	i32.load8_u	$push0=, r.c.0($3)
	i32.ne  	$push1=, $1, $pop0
	br_if   	$pop1, 0        # 0: down to label9
# BB#1:                                 # %lor.lhs.false
	i32.load8_u	$push2=, 1($0)
	br_if   	$pop2, 0        # 0: down to label9
# BB#2:                                 # %lor.lhs.false
	i32.load	$2=, r.cnt($3)
	i32.const	$push3=, 4
	i32.ge_s	$push4=, $2, $pop3
	br_if   	$pop4, 0        # 0: down to label9
# BB#3:                                 # %if.end
	i32.const	$0=, 1
	i32.add 	$push5=, $1, $0
	i32.store8	$discard=, r.c.0($3), $pop5
	i32.add 	$push6=, $2, $0
	i32.store	$discard=, r.cnt($3), $pop6
	return  	$0
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
	.align	2
check:
	.int32	0                       # 0x0
	.size	check, 4

	.hidden	o                       # @o
	.type	o,@object
	.section	.bss.o,"aw",@nobits
	.globl	o
	.align	2
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
	.align	4
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
	.align	2
h:
	.int32	0
	.size	h, 4

	.hidden	u                       # @u
	.type	u,@object
	.section	.bss.u,"aw",@nobits
	.globl	u
	.align	2
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
	.section	".note.GNU-stack","",@progbits
