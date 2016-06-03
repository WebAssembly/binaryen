	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960513-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i64, i64, i32
	.local  	i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$push37=, 0
	i32.const	$push34=, 0
	i32.load	$push35=, __stack_pointer($pop34)
	i32.const	$push36=, 192
	i32.sub 	$push85=, $pop35, $pop36
	i32.store	$push122=, __stack_pointer($pop37), $pop85
	tee_local	$push121=, $4=, $pop122
	i32.const	$push41=, 176
	i32.add 	$push42=, $pop121, $pop41
	i64.const	$push1=, 0
	i64.const	$push0=, -9223372036854775808
	call    	__subtf3@FUNCTION, $pop42, $pop1, $pop0, $1, $2
	i32.const	$push43=, 160
	i32.add 	$push44=, $4, $pop43
	i64.const	$push120=, 0
	i64.const	$push2=, -4611686018427387904
	call    	__multf3@FUNCTION, $pop44, $1, $2, $pop120, $pop2
	i32.const	$push49=, 144
	i32.add 	$push50=, $4, $pop49
	i64.load	$push10=, 160($4)
	i64.load	$push9=, 176($4)
	i32.const	$push3=, 1
	i32.eq  	$push119=, $3, $pop3
	tee_local	$push118=, $3=, $pop119
	i64.select	$push117=, $pop10, $pop9, $pop118
	tee_local	$push116=, $6=, $pop117
	i32.const	$push47=, 160
	i32.add 	$push48=, $4, $pop47
	i32.const	$push4=, 8
	i32.add 	$push7=, $pop48, $pop4
	i64.load	$push8=, 0($pop7)
	i32.const	$push45=, 176
	i32.add 	$push46=, $4, $pop45
	i32.const	$push115=, 8
	i32.add 	$push5=, $pop46, $pop115
	i64.load	$push6=, 0($pop5)
	i64.select	$push114=, $pop8, $pop6, $3
	tee_local	$push113=, $5=, $pop114
	call    	__multf3@FUNCTION, $pop50, $pop116, $pop113, $1, $2
	i32.const	$push53=, 128
	i32.add 	$push54=, $4, $pop53
	i64.load	$push13=, 144($4)
	i32.const	$push51=, 144
	i32.add 	$push52=, $4, $pop51
	i32.const	$push112=, 8
	i32.add 	$push11=, $pop52, $pop112
	i64.load	$push12=, 0($pop11)
	call    	__addtf3@FUNCTION, $pop54, $6, $5, $pop13, $pop12
	i32.const	$push57=, 112
	i32.add 	$push58=, $4, $pop57
	i64.load	$push111=, 128($4)
	tee_local	$push110=, $6=, $pop111
	i32.const	$push55=, 128
	i32.add 	$push56=, $4, $pop55
	i32.const	$push109=, 8
	i32.add 	$push14=, $pop56, $pop109
	i64.load	$push108=, 0($pop14)
	tee_local	$push107=, $5=, $pop108
	call    	__multf3@FUNCTION, $pop58, $pop110, $pop107, $1, $2
	i32.const	$push61=, 96
	i32.add 	$push62=, $4, $pop61
	i64.load	$push17=, 112($4)
	i32.const	$push59=, 112
	i32.add 	$push60=, $4, $pop59
	i32.const	$push106=, 8
	i32.add 	$push15=, $pop60, $pop106
	i64.load	$push16=, 0($pop15)
	call    	__addtf3@FUNCTION, $pop62, $6, $5, $pop17, $pop16
	i32.const	$push65=, 80
	i32.add 	$push66=, $4, $pop65
	i64.load	$push105=, 96($4)
	tee_local	$push104=, $6=, $pop105
	i32.const	$push63=, 96
	i32.add 	$push64=, $4, $pop63
	i32.const	$push103=, 8
	i32.add 	$push18=, $pop64, $pop103
	i64.load	$push102=, 0($pop18)
	tee_local	$push101=, $5=, $pop102
	call    	__multf3@FUNCTION, $pop66, $pop104, $pop101, $1, $2
	i32.const	$push69=, 64
	i32.add 	$push70=, $4, $pop69
	i64.load	$push21=, 80($4)
	i32.const	$push67=, 80
	i32.add 	$push68=, $4, $pop67
	i32.const	$push100=, 8
	i32.add 	$push19=, $pop68, $pop100
	i64.load	$push20=, 0($pop19)
	call    	__addtf3@FUNCTION, $pop70, $6, $5, $pop21, $pop20
	i32.const	$push73=, 48
	i32.add 	$push74=, $4, $pop73
	i64.load	$push99=, 64($4)
	tee_local	$push98=, $6=, $pop99
	i32.const	$push71=, 64
	i32.add 	$push72=, $4, $pop71
	i32.const	$push97=, 8
	i32.add 	$push22=, $pop72, $pop97
	i64.load	$push96=, 0($pop22)
	tee_local	$push95=, $5=, $pop96
	call    	__multf3@FUNCTION, $pop74, $pop98, $pop95, $1, $2
	i32.const	$push77=, 32
	i32.add 	$push78=, $4, $pop77
	i64.load	$push25=, 48($4)
	i32.const	$push75=, 48
	i32.add 	$push76=, $4, $pop75
	i32.const	$push94=, 8
	i32.add 	$push23=, $pop76, $pop94
	i64.load	$push24=, 0($pop23)
	call    	__addtf3@FUNCTION, $pop78, $6, $5, $pop25, $pop24
	i32.const	$push81=, 16
	i32.add 	$push82=, $4, $pop81
	i64.load	$push93=, 32($4)
	tee_local	$push92=, $6=, $pop93
	i32.const	$push79=, 32
	i32.add 	$push80=, $4, $pop79
	i32.const	$push91=, 8
	i32.add 	$push26=, $pop80, $pop91
	i64.load	$push90=, 0($pop26)
	tee_local	$push89=, $5=, $pop90
	call    	__multf3@FUNCTION, $pop82, $pop92, $pop89, $1, $2
	i64.load	$push29=, 16($4)
	i32.const	$push83=, 16
	i32.add 	$push84=, $4, $pop83
	i32.const	$push88=, 8
	i32.add 	$push27=, $pop84, $pop88
	i64.load	$push28=, 0($pop27)
	call    	__addtf3@FUNCTION, $4, $6, $5, $pop29, $pop28
	i32.const	$push87=, 8
	i32.add 	$push30=, $0, $pop87
	i32.const	$push86=, 8
	i32.add 	$push31=, $4, $pop86
	i64.load	$push32=, 0($pop31)
	i64.store	$drop=, 0($pop30), $pop32
	i64.load	$push33=, 0($4)
	i64.store	$drop=, 0($0), $pop33
	i32.const	$push40=, 0
	i32.const	$push38=, 192
	i32.add 	$push39=, $4, $pop38
	i32.store	$drop=, __stack_pointer($pop40), $pop39
                                        # fallthrough-return
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
	.functype	exit, void, i32
