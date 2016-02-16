	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49390.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 4
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push2=, u+4
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push5=, 0
	i32.add 	$push4=, $3, $2
	i32.store	$discard=, v($pop5), $pop4
	i32.const	$push7=, 0
	i32.const	$push6=, 16384
	i32.store	$discard=, v($pop7), $pop6
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, 0($0)
	i32.store	$discard=, v($pop1), $pop0
	i32.const	$push3=, 0
	i32.load	$push2=, 4($0)
	i32.store	$discard=, v($pop3), $pop2
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, 0($0)
	i32.store	$discard=, v($pop1), $pop0
	i32.const	$push9=, 0
	i32.load	$push2=, 4($0)
	i32.store	$discard=, v($pop9), $pop2
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.store	$push3=, v($pop8), $pop7
	i32.load	$push4=, v($pop3)
	i32.const	$push5=, 1
	i32.add 	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$12=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$12=, 0($8), $12
	i32.const	$10=, 8
	i32.add 	$10=, $12, $10
	copy_local	$2=, $10
	i32.const	$push1=, 0
	i64.load	$push2=, a($pop1)
	i64.store	$1=, 8($12), $pop2
	block
	i32.const	$push72=, 0
	i32.eq  	$push73=, $0, $pop72
	br_if   	0, $pop73       # 0: down to label1
# BB#1:                                 # %if.else
	block
	i32.load	$push53=, 4($0)
	tee_local	$push52=, $5=, $pop53
	i32.const	$push6=, 8191
	i32.and 	$push51=, $pop52, $pop6
	tee_local	$push50=, $3=, $pop51
	i32.const	$push7=, 16
	i32.lt_u	$push8=, $pop50, $pop7
	br_if   	0, $pop8        # 0: down to label2
# BB#2:                                 # %if.else
	copy_local	$2=, $0
	i32.const	$push9=, 8192
	i32.sub 	$push5=, $pop9, $3
	i32.const	$push10=, 31
	i32.gt_u	$push11=, $pop5, $pop10
	br_if   	1, $pop11       # 1: down to label1
.LBB3_3:                                # %if.then5
	end_block                       # label2:
	i32.const	$push14=, 1
	i32.const	$push13=, 0
	i32.load	$push12=, 0($0)
	call    	foo@FUNCTION, $pop14, $pop13, $pop12, $5
	copy_local	$2=, $0
.LBB3_4:                                # %if.end7
	end_block                       # label1:
	block
	i32.call	$push15=, baz@FUNCTION, $2
	i32.const	$push74=, 0
	i32.eq  	$push75=, $pop15, $pop74
	br_if   	0, $pop75       # 0: down to label3
# BB#5:                                 # %if.end9
	i32.const	$push21=, 32
	i32.const	$push62=, 4
	i32.const	$push16=, 0
	i32.load	$push61=, b($pop16)
	tee_local	$push60=, $6=, $pop61
	i32.load16_u	$push59=, 2($pop60)
	tee_local	$push58=, $5=, $pop59
	i32.const	$push17=, 2
	i32.and 	$push18=, $pop58, $pop17
	i32.const	$push19=, 1
	i32.shr_u	$push20=, $pop18, $pop19
	i32.select	$0=, $pop21, $pop62, $pop20
	block
	block
	i32.load	$push57=, 4($2)
	tee_local	$push56=, $4=, $pop57
	i32.const	$push22=, 8191
	i32.and 	$push55=, $pop56, $pop22
	tee_local	$push54=, $3=, $pop55
	i32.const	$push76=, 0
	i32.eq  	$push77=, $pop54, $pop76
	br_if   	0, $pop77       # 0: down to label5
# BB#6:                                 # %if.else17
	i32.ge_u	$push23=, $3, $0
	br_if   	1, $pop23       # 1: down to label4
# BB#7:                                 # %if.then20
	i32.const	$push26=, 2
	i32.const	$push25=, 0
	i32.load	$push24=, 0($2)
	call    	foo@FUNCTION, $pop26, $pop25, $pop24, $4
	br      	2               # 2: down to label3
.LBB3_8:                                # %if.then15
	end_block                       # label5:
	i32.const	$push63=, 4
	i32.const	$11=, 8
	i32.add 	$11=, $12, $11
	i32.or  	$push27=, $11, $pop63
	i64.const	$push3=, 32
	i64.shr_u	$push4=, $1, $pop3
	i32.wrap/i64	$push0=, $pop4
	i32.add 	$push28=, $pop0, $0
	i32.store	$discard=, 0($pop27), $pop28
	copy_local	$3=, $0
.LBB3_9:                                # %if.end24
	end_block                       # label4:
	block
	i32.ne  	$push31=, $3, $0
	br_if   	0, $pop31       # 0: down to label6
# BB#10:                                # %if.end24
	i32.const	$push30=, 1
	i32.and 	$push29=, $5, $pop30
	i32.const	$push78=, 0
	i32.eq  	$push79=, $pop29, $pop78
	br_if   	0, $pop79       # 0: down to label6
# BB#11:                                # %if.then31
	i64.load	$push43=, 0($2):p2align=2
	i64.store	$discard=, 0($12):p2align=2, $pop43
	call    	bar@FUNCTION, $12
	i32.const	$push49=, 3
	i32.const	$push48=, 0
	i32.load	$push46=, 0($2)
	i32.const	$push44=, 4
	i32.add 	$push45=, $2, $pop44
	i32.load	$push47=, 0($pop45)
	call    	foo@FUNCTION, $pop49, $pop48, $pop46, $pop47
	br      	1               # 1: down to label3
.LBB3_12:                               # %if.end34
	end_block                       # label6:
	i32.const	$push32=, 4
	i32.add 	$push33=, $2, $pop32
	i32.load	$push71=, 0($pop33)
	tee_local	$push70=, $0=, $pop71
	i32.const	$push34=, 8191
	i32.and 	$push35=, $pop70, $pop34
	i32.add 	$push69=, $6, $pop35
	tee_local	$push68=, $3=, $pop69
	i32.load	$push67=, 4($pop68)
	tee_local	$push66=, $5=, $pop67
	i32.load	$push65=, 0($2)
	tee_local	$push64=, $2=, $pop65
	i32.lt_u	$push36=, $pop66, $pop64
	br_if   	0, $pop36       # 0: down to label3
# BB#13:                                # %land.lhs.true41
	block
	i32.ne  	$push37=, $5, $2
	br_if   	0, $pop37       # 0: down to label7
# BB#14:                                # %lor.lhs.false47
	i32.const	$push38=, 8
	i32.add 	$push39=, $3, $pop38
	i32.load	$push40=, 0($pop39)
	i32.lt_u	$push41=, $pop40, $0
	br_if   	1, $pop41       # 1: down to label3
.LBB3_15:                               # %if.then53
	end_block                       # label7:
	i32.const	$push42=, 4
	call    	foo@FUNCTION, $pop42, $3, $2, $0
.LBB3_16:                               # %cleanup
	end_block                       # label3:
	i32.const	$9=, 16
	i32.add 	$12=, $12, $9
	i32.const	$9=, __stack_pointer
	i32.store	$12=, 0($9), $12
	return
	.endfunc
.Lfunc_end3:
	.size	test, .Lfunc_end3-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, a
	i32.const	$0=, 0
	#APP
	#NO_APP
	i32.const	$push7=, 0
	i32.const	$push0=, 8192
	i32.store	$discard=, u+8($pop7), $pop0
	i32.const	$push6=, 0
	i32.const	$push1=, u
	i32.store	$discard=, b($pop6), $pop1
	call    	test@FUNCTION, $0
	block
	i32.const	$push5=, 0
	i32.load	$push2=, v($pop5)
	i32.const	$push3=, 16384
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label8
# BB#1:                                 # %if.end
	i32.const	$push8=, 0
	return  	$pop8
.LBB4_2:                                # %if.then
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.hidden	u                       # @u
	.type	u,@object
	.section	.bss.u,"aw",@nobits
	.globl	u
	.p2align	2
u:
	.skip	64
	.size	u, 64

	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.p2align	2
v:
	.int32	0                       # 0x0
	.size	v, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	3
a:
	.skip	8
	.size	a, 8

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0
	.size	b, 4


	.ident	"clang version 3.9.0 "
