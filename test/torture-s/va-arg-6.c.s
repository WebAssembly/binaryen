	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-6.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.store	$push0=, 12($7), $1
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push78=, $pop2, $pop3
	tee_local	$push77=, $1=, $pop78
	i32.const	$push4=, 4
	i32.add 	$push5=, $pop77, $pop4
	i32.store	$discard=, 12($7), $pop5
	block
	block
	block
	block
	block
	block
	block
	block
	block
	i32.load	$push6=, 0($1)
	i32.const	$push7=, 10
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label8
# BB#1:                                 # %if.end
	i32.load	$push9=, 12($7)
	i32.const	$push10=, 7
	i32.add 	$push11=, $pop9, $pop10
	i32.const	$push12=, -8
	i32.and 	$push80=, $pop11, $pop12
	tee_local	$push79=, $1=, $pop80
	i32.const	$push13=, 8
	i32.add 	$push14=, $pop79, $pop13
	i32.store	$discard=, 12($7), $pop14
	i64.load	$push15=, 0($1)
	i64.const	$push16=, 10000000000
	i64.ne  	$push17=, $pop15, $pop16
	br_if   	1, $pop17       # 1: down to label7
# BB#2:                                 # %if.end4
	i32.load	$push18=, 12($7)
	i32.const	$push19=, 3
	i32.add 	$push20=, $pop18, $pop19
	i32.const	$push21=, -4
	i32.and 	$push82=, $pop20, $pop21
	tee_local	$push81=, $1=, $pop82
	i32.const	$push22=, 4
	i32.add 	$push23=, $pop81, $pop22
	i32.store	$discard=, 12($7), $pop23
	i32.load	$push24=, 0($1)
	i32.const	$push25=, 11
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	2, $pop26       # 2: down to label6
# BB#3:                                 # %if.end7
	i32.load	$push27=, 12($7)
	i32.const	$push28=, 15
	i32.add 	$push29=, $pop27, $pop28
	i32.const	$push30=, -16
	i32.and 	$push85=, $pop29, $pop30
	tee_local	$push84=, $3=, $pop85
	i32.const	$push31=, 8
	i32.or  	$push32=, $pop84, $pop31
	i32.store	$1=, 12($7), $pop32
	i64.load	$2=, 0($3)
	i32.const	$push83=, 8
	i32.add 	$push33=, $1, $pop83
	i32.store	$discard=, 12($7), $pop33
	i64.load	$push34=, 0($1)
	i64.const	$push36=, -1475739525896764129
	i64.const	$push35=, 4611846459164112977
	i32.call	$push37=, __eqtf2@FUNCTION, $2, $pop34, $pop36, $pop35
	br_if   	3, $pop37       # 3: down to label5
# BB#4:                                 # %if.end10
	i32.load	$push38=, 12($7)
	i32.const	$push90=, 3
	i32.add 	$push39=, $pop38, $pop90
	i32.const	$push89=, -4
	i32.and 	$push88=, $pop39, $pop89
	tee_local	$push87=, $1=, $pop88
	i32.const	$push86=, 4
	i32.add 	$push40=, $pop87, $pop86
	i32.store	$discard=, 12($7), $pop40
	i32.load	$push41=, 0($1)
	i32.const	$push42=, 12
	i32.ne  	$push43=, $pop41, $pop42
	br_if   	4, $pop43       # 4: down to label4
# BB#5:                                 # %if.end13
	i32.load	$push44=, 12($7)
	i32.const	$push95=, 3
	i32.add 	$push45=, $pop44, $pop95
	i32.const	$push94=, -4
	i32.and 	$push93=, $pop45, $pop94
	tee_local	$push92=, $1=, $pop93
	i32.const	$push91=, 4
	i32.add 	$push46=, $pop92, $pop91
	i32.store	$discard=, 12($7), $pop46
	i32.load	$push47=, 0($1)
	i32.const	$push48=, 13
	i32.ne  	$push49=, $pop47, $pop48
	br_if   	5, $pop49       # 5: down to label3
# BB#6:                                 # %if.end16
	i32.load	$push50=, 12($7)
	i32.const	$push51=, 7
	i32.add 	$push52=, $pop50, $pop51
	i32.const	$push53=, -8
	i32.and 	$push97=, $pop52, $pop53
	tee_local	$push96=, $1=, $pop97
	i32.const	$push54=, 8
	i32.add 	$push55=, $pop96, $pop54
	i32.store	$discard=, 12($7), $pop55
	i64.load	$push56=, 0($1)
	i64.const	$push57=, 20000000000
	i64.ne  	$push58=, $pop56, $pop57
	br_if   	6, $pop58       # 6: down to label2
# BB#7:                                 # %if.end19
	i32.load	$push59=, 12($7)
	i32.const	$push60=, 3
	i32.add 	$push61=, $pop59, $pop60
	i32.const	$push62=, -4
	i32.and 	$push99=, $pop61, $pop62
	tee_local	$push98=, $1=, $pop99
	i32.const	$push63=, 4
	i32.add 	$push64=, $pop98, $pop63
	i32.store	$discard=, 12($7), $pop64
	i32.load	$push65=, 0($1)
	i32.const	$push66=, 14
	i32.ne  	$push67=, $pop65, $pop66
	br_if   	7, $pop67       # 7: down to label1
# BB#8:                                 # %if.end22
	i32.load	$push68=, 12($7)
	i32.const	$push69=, 7
	i32.add 	$push70=, $pop68, $pop69
	i32.const	$push71=, -8
	i32.and 	$push101=, $pop70, $pop71
	tee_local	$push100=, $1=, $pop101
	i32.const	$push72=, 8
	i32.add 	$push73=, $pop100, $pop72
	i32.store	$discard=, 12($7), $pop73
	f64.load	$push74=, 0($1)
	f64.const	$push75=, 0x1.5c28f5c28f5c3p1
	f64.ne  	$push76=, $pop74, $pop75
	br_if   	8, $pop76       # 8: down to label0
# BB#9:                                 # %if.end25
	i32.const	$6=, 16
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return  	$1
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
	.size	f, .Lfunc_end0-f

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
	i64.const	$push2=, 4613307314293241283
	i64.store	$discard=, 0($pop1):p2align=4, $pop2
	i32.const	$push3=, 56
	i32.add 	$push4=, $3, $pop3
	i32.const	$push5=, 14
	i32.store	$discard=, 0($pop4):p2align=3, $pop5
	i32.const	$push6=, 48
	i32.add 	$push7=, $3, $pop6
	i64.const	$push8=, 20000000000
	i64.store	$discard=, 0($pop7):p2align=4, $pop8
	i32.const	$push9=, 44
	i32.add 	$push10=, $3, $pop9
	i32.const	$push11=, 13
	i32.store	$discard=, 0($pop10), $pop11
	i32.const	$push12=, 40
	i32.add 	$push13=, $3, $pop12
	i32.const	$push14=, 12
	i32.store	$discard=, 0($pop13):p2align=3, $pop14
	i32.const	$push15=, 32
	i32.add 	$push16=, $3, $pop15
	i64.const	$push17=, 4611846459164112977
	i64.store	$discard=, 0($pop16):p2align=4, $pop17
	i32.const	$push18=, 24
	i32.add 	$push19=, $3, $pop18
	i64.const	$push20=, -1475739525896764129
	i64.store	$discard=, 0($pop19), $pop20
	i32.const	$push21=, 16
	i32.add 	$push22=, $3, $pop21
	i32.const	$push23=, 11
	i32.store	$discard=, 0($pop22):p2align=4, $pop23
	i32.const	$push24=, 8
	i32.or  	$push25=, $3, $pop24
	i64.const	$push26=, 10000000000
	i64.store	$discard=, 0($pop25), $pop26
	i32.const	$push27=, 10
	i32.store	$discard=, 0($3):p2align=4, $pop27
	i32.call	$discard=, f@FUNCTION, $0, $3
	i32.const	$push28=, 0
	call    	exit@FUNCTION, $pop28
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
