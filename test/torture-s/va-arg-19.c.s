	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-19.c"
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
	i32.const	$push67=, 3
	i32.add 	$push1=, $pop0, $pop67
	i32.const	$push66=, -4
	i32.and 	$push2=, $pop1, $pop66
	tee_local	$push65=, $1=, $pop2
	i32.const	$push64=, 4
	i32.add 	$push3=, $pop65, $pop64
	i32.store	$discard=, 12($5), $pop3
	block
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 1
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push7=, 12($5)
	i32.const	$push71=, 3
	i32.add 	$push8=, $pop7, $pop71
	i32.const	$push70=, -4
	i32.and 	$push9=, $pop8, $pop70
	tee_local	$push69=, $1=, $pop9
	i32.const	$push68=, 4
	i32.add 	$push10=, $pop69, $pop68
	i32.store	$discard=, 12($5), $pop10
	block
	i32.load	$push11=, 0($1)
	i32.const	$push12=, 2
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	$pop13, 0       # 0: down to label1
# BB#2:                                 # %if.end4
	i32.load	$push14=, 12($5)
	i32.const	$push76=, 3
	i32.add 	$push15=, $pop14, $pop76
	i32.const	$push75=, -4
	i32.and 	$push16=, $pop15, $pop75
	tee_local	$push74=, $1=, $pop16
	i32.const	$push73=, 4
	i32.add 	$push17=, $pop74, $pop73
	i32.store	$discard=, 12($5), $pop17
	block
	i32.load	$push18=, 0($1)
	i32.const	$push72=, 3
	i32.ne  	$push19=, $pop18, $pop72
	br_if   	$pop19, 0       # 0: down to label2
# BB#3:                                 # %if.end7
	i32.load	$push20=, 12($5)
	i32.const	$push81=, 3
	i32.add 	$push21=, $pop20, $pop81
	i32.const	$push80=, -4
	i32.and 	$push22=, $pop21, $pop80
	tee_local	$push79=, $1=, $pop22
	i32.const	$push78=, 4
	i32.add 	$push23=, $pop79, $pop78
	i32.store	$discard=, 12($5), $pop23
	block
	i32.load	$push24=, 0($1)
	i32.const	$push77=, 4
	i32.ne  	$push25=, $pop24, $pop77
	br_if   	$pop25, 0       # 0: down to label3
# BB#4:                                 # %if.end10
	i32.load	$push26=, 12($5)
	i32.const	$push85=, 3
	i32.add 	$push27=, $pop26, $pop85
	i32.const	$push84=, -4
	i32.and 	$push28=, $pop27, $pop84
	tee_local	$push83=, $1=, $pop28
	i32.const	$push82=, 4
	i32.add 	$push29=, $pop83, $pop82
	i32.store	$discard=, 12($5), $pop29
	block
	i32.load	$push30=, 0($1)
	i32.const	$push31=, 5
	i32.ne  	$push32=, $pop30, $pop31
	br_if   	$pop32, 0       # 0: down to label4
# BB#5:                                 # %if.end13
	i32.load	$push33=, 12($5)
	i32.const	$push89=, 3
	i32.add 	$push34=, $pop33, $pop89
	i32.const	$push88=, -4
	i32.and 	$push35=, $pop34, $pop88
	tee_local	$push87=, $1=, $pop35
	i32.const	$push86=, 4
	i32.add 	$push36=, $pop87, $pop86
	i32.store	$discard=, 12($5), $pop36
	block
	i32.load	$push37=, 0($1)
	i32.const	$push38=, 6
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	$pop39, 0       # 0: down to label5
# BB#6:                                 # %if.end16
	i32.load	$push40=, 12($5)
	i32.const	$push93=, 3
	i32.add 	$push41=, $pop40, $pop93
	i32.const	$push92=, -4
	i32.and 	$push42=, $pop41, $pop92
	tee_local	$push91=, $1=, $pop42
	i32.const	$push90=, 4
	i32.add 	$push43=, $pop91, $pop90
	i32.store	$discard=, 12($5), $pop43
	block
	i32.load	$push44=, 0($1)
	i32.const	$push45=, 7
	i32.ne  	$push46=, $pop44, $pop45
	br_if   	$pop46, 0       # 0: down to label6
# BB#7:                                 # %if.end19
	i32.load	$push47=, 12($5)
	i32.const	$push97=, 3
	i32.add 	$push48=, $pop47, $pop97
	i32.const	$push96=, -4
	i32.and 	$push49=, $pop48, $pop96
	tee_local	$push95=, $1=, $pop49
	i32.const	$push94=, 4
	i32.add 	$push50=, $pop95, $pop94
	i32.store	$discard=, 12($5), $pop50
	block
	i32.load	$push51=, 0($1)
	i32.const	$push52=, 8
	i32.ne  	$push53=, $pop51, $pop52
	br_if   	$pop53, 0       # 0: down to label7
# BB#8:                                 # %if.end22
	i32.load	$push54=, 12($5)
	i32.const	$push55=, 3
	i32.add 	$push56=, $pop54, $pop55
	i32.const	$push57=, -4
	i32.and 	$push58=, $pop56, $pop57
	tee_local	$push98=, $1=, $pop58
	i32.const	$push59=, 4
	i32.add 	$push60=, $pop98, $pop59
	i32.store	$discard=, 12($5), $pop60
	block
	i32.load	$push61=, 0($1)
	i32.const	$push62=, 9
	i32.ne  	$push63=, $pop61, $pop62
	br_if   	$pop63, 0       # 0: down to label8
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
	i32.const	$6=, 48
	i32.sub 	$7=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 36
	i32.sub 	$7=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	i64.const	$push0=, 8589934593
	i64.store	$discard=, 0($7):p2align=2, $pop0
	i32.const	$push1=, 32
	i32.add 	$0=, $7, $pop1
	i32.const	$push2=, 9
	i32.store	$discard=, 0($0), $pop2
	i32.const	$push3=, 24
	i32.add 	$0=, $7, $pop3
	i64.const	$push4=, 34359738375
	i64.store	$discard=, 0($0):p2align=2, $pop4
	i32.const	$push5=, 16
	i32.add 	$0=, $7, $pop5
	i64.const	$push6=, 25769803781
	i64.store	$discard=, 0($0):p2align=2, $pop6
	i32.const	$push7=, 8
	i32.add 	$0=, $7, $pop7
	i64.const	$push8=, 17179869187
	i64.store	$discard=, 0($0):p2align=2, $pop8
	call    	vafunction@FUNCTION, $0
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 36
	i32.add 	$7=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
