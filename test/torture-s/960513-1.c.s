	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960513-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i64, i64, i32
	.local  	i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push66=, __stack_pointer
	i32.load	$push67=, 0($pop66)
	i32.const	$push68=, 192
	i32.sub 	$6=, $pop67, $pop68
	i32.const	$push69=, __stack_pointer
	i32.store	$discard=, 0($pop69), $6
	i32.const	$push73=, 176
	i32.add 	$push74=, $6, $pop73
	i64.const	$push1=, 0
	i64.const	$push0=, -9223372036854775808
	call    	__subtf3@FUNCTION, $pop74, $pop1, $pop0, $1, $2
	i32.const	$push75=, 176
	i32.add 	$push76=, $6, $pop75
	i32.const	$push2=, 8
	i32.add 	$push3=, $pop76, $pop2
	i64.load	$4=, 0($pop3)
	i64.load	$5=, 176($6)
	i32.const	$push77=, 160
	i32.add 	$push78=, $6, $pop77
	i64.const	$push65=, 0
	i64.const	$push5=, -4611686018427387904
	call    	__multf3@FUNCTION, $pop78, $1, $2, $pop65, $pop5
	i32.const	$push81=, 144
	i32.add 	$push82=, $6, $pop81
	i64.load	$push8=, 160($6)
	i32.const	$push4=, 1
	i32.eq  	$push64=, $3, $pop4
	tee_local	$push63=, $3=, $pop64
	i64.select	$push62=, $pop8, $5, $pop63
	tee_local	$push61=, $5=, $pop62
	i32.const	$push79=, 160
	i32.add 	$push80=, $6, $pop79
	i32.const	$push60=, 8
	i32.add 	$push6=, $pop80, $pop60
	i64.load	$push7=, 0($pop6)
	i64.select	$push59=, $pop7, $4, $3
	tee_local	$push58=, $4=, $pop59
	call    	__multf3@FUNCTION, $pop82, $pop61, $pop58, $1, $2
	i32.const	$push85=, 128
	i32.add 	$push86=, $6, $pop85
	i64.load	$push11=, 144($6)
	i32.const	$push83=, 144
	i32.add 	$push84=, $6, $pop83
	i32.const	$push57=, 8
	i32.add 	$push9=, $pop84, $pop57
	i64.load	$push10=, 0($pop9)
	call    	__addtf3@FUNCTION, $pop86, $5, $4, $pop11, $pop10
	i32.const	$push89=, 112
	i32.add 	$push90=, $6, $pop89
	i64.load	$push56=, 128($6)
	tee_local	$push55=, $4=, $pop56
	i32.const	$push87=, 128
	i32.add 	$push88=, $6, $pop87
	i32.const	$push54=, 8
	i32.add 	$push12=, $pop88, $pop54
	i64.load	$push53=, 0($pop12)
	tee_local	$push52=, $5=, $pop53
	call    	__multf3@FUNCTION, $pop90, $pop55, $pop52, $1, $2
	i32.const	$push93=, 96
	i32.add 	$push94=, $6, $pop93
	i64.load	$push15=, 112($6)
	i32.const	$push91=, 112
	i32.add 	$push92=, $6, $pop91
	i32.const	$push51=, 8
	i32.add 	$push13=, $pop92, $pop51
	i64.load	$push14=, 0($pop13)
	call    	__addtf3@FUNCTION, $pop94, $4, $5, $pop15, $pop14
	i32.const	$push97=, 80
	i32.add 	$push98=, $6, $pop97
	i64.load	$push50=, 96($6)
	tee_local	$push49=, $4=, $pop50
	i32.const	$push95=, 96
	i32.add 	$push96=, $6, $pop95
	i32.const	$push48=, 8
	i32.add 	$push16=, $pop96, $pop48
	i64.load	$push47=, 0($pop16)
	tee_local	$push46=, $5=, $pop47
	call    	__multf3@FUNCTION, $pop98, $pop49, $pop46, $1, $2
	i32.const	$push101=, 64
	i32.add 	$push102=, $6, $pop101
	i64.load	$push19=, 80($6)
	i32.const	$push99=, 80
	i32.add 	$push100=, $6, $pop99
	i32.const	$push45=, 8
	i32.add 	$push17=, $pop100, $pop45
	i64.load	$push18=, 0($pop17)
	call    	__addtf3@FUNCTION, $pop102, $4, $5, $pop19, $pop18
	i32.const	$push105=, 48
	i32.add 	$push106=, $6, $pop105
	i64.load	$push44=, 64($6)
	tee_local	$push43=, $4=, $pop44
	i32.const	$push103=, 64
	i32.add 	$push104=, $6, $pop103
	i32.const	$push42=, 8
	i32.add 	$push20=, $pop104, $pop42
	i64.load	$push41=, 0($pop20)
	tee_local	$push40=, $5=, $pop41
	call    	__multf3@FUNCTION, $pop106, $pop43, $pop40, $1, $2
	i32.const	$push109=, 32
	i32.add 	$push110=, $6, $pop109
	i64.load	$push23=, 48($6)
	i32.const	$push107=, 48
	i32.add 	$push108=, $6, $pop107
	i32.const	$push39=, 8
	i32.add 	$push21=, $pop108, $pop39
	i64.load	$push22=, 0($pop21)
	call    	__addtf3@FUNCTION, $pop110, $4, $5, $pop23, $pop22
	i32.const	$push113=, 16
	i32.add 	$push114=, $6, $pop113
	i64.load	$push38=, 32($6)
	tee_local	$push37=, $4=, $pop38
	i32.const	$push111=, 32
	i32.add 	$push112=, $6, $pop111
	i32.const	$push36=, 8
	i32.add 	$push24=, $pop112, $pop36
	i64.load	$push35=, 0($pop24)
	tee_local	$push34=, $5=, $pop35
	call    	__multf3@FUNCTION, $pop114, $pop37, $pop34, $1, $2
	i64.load	$push27=, 16($6)
	i32.const	$push115=, 16
	i32.add 	$push116=, $6, $pop115
	i32.const	$push33=, 8
	i32.add 	$push25=, $pop116, $pop33
	i64.load	$push26=, 0($pop25)
	call    	__addtf3@FUNCTION, $6, $4, $5, $pop27, $pop26
	i64.load	$2=, 0($6)
	i32.const	$push32=, 8
	i32.add 	$push30=, $0, $pop32
	i32.const	$push31=, 8
	i32.add 	$push28=, $6, $pop31
	i64.load	$push29=, 0($pop28)
	i64.store	$discard=, 0($pop30), $pop29
	i64.store	$discard=, 0($0):p2align=4, $2
	i32.const	$push72=, __stack_pointer
	i32.const	$push70=, 192
	i32.add 	$push71=, $6, $pop70
	i32.store	$discard=, 0($pop72), $pop71
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
