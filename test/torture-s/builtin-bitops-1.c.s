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
	i32.eqz 	$push9=, $0
	br_if   	0, $pop9        # 0: down to label0
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
	i32.const	$push8=, 1
	i32.add 	$push7=, $1, $pop8
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, 32
	i32.lt_u	$push2=, $pop6, $pop5
	br_if   	0, $pop2        # 0: up to label1
.LBB0_4:                                # %for.end
	end_loop                        # label2:
	i32.const	$push3=, 1
	i32.add 	$1=, $1, $pop3
.LBB0_5:                                # %cleanup
	end_block                       # label0:
	copy_local	$push10=, $1
                                        # fallthrough-return: $pop10
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
	i32.const	$push7=, 1
	i32.add 	$push6=, $1, $pop7
	tee_local	$push5=, $1=, $pop6
	i32.const	$push4=, 32
	i32.lt_u	$push2=, $pop5, $pop4
	br_if   	0, $pop2        # 0: up to label3
.LBB1_3:                                # %for.end
	end_loop                        # label4:
	copy_local	$push8=, $1
                                        # fallthrough-return: $pop8
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
	i32.const	$push8=, -1
	i32.add 	$1=, $1, $pop8
	i32.const	$push7=, 1
	i32.add 	$push6=, $2, $pop7
	tee_local	$push5=, $2=, $pop6
	i32.const	$push4=, 32
	i32.lt_u	$push2=, $pop5, $pop4
	br_if   	0, $pop2        # 0: up to label5
.LBB2_3:                                # %for.end
	end_loop                        # label6:
	copy_local	$push9=, $2
                                        # fallthrough-return: $pop9
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
	i32.const	$push12=, -1
	i32.add 	$2=, $2, $pop12
	i32.const	$push11=, 1
	i32.add 	$push10=, $3, $pop11
	tee_local	$push9=, $3=, $pop10
	i32.const	$push8=, 32
	i32.lt_u	$push4=, $pop9, $pop8
	br_if   	0, $pop4        # 0: up to label7
.LBB3_3:                                # %for.end
	end_loop                        # label8:
	i32.const	$push5=, -1
	i32.add 	$push6=, $3, $pop5
                                        # fallthrough-return: $pop6
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
	i32.const	$push9=, 1
	i32.shl 	$push0=, $pop9, $2
	i32.and 	$push1=, $pop0, $0
	i32.const	$push8=, 0
	i32.ne  	$push2=, $pop1, $pop8
	i32.add 	$1=, $pop2, $1
	i32.const	$push7=, 1
	i32.add 	$push6=, $2, $pop7
	tee_local	$push5=, $2=, $pop6
	i32.const	$push4=, 32
	i32.ne  	$push3=, $pop5, $pop4
	br_if   	0, $pop3        # 0: up to label9
# BB#2:                                 # %for.end
	end_loop                        # label10:
	copy_local	$push10=, $1
                                        # fallthrough-return: $pop10
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
	i32.const	$push11=, 1
	i32.shl 	$push0=, $pop11, $2
	i32.and 	$push1=, $pop0, $0
	i32.const	$push10=, 0
	i32.ne  	$push2=, $pop1, $pop10
	i32.add 	$1=, $pop2, $1
	i32.const	$push9=, 1
	i32.add 	$push8=, $2, $pop9
	tee_local	$push7=, $2=, $pop8
	i32.const	$push6=, 32
	i32.ne  	$push3=, $pop7, $pop6
	br_if   	0, $pop3        # 0: up to label11
# BB#2:                                 # %for.end
	end_loop                        # label12:
	i32.const	$push4=, 1
	i32.and 	$push5=, $1, $pop4
                                        # fallthrough-return: $pop5
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
	i32.eqz 	$push9=, $0
	br_if   	0, $pop9        # 0: down to label13
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
	i32.const	$push8=, 1
	i32.add 	$push7=, $1, $pop8
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, 32
	i32.lt_u	$push2=, $pop6, $pop5
	br_if   	0, $pop2        # 0: up to label14
.LBB6_4:                                # %for.end
	end_loop                        # label15:
	i32.const	$push3=, 1
	i32.add 	$1=, $1, $pop3
.LBB6_5:                                # %cleanup
	end_block                       # label13:
	copy_local	$push10=, $1
                                        # fallthrough-return: $pop10
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
	i32.const	$push7=, 1
	i32.add 	$push6=, $1, $pop7
	tee_local	$push5=, $1=, $pop6
	i32.const	$push4=, 32
	i32.lt_u	$push2=, $pop5, $pop4
	br_if   	0, $pop2        # 0: up to label16
.LBB7_3:                                # %for.end
	end_loop                        # label17:
	copy_local	$push8=, $1
                                        # fallthrough-return: $pop8
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
	i32.const	$push8=, -1
	i32.add 	$1=, $1, $pop8
	i32.const	$push7=, 1
	i32.add 	$push6=, $2, $pop7
	tee_local	$push5=, $2=, $pop6
	i32.const	$push4=, 32
	i32.lt_u	$push2=, $pop5, $pop4
	br_if   	0, $pop2        # 0: up to label18
.LBB8_3:                                # %for.end
	end_loop                        # label19:
	copy_local	$push9=, $2
                                        # fallthrough-return: $pop9
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
	i32.const	$push12=, -1
	i32.add 	$2=, $2, $pop12
	i32.const	$push11=, 1
	i32.add 	$push10=, $3, $pop11
	tee_local	$push9=, $3=, $pop10
	i32.const	$push8=, 32
	i32.lt_u	$push4=, $pop9, $pop8
	br_if   	0, $pop4        # 0: up to label20
.LBB9_3:                                # %for.end
	end_loop                        # label21:
	i32.const	$push5=, -1
	i32.add 	$push6=, $3, $pop5
                                        # fallthrough-return: $pop6
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
	i32.const	$push9=, 1
	i32.shl 	$push0=, $pop9, $2
	i32.and 	$push1=, $pop0, $0
	i32.const	$push8=, 0
	i32.ne  	$push2=, $pop1, $pop8
	i32.add 	$1=, $pop2, $1
	i32.const	$push7=, 1
	i32.add 	$push6=, $2, $pop7
	tee_local	$push5=, $2=, $pop6
	i32.const	$push4=, 32
	i32.ne  	$push3=, $pop5, $pop4
	br_if   	0, $pop3        # 0: up to label22
# BB#2:                                 # %for.end
	end_loop                        # label23:
	copy_local	$push10=, $1
                                        # fallthrough-return: $pop10
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
	i32.const	$push11=, 1
	i32.shl 	$push0=, $pop11, $2
	i32.and 	$push1=, $pop0, $0
	i32.const	$push10=, 0
	i32.ne  	$push2=, $pop1, $pop10
	i32.add 	$1=, $pop2, $1
	i32.const	$push9=, 1
	i32.add 	$push8=, $2, $pop9
	tee_local	$push7=, $2=, $pop8
	i32.const	$push6=, 32
	i32.ne  	$push3=, $pop7, $pop6
	br_if   	0, $pop3        # 0: up to label24
# BB#2:                                 # %for.end
	end_loop                        # label25:
	i32.const	$push4=, 1
	i32.and 	$push5=, $1, $pop4
                                        # fallthrough-return: $pop5
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
	i32.const	$2=, 0
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
	i32.const	$push12=, 1
	i32.add 	$2=, $2, $pop12
	i64.const	$push11=, 1
	i64.add 	$push10=, $1, $pop11
	tee_local	$push9=, $1=, $pop10
	i64.const	$push8=, 64
	i64.lt_u	$push4=, $pop9, $pop8
	br_if   	0, $pop4        # 0: up to label27
.LBB12_4:                               # %for.end
	end_loop                        # label28:
	i32.const	$push5=, 1
	i32.add 	$2=, $2, $pop5
.LBB12_5:                               # %cleanup
	end_block                       # label26:
	copy_local	$push13=, $2
                                        # fallthrough-return: $pop13
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
	i32.const	$2=, 0
	i64.const	$1=, 0
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
	i32.const	$push10=, 1
	i32.add 	$2=, $2, $pop10
	i64.const	$push9=, 1
	i64.add 	$push8=, $1, $pop9
	tee_local	$push7=, $1=, $pop8
	i64.const	$push6=, 64
	i64.lt_u	$push3=, $pop7, $pop6
	br_if   	0, $pop3        # 0: up to label29
.LBB13_3:                               # %for.end
	end_loop                        # label30:
	copy_local	$push11=, $2
                                        # fallthrough-return: $pop11
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
	i32.const	$3=, 0
	i64.const	$1=, 63
	i64.const	$2=, 0
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
	i64.const	$push13=, -1
	i64.add 	$1=, $1, $pop13
	i32.const	$push12=, 1
	i32.add 	$3=, $3, $pop12
	i64.const	$push11=, 1
	i64.add 	$push10=, $2, $pop11
	tee_local	$push9=, $2=, $pop10
	i64.const	$push8=, 64
	i64.lt_u	$push4=, $pop9, $pop8
	br_if   	0, $pop4        # 0: up to label31
.LBB14_3:                               # %for.end
	end_loop                        # label32:
	copy_local	$push14=, $3
                                        # fallthrough-return: $pop14
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
	i64.const	$push13=, -1
	i64.add 	$2=, $2, $pop13
	i32.const	$push12=, 1
	i32.add 	$4=, $4, $pop12
	i64.const	$push11=, 1
	i64.add 	$push10=, $3, $pop11
	tee_local	$push9=, $3=, $pop10
	i64.const	$push8=, 64
	i64.lt_u	$push4=, $pop9, $pop8
	br_if   	0, $pop4        # 0: up to label33
.LBB15_3:                               # %for.end
	end_loop                        # label34:
	i32.const	$push5=, -1
	i32.add 	$push6=, $4, $pop5
                                        # fallthrough-return: $pop6
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
	i32.const	$2=, 0
	i64.const	$1=, 0
.LBB16_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label35:
	i64.const	$push9=, 1
	i64.shl 	$push0=, $pop9, $1
	i64.and 	$push1=, $pop0, $0
	i64.const	$push8=, 0
	i64.ne  	$push2=, $pop1, $pop8
	i32.add 	$2=, $pop2, $2
	i64.const	$push7=, 1
	i64.add 	$push6=, $1, $pop7
	tee_local	$push5=, $1=, $pop6
	i64.const	$push4=, 64
	i64.ne  	$push3=, $pop5, $pop4
	br_if   	0, $pop3        # 0: up to label35
# BB#2:                                 # %for.end
	end_loop                        # label36:
	copy_local	$push10=, $2
                                        # fallthrough-return: $pop10
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
	i32.const	$2=, 0
	i64.const	$1=, 0
.LBB17_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label37:
	i64.const	$push11=, 1
	i64.shl 	$push0=, $pop11, $1
	i64.and 	$push1=, $pop0, $0
	i64.const	$push10=, 0
	i64.ne  	$push2=, $pop1, $pop10
	i32.add 	$2=, $pop2, $2
	i64.const	$push9=, 1
	i64.add 	$push8=, $1, $pop9
	tee_local	$push7=, $1=, $pop8
	i64.const	$push6=, 64
	i64.ne  	$push3=, $pop7, $pop6
	br_if   	0, $pop3        # 0: up to label37
# BB#2:                                 # %for.end
	end_loop                        # label38:
	i32.const	$push4=, 1
	i32.and 	$push5=, $2, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end17:
	.size	my_parityll, .Lfunc_end17-my_parityll

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i64, i32, i32, i64, i64, i64, i32
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
	i32.const	$push221=, 2
	i32.shl 	$push220=, $0, $pop221
	tee_local	$push219=, $6=, $pop220
	i32.load	$push218=, ints($pop219)
	tee_local	$push217=, $10=, $pop218
	i32.ctz 	$push216=, $pop217
	tee_local	$push215=, $2=, $pop216
	i32.const	$push214=, 1
	i32.add 	$push5=, $pop215, $pop214
	i32.const	$push213=, 0
	i32.select	$5=, $pop5, $pop213, $10
	i32.const	$3=, 0
	block
	i32.eqz 	$push433=, $10
	br_if   	0, $pop433      # 0: down to label43
# BB#2:                                 # %for.body.i.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$3=, 0
.LBB18_3:                               # %for.body.i
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label44:
	i32.const	$push222=, 1
	i32.shl 	$push6=, $pop222, $3
	i32.and 	$push7=, $pop6, $10
	br_if   	1, $pop7        # 1: down to label45
# BB#4:                                 # %for.inc.i
                                        #   in Loop: Header=BB18_3 Depth=2
	i32.const	$push226=, 1
	i32.add 	$push225=, $3, $pop226
	tee_local	$push224=, $3=, $pop225
	i32.const	$push223=, 32
	i32.lt_u	$push8=, $pop224, $pop223
	br_if   	0, $pop8        # 0: up to label44
.LBB18_5:                               # %for.end.i
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label45:
	i32.const	$push227=, 1
	i32.add 	$3=, $3, $pop227
.LBB18_6:                               # %my_ffs.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label43:
	i32.ne  	$push9=, $5, $3
	br_if   	2, $pop9        # 2: down to label40
# BB#7:                                 # %if.end
                                        #   in Loop: Header=BB18_1 Depth=1
	block
	i32.eqz 	$push434=, $10
	br_if   	0, $pop434      # 0: down to label46
# BB#8:                                 # %land.lhs.true
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.clz 	$1=, $10
	i32.const	$5=, 0
	i32.const	$3=, 31
.LBB18_9:                               # %for.body.i822
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label47:
	i32.const	$push228=, 1
	i32.shl 	$push10=, $pop228, $3
	i32.and 	$push11=, $pop10, $10
	br_if   	1, $pop11       # 1: down to label48
# BB#10:                                # %for.inc.i825
                                        #   in Loop: Header=BB18_9 Depth=2
	i32.const	$push233=, -1
	i32.add 	$3=, $3, $pop233
	i32.const	$push232=, 1
	i32.add 	$push231=, $5, $pop232
	tee_local	$push230=, $5=, $pop231
	i32.const	$push229=, 32
	i32.lt_u	$push12=, $pop230, $pop229
	br_if   	0, $pop12       # 0: up to label47
.LBB18_11:                              # %my_clz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label48:
	i32.ne  	$push13=, $1, $5
	br_if   	3, $pop13       # 3: down to label40
# BB#12:                                # %land.lhs.true13
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$3=, 0
.LBB18_13:                              # %for.body.i889
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label49:
	i32.const	$push234=, 1
	i32.shl 	$push14=, $pop234, $3
	i32.and 	$push15=, $pop14, $10
	br_if   	1, $pop15       # 1: down to label50
# BB#14:                                # %for.inc.i892
                                        #   in Loop: Header=BB18_13 Depth=2
	i32.const	$push238=, 1
	i32.add 	$push237=, $3, $pop238
	tee_local	$push236=, $3=, $pop237
	i32.const	$push235=, 32
	i32.lt_u	$push16=, $pop236, $pop235
	br_if   	0, $pop16       # 0: up to label49
.LBB18_15:                              # %my_ctz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label50:
	i32.ne  	$push17=, $2, $3
	br_if   	3, $pop17       # 3: down to label40
.LBB18_16:                              # %if.end19
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label46:
	i32.call	$2=, __builtin_clrsb@FUNCTION, $10
	i32.const	$push242=, ints
	i32.add 	$push0=, $6, $pop242
	i32.load	$push241=, 0($pop0)
	tee_local	$push240=, $3=, $pop241
	i32.const	$push239=, 31
	i32.shr_u	$6=, $pop240, $pop239
	i32.const	$5=, 1
	i32.const	$10=, 30
.LBB18_17:                              # %for.body.i974
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label51:
	i32.shr_u	$push18=, $3, $10
	i32.const	$push243=, 1
	i32.and 	$push19=, $pop18, $pop243
	i32.ne  	$push20=, $pop19, $6
	br_if   	1, $pop20       # 1: down to label52
# BB#18:                                # %for.inc.i977
                                        #   in Loop: Header=BB18_17 Depth=2
	i32.const	$push248=, -1
	i32.add 	$10=, $10, $pop248
	i32.const	$push247=, 1
	i32.add 	$push246=, $5, $pop247
	tee_local	$push245=, $5=, $pop246
	i32.const	$push244=, 32
	i32.lt_u	$push21=, $pop245, $pop244
	br_if   	0, $pop21       # 0: up to label51
.LBB18_19:                              # %my_clrsb.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label52:
	i32.const	$push249=, -1
	i32.add 	$push22=, $5, $pop249
	i32.ne  	$push23=, $2, $pop22
	br_if   	2, $pop23       # 2: down to label40
# BB#20:                                # %for.body.i1069.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$5=, 0
	i32.const	$10=, 0
.LBB18_21:                              # %for.body.i1069
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label53:
	i32.const	$push255=, 1
	i32.shl 	$push24=, $pop255, $10
	i32.and 	$push25=, $pop24, $3
	i32.const	$push254=, 0
	i32.ne  	$push26=, $pop25, $pop254
	i32.add 	$5=, $pop26, $5
	i32.const	$push253=, 1
	i32.add 	$push252=, $10, $pop253
	tee_local	$push251=, $10=, $pop252
	i32.const	$push250=, 32
	i32.ne  	$push27=, $pop251, $pop250
	br_if   	0, $pop27       # 0: up to label53
# BB#22:                                # %my_popcount.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label54:
	i32.popcnt	$push28=, $3
	i32.ne  	$push29=, $pop28, $5
	br_if   	2, $pop29       # 2: down to label40
# BB#23:                                # %for.body.i1161.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$6=, 0
	i32.const	$10=, 0
.LBB18_24:                              # %for.body.i1161
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label55:
	i32.const	$push261=, 1
	i32.shl 	$push30=, $pop261, $10
	i32.and 	$push31=, $pop30, $3
	i32.const	$push260=, 0
	i32.ne  	$push32=, $pop31, $pop260
	i32.add 	$6=, $pop32, $6
	i32.const	$push259=, 1
	i32.add 	$push258=, $10, $pop259
	tee_local	$push257=, $10=, $pop258
	i32.const	$push256=, 32
	i32.ne  	$push33=, $pop257, $pop256
	br_if   	0, $pop33       # 0: up to label55
# BB#25:                                # %my_parity.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label56:
	i32.xor 	$push34=, $6, $5
	i32.const	$push262=, 1
	i32.and 	$push35=, $pop34, $pop262
	br_if   	2, $pop35       # 2: down to label40
# BB#26:                                # %for.cond
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$push266=, 1
	i32.add 	$push265=, $0, $pop266
	tee_local	$push264=, $0=, $pop265
	i32.const	$push263=, 13
	i32.lt_u	$push36=, $pop264, $pop263
	br_if   	0, $pop36       # 0: up to label41
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
	i32.const	$push275=, 2
	i32.shl 	$push274=, $0, $pop275
	tee_local	$push273=, $6=, $pop274
	i32.load	$push272=, longs($pop273)
	tee_local	$push271=, $10=, $pop272
	i32.ctz 	$push270=, $pop271
	tee_local	$push269=, $2=, $pop270
	i32.const	$push268=, 1
	i32.add 	$push37=, $pop269, $pop268
	i32.const	$push267=, 0
	i32.select	$5=, $pop37, $pop267, $10
	i32.const	$3=, 0
	block
	i32.eqz 	$push435=, $10
	br_if   	0, $pop435      # 0: down to label59
# BB#29:                                # %for.body.i1251.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$3=, 0
.LBB18_30:                              # %for.body.i1251
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label60:
	i32.const	$push276=, 1
	i32.shl 	$push38=, $pop276, $3
	i32.and 	$push39=, $pop38, $10
	br_if   	1, $pop39       # 1: down to label61
# BB#31:                                # %for.inc.i1254
                                        #   in Loop: Header=BB18_30 Depth=2
	i32.const	$push280=, 1
	i32.add 	$push279=, $3, $pop280
	tee_local	$push278=, $3=, $pop279
	i32.const	$push277=, 32
	i32.lt_u	$push40=, $pop278, $pop277
	br_if   	0, $pop40       # 0: up to label60
.LBB18_32:                              # %for.end.i1257
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label61:
	i32.const	$push281=, 1
	i32.add 	$3=, $3, $pop281
.LBB18_33:                              # %my_ffsl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_block                       # label59:
	i32.ne  	$push41=, $5, $3
	br_if   	2, $pop41       # 2: down to label40
# BB#34:                                # %if.end49
                                        #   in Loop: Header=BB18_28 Depth=1
	block
	i32.eqz 	$push436=, $10
	br_if   	0, $pop436      # 0: down to label62
# BB#35:                                # %land.lhs.true52
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.clz 	$1=, $10
	i32.const	$5=, 0
	i32.const	$3=, 31
.LBB18_36:                              # %for.body.i1346
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label63:
	i32.const	$push282=, 1
	i32.shl 	$push42=, $pop282, $3
	i32.and 	$push43=, $pop42, $10
	br_if   	1, $pop43       # 1: down to label64
# BB#37:                                # %for.inc.i1349
                                        #   in Loop: Header=BB18_36 Depth=2
	i32.const	$push287=, -1
	i32.add 	$3=, $3, $pop287
	i32.const	$push286=, 1
	i32.add 	$push285=, $5, $pop286
	tee_local	$push284=, $5=, $pop285
	i32.const	$push283=, 32
	i32.lt_u	$push44=, $pop284, $pop283
	br_if   	0, $pop44       # 0: up to label63
.LBB18_38:                              # %my_clzl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label64:
	i32.ne  	$push45=, $1, $5
	br_if   	3, $pop45       # 3: down to label40
# BB#39:                                # %land.lhs.true61
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$3=, 0
.LBB18_40:                              # %for.body.i1438
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label65:
	i32.const	$push288=, 1
	i32.shl 	$push46=, $pop288, $3
	i32.and 	$push47=, $pop46, $10
	br_if   	1, $pop47       # 1: down to label66
# BB#41:                                # %for.inc.i1441
                                        #   in Loop: Header=BB18_40 Depth=2
	i32.const	$push292=, 1
	i32.add 	$push291=, $3, $pop292
	tee_local	$push290=, $3=, $pop291
	i32.const	$push289=, 32
	i32.lt_u	$push48=, $pop290, $pop289
	br_if   	0, $pop48       # 0: up to label65
.LBB18_42:                              # %my_ctzl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label66:
	i32.ne  	$push49=, $2, $3
	br_if   	3, $pop49       # 3: down to label40
.LBB18_43:                              # %if.end67
                                        #   in Loop: Header=BB18_28 Depth=1
	end_block                       # label62:
	i32.call	$2=, __builtin_clrsbl@FUNCTION, $10
	i32.const	$push296=, longs
	i32.add 	$push1=, $6, $pop296
	i32.load	$push295=, 0($pop1)
	tee_local	$push294=, $3=, $pop295
	i32.const	$push293=, 31
	i32.shr_u	$6=, $pop294, $pop293
	i32.const	$5=, 1
	i32.const	$10=, 30
.LBB18_44:                              # %for.body.i1532
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label67:
	i32.shr_u	$push50=, $3, $10
	i32.const	$push297=, 1
	i32.and 	$push51=, $pop50, $pop297
	i32.ne  	$push52=, $pop51, $6
	br_if   	1, $pop52       # 1: down to label68
# BB#45:                                # %for.inc.i1535
                                        #   in Loop: Header=BB18_44 Depth=2
	i32.const	$push302=, -1
	i32.add 	$10=, $10, $pop302
	i32.const	$push301=, 1
	i32.add 	$push300=, $5, $pop301
	tee_local	$push299=, $5=, $pop300
	i32.const	$push298=, 32
	i32.lt_u	$push53=, $pop299, $pop298
	br_if   	0, $pop53       # 0: up to label67
.LBB18_46:                              # %my_clrsbl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label68:
	i32.const	$push303=, -1
	i32.add 	$push54=, $5, $pop303
	i32.ne  	$push55=, $2, $pop54
	br_if   	2, $pop55       # 2: down to label40
# BB#47:                                # %for.body.i1630.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$5=, 0
	i32.const	$10=, 0
.LBB18_48:                              # %for.body.i1630
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label69:
	i32.const	$push309=, 1
	i32.shl 	$push56=, $pop309, $10
	i32.and 	$push57=, $pop56, $3
	i32.const	$push308=, 0
	i32.ne  	$push58=, $pop57, $pop308
	i32.add 	$5=, $pop58, $5
	i32.const	$push307=, 1
	i32.add 	$push306=, $10, $pop307
	tee_local	$push305=, $10=, $pop306
	i32.const	$push304=, 32
	i32.ne  	$push59=, $pop305, $pop304
	br_if   	0, $pop59       # 0: up to label69
# BB#49:                                # %my_popcountl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label70:
	i32.popcnt	$push60=, $3
	i32.ne  	$push61=, $pop60, $5
	br_if   	2, $pop61       # 2: down to label40
# BB#50:                                # %for.body.i1723.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$6=, 0
	i32.const	$10=, 0
.LBB18_51:                              # %for.body.i1723
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label71:
	i32.const	$push315=, 1
	i32.shl 	$push62=, $pop315, $10
	i32.and 	$push63=, $pop62, $3
	i32.const	$push314=, 0
	i32.ne  	$push64=, $pop63, $pop314
	i32.add 	$6=, $pop64, $6
	i32.const	$push313=, 1
	i32.add 	$push312=, $10, $pop313
	tee_local	$push311=, $10=, $pop312
	i32.const	$push310=, 32
	i32.ne  	$push65=, $pop311, $pop310
	br_if   	0, $pop65       # 0: up to label71
# BB#52:                                # %my_parityl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label72:
	i32.xor 	$push66=, $6, $5
	i32.const	$push316=, 1
	i32.and 	$push67=, $pop66, $pop316
	br_if   	2, $pop67       # 2: down to label40
# BB#53:                                # %for.cond39
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$push320=, 1
	i32.add 	$push319=, $0, $pop320
	tee_local	$push318=, $0=, $pop319
	i32.const	$push317=, 13
	i32.lt_u	$push68=, $pop318, $pop317
	br_if   	0, $pop68       # 0: up to label57
# BB#54:                                # %for.body92.preheader
	end_loop                        # label58:
	i32.const	$5=, 0
.LBB18_55:                              # %for.body92
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_57 Depth 2
                                        #     Child Loop BB18_63 Depth 2
                                        #     Child Loop BB18_67 Depth 2
                                        #     Child Loop BB18_71 Depth 2
                                        #     Child Loop BB18_75 Depth 2
                                        #     Child Loop BB18_78 Depth 2
	loop                            # label73:
	i32.const	$push331=, 0
	i32.const	$push330=, 3
	i32.shl 	$push329=, $5, $pop330
	tee_local	$push328=, $0=, $pop329
	i64.load	$push327=, longlongs($pop328)
	tee_local	$push326=, $8=, $pop327
	i64.ctz 	$push325=, $pop326
	tee_local	$push324=, $4=, $pop325
	i64.const	$push323=, 1
	i64.add 	$push69=, $pop324, $pop323
	i32.wrap/i64	$push70=, $pop69
	i64.eqz 	$push322=, $8
	tee_local	$push321=, $3=, $pop322
	i32.select	$6=, $pop331, $pop70, $pop321
	i32.const	$10=, 0
	block
	br_if   	0, $3           # 0: down to label75
# BB#56:                                # %for.body.i1814.preheader
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.const	$10=, 0
	i64.const	$9=, 0
.LBB18_57:                              # %for.body.i1814
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label76:
	i64.const	$push333=, 1
	i64.shl 	$push71=, $pop333, $9
	i64.and 	$push72=, $pop71, $8
	i64.const	$push332=, 0
	i64.ne  	$push73=, $pop72, $pop332
	br_if   	1, $pop73       # 1: down to label77
# BB#58:                                # %for.inc.i1818
                                        #   in Loop: Header=BB18_57 Depth=2
	i32.const	$push338=, 1
	i32.add 	$10=, $10, $pop338
	i64.const	$push337=, 1
	i64.add 	$push336=, $9, $pop337
	tee_local	$push335=, $9=, $pop336
	i64.const	$push334=, 64
	i64.lt_u	$push74=, $pop335, $pop334
	br_if   	0, $pop74       # 0: up to label76
.LBB18_59:                              # %for.end.i1821
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label77:
	i32.const	$push339=, 1
	i32.add 	$10=, $10, $pop339
.LBB18_60:                              # %my_ffsll.exit1823
                                        #   in Loop: Header=BB18_55 Depth=1
	end_block                       # label75:
	i32.ne  	$push75=, $6, $10
	br_if   	2, $pop75       # 2: down to label40
# BB#61:                                # %if.end100
                                        #   in Loop: Header=BB18_55 Depth=1
	block
	br_if   	0, $3           # 0: down to label78
# BB#62:                                # %land.lhs.true103
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.clz 	$push76=, $8
	i32.wrap/i64	$3=, $pop76
	i32.const	$10=, 0
	i64.const	$7=, 0
	i64.const	$9=, 63
.LBB18_63:                              # %for.body.i1902
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label79:
	i64.const	$push342=, 1
	i64.const	$push341=, 4294967295
	i64.and 	$push77=, $9, $pop341
	i64.shl 	$push78=, $pop342, $pop77
	i64.and 	$push79=, $pop78, $8
	i64.const	$push340=, 0
	i64.ne  	$push80=, $pop79, $pop340
	br_if   	1, $pop80       # 1: down to label80
# BB#64:                                # %for.inc.i1906
                                        #   in Loop: Header=BB18_63 Depth=2
	i64.const	$push348=, -1
	i64.add 	$9=, $9, $pop348
	i32.const	$push347=, 1
	i32.add 	$10=, $10, $pop347
	i64.const	$push346=, 1
	i64.add 	$push345=, $7, $pop346
	tee_local	$push344=, $7=, $pop345
	i64.const	$push343=, 64
	i64.lt_u	$push81=, $pop344, $pop343
	br_if   	0, $pop81       # 0: up to label79
.LBB18_65:                              # %my_clzll.exit1909
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label80:
	i32.ne  	$push82=, $3, $10
	br_if   	3, $pop82       # 3: down to label40
# BB#66:                                # %land.lhs.true113
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.wrap/i64	$3=, $4
	i32.const	$10=, 0
	i64.const	$9=, 0
.LBB18_67:                              # %for.body.i1948
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label81:
	i64.const	$push350=, 1
	i64.shl 	$push83=, $pop350, $9
	i64.and 	$push84=, $pop83, $8
	i64.const	$push349=, 0
	i64.ne  	$push85=, $pop84, $pop349
	br_if   	1, $pop85       # 1: down to label82
# BB#68:                                # %for.inc.i1952
                                        #   in Loop: Header=BB18_67 Depth=2
	i32.const	$push355=, 1
	i32.add 	$10=, $10, $pop355
	i64.const	$push354=, 1
	i64.add 	$push353=, $9, $pop354
	tee_local	$push352=, $9=, $pop353
	i64.const	$push351=, 64
	i64.lt_u	$push86=, $pop352, $pop351
	br_if   	0, $pop86       # 0: up to label81
.LBB18_69:                              # %my_ctzll.exit1955
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label82:
	i32.ne  	$push87=, $3, $10
	br_if   	3, $pop87       # 3: down to label40
.LBB18_70:                              # %if.end120
                                        #   in Loop: Header=BB18_55 Depth=1
	end_block                       # label78:
	i32.call	$3=, __builtin_clrsbll@FUNCTION, $8
	i32.const	$push359=, longlongs
	i32.add 	$push2=, $0, $pop359
	i64.load	$push358=, 0($pop2)
	tee_local	$push357=, $9=, $pop358
	i64.const	$push356=, 63
	i64.shr_u	$4=, $pop357, $pop356
	i32.const	$10=, 1
	i64.const	$7=, 1
	i64.const	$8=, 62
.LBB18_71:                              # %for.body.i2018
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label83:
	i64.shr_u	$push88=, $9, $8
	i64.const	$push360=, 1
	i64.and 	$push89=, $pop88, $pop360
	i64.ne  	$push90=, $pop89, $4
	br_if   	1, $pop90       # 1: down to label84
# BB#72:                                # %for.inc.i2022
                                        #   in Loop: Header=BB18_71 Depth=2
	i64.const	$push366=, -1
	i64.add 	$8=, $8, $pop366
	i32.const	$push365=, 1
	i32.add 	$10=, $10, $pop365
	i64.const	$push364=, 1
	i64.add 	$push363=, $7, $pop364
	tee_local	$push362=, $7=, $pop363
	i64.const	$push361=, 64
	i64.lt_u	$push91=, $pop362, $pop361
	br_if   	0, $pop91       # 0: up to label83
.LBB18_73:                              # %my_clrsbll.exit2026
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label84:
	i32.const	$push367=, -1
	i32.add 	$push92=, $10, $pop367
	i32.ne  	$push93=, $3, $pop92
	br_if   	2, $pop93       # 2: down to label40
# BB#74:                                # %if.end127
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.popcnt	$7=, $9
	i32.const	$10=, 0
	i64.const	$8=, 0
.LBB18_75:                              # %for.body.i2110
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label85:
	i64.const	$push373=, 1
	i64.shl 	$push94=, $pop373, $8
	i64.and 	$push95=, $pop94, $9
	i64.const	$push372=, 0
	i64.ne  	$push96=, $pop95, $pop372
	i32.add 	$10=, $pop96, $10
	i64.const	$push371=, 1
	i64.add 	$push370=, $8, $pop371
	tee_local	$push369=, $8=, $pop370
	i64.const	$push368=, 64
	i64.ne  	$push97=, $pop369, $pop368
	br_if   	0, $pop97       # 0: up to label85
# BB#76:                                # %my_popcountll.exit2112
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label86:
	i32.wrap/i64	$push98=, $7
	i32.ne  	$push99=, $pop98, $10
	br_if   	2, $pop99       # 2: down to label40
# BB#77:                                # %for.body.i2196.preheader
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.const	$3=, 0
	i64.const	$8=, 0
.LBB18_78:                              # %for.body.i2196
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label87:
	i64.const	$push379=, 1
	i64.shl 	$push100=, $pop379, $8
	i64.and 	$push101=, $pop100, $9
	i64.const	$push378=, 0
	i64.ne  	$push102=, $pop101, $pop378
	i32.add 	$3=, $pop102, $3
	i64.const	$push377=, 1
	i64.add 	$push376=, $8, $pop377
	tee_local	$push375=, $8=, $pop376
	i64.const	$push374=, 64
	i64.ne  	$push103=, $pop375, $pop374
	br_if   	0, $pop103      # 0: up to label87
# BB#79:                                # %my_parityll.exit2199
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label88:
	i32.xor 	$push104=, $3, $10
	i32.const	$push380=, 1
	i32.and 	$push105=, $pop104, $pop380
	br_if   	3, $pop105      # 3: down to label39
# BB#80:                                # %for.cond90
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.const	$push384=, 1
	i32.add 	$push383=, $5, $pop384
	tee_local	$push382=, $5=, $pop383
	i32.const	$push381=, 12
	i32.le_u	$push106=, $pop382, $pop381
	br_if   	0, $pop106      # 0: up to label73
# BB#81:                                # %if.end148
	end_loop                        # label74:
	i32.const	$push107=, 0
	i32.call	$push108=, __builtin_clrsb@FUNCTION, $pop107
	i32.const	$push109=, 31
	i32.ne  	$push110=, $pop108, $pop109
	br_if   	0, $pop110      # 0: down to label40
# BB#82:                                # %my_clrsb.exit2770
	i32.const	$push111=, 1
	i32.call	$push112=, __builtin_clrsb@FUNCTION, $pop111
	i32.const	$push113=, 30
	i32.ne  	$push114=, $pop112, $pop113
	br_if   	0, $pop114      # 0: down to label40
# BB#83:                                # %if.end198
	i32.const	$push115=, -2147483648
	i32.call	$push116=, __builtin_clrsb@FUNCTION, $pop115
	br_if   	0, $pop116      # 0: down to label40
# BB#84:                                # %my_clrsb.exit2597
	i32.const	$push117=, 1073741824
	i32.call	$push118=, __builtin_clrsb@FUNCTION, $pop117
	br_if   	0, $pop118      # 0: down to label40
# BB#85:                                # %my_clrsb.exit2514
	i32.const	$push119=, 65536
	i32.call	$push120=, __builtin_clrsb@FUNCTION, $pop119
	i32.const	$push121=, 14
	i32.ne  	$push122=, $pop120, $pop121
	br_if   	0, $pop122      # 0: down to label40
# BB#86:                                # %my_clrsb.exit2432
	i32.const	$push123=, 32768
	i32.call	$push124=, __builtin_clrsb@FUNCTION, $pop123
	i32.const	$push125=, 15
	i32.ne  	$push126=, $pop124, $pop125
	br_if   	0, $pop126      # 0: down to label40
# BB#87:                                # %my_clrsb.exit2348
	i32.const	$push127=, -1515870811
	i32.call	$push128=, __builtin_clrsb@FUNCTION, $pop127
	br_if   	0, $pop128      # 0: down to label40
# BB#88:                                # %my_clrsb.exit2273
	i32.const	$push129=, 1515870810
	i32.call	$push130=, __builtin_clrsb@FUNCTION, $pop129
	br_if   	0, $pop130      # 0: down to label40
# BB#89:                                # %for.body.i2179
	i32.const	$push131=, -889323520
	i32.call	$push132=, __builtin_clrsb@FUNCTION, $pop131
	i32.const	$push133=, 1
	i32.ne  	$push134=, $pop132, $pop133
	br_if   	0, $pop134      # 0: down to label40
# BB#90:                                # %for.body.i2093
	i32.const	$push135=, 13303296
	i32.call	$push136=, __builtin_clrsb@FUNCTION, $pop135
	i32.const	$push137=, 7
	i32.ne  	$push138=, $pop136, $pop137
	br_if   	0, $pop138      # 0: down to label40
# BB#91:                                # %for.body.i2004
	i32.const	$push139=, 51966
	i32.call	$push140=, __builtin_clrsb@FUNCTION, $pop139
	i32.const	$push141=, 15
	i32.ne  	$push142=, $pop140, $pop141
	br_if   	0, $pop142      # 0: down to label40
# BB#92:                                # %if.end423
	i32.const	$push385=, -1
	i32.call	$5=, __builtin_clrsb@FUNCTION, $pop385
	i32.const	$10=, 30
	i32.const	$3=, 1
.LBB18_93:                              # %for.body.i1935
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label89:
	i32.const	$push387=, -1
	i32.shr_u	$push143=, $pop387, $10
	i32.const	$push386=, 1
	i32.and 	$push144=, $pop143, $pop386
	i32.eqz 	$push437=, $pop144
	br_if   	1, $pop437      # 1: down to label90
# BB#94:                                # %for.inc.i1938
                                        #   in Loop: Header=BB18_93 Depth=1
	i32.const	$push392=, -1
	i32.add 	$10=, $10, $pop392
	i32.const	$push391=, 1
	i32.add 	$push390=, $3, $pop391
	tee_local	$push389=, $3=, $pop390
	i32.const	$push388=, 32
	i32.lt_u	$push145=, $pop389, $pop388
	br_if   	0, $pop145      # 0: up to label89
.LBB18_95:                              # %my_clrsb.exit1942
	end_loop                        # label90:
	i32.const	$push146=, -1
	i32.add 	$push147=, $3, $pop146
	i32.ne  	$push148=, $5, $pop147
	br_if   	0, $pop148      # 0: down to label40
# BB#96:                                # %if.end440
	i64.const	$9=, 0
	i64.const	$push393=, 0
	i32.call	$push149=, __builtin_clrsbll@FUNCTION, $pop393
	i32.const	$push150=, 63
	i32.ne  	$push151=, $pop149, $pop150
	br_if   	0, $pop151      # 0: down to label40
# BB#97:                                # %for.body.i1844.preheader
	i32.const	$10=, 0
	i64.const	$8=, 63
.LBB18_98:                              # %for.body.i1844
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label91:
	i32.wrap/i64	$push152=, $8
	i32.eqz 	$push438=, $pop152
	br_if   	1, $pop438      # 1: down to label92
# BB#99:                                # %for.inc.i1848
                                        #   in Loop: Header=BB18_98 Depth=1
	i64.const	$push399=, -1
	i64.add 	$8=, $8, $pop399
	i32.const	$push398=, 1
	i32.add 	$10=, $10, $pop398
	i64.const	$push397=, 1
	i64.add 	$push396=, $9, $pop397
	tee_local	$push395=, $9=, $pop396
	i64.const	$push394=, 64
	i64.lt_u	$push153=, $pop395, $pop394
	br_if   	0, $pop153      # 0: up to label91
.LBB18_100:                             # %my_clzll.exit1851
	end_loop                        # label92:
	i32.const	$push154=, 63
	i32.ne  	$push155=, $10, $pop154
	br_if   	0, $pop155      # 0: down to label40
# BB#101:                               # %if.end465
	i64.const	$push400=, 1
	i32.call	$3=, __builtin_clrsbll@FUNCTION, $pop400
	i64.const	$8=, 1
.LBB18_102:                             # %for.body.i1799
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label93:
	i32.const	$10=, 62
	i64.const	$push401=, 63
	i64.eq  	$push156=, $8, $pop401
	br_if   	1, $pop156      # 1: down to label94
# BB#103:                               # %for.inc.i1803
                                        #   in Loop: Header=BB18_102 Depth=1
	i32.const	$10=, 63
	i64.const	$push405=, 1
	i64.add 	$push404=, $8, $pop405
	tee_local	$push403=, $8=, $pop404
	i64.const	$push402=, 64
	i64.lt_u	$push157=, $pop403, $pop402
	br_if   	0, $pop157      # 0: up to label93
.LBB18_104:                             # %my_clrsbll.exit1807
	end_loop                        # label94:
	i32.ne  	$push158=, $3, $10
	br_if   	0, $pop158      # 0: down to label40
# BB#105:                               # %for.body.i1759.preheader
	i64.const	$8=, 0
.LBB18_106:                             # %for.body.i1759
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label96:
	i64.const	$push406=, 63
	i64.eq  	$push159=, $8, $pop406
	br_if   	2, $pop159      # 2: down to label95
# BB#107:                               # %for.inc.i1763
                                        #   in Loop: Header=BB18_106 Depth=1
	i64.const	$push410=, 1
	i64.add 	$push409=, $8, $pop410
	tee_local	$push408=, $8=, $pop409
	i64.const	$push407=, 64
	i64.lt_u	$push160=, $pop408, $pop407
	br_if   	0, $pop160      # 0: up to label96
# BB#108:                               # %if.then481
	end_loop                        # label97:
	call    	abort@FUNCTION
	unreachable
.LBB18_109:                             # %for.body.i1731.preheader
	end_block                       # label95:
	i64.const	$8=, 0
.LBB18_110:                             # %for.body.i1731
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label99:
	i64.const	$push411=, 63
	i64.eq  	$push161=, $8, $pop411
	br_if   	2, $pop161      # 2: down to label98
# BB#111:                               # %for.inc.i1735
                                        #   in Loop: Header=BB18_110 Depth=1
	i64.const	$push415=, 1
	i64.add 	$push414=, $8, $pop415
	tee_local	$push413=, $8=, $pop414
	i64.const	$push412=, 64
	i64.lt_u	$push162=, $pop413, $pop412
	br_if   	0, $pop162      # 0: up to label99
# BB#112:                               # %if.then489
	end_loop                        # label100:
	call    	abort@FUNCTION
	unreachable
.LBB18_113:                             # %if.end490
	end_block                       # label98:
	i64.const	$push163=, -9223372036854775808
	i32.call	$push164=, __builtin_clrsbll@FUNCTION, $pop163
	br_if   	0, $pop164      # 0: down to label40
# BB#114:                               # %for.body.i1652.preheader
	i64.const	$8=, 63
	i64.const	$9=, -1
.LBB18_115:                             # %for.body.i1652
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label101:
	i64.const	$push418=, 1
	i64.add 	$9=, $9, $pop418
	i32.wrap/i64	$10=, $8
	i64.const	$push417=, -1
	i64.add 	$push3=, $8, $pop417
	copy_local	$8=, $pop3
	i32.const	$push416=, 1
	i32.ne  	$push165=, $10, $pop416
	br_if   	0, $pop165      # 0: up to label101
# BB#116:                               # %my_clzll.exit1659
	end_loop                        # label102:
	i32.wrap/i64	$push166=, $9
	i32.const	$push167=, 62
	i32.ne  	$push168=, $pop166, $pop167
	br_if   	0, $pop168      # 0: down to label40
# BB#117:                               # %for.body.i1612
	i64.const	$push169=, 2
	i32.call	$push170=, __builtin_clrsbll@FUNCTION, $pop169
	i32.const	$push171=, 61
	i32.ne  	$push172=, $pop170, $pop171
	br_if   	0, $pop172      # 0: down to label40
# BB#118:                               # %my_clrsbll.exit1525
	i64.const	$push173=, 4611686018427387904
	i32.call	$push174=, __builtin_clrsbll@FUNCTION, $pop173
	br_if   	0, $pop174      # 0: down to label40
# BB#119:                               # %for.body.i1425
	i64.const	$push175=, 4294967296
	i32.call	$push176=, __builtin_clrsbll@FUNCTION, $pop175
	i32.const	$push177=, 30
	i32.ne  	$push178=, $pop176, $pop177
	br_if   	0, $pop178      # 0: down to label40
# BB#120:                               # %for.body.i1332
	i64.const	$push179=, 2147483648
	i32.call	$push180=, __builtin_clrsbll@FUNCTION, $pop179
	i32.const	$push181=, 31
	i32.ne  	$push182=, $pop180, $pop181
	br_if   	0, $pop182      # 0: down to label40
# BB#121:                               # %my_clrsbll.exit1245
	i64.const	$push183=, -6510615555426900571
	i32.call	$push184=, __builtin_clrsbll@FUNCTION, $pop183
	br_if   	0, $pop184      # 0: down to label40
# BB#122:                               # %my_clrsbll.exit1152
	i64.const	$push185=, 6510615555426900570
	i32.call	$push186=, __builtin_clrsbll@FUNCTION, $pop185
	br_if   	0, $pop186      # 0: down to label40
# BB#123:                               # %for.body.i1053
	i64.const	$push187=, -3819392241693097984
	i32.call	$push188=, __builtin_clrsbll@FUNCTION, $pop187
	i32.const	$push189=, 1
	i32.ne  	$push190=, $pop188, $pop189
	br_if   	0, $pop190      # 0: down to label40
# BB#124:                               # %for.body.i964
	i64.const	$push191=, 223195676147712
	i32.call	$push192=, __builtin_clrsbll@FUNCTION, $pop191
	i32.const	$push193=, 15
	i32.ne  	$push194=, $pop192, $pop193
	br_if   	0, $pop194      # 0: down to label40
# BB#125:                               # %for.body.i913.preheader
	i64.const	$8=, 63
	i64.const	$9=, -1
.LBB18_126:                             # %for.body.i913
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label103:
	i64.const	$push423=, 1
	i64.add 	$9=, $9, $pop423
	i64.const	$push422=, 4294967295
	i64.and 	$7=, $8, $pop422
	i64.const	$push421=, -1
	i64.add 	$push4=, $8, $pop421
	copy_local	$8=, $pop4
	i64.const	$push420=, 1
	i64.shl 	$push195=, $pop420, $7
	i64.const	$push419=, 3405695742
	i64.and 	$push196=, $pop195, $pop419
	i64.eqz 	$push197=, $pop196
	br_if   	0, $pop197      # 0: up to label103
# BB#127:                               # %my_clzll.exit
	end_loop                        # label104:
	i32.wrap/i64	$push198=, $9
	i32.const	$push199=, 32
	i32.ne  	$push200=, $pop198, $pop199
	br_if   	0, $pop200      # 0: down to label40
# BB#128:                               # %for.body.i877
	i64.const	$push201=, 3405695742
	i32.call	$push202=, __builtin_clrsbll@FUNCTION, $pop201
	i32.const	$push203=, 31
	i32.ne  	$push204=, $pop202, $pop203
	br_if   	0, $pop204      # 0: down to label40
# BB#129:                               # %if.end740
	i64.const	$push424=, -1
	i32.call	$3=, __builtin_clrsbll@FUNCTION, $pop424
	i64.const	$8=, 62
	i64.const	$9=, 1
	i32.const	$10=, 1
.LBB18_130:                             # %for.body.i812
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label105:
	i64.const	$push426=, -1
	i64.shr_u	$push205=, $pop426, $8
	i64.const	$push425=, 1
	i64.and 	$push206=, $pop205, $pop425
	i64.eqz 	$push207=, $pop206
	br_if   	1, $pop207      # 1: down to label106
# BB#131:                               # %for.inc.i816
                                        #   in Loop: Header=BB18_130 Depth=1
	i64.const	$push432=, -1
	i64.add 	$8=, $8, $pop432
	i32.const	$push431=, 1
	i32.add 	$10=, $10, $pop431
	i64.const	$push430=, 1
	i64.add 	$push429=, $9, $pop430
	tee_local	$push428=, $9=, $pop429
	i64.const	$push427=, 64
	i64.lt_u	$push208=, $pop428, $pop427
	br_if   	0, $pop208      # 0: up to label105
.LBB18_132:                             # %my_clrsbll.exit
	end_loop                        # label106:
	i32.const	$push209=, -1
	i32.add 	$push210=, $10, $pop209
	i32.ne  	$push211=, $3, $pop210
	br_if   	0, $pop211      # 0: down to label40
# BB#133:                               # %if.end753
	i32.const	$push212=, 0
	call    	exit@FUNCTION, $pop212
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
