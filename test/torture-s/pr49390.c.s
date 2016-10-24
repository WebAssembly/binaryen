	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49390.c"
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
	i32.store	v($pop5), $pop4
	i32.const	$push7=, 0
	i32.const	$push6=, 16384
	i32.store	v($pop7), $pop6
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
	i32.store	v($pop1), $pop0
	i32.const	$push3=, 0
	i32.load	$push2=, 4($0)
	i32.store	v($pop3), $pop2
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
	i32.store	v($pop1), $pop0
	i32.const	$push9=, 0
	i32.load	$push2=, 4($0)
	i32.store	v($pop9), $pop2
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.store	v($pop8), $pop7
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
	.local  	i32, i32, i32, i32, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push53=, 0
	i32.const	$push50=, 0
	i32.load	$push51=, __stack_pointer($pop50)
	i32.const	$push52=, 16
	i32.sub 	$push62=, $pop51, $pop52
	tee_local	$push61=, $7=, $pop62
	i32.store	__stack_pointer($pop53), $pop61
	i32.const	$push1=, 0
	i64.load	$push60=, a($pop1)
	tee_local	$push59=, $5=, $pop60
	i64.store	8($7), $pop59
	block   	
	block   	
	block   	
	block   	
	i32.eqz 	$push83=, $0
	br_if   	0, $pop83       # 0: down to label4
# BB#1:                                 # %if.else
	block   	
	i32.load	$push66=, 4($0)
	tee_local	$push65=, $6=, $pop66
	i32.const	$push5=, 8191
	i32.and 	$push64=, $pop65, $pop5
	tee_local	$push63=, $3=, $pop64
	i32.const	$push7=, 16
	i32.lt_u	$push8=, $pop63, $pop7
	br_if   	0, $pop8        # 0: down to label5
# BB#2:                                 # %if.else
	i32.const	$push6=, 8192
	i32.sub 	$push4=, $pop6, $3
	i32.const	$push9=, 31
	i32.gt_u	$push10=, $pop4, $pop9
	br_if   	2, $pop10       # 2: down to label3
.LBB3_3:                                # %if.then5
	end_block                       # label5:
	i32.const	$push13=, 1
	i32.const	$push12=, 0
	i32.load	$push11=, 0($0)
	call    	foo@FUNCTION, $pop13, $pop12, $pop11, $6
	i32.call	$push14=, baz@FUNCTION, $0
	br_if   	2, $pop14       # 2: down to label2
	br      	3               # 3: down to label1
.LBB3_4:
	end_block                       # label4:
	i32.const	$push57=, 8
	i32.add 	$push58=, $7, $pop57
	copy_local	$0=, $pop58
.LBB3_5:                                # %if.end7
	end_block                       # label3:
	i32.call	$push15=, baz@FUNCTION, $0
	i32.eqz 	$push84=, $pop15
	br_if   	1, $pop84       # 1: down to label1
.LBB3_6:                                # %if.end9
	end_block                       # label2:
	i32.const	$push22=, 32
	i32.const	$push21=, 4
	i32.const	$push16=, 0
	i32.load	$push74=, b($pop16)
	tee_local	$push73=, $1=, $pop74
	i32.load16_u	$push72=, 2($pop73)
	tee_local	$push71=, $2=, $pop72
	i32.const	$push17=, 2
	i32.and 	$push18=, $pop71, $pop17
	i32.const	$push19=, 1
	i32.shr_u	$push20=, $pop18, $pop19
	i32.select	$3=, $pop22, $pop21, $pop20
	block   	
	block   	
	i32.load	$push70=, 4($0)
	tee_local	$push69=, $4=, $pop70
	i32.const	$push23=, 8191
	i32.and 	$push68=, $pop69, $pop23
	tee_local	$push67=, $6=, $pop68
	i32.eqz 	$push85=, $pop67
	br_if   	0, $pop85       # 0: down to label7
# BB#7:                                 # %if.else17
	i32.ge_u	$push24=, $6, $3
	br_if   	1, $pop24       # 1: down to label6
# BB#8:                                 # %if.then20
	i32.const	$push27=, 2
	i32.const	$push26=, 0
	i32.load	$push25=, 0($0)
	call    	foo@FUNCTION, $pop27, $pop26, $pop25, $4
	br      	2               # 2: down to label1
.LBB3_9:                                # %if.then15
	end_block                       # label7:
	i64.const	$push2=, 32
	i64.shr_u	$push3=, $5, $pop2
	i32.wrap/i64	$push0=, $pop3
	i32.add 	$push28=, $pop0, $3
	i32.store	12($7), $pop28
	copy_local	$6=, $3
.LBB3_10:                               # %if.end24
	end_block                       # label6:
	block   	
	i32.const	$push29=, 1
	i32.and 	$push30=, $2, $pop29
	i32.eqz 	$push86=, $pop30
	br_if   	0, $pop86       # 0: down to label8
# BB#11:                                # %if.end24
	i32.ne  	$push31=, $6, $3
	br_if   	0, $pop31       # 0: down to label8
# BB#12:                                # %if.then31
	i64.load	$push43=, 0($0):p2align=2
	i64.store	0($7):p2align=2, $pop43
	call    	bar@FUNCTION, $7
	i32.const	$push49=, 3
	i32.const	$push48=, 0
	i32.load	$push47=, 0($0)
	i32.const	$push44=, 4
	i32.add 	$push45=, $0, $pop44
	i32.load	$push46=, 0($pop45)
	call    	foo@FUNCTION, $pop49, $pop48, $pop47, $pop46
	br      	1               # 1: down to label1
.LBB3_13:                               # %if.end34
	end_block                       # label8:
	i32.const	$push32=, 4
	i32.add 	$push33=, $0, $pop32
	i32.load	$push82=, 0($pop33)
	tee_local	$push81=, $3=, $pop82
	i32.const	$push34=, 8191
	i32.and 	$push35=, $pop81, $pop34
	i32.add 	$push80=, $1, $pop35
	tee_local	$push79=, $6=, $pop80
	i32.load	$push78=, 4($pop79)
	tee_local	$push77=, $2=, $pop78
	i32.load	$push76=, 0($0)
	tee_local	$push75=, $0=, $pop76
	i32.lt_u	$push36=, $pop77, $pop75
	br_if   	0, $pop36       # 0: down to label1
# BB#14:                                # %land.lhs.true41
	block   	
	i32.ne  	$push37=, $2, $0
	br_if   	0, $pop37       # 0: down to label9
# BB#15:                                # %lor.lhs.false47
	i32.const	$push38=, 8
	i32.add 	$push39=, $6, $pop38
	i32.load	$push40=, 0($pop39)
	i32.lt_u	$push41=, $pop40, $3
	br_if   	1, $pop41       # 1: down to label1
.LBB3_16:                               # %if.then53
	end_block                       # label9:
	i32.const	$push42=, 4
	call    	foo@FUNCTION, $pop42, $6, $0, $3
.LBB3_17:                               # %cleanup
	end_block                       # label1:
	i32.const	$push56=, 0
	i32.const	$push54=, 16
	i32.add 	$push55=, $7, $pop54
	i32.store	__stack_pointer($pop56), $pop55
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
	i32.store	b($pop7), $pop0
	i32.const	$push6=, 0
	i32.const	$push1=, 8192
	i32.store	u+8($pop6), $pop1
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
	br_if   	0, $pop4        # 0: down to label10
# BB#1:                                 # %if.end
	i32.const	$push8=, 0
	return  	$pop8
.LBB4_2:                                # %if.then
	end_block                       # label10:
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
