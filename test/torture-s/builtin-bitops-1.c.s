	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-bitops-1.c"
	.section	.text.my_ffs,"ax",@progbits
	.hidden	my_ffs
	.globl	my_ffs
	.type	my_ffs,@function
my_ffs:                                 # @my_ffs
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	i32.const	$push7=, 0
	i32.eq  	$push8=, $0, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push4=, 1
	i32.shl 	$push0=, $pop4, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label2
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push6=, 1
	i32.add 	$1=, $1, $pop6
	i32.const	$push5=, 32
	i32.lt_u	$push2=, $1, $pop5
	br_if   	0, $pop2        # 0: up to label1
.LBB0_4:                                # %for.end
	end_loop                        # label2:
	i32.const	$push3=, 1
	i32.add 	$1=, $1, $pop3
.LBB0_5:                                # %cleanup
	end_block                       # label0:
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	my_ffs, .Lfunc_end0-my_ffs

	.section	.text.my_ctz,"ax",@progbits
	.hidden	my_ctz
	.globl	my_ctz
	.type	my_ctz,@function
my_ctz:                                 # @my_ctz
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push3=, 1
	i32.shl 	$push0=, $pop3, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label4
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push5=, 1
	i32.add 	$1=, $1, $pop5
	i32.const	$push4=, 32
	i32.lt_u	$push2=, $1, $pop4
	br_if   	0, $pop2        # 0: up to label3
.LBB1_3:                                # %for.end
	end_loop                        # label4:
	return  	$1
	.endfunc
.Lfunc_end1:
	.size	my_ctz, .Lfunc_end1-my_ctz

	.section	.text.my_clz,"ax",@progbits
	.hidden	my_clz
	.globl	my_clz
	.type	my_clz,@function
my_clz:                                 # @my_clz
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$1=, 31
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label5:
	i32.const	$push3=, 1
	i32.shl 	$push0=, $pop3, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label6
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push6=, 1
	i32.add 	$2=, $2, $pop6
	i32.const	$push5=, -1
	i32.add 	$1=, $1, $pop5
	i32.const	$push4=, 32
	i32.lt_u	$push2=, $2, $pop4
	br_if   	0, $pop2        # 0: up to label5
.LBB2_3:                                # %for.end
	end_loop                        # label6:
	return  	$2
	.endfunc
.Lfunc_end2:
	.size	my_clz, .Lfunc_end2-my_clz

	.section	.text.my_clrsb,"ax",@progbits
	.hidden	my_clrsb
	.globl	my_clrsb
	.type	my_clrsb,@function
my_clrsb:                               # @my_clrsb
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.shr_u	$1=, $0, $pop0
	i32.const	$2=, 30
	i32.const	$3=, 1
.LBB3_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.shr_u	$push1=, $0, $2
	i32.const	$push7=, 1
	i32.and 	$push2=, $pop1, $pop7
	i32.ne  	$push3=, $pop2, $1
	br_if   	1, $pop3        # 1: down to label8
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$push10=, 1
	i32.add 	$3=, $3, $pop10
	i32.const	$push9=, -1
	i32.add 	$2=, $2, $pop9
	i32.const	$push8=, 32
	i32.lt_u	$push4=, $3, $pop8
	br_if   	0, $pop4        # 0: up to label7
.LBB3_3:                                # %for.end
	end_loop                        # label8:
	i32.const	$push5=, -1
	i32.add 	$push6=, $3, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end3:
	.size	my_clrsb, .Lfunc_end3-my_clrsb

	.section	.text.my_popcount,"ax",@progbits
	.hidden	my_popcount
	.globl	my_popcount
	.type	my_popcount,@function
my_popcount:                            # @my_popcount
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$2=, 0
.LBB4_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label9:
	i32.const	$push7=, 1
	i32.shl 	$push0=, $pop7, $2
	i32.and 	$push1=, $pop0, $0
	i32.const	$push6=, 0
	i32.ne  	$push2=, $pop1, $pop6
	i32.add 	$1=, $pop2, $1
	i32.const	$push5=, 1
	i32.add 	$2=, $2, $pop5
	i32.const	$push4=, 32
	i32.ne  	$push3=, $2, $pop4
	br_if   	0, $pop3        # 0: up to label9
# BB#2:                                 # %for.end
	end_loop                        # label10:
	return  	$1
	.endfunc
.Lfunc_end4:
	.size	my_popcount, .Lfunc_end4-my_popcount

	.section	.text.my_parity,"ax",@progbits
	.hidden	my_parity
	.globl	my_parity
	.type	my_parity,@function
my_parity:                              # @my_parity
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$2=, 0
.LBB5_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label11:
	i32.const	$push9=, 1
	i32.shl 	$push0=, $pop9, $2
	i32.and 	$push1=, $pop0, $0
	i32.const	$push8=, 0
	i32.ne  	$push2=, $pop1, $pop8
	i32.add 	$1=, $pop2, $1
	i32.const	$push7=, 1
	i32.add 	$2=, $2, $pop7
	i32.const	$push6=, 32
	i32.ne  	$push3=, $2, $pop6
	br_if   	0, $pop3        # 0: up to label11
# BB#2:                                 # %for.end
	end_loop                        # label12:
	i32.const	$push4=, 1
	i32.and 	$push5=, $1, $pop4
	return  	$pop5
	.endfunc
.Lfunc_end5:
	.size	my_parity, .Lfunc_end5-my_parity

	.section	.text.my_ffsl,"ax",@progbits
	.hidden	my_ffsl
	.globl	my_ffsl
	.type	my_ffsl,@function
my_ffsl:                                # @my_ffsl
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	i32.const	$push7=, 0
	i32.eq  	$push8=, $0, $pop7
	br_if   	0, $pop8        # 0: down to label13
# BB#1:                                 # %for.body.preheader
	i32.const	$1=, 0
.LBB6_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label14:
	i32.const	$push4=, 1
	i32.shl 	$push0=, $pop4, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label15
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB6_2 Depth=1
	i32.const	$push6=, 1
	i32.add 	$1=, $1, $pop6
	i32.const	$push5=, 32
	i32.lt_u	$push2=, $1, $pop5
	br_if   	0, $pop2        # 0: up to label14
.LBB6_4:                                # %for.end
	end_loop                        # label15:
	i32.const	$push3=, 1
	i32.add 	$1=, $1, $pop3
.LBB6_5:                                # %cleanup
	end_block                       # label13:
	return  	$1
	.endfunc
.Lfunc_end6:
	.size	my_ffsl, .Lfunc_end6-my_ffsl

	.section	.text.my_ctzl,"ax",@progbits
	.hidden	my_ctzl
	.globl	my_ctzl
	.type	my_ctzl,@function
my_ctzl:                                # @my_ctzl
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
.LBB7_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	i32.const	$push3=, 1
	i32.shl 	$push0=, $pop3, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label17
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.const	$push5=, 1
	i32.add 	$1=, $1, $pop5
	i32.const	$push4=, 32
	i32.lt_u	$push2=, $1, $pop4
	br_if   	0, $pop2        # 0: up to label16
.LBB7_3:                                # %for.end
	end_loop                        # label17:
	return  	$1
	.endfunc
.Lfunc_end7:
	.size	my_ctzl, .Lfunc_end7-my_ctzl

	.section	.text.my_clzl,"ax",@progbits
	.hidden	my_clzl
	.globl	my_clzl
	.type	my_clzl,@function
my_clzl:                                # @my_clzl
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$1=, 31
.LBB8_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label18:
	i32.const	$push3=, 1
	i32.shl 	$push0=, $pop3, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label19
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.const	$push6=, 1
	i32.add 	$2=, $2, $pop6
	i32.const	$push5=, -1
	i32.add 	$1=, $1, $pop5
	i32.const	$push4=, 32
	i32.lt_u	$push2=, $2, $pop4
	br_if   	0, $pop2        # 0: up to label18
.LBB8_3:                                # %for.end
	end_loop                        # label19:
	return  	$2
	.endfunc
.Lfunc_end8:
	.size	my_clzl, .Lfunc_end8-my_clzl

	.section	.text.my_clrsbl,"ax",@progbits
	.hidden	my_clrsbl
	.globl	my_clrsbl
	.type	my_clrsbl,@function
my_clrsbl:                              # @my_clrsbl
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.shr_u	$1=, $0, $pop0
	i32.const	$2=, 30
	i32.const	$3=, 1
.LBB9_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label20:
	i32.shr_u	$push1=, $0, $2
	i32.const	$push7=, 1
	i32.and 	$push2=, $pop1, $pop7
	i32.ne  	$push3=, $pop2, $1
	br_if   	1, $pop3        # 1: down to label21
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.const	$push10=, 1
	i32.add 	$3=, $3, $pop10
	i32.const	$push9=, -1
	i32.add 	$2=, $2, $pop9
	i32.const	$push8=, 32
	i32.lt_u	$push4=, $3, $pop8
	br_if   	0, $pop4        # 0: up to label20
.LBB9_3:                                # %for.end
	end_loop                        # label21:
	i32.const	$push5=, -1
	i32.add 	$push6=, $3, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end9:
	.size	my_clrsbl, .Lfunc_end9-my_clrsbl

	.section	.text.my_popcountl,"ax",@progbits
	.hidden	my_popcountl
	.globl	my_popcountl
	.type	my_popcountl,@function
my_popcountl:                           # @my_popcountl
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$2=, 0
.LBB10_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label22:
	i32.const	$push7=, 1
	i32.shl 	$push0=, $pop7, $2
	i32.and 	$push1=, $pop0, $0
	i32.const	$push6=, 0
	i32.ne  	$push2=, $pop1, $pop6
	i32.add 	$1=, $pop2, $1
	i32.const	$push5=, 1
	i32.add 	$2=, $2, $pop5
	i32.const	$push4=, 32
	i32.ne  	$push3=, $2, $pop4
	br_if   	0, $pop3        # 0: up to label22
# BB#2:                                 # %for.end
	end_loop                        # label23:
	return  	$1
	.endfunc
.Lfunc_end10:
	.size	my_popcountl, .Lfunc_end10-my_popcountl

	.section	.text.my_parityl,"ax",@progbits
	.hidden	my_parityl
	.globl	my_parityl
	.type	my_parityl,@function
my_parityl:                             # @my_parityl
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$2=, 0
.LBB11_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label24:
	i32.const	$push9=, 1
	i32.shl 	$push0=, $pop9, $2
	i32.and 	$push1=, $pop0, $0
	i32.const	$push8=, 0
	i32.ne  	$push2=, $pop1, $pop8
	i32.add 	$1=, $pop2, $1
	i32.const	$push7=, 1
	i32.add 	$2=, $2, $pop7
	i32.const	$push6=, 32
	i32.ne  	$push3=, $2, $pop6
	br_if   	0, $pop3        # 0: up to label24
# BB#2:                                 # %for.end
	end_loop                        # label25:
	i32.const	$push4=, 1
	i32.and 	$push5=, $1, $pop4
	return  	$pop5
	.endfunc
.Lfunc_end11:
	.size	my_parityl, .Lfunc_end11-my_parityl

	.section	.text.my_ffsll,"ax",@progbits
	.hidden	my_ffsll
	.globl	my_ffsll
	.type	my_ffsll,@function
my_ffsll:                               # @my_ffsll
	.param  	i64
	.result 	i32
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block
	i64.eqz 	$push0=, $0
	br_if   	0, $pop0        # 0: down to label26
# BB#1:                                 # %for.body.preheader
	i64.const	$1=, 0
	i32.const	$2=, 0
.LBB12_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label27:
	i64.const	$push7=, 1
	i64.shl 	$push1=, $pop7, $1
	i64.and 	$push2=, $pop1, $0
	i64.const	$push6=, 0
	i64.ne  	$push3=, $pop2, $pop6
	br_if   	1, $pop3        # 1: down to label28
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB12_2 Depth=1
	i64.const	$push10=, 1
	i64.add 	$1=, $1, $pop10
	i32.const	$push9=, 1
	i32.add 	$2=, $2, $pop9
	i64.const	$push8=, 64
	i64.lt_u	$push4=, $1, $pop8
	br_if   	0, $pop4        # 0: up to label27
.LBB12_4:                               # %for.end
	end_loop                        # label28:
	i32.const	$push5=, 1
	i32.add 	$2=, $2, $pop5
.LBB12_5:                               # %cleanup
	end_block                       # label26:
	return  	$2
	.endfunc
.Lfunc_end12:
	.size	my_ffsll, .Lfunc_end12-my_ffsll

	.section	.text.my_ctzll,"ax",@progbits
	.hidden	my_ctzll
	.globl	my_ctzll
	.type	my_ctzll,@function
my_ctzll:                               # @my_ctzll
	.param  	i64
	.result 	i32
	.local  	i64, i32
# BB#0:                                 # %entry
	i64.const	$1=, 0
	i32.const	$2=, 0
.LBB13_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label29:
	i64.const	$push5=, 1
	i64.shl 	$push0=, $pop5, $1
	i64.and 	$push1=, $pop0, $0
	i64.const	$push4=, 0
	i64.ne  	$push2=, $pop1, $pop4
	br_if   	1, $pop2        # 1: down to label30
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB13_1 Depth=1
	i64.const	$push8=, 1
	i64.add 	$1=, $1, $pop8
	i32.const	$push7=, 1
	i32.add 	$2=, $2, $pop7
	i64.const	$push6=, 64
	i64.lt_u	$push3=, $1, $pop6
	br_if   	0, $pop3        # 0: up to label29
.LBB13_3:                               # %for.end
	end_loop                        # label30:
	return  	$2
	.endfunc
.Lfunc_end13:
	.size	my_ctzll, .Lfunc_end13-my_ctzll

	.section	.text.my_clzll,"ax",@progbits
	.hidden	my_clzll
	.globl	my_clzll
	.type	my_clzll,@function
my_clzll:                               # @my_clzll
	.param  	i64
	.result 	i32
	.local  	i64, i64, i32
# BB#0:                                 # %entry
	i64.const	$1=, 63
	i64.const	$2=, 0
	i32.const	$3=, 0
.LBB14_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label31:
	i64.const	$push7=, 1
	i64.const	$push6=, 4294967295
	i64.and 	$push0=, $1, $pop6
	i64.shl 	$push1=, $pop7, $pop0
	i64.and 	$push2=, $pop1, $0
	i64.const	$push5=, 0
	i64.ne  	$push3=, $pop2, $pop5
	br_if   	1, $pop3        # 1: down to label32
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB14_1 Depth=1
	i64.const	$push11=, 1
	i64.add 	$2=, $2, $pop11
	i32.const	$push10=, 1
	i32.add 	$3=, $3, $pop10
	i64.const	$push9=, -1
	i64.add 	$1=, $1, $pop9
	i64.const	$push8=, 64
	i64.lt_u	$push4=, $2, $pop8
	br_if   	0, $pop4        # 0: up to label31
.LBB14_3:                               # %for.end
	end_loop                        # label32:
	return  	$3
	.endfunc
.Lfunc_end14:
	.size	my_clzll, .Lfunc_end14-my_clzll

	.section	.text.my_clrsbll,"ax",@progbits
	.hidden	my_clrsbll
	.globl	my_clrsbll
	.type	my_clrsbll,@function
my_clrsbll:                             # @my_clrsbll
	.param  	i64
	.result 	i32
	.local  	i64, i64, i64, i32
# BB#0:                                 # %entry
	i64.const	$push0=, 63
	i64.shr_u	$1=, $0, $pop0
	i64.const	$2=, 62
	i64.const	$3=, 1
	i32.const	$4=, 1
.LBB15_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label33:
	i64.shr_u	$push1=, $0, $2
	i64.const	$push7=, 1
	i64.and 	$push2=, $pop1, $pop7
	i64.ne  	$push3=, $pop2, $1
	br_if   	1, $pop3        # 1: down to label34
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB15_1 Depth=1
	i64.const	$push11=, 1
	i64.add 	$3=, $3, $pop11
	i32.const	$push10=, 1
	i32.add 	$4=, $4, $pop10
	i64.const	$push9=, -1
	i64.add 	$2=, $2, $pop9
	i64.const	$push8=, 64
	i64.lt_u	$push4=, $3, $pop8
	br_if   	0, $pop4        # 0: up to label33
.LBB15_3:                               # %for.end
	end_loop                        # label34:
	i32.const	$push5=, -1
	i32.add 	$push6=, $4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end15:
	.size	my_clrsbll, .Lfunc_end15-my_clrsbll

	.section	.text.my_popcountll,"ax",@progbits
	.hidden	my_popcountll
	.globl	my_popcountll
	.type	my_popcountll,@function
my_popcountll:                          # @my_popcountll
	.param  	i64
	.result 	i32
	.local  	i64, i32
# BB#0:                                 # %entry
	i64.const	$1=, 0
	i32.const	$2=, 0
.LBB16_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label35:
	i64.const	$push7=, 1
	i64.shl 	$push0=, $pop7, $1
	i64.and 	$push1=, $pop0, $0
	i64.const	$push6=, 0
	i64.ne  	$push2=, $pop1, $pop6
	i32.add 	$2=, $pop2, $2
	i64.const	$push5=, 1
	i64.add 	$1=, $1, $pop5
	i64.const	$push4=, 64
	i64.ne  	$push3=, $1, $pop4
	br_if   	0, $pop3        # 0: up to label35
# BB#2:                                 # %for.end
	end_loop                        # label36:
	return  	$2
	.endfunc
.Lfunc_end16:
	.size	my_popcountll, .Lfunc_end16-my_popcountll

	.section	.text.my_parityll,"ax",@progbits
	.hidden	my_parityll
	.globl	my_parityll
	.type	my_parityll,@function
my_parityll:                            # @my_parityll
	.param  	i64
	.result 	i32
	.local  	i64, i32
# BB#0:                                 # %entry
	i64.const	$1=, 0
	i32.const	$2=, 0
.LBB17_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label37:
	i64.const	$push9=, 1
	i64.shl 	$push0=, $pop9, $1
	i64.and 	$push1=, $pop0, $0
	i64.const	$push8=, 0
	i64.ne  	$push2=, $pop1, $pop8
	i32.add 	$2=, $pop2, $2
	i64.const	$push7=, 1
	i64.add 	$1=, $1, $pop7
	i64.const	$push6=, 64
	i64.ne  	$push3=, $1, $pop6
	br_if   	0, $pop3        # 0: up to label37
# BB#2:                                 # %for.end
	end_loop                        # label38:
	i32.const	$push4=, 1
	i32.and 	$push5=, $2, $pop4
	return  	$pop5
	.endfunc
.Lfunc_end17:
	.size	my_parityll, .Lfunc_end17-my_parityll

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i64, i32, i32, i64, i64, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB18_1:                               # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_3 Depth 2
                                        #     Child Loop BB18_9 Depth 2
                                        #     Child Loop BB18_13 Depth 2
                                        #     Child Loop BB18_17 Depth 2
                                        #     Child Loop BB18_21 Depth 2
                                        #     Child Loop BB18_24 Depth 2
	block
	block
	loop                            # label41:
	i32.const	$push220=, 2
	i32.shl 	$push219=, $0, $pop220
	tee_local	$push218=, $5=, $pop219
	i32.load	$push217=, ints($pop218)
	tee_local	$push216=, $10=, $pop217
	i32.ctz 	$push215=, $pop216
	tee_local	$push214=, $2=, $pop215
	i32.const	$push213=, 1
	i32.add 	$push4=, $pop214, $pop213
	i32.const	$push212=, 0
	i32.select	$4=, $pop4, $pop212, $10
	i32.const	$9=, 0
	block
	i32.const	$push378=, 0
	i32.eq  	$push379=, $10, $pop378
	br_if   	0, $pop379      # 0: down to label43
# BB#2:                                 # %for.body.i.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$9=, 0
.LBB18_3:                               # %for.body.i
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label44:
	i32.const	$push221=, 1
	i32.shl 	$push5=, $pop221, $9
	i32.and 	$push6=, $pop5, $10
	br_if   	1, $pop6        # 1: down to label45
# BB#4:                                 # %for.inc.i
                                        #   in Loop: Header=BB18_3 Depth=2
	i32.const	$push223=, 1
	i32.add 	$9=, $9, $pop223
	i32.const	$push222=, 32
	i32.lt_u	$push7=, $9, $pop222
	br_if   	0, $pop7        # 0: up to label44
.LBB18_5:                               # %for.end.i
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label45:
	i32.const	$push224=, 1
	i32.add 	$9=, $9, $pop224
.LBB18_6:                               # %my_ffs.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label43:
	i32.ne  	$push8=, $4, $9
	br_if   	2, $pop8        # 2: down to label40
# BB#7:                                 # %if.end
                                        #   in Loop: Header=BB18_1 Depth=1
	block
	i32.const	$push380=, 0
	i32.eq  	$push381=, $10, $pop380
	br_if   	0, $pop381      # 0: down to label46
# BB#8:                                 # %land.lhs.true
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.clz 	$1=, $10
	i32.const	$9=, 0
	i32.const	$4=, 31
.LBB18_9:                               # %for.body.i822
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label47:
	i32.const	$push225=, 1
	i32.shl 	$push9=, $pop225, $4
	i32.and 	$push10=, $pop9, $10
	br_if   	1, $pop10       # 1: down to label48
# BB#10:                                # %for.inc.i825
                                        #   in Loop: Header=BB18_9 Depth=2
	i32.const	$push228=, 1
	i32.add 	$9=, $9, $pop228
	i32.const	$push227=, -1
	i32.add 	$4=, $4, $pop227
	i32.const	$push226=, 32
	i32.lt_u	$push11=, $9, $pop226
	br_if   	0, $pop11       # 0: up to label47
.LBB18_11:                              # %my_clz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label48:
	i32.ne  	$push12=, $1, $9
	br_if   	3, $pop12       # 3: down to label40
# BB#12:                                # %land.lhs.true13
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$9=, 0
.LBB18_13:                              # %for.body.i889
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label49:
	i32.const	$push229=, 1
	i32.shl 	$push13=, $pop229, $9
	i32.and 	$push14=, $pop13, $10
	br_if   	1, $pop14       # 1: down to label50
# BB#14:                                # %for.inc.i892
                                        #   in Loop: Header=BB18_13 Depth=2
	i32.const	$push231=, 1
	i32.add 	$9=, $9, $pop231
	i32.const	$push230=, 32
	i32.lt_u	$push15=, $9, $pop230
	br_if   	0, $pop15       # 0: up to label49
.LBB18_15:                              # %my_ctz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label50:
	i32.ne  	$push16=, $2, $9
	br_if   	3, $pop16       # 3: down to label40
.LBB18_16:                              # %if.end19
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label46:
	i32.call	$2=, __builtin_clrsb@FUNCTION, $10
	i32.const	$push235=, ints
	i32.add 	$push0=, $5, $pop235
	i32.load	$push234=, 0($pop0)
	tee_local	$push233=, $10=, $pop234
	i32.const	$push232=, 31
	i32.shr_u	$5=, $pop233, $pop232
	i32.const	$9=, 1
	i32.const	$4=, 30
.LBB18_17:                              # %for.body.i974
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label51:
	i32.shr_u	$push17=, $10, $4
	i32.const	$push236=, 1
	i32.and 	$push18=, $pop17, $pop236
	i32.ne  	$push19=, $pop18, $5
	br_if   	1, $pop19       # 1: down to label52
# BB#18:                                # %for.inc.i977
                                        #   in Loop: Header=BB18_17 Depth=2
	i32.const	$push239=, 1
	i32.add 	$9=, $9, $pop239
	i32.const	$push238=, -1
	i32.add 	$4=, $4, $pop238
	i32.const	$push237=, 32
	i32.lt_u	$push20=, $9, $pop237
	br_if   	0, $pop20       # 0: up to label51
.LBB18_19:                              # %my_clrsb.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label52:
	i32.const	$push240=, -1
	i32.add 	$push21=, $9, $pop240
	i32.ne  	$push22=, $2, $pop21
	br_if   	2, $pop22       # 2: down to label40
# BB#20:                                # %for.body.i1069.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$4=, 0
	i32.const	$9=, 0
.LBB18_21:                              # %for.body.i1069
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label53:
	i32.const	$push244=, 1
	i32.shl 	$push23=, $pop244, $9
	i32.and 	$push24=, $pop23, $10
	i32.const	$push243=, 0
	i32.ne  	$push25=, $pop24, $pop243
	i32.add 	$4=, $pop25, $4
	i32.const	$push242=, 1
	i32.add 	$9=, $9, $pop242
	i32.const	$push241=, 32
	i32.ne  	$push26=, $9, $pop241
	br_if   	0, $pop26       # 0: up to label53
# BB#22:                                # %my_popcount.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label54:
	i32.popcnt	$push27=, $10
	i32.ne  	$push28=, $pop27, $4
	br_if   	2, $pop28       # 2: down to label40
# BB#23:                                # %for.body.i1161.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$5=, 0
	i32.const	$9=, 0
.LBB18_24:                              # %for.body.i1161
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label55:
	i32.const	$push248=, 1
	i32.shl 	$push29=, $pop248, $9
	i32.and 	$push30=, $pop29, $10
	i32.const	$push247=, 0
	i32.ne  	$push31=, $pop30, $pop247
	i32.add 	$5=, $pop31, $5
	i32.const	$push246=, 1
	i32.add 	$9=, $9, $pop246
	i32.const	$push245=, 32
	i32.ne  	$push32=, $9, $pop245
	br_if   	0, $pop32       # 0: up to label55
# BB#25:                                # %my_parity.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label56:
	i32.xor 	$push33=, $5, $4
	i32.const	$push249=, 1
	i32.and 	$push34=, $pop33, $pop249
	br_if   	2, $pop34       # 2: down to label40
# BB#26:                                # %for.cond
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$push251=, 1
	i32.add 	$0=, $0, $pop251
	i32.const	$push250=, 13
	i32.lt_u	$push35=, $0, $pop250
	br_if   	0, $pop35       # 0: up to label41
# BB#27:                                # %for.body41.preheader
	end_loop                        # label42:
	i32.const	$0=, 0
.LBB18_28:                              # %for.body41
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_30 Depth 2
                                        #     Child Loop BB18_36 Depth 2
                                        #     Child Loop BB18_40 Depth 2
                                        #     Child Loop BB18_44 Depth 2
                                        #     Child Loop BB18_48 Depth 2
                                        #     Child Loop BB18_51 Depth 2
	loop                            # label57:
	i32.const	$push260=, 2
	i32.shl 	$push259=, $0, $pop260
	tee_local	$push258=, $5=, $pop259
	i32.load	$push257=, longs($pop258)
	tee_local	$push256=, $10=, $pop257
	i32.ctz 	$push255=, $pop256
	tee_local	$push254=, $2=, $pop255
	i32.const	$push253=, 1
	i32.add 	$push36=, $pop254, $pop253
	i32.const	$push252=, 0
	i32.select	$4=, $pop36, $pop252, $10
	i32.const	$9=, 0
	block
	i32.const	$push382=, 0
	i32.eq  	$push383=, $10, $pop382
	br_if   	0, $pop383      # 0: down to label59
# BB#29:                                # %for.body.i1251.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$9=, 0
.LBB18_30:                              # %for.body.i1251
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label60:
	i32.const	$push261=, 1
	i32.shl 	$push37=, $pop261, $9
	i32.and 	$push38=, $pop37, $10
	br_if   	1, $pop38       # 1: down to label61
# BB#31:                                # %for.inc.i1254
                                        #   in Loop: Header=BB18_30 Depth=2
	i32.const	$push263=, 1
	i32.add 	$9=, $9, $pop263
	i32.const	$push262=, 32
	i32.lt_u	$push39=, $9, $pop262
	br_if   	0, $pop39       # 0: up to label60
.LBB18_32:                              # %for.end.i1257
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label61:
	i32.const	$push264=, 1
	i32.add 	$9=, $9, $pop264
.LBB18_33:                              # %my_ffsl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_block                       # label59:
	i32.ne  	$push40=, $4, $9
	br_if   	2, $pop40       # 2: down to label40
# BB#34:                                # %if.end49
                                        #   in Loop: Header=BB18_28 Depth=1
	block
	i32.const	$push384=, 0
	i32.eq  	$push385=, $10, $pop384
	br_if   	0, $pop385      # 0: down to label62
# BB#35:                                # %land.lhs.true52
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.clz 	$1=, $10
	i32.const	$9=, 0
	i32.const	$4=, 31
.LBB18_36:                              # %for.body.i1346
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label63:
	i32.const	$push265=, 1
	i32.shl 	$push41=, $pop265, $4
	i32.and 	$push42=, $pop41, $10
	br_if   	1, $pop42       # 1: down to label64
# BB#37:                                # %for.inc.i1349
                                        #   in Loop: Header=BB18_36 Depth=2
	i32.const	$push268=, 1
	i32.add 	$9=, $9, $pop268
	i32.const	$push267=, -1
	i32.add 	$4=, $4, $pop267
	i32.const	$push266=, 32
	i32.lt_u	$push43=, $9, $pop266
	br_if   	0, $pop43       # 0: up to label63
.LBB18_38:                              # %my_clzl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label64:
	i32.ne  	$push44=, $1, $9
	br_if   	3, $pop44       # 3: down to label40
# BB#39:                                # %land.lhs.true61
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$9=, 0
.LBB18_40:                              # %for.body.i1438
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label65:
	i32.const	$push269=, 1
	i32.shl 	$push45=, $pop269, $9
	i32.and 	$push46=, $pop45, $10
	br_if   	1, $pop46       # 1: down to label66
# BB#41:                                # %for.inc.i1441
                                        #   in Loop: Header=BB18_40 Depth=2
	i32.const	$push271=, 1
	i32.add 	$9=, $9, $pop271
	i32.const	$push270=, 32
	i32.lt_u	$push47=, $9, $pop270
	br_if   	0, $pop47       # 0: up to label65
.LBB18_42:                              # %my_ctzl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label66:
	i32.ne  	$push48=, $2, $9
	br_if   	3, $pop48       # 3: down to label40
.LBB18_43:                              # %if.end67
                                        #   in Loop: Header=BB18_28 Depth=1
	end_block                       # label62:
	i32.call	$2=, __builtin_clrsbl@FUNCTION, $10
	i32.const	$push275=, longs
	i32.add 	$push1=, $5, $pop275
	i32.load	$push274=, 0($pop1)
	tee_local	$push273=, $10=, $pop274
	i32.const	$push272=, 31
	i32.shr_u	$5=, $pop273, $pop272
	i32.const	$9=, 1
	i32.const	$4=, 30
.LBB18_44:                              # %for.body.i1532
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label67:
	i32.shr_u	$push49=, $10, $4
	i32.const	$push276=, 1
	i32.and 	$push50=, $pop49, $pop276
	i32.ne  	$push51=, $pop50, $5
	br_if   	1, $pop51       # 1: down to label68
# BB#45:                                # %for.inc.i1535
                                        #   in Loop: Header=BB18_44 Depth=2
	i32.const	$push279=, 1
	i32.add 	$9=, $9, $pop279
	i32.const	$push278=, -1
	i32.add 	$4=, $4, $pop278
	i32.const	$push277=, 32
	i32.lt_u	$push52=, $9, $pop277
	br_if   	0, $pop52       # 0: up to label67
.LBB18_46:                              # %my_clrsbl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label68:
	i32.const	$push280=, -1
	i32.add 	$push53=, $9, $pop280
	i32.ne  	$push54=, $2, $pop53
	br_if   	2, $pop54       # 2: down to label40
# BB#47:                                # %for.body.i1630.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$4=, 0
	i32.const	$9=, 0
.LBB18_48:                              # %for.body.i1630
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label69:
	i32.const	$push284=, 1
	i32.shl 	$push55=, $pop284, $9
	i32.and 	$push56=, $pop55, $10
	i32.const	$push283=, 0
	i32.ne  	$push57=, $pop56, $pop283
	i32.add 	$4=, $pop57, $4
	i32.const	$push282=, 1
	i32.add 	$9=, $9, $pop282
	i32.const	$push281=, 32
	i32.ne  	$push58=, $9, $pop281
	br_if   	0, $pop58       # 0: up to label69
# BB#49:                                # %my_popcountl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label70:
	i32.popcnt	$push59=, $10
	i32.ne  	$push60=, $pop59, $4
	br_if   	2, $pop60       # 2: down to label40
# BB#50:                                # %for.body.i1723.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$5=, 0
	i32.const	$9=, 0
.LBB18_51:                              # %for.body.i1723
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label71:
	i32.const	$push288=, 1
	i32.shl 	$push61=, $pop288, $9
	i32.and 	$push62=, $pop61, $10
	i32.const	$push287=, 0
	i32.ne  	$push63=, $pop62, $pop287
	i32.add 	$5=, $pop63, $5
	i32.const	$push286=, 1
	i32.add 	$9=, $9, $pop286
	i32.const	$push285=, 32
	i32.ne  	$push64=, $9, $pop285
	br_if   	0, $pop64       # 0: up to label71
# BB#52:                                # %my_parityl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label72:
	i32.xor 	$push65=, $5, $4
	i32.const	$push289=, 1
	i32.and 	$push66=, $pop65, $pop289
	br_if   	2, $pop66       # 2: down to label40
# BB#53:                                # %for.cond39
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$push291=, 1
	i32.add 	$0=, $0, $pop291
	i32.const	$push290=, 13
	i32.lt_u	$push67=, $0, $pop290
	br_if   	0, $pop67       # 0: up to label57
# BB#54:                                # %for.body92.preheader
	end_loop                        # label58:
	i32.const	$4=, 0
.LBB18_55:                              # %for.body92
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_57 Depth 2
                                        #     Child Loop BB18_63 Depth 2
                                        #     Child Loop BB18_67 Depth 2
                                        #     Child Loop BB18_71 Depth 2
                                        #     Child Loop BB18_75 Depth 2
                                        #     Child Loop BB18_78 Depth 2
	loop                            # label73:
	i32.const	$push302=, 0
	i32.const	$push301=, 3
	i32.shl 	$push300=, $4, $pop301
	tee_local	$push299=, $0=, $pop300
	i64.load	$push298=, longlongs($pop299)
	tee_local	$push297=, $8=, $pop298
	i64.ctz 	$push296=, $pop297
	tee_local	$push295=, $3=, $pop296
	i64.const	$push294=, 1
	i64.add 	$push68=, $pop295, $pop294
	i32.wrap/i64	$push69=, $pop68
	i64.eqz 	$push293=, $8
	tee_local	$push292=, $10=, $pop293
	i32.select	$5=, $pop302, $pop69, $pop292
	i32.const	$9=, 0
	block
	br_if   	0, $10          # 0: down to label75
# BB#56:                                # %for.body.i1814.preheader
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.const	$7=, 0
	i32.const	$9=, 0
.LBB18_57:                              # %for.body.i1814
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label76:
	i64.const	$push304=, 1
	i64.shl 	$push70=, $pop304, $7
	i64.and 	$push71=, $pop70, $8
	i64.const	$push303=, 0
	i64.ne  	$push72=, $pop71, $pop303
	br_if   	1, $pop72       # 1: down to label77
# BB#58:                                # %for.inc.i1818
                                        #   in Loop: Header=BB18_57 Depth=2
	i64.const	$push307=, 1
	i64.add 	$7=, $7, $pop307
	i32.const	$push306=, 1
	i32.add 	$9=, $9, $pop306
	i64.const	$push305=, 64
	i64.lt_u	$push73=, $7, $pop305
	br_if   	0, $pop73       # 0: up to label76
.LBB18_59:                              # %for.end.i1821
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label77:
	i32.const	$push308=, 1
	i32.add 	$9=, $9, $pop308
.LBB18_60:                              # %my_ffsll.exit1823
                                        #   in Loop: Header=BB18_55 Depth=1
	end_block                       # label75:
	i32.ne  	$push74=, $5, $9
	br_if   	2, $pop74       # 2: down to label40
# BB#61:                                # %if.end100
                                        #   in Loop: Header=BB18_55 Depth=1
	block
	br_if   	0, $10          # 0: down to label78
# BB#62:                                # %land.lhs.true103
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.const	$6=, 0
	i64.const	$7=, 63
	i64.clz 	$push75=, $8
	i32.wrap/i64	$10=, $pop75
	i32.const	$9=, 0
.LBB18_63:                              # %for.body.i1902
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label79:
	i64.const	$push311=, 1
	i64.const	$push310=, 4294967295
	i64.and 	$push76=, $7, $pop310
	i64.shl 	$push77=, $pop311, $pop76
	i64.and 	$push78=, $pop77, $8
	i64.const	$push309=, 0
	i64.ne  	$push79=, $pop78, $pop309
	br_if   	1, $pop79       # 1: down to label80
# BB#64:                                # %for.inc.i1906
                                        #   in Loop: Header=BB18_63 Depth=2
	i64.const	$push315=, 1
	i64.add 	$6=, $6, $pop315
	i32.const	$push314=, 1
	i32.add 	$9=, $9, $pop314
	i64.const	$push313=, -1
	i64.add 	$7=, $7, $pop313
	i64.const	$push312=, 64
	i64.lt_u	$push80=, $6, $pop312
	br_if   	0, $pop80       # 0: up to label79
.LBB18_65:                              # %my_clzll.exit1909
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label80:
	i32.ne  	$push81=, $10, $9
	br_if   	3, $pop81       # 3: down to label40
# BB#66:                                # %land.lhs.true113
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.const	$7=, 0
	i32.wrap/i64	$10=, $3
	i32.const	$9=, 0
.LBB18_67:                              # %for.body.i1948
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label81:
	i64.const	$push317=, 1
	i64.shl 	$push82=, $pop317, $7
	i64.and 	$push83=, $pop82, $8
	i64.const	$push316=, 0
	i64.ne  	$push84=, $pop83, $pop316
	br_if   	1, $pop84       # 1: down to label82
# BB#68:                                # %for.inc.i1952
                                        #   in Loop: Header=BB18_67 Depth=2
	i64.const	$push320=, 1
	i64.add 	$7=, $7, $pop320
	i32.const	$push319=, 1
	i32.add 	$9=, $9, $pop319
	i64.const	$push318=, 64
	i64.lt_u	$push85=, $7, $pop318
	br_if   	0, $pop85       # 0: up to label81
.LBB18_69:                              # %my_ctzll.exit1955
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label82:
	i32.ne  	$push86=, $10, $9
	br_if   	3, $pop86       # 3: down to label40
.LBB18_70:                              # %if.end120
                                        #   in Loop: Header=BB18_55 Depth=1
	end_block                       # label78:
	i32.call	$10=, __builtin_clrsbll@FUNCTION, $8
	i32.const	$push324=, longlongs
	i32.add 	$push2=, $0, $pop324
	i64.load	$push323=, 0($pop2)
	tee_local	$push322=, $8=, $pop323
	i64.const	$push321=, 63
	i64.shr_u	$3=, $pop322, $pop321
	i64.const	$6=, 1
	i64.const	$7=, 62
	i32.const	$9=, 1
.LBB18_71:                              # %for.body.i2018
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label83:
	i64.shr_u	$push87=, $8, $7
	i64.const	$push325=, 1
	i64.and 	$push88=, $pop87, $pop325
	i64.ne  	$push89=, $pop88, $3
	br_if   	1, $pop89       # 1: down to label84
# BB#72:                                # %for.inc.i2022
                                        #   in Loop: Header=BB18_71 Depth=2
	i64.const	$push329=, 1
	i64.add 	$6=, $6, $pop329
	i32.const	$push328=, 1
	i32.add 	$9=, $9, $pop328
	i64.const	$push327=, -1
	i64.add 	$7=, $7, $pop327
	i64.const	$push326=, 64
	i64.lt_u	$push90=, $6, $pop326
	br_if   	0, $pop90       # 0: up to label83
.LBB18_73:                              # %my_clrsbll.exit2026
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label84:
	i32.const	$push330=, -1
	i32.add 	$push91=, $9, $pop330
	i32.ne  	$push92=, $10, $pop91
	br_if   	2, $pop92       # 2: down to label40
# BB#74:                                # %if.end127
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.popcnt	$6=, $8
	i64.const	$7=, 0
	i32.const	$9=, 0
.LBB18_75:                              # %for.body.i2110
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label85:
	i64.const	$push334=, 1
	i64.shl 	$push93=, $pop334, $7
	i64.and 	$push94=, $pop93, $8
	i64.const	$push333=, 0
	i64.ne  	$push95=, $pop94, $pop333
	i32.add 	$9=, $pop95, $9
	i64.const	$push332=, 1
	i64.add 	$7=, $7, $pop332
	i64.const	$push331=, 64
	i64.ne  	$push96=, $7, $pop331
	br_if   	0, $pop96       # 0: up to label85
# BB#76:                                # %my_popcountll.exit2112
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label86:
	i32.wrap/i64	$push97=, $6
	i32.ne  	$push98=, $pop97, $9
	br_if   	2, $pop98       # 2: down to label40
# BB#77:                                # %for.body.i2196.preheader
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.const	$7=, 0
	i32.const	$10=, 0
.LBB18_78:                              # %for.body.i2196
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label87:
	i64.const	$push338=, 1
	i64.shl 	$push99=, $pop338, $7
	i64.and 	$push100=, $pop99, $8
	i64.const	$push337=, 0
	i64.ne  	$push101=, $pop100, $pop337
	i32.add 	$10=, $pop101, $10
	i64.const	$push336=, 1
	i64.add 	$7=, $7, $pop336
	i64.const	$push335=, 64
	i64.ne  	$push102=, $7, $pop335
	br_if   	0, $pop102      # 0: up to label87
# BB#79:                                # %my_parityll.exit2199
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label88:
	i32.xor 	$push103=, $10, $9
	i32.const	$push339=, 1
	i32.and 	$push104=, $pop103, $pop339
	br_if   	3, $pop104      # 3: down to label39
# BB#80:                                # %for.cond90
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.const	$push341=, 1
	i32.add 	$4=, $4, $pop341
	i32.const	$push340=, 12
	i32.le_u	$push105=, $4, $pop340
	br_if   	0, $pop105      # 0: up to label73
# BB#81:                                # %if.end148
	end_loop                        # label74:
	i32.const	$push106=, 0
	i32.call	$push107=, __builtin_clrsb@FUNCTION, $pop106
	i32.const	$push108=, 31
	i32.ne  	$push109=, $pop107, $pop108
	br_if   	0, $pop109      # 0: down to label40
# BB#82:                                # %my_clrsb.exit2770
	i32.const	$push110=, 1
	i32.call	$push111=, __builtin_clrsb@FUNCTION, $pop110
	i32.const	$push112=, 30
	i32.ne  	$push113=, $pop111, $pop112
	br_if   	0, $pop113      # 0: down to label40
# BB#83:                                # %if.end198
	i32.const	$push114=, -2147483648
	i32.call	$push115=, __builtin_clrsb@FUNCTION, $pop114
	br_if   	0, $pop115      # 0: down to label40
# BB#84:                                # %my_clrsb.exit2597
	i32.const	$push116=, 1073741824
	i32.call	$push117=, __builtin_clrsb@FUNCTION, $pop116
	br_if   	0, $pop117      # 0: down to label40
# BB#85:                                # %my_clrsb.exit2514
	i32.const	$push118=, 65536
	i32.call	$push119=, __builtin_clrsb@FUNCTION, $pop118
	i32.const	$push120=, 14
	i32.ne  	$push121=, $pop119, $pop120
	br_if   	0, $pop121      # 0: down to label40
# BB#86:                                # %my_clrsb.exit2432
	i32.const	$push122=, 32768
	i32.call	$push123=, __builtin_clrsb@FUNCTION, $pop122
	i32.const	$push124=, 15
	i32.ne  	$push125=, $pop123, $pop124
	br_if   	0, $pop125      # 0: down to label40
# BB#87:                                # %my_clrsb.exit2348
	i32.const	$push126=, -1515870811
	i32.call	$push127=, __builtin_clrsb@FUNCTION, $pop126
	br_if   	0, $pop127      # 0: down to label40
# BB#88:                                # %my_clrsb.exit2273
	i32.const	$push128=, 1515870810
	i32.call	$push129=, __builtin_clrsb@FUNCTION, $pop128
	br_if   	0, $pop129      # 0: down to label40
# BB#89:                                # %for.body.i2179
	i32.const	$push130=, -889323520
	i32.call	$push131=, __builtin_clrsb@FUNCTION, $pop130
	i32.const	$push132=, 1
	i32.ne  	$push133=, $pop131, $pop132
	br_if   	0, $pop133      # 0: down to label40
# BB#90:                                # %for.body.i2093
	i32.const	$push134=, 13303296
	i32.call	$push135=, __builtin_clrsb@FUNCTION, $pop134
	i32.const	$push136=, 7
	i32.ne  	$push137=, $pop135, $pop136
	br_if   	0, $pop137      # 0: down to label40
# BB#91:                                # %for.body.i2004
	i32.const	$push138=, 51966
	i32.call	$push139=, __builtin_clrsb@FUNCTION, $pop138
	i32.const	$push140=, 15
	i32.ne  	$push141=, $pop139, $pop140
	br_if   	0, $pop141      # 0: down to label40
# BB#92:                                # %if.end423
	i32.const	$push342=, -1
	i32.call	$4=, __builtin_clrsb@FUNCTION, $pop342
	i32.const	$10=, 30
	i32.const	$9=, 1
.LBB18_93:                              # %for.body.i1935
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label89:
	i32.const	$push344=, -1
	i32.shr_u	$push142=, $pop344, $10
	i32.const	$push343=, 1
	i32.and 	$push143=, $pop142, $pop343
	i32.const	$push386=, 0
	i32.eq  	$push387=, $pop143, $pop386
	br_if   	1, $pop387      # 1: down to label90
# BB#94:                                # %for.inc.i1938
                                        #   in Loop: Header=BB18_93 Depth=1
	i32.const	$push347=, 1
	i32.add 	$9=, $9, $pop347
	i32.const	$push346=, -1
	i32.add 	$10=, $10, $pop346
	i32.const	$push345=, 32
	i32.lt_u	$push144=, $9, $pop345
	br_if   	0, $pop144      # 0: up to label89
.LBB18_95:                              # %my_clrsb.exit1942
	end_loop                        # label90:
	i32.const	$push145=, -1
	i32.add 	$push146=, $9, $pop145
	i32.ne  	$push147=, $4, $pop146
	br_if   	0, $pop147      # 0: down to label40
# BB#96:                                # %if.end440
	i64.const	$8=, 0
	i64.const	$push348=, 0
	i32.call	$push148=, __builtin_clrsbll@FUNCTION, $pop348
	i32.const	$push149=, 63
	i32.ne  	$push150=, $pop148, $pop149
	br_if   	0, $pop150      # 0: down to label40
# BB#97:                                # %for.body.i1844.preheader
	i64.const	$7=, 63
	i32.const	$9=, 0
.LBB18_98:                              # %for.body.i1844
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label91:
	i32.wrap/i64	$push151=, $7
	i32.const	$push388=, 0
	i32.eq  	$push389=, $pop151, $pop388
	br_if   	1, $pop389      # 1: down to label92
# BB#99:                                # %for.inc.i1848
                                        #   in Loop: Header=BB18_98 Depth=1
	i64.const	$push352=, 1
	i64.add 	$8=, $8, $pop352
	i32.const	$push351=, 1
	i32.add 	$9=, $9, $pop351
	i64.const	$push350=, -1
	i64.add 	$7=, $7, $pop350
	i64.const	$push349=, 64
	i64.lt_u	$push152=, $8, $pop349
	br_if   	0, $pop152      # 0: up to label91
.LBB18_100:                             # %my_clzll.exit1851
	end_loop                        # label92:
	i32.const	$push153=, 63
	i32.ne  	$push154=, $9, $pop153
	br_if   	0, $pop154      # 0: down to label40
# BB#101:                               # %if.end465
	i64.const	$push353=, 1
	i32.call	$10=, __builtin_clrsbll@FUNCTION, $pop353
	i64.const	$7=, 1
.LBB18_102:                             # %for.body.i1799
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label93:
	i32.const	$9=, 62
	i64.const	$push354=, 63
	i64.eq  	$push155=, $7, $pop354
	br_if   	1, $pop155      # 1: down to label94
# BB#103:                               # %for.inc.i1803
                                        #   in Loop: Header=BB18_102 Depth=1
	i64.const	$push356=, 1
	i64.add 	$7=, $7, $pop356
	i32.const	$9=, 63
	i64.const	$push355=, 64
	i64.lt_u	$push156=, $7, $pop355
	br_if   	0, $pop156      # 0: up to label93
.LBB18_104:                             # %my_clrsbll.exit1807
	end_loop                        # label94:
	i32.ne  	$push157=, $10, $9
	br_if   	0, $pop157      # 0: down to label40
# BB#105:                               # %for.body.i1759.preheader
	i64.const	$7=, 0
.LBB18_106:                             # %for.body.i1759
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label96:
	i64.const	$push357=, 63
	i64.eq  	$push158=, $7, $pop357
	br_if   	2, $pop158      # 2: down to label95
# BB#107:                               # %for.inc.i1763
                                        #   in Loop: Header=BB18_106 Depth=1
	i64.const	$push359=, 1
	i64.add 	$7=, $7, $pop359
	i64.const	$push358=, 64
	i64.lt_u	$push159=, $7, $pop358
	br_if   	0, $pop159      # 0: up to label96
# BB#108:                               # %if.then481
	end_loop                        # label97:
	call    	abort@FUNCTION
	unreachable
.LBB18_109:                             # %for.body.i1731.preheader
	end_block                       # label95:
	i64.const	$7=, 0
.LBB18_110:                             # %for.body.i1731
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label99:
	i64.const	$push360=, 63
	i64.eq  	$push160=, $7, $pop360
	br_if   	2, $pop160      # 2: down to label98
# BB#111:                               # %for.inc.i1735
                                        #   in Loop: Header=BB18_110 Depth=1
	i64.const	$push362=, 1
	i64.add 	$7=, $7, $pop362
	i64.const	$push361=, 64
	i64.lt_u	$push161=, $7, $pop361
	br_if   	0, $pop161      # 0: up to label99
# BB#112:                               # %if.then489
	end_loop                        # label100:
	call    	abort@FUNCTION
	unreachable
.LBB18_113:                             # %if.end490
	end_block                       # label98:
	i64.const	$push162=, -9223372036854775808
	i32.call	$push163=, __builtin_clrsbll@FUNCTION, $pop162
	br_if   	0, $pop163      # 0: down to label40
# BB#114:                               # %for.body.i1652.preheader
	i64.const	$7=, 63
	i64.const	$8=, -1
.LBB18_115:                             # %for.body.i1652
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label101:
	i64.const	$push365=, 1
	i64.add 	$8=, $8, $pop365
	i32.wrap/i64	$9=, $7
	i64.const	$push364=, -1
	i64.add 	$push3=, $7, $pop364
	copy_local	$7=, $pop3
	i32.const	$push363=, 1
	i32.ne  	$push164=, $9, $pop363
	br_if   	0, $pop164      # 0: up to label101
# BB#116:                               # %my_clzll.exit1659
	end_loop                        # label102:
	i32.wrap/i64	$push165=, $8
	i32.const	$push166=, 62
	i32.ne  	$push167=, $pop165, $pop166
	br_if   	0, $pop167      # 0: down to label40
# BB#117:                               # %for.body.i1612
	i64.const	$push168=, 2
	i32.call	$push169=, __builtin_clrsbll@FUNCTION, $pop168
	i32.const	$push170=, 61
	i32.ne  	$push171=, $pop169, $pop170
	br_if   	0, $pop171      # 0: down to label40
# BB#118:                               # %my_clrsbll.exit1525
	i64.const	$push172=, 4611686018427387904
	i32.call	$push173=, __builtin_clrsbll@FUNCTION, $pop172
	br_if   	0, $pop173      # 0: down to label40
# BB#119:                               # %for.body.i1425
	i64.const	$push174=, 4294967296
	i32.call	$push175=, __builtin_clrsbll@FUNCTION, $pop174
	i32.const	$push176=, 30
	i32.ne  	$push177=, $pop175, $pop176
	br_if   	0, $pop177      # 0: down to label40
# BB#120:                               # %for.body.i1332
	i64.const	$push178=, 2147483648
	i32.call	$push179=, __builtin_clrsbll@FUNCTION, $pop178
	i32.const	$push180=, 31
	i32.ne  	$push181=, $pop179, $pop180
	br_if   	0, $pop181      # 0: down to label40
# BB#121:                               # %my_clrsbll.exit1245
	i64.const	$push182=, -6510615555426900571
	i32.call	$push183=, __builtin_clrsbll@FUNCTION, $pop182
	br_if   	0, $pop183      # 0: down to label40
# BB#122:                               # %my_clrsbll.exit1152
	i64.const	$push184=, 6510615555426900570
	i32.call	$push185=, __builtin_clrsbll@FUNCTION, $pop184
	br_if   	0, $pop185      # 0: down to label40
# BB#123:                               # %for.body.i1053
	i64.const	$push186=, -3819392241693097984
	i32.call	$push187=, __builtin_clrsbll@FUNCTION, $pop186
	i32.const	$push188=, 1
	i32.ne  	$push189=, $pop187, $pop188
	br_if   	0, $pop189      # 0: down to label40
# BB#124:                               # %for.body.i964
	i64.const	$push190=, 223195676147712
	i32.call	$push191=, __builtin_clrsbll@FUNCTION, $pop190
	i32.const	$push192=, 15
	i32.ne  	$push193=, $pop191, $pop192
	br_if   	0, $pop193      # 0: down to label40
# BB#125:                               # %for.body.i913.preheader
	i64.const	$7=, 63
	i64.const	$8=, -1
.LBB18_126:                             # %for.body.i913
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label103:
	i64.const	$push370=, 4294967295
	i64.and 	$6=, $7, $pop370
	i64.const	$push369=, 1
	i64.add 	$8=, $8, $pop369
	i64.const	$push368=, -1
	i64.add 	$7=, $7, $pop368
	i64.const	$push367=, 1
	i64.shl 	$push194=, $pop367, $6
	i64.const	$push366=, 3405695742
	i64.and 	$push195=, $pop194, $pop366
	i64.eqz 	$push196=, $pop195
	br_if   	0, $pop196      # 0: up to label103
# BB#127:                               # %my_clzll.exit
	end_loop                        # label104:
	i32.wrap/i64	$push197=, $8
	i32.const	$push198=, 32
	i32.ne  	$push199=, $pop197, $pop198
	br_if   	0, $pop199      # 0: down to label40
# BB#128:                               # %for.body.i877
	i64.const	$push200=, 3405695742
	i32.call	$push201=, __builtin_clrsbll@FUNCTION, $pop200
	i32.const	$push202=, 31
	i32.ne  	$push203=, $pop201, $pop202
	br_if   	0, $pop203      # 0: down to label40
# BB#129:                               # %if.end740
	i64.const	$push371=, -1
	i32.call	$10=, __builtin_clrsbll@FUNCTION, $pop371
	i64.const	$7=, 62
	i64.const	$8=, 1
	i32.const	$9=, 1
.LBB18_130:                             # %for.body.i812
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label105:
	i64.const	$push373=, -1
	i64.shr_u	$push204=, $pop373, $7
	i64.const	$push372=, 1
	i64.and 	$push205=, $pop204, $pop372
	i64.eqz 	$push206=, $pop205
	br_if   	1, $pop206      # 1: down to label106
# BB#131:                               # %for.inc.i816
                                        #   in Loop: Header=BB18_130 Depth=1
	i64.const	$push377=, 1
	i64.add 	$8=, $8, $pop377
	i32.const	$push376=, 1
	i32.add 	$9=, $9, $pop376
	i64.const	$push375=, -1
	i64.add 	$7=, $7, $pop375
	i64.const	$push374=, 64
	i64.lt_u	$push207=, $8, $pop374
	br_if   	0, $pop207      # 0: up to label105
.LBB18_132:                             # %my_clrsbll.exit
	end_loop                        # label106:
	i32.const	$push208=, -1
	i32.add 	$push209=, $9, $pop208
	i32.ne  	$push210=, $10, $pop209
	br_if   	0, $pop210      # 0: down to label40
# BB#133:                               # %if.end753
	i32.const	$push211=, 0
	call    	exit@FUNCTION, $pop211
	unreachable
.LBB18_134:                             # %if.then37
	end_block                       # label40:
	call    	abort@FUNCTION
	unreachable
.LBB18_135:                             # %if.then140
	end_block                       # label39:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end18:
	.size	main, .Lfunc_end18-main

	.hidden	ints                    # @ints
	.type	ints,@object
	.section	.data.ints,"aw",@progbits
	.globl	ints
	.p2align	4
ints:
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	2147483648              # 0x80000000
	.int32	2                       # 0x2
	.int32	1073741824              # 0x40000000
	.int32	65536                   # 0x10000
	.int32	32768                   # 0x8000
	.int32	2779096485              # 0xa5a5a5a5
	.int32	1515870810              # 0x5a5a5a5a
	.int32	3405643776              # 0xcafe0000
	.int32	13303296                # 0xcafe00
	.int32	51966                   # 0xcafe
	.int32	4294967295              # 0xffffffff
	.size	ints, 52

	.hidden	longs                   # @longs
	.type	longs,@object
	.section	.data.longs,"aw",@progbits
	.globl	longs
	.p2align	4
longs:
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	2147483648              # 0x80000000
	.int32	2                       # 0x2
	.int32	1073741824              # 0x40000000
	.int32	65536                   # 0x10000
	.int32	32768                   # 0x8000
	.int32	2779096485              # 0xa5a5a5a5
	.int32	1515870810              # 0x5a5a5a5a
	.int32	3405643776              # 0xcafe0000
	.int32	13303296                # 0xcafe00
	.int32	51966                   # 0xcafe
	.int32	4294967295              # 0xffffffff
	.size	longs, 52

	.hidden	longlongs               # @longlongs
	.type	longlongs,@object
	.section	.data.longlongs,"aw",@progbits
	.globl	longlongs
	.p2align	4
longlongs:
	.int64	0                       # 0x0
	.int64	1                       # 0x1
	.int64	-9223372036854775808    # 0x8000000000000000
	.int64	2                       # 0x2
	.int64	4611686018427387904     # 0x4000000000000000
	.int64	4294967296              # 0x100000000
	.int64	2147483648              # 0x80000000
	.int64	-6510615555426900571    # 0xa5a5a5a5a5a5a5a5
	.int64	6510615555426900570     # 0x5a5a5a5a5a5a5a5a
	.int64	-3819392241693097984    # 0xcafecafe00000000
	.int64	223195676147712         # 0xcafecafe0000
	.int64	3405695742              # 0xcafecafe
	.int64	-1                      # 0xffffffffffffffff
	.size	longlongs, 104


	.ident	"clang version 3.9.0 "
