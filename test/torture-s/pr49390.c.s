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
	i32.const	$push54=, 0
	i32.const	$push52=, 0
	i32.load	$push51=, __stack_pointer($pop52)
	i32.const	$push53=, 16
	i32.sub 	$push63=, $pop51, $pop53
	tee_local	$push62=, $7=, $pop63
	i32.store	__stack_pointer($pop54), $pop62
	i32.const	$push1=, 0
	i64.load	$push61=, a($pop1)
	tee_local	$push60=, $5=, $pop61
	i64.store	8($7), $pop60
	block   	
	block   	
	block   	
	block   	
	i32.eqz 	$push86=, $0
	br_if   	0, $pop86       # 0: down to label4
# BB#1:                                 # %if.else
	i32.load	$push67=, 4($0)
	tee_local	$push66=, $6=, $pop67
	i32.const	$push5=, 8191
	i32.and 	$push65=, $pop66, $pop5
	tee_local	$push64=, $3=, $pop65
	i32.const	$push7=, 16
	i32.lt_u	$push8=, $pop64, $pop7
	br_if   	1, $pop8        # 1: down to label3
# BB#2:                                 # %if.else
	i32.const	$push6=, 8192
	i32.sub 	$push4=, $pop6, $3
	i32.const	$push9=, 31
	i32.le_u	$push10=, $pop4, $pop9
	br_if   	1, $pop10       # 1: down to label3
# BB#3:                                 # %if.end7
	i32.call	$push16=, baz@FUNCTION, $0
	br_if   	2, $pop16       # 2: down to label2
	br      	3               # 3: down to label1
.LBB3_4:
	end_block                       # label4:
	i32.const	$push58=, 8
	i32.add 	$push59=, $7, $pop58
	copy_local	$push69=, $pop59
	tee_local	$push68=, $0=, $pop69
	i32.call	$push14=, baz@FUNCTION, $pop68
	br_if   	1, $pop14       # 1: down to label2
	br      	2               # 2: down to label1
.LBB3_5:                                # %if.then5
	end_block                       # label3:
	i32.const	$push13=, 1
	i32.const	$push12=, 0
	i32.load	$push11=, 0($0)
	call    	foo@FUNCTION, $pop13, $pop12, $pop11, $6
	i32.call	$push15=, baz@FUNCTION, $0
	i32.eqz 	$push87=, $pop15
	br_if   	1, $pop87       # 1: down to label1
.LBB3_6:                                # %if.end9
	end_block                       # label2:
	i32.const	$push23=, 32
	i32.const	$push22=, 4
	i32.const	$push17=, 0
	i32.load	$push77=, b($pop17)
	tee_local	$push76=, $1=, $pop77
	i32.load16_u	$push75=, 2($pop76)
	tee_local	$push74=, $2=, $pop75
	i32.const	$push18=, 2
	i32.and 	$push19=, $pop74, $pop18
	i32.const	$push20=, 1
	i32.shr_u	$push21=, $pop19, $pop20
	i32.select	$3=, $pop23, $pop22, $pop21
	block   	
	block   	
	i32.load	$push73=, 4($0)
	tee_local	$push72=, $4=, $pop73
	i32.const	$push24=, 8191
	i32.and 	$push71=, $pop72, $pop24
	tee_local	$push70=, $6=, $pop71
	i32.eqz 	$push88=, $pop70
	br_if   	0, $pop88       # 0: down to label6
# BB#7:                                 # %if.else17
	i32.ge_u	$push25=, $6, $3
	br_if   	1, $pop25       # 1: down to label5
# BB#8:                                 # %if.then20
	i32.const	$push28=, 2
	i32.const	$push27=, 0
	i32.load	$push26=, 0($0)
	call    	foo@FUNCTION, $pop28, $pop27, $pop26, $4
	br      	2               # 2: down to label1
.LBB3_9:                                # %if.then15
	end_block                       # label6:
	i64.const	$push2=, 32
	i64.shr_u	$push3=, $5, $pop2
	i32.wrap/i64	$push0=, $pop3
	i32.add 	$push29=, $3, $pop0
	i32.store	12($7), $pop29
	copy_local	$6=, $3
.LBB3_10:                               # %if.end24
	end_block                       # label5:
	block   	
	i32.ne  	$push32=, $6, $3
	br_if   	0, $pop32       # 0: down to label7
# BB#11:                                # %if.end24
	i32.const	$push31=, 1
	i32.and 	$push30=, $2, $pop31
	i32.eqz 	$push89=, $pop30
	br_if   	0, $pop89       # 0: down to label7
# BB#12:                                # %if.then31
	i64.load	$push44=, 0($0):p2align=2
	i64.store	0($7):p2align=2, $pop44
	call    	bar@FUNCTION, $7
	i32.const	$push50=, 3
	i32.const	$push49=, 0
	i32.load	$push48=, 0($0)
	i32.const	$push45=, 4
	i32.add 	$push46=, $0, $pop45
	i32.load	$push47=, 0($pop46)
	call    	foo@FUNCTION, $pop50, $pop49, $pop48, $pop47
	br      	1               # 1: down to label1
.LBB3_13:                               # %if.end34
	end_block                       # label7:
	i32.const	$push33=, 4
	i32.add 	$push34=, $0, $pop33
	i32.load	$push85=, 0($pop34)
	tee_local	$push84=, $3=, $pop85
	i32.const	$push35=, 8191
	i32.and 	$push36=, $pop84, $pop35
	i32.add 	$push83=, $1, $pop36
	tee_local	$push82=, $6=, $pop83
	i32.load	$push81=, 4($pop82)
	tee_local	$push80=, $2=, $pop81
	i32.load	$push79=, 0($0)
	tee_local	$push78=, $0=, $pop79
	i32.lt_u	$push37=, $pop80, $pop78
	br_if   	0, $pop37       # 0: down to label1
# BB#14:                                # %land.lhs.true41
	block   	
	i32.ne  	$push38=, $2, $0
	br_if   	0, $pop38       # 0: down to label8
# BB#15:                                # %lor.lhs.false47
	i32.const	$push39=, 8
	i32.add 	$push40=, $6, $pop39
	i32.load	$push41=, 0($pop40)
	i32.lt_u	$push42=, $pop41, $3
	br_if   	1, $pop42       # 1: down to label1
.LBB3_16:                               # %if.then53
	end_block                       # label8:
	i32.const	$push43=, 4
	call    	foo@FUNCTION, $pop43, $6, $0, $3
.LBB3_17:                               # %cleanup
	end_block                       # label1:
	i32.const	$push57=, 0
	i32.const	$push55=, 16
	i32.add 	$push56=, $7, $pop55
	i32.store	__stack_pointer($pop57), $pop56
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
