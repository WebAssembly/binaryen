	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56205.c"
	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 16
	i32.sub 	$16=, $13, $14
	copy_local	$17=, $16
	i32.const	$14=, __stack_pointer
	i32.store	$16=, 0($14), $16
	i32.store	$discard=, 12($16), $17
	block
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push18=, 0
	i32.load8_u	$push1=, c($pop18):p2align=4
	i32.const	$push2=, 255
	i32.and 	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.then
	i32.const	$push4=, 0
	i32.const	$push19=, 0
	i32.load	$push5=, b($pop19)
	i32.const	$push6=, 1
	i32.add 	$push7=, $pop5, $pop6
	i32.store	$discard=, b($pop4), $pop7
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.const	$push22=, .L.str.3
	i32.const	$push8=, .L.str.1
	i32.select	$0=, $pop22, $pop8, $0
	i32.load	$2=, 12($16)
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.load	$push9=, a($pop20)
	i32.const	$push10=, 1
	i32.add 	$push0=, $pop9, $pop10
	i32.store	$3=, a($pop21), $pop0
	block
	block
	i32.const	$push25=, 0
	i32.eq  	$push26=, $1, $pop25
	br_if   	0, $pop26       # 0: down to label2
# BB#4:                                 # %land.rhs.i
	i32.load8_u	$4=, 0($1)
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 12
	i32.sub 	$16=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$16=, 0($6), $16
	i32.store	$discard=, 0($16), $0
	i32.const	$push13=, 8
	i32.add 	$0=, $16, $pop13
	i32.const	$push11=, .L.str.4
	i32.const	$push23=, .L.str.3
	i32.select	$push12=, $pop11, $pop23, $4
	i32.store	$discard=, 0($0), $pop12
	i32.const	$push14=, 4
	i32.add 	$0=, $16, $pop14
	i32.store	$discard=, 0($0), $3
	call    	f1@FUNCTION, $1
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 12
	i32.add 	$16=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$16=, 0($8), $16
	i32.load8_u	$push15=, 0($1)
	i32.const	$push27=, 0
	i32.eq  	$push28=, $pop15, $pop27
	br_if   	1, $pop28       # 1: down to label1
# BB#5:                                 # %if.then.i
	call    	f2@FUNCTION, $1, $2
	br      	1               # 1: down to label1
.LBB0_6:                                # %if.end.critedge.i
	end_block                       # label2:
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 12
	i32.sub 	$16=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$16=, 0($10), $16
	i32.store	$discard=, 0($16), $0
	i32.const	$push16=, 8
	i32.add 	$1=, $16, $pop16
	i32.const	$push24=, .L.str.3
	i32.store	$discard=, 0($1), $pop24
	i32.const	$push17=, 4
	i32.add 	$1=, $16, $pop17
	i32.store	$discard=, 0($1), $3
	call    	f1@FUNCTION, $1
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 12
	i32.add 	$16=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$16=, 0($12), $16
.LBB0_7:                                # %f3.exit
	end_block                       # label1:
	i32.const	$15=, 16
	i32.add 	$16=, $17, $15
	i32.const	$15=, __stack_pointer
	i32.store	$16=, 0($15), $16
	return
	.endfunc
.Lfunc_end0:
	.size	f4, .Lfunc_end0-f4

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 32
	i32.sub 	$8=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$8=, 0($6), $8
	#APP
	#NO_APP
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 24
	i32.sub 	$8=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$8=, 0($2), $8
	i32.const	$push1=, .L.str.1
	i32.store	$discard=, 0($8), $pop1
	i32.const	$push2=, 16
	i32.add 	$0=, $8, $pop2
	i32.const	$push3=, 26
	i32.store	$discard=, 0($0), $pop3
	i32.const	$push4=, 8
	i32.add 	$0=, $8, $pop4
	i64.const	$push5=, 4622945017495814144
	i64.store	$discard=, 0($0), $pop5
	i32.const	$push13=, 0
	i32.const	$push6=, .L.str
	call    	f4@FUNCTION, $pop13, $pop6
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 24
	i32.add 	$8=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$8=, 0($4), $8
	block
	i32.const	$push12=, 0
	i32.load	$push7=, a($pop12)
	i32.const	$push11=, 1
	i32.ne  	$push8=, $pop7, $pop11
	br_if   	0, $pop8        # 0: down to label3
# BB#1:                                 # %entry
	i32.const	$push15=, 0
	i32.load	$push0=, b($pop15)
	i32.const	$push14=, 1
	i32.ne  	$push9=, $pop0, $pop14
	br_if   	0, $pop9        # 0: down to label3
# BB#2:                                 # %if.end
	i32.const	$push10=, 0
	i32.const	$7=, 32
	i32.add 	$8=, $8, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	return  	$pop10
.LBB1_3:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.section	.text.f1,"ax",@progbits
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	copy_local	$6=, $5
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	#APP
	#NO_APP
	i32.store	$push0=, 12($5), $6
	i32.const	$push27=, 3
	i32.add 	$push1=, $pop0, $pop27
	i32.const	$push26=, -4
	i32.and 	$push2=, $pop1, $pop26
	tee_local	$push25=, $1=, $pop2
	i32.const	$push24=, 4
	i32.add 	$push3=, $pop25, $pop24
	i32.store	$discard=, 12($5), $pop3
	block
	i32.load	$push4=, 0($1)
	i32.const	$push5=, .L.str.1
	i32.call	$push6=, strcmp@FUNCTION, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label4
# BB#1:                                 # %lor.lhs.false
	i32.load	$push7=, 12($5)
	i32.const	$push31=, 3
	i32.add 	$push8=, $pop7, $pop31
	i32.const	$push30=, -4
	i32.and 	$push9=, $pop8, $pop30
	tee_local	$push29=, $1=, $pop9
	i32.const	$push28=, 4
	i32.add 	$push10=, $pop29, $pop28
	i32.store	$discard=, 12($5), $pop10
	i32.load	$push11=, 0($1)
	i32.const	$push12=, 1
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label4
# BB#2:                                 # %lor.lhs.false5
	i32.load	$push14=, 12($5)
	i32.const	$push15=, 3
	i32.add 	$push16=, $pop14, $pop15
	i32.const	$push17=, -4
	i32.and 	$push18=, $pop16, $pop17
	tee_local	$push32=, $1=, $pop18
	i32.const	$push19=, 4
	i32.add 	$push20=, $pop32, $pop19
	i32.store	$discard=, 12($5), $pop20
	i32.load	$push21=, 0($1)
	i32.const	$push22=, .L.str.4
	i32.call	$push23=, strcmp@FUNCTION, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label4
# BB#3:                                 # %if.end9
	i32.const	$4=, 16
	i32.add 	$5=, $6, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB2_4:                                # %if.then8
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f1, .Lfunc_end2-f1

	.section	.text.f2,"ax",@progbits
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$discard=, 12($5), $1
	#APP
	#NO_APP
	block
	i32.const	$push0=, .L.str
	i32.call	$push1=, strcmp@FUNCTION, $0, $pop0
	br_if   	0, $pop1        # 0: down to label5
# BB#1:                                 # %lor.lhs.false
	i32.load	$push2=, 12($5)
	i32.const	$push3=, 3
	i32.add 	$push4=, $pop2, $pop3
	i32.const	$push5=, -4
	i32.and 	$push6=, $pop4, $pop5
	tee_local	$push32=, $0=, $pop6
	i32.const	$push7=, 4
	i32.add 	$push8=, $pop32, $pop7
	i32.store	$discard=, 12($5), $pop8
	i32.load	$push9=, 0($0)
	i32.const	$push10=, .L.str.1
	i32.call	$push11=, strcmp@FUNCTION, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label5
# BB#2:                                 # %lor.lhs.false3
	i32.load	$push12=, 12($5)
	i32.const	$push13=, 7
	i32.add 	$push14=, $pop12, $pop13
	i32.const	$push15=, -8
	i32.and 	$push16=, $pop14, $pop15
	tee_local	$push33=, $0=, $pop16
	i32.const	$push17=, 8
	i32.add 	$push18=, $pop33, $pop17
	i32.store	$discard=, 12($5), $pop18
	f64.load	$push19=, 0($0)
	f64.const	$push20=, 0x1.8p3
	f64.ne  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label5
# BB#3:                                 # %lor.lhs.false5
	i32.load	$push22=, 12($5)
	i32.const	$push23=, 3
	i32.add 	$push24=, $pop22, $pop23
	i32.const	$push25=, -4
	i32.and 	$push26=, $pop24, $pop25
	tee_local	$push34=, $0=, $pop26
	i32.const	$push27=, 4
	i32.add 	$push28=, $pop34, $pop27
	i32.store	$discard=, 12($5), $pop28
	i32.load	$push29=, 0($0)
	i32.const	$push30=, 26
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label5
# BB#4:                                 # %if.end
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB3_5:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	f2, .Lfunc_end3-f2

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	4
c:
	.skip	128
	.size	c, 128

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"baz"
	.size	.L.str, 4

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"foo"
	.size	.L.str.1, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.type	.L.str.3,@object        # @.str.3
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.3:
	.skip	1
	.size	.L.str.3, 1

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"bar"
	.size	.L.str.4, 4


	.ident	"clang version 3.9.0 "
