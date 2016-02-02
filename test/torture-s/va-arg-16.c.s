	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-16.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	f64, f64
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	copy_local	$7=, $6
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$discard=, 12($6), $7
	block
	f64.const	$push0=, 0x1.bcp9
	f64.ne  	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.end
	block
	f64.const	$push2=, 0x1.f38p9
	f64.ne  	$push3=, $1, $pop2
	br_if   	$pop3, 0        # 0: down to label1
# BB#2:                                 # %if.end4
	i32.load	$push4=, 12($6)
	i32.const	$push73=, 7
	i32.add 	$push5=, $pop4, $pop73
	i32.const	$push72=, -8
	i32.and 	$push6=, $pop5, $pop72
	tee_local	$push71=, $2=, $pop6
	i32.const	$push70=, 8
	i32.add 	$push7=, $pop71, $pop70
	i32.store	$discard=, 12($6), $pop7
	block
	f64.load	$push8=, 0($2)
	f64.const	$push9=, 0x1p0
	f64.ne  	$push10=, $pop8, $pop9
	br_if   	$pop10, 0       # 0: down to label2
# BB#3:                                 # %if.end7
	i32.load	$push11=, 12($6)
	i32.const	$push77=, 7
	i32.add 	$push12=, $pop11, $pop77
	i32.const	$push76=, -8
	i32.and 	$push13=, $pop12, $pop76
	tee_local	$push75=, $2=, $pop13
	i32.const	$push74=, 8
	i32.add 	$push14=, $pop75, $pop74
	i32.store	$discard=, 12($6), $pop14
	block
	f64.load	$push15=, 0($2)
	f64.const	$push16=, 0x1p1
	f64.ne  	$push17=, $pop15, $pop16
	br_if   	$pop17, 0       # 0: down to label3
# BB#4:                                 # %if.end10
	i32.load	$push18=, 12($6)
	i32.const	$push81=, 7
	i32.add 	$push19=, $pop18, $pop81
	i32.const	$push80=, -8
	i32.and 	$push20=, $pop19, $pop80
	tee_local	$push79=, $2=, $pop20
	i32.const	$push78=, 8
	i32.add 	$push21=, $pop79, $pop78
	i32.store	$discard=, 12($6), $pop21
	block
	f64.load	$push22=, 0($2)
	f64.const	$push23=, 0x1.8p1
	f64.ne  	$push24=, $pop22, $pop23
	br_if   	$pop24, 0       # 0: down to label4
# BB#5:                                 # %if.end13
	i32.load	$push25=, 12($6)
	i32.const	$push85=, 7
	i32.add 	$push26=, $pop25, $pop85
	i32.const	$push84=, -8
	i32.and 	$push27=, $pop26, $pop84
	tee_local	$push83=, $2=, $pop27
	i32.const	$push82=, 8
	i32.add 	$push28=, $pop83, $pop82
	i32.store	$discard=, 12($6), $pop28
	block
	f64.load	$push29=, 0($2)
	f64.const	$push30=, 0x1p2
	f64.ne  	$push31=, $pop29, $pop30
	br_if   	$pop31, 0       # 0: down to label5
# BB#6:                                 # %if.end16
	i32.load	$push32=, 12($6)
	i32.const	$push89=, 7
	i32.add 	$push33=, $pop32, $pop89
	i32.const	$push88=, -8
	i32.and 	$push34=, $pop33, $pop88
	tee_local	$push87=, $2=, $pop34
	i32.const	$push86=, 8
	i32.add 	$push35=, $pop87, $pop86
	i32.store	$discard=, 12($6), $pop35
	block
	f64.load	$push36=, 0($2)
	f64.const	$push37=, 0x1.4p2
	f64.ne  	$push38=, $pop36, $pop37
	br_if   	$pop38, 0       # 0: down to label6
# BB#7:                                 # %if.end19
	i32.load	$push39=, 12($6)
	i32.const	$push93=, 7
	i32.add 	$push40=, $pop39, $pop93
	i32.const	$push92=, -8
	i32.and 	$push41=, $pop40, $pop92
	tee_local	$push91=, $2=, $pop41
	i32.const	$push90=, 8
	i32.add 	$push42=, $pop91, $pop90
	i32.store	$discard=, 12($6), $pop42
	block
	f64.load	$push43=, 0($2)
	f64.const	$push44=, 0x1.8p2
	f64.ne  	$push45=, $pop43, $pop44
	br_if   	$pop45, 0       # 0: down to label7
# BB#8:                                 # %if.end22
	i32.load	$push46=, 12($6)
	i32.const	$push97=, 7
	i32.add 	$push47=, $pop46, $pop97
	i32.const	$push96=, -8
	i32.and 	$push48=, $pop47, $pop96
	tee_local	$push95=, $2=, $pop48
	i32.const	$push94=, 8
	i32.add 	$push49=, $pop95, $pop94
	i32.store	$discard=, 12($6), $pop49
	block
	f64.load	$push50=, 0($2)
	f64.const	$push51=, 0x1.cp2
	f64.ne  	$push52=, $pop50, $pop51
	br_if   	$pop52, 0       # 0: down to label8
# BB#9:                                 # %if.end25
	i32.load	$push53=, 12($6)
	i32.const	$push101=, 7
	i32.add 	$push54=, $pop53, $pop101
	i32.const	$push100=, -8
	i32.and 	$push55=, $pop54, $pop100
	tee_local	$push99=, $2=, $pop55
	i32.const	$push98=, 8
	i32.add 	$push56=, $pop99, $pop98
	i32.store	$discard=, 12($6), $pop56
	block
	f64.load	$push57=, 0($2)
	f64.const	$push58=, 0x1p3
	f64.ne  	$push59=, $pop57, $pop58
	br_if   	$pop59, 0       # 0: down to label9
# BB#10:                                # %if.end28
	i32.load	$push60=, 12($6)
	i32.const	$push61=, 7
	i32.add 	$push62=, $pop60, $pop61
	i32.const	$push63=, -8
	i32.and 	$push64=, $pop62, $pop63
	tee_local	$push102=, $2=, $pop64
	i32.const	$push65=, 8
	i32.add 	$push66=, $pop102, $pop65
	i32.store	$discard=, 12($6), $pop66
	block
	f64.load	$push67=, 0($2)
	f64.const	$push68=, 0x1.2p3
	f64.ne  	$push69=, $pop67, $pop68
	br_if   	$pop69, 0       # 0: down to label10
# BB#11:                                # %if.end31
	i32.const	$5=, 16
	i32.add 	$6=, $7, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
.LBB0_12:                               # %if.then30
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.then27
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %if.then24
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then21
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then18
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then15
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %if.then12
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_19:                               # %if.then9
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %if.then6
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_21:                               # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_22:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	vafunction, .Lfunc_end0-vafunction

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 80
	i32.sub 	$7=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 72
	i32.sub 	$7=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	i64.const	$push0=, 4607182418800017408
	i64.store	$discard=, 0($7), $pop0
	i32.const	$push1=, 64
	i32.add 	$0=, $7, $pop1
	i64.const	$push2=, 4621256167635550208
	i64.store	$discard=, 0($0), $pop2
	i32.const	$push3=, 56
	i32.add 	$0=, $7, $pop3
	i64.const	$push4=, 4620693217682128896
	i64.store	$discard=, 0($0), $pop4
	i32.const	$push5=, 48
	i32.add 	$0=, $7, $pop5
	i64.const	$push6=, 4619567317775286272
	i64.store	$discard=, 0($0), $pop6
	i32.const	$push7=, 40
	i32.add 	$0=, $7, $pop7
	i64.const	$push8=, 4618441417868443648
	i64.store	$discard=, 0($0), $pop8
	i32.const	$push9=, 32
	i32.add 	$0=, $7, $pop9
	i64.const	$push10=, 4617315517961601024
	i64.store	$discard=, 0($0), $pop10
	i32.const	$push11=, 24
	i32.add 	$0=, $7, $pop11
	i64.const	$push12=, 4616189618054758400
	i64.store	$discard=, 0($0), $pop12
	i32.const	$push13=, 16
	i32.add 	$0=, $7, $pop13
	i64.const	$push14=, 4613937818241073152
	i64.store	$discard=, 0($0), $pop14
	i32.const	$push15=, 8
	i32.add 	$0=, $7, $pop15
	i64.const	$push16=, 4611686018427387904
	i64.store	$discard=, 0($0), $pop16
	f64.const	$push18=, 0x1.bcp9
	f64.const	$push17=, 0x1.f38p9
	call    	vafunction@FUNCTION, $pop18, $pop17
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 72
	i32.add 	$7=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	i32.const	$push19=, 0
	call    	exit@FUNCTION, $pop19
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
