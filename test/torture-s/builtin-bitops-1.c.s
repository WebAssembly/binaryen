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
	i64.const	$push5=, 1
	i64.shl 	$push0=, $pop5, $1
	i64.and 	$push1=, $pop0, $0
	i64.const	$push4=, 0
	i64.ne  	$push2=, $pop1, $pop4
	br_if   	1, $pop2        # 1: down to label32
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB14_1 Depth=1
	i64.const	$push11=, -1
	i64.add 	$1=, $1, $pop11
	i32.const	$push10=, 1
	i32.add 	$3=, $3, $pop10
	i64.const	$push9=, 1
	i64.add 	$push8=, $2, $pop9
	tee_local	$push7=, $2=, $pop8
	i64.const	$push6=, 64
	i64.lt_u	$push3=, $pop7, $pop6
	br_if   	0, $pop3        # 0: up to label31
.LBB14_3:                               # %for.end
	end_loop                        # label32:
	copy_local	$push12=, $3
                                        # fallthrough-return: $pop12
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
	i32.const	$push205=, 2
	i32.shl 	$push1=, $0, $pop205
	i32.const	$push204=, ints
	i32.add 	$push203=, $pop1, $pop204
	tee_local	$push202=, $1=, $pop203
	i32.load	$push201=, 0($pop202)
	tee_local	$push200=, $10=, $pop201
	i32.ctz 	$push199=, $pop200
	tee_local	$push198=, $2=, $pop199
	i32.const	$push197=, 1
	i32.add 	$push2=, $pop198, $pop197
	i32.const	$push196=, 0
	i32.select	$6=, $pop2, $pop196, $10
	i32.const	$3=, 0
	block
	i32.eqz 	$push397=, $10
	br_if   	0, $pop397      # 0: down to label43
# BB#2:                                 # %for.cond.i.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$5=, 0
.LBB18_3:                               # %for.cond.i
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label44:
	copy_local	$push208=, $5
	tee_local	$push207=, $3=, $pop208
	i32.const	$push206=, 31
	i32.gt_u	$push3=, $pop207, $pop206
	br_if   	1, $pop3        # 1: down to label45
# BB#4:                                 # %for.body.i
                                        #   in Loop: Header=BB18_3 Depth=2
	i32.const	$push210=, 1
	i32.add 	$5=, $3, $pop210
	i32.const	$push209=, 1
	i32.shl 	$push4=, $pop209, $3
	i32.and 	$push5=, $pop4, $10
	i32.eqz 	$push398=, $pop5
	br_if   	0, $pop398      # 0: up to label44
.LBB18_5:                               # %my_ffs.exit.loopexit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label45:
	i32.const	$push211=, 1
	i32.add 	$3=, $3, $pop211
.LBB18_6:                               # %my_ffs.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label43:
	i32.ne  	$push6=, $6, $3
	br_if   	2, $pop6        # 2: down to label40
# BB#7:                                 # %if.end
                                        #   in Loop: Header=BB18_1 Depth=1
	block
	i32.eqz 	$push399=, $10
	br_if   	0, $pop399      # 0: down to label46
# BB#8:                                 # %land.lhs.true
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.clz 	$6=, $10
	i32.const	$5=, 0
	i32.const	$3=, 31
.LBB18_9:                               # %for.body.i816
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label47:
	i32.const	$push212=, 1
	i32.shl 	$push7=, $pop212, $3
	i32.and 	$push8=, $pop7, $10
	br_if   	1, $pop8        # 1: down to label48
# BB#10:                                # %for.inc.i819
                                        #   in Loop: Header=BB18_9 Depth=2
	i32.const	$push217=, -1
	i32.add 	$3=, $3, $pop217
	i32.const	$push216=, 1
	i32.add 	$push215=, $5, $pop216
	tee_local	$push214=, $5=, $pop215
	i32.const	$push213=, 32
	i32.lt_u	$push9=, $pop214, $pop213
	br_if   	0, $pop9        # 0: up to label47
.LBB18_11:                              # %my_clz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label48:
	i32.ne  	$push10=, $6, $5
	br_if   	3, $pop10       # 3: down to label40
# BB#12:                                # %land.lhs.true13
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$3=, 0
.LBB18_13:                              # %for.body.i875
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label49:
	i32.const	$push218=, 1
	i32.shl 	$push11=, $pop218, $3
	i32.and 	$push12=, $pop11, $10
	br_if   	1, $pop12       # 1: down to label50
# BB#14:                                # %for.inc.i878
                                        #   in Loop: Header=BB18_13 Depth=2
	i32.const	$push222=, 1
	i32.add 	$push221=, $3, $pop222
	tee_local	$push220=, $3=, $pop221
	i32.const	$push219=, 32
	i32.lt_u	$push13=, $pop220, $pop219
	br_if   	0, $pop13       # 0: up to label49
.LBB18_15:                              # %my_ctz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label50:
	i32.ne  	$push14=, $2, $3
	br_if   	3, $pop14       # 3: down to label40
.LBB18_16:                              # %if.end19
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label46:
	i32.call	$2=, __builtin_clrsb@FUNCTION, $10
	i32.load	$push225=, 0($1)
	tee_local	$push224=, $3=, $pop225
	i32.const	$push223=, 31
	i32.shr_u	$6=, $pop224, $pop223
	i32.const	$5=, 1
	i32.const	$10=, 30
.LBB18_17:                              # %for.body.i948
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label51:
	i32.shr_u	$push15=, $3, $10
	i32.const	$push226=, 1
	i32.and 	$push16=, $pop15, $pop226
	i32.ne  	$push17=, $pop16, $6
	br_if   	1, $pop17       # 1: down to label52
# BB#18:                                # %for.inc.i951
                                        #   in Loop: Header=BB18_17 Depth=2
	i32.const	$push231=, -1
	i32.add 	$10=, $10, $pop231
	i32.const	$push230=, 1
	i32.add 	$push229=, $5, $pop230
	tee_local	$push228=, $5=, $pop229
	i32.const	$push227=, 32
	i32.lt_u	$push18=, $pop228, $pop227
	br_if   	0, $pop18       # 0: up to label51
.LBB18_19:                              # %my_clrsb.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label52:
	i32.const	$push232=, -1
	i32.add 	$push19=, $5, $pop232
	i32.ne  	$push20=, $2, $pop19
	br_if   	2, $pop20       # 2: down to label40
# BB#20:                                # %for.body.i1030.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$5=, 0
	i32.const	$10=, 0
.LBB18_21:                              # %for.body.i1030
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label53:
	i32.const	$push238=, 1
	i32.shl 	$push21=, $pop238, $10
	i32.and 	$push22=, $pop21, $3
	i32.const	$push237=, 0
	i32.ne  	$push23=, $pop22, $pop237
	i32.add 	$5=, $pop23, $5
	i32.const	$push236=, 1
	i32.add 	$push235=, $10, $pop236
	tee_local	$push234=, $10=, $pop235
	i32.const	$push233=, 32
	i32.ne  	$push24=, $pop234, $pop233
	br_if   	0, $pop24       # 0: up to label53
# BB#22:                                # %my_popcount.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label54:
	i32.popcnt	$push25=, $3
	i32.ne  	$push26=, $pop25, $5
	br_if   	2, $pop26       # 2: down to label40
# BB#23:                                # %for.body.i1109.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$6=, 0
	i32.const	$10=, 0
.LBB18_24:                              # %for.body.i1109
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label55:
	i32.const	$push244=, 1
	i32.shl 	$push27=, $pop244, $10
	i32.and 	$push28=, $pop27, $3
	i32.const	$push243=, 0
	i32.ne  	$push29=, $pop28, $pop243
	i32.add 	$6=, $pop29, $6
	i32.const	$push242=, 1
	i32.add 	$push241=, $10, $pop242
	tee_local	$push240=, $10=, $pop241
	i32.const	$push239=, 32
	i32.ne  	$push30=, $pop240, $pop239
	br_if   	0, $pop30       # 0: up to label55
# BB#25:                                # %my_parity.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop                        # label56:
	i32.xor 	$push31=, $6, $5
	i32.const	$push245=, 1
	i32.and 	$push32=, $pop31, $pop245
	br_if   	2, $pop32       # 2: down to label40
# BB#26:                                # %for.cond
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$push249=, 1
	i32.add 	$push248=, $0, $pop249
	tee_local	$push247=, $0=, $pop248
	i32.const	$push246=, 13
	i32.lt_u	$push33=, $pop247, $pop246
	br_if   	0, $pop33       # 0: up to label41
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
	i32.const	$push259=, 2
	i32.shl 	$push34=, $0, $pop259
	i32.const	$push258=, longs
	i32.add 	$push257=, $pop34, $pop258
	tee_local	$push256=, $1=, $pop257
	i32.load	$push255=, 0($pop256)
	tee_local	$push254=, $10=, $pop255
	i32.ctz 	$push253=, $pop254
	tee_local	$push252=, $2=, $pop253
	i32.const	$push251=, 1
	i32.add 	$push35=, $pop252, $pop251
	i32.const	$push250=, 0
	i32.select	$6=, $pop35, $pop250, $10
	i32.const	$3=, 0
	block
	i32.eqz 	$push400=, $10
	br_if   	0, $pop400      # 0: down to label59
# BB#29:                                # %for.cond.i1185.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$5=, 0
.LBB18_30:                              # %for.cond.i1185
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label60:
	copy_local	$push262=, $5
	tee_local	$push261=, $3=, $pop262
	i32.const	$push260=, 31
	i32.gt_u	$push36=, $pop261, $pop260
	br_if   	1, $pop36       # 1: down to label61
# BB#31:                                # %for.body.i1189
                                        #   in Loop: Header=BB18_30 Depth=2
	i32.const	$push264=, 1
	i32.add 	$5=, $3, $pop264
	i32.const	$push263=, 1
	i32.shl 	$push37=, $pop263, $3
	i32.and 	$push38=, $pop37, $10
	i32.eqz 	$push401=, $pop38
	br_if   	0, $pop401      # 0: up to label60
.LBB18_32:                              # %my_ffsl.exit.loopexit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label61:
	i32.const	$push265=, 1
	i32.add 	$3=, $3, $pop265
.LBB18_33:                              # %my_ffsl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_block                       # label59:
	i32.ne  	$push39=, $6, $3
	br_if   	2, $pop39       # 2: down to label40
# BB#34:                                # %if.end49
                                        #   in Loop: Header=BB18_28 Depth=1
	block
	i32.eqz 	$push402=, $10
	br_if   	0, $pop402      # 0: down to label62
# BB#35:                                # %land.lhs.true52
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.clz 	$6=, $10
	i32.const	$5=, 0
	i32.const	$3=, 31
.LBB18_36:                              # %for.body.i1266
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label63:
	i32.const	$push266=, 1
	i32.shl 	$push40=, $pop266, $3
	i32.and 	$push41=, $pop40, $10
	br_if   	1, $pop41       # 1: down to label64
# BB#37:                                # %for.inc.i1269
                                        #   in Loop: Header=BB18_36 Depth=2
	i32.const	$push271=, -1
	i32.add 	$3=, $3, $pop271
	i32.const	$push270=, 1
	i32.add 	$push269=, $5, $pop270
	tee_local	$push268=, $5=, $pop269
	i32.const	$push267=, 32
	i32.lt_u	$push42=, $pop268, $pop267
	br_if   	0, $pop42       # 0: up to label63
.LBB18_38:                              # %my_clzl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label64:
	i32.ne  	$push43=, $6, $5
	br_if   	3, $pop43       # 3: down to label40
# BB#39:                                # %land.lhs.true61
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$3=, 0
.LBB18_40:                              # %for.body.i1345
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label65:
	i32.const	$push272=, 1
	i32.shl 	$push44=, $pop272, $3
	i32.and 	$push45=, $pop44, $10
	br_if   	1, $pop45       # 1: down to label66
# BB#41:                                # %for.inc.i1348
                                        #   in Loop: Header=BB18_40 Depth=2
	i32.const	$push276=, 1
	i32.add 	$push275=, $3, $pop276
	tee_local	$push274=, $3=, $pop275
	i32.const	$push273=, 32
	i32.lt_u	$push46=, $pop274, $pop273
	br_if   	0, $pop46       # 0: up to label65
.LBB18_42:                              # %my_ctzl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label66:
	i32.ne  	$push47=, $2, $3
	br_if   	3, $pop47       # 3: down to label40
.LBB18_43:                              # %if.end67
                                        #   in Loop: Header=BB18_28 Depth=1
	end_block                       # label62:
	i32.call	$2=, __builtin_clrsbl@FUNCTION, $10
	i32.load	$push279=, 0($1)
	tee_local	$push278=, $3=, $pop279
	i32.const	$push277=, 31
	i32.shr_u	$6=, $pop278, $pop277
	i32.const	$5=, 1
	i32.const	$10=, 30
.LBB18_44:                              # %for.body.i1426
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label67:
	i32.shr_u	$push48=, $3, $10
	i32.const	$push280=, 1
	i32.and 	$push49=, $pop48, $pop280
	i32.ne  	$push50=, $pop49, $6
	br_if   	1, $pop50       # 1: down to label68
# BB#45:                                # %for.inc.i1429
                                        #   in Loop: Header=BB18_44 Depth=2
	i32.const	$push285=, -1
	i32.add 	$10=, $10, $pop285
	i32.const	$push284=, 1
	i32.add 	$push283=, $5, $pop284
	tee_local	$push282=, $5=, $pop283
	i32.const	$push281=, 32
	i32.lt_u	$push51=, $pop282, $pop281
	br_if   	0, $pop51       # 0: up to label67
.LBB18_46:                              # %my_clrsbl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label68:
	i32.const	$push286=, -1
	i32.add 	$push52=, $5, $pop286
	i32.ne  	$push53=, $2, $pop52
	br_if   	2, $pop53       # 2: down to label40
# BB#47:                                # %for.body.i1511.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$5=, 0
	i32.const	$10=, 0
.LBB18_48:                              # %for.body.i1511
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label69:
	i32.const	$push292=, 1
	i32.shl 	$push54=, $pop292, $10
	i32.and 	$push55=, $pop54, $3
	i32.const	$push291=, 0
	i32.ne  	$push56=, $pop55, $pop291
	i32.add 	$5=, $pop56, $5
	i32.const	$push290=, 1
	i32.add 	$push289=, $10, $pop290
	tee_local	$push288=, $10=, $pop289
	i32.const	$push287=, 32
	i32.ne  	$push57=, $pop288, $pop287
	br_if   	0, $pop57       # 0: up to label69
# BB#49:                                # %my_popcountl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label70:
	i32.popcnt	$push58=, $3
	i32.ne  	$push59=, $pop58, $5
	br_if   	2, $pop59       # 2: down to label40
# BB#50:                                # %for.body.i1591.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$6=, 0
	i32.const	$10=, 0
.LBB18_51:                              # %for.body.i1591
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label71:
	i32.const	$push298=, 1
	i32.shl 	$push60=, $pop298, $10
	i32.and 	$push61=, $pop60, $3
	i32.const	$push297=, 0
	i32.ne  	$push62=, $pop61, $pop297
	i32.add 	$6=, $pop62, $6
	i32.const	$push296=, 1
	i32.add 	$push295=, $10, $pop296
	tee_local	$push294=, $10=, $pop295
	i32.const	$push293=, 32
	i32.ne  	$push63=, $pop294, $pop293
	br_if   	0, $pop63       # 0: up to label71
# BB#52:                                # %my_parityl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop                        # label72:
	i32.xor 	$push64=, $6, $5
	i32.const	$push299=, 1
	i32.and 	$push65=, $pop64, $pop299
	br_if   	2, $pop65       # 2: down to label40
# BB#53:                                # %for.cond39
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$push303=, 1
	i32.add 	$push302=, $0, $pop303
	tee_local	$push301=, $0=, $pop302
	i32.const	$push300=, 13
	i32.lt_u	$push66=, $pop301, $pop300
	br_if   	0, $pop66       # 0: up to label57
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
	i32.const	$push315=, 0
	i32.const	$push314=, 3
	i32.shl 	$push67=, $5, $pop314
	i32.const	$push313=, longlongs
	i32.add 	$push312=, $pop67, $pop313
	tee_local	$push311=, $1=, $pop312
	i64.load	$push310=, 0($pop311)
	tee_local	$push309=, $9=, $pop310
	i64.ctz 	$push308=, $pop309
	tee_local	$push307=, $4=, $pop308
	i64.const	$push306=, 1
	i64.add 	$push68=, $pop307, $pop306
	i32.wrap/i64	$push69=, $pop68
	i64.eqz 	$push305=, $9
	tee_local	$push304=, $6=, $pop305
	i32.select	$0=, $pop315, $pop69, $pop304
	i32.const	$10=, 0
	block
	br_if   	0, $6           # 0: down to label75
# BB#56:                                # %for.cond.i1667.preheader
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.const	$8=, 0
	i32.const	$3=, 1
.LBB18_57:                              # %for.cond.i1667
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label76:
	copy_local	$10=, $3
	i64.const	$push316=, 63
	i64.gt_u	$push70=, $8, $pop316
	br_if   	1, $pop70       # 1: down to label77
# BB#58:                                # %for.body.i1671
                                        #   in Loop: Header=BB18_57 Depth=2
	i32.const	$push319=, 1
	i32.add 	$3=, $10, $pop319
	i64.const	$push318=, 1
	i64.shl 	$7=, $pop318, $8
	i64.const	$push317=, 1
	i64.add 	$push0=, $8, $pop317
	copy_local	$8=, $pop0
	i64.and 	$push71=, $7, $9
	i64.eqz 	$push72=, $pop71
	br_if   	0, $pop72       # 0: up to label76
.LBB18_59:                              # %my_ffsll.exit1673
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label77:
	end_block                       # label75:
	i32.ne  	$push73=, $0, $10
	br_if   	2, $pop73       # 2: down to label40
# BB#60:                                # %if.end100
                                        #   in Loop: Header=BB18_55 Depth=1
	block
	br_if   	0, $6           # 0: down to label78
# BB#61:                                # %land.lhs.true103
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.clz 	$push74=, $9
	i32.wrap/i64	$3=, $pop74
	i32.const	$10=, 0
	i64.const	$7=, 0
	i64.const	$8=, 63
.LBB18_62:                              # %for.body.i1739
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label79:
	i64.const	$push321=, 1
	i64.shl 	$push75=, $pop321, $8
	i64.and 	$push76=, $pop75, $9
	i64.const	$push320=, 0
	i64.ne  	$push77=, $pop76, $pop320
	br_if   	1, $pop77       # 1: down to label80
# BB#63:                                # %for.inc.i1743
                                        #   in Loop: Header=BB18_62 Depth=2
	i64.const	$push327=, -1
	i64.add 	$8=, $8, $pop327
	i32.const	$push326=, 1
	i32.add 	$10=, $10, $pop326
	i64.const	$push325=, 1
	i64.add 	$push324=, $7, $pop325
	tee_local	$push323=, $7=, $pop324
	i64.const	$push322=, 64
	i64.lt_u	$push78=, $pop323, $pop322
	br_if   	0, $pop78       # 0: up to label79
.LBB18_64:                              # %my_clzll.exit1745
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label80:
	i32.ne  	$push79=, $3, $10
	br_if   	3, $pop79       # 3: down to label40
# BB#65:                                # %land.lhs.true113
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.wrap/i64	$3=, $4
	i32.const	$10=, 0
	i64.const	$8=, 0
.LBB18_66:                              # %for.body.i1781
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label81:
	i64.const	$push329=, 1
	i64.shl 	$push80=, $pop329, $8
	i64.and 	$push81=, $pop80, $9
	i64.const	$push328=, 0
	i64.ne  	$push82=, $pop81, $pop328
	br_if   	1, $pop82       # 1: down to label82
# BB#67:                                # %for.inc.i1785
                                        #   in Loop: Header=BB18_66 Depth=2
	i32.const	$push334=, 1
	i32.add 	$10=, $10, $pop334
	i64.const	$push333=, 1
	i64.add 	$push332=, $8, $pop333
	tee_local	$push331=, $8=, $pop332
	i64.const	$push330=, 64
	i64.lt_u	$push83=, $pop331, $pop330
	br_if   	0, $pop83       # 0: up to label81
.LBB18_68:                              # %my_ctzll.exit1787
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label82:
	i32.ne  	$push84=, $3, $10
	br_if   	3, $pop84       # 3: down to label40
.LBB18_69:                              # %if.end120
                                        #   in Loop: Header=BB18_55 Depth=1
	end_block                       # label78:
	i32.call	$3=, __builtin_clrsbll@FUNCTION, $9
	i64.load	$push337=, 0($1)
	tee_local	$push336=, $9=, $pop337
	i64.const	$push335=, 63
	i64.shr_u	$4=, $pop336, $pop335
	i32.const	$10=, 1
	i64.const	$7=, 1
	i64.const	$8=, 62
.LBB18_70:                              # %for.body.i1845
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label83:
	i64.shr_u	$push85=, $9, $8
	i64.const	$push338=, 1
	i64.and 	$push86=, $pop85, $pop338
	i64.ne  	$push87=, $pop86, $4
	br_if   	1, $pop87       # 1: down to label84
# BB#71:                                # %for.inc.i1849
                                        #   in Loop: Header=BB18_70 Depth=2
	i64.const	$push344=, -1
	i64.add 	$8=, $8, $pop344
	i32.const	$push343=, 1
	i32.add 	$10=, $10, $pop343
	i64.const	$push342=, 1
	i64.add 	$push341=, $7, $pop342
	tee_local	$push340=, $7=, $pop341
	i64.const	$push339=, 64
	i64.lt_u	$push88=, $pop340, $pop339
	br_if   	0, $pop88       # 0: up to label83
.LBB18_72:                              # %my_clrsbll.exit1852
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label84:
	i32.const	$push345=, -1
	i32.add 	$push89=, $10, $pop345
	i32.ne  	$push90=, $3, $pop89
	br_if   	2, $pop90       # 2: down to label40
# BB#73:                                # %if.end127
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.popcnt	$7=, $9
	i32.const	$10=, 0
	i64.const	$8=, 0
.LBB18_74:                              # %for.body.i1928
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label85:
	i64.const	$push351=, 1
	i64.shl 	$push91=, $pop351, $8
	i64.and 	$push92=, $pop91, $9
	i64.const	$push350=, 0
	i64.ne  	$push93=, $pop92, $pop350
	i32.add 	$10=, $pop93, $10
	i64.const	$push349=, 1
	i64.add 	$push348=, $8, $pop349
	tee_local	$push347=, $8=, $pop348
	i64.const	$push346=, 64
	i64.ne  	$push94=, $pop347, $pop346
	br_if   	0, $pop94       # 0: up to label85
# BB#75:                                # %my_popcountll.exit1929
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label86:
	i32.wrap/i64	$push95=, $7
	i32.ne  	$push96=, $pop95, $10
	br_if   	2, $pop96       # 2: down to label40
# BB#76:                                # %for.body.i2005.preheader
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.const	$3=, 0
	i64.const	$8=, 0
.LBB18_77:                              # %for.body.i2005
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label87:
	i64.const	$push357=, 1
	i64.shl 	$push97=, $pop357, $8
	i64.and 	$push98=, $pop97, $9
	i64.const	$push356=, 0
	i64.ne  	$push99=, $pop98, $pop356
	i32.add 	$3=, $pop99, $3
	i64.const	$push355=, 1
	i64.add 	$push354=, $8, $pop355
	tee_local	$push353=, $8=, $pop354
	i64.const	$push352=, 64
	i64.ne  	$push100=, $pop353, $pop352
	br_if   	0, $pop100      # 0: up to label87
# BB#78:                                # %my_parityll.exit2007
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop                        # label88:
	i32.xor 	$push101=, $3, $10
	i32.const	$push358=, 1
	i32.and 	$push102=, $pop101, $pop358
	br_if   	3, $pop102      # 3: down to label39
# BB#79:                                # %for.cond90
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.const	$push362=, 1
	i32.add 	$push361=, $5, $pop362
	tee_local	$push360=, $5=, $pop361
	i32.const	$push359=, 12
	i32.le_u	$push103=, $pop360, $pop359
	br_if   	0, $pop103      # 0: up to label73
# BB#80:                                # %if.end148
	end_loop                        # label74:
	i32.const	$push104=, 0
	i32.call	$push105=, __builtin_clrsb@FUNCTION, $pop104
	i32.const	$push106=, 31
	i32.ne  	$push107=, $pop105, $pop106
	br_if   	0, $pop107      # 0: down to label40
# BB#81:                                # %my_clrsb.exit2515
	i32.const	$push108=, 1
	i32.call	$push109=, __builtin_clrsb@FUNCTION, $pop108
	i32.const	$push110=, 30
	i32.ne  	$push111=, $pop109, $pop110
	br_if   	0, $pop111      # 0: down to label40
# BB#82:                                # %if.end198
	i32.const	$push112=, -2147483648
	i32.call	$push113=, __builtin_clrsb@FUNCTION, $pop112
	br_if   	0, $pop113      # 0: down to label40
# BB#83:                                # %my_clrsb.exit2362
	i32.const	$push114=, 1073741824
	i32.call	$push115=, __builtin_clrsb@FUNCTION, $pop114
	br_if   	0, $pop115      # 0: down to label40
# BB#84:                                # %my_clrsb.exit2288
	i32.const	$push116=, 65536
	i32.call	$push117=, __builtin_clrsb@FUNCTION, $pop116
	i32.const	$push118=, 14
	i32.ne  	$push119=, $pop117, $pop118
	br_if   	0, $pop119      # 0: down to label40
# BB#85:                                # %my_clrsb.exit2215
	i32.const	$push120=, 32768
	i32.call	$push121=, __builtin_clrsb@FUNCTION, $pop120
	i32.const	$push122=, 15
	i32.ne  	$push123=, $pop121, $pop122
	br_if   	0, $pop123      # 0: down to label40
# BB#86:                                # %my_clrsb.exit2140
	i32.const	$push124=, -1515870811
	i32.call	$push125=, __builtin_clrsb@FUNCTION, $pop124
	br_if   	0, $pop125      # 0: down to label40
# BB#87:                                # %my_clrsb.exit2073
	i32.const	$push126=, 1515870810
	i32.call	$push127=, __builtin_clrsb@FUNCTION, $pop126
	br_if   	0, $pop127      # 0: down to label40
# BB#88:                                # %for.body.i1989
	i32.const	$push128=, -889323520
	i32.call	$push129=, __builtin_clrsb@FUNCTION, $pop128
	i32.const	$push130=, 1
	i32.ne  	$push131=, $pop129, $pop130
	br_if   	0, $pop131      # 0: down to label40
# BB#89:                                # %for.body.i1912
	i32.const	$push132=, 13303296
	i32.call	$push133=, __builtin_clrsb@FUNCTION, $pop132
	i32.const	$push134=, 7
	i32.ne  	$push135=, $pop133, $pop134
	br_if   	0, $pop135      # 0: down to label40
# BB#90:                                # %for.body.i1832
	i32.const	$push136=, 51966
	i32.call	$push137=, __builtin_clrsb@FUNCTION, $pop136
	i32.const	$push138=, 15
	i32.ne  	$push139=, $pop137, $pop138
	br_if   	0, $pop139      # 0: down to label40
# BB#91:                                # %if.end423
	i32.const	$push363=, -1
	i32.call	$5=, __builtin_clrsb@FUNCTION, $pop363
	i32.const	$10=, 30
	i32.const	$3=, 1
.LBB18_92:                              # %for.body.i1769
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label89:
	i32.const	$push365=, -1
	i32.shr_u	$push140=, $pop365, $10
	i32.const	$push364=, 1
	i32.and 	$push141=, $pop140, $pop364
	i32.eqz 	$push403=, $pop141
	br_if   	1, $pop403      # 1: down to label90
# BB#93:                                # %for.inc.i1772
                                        #   in Loop: Header=BB18_92 Depth=1
	i32.const	$push370=, -1
	i32.add 	$10=, $10, $pop370
	i32.const	$push369=, 1
	i32.add 	$push368=, $3, $pop369
	tee_local	$push367=, $3=, $pop368
	i32.const	$push366=, 32
	i32.lt_u	$push142=, $pop367, $pop366
	br_if   	0, $pop142      # 0: up to label89
.LBB18_94:                              # %my_clrsb.exit1775
	end_loop                        # label90:
	i32.const	$push143=, -1
	i32.add 	$push144=, $3, $pop143
	i32.ne  	$push145=, $5, $pop144
	br_if   	0, $pop145      # 0: down to label40
# BB#95:                                # %if.end440
	i64.const	$8=, 0
	i64.const	$push371=, 0
	i32.call	$push146=, __builtin_clrsbll@FUNCTION, $pop371
	i32.const	$push147=, 63
	i32.ne  	$push148=, $pop146, $pop147
	br_if   	0, $pop148      # 0: down to label40
# BB#96:                                # %for.body.i1691.preheader
.LBB18_97:                              # %for.body.i1691
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label92:
	i64.const	$push372=, 63
	i64.eq  	$push149=, $8, $pop372
	br_if   	2, $pop149      # 2: down to label91
# BB#98:                                # %for.inc.i1695
                                        #   in Loop: Header=BB18_97 Depth=1
	i64.const	$push376=, 1
	i64.add 	$push375=, $8, $pop376
	tee_local	$push374=, $8=, $pop375
	i64.const	$push373=, 64
	i64.lt_u	$push150=, $pop374, $pop373
	br_if   	0, $pop150      # 0: up to label92
# BB#99:                                # %if.then460
	end_loop                        # label93:
	call    	abort@FUNCTION
	unreachable
.LBB18_100:                             # %if.end465
	end_block                       # label91:
	i64.const	$push377=, 1
	i32.call	$3=, __builtin_clrsbll@FUNCTION, $pop377
	i64.const	$8=, 1
.LBB18_101:                             # %for.body.i1655
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label94:
	i32.const	$10=, 62
	i64.const	$push378=, 63
	i64.eq  	$push151=, $8, $pop378
	br_if   	1, $pop151      # 1: down to label95
# BB#102:                               # %for.inc.i1659
                                        #   in Loop: Header=BB18_101 Depth=1
	i32.const	$10=, 63
	i64.const	$push382=, 1
	i64.add 	$push381=, $8, $pop382
	tee_local	$push380=, $8=, $pop381
	i64.const	$push379=, 64
	i64.lt_u	$push152=, $pop380, $pop379
	br_if   	0, $pop152      # 0: up to label94
.LBB18_103:                             # %my_clrsbll.exit1662
	end_loop                        # label95:
	i32.ne  	$push153=, $3, $10
	br_if   	0, $pop153      # 0: down to label40
# BB#104:                               # %for.body.i1598.preheader
	i64.const	$8=, 0
.LBB18_105:                             # %for.body.i1598
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label97:
	i64.const	$push383=, 63
	i64.eq  	$push154=, $8, $pop383
	br_if   	2, $pop154      # 2: down to label96
# BB#106:                               # %for.inc.i1602
                                        #   in Loop: Header=BB18_105 Depth=1
	i64.const	$push387=, 1
	i64.add 	$push386=, $8, $pop387
	tee_local	$push385=, $8=, $pop386
	i64.const	$push384=, 64
	i64.lt_u	$push155=, $pop385, $pop384
	br_if   	0, $pop155      # 0: up to label97
# BB#107:                               # %if.then489
	end_loop                        # label98:
	call    	abort@FUNCTION
	unreachable
.LBB18_108:                             # %if.end490
	end_block                       # label96:
	i64.const	$push156=, -9223372036854775808
	i32.call	$push157=, __builtin_clrsbll@FUNCTION, $pop156
	br_if   	0, $pop157      # 0: down to label40
# BB#109:                               # %for.body.i1494
	i64.const	$push158=, 2
	i32.call	$push159=, __builtin_clrsbll@FUNCTION, $pop158
	i32.const	$push160=, 61
	i32.ne  	$push161=, $pop159, $pop160
	br_if   	0, $pop161      # 0: down to label40
# BB#110:                               # %my_clrsbll.exit1419
	i64.const	$push162=, 4611686018427387904
	i32.call	$push163=, __builtin_clrsbll@FUNCTION, $pop162
	br_if   	0, $pop163      # 0: down to label40
# BB#111:                               # %for.body.i1333
	i64.const	$push164=, 4294967296
	i32.call	$push165=, __builtin_clrsbll@FUNCTION, $pop164
	i32.const	$push166=, 30
	i32.ne  	$push167=, $pop165, $pop166
	br_if   	0, $pop167      # 0: down to label40
# BB#112:                               # %for.body.i1253
	i64.const	$push168=, 2147483648
	i32.call	$push169=, __builtin_clrsbll@FUNCTION, $pop168
	i32.const	$push170=, 31
	i32.ne  	$push171=, $pop169, $pop170
	br_if   	0, $pop171      # 0: down to label40
# BB#113:                               # %my_clrsbll.exit1180
	i64.const	$push172=, -6510615555426900571
	i32.call	$push173=, __builtin_clrsbll@FUNCTION, $pop172
	br_if   	0, $pop173      # 0: down to label40
# BB#114:                               # %my_clrsbll.exit1100
	i64.const	$push174=, 6510615555426900570
	i32.call	$push175=, __builtin_clrsbll@FUNCTION, $pop174
	br_if   	0, $pop175      # 0: down to label40
# BB#115:                               # %for.body.i1015
	i64.const	$push176=, -3819392241693097984
	i32.call	$push177=, __builtin_clrsbll@FUNCTION, $pop176
	i32.const	$push178=, 1
	i32.ne  	$push179=, $pop177, $pop178
	br_if   	0, $pop179      # 0: down to label40
# BB#116:                               # %for.body.i939
	i64.const	$push180=, 223195676147712
	i32.call	$push181=, __builtin_clrsbll@FUNCTION, $pop180
	i32.const	$push182=, 15
	i32.ne  	$push183=, $pop181, $pop182
	br_if   	0, $pop183      # 0: down to label40
# BB#117:                               # %for.body.i864
	i64.const	$push184=, 3405695742
	i32.call	$push185=, __builtin_clrsbll@FUNCTION, $pop184
	i32.const	$push186=, 31
	i32.ne  	$push187=, $pop185, $pop186
	br_if   	0, $pop187      # 0: down to label40
# BB#118:                               # %if.end740
	i64.const	$push388=, -1
	i32.call	$3=, __builtin_clrsbll@FUNCTION, $pop388
	i64.const	$8=, 62
	i64.const	$9=, 1
	i32.const	$10=, 1
.LBB18_119:                             # %for.body.i810
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label99:
	i64.const	$push390=, -1
	i64.shr_u	$push188=, $pop390, $8
	i64.const	$push389=, 1
	i64.and 	$push189=, $pop188, $pop389
	i64.eqz 	$push190=, $pop189
	br_if   	1, $pop190      # 1: down to label100
# BB#120:                               # %for.inc.i
                                        #   in Loop: Header=BB18_119 Depth=1
	i64.const	$push396=, -1
	i64.add 	$8=, $8, $pop396
	i32.const	$push395=, 1
	i32.add 	$10=, $10, $pop395
	i64.const	$push394=, 1
	i64.add 	$push393=, $9, $pop394
	tee_local	$push392=, $9=, $pop393
	i64.const	$push391=, 64
	i64.lt_u	$push191=, $pop392, $pop391
	br_if   	0, $pop191      # 0: up to label99
.LBB18_121:                             # %my_clrsbll.exit
	end_loop                        # label100:
	i32.const	$push192=, -1
	i32.add 	$push193=, $10, $pop192
	i32.ne  	$push194=, $3, $pop193
	br_if   	0, $pop194      # 0: down to label40
# BB#122:                               # %if.end753
	i32.const	$push195=, 0
	call    	exit@FUNCTION, $pop195
	unreachable
.LBB18_123:                             # %if.then37
	end_block                       # label40:
	call    	abort@FUNCTION
	unreachable
.LBB18_124:                             # %if.then140
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
