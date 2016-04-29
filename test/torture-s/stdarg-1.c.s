	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/stdarg-1.c"
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
	i32.store	$discard=, foo_arg($pop3), $pop2
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
	.local  	i32, f64, i32
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
	i32.const	$push47=, 0
	i32.load	$push30=, gap($pop47)
	i32.const	$push31=, 7
	i32.add 	$push32=, $pop30, $pop31
	i32.const	$push33=, -8
	i32.and 	$push46=, $pop32, $pop33
	tee_local	$push45=, $1=, $pop46
	f64.load	$2=, 0($pop45)
	i32.const	$push44=, 0
	i32.const	$push34=, 8
	i32.add 	$push35=, $1, $pop34
	i32.store	$3=, gap($pop44), $pop35
	block
	f64.const	$push36=, 0x1.1p4
	f64.ne  	$push37=, $2, $pop36
	br_if   	0, $pop37       # 0: down to label4
# BB#3:                                 # %lor.lhs.false
	i32.const	$push48=, 0
	i32.const	$push38=, 12
	i32.add 	$push39=, $1, $pop38
	i32.store	$discard=, gap($pop48), $pop39
	i32.load	$push40=, 0($3)
	i32.const	$push41=, 129
	i32.eq  	$push42=, $pop40, $pop41
	br_if   	2, $pop42       # 2: down to label2
.LBB1_4:                                # %if.then5
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %if.then7
	end_block                       # label3:
	i32.const	$push51=, 0
	i32.load	$1=, pap($pop51)
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 7
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, -8
	i32.and 	$push50=, $pop6, $pop7
	tee_local	$push49=, $3=, $pop50
	i32.const	$push8=, 8
	i32.add 	$push9=, $pop49, $pop8
	i32.store	$discard=, 0($1), $pop9
	i64.load	$push10=, 0($3)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label1
# BB#6:                                 # %lor.lhs.false11
	i32.const	$push54=, 0
	i32.load	$1=, pap($pop54)
	i32.load	$push13=, 0($1)
	i32.const	$push14=, 15
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -16
	i32.and 	$push53=, $pop15, $pop16
	tee_local	$push52=, $3=, $pop53
	i32.const	$push17=, 16
	i32.add 	$push18=, $pop52, $pop17
	i32.store	$discard=, 0($1), $pop18
	i64.load	$push20=, 0($3)
	i64.load	$push19=, 8($3)
	i64.const	$push22=, 0
	i64.const	$push21=, 4613381465357418496
	i32.call	$push23=, __netf2@FUNCTION, $pop20, $pop19, $pop22, $pop21
	br_if   	1, $pop23       # 1: down to label1
# BB#7:                                 # %lor.lhs.false15
	i32.const	$push24=, 0
	i32.load	$1=, pap($pop24)
	i32.load	$push56=, 0($1)
	tee_local	$push55=, $3=, $pop56
	i32.const	$push25=, 4
	i32.add 	$push26=, $pop55, $pop25
	i32.store	$discard=, 0($1), $pop26
	i32.load	$push27=, 0($3)
	i32.const	$push28=, 17
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	1, $pop29       # 1: down to label1
.LBB1_8:                                # %if.end22
	end_block                       # label2:
	i32.const	$push43=, 0
	i32.store	$discard=, bar_arg($pop43), $0
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
	return
	.endfunc
.Lfunc_end2:
	.size	f0, .Lfunc_end2-f0

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, __stack_pointer
	i32.load	$push1=, 0($pop0)
	i32.const	$push2=, 16
	i32.sub 	$2=, $pop1, $pop2
	i32.store	$discard=, 12($2), $1
	return
	.endfunc
.Lfunc_end3:
	.size	f1, .Lfunc_end3-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.local  	f64, i32
# BB#0:                                 # %entry
	i32.const	$push9=, __stack_pointer
	i32.load	$push10=, 0($pop9)
	i32.const	$push11=, 16
	i32.sub 	$3=, $pop10, $pop11
	i32.const	$push12=, __stack_pointer
	i32.store	$discard=, 0($pop12), $3
	i32.const	$push0=, 0
	f64.load	$2=, d($pop0)
	i32.store	$discard=, 12($3), $1
	i32.trunc_s/f64	$push1=, $2
	call    	bar@FUNCTION, $pop1
	i32.load	$push8=, 12($3)
	tee_local	$push7=, $1=, $pop8
	i32.const	$push2=, 4
	i32.add 	$push3=, $pop7, $pop2
	i32.store	$discard=, 12($3), $pop3
	i32.const	$push6=, 0
	i32.load	$push4=, 0($1)
	i32.store	$push5=, x($pop6), $pop4
	call    	bar@FUNCTION, $pop5
	i32.const	$push15=, __stack_pointer
	i32.const	$push13=, 16
	i32.add 	$push14=, $3, $pop13
	i32.store	$discard=, 0($pop15), $pop14
	return
	.endfunc
.Lfunc_end4:
	.size	f2, .Lfunc_end4-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push9=, __stack_pointer
	i32.load	$push10=, 0($pop9)
	i32.const	$push11=, 16
	i32.sub 	$3=, $pop10, $pop11
	i32.store	$push0=, 12($3), $1
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push8=, $pop2, $pop3
	tee_local	$push7=, $1=, $pop8
	i64.load	$2=, 0($pop7)
	i32.const	$push4=, 8
	i32.add 	$push5=, $1, $pop4
	i32.store	$discard=, 12($3), $pop5
	i32.const	$push6=, 0
	i64.store	$discard=, d($pop6), $2
	return
	.endfunc
.Lfunc_end5:
	.size	f3, .Lfunc_end5-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	f64, i32
# BB#0:                                 # %entry
	i32.const	$push14=, __stack_pointer
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, 16
	i32.sub 	$3=, $pop15, $pop16
	i32.const	$push17=, __stack_pointer
	i32.store	$discard=, 0($pop17), $3
	i32.store	$push1=, 12($3), $1
	i32.const	$push2=, 7
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -8
	i32.and 	$push12=, $pop3, $pop4
	tee_local	$push11=, $1=, $pop12
	f64.load	$2=, 0($pop11)
	i32.const	$push5=, 8
	i32.add 	$push0=, $1, $pop5
	i32.store	$1=, 12($3), $pop0
	i32.const	$push10=, 0
	i32.trunc_s/f64	$push6=, $2
	i32.store	$discard=, x($pop10), $pop6
	block
	i32.const	$push7=, 5
	i32.ne  	$push8=, $0, $pop7
	br_if   	0, $pop8        # 0: down to label5
# BB#1:                                 # %foo.exit
	i32.const	$push13=, 0
	i32.load	$push9=, 0($1)
	i32.store	$discard=, foo_arg($pop13), $pop9
	i32.const	$push20=, __stack_pointer
	i32.const	$push18=, 16
	i32.add 	$push19=, $3, $pop18
	i32.store	$discard=, 0($pop20), $pop19
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
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$2=, $pop3, $pop4
	i32.const	$push5=, __stack_pointer
	i32.store	$discard=, 0($pop5), $2
	i32.const	$push1=, 0
	i32.store	$push0=, 12($2), $1
	i32.store	$discard=, gap($pop1), $pop0
	call    	bar@FUNCTION, $0
	i32.const	$push8=, __stack_pointer
	i32.const	$push6=, 16
	i32.add 	$push7=, $2, $pop6
	i32.store	$discard=, 0($pop8), $pop7
	return
	.endfunc
.Lfunc_end7:
	.size	f5, .Lfunc_end7-f5

	.section	.text.f6,"ax",@progbits
	.hidden	f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32, i32
	.local  	f64, i32
# BB#0:                                 # %entry
	i32.const	$push9=, __stack_pointer
	i32.load	$push10=, 0($pop9)
	i32.const	$push11=, 16
	i32.sub 	$3=, $pop10, $pop11
	i32.const	$push12=, __stack_pointer
	i32.store	$discard=, 0($pop12), $3
	i32.const	$push0=, 0
	f64.load	$2=, d($pop0)
	i32.store	$discard=, 12($3), $1
	i32.trunc_s/f64	$push1=, $2
	call    	bar@FUNCTION, $pop1
	i32.load	$push8=, 12($3)
	tee_local	$push7=, $1=, $pop8
	i32.const	$push2=, 12
	i32.add 	$push3=, $pop7, $pop2
	i32.store	$discard=, 12($3), $pop3
	i32.const	$push6=, 0
	i32.load	$push4=, 8($1)
	i32.store	$push5=, x($pop6), $pop4
	call    	bar@FUNCTION, $pop5
	i32.const	$push15=, __stack_pointer
	i32.const	$push13=, 16
	i32.add 	$push14=, $3, $pop13
	i32.store	$discard=, 0($pop15), $pop14
	return
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
	i32.const	$push1=, __stack_pointer
	i32.load	$push2=, 0($pop1)
	i32.const	$push3=, 16
	i32.sub 	$2=, $pop2, $pop3
	i32.const	$push4=, __stack_pointer
	i32.store	$discard=, 0($pop4), $2
	i32.store	$discard=, 12($2), $1
	i32.const	$push0=, 0
	i32.const	$push8=, 12
	i32.add 	$push9=, $2, $pop8
	i32.store	$discard=, pap($pop0), $pop9
	call    	bar@FUNCTION, $0
	i32.const	$push7=, __stack_pointer
	i32.const	$push5=, 16
	i32.add 	$push6=, $2, $pop5
	i32.store	$discard=, 0($pop7), $pop6
	return
	.endfunc
.Lfunc_end9:
	.size	f7, .Lfunc_end9-f7

	.section	.text.f8,"ax",@progbits
	.hidden	f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32, i32
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push10=, __stack_pointer
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 16
	i32.sub 	$3=, $pop11, $pop12
	i32.const	$push13=, __stack_pointer
	i32.store	$discard=, 0($pop13), $3
	i32.store	$discard=, 12($3), $1
	i32.const	$push0=, 0
	i32.const	$push17=, 12
	i32.add 	$push18=, $3, $pop17
	i32.store	$discard=, pap($pop0), $pop18
	call    	bar@FUNCTION, $0
	i32.load	$push1=, 12($3)
	i32.const	$push2=, 7
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -8
	i32.and 	$push9=, $pop3, $pop4
	tee_local	$push8=, $1=, $pop9
	i64.load	$2=, 0($pop8)
	i32.const	$push5=, 8
	i32.add 	$push6=, $1, $pop5
	i32.store	$discard=, 12($3), $pop6
	i32.const	$push7=, 0
	i64.store	$discard=, d($pop7), $2
	i32.const	$push16=, __stack_pointer
	i32.const	$push14=, 16
	i32.add 	$push15=, $3, $pop14
	i32.store	$discard=, 0($pop16), $pop15
	return
	.endfunc
.Lfunc_end10:
	.size	f8, .Lfunc_end10-f8

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push70=, __stack_pointer
	i32.load	$push71=, 0($pop70)
	i32.const	$push72=, 176
	i32.sub 	$4=, $pop71, $pop72
	i32.const	$push73=, __stack_pointer
	i32.store	$discard=, 0($pop73), $4
	i32.const	$push49=, 0
	call    	f1@FUNCTION, $0, $pop49
	i32.const	$push48=, 0
	i64.const	$push1=, 4629418941960159232
	i64.store	$discard=, d($pop48), $pop1
	i32.const	$push2=, 28
	i32.store	$0=, 160($4), $pop2
	i32.const	$push77=, 160
	i32.add 	$push78=, $4, $pop77
	call    	f2@FUNCTION, $0, $pop78
	block
	i32.const	$push47=, 0
	i32.load	$push3=, bar_arg($pop47)
	i32.ne  	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label6
# BB#1:                                 # %entry
	i32.const	$push50=, 0
	i32.load	$push0=, x($pop50)
	i32.ne  	$push5=, $pop0, $0
	br_if   	0, $pop5        # 0: down to label6
# BB#2:                                 # %if.end
	i64.const	$push6=, 4638813169307877376
	i64.store	$discard=, 144($4), $pop6
	i32.const	$push79=, 144
	i32.add 	$push80=, $4, $pop79
	call    	f3@FUNCTION, $0, $pop80
	i32.const	$push51=, 0
	f64.load	$push7=, d($pop51)
	f64.const	$push8=, 0x1.06p7
	f64.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label6
# BB#3:                                 # %if.end4
	i32.const	$push11=, 128
	i32.store	$0=, 136($4), $pop11
	i64.const	$push12=, 4625196817309499392
	i64.store	$discard=, 128($4), $pop12
	i32.const	$push13=, 5
	i32.const	$push81=, 128
	i32.add 	$push82=, $4, $pop81
	call    	f4@FUNCTION, $pop13, $pop82
	i32.const	$push52=, 0
	i32.load	$push14=, x($pop52)
	i32.const	$push15=, 16
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label6
# BB#4:                                 # %if.end4
	i32.const	$push53=, 0
	i32.load	$push10=, foo_arg($pop53)
	i32.ne  	$push17=, $pop10, $0
	br_if   	0, $pop17       # 0: down to label6
# BB#5:                                 # %if.end9
	i32.const	$push18=, 129
	i32.store	$discard=, 120($4), $pop18
	i64.const	$push19=, 4625478292286210048
	i64.store	$discard=, 112($4), $pop19
	i32.const	$push20=, 16390
	i32.const	$push83=, 112
	i32.add 	$push84=, $4, $pop83
	call    	f5@FUNCTION, $pop20, $pop84
	i32.const	$push55=, 0
	i32.load	$push21=, bar_arg($pop55)
	i32.const	$push54=, 16390
	i32.ne  	$push22=, $pop21, $pop54
	br_if   	0, $pop22       # 0: down to label6
# BB#6:                                 # %if.end12
	i32.const	$push23=, -31
	i32.store	$0=, 104($4), $pop23
	i64.const	$push24=, 60129542156
	i64.store	$discard=, 96($4), $pop24
	i32.const	$push85=, 96
	i32.add 	$push86=, $4, $pop85
	call    	f6@FUNCTION, $0, $pop86
	i32.const	$push56=, 0
	i32.load	$push25=, bar_arg($pop56)
	i32.ne  	$push26=, $0, $pop25
	br_if   	0, $pop26       # 0: down to label6
# BB#7:                                 # %if.end15
	i32.const	$push87=, 48
	i32.add 	$push88=, $4, $pop87
	i32.const	$push62=, 32
	i32.add 	$push27=, $pop88, $pop62
	i64.const	$push28=, 4628011567076605952
	i64.store	$discard=, 0($pop27), $pop28
	i32.const	$push89=, 48
	i32.add 	$push90=, $4, $pop89
	i32.const	$push61=, 24
	i32.add 	$push29=, $pop90, $pop61
	i32.const	$push30=, 17
	i32.store	$0=, 0($pop29), $pop30
	i32.const	$push91=, 48
	i32.add 	$push92=, $4, $pop91
	i32.const	$push60=, 16
	i32.add 	$push31=, $pop92, $pop60
	i64.const	$push32=, 4613381465357418496
	i64.store	$1=, 0($pop31), $pop32
	i64.const	$push33=, 0
	i64.store	$2=, 56($4), $pop33
	i64.const	$push34=, 14
	i64.store	$3=, 48($4), $pop34
	i32.const	$push59=, 16392
	i32.const	$push93=, 48
	i32.add 	$push94=, $4, $pop93
	call    	f7@FUNCTION, $pop59, $pop94
	i32.const	$push58=, 0
	i32.load	$push35=, bar_arg($pop58)
	i32.const	$push57=, 16392
	i32.ne  	$push36=, $pop35, $pop57
	br_if   	0, $pop36       # 0: down to label6
# BB#8:                                 # %if.end18
	i32.const	$push68=, 32
	i32.add 	$push38=, $4, $pop68
	i64.const	$push39=, 4628293042053316608
	i64.store	$discard=, 0($pop38), $pop39
	i32.const	$push67=, 24
	i32.add 	$push40=, $4, $pop67
	i32.store	$discard=, 0($pop40), $0
	i32.const	$push66=, 16
	i32.add 	$push41=, $4, $pop66
	i64.store	$discard=, 0($pop41), $1
	i64.store	$discard=, 8($4), $2
	i64.store	$discard=, 0($4), $3
	i32.const	$push65=, 16392
	call    	f8@FUNCTION, $pop65, $4
	i32.const	$push64=, 0
	i32.load	$push42=, bar_arg($pop64)
	i32.const	$push63=, 16392
	i32.ne  	$push43=, $pop42, $pop63
	br_if   	0, $pop43       # 0: down to label6
# BB#9:                                 # %if.end18
	i32.const	$push69=, 0
	f64.load	$push37=, d($pop69)
	f64.const	$push44=, 0x1.bp4
	f64.ne  	$push45=, $pop37, $pop44
	br_if   	0, $pop45       # 0: down to label6
# BB#10:                                # %if.end23
	i32.const	$push46=, 0
	i32.const	$push76=, __stack_pointer
	i32.const	$push74=, 176
	i32.add 	$push75=, $4, $pop74
	i32.store	$discard=, 0($pop76), $pop75
	return  	$pop46
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


	.ident	"clang version 3.9.0 "
