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
	i32.const	$push34=, __stack_pointer
	i32.const	$push31=, __stack_pointer
	i32.load	$push32=, 0($pop31)
	i32.const	$push33=, 192
	i32.sub 	$push82=, $pop32, $pop33
	i32.store	$push119=, 0($pop34), $pop82
	tee_local	$push118=, $6=, $pop119
	i32.const	$push38=, 176
	i32.add 	$push39=, $pop118, $pop38
	i64.const	$push1=, 0
	i64.const	$push0=, -9223372036854775808
	call    	__subtf3@FUNCTION, $pop39, $pop1, $pop0, $1, $2
	i32.const	$push40=, 176
	i32.add 	$push41=, $6, $pop40
	i32.const	$push2=, 8
	i32.add 	$push3=, $pop41, $pop2
	i64.load	$4=, 0($pop3)
	i64.load	$5=, 176($6)
	i32.const	$push42=, 160
	i32.add 	$push43=, $6, $pop42
	i64.const	$push117=, 0
	i64.const	$push5=, -4611686018427387904
	call    	__multf3@FUNCTION, $pop43, $1, $2, $pop117, $pop5
	i32.const	$push46=, 144
	i32.add 	$push47=, $6, $pop46
	i64.load	$push8=, 160($6)
	i32.const	$push4=, 1
	i32.eq  	$push116=, $3, $pop4
	tee_local	$push115=, $3=, $pop116
	i64.select	$push114=, $pop8, $5, $pop115
	tee_local	$push113=, $5=, $pop114
	i32.const	$push44=, 160
	i32.add 	$push45=, $6, $pop44
	i32.const	$push112=, 8
	i32.add 	$push6=, $pop45, $pop112
	i64.load	$push7=, 0($pop6)
	i64.select	$push111=, $pop7, $4, $3
	tee_local	$push110=, $4=, $pop111
	call    	__multf3@FUNCTION, $pop47, $pop113, $pop110, $1, $2
	i32.const	$push50=, 128
	i32.add 	$push51=, $6, $pop50
	i64.load	$push11=, 144($6)
	i32.const	$push48=, 144
	i32.add 	$push49=, $6, $pop48
	i32.const	$push109=, 8
	i32.add 	$push9=, $pop49, $pop109
	i64.load	$push10=, 0($pop9)
	call    	__addtf3@FUNCTION, $pop51, $5, $4, $pop11, $pop10
	i32.const	$push54=, 112
	i32.add 	$push55=, $6, $pop54
	i64.load	$push108=, 128($6)
	tee_local	$push107=, $4=, $pop108
	i32.const	$push52=, 128
	i32.add 	$push53=, $6, $pop52
	i32.const	$push106=, 8
	i32.add 	$push12=, $pop53, $pop106
	i64.load	$push105=, 0($pop12)
	tee_local	$push104=, $5=, $pop105
	call    	__multf3@FUNCTION, $pop55, $pop107, $pop104, $1, $2
	i32.const	$push58=, 96
	i32.add 	$push59=, $6, $pop58
	i64.load	$push15=, 112($6)
	i32.const	$push56=, 112
	i32.add 	$push57=, $6, $pop56
	i32.const	$push103=, 8
	i32.add 	$push13=, $pop57, $pop103
	i64.load	$push14=, 0($pop13)
	call    	__addtf3@FUNCTION, $pop59, $4, $5, $pop15, $pop14
	i32.const	$push62=, 80
	i32.add 	$push63=, $6, $pop62
	i64.load	$push102=, 96($6)
	tee_local	$push101=, $4=, $pop102
	i32.const	$push60=, 96
	i32.add 	$push61=, $6, $pop60
	i32.const	$push100=, 8
	i32.add 	$push16=, $pop61, $pop100
	i64.load	$push99=, 0($pop16)
	tee_local	$push98=, $5=, $pop99
	call    	__multf3@FUNCTION, $pop63, $pop101, $pop98, $1, $2
	i32.const	$push66=, 64
	i32.add 	$push67=, $6, $pop66
	i64.load	$push19=, 80($6)
	i32.const	$push64=, 80
	i32.add 	$push65=, $6, $pop64
	i32.const	$push97=, 8
	i32.add 	$push17=, $pop65, $pop97
	i64.load	$push18=, 0($pop17)
	call    	__addtf3@FUNCTION, $pop67, $4, $5, $pop19, $pop18
	i32.const	$push70=, 48
	i32.add 	$push71=, $6, $pop70
	i64.load	$push96=, 64($6)
	tee_local	$push95=, $4=, $pop96
	i32.const	$push68=, 64
	i32.add 	$push69=, $6, $pop68
	i32.const	$push94=, 8
	i32.add 	$push20=, $pop69, $pop94
	i64.load	$push93=, 0($pop20)
	tee_local	$push92=, $5=, $pop93
	call    	__multf3@FUNCTION, $pop71, $pop95, $pop92, $1, $2
	i32.const	$push74=, 32
	i32.add 	$push75=, $6, $pop74
	i64.load	$push23=, 48($6)
	i32.const	$push72=, 48
	i32.add 	$push73=, $6, $pop72
	i32.const	$push91=, 8
	i32.add 	$push21=, $pop73, $pop91
	i64.load	$push22=, 0($pop21)
	call    	__addtf3@FUNCTION, $pop75, $4, $5, $pop23, $pop22
	i32.const	$push78=, 16
	i32.add 	$push79=, $6, $pop78
	i64.load	$push90=, 32($6)
	tee_local	$push89=, $4=, $pop90
	i32.const	$push76=, 32
	i32.add 	$push77=, $6, $pop76
	i32.const	$push88=, 8
	i32.add 	$push24=, $pop77, $pop88
	i64.load	$push87=, 0($pop24)
	tee_local	$push86=, $5=, $pop87
	call    	__multf3@FUNCTION, $pop79, $pop89, $pop86, $1, $2
	i64.load	$push27=, 16($6)
	i32.const	$push80=, 16
	i32.add 	$push81=, $6, $pop80
	i32.const	$push85=, 8
	i32.add 	$push25=, $pop81, $pop85
	i64.load	$push26=, 0($pop25)
	call    	__addtf3@FUNCTION, $6, $4, $5, $pop27, $pop26
	i64.load	$1=, 0($6)
	i32.const	$push84=, 8
	i32.add 	$push30=, $0, $pop84
	i32.const	$push83=, 8
	i32.add 	$push28=, $6, $pop83
	i64.load	$push29=, 0($pop28)
	i64.store	$discard=, 0($pop30), $pop29
	i64.store	$discard=, 0($0), $1
	i32.const	$push37=, __stack_pointer
	i32.const	$push35=, 192
	i32.add 	$push36=, $6, $pop35
	i32.store	$discard=, 0($pop37), $pop36
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
