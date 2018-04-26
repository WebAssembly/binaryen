	.text
	.file	"960513-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i64, i64, i32
	.local  	i64, i64, i32
# %bb.0:                                # %entry
	i32.const	$push34=, 0
	i32.load	$push33=, __stack_pointer($pop34)
	i32.const	$push35=, 192
	i32.sub 	$6=, $pop33, $pop35
	i32.const	$push36=, 0
	i32.store	__stack_pointer($pop36), $6
	i32.const	$push40=, 176
	i32.add 	$push41=, $6, $pop40
	i64.const	$push1=, 0
	i64.const	$push0=, -9223372036854775808
	call    	__subtf3@FUNCTION, $pop41, $pop1, $pop0, $1, $2
	i32.const	$push42=, 160
	i32.add 	$push43=, $6, $pop42
	i64.const	$push95=, 0
	i64.const	$push2=, -4611686018427387904
	call    	__multf3@FUNCTION, $pop43, $1, $2, $pop95, $pop2
	i32.const	$push3=, 1
	i32.eq  	$3=, $3, $pop3
	i32.const	$push46=, 160
	i32.add 	$push47=, $6, $pop46
	i32.const	$push4=, 8
	i32.add 	$push7=, $pop47, $pop4
	i64.load	$push8=, 0($pop7)
	i32.const	$push44=, 176
	i32.add 	$push45=, $6, $pop44
	i32.const	$push94=, 8
	i32.add 	$push5=, $pop45, $pop94
	i64.load	$push6=, 0($pop5)
	i64.select	$4=, $pop8, $pop6, $3
	i64.load	$push10=, 160($6)
	i64.load	$push9=, 176($6)
	i64.select	$5=, $pop10, $pop9, $3
	i32.const	$push48=, 144
	i32.add 	$push49=, $6, $pop48
	call    	__multf3@FUNCTION, $pop49, $5, $4, $1, $2
	i32.const	$push52=, 128
	i32.add 	$push53=, $6, $pop52
	i64.load	$push13=, 144($6)
	i32.const	$push50=, 144
	i32.add 	$push51=, $6, $pop50
	i32.const	$push93=, 8
	i32.add 	$push11=, $pop51, $pop93
	i64.load	$push12=, 0($pop11)
	call    	__addtf3@FUNCTION, $pop53, $5, $4, $pop13, $pop12
	i32.const	$push54=, 128
	i32.add 	$push55=, $6, $pop54
	i32.const	$push92=, 8
	i32.add 	$push14=, $pop55, $pop92
	i64.load	$4=, 0($pop14)
	i64.load	$5=, 128($6)
	i32.const	$push56=, 112
	i32.add 	$push57=, $6, $pop56
	call    	__multf3@FUNCTION, $pop57, $5, $4, $1, $2
	i32.const	$push60=, 96
	i32.add 	$push61=, $6, $pop60
	i64.load	$push17=, 112($6)
	i32.const	$push58=, 112
	i32.add 	$push59=, $6, $pop58
	i32.const	$push91=, 8
	i32.add 	$push15=, $pop59, $pop91
	i64.load	$push16=, 0($pop15)
	call    	__addtf3@FUNCTION, $pop61, $5, $4, $pop17, $pop16
	i32.const	$push62=, 96
	i32.add 	$push63=, $6, $pop62
	i32.const	$push90=, 8
	i32.add 	$push18=, $pop63, $pop90
	i64.load	$4=, 0($pop18)
	i64.load	$5=, 96($6)
	i32.const	$push64=, 80
	i32.add 	$push65=, $6, $pop64
	call    	__multf3@FUNCTION, $pop65, $5, $4, $1, $2
	i32.const	$push68=, 64
	i32.add 	$push69=, $6, $pop68
	i64.load	$push21=, 80($6)
	i32.const	$push66=, 80
	i32.add 	$push67=, $6, $pop66
	i32.const	$push89=, 8
	i32.add 	$push19=, $pop67, $pop89
	i64.load	$push20=, 0($pop19)
	call    	__addtf3@FUNCTION, $pop69, $5, $4, $pop21, $pop20
	i32.const	$push70=, 64
	i32.add 	$push71=, $6, $pop70
	i32.const	$push88=, 8
	i32.add 	$push22=, $pop71, $pop88
	i64.load	$4=, 0($pop22)
	i64.load	$5=, 64($6)
	i32.const	$push72=, 48
	i32.add 	$push73=, $6, $pop72
	call    	__multf3@FUNCTION, $pop73, $5, $4, $1, $2
	i32.const	$push76=, 32
	i32.add 	$push77=, $6, $pop76
	i64.load	$push25=, 48($6)
	i32.const	$push74=, 48
	i32.add 	$push75=, $6, $pop74
	i32.const	$push87=, 8
	i32.add 	$push23=, $pop75, $pop87
	i64.load	$push24=, 0($pop23)
	call    	__addtf3@FUNCTION, $pop77, $5, $4, $pop25, $pop24
	i32.const	$push78=, 32
	i32.add 	$push79=, $6, $pop78
	i32.const	$push86=, 8
	i32.add 	$push26=, $pop79, $pop86
	i64.load	$4=, 0($pop26)
	i64.load	$5=, 32($6)
	i32.const	$push80=, 16
	i32.add 	$push81=, $6, $pop80
	call    	__multf3@FUNCTION, $pop81, $5, $4, $1, $2
	i64.load	$push29=, 16($6)
	i32.const	$push82=, 16
	i32.add 	$push83=, $6, $pop82
	i32.const	$push85=, 8
	i32.add 	$push27=, $pop83, $pop85
	i64.load	$push28=, 0($pop27)
	call    	__addtf3@FUNCTION, $6, $5, $4, $pop29, $pop28
	i32.const	$push84=, 8
	i32.add 	$push30=, $6, $pop84
	i64.load	$push31=, 0($pop30)
	i64.store	8($0), $pop31
	i64.load	$push32=, 0($6)
	i64.store	0($0), $pop32
	i32.const	$push39=, 0
	i32.const	$push37=, 192
	i32.add 	$push38=, $6, $pop37
	i32.store	__stack_pointer($pop39), $pop38
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
