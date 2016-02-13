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
                                        #     Child Loop BB18_18 Depth 2
                                        #     Child Loop BB18_21 Depth 2
                                        #     Child Loop BB18_23 Depth 2
	block
	block
	block
	block
	loop                            # label43:
	i32.const	$push282=, 2
	i32.shl 	$push9=, $0, $pop282
	tee_local	$push281=, $2=, $pop9
	i32.load	$push1=, ints($pop281)
	tee_local	$push280=, $10=, $pop1
	i32.ctz 	$push10=, $pop280
	tee_local	$push279=, $1=, $pop10
	i32.const	$push278=, 1
	i32.add 	$push11=, $pop279, $pop278
	i32.const	$push277=, 0
	i32.select	$5=, $pop11, $pop277, $10
	i32.const	$9=, 0
	i32.const	$4=, 0
	block
	i32.const	$push382=, 0
	i32.eq  	$push383=, $10, $pop382
	br_if   	0, $pop383      # 0: down to label45
.LBB18_2:                               # %for.body.i
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label46:
	i32.const	$push283=, 1
	i32.shl 	$push12=, $pop283, $9
	i32.and 	$push13=, $pop12, $10
	br_if   	1, $pop13       # 1: down to label47
# BB#3:                                 # %for.inc.i
                                        #   in Loop: Header=BB18_2 Depth=2
	i32.const	$push285=, 1
	i32.add 	$9=, $9, $pop285
	i32.const	$push284=, 32
	i32.lt_u	$push14=, $9, $pop284
	br_if   	0, $pop14       # 0: up to label46
.LBB18_4:                               # %for.end.i
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label47:
	i32.const	$push286=, 1
	i32.add 	$4=, $9, $pop286
.LBB18_5:                               # %my_ffs.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label45:
	i32.ne  	$push15=, $5, $4
	br_if   	5, $pop15       # 5: down to label39
# BB#6:                                 # %if.end
                                        #   in Loop: Header=BB18_1 Depth=1
	block
	i32.const	$push384=, 0
	i32.eq  	$push385=, $10, $pop384
	br_if   	0, $pop385      # 0: down to label48
# BB#7:                                 # %land.lhs.true
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.clz 	$5=, $10
	i32.const	$9=, 0
	i32.const	$4=, 31
.LBB18_8:                               # %for.body.i822
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label49:
	i32.const	$push287=, 1
	i32.shl 	$push16=, $pop287, $4
	i32.and 	$push17=, $pop16, $10
	br_if   	1, $pop17       # 1: down to label50
# BB#9:                                 # %for.inc.i825
                                        #   in Loop: Header=BB18_8 Depth=2
	i32.const	$push290=, 1
	i32.add 	$9=, $9, $pop290
	i32.const	$push289=, -1
	i32.add 	$4=, $4, $pop289
	i32.const	$push288=, 32
	i32.lt_u	$push18=, $9, $pop288
	br_if   	0, $pop18       # 0: up to label49
.LBB18_10:                              # %my_clz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label50:
	block
	i32.ne  	$push19=, $5, $9
	br_if   	0, $pop19       # 0: down to label51
# BB#11:                                # %land.lhs.true13
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$9=, 0
.LBB18_12:                              # %for.body.i889
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label52:
	i32.const	$push291=, 1
	i32.shl 	$push20=, $pop291, $9
	i32.and 	$push21=, $pop20, $10
	br_if   	1, $pop21       # 1: down to label53
# BB#13:                                # %for.inc.i892
                                        #   in Loop: Header=BB18_12 Depth=2
	i32.const	$push293=, 1
	i32.add 	$9=, $9, $pop293
	i32.const	$push292=, 32
	i32.lt_u	$push22=, $9, $pop292
	br_if   	0, $pop22       # 0: up to label52
.LBB18_14:                              # %my_ctz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label53:
	i32.eq  	$push23=, $1, $9
	br_if   	1, $pop23       # 1: down to label48
# BB#15:                                # %if.then18
	call    	abort@FUNCTION
	unreachable
.LBB18_16:                              # %if.then9
	end_block                       # label51:
	call    	abort@FUNCTION
	unreachable
.LBB18_17:                              # %if.end19
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label48:
	i32.call	$1=, __builtin_clrsb@FUNCTION, $10
	i32.const	$push296=, ints
	i32.add 	$push0=, $2, $pop296
	i32.load	$push2=, 0($pop0)
	tee_local	$push295=, $10=, $pop2
	i32.const	$push294=, 31
	i32.shr_u	$4=, $pop295, $pop294
	i32.const	$5=, 1
	i32.const	$9=, 30
.LBB18_18:                              # %for.body.i974
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label54:
	i32.shr_u	$push24=, $10, $9
	i32.const	$push297=, 1
	i32.and 	$push25=, $pop24, $pop297
	i32.ne  	$push26=, $pop25, $4
	br_if   	1, $pop26       # 1: down to label55
# BB#19:                                # %for.inc.i977
                                        #   in Loop: Header=BB18_18 Depth=2
	i32.const	$push300=, 1
	i32.add 	$5=, $5, $pop300
	i32.const	$push299=, -1
	i32.add 	$9=, $9, $pop299
	i32.const	$push298=, 32
	i32.lt_u	$push27=, $5, $pop298
	br_if   	0, $pop27       # 0: up to label54
.LBB18_20:                              # %my_clrsb.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label55:
	i32.const	$4=, 0
	i32.const	$9=, 0
	i32.const	$push301=, -1
	i32.add 	$push28=, $5, $pop301
	i32.ne  	$push29=, $1, $pop28
	br_if   	4, $pop29       # 4: down to label40
.LBB18_21:                              # %for.body.i1069
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label56:
	i32.const	$push305=, 1
	i32.shl 	$push30=, $pop305, $9
	i32.and 	$push31=, $pop30, $10
	i32.const	$push304=, 0
	i32.ne  	$push32=, $pop31, $pop304
	i32.add 	$4=, $pop32, $4
	i32.const	$push303=, 1
	i32.add 	$9=, $9, $pop303
	i32.const	$push302=, 32
	i32.ne  	$push33=, $9, $pop302
	br_if   	0, $pop33       # 0: up to label56
# BB#22:                                # %my_popcount.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label57:
	i32.const	$5=, 0
	i32.const	$9=, 0
	i32.popcnt	$push34=, $10
	i32.ne  	$push35=, $pop34, $4
	br_if   	3, $pop35       # 3: down to label41
.LBB18_23:                              # %for.body.i1161
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label58:
	i32.const	$push309=, 1
	i32.shl 	$push36=, $pop309, $9
	i32.and 	$push37=, $pop36, $10
	i32.const	$push308=, 0
	i32.ne  	$push38=, $pop37, $pop308
	i32.add 	$5=, $pop38, $5
	i32.const	$push307=, 1
	i32.add 	$9=, $9, $pop307
	i32.const	$push306=, 32
	i32.ne  	$push39=, $9, $pop306
	br_if   	0, $pop39       # 0: up to label58
# BB#24:                                # %my_parity.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label59:
	i32.xor 	$push40=, $5, $4
	i32.const	$push310=, 1
	i32.and 	$push41=, $pop40, $pop310
	br_if   	2, $pop41       # 2: down to label42
# BB#25:                                # %for.cond
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$push276=, 1
	i32.add 	$0=, $0, $pop276
	i32.const	$2=, 0
	i32.const	$push275=, 12
	i32.le_u	$push42=, $0, $pop275
	br_if   	0, $pop42       # 0: up to label43
.LBB18_26:                              # %for.body41
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_27 Depth 2
                                        #     Child Loop BB18_33 Depth 2
                                        #     Child Loop BB18_37 Depth 2
                                        #     Child Loop BB18_43 Depth 2
                                        #     Child Loop BB18_46 Depth 2
                                        #     Child Loop BB18_48 Depth 2
	end_loop                        # label44:
	block
	block
	block
	block
	loop                            # label64:
	i32.const	$push43=, 2
	i32.shl 	$push44=, $2, $pop43
	tee_local	$push316=, $0=, $pop44
	i32.load	$push4=, longs($pop316)
	tee_local	$push315=, $10=, $pop4
	i32.ctz 	$push46=, $pop315
	tee_local	$push314=, $1=, $pop46
	i32.const	$push313=, 1
	i32.add 	$push47=, $pop314, $pop313
	i32.const	$push312=, 0
	i32.select	$5=, $pop47, $pop312, $10
	i32.const	$9=, 0
	i32.const	$4=, 0
	block
	i32.const	$push386=, 0
	i32.eq  	$push387=, $10, $pop386
	br_if   	0, $pop387      # 0: down to label66
.LBB18_27:                              # %for.body.i1251
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label67:
	i32.const	$push317=, 1
	i32.shl 	$push48=, $pop317, $9
	i32.and 	$push49=, $pop48, $10
	br_if   	1, $pop49       # 1: down to label68
# BB#28:                                # %for.inc.i1254
                                        #   in Loop: Header=BB18_27 Depth=2
	i32.const	$push50=, 1
	i32.add 	$9=, $9, $pop50
	i32.const	$push51=, 32
	i32.lt_u	$push52=, $9, $pop51
	br_if   	0, $pop52       # 0: up to label67
.LBB18_29:                              # %for.end.i1257
                                        #   in Loop: Header=BB18_26 Depth=1
	end_loop                        # label68:
	i32.const	$push53=, 1
	i32.add 	$4=, $9, $pop53
.LBB18_30:                              # %my_ffsl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	end_block                       # label66:
	i32.ne  	$push54=, $5, $4
	br_if   	5, $pop54       # 5: down to label60
# BB#31:                                # %if.end49
                                        #   in Loop: Header=BB18_26 Depth=1
	block
	i32.const	$push388=, 0
	i32.eq  	$push389=, $10, $pop388
	br_if   	0, $pop389      # 0: down to label69
# BB#32:                                # %land.lhs.true52
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.clz 	$5=, $10
	i32.const	$9=, 0
	i32.const	$4=, 31
.LBB18_33:                              # %for.body.i1346
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label70:
	i32.const	$push318=, 1
	i32.shl 	$push55=, $pop318, $4
	i32.and 	$push56=, $pop55, $10
	br_if   	1, $pop56       # 1: down to label71
# BB#34:                                # %for.inc.i1349
                                        #   in Loop: Header=BB18_33 Depth=2
	i32.const	$push319=, 1
	i32.add 	$9=, $9, $pop319
	i32.const	$push57=, -1
	i32.add 	$4=, $4, $pop57
	i32.const	$push58=, 32
	i32.lt_u	$push59=, $9, $pop58
	br_if   	0, $pop59       # 0: up to label70
.LBB18_35:                              # %my_clzl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	end_loop                        # label71:
	block
	i32.ne  	$push60=, $5, $9
	br_if   	0, $pop60       # 0: down to label72
# BB#36:                                # %land.lhs.true61
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.const	$9=, 0
.LBB18_37:                              # %for.body.i1438
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label73:
	i32.const	$push320=, 1
	i32.shl 	$push61=, $pop320, $9
	i32.and 	$push62=, $pop61, $10
	br_if   	1, $pop62       # 1: down to label74
# BB#38:                                # %for.inc.i1441
                                        #   in Loop: Header=BB18_37 Depth=2
	i32.const	$push321=, 1
	i32.add 	$9=, $9, $pop321
	i32.const	$push63=, 32
	i32.lt_u	$push64=, $9, $pop63
	br_if   	0, $pop64       # 0: up to label73
.LBB18_39:                              # %my_ctzl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	end_loop                        # label74:
	i32.eq  	$push65=, $1, $9
	br_if   	1, $pop65       # 1: down to label69
# BB#40:                                # %if.then66
	call    	abort@FUNCTION
	unreachable
.LBB18_41:                              # %if.then57
	end_block                       # label72:
	call    	abort@FUNCTION
	unreachable
.LBB18_42:                              # %if.end67
                                        #   in Loop: Header=BB18_26 Depth=1
	end_block                       # label69:
	i32.call	$1=, __builtin_clrsbl@FUNCTION, $10
	i32.const	$push45=, longs
	i32.add 	$push3=, $0, $pop45
	i32.load	$push5=, 0($pop3)
	tee_local	$push322=, $10=, $pop5
	i32.const	$push66=, 31
	i32.shr_u	$4=, $pop322, $pop66
	i32.const	$9=, 30
	i32.const	$5=, 1
.LBB18_43:                              # %for.body.i1532
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label75:
	i32.shr_u	$push67=, $10, $9
	i32.const	$push323=, 1
	i32.and 	$push68=, $pop67, $pop323
	i32.ne  	$push69=, $pop68, $4
	br_if   	1, $pop69       # 1: down to label76
# BB#44:                                # %for.inc.i1535
                                        #   in Loop: Header=BB18_43 Depth=2
	i32.const	$push70=, 1
	i32.add 	$5=, $5, $pop70
	i32.const	$push71=, -1
	i32.add 	$9=, $9, $pop71
	i32.const	$push72=, 32
	i32.lt_u	$push73=, $5, $pop72
	br_if   	0, $pop73       # 0: up to label75
.LBB18_45:                              # %my_clrsbl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	end_loop                        # label76:
	i32.const	$4=, 0
	i32.const	$9=, 0
	i32.const	$push74=, -1
	i32.add 	$push75=, $5, $pop74
	i32.ne  	$push76=, $1, $pop75
	br_if   	4, $pop76       # 4: down to label61
.LBB18_46:                              # %for.body.i1630
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label77:
	i32.const	$push77=, 1
	i32.shl 	$push78=, $pop77, $9
	i32.and 	$push79=, $pop78, $10
	i32.const	$push325=, 0
	i32.ne  	$push80=, $pop79, $pop325
	i32.add 	$4=, $pop80, $4
	i32.const	$push324=, 1
	i32.add 	$9=, $9, $pop324
	i32.const	$push81=, 32
	i32.ne  	$push82=, $9, $pop81
	br_if   	0, $pop82       # 0: up to label77
# BB#47:                                # %my_popcountl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	end_loop                        # label78:
	i32.const	$5=, 0
	i32.const	$9=, 0
	i32.popcnt	$push83=, $10
	i32.ne  	$push84=, $pop83, $4
	br_if   	3, $pop84       # 3: down to label62
.LBB18_48:                              # %for.body.i1723
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label79:
	i32.const	$push328=, 1
	i32.shl 	$push85=, $pop328, $9
	i32.and 	$push86=, $pop85, $10
	i32.const	$push327=, 0
	i32.ne  	$push87=, $pop86, $pop327
	i32.add 	$5=, $pop87, $5
	i32.const	$push326=, 1
	i32.add 	$9=, $9, $pop326
	i32.const	$push88=, 32
	i32.ne  	$push89=, $9, $pop88
	br_if   	0, $pop89       # 0: up to label79
# BB#49:                                # %my_parityl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	end_loop                        # label80:
	i32.xor 	$push90=, $5, $4
	i32.const	$push329=, 1
	i32.and 	$push91=, $pop90, $pop329
	br_if   	2, $pop91       # 2: down to label63
# BB#50:                                # %for.cond39
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.const	$push311=, 1
	i32.add 	$2=, $2, $pop311
	i32.const	$4=, 0
	i32.const	$push92=, 12
	i32.le_u	$push93=, $2, $pop92
	br_if   	0, $pop93       # 0: up to label64
.LBB18_51:                              # %for.body92
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_52 Depth 2
                                        #     Child Loop BB18_58 Depth 2
                                        #     Child Loop BB18_62 Depth 2
                                        #     Child Loop BB18_68 Depth 2
                                        #     Child Loop BB18_72 Depth 2
                                        #     Child Loop BB18_74 Depth 2
	end_loop                        # label65:
	block
	block
	block
	block
	loop                            # label85:
	i32.const	$push337=, 0
	i32.const	$push94=, 3
	i32.shl 	$push95=, $4, $pop94
	tee_local	$push336=, $0=, $pop95
	i64.load	$push7=, longlongs($pop336)
	tee_local	$push335=, $8=, $pop7
	i64.ctz 	$push97=, $pop335
	tee_local	$push334=, $3=, $pop97
	i64.const	$push333=, 1
	i64.add 	$push98=, $pop334, $pop333
	i32.wrap/i64	$push100=, $pop98
	i64.const	$push332=, 0
	i64.eq  	$push99=, $8, $pop332
	tee_local	$push331=, $5=, $pop99
	i32.select	$2=, $pop337, $pop100, $pop331
	i64.const	$7=, 0
	i32.const	$9=, 0
	i32.const	$10=, 0
	block
	br_if   	0, $5           # 0: down to label87
.LBB18_52:                              # %for.body.i1814
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label88:
	i64.const	$push339=, 1
	i64.shl 	$push101=, $pop339, $7
	i64.and 	$push102=, $pop101, $8
	i64.const	$push338=, 0
	i64.ne  	$push103=, $pop102, $pop338
	br_if   	1, $pop103      # 1: down to label89
# BB#53:                                # %for.inc.i1818
                                        #   in Loop: Header=BB18_52 Depth=2
	i32.const	$push105=, 1
	i32.add 	$9=, $9, $pop105
	i64.const	$push104=, 1
	i64.add 	$7=, $7, $pop104
	i64.const	$push106=, 64
	i64.lt_u	$push107=, $7, $pop106
	br_if   	0, $pop107      # 0: up to label88
.LBB18_54:                              # %for.end.i1821
                                        #   in Loop: Header=BB18_51 Depth=1
	end_loop                        # label89:
	i32.const	$push108=, 1
	i32.add 	$10=, $9, $pop108
.LBB18_55:                              # %my_ffsll.exit1823
                                        #   in Loop: Header=BB18_51 Depth=1
	end_block                       # label87:
	i32.ne  	$push109=, $2, $10
	br_if   	5, $pop109      # 5: down to label81
# BB#56:                                # %if.end100
                                        #   in Loop: Header=BB18_51 Depth=1
	i64.const	$7=, 0
	block
	i64.const	$push340=, 0
	i64.eq  	$push110=, $8, $pop340
	br_if   	0, $pop110      # 0: down to label90
# BB#57:                                # %land.lhs.true103
                                        #   in Loop: Header=BB18_51 Depth=1
	i64.const	$6=, 63
	i64.clz 	$push111=, $8
	i32.wrap/i64	$10=, $pop111
	i32.const	$9=, 0
.LBB18_58:                              # %for.body.i1902
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label91:
	i64.const	$push341=, 1
	i64.const	$push112=, 4294967295
	i64.and 	$push113=, $6, $pop112
	i64.shl 	$push114=, $pop341, $pop113
	i64.and 	$push115=, $pop114, $8
	i64.const	$push116=, 0
	i64.ne  	$push117=, $pop115, $pop116
	br_if   	1, $pop117      # 1: down to label92
# BB#59:                                # %for.inc.i1906
                                        #   in Loop: Header=BB18_58 Depth=2
	i32.const	$push118=, 1
	i32.add 	$9=, $9, $pop118
	i64.const	$push342=, 1
	i64.add 	$7=, $7, $pop342
	i64.const	$push119=, -1
	i64.add 	$6=, $6, $pop119
	i64.const	$push120=, 64
	i64.lt_u	$push121=, $7, $pop120
	br_if   	0, $pop121      # 0: up to label91
.LBB18_60:                              # %my_clzll.exit1909
                                        #   in Loop: Header=BB18_51 Depth=1
	end_loop                        # label92:
	block
	i32.ne  	$push122=, $10, $9
	br_if   	0, $pop122      # 0: down to label93
# BB#61:                                # %land.lhs.true113
                                        #   in Loop: Header=BB18_51 Depth=1
	i64.const	$7=, 0
	i32.wrap/i64	$10=, $3
	i32.const	$9=, 0
.LBB18_62:                              # %for.body.i1948
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label94:
	i64.const	$push344=, 1
	i64.shl 	$push123=, $pop344, $7
	i64.and 	$push124=, $pop123, $8
	i64.const	$push343=, 0
	i64.ne  	$push125=, $pop124, $pop343
	br_if   	1, $pop125      # 1: down to label95
# BB#63:                                # %for.inc.i1952
                                        #   in Loop: Header=BB18_62 Depth=2
	i32.const	$push126=, 1
	i32.add 	$9=, $9, $pop126
	i64.const	$push345=, 1
	i64.add 	$7=, $7, $pop345
	i64.const	$push127=, 64
	i64.lt_u	$push128=, $7, $pop127
	br_if   	0, $pop128      # 0: up to label94
.LBB18_64:                              # %my_ctzll.exit1955
                                        #   in Loop: Header=BB18_51 Depth=1
	end_loop                        # label95:
	i32.eq  	$push129=, $10, $9
	br_if   	1, $pop129      # 1: down to label90
# BB#65:                                # %if.then119
	call    	abort@FUNCTION
	unreachable
.LBB18_66:                              # %if.then109
	end_block                       # label93:
	call    	abort@FUNCTION
	unreachable
.LBB18_67:                              # %if.end120
                                        #   in Loop: Header=BB18_51 Depth=1
	end_block                       # label90:
	i32.call	$10=, __builtin_clrsbll@FUNCTION, $8
	i32.const	$push96=, longlongs
	i32.add 	$push6=, $0, $pop96
	i64.load	$push8=, 0($pop6)
	tee_local	$push346=, $8=, $pop8
	i64.const	$push130=, 63
	i64.shr_u	$3=, $pop346, $pop130
	i64.const	$7=, 62
	i64.const	$6=, 1
	i32.const	$9=, 1
.LBB18_68:                              # %for.body.i2018
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label96:
	i64.shr_u	$push131=, $8, $7
	i64.const	$push347=, 1
	i64.and 	$push132=, $pop131, $pop347
	i64.ne  	$push133=, $pop132, $3
	br_if   	1, $pop133      # 1: down to label97
# BB#69:                                # %for.inc.i2022
                                        #   in Loop: Header=BB18_68 Depth=2
	i32.const	$push135=, 1
	i32.add 	$9=, $9, $pop135
	i64.const	$push134=, 1
	i64.add 	$6=, $6, $pop134
	i64.const	$push136=, -1
	i64.add 	$7=, $7, $pop136
	i64.const	$push137=, 64
	i64.lt_u	$push138=, $6, $pop137
	br_if   	0, $pop138      # 0: up to label96
.LBB18_70:                              # %my_clrsbll.exit2026
                                        #   in Loop: Header=BB18_51 Depth=1
	end_loop                        # label97:
	i32.const	$push139=, -1
	i32.add 	$push140=, $9, $pop139
	i32.ne  	$push141=, $10, $pop140
	br_if   	4, $pop141      # 4: down to label82
# BB#71:                                # %if.end127
                                        #   in Loop: Header=BB18_51 Depth=1
	i64.popcnt	$6=, $8
	i64.const	$7=, 0
	i32.const	$9=, 0
.LBB18_72:                              # %for.body.i2110
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label98:
	i64.const	$push142=, 1
	i64.shl 	$push143=, $pop142, $7
	i64.and 	$push144=, $pop143, $8
	i64.const	$push349=, 0
	i64.ne  	$push145=, $pop144, $pop349
	i32.add 	$9=, $pop145, $9
	i64.const	$push348=, 1
	i64.add 	$7=, $7, $pop348
	i64.const	$push146=, 64
	i64.ne  	$push147=, $7, $pop146
	br_if   	0, $pop147      # 0: up to label98
# BB#73:                                # %my_popcountll.exit2112
                                        #   in Loop: Header=BB18_51 Depth=1
	end_loop                        # label99:
	i64.const	$7=, 0
	i32.const	$10=, 0
	i32.wrap/i64	$push148=, $6
	i32.ne  	$push149=, $pop148, $9
	br_if   	3, $pop149      # 3: down to label83
.LBB18_74:                              # %for.body.i2196
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label100:
	i64.const	$push150=, 1
	i64.shl 	$push151=, $pop150, $7
	i64.and 	$push152=, $pop151, $8
	i64.const	$push351=, 0
	i64.ne  	$push153=, $pop152, $pop351
	i32.add 	$10=, $pop153, $10
	i64.const	$push350=, 1
	i64.add 	$7=, $7, $pop350
	i64.const	$push154=, 64
	i64.ne  	$push155=, $7, $pop154
	br_if   	0, $pop155      # 0: up to label100
# BB#75:                                # %my_parityll.exit2199
                                        #   in Loop: Header=BB18_51 Depth=1
	end_loop                        # label101:
	i32.xor 	$push156=, $10, $9
	i32.const	$push157=, 1
	i32.and 	$push158=, $pop156, $pop157
	br_if   	2, $pop158      # 2: down to label84
# BB#76:                                # %for.cond90
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.const	$push330=, 1
	i32.add 	$4=, $4, $pop330
	i32.const	$push159=, 12
	i32.le_u	$push160=, $4, $pop159
	br_if   	0, $pop160      # 0: up to label85
# BB#77:                                # %if.end148
	end_loop                        # label86:
	block
	i32.const	$push161=, 0
	i32.call	$push162=, __builtin_clrsb@FUNCTION, $pop161
	i32.const	$push163=, 31
	i32.ne  	$push164=, $pop162, $pop163
	br_if   	0, $pop164      # 0: down to label102
# BB#78:                                # %my_clrsb.exit2770
	block
	i32.const	$push165=, 1
	i32.call	$push166=, __builtin_clrsb@FUNCTION, $pop165
	i32.const	$push167=, 30
	i32.ne  	$push168=, $pop166, $pop167
	br_if   	0, $pop168      # 0: down to label103
# BB#79:                                # %if.end198
	block
	i32.const	$push169=, -2147483648
	i32.call	$push170=, __builtin_clrsb@FUNCTION, $pop169
	br_if   	0, $pop170      # 0: down to label104
# BB#80:                                # %my_clrsb.exit2597
	block
	i32.const	$push171=, 1073741824
	i32.call	$push172=, __builtin_clrsb@FUNCTION, $pop171
	br_if   	0, $pop172      # 0: down to label105
# BB#81:                                # %my_clrsb.exit2514
	block
	i32.const	$push173=, 65536
	i32.call	$push174=, __builtin_clrsb@FUNCTION, $pop173
	i32.const	$push175=, 14
	i32.ne  	$push176=, $pop174, $pop175
	br_if   	0, $pop176      # 0: down to label106
# BB#82:                                # %my_clrsb.exit2432
	block
	i32.const	$push177=, 32768
	i32.call	$push178=, __builtin_clrsb@FUNCTION, $pop177
	i32.const	$push179=, 15
	i32.ne  	$push180=, $pop178, $pop179
	br_if   	0, $pop180      # 0: down to label107
# BB#83:                                # %my_clrsb.exit2348
	block
	i32.const	$push181=, -1515870811
	i32.call	$push182=, __builtin_clrsb@FUNCTION, $pop181
	br_if   	0, $pop182      # 0: down to label108
# BB#84:                                # %my_clrsb.exit2273
	block
	i32.const	$push183=, 1515870810
	i32.call	$push184=, __builtin_clrsb@FUNCTION, $pop183
	br_if   	0, $pop184      # 0: down to label109
# BB#85:                                # %for.body.i2179
	block
	i32.const	$push185=, -889323520
	i32.call	$push186=, __builtin_clrsb@FUNCTION, $pop185
	i32.const	$push187=, 1
	i32.ne  	$push188=, $pop186, $pop187
	br_if   	0, $pop188      # 0: down to label110
# BB#86:                                # %for.body.i2093
	block
	i32.const	$push189=, 13303296
	i32.call	$push190=, __builtin_clrsb@FUNCTION, $pop189
	i32.const	$push191=, 7
	i32.ne  	$push192=, $pop190, $pop191
	br_if   	0, $pop192      # 0: down to label111
# BB#87:                                # %for.body.i2004
	block
	i32.const	$push193=, 51966
	i32.call	$push194=, __builtin_clrsb@FUNCTION, $pop193
	i32.const	$push195=, 15
	i32.ne  	$push196=, $pop194, $pop195
	br_if   	0, $pop196      # 0: down to label112
# BB#88:                                # %if.end423
	i32.const	$push352=, -1
	i32.call	$4=, __builtin_clrsb@FUNCTION, $pop352
	i32.const	$10=, 30
	i32.const	$9=, 1
.LBB18_89:                              # %for.body.i1935
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label113:
	i32.const	$push354=, -1
	i32.shr_u	$push197=, $pop354, $10
	i32.const	$push353=, 1
	i32.and 	$push198=, $pop197, $pop353
	i32.const	$push390=, 0
	i32.eq  	$push391=, $pop198, $pop390
	br_if   	1, $pop391      # 1: down to label114
# BB#90:                                # %for.inc.i1938
                                        #   in Loop: Header=BB18_89 Depth=1
	i32.const	$push357=, 1
	i32.add 	$9=, $9, $pop357
	i32.const	$push356=, -1
	i32.add 	$10=, $10, $pop356
	i32.const	$push355=, 32
	i32.lt_u	$push199=, $9, $pop355
	br_if   	0, $pop199      # 0: up to label113
.LBB18_91:                              # %my_clrsb.exit1942
	end_loop                        # label114:
	block
	i32.const	$push200=, -1
	i32.add 	$push201=, $9, $pop200
	i32.ne  	$push202=, $4, $pop201
	br_if   	0, $pop202      # 0: down to label115
# BB#92:                                # %if.end440
	i64.const	$8=, 0
	i64.const	$7=, 63
	i32.const	$9=, 0
	block
	i64.const	$push358=, 0
	i32.call	$push203=, __builtin_clrsbll@FUNCTION, $pop358
	i32.const	$push204=, 63
	i32.ne  	$push205=, $pop203, $pop204
	br_if   	0, $pop205      # 0: down to label116
.LBB18_93:                              # %for.body.i1844
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label117:
	i32.wrap/i64	$push206=, $7
	i32.const	$push392=, 0
	i32.eq  	$push393=, $pop206, $pop392
	br_if   	1, $pop393      # 1: down to label118
# BB#94:                                # %for.inc.i1848
                                        #   in Loop: Header=BB18_93 Depth=1
	i32.const	$push208=, 1
	i32.add 	$9=, $9, $pop208
	i64.const	$push207=, 1
	i64.add 	$8=, $8, $pop207
	i64.const	$push209=, -1
	i64.add 	$7=, $7, $pop209
	i64.const	$push210=, 64
	i64.lt_u	$push211=, $8, $pop210
	br_if   	0, $pop211      # 0: up to label117
.LBB18_95:                              # %my_clzll.exit1851
	end_loop                        # label118:
	block
	i32.const	$push212=, 63
	i32.ne  	$push213=, $9, $pop212
	br_if   	0, $pop213      # 0: down to label119
# BB#96:                                # %if.end465
	i64.const	$push359=, 1
	i32.call	$10=, __builtin_clrsbll@FUNCTION, $pop359
	i64.const	$7=, 1
.LBB18_97:                              # %for.body.i1799
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label120:
	i32.const	$9=, 62
	i64.const	$push360=, 63
	i64.eq  	$push214=, $7, $pop360
	br_if   	1, $pop214      # 1: down to label121
# BB#98:                                # %for.inc.i1803
                                        #   in Loop: Header=BB18_97 Depth=1
	i64.const	$push362=, 1
	i64.add 	$7=, $7, $pop362
	i32.const	$9=, 63
	i64.const	$push361=, 64
	i64.lt_u	$push215=, $7, $pop361
	br_if   	0, $pop215      # 0: up to label120
.LBB18_99:                              # %my_clrsbll.exit1807
	end_loop                        # label121:
	i64.const	$8=, 0
	i64.const	$7=, 0
	block
	i32.ne  	$push216=, $10, $9
	br_if   	0, $pop216      # 0: down to label122
.LBB18_100:                             # %for.body.i1759
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label124:
	i64.const	$push363=, 63
	i64.eq  	$push217=, $7, $pop363
	br_if   	2, $pop217      # 2: down to label123
# BB#101:                               # %for.inc.i1763
                                        #   in Loop: Header=BB18_100 Depth=1
	i64.const	$push218=, 1
	i64.add 	$7=, $7, $pop218
	i64.const	$push219=, 64
	i64.lt_u	$push220=, $7, $pop219
	br_if   	0, $pop220      # 0: up to label124
# BB#102:                               # %if.then481
	end_loop                        # label125:
	call    	abort@FUNCTION
	unreachable
.LBB18_103:                             # %for.body.i1731
                                        # =>This Inner Loop Header: Depth=1
	end_block                       # label123:
	block
	loop                            # label127:
	i64.const	$push364=, 63
	i64.eq  	$push221=, $8, $pop364
	br_if   	2, $pop221      # 2: down to label126
# BB#104:                               # %for.inc.i1735
                                        #   in Loop: Header=BB18_103 Depth=1
	i64.const	$push222=, 1
	i64.add 	$8=, $8, $pop222
	i64.const	$push223=, 64
	i64.lt_u	$push224=, $8, $pop223
	br_if   	0, $pop224      # 0: up to label127
# BB#105:                               # %if.then489
	end_loop                        # label128:
	call    	abort@FUNCTION
	unreachable
.LBB18_106:                             # %if.end490
	end_block                       # label126:
	block
	i64.const	$push225=, -9223372036854775808
	i32.call	$push226=, __builtin_clrsbll@FUNCTION, $pop225
	br_if   	0, $pop226      # 0: down to label129
# BB#107:                               # %for.body.i1665
	i64.const	$7=, 63
	i64.const	$8=, -1
.LBB18_108:                             # %for.body.i1652
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label130:
	i64.const	$push367=, 1
	i64.add 	$8=, $8, $pop367
	i64.const	$push366=, -1
	i64.add 	$6=, $7, $pop366
	i32.wrap/i64	$9=, $7
	copy_local	$7=, $6
	i32.const	$push365=, 1
	i32.ne  	$push227=, $9, $pop365
	br_if   	0, $pop227      # 0: up to label130
# BB#109:                               # %my_clzll.exit1659
	end_loop                        # label131:
	block
	i32.wrap/i64	$push228=, $8
	i32.const	$push229=, 62
	i32.ne  	$push230=, $pop228, $pop229
	br_if   	0, $pop230      # 0: down to label132
# BB#110:                               # %for.body.i1612
	block
	i64.const	$push231=, 2
	i32.call	$push232=, __builtin_clrsbll@FUNCTION, $pop231
	i32.const	$push233=, 61
	i32.ne  	$push234=, $pop232, $pop233
	br_if   	0, $pop234      # 0: down to label133
# BB#111:                               # %my_clrsbll.exit1525
	block
	i64.const	$push235=, 4611686018427387904
	i32.call	$push236=, __builtin_clrsbll@FUNCTION, $pop235
	br_if   	0, $pop236      # 0: down to label134
# BB#112:                               # %for.body.i1425
	block
	i64.const	$push237=, 4294967296
	i32.call	$push238=, __builtin_clrsbll@FUNCTION, $pop237
	i32.const	$push239=, 30
	i32.ne  	$push240=, $pop238, $pop239
	br_if   	0, $pop240      # 0: down to label135
# BB#113:                               # %for.body.i1332
	block
	i64.const	$push241=, 2147483648
	i32.call	$push242=, __builtin_clrsbll@FUNCTION, $pop241
	i32.const	$push243=, 31
	i32.ne  	$push244=, $pop242, $pop243
	br_if   	0, $pop244      # 0: down to label136
# BB#114:                               # %my_clrsbll.exit1245
	block
	i64.const	$push245=, -6510615555426900571
	i32.call	$push246=, __builtin_clrsbll@FUNCTION, $pop245
	br_if   	0, $pop246      # 0: down to label137
# BB#115:                               # %my_clrsbll.exit1152
	block
	i64.const	$push247=, 6510615555426900570
	i32.call	$push248=, __builtin_clrsbll@FUNCTION, $pop247
	br_if   	0, $pop248      # 0: down to label138
# BB#116:                               # %for.body.i1053
	block
	i64.const	$push249=, -3819392241693097984
	i32.call	$push250=, __builtin_clrsbll@FUNCTION, $pop249
	i32.const	$push251=, 1
	i32.ne  	$push252=, $pop250, $pop251
	br_if   	0, $pop252      # 0: down to label139
# BB#117:                               # %for.body.i964
	block
	i64.const	$push253=, 223195676147712
	i32.call	$push254=, __builtin_clrsbll@FUNCTION, $pop253
	i32.const	$push255=, 15
	i32.ne  	$push256=, $pop254, $pop255
	br_if   	0, $pop256      # 0: down to label140
# BB#118:                               # %for.body.i925
	i64.const	$7=, 63
	i64.const	$8=, -1
.LBB18_119:                             # %for.body.i913
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label141:
	i64.const	$push373=, 4294967295
	i64.and 	$6=, $7, $pop373
	i64.const	$push372=, 1
	i64.add 	$8=, $8, $pop372
	i64.const	$push371=, -1
	i64.add 	$7=, $7, $pop371
	i64.const	$push370=, 1
	i64.shl 	$push257=, $pop370, $6
	i64.const	$push369=, 3405695742
	i64.and 	$push258=, $pop257, $pop369
	i64.const	$push368=, 0
	i64.eq  	$push259=, $pop258, $pop368
	br_if   	0, $pop259      # 0: up to label141
# BB#120:                               # %my_clzll.exit
	end_loop                        # label142:
	block
	i32.wrap/i64	$push260=, $8
	i32.const	$push261=, 32
	i32.ne  	$push262=, $pop260, $pop261
	br_if   	0, $pop262      # 0: down to label143
# BB#121:                               # %for.body.i877
	block
	i64.const	$push263=, 3405695742
	i32.call	$push264=, __builtin_clrsbll@FUNCTION, $pop263
	i32.const	$push265=, 31
	i32.ne  	$push266=, $pop264, $pop265
	br_if   	0, $pop266      # 0: down to label144
# BB#122:                               # %if.end740
	i64.const	$push374=, -1
	i32.call	$10=, __builtin_clrsbll@FUNCTION, $pop374
	i64.const	$7=, 62
	i64.const	$8=, 1
	i32.const	$9=, 1
.LBB18_123:                             # %for.body.i812
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label145:
	i64.const	$push377=, -1
	i64.shr_u	$push267=, $pop377, $7
	i64.const	$push376=, 1
	i64.and 	$push268=, $pop267, $pop376
	i64.const	$push375=, 0
	i64.eq  	$push269=, $pop268, $pop375
	br_if   	1, $pop269      # 1: down to label146
# BB#124:                               # %for.inc.i816
                                        #   in Loop: Header=BB18_123 Depth=1
	i64.const	$push381=, 1
	i64.add 	$8=, $8, $pop381
	i32.const	$push380=, 1
	i32.add 	$9=, $9, $pop380
	i64.const	$push379=, -1
	i64.add 	$7=, $7, $pop379
	i64.const	$push378=, 64
	i64.lt_u	$push270=, $8, $pop378
	br_if   	0, $pop270      # 0: up to label145
.LBB18_125:                             # %my_clrsbll.exit
	end_loop                        # label146:
	block
	i32.const	$push271=, -1
	i32.add 	$push272=, $9, $pop271
	i32.ne  	$push273=, $10, $pop272
	br_if   	0, $pop273      # 0: down to label147
# BB#126:                               # %if.end753
	i32.const	$push274=, 0
	call    	exit@FUNCTION, $pop274
	unreachable
.LBB18_127:                             # %if.then744
	end_block                       # label147:
	call    	abort@FUNCTION
	unreachable
.LBB18_128:                             # %if.then719
	end_block                       # label144:
	call    	abort@FUNCTION
	unreachable
.LBB18_129:                             # %if.then710
	end_block                       # label143:
	call    	abort@FUNCTION
	unreachable
.LBB18_130:                             # %if.then694
	end_block                       # label140:
	call    	abort@FUNCTION
	unreachable
.LBB18_131:                             # %if.then669
	end_block                       # label139:
	call    	abort@FUNCTION
	unreachable
.LBB18_132:                             # %if.then644
	end_block                       # label138:
	call    	abort@FUNCTION
	unreachable
.LBB18_133:                             # %if.then619
	end_block                       # label137:
	call    	abort@FUNCTION
	unreachable
.LBB18_134:                             # %if.then594
	end_block                       # label136:
	call    	abort@FUNCTION
	unreachable
.LBB18_135:                             # %if.then569
	end_block                       # label135:
	call    	abort@FUNCTION
	unreachable
.LBB18_136:                             # %if.then544
	end_block                       # label134:
	call    	abort@FUNCTION
	unreachable
.LBB18_137:                             # %if.then519
	end_block                       # label133:
	call    	abort@FUNCTION
	unreachable
.LBB18_138:                             # %if.then510
	end_block                       # label132:
	call    	abort@FUNCTION
	unreachable
.LBB18_139:                             # %if.then494
	end_block                       # label129:
	call    	abort@FUNCTION
	unreachable
.LBB18_140:                             # %if.then469
	end_block                       # label122:
	call    	abort@FUNCTION
	unreachable
.LBB18_141:                             # %if.then460
	end_block                       # label119:
	call    	abort@FUNCTION
	unreachable
.LBB18_142:                             # %if.then444
	end_block                       # label116:
	call    	abort@FUNCTION
	unreachable
.LBB18_143:                             # %if.then427
	end_block                       # label115:
	call    	abort@FUNCTION
	unreachable
.LBB18_144:                             # %if.then402
	end_block                       # label112:
	call    	abort@FUNCTION
	unreachable
.LBB18_145:                             # %if.then377
	end_block                       # label111:
	call    	abort@FUNCTION
	unreachable
.LBB18_146:                             # %if.then352
	end_block                       # label110:
	call    	abort@FUNCTION
	unreachable
.LBB18_147:                             # %if.then327
	end_block                       # label109:
	call    	abort@FUNCTION
	unreachable
.LBB18_148:                             # %if.then302
	end_block                       # label108:
	call    	abort@FUNCTION
	unreachable
.LBB18_149:                             # %if.then277
	end_block                       # label107:
	call    	abort@FUNCTION
	unreachable
.LBB18_150:                             # %if.then252
	end_block                       # label106:
	call    	abort@FUNCTION
	unreachable
.LBB18_151:                             # %if.then227
	end_block                       # label105:
	call    	abort@FUNCTION
	unreachable
.LBB18_152:                             # %if.then202
	end_block                       # label104:
	call    	abort@FUNCTION
	unreachable
.LBB18_153:                             # %if.then177
	end_block                       # label103:
	call    	abort@FUNCTION
	unreachable
.LBB18_154:                             # %if.then152
	end_block                       # label102:
	call    	abort@FUNCTION
	unreachable
.LBB18_155:                             # %if.then140
	end_block                       # label84:
	call    	abort@FUNCTION
	unreachable
.LBB18_156:                             # %if.then133
	end_block                       # label83:
	call    	abort@FUNCTION
	unreachable
.LBB18_157:                             # %if.then126
	end_block                       # label82:
	call    	abort@FUNCTION
	unreachable
.LBB18_158:                             # %if.then99
	end_block                       # label81:
	call    	abort@FUNCTION
	unreachable
.LBB18_159:                             # %if.then85
	end_block                       # label63:
	call    	abort@FUNCTION
	unreachable
.LBB18_160:                             # %if.then79
	end_block                       # label62:
	call    	abort@FUNCTION
	unreachable
.LBB18_161:                             # %if.then73
	end_block                       # label61:
	call    	abort@FUNCTION
	unreachable
.LBB18_162:                             # %if.then48
	end_block                       # label60:
	call    	abort@FUNCTION
	unreachable
.LBB18_163:                             # %if.then37
	end_block                       # label42:
	call    	abort@FUNCTION
	unreachable
.LBB18_164:                             # %if.then31
	end_block                       # label41:
	call    	abort@FUNCTION
	unreachable
.LBB18_165:                             # %if.then25
	end_block                       # label40:
	call    	abort@FUNCTION
	unreachable
.LBB18_166:                             # %if.then
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
