	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-17.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 12($5), $1
	i32.const	$push61=, 7
	i32.add 	$push1=, $pop0, $pop61
	i32.const	$push60=, -8
	i32.and 	$push59=, $pop1, $pop60
	tee_local	$push58=, $1=, $pop59
	i32.const	$push57=, 8
	i32.add 	$push2=, $pop58, $pop57
	i32.store	$discard=, 12($5), $pop2
	block
	block
	block
	block
	block
	block
	block
	block
	block
	f64.load	$push3=, 0($1)
	f64.const	$push4=, 0x1p0
	f64.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label8
# BB#1:                                 # %if.end
	i32.load	$push6=, 12($5)
	i32.const	$push66=, 7
	i32.add 	$push7=, $pop6, $pop66
	i32.const	$push65=, -8
	i32.and 	$push64=, $pop7, $pop65
	tee_local	$push63=, $1=, $pop64
	i32.const	$push62=, 8
	i32.add 	$push8=, $pop63, $pop62
	i32.store	$discard=, 12($5), $pop8
	f64.load	$push9=, 0($1)
	f64.const	$push10=, 0x1p1
	f64.ne  	$push11=, $pop9, $pop10
	br_if   	1, $pop11       # 1: down to label7
# BB#2:                                 # %if.end4
	i32.load	$push12=, 12($5)
	i32.const	$push71=, 7
	i32.add 	$push13=, $pop12, $pop71
	i32.const	$push70=, -8
	i32.and 	$push69=, $pop13, $pop70
	tee_local	$push68=, $1=, $pop69
	i32.const	$push67=, 8
	i32.add 	$push14=, $pop68, $pop67
	i32.store	$discard=, 12($5), $pop14
	f64.load	$push15=, 0($1)
	f64.const	$push16=, 0x1.8p1
	f64.ne  	$push17=, $pop15, $pop16
	br_if   	2, $pop17       # 2: down to label6
# BB#3:                                 # %if.end7
	i32.load	$push18=, 12($5)
	i32.const	$push76=, 7
	i32.add 	$push19=, $pop18, $pop76
	i32.const	$push75=, -8
	i32.and 	$push74=, $pop19, $pop75
	tee_local	$push73=, $1=, $pop74
	i32.const	$push72=, 8
	i32.add 	$push20=, $pop73, $pop72
	i32.store	$discard=, 12($5), $pop20
	f64.load	$push21=, 0($1)
	f64.const	$push22=, 0x1p2
	f64.ne  	$push23=, $pop21, $pop22
	br_if   	3, $pop23       # 3: down to label5
# BB#4:                                 # %if.end10
	i32.load	$push24=, 12($5)
	i32.const	$push81=, 7
	i32.add 	$push25=, $pop24, $pop81
	i32.const	$push80=, -8
	i32.and 	$push79=, $pop25, $pop80
	tee_local	$push78=, $1=, $pop79
	i32.const	$push77=, 8
	i32.add 	$push26=, $pop78, $pop77
	i32.store	$discard=, 12($5), $pop26
	f64.load	$push27=, 0($1)
	f64.const	$push28=, 0x1.4p2
	f64.ne  	$push29=, $pop27, $pop28
	br_if   	4, $pop29       # 4: down to label4
# BB#5:                                 # %if.end13
	i32.load	$push30=, 12($5)
	i32.const	$push86=, 7
	i32.add 	$push31=, $pop30, $pop86
	i32.const	$push85=, -8
	i32.and 	$push84=, $pop31, $pop85
	tee_local	$push83=, $1=, $pop84
	i32.const	$push82=, 8
	i32.add 	$push32=, $pop83, $pop82
	i32.store	$discard=, 12($5), $pop32
	f64.load	$push33=, 0($1)
	f64.const	$push34=, 0x1.8p2
	f64.ne  	$push35=, $pop33, $pop34
	br_if   	5, $pop35       # 5: down to label3
# BB#6:                                 # %if.end16
	i32.load	$push36=, 12($5)
	i32.const	$push91=, 7
	i32.add 	$push37=, $pop36, $pop91
	i32.const	$push90=, -8
	i32.and 	$push89=, $pop37, $pop90
	tee_local	$push88=, $1=, $pop89
	i32.const	$push87=, 8
	i32.add 	$push38=, $pop88, $pop87
	i32.store	$discard=, 12($5), $pop38
	f64.load	$push39=, 0($1)
	f64.const	$push40=, 0x1.cp2
	f64.ne  	$push41=, $pop39, $pop40
	br_if   	6, $pop41       # 6: down to label2
# BB#7:                                 # %if.end19
	i32.load	$push42=, 12($5)
	i32.const	$push96=, 7
	i32.add 	$push43=, $pop42, $pop96
	i32.const	$push95=, -8
	i32.and 	$push94=, $pop43, $pop95
	tee_local	$push93=, $1=, $pop94
	i32.const	$push92=, 8
	i32.add 	$push44=, $pop93, $pop92
	i32.store	$discard=, 12($5), $pop44
	f64.load	$push45=, 0($1)
	f64.const	$push46=, 0x1p3
	f64.ne  	$push47=, $pop45, $pop46
	br_if   	7, $pop47       # 7: down to label1
# BB#8:                                 # %if.end22
	i32.load	$push48=, 12($5)
	i32.const	$push49=, 7
	i32.add 	$push50=, $pop48, $pop49
	i32.const	$push51=, -8
	i32.and 	$push98=, $pop50, $pop51
	tee_local	$push97=, $1=, $pop98
	i32.const	$push52=, 8
	i32.add 	$push53=, $pop97, $pop52
	i32.store	$discard=, 12($5), $pop53
	f64.load	$push54=, 0($1)
	f64.const	$push55=, 0x1.2p3
	f64.ne  	$push56=, $pop54, $pop55
	br_if   	8, $pop56       # 8: down to label0
# BB#9:                                 # %if.end25
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB0_10:                               # %if.then
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %if.then3
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %if.then6
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.then9
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %if.then12
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then15
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then18
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then21
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %if.then24
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 80
	i32.sub 	$3=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	i32.const	$push0=, 64
	i32.add 	$push1=, $3, $pop0
	i64.const	$push2=, 4621256167635550208
	i64.store	$discard=, 0($pop1):p2align=4, $pop2
	i32.const	$push3=, 56
	i32.add 	$push4=, $3, $pop3
	i64.const	$push5=, 4620693217682128896
	i64.store	$discard=, 0($pop4), $pop5
	i32.const	$push6=, 48
	i32.add 	$push7=, $3, $pop6
	i64.const	$push8=, 4619567317775286272
	i64.store	$discard=, 0($pop7):p2align=4, $pop8
	i32.const	$push9=, 40
	i32.add 	$push10=, $3, $pop9
	i64.const	$push11=, 4618441417868443648
	i64.store	$discard=, 0($pop10), $pop11
	i32.const	$push12=, 32
	i32.add 	$push13=, $3, $pop12
	i64.const	$push14=, 4617315517961601024
	i64.store	$discard=, 0($pop13):p2align=4, $pop14
	i32.const	$push15=, 24
	i32.add 	$push16=, $3, $pop15
	i64.const	$push17=, 4616189618054758400
	i64.store	$discard=, 0($pop16), $pop17
	i32.const	$push18=, 16
	i32.add 	$push19=, $3, $pop18
	i64.const	$push20=, 4613937818241073152
	i64.store	$discard=, 0($pop19):p2align=4, $pop20
	i32.const	$push21=, 8
	i32.or  	$push22=, $3, $pop21
	i64.const	$push23=, 4611686018427387904
	i64.store	$discard=, 0($pop22), $pop23
	i64.const	$push24=, 4607182418800017408
	i64.store	$discard=, 0($3):p2align=4, $pop24
	call    	vafunction@FUNCTION, $0, $3
	i32.const	$push25=, 0
	call    	exit@FUNCTION, $pop25
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
