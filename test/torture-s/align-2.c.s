	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/align-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push95=, 0
	i32.load8_u	$push0=, s_c_s($pop95):p2align=1
	i32.const	$push1=, 97
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label27
# BB#1:                                 # %if.end
	i32.const	$push96=, 0
	i32.load16_u	$push3=, s_c_s+2($pop96)
	i32.const	$push4=, 13
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label26
# BB#2:                                 # %if.end6
	i32.const	$push97=, 0
	i32.load8_u	$push6=, s_c_i($pop97):p2align=2
	i32.const	$push7=, 98
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	2, $pop8        # 2: down to label25
# BB#3:                                 # %if.end11
	i32.const	$push98=, 0
	i32.load	$push9=, s_c_i+4($pop98)
	i32.const	$push10=, 14
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	3, $pop11       # 3: down to label24
# BB#4:                                 # %if.end15
	i32.const	$push99=, 0
	i32.load16_u	$push12=, s_s_i($pop99):p2align=2
	i32.const	$push13=, 15
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	4, $pop14       # 4: down to label23
# BB#5:                                 # %if.end20
	i32.const	$push100=, 0
	i32.load	$push15=, s_s_i+4($pop100)
	i32.const	$push16=, 16
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	5, $pop17       # 5: down to label22
# BB#6:                                 # %if.end24
	i32.const	$push101=, 0
	i32.load8_u	$push18=, s_c_f($pop101):p2align=2
	i32.const	$push19=, 99
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	6, $pop20       # 6: down to label21
# BB#7:                                 # %if.end29
	i32.const	$push102=, 0
	f32.load	$push21=, s_c_f+4($pop102)
	f32.const	$push22=, 0x1.1p4
	f32.ne  	$push23=, $pop21, $pop22
	br_if   	7, $pop23       # 7: down to label20
# BB#8:                                 # %if.end34
	i32.const	$push103=, 0
	i32.load16_u	$push24=, s_s_f($pop103):p2align=2
	i32.const	$push25=, 18
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	8, $pop26       # 8: down to label19
# BB#9:                                 # %if.end39
	i32.const	$push104=, 0
	f32.load	$push27=, s_s_f+4($pop104)
	f32.const	$push28=, 0x1.3p4
	f32.ne  	$push29=, $pop27, $pop28
	br_if   	9, $pop29       # 9: down to label18
# BB#10:                                # %if.end44
	i32.const	$push105=, 0
	i32.load8_u	$push30=, s_c_d($pop105):p2align=3
	i32.const	$push31=, 100
	i32.ne  	$push32=, $pop30, $pop31
	br_if   	10, $pop32      # 10: down to label17
# BB#11:                                # %if.end49
	i32.const	$push106=, 0
	f64.load	$push33=, s_c_d+8($pop106)
	f64.const	$push34=, 0x1.4p4
	f64.ne  	$push35=, $pop33, $pop34
	br_if   	11, $pop35      # 11: down to label16
# BB#12:                                # %if.end53
	i32.const	$push107=, 0
	i32.load16_u	$push36=, s_s_d($pop107):p2align=3
	i32.const	$push37=, 21
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	12, $pop38      # 12: down to label15
# BB#13:                                # %if.end58
	i32.const	$push108=, 0
	f64.load	$push39=, s_s_d+8($pop108)
	f64.const	$push40=, 0x1.6p4
	f64.ne  	$push41=, $pop39, $pop40
	br_if   	13, $pop41      # 13: down to label14
# BB#14:                                # %if.end62
	i32.const	$push109=, 0
	i32.load	$push42=, s_i_d($pop109):p2align=3
	i32.const	$push43=, 23
	i32.ne  	$push44=, $pop42, $pop43
	br_if   	14, $pop44      # 14: down to label13
# BB#15:                                # %if.end66
	i32.const	$push110=, 0
	f64.load	$push45=, s_i_d+8($pop110)
	f64.const	$push46=, 0x1.8p4
	f64.ne  	$push47=, $pop45, $pop46
	br_if   	15, $pop47      # 15: down to label12
# BB#16:                                # %if.end70
	i32.const	$push111=, 0
	f32.load	$push48=, s_f_d($pop111):p2align=3
	f32.const	$push49=, 0x1.9p4
	f32.ne  	$push50=, $pop48, $pop49
	br_if   	16, $pop50      # 16: down to label11
# BB#17:                                # %if.end75
	i32.const	$push112=, 0
	f64.load	$push51=, s_f_d+8($pop112)
	f64.const	$push52=, 0x1.ap4
	f64.ne  	$push53=, $pop51, $pop52
	br_if   	17, $pop53      # 17: down to label10
# BB#18:                                # %if.end79
	i32.const	$push113=, 0
	i32.load8_u	$push54=, s_c_ld($pop113):p2align=4
	i32.const	$push55=, 101
	i32.ne  	$push56=, $pop54, $pop55
	br_if   	18, $pop56      # 18: down to label9
# BB#19:                                # %if.end84
	i32.const	$push115=, 0
	i64.load	$push58=, s_c_ld+16($pop115):p2align=4
	i32.const	$push114=, 0
	i64.load	$push57=, s_c_ld+24($pop114)
	i64.const	$push60=, 0
	i64.const	$push59=, 4612723957404008448
	i32.call	$push61=, __eqtf2@FUNCTION, $pop58, $pop57, $pop60, $pop59
	br_if   	19, $pop61      # 19: down to label8
# BB#20:                                # %if.end88
	i32.const	$push116=, 0
	i32.load16_u	$push62=, s_s_ld($pop116):p2align=4
	i32.const	$push63=, 28
	i32.ne  	$push64=, $pop62, $pop63
	br_if   	20, $pop64      # 20: down to label7
# BB#21:                                # %if.end93
	i32.const	$push118=, 0
	i64.load	$push66=, s_s_ld+16($pop118):p2align=4
	i32.const	$push117=, 0
	i64.load	$push65=, s_s_ld+24($pop117)
	i64.const	$push68=, 0
	i64.const	$push67=, 4612759141776097280
	i32.call	$push69=, __eqtf2@FUNCTION, $pop66, $pop65, $pop68, $pop67
	br_if   	21, $pop69      # 21: down to label6
# BB#22:                                # %if.end97
	i32.const	$push119=, 0
	i32.load	$push70=, s_i_ld($pop119):p2align=4
	i32.const	$push71=, 30
	i32.ne  	$push72=, $pop70, $pop71
	br_if   	22, $pop72      # 22: down to label5
# BB#23:                                # %if.end101
	i32.const	$push121=, 0
	i64.load	$push74=, s_i_ld+16($pop121):p2align=4
	i32.const	$push120=, 0
	i64.load	$push73=, s_i_ld+24($pop120)
	i64.const	$push76=, 0
	i64.const	$push75=, 4612794326148186112
	i32.call	$push77=, __eqtf2@FUNCTION, $pop74, $pop73, $pop76, $pop75
	br_if   	23, $pop77      # 23: down to label4
# BB#24:                                # %if.end105
	i32.const	$push122=, 0
	f32.load	$push78=, s_f_ld($pop122):p2align=4
	f32.const	$push79=, 0x1p5
	f32.ne  	$push80=, $pop78, $pop79
	br_if   	24, $pop80      # 24: down to label3
# BB#25:                                # %if.end110
	i32.const	$push124=, 0
	i64.load	$push82=, s_f_ld+16($pop124):p2align=4
	i32.const	$push123=, 0
	i64.load	$push81=, s_f_ld+24($pop123)
	i64.const	$push84=, 0
	i64.const	$push83=, 4612820714427252736
	i32.call	$push85=, __eqtf2@FUNCTION, $pop82, $pop81, $pop84, $pop83
	br_if   	25, $pop85      # 25: down to label2
# BB#26:                                # %if.end114
	i32.const	$push125=, 0
	f64.load	$push86=, s_d_ld($pop125):p2align=4
	f64.const	$push87=, 0x1.1p5
	f64.ne  	$push88=, $pop86, $pop87
	br_if   	26, $pop88      # 26: down to label1
# BB#27:                                # %if.end118
	i32.const	$push127=, 0
	i64.load	$push90=, s_d_ld+16($pop127):p2align=4
	i32.const	$push126=, 0
	i64.load	$push89=, s_d_ld+24($pop126)
	i64.const	$push92=, 0
	i64.const	$push91=, 4612838306613297152
	i32.call	$push93=, __eqtf2@FUNCTION, $pop90, $pop89, $pop92, $pop91
	br_if   	27, $pop93      # 27: down to label0
# BB#28:                                # %if.end122
	i32.const	$push94=, 0
	return  	$pop94
.LBB0_29:                               # %if.then
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
.LBB0_30:                               # %if.then5
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
.LBB0_31:                               # %if.then10
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
.LBB0_32:                               # %if.then14
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
.LBB0_33:                               # %if.then19
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
.LBB0_34:                               # %if.then23
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
.LBB0_35:                               # %if.then28
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
.LBB0_36:                               # %if.then33
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB0_37:                               # %if.then38
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB0_38:                               # %if.then43
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB0_39:                               # %if.then48
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB0_40:                               # %if.then52
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB0_41:                               # %if.then57
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB0_42:                               # %if.then61
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB0_43:                               # %if.then65
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB0_44:                               # %if.then69
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB0_45:                               # %if.then74
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB0_46:                               # %if.then78
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB0_47:                               # %if.then83
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_48:                               # %if.then87
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_49:                               # %if.then92
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_50:                               # %if.then96
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_51:                               # %if.then100
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_52:                               # %if.then104
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_53:                               # %if.then109
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_54:                               # %if.then113
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_55:                               # %if.then117
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_56:                               # %if.then121
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

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


	.ident	"clang version 3.9.0 "
