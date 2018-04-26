	.text
	.file	"pr35472.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.store	p($pop0), $1
	i32.const	$push1=, -1
	i32.store	0($0), $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push29=, 0
	i32.load	$push28=, __stack_pointer($pop29)
	i32.const	$push30=, 128
	i32.sub 	$16=, $pop28, $pop30
	i32.const	$push31=, 0
	i32.store	__stack_pointer($pop31), $16
	i32.const	$push35=, 64
	i32.add 	$push36=, $16, $pop35
	i32.const	$push0=, 56
	i32.add 	$0=, $pop36, $pop0
	i64.const	$push1=, 0
	i64.store	0($0), $pop1
	i32.const	$push37=, 64
	i32.add 	$push38=, $16, $pop37
	i32.const	$push2=, 48
	i32.add 	$1=, $pop38, $pop2
	i64.const	$push79=, 0
	i64.store	0($1), $pop79
	i32.const	$push39=, 64
	i32.add 	$push40=, $16, $pop39
	i32.const	$push3=, 40
	i32.add 	$2=, $pop40, $pop3
	i64.const	$push78=, 0
	i64.store	0($2), $pop78
	i32.const	$push41=, 64
	i32.add 	$push42=, $16, $pop41
	i32.const	$push4=, 32
	i32.add 	$3=, $pop42, $pop4
	i64.const	$push77=, 0
	i64.store	0($3), $pop77
	i32.const	$push43=, 64
	i32.add 	$push44=, $16, $pop43
	i32.const	$push5=, 24
	i32.add 	$4=, $pop44, $pop5
	i64.const	$push76=, 0
	i64.store	0($4), $pop76
	i32.const	$push45=, 64
	i32.add 	$push46=, $16, $pop45
	i32.const	$push6=, 16
	i32.add 	$5=, $pop46, $pop6
	i64.const	$push75=, 0
	i64.store	0($5), $pop75
	i32.const	$push47=, 64
	i32.add 	$push48=, $16, $pop47
	i32.const	$push7=, 8
	i32.add 	$6=, $pop48, $pop7
	i64.const	$push74=, 0
	i64.store	0($6), $pop74
	i32.const	$push73=, 56
	i32.add 	$7=, $16, $pop73
	i64.const	$push72=, 0
	i64.store	0($7), $pop72
	i32.const	$push71=, 48
	i32.add 	$8=, $16, $pop71
	i64.const	$push70=, 0
	i64.store	0($8), $pop70
	i32.const	$push69=, 40
	i32.add 	$9=, $16, $pop69
	i64.const	$push68=, 0
	i64.store	0($9), $pop68
	i32.const	$push67=, 32
	i32.add 	$10=, $16, $pop67
	i64.const	$push66=, 0
	i64.store	0($10), $pop66
	i32.const	$push65=, 24
	i32.add 	$11=, $16, $pop65
	i64.const	$push64=, 0
	i64.store	0($11), $pop64
	i32.const	$push63=, 16
	i32.add 	$12=, $16, $pop63
	i64.const	$push62=, 0
	i64.store	0($12), $pop62
	i32.const	$push61=, 8
	i32.add 	$13=, $16, $pop61
	i64.const	$push60=, 0
	i64.store	0($13), $pop60
	i64.const	$push59=, 0
	i64.store	64($16), $pop59
	i64.const	$push58=, 0
	i64.store	0($16), $pop58
	i32.const	$push49=, 64
	i32.add 	$push50=, $16, $pop49
	call    	foo@FUNCTION, $pop50, $16
	i32.const	$push8=, 0
	i32.load	$14=, p($pop8)
	i64.load	$push9=, 64($16)
	i64.store	0($14):p2align=2, $pop9
	i32.const	$push57=, 56
	i32.add 	$15=, $14, $pop57
	i64.load	$push10=, 0($0)
	i64.store	0($15):p2align=2, $pop10
	i32.const	$push56=, 48
	i32.add 	$0=, $14, $pop56
	i64.load	$push11=, 0($1)
	i64.store	0($0):p2align=2, $pop11
	i32.const	$push55=, 40
	i32.add 	$1=, $14, $pop55
	i64.load	$push12=, 0($2)
	i64.store	0($1):p2align=2, $pop12
	i32.const	$push54=, 32
	i32.add 	$2=, $14, $pop54
	i64.load	$push13=, 0($3)
	i64.store	0($2):p2align=2, $pop13
	i32.const	$push53=, 24
	i32.add 	$3=, $14, $pop53
	i64.load	$push14=, 0($4)
	i64.store	0($3):p2align=2, $pop14
	i32.const	$push52=, 16
	i32.add 	$4=, $14, $pop52
	i64.load	$push15=, 0($5)
	i64.store	0($4):p2align=2, $pop15
	i32.const	$push51=, 8
	i32.add 	$5=, $14, $pop51
	i64.load	$push16=, 0($6)
	i64.store	0($5):p2align=2, $pop16
	i64.load	$push17=, 0($16)
	i64.store	0($14):p2align=2, $pop17
	i64.load	$push18=, 0($13)
	i64.store	0($5):p2align=2, $pop18
	i64.load	$push19=, 0($12)
	i64.store	0($4):p2align=2, $pop19
	i64.load	$push20=, 0($11)
	i64.store	0($3):p2align=2, $pop20
	i64.load	$push21=, 0($10)
	i64.store	0($2):p2align=2, $pop21
	i64.load	$push22=, 0($9)
	i64.store	0($1):p2align=2, $pop22
	i64.load	$push23=, 0($8)
	i64.store	0($0):p2align=2, $pop23
	i64.load	$push24=, 0($7)
	i64.store	0($15):p2align=2, $pop24
	block   	
	i32.load	$push26=, 0($16)
	i32.const	$push25=, -1
	i32.ne  	$push27=, $pop26, $pop25
	br_if   	0, $pop27       # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push34=, 0
	i32.const	$push32=, 128
	i32.add 	$push33=, $16, $pop32
	i32.store	__stack_pointer($pop34), $pop33
	return
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	test, .Lfunc_end1-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push28=, 0
	i32.load	$push27=, __stack_pointer($pop28)
	i32.const	$push29=, 128
	i32.sub 	$16=, $pop27, $pop29
	i32.const	$push30=, 0
	i32.store	__stack_pointer($pop30), $16
	i32.const	$push34=, 64
	i32.add 	$push35=, $16, $pop34
	i32.const	$push0=, 56
	i32.add 	$0=, $pop35, $pop0
	i64.const	$push1=, 0
	i64.store	0($0), $pop1
	i32.const	$push36=, 64
	i32.add 	$push37=, $16, $pop36
	i32.const	$push2=, 48
	i32.add 	$1=, $pop37, $pop2
	i64.const	$push79=, 0
	i64.store	0($1), $pop79
	i32.const	$push38=, 64
	i32.add 	$push39=, $16, $pop38
	i32.const	$push3=, 40
	i32.add 	$2=, $pop39, $pop3
	i64.const	$push78=, 0
	i64.store	0($2), $pop78
	i32.const	$push40=, 64
	i32.add 	$push41=, $16, $pop40
	i32.const	$push4=, 32
	i32.add 	$3=, $pop41, $pop4
	i64.const	$push77=, 0
	i64.store	0($3), $pop77
	i32.const	$push42=, 64
	i32.add 	$push43=, $16, $pop42
	i32.const	$push5=, 24
	i32.add 	$4=, $pop43, $pop5
	i64.const	$push76=, 0
	i64.store	0($4), $pop76
	i32.const	$push44=, 64
	i32.add 	$push45=, $16, $pop44
	i32.const	$push6=, 16
	i32.add 	$5=, $pop45, $pop6
	i64.const	$push75=, 0
	i64.store	0($5), $pop75
	i32.const	$push46=, 64
	i32.add 	$push47=, $16, $pop46
	i32.const	$push7=, 8
	i32.add 	$6=, $pop47, $pop7
	i64.const	$push74=, 0
	i64.store	0($6), $pop74
	i32.const	$push73=, 56
	i32.add 	$7=, $16, $pop73
	i64.const	$push72=, 0
	i64.store	0($7), $pop72
	i32.const	$push71=, 48
	i32.add 	$8=, $16, $pop71
	i64.const	$push70=, 0
	i64.store	0($8), $pop70
	i32.const	$push69=, 40
	i32.add 	$9=, $16, $pop69
	i64.const	$push68=, 0
	i64.store	0($9), $pop68
	i32.const	$push67=, 32
	i32.add 	$10=, $16, $pop67
	i64.const	$push66=, 0
	i64.store	0($10), $pop66
	i32.const	$push65=, 24
	i32.add 	$11=, $16, $pop65
	i64.const	$push64=, 0
	i64.store	0($11), $pop64
	i32.const	$push63=, 16
	i32.add 	$12=, $16, $pop63
	i64.const	$push62=, 0
	i64.store	0($12), $pop62
	i32.const	$push61=, 8
	i32.add 	$13=, $16, $pop61
	i64.const	$push60=, 0
	i64.store	0($13), $pop60
	i64.const	$push59=, 0
	i64.store	64($16), $pop59
	i64.const	$push58=, 0
	i64.store	0($16), $pop58
	i32.const	$push48=, 64
	i32.add 	$push49=, $16, $pop48
	call    	foo@FUNCTION, $pop49, $16
	i32.const	$push57=, 0
	i32.load	$14=, p($pop57)
	i64.load	$push8=, 64($16)
	i64.store	0($14):p2align=2, $pop8
	i32.const	$push56=, 56
	i32.add 	$15=, $14, $pop56
	i64.load	$push9=, 0($0)
	i64.store	0($15):p2align=2, $pop9
	i32.const	$push55=, 48
	i32.add 	$0=, $14, $pop55
	i64.load	$push10=, 0($1)
	i64.store	0($0):p2align=2, $pop10
	i32.const	$push54=, 40
	i32.add 	$1=, $14, $pop54
	i64.load	$push11=, 0($2)
	i64.store	0($1):p2align=2, $pop11
	i32.const	$push53=, 32
	i32.add 	$2=, $14, $pop53
	i64.load	$push12=, 0($3)
	i64.store	0($2):p2align=2, $pop12
	i32.const	$push52=, 24
	i32.add 	$3=, $14, $pop52
	i64.load	$push13=, 0($4)
	i64.store	0($3):p2align=2, $pop13
	i32.const	$push51=, 16
	i32.add 	$4=, $14, $pop51
	i64.load	$push14=, 0($5)
	i64.store	0($4):p2align=2, $pop14
	i32.const	$push50=, 8
	i32.add 	$5=, $14, $pop50
	i64.load	$push15=, 0($6)
	i64.store	0($5):p2align=2, $pop15
	i64.load	$push16=, 0($16)
	i64.store	0($14):p2align=2, $pop16
	i64.load	$push17=, 0($13)
	i64.store	0($5):p2align=2, $pop17
	i64.load	$push18=, 0($12)
	i64.store	0($4):p2align=2, $pop18
	i64.load	$push19=, 0($11)
	i64.store	0($3):p2align=2, $pop19
	i64.load	$push20=, 0($10)
	i64.store	0($2):p2align=2, $pop20
	i64.load	$push21=, 0($9)
	i64.store	0($1):p2align=2, $pop21
	i64.load	$push22=, 0($8)
	i64.store	0($0):p2align=2, $pop22
	i64.load	$push23=, 0($7)
	i64.store	0($15):p2align=2, $pop23
	block   	
	i32.load	$push25=, 0($16)
	i32.const	$push24=, -1
	i32.ne  	$push26=, $pop25, $pop24
	br_if   	0, $pop26       # 0: down to label1
# %bb.1:                                # %test.exit
	i32.const	$push33=, 0
	i32.const	$push31=, 128
	i32.add 	$push32=, $16, $pop31
	i32.store	__stack_pointer($pop33), $pop32
	i32.const	$push80=, 0
	return  	$pop80
.LBB2_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
