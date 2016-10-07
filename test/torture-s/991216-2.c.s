	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991216-2.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 16
	i32.sub 	$push25=, $pop18, $pop19
	tee_local	$push24=, $4=, $pop25
	i32.store	__stack_pointer($pop20), $pop24
	i32.store	12($4), $1
	block   	
	block   	
	block   	
	i32.const	$push0=, 2
	i32.ge_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# BB#1:
	copy_local	$3=, $1
	br      	1               # 1: down to label1
.LBB0_2:                                # %for.body.preheader
	end_block                       # label2:
	i32.const	$2=, 1
.LBB0_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push31=, 4
	i32.add 	$push30=, $1, $pop31
	tee_local	$push29=, $3=, $pop30
	i32.store	12($4), $pop29
	i32.const	$push28=, 1
	i32.add 	$push27=, $2, $pop28
	tee_local	$push26=, $2=, $pop27
	i32.load	$push2=, 0($1)
	i32.ne  	$push3=, $pop26, $pop2
	br_if   	2, $pop3        # 2: down to label0
# BB#4:                                 # %for.cond
                                        #   in Loop: Header=BB0_3 Depth=1
	copy_local	$1=, $3
	i32.lt_s	$push4=, $2, $0
	br_if   	0, $pop4        # 0: up to label3
.LBB0_5:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.const	$push5=, 7
	i32.add 	$push6=, $3, $pop5
	i32.const	$push7=, -8
	i32.and 	$push35=, $pop6, $pop7
	tee_local	$push34=, $1=, $pop35
	i32.const	$push8=, 8
	i32.add 	$push33=, $pop34, $pop8
	tee_local	$push32=, $2=, $pop33
	i32.store	12($4), $pop32
	i64.load	$push9=, 0($1)
	i64.const	$push10=, 81985529216486895
	i64.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#6:                                 # %if.end7
	i32.const	$push12=, 12
	i32.add 	$push13=, $1, $pop12
	i32.store	12($4), $pop13
	i32.load	$push14=, 0($2)
	i32.const	$push15=, 85
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#7:                                 # %if.end12
	i32.const	$push23=, 0
	i32.const	$push21=, 16
	i32.add 	$push22=, $4, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	return
.LBB0_8:                                # %if.then11
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
	i32.const	$push37=, 0
	i32.const	$push34=, 0
	i32.load	$push35=, __stack_pointer($pop34)
	i32.const	$push36=, 288
	i32.sub 	$push116=, $pop35, $pop36
	tee_local	$push115=, $0=, $pop116
	i32.store	__stack_pointer($pop37), $pop115
	i32.const	$push0=, 85
	i32.store	280($0), $pop0
	i64.const	$push1=, 81985529216486895
	i64.store	272($0), $pop1
	i32.const	$push2=, 1
	i32.const	$push38=, 272
	i32.add 	$push39=, $0, $pop38
	call    	test@FUNCTION, $pop2, $pop39
	i32.const	$push40=, 240
	i32.add 	$push41=, $0, $pop40
	i32.const	$push3=, 16
	i32.add 	$push4=, $pop41, $pop3
	i32.const	$push114=, 85
	i32.store	0($pop4), $pop114
	i64.const	$push113=, 81985529216486895
	i64.store	248($0), $pop113
	i32.const	$push5=, 2
	i32.store	240($0), $pop5
	i32.const	$push112=, 2
	i32.const	$push42=, 240
	i32.add 	$push43=, $0, $pop42
	call    	test@FUNCTION, $pop112, $pop43
	i32.const	$push44=, 208
	i32.add 	$push45=, $0, $pop44
	i32.const	$push111=, 16
	i32.add 	$push6=, $pop45, $pop111
	i32.const	$push110=, 85
	i32.store	0($pop6), $pop110
	i64.const	$push109=, 81985529216486895
	i64.store	216($0), $pop109
	i64.const	$push7=, 12884901890
	i64.store	208($0), $pop7
	i32.const	$push8=, 3
	i32.const	$push46=, 208
	i32.add 	$push47=, $0, $pop46
	call    	test@FUNCTION, $pop8, $pop47
	i32.const	$push48=, 176
	i32.add 	$push49=, $0, $pop48
	i32.const	$push9=, 24
	i32.add 	$push10=, $pop49, $pop9
	i32.const	$push108=, 85
	i32.store	0($pop10), $pop108
	i32.const	$push50=, 176
	i32.add 	$push51=, $0, $pop50
	i32.const	$push107=, 16
	i32.add 	$push11=, $pop51, $pop107
	i64.const	$push106=, 81985529216486895
	i64.store	0($pop11), $pop106
	i32.const	$push12=, 4
	i32.store	184($0), $pop12
	i64.const	$push105=, 12884901890
	i64.store	176($0), $pop105
	i32.const	$push104=, 4
	i32.const	$push52=, 176
	i32.add 	$push53=, $0, $pop52
	call    	test@FUNCTION, $pop104, $pop53
	i32.const	$push54=, 144
	i32.add 	$push55=, $0, $pop54
	i32.const	$push103=, 24
	i32.add 	$push13=, $pop55, $pop103
	i32.const	$push102=, 85
	i32.store	0($pop13), $pop102
	i32.const	$push56=, 144
	i32.add 	$push57=, $0, $pop56
	i32.const	$push101=, 16
	i32.add 	$push14=, $pop57, $pop101
	i64.const	$push100=, 81985529216486895
	i64.store	0($pop14), $pop100
	i64.const	$push15=, 21474836484
	i64.store	152($0), $pop15
	i64.const	$push99=, 12884901890
	i64.store	144($0), $pop99
	i32.const	$push16=, 5
	i32.const	$push58=, 144
	i32.add 	$push59=, $0, $pop58
	call    	test@FUNCTION, $pop16, $pop59
	i32.const	$push60=, 96
	i32.add 	$push61=, $0, $pop60
	i32.const	$push17=, 32
	i32.add 	$push18=, $pop61, $pop17
	i32.const	$push98=, 85
	i32.store	0($pop18), $pop98
	i32.const	$push62=, 96
	i32.add 	$push63=, $0, $pop62
	i32.const	$push97=, 24
	i32.add 	$push19=, $pop63, $pop97
	i64.const	$push96=, 81985529216486895
	i64.store	0($pop19), $pop96
	i32.const	$push64=, 96
	i32.add 	$push65=, $0, $pop64
	i32.const	$push95=, 16
	i32.add 	$push20=, $pop65, $pop95
	i32.const	$push21=, 6
	i32.store	0($pop20), $pop21
	i64.const	$push94=, 21474836484
	i64.store	104($0), $pop94
	i64.const	$push93=, 12884901890
	i64.store	96($0), $pop93
	i32.const	$push92=, 6
	i32.const	$push66=, 96
	i32.add 	$push67=, $0, $pop66
	call    	test@FUNCTION, $pop92, $pop67
	i32.const	$push68=, 48
	i32.add 	$push69=, $0, $pop68
	i32.const	$push91=, 32
	i32.add 	$push22=, $pop69, $pop91
	i32.const	$push90=, 85
	i32.store	0($pop22), $pop90
	i32.const	$push70=, 48
	i32.add 	$push71=, $0, $pop70
	i32.const	$push89=, 24
	i32.add 	$push23=, $pop71, $pop89
	i64.const	$push88=, 81985529216486895
	i64.store	0($pop23), $pop88
	i32.const	$push72=, 48
	i32.add 	$push73=, $0, $pop72
	i32.const	$push87=, 16
	i32.add 	$push24=, $pop73, $pop87
	i64.const	$push25=, 30064771078
	i64.store	0($pop24), $pop25
	i64.const	$push86=, 21474836484
	i64.store	56($0), $pop86
	i64.const	$push85=, 12884901890
	i64.store	48($0), $pop85
	i32.const	$push26=, 7
	i32.const	$push74=, 48
	i32.add 	$push75=, $0, $pop74
	call    	test@FUNCTION, $pop26, $pop75
	i32.const	$push27=, 40
	i32.add 	$push28=, $0, $pop27
	i32.const	$push84=, 85
	i32.store	0($pop28), $pop84
	i32.const	$push83=, 32
	i32.add 	$push29=, $0, $pop83
	i64.const	$push82=, 81985529216486895
	i64.store	0($pop29), $pop82
	i32.const	$push81=, 24
	i32.add 	$push30=, $0, $pop81
	i32.const	$push31=, 8
	i32.store	0($pop30), $pop31
	i32.const	$push80=, 16
	i32.add 	$push32=, $0, $pop80
	i64.const	$push79=, 30064771078
	i64.store	0($pop32), $pop79
	i64.const	$push78=, 21474836484
	i64.store	8($0), $pop78
	i64.const	$push77=, 12884901890
	i64.store	0($0), $pop77
	i32.const	$push76=, 8
	call    	test@FUNCTION, $pop76, $0
	i32.const	$push33=, 0
	call    	exit@FUNCTION, $pop33
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
