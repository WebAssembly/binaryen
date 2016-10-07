	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/stdarg-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 5
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %sw.bb
	i32.const	$push3=, 0
	i32.load	$push2=, 0($1)
	i32.store	foo_arg($pop3), $pop2
	return
.LBB0_2:                                # %sw.default
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
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 16392
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %entry
	i32.const	$push2=, 16390
	i32.ne  	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label2
# BB#2:                                 # %if.then
	i32.const	$push49=, 0
	i32.const	$push48=, 0
	i32.load	$push30=, gap($pop48)
	i32.const	$push31=, 7
	i32.add 	$push32=, $pop30, $pop31
	i32.const	$push33=, -8
	i32.and 	$push47=, $pop32, $pop33
	tee_local	$push46=, $1=, $pop47
	i32.const	$push34=, 8
	i32.add 	$push45=, $pop46, $pop34
	tee_local	$push44=, $2=, $pop45
	i32.store	gap($pop49), $pop44
	block   	
	f64.load	$push35=, 0($1)
	f64.const	$push36=, 0x1.1p4
	f64.ne  	$push37=, $pop35, $pop36
	br_if   	0, $pop37       # 0: down to label4
# BB#3:                                 # %lor.lhs.false
	i32.const	$push50=, 0
	i32.const	$push38=, 12
	i32.add 	$push39=, $1, $pop38
	i32.store	gap($pop50), $pop39
	i32.load	$push40=, 0($2)
	i32.const	$push41=, 129
	i32.eq  	$push42=, $pop40, $pop41
	br_if   	2, $pop42       # 2: down to label2
.LBB1_4:                                # %if.then5
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %if.then7
	end_block                       # label3:
	i32.const	$push55=, 0
	i32.load	$push54=, pap($pop55)
	tee_local	$push53=, $1=, $pop54
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 7
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, -8
	i32.and 	$push52=, $pop6, $pop7
	tee_local	$push51=, $1=, $pop52
	i32.const	$push8=, 8
	i32.add 	$push9=, $pop51, $pop8
	i32.store	0($pop53), $pop9
	i64.load	$push10=, 0($1)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label1
# BB#6:                                 # %lor.lhs.false11
	i32.const	$push60=, 0
	i32.load	$push59=, pap($pop60)
	tee_local	$push58=, $1=, $pop59
	i32.load	$push13=, 0($1)
	i32.const	$push14=, 15
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -16
	i32.and 	$push57=, $pop15, $pop16
	tee_local	$push56=, $1=, $pop57
	i32.const	$push17=, 16
	i32.add 	$push18=, $pop56, $pop17
	i32.store	0($pop58), $pop18
	i64.load	$push20=, 0($1)
	i64.load	$push19=, 8($1)
	i64.const	$push22=, 0
	i64.const	$push21=, 4613381465357418496
	i32.call	$push23=, __netf2@FUNCTION, $pop20, $pop19, $pop22, $pop21
	br_if   	1, $pop23       # 1: down to label1
# BB#7:                                 # %lor.lhs.false15
	i32.const	$push24=, 0
	i32.load	$push64=, pap($pop24)
	tee_local	$push63=, $1=, $pop64
	i32.load	$push62=, 0($1)
	tee_local	$push61=, $1=, $pop62
	i32.const	$push25=, 4
	i32.add 	$push26=, $pop61, $pop25
	i32.store	0($pop63), $pop26
	i32.load	$push27=, 0($1)
	i32.const	$push28=, 17
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	1, $pop29       # 1: down to label1
.LBB1_8:                                # %if.end22
	end_block                       # label2:
	i32.const	$push43=, 0
	i32.store	bar_arg($pop43), $0
	return
.LBB1_9:                                # %if.then19
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.f0,"ax",@progbits
	.hidden	f0
	.globl	f0
	.type	f0,@function
f0:                                     # @f0
	.param  	i32, i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	f0, .Lfunc_end2-f0

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	f1, .Lfunc_end3-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push18=, $pop6, $pop7
	tee_local	$push17=, $2=, $pop18
	i32.store	__stack_pointer($pop8), $pop17
	i32.store	12($2), $1
	i32.const	$push0=, 0
	f64.load	$push1=, d($pop0)
	i32.trunc_s/f64	$push2=, $pop1
	call    	bar@FUNCTION, $pop2
	i32.load	$push16=, 12($2)
	tee_local	$push15=, $1=, $pop16
	i32.const	$push3=, 4
	i32.add 	$push4=, $pop15, $pop3
	i32.store	12($2), $pop4
	i32.const	$push14=, 0
	i32.load	$push13=, 0($1)
	tee_local	$push12=, $1=, $pop13
	i32.store	x($pop14), $pop12
	call    	bar@FUNCTION, $1
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $2, $pop9
	i32.store	__stack_pointer($pop11), $pop10
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	f2, .Lfunc_end4-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push13=, $pop8, $pop9
	tee_local	$push12=, $2=, $pop13
	i32.store	12($pop12), $1
	i32.const	$push4=, 0
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$push11=, $pop1, $pop2
	tee_local	$push10=, $1=, $pop11
	i64.load	$push3=, 0($pop10)
	i64.store	d($pop4), $pop3
	i32.const	$push5=, 8
	i32.add 	$push6=, $1, $pop5
	i32.store	12($2), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	f3, .Lfunc_end5-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 16
	i32.sub 	$push22=, $pop10, $pop11
	tee_local	$push21=, $2=, $pop22
	i32.store	__stack_pointer($pop12), $pop21
	i32.store	12($2), $1
	i32.const	$push20=, 0
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$push19=, $pop1, $pop2
	tee_local	$push18=, $1=, $pop19
	f64.load	$push3=, 0($pop18)
	i32.trunc_s/f64	$push4=, $pop3
	i32.store	x($pop20), $pop4
	i32.const	$push5=, 8
	i32.add 	$push17=, $1, $pop5
	tee_local	$push16=, $1=, $pop17
	i32.store	12($2), $pop16
	block   	
	i32.const	$push6=, 5
	i32.ne  	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label5
# BB#1:                                 # %foo.exit
	i32.const	$push23=, 0
	i32.load	$push8=, 0($1)
	i32.store	foo_arg($pop23), $pop8
	i32.const	$push15=, 0
	i32.const	$push13=, 16
	i32.add 	$push14=, $2, $pop13
	i32.store	__stack_pointer($pop15), $pop14
	return
.LBB6_2:                                # %sw.default.i
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	f4, .Lfunc_end6-f4

	.section	.text.f5,"ax",@progbits
	.hidden	f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push1=, 0
	i32.load	$push2=, __stack_pointer($pop1)
	i32.const	$push3=, 16
	i32.sub 	$push9=, $pop2, $pop3
	tee_local	$push8=, $2=, $pop9
	i32.store	__stack_pointer($pop4), $pop8
	i32.const	$push0=, 0
	i32.store	gap($pop0), $1
	i32.store	12($2), $1
	call    	bar@FUNCTION, $0
	i32.const	$push7=, 0
	i32.const	$push5=, 16
	i32.add 	$push6=, $2, $pop5
	i32.store	__stack_pointer($pop7), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end7:
	.size	f5, .Lfunc_end7-f5

	.section	.text.f6,"ax",@progbits
	.hidden	f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push18=, $pop6, $pop7
	tee_local	$push17=, $3=, $pop18
	i32.store	__stack_pointer($pop8), $pop17
	i32.store	12($3), $1
	i32.const	$push0=, 0
	f64.load	$push1=, d($pop0)
	i32.trunc_s/f64	$push2=, $pop1
	call    	bar@FUNCTION, $pop2
	i32.const	$push16=, 0
	i32.load	$push15=, 12($3)
	tee_local	$push14=, $1=, $pop15
	i32.load	$push13=, 8($pop14)
	tee_local	$push12=, $2=, $pop13
	i32.store	x($pop16), $pop12
	i32.const	$push3=, 12
	i32.add 	$push4=, $1, $pop3
	i32.store	12($3), $pop4
	call    	bar@FUNCTION, $2
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $3, $pop9
	i32.store	__stack_pointer($pop11), $pop10
                                        # fallthrough-return
	.endfunc
.Lfunc_end8:
	.size	f6, .Lfunc_end8-f6

	.section	.text.f7,"ax",@progbits
	.hidden	f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push1=, 0
	i32.load	$push2=, __stack_pointer($pop1)
	i32.const	$push3=, 16
	i32.sub 	$push11=, $pop2, $pop3
	tee_local	$push10=, $2=, $pop11
	i32.store	__stack_pointer($pop4), $pop10
	i32.const	$push0=, 0
	i32.const	$push8=, 12
	i32.add 	$push9=, $2, $pop8
	i32.store	pap($pop0), $pop9
	i32.store	12($2), $1
	call    	bar@FUNCTION, $0
	i32.const	$push7=, 0
	i32.const	$push5=, 16
	i32.add 	$push6=, $2, $pop5
	i32.store	__stack_pointer($pop7), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end9:
	.size	f7, .Lfunc_end9-f7

	.section	.text.f8,"ax",@progbits
	.hidden	f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push21=, $pop9, $pop10
	tee_local	$push20=, $2=, $pop21
	i32.store	__stack_pointer($pop11), $pop20
	i32.const	$push0=, 0
	i32.const	$push15=, 12
	i32.add 	$push16=, $2, $pop15
	i32.store	pap($pop0), $pop16
	i32.store	12($2), $1
	call    	bar@FUNCTION, $0
	i32.const	$push19=, 0
	i32.load	$push2=, 12($2)
	i32.const	$push1=, 7
	i32.add 	$push3=, $pop2, $pop1
	i32.const	$push4=, -8
	i32.and 	$push18=, $pop3, $pop4
	tee_local	$push17=, $0=, $pop18
	i64.load	$push5=, 0($pop17)
	i64.store	d($pop19), $pop5
	i32.const	$push6=, 8
	i32.add 	$push7=, $0, $pop6
	i32.store	12($2), $pop7
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $2, $pop12
	i32.store	__stack_pointer($pop14), $pop13
                                        # fallthrough-return
	.endfunc
.Lfunc_end10:
	.size	f8, .Lfunc_end10-f8

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push44=, 0
	i32.const	$push41=, 0
	i32.load	$push42=, __stack_pointer($pop41)
	i32.const	$push43=, 176
	i32.sub 	$push71=, $pop42, $pop43
	tee_local	$push70=, $0=, $pop71
	i32.store	__stack_pointer($pop44), $pop70
	i32.const	$push69=, 0
	i64.const	$push1=, 4629418941960159232
	i64.store	d($pop69), $pop1
	i32.const	$push68=, 28
	i32.store	160($0), $pop68
	i32.const	$push48=, 160
	i32.add 	$push49=, $0, $pop48
	call    	f2@FUNCTION, $0, $pop49
	block   	
	i32.const	$push67=, 0
	i32.load	$push2=, bar_arg($pop67)
	i32.const	$push66=, 28
	i32.ne  	$push3=, $pop2, $pop66
	br_if   	0, $pop3        # 0: down to label6
# BB#1:                                 # %entry
	i32.const	$push73=, 0
	i32.load	$push0=, x($pop73)
	i32.const	$push72=, 28
	i32.ne  	$push4=, $pop0, $pop72
	br_if   	0, $pop4        # 0: down to label6
# BB#2:                                 # %if.end
	i64.const	$push5=, 4638813169307877376
	i64.store	144($0), $pop5
	i32.const	$push50=, 144
	i32.add 	$push51=, $0, $pop50
	call    	f3@FUNCTION, $0, $pop51
	i32.const	$push74=, 0
	f64.load	$push6=, d($pop74)
	f64.const	$push7=, 0x1.06p7
	f64.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label6
# BB#3:                                 # %if.end4
	i32.const	$push76=, 128
	i32.store	136($0), $pop76
	i64.const	$push10=, 4625196817309499392
	i64.store	128($0), $pop10
	i32.const	$push11=, 5
	i32.const	$push52=, 128
	i32.add 	$push53=, $0, $pop52
	call    	f4@FUNCTION, $pop11, $pop53
	i32.const	$push75=, 0
	i32.load	$push12=, x($pop75)
	i32.const	$push13=, 16
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label6
# BB#4:                                 # %if.end4
	i32.const	$push78=, 0
	i32.load	$push9=, foo_arg($pop78)
	i32.const	$push77=, 128
	i32.ne  	$push15=, $pop9, $pop77
	br_if   	0, $pop15       # 0: down to label6
# BB#5:                                 # %if.end9
	i32.const	$push16=, 129
	i32.store	120($0), $pop16
	i64.const	$push17=, 4625478292286210048
	i64.store	112($0), $pop17
	i32.const	$push18=, 16390
	i32.const	$push54=, 112
	i32.add 	$push55=, $0, $pop54
	call    	f5@FUNCTION, $pop18, $pop55
	i32.const	$push80=, 0
	i32.load	$push19=, bar_arg($pop80)
	i32.const	$push79=, 16390
	i32.ne  	$push20=, $pop19, $pop79
	br_if   	0, $pop20       # 0: down to label6
# BB#6:                                 # %if.end12
	i64.const	$push21=, 60129542156
	i64.store	96($0), $pop21
	i32.const	$push22=, -31
	i32.store	104($0), $pop22
	i32.const	$push56=, 96
	i32.add 	$push57=, $0, $pop56
	call    	f6@FUNCTION, $0, $pop57
	i32.const	$push82=, 0
	i32.load	$push23=, bar_arg($pop82)
	i32.const	$push81=, -31
	i32.ne  	$push24=, $pop23, $pop81
	br_if   	0, $pop24       # 0: down to label6
# BB#7:                                 # %if.end15
	i32.const	$push58=, 48
	i32.add 	$push59=, $0, $pop58
	i32.const	$push92=, 32
	i32.add 	$push25=, $pop59, $pop92
	i64.const	$push26=, 4628011567076605952
	i64.store	0($pop25), $pop26
	i32.const	$push60=, 48
	i32.add 	$push61=, $0, $pop60
	i32.const	$push91=, 24
	i32.add 	$push27=, $pop61, $pop91
	i32.const	$push90=, 17
	i32.store	0($pop27), $pop90
	i32.const	$push62=, 48
	i32.add 	$push63=, $0, $pop62
	i32.const	$push89=, 16
	i32.add 	$push28=, $pop63, $pop89
	i64.const	$push88=, 4613381465357418496
	i64.store	0($pop28), $pop88
	i64.const	$push87=, 0
	i64.store	56($0), $pop87
	i64.const	$push86=, 14
	i64.store	48($0), $pop86
	i32.const	$push85=, 16392
	i32.const	$push64=, 48
	i32.add 	$push65=, $0, $pop64
	call    	f7@FUNCTION, $pop85, $pop65
	i32.const	$push84=, 0
	i32.load	$push29=, bar_arg($pop84)
	i32.const	$push83=, 16392
	i32.ne  	$push30=, $pop29, $pop83
	br_if   	0, $pop30       # 0: down to label6
# BB#8:                                 # %if.end18
	i32.const	$push102=, 32
	i32.add 	$push32=, $0, $pop102
	i64.const	$push33=, 4628293042053316608
	i64.store	0($pop32), $pop33
	i32.const	$push101=, 24
	i32.add 	$push34=, $0, $pop101
	i32.const	$push100=, 17
	i32.store	0($pop34), $pop100
	i32.const	$push99=, 16
	i32.add 	$push35=, $0, $pop99
	i64.const	$push98=, 4613381465357418496
	i64.store	0($pop35), $pop98
	i64.const	$push97=, 0
	i64.store	8($0), $pop97
	i64.const	$push96=, 14
	i64.store	0($0), $pop96
	i32.const	$push95=, 16392
	call    	f8@FUNCTION, $pop95, $0
	i32.const	$push94=, 0
	i32.load	$push36=, bar_arg($pop94)
	i32.const	$push93=, 16392
	i32.ne  	$push37=, $pop36, $pop93
	br_if   	0, $pop37       # 0: down to label6
# BB#9:                                 # %if.end18
	i32.const	$push103=, 0
	f64.load	$push31=, d($pop103)
	f64.const	$push38=, 0x1.bp4
	f64.ne  	$push39=, $pop31, $pop38
	br_if   	0, $pop39       # 0: down to label6
# BB#10:                                # %if.end23
	i32.const	$push47=, 0
	i32.const	$push45=, 176
	i32.add 	$push46=, $0, $pop45
	i32.store	__stack_pointer($pop47), $pop46
	i32.const	$push40=, 0
	return  	$pop40
.LBB11_11:                              # %if.then22
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end11:
	.size	main, .Lfunc_end11-main

	.hidden	foo_arg                 # @foo_arg
	.type	foo_arg,@object
	.section	.bss.foo_arg,"aw",@nobits
	.globl	foo_arg
	.p2align	2
foo_arg:
	.int32	0                       # 0x0
	.size	foo_arg, 4

	.hidden	gap                     # @gap
	.type	gap,@object
	.section	.bss.gap,"aw",@nobits
	.globl	gap
	.p2align	2
gap:
	.int32	0
	.size	gap, 4

	.hidden	pap                     # @pap
	.type	pap,@object
	.section	.bss.pap,"aw",@nobits
	.globl	pap
	.p2align	2
pap:
	.int32	0
	.size	pap, 4

	.hidden	bar_arg                 # @bar_arg
	.type	bar_arg,@object
	.section	.bss.bar_arg,"aw",@nobits
	.globl	bar_arg
	.p2align	2
bar_arg:
	.int32	0                       # 0x0
	.size	bar_arg, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	3
d:
	.int64	0                       # double 0
	.size	d, 8

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.int32	0                       # 0x0
	.size	x, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
