	.text
	.file	"20020508-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i64, i64, i64, i32
# %bb.0:                                # %entry
	i32.const	$push2=, 0
	i32.load	$1=, shift1($pop2)
	i32.const	$push97=, 0
	i32.load8_u	$0=, uc($pop97)
	i32.const	$push4=, 8
	i32.sub 	$2=, $pop4, $1
	block   	
	i32.shl 	$push5=, $0, $2
	i32.shr_u	$push3=, $0, $1
	i32.or  	$push6=, $pop5, $pop3
	i32.const	$push96=, 835
	i32.ne  	$push7=, $pop6, $pop96
	br_if   	0, $pop7        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push8=, 4
	i32.shr_u	$push10=, $0, $pop8
	i32.const	$push99=, 4
	i32.shl 	$push9=, $0, $pop99
	i32.or  	$push11=, $pop10, $pop9
	i32.const	$push98=, 835
	i32.ne  	$push12=, $pop11, $pop98
	br_if   	0, $pop12       # 0: down to label0
# %bb.2:                                # %if.end11
	i32.const	$push13=, 16
	i32.sub 	$4=, $pop13, $1
	i32.const	$push14=, 0
	i32.load16_u	$3=, us($pop14)
	i32.shr_u	$push16=, $3, $1
	i32.shl 	$push15=, $3, $4
	i32.or  	$push17=, $pop16, $pop15
	i32.const	$push100=, 253972259
	i32.ne  	$push18=, $pop17, $pop100
	br_if   	0, $pop18       # 0: down to label0
# %bb.3:                                # %if.end21
	i32.const	$push21=, 4
	i32.shr_u	$push22=, $3, $pop21
	i32.const	$push19=, 12
	i32.shl 	$push20=, $3, $pop19
	i32.or  	$push23=, $pop22, $pop20
	i32.const	$push101=, 253972259
	i32.ne  	$push24=, $pop23, $pop101
	br_if   	0, $pop24       # 0: down to label0
# %bb.4:                                # %if.end30
	i32.const	$push26=, 0
	i32.load	$5=, ui($pop26)
	i32.rotr	$push27=, $5, $1
	i32.const	$push102=, 1073745699
	i32.ne  	$push28=, $pop27, $pop102
	br_if   	0, $pop28       # 0: down to label0
# %bb.5:                                # %if.end38
	i32.const	$push29=, 28
	i32.rotl	$push30=, $5, $pop29
	i32.const	$push103=, 1073745699
	i32.ne  	$push31=, $pop30, $pop103
	br_if   	0, $pop31       # 0: down to label0
# %bb.6:                                # %if.end45
	i32.const	$push25=, 32
	i32.sub 	$6=, $pop25, $1
	i32.const	$push32=, 0
	i32.load	$7=, ul($pop32)
	i32.shr_u	$push34=, $7, $1
	i32.shl 	$push33=, $7, $6
	i32.or  	$push35=, $pop34, $pop33
	i32.const	$push104=, -1893513881
	i32.ne  	$push36=, $pop35, $pop104
	br_if   	0, $pop36       # 0: down to label0
# %bb.7:                                # %if.end53
	i32.const	$push37=, 28
	i32.rotl	$push38=, $7, $pop37
	i32.const	$push105=, -1893513881
	i32.ne  	$push39=, $pop38, $pop105
	br_if   	0, $pop39       # 0: down to label0
# %bb.8:                                # %if.end60
	i64.extend_u/i32	$9=, $1
	i32.const	$push40=, 0
	i64.load	$8=, ull($pop40)
	i64.rotr	$push41=, $8, $9
	i64.const	$push106=, 68174490360335855
	i64.ne  	$push42=, $pop41, $pop106
	br_if   	0, $pop42       # 0: down to label0
# %bb.9:                                # %if.end69
	i64.const	$push45=, 60
	i64.rotl	$push46=, $8, $pop45
	i64.const	$push107=, 68174490360335855
	i64.ne  	$push47=, $pop46, $pop107
	br_if   	0, $pop47       # 0: down to label0
# %bb.10:                               # %if.end76
	i32.const	$push48=, 0
	i32.load	$11=, shift2($pop48)
	i64.extend_u/i32	$10=, $11
	i64.rotr	$push49=, $8, $10
	i64.const	$push108=, -994074541463572736
	i64.ne  	$push50=, $pop49, $pop108
	br_if   	0, $pop50       # 0: down to label0
# %bb.11:                               # %if.end86
	i64.const	$push53=, 4
	i64.rotl	$push54=, $8, $pop53
	i64.const	$push109=, -994074541463572736
	i64.ne  	$push55=, $pop54, $pop109
	br_if   	0, $pop55       # 0: down to label0
# %bb.12:                               # %if.end93
	i32.shr_u	$push57=, $0, $2
	i32.shl 	$push56=, $0, $1
	i32.or  	$push58=, $pop57, $pop56
	i32.const	$push59=, 835
	i32.ne  	$push60=, $pop58, $pop59
	br_if   	0, $pop60       # 0: down to label0
# %bb.13:                               # %if.end112
	i32.shl 	$push62=, $3, $1
	i32.shr_u	$push61=, $3, $4
	i32.or  	$push63=, $pop62, $pop61
	i32.const	$push110=, 992079
	i32.ne  	$push64=, $pop63, $pop110
	br_if   	0, $pop64       # 0: down to label0
# %bb.14:                               # %if.end122
	i32.const	$push67=, 4
	i32.shl 	$push68=, $3, $pop67
	i32.const	$push65=, 12
	i32.shr_u	$push66=, $3, $pop65
	i32.or  	$push69=, $pop68, $pop66
	i32.const	$push111=, 992079
	i32.ne  	$push70=, $pop69, $pop111
	br_if   	0, $pop70       # 0: down to label0
# %bb.15:                               # %if.end131
	i32.shl 	$push72=, $5, $1
	i32.shr_u	$push71=, $5, $6
	i32.or  	$push73=, $pop72, $pop71
	i32.const	$push112=, 992064
	i32.ne  	$push74=, $pop73, $pop112
	br_if   	0, $pop74       # 0: down to label0
# %bb.16:                               # %if.end139
	i32.const	$push75=, 4
	i32.rotl	$push76=, $5, $pop75
	i32.const	$push113=, 992064
	i32.ne  	$push77=, $pop76, $pop113
	br_if   	0, $pop77       # 0: down to label0
# %bb.17:                               # %if.end146
	i32.shl 	$push79=, $7, $1
	i32.shr_u	$push78=, $7, $6
	i32.or  	$push80=, $pop79, $pop78
	i32.const	$push114=, 591751055
	i32.ne  	$push81=, $pop80, $pop114
	br_if   	0, $pop81       # 0: down to label0
# %bb.18:                               # %if.end154
	i32.const	$push82=, 4
	i32.rotl	$push83=, $7, $pop82
	i32.const	$push115=, 591751055
	i32.ne  	$push84=, $pop83, $pop115
	br_if   	0, $pop84       # 0: down to label0
# %bb.19:                               # %if.end161
	i64.shl 	$push86=, $8, $9
	i32.const	$push43=, 64
	i32.sub 	$push44=, $pop43, $1
	i64.extend_u/i32	$push0=, $pop44
	i64.shr_u	$push85=, $8, $pop0
	i64.or  	$push87=, $pop86, $pop85
	i64.const	$push88=, -994074541463572736
	i64.ne  	$push89=, $pop87, $pop88
	br_if   	0, $pop89       # 0: down to label0
# %bb.20:                               # %if.end178
	i32.const	$push51=, 64
	i32.sub 	$push52=, $pop51, $11
	i64.extend_u/i32	$push1=, $pop52
	i64.shr_u	$push91=, $8, $pop1
	i64.shl 	$push90=, $8, $10
	i64.or  	$push92=, $pop91, $pop90
	i64.const	$push93=, 68174490360335855
	i64.ne  	$push94=, $pop92, $pop93
	br_if   	0, $pop94       # 0: down to label0
# %bb.21:                               # %if.end195
	i32.const	$push95=, 0
	call    	exit@FUNCTION, $pop95
	unreachable
.LBB0_22:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	uc                      # @uc
	.type	uc,@object
	.section	.data.uc,"aw",@progbits
	.globl	uc
uc:
	.int8	52                      # 0x34
	.size	uc, 1

	.hidden	us                      # @us
	.type	us,@object
	.section	.data.us,"aw",@progbits
	.globl	us
	.p2align	1
us:
	.int16	62004                   # 0xf234
	.size	us, 2

	.hidden	ui                      # @ui
	.type	ui,@object
	.section	.data.ui,"aw",@progbits
	.globl	ui
	.p2align	2
ui:
	.int32	62004                   # 0xf234
	.size	ui, 4

	.hidden	ul                      # @ul
	.type	ul,@object
	.section	.data.ul,"aw",@progbits
	.globl	ul
	.p2align	2
ul:
	.int32	4063516280              # 0xf2345678
	.size	ul, 4

	.hidden	ull                     # @ull
	.type	ull,@object
	.section	.data.ull,"aw",@progbits
	.globl	ull
	.p2align	3
ull:
	.int64	1090791845765373680     # 0xf2345678abcdef0
	.size	ull, 8

	.hidden	shift1                  # @shift1
	.type	shift1,@object
	.section	.data.shift1,"aw",@progbits
	.globl	shift1
	.p2align	2
shift1:
	.int32	4                       # 0x4
	.size	shift1, 4

	.hidden	shift2                  # @shift2
	.type	shift2,@object
	.section	.data.shift2,"aw",@progbits
	.globl	shift2
	.p2align	2
shift2:
	.int32	60                      # 0x3c
	.size	shift2, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
