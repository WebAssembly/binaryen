	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-bitops-1.c"
	.section	.text.my_ffs,"ax",@progbits
	.hidden	my_ffs
	.globl	my_ffs
	.type	my_ffs,@function
my_ffs:                                 # @my_ffs
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	block
	i32.eqz 	$push11=, $0
	br_if   	0, $pop11       # 0: down to label0
# BB#1:                                 # %for.cond.preheader
	i32.const	$2=, 1
.LBB0_2:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	copy_local	$push8=, $2
	tee_local	$push7=, $3=, $pop8
	i32.const	$push6=, -1
	i32.add 	$push5=, $pop7, $pop6
	tee_local	$push4=, $1=, $pop5
	i32.const	$push3=, 31
	i32.gt_u	$push0=, $pop4, $pop3
	br_if   	1, $pop0        # 1: down to label2
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push10=, 1
	i32.add 	$2=, $3, $pop10
	i32.const	$push9=, 1
	i32.shl 	$push1=, $pop9, $1
	i32.and 	$push2=, $pop1, $0
	i32.eqz 	$push12=, $pop2
	br_if   	0, $pop12       # 0: up to label1
.LBB0_4:                                # %cleanup
	end_loop                        # label2:
	end_block                       # label0:
	copy_local	$push13=, $3
                                        # fallthrough-return: $pop13
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	block
	i32.eqz 	$push11=, $0
	br_if   	0, $pop11       # 0: down to label13
# BB#1:                                 # %for.cond.preheader
	i32.const	$2=, 1
.LBB6_2:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label14:
	copy_local	$push8=, $2
	tee_local	$push7=, $3=, $pop8
	i32.const	$push6=, -1
	i32.add 	$push5=, $pop7, $pop6
	tee_local	$push4=, $1=, $pop5
	i32.const	$push3=, 31
	i32.gt_u	$push0=, $pop4, $pop3
	br_if   	1, $pop0        # 1: down to label15
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB6_2 Depth=1
	i32.const	$push10=, 1
	i32.add 	$2=, $3, $pop10
	i32.const	$push9=, 1
	i32.shl 	$push1=, $pop9, $1
	i32.and 	$push2=, $pop1, $0
	i32.eqz 	$push12=, $pop2
	br_if   	0, $pop12       # 0: up to label14
.LBB6_4:                                # %cleanup
	end_loop                        # label15:
	end_block                       # label13:
	copy_local	$push13=, $3
                                        # fallthrough-return: $pop13
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
	.local  	i64, i32, i64, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	block
	i64.eqz 	$push1=, $0
	br_if   	0, $pop1        # 0: down to label26
# BB#1:                                 # %for.cond.preheader
	i64.const	$3=, 0
	i32.const	$2=, 1
.LBB12_2:                               # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label27:
	copy_local	$4=, $2
	i64.const	$push5=, 63
	i64.gt_u	$push2=, $3, $pop5
	br_if   	1, $pop2        # 1: down to label28
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB12_2 Depth=1
	i32.const	$push8=, 1
	i32.add 	$2=, $4, $pop8
	i64.const	$push7=, 1
	i64.shl 	$1=, $pop7, $3
	i64.const	$push6=, 1
	i64.add 	$push0=, $3, $pop6
	copy_local	$3=, $pop0
	i64.and 	$push3=, $1, $0
	i64.eqz 	$push4=, $pop3
	br_if   	0, $pop4        # 0: up to label27
.LBB12_4:                               # %cleanup
	end_loop                        # label28:
	end_block                       # label26:
	copy_local	$push9=, $4
                                        # fallthrough-return: $pop9
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
	.local  	i32, i32, i32, i64, i32, i32, i32, i64, i64, i64, i32
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
	i32.const	$push213=, 2
	i32.shl 	$push212=, $0, $pop213
	tee_local	$push211=, $4=, $pop212
	i32.load	$push210=, ints($pop211)
	tee_local	$push209=, $10=, $pop210
	i32.ctz 	$push208=, $pop209
	tee_local	$push207=, $1=, $pop208
	i32.const	$push206=, 1
	i32.add 	$push6=, $pop207, $pop206
	i32.const	$push205=, 0
	i32.select	$6=, $pop6, $pop205, $10
	i32.const	$2=, 0
	block
	i32.eqz 	$push416=, $10
	br_if   	0, $pop416      # 0: down to label43
# BB#2:                                 # %for.cond.i.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$5=, 0
.LBB18_3:                               # %for.cond.i
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label44:
	copy_local	$push216=, $5
	tee_local	$push215=, $2=, $pop216
	i32.const	$push214=, 31
	i32.gt_u	$push7=, $pop215, $pop214
	br_if   	1, $pop7        # 1: down to label45
# BB#4:                                 # %for.body.i
                                        #   in Loop: Header=BB18_3 Depth=2
	i32.const	$push218=, 1
	i32.add 	$5=, $2, $pop218
	i32.const	$push217=, 1
	i32.shl 	$push8=, $pop217, $2
	i32.and 	$push9=, $pop8, $10
	i32.eqz 	$push417=, $pop9
	br_if   	0, $pop417      # 0: up to label44
.LBB18_5:                               # %my_ffs.exit.loopexit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label45:
	i32.const	$push219=, 1
	i32.add 	$2=, $2, $pop219
.LBB18_6:                               # %my_ffs.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label43:
	i32.ne  	$push10=, $6, $2
	br_if   	2, $pop10       # 2: down to label40
# BB#7:                                 # %if.end
                                        #   in Loop: Header=BB18_1 Depth=1
	block
	i32.eqz 	$push418=, $10
	br_if   	0, $pop418      # 0: down to label46
# BB#8:                                 # %land.lhs.true
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.clz 	$6=, $10
	i32.const	$5=, 0
	i32.const	$2=, 31
.LBB18_9:                               # %for.body.i816
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label47:
	i32.const	$push220=, 1
	i32.shl 	$push11=, $pop220, $2
	i32.and 	$push12=, $pop11, $10
	br_if   	1, $pop12       # 1: down to label48
# BB#10:                                # %for.inc.i819
                                        #   in Loop: Header=BB18_9 Depth=2
	i32.const	$push225=, -1
	i32.add 	$2=, $2, $pop225
	i32.const	$push224=, 1
	i32.add 	$push223=, $5, $pop224
	tee_local	$push222=, $5=, $pop223
	i32.const	$push221=, 32
	i32.lt_u	$push13=, $pop222, $pop221
	br_if   	0, $pop13       # 0: up to label47
.LBB18_11:                              # %my_clz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label48:
	i32.ne  	$push14=, $6, $5
	br_if   	3, $pop14       # 3: down to label40
# BB#12:                                # %land.lhs.true13
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$2=, 0
.LBB18_13:                              # %for.body.i876
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label49:
	i32.const	$push226=, 1
	i32.shl 	$push15=, $pop226, $2
	i32.and 	$push16=, $pop15, $10
	br_if   	1, $pop16       # 1: down to label50
# BB#14:                                # %for.inc.i879
                                        #   in Loop: Header=BB18_13 Depth=2
	i32.const	$push230=, 1
	i32.add 	$push229=, $2, $pop230
	tee_local	$push228=, $2=, $pop229
	i32.const	$push227=, 32
	i32.lt_u	$push17=, $pop228, $pop227
	br_if   	0, $pop17       # 0: up to label49
.LBB18_15:                              # %my_ctz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label50:
	i32.ne  	$push18=, $1, $2
	br_if   	3, $pop18       # 3: down to label40
.LBB18_16:                              # %if.end19
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label46:
	i32.call	$1=, __builtin_clrsb@FUNCTION, $10
	i32.const	$push234=, ints
	i32.add 	$push0=, $4, $pop234
	i32.load	$push233=, 0($pop0)
	tee_local	$push232=, $2=, $pop233
	i32.const	$push231=, 31
	i32.shr_u	$6=, $pop232, $pop231
	i32.const	$5=, 1
	i32.const	$10=, 30
.LBB18_17:                              # %for.body.i950
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label51:
	i32.shr_u	$push19=, $2, $10
	i32.const	$push235=, 1
	i32.and 	$push20=, $pop19, $pop235
	i32.ne  	$push21=, $pop20, $6
	br_if   	1, $pop21       # 1: down to label52
# BB#18:                                # %for.inc.i953
                                        #   in Loop: Header=BB18_17 Depth=2
	i32.const	$push240=, -1
	i32.add 	$10=, $10, $pop240
	i32.const	$push239=, 1
	i32.add 	$push238=, $5, $pop239
	tee_local	$push237=, $5=, $pop238
	i32.const	$push236=, 32
	i32.lt_u	$push22=, $pop237, $pop236
	br_if   	0, $pop22       # 0: up to label51
.LBB18_19:                              # %my_clrsb.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label52:
	i32.const	$push241=, -1
	i32.add 	$push23=, $5, $pop241
	i32.ne  	$push24=, $1, $pop23
	br_if   	2, $pop24       # 2: down to label40
# BB#20:                                # %for.body.i1034.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$5=, 0
	i32.const	$10=, 0
.LBB18_21:                              # %for.body.i1034
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label53:
	i32.const	$push247=, 1
	i32.shl 	$push25=, $pop247, $10
	i32.and 	$push26=, $pop25, $2
	i32.const	$push246=, 0
	i32.ne  	$push27=, $pop26, $pop246
	i32.add 	$5=, $pop27, $5
	i32.const	$push245=, 1
	i32.add 	$push244=, $10, $pop245
	tee_local	$push243=, $10=, $pop244
	i32.const	$push242=, 32
	i32.ne  	$push28=, $pop243, $pop242
	br_if   	0, $pop28       # 0: up to label53
# BB#22:                                # %my_popcount.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label54:
	i32.popcnt	$push29=, $2
	i32.ne  	$push30=, $pop29, $5
	br_if   	2, $pop30       # 2: down to label40
# BB#23:                                # %for.body.i1115.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$6=, 0
	i32.const	$10=, 0
.LBB18_24:                              # %for.body.i1115
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label55:
	i32.const	$push253=, 1
	i32.shl 	$push31=, $pop253, $10
	i32.and 	$push32=, $pop31, $2
	i32.const	$push252=, 0
	i32.ne  	$push33=, $pop32, $pop252
	i32.add 	$6=, $pop33, $6
	i32.const	$push251=, 1
	i32.add 	$push250=, $10, $pop251
	tee_local	$push249=, $10=, $pop250
	i32.const	$push248=, 32
	i32.ne  	$push34=, $pop249, $pop248
	br_if   	0, $pop34       # 0: up to label55
# BB#25:                                # %my_parity.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label56:
	i32.xor 	$push35=, $6, $5
	i32.const	$push254=, 1
	i32.and 	$push36=, $pop35, $pop254
	br_if   	2, $pop36       # 2: down to label40
# BB#26:                                # %for.cond
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$push258=, 1
	i32.add 	$push257=, $0, $pop258
	tee_local	$push256=, $0=, $pop257
	i32.const	$push255=, 13
	i32.lt_u	$push37=, $pop256, $pop255
	br_if   	0, $pop37       # 0: up to label41
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
	i32.const	$push267=, 2
	i32.shl 	$push266=, $0, $pop267
	tee_local	$push265=, $4=, $pop266
	i32.load	$push264=, longs($pop265)
	tee_local	$push263=, $10=, $pop264
	i32.ctz 	$push262=, $pop263
	tee_local	$push261=, $1=, $pop262
	i32.const	$push260=, 1
	i32.add 	$push38=, $pop261, $pop260
	i32.const	$push259=, 0
	i32.select	$6=, $pop38, $pop259, $10
	i32.const	$2=, 0
	block
	i32.eqz 	$push419=, $10
	br_if   	0, $pop419      # 0: down to label59
# BB#29:                                # %for.cond.i1193.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$5=, 0
.LBB18_30:                              # %for.cond.i1193
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label60:
	copy_local	$push270=, $5
	tee_local	$push269=, $2=, $pop270
	i32.const	$push268=, 31
	i32.gt_u	$push39=, $pop269, $pop268
	br_if   	1, $pop39       # 1: down to label61
# BB#31:                                # %for.body.i1197
                                        #   in Loop: Header=BB18_30 Depth=2
	i32.const	$push272=, 1
	i32.add 	$5=, $2, $pop272
	i32.const	$push271=, 1
	i32.shl 	$push40=, $pop271, $2
	i32.and 	$push41=, $pop40, $10
	i32.eqz 	$push420=, $pop41
	br_if   	0, $pop420      # 0: up to label60
.LBB18_32:                              # %my_ffsl.exit.loopexit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label61:
	i32.const	$push273=, 1
	i32.add 	$2=, $2, $pop273
.LBB18_33:                              # %my_ffsl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_block                       # label59:
	i32.ne  	$push42=, $6, $2
	br_if   	2, $pop42       # 2: down to label40
# BB#34:                                # %if.end49
                                        #   in Loop: Header=BB18_28 Depth=1
	block
	i32.eqz 	$push421=, $10
	br_if   	0, $pop421      # 0: down to label62
# BB#35:                                # %land.lhs.true52
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.clz 	$6=, $10
	i32.const	$5=, 0
	i32.const	$2=, 31
.LBB18_36:                              # %for.body.i1276
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label63:
	i32.const	$push274=, 1
	i32.shl 	$push43=, $pop274, $2
	i32.and 	$push44=, $pop43, $10
	br_if   	1, $pop44       # 1: down to label64
# BB#37:                                # %for.inc.i1279
                                        #   in Loop: Header=BB18_36 Depth=2
	i32.const	$push279=, -1
	i32.add 	$2=, $2, $pop279
	i32.const	$push278=, 1
	i32.add 	$push277=, $5, $pop278
	tee_local	$push276=, $5=, $pop277
	i32.const	$push275=, 32
	i32.lt_u	$push45=, $pop276, $pop275
	br_if   	0, $pop45       # 0: up to label63
.LBB18_38:                              # %my_clzl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label64:
	i32.ne  	$push46=, $6, $5
	br_if   	3, $pop46       # 3: down to label40
# BB#39:                                # %land.lhs.true61
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$2=, 0
.LBB18_40:                              # %for.body.i1357
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label65:
	i32.const	$push280=, 1
	i32.shl 	$push47=, $pop280, $2
	i32.and 	$push48=, $pop47, $10
	br_if   	1, $pop48       # 1: down to label66
# BB#41:                                # %for.inc.i1360
                                        #   in Loop: Header=BB18_40 Depth=2
	i32.const	$push284=, 1
	i32.add 	$push283=, $2, $pop284
	tee_local	$push282=, $2=, $pop283
	i32.const	$push281=, 32
	i32.lt_u	$push49=, $pop282, $pop281
	br_if   	0, $pop49       # 0: up to label65
.LBB18_42:                              # %my_ctzl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label66:
	i32.ne  	$push50=, $1, $2
	br_if   	3, $pop50       # 3: down to label40
.LBB18_43:                              # %if.end67
                                        #   in Loop: Header=BB18_28 Depth=1
	end_block                       # label62:
	i32.call	$1=, __builtin_clrsbl@FUNCTION, $10
	i32.const	$push288=, longs
	i32.add 	$push1=, $4, $pop288
	i32.load	$push287=, 0($pop1)
	tee_local	$push286=, $2=, $pop287
	i32.const	$push285=, 31
	i32.shr_u	$6=, $pop286, $pop285
	i32.const	$5=, 1
	i32.const	$10=, 30
.LBB18_44:                              # %for.body.i1440
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label67:
	i32.shr_u	$push51=, $2, $10
	i32.const	$push289=, 1
	i32.and 	$push52=, $pop51, $pop289
	i32.ne  	$push53=, $pop52, $6
	br_if   	1, $pop53       # 1: down to label68
# BB#45:                                # %for.inc.i1443
                                        #   in Loop: Header=BB18_44 Depth=2
	i32.const	$push294=, -1
	i32.add 	$10=, $10, $pop294
	i32.const	$push293=, 1
	i32.add 	$push292=, $5, $pop293
	tee_local	$push291=, $5=, $pop292
	i32.const	$push290=, 32
	i32.lt_u	$push54=, $pop291, $pop290
	br_if   	0, $pop54       # 0: up to label67
.LBB18_46:                              # %my_clrsbl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label68:
	i32.const	$push295=, -1
	i32.add 	$push55=, $5, $pop295
	i32.ne  	$push56=, $1, $pop55
	br_if   	2, $pop56       # 2: down to label40
# BB#47:                                # %for.body.i1527.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$5=, 0
	i32.const	$10=, 0
.LBB18_48:                              # %for.body.i1527
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label69:
	i32.const	$push301=, 1
	i32.shl 	$push57=, $pop301, $10
	i32.and 	$push58=, $pop57, $2
	i32.const	$push300=, 0
	i32.ne  	$push59=, $pop58, $pop300
	i32.add 	$5=, $pop59, $5
	i32.const	$push299=, 1
	i32.add 	$push298=, $10, $pop299
	tee_local	$push297=, $10=, $pop298
	i32.const	$push296=, 32
	i32.ne  	$push60=, $pop297, $pop296
	br_if   	0, $pop60       # 0: up to label69
# BB#49:                                # %my_popcountl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label70:
	i32.popcnt	$push61=, $2
	i32.ne  	$push62=, $pop61, $5
	br_if   	2, $pop62       # 2: down to label40
# BB#50:                                # %for.body.i1609.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$6=, 0
	i32.const	$10=, 0
.LBB18_51:                              # %for.body.i1609
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label71:
	i32.const	$push307=, 1
	i32.shl 	$push63=, $pop307, $10
	i32.and 	$push64=, $pop63, $2
	i32.const	$push306=, 0
	i32.ne  	$push65=, $pop64, $pop306
	i32.add 	$6=, $pop65, $6
	i32.const	$push305=, 1
	i32.add 	$push304=, $10, $pop305
	tee_local	$push303=, $10=, $pop304
	i32.const	$push302=, 32
	i32.ne  	$push66=, $pop303, $pop302
	br_if   	0, $pop66       # 0: up to label71
# BB#52:                                # %my_parityl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label72:
	i32.xor 	$push67=, $6, $5
	i32.const	$push308=, 1
	i32.and 	$push68=, $pop67, $pop308
	br_if   	2, $pop68       # 2: down to label40
# BB#53:                                # %for.cond39
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$push312=, 1
	i32.add 	$push311=, $0, $pop312
	tee_local	$push310=, $0=, $pop311
	i32.const	$push309=, 13
	i32.lt_u	$push69=, $pop310, $pop309
	br_if   	0, $pop69       # 0: up to label57
# BB#54:                                # %for.body92.preheader
	end_loop                        # label58:
	i32.const	$5=, 0
.LBB18_55:                              # %for.body92
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_57 Depth 2
                                        #     Child Loop BB18_62 Depth 2
                                        #     Child Loop BB18_66 Depth 2
                                        #     Child Loop BB18_70 Depth 2
                                        #     Child Loop BB18_74 Depth 2
                                        #     Child Loop BB18_77 Depth 2
	loop                            # label73:
	i32.const	$push323=, 0
	i32.const	$push322=, 3
	i32.shl 	$push321=, $5, $pop322
	tee_local	$push320=, $4=, $pop321
	i64.load	$push319=, longlongs($pop320)
	tee_local	$push318=, $9=, $pop319
	i64.ctz 	$push317=, $pop318
	tee_local	$push316=, $3=, $pop317
	i64.const	$push315=, 1
	i64.add 	$push70=, $pop316, $pop315
	i32.wrap/i64	$push71=, $pop70
	i64.eqz 	$push314=, $9
	tee_local	$push313=, $6=, $pop314
	i32.select	$0=, $pop323, $pop71, $pop313
	i32.const	$10=, 0
	block
	br_if   	0, $6           # 0: down to label75
# BB#56:                                # %for.cond.i1687.preheader
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.const	$8=, 0
	i32.const	$2=, 1
.LBB18_57:                              # %for.cond.i1687
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label76:
	copy_local	$10=, $2
	i64.const	$push324=, 63
	i64.gt_u	$push72=, $8, $pop324
	br_if   	1, $pop72       # 1: down to label77
# BB#58:                                # %for.body.i1691
                                        #   in Loop: Header=BB18_57 Depth=2
	i32.const	$push327=, 1
	i32.add 	$2=, $10, $pop327
	i64.const	$push326=, 1
	i64.shl 	$7=, $pop326, $8
	i64.const	$push325=, 1
	i64.add 	$push3=, $8, $pop325
	copy_local	$8=, $pop3
	i64.and 	$push73=, $7, $9
	i64.eqz 	$push74=, $pop73
	br_if   	0, $pop74       # 0: up to label76
.LBB18_59:                              # %my_ffsll.exit1693
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label77:
	end_block                       # label75:
	i32.ne  	$push75=, $0, $10
	br_if   	2, $pop75       # 2: down to label40
# BB#60:                                # %if.end100
                                        #   in Loop: Header=BB18_55 Depth=1
	block
	br_if   	0, $6           # 0: down to label78
# BB#61:                                # %land.lhs.true103
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.clz 	$push76=, $9
	i32.wrap/i64	$2=, $pop76
	i32.const	$10=, 0
	i64.const	$7=, 0
	i64.const	$8=, 63
.LBB18_62:                              # %for.body.i1763
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label79:
	i64.const	$push330=, 1
	i64.const	$push329=, 4294967295
	i64.and 	$push77=, $8, $pop329
	i64.shl 	$push78=, $pop330, $pop77
	i64.and 	$push79=, $pop78, $9
	i64.const	$push328=, 0
	i64.ne  	$push80=, $pop79, $pop328
	br_if   	1, $pop80       # 1: down to label80
# BB#63:                                # %for.inc.i1767
                                        #   in Loop: Header=BB18_62 Depth=2
	i64.const	$push336=, -1
	i64.add 	$8=, $8, $pop336
	i32.const	$push335=, 1
	i32.add 	$10=, $10, $pop335
	i64.const	$push334=, 1
	i64.add 	$push333=, $7, $pop334
	tee_local	$push332=, $7=, $pop333
	i64.const	$push331=, 64
	i64.lt_u	$push81=, $pop332, $pop331
	br_if   	0, $pop81       # 0: up to label79
.LBB18_64:                              # %my_clzll.exit1769
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label80:
	i32.ne  	$push82=, $2, $10
	br_if   	3, $pop82       # 3: down to label40
# BB#65:                                # %land.lhs.true113
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.wrap/i64	$2=, $3
	i32.const	$10=, 0
	i64.const	$8=, 0
.LBB18_66:                              # %for.body.i1805
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label81:
	i64.const	$push338=, 1
	i64.shl 	$push83=, $pop338, $8
	i64.and 	$push84=, $pop83, $9
	i64.const	$push337=, 0
	i64.ne  	$push85=, $pop84, $pop337
	br_if   	1, $pop85       # 1: down to label82
# BB#67:                                # %for.inc.i1809
                                        #   in Loop: Header=BB18_66 Depth=2
	i32.const	$push343=, 1
	i32.add 	$10=, $10, $pop343
	i64.const	$push342=, 1
	i64.add 	$push341=, $8, $pop342
	tee_local	$push340=, $8=, $pop341
	i64.const	$push339=, 64
	i64.lt_u	$push86=, $pop340, $pop339
	br_if   	0, $pop86       # 0: up to label81
.LBB18_68:                              # %my_ctzll.exit1811
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label82:
	i32.ne  	$push87=, $2, $10
	br_if   	3, $pop87       # 3: down to label40
.LBB18_69:                              # %if.end120
                                        #   in Loop: Header=BB18_55 Depth=1
	end_block                       # label78:
	i32.call	$2=, __builtin_clrsbll@FUNCTION, $9
	i32.const	$push347=, longlongs
	i32.add 	$push2=, $4, $pop347
	i64.load	$push346=, 0($pop2)
	tee_local	$push345=, $9=, $pop346
	i64.const	$push344=, 63
	i64.shr_u	$3=, $pop345, $pop344
	i32.const	$10=, 1
	i64.const	$7=, 1
	i64.const	$8=, 62
.LBB18_70:                              # %for.body.i1869
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label83:
	i64.shr_u	$push88=, $9, $8
	i64.const	$push348=, 1
	i64.and 	$push89=, $pop88, $pop348
	i64.ne  	$push90=, $pop89, $3
	br_if   	1, $pop90       # 1: down to label84
# BB#71:                                # %for.inc.i1873
                                        #   in Loop: Header=BB18_70 Depth=2
	i64.const	$push354=, -1
	i64.add 	$8=, $8, $pop354
	i32.const	$push353=, 1
	i32.add 	$10=, $10, $pop353
	i64.const	$push352=, 1
	i64.add 	$push351=, $7, $pop352
	tee_local	$push350=, $7=, $pop351
	i64.const	$push349=, 64
	i64.lt_u	$push91=, $pop350, $pop349
	br_if   	0, $pop91       # 0: up to label83
.LBB18_72:                              # %my_clrsbll.exit1876
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label84:
	i32.const	$push355=, -1
	i32.add 	$push92=, $10, $pop355
	i32.ne  	$push93=, $2, $pop92
	br_if   	2, $pop93       # 2: down to label40
# BB#73:                                # %if.end127
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.popcnt	$7=, $9
	i32.const	$10=, 0
	i64.const	$8=, 0
.LBB18_74:                              # %for.body.i1952
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label85:
	i64.const	$push361=, 1
	i64.shl 	$push94=, $pop361, $8
	i64.and 	$push95=, $pop94, $9
	i64.const	$push360=, 0
	i64.ne  	$push96=, $pop95, $pop360
	i32.add 	$10=, $pop96, $10
	i64.const	$push359=, 1
	i64.add 	$push358=, $8, $pop359
	tee_local	$push357=, $8=, $pop358
	i64.const	$push356=, 64
	i64.ne  	$push97=, $pop357, $pop356
	br_if   	0, $pop97       # 0: up to label85
# BB#75:                                # %my_popcountll.exit1953
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label86:
	i32.wrap/i64	$push98=, $7
	i32.ne  	$push99=, $pop98, $10
	br_if   	2, $pop99       # 2: down to label40
# BB#76:                                # %for.body.i2029.preheader
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.const	$2=, 0
	i64.const	$8=, 0
.LBB18_77:                              # %for.body.i2029
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label87:
	i64.const	$push367=, 1
	i64.shl 	$push100=, $pop367, $8
	i64.and 	$push101=, $pop100, $9
	i64.const	$push366=, 0
	i64.ne  	$push102=, $pop101, $pop366
	i32.add 	$2=, $pop102, $2
	i64.const	$push365=, 1
	i64.add 	$push364=, $8, $pop365
	tee_local	$push363=, $8=, $pop364
	i64.const	$push362=, 64
	i64.ne  	$push103=, $pop363, $pop362
	br_if   	0, $pop103      # 0: up to label87
# BB#78:                                # %my_parityll.exit2031
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label88:
	i32.xor 	$push104=, $2, $10
	i32.const	$push368=, 1
	i32.and 	$push105=, $pop104, $pop368
	br_if   	3, $pop105      # 3: down to label39
# BB#79:                                # %for.cond90
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.const	$push372=, 1
	i32.add 	$push371=, $5, $pop372
	tee_local	$push370=, $5=, $pop371
	i32.const	$push369=, 12
	i32.le_u	$push106=, $pop370, $pop369
	br_if   	0, $pop106      # 0: up to label73
# BB#80:                                # %if.end148
	end_loop                        # label74:
	i32.const	$push107=, 0
	i32.call	$push108=, __builtin_clrsb@FUNCTION, $pop107
	i32.const	$push109=, 31
	i32.ne  	$push110=, $pop108, $pop109
	br_if   	0, $pop110      # 0: down to label40
# BB#81:                                # %my_clrsb.exit2539
	i32.const	$push111=, 1
	i32.call	$push112=, __builtin_clrsb@FUNCTION, $pop111
	i32.const	$push113=, 30
	i32.ne  	$push114=, $pop112, $pop113
	br_if   	0, $pop114      # 0: down to label40
# BB#82:                                # %if.end198
	i32.const	$push115=, -2147483648
	i32.call	$push116=, __builtin_clrsb@FUNCTION, $pop115
	br_if   	0, $pop116      # 0: down to label40
# BB#83:                                # %my_clrsb.exit2386
	i32.const	$push117=, 1073741824
	i32.call	$push118=, __builtin_clrsb@FUNCTION, $pop117
	br_if   	0, $pop118      # 0: down to label40
# BB#84:                                # %my_clrsb.exit2312
	i32.const	$push119=, 65536
	i32.call	$push120=, __builtin_clrsb@FUNCTION, $pop119
	i32.const	$push121=, 14
	i32.ne  	$push122=, $pop120, $pop121
	br_if   	0, $pop122      # 0: down to label40
# BB#85:                                # %my_clrsb.exit2239
	i32.const	$push123=, 32768
	i32.call	$push124=, __builtin_clrsb@FUNCTION, $pop123
	i32.const	$push125=, 15
	i32.ne  	$push126=, $pop124, $pop125
	br_if   	0, $pop126      # 0: down to label40
# BB#86:                                # %my_clrsb.exit2164
	i32.const	$push127=, -1515870811
	i32.call	$push128=, __builtin_clrsb@FUNCTION, $pop127
	br_if   	0, $pop128      # 0: down to label40
# BB#87:                                # %my_clrsb.exit2097
	i32.const	$push129=, 1515870810
	i32.call	$push130=, __builtin_clrsb@FUNCTION, $pop129
	br_if   	0, $pop130      # 0: down to label40
# BB#88:                                # %for.body.i2013
	i32.const	$push131=, -889323520
	i32.call	$push132=, __builtin_clrsb@FUNCTION, $pop131
	i32.const	$push133=, 1
	i32.ne  	$push134=, $pop132, $pop133
	br_if   	0, $pop134      # 0: down to label40
# BB#89:                                # %for.body.i1936
	i32.const	$push135=, 13303296
	i32.call	$push136=, __builtin_clrsb@FUNCTION, $pop135
	i32.const	$push137=, 7
	i32.ne  	$push138=, $pop136, $pop137
	br_if   	0, $pop138      # 0: down to label40
# BB#90:                                # %for.body.i1856
	i32.const	$push139=, 51966
	i32.call	$push140=, __builtin_clrsb@FUNCTION, $pop139
	i32.const	$push141=, 15
	i32.ne  	$push142=, $pop140, $pop141
	br_if   	0, $pop142      # 0: down to label40
# BB#91:                                # %if.end423
	i32.const	$push373=, -1
	i32.call	$5=, __builtin_clrsb@FUNCTION, $pop373
	i32.const	$10=, 30
	i32.const	$2=, 1
.LBB18_92:                              # %for.body.i1793
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label89:
	i32.const	$push375=, -1
	i32.shr_u	$push143=, $pop375, $10
	i32.const	$push374=, 1
	i32.and 	$push144=, $pop143, $pop374
	i32.eqz 	$push422=, $pop144
	br_if   	1, $pop422      # 1: down to label90
# BB#93:                                # %for.inc.i1796
                                        #   in Loop: Header=BB18_92 Depth=1
	i32.const	$push380=, -1
	i32.add 	$10=, $10, $pop380
	i32.const	$push379=, 1
	i32.add 	$push378=, $2, $pop379
	tee_local	$push377=, $2=, $pop378
	i32.const	$push376=, 32
	i32.lt_u	$push145=, $pop377, $pop376
	br_if   	0, $pop145      # 0: up to label89
.LBB18_94:                              # %my_clrsb.exit1799
	end_loop                        # label90:
	i32.const	$push146=, -1
	i32.add 	$push147=, $2, $pop146
	i32.ne  	$push148=, $5, $pop147
	br_if   	0, $pop148      # 0: down to label40
# BB#95:                                # %if.end440
	i64.const	$9=, 0
	i64.const	$push381=, 0
	i32.call	$push149=, __builtin_clrsbll@FUNCTION, $pop381
	i32.const	$push150=, 63
	i32.ne  	$push151=, $pop149, $pop150
	br_if   	0, $pop151      # 0: down to label40
# BB#96:                                # %for.body.i1713.preheader
	i32.const	$10=, 0
	i64.const	$8=, 63
.LBB18_97:                              # %for.body.i1713
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label91:
	i32.wrap/i64	$push152=, $8
	i32.eqz 	$push423=, $pop152
	br_if   	1, $pop423      # 1: down to label92
# BB#98:                                # %for.inc.i1717
                                        #   in Loop: Header=BB18_97 Depth=1
	i64.const	$push387=, -1
	i64.add 	$8=, $8, $pop387
	i32.const	$push386=, 1
	i32.add 	$10=, $10, $pop386
	i64.const	$push385=, 1
	i64.add 	$push384=, $9, $pop385
	tee_local	$push383=, $9=, $pop384
	i64.const	$push382=, 64
	i64.lt_u	$push153=, $pop383, $pop382
	br_if   	0, $pop153      # 0: up to label91
.LBB18_99:                              # %my_clzll.exit1719
	end_loop                        # label92:
	i32.const	$push154=, 63
	i32.ne  	$push155=, $10, $pop154
	br_if   	0, $pop155      # 0: down to label40
# BB#100:                               # %if.end465
	i64.const	$push388=, 1
	i32.call	$2=, __builtin_clrsbll@FUNCTION, $pop388
	i64.const	$8=, 1
.LBB18_101:                             # %for.body.i1675
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label93:
	i32.const	$10=, 62
	i64.const	$push389=, 63
	i64.eq  	$push156=, $8, $pop389
	br_if   	1, $pop156      # 1: down to label94
# BB#102:                               # %for.inc.i1679
                                        #   in Loop: Header=BB18_101 Depth=1
	i32.const	$10=, 63
	i64.const	$push393=, 1
	i64.add 	$push392=, $8, $pop393
	tee_local	$push391=, $8=, $pop392
	i64.const	$push390=, 64
	i64.lt_u	$push157=, $pop391, $pop390
	br_if   	0, $pop157      # 0: up to label93
.LBB18_103:                             # %my_clrsbll.exit1682
	end_loop                        # label94:
	i32.ne  	$push158=, $2, $10
	br_if   	0, $pop158      # 0: down to label40
# BB#104:                               # %for.body.i1616.preheader
	i64.const	$8=, 0
.LBB18_105:                             # %for.body.i1616
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label96:
	i64.const	$push394=, 63
	i64.eq  	$push159=, $8, $pop394
	br_if   	2, $pop159      # 2: down to label95
# BB#106:                               # %for.inc.i1620
                                        #   in Loop: Header=BB18_105 Depth=1
	i64.const	$push398=, 1
	i64.add 	$push397=, $8, $pop398
	tee_local	$push396=, $8=, $pop397
	i64.const	$push395=, 64
	i64.lt_u	$push160=, $pop396, $pop395
	br_if   	0, $pop160      # 0: up to label96
# BB#107:                               # %if.then489
	end_loop                        # label97:
	call    	abort@FUNCTION
	unreachable
.LBB18_108:                             # %if.end490
	end_block                       # label95:
	i64.const	$push161=, -9223372036854775808
	i32.call	$push162=, __builtin_clrsbll@FUNCTION, $pop161
	br_if   	0, $pop162      # 0: down to label40
# BB#109:                               # %for.body.i1547.preheader
	i32.const	$10=, 63
	i64.const	$8=, 63
.LBB18_110:                             # %for.body.i1547
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label98:
	i32.const	$push401=, -1
	i32.add 	$10=, $10, $pop401
	i32.wrap/i64	$2=, $8
	i64.const	$push400=, -1
	i64.add 	$push4=, $8, $pop400
	copy_local	$8=, $pop4
	i32.const	$push399=, 1
	i32.ne  	$push163=, $2, $pop399
	br_if   	0, $pop163      # 0: up to label98
# BB#111:                               # %my_clzll.exit1553
	end_loop                        # label99:
	br_if   	0, $10          # 0: down to label40
# BB#112:                               # %for.body.i1510
	i64.const	$push164=, 2
	i32.call	$push165=, __builtin_clrsbll@FUNCTION, $pop164
	i32.const	$push166=, 61
	i32.ne  	$push167=, $pop165, $pop166
	br_if   	0, $pop167      # 0: down to label40
# BB#113:                               # %my_clrsbll.exit1433
	i64.const	$push168=, 4611686018427387904
	i32.call	$push169=, __builtin_clrsbll@FUNCTION, $pop168
	br_if   	0, $pop169      # 0: down to label40
# BB#114:                               # %for.body.i1345
	i64.const	$push170=, 4294967296
	i32.call	$push171=, __builtin_clrsbll@FUNCTION, $pop170
	i32.const	$push172=, 30
	i32.ne  	$push173=, $pop171, $pop172
	br_if   	0, $pop173      # 0: down to label40
# BB#115:                               # %for.body.i1263
	i64.const	$push174=, 2147483648
	i32.call	$push175=, __builtin_clrsbll@FUNCTION, $pop174
	i32.const	$push176=, 31
	i32.ne  	$push177=, $pop175, $pop176
	br_if   	0, $pop177      # 0: down to label40
# BB#116:                               # %my_clrsbll.exit1188
	i64.const	$push178=, -6510615555426900571
	i32.call	$push179=, __builtin_clrsbll@FUNCTION, $pop178
	br_if   	0, $pop179      # 0: down to label40
# BB#117:                               # %my_clrsbll.exit1106
	i64.const	$push180=, 6510615555426900570
	i32.call	$push181=, __builtin_clrsbll@FUNCTION, $pop180
	br_if   	0, $pop181      # 0: down to label40
# BB#118:                               # %for.body.i1019
	i64.const	$push182=, -3819392241693097984
	i32.call	$push183=, __builtin_clrsbll@FUNCTION, $pop182
	i32.const	$push184=, 1
	i32.ne  	$push185=, $pop183, $pop184
	br_if   	0, $pop185      # 0: down to label40
# BB#119:                               # %for.body.i941
	i64.const	$push186=, 223195676147712
	i32.call	$push187=, __builtin_clrsbll@FUNCTION, $pop186
	i32.const	$push188=, 15
	i32.ne  	$push189=, $pop187, $pop188
	br_if   	0, $pop189      # 0: down to label40
# BB#120:                               # %for.body.i898.preheader
	i32.const	$10=, 33
	i64.const	$8=, 63
.LBB18_121:                             # %for.body.i898
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label100:
	i32.const	$push406=, -1
	i32.add 	$10=, $10, $pop406
	i64.const	$push405=, 4294967295
	i64.and 	$9=, $8, $pop405
	i64.const	$push404=, -1
	i64.add 	$push5=, $8, $pop404
	copy_local	$8=, $pop5
	i64.const	$push403=, 1
	i64.shl 	$push190=, $pop403, $9
	i64.const	$push402=, 3405695742
	i64.and 	$push191=, $pop190, $pop402
	i64.eqz 	$push192=, $pop191
	br_if   	0, $pop192      # 0: up to label100
# BB#122:                               # %my_clzll.exit
	end_loop                        # label101:
	br_if   	0, $10          # 0: down to label40
# BB#123:                               # %for.body.i865
	i64.const	$push193=, 3405695742
	i32.call	$push194=, __builtin_clrsbll@FUNCTION, $pop193
	i32.const	$push195=, 31
	i32.ne  	$push196=, $pop194, $pop195
	br_if   	0, $pop196      # 0: down to label40
# BB#124:                               # %if.end740
	i64.const	$push407=, -1
	i32.call	$2=, __builtin_clrsbll@FUNCTION, $pop407
	i64.const	$8=, 62
	i64.const	$9=, 1
	i32.const	$10=, 1
.LBB18_125:                             # %for.body.i810
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label102:
	i64.const	$push409=, -1
	i64.shr_u	$push197=, $pop409, $8
	i64.const	$push408=, 1
	i64.and 	$push198=, $pop197, $pop408
	i64.eqz 	$push199=, $pop198
	br_if   	1, $pop199      # 1: down to label103
# BB#126:                               # %for.inc.i
                                        #   in Loop: Header=BB18_125 Depth=1
	i64.const	$push415=, -1
	i64.add 	$8=, $8, $pop415
	i32.const	$push414=, 1
	i32.add 	$10=, $10, $pop414
	i64.const	$push413=, 1
	i64.add 	$push412=, $9, $pop413
	tee_local	$push411=, $9=, $pop412
	i64.const	$push410=, 64
	i64.lt_u	$push200=, $pop411, $pop410
	br_if   	0, $pop200      # 0: up to label102
.LBB18_127:                             # %my_clrsbll.exit
	end_loop                        # label103:
	i32.const	$push201=, -1
	i32.add 	$push202=, $10, $pop201
	i32.ne  	$push203=, $2, $pop202
	br_if   	0, $pop203      # 0: down to label40
# BB#128:                               # %if.end753
	i32.const	$push204=, 0
	call    	exit@FUNCTION, $pop204
	unreachable
.LBB18_129:                             # %if.then37
	end_block                       # label40:
	call    	abort@FUNCTION
	unreachable
.LBB18_130:                             # %if.then140
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	__builtin_clrsb, i32
	.functype	__builtin_clrsbl, i32
	.functype	__builtin_clrsbll, i32
	.functype	exit, void, i32
