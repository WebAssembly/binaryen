	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991216-2.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, __stack_pointer
	i32.const	$push17=, __stack_pointer
	i32.load	$push18=, 0($pop17)
	i32.const	$push19=, 16
	i32.sub 	$push24=, $pop18, $pop19
	i32.store	$push26=, 0($pop20), $pop24
	tee_local	$push25=, $4=, $pop26
	i32.store	$discard=, 12($pop25), $1
	block
	block
	block
	i32.const	$push0=, 2
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$3=, 1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	copy_local	$push32=, $1
	tee_local	$push31=, $5=, $pop32
	i32.const	$push30=, 4
	i32.add 	$push29=, $pop31, $pop30
	tee_local	$push28=, $1=, $pop29
	i32.store	$discard=, 12($4), $pop28
	i32.const	$push27=, 1
	i32.add 	$3=, $3, $pop27
	i32.load	$push2=, 0($5)
	i32.ne  	$push3=, $3, $pop2
	br_if   	3, $pop3        # 3: down to label1
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.lt_s	$push4=, $3, $0
	br_if   	0, $pop4        # 0: up to label3
.LBB0_4:                                # %for.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.const	$push5=, 7
	i32.add 	$push6=, $1, $pop5
	i32.const	$push7=, -8
	i32.and 	$push34=, $pop6, $pop7
	tee_local	$push33=, $3=, $pop34
	i64.load	$2=, 0($pop33)
	i32.const	$push8=, 8
	i32.add 	$push9=, $3, $pop8
	i32.store	$1=, 12($4), $pop9
	i64.const	$push10=, 81985529216486895
	i64.ne  	$push11=, $2, $pop10
	br_if   	1, $pop11       # 1: down to label0
# BB#5:                                 # %if.end7
	i32.const	$push12=, 12
	i32.add 	$push13=, $3, $pop12
	i32.store	$discard=, 12($4), $pop13
	i32.load	$push14=, 0($1)
	i32.const	$push15=, 85
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	1, $pop16       # 1: down to label0
# BB#6:                                 # %if.end12
	i32.const	$push23=, __stack_pointer
	i32.const	$push21=, 16
	i32.add 	$push22=, $4, $pop21
	i32.store	$discard=, 0($pop23), $pop22
	return
.LBB0_7:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
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
	.local  	i32, i64, i64, i32, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push38=, __stack_pointer
	i32.const	$push35=, __stack_pointer
	i32.load	$push36=, 0($pop35)
	i32.const	$push37=, 288
	i32.sub 	$push77=, $pop36, $pop37
	i32.store	$push91=, 0($pop38), $pop77
	tee_local	$push90=, $6=, $pop91
	i32.const	$push1=, 85
	i32.store	$0=, 280($pop90), $pop1
	i64.const	$push2=, 81985529216486895
	i64.store	$1=, 272($6), $pop2
	i32.const	$push3=, 1
	i32.const	$push39=, 272
	i32.add 	$push40=, $6, $pop39
	call    	test@FUNCTION, $pop3, $pop40
	i32.const	$push41=, 240
	i32.add 	$push42=, $6, $pop41
	i32.const	$push4=, 16
	i32.add 	$push5=, $pop42, $pop4
	i32.store	$discard=, 0($pop5), $0
	i64.store	$discard=, 248($6), $1
	i32.const	$push6=, 2
	i32.store	$push0=, 240($6), $pop6
	i32.const	$push43=, 240
	i32.add 	$push44=, $6, $pop43
	call    	test@FUNCTION, $pop0, $pop44
	i32.const	$push45=, 208
	i32.add 	$push46=, $6, $pop45
	i32.const	$push89=, 16
	i32.add 	$push7=, $pop46, $pop89
	i32.store	$discard=, 0($pop7), $0
	i64.store	$discard=, 216($6), $1
	i64.const	$push8=, 12884901890
	i64.store	$2=, 208($6), $pop8
	i32.const	$push9=, 3
	i32.const	$push47=, 208
	i32.add 	$push48=, $6, $pop47
	call    	test@FUNCTION, $pop9, $pop48
	i32.const	$push49=, 176
	i32.add 	$push50=, $6, $pop49
	i32.const	$push10=, 24
	i32.add 	$push11=, $pop50, $pop10
	i32.store	$discard=, 0($pop11), $0
	i32.const	$push51=, 176
	i32.add 	$push52=, $6, $pop51
	i32.const	$push88=, 16
	i32.add 	$push12=, $pop52, $pop88
	i64.store	$discard=, 0($pop12), $1
	i32.const	$push13=, 4
	i32.store	$3=, 184($6), $pop13
	i64.store	$discard=, 176($6), $2
	i32.const	$push53=, 176
	i32.add 	$push54=, $6, $pop53
	call    	test@FUNCTION, $3, $pop54
	i32.const	$push55=, 144
	i32.add 	$push56=, $6, $pop55
	i32.const	$push87=, 24
	i32.add 	$push14=, $pop56, $pop87
	i32.store	$discard=, 0($pop14), $0
	i32.const	$push57=, 144
	i32.add 	$push58=, $6, $pop57
	i32.const	$push86=, 16
	i32.add 	$push15=, $pop58, $pop86
	i64.store	$discard=, 0($pop15), $1
	i64.const	$push16=, 21474836484
	i64.store	$4=, 152($6), $pop16
	i64.store	$discard=, 144($6), $2
	i32.const	$push17=, 5
	i32.const	$push59=, 144
	i32.add 	$push60=, $6, $pop59
	call    	test@FUNCTION, $pop17, $pop60
	i32.const	$push61=, 96
	i32.add 	$push62=, $6, $pop61
	i32.const	$push18=, 32
	i32.add 	$push19=, $pop62, $pop18
	i32.store	$discard=, 0($pop19), $0
	i32.const	$push63=, 96
	i32.add 	$push64=, $6, $pop63
	i32.const	$push85=, 24
	i32.add 	$push20=, $pop64, $pop85
	i64.store	$discard=, 0($pop20), $1
	i32.const	$push65=, 96
	i32.add 	$push66=, $6, $pop65
	i32.const	$push84=, 16
	i32.add 	$push21=, $pop66, $pop84
	i32.const	$push22=, 6
	i32.store	$3=, 0($pop21), $pop22
	i64.store	$discard=, 104($6), $4
	i64.store	$discard=, 96($6), $2
	i32.const	$push67=, 96
	i32.add 	$push68=, $6, $pop67
	call    	test@FUNCTION, $3, $pop68
	i32.const	$push69=, 48
	i32.add 	$push70=, $6, $pop69
	i32.const	$push83=, 32
	i32.add 	$push23=, $pop70, $pop83
	i32.store	$discard=, 0($pop23), $0
	i32.const	$push71=, 48
	i32.add 	$push72=, $6, $pop71
	i32.const	$push82=, 24
	i32.add 	$push24=, $pop72, $pop82
	i64.store	$discard=, 0($pop24), $1
	i32.const	$push73=, 48
	i32.add 	$push74=, $6, $pop73
	i32.const	$push81=, 16
	i32.add 	$push25=, $pop74, $pop81
	i64.const	$push26=, 30064771078
	i64.store	$5=, 0($pop25), $pop26
	i64.store	$discard=, 56($6), $4
	i64.store	$discard=, 48($6), $2
	i32.const	$push27=, 7
	i32.const	$push75=, 48
	i32.add 	$push76=, $6, $pop75
	call    	test@FUNCTION, $pop27, $pop76
	i32.const	$push28=, 40
	i32.add 	$push29=, $6, $pop28
	i32.store	$discard=, 0($pop29), $0
	i32.const	$push80=, 32
	i32.add 	$push30=, $6, $pop80
	i64.store	$discard=, 0($pop30), $1
	i32.const	$push79=, 24
	i32.add 	$push31=, $6, $pop79
	i32.const	$push32=, 8
	i32.store	$0=, 0($pop31), $pop32
	i32.const	$push78=, 16
	i32.add 	$push33=, $6, $pop78
	i64.store	$discard=, 0($pop33), $5
	i64.store	$discard=, 8($6), $4
	i64.store	$discard=, 0($6), $2
	call    	test@FUNCTION, $0, $6
	i32.const	$push34=, 0
	call    	exit@FUNCTION, $pop34
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
