	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960513-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i64, i64, i32
	.local  	i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push37=, 0
	i32.const	$push34=, 0
	i32.load	$push35=, __stack_pointer($pop34)
	i32.const	$push36=, 192
	i32.sub 	$push121=, $pop35, $pop36
	tee_local	$push120=, $6=, $pop121
	i32.store	__stack_pointer($pop37), $pop120
	i32.const	$push41=, 176
	i32.add 	$push42=, $6, $pop41
	i64.const	$push1=, 0
	i64.const	$push0=, -9223372036854775808
	call    	__subtf3@FUNCTION, $pop42, $pop1, $pop0, $1, $2
	i32.const	$push43=, 160
	i32.add 	$push44=, $6, $pop43
	i64.const	$push119=, 0
	i64.const	$push2=, -4611686018427387904
	call    	__multf3@FUNCTION, $pop44, $1, $2, $pop119, $pop2
	i32.const	$push49=, 144
	i32.add 	$push50=, $6, $pop49
	i64.load	$push10=, 160($6)
	i64.load	$push9=, 176($6)
	i32.const	$push3=, 1
	i32.eq  	$push118=, $3, $pop3
	tee_local	$push117=, $3=, $pop118
	i64.select	$push116=, $pop10, $pop9, $pop117
	tee_local	$push115=, $5=, $pop116
	i32.const	$push47=, 160
	i32.add 	$push48=, $6, $pop47
	i32.const	$push4=, 8
	i32.add 	$push7=, $pop48, $pop4
	i64.load	$push8=, 0($pop7)
	i32.const	$push45=, 176
	i32.add 	$push46=, $6, $pop45
	i32.const	$push114=, 8
	i32.add 	$push5=, $pop46, $pop114
	i64.load	$push6=, 0($pop5)
	i64.select	$push113=, $pop8, $pop6, $3
	tee_local	$push112=, $4=, $pop113
	call    	__multf3@FUNCTION, $pop50, $pop115, $pop112, $1, $2
	i32.const	$push53=, 128
	i32.add 	$push54=, $6, $pop53
	i64.load	$push13=, 144($6)
	i32.const	$push51=, 144
	i32.add 	$push52=, $6, $pop51
	i32.const	$push111=, 8
	i32.add 	$push11=, $pop52, $pop111
	i64.load	$push12=, 0($pop11)
	call    	__addtf3@FUNCTION, $pop54, $5, $4, $pop13, $pop12
	i32.const	$push57=, 112
	i32.add 	$push58=, $6, $pop57
	i64.load	$push110=, 128($6)
	tee_local	$push109=, $5=, $pop110
	i32.const	$push55=, 128
	i32.add 	$push56=, $6, $pop55
	i32.const	$push108=, 8
	i32.add 	$push14=, $pop56, $pop108
	i64.load	$push107=, 0($pop14)
	tee_local	$push106=, $4=, $pop107
	call    	__multf3@FUNCTION, $pop58, $pop109, $pop106, $1, $2
	i32.const	$push61=, 96
	i32.add 	$push62=, $6, $pop61
	i64.load	$push17=, 112($6)
	i32.const	$push59=, 112
	i32.add 	$push60=, $6, $pop59
	i32.const	$push105=, 8
	i32.add 	$push15=, $pop60, $pop105
	i64.load	$push16=, 0($pop15)
	call    	__addtf3@FUNCTION, $pop62, $5, $4, $pop17, $pop16
	i32.const	$push65=, 80
	i32.add 	$push66=, $6, $pop65
	i64.load	$push104=, 96($6)
	tee_local	$push103=, $5=, $pop104
	i32.const	$push63=, 96
	i32.add 	$push64=, $6, $pop63
	i32.const	$push102=, 8
	i32.add 	$push18=, $pop64, $pop102
	i64.load	$push101=, 0($pop18)
	tee_local	$push100=, $4=, $pop101
	call    	__multf3@FUNCTION, $pop66, $pop103, $pop100, $1, $2
	i32.const	$push69=, 64
	i32.add 	$push70=, $6, $pop69
	i64.load	$push21=, 80($6)
	i32.const	$push67=, 80
	i32.add 	$push68=, $6, $pop67
	i32.const	$push99=, 8
	i32.add 	$push19=, $pop68, $pop99
	i64.load	$push20=, 0($pop19)
	call    	__addtf3@FUNCTION, $pop70, $5, $4, $pop21, $pop20
	i32.const	$push73=, 48
	i32.add 	$push74=, $6, $pop73
	i64.load	$push98=, 64($6)
	tee_local	$push97=, $5=, $pop98
	i32.const	$push71=, 64
	i32.add 	$push72=, $6, $pop71
	i32.const	$push96=, 8
	i32.add 	$push22=, $pop72, $pop96
	i64.load	$push95=, 0($pop22)
	tee_local	$push94=, $4=, $pop95
	call    	__multf3@FUNCTION, $pop74, $pop97, $pop94, $1, $2
	i32.const	$push77=, 32
	i32.add 	$push78=, $6, $pop77
	i64.load	$push25=, 48($6)
	i32.const	$push75=, 48
	i32.add 	$push76=, $6, $pop75
	i32.const	$push93=, 8
	i32.add 	$push23=, $pop76, $pop93
	i64.load	$push24=, 0($pop23)
	call    	__addtf3@FUNCTION, $pop78, $5, $4, $pop25, $pop24
	i32.const	$push81=, 16
	i32.add 	$push82=, $6, $pop81
	i64.load	$push92=, 32($6)
	tee_local	$push91=, $5=, $pop92
	i32.const	$push79=, 32
	i32.add 	$push80=, $6, $pop79
	i32.const	$push90=, 8
	i32.add 	$push26=, $pop80, $pop90
	i64.load	$push89=, 0($pop26)
	tee_local	$push88=, $4=, $pop89
	call    	__multf3@FUNCTION, $pop82, $pop91, $pop88, $1, $2
	i64.load	$push29=, 16($6)
	i32.const	$push83=, 16
	i32.add 	$push84=, $6, $pop83
	i32.const	$push87=, 8
	i32.add 	$push27=, $pop84, $pop87
	i64.load	$push28=, 0($pop27)
	call    	__addtf3@FUNCTION, $6, $5, $4, $pop29, $pop28
	i32.const	$push86=, 8
	i32.add 	$push30=, $0, $pop86
	i32.const	$push85=, 8
	i32.add 	$push31=, $6, $pop85
	i64.load	$push32=, 0($pop31)
	i64.store	0($pop30), $pop32
	i64.load	$push33=, 0($6)
	i64.store	0($0), $pop33
	i32.const	$push40=, 0
	i32.const	$push38=, 192
	i32.add 	$push39=, $6, $pop38
	i32.store	__stack_pointer($pop40), $pop39
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
