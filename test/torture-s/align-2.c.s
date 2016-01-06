	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/align-2.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB0_56
	i32.load8_u	$push0=, s_c_s($0)
	i32.const	$push1=, 97
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, BB0_56
# BB#1:                                 # %if.end
	block   	BB0_55
	i32.load16_u	$push3=, s_c_s+2($0)
	i32.const	$push4=, 13
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, BB0_55
# BB#2:                                 # %if.end6
	block   	BB0_54
	i32.load8_u	$push6=, s_c_i($0)
	i32.const	$push7=, 98
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, BB0_54
# BB#3:                                 # %if.end11
	block   	BB0_53
	i32.load	$push9=, s_c_i+4($0)
	i32.const	$push10=, 14
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	$pop11, BB0_53
# BB#4:                                 # %if.end15
	block   	BB0_52
	i32.load16_u	$push12=, s_s_i($0)
	i32.const	$push13=, 15
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	$pop14, BB0_52
# BB#5:                                 # %if.end20
	block   	BB0_51
	i32.load	$push15=, s_s_i+4($0)
	i32.const	$push16=, 16
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	$pop17, BB0_51
# BB#6:                                 # %if.end24
	block   	BB0_50
	i32.load8_u	$push18=, s_c_f($0)
	i32.const	$push19=, 99
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	$pop20, BB0_50
# BB#7:                                 # %if.end29
	block   	BB0_49
	f32.load	$push21=, s_c_f+4($0)
	f32.const	$push22=, 0x1.1p4
	f32.ne  	$push23=, $pop21, $pop22
	br_if   	$pop23, BB0_49
# BB#8:                                 # %if.end34
	block   	BB0_48
	i32.load16_u	$push24=, s_s_f($0)
	i32.const	$push25=, 18
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	$pop26, BB0_48
# BB#9:                                 # %if.end39
	block   	BB0_47
	f32.load	$push27=, s_s_f+4($0)
	f32.const	$push28=, 0x1.3p4
	f32.ne  	$push29=, $pop27, $pop28
	br_if   	$pop29, BB0_47
# BB#10:                                # %if.end44
	block   	BB0_46
	i32.load8_u	$push30=, s_c_d($0)
	i32.const	$push31=, 100
	i32.ne  	$push32=, $pop30, $pop31
	br_if   	$pop32, BB0_46
# BB#11:                                # %if.end49
	block   	BB0_45
	f64.load	$push33=, s_c_d+8($0)
	f64.const	$push34=, 0x1.4p4
	f64.ne  	$push35=, $pop33, $pop34
	br_if   	$pop35, BB0_45
# BB#12:                                # %if.end53
	block   	BB0_44
	i32.load16_u	$push36=, s_s_d($0)
	i32.const	$push37=, 21
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	$pop38, BB0_44
# BB#13:                                # %if.end58
	block   	BB0_43
	f64.load	$push39=, s_s_d+8($0)
	f64.const	$push40=, 0x1.6p4
	f64.ne  	$push41=, $pop39, $pop40
	br_if   	$pop41, BB0_43
# BB#14:                                # %if.end62
	block   	BB0_42
	i32.load	$push42=, s_i_d($0)
	i32.const	$push43=, 23
	i32.ne  	$push44=, $pop42, $pop43
	br_if   	$pop44, BB0_42
# BB#15:                                # %if.end66
	block   	BB0_41
	f64.load	$push45=, s_i_d+8($0)
	f64.const	$push46=, 0x1.8p4
	f64.ne  	$push47=, $pop45, $pop46
	br_if   	$pop47, BB0_41
# BB#16:                                # %if.end70
	block   	BB0_40
	f32.load	$push48=, s_f_d($0)
	f32.const	$push49=, 0x1.9p4
	f32.ne  	$push50=, $pop48, $pop49
	br_if   	$pop50, BB0_40
# BB#17:                                # %if.end75
	block   	BB0_39
	f64.load	$push51=, s_f_d+8($0)
	f64.const	$push52=, 0x1.ap4
	f64.ne  	$push53=, $pop51, $pop52
	br_if   	$pop53, BB0_39
# BB#18:                                # %if.end79
	block   	BB0_38
	i32.load8_u	$push54=, s_c_ld($0)
	i32.const	$push55=, 101
	i32.ne  	$push56=, $pop54, $pop55
	br_if   	$pop56, BB0_38
# BB#19:                                # %if.end84
	i64.const	$1=, 0
	block   	BB0_37
	i64.load	$push58=, s_c_ld+16($0)
	i64.load	$push57=, s_c_ld+24($0)
	i64.const	$push59=, 4612723957404008448
	i32.call	$push60=, __eqtf2, $pop58, $pop57, $1, $pop59
	br_if   	$pop60, BB0_37
# BB#20:                                # %if.end88
	block   	BB0_36
	i32.load16_u	$push61=, s_s_ld($0)
	i32.const	$push62=, 28
	i32.ne  	$push63=, $pop61, $pop62
	br_if   	$pop63, BB0_36
# BB#21:                                # %if.end93
	block   	BB0_35
	i64.load	$push65=, s_s_ld+16($0)
	i64.load	$push64=, s_s_ld+24($0)
	i64.const	$push66=, 4612759141776097280
	i32.call	$push67=, __eqtf2, $pop65, $pop64, $1, $pop66
	br_if   	$pop67, BB0_35
# BB#22:                                # %if.end97
	block   	BB0_34
	i32.load	$push68=, s_i_ld($0)
	i32.const	$push69=, 30
	i32.ne  	$push70=, $pop68, $pop69
	br_if   	$pop70, BB0_34
# BB#23:                                # %if.end101
	block   	BB0_33
	i64.load	$push72=, s_i_ld+16($0)
	i64.load	$push71=, s_i_ld+24($0)
	i64.const	$push73=, 4612794326148186112
	i32.call	$push74=, __eqtf2, $pop72, $pop71, $1, $pop73
	br_if   	$pop74, BB0_33
# BB#24:                                # %if.end105
	block   	BB0_32
	f32.load	$push75=, s_f_ld($0)
	f32.const	$push76=, 0x1p5
	f32.ne  	$push77=, $pop75, $pop76
	br_if   	$pop77, BB0_32
# BB#25:                                # %if.end110
	block   	BB0_31
	i64.load	$push79=, s_f_ld+16($0)
	i64.load	$push78=, s_f_ld+24($0)
	i64.const	$push80=, 4612820714427252736
	i32.call	$push81=, __eqtf2, $pop79, $pop78, $1, $pop80
	br_if   	$pop81, BB0_31
# BB#26:                                # %if.end114
	block   	BB0_30
	f64.load	$push82=, s_d_ld($0)
	f64.const	$push83=, 0x1.1p5
	f64.ne  	$push84=, $pop82, $pop83
	br_if   	$pop84, BB0_30
# BB#27:                                # %if.end118
	block   	BB0_29
	i64.load	$push86=, s_d_ld+16($0)
	i64.load	$push85=, s_d_ld+24($0)
	i64.const	$push87=, 4612838306613297152
	i32.call	$push88=, __eqtf2, $pop86, $pop85, $1, $pop87
	br_if   	$pop88, BB0_29
# BB#28:                                # %if.end122
	return  	$0
BB0_29:                                 # %if.then121
	call    	abort
	unreachable
BB0_30:                                 # %if.then117
	call    	abort
	unreachable
BB0_31:                                 # %if.then113
	call    	abort
	unreachable
BB0_32:                                 # %if.then109
	call    	abort
	unreachable
BB0_33:                                 # %if.then104
	call    	abort
	unreachable
BB0_34:                                 # %if.then100
	call    	abort
	unreachable
BB0_35:                                 # %if.then96
	call    	abort
	unreachable
BB0_36:                                 # %if.then92
	call    	abort
	unreachable
BB0_37:                                 # %if.then87
	call    	abort
	unreachable
BB0_38:                                 # %if.then83
	call    	abort
	unreachable
BB0_39:                                 # %if.then78
	call    	abort
	unreachable
BB0_40:                                 # %if.then74
	call    	abort
	unreachable
BB0_41:                                 # %if.then69
	call    	abort
	unreachable
BB0_42:                                 # %if.then65
	call    	abort
	unreachable
BB0_43:                                 # %if.then61
	call    	abort
	unreachable
BB0_44:                                 # %if.then57
	call    	abort
	unreachable
BB0_45:                                 # %if.then52
	call    	abort
	unreachable
BB0_46:                                 # %if.then48
	call    	abort
	unreachable
BB0_47:                                 # %if.then43
	call    	abort
	unreachable
BB0_48:                                 # %if.then38
	call    	abort
	unreachable
BB0_49:                                 # %if.then33
	call    	abort
	unreachable
BB0_50:                                 # %if.then28
	call    	abort
	unreachable
BB0_51:                                 # %if.then23
	call    	abort
	unreachable
BB0_52:                                 # %if.then19
	call    	abort
	unreachable
BB0_53:                                 # %if.then14
	call    	abort
	unreachable
BB0_54:                                 # %if.then10
	call    	abort
	unreachable
BB0_55:                                 # %if.then5
	call    	abort
	unreachable
BB0_56:                                 # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	s_c_s,@object           # @s_c_s
	.data
	.globl	s_c_s
	.align	1
s_c_s:
	.int8	97                      # 0x61
	.zero	1
	.int16	13                      # 0xd
	.size	s_c_s, 4

	.type	s_c_i,@object           # @s_c_i
	.globl	s_c_i
	.align	2
s_c_i:
	.int8	98                      # 0x62
	.zero	3
	.int32	14                      # 0xe
	.size	s_c_i, 8

	.type	s_s_i,@object           # @s_s_i
	.globl	s_s_i
	.align	2
s_s_i:
	.int16	15                      # 0xf
	.zero	2
	.int32	16                      # 0x10
	.size	s_s_i, 8

	.type	s_c_f,@object           # @s_c_f
	.globl	s_c_f
	.align	2
s_c_f:
	.int8	99                      # 0x63
	.zero	3
	.int32	1099431936              # float 17
	.size	s_c_f, 8

	.type	s_s_f,@object           # @s_s_f
	.globl	s_s_f
	.align	2
s_s_f:
	.int16	18                      # 0x12
	.zero	2
	.int32	1100480512              # float 19
	.size	s_s_f, 8

	.type	s_c_d,@object           # @s_c_d
	.globl	s_c_d
	.align	3
s_c_d:
	.int8	100                     # 0x64
	.zero	7
	.int64	4626322717216342016     # double 20
	.size	s_c_d, 16

	.type	s_s_d,@object           # @s_s_d
	.globl	s_s_d
	.align	3
s_s_d:
	.int16	21                      # 0x15
	.zero	6
	.int64	4626885667169763328     # double 22
	.size	s_s_d, 16

	.type	s_i_d,@object           # @s_i_d
	.globl	s_i_d
	.align	3
s_i_d:
	.int32	23                      # 0x17
	.zero	4
	.int64	4627448617123184640     # double 24
	.size	s_i_d, 16

	.type	s_f_d,@object           # @s_f_d
	.globl	s_f_d
	.align	3
s_f_d:
	.int32	1103626240              # float 25
	.zero	4
	.int64	4628011567076605952     # double 26
	.size	s_f_d, 16

	.type	s_c_ld,@object          # @s_c_ld
	.globl	s_c_ld
	.align	4
s_c_ld:
	.int8	101                     # 0x65
	.zero	15
	.int64	0                       # fp128 27
	.int64	4612723957404008448
	.size	s_c_ld, 32

	.type	s_s_ld,@object          # @s_s_ld
	.globl	s_s_ld
	.align	4
s_s_ld:
	.int16	28                      # 0x1c
	.zero	14
	.int64	0                       # fp128 29
	.int64	4612759141776097280
	.size	s_s_ld, 32

	.type	s_i_ld,@object          # @s_i_ld
	.globl	s_i_ld
	.align	4
s_i_ld:
	.int32	30                      # 0x1e
	.zero	12
	.int64	0                       # fp128 31
	.int64	4612794326148186112
	.size	s_i_ld, 32

	.type	s_f_ld,@object          # @s_f_ld
	.globl	s_f_ld
	.align	4
s_f_ld:
	.int32	1107296256              # float 32
	.zero	12
	.int64	0                       # fp128 33
	.int64	4612820714427252736
	.size	s_f_ld, 32

	.type	s_d_ld,@object          # @s_d_ld
	.globl	s_d_ld
	.align	4
s_d_ld:
	.int64	4629981891913580544     # double 34
	.zero	8
	.int64	0                       # fp128 35
	.int64	4612838306613297152
	.size	s_d_ld, 32


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
