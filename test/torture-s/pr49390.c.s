	.text
	.file	"pr49390.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
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
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
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
                                        # -- End function
	.section	.text.baz,"ax",@progbits
	.hidden	baz                     # -- Begin function baz
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
                                        # -- End function
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.local  	i32, i32, i32, i32, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push51=, 0
	i32.const	$push49=, 0
	i32.load	$push48=, __stack_pointer($pop49)
	i32.const	$push50=, 16
	i32.sub 	$push60=, $pop48, $pop50
	tee_local	$push59=, $7=, $pop60
	i32.store	__stack_pointer($pop51), $pop59
	i32.const	$push1=, 0
	i64.load	$push58=, a($pop1)
	tee_local	$push57=, $5=, $pop58
	i64.store	8($7), $pop57
	block   	
	block   	
	block   	
	i32.eqz 	$push83=, $0
	br_if   	0, $pop83       # 0: down to label3
# BB#1:                                 # %if.else
	block   	
	block   	
	i32.load	$push64=, 4($0)
	tee_local	$push63=, $6=, $pop64
	i32.const	$push5=, 8191
	i32.and 	$push62=, $pop63, $pop5
	tee_local	$push61=, $3=, $pop62
	i32.const	$push7=, 16
	i32.lt_u	$push8=, $pop61, $pop7
	br_if   	0, $pop8        # 0: down to label5
# BB#2:                                 # %if.else
	i32.const	$push6=, 8192
	i32.sub 	$push4=, $pop6, $3
	i32.const	$push9=, 31
	i32.gt_u	$push10=, $pop4, $pop9
	br_if   	1, $pop10       # 1: down to label4
.LBB3_3:                                # %if.then5
	end_block                       # label5:
	i32.const	$push13=, 1
	i32.const	$push12=, 0
	i32.load	$push11=, 0($0)
	call    	foo@FUNCTION, $pop13, $pop12, $pop11, $6
.LBB3_4:                                # %if.end7
	end_block                       # label4:
	i32.call	$push15=, baz@FUNCTION, $0
	br_if   	1, $pop15       # 1: down to label2
	br      	2               # 2: down to label1
.LBB3_5:
	end_block                       # label3:
	i32.const	$push55=, 8
	i32.add 	$push56=, $7, $pop55
	copy_local	$push66=, $pop56
	tee_local	$push65=, $0=, $pop66
	i32.call	$push14=, baz@FUNCTION, $pop65
	i32.eqz 	$push84=, $pop14
	br_if   	1, $pop84       # 1: down to label1
.LBB3_6:                                # %if.end9
	end_block                       # label2:
	i32.const	$push20=, 32
	i32.const	$push19=, 4
	i32.const	$push16=, 0
	i32.load	$push74=, b($pop16)
	tee_local	$push73=, $1=, $pop74
	i32.load16_u	$push72=, 2($pop73)
	tee_local	$push71=, $2=, $pop72
	i32.const	$push17=, 2
	i32.and 	$push18=, $pop71, $pop17
	i32.select	$3=, $pop20, $pop19, $pop18
	block   	
	block   	
	i32.load	$push70=, 4($0)
	tee_local	$push69=, $4=, $pop70
	i32.const	$push21=, 8191
	i32.and 	$push68=, $pop69, $pop21
	tee_local	$push67=, $6=, $pop68
	i32.eqz 	$push85=, $pop67
	br_if   	0, $pop85       # 0: down to label7
# BB#7:                                 # %if.else17
	i32.ge_u	$push22=, $6, $3
	br_if   	1, $pop22       # 1: down to label6
# BB#8:                                 # %if.then20
	i32.const	$push25=, 2
	i32.const	$push24=, 0
	i32.load	$push23=, 0($0)
	call    	foo@FUNCTION, $pop25, $pop24, $pop23, $4
	br      	2               # 2: down to label1
.LBB3_9:                                # %if.then15
	end_block                       # label7:
	i64.const	$push2=, 32
	i64.shr_u	$push3=, $5, $pop2
	i32.wrap/i64	$push0=, $pop3
	i32.add 	$push26=, $3, $pop0
	i32.store	12($7), $pop26
	copy_local	$6=, $3
.LBB3_10:                               # %if.end24
	end_block                       # label6:
	block   	
	i32.const	$push27=, 1
	i32.and 	$push28=, $2, $pop27
	i32.eqz 	$push86=, $pop28
	br_if   	0, $pop86       # 0: down to label8
# BB#11:                                # %if.end24
	i32.ne  	$push29=, $6, $3
	br_if   	0, $pop29       # 0: down to label8
# BB#12:                                # %if.then31
	i64.load	$push41=, 0($0):p2align=2
	i64.store	0($7), $pop41
	call    	bar@FUNCTION, $7
	i32.const	$push47=, 3
	i32.const	$push46=, 0
	i32.load	$push45=, 0($0)
	i32.const	$push42=, 4
	i32.add 	$push43=, $0, $pop42
	i32.load	$push44=, 0($pop43)
	call    	foo@FUNCTION, $pop47, $pop46, $pop45, $pop44
	br      	1               # 1: down to label1
.LBB3_13:                               # %if.end34
	end_block                       # label8:
	i32.const	$push30=, 4
	i32.add 	$push31=, $0, $pop30
	i32.load	$push82=, 0($pop31)
	tee_local	$push81=, $3=, $pop82
	i32.const	$push32=, 8191
	i32.and 	$push33=, $pop81, $pop32
	i32.add 	$push80=, $1, $pop33
	tee_local	$push79=, $6=, $pop80
	i32.load	$push78=, 4($pop79)
	tee_local	$push77=, $2=, $pop78
	i32.load	$push76=, 0($0)
	tee_local	$push75=, $0=, $pop76
	i32.lt_u	$push34=, $pop77, $pop75
	br_if   	0, $pop34       # 0: down to label1
# BB#14:                                # %land.lhs.true41
	block   	
	i32.ne  	$push35=, $2, $0
	br_if   	0, $pop35       # 0: down to label9
# BB#15:                                # %lor.lhs.false47
	i32.const	$push36=, 8
	i32.add 	$push37=, $6, $pop36
	i32.load	$push38=, 0($pop37)
	i32.lt_u	$push39=, $pop38, $3
	br_if   	1, $pop39       # 1: down to label1
.LBB3_16:                               # %if.then53
	end_block                       # label9:
	i32.const	$push40=, 4
	call    	foo@FUNCTION, $pop40, $6, $0, $3
.LBB3_17:                               # %cleanup
	end_block                       # label1:
	i32.const	$push54=, 0
	i32.const	$push52=, 16
	i32.add 	$push53=, $7, $pop52
	i32.store	__stack_pointer($pop54), $pop53
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	test, .Lfunc_end3-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
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
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
