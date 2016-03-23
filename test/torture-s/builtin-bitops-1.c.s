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
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push4=, 1
	i32.shl 	$push0=, $pop4, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label2
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push6=, 1
	i32.add 	$1=, $1, $pop6
	i32.const	$push5=, 32
	i32.lt_u	$push2=, $1, $pop5
	br_if   	0, $pop2        # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	i32.const	$push3=, 1
	i32.add 	$1=, $1, $pop3
.LBB0_4:                                # %cleanup
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
.LBB6_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label14:
	i32.const	$push4=, 1
	i32.shl 	$push0=, $pop4, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label15
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.const	$push6=, 1
	i32.add 	$1=, $1, $pop6
	i32.const	$push5=, 32
	i32.lt_u	$push2=, $1, $pop5
	br_if   	0, $pop2        # 0: up to label14
.LBB6_3:                                # %for.end
	end_loop                        # label15:
	i32.const	$push3=, 1
	i32.add 	$1=, $1, $pop3
.LBB6_4:                                # %cleanup
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
# BB#1:
	i64.const	$1=, 0
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
	.local  	i32, i32, i64, i32, i32, i64, i64, i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB18_1:                               # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_2 Depth 2
                                        #     Child Loop BB18_8 Depth 2
                                        #     Child Loop BB18_12 Depth 2
                                        #     Child Loop BB18_16 Depth 2
                                        #     Child Loop BB18_19 Depth 2
                                        #     Child Loop BB18_21 Depth 2
	block
	block
	loop                            # label41:
	i32.const	$push221=, 2
	i32.shl 	$push220=, $0, $pop221
	tee_local	$push219=, $9=, $pop220
	i32.load	$push218=, ints($pop219)
	tee_local	$push217=, $10=, $pop218
	i32.ctz 	$push216=, $pop217
	tee_local	$push215=, $1=, $pop216
	i32.const	$push214=, 1
	i32.add 	$push3=, $pop215, $pop214
	i32.const	$push213=, 0
	i32.select	$4=, $pop3, $pop213, $10
	i32.const	$8=, 0
	i32.const	$3=, 0
	block
	i32.const	$push377=, 0
	i32.eq  	$push378=, $10, $pop377
	br_if   	0, $pop378      # 0: down to label43
.LBB18_2:                               # %for.body.i
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label44:
	i32.const	$push222=, 1
	i32.shl 	$push4=, $pop222, $8
	i32.and 	$push5=, $pop4, $10
	br_if   	1, $pop5        # 1: down to label45
# BB#3:                                 # %for.inc.i
                                        #   in Loop: Header=BB18_2 Depth=2
	i32.const	$push224=, 1
	i32.add 	$8=, $8, $pop224
	i32.const	$push223=, 32
	i32.lt_u	$push6=, $8, $pop223
	br_if   	0, $pop6        # 0: up to label44
.LBB18_4:                               # %for.end.i
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label45:
	i32.const	$push225=, 1
	i32.add 	$3=, $8, $pop225
.LBB18_5:                               # %my_ffs.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label43:
	i32.ne  	$push7=, $4, $3
	br_if   	2, $pop7        # 2: down to label40
# BB#6:                                 # %if.end
                                        #   in Loop: Header=BB18_1 Depth=1
	block
	i32.const	$push379=, 0
	i32.eq  	$push380=, $10, $pop379
	br_if   	0, $pop380      # 0: down to label46
# BB#7:                                 # %land.lhs.true
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.clz 	$4=, $10
	i32.const	$8=, 0
	i32.const	$3=, 31
.LBB18_8:                               # %for.body.i822
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label47:
	i32.const	$push226=, 1
	i32.shl 	$push8=, $pop226, $3
	i32.and 	$push9=, $pop8, $10
	br_if   	1, $pop9        # 1: down to label48
# BB#9:                                 # %for.inc.i825
                                        #   in Loop: Header=BB18_8 Depth=2
	i32.const	$push229=, 1
	i32.add 	$8=, $8, $pop229
	i32.const	$push228=, -1
	i32.add 	$3=, $3, $pop228
	i32.const	$push227=, 32
	i32.lt_u	$push10=, $8, $pop227
	br_if   	0, $pop10       # 0: up to label47
.LBB18_10:                              # %my_clz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label48:
	i32.ne  	$push11=, $4, $8
	br_if   	3, $pop11       # 3: down to label40
# BB#11:                                # %land.lhs.true13
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$8=, 0
.LBB18_12:                              # %for.body.i889
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label49:
	i32.const	$push230=, 1
	i32.shl 	$push12=, $pop230, $8
	i32.and 	$push13=, $pop12, $10
	br_if   	1, $pop13       # 1: down to label50
# BB#13:                                # %for.inc.i892
                                        #   in Loop: Header=BB18_12 Depth=2
	i32.const	$push232=, 1
	i32.add 	$8=, $8, $pop232
	i32.const	$push231=, 32
	i32.lt_u	$push14=, $8, $pop231
	br_if   	0, $pop14       # 0: up to label49
.LBB18_14:                              # %my_ctz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label50:
	i32.ne  	$push15=, $1, $8
	br_if   	3, $pop15       # 3: down to label40
.LBB18_15:                              # %if.end19
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label46:
	i32.call	$1=, __builtin_clrsb@FUNCTION, $10
	i32.const	$push236=, ints
	i32.add 	$push0=, $9, $pop236
	i32.load	$push235=, 0($pop0)
	tee_local	$push234=, $10=, $pop235
	i32.const	$push233=, 31
	i32.shr_u	$3=, $pop234, $pop233
	i32.const	$4=, 1
	i32.const	$8=, 30
.LBB18_16:                              # %for.body.i974
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label51:
	i32.shr_u	$push16=, $10, $8
	i32.const	$push237=, 1
	i32.and 	$push17=, $pop16, $pop237
	i32.ne  	$push18=, $pop17, $3
	br_if   	1, $pop18       # 1: down to label52
# BB#17:                                # %for.inc.i977
                                        #   in Loop: Header=BB18_16 Depth=2
	i32.const	$push240=, 1
	i32.add 	$4=, $4, $pop240
	i32.const	$push239=, -1
	i32.add 	$8=, $8, $pop239
	i32.const	$push238=, 32
	i32.lt_u	$push19=, $4, $pop238
	br_if   	0, $pop19       # 0: up to label51
.LBB18_18:                              # %my_clrsb.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label52:
	i32.const	$3=, 0
	i32.const	$8=, 0
	i32.const	$push241=, -1
	i32.add 	$push20=, $4, $pop241
	i32.ne  	$push21=, $1, $pop20
	br_if   	2, $pop21       # 2: down to label40
.LBB18_19:                              # %for.body.i1069
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label53:
	i32.const	$push245=, 1
	i32.shl 	$push22=, $pop245, $8
	i32.and 	$push23=, $pop22, $10
	i32.const	$push244=, 0
	i32.ne  	$push24=, $pop23, $pop244
	i32.add 	$3=, $pop24, $3
	i32.const	$push243=, 1
	i32.add 	$8=, $8, $pop243
	i32.const	$push242=, 32
	i32.ne  	$push25=, $8, $pop242
	br_if   	0, $pop25       # 0: up to label53
# BB#20:                                # %my_popcount.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label54:
	i32.const	$4=, 0
	i32.const	$8=, 0
	i32.popcnt	$push26=, $10
	i32.ne  	$push27=, $pop26, $3
	br_if   	2, $pop27       # 2: down to label40
.LBB18_21:                              # %for.body.i1161
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label55:
	i32.const	$push249=, 1
	i32.shl 	$push28=, $pop249, $8
	i32.and 	$push29=, $pop28, $10
	i32.const	$push248=, 0
	i32.ne  	$push30=, $pop29, $pop248
	i32.add 	$4=, $pop30, $4
	i32.const	$push247=, 1
	i32.add 	$8=, $8, $pop247
	i32.const	$push246=, 32
	i32.ne  	$push31=, $8, $pop246
	br_if   	0, $pop31       # 0: up to label55
# BB#22:                                # %my_parity.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label56:
	i32.xor 	$push32=, $4, $3
	i32.const	$push250=, 1
	i32.and 	$push33=, $pop32, $pop250
	br_if   	2, $pop33       # 2: down to label40
# BB#23:                                # %for.cond
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$push212=, 1
	i32.add 	$0=, $0, $pop212
	i32.const	$push211=, 12
	i32.le_u	$push34=, $0, $pop211
	br_if   	0, $pop34       # 0: up to label41
# BB#24:
	end_loop                        # label42:
	i32.const	$0=, 0
.LBB18_25:                              # %for.body41
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_26 Depth 2
                                        #     Child Loop BB18_32 Depth 2
                                        #     Child Loop BB18_36 Depth 2
                                        #     Child Loop BB18_40 Depth 2
                                        #     Child Loop BB18_43 Depth 2
                                        #     Child Loop BB18_45 Depth 2
	loop                            # label57:
	i32.const	$push261=, 2
	i32.shl 	$push260=, $0, $pop261
	tee_local	$push259=, $9=, $pop260
	i32.load	$push258=, longs($pop259)
	tee_local	$push257=, $10=, $pop258
	i32.ctz 	$push256=, $pop257
	tee_local	$push255=, $1=, $pop256
	i32.const	$push254=, 1
	i32.add 	$push35=, $pop255, $pop254
	i32.const	$push253=, 0
	i32.select	$4=, $pop35, $pop253, $10
	i32.const	$8=, 0
	i32.const	$3=, 0
	block
	i32.const	$push381=, 0
	i32.eq  	$push382=, $10, $pop381
	br_if   	0, $pop382      # 0: down to label59
.LBB18_26:                              # %for.body.i1251
                                        #   Parent Loop BB18_25 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label60:
	i32.const	$push262=, 1
	i32.shl 	$push36=, $pop262, $8
	i32.and 	$push37=, $pop36, $10
	br_if   	1, $pop37       # 1: down to label61
# BB#27:                                # %for.inc.i1254
                                        #   in Loop: Header=BB18_26 Depth=2
	i32.const	$push264=, 1
	i32.add 	$8=, $8, $pop264
	i32.const	$push263=, 32
	i32.lt_u	$push38=, $8, $pop263
	br_if   	0, $pop38       # 0: up to label60
.LBB18_28:                              # %for.end.i1257
                                        #   in Loop: Header=BB18_25 Depth=1
	end_loop                        # label61:
	i32.const	$push265=, 1
	i32.add 	$3=, $8, $pop265
.LBB18_29:                              # %my_ffsl.exit
                                        #   in Loop: Header=BB18_25 Depth=1
	end_block                       # label59:
	i32.ne  	$push39=, $4, $3
	br_if   	2, $pop39       # 2: down to label40
# BB#30:                                # %if.end49
                                        #   in Loop: Header=BB18_25 Depth=1
	block
	i32.const	$push383=, 0
	i32.eq  	$push384=, $10, $pop383
	br_if   	0, $pop384      # 0: down to label62
# BB#31:                                # %land.lhs.true52
                                        #   in Loop: Header=BB18_25 Depth=1
	i32.clz 	$4=, $10
	i32.const	$8=, 0
	i32.const	$3=, 31
.LBB18_32:                              # %for.body.i1346
                                        #   Parent Loop BB18_25 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label63:
	i32.const	$push266=, 1
	i32.shl 	$push40=, $pop266, $3
	i32.and 	$push41=, $pop40, $10
	br_if   	1, $pop41       # 1: down to label64
# BB#33:                                # %for.inc.i1349
                                        #   in Loop: Header=BB18_32 Depth=2
	i32.const	$push269=, 1
	i32.add 	$8=, $8, $pop269
	i32.const	$push268=, -1
	i32.add 	$3=, $3, $pop268
	i32.const	$push267=, 32
	i32.lt_u	$push42=, $8, $pop267
	br_if   	0, $pop42       # 0: up to label63
.LBB18_34:                              # %my_clzl.exit
                                        #   in Loop: Header=BB18_25 Depth=1
	end_loop                        # label64:
	i32.ne  	$push43=, $4, $8
	br_if   	3, $pop43       # 3: down to label40
# BB#35:                                # %land.lhs.true61
                                        #   in Loop: Header=BB18_25 Depth=1
	i32.const	$8=, 0
.LBB18_36:                              # %for.body.i1438
                                        #   Parent Loop BB18_25 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label65:
	i32.const	$push270=, 1
	i32.shl 	$push44=, $pop270, $8
	i32.and 	$push45=, $pop44, $10
	br_if   	1, $pop45       # 1: down to label66
# BB#37:                                # %for.inc.i1441
                                        #   in Loop: Header=BB18_36 Depth=2
	i32.const	$push272=, 1
	i32.add 	$8=, $8, $pop272
	i32.const	$push271=, 32
	i32.lt_u	$push46=, $8, $pop271
	br_if   	0, $pop46       # 0: up to label65
.LBB18_38:                              # %my_ctzl.exit
                                        #   in Loop: Header=BB18_25 Depth=1
	end_loop                        # label66:
	i32.ne  	$push47=, $1, $8
	br_if   	3, $pop47       # 3: down to label40
.LBB18_39:                              # %if.end67
                                        #   in Loop: Header=BB18_25 Depth=1
	end_block                       # label62:
	i32.call	$1=, __builtin_clrsbl@FUNCTION, $10
	i32.const	$push276=, longs
	i32.add 	$push1=, $9, $pop276
	i32.load	$push275=, 0($pop1)
	tee_local	$push274=, $10=, $pop275
	i32.const	$push273=, 31
	i32.shr_u	$3=, $pop274, $pop273
	i32.const	$4=, 1
	i32.const	$8=, 30
.LBB18_40:                              # %for.body.i1532
                                        #   Parent Loop BB18_25 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label67:
	i32.shr_u	$push48=, $10, $8
	i32.const	$push277=, 1
	i32.and 	$push49=, $pop48, $pop277
	i32.ne  	$push50=, $pop49, $3
	br_if   	1, $pop50       # 1: down to label68
# BB#41:                                # %for.inc.i1535
                                        #   in Loop: Header=BB18_40 Depth=2
	i32.const	$push280=, 1
	i32.add 	$4=, $4, $pop280
	i32.const	$push279=, -1
	i32.add 	$8=, $8, $pop279
	i32.const	$push278=, 32
	i32.lt_u	$push51=, $4, $pop278
	br_if   	0, $pop51       # 0: up to label67
.LBB18_42:                              # %my_clrsbl.exit
                                        #   in Loop: Header=BB18_25 Depth=1
	end_loop                        # label68:
	i32.const	$3=, 0
	i32.const	$8=, 0
	i32.const	$push281=, -1
	i32.add 	$push52=, $4, $pop281
	i32.ne  	$push53=, $1, $pop52
	br_if   	2, $pop53       # 2: down to label40
.LBB18_43:                              # %for.body.i1630
                                        #   Parent Loop BB18_25 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label69:
	i32.const	$push285=, 1
	i32.shl 	$push54=, $pop285, $8
	i32.and 	$push55=, $pop54, $10
	i32.const	$push284=, 0
	i32.ne  	$push56=, $pop55, $pop284
	i32.add 	$3=, $pop56, $3
	i32.const	$push283=, 1
	i32.add 	$8=, $8, $pop283
	i32.const	$push282=, 32
	i32.ne  	$push57=, $8, $pop282
	br_if   	0, $pop57       # 0: up to label69
# BB#44:                                # %my_popcountl.exit
                                        #   in Loop: Header=BB18_25 Depth=1
	end_loop                        # label70:
	i32.const	$4=, 0
	i32.const	$8=, 0
	i32.popcnt	$push58=, $10
	i32.ne  	$push59=, $pop58, $3
	br_if   	2, $pop59       # 2: down to label40
.LBB18_45:                              # %for.body.i1723
                                        #   Parent Loop BB18_25 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label71:
	i32.const	$push289=, 1
	i32.shl 	$push60=, $pop289, $8
	i32.and 	$push61=, $pop60, $10
	i32.const	$push288=, 0
	i32.ne  	$push62=, $pop61, $pop288
	i32.add 	$4=, $pop62, $4
	i32.const	$push287=, 1
	i32.add 	$8=, $8, $pop287
	i32.const	$push286=, 32
	i32.ne  	$push63=, $8, $pop286
	br_if   	0, $pop63       # 0: up to label71
# BB#46:                                # %my_parityl.exit
                                        #   in Loop: Header=BB18_25 Depth=1
	end_loop                        # label72:
	i32.xor 	$push64=, $4, $3
	i32.const	$push290=, 1
	i32.and 	$push65=, $pop64, $pop290
	br_if   	2, $pop65       # 2: down to label40
# BB#47:                                # %for.cond39
                                        #   in Loop: Header=BB18_25 Depth=1
	i32.const	$push252=, 1
	i32.add 	$0=, $0, $pop252
	i32.const	$push251=, 12
	i32.le_u	$push66=, $0, $pop251
	br_if   	0, $pop66       # 0: up to label57
# BB#48:
	end_loop                        # label58:
	i32.const	$3=, 0
.LBB18_49:                              # %for.body92
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_50 Depth 2
                                        #     Child Loop BB18_56 Depth 2
                                        #     Child Loop BB18_60 Depth 2
                                        #     Child Loop BB18_64 Depth 2
                                        #     Child Loop BB18_68 Depth 2
                                        #     Child Loop BB18_71 Depth 2
	loop                            # label73:
	i32.const	$8=, 0
	i32.const	$push303=, 0
	i32.const	$push302=, 3
	i32.shl 	$push301=, $3, $pop302
	tee_local	$push300=, $0=, $pop301
	i64.load	$push299=, longlongs($pop300)
	tee_local	$push298=, $7=, $pop299
	i64.ctz 	$push297=, $pop298
	tee_local	$push296=, $2=, $pop297
	i64.const	$push295=, 1
	i64.add 	$push67=, $pop296, $pop295
	i32.wrap/i64	$push68=, $pop67
	i64.eqz 	$push294=, $7
	tee_local	$push293=, $10=, $pop294
	i32.select	$4=, $pop303, $pop68, $pop293
	i64.const	$6=, 0
	block
	br_if   	0, $10          # 0: down to label75
.LBB18_50:                              # %for.body.i1814
                                        #   Parent Loop BB18_49 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label76:
	i64.const	$push305=, 1
	i64.shl 	$push69=, $pop305, $6
	i64.and 	$push70=, $pop69, $7
	i64.const	$push304=, 0
	i64.ne  	$push71=, $pop70, $pop304
	br_if   	1, $pop71       # 1: down to label77
# BB#51:                                # %for.inc.i1818
                                        #   in Loop: Header=BB18_50 Depth=2
	i64.const	$push308=, 1
	i64.add 	$6=, $6, $pop308
	i32.const	$push307=, 1
	i32.add 	$8=, $8, $pop307
	i64.const	$push306=, 64
	i64.lt_u	$push72=, $6, $pop306
	br_if   	0, $pop72       # 0: up to label76
.LBB18_52:                              # %for.end.i1821
                                        #   in Loop: Header=BB18_49 Depth=1
	end_loop                        # label77:
	i32.const	$push309=, 1
	i32.add 	$8=, $8, $pop309
.LBB18_53:                              # %my_ffsll.exit1823
                                        #   in Loop: Header=BB18_49 Depth=1
	end_block                       # label75:
	i32.ne  	$push73=, $4, $8
	br_if   	2, $pop73       # 2: down to label40
# BB#54:                                # %if.end100
                                        #   in Loop: Header=BB18_49 Depth=1
	block
	br_if   	0, $10          # 0: down to label78
# BB#55:                                # %land.lhs.true103
                                        #   in Loop: Header=BB18_49 Depth=1
	i64.const	$5=, 0
	i64.const	$6=, 63
	i64.clz 	$push74=, $7
	i32.wrap/i64	$10=, $pop74
	i32.const	$8=, 0
.LBB18_56:                              # %for.body.i1902
                                        #   Parent Loop BB18_49 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label79:
	i64.const	$push312=, 1
	i64.const	$push311=, 4294967295
	i64.and 	$push75=, $6, $pop311
	i64.shl 	$push76=, $pop312, $pop75
	i64.and 	$push77=, $pop76, $7
	i64.const	$push310=, 0
	i64.ne  	$push78=, $pop77, $pop310
	br_if   	1, $pop78       # 1: down to label80
# BB#57:                                # %for.inc.i1906
                                        #   in Loop: Header=BB18_56 Depth=2
	i64.const	$push316=, 1
	i64.add 	$5=, $5, $pop316
	i32.const	$push315=, 1
	i32.add 	$8=, $8, $pop315
	i64.const	$push314=, -1
	i64.add 	$6=, $6, $pop314
	i64.const	$push313=, 64
	i64.lt_u	$push79=, $5, $pop313
	br_if   	0, $pop79       # 0: up to label79
.LBB18_58:                              # %my_clzll.exit1909
                                        #   in Loop: Header=BB18_49 Depth=1
	end_loop                        # label80:
	i32.ne  	$push80=, $10, $8
	br_if   	3, $pop80       # 3: down to label40
# BB#59:                                # %land.lhs.true113
                                        #   in Loop: Header=BB18_49 Depth=1
	i64.const	$6=, 0
	i32.wrap/i64	$10=, $2
	i32.const	$8=, 0
.LBB18_60:                              # %for.body.i1948
                                        #   Parent Loop BB18_49 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label81:
	i64.const	$push318=, 1
	i64.shl 	$push81=, $pop318, $6
	i64.and 	$push82=, $pop81, $7
	i64.const	$push317=, 0
	i64.ne  	$push83=, $pop82, $pop317
	br_if   	1, $pop83       # 1: down to label82
# BB#61:                                # %for.inc.i1952
                                        #   in Loop: Header=BB18_60 Depth=2
	i64.const	$push321=, 1
	i64.add 	$6=, $6, $pop321
	i32.const	$push320=, 1
	i32.add 	$8=, $8, $pop320
	i64.const	$push319=, 64
	i64.lt_u	$push84=, $6, $pop319
	br_if   	0, $pop84       # 0: up to label81
.LBB18_62:                              # %my_ctzll.exit1955
                                        #   in Loop: Header=BB18_49 Depth=1
	end_loop                        # label82:
	i32.ne  	$push85=, $10, $8
	br_if   	3, $pop85       # 3: down to label40
.LBB18_63:                              # %if.end120
                                        #   in Loop: Header=BB18_49 Depth=1
	end_block                       # label78:
	i32.call	$10=, __builtin_clrsbll@FUNCTION, $7
	i32.const	$push325=, longlongs
	i32.add 	$push2=, $0, $pop325
	i64.load	$push324=, 0($pop2)
	tee_local	$push323=, $7=, $pop324
	i64.const	$push322=, 63
	i64.shr_u	$2=, $pop323, $pop322
	i64.const	$5=, 1
	i64.const	$6=, 62
	i32.const	$8=, 1
.LBB18_64:                              # %for.body.i2018
                                        #   Parent Loop BB18_49 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label83:
	i64.shr_u	$push86=, $7, $6
	i64.const	$push326=, 1
	i64.and 	$push87=, $pop86, $pop326
	i64.ne  	$push88=, $pop87, $2
	br_if   	1, $pop88       # 1: down to label84
# BB#65:                                # %for.inc.i2022
                                        #   in Loop: Header=BB18_64 Depth=2
	i64.const	$push330=, 1
	i64.add 	$5=, $5, $pop330
	i32.const	$push329=, 1
	i32.add 	$8=, $8, $pop329
	i64.const	$push328=, -1
	i64.add 	$6=, $6, $pop328
	i64.const	$push327=, 64
	i64.lt_u	$push89=, $5, $pop327
	br_if   	0, $pop89       # 0: up to label83
.LBB18_66:                              # %my_clrsbll.exit2026
                                        #   in Loop: Header=BB18_49 Depth=1
	end_loop                        # label84:
	i32.const	$push331=, -1
	i32.add 	$push90=, $8, $pop331
	i32.ne  	$push91=, $10, $pop90
	br_if   	2, $pop91       # 2: down to label40
# BB#67:                                # %if.end127
                                        #   in Loop: Header=BB18_49 Depth=1
	i64.popcnt	$5=, $7
	i64.const	$6=, 0
	i32.const	$8=, 0
.LBB18_68:                              # %for.body.i2110
                                        #   Parent Loop BB18_49 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label85:
	i64.const	$push335=, 1
	i64.shl 	$push92=, $pop335, $6
	i64.and 	$push93=, $pop92, $7
	i64.const	$push334=, 0
	i64.ne  	$push94=, $pop93, $pop334
	i32.add 	$8=, $pop94, $8
	i64.const	$push333=, 1
	i64.add 	$6=, $6, $pop333
	i64.const	$push332=, 64
	i64.ne  	$push95=, $6, $pop332
	br_if   	0, $pop95       # 0: up to label85
# BB#69:                                # %my_popcountll.exit2112
                                        #   in Loop: Header=BB18_49 Depth=1
	end_loop                        # label86:
	i32.wrap/i64	$push96=, $5
	i32.ne  	$push97=, $pop96, $8
	br_if   	2, $pop97       # 2: down to label40
# BB#70:                                #   in Loop: Header=BB18_49 Depth=1
	i64.const	$6=, 0
	i32.const	$10=, 0
.LBB18_71:                              # %for.body.i2196
                                        #   Parent Loop BB18_49 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label87:
	i64.const	$push339=, 1
	i64.shl 	$push98=, $pop339, $6
	i64.and 	$push99=, $pop98, $7
	i64.const	$push338=, 0
	i64.ne  	$push100=, $pop99, $pop338
	i32.add 	$10=, $pop100, $10
	i64.const	$push337=, 1
	i64.add 	$6=, $6, $pop337
	i64.const	$push336=, 64
	i64.ne  	$push101=, $6, $pop336
	br_if   	0, $pop101      # 0: up to label87
# BB#72:                                # %my_parityll.exit2199
                                        #   in Loop: Header=BB18_49 Depth=1
	end_loop                        # label88:
	i32.xor 	$push102=, $10, $8
	i32.const	$push340=, 1
	i32.and 	$push103=, $pop102, $pop340
	br_if   	3, $pop103      # 3: down to label39
# BB#73:                                # %for.cond90
                                        #   in Loop: Header=BB18_49 Depth=1
	i32.const	$push292=, 1
	i32.add 	$3=, $3, $pop292
	i32.const	$push291=, 12
	i32.le_u	$push104=, $3, $pop291
	br_if   	0, $pop104      # 0: up to label73
# BB#74:                                # %if.end148
	end_loop                        # label74:
	i32.const	$push105=, 0
	i32.call	$push106=, __builtin_clrsb@FUNCTION, $pop105
	i32.const	$push107=, 31
	i32.ne  	$push108=, $pop106, $pop107
	br_if   	0, $pop108      # 0: down to label40
# BB#75:                                # %my_clrsb.exit2770
	i32.const	$push109=, 1
	i32.call	$push110=, __builtin_clrsb@FUNCTION, $pop109
	i32.const	$push111=, 30
	i32.ne  	$push112=, $pop110, $pop111
	br_if   	0, $pop112      # 0: down to label40
# BB#76:                                # %if.end198
	i32.const	$push113=, -2147483648
	i32.call	$push114=, __builtin_clrsb@FUNCTION, $pop113
	br_if   	0, $pop114      # 0: down to label40
# BB#77:                                # %my_clrsb.exit2597
	i32.const	$push115=, 1073741824
	i32.call	$push116=, __builtin_clrsb@FUNCTION, $pop115
	br_if   	0, $pop116      # 0: down to label40
# BB#78:                                # %my_clrsb.exit2514
	i32.const	$push117=, 65536
	i32.call	$push118=, __builtin_clrsb@FUNCTION, $pop117
	i32.const	$push119=, 14
	i32.ne  	$push120=, $pop118, $pop119
	br_if   	0, $pop120      # 0: down to label40
# BB#79:                                # %my_clrsb.exit2432
	i32.const	$push121=, 32768
	i32.call	$push122=, __builtin_clrsb@FUNCTION, $pop121
	i32.const	$push123=, 15
	i32.ne  	$push124=, $pop122, $pop123
	br_if   	0, $pop124      # 0: down to label40
# BB#80:                                # %my_clrsb.exit2348
	i32.const	$push125=, -1515870811
	i32.call	$push126=, __builtin_clrsb@FUNCTION, $pop125
	br_if   	0, $pop126      # 0: down to label40
# BB#81:                                # %my_clrsb.exit2273
	i32.const	$push127=, 1515870810
	i32.call	$push128=, __builtin_clrsb@FUNCTION, $pop127
	br_if   	0, $pop128      # 0: down to label40
# BB#82:                                # %for.body.i2179
	i32.const	$push129=, -889323520
	i32.call	$push130=, __builtin_clrsb@FUNCTION, $pop129
	i32.const	$push131=, 1
	i32.ne  	$push132=, $pop130, $pop131
	br_if   	0, $pop132      # 0: down to label40
# BB#83:                                # %for.body.i2093
	i32.const	$push133=, 13303296
	i32.call	$push134=, __builtin_clrsb@FUNCTION, $pop133
	i32.const	$push135=, 7
	i32.ne  	$push136=, $pop134, $pop135
	br_if   	0, $pop136      # 0: down to label40
# BB#84:                                # %for.body.i2004
	i32.const	$push137=, 51966
	i32.call	$push138=, __builtin_clrsb@FUNCTION, $pop137
	i32.const	$push139=, 15
	i32.ne  	$push140=, $pop138, $pop139
	br_if   	0, $pop140      # 0: down to label40
# BB#85:                                # %if.end423
	i32.const	$push341=, -1
	i32.call	$3=, __builtin_clrsb@FUNCTION, $pop341
	i32.const	$10=, 30
	i32.const	$8=, 1
.LBB18_86:                              # %for.body.i1935
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label89:
	i32.const	$push343=, -1
	i32.shr_u	$push141=, $pop343, $10
	i32.const	$push342=, 1
	i32.and 	$push142=, $pop141, $pop342
	i32.const	$push385=, 0
	i32.eq  	$push386=, $pop142, $pop385
	br_if   	1, $pop386      # 1: down to label90
# BB#87:                                # %for.inc.i1938
                                        #   in Loop: Header=BB18_86 Depth=1
	i32.const	$push346=, 1
	i32.add 	$8=, $8, $pop346
	i32.const	$push345=, -1
	i32.add 	$10=, $10, $pop345
	i32.const	$push344=, 32
	i32.lt_u	$push143=, $8, $pop344
	br_if   	0, $pop143      # 0: up to label89
.LBB18_88:                              # %my_clrsb.exit1942
	end_loop                        # label90:
	i32.const	$push144=, -1
	i32.add 	$push145=, $8, $pop144
	i32.ne  	$push146=, $3, $pop145
	br_if   	0, $pop146      # 0: down to label40
# BB#89:                                # %if.end440
	i64.const	$7=, 0
	i64.const	$push347=, 0
	i32.call	$push147=, __builtin_clrsbll@FUNCTION, $pop347
	i32.const	$push148=, 63
	i32.ne  	$push149=, $pop147, $pop148
	br_if   	0, $pop149      # 0: down to label40
# BB#90:
	i64.const	$6=, 63
	i32.const	$8=, 0
.LBB18_91:                              # %for.body.i1844
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label91:
	i32.wrap/i64	$push150=, $6
	i32.const	$push387=, 0
	i32.eq  	$push388=, $pop150, $pop387
	br_if   	1, $pop388      # 1: down to label92
# BB#92:                                # %for.inc.i1848
                                        #   in Loop: Header=BB18_91 Depth=1
	i64.const	$push351=, 1
	i64.add 	$7=, $7, $pop351
	i32.const	$push350=, 1
	i32.add 	$8=, $8, $pop350
	i64.const	$push349=, -1
	i64.add 	$6=, $6, $pop349
	i64.const	$push348=, 64
	i64.lt_u	$push151=, $7, $pop348
	br_if   	0, $pop151      # 0: up to label91
.LBB18_93:                              # %my_clzll.exit1851
	end_loop                        # label92:
	i32.const	$push152=, 63
	i32.ne  	$push153=, $8, $pop152
	br_if   	0, $pop153      # 0: down to label40
# BB#94:                                # %if.end465
	i64.const	$push352=, 1
	i32.call	$10=, __builtin_clrsbll@FUNCTION, $pop352
	i64.const	$6=, 1
.LBB18_95:                              # %for.body.i1799
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label93:
	i32.const	$8=, 62
	i64.const	$push353=, 63
	i64.eq  	$push154=, $6, $pop353
	br_if   	1, $pop154      # 1: down to label94
# BB#96:                                # %for.inc.i1803
                                        #   in Loop: Header=BB18_95 Depth=1
	i64.const	$push355=, 1
	i64.add 	$6=, $6, $pop355
	i32.const	$8=, 63
	i64.const	$push354=, 64
	i64.lt_u	$push155=, $6, $pop354
	br_if   	0, $pop155      # 0: up to label93
.LBB18_97:                              # %my_clrsbll.exit1807
	end_loop                        # label94:
	i32.ne  	$push156=, $10, $8
	br_if   	0, $pop156      # 0: down to label40
# BB#98:
	i64.const	$6=, 0
.LBB18_99:                              # %for.body.i1759
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label96:
	i64.const	$push356=, 63
	i64.eq  	$push157=, $6, $pop356
	br_if   	2, $pop157      # 2: down to label95
# BB#100:                               # %for.inc.i1763
                                        #   in Loop: Header=BB18_99 Depth=1
	i64.const	$push358=, 1
	i64.add 	$6=, $6, $pop358
	i64.const	$push357=, 64
	i64.lt_u	$push158=, $6, $pop357
	br_if   	0, $pop158      # 0: up to label96
# BB#101:                               # %if.then481
	end_loop                        # label97:
	call    	abort@FUNCTION
	unreachable
.LBB18_102:
	end_block                       # label95:
	i64.const	$6=, 0
.LBB18_103:                             # %for.body.i1731
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label99:
	i64.const	$push359=, 63
	i64.eq  	$push159=, $6, $pop359
	br_if   	2, $pop159      # 2: down to label98
# BB#104:                               # %for.inc.i1735
                                        #   in Loop: Header=BB18_103 Depth=1
	i64.const	$push361=, 1
	i64.add 	$6=, $6, $pop361
	i64.const	$push360=, 64
	i64.lt_u	$push160=, $6, $pop360
	br_if   	0, $pop160      # 0: up to label99
# BB#105:                               # %if.then489
	end_loop                        # label100:
	call    	abort@FUNCTION
	unreachable
.LBB18_106:                             # %if.end490
	end_block                       # label98:
	i64.const	$push161=, -9223372036854775808
	i32.call	$push162=, __builtin_clrsbll@FUNCTION, $pop161
	br_if   	0, $pop162      # 0: down to label40
# BB#107:                               # %for.body.i1665
	i64.const	$6=, 63
	i64.const	$7=, -1
.LBB18_108:                             # %for.body.i1652
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label101:
	i64.const	$push364=, 1
	i64.add 	$7=, $7, $pop364
	i64.const	$push363=, -1
	i64.add 	$5=, $6, $pop363
	i32.wrap/i64	$8=, $6
	copy_local	$6=, $5
	i32.const	$push362=, 1
	i32.ne  	$push163=, $8, $pop362
	br_if   	0, $pop163      # 0: up to label101
# BB#109:                               # %my_clzll.exit1659
	end_loop                        # label102:
	i32.wrap/i64	$push164=, $7
	i32.const	$push165=, 62
	i32.ne  	$push166=, $pop164, $pop165
	br_if   	0, $pop166      # 0: down to label40
# BB#110:                               # %for.body.i1612
	i64.const	$push167=, 2
	i32.call	$push168=, __builtin_clrsbll@FUNCTION, $pop167
	i32.const	$push169=, 61
	i32.ne  	$push170=, $pop168, $pop169
	br_if   	0, $pop170      # 0: down to label40
# BB#111:                               # %my_clrsbll.exit1525
	i64.const	$push171=, 4611686018427387904
	i32.call	$push172=, __builtin_clrsbll@FUNCTION, $pop171
	br_if   	0, $pop172      # 0: down to label40
# BB#112:                               # %for.body.i1425
	i64.const	$push173=, 4294967296
	i32.call	$push174=, __builtin_clrsbll@FUNCTION, $pop173
	i32.const	$push175=, 30
	i32.ne  	$push176=, $pop174, $pop175
	br_if   	0, $pop176      # 0: down to label40
# BB#113:                               # %for.body.i1332
	i64.const	$push177=, 2147483648
	i32.call	$push178=, __builtin_clrsbll@FUNCTION, $pop177
	i32.const	$push179=, 31
	i32.ne  	$push180=, $pop178, $pop179
	br_if   	0, $pop180      # 0: down to label40
# BB#114:                               # %my_clrsbll.exit1245
	i64.const	$push181=, -6510615555426900571
	i32.call	$push182=, __builtin_clrsbll@FUNCTION, $pop181
	br_if   	0, $pop182      # 0: down to label40
# BB#115:                               # %my_clrsbll.exit1152
	i64.const	$push183=, 6510615555426900570
	i32.call	$push184=, __builtin_clrsbll@FUNCTION, $pop183
	br_if   	0, $pop184      # 0: down to label40
# BB#116:                               # %for.body.i1053
	i64.const	$push185=, -3819392241693097984
	i32.call	$push186=, __builtin_clrsbll@FUNCTION, $pop185
	i32.const	$push187=, 1
	i32.ne  	$push188=, $pop186, $pop187
	br_if   	0, $pop188      # 0: down to label40
# BB#117:                               # %for.body.i964
	i64.const	$push189=, 223195676147712
	i32.call	$push190=, __builtin_clrsbll@FUNCTION, $pop189
	i32.const	$push191=, 15
	i32.ne  	$push192=, $pop190, $pop191
	br_if   	0, $pop192      # 0: down to label40
# BB#118:                               # %for.body.i925
	i64.const	$6=, 63
	i64.const	$7=, -1
.LBB18_119:                             # %for.body.i913
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label103:
	i64.const	$push369=, 4294967295
	i64.and 	$5=, $6, $pop369
	i64.const	$push368=, 1
	i64.add 	$7=, $7, $pop368
	i64.const	$push367=, -1
	i64.add 	$6=, $6, $pop367
	i64.const	$push366=, 1
	i64.shl 	$push193=, $pop366, $5
	i64.const	$push365=, 3405695742
	i64.and 	$push194=, $pop193, $pop365
	i64.eqz 	$push195=, $pop194
	br_if   	0, $pop195      # 0: up to label103
# BB#120:                               # %my_clzll.exit
	end_loop                        # label104:
	i32.wrap/i64	$push196=, $7
	i32.const	$push197=, 32
	i32.ne  	$push198=, $pop196, $pop197
	br_if   	0, $pop198      # 0: down to label40
# BB#121:                               # %for.body.i877
	i64.const	$push199=, 3405695742
	i32.call	$push200=, __builtin_clrsbll@FUNCTION, $pop199
	i32.const	$push201=, 31
	i32.ne  	$push202=, $pop200, $pop201
	br_if   	0, $pop202      # 0: down to label40
# BB#122:                               # %if.end740
	i64.const	$push370=, -1
	i32.call	$10=, __builtin_clrsbll@FUNCTION, $pop370
	i64.const	$6=, 62
	i64.const	$7=, 1
	i32.const	$8=, 1
.LBB18_123:                             # %for.body.i812
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label105:
	i64.const	$push372=, -1
	i64.shr_u	$push203=, $pop372, $6
	i64.const	$push371=, 1
	i64.and 	$push204=, $pop203, $pop371
	i64.eqz 	$push205=, $pop204
	br_if   	1, $pop205      # 1: down to label106
# BB#124:                               # %for.inc.i816
                                        #   in Loop: Header=BB18_123 Depth=1
	i64.const	$push376=, 1
	i64.add 	$7=, $7, $pop376
	i32.const	$push375=, 1
	i32.add 	$8=, $8, $pop375
	i64.const	$push374=, -1
	i64.add 	$6=, $6, $pop374
	i64.const	$push373=, 64
	i64.lt_u	$push206=, $7, $pop373
	br_if   	0, $pop206      # 0: up to label105
.LBB18_125:                             # %my_clrsbll.exit
	end_loop                        # label106:
	i32.const	$push207=, -1
	i32.add 	$push208=, $8, $pop207
	i32.ne  	$push209=, $10, $pop208
	br_if   	0, $pop209      # 0: down to label40
# BB#126:                               # %if.end753
	i32.const	$push210=, 0
	call    	exit@FUNCTION, $pop210
	unreachable
.LBB18_127:                             # %if.then37
	end_block                       # label40:
	call    	abort@FUNCTION
	unreachable
.LBB18_128:                             # %if.then140
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
