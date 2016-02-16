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
	i32.const	$push5=, 1
	i32.add 	$1=, $1, $pop5
	i32.const	$push2=, 32
	i32.lt_u	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	i32.const	$push6=, 1
	i32.add 	$1=, $1, $pop6
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
	i32.const	$push5=, 1
	i32.add 	$1=, $1, $pop5
	i32.const	$push2=, 32
	i32.lt_u	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: up to label14
.LBB6_3:                                # %for.end
	end_loop                        # label15:
	i32.const	$push6=, 1
	i32.add 	$1=, $1, $pop6
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
	i64.const	$1=, 0
	i32.const	$2=, 0
	block
	i64.const	$push8=, 0
	i64.eq  	$push0=, $0, $pop8
	br_if   	0, $pop0        # 0: down to label26
.LBB12_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label27:
	i64.const	$push10=, 1
	i64.shl 	$push1=, $pop10, $1
	i64.and 	$push2=, $pop1, $0
	i64.const	$push9=, 0
	i64.ne  	$push3=, $pop2, $pop9
	br_if   	1, $pop3        # 1: down to label28
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB12_1 Depth=1
	i32.const	$push4=, 1
	i32.add 	$2=, $2, $pop4
	i64.const	$push11=, 1
	i64.add 	$1=, $1, $pop11
	i64.const	$push5=, 64
	i64.lt_u	$push6=, $1, $pop5
	br_if   	0, $pop6        # 0: up to label27
.LBB12_3:                               # %for.end
	end_loop                        # label28:
	i32.const	$push7=, 1
	i32.add 	$2=, $2, $pop7
.LBB12_4:                               # %cleanup
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
                                        #     Child Loop BB18_2 Depth 2
                                        #     Child Loop BB18_8 Depth 2
                                        #     Child Loop BB18_12 Depth 2
                                        #     Child Loop BB18_16 Depth 2
                                        #     Child Loop BB18_19 Depth 2
                                        #     Child Loop BB18_21 Depth 2
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
	loop                            # label84:
	i32.const	$push272=, 2
	i32.shl 	$push271=, $0, $pop272
	tee_local	$push270=, $2=, $pop271
	i32.load	$push269=, ints($pop270)
	tee_local	$push268=, $10=, $pop269
	i32.ctz 	$push267=, $pop268
	tee_local	$push266=, $1=, $pop267
	i32.const	$push265=, 1
	i32.add 	$push3=, $pop266, $pop265
	i32.const	$push264=, 0
	i32.select	$5=, $pop3, $pop264, $10
	i32.const	$9=, 0
	i32.const	$4=, 0
	block
	i32.const	$push382=, 0
	i32.eq  	$push383=, $10, $pop382
	br_if   	0, $pop383      # 0: down to label86
.LBB18_2:                               # %for.body.i
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label87:
	i32.const	$push273=, 1
	i32.shl 	$push4=, $pop273, $9
	i32.and 	$push5=, $pop4, $10
	br_if   	1, $pop5        # 1: down to label88
# BB#3:                                 # %for.inc.i
                                        #   in Loop: Header=BB18_2 Depth=2
	i32.const	$push275=, 1
	i32.add 	$9=, $9, $pop275
	i32.const	$push274=, 32
	i32.lt_u	$push6=, $9, $pop274
	br_if   	0, $pop6        # 0: up to label87
.LBB18_4:                               # %for.end.i
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label88:
	i32.const	$push276=, 1
	i32.add 	$4=, $9, $pop276
.LBB18_5:                               # %my_ffs.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label86:
	i32.ne  	$push7=, $5, $4
	br_if   	2, $pop7        # 2: down to label83
# BB#6:                                 # %if.end
                                        #   in Loop: Header=BB18_1 Depth=1
	block
	i32.const	$push384=, 0
	i32.eq  	$push385=, $10, $pop384
	br_if   	0, $pop385      # 0: down to label89
# BB#7:                                 # %land.lhs.true
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.clz 	$5=, $10
	i32.const	$9=, 0
	i32.const	$4=, 31
.LBB18_8:                               # %for.body.i822
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label90:
	i32.const	$push277=, 1
	i32.shl 	$push8=, $pop277, $4
	i32.and 	$push9=, $pop8, $10
	br_if   	1, $pop9        # 1: down to label91
# BB#9:                                 # %for.inc.i825
                                        #   in Loop: Header=BB18_8 Depth=2
	i32.const	$push280=, 1
	i32.add 	$9=, $9, $pop280
	i32.const	$push279=, -1
	i32.add 	$4=, $4, $pop279
	i32.const	$push278=, 32
	i32.lt_u	$push10=, $9, $pop278
	br_if   	0, $pop10       # 0: up to label90
.LBB18_10:                              # %my_clz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label91:
	i32.ne  	$push11=, $5, $9
	br_if   	15, $pop11      # 15: down to label71
# BB#11:                                # %land.lhs.true13
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$9=, 0
.LBB18_12:                              # %for.body.i889
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label92:
	i32.const	$push281=, 1
	i32.shl 	$push12=, $pop281, $9
	i32.and 	$push13=, $pop12, $10
	br_if   	1, $pop13       # 1: down to label93
# BB#13:                                # %for.inc.i892
                                        #   in Loop: Header=BB18_12 Depth=2
	i32.const	$push283=, 1
	i32.add 	$9=, $9, $pop283
	i32.const	$push282=, 32
	i32.lt_u	$push14=, $9, $pop282
	br_if   	0, $pop14       # 0: up to label92
.LBB18_14:                              # %my_ctz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label93:
	i32.ne  	$push15=, $1, $9
	br_if   	16, $pop15      # 16: down to label70
.LBB18_15:                              # %if.end19
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label89:
	i32.call	$1=, __builtin_clrsb@FUNCTION, $10
	i32.const	$push287=, ints
	i32.add 	$push0=, $2, $pop287
	i32.load	$push286=, 0($pop0)
	tee_local	$push285=, $10=, $pop286
	i32.const	$push284=, 31
	i32.shr_u	$4=, $pop285, $pop284
	i32.const	$5=, 1
	i32.const	$9=, 30
.LBB18_16:                              # %for.body.i974
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label94:
	i32.shr_u	$push16=, $10, $9
	i32.const	$push288=, 1
	i32.and 	$push17=, $pop16, $pop288
	i32.ne  	$push18=, $pop17, $4
	br_if   	1, $pop18       # 1: down to label95
# BB#17:                                # %for.inc.i977
                                        #   in Loop: Header=BB18_16 Depth=2
	i32.const	$push291=, 1
	i32.add 	$5=, $5, $pop291
	i32.const	$push290=, -1
	i32.add 	$9=, $9, $pop290
	i32.const	$push289=, 32
	i32.lt_u	$push19=, $5, $pop289
	br_if   	0, $pop19       # 0: up to label94
.LBB18_18:                              # %my_clrsb.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label95:
	i32.const	$4=, 0
	i32.const	$9=, 0
	i32.const	$push292=, -1
	i32.add 	$push20=, $5, $pop292
	i32.ne  	$push21=, $1, $pop20
	br_if   	3, $pop21       # 3: down to label82
.LBB18_19:                              # %for.body.i1069
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label96:
	i32.const	$push296=, 1
	i32.shl 	$push22=, $pop296, $9
	i32.and 	$push23=, $pop22, $10
	i32.const	$push295=, 0
	i32.ne  	$push24=, $pop23, $pop295
	i32.add 	$4=, $pop24, $4
	i32.const	$push294=, 1
	i32.add 	$9=, $9, $pop294
	i32.const	$push293=, 32
	i32.ne  	$push25=, $9, $pop293
	br_if   	0, $pop25       # 0: up to label96
# BB#20:                                # %my_popcount.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label97:
	i32.const	$5=, 0
	i32.const	$9=, 0
	i32.popcnt	$push26=, $10
	i32.ne  	$push27=, $pop26, $4
	br_if   	4, $pop27       # 4: down to label81
.LBB18_21:                              # %for.body.i1161
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label98:
	i32.const	$push300=, 1
	i32.shl 	$push28=, $pop300, $9
	i32.and 	$push29=, $pop28, $10
	i32.const	$push299=, 0
	i32.ne  	$push30=, $pop29, $pop299
	i32.add 	$5=, $pop30, $5
	i32.const	$push298=, 1
	i32.add 	$9=, $9, $pop298
	i32.const	$push297=, 32
	i32.ne  	$push31=, $9, $pop297
	br_if   	0, $pop31       # 0: up to label98
# BB#22:                                # %my_parity.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label99:
	i32.xor 	$push32=, $5, $4
	i32.const	$push301=, 1
	i32.and 	$push33=, $pop32, $pop301
	br_if   	5, $pop33       # 5: down to label80
# BB#23:                                # %for.cond
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$push263=, 1
	i32.add 	$0=, $0, $pop263
	i32.const	$2=, 0
	i32.const	$push262=, 12
	i32.le_u	$push34=, $0, $pop262
	br_if   	0, $pop34       # 0: up to label84
.LBB18_24:                              # %for.body41
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_25 Depth 2
                                        #     Child Loop BB18_31 Depth 2
                                        #     Child Loop BB18_35 Depth 2
                                        #     Child Loop BB18_39 Depth 2
                                        #     Child Loop BB18_42 Depth 2
                                        #     Child Loop BB18_44 Depth 2
	end_loop                        # label85:
	loop                            # label100:
	i32.const	$push35=, 2
	i32.shl 	$push310=, $2, $pop35
	tee_local	$push309=, $0=, $pop310
	i32.load	$push308=, longs($pop309)
	tee_local	$push307=, $10=, $pop308
	i32.ctz 	$push306=, $pop307
	tee_local	$push305=, $1=, $pop306
	i32.const	$push304=, 1
	i32.add 	$push37=, $pop305, $pop304
	i32.const	$push303=, 0
	i32.select	$5=, $pop37, $pop303, $10
	i32.const	$9=, 0
	i32.const	$4=, 0
	block
	i32.const	$push386=, 0
	i32.eq  	$push387=, $10, $pop386
	br_if   	0, $pop387      # 0: down to label102
.LBB18_25:                              # %for.body.i1251
                                        #   Parent Loop BB18_24 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label103:
	i32.const	$push311=, 1
	i32.shl 	$push38=, $pop311, $9
	i32.and 	$push39=, $pop38, $10
	br_if   	1, $pop39       # 1: down to label104
# BB#26:                                # %for.inc.i1254
                                        #   in Loop: Header=BB18_25 Depth=2
	i32.const	$push40=, 1
	i32.add 	$9=, $9, $pop40
	i32.const	$push41=, 32
	i32.lt_u	$push42=, $9, $pop41
	br_if   	0, $pop42       # 0: up to label103
.LBB18_27:                              # %for.end.i1257
                                        #   in Loop: Header=BB18_24 Depth=1
	end_loop                        # label104:
	i32.const	$push43=, 1
	i32.add 	$4=, $9, $pop43
.LBB18_28:                              # %my_ffsl.exit
                                        #   in Loop: Header=BB18_24 Depth=1
	end_block                       # label102:
	i32.ne  	$push44=, $5, $4
	br_if   	6, $pop44       # 6: down to label79
# BB#29:                                # %if.end49
                                        #   in Loop: Header=BB18_24 Depth=1
	block
	i32.const	$push388=, 0
	i32.eq  	$push389=, $10, $pop388
	br_if   	0, $pop389      # 0: down to label105
# BB#30:                                # %land.lhs.true52
                                        #   in Loop: Header=BB18_24 Depth=1
	i32.clz 	$5=, $10
	i32.const	$9=, 0
	i32.const	$4=, 31
.LBB18_31:                              # %for.body.i1346
                                        #   Parent Loop BB18_24 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label106:
	i32.const	$push312=, 1
	i32.shl 	$push45=, $pop312, $4
	i32.and 	$push46=, $pop45, $10
	br_if   	1, $pop46       # 1: down to label107
# BB#32:                                # %for.inc.i1349
                                        #   in Loop: Header=BB18_31 Depth=2
	i32.const	$push313=, 1
	i32.add 	$9=, $9, $pop313
	i32.const	$push47=, -1
	i32.add 	$4=, $4, $pop47
	i32.const	$push48=, 32
	i32.lt_u	$push49=, $9, $pop48
	br_if   	0, $pop49       # 0: up to label106
.LBB18_33:                              # %my_clzl.exit
                                        #   in Loop: Header=BB18_24 Depth=1
	end_loop                        # label107:
	i32.ne  	$push50=, $5, $9
	br_if   	17, $pop50      # 17: down to label69
# BB#34:                                # %land.lhs.true61
                                        #   in Loop: Header=BB18_24 Depth=1
	i32.const	$9=, 0
.LBB18_35:                              # %for.body.i1438
                                        #   Parent Loop BB18_24 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label108:
	i32.const	$push314=, 1
	i32.shl 	$push51=, $pop314, $9
	i32.and 	$push52=, $pop51, $10
	br_if   	1, $pop52       # 1: down to label109
# BB#36:                                # %for.inc.i1441
                                        #   in Loop: Header=BB18_35 Depth=2
	i32.const	$push315=, 1
	i32.add 	$9=, $9, $pop315
	i32.const	$push53=, 32
	i32.lt_u	$push54=, $9, $pop53
	br_if   	0, $pop54       # 0: up to label108
.LBB18_37:                              # %my_ctzl.exit
                                        #   in Loop: Header=BB18_24 Depth=1
	end_loop                        # label109:
	i32.ne  	$push55=, $1, $9
	br_if   	18, $pop55      # 18: down to label68
.LBB18_38:                              # %if.end67
                                        #   in Loop: Header=BB18_24 Depth=1
	end_block                       # label105:
	i32.call	$1=, __builtin_clrsbl@FUNCTION, $10
	i32.const	$push36=, longs
	i32.add 	$push1=, $0, $pop36
	i32.load	$push317=, 0($pop1)
	tee_local	$push316=, $10=, $pop317
	i32.const	$push56=, 31
	i32.shr_u	$4=, $pop316, $pop56
	i32.const	$9=, 30
	i32.const	$5=, 1
.LBB18_39:                              # %for.body.i1532
                                        #   Parent Loop BB18_24 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label110:
	i32.shr_u	$push57=, $10, $9
	i32.const	$push318=, 1
	i32.and 	$push58=, $pop57, $pop318
	i32.ne  	$push59=, $pop58, $4
	br_if   	1, $pop59       # 1: down to label111
# BB#40:                                # %for.inc.i1535
                                        #   in Loop: Header=BB18_39 Depth=2
	i32.const	$push60=, 1
	i32.add 	$5=, $5, $pop60
	i32.const	$push61=, -1
	i32.add 	$9=, $9, $pop61
	i32.const	$push62=, 32
	i32.lt_u	$push63=, $5, $pop62
	br_if   	0, $pop63       # 0: up to label110
.LBB18_41:                              # %my_clrsbl.exit
                                        #   in Loop: Header=BB18_24 Depth=1
	end_loop                        # label111:
	i32.const	$4=, 0
	i32.const	$9=, 0
	i32.const	$push64=, -1
	i32.add 	$push65=, $5, $pop64
	i32.ne  	$push66=, $1, $pop65
	br_if   	7, $pop66       # 7: down to label78
.LBB18_42:                              # %for.body.i1630
                                        #   Parent Loop BB18_24 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label112:
	i32.const	$push67=, 1
	i32.shl 	$push68=, $pop67, $9
	i32.and 	$push69=, $pop68, $10
	i32.const	$push320=, 0
	i32.ne  	$push70=, $pop69, $pop320
	i32.add 	$4=, $pop70, $4
	i32.const	$push319=, 1
	i32.add 	$9=, $9, $pop319
	i32.const	$push71=, 32
	i32.ne  	$push72=, $9, $pop71
	br_if   	0, $pop72       # 0: up to label112
# BB#43:                                # %my_popcountl.exit
                                        #   in Loop: Header=BB18_24 Depth=1
	end_loop                        # label113:
	i32.const	$5=, 0
	i32.const	$9=, 0
	i32.popcnt	$push73=, $10
	i32.ne  	$push74=, $pop73, $4
	br_if   	8, $pop74       # 8: down to label77
.LBB18_44:                              # %for.body.i1723
                                        #   Parent Loop BB18_24 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label114:
	i32.const	$push323=, 1
	i32.shl 	$push75=, $pop323, $9
	i32.and 	$push76=, $pop75, $10
	i32.const	$push322=, 0
	i32.ne  	$push77=, $pop76, $pop322
	i32.add 	$5=, $pop77, $5
	i32.const	$push321=, 1
	i32.add 	$9=, $9, $pop321
	i32.const	$push78=, 32
	i32.ne  	$push79=, $9, $pop78
	br_if   	0, $pop79       # 0: up to label114
# BB#45:                                # %my_parityl.exit
                                        #   in Loop: Header=BB18_24 Depth=1
	end_loop                        # label115:
	i32.xor 	$push80=, $5, $4
	i32.const	$push324=, 1
	i32.and 	$push81=, $pop80, $pop324
	br_if   	9, $pop81       # 9: down to label76
# BB#46:                                # %for.cond39
                                        #   in Loop: Header=BB18_24 Depth=1
	i32.const	$push302=, 1
	i32.add 	$2=, $2, $pop302
	i32.const	$4=, 0
	i32.const	$push82=, 12
	i32.le_u	$push83=, $2, $pop82
	br_if   	0, $pop83       # 0: up to label100
.LBB18_47:                              # %for.body92
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_48 Depth 2
                                        #     Child Loop BB18_54 Depth 2
                                        #     Child Loop BB18_58 Depth 2
                                        #     Child Loop BB18_62 Depth 2
                                        #     Child Loop BB18_66 Depth 2
                                        #     Child Loop BB18_68 Depth 2
	end_loop                        # label101:
	loop                            # label116:
	i32.const	$push336=, 0
	i32.const	$push84=, 3
	i32.shl 	$push335=, $4, $pop84
	tee_local	$push334=, $0=, $pop335
	i64.load	$push333=, longlongs($pop334)
	tee_local	$push332=, $8=, $pop333
	i64.ctz 	$push331=, $pop332
	tee_local	$push330=, $3=, $pop331
	i64.const	$push329=, 1
	i64.add 	$push86=, $pop330, $pop329
	i32.wrap/i64	$push87=, $pop86
	i64.const	$push328=, 0
	i64.eq  	$push327=, $8, $pop328
	tee_local	$push326=, $5=, $pop327
	i32.select	$2=, $pop336, $pop87, $pop326
	i64.const	$7=, 0
	i32.const	$9=, 0
	i32.const	$10=, 0
	block
	br_if   	0, $5           # 0: down to label118
.LBB18_48:                              # %for.body.i1814
                                        #   Parent Loop BB18_47 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label119:
	i64.const	$push338=, 1
	i64.shl 	$push88=, $pop338, $7
	i64.and 	$push89=, $pop88, $8
	i64.const	$push337=, 0
	i64.ne  	$push90=, $pop89, $pop337
	br_if   	1, $pop90       # 1: down to label120
# BB#49:                                # %for.inc.i1818
                                        #   in Loop: Header=BB18_48 Depth=2
	i32.const	$push92=, 1
	i32.add 	$9=, $9, $pop92
	i64.const	$push91=, 1
	i64.add 	$7=, $7, $pop91
	i64.const	$push93=, 64
	i64.lt_u	$push94=, $7, $pop93
	br_if   	0, $pop94       # 0: up to label119
.LBB18_50:                              # %for.end.i1821
                                        #   in Loop: Header=BB18_47 Depth=1
	end_loop                        # label120:
	i32.const	$push95=, 1
	i32.add 	$10=, $9, $pop95
.LBB18_51:                              # %my_ffsll.exit1823
                                        #   in Loop: Header=BB18_47 Depth=1
	end_block                       # label118:
	i32.ne  	$push96=, $2, $10
	br_if   	10, $pop96      # 10: down to label75
# BB#52:                                # %if.end100
                                        #   in Loop: Header=BB18_47 Depth=1
	i64.const	$7=, 0
	block
	i64.const	$push339=, 0
	i64.eq  	$push97=, $8, $pop339
	br_if   	0, $pop97       # 0: down to label121
# BB#53:                                # %land.lhs.true103
                                        #   in Loop: Header=BB18_47 Depth=1
	i64.const	$6=, 63
	i64.clz 	$push98=, $8
	i32.wrap/i64	$10=, $pop98
	i32.const	$9=, 0
.LBB18_54:                              # %for.body.i1902
                                        #   Parent Loop BB18_47 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label122:
	i64.const	$push340=, 1
	i64.const	$push99=, 4294967295
	i64.and 	$push100=, $6, $pop99
	i64.shl 	$push101=, $pop340, $pop100
	i64.and 	$push102=, $pop101, $8
	i64.const	$push103=, 0
	i64.ne  	$push104=, $pop102, $pop103
	br_if   	1, $pop104      # 1: down to label123
# BB#55:                                # %for.inc.i1906
                                        #   in Loop: Header=BB18_54 Depth=2
	i32.const	$push105=, 1
	i32.add 	$9=, $9, $pop105
	i64.const	$push341=, 1
	i64.add 	$7=, $7, $pop341
	i64.const	$push106=, -1
	i64.add 	$6=, $6, $pop106
	i64.const	$push107=, 64
	i64.lt_u	$push108=, $7, $pop107
	br_if   	0, $pop108      # 0: up to label122
.LBB18_56:                              # %my_clzll.exit1909
                                        #   in Loop: Header=BB18_47 Depth=1
	end_loop                        # label123:
	i32.ne  	$push109=, $10, $9
	br_if   	19, $pop109     # 19: down to label67
# BB#57:                                # %land.lhs.true113
                                        #   in Loop: Header=BB18_47 Depth=1
	i64.const	$7=, 0
	i32.wrap/i64	$10=, $3
	i32.const	$9=, 0
.LBB18_58:                              # %for.body.i1948
                                        #   Parent Loop BB18_47 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label124:
	i64.const	$push343=, 1
	i64.shl 	$push110=, $pop343, $7
	i64.and 	$push111=, $pop110, $8
	i64.const	$push342=, 0
	i64.ne  	$push112=, $pop111, $pop342
	br_if   	1, $pop112      # 1: down to label125
# BB#59:                                # %for.inc.i1952
                                        #   in Loop: Header=BB18_58 Depth=2
	i32.const	$push113=, 1
	i32.add 	$9=, $9, $pop113
	i64.const	$push344=, 1
	i64.add 	$7=, $7, $pop344
	i64.const	$push114=, 64
	i64.lt_u	$push115=, $7, $pop114
	br_if   	0, $pop115      # 0: up to label124
.LBB18_60:                              # %my_ctzll.exit1955
                                        #   in Loop: Header=BB18_47 Depth=1
	end_loop                        # label125:
	i32.ne  	$push116=, $10, $9
	br_if   	20, $pop116     # 20: down to label66
.LBB18_61:                              # %if.end120
                                        #   in Loop: Header=BB18_47 Depth=1
	end_block                       # label121:
	i32.call	$10=, __builtin_clrsbll@FUNCTION, $8
	i32.const	$push85=, longlongs
	i32.add 	$push2=, $0, $pop85
	i64.load	$push346=, 0($pop2)
	tee_local	$push345=, $8=, $pop346
	i64.const	$push117=, 63
	i64.shr_u	$3=, $pop345, $pop117
	i64.const	$7=, 62
	i64.const	$6=, 1
	i32.const	$9=, 1
.LBB18_62:                              # %for.body.i2018
                                        #   Parent Loop BB18_47 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label126:
	i64.shr_u	$push118=, $8, $7
	i64.const	$push347=, 1
	i64.and 	$push119=, $pop118, $pop347
	i64.ne  	$push120=, $pop119, $3
	br_if   	1, $pop120      # 1: down to label127
# BB#63:                                # %for.inc.i2022
                                        #   in Loop: Header=BB18_62 Depth=2
	i32.const	$push122=, 1
	i32.add 	$9=, $9, $pop122
	i64.const	$push121=, 1
	i64.add 	$6=, $6, $pop121
	i64.const	$push123=, -1
	i64.add 	$7=, $7, $pop123
	i64.const	$push124=, 64
	i64.lt_u	$push125=, $6, $pop124
	br_if   	0, $pop125      # 0: up to label126
.LBB18_64:                              # %my_clrsbll.exit2026
                                        #   in Loop: Header=BB18_47 Depth=1
	end_loop                        # label127:
	i32.const	$push126=, -1
	i32.add 	$push127=, $9, $pop126
	i32.ne  	$push128=, $10, $pop127
	br_if   	11, $pop128     # 11: down to label74
# BB#65:                                # %if.end127
                                        #   in Loop: Header=BB18_47 Depth=1
	i64.popcnt	$6=, $8
	i64.const	$7=, 0
	i32.const	$9=, 0
.LBB18_66:                              # %for.body.i2110
                                        #   Parent Loop BB18_47 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label128:
	i64.const	$push129=, 1
	i64.shl 	$push130=, $pop129, $7
	i64.and 	$push131=, $pop130, $8
	i64.const	$push349=, 0
	i64.ne  	$push132=, $pop131, $pop349
	i32.add 	$9=, $pop132, $9
	i64.const	$push348=, 1
	i64.add 	$7=, $7, $pop348
	i64.const	$push133=, 64
	i64.ne  	$push134=, $7, $pop133
	br_if   	0, $pop134      # 0: up to label128
# BB#67:                                # %my_popcountll.exit2112
                                        #   in Loop: Header=BB18_47 Depth=1
	end_loop                        # label129:
	i64.const	$7=, 0
	i32.const	$10=, 0
	i32.wrap/i64	$push135=, $6
	i32.ne  	$push136=, $pop135, $9
	br_if   	12, $pop136     # 12: down to label73
.LBB18_68:                              # %for.body.i2196
                                        #   Parent Loop BB18_47 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label130:
	i64.const	$push137=, 1
	i64.shl 	$push138=, $pop137, $7
	i64.and 	$push139=, $pop138, $8
	i64.const	$push351=, 0
	i64.ne  	$push140=, $pop139, $pop351
	i32.add 	$10=, $pop140, $10
	i64.const	$push350=, 1
	i64.add 	$7=, $7, $pop350
	i64.const	$push141=, 64
	i64.ne  	$push142=, $7, $pop141
	br_if   	0, $pop142      # 0: up to label130
# BB#69:                                # %my_parityll.exit2199
                                        #   in Loop: Header=BB18_47 Depth=1
	end_loop                        # label131:
	i32.xor 	$push143=, $10, $9
	i32.const	$push144=, 1
	i32.and 	$push145=, $pop143, $pop144
	br_if   	13, $pop145     # 13: down to label72
# BB#70:                                # %for.cond90
                                        #   in Loop: Header=BB18_47 Depth=1
	i32.const	$push325=, 1
	i32.add 	$4=, $4, $pop325
	i32.const	$push146=, 12
	i32.le_u	$push147=, $4, $pop146
	br_if   	0, $pop147      # 0: up to label116
# BB#71:                                # %if.end148
	end_loop                        # label117:
	i32.const	$push148=, 0
	i32.call	$push149=, __builtin_clrsb@FUNCTION, $pop148
	i32.const	$push150=, 31
	i32.ne  	$push151=, $pop149, $pop150
	br_if   	18, $pop151     # 18: down to label65
# BB#72:                                # %my_clrsb.exit2770
	i32.const	$push152=, 1
	i32.call	$push153=, __builtin_clrsb@FUNCTION, $pop152
	i32.const	$push154=, 30
	i32.ne  	$push155=, $pop153, $pop154
	br_if   	19, $pop155     # 19: down to label64
# BB#73:                                # %if.end198
	i32.const	$push156=, -2147483648
	i32.call	$push157=, __builtin_clrsb@FUNCTION, $pop156
	br_if   	20, $pop157     # 20: down to label63
# BB#74:                                # %my_clrsb.exit2597
	i32.const	$push158=, 1073741824
	i32.call	$push159=, __builtin_clrsb@FUNCTION, $pop158
	br_if   	21, $pop159     # 21: down to label62
# BB#75:                                # %my_clrsb.exit2514
	i32.const	$push160=, 65536
	i32.call	$push161=, __builtin_clrsb@FUNCTION, $pop160
	i32.const	$push162=, 14
	i32.ne  	$push163=, $pop161, $pop162
	br_if   	22, $pop163     # 22: down to label61
# BB#76:                                # %my_clrsb.exit2432
	i32.const	$push164=, 32768
	i32.call	$push165=, __builtin_clrsb@FUNCTION, $pop164
	i32.const	$push166=, 15
	i32.ne  	$push167=, $pop165, $pop166
	br_if   	23, $pop167     # 23: down to label60
# BB#77:                                # %my_clrsb.exit2348
	i32.const	$push168=, -1515870811
	i32.call	$push169=, __builtin_clrsb@FUNCTION, $pop168
	br_if   	24, $pop169     # 24: down to label59
# BB#78:                                # %my_clrsb.exit2273
	i32.const	$push170=, 1515870810
	i32.call	$push171=, __builtin_clrsb@FUNCTION, $pop170
	br_if   	25, $pop171     # 25: down to label58
# BB#79:                                # %for.body.i2179
	i32.const	$push172=, -889323520
	i32.call	$push173=, __builtin_clrsb@FUNCTION, $pop172
	i32.const	$push174=, 1
	i32.ne  	$push175=, $pop173, $pop174
	br_if   	26, $pop175     # 26: down to label57
# BB#80:                                # %for.body.i2093
	i32.const	$push176=, 13303296
	i32.call	$push177=, __builtin_clrsb@FUNCTION, $pop176
	i32.const	$push178=, 7
	i32.ne  	$push179=, $pop177, $pop178
	br_if   	27, $pop179     # 27: down to label56
# BB#81:                                # %for.body.i2004
	i32.const	$push180=, 51966
	i32.call	$push181=, __builtin_clrsb@FUNCTION, $pop180
	i32.const	$push182=, 15
	i32.ne  	$push183=, $pop181, $pop182
	br_if   	28, $pop183     # 28: down to label55
# BB#82:                                # %if.end423
	i32.const	$push352=, -1
	i32.call	$4=, __builtin_clrsb@FUNCTION, $pop352
	i32.const	$10=, 30
	i32.const	$9=, 1
.LBB18_83:                              # %for.body.i1935
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label132:
	i32.const	$push354=, -1
	i32.shr_u	$push184=, $pop354, $10
	i32.const	$push353=, 1
	i32.and 	$push185=, $pop184, $pop353
	i32.const	$push390=, 0
	i32.eq  	$push391=, $pop185, $pop390
	br_if   	1, $pop391      # 1: down to label133
# BB#84:                                # %for.inc.i1938
                                        #   in Loop: Header=BB18_83 Depth=1
	i32.const	$push357=, 1
	i32.add 	$9=, $9, $pop357
	i32.const	$push356=, -1
	i32.add 	$10=, $10, $pop356
	i32.const	$push355=, 32
	i32.lt_u	$push186=, $9, $pop355
	br_if   	0, $pop186      # 0: up to label132
.LBB18_85:                              # %my_clrsb.exit1942
	end_loop                        # label133:
	i32.const	$push187=, -1
	i32.add 	$push188=, $9, $pop187
	i32.ne  	$push189=, $4, $pop188
	br_if   	29, $pop189     # 29: down to label54
# BB#86:                                # %if.end440
	i64.const	$8=, 0
	i64.const	$7=, 63
	i32.const	$9=, 0
	i64.const	$push358=, 0
	i32.call	$push190=, __builtin_clrsbll@FUNCTION, $pop358
	i32.const	$push191=, 63
	i32.ne  	$push192=, $pop190, $pop191
	br_if   	30, $pop192     # 30: down to label53
.LBB18_87:                              # %for.body.i1844
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label134:
	i32.wrap/i64	$push193=, $7
	i32.const	$push392=, 0
	i32.eq  	$push393=, $pop193, $pop392
	br_if   	1, $pop393      # 1: down to label135
# BB#88:                                # %for.inc.i1848
                                        #   in Loop: Header=BB18_87 Depth=1
	i32.const	$push195=, 1
	i32.add 	$9=, $9, $pop195
	i64.const	$push194=, 1
	i64.add 	$8=, $8, $pop194
	i64.const	$push196=, -1
	i64.add 	$7=, $7, $pop196
	i64.const	$push197=, 64
	i64.lt_u	$push198=, $8, $pop197
	br_if   	0, $pop198      # 0: up to label134
.LBB18_89:                              # %my_clzll.exit1851
	end_loop                        # label135:
	i32.const	$push199=, 63
	i32.ne  	$push200=, $9, $pop199
	br_if   	31, $pop200     # 31: down to label52
# BB#90:                                # %if.end465
	i64.const	$push359=, 1
	i32.call	$10=, __builtin_clrsbll@FUNCTION, $pop359
	i64.const	$7=, 1
.LBB18_91:                              # %for.body.i1799
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label136:
	i32.const	$9=, 62
	i64.const	$push360=, 63
	i64.eq  	$push201=, $7, $pop360
	br_if   	1, $pop201      # 1: down to label137
# BB#92:                                # %for.inc.i1803
                                        #   in Loop: Header=BB18_91 Depth=1
	i64.const	$push362=, 1
	i64.add 	$7=, $7, $pop362
	i32.const	$9=, 63
	i64.const	$push361=, 64
	i64.lt_u	$push202=, $7, $pop361
	br_if   	0, $pop202      # 0: up to label136
.LBB18_93:                              # %my_clrsbll.exit1807
	end_loop                        # label137:
	i64.const	$8=, 0
	i64.const	$7=, 0
	i32.ne  	$push203=, $10, $9
	br_if   	32, $pop203     # 32: down to label51
.LBB18_94:                              # %for.body.i1759
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label139:
	i64.const	$push363=, 63
	i64.eq  	$push204=, $7, $pop363
	br_if   	2, $pop204      # 2: down to label138
# BB#95:                                # %for.inc.i1763
                                        #   in Loop: Header=BB18_94 Depth=1
	i64.const	$push205=, 1
	i64.add 	$7=, $7, $pop205
	i64.const	$push206=, 64
	i64.lt_u	$push207=, $7, $pop206
	br_if   	0, $pop207      # 0: up to label139
# BB#96:                                # %if.then481
	end_loop                        # label140:
	call    	abort@FUNCTION
	unreachable
.LBB18_97:                              # %for.body.i1731
                                        # =>This Inner Loop Header: Depth=1
	end_block                       # label138:
	block
	loop                            # label142:
	i64.const	$push364=, 63
	i64.eq  	$push208=, $8, $pop364
	br_if   	2, $pop208      # 2: down to label141
# BB#98:                                # %for.inc.i1735
                                        #   in Loop: Header=BB18_97 Depth=1
	i64.const	$push209=, 1
	i64.add 	$8=, $8, $pop209
	i64.const	$push210=, 64
	i64.lt_u	$push211=, $8, $pop210
	br_if   	0, $pop211      # 0: up to label142
# BB#99:                                # %if.then489
	end_loop                        # label143:
	call    	abort@FUNCTION
	unreachable
.LBB18_100:                             # %if.end490
	end_block                       # label141:
	i64.const	$push212=, -9223372036854775808
	i32.call	$push213=, __builtin_clrsbll@FUNCTION, $pop212
	br_if   	33, $pop213     # 33: down to label50
# BB#101:                               # %for.body.i1665
	i64.const	$7=, 63
	i64.const	$8=, -1
.LBB18_102:                             # %for.body.i1652
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label144:
	i64.const	$push367=, 1
	i64.add 	$8=, $8, $pop367
	i64.const	$push366=, -1
	i64.add 	$6=, $7, $pop366
	i32.wrap/i64	$9=, $7
	copy_local	$7=, $6
	i32.const	$push365=, 1
	i32.ne  	$push214=, $9, $pop365
	br_if   	0, $pop214      # 0: up to label144
# BB#103:                               # %my_clzll.exit1659
	end_loop                        # label145:
	i32.wrap/i64	$push215=, $8
	i32.const	$push216=, 62
	i32.ne  	$push217=, $pop215, $pop216
	br_if   	34, $pop217     # 34: down to label49
# BB#104:                               # %for.body.i1612
	i64.const	$push218=, 2
	i32.call	$push219=, __builtin_clrsbll@FUNCTION, $pop218
	i32.const	$push220=, 61
	i32.ne  	$push221=, $pop219, $pop220
	br_if   	35, $pop221     # 35: down to label48
# BB#105:                               # %my_clrsbll.exit1525
	i64.const	$push222=, 4611686018427387904
	i32.call	$push223=, __builtin_clrsbll@FUNCTION, $pop222
	br_if   	36, $pop223     # 36: down to label47
# BB#106:                               # %for.body.i1425
	i64.const	$push224=, 4294967296
	i32.call	$push225=, __builtin_clrsbll@FUNCTION, $pop224
	i32.const	$push226=, 30
	i32.ne  	$push227=, $pop225, $pop226
	br_if   	37, $pop227     # 37: down to label46
# BB#107:                               # %for.body.i1332
	i64.const	$push228=, 2147483648
	i32.call	$push229=, __builtin_clrsbll@FUNCTION, $pop228
	i32.const	$push230=, 31
	i32.ne  	$push231=, $pop229, $pop230
	br_if   	38, $pop231     # 38: down to label45
# BB#108:                               # %my_clrsbll.exit1245
	i64.const	$push232=, -6510615555426900571
	i32.call	$push233=, __builtin_clrsbll@FUNCTION, $pop232
	br_if   	39, $pop233     # 39: down to label44
# BB#109:                               # %my_clrsbll.exit1152
	i64.const	$push234=, 6510615555426900570
	i32.call	$push235=, __builtin_clrsbll@FUNCTION, $pop234
	br_if   	40, $pop235     # 40: down to label43
# BB#110:                               # %for.body.i1053
	i64.const	$push236=, -3819392241693097984
	i32.call	$push237=, __builtin_clrsbll@FUNCTION, $pop236
	i32.const	$push238=, 1
	i32.ne  	$push239=, $pop237, $pop238
	br_if   	41, $pop239     # 41: down to label42
# BB#111:                               # %for.body.i964
	i64.const	$push240=, 223195676147712
	i32.call	$push241=, __builtin_clrsbll@FUNCTION, $pop240
	i32.const	$push242=, 15
	i32.ne  	$push243=, $pop241, $pop242
	br_if   	42, $pop243     # 42: down to label41
# BB#112:                               # %for.body.i925
	i64.const	$7=, 63
	i64.const	$8=, -1
.LBB18_113:                             # %for.body.i913
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label146:
	i64.const	$push373=, 4294967295
	i64.and 	$6=, $7, $pop373
	i64.const	$push372=, 1
	i64.add 	$8=, $8, $pop372
	i64.const	$push371=, -1
	i64.add 	$7=, $7, $pop371
	i64.const	$push370=, 1
	i64.shl 	$push244=, $pop370, $6
	i64.const	$push369=, 3405695742
	i64.and 	$push245=, $pop244, $pop369
	i64.const	$push368=, 0
	i64.eq  	$push246=, $pop245, $pop368
	br_if   	0, $pop246      # 0: up to label146
# BB#114:                               # %my_clzll.exit
	end_loop                        # label147:
	i32.wrap/i64	$push247=, $8
	i32.const	$push248=, 32
	i32.ne  	$push249=, $pop247, $pop248
	br_if   	43, $pop249     # 43: down to label40
# BB#115:                               # %for.body.i877
	i64.const	$push250=, 3405695742
	i32.call	$push251=, __builtin_clrsbll@FUNCTION, $pop250
	i32.const	$push252=, 31
	i32.ne  	$push253=, $pop251, $pop252
	br_if   	44, $pop253     # 44: down to label39
# BB#116:                               # %if.end740
	i64.const	$push374=, -1
	i32.call	$10=, __builtin_clrsbll@FUNCTION, $pop374
	i64.const	$7=, 62
	i64.const	$8=, 1
	i32.const	$9=, 1
.LBB18_117:                             # %for.body.i812
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label148:
	i64.const	$push377=, -1
	i64.shr_u	$push254=, $pop377, $7
	i64.const	$push376=, 1
	i64.and 	$push255=, $pop254, $pop376
	i64.const	$push375=, 0
	i64.eq  	$push256=, $pop255, $pop375
	br_if   	1, $pop256      # 1: down to label149
# BB#118:                               # %for.inc.i816
                                        #   in Loop: Header=BB18_117 Depth=1
	i64.const	$push381=, 1
	i64.add 	$8=, $8, $pop381
	i32.const	$push380=, 1
	i32.add 	$9=, $9, $pop380
	i64.const	$push379=, -1
	i64.add 	$7=, $7, $pop379
	i64.const	$push378=, 64
	i64.lt_u	$push257=, $8, $pop378
	br_if   	0, $pop257      # 0: up to label148
.LBB18_119:                             # %my_clrsbll.exit
	end_loop                        # label149:
	block
	i32.const	$push258=, -1
	i32.add 	$push259=, $9, $pop258
	i32.ne  	$push260=, $10, $pop259
	br_if   	0, $pop260      # 0: down to label150
# BB#120:                               # %if.end753
	i32.const	$push261=, 0
	call    	exit@FUNCTION, $pop261
	unreachable
.LBB18_121:                             # %if.then744
	end_block                       # label150:
	call    	abort@FUNCTION
	unreachable
.LBB18_122:                             # %if.then
	end_block                       # label83:
	call    	abort@FUNCTION
	unreachable
.LBB18_123:                             # %if.then25
	end_block                       # label82:
	call    	abort@FUNCTION
	unreachable
.LBB18_124:                             # %if.then31
	end_block                       # label81:
	call    	abort@FUNCTION
	unreachable
.LBB18_125:                             # %if.then37
	end_block                       # label80:
	call    	abort@FUNCTION
	unreachable
.LBB18_126:                             # %if.then48
	end_block                       # label79:
	call    	abort@FUNCTION
	unreachable
.LBB18_127:                             # %if.then73
	end_block                       # label78:
	call    	abort@FUNCTION
	unreachable
.LBB18_128:                             # %if.then79
	end_block                       # label77:
	call    	abort@FUNCTION
	unreachable
.LBB18_129:                             # %if.then85
	end_block                       # label76:
	call    	abort@FUNCTION
	unreachable
.LBB18_130:                             # %if.then99
	end_block                       # label75:
	call    	abort@FUNCTION
	unreachable
.LBB18_131:                             # %if.then126
	end_block                       # label74:
	call    	abort@FUNCTION
	unreachable
.LBB18_132:                             # %if.then133
	end_block                       # label73:
	call    	abort@FUNCTION
	unreachable
.LBB18_133:                             # %if.then140
	end_block                       # label72:
	call    	abort@FUNCTION
	unreachable
.LBB18_134:                             # %if.then9
	end_block                       # label71:
	call    	abort@FUNCTION
	unreachable
.LBB18_135:                             # %if.then18
	end_block                       # label70:
	call    	abort@FUNCTION
	unreachable
.LBB18_136:                             # %if.then57
	end_block                       # label69:
	call    	abort@FUNCTION
	unreachable
.LBB18_137:                             # %if.then66
	end_block                       # label68:
	call    	abort@FUNCTION
	unreachable
.LBB18_138:                             # %if.then109
	end_block                       # label67:
	call    	abort@FUNCTION
	unreachable
.LBB18_139:                             # %if.then119
	end_block                       # label66:
	call    	abort@FUNCTION
	unreachable
.LBB18_140:                             # %if.then152
	end_block                       # label65:
	call    	abort@FUNCTION
	unreachable
.LBB18_141:                             # %if.then177
	end_block                       # label64:
	call    	abort@FUNCTION
	unreachable
.LBB18_142:                             # %if.then202
	end_block                       # label63:
	call    	abort@FUNCTION
	unreachable
.LBB18_143:                             # %if.then227
	end_block                       # label62:
	call    	abort@FUNCTION
	unreachable
.LBB18_144:                             # %if.then252
	end_block                       # label61:
	call    	abort@FUNCTION
	unreachable
.LBB18_145:                             # %if.then277
	end_block                       # label60:
	call    	abort@FUNCTION
	unreachable
.LBB18_146:                             # %if.then302
	end_block                       # label59:
	call    	abort@FUNCTION
	unreachable
.LBB18_147:                             # %if.then327
	end_block                       # label58:
	call    	abort@FUNCTION
	unreachable
.LBB18_148:                             # %if.then352
	end_block                       # label57:
	call    	abort@FUNCTION
	unreachable
.LBB18_149:                             # %if.then377
	end_block                       # label56:
	call    	abort@FUNCTION
	unreachable
.LBB18_150:                             # %if.then402
	end_block                       # label55:
	call    	abort@FUNCTION
	unreachable
.LBB18_151:                             # %if.then427
	end_block                       # label54:
	call    	abort@FUNCTION
	unreachable
.LBB18_152:                             # %if.then444
	end_block                       # label53:
	call    	abort@FUNCTION
	unreachable
.LBB18_153:                             # %if.then460
	end_block                       # label52:
	call    	abort@FUNCTION
	unreachable
.LBB18_154:                             # %if.then469
	end_block                       # label51:
	call    	abort@FUNCTION
	unreachable
.LBB18_155:                             # %if.then494
	end_block                       # label50:
	call    	abort@FUNCTION
	unreachable
.LBB18_156:                             # %if.then510
	end_block                       # label49:
	call    	abort@FUNCTION
	unreachable
.LBB18_157:                             # %if.then519
	end_block                       # label48:
	call    	abort@FUNCTION
	unreachable
.LBB18_158:                             # %if.then544
	end_block                       # label47:
	call    	abort@FUNCTION
	unreachable
.LBB18_159:                             # %if.then569
	end_block                       # label46:
	call    	abort@FUNCTION
	unreachable
.LBB18_160:                             # %if.then594
	end_block                       # label45:
	call    	abort@FUNCTION
	unreachable
.LBB18_161:                             # %if.then619
	end_block                       # label44:
	call    	abort@FUNCTION
	unreachable
.LBB18_162:                             # %if.then644
	end_block                       # label43:
	call    	abort@FUNCTION
	unreachable
.LBB18_163:                             # %if.then669
	end_block                       # label42:
	call    	abort@FUNCTION
	unreachable
.LBB18_164:                             # %if.then694
	end_block                       # label41:
	call    	abort@FUNCTION
	unreachable
.LBB18_165:                             # %if.then710
	end_block                       # label40:
	call    	abort@FUNCTION
	unreachable
.LBB18_166:                             # %if.then719
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
