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
	i32.store	$drop=, v($pop5), $pop4
	i32.const	$push7=, 0
	i32.const	$push6=, 16384
	i32.store	$drop=, v($pop7), $pop6
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
	i32.store	$drop=, v($pop1), $pop0
	i32.const	$push3=, 0
	i32.load	$push2=, 4($0)
	i32.store	$drop=, v($pop3), $pop2
                                        # fallthrough-return
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
	i32.store	$drop=, v($pop1), $pop0
	i32.const	$push9=, 0
	i32.load	$push2=, 4($0)
	i32.store	$drop=, v($pop9), $pop2
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.store	$drop=, v($pop8), $pop7
	i32.const	$push6=, 0
	i32.load	$push3=, v($pop6)
	i32.const	$push4=, 1
	i32.add 	$push5=, $pop3, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.local  	i32, i32, i32, i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push52=, 0
	i32.const	$push49=, 0
	i32.load	$push50=, __stack_pointer($pop49)
	i32.const	$push51=, 16
	i32.sub 	$push61=, $pop50, $pop51
	tee_local	$push60=, $7=, $pop61
	i32.store	$drop=, __stack_pointer($pop52), $pop60
	i32.const	$push1=, 0
	i64.load	$push59=, a($pop1)
	tee_local	$push58=, $4=, $pop59
	i64.store	$drop=, 8($7), $pop58
	i32.const	$push56=, 8
	i32.add 	$push57=, $7, $pop56
	copy_local	$5=, $pop57
	block
	i32.eqz 	$push82=, $0
	br_if   	0, $pop82       # 0: down to label1
# BB#1:                                 # %if.else
	block
	block
	i32.load	$push65=, 4($0)
	tee_local	$push64=, $6=, $pop65
	i32.const	$push5=, 8191
	i32.and 	$push63=, $pop64, $pop5
	tee_local	$push62=, $5=, $pop63
	i32.const	$push7=, 16
	i32.lt_u	$push8=, $pop62, $pop7
	br_if   	0, $pop8        # 0: down to label3
# BB#2:                                 # %if.else
	i32.const	$push6=, 8192
	i32.sub 	$push4=, $pop6, $5
	i32.const	$push9=, 31
	i32.gt_u	$push10=, $pop4, $pop9
	br_if   	1, $pop10       # 1: down to label2
.LBB3_3:                                # %if.then5
	end_block                       # label3:
	i32.const	$push13=, 1
	i32.const	$push12=, 0
	i32.load	$push11=, 0($0)
	call    	foo@FUNCTION, $pop13, $pop12, $pop11, $6
.LBB3_4:                                # %if.end7
	end_block                       # label2:
	copy_local	$5=, $0
.LBB3_5:                                # %if.end7
	end_block                       # label1:
	block
	i32.call	$push14=, baz@FUNCTION, $5
	i32.eqz 	$push83=, $pop14
	br_if   	0, $pop83       # 0: down to label4
# BB#6:                                 # %if.end9
	i32.const	$push21=, 32
	i32.const	$push20=, 4
	i32.const	$push15=, 0
	i32.load	$push73=, b($pop15)
	tee_local	$push72=, $1=, $pop73
	i32.load16_u	$push71=, 2($pop72)
	tee_local	$push70=, $2=, $pop71
	i32.const	$push16=, 2
	i32.and 	$push17=, $pop70, $pop16
	i32.const	$push18=, 1
	i32.shr_u	$push19=, $pop17, $pop18
	i32.select	$0=, $pop21, $pop20, $pop19
	block
	block
	i32.load	$push69=, 4($5)
	tee_local	$push68=, $3=, $pop69
	i32.const	$push22=, 8191
	i32.and 	$push67=, $pop68, $pop22
	tee_local	$push66=, $6=, $pop67
	i32.eqz 	$push84=, $pop66
	br_if   	0, $pop84       # 0: down to label6
# BB#7:                                 # %if.else17
	i32.ge_u	$push23=, $6, $0
	br_if   	1, $pop23       # 1: down to label5
# BB#8:                                 # %if.then20
	i32.const	$push26=, 2
	i32.const	$push25=, 0
	i32.load	$push24=, 0($5)
	call    	foo@FUNCTION, $pop26, $pop25, $pop24, $3
	br      	2               # 2: down to label4
.LBB3_9:                                # %if.then15
	end_block                       # label6:
	i64.const	$push2=, 32
	i64.shr_u	$push3=, $4, $pop2
	i32.wrap/i64	$push0=, $pop3
	i32.add 	$push27=, $pop0, $0
	i32.store	$drop=, 12($7), $pop27
	copy_local	$6=, $0
.LBB3_10:                               # %if.end24
	end_block                       # label5:
	block
	i32.const	$push28=, 1
	i32.and 	$push29=, $2, $pop28
	i32.eqz 	$push85=, $pop29
	br_if   	0, $pop85       # 0: down to label7
# BB#11:                                # %if.end24
	i32.ne  	$push30=, $6, $0
	br_if   	0, $pop30       # 0: down to label7
# BB#12:                                # %if.then31
	i64.load	$push42=, 0($5):p2align=2
	i64.store	$drop=, 0($7):p2align=2, $pop42
	call    	bar@FUNCTION, $7
	i32.const	$push48=, 3
	i32.const	$push47=, 0
	i32.load	$push46=, 0($5)
	i32.const	$push43=, 4
	i32.add 	$push44=, $5, $pop43
	i32.load	$push45=, 0($pop44)
	call    	foo@FUNCTION, $pop48, $pop47, $pop46, $pop45
	br      	1               # 1: down to label4
.LBB3_13:                               # %if.end34
	end_block                       # label7:
	i32.const	$push31=, 4
	i32.add 	$push32=, $5, $pop31
	i32.load	$push81=, 0($pop32)
	tee_local	$push80=, $0=, $pop81
	i32.const	$push33=, 8191
	i32.and 	$push34=, $pop80, $pop33
	i32.add 	$push79=, $1, $pop34
	tee_local	$push78=, $6=, $pop79
	i32.load	$push77=, 4($pop78)
	tee_local	$push76=, $2=, $pop77
	i32.load	$push75=, 0($5)
	tee_local	$push74=, $5=, $pop75
	i32.lt_u	$push35=, $pop76, $pop74
	br_if   	0, $pop35       # 0: down to label4
# BB#14:                                # %land.lhs.true41
	block
	i32.ne  	$push36=, $2, $5
	br_if   	0, $pop36       # 0: down to label8
# BB#15:                                # %lor.lhs.false47
	i32.const	$push37=, 8
	i32.add 	$push38=, $6, $pop37
	i32.load	$push39=, 0($pop38)
	i32.lt_u	$push40=, $pop39, $0
	br_if   	1, $pop40       # 1: down to label4
.LBB3_16:                               # %if.then53
	end_block                       # label8:
	i32.const	$push41=, 4
	call    	foo@FUNCTION, $pop41, $6, $5, $0
.LBB3_17:                               # %cleanup
	end_block                       # label4:
	i32.const	$push55=, 0
	i32.const	$push53=, 16
	i32.add 	$push54=, $7, $pop53
	i32.store	$drop=, __stack_pointer($pop55), $pop54
                                        # fallthrough-return
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
	i32.const	$push7=, 0
	i32.const	$push0=, u
	i32.store	$drop=, b($pop7), $pop0
	i32.const	$push6=, 0
	i32.const	$push1=, 8192
	i32.store	$drop=, u+8($pop6), $pop1
	i32.const	$1=, a
	i32.const	$0=, 0
	#APP
	#NO_APP
	call    	test@FUNCTION, $0
	block
	i32.const	$push5=, 0
	i32.load	$push2=, v($pop5)
	i32.const	$push3=, 16384
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label9
# BB#1:                                 # %if.end
	i32.const	$push8=, 0
	return  	$pop8
.LBB4_2:                                # %if.then
	end_block                       # label9:
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
