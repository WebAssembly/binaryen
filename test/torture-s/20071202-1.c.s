	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071202-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($0)
	i32.load	$push0=, 4($0)
	i32.store	$discard=, 0($0), $pop0
	i32.store	$discard=, 4($0), $1
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.const	$push3=, 24
	i32.add 	$push4=, $0, $pop3
	i64.const	$push1=, 0
	i64.store	$push2=, 8($0):p2align=2, $pop1
	i64.store	$push5=, 0($pop4):p2align=2, $pop2
	i64.store	$discard=, 0($pop7):p2align=2, $pop5
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push68=, __stack_pointer
	i32.load	$push69=, 0($pop68)
	i32.const	$push70=, 80
	i32.sub 	$0=, $pop69, $pop70
	i32.const	$push71=, __stack_pointer
	i32.store	$discard=, 0($pop71), $0
	i32.const	$push75=, 8
	i32.add 	$push76=, $0, $pop75
	i32.const	$push0=, .Lmain.s
	i32.const	$push1=, 68
	i32.call	$discard=, memcpy@FUNCTION, $pop76, $pop0, $pop1
	i32.const	$push77=, 8
	i32.add 	$push78=, $0, $pop77
	call    	foo@FUNCTION, $pop78
	block
	i32.load	$push2=, 8($0)
	i32.const	$push3=, 12
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push5=, 12($0)
	i32.const	$push6=, 6
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %lor.lhs.false2
	i32.load	$push8=, 16($0)
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %lor.lhs.false3
	i32.const	$push79=, 8
	i32.add 	$push80=, $0, $pop79
	i32.const	$push9=, 12
	i32.add 	$push10=, $pop80, $pop9
	i32.load	$push11=, 0($pop10)
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %lor.lhs.false7
	i32.const	$push81=, 8
	i32.add 	$push82=, $0, $pop81
	i32.const	$push12=, 16
	i32.add 	$push13=, $pop82, $pop12
	i32.load	$push14=, 0($pop13)
	br_if   	0, $pop14       # 0: down to label0
# BB#5:                                 # %lor.lhs.false11
	i32.const	$push83=, 8
	i32.add 	$push84=, $0, $pop83
	i32.const	$push15=, 20
	i32.add 	$push16=, $pop84, $pop15
	i32.load	$push17=, 0($pop16)
	br_if   	0, $pop17       # 0: down to label0
# BB#6:                                 # %lor.lhs.false15
	i32.const	$push85=, 8
	i32.add 	$push86=, $0, $pop85
	i32.const	$push18=, 24
	i32.add 	$push19=, $pop86, $pop18
	i32.load	$push20=, 0($pop19)
	br_if   	0, $pop20       # 0: down to label0
# BB#7:                                 # %lor.lhs.false19
	i32.const	$push87=, 8
	i32.add 	$push88=, $0, $pop87
	i32.const	$push21=, 28
	i32.add 	$push22=, $pop88, $pop21
	i32.load	$push23=, 0($pop22)
	br_if   	0, $pop23       # 0: down to label0
# BB#8:                                 # %if.end
	i32.load	$push24=, 40($0)
	i32.const	$push25=, 7
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label0
# BB#9:                                 # %lor.lhs.false24
	i32.const	$push89=, 8
	i32.add 	$push90=, $0, $pop89
	i32.const	$push27=, 36
	i32.add 	$push28=, $pop90, $pop27
	i32.load	$push29=, 0($pop28)
	i32.const	$push30=, 8
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#10:                                # %lor.lhs.false28
	i32.const	$push91=, 8
	i32.add 	$push92=, $0, $pop91
	i32.const	$push32=, 40
	i32.add 	$push33=, $pop92, $pop32
	i32.load	$push34=, 0($pop33)
	i32.const	$push35=, 9
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label0
# BB#11:                                # %lor.lhs.false33
	i32.const	$push93=, 8
	i32.add 	$push94=, $0, $pop93
	i32.const	$push37=, 44
	i32.add 	$push38=, $pop94, $pop37
	i32.load	$push39=, 0($pop38)
	i32.const	$push40=, 10
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label0
# BB#12:                                # %lor.lhs.false38
	i32.const	$push95=, 8
	i32.add 	$push96=, $0, $pop95
	i32.const	$push42=, 48
	i32.add 	$push43=, $pop96, $pop42
	i32.load	$push44=, 0($pop43)
	i32.const	$push45=, 11
	i32.ne  	$push46=, $pop44, $pop45
	br_if   	0, $pop46       # 0: down to label0
# BB#13:                                # %lor.lhs.false43
	i32.const	$push97=, 8
	i32.add 	$push98=, $0, $pop97
	i32.const	$push47=, 52
	i32.add 	$push48=, $pop98, $pop47
	i32.load	$push49=, 0($pop48)
	i32.const	$push50=, 12
	i32.ne  	$push51=, $pop49, $pop50
	br_if   	0, $pop51       # 0: down to label0
# BB#14:                                # %lor.lhs.false48
	i32.const	$push99=, 8
	i32.add 	$push100=, $0, $pop99
	i32.const	$push52=, 56
	i32.add 	$push53=, $pop100, $pop52
	i32.load	$push54=, 0($pop53)
	i32.const	$push55=, 13
	i32.ne  	$push56=, $pop54, $pop55
	br_if   	0, $pop56       # 0: down to label0
# BB#15:                                # %lor.lhs.false53
	i32.const	$push101=, 8
	i32.add 	$push102=, $0, $pop101
	i32.const	$push57=, 60
	i32.add 	$push58=, $pop102, $pop57
	i32.load	$push59=, 0($pop58)
	i32.const	$push60=, 14
	i32.ne  	$push61=, $pop59, $pop60
	br_if   	0, $pop61       # 0: down to label0
# BB#16:                                # %lor.lhs.false58
	i32.const	$push103=, 8
	i32.add 	$push104=, $0, $pop103
	i32.const	$push62=, 64
	i32.add 	$push63=, $pop104, $pop62
	i32.load	$push64=, 0($pop63)
	i32.const	$push65=, 15
	i32.ne  	$push66=, $pop64, $pop65
	br_if   	0, $pop66       # 0: down to label0
# BB#17:                                # %if.end64
	i32.const	$push67=, 0
	i32.const	$push74=, __stack_pointer
	i32.const	$push72=, 80
	i32.add 	$push73=, $0, $pop72
	i32.store	$discard=, 0($pop74), $pop73
	return  	$pop67
.LBB1_18:                               # %if.then63
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.s,@object        # @main.s
	.section	.rodata..Lmain.s,"a",@progbits
	.p2align	2
.Lmain.s:
	.int32	6                       # 0x6
	.int32	12                      # 0xc
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.int32	5                       # 0x5
	.int32	6                       # 0x6
	.int32	7                       # 0x7
	.int32	8                       # 0x8
	.int32	9                       # 0x9
	.int32	10                      # 0xa
	.int32	11                      # 0xb
	.int32	12                      # 0xc
	.int32	13                      # 0xd
	.int32	14                      # 0xe
	.int32	15                      # 0xf
	.size	.Lmain.s, 68


	.ident	"clang version 3.9.0 "
