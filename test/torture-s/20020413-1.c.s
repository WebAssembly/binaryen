	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020413-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i64, i64, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push83=, 0
	i32.const	$push80=, 0
	i32.load	$push81=, __stack_pointer($pop80)
	i32.const	$push82=, 16
	i32.sub 	$push101=, $pop81, $pop82
	tee_local	$push100=, $5=, $pop101
	i32.store	__stack_pointer($pop83), $pop100
	i64.const	$push99=, 0
	i64.const	$push0=, -9223372036854775808
	call    	__subtf3@FUNCTION, $5, $pop99, $pop0, $0, $1
	i64.const	$push98=, 0
	i64.const	$push97=, 0
	i32.call	$3=, __lttf2@FUNCTION, $0, $1, $pop98, $pop97
	i32.const	$4=, 0
	block   	
	block   	
	block   	
	i64.load	$push4=, 0($5)
	i32.const	$push96=, 0
	i32.lt_s	$push95=, $3, $pop96
	tee_local	$push94=, $3=, $pop95
	i64.select	$push93=, $pop4, $0, $pop94
	tee_local	$push92=, $0=, $pop93
	i32.const	$push1=, 8
	i32.add 	$push2=, $5, $pop1
	i64.load	$push3=, 0($pop2)
	i64.select	$push91=, $pop3, $1, $3
	tee_local	$push90=, $1=, $pop91
	i64.const	$push89=, 0
	i64.const	$push88=, 4611404543450677248
	i32.call	$push5=, __getf2@FUNCTION, $pop92, $pop90, $pop89, $pop88
	i32.const	$push87=, 0
	i32.ge_s	$push6=, $pop5, $pop87
	br_if   	0, $pop6        # 0: down to label2
# BB#1:                                 # %if.else
	i64.const	$push103=, 0
	i64.const	$push102=, 0
	i32.call	$push42=, __eqtf2@FUNCTION, $0, $1, $pop103, $pop102
	i32.eqz 	$push142=, $pop42
	br_if   	1, $pop142      # 1: down to label1
# BB#2:                                 # %if.else
	i64.const	$push104=, 0
	i64.const	$push43=, 4611404543450677248
	i32.call	$push44=, __lttf2@FUNCTION, $0, $1, $pop104, $pop43
	i32.const	$push45=, -1
	i32.gt_s	$push46=, $pop44, $pop45
	br_if   	1, $pop46       # 1: down to label1
# BB#3:                                 # %while.body12
	i32.const	$4=, 1
	i64.const	$push105=, 0
	i64.const	$push47=, 4611123068473966592
	i32.call	$push48=, __lttf2@FUNCTION, $0, $1, $pop105, $pop47
	i32.const	$push49=, 0
	i32.ge_s	$push50=, $pop48, $pop49
	br_if   	1, $pop50       # 1: down to label1
# BB#4:                                 # %while.body12.1
	i32.const	$4=, 2
	i64.const	$push107=, 0
	i64.const	$push51=, 4610841593497255936
	i32.call	$push52=, __lttf2@FUNCTION, $0, $1, $pop107, $pop51
	i32.const	$push106=, -1
	i32.gt_s	$push53=, $pop52, $pop106
	br_if   	1, $pop53       # 1: down to label1
# BB#5:                                 # %while.body12.2
	i32.const	$4=, 3
	i64.const	$push109=, 0
	i64.const	$push54=, 4610560118520545280
	i32.call	$push55=, __lttf2@FUNCTION, $0, $1, $pop109, $pop54
	i32.const	$push108=, -1
	i32.gt_s	$push56=, $pop55, $pop108
	br_if   	1, $pop56       # 1: down to label1
# BB#6:                                 # %while.body12.3
	i32.const	$4=, 4
	i64.const	$push111=, 0
	i64.const	$push57=, 4610278643543834624
	i32.call	$push58=, __lttf2@FUNCTION, $0, $1, $pop111, $pop57
	i32.const	$push110=, -1
	i32.gt_s	$push59=, $pop58, $pop110
	br_if   	1, $pop59       # 1: down to label1
# BB#7:                                 # %while.body12.4
	i32.const	$4=, 5
	i64.const	$push113=, 0
	i64.const	$push60=, 4609997168567123968
	i32.call	$push61=, __lttf2@FUNCTION, $0, $1, $pop113, $pop60
	i32.const	$push112=, -1
	i32.gt_s	$push62=, $pop61, $pop112
	br_if   	1, $pop62       # 1: down to label1
# BB#8:                                 # %while.body12.5
	i32.const	$4=, 6
	i64.const	$push115=, 0
	i64.const	$push63=, 4609715693590413312
	i32.call	$push64=, __lttf2@FUNCTION, $0, $1, $pop115, $pop63
	i32.const	$push114=, -1
	i32.gt_s	$push65=, $pop64, $pop114
	br_if   	1, $pop65       # 1: down to label1
# BB#9:                                 # %while.body12.6
	i32.const	$4=, 7
	i64.const	$push117=, 0
	i64.const	$push66=, 4609434218613702656
	i32.call	$push67=, __lttf2@FUNCTION, $0, $1, $pop117, $pop66
	i32.const	$push116=, -1
	i32.gt_s	$push68=, $pop67, $pop116
	br_if   	1, $pop68       # 1: down to label1
# BB#10:                                # %while.body12.7
	i32.const	$4=, 8
	i64.const	$push119=, 0
	i64.const	$push69=, 4609152743636992000
	i32.call	$push70=, __lttf2@FUNCTION, $0, $1, $pop119, $pop69
	i32.const	$push118=, -1
	i32.gt_s	$push71=, $pop70, $pop118
	br_if   	1, $pop71       # 1: down to label1
# BB#11:                                # %while.body12.8
	i32.const	$4=, 9
	i64.const	$push121=, 0
	i64.const	$push72=, 4608871268660281344
	i32.call	$push73=, __lttf2@FUNCTION, $0, $1, $pop121, $pop72
	i32.const	$push120=, -1
	i32.gt_s	$push74=, $pop73, $pop120
	br_if   	1, $pop74       # 1: down to label1
# BB#12:                                # %while.body12.9
	i32.const	$4=, 10
	i64.const	$push76=, 0
	i64.const	$push75=, 4608589793683570688
	i32.call	$push77=, __lttf2@FUNCTION, $0, $1, $pop76, $pop75
	i32.const	$push78=, -1
	i32.gt_s	$push79=, $pop77, $pop78
	br_if   	1, $pop79       # 1: down to label1
# BB#13:                                # %while.body12.10
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %while.cond.preheader
	end_block                       # label2:
	i64.const	$push123=, 0
	i64.const	$push122=, 4611404543450677248
	i32.call	$push7=, __gttf2@FUNCTION, $0, $1, $pop123, $pop122
	i32.const	$push8=, 1
	i32.lt_s	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#15:                                # %while.body
	i32.const	$4=, 1
	i64.const	$push124=, 0
	i64.const	$push10=, 4611686018427387904
	i32.call	$push11=, __gttf2@FUNCTION, $0, $1, $pop124, $pop10
	i32.const	$push12=, 0
	i32.le_s	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label1
# BB#16:                                # %while.body.1
	i32.const	$4=, 2
	i64.const	$push126=, 0
	i64.const	$push14=, 4611967493404098560
	i32.call	$push15=, __gttf2@FUNCTION, $0, $1, $pop126, $pop14
	i32.const	$push125=, 1
	i32.lt_s	$push16=, $pop15, $pop125
	br_if   	0, $pop16       # 0: down to label1
# BB#17:                                # %while.body.2
	i32.const	$4=, 3
	i64.const	$push128=, 0
	i64.const	$push17=, 4612248968380809216
	i32.call	$push18=, __gttf2@FUNCTION, $0, $1, $pop128, $pop17
	i32.const	$push127=, 1
	i32.lt_s	$push19=, $pop18, $pop127
	br_if   	0, $pop19       # 0: down to label1
# BB#18:                                # %while.body.3
	i32.const	$4=, 4
	i64.const	$push130=, 0
	i64.const	$push20=, 4612530443357519872
	i32.call	$push21=, __gttf2@FUNCTION, $0, $1, $pop130, $pop20
	i32.const	$push129=, 1
	i32.lt_s	$push22=, $pop21, $pop129
	br_if   	0, $pop22       # 0: down to label1
# BB#19:                                # %while.body.4
	i32.const	$4=, 5
	i64.const	$push132=, 0
	i64.const	$push23=, 4612811918334230528
	i32.call	$push24=, __gttf2@FUNCTION, $0, $1, $pop132, $pop23
	i32.const	$push131=, 1
	i32.lt_s	$push25=, $pop24, $pop131
	br_if   	0, $pop25       # 0: down to label1
# BB#20:                                # %while.body.5
	i32.const	$4=, 6
	i64.const	$push134=, 0
	i64.const	$push26=, 4613093393310941184
	i32.call	$push27=, __gttf2@FUNCTION, $0, $1, $pop134, $pop26
	i32.const	$push133=, 1
	i32.lt_s	$push28=, $pop27, $pop133
	br_if   	0, $pop28       # 0: down to label1
# BB#21:                                # %while.body.6
	i32.const	$4=, 7
	i64.const	$push136=, 0
	i64.const	$push29=, 4613374868287651840
	i32.call	$push30=, __gttf2@FUNCTION, $0, $1, $pop136, $pop29
	i32.const	$push135=, 1
	i32.lt_s	$push31=, $pop30, $pop135
	br_if   	0, $pop31       # 0: down to label1
# BB#22:                                # %while.body.7
	i32.const	$4=, 8
	i64.const	$push138=, 0
	i64.const	$push32=, 4613656343264362496
	i32.call	$push33=, __gttf2@FUNCTION, $0, $1, $pop138, $pop32
	i32.const	$push137=, 1
	i32.lt_s	$push34=, $pop33, $pop137
	br_if   	0, $pop34       # 0: down to label1
# BB#23:                                # %while.body.8
	i32.const	$4=, 9
	i64.const	$push140=, 0
	i64.const	$push35=, 4613937818241073152
	i32.call	$push36=, __gttf2@FUNCTION, $0, $1, $pop140, $pop35
	i32.const	$push139=, 1
	i32.lt_s	$push37=, $pop36, $pop139
	br_if   	0, $pop37       # 0: down to label1
# BB#24:                                # %while.body.9
	i32.const	$4=, 10
	i64.const	$push141=, 0
	i64.const	$push38=, 4614219293217783808
	i32.call	$push39=, __gttf2@FUNCTION, $0, $1, $pop141, $pop38
	i32.const	$push40=, 1
	i32.ge_s	$push41=, $pop39, $pop40
	br_if   	1, $pop41       # 1: down to label0
.LBB0_25:                               # %if.end19
	end_block                       # label1:
	i32.store	0($2), $4
	i32.const	$push86=, 0
	i32.const	$push84=, 16
	i32.add 	$push85=, $5, $pop84
	i32.store	__stack_pointer($pop86), $pop85
	return
.LBB0_26:                               # %while.body.10
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push22=, $pop7, $pop8
	tee_local	$push21=, $0=, $pop22
	i32.store	__stack_pointer($pop9), $pop21
	i64.const	$push1=, 0
	i64.const	$push0=, 4611826755915743232
	i32.const	$push10=, 12
	i32.add 	$push11=, $0, $pop10
	call    	test@FUNCTION, $pop1, $pop0, $pop11
	i64.const	$push20=, 0
	i64.const	$push2=, 4611897124659920896
	i32.const	$push12=, 12
	i32.add 	$push13=, $0, $pop12
	call    	test@FUNCTION, $pop20, $pop2, $pop13
	i64.const	$push19=, 0
	i64.const	$push3=, 4611967493404098560
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	call    	test@FUNCTION, $pop19, $pop3, $pop15
	i64.const	$push18=, 0
	i64.const	$push4=, 4612037862148276224
	i32.const	$push16=, 12
	i32.add 	$push17=, $0, $pop16
	call    	test@FUNCTION, $pop18, $pop4, $pop17
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
