	.text
	.file	"20010915-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push12=, 0
	i32.load	$push11=, __stack_pointer($pop12)
	i32.const	$push13=, 32
	i32.sub 	$2=, $pop11, $pop13
	i32.const	$push14=, 0
	i32.store	__stack_pointer($pop14), $2
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
# %bb.1:                                # %entry
	i32.const	$push21=, 0
	i32.load	$push0=, o($pop21)
	i32.const	$push20=, 5
	i32.ne  	$push9=, $pop0, $pop20
	br_if   	0, $pop9        # 0: down to label0
# %bb.2:                                # %if.end
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
                                        # -- End function
	.section	.text.x,"ax",@progbits
	.hidden	x                       # -- Begin function x
	.globl	x
	.type	x,@function
x:                                      # @x
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 3
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$push2=, 0
	i32.load	$3=, o($pop2)
	i32.ge_s	$push3=, $3, $0
	br_if   	0, $pop3        # 0: down to label1
# %bb.2:                                # %land.lhs.true2
	i32.const	$push4=, 2
	i32.shl 	$push5=, $3, $pop4
	i32.add 	$2=, $1, $pop5
	i32.load	$5=, 0($2)
	i32.eqz 	$push51=, $5
	br_if   	0, $pop51       # 0: down to label1
# %bb.3:                                # %if.then
	i32.const	$push6=, .L.str
	i32.call	$push7=, strcmp@FUNCTION, $5, $pop6
	br_if   	0, $pop7        # 0: down to label1
# %bb.4:                                # %lor.lhs.false.i
	i32.const	$push8=, 0
	i32.load	$4=, check($pop8)
	i32.const	$push31=, 0
	i32.const	$push9=, 1
	i32.add 	$push10=, $4, $pop9
	i32.store	check($pop31), $pop10
	i32.const	$push11=, 2
	i32.ge_s	$push12=, $4, $pop11
	br_if   	0, $pop12       # 0: down to label1
# %bb.5:                                # %s.exit
	i32.const	$push13=, .L.str
	i32.call	$push14=, strcmp@FUNCTION, $5, $pop13
	br_if   	0, $pop14       # 0: down to label1
# %bb.6:                                # %lor.lhs.false.i45
	i32.const	$push33=, 0
	i32.const	$push15=, 2
	i32.add 	$push16=, $4, $pop15
	i32.store	check($pop33), $pop16
	i32.const	$push32=, 1
	i32.ge_s	$push17=, $4, $pop32
	br_if   	0, $pop17       # 0: down to label1
# %bb.7:                                # %s.exit48
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.store	u($pop36), $pop35
	i32.load	$push19=, 0($2)
	i32.const	$push34=, 1
	i32.add 	$push18=, $5, $pop34
	i32.eq  	$push20=, $pop19, $pop18
	br_if   	0, $pop20       # 0: down to label1
# %bb.8:                                # %if.end19
	i32.const	$push38=, 1
	i32.add 	$5=, $3, $pop38
	i32.const	$push37=, 0
	i32.store	o($pop37), $5
	block   	
	i32.ge_s	$push21=, $5, $0
	br_if   	0, $pop21       # 0: down to label2
# %bb.9:                                # %while.body.lr.ph
	i32.const	$push22=, 2
	i32.shl 	$push23=, $5, $pop22
	i32.add 	$3=, $1, $pop23
	i32.const	$push39=, 0
	i32.load8_u	$4=, r.c.0($pop39)
.LBB1_10:                               # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.load	$2=, 0($3)
	i32.load8_u	$push25=, 0($2)
	i32.const	$push40=, 255
	i32.and 	$push24=, $4, $pop40
	i32.ne  	$push26=, $pop25, $pop24
	br_if   	2, $pop26       # 2: down to label1
# %bb.11:                               # %lor.lhs.false.i50
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.load8_u	$push27=, 1($2)
	br_if   	2, $pop27       # 2: down to label1
# %bb.12:                               # %lor.lhs.false.i50
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.const	$push42=, 0
	i32.load	$2=, r.cnt($pop42)
	i32.const	$push41=, 4
	i32.ge_s	$push28=, $2, $pop41
	br_if   	2, $pop28       # 2: down to label1
# %bb.13:                               # %r.exit
                                        #   in Loop: Header=BB1_10 Depth=1
	i32.const	$push49=, 0
	i32.const	$push48=, 1
	i32.add 	$push29=, $2, $pop48
	i32.store	r.cnt($pop49), $pop29
	i32.const	$push47=, 1
	i32.add 	$4=, $4, $pop47
	i32.const	$push46=, 0
	i32.store8	r.c.0($pop46), $4
	i32.const	$push45=, 1
	i32.add 	$5=, $5, $pop45
	i32.const	$push44=, 0
	i32.store	o($pop44), $5
	i32.const	$push43=, 4
	i32.add 	$3=, $3, $pop43
	i32.lt_s	$push30=, $5, $0
	br_if   	0, $pop30       # 0: up to label3
.LBB1_14:                               # %cleanup
	end_loop
	end_block                       # label2:
	i32.const	$push50=, 0
	return  	$pop50
.LBB1_15:                               # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	x, .Lfunc_end1-x
                                        # -- End function
	.section	.text.s,"ax",@progbits
	.hidden	s                       # -- Begin function s
	.globl	s
	.type	s,@function
s:                                      # @s
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, .L.str
	i32.call	$push1=, strcmp@FUNCTION, $0, $pop0
	br_if   	0, $pop1        # 0: down to label4
# %bb.1:                                # %lor.lhs.false
	i32.const	$push8=, 0
	i32.load	$2=, check($pop8)
	i32.const	$push7=, 0
	i32.const	$push6=, 1
	i32.add 	$push2=, $2, $pop6
	i32.store	check($pop7), $pop2
	i32.const	$push3=, 2
	i32.ge_s	$push4=, $2, $pop3
	br_if   	0, $pop4        # 0: down to label4
# %bb.2:                                # %if.end
	i32.const	$push10=, 1
	i32.add 	$push5=, $0, $pop10
	i32.store	0($1), $pop5
	i32.const	$push9=, 0
	return  	$pop9
.LBB2_3:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	s, .Lfunc_end2-s
                                        # -- End function
	.section	.text.m,"ax",@progbits
	.hidden	m                       # -- Begin function m
	.globl	m
	.type	m,@function
m:                                      # @m
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	m, .Lfunc_end3-m
                                        # -- End function
	.section	.text.r,"ax",@progbits
	.hidden	r                       # -- Begin function r
	.globl	r
	.type	r,@function
r:                                      # @r
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.load8_u	$1=, 0($0)
	block   	
	i32.const	$push9=, 0
	i32.load8_u	$push0=, r.c.0($pop9)
	i32.ne  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label5
# %bb.1:                                # %lor.lhs.false
	i32.load8_u	$push2=, 1($0)
	br_if   	0, $pop2        # 0: down to label5
# %bb.2:                                # %lor.lhs.false
	i32.const	$push10=, 0
	i32.load	$0=, r.cnt($pop10)
	i32.const	$push3=, 4
	i32.ge_s	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label5
# %bb.3:                                # %if.end
	i32.const	$push7=, 0
	i32.const	$push5=, 1
	i32.add 	$push6=, $0, $pop5
	i32.store	r.cnt($pop7), $pop6
	i32.const	$push13=, 0
	i32.const	$push12=, 1
	i32.add 	$push8=, $1, $pop12
	i32.store8	r.c.0($pop13), $pop8
	i32.const	$push11=, 1
	return  	$pop11
.LBB4_4:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	r, .Lfunc_end4-r
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
	.functype	strcmp, i32, i32, i32
