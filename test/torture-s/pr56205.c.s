	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56205.c"
	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 32
	i32.sub 	$11=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$11=, 0($6), $11
	i32.store	$discard=, 28($11), $2
	block
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push22=, 0
	i32.load8_u	$push1=, c($pop22):p2align=4
	i32.const	$push2=, 255
	i32.and 	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.then
	i32.const	$push4=, 0
	i32.const	$push23=, 0
	i32.load	$push5=, b($pop23)
	i32.const	$push6=, 1
	i32.add 	$push7=, $pop5, $pop6
	i32.store	$discard=, b($pop4), $pop7
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.const	$push26=, .L.str.3
	i32.const	$push8=, .L.str.1
	i32.select	$0=, $pop26, $pop8, $0
	i32.load	$3=, 28($11)
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load	$push9=, a($pop24)
	i32.const	$push10=, 1
	i32.add 	$push0=, $pop9, $pop10
	i32.store	$2=, a($pop25), $pop0
	block
	block
	i32.const	$push29=, 0
	i32.eq  	$push30=, $1, $pop29
	br_if   	0, $pop30       # 0: down to label2
# BB#4:                                 # %land.rhs.i
	i32.load8_u	$4=, 0($1)
	i32.const	$push13=, 4
	i32.const	$8=, 16
	i32.add 	$8=, $11, $8
	i32.or  	$push14=, $8, $pop13
	i32.store	$discard=, 0($pop14), $2
	i32.const	$push15=, 8
	i32.const	$9=, 16
	i32.add 	$9=, $11, $9
	i32.or  	$push16=, $9, $pop15
	i32.const	$push11=, .L.str.4
	i32.const	$push27=, .L.str.3
	i32.select	$push12=, $pop11, $pop27, $4
	i32.store	$discard=, 0($pop16):p2align=3, $pop12
	i32.store	$discard=, 16($11):p2align=4, $0
	i32.const	$10=, 16
	i32.add 	$10=, $11, $10
	call    	f1@FUNCTION, $1, $10
	i32.load8_u	$push17=, 0($1)
	i32.const	$push31=, 0
	i32.eq  	$push32=, $pop17, $pop31
	br_if   	1, $pop32       # 1: down to label1
# BB#5:                                 # %if.then.i
	call    	f2@FUNCTION, $1, $3
	br      	1               # 1: down to label1
.LBB0_6:                                # %if.end.critedge.i
	end_block                       # label2:
	i32.const	$push18=, 8
	i32.or  	$push19=, $11, $pop18
	i32.const	$push28=, .L.str.3
	i32.store	$discard=, 0($pop19):p2align=3, $pop28
	i32.const	$push20=, 4
	i32.or  	$push21=, $11, $pop20
	i32.store	$discard=, 0($pop21), $2
	i32.store	$discard=, 0($11):p2align=4, $0
	call    	f1@FUNCTION, $1, $11
.LBB0_7:                                # %f3.exit
	end_block                       # label1:
	i32.const	$7=, 32
	i32.add 	$11=, $11, $7
	i32.const	$7=, __stack_pointer
	i32.store	$11=, 0($7), $11
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 32
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	#APP
	#NO_APP
	i32.const	$push1=, 16
	i32.add 	$push2=, $3, $pop1
	i32.const	$push3=, 26
	i32.store	$discard=, 0($pop2):p2align=4, $pop3
	i32.const	$push4=, 8
	i32.or  	$push5=, $3, $pop4
	i64.const	$push6=, 4622945017495814144
	i64.store	$discard=, 0($pop5), $pop6
	i32.const	$push7=, .L.str.1
	i32.store	$discard=, 0($3):p2align=4, $pop7
	i32.const	$push15=, 0
	i32.const	$push8=, .L.str
	call    	f4@FUNCTION, $pop15, $pop8, $3
	block
	i32.const	$push14=, 0
	i32.load	$push9=, a($pop14)
	i32.const	$push13=, 1
	i32.ne  	$push10=, $pop9, $pop13
	br_if   	0, $pop10       # 0: down to label3
# BB#1:                                 # %entry
	i32.const	$push17=, 0
	i32.load	$push0=, b($pop17)
	i32.const	$push16=, 1
	i32.ne  	$push11=, $pop0, $pop16
	br_if   	0, $pop11       # 0: down to label3
# BB#2:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$2=, 32
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return  	$pop12
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
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	#APP
	#NO_APP
	i32.store	$push0=, 12($5), $1
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
	i32.add 	$5=, $5, $4
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
