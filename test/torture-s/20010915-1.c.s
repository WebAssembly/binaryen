	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010915-1.c"
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
	i32.sub 	$push21=, $pop12, $pop13
	tee_local	$push20=, $2=, $pop21
	i32.store	__stack_pointer($pop14), $pop20
	i32.const	$push2=, 16
	i32.add 	$push3=, $2, $pop2
	i32.const	$push19=, 0
	i32.load	$push1=, .Lmain.args+16($pop19)
	i32.store	0($pop3), $pop1
	i32.const	$push18=, 0
	i64.load	$push4=, .Lmain.args+8($pop18)
	i64.store	8($2), $pop4
	i32.const	$push17=, 0
	i64.load	$push5=, .Lmain.args($pop17)
	i64.store	0($2), $pop5
	i32.const	$push16=, 5
	i32.call	$drop=, x@FUNCTION, $pop16, $2
	block   	
	i32.const	$push15=, 0
	i32.load	$push6=, check($pop15)
	i32.const	$push7=, 2
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push23=, 0
	i32.load	$push0=, o($pop23)
	i32.const	$push22=, 5
	i32.ne  	$push9=, $pop0, $pop22
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
	i32.const	$push0=, 3
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# BB#1:                                 # %entry
	i32.const	$push2=, 0
	i32.load	$push32=, o($pop2)
	tee_local	$push31=, $4=, $pop32
	i32.ge_s	$push3=, $pop31, $0
	br_if   	0, $pop3        # 0: down to label2
# BB#2:                                 # %land.lhs.true2
	i32.const	$push4=, 2
	i32.shl 	$push5=, $4, $pop4
	i32.add 	$push36=, $1, $pop5
	tee_local	$push35=, $2=, $pop36
	i32.load	$push34=, 0($pop35)
	tee_local	$push33=, $5=, $pop34
	i32.eqz 	$push69=, $pop33
	br_if   	0, $pop69       # 0: down to label2
# BB#3:                                 # %if.then
	block   	
	i32.const	$push6=, .L.str
	i32.call	$push7=, strcmp@FUNCTION, $5, $pop6
	br_if   	0, $pop7        # 0: down to label3
# BB#4:                                 # %lor.lhs.false.i
	i32.const	$push8=, 0
	i32.const	$push39=, 0
	i32.load	$push38=, check($pop39)
	tee_local	$push37=, $3=, $pop38
	i32.const	$push9=, 1
	i32.add 	$push10=, $pop37, $pop9
	i32.store	check($pop8), $pop10
	i32.const	$push11=, 2
	i32.ge_s	$push12=, $3, $pop11
	br_if   	0, $pop12       # 0: down to label3
# BB#5:                                 # %s.exit
	i32.const	$push13=, .L.str
	i32.call	$push14=, strcmp@FUNCTION, $5, $pop13
	br_if   	0, $pop14       # 0: down to label3
# BB#6:                                 # %lor.lhs.false.i45
	i32.const	$push41=, 0
	i32.const	$push15=, 2
	i32.add 	$push16=, $3, $pop15
	i32.store	check($pop41), $pop16
	i32.const	$push40=, 1
	i32.ge_s	$push17=, $3, $pop40
	br_if   	0, $pop17       # 0: down to label3
# BB#7:                                 # %s.exit48
	i32.const	$push44=, 0
	i32.const	$push43=, 0
	i32.store	u($pop44), $pop43
	i32.load	$push19=, 0($2)
	i32.const	$push42=, 1
	i32.add 	$push18=, $5, $pop42
	i32.eq  	$push20=, $pop19, $pop18
	br_if   	2, $pop20       # 2: down to label1
# BB#8:                                 # %while.cond.preheader
	i32.const	$push48=, 0
	i32.const	$push47=, 1
	i32.add 	$push46=, $4, $pop47
	tee_local	$push45=, $5=, $pop46
	i32.store	o($pop48), $pop45
	block   	
	block   	
	i32.ge_s	$push21=, $5, $0
	br_if   	0, $pop21       # 0: down to label5
# BB#9:                                 # %while.body.preheader
	i32.const	$push22=, 2
	i32.shl 	$push23=, $5, $pop22
	i32.add 	$3=, $1, $pop23
	i32.const	$push49=, 0
	i32.load8_u	$4=, r.c.0($pop49)
.LBB1_10:                               # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i32.load	$push52=, 0($3)
	tee_local	$push51=, $1=, $pop52
	i32.load8_u	$push25=, 0($pop51)
	i32.const	$push50=, 255
	i32.and 	$push24=, $4, $pop50
	i32.ne  	$push26=, $pop25, $pop24
	br_if   	2, $pop26       # 2: down to label4
# BB#11:                                # %lor.lhs.false.i50
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.load8_u	$push27=, 1($1)
	br_if   	2, $pop27       # 2: down to label4
# BB#12:                                # %lor.lhs.false.i50
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.const	$push56=, 0
	i32.load	$push55=, r.cnt($pop56)
	tee_local	$push54=, $1=, $pop55
	i32.const	$push53=, 4
	i32.ge_s	$push28=, $pop54, $pop53
	br_if   	2, $pop28       # 2: down to label4
# BB#13:                                # %r.exit
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.const	$push67=, 0
	i32.const	$push66=, 1
	i32.add 	$push29=, $1, $pop66
	i32.store	r.cnt($pop67), $pop29
	i32.const	$push65=, 0
	i32.const	$push64=, 1
	i32.add 	$push63=, $4, $pop64
	tee_local	$push62=, $4=, $pop63
	i32.store8	r.c.0($pop65), $pop62
	i32.const	$push61=, 0
	i32.const	$push60=, 1
	i32.add 	$push59=, $5, $pop60
	tee_local	$push58=, $5=, $pop59
	i32.store	o($pop61), $pop58
	i32.const	$push57=, 4
	i32.add 	$3=, $3, $pop57
	i32.lt_s	$push30=, $5, $0
	br_if   	0, $pop30       # 0: up to label6
.LBB1_14:                               # %cleanup
	end_loop
	end_block                       # label5:
	i32.const	$push68=, 0
	return  	$pop68
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
	i32.call	$drop=, m@FUNCTION, $5
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
	br_if   	0, $pop1        # 0: down to label7
# BB#1:                                 # %lor.lhs.false
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.load	$push8=, check($pop9)
	tee_local	$push7=, $2=, $pop8
	i32.const	$push6=, 1
	i32.add 	$push2=, $pop7, $pop6
	i32.store	check($pop10), $pop2
	i32.const	$push3=, 2
	i32.ge_s	$push4=, $2, $pop3
	br_if   	0, $pop4        # 0: down to label7
# BB#2:                                 # %if.end
	i32.const	$push12=, 1
	i32.add 	$push5=, $0, $pop12
	i32.store	0($1), $pop5
	i32.const	$push11=, 0
	return  	$pop11
.LBB2_3:                                # %if.then
	end_block                       # label7:
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
	br_if   	0, $pop1        # 0: down to label8
# BB#1:                                 # %lor.lhs.false
	i32.load8_u	$push2=, 1($0)
	br_if   	0, $pop2        # 0: down to label8
# BB#2:                                 # %lor.lhs.false
	i32.const	$push14=, 0
	i32.load	$push13=, r.cnt($pop14)
	tee_local	$push12=, $0=, $pop13
	i32.const	$push3=, 4
	i32.ge_s	$push4=, $pop12, $pop3
	br_if   	0, $pop4        # 0: down to label8
# BB#3:                                 # %if.end
	i32.const	$push7=, 0
	i32.const	$push5=, 1
	i32.add 	$push6=, $0, $pop5
	i32.store	r.cnt($pop7), $pop6
	i32.const	$push17=, 0
	i32.const	$push16=, 1
	i32.add 	$push8=, $1, $pop16
	i32.store8	r.c.0($pop17), $pop8
	i32.const	$push15=, 1
	return  	$pop15
.LBB4_4:                                # %if.then
	end_block                       # label8:
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
	.section	.rodata..Lmain.args,"a",@progbits
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
	.section	.bss.r.cnt,"aw",@nobits
	.p2align	2
r.cnt:
	.int32	0                       # 0x0
	.size	r.cnt, 4

	.type	r.c.0,@object           # @r.c.0
	.section	.data.r.c.0,"aw",@progbits
r.c.0:
	.int8	98                      # 0x62
	.size	r.c.0, 1


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
	.functype	strcmp, i32, i32, i32
