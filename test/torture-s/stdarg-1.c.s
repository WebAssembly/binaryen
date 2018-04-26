	.text
	.file	"stdarg-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 5
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %sw.bb
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
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 16392
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
# %bb.1:                                # %entry
	i32.const	$push2=, 16390
	i32.ne  	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label2
# %bb.2:                                # %if.then
	i32.const	$push45=, 0
	i32.load	$push30=, gap($pop45)
	i32.const	$push31=, 7
	i32.add 	$push32=, $pop30, $pop31
	i32.const	$push33=, -8
	i32.and 	$1=, $pop32, $pop33
	i32.const	$push34=, 8
	i32.add 	$2=, $1, $pop34
	i32.const	$push44=, 0
	i32.store	gap($pop44), $2
	f64.load	$push35=, 0($1)
	f64.const	$push36=, 0x1.1p4
	f64.ne  	$push37=, $pop35, $pop36
	br_if   	2, $pop37       # 2: down to label1
# %bb.3:                                # %lor.lhs.false
	i32.const	$push46=, 0
	i32.const	$push38=, 12
	i32.add 	$push39=, $1, $pop38
	i32.store	gap($pop46), $pop39
	i32.load	$push40=, 0($2)
	i32.const	$push41=, 129
	i32.eq  	$push42=, $pop40, $pop41
	br_if   	1, $pop42       # 1: down to label2
	br      	2               # 2: down to label1
.LBB1_4:                                # %if.then7
	end_block                       # label3:
	i32.const	$push47=, 0
	i32.load	$1=, pap($pop47)
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 7
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, -8
	i32.and 	$2=, $pop6, $pop7
	i32.const	$push8=, 8
	i32.add 	$push9=, $2, $pop8
	i32.store	0($1), $pop9
	i64.load	$push10=, 0($2)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label1
# %bb.5:                                # %lor.lhs.false11
	i32.const	$push48=, 0
	i32.load	$2=, pap($pop48)
	i32.load	$push13=, 0($2)
	i32.const	$push14=, 15
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -16
	i32.and 	$1=, $pop15, $pop16
	i32.const	$push17=, 16
	i32.add 	$push18=, $1, $pop17
	i32.store	0($2), $pop18
	i64.load	$push20=, 0($1)
	i64.load	$push19=, 8($1)
	i64.const	$push22=, 0
	i64.const	$push21=, 4613381465357418496
	i32.call	$push23=, __netf2@FUNCTION, $pop20, $pop19, $pop22, $pop21
	br_if   	1, $pop23       # 1: down to label1
# %bb.6:                                # %lor.lhs.false15
	i32.const	$push24=, 0
	i32.load	$1=, pap($pop24)
	i32.load	$2=, 0($1)
	i32.const	$push25=, 4
	i32.add 	$push26=, $2, $pop25
	i32.store	0($1), $pop26
	i32.load	$push27=, 0($2)
	i32.const	$push28=, 17
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	1, $pop29       # 1: down to label1
.LBB1_7:                                # %if.end22
	end_block                       # label2:
	i32.const	$push43=, 0
	i32.store	bar_arg($pop43), $0
	return
.LBB1_8:                                # %if.then5
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.f0,"ax",@progbits
	.hidden	f0                      # -- Begin function f0
	.globl	f0
	.type	f0,@function
f0:                                     # @f0
	.param  	i32, i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	f0, .Lfunc_end2-f0
                                        # -- End function
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	f1, .Lfunc_end3-f1
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.local  	i32, f64, i32, i32
# %bb.0:                                # %entry
	i32.const	$push93=, 0
	i32.load	$push92=, __stack_pointer($pop93)
	i32.const	$push94=, 16
	i32.sub 	$5=, $pop92, $pop94
	i32.const	$push95=, 0
	i32.store	__stack_pointer($pop95), $5
	i32.store	12($5), $1
	i32.const	$push0=, 0
	f64.load	$3=, d($pop0)
	block   	
	block   	
	f64.abs 	$push89=, $3
	f64.const	$push90=, 0x1p31
	f64.lt  	$push91=, $pop89, $pop90
	br_if   	0, $pop91       # 0: down to label5
# %bb.1:                                # %entry
	i32.const	$1=, -2147483648
	br      	1               # 1: down to label4
.LBB4_2:                                # %entry
	end_block                       # label5:
	i32.trunc_s/f64	$1=, $3
.LBB4_3:                                # %entry
	end_block                       # label4:
	block   	
	block   	
	block   	
	i32.const	$push1=, 16392
	i32.eq  	$push2=, $1, $pop1
	br_if   	0, $pop2        # 0: down to label8
# %bb.4:                                # %entry
	i32.const	$push3=, 16390
	i32.ne  	$push4=, $1, $pop3
	br_if   	1, $pop4        # 1: down to label7
# %bb.5:                                # %if.then.i
	i32.const	$push100=, 0
	i32.load	$push31=, gap($pop100)
	i32.const	$push32=, 7
	i32.add 	$push33=, $pop31, $pop32
	i32.const	$push34=, -8
	i32.and 	$2=, $pop33, $pop34
	i32.const	$push35=, 8
	i32.add 	$4=, $2, $pop35
	i32.const	$push99=, 0
	i32.store	gap($pop99), $4
	f64.load	$push36=, 0($2)
	f64.const	$push37=, 0x1.1p4
	f64.ne  	$push38=, $pop36, $pop37
	br_if   	2, $pop38       # 2: down to label6
# %bb.6:                                # %lor.lhs.false.i
	i32.const	$push101=, 0
	i32.const	$push39=, 12
	i32.add 	$push40=, $2, $pop39
	i32.store	gap($pop101), $pop40
	i32.load	$push41=, 0($4)
	i32.const	$push42=, 129
	i32.eq  	$push43=, $pop41, $pop42
	br_if   	1, $pop43       # 1: down to label7
	br      	2               # 2: down to label6
.LBB4_7:                                # %if.then7.i
	end_block                       # label8:
	i32.const	$push102=, 0
	i32.load	$2=, pap($pop102)
	i32.load	$push5=, 0($2)
	i32.const	$push6=, 7
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -8
	i32.and 	$4=, $pop7, $pop8
	i32.const	$push9=, 8
	i32.add 	$push10=, $4, $pop9
	i32.store	0($2), $pop10
	i64.load	$push11=, 0($4)
	i64.const	$push12=, 14
	i64.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label6
# %bb.8:                                # %lor.lhs.false11.i
	i32.const	$push103=, 0
	i32.load	$4=, pap($pop103)
	i32.load	$push14=, 0($4)
	i32.const	$push15=, 15
	i32.add 	$push16=, $pop14, $pop15
	i32.const	$push17=, -16
	i32.and 	$2=, $pop16, $pop17
	i32.const	$push18=, 16
	i32.add 	$push19=, $2, $pop18
	i32.store	0($4), $pop19
	i64.load	$push21=, 0($2)
	i64.load	$push20=, 8($2)
	i64.const	$push23=, 0
	i64.const	$push22=, 4613381465357418496
	i32.call	$push24=, __netf2@FUNCTION, $pop21, $pop20, $pop23, $pop22
	br_if   	1, $pop24       # 1: down to label6
# %bb.9:                                # %lor.lhs.false15.i
	i32.const	$push25=, 0
	i32.load	$2=, pap($pop25)
	i32.load	$4=, 0($2)
	i32.const	$push26=, 4
	i32.add 	$push27=, $4, $pop26
	i32.store	0($2), $pop27
	i32.load	$push28=, 0($4)
	i32.const	$push29=, 17
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	1, $pop30       # 1: down to label6
.LBB4_10:                               # %bar.exit
	end_block                       # label7:
	i32.const	$push105=, 0
	i32.store	bar_arg($pop105), $1
	i32.load	$1=, 12($5)
	i32.const	$push44=, 4
	i32.add 	$push45=, $1, $pop44
	i32.store	12($5), $pop45
	i32.load	$1=, 0($1)
	i32.const	$push104=, 0
	i32.store	x($pop104), $1
	block   	
	block   	
	i32.const	$push46=, 16392
	i32.eq  	$push47=, $1, $pop46
	br_if   	0, $pop47       # 0: down to label10
# %bb.11:                               # %bar.exit
	i32.const	$push48=, 16390
	i32.ne  	$push49=, $1, $pop48
	br_if   	1, $pop49       # 1: down to label9
# %bb.12:                               # %if.then.i7
	i32.const	$push107=, 0
	i32.load	$push75=, gap($pop107)
	i32.const	$push76=, 7
	i32.add 	$push77=, $pop75, $pop76
	i32.const	$push78=, -8
	i32.and 	$2=, $pop77, $pop78
	i32.const	$push79=, 8
	i32.add 	$4=, $2, $pop79
	i32.const	$push106=, 0
	i32.store	gap($pop106), $4
	f64.load	$push80=, 0($2)
	f64.const	$push81=, 0x1.1p4
	f64.ne  	$push82=, $pop80, $pop81
	br_if   	2, $pop82       # 2: down to label6
# %bb.13:                               # %lor.lhs.false.i10
	i32.const	$push108=, 0
	i32.const	$push83=, 12
	i32.add 	$push84=, $2, $pop83
	i32.store	gap($pop108), $pop84
	i32.load	$push85=, 0($4)
	i32.const	$push86=, 129
	i32.eq  	$push87=, $pop85, $pop86
	br_if   	1, $pop87       # 1: down to label9
	br      	2               # 2: down to label6
.LBB4_14:                               # %if.then7.i16
	end_block                       # label10:
	i32.const	$push109=, 0
	i32.load	$2=, pap($pop109)
	i32.load	$push50=, 0($2)
	i32.const	$push51=, 7
	i32.add 	$push52=, $pop50, $pop51
	i32.const	$push53=, -8
	i32.and 	$4=, $pop52, $pop53
	i32.const	$push54=, 8
	i32.add 	$push55=, $4, $pop54
	i32.store	0($2), $pop55
	i64.load	$push56=, 0($4)
	i64.const	$push57=, 14
	i64.ne  	$push58=, $pop56, $pop57
	br_if   	1, $pop58       # 1: down to label6
# %bb.15:                               # %lor.lhs.false11.i21
	i32.const	$push110=, 0
	i32.load	$4=, pap($pop110)
	i32.load	$push59=, 0($4)
	i32.const	$push60=, 15
	i32.add 	$push61=, $pop59, $pop60
	i32.const	$push62=, -16
	i32.and 	$2=, $pop61, $pop62
	i32.const	$push63=, 16
	i32.add 	$push64=, $2, $pop63
	i32.store	0($4), $pop64
	i64.load	$push66=, 0($2)
	i64.load	$push65=, 8($2)
	i64.const	$push68=, 0
	i64.const	$push67=, 4613381465357418496
	i32.call	$push69=, __netf2@FUNCTION, $pop66, $pop65, $pop68, $pop67
	br_if   	1, $pop69       # 1: down to label6
# %bb.16:                               # %lor.lhs.false15.i25
	i32.const	$push111=, 0
	i32.load	$2=, pap($pop111)
	i32.load	$4=, 0($2)
	i32.const	$push70=, 4
	i32.add 	$push71=, $4, $pop70
	i32.store	0($2), $pop71
	i32.load	$push72=, 0($4)
	i32.const	$push73=, 17
	i32.ne  	$push74=, $pop72, $pop73
	br_if   	1, $pop74       # 1: down to label6
.LBB4_17:                               # %bar.exit27
	end_block                       # label9:
	i32.const	$push88=, 0
	i32.store	bar_arg($pop88), $1
	i32.const	$push98=, 0
	i32.const	$push96=, 16
	i32.add 	$push97=, $5, $pop96
	i32.store	__stack_pointer($pop98), $pop97
	return
.LBB4_18:                               # %if.then5.i
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	f2, .Lfunc_end4-f2
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$2=, __stack_pointer($pop7)
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$1=, $pop1, $pop2
	i32.const	$push4=, 0
	i64.load	$push3=, 0($1)
	i64.store	d($pop4), $pop3
	i32.const	$push8=, 16
	i32.sub 	$push9=, $2, $pop8
	i32.const	$push5=, 8
	i32.add 	$push6=, $1, $pop5
	i32.store	12($pop9), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	f3, .Lfunc_end5-f3
                                        # -- End function
	.section	.text.f4,"ax",@progbits
	.hidden	f4                      # -- Begin function f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	f64, i32, i32
# %bb.0:                                # %entry
	i32.const	$push11=, 0
	i32.load	$push10=, __stack_pointer($pop11)
	i32.const	$push12=, 16
	i32.sub 	$4=, $pop10, $pop12
	i32.const	$push13=, 0
	i32.store	__stack_pointer($pop13), $4
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$1=, $pop1, $pop2
	f64.load	$2=, 0($1)
	block   	
	block   	
	f64.abs 	$push7=, $2
	f64.const	$push8=, 0x1p31
	f64.lt  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label12
# %bb.1:                                # %entry
	i32.const	$3=, -2147483648
	br      	1               # 1: down to label11
.LBB6_2:                                # %entry
	end_block                       # label12:
	i32.trunc_s/f64	$3=, $2
.LBB6_3:                                # %entry
	end_block                       # label11:
	i32.const	$push17=, 0
	i32.store	x($pop17), $3
	i32.const	$push3=, 8
	i32.add 	$1=, $1, $pop3
	i32.store	12($4), $1
	block   	
	i32.const	$push4=, 5
	i32.ne  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label13
# %bb.4:                                # %foo.exit
	i32.const	$push18=, 0
	i32.load	$push6=, 0($1)
	i32.store	foo_arg($pop18), $pop6
	i32.const	$push16=, 0
	i32.const	$push14=, 16
	i32.add 	$push15=, $4, $pop14
	i32.store	__stack_pointer($pop16), $pop15
	return
.LBB6_5:                                # %sw.default.i
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	f4, .Lfunc_end6-f4
                                        # -- End function
	.section	.text.f5,"ax",@progbits
	.hidden	f5                      # -- Begin function f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push44=, 0
	i32.load	$push43=, __stack_pointer($pop44)
	i32.const	$push45=, 16
	i32.sub 	$3=, $pop43, $pop45
	i32.const	$push46=, 0
	i32.store	__stack_pointer($pop46), $3
	i32.const	$push50=, 0
	i32.store	gap($pop50), $1
	i32.store	12($3), $1
	block   	
	block   	
	block   	
	i32.const	$push0=, 16392
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label16
# %bb.1:                                # %entry
	i32.const	$push2=, 16390
	i32.ne  	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label15
# %bb.2:                                # %if.then.i
	i32.const	$push52=, 0
	i32.load	$push29=, gap($pop52)
	i32.const	$push30=, 7
	i32.add 	$push31=, $pop29, $pop30
	i32.const	$push32=, -8
	i32.and 	$1=, $pop31, $pop32
	i32.const	$push33=, 8
	i32.add 	$2=, $1, $pop33
	i32.const	$push51=, 0
	i32.store	gap($pop51), $2
	f64.load	$push34=, 0($1)
	f64.const	$push35=, 0x1.1p4
	f64.ne  	$push36=, $pop34, $pop35
	br_if   	2, $pop36       # 2: down to label14
# %bb.3:                                # %lor.lhs.false.i
	i32.const	$push53=, 0
	i32.const	$push37=, 12
	i32.add 	$push38=, $1, $pop37
	i32.store	gap($pop53), $pop38
	i32.load	$push39=, 0($2)
	i32.const	$push40=, 129
	i32.eq  	$push41=, $pop39, $pop40
	br_if   	1, $pop41       # 1: down to label15
	br      	2               # 2: down to label14
.LBB7_4:                                # %if.then7.i
	end_block                       # label16:
	i32.const	$push54=, 0
	i32.load	$1=, pap($pop54)
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 7
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, -8
	i32.and 	$2=, $pop6, $pop7
	i32.const	$push8=, 8
	i32.add 	$push9=, $2, $pop8
	i32.store	0($1), $pop9
	i64.load	$push10=, 0($2)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label14
# %bb.5:                                # %lor.lhs.false11.i
	i32.const	$push55=, 0
	i32.load	$2=, pap($pop55)
	i32.load	$push13=, 0($2)
	i32.const	$push14=, 15
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -16
	i32.and 	$1=, $pop15, $pop16
	i32.const	$push17=, 16
	i32.add 	$push18=, $1, $pop17
	i32.store	0($2), $pop18
	i64.load	$push20=, 0($1)
	i64.load	$push19=, 8($1)
	i64.const	$push22=, 0
	i64.const	$push21=, 4613381465357418496
	i32.call	$push23=, __netf2@FUNCTION, $pop20, $pop19, $pop22, $pop21
	br_if   	1, $pop23       # 1: down to label14
# %bb.6:                                # %lor.lhs.false15.i
	i32.const	$push56=, 0
	i32.load	$1=, pap($pop56)
	i32.load	$2=, 0($1)
	i32.const	$push24=, 4
	i32.add 	$push25=, $2, $pop24
	i32.store	0($1), $pop25
	i32.load	$push26=, 0($2)
	i32.const	$push27=, 17
	i32.ne  	$push28=, $pop26, $pop27
	br_if   	1, $pop28       # 1: down to label14
.LBB7_7:                                # %bar.exit
	end_block                       # label15:
	i32.const	$push42=, 0
	i32.store	bar_arg($pop42), $0
	i32.const	$push49=, 0
	i32.const	$push47=, 16
	i32.add 	$push48=, $3, $pop47
	i32.store	__stack_pointer($pop49), $pop48
	return
.LBB7_8:                                # %if.then5.i
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	f5, .Lfunc_end7-f5
                                        # -- End function
	.section	.text.f6,"ax",@progbits
	.hidden	f6                      # -- Begin function f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32, i32
	.local  	f64, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push93=, 0
	i32.load	$push92=, __stack_pointer($pop93)
	i32.const	$push94=, 16
	i32.sub 	$5=, $pop92, $pop94
	i32.const	$push95=, 0
	i32.store	__stack_pointer($pop95), $5
	i32.store	12($5), $1
	i32.const	$push0=, 0
	f64.load	$2=, d($pop0)
	block   	
	block   	
	f64.abs 	$push89=, $2
	f64.const	$push90=, 0x1p31
	f64.lt  	$push91=, $pop89, $pop90
	br_if   	0, $pop91       # 0: down to label18
# %bb.1:                                # %entry
	i32.const	$1=, -2147483648
	br      	1               # 1: down to label17
.LBB8_2:                                # %entry
	end_block                       # label18:
	i32.trunc_s/f64	$1=, $2
.LBB8_3:                                # %entry
	end_block                       # label17:
	block   	
	block   	
	block   	
	i32.const	$push1=, 16392
	i32.eq  	$push2=, $1, $pop1
	br_if   	0, $pop2        # 0: down to label21
# %bb.4:                                # %entry
	i32.const	$push3=, 16390
	i32.ne  	$push4=, $1, $pop3
	br_if   	1, $pop4        # 1: down to label20
# %bb.5:                                # %if.then.i
	i32.const	$push100=, 0
	i32.load	$push31=, gap($pop100)
	i32.const	$push32=, 7
	i32.add 	$push33=, $pop31, $pop32
	i32.const	$push34=, -8
	i32.and 	$4=, $pop33, $pop34
	i32.const	$push35=, 8
	i32.add 	$3=, $4, $pop35
	i32.const	$push99=, 0
	i32.store	gap($pop99), $3
	f64.load	$push36=, 0($4)
	f64.const	$push37=, 0x1.1p4
	f64.ne  	$push38=, $pop36, $pop37
	br_if   	2, $pop38       # 2: down to label19
# %bb.6:                                # %lor.lhs.false.i
	i32.const	$push101=, 0
	i32.const	$push39=, 12
	i32.add 	$push40=, $4, $pop39
	i32.store	gap($pop101), $pop40
	i32.load	$push41=, 0($3)
	i32.const	$push42=, 129
	i32.eq  	$push43=, $pop41, $pop42
	br_if   	1, $pop43       # 1: down to label20
	br      	2               # 2: down to label19
.LBB8_7:                                # %if.then7.i
	end_block                       # label21:
	i32.const	$push102=, 0
	i32.load	$4=, pap($pop102)
	i32.load	$push5=, 0($4)
	i32.const	$push6=, 7
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -8
	i32.and 	$3=, $pop7, $pop8
	i32.const	$push9=, 8
	i32.add 	$push10=, $3, $pop9
	i32.store	0($4), $pop10
	i64.load	$push11=, 0($3)
	i64.const	$push12=, 14
	i64.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label19
# %bb.8:                                # %lor.lhs.false11.i
	i32.const	$push103=, 0
	i32.load	$3=, pap($pop103)
	i32.load	$push14=, 0($3)
	i32.const	$push15=, 15
	i32.add 	$push16=, $pop14, $pop15
	i32.const	$push17=, -16
	i32.and 	$4=, $pop16, $pop17
	i32.const	$push18=, 16
	i32.add 	$push19=, $4, $pop18
	i32.store	0($3), $pop19
	i64.load	$push21=, 0($4)
	i64.load	$push20=, 8($4)
	i64.const	$push23=, 0
	i64.const	$push22=, 4613381465357418496
	i32.call	$push24=, __netf2@FUNCTION, $pop21, $pop20, $pop23, $pop22
	br_if   	1, $pop24       # 1: down to label19
# %bb.9:                                # %lor.lhs.false15.i
	i32.const	$push25=, 0
	i32.load	$4=, pap($pop25)
	i32.load	$3=, 0($4)
	i32.const	$push26=, 4
	i32.add 	$push27=, $3, $pop26
	i32.store	0($4), $pop27
	i32.load	$push28=, 0($3)
	i32.const	$push29=, 17
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	1, $pop30       # 1: down to label19
.LBB8_10:                               # %bar.exit
	end_block                       # label20:
	i32.const	$push105=, 0
	i32.store	bar_arg($pop105), $1
	i32.load	$4=, 12($5)
	i32.load	$1=, 8($4)
	i32.const	$push104=, 0
	i32.store	x($pop104), $1
	i32.const	$push44=, 12
	i32.add 	$push45=, $4, $pop44
	i32.store	12($5), $pop45
	block   	
	block   	
	i32.const	$push46=, 16392
	i32.eq  	$push47=, $1, $pop46
	br_if   	0, $pop47       # 0: down to label23
# %bb.11:                               # %bar.exit
	i32.const	$push48=, 16390
	i32.ne  	$push49=, $1, $pop48
	br_if   	1, $pop49       # 1: down to label22
# %bb.12:                               # %if.then.i11
	i32.const	$push107=, 0
	i32.load	$push75=, gap($pop107)
	i32.const	$push76=, 7
	i32.add 	$push77=, $pop75, $pop76
	i32.const	$push78=, -8
	i32.and 	$4=, $pop77, $pop78
	i32.const	$push79=, 8
	i32.add 	$3=, $4, $pop79
	i32.const	$push106=, 0
	i32.store	gap($pop106), $3
	f64.load	$push80=, 0($4)
	f64.const	$push81=, 0x1.1p4
	f64.ne  	$push82=, $pop80, $pop81
	br_if   	2, $pop82       # 2: down to label19
# %bb.13:                               # %lor.lhs.false.i14
	i32.const	$push108=, 0
	i32.const	$push83=, 12
	i32.add 	$push84=, $4, $pop83
	i32.store	gap($pop108), $pop84
	i32.load	$push85=, 0($3)
	i32.const	$push86=, 129
	i32.eq  	$push87=, $pop85, $pop86
	br_if   	1, $pop87       # 1: down to label22
	br      	2               # 2: down to label19
.LBB8_14:                               # %if.then7.i20
	end_block                       # label23:
	i32.const	$push109=, 0
	i32.load	$4=, pap($pop109)
	i32.load	$push50=, 0($4)
	i32.const	$push51=, 7
	i32.add 	$push52=, $pop50, $pop51
	i32.const	$push53=, -8
	i32.and 	$3=, $pop52, $pop53
	i32.const	$push54=, 8
	i32.add 	$push55=, $3, $pop54
	i32.store	0($4), $pop55
	i64.load	$push56=, 0($3)
	i64.const	$push57=, 14
	i64.ne  	$push58=, $pop56, $pop57
	br_if   	1, $pop58       # 1: down to label19
# %bb.15:                               # %lor.lhs.false11.i25
	i32.const	$push110=, 0
	i32.load	$3=, pap($pop110)
	i32.load	$push59=, 0($3)
	i32.const	$push60=, 15
	i32.add 	$push61=, $pop59, $pop60
	i32.const	$push62=, -16
	i32.and 	$4=, $pop61, $pop62
	i32.const	$push63=, 16
	i32.add 	$push64=, $4, $pop63
	i32.store	0($3), $pop64
	i64.load	$push66=, 0($4)
	i64.load	$push65=, 8($4)
	i64.const	$push68=, 0
	i64.const	$push67=, 4613381465357418496
	i32.call	$push69=, __netf2@FUNCTION, $pop66, $pop65, $pop68, $pop67
	br_if   	1, $pop69       # 1: down to label19
# %bb.16:                               # %lor.lhs.false15.i29
	i32.const	$push111=, 0
	i32.load	$4=, pap($pop111)
	i32.load	$3=, 0($4)
	i32.const	$push70=, 4
	i32.add 	$push71=, $3, $pop70
	i32.store	0($4), $pop71
	i32.load	$push72=, 0($3)
	i32.const	$push73=, 17
	i32.ne  	$push74=, $pop72, $pop73
	br_if   	1, $pop74       # 1: down to label19
.LBB8_17:                               # %bar.exit31
	end_block                       # label22:
	i32.const	$push88=, 0
	i32.store	bar_arg($pop88), $1
	i32.const	$push98=, 0
	i32.const	$push96=, 16
	i32.add 	$push97=, $5, $pop96
	i32.store	__stack_pointer($pop98), $pop97
	return
.LBB8_18:                               # %if.then5.i
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end8:
	.size	f6, .Lfunc_end8-f6
                                        # -- End function
	.section	.text.f7,"ax",@progbits
	.hidden	f7                      # -- Begin function f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push42=, 0
	i32.load	$push41=, __stack_pointer($pop42)
	i32.const	$push43=, 16
	i32.sub 	$3=, $pop41, $pop43
	i32.const	$push44=, 0
	i32.store	__stack_pointer($pop44), $3
	i32.const	$push0=, 0
	i32.const	$push48=, 12
	i32.add 	$push49=, $3, $pop48
	i32.store	pap($pop0), $pop49
	i32.store	12($3), $1
	block   	
	block   	
	block   	
	i32.const	$push1=, 16392
	i32.eq  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label26
# %bb.1:                                # %entry
	i32.const	$push3=, 16390
	i32.ne  	$push4=, $0, $pop3
	br_if   	1, $pop4        # 1: down to label25
# %bb.2:                                # %if.then.i
	i32.const	$push51=, 0
	i32.load	$push27=, gap($pop51)
	i32.const	$push28=, 7
	i32.add 	$push29=, $pop27, $pop28
	i32.const	$push30=, -8
	i32.and 	$1=, $pop29, $pop30
	i32.const	$push31=, 8
	i32.add 	$2=, $1, $pop31
	i32.const	$push50=, 0
	i32.store	gap($pop50), $2
	f64.load	$push32=, 0($1)
	f64.const	$push33=, 0x1.1p4
	f64.ne  	$push34=, $pop32, $pop33
	br_if   	2, $pop34       # 2: down to label24
# %bb.3:                                # %lor.lhs.false.i
	i32.const	$push52=, 0
	i32.const	$push35=, 12
	i32.add 	$push36=, $1, $pop35
	i32.store	gap($pop52), $pop36
	i32.load	$push37=, 0($2)
	i32.const	$push38=, 129
	i32.eq  	$push39=, $pop37, $pop38
	br_if   	1, $pop39       # 1: down to label25
	br      	2               # 2: down to label24
.LBB9_4:                                # %if.then7.i
	end_block                       # label26:
	i32.load	$push6=, 12($3)
	i32.const	$push5=, 7
	i32.add 	$push7=, $pop6, $pop5
	i32.const	$push8=, -8
	i32.and 	$1=, $pop7, $pop8
	i32.const	$push9=, 8
	i32.add 	$2=, $1, $pop9
	i32.store	12($3), $2
	i64.load	$push10=, 0($1)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label24
# %bb.5:                                # %lor.lhs.false11.i
	i32.const	$push13=, 15
	i32.add 	$push14=, $2, $pop13
	i32.const	$push15=, -16
	i32.and 	$1=, $pop14, $pop15
	i32.const	$push16=, 16
	i32.add 	$2=, $1, $pop16
	i32.store	12($3), $2
	i64.load	$push18=, 0($1)
	i64.load	$push17=, 8($1)
	i64.const	$push20=, 0
	i64.const	$push19=, 4613381465357418496
	i32.call	$push21=, __netf2@FUNCTION, $pop18, $pop17, $pop20, $pop19
	br_if   	1, $pop21       # 1: down to label24
# %bb.6:                                # %lor.lhs.false15.i
	i32.const	$push22=, 20
	i32.add 	$push23=, $1, $pop22
	i32.store	12($3), $pop23
	i32.load	$push24=, 0($2)
	i32.const	$push25=, 17
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	1, $pop26       # 1: down to label24
.LBB9_7:                                # %bar.exit
	end_block                       # label25:
	i32.const	$push40=, 0
	i32.store	bar_arg($pop40), $0
	i32.const	$push47=, 0
	i32.const	$push45=, 16
	i32.add 	$push46=, $3, $pop45
	i32.store	__stack_pointer($pop47), $pop46
	return
.LBB9_8:                                # %if.then5.i
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end9:
	.size	f7, .Lfunc_end9-f7
                                        # -- End function
	.section	.text.f8,"ax",@progbits
	.hidden	f8                      # -- Begin function f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push49=, 0
	i32.load	$push48=, __stack_pointer($pop49)
	i32.const	$push50=, 16
	i32.sub 	$3=, $pop48, $pop50
	i32.const	$push51=, 0
	i32.store	__stack_pointer($pop51), $3
	i32.const	$push0=, 0
	i32.const	$push55=, 12
	i32.add 	$push56=, $3, $pop55
	i32.store	pap($pop0), $pop56
	i32.store	12($3), $1
	block   	
	block   	
	block   	
	i32.const	$push1=, 16392
	i32.eq  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label29
# %bb.1:                                # %entry
	i32.const	$push3=, 16390
	i32.ne  	$push4=, $0, $pop3
	br_if   	1, $pop4        # 1: down to label28
# %bb.2:                                # %if.then.i
	i32.const	$push58=, 0
	i32.load	$push27=, gap($pop58)
	i32.const	$push28=, 7
	i32.add 	$push29=, $pop27, $pop28
	i32.const	$push30=, -8
	i32.and 	$1=, $pop29, $pop30
	i32.const	$push31=, 8
	i32.add 	$2=, $1, $pop31
	i32.const	$push57=, 0
	i32.store	gap($pop57), $2
	f64.load	$push32=, 0($1)
	f64.const	$push33=, 0x1.1p4
	f64.ne  	$push34=, $pop32, $pop33
	br_if   	2, $pop34       # 2: down to label27
# %bb.3:                                # %lor.lhs.false.i
	i32.const	$push59=, 0
	i32.const	$push35=, 12
	i32.add 	$push36=, $1, $pop35
	i32.store	gap($pop59), $pop36
	i32.load	$push37=, 0($2)
	i32.const	$push38=, 129
	i32.eq  	$push39=, $pop37, $pop38
	br_if   	1, $pop39       # 1: down to label28
	br      	2               # 2: down to label27
.LBB10_4:                               # %if.then7.i
	end_block                       # label29:
	i32.load	$push6=, 12($3)
	i32.const	$push5=, 7
	i32.add 	$push7=, $pop6, $pop5
	i32.const	$push8=, -8
	i32.and 	$1=, $pop7, $pop8
	i32.const	$push9=, 8
	i32.add 	$2=, $1, $pop9
	i32.store	12($3), $2
	i64.load	$push10=, 0($1)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label27
# %bb.5:                                # %lor.lhs.false11.i
	i32.const	$push13=, 15
	i32.add 	$push14=, $2, $pop13
	i32.const	$push15=, -16
	i32.and 	$1=, $pop14, $pop15
	i32.const	$push16=, 16
	i32.add 	$2=, $1, $pop16
	i32.store	12($3), $2
	i64.load	$push18=, 0($1)
	i64.load	$push17=, 8($1)
	i64.const	$push20=, 0
	i64.const	$push19=, 4613381465357418496
	i32.call	$push21=, __netf2@FUNCTION, $pop18, $pop17, $pop20, $pop19
	br_if   	1, $pop21       # 1: down to label27
# %bb.6:                                # %lor.lhs.false15.i
	i32.const	$push22=, 20
	i32.add 	$push23=, $1, $pop22
	i32.store	12($3), $pop23
	i32.load	$push24=, 0($2)
	i32.const	$push25=, 17
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	1, $pop26       # 1: down to label27
.LBB10_7:                               # %bar.exit
	end_block                       # label28:
	i32.const	$push40=, 0
	i32.store	bar_arg($pop40), $0
	i32.load	$push42=, 12($3)
	i32.const	$push41=, 7
	i32.add 	$push43=, $pop42, $pop41
	i32.const	$push44=, -8
	i32.and 	$0=, $pop43, $pop44
	i32.const	$push60=, 0
	i64.load	$push45=, 0($0)
	i64.store	d($pop60), $pop45
	i32.const	$push46=, 8
	i32.add 	$push47=, $0, $pop46
	i32.store	12($3), $pop47
	i32.const	$push54=, 0
	i32.const	$push52=, 16
	i32.add 	$push53=, $3, $pop52
	i32.store	__stack_pointer($pop54), $pop53
	return
.LBB10_8:                               # %if.then5.i
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end10:
	.size	f8, .Lfunc_end10-f8
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push42=, 0
	i32.load	$push41=, __stack_pointer($pop42)
	i32.const	$push43=, 176
	i32.sub 	$0=, $pop41, $pop43
	i32.const	$push44=, 0
	i32.store	__stack_pointer($pop44), $0
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
	br_if   	0, $pop3        # 0: down to label30
# %bb.1:                                # %entry
	i32.const	$push71=, 0
	i32.load	$push0=, x($pop71)
	i32.const	$push70=, 28
	i32.ne  	$push4=, $pop0, $pop70
	br_if   	0, $pop4        # 0: down to label30
# %bb.2:                                # %if.end
	i64.const	$push5=, 4638813169307877376
	i64.store	144($0), $pop5
	i32.const	$push50=, 144
	i32.add 	$push51=, $0, $pop50
	call    	f3@FUNCTION, $0, $pop51
	i32.const	$push72=, 0
	f64.load	$push6=, d($pop72)
	f64.const	$push7=, 0x1.06p7
	f64.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label30
# %bb.3:                                # %if.end4
	i32.const	$push74=, 128
	i32.store	136($0), $pop74
	i64.const	$push10=, 4625196817309499392
	i64.store	128($0), $pop10
	i32.const	$push11=, 5
	i32.const	$push52=, 128
	i32.add 	$push53=, $0, $pop52
	call    	f4@FUNCTION, $pop11, $pop53
	i32.const	$push73=, 0
	i32.load	$push12=, x($pop73)
	i32.const	$push13=, 16
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label30
# %bb.4:                                # %if.end4
	i32.const	$push76=, 0
	i32.load	$push9=, foo_arg($pop76)
	i32.const	$push75=, 128
	i32.ne  	$push15=, $pop9, $pop75
	br_if   	0, $pop15       # 0: down to label30
# %bb.5:                                # %if.end9
	i32.const	$push16=, 129
	i32.store	120($0), $pop16
	i64.const	$push17=, 4625478292286210048
	i64.store	112($0), $pop17
	i32.const	$push18=, 16390
	i32.const	$push54=, 112
	i32.add 	$push55=, $0, $pop54
	call    	f5@FUNCTION, $pop18, $pop55
	i32.const	$push78=, 0
	i32.load	$push19=, bar_arg($pop78)
	i32.const	$push77=, 16390
	i32.ne  	$push20=, $pop19, $pop77
	br_if   	0, $pop20       # 0: down to label30
# %bb.6:                                # %if.end12
	i64.const	$push21=, 60129542156
	i64.store	96($0), $pop21
	i32.const	$push22=, -31
	i32.store	104($0), $pop22
	i32.const	$push56=, 96
	i32.add 	$push57=, $0, $pop56
	call    	f6@FUNCTION, $0, $pop57
	i32.const	$push80=, 0
	i32.load	$push23=, bar_arg($pop80)
	i32.const	$push79=, -31
	i32.ne  	$push24=, $pop23, $pop79
	br_if   	0, $pop24       # 0: down to label30
# %bb.7:                                # %if.end15
	i32.const	$push58=, 48
	i32.add 	$push59=, $0, $pop58
	i32.const	$push90=, 32
	i32.add 	$push25=, $pop59, $pop90
	i64.const	$push26=, 4628011567076605952
	i64.store	0($pop25), $pop26
	i32.const	$push60=, 48
	i32.add 	$push61=, $0, $pop60
	i32.const	$push89=, 24
	i32.add 	$push27=, $pop61, $pop89
	i32.const	$push88=, 17
	i32.store	0($pop27), $pop88
	i32.const	$push62=, 48
	i32.add 	$push63=, $0, $pop62
	i32.const	$push87=, 16
	i32.add 	$push28=, $pop63, $pop87
	i64.const	$push86=, 4613381465357418496
	i64.store	0($pop28), $pop86
	i64.const	$push85=, 0
	i64.store	56($0), $pop85
	i64.const	$push84=, 14
	i64.store	48($0), $pop84
	i32.const	$push83=, 16392
	i32.const	$push64=, 48
	i32.add 	$push65=, $0, $pop64
	call    	f7@FUNCTION, $pop83, $pop65
	i32.const	$push82=, 0
	i32.load	$push29=, bar_arg($pop82)
	i32.const	$push81=, 16392
	i32.ne  	$push30=, $pop29, $pop81
	br_if   	0, $pop30       # 0: down to label30
# %bb.8:                                # %if.end18
	i32.const	$push100=, 32
	i32.add 	$push32=, $0, $pop100
	i64.const	$push33=, 4628293042053316608
	i64.store	0($pop32), $pop33
	i32.const	$push99=, 24
	i32.add 	$push34=, $0, $pop99
	i32.const	$push98=, 17
	i32.store	0($pop34), $pop98
	i32.const	$push97=, 16
	i32.add 	$push35=, $0, $pop97
	i64.const	$push96=, 4613381465357418496
	i64.store	0($pop35), $pop96
	i64.const	$push95=, 0
	i64.store	8($0), $pop95
	i64.const	$push94=, 14
	i64.store	0($0), $pop94
	i32.const	$push93=, 16392
	call    	f8@FUNCTION, $pop93, $0
	i32.const	$push92=, 0
	i32.load	$push36=, bar_arg($pop92)
	i32.const	$push91=, 16392
	i32.ne  	$push37=, $pop36, $pop91
	br_if   	0, $pop37       # 0: down to label30
# %bb.9:                                # %if.end18
	i32.const	$push101=, 0
	f64.load	$push31=, d($pop101)
	f64.const	$push38=, 0x1.bp4
	f64.ne  	$push39=, $pop31, $pop38
	br_if   	0, $pop39       # 0: down to label30
# %bb.10:                               # %if.end23
	i32.const	$push47=, 0
	i32.const	$push45=, 176
	i32.add 	$push46=, $0, $pop45
	i32.store	__stack_pointer($pop47), $pop46
	i32.const	$push40=, 0
	return  	$pop40
.LBB11_11:                              # %if.then
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end11:
	.size	main, .Lfunc_end11-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
