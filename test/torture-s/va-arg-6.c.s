	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-6.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$push0=, 12($6), $1
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push87=, $1=, $pop4
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop87, $pop5
	i32.store	$discard=, 12($6), $pop6
	block
	i32.load	$push7=, 0($1)
	i32.const	$push8=, 10
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push10=, 12($6)
	i32.const	$push11=, 7
	i32.add 	$push12=, $pop10, $pop11
	i32.const	$push13=, -8
	i32.and 	$push14=, $pop12, $pop13
	tee_local	$push88=, $1=, $pop14
	i32.const	$push15=, 8
	i32.add 	$push16=, $pop88, $pop15
	i32.store	$discard=, 12($6), $pop16
	block
	i64.load	$push17=, 0($1)
	i64.const	$push18=, 10000000000
	i64.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label1
# BB#2:                                 # %if.end4
	i32.load	$push20=, 12($6)
	i32.const	$push21=, 3
	i32.add 	$push22=, $pop20, $pop21
	i32.const	$push23=, -4
	i32.and 	$push24=, $pop22, $pop23
	tee_local	$push89=, $1=, $pop24
	i32.const	$push25=, 4
	i32.add 	$push26=, $pop89, $pop25
	i32.store	$discard=, 12($6), $pop26
	block
	i32.load	$push27=, 0($1)
	i32.const	$push28=, 11
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label2
# BB#3:                                 # %if.end7
	i32.load	$push30=, 12($6)
	i32.const	$push31=, 15
	i32.add 	$push32=, $pop30, $pop31
	i32.const	$push33=, -16
	i32.and 	$push34=, $pop32, $pop33
	tee_local	$push92=, $1=, $pop34
	i64.load	$2=, 0($pop92)
	i32.const	$push35=, 8
	i32.or  	$push36=, $1, $pop35
	i32.store	$push37=, 12($6), $pop36
	tee_local	$push91=, $1=, $pop37
	i32.const	$push90=, 8
	i32.add 	$push38=, $pop91, $pop90
	i32.store	$discard=, 12($6), $pop38
	block
	i64.load	$push39=, 0($1)
	i64.const	$push41=, -1475739525896764129
	i64.const	$push40=, 4611846459164112977
	i32.call	$push42=, __eqtf2@FUNCTION, $2, $pop39, $pop41, $pop40
	br_if   	0, $pop42       # 0: down to label3
# BB#4:                                 # %if.end10
	i32.load	$push43=, 12($6)
	i32.const	$push96=, 3
	i32.add 	$push44=, $pop43, $pop96
	i32.const	$push95=, -4
	i32.and 	$push45=, $pop44, $pop95
	tee_local	$push94=, $1=, $pop45
	i32.const	$push93=, 4
	i32.add 	$push46=, $pop94, $pop93
	i32.store	$discard=, 12($6), $pop46
	block
	i32.load	$push47=, 0($1)
	i32.const	$push48=, 12
	i32.ne  	$push49=, $pop47, $pop48
	br_if   	0, $pop49       # 0: down to label4
# BB#5:                                 # %if.end13
	i32.load	$push50=, 12($6)
	i32.const	$push100=, 3
	i32.add 	$push51=, $pop50, $pop100
	i32.const	$push99=, -4
	i32.and 	$push52=, $pop51, $pop99
	tee_local	$push98=, $1=, $pop52
	i32.const	$push97=, 4
	i32.add 	$push53=, $pop98, $pop97
	i32.store	$discard=, 12($6), $pop53
	block
	i32.load	$push54=, 0($1)
	i32.const	$push55=, 13
	i32.ne  	$push56=, $pop54, $pop55
	br_if   	0, $pop56       # 0: down to label5
# BB#6:                                 # %if.end16
	i32.load	$push57=, 12($6)
	i32.const	$push58=, 7
	i32.add 	$push59=, $pop57, $pop58
	i32.const	$push60=, -8
	i32.and 	$push61=, $pop59, $pop60
	tee_local	$push101=, $1=, $pop61
	i32.const	$push62=, 8
	i32.add 	$push63=, $pop101, $pop62
	i32.store	$discard=, 12($6), $pop63
	block
	i64.load	$push64=, 0($1)
	i64.const	$push65=, 20000000000
	i64.ne  	$push66=, $pop64, $pop65
	br_if   	0, $pop66       # 0: down to label6
# BB#7:                                 # %if.end19
	i32.load	$push67=, 12($6)
	i32.const	$push68=, 3
	i32.add 	$push69=, $pop67, $pop68
	i32.const	$push70=, -4
	i32.and 	$push71=, $pop69, $pop70
	tee_local	$push102=, $1=, $pop71
	i32.const	$push72=, 4
	i32.add 	$push73=, $pop102, $pop72
	i32.store	$discard=, 12($6), $pop73
	block
	i32.load	$push74=, 0($1)
	i32.const	$push75=, 14
	i32.ne  	$push76=, $pop74, $pop75
	br_if   	0, $pop76       # 0: down to label7
# BB#8:                                 # %if.end22
	i32.load	$push77=, 12($6)
	i32.const	$push78=, 7
	i32.add 	$push79=, $pop77, $pop78
	i32.const	$push80=, -8
	i32.and 	$push81=, $pop79, $pop80
	tee_local	$push103=, $1=, $pop81
	i32.const	$push82=, 8
	i32.add 	$push83=, $pop103, $pop82
	i32.store	$discard=, 12($6), $pop83
	block
	f64.load	$push84=, 0($1)
	f64.const	$push85=, 0x1.5c28f5c28f5c3p1
	f64.ne  	$push86=, $pop84, $pop85
	br_if   	0, $pop86       # 0: down to label8
# BB#9:                                 # %if.end25
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return  	$1
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
