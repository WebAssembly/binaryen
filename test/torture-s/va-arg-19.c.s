	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-19.c"
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
	i32.const	$push59=, 3
	i32.add 	$push1=, $pop0, $pop59
	i32.const	$push58=, -4
	i32.and 	$push57=, $pop1, $pop58
	tee_local	$push56=, $1=, $pop57
	i32.const	$push55=, 4
	i32.add 	$push2=, $pop56, $pop55
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
	i32.load	$push3=, 0($1)
	i32.const	$push4=, 1
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label8
# BB#1:                                 # %if.end
	i32.load	$push6=, 12($5)
	i32.const	$push64=, 3
	i32.add 	$push7=, $pop6, $pop64
	i32.const	$push63=, -4
	i32.and 	$push62=, $pop7, $pop63
	tee_local	$push61=, $1=, $pop62
	i32.const	$push60=, 4
	i32.add 	$push8=, $pop61, $pop60
	i32.store	$discard=, 12($5), $pop8
	i32.load	$push9=, 0($1)
	i32.const	$push10=, 2
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	1, $pop11       # 1: down to label7
# BB#2:                                 # %if.end4
	i32.load	$push12=, 12($5)
	i32.const	$push70=, 3
	i32.add 	$push13=, $pop12, $pop70
	i32.const	$push69=, -4
	i32.and 	$push68=, $pop13, $pop69
	tee_local	$push67=, $1=, $pop68
	i32.const	$push66=, 4
	i32.add 	$push14=, $pop67, $pop66
	i32.store	$discard=, 12($5), $pop14
	i32.load	$push15=, 0($1)
	i32.const	$push65=, 3
	i32.ne  	$push16=, $pop15, $pop65
	br_if   	2, $pop16       # 2: down to label6
# BB#3:                                 # %if.end7
	i32.load	$push17=, 12($5)
	i32.const	$push76=, 3
	i32.add 	$push18=, $pop17, $pop76
	i32.const	$push75=, -4
	i32.and 	$push74=, $pop18, $pop75
	tee_local	$push73=, $1=, $pop74
	i32.const	$push72=, 4
	i32.add 	$push19=, $pop73, $pop72
	i32.store	$discard=, 12($5), $pop19
	i32.load	$push20=, 0($1)
	i32.const	$push71=, 4
	i32.ne  	$push21=, $pop20, $pop71
	br_if   	3, $pop21       # 3: down to label5
# BB#4:                                 # %if.end10
	i32.load	$push22=, 12($5)
	i32.const	$push81=, 3
	i32.add 	$push23=, $pop22, $pop81
	i32.const	$push80=, -4
	i32.and 	$push79=, $pop23, $pop80
	tee_local	$push78=, $1=, $pop79
	i32.const	$push77=, 4
	i32.add 	$push24=, $pop78, $pop77
	i32.store	$discard=, 12($5), $pop24
	i32.load	$push25=, 0($1)
	i32.const	$push26=, 5
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	4, $pop27       # 4: down to label4
# BB#5:                                 # %if.end13
	i32.load	$push28=, 12($5)
	i32.const	$push86=, 3
	i32.add 	$push29=, $pop28, $pop86
	i32.const	$push85=, -4
	i32.and 	$push84=, $pop29, $pop85
	tee_local	$push83=, $1=, $pop84
	i32.const	$push82=, 4
	i32.add 	$push30=, $pop83, $pop82
	i32.store	$discard=, 12($5), $pop30
	i32.load	$push31=, 0($1)
	i32.const	$push32=, 6
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	5, $pop33       # 5: down to label3
# BB#6:                                 # %if.end16
	i32.load	$push34=, 12($5)
	i32.const	$push91=, 3
	i32.add 	$push35=, $pop34, $pop91
	i32.const	$push90=, -4
	i32.and 	$push89=, $pop35, $pop90
	tee_local	$push88=, $1=, $pop89
	i32.const	$push87=, 4
	i32.add 	$push36=, $pop88, $pop87
	i32.store	$discard=, 12($5), $pop36
	i32.load	$push37=, 0($1)
	i32.const	$push38=, 7
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	6, $pop39       # 6: down to label2
# BB#7:                                 # %if.end19
	i32.load	$push40=, 12($5)
	i32.const	$push96=, 3
	i32.add 	$push41=, $pop40, $pop96
	i32.const	$push95=, -4
	i32.and 	$push94=, $pop41, $pop95
	tee_local	$push93=, $1=, $pop94
	i32.const	$push92=, 4
	i32.add 	$push42=, $pop93, $pop92
	i32.store	$discard=, 12($5), $pop42
	i32.load	$push43=, 0($1)
	i32.const	$push44=, 8
	i32.ne  	$push45=, $pop43, $pop44
	br_if   	7, $pop45       # 7: down to label1
# BB#8:                                 # %if.end22
	i32.load	$push46=, 12($5)
	i32.const	$push47=, 3
	i32.add 	$push48=, $pop46, $pop47
	i32.const	$push49=, -4
	i32.and 	$push98=, $pop48, $pop49
	tee_local	$push97=, $1=, $pop98
	i32.const	$push50=, 4
	i32.add 	$push51=, $pop97, $pop50
	i32.store	$discard=, 12($5), $pop51
	i32.load	$push52=, 0($1)
	i32.const	$push53=, 9
	i32.ne  	$push54=, $pop52, $pop53
	br_if   	8, $pop54       # 8: down to label0
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
	i32.const	$2=, 48
	i32.sub 	$3=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	i32.const	$push0=, 32
	i32.add 	$push1=, $3, $pop0
	i32.const	$push2=, 9
	i32.store	$discard=, 0($pop1):p2align=4, $pop2
	i32.const	$push3=, 24
	i32.add 	$push4=, $3, $pop3
	i64.const	$push5=, 34359738375
	i64.store	$discard=, 0($pop4), $pop5
	i32.const	$push6=, 16
	i32.add 	$push7=, $3, $pop6
	i64.const	$push8=, 25769803781
	i64.store	$discard=, 0($pop7):p2align=4, $pop8
	i32.const	$push9=, 8
	i32.or  	$push10=, $3, $pop9
	i64.const	$push11=, 17179869187
	i64.store	$discard=, 0($pop10), $pop11
	i64.const	$push12=, 8589934593
	i64.store	$discard=, 0($3):p2align=4, $pop12
	call    	vafunction@FUNCTION, $0, $3
	i32.const	$push13=, 0
	call    	exit@FUNCTION, $pop13
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
