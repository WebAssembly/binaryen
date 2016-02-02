	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-17.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	copy_local	$6=, $5
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 12($5), $6
	i32.const	$push69=, 7
	i32.add 	$push1=, $pop0, $pop69
	i32.const	$push68=, -8
	i32.and 	$push2=, $pop1, $pop68
	tee_local	$push67=, $1=, $pop2
	i32.const	$push66=, 8
	i32.add 	$push3=, $pop67, $pop66
	i32.store	$discard=, 12($5), $pop3
	block
	f64.load	$push4=, 0($1)
	f64.const	$push5=, 0x1p0
	f64.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push7=, 12($5)
	i32.const	$push73=, 7
	i32.add 	$push8=, $pop7, $pop73
	i32.const	$push72=, -8
	i32.and 	$push9=, $pop8, $pop72
	tee_local	$push71=, $1=, $pop9
	i32.const	$push70=, 8
	i32.add 	$push10=, $pop71, $pop70
	i32.store	$discard=, 12($5), $pop10
	block
	f64.load	$push11=, 0($1)
	f64.const	$push12=, 0x1p1
	f64.ne  	$push13=, $pop11, $pop12
	br_if   	$pop13, 0       # 0: down to label1
# BB#2:                                 # %if.end4
	i32.load	$push14=, 12($5)
	i32.const	$push77=, 7
	i32.add 	$push15=, $pop14, $pop77
	i32.const	$push76=, -8
	i32.and 	$push16=, $pop15, $pop76
	tee_local	$push75=, $1=, $pop16
	i32.const	$push74=, 8
	i32.add 	$push17=, $pop75, $pop74
	i32.store	$discard=, 12($5), $pop17
	block
	f64.load	$push18=, 0($1)
	f64.const	$push19=, 0x1.8p1
	f64.ne  	$push20=, $pop18, $pop19
	br_if   	$pop20, 0       # 0: down to label2
# BB#3:                                 # %if.end7
	i32.load	$push21=, 12($5)
	i32.const	$push81=, 7
	i32.add 	$push22=, $pop21, $pop81
	i32.const	$push80=, -8
	i32.and 	$push23=, $pop22, $pop80
	tee_local	$push79=, $1=, $pop23
	i32.const	$push78=, 8
	i32.add 	$push24=, $pop79, $pop78
	i32.store	$discard=, 12($5), $pop24
	block
	f64.load	$push25=, 0($1)
	f64.const	$push26=, 0x1p2
	f64.ne  	$push27=, $pop25, $pop26
	br_if   	$pop27, 0       # 0: down to label3
# BB#4:                                 # %if.end10
	i32.load	$push28=, 12($5)
	i32.const	$push85=, 7
	i32.add 	$push29=, $pop28, $pop85
	i32.const	$push84=, -8
	i32.and 	$push30=, $pop29, $pop84
	tee_local	$push83=, $1=, $pop30
	i32.const	$push82=, 8
	i32.add 	$push31=, $pop83, $pop82
	i32.store	$discard=, 12($5), $pop31
	block
	f64.load	$push32=, 0($1)
	f64.const	$push33=, 0x1.4p2
	f64.ne  	$push34=, $pop32, $pop33
	br_if   	$pop34, 0       # 0: down to label4
# BB#5:                                 # %if.end13
	i32.load	$push35=, 12($5)
	i32.const	$push89=, 7
	i32.add 	$push36=, $pop35, $pop89
	i32.const	$push88=, -8
	i32.and 	$push37=, $pop36, $pop88
	tee_local	$push87=, $1=, $pop37
	i32.const	$push86=, 8
	i32.add 	$push38=, $pop87, $pop86
	i32.store	$discard=, 12($5), $pop38
	block
	f64.load	$push39=, 0($1)
	f64.const	$push40=, 0x1.8p2
	f64.ne  	$push41=, $pop39, $pop40
	br_if   	$pop41, 0       # 0: down to label5
# BB#6:                                 # %if.end16
	i32.load	$push42=, 12($5)
	i32.const	$push93=, 7
	i32.add 	$push43=, $pop42, $pop93
	i32.const	$push92=, -8
	i32.and 	$push44=, $pop43, $pop92
	tee_local	$push91=, $1=, $pop44
	i32.const	$push90=, 8
	i32.add 	$push45=, $pop91, $pop90
	i32.store	$discard=, 12($5), $pop45
	block
	f64.load	$push46=, 0($1)
	f64.const	$push47=, 0x1.cp2
	f64.ne  	$push48=, $pop46, $pop47
	br_if   	$pop48, 0       # 0: down to label6
# BB#7:                                 # %if.end19
	i32.load	$push49=, 12($5)
	i32.const	$push97=, 7
	i32.add 	$push50=, $pop49, $pop97
	i32.const	$push96=, -8
	i32.and 	$push51=, $pop50, $pop96
	tee_local	$push95=, $1=, $pop51
	i32.const	$push94=, 8
	i32.add 	$push52=, $pop95, $pop94
	i32.store	$discard=, 12($5), $pop52
	block
	f64.load	$push53=, 0($1)
	f64.const	$push54=, 0x1p3
	f64.ne  	$push55=, $pop53, $pop54
	br_if   	$pop55, 0       # 0: down to label7
# BB#8:                                 # %if.end22
	i32.load	$push56=, 12($5)
	i32.const	$push57=, 7
	i32.add 	$push58=, $pop56, $pop57
	i32.const	$push59=, -8
	i32.and 	$push60=, $pop58, $pop59
	tee_local	$push98=, $1=, $pop60
	i32.const	$push61=, 8
	i32.add 	$push62=, $pop98, $pop61
	i32.store	$discard=, 12($5), $pop62
	block
	f64.load	$push63=, 0($1)
	f64.const	$push64=, 0x1.2p3
	f64.ne  	$push65=, $pop63, $pop64
	br_if   	$pop65, 0       # 0: down to label8
# BB#9:                                 # %if.end25
	i32.const	$4=, 16
	i32.add 	$5=, $6, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB0_10:                               # %if.then24
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %if.then21
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %if.then18
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.then15
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %if.then12
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then9
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then6
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %if.then
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
	call    	vafunction@FUNCTION, $0
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 72
	i32.add 	$7=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	i32.const	$push17=, 0
	call    	exit@FUNCTION, $pop17
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
