	.text
	.file	"align-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push95=, 0
	i32.load8_u	$push0=, s_c_s($pop95)
	i32.const	$push1=, 97
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push96=, 0
	i32.load16_u	$push3=, s_c_s+2($pop96)
	i32.const	$push4=, 13
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.2:                                # %if.end6
	i32.const	$push97=, 0
	i32.load8_u	$push6=, s_c_i($pop97)
	i32.const	$push7=, 98
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.3:                                # %if.end11
	i32.const	$push98=, 0
	i32.load	$push9=, s_c_i+4($pop98)
	i32.const	$push10=, 14
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.4:                                # %if.end15
	i32.const	$push99=, 0
	i32.load16_u	$push12=, s_s_i($pop99)
	i32.const	$push13=, 15
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# %bb.5:                                # %if.end20
	i32.const	$push100=, 0
	i32.load	$push15=, s_s_i+4($pop100)
	i32.const	$push16=, 16
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# %bb.6:                                # %if.end24
	i32.const	$push101=, 0
	i32.load8_u	$push18=, s_c_f($pop101)
	i32.const	$push19=, 99
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label0
# %bb.7:                                # %if.end29
	i32.const	$push102=, 0
	f32.load	$push21=, s_c_f+4($pop102)
	f32.const	$push22=, 0x1.1p4
	f32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# %bb.8:                                # %if.end34
	i32.const	$push103=, 0
	i32.load16_u	$push24=, s_s_f($pop103)
	i32.const	$push25=, 18
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label0
# %bb.9:                                # %if.end39
	i32.const	$push104=, 0
	f32.load	$push27=, s_s_f+4($pop104)
	f32.const	$push28=, 0x1.3p4
	f32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label0
# %bb.10:                               # %if.end44
	i32.const	$push105=, 0
	i32.load8_u	$push30=, s_c_d($pop105)
	i32.const	$push31=, 100
	i32.ne  	$push32=, $pop30, $pop31
	br_if   	0, $pop32       # 0: down to label0
# %bb.11:                               # %if.end49
	i32.const	$push106=, 0
	f64.load	$push33=, s_c_d+8($pop106)
	f64.const	$push34=, 0x1.4p4
	f64.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label0
# %bb.12:                               # %if.end53
	i32.const	$push107=, 0
	i32.load16_u	$push36=, s_s_d($pop107)
	i32.const	$push37=, 21
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	0, $pop38       # 0: down to label0
# %bb.13:                               # %if.end58
	i32.const	$push108=, 0
	f64.load	$push39=, s_s_d+8($pop108)
	f64.const	$push40=, 0x1.6p4
	f64.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label0
# %bb.14:                               # %if.end62
	i32.const	$push109=, 0
	i32.load	$push42=, s_i_d($pop109)
	i32.const	$push43=, 23
	i32.ne  	$push44=, $pop42, $pop43
	br_if   	0, $pop44       # 0: down to label0
# %bb.15:                               # %if.end66
	i32.const	$push110=, 0
	f64.load	$push45=, s_i_d+8($pop110)
	f64.const	$push46=, 0x1.8p4
	f64.ne  	$push47=, $pop45, $pop46
	br_if   	0, $pop47       # 0: down to label0
# %bb.16:                               # %if.end70
	i32.const	$push111=, 0
	f32.load	$push48=, s_f_d($pop111)
	f32.const	$push49=, 0x1.9p4
	f32.ne  	$push50=, $pop48, $pop49
	br_if   	0, $pop50       # 0: down to label0
# %bb.17:                               # %if.end75
	i32.const	$push112=, 0
	f64.load	$push51=, s_f_d+8($pop112)
	f64.const	$push52=, 0x1.ap4
	f64.ne  	$push53=, $pop51, $pop52
	br_if   	0, $pop53       # 0: down to label0
# %bb.18:                               # %if.end79
	i32.const	$push113=, 0
	i32.load8_u	$push54=, s_c_ld($pop113)
	i32.const	$push55=, 101
	i32.ne  	$push56=, $pop54, $pop55
	br_if   	0, $pop56       # 0: down to label0
# %bb.19:                               # %if.end84
	i32.const	$push115=, 0
	i64.load	$push58=, s_c_ld+16($pop115)
	i32.const	$push114=, 0
	i64.load	$push57=, s_c_ld+24($pop114)
	i64.const	$push60=, 0
	i64.const	$push59=, 4612723957404008448
	i32.call	$push61=, __eqtf2@FUNCTION, $pop58, $pop57, $pop60, $pop59
	br_if   	0, $pop61       # 0: down to label0
# %bb.20:                               # %if.end88
	i32.const	$push116=, 0
	i32.load16_u	$push62=, s_s_ld($pop116)
	i32.const	$push63=, 28
	i32.ne  	$push64=, $pop62, $pop63
	br_if   	0, $pop64       # 0: down to label0
# %bb.21:                               # %if.end93
	i32.const	$push118=, 0
	i64.load	$push66=, s_s_ld+16($pop118)
	i32.const	$push117=, 0
	i64.load	$push65=, s_s_ld+24($pop117)
	i64.const	$push68=, 0
	i64.const	$push67=, 4612759141776097280
	i32.call	$push69=, __eqtf2@FUNCTION, $pop66, $pop65, $pop68, $pop67
	br_if   	0, $pop69       # 0: down to label0
# %bb.22:                               # %if.end97
	i32.const	$push119=, 0
	i32.load	$push70=, s_i_ld($pop119)
	i32.const	$push71=, 30
	i32.ne  	$push72=, $pop70, $pop71
	br_if   	0, $pop72       # 0: down to label0
# %bb.23:                               # %if.end101
	i32.const	$push121=, 0
	i64.load	$push74=, s_i_ld+16($pop121)
	i32.const	$push120=, 0
	i64.load	$push73=, s_i_ld+24($pop120)
	i64.const	$push76=, 0
	i64.const	$push75=, 4612794326148186112
	i32.call	$push77=, __eqtf2@FUNCTION, $pop74, $pop73, $pop76, $pop75
	br_if   	0, $pop77       # 0: down to label0
# %bb.24:                               # %if.end105
	i32.const	$push122=, 0
	f32.load	$push78=, s_f_ld($pop122)
	f32.const	$push79=, 0x1p5
	f32.ne  	$push80=, $pop78, $pop79
	br_if   	0, $pop80       # 0: down to label0
# %bb.25:                               # %if.end110
	i32.const	$push124=, 0
	i64.load	$push82=, s_f_ld+16($pop124)
	i32.const	$push123=, 0
	i64.load	$push81=, s_f_ld+24($pop123)
	i64.const	$push84=, 0
	i64.const	$push83=, 4612820714427252736
	i32.call	$push85=, __eqtf2@FUNCTION, $pop82, $pop81, $pop84, $pop83
	br_if   	0, $pop85       # 0: down to label0
# %bb.26:                               # %if.end114
	i32.const	$push125=, 0
	f64.load	$push86=, s_d_ld($pop125)
	f64.const	$push87=, 0x1.1p5
	f64.ne  	$push88=, $pop86, $pop87
	br_if   	0, $pop88       # 0: down to label0
# %bb.27:                               # %if.end118
	i32.const	$push127=, 0
	i64.load	$push90=, s_d_ld+16($pop127)
	i32.const	$push126=, 0
	i64.load	$push89=, s_d_ld+24($pop126)
	i64.const	$push92=, 0
	i64.const	$push91=, 4612838306613297152
	i32.call	$push93=, __eqtf2@FUNCTION, $pop90, $pop89, $pop92, $pop91
	br_if   	0, $pop93       # 0: down to label0
# %bb.28:                               # %if.end122
	i32.const	$push94=, 0
	return  	$pop94
.LBB0_29:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	s_c_s                   # @s_c_s
	.type	s_c_s,@object
	.section	.data.s_c_s,"aw",@progbits
	.globl	s_c_s
	.p2align	1
s_c_s:
	.int8	97                      # 0x61
	.skip	1
	.int16	13                      # 0xd
	.size	s_c_s, 4

	.hidden	s_c_i                   # @s_c_i
	.type	s_c_i,@object
	.section	.data.s_c_i,"aw",@progbits
	.globl	s_c_i
	.p2align	2
s_c_i:
	.int8	98                      # 0x62
	.skip	3
	.int32	14                      # 0xe
	.size	s_c_i, 8

	.hidden	s_s_i                   # @s_s_i
	.type	s_s_i,@object
	.section	.data.s_s_i,"aw",@progbits
	.globl	s_s_i
	.p2align	2
s_s_i:
	.int16	15                      # 0xf
	.skip	2
	.int32	16                      # 0x10
	.size	s_s_i, 8

	.hidden	s_c_f                   # @s_c_f
	.type	s_c_f,@object
	.section	.data.s_c_f,"aw",@progbits
	.globl	s_c_f
	.p2align	2
s_c_f:
	.int8	99                      # 0x63
	.skip	3
	.int32	1099431936              # float 17
	.size	s_c_f, 8

	.hidden	s_s_f                   # @s_s_f
	.type	s_s_f,@object
	.section	.data.s_s_f,"aw",@progbits
	.globl	s_s_f
	.p2align	2
s_s_f:
	.int16	18                      # 0x12
	.skip	2
	.int32	1100480512              # float 19
	.size	s_s_f, 8

	.hidden	s_c_d                   # @s_c_d
	.type	s_c_d,@object
	.section	.data.s_c_d,"aw",@progbits
	.globl	s_c_d
	.p2align	3
s_c_d:
	.int8	100                     # 0x64
	.skip	7
	.int64	4626322717216342016     # double 20
	.size	s_c_d, 16

	.hidden	s_s_d                   # @s_s_d
	.type	s_s_d,@object
	.section	.data.s_s_d,"aw",@progbits
	.globl	s_s_d
	.p2align	3
s_s_d:
	.int16	21                      # 0x15
	.skip	6
	.int64	4626885667169763328     # double 22
	.size	s_s_d, 16

	.hidden	s_i_d                   # @s_i_d
	.type	s_i_d,@object
	.section	.data.s_i_d,"aw",@progbits
	.globl	s_i_d
	.p2align	3
s_i_d:
	.int32	23                      # 0x17
	.skip	4
	.int64	4627448617123184640     # double 24
	.size	s_i_d, 16

	.hidden	s_f_d                   # @s_f_d
	.type	s_f_d,@object
	.section	.data.s_f_d,"aw",@progbits
	.globl	s_f_d
	.p2align	3
s_f_d:
	.int32	1103626240              # float 25
	.skip	4
	.int64	4628011567076605952     # double 26
	.size	s_f_d, 16

	.hidden	s_c_ld                  # @s_c_ld
	.type	s_c_ld,@object
	.section	.data.s_c_ld,"aw",@progbits
	.globl	s_c_ld
	.p2align	4
s_c_ld:
	.int8	101                     # 0x65
	.skip	15
	.int64	0                       # fp128 27
	.int64	4612723957404008448
	.size	s_c_ld, 32

	.hidden	s_s_ld                  # @s_s_ld
	.type	s_s_ld,@object
	.section	.data.s_s_ld,"aw",@progbits
	.globl	s_s_ld
	.p2align	4
s_s_ld:
	.int16	28                      # 0x1c
	.skip	14
	.int64	0                       # fp128 29
	.int64	4612759141776097280
	.size	s_s_ld, 32

	.hidden	s_i_ld                  # @s_i_ld
	.type	s_i_ld,@object
	.section	.data.s_i_ld,"aw",@progbits
	.globl	s_i_ld
	.p2align	4
s_i_ld:
	.int32	30                      # 0x1e
	.skip	12
	.int64	0                       # fp128 31
	.int64	4612794326148186112
	.size	s_i_ld, 32

	.hidden	s_f_ld                  # @s_f_ld
	.type	s_f_ld,@object
	.section	.data.s_f_ld,"aw",@progbits
	.globl	s_f_ld
	.p2align	4
s_f_ld:
	.int32	1107296256              # float 32
	.skip	12
	.int64	0                       # fp128 33
	.int64	4612820714427252736
	.size	s_f_ld, 32

	.hidden	s_d_ld                  # @s_d_ld
	.type	s_d_ld,@object
	.section	.data.s_d_ld,"aw",@progbits
	.globl	s_d_ld
	.p2align	4
s_d_ld:
	.int64	4629981891913580544     # double 34
	.skip	8
	.int64	0                       # fp128 35
	.int64	4612838306613297152
	.size	s_d_ld, 32


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
