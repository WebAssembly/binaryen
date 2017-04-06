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
	block   	
	i32.eqz 	$push11=, $0
	br_if   	0, $pop11       # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.const	$push6=, 1
	i32.shl 	$push0=, $pop6, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label1
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push10=, 1
	i32.add 	$push9=, $1, $pop10
	tee_local	$push8=, $1=, $pop9
	i32.const	$push7=, 32
	i32.lt_u	$push2=, $pop8, $pop7
	br_if   	0, $pop2        # 0: up to label2
.LBB0_4:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.const	$push3=, 1
	i32.add 	$push5=, $1, $pop3
	return  	$pop5
.LBB0_5:
	end_block                       # label0:
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
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
	block   	
	loop    	                # label4:
	i32.const	$push3=, 1
	i32.shl 	$push0=, $pop3, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push7=, 1
	i32.add 	$push6=, $1, $pop7
	tee_local	$push5=, $1=, $pop6
	i32.const	$push4=, 32
	i32.lt_u	$push2=, $pop5, $pop4
	br_if   	0, $pop2        # 0: up to label4
.LBB1_3:                                # %for.end
	end_loop
	end_block                       # label3:
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
	block   	
	loop    	                # label6:
	i32.const	$push3=, 1
	i32.shl 	$push0=, $pop3, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label5
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push8=, -1
	i32.add 	$1=, $1, $pop8
	i32.const	$push7=, 1
	i32.add 	$push6=, $2, $pop7
	tee_local	$push5=, $2=, $pop6
	i32.const	$push4=, 32
	i32.lt_u	$push2=, $pop5, $pop4
	br_if   	0, $pop2        # 0: up to label6
.LBB2_3:                                # %for.end
	end_loop
	end_block                       # label5:
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
	block   	
	loop    	                # label8:
	i32.shr_u	$push1=, $0, $2
	i32.const	$push7=, 1
	i32.and 	$push2=, $pop1, $pop7
	i32.ne  	$push3=, $pop2, $1
	br_if   	1, $pop3        # 1: down to label7
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$push12=, -1
	i32.add 	$2=, $2, $pop12
	i32.const	$push11=, 1
	i32.add 	$push10=, $3, $pop11
	tee_local	$push9=, $3=, $pop10
	i32.const	$push8=, 32
	i32.lt_u	$push4=, $pop9, $pop8
	br_if   	0, $pop4        # 0: up to label8
.LBB3_3:                                # %for.end
	end_loop
	end_block                       # label7:
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
	loop    	                # label9:
	i32.const	$push9=, 1
	i32.shl 	$push0=, $pop9, $2
	i32.and 	$push1=, $pop0, $0
	i32.const	$push8=, 0
	i32.ne  	$push2=, $pop1, $pop8
	i32.add 	$1=, $1, $pop2
	i32.const	$push7=, 1
	i32.add 	$push6=, $2, $pop7
	tee_local	$push5=, $2=, $pop6
	i32.const	$push4=, 32
	i32.ne  	$push3=, $pop5, $pop4
	br_if   	0, $pop3        # 0: up to label9
# BB#2:                                 # %for.end
	end_loop
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
	loop    	                # label10:
	i32.const	$push11=, 1
	i32.shl 	$push0=, $pop11, $2
	i32.and 	$push1=, $pop0, $0
	i32.const	$push10=, 0
	i32.ne  	$push2=, $pop1, $pop10
	i32.add 	$1=, $1, $pop2
	i32.const	$push9=, 1
	i32.add 	$push8=, $2, $pop9
	tee_local	$push7=, $2=, $pop8
	i32.const	$push6=, 32
	i32.ne  	$push3=, $pop7, $pop6
	br_if   	0, $pop3        # 0: up to label10
# BB#2:                                 # %for.end
	end_loop
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
	block   	
	i32.eqz 	$push11=, $0
	br_if   	0, $pop11       # 0: down to label11
# BB#1:                                 # %for.body.preheader
	i32.const	$1=, 0
.LBB6_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label13:
	i32.const	$push6=, 1
	i32.shl 	$push0=, $pop6, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label12
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB6_2 Depth=1
	i32.const	$push10=, 1
	i32.add 	$push9=, $1, $pop10
	tee_local	$push8=, $1=, $pop9
	i32.const	$push7=, 32
	i32.lt_u	$push2=, $pop8, $pop7
	br_if   	0, $pop2        # 0: up to label13
.LBB6_4:                                # %for.end
	end_loop
	end_block                       # label12:
	i32.const	$push3=, 1
	i32.add 	$push5=, $1, $pop3
	return  	$pop5
.LBB6_5:
	end_block                       # label11:
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
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
	block   	
	loop    	                # label15:
	i32.const	$push3=, 1
	i32.shl 	$push0=, $pop3, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label14
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.const	$push7=, 1
	i32.add 	$push6=, $1, $pop7
	tee_local	$push5=, $1=, $pop6
	i32.const	$push4=, 32
	i32.lt_u	$push2=, $pop5, $pop4
	br_if   	0, $pop2        # 0: up to label15
.LBB7_3:                                # %for.end
	end_loop
	end_block                       # label14:
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
	block   	
	loop    	                # label17:
	i32.const	$push3=, 1
	i32.shl 	$push0=, $pop3, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label16
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.const	$push8=, -1
	i32.add 	$1=, $1, $pop8
	i32.const	$push7=, 1
	i32.add 	$push6=, $2, $pop7
	tee_local	$push5=, $2=, $pop6
	i32.const	$push4=, 32
	i32.lt_u	$push2=, $pop5, $pop4
	br_if   	0, $pop2        # 0: up to label17
.LBB8_3:                                # %for.end
	end_loop
	end_block                       # label16:
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
	block   	
	loop    	                # label19:
	i32.shr_u	$push1=, $0, $2
	i32.const	$push7=, 1
	i32.and 	$push2=, $pop1, $pop7
	i32.ne  	$push3=, $pop2, $1
	br_if   	1, $pop3        # 1: down to label18
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.const	$push12=, -1
	i32.add 	$2=, $2, $pop12
	i32.const	$push11=, 1
	i32.add 	$push10=, $3, $pop11
	tee_local	$push9=, $3=, $pop10
	i32.const	$push8=, 32
	i32.lt_u	$push4=, $pop9, $pop8
	br_if   	0, $pop4        # 0: up to label19
.LBB9_3:                                # %for.end
	end_loop
	end_block                       # label18:
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
	loop    	                # label20:
	i32.const	$push9=, 1
	i32.shl 	$push0=, $pop9, $2
	i32.and 	$push1=, $pop0, $0
	i32.const	$push8=, 0
	i32.ne  	$push2=, $pop1, $pop8
	i32.add 	$1=, $1, $pop2
	i32.const	$push7=, 1
	i32.add 	$push6=, $2, $pop7
	tee_local	$push5=, $2=, $pop6
	i32.const	$push4=, 32
	i32.ne  	$push3=, $pop5, $pop4
	br_if   	0, $pop3        # 0: up to label20
# BB#2:                                 # %for.end
	end_loop
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
	loop    	                # label21:
	i32.const	$push11=, 1
	i32.shl 	$push0=, $pop11, $2
	i32.and 	$push1=, $pop0, $0
	i32.const	$push10=, 0
	i32.ne  	$push2=, $pop1, $pop10
	i32.add 	$1=, $1, $pop2
	i32.const	$push9=, 1
	i32.add 	$push8=, $2, $pop9
	tee_local	$push7=, $2=, $pop8
	i32.const	$push6=, 32
	i32.ne  	$push3=, $pop7, $pop6
	br_if   	0, $pop3        # 0: up to label21
# BB#2:                                 # %for.end
	end_loop
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
	block   	
	i64.eqz 	$push0=, $0
	br_if   	0, $pop0        # 0: down to label22
# BB#1:                                 # %for.body.preheader
	i32.const	$2=, 0
	i64.const	$1=, 0
.LBB12_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label24:
	i64.const	$push9=, 1
	i64.shl 	$push1=, $pop9, $1
	i64.and 	$push2=, $pop1, $0
	i64.const	$push8=, 0
	i64.ne  	$push3=, $pop2, $pop8
	br_if   	1, $pop3        # 1: down to label23
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB12_2 Depth=1
	i32.const	$push14=, 1
	i32.add 	$2=, $2, $pop14
	i64.const	$push13=, 1
	i64.add 	$push12=, $1, $pop13
	tee_local	$push11=, $1=, $pop12
	i64.const	$push10=, 64
	i64.lt_u	$push4=, $pop11, $pop10
	br_if   	0, $pop4        # 0: up to label24
.LBB12_4:                               # %for.end
	end_loop
	end_block                       # label23:
	i32.const	$push5=, 1
	i32.add 	$push7=, $2, $pop5
	return  	$pop7
.LBB12_5:
	end_block                       # label22:
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
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
	block   	
	loop    	                # label26:
	i64.const	$push5=, 1
	i64.shl 	$push0=, $pop5, $1
	i64.and 	$push1=, $pop0, $0
	i64.const	$push4=, 0
	i64.ne  	$push2=, $pop1, $pop4
	br_if   	1, $pop2        # 1: down to label25
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB13_1 Depth=1
	i32.const	$push10=, 1
	i32.add 	$2=, $2, $pop10
	i64.const	$push9=, 1
	i64.add 	$push8=, $1, $pop9
	tee_local	$push7=, $1=, $pop8
	i64.const	$push6=, 64
	i64.lt_u	$push3=, $pop7, $pop6
	br_if   	0, $pop3        # 0: up to label26
.LBB13_3:                               # %for.end
	end_loop
	end_block                       # label25:
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
	block   	
	loop    	                # label28:
	i64.const	$push5=, 1
	i64.shl 	$push0=, $pop5, $1
	i64.and 	$push1=, $pop0, $0
	i64.const	$push4=, 0
	i64.ne  	$push2=, $pop1, $pop4
	br_if   	1, $pop2        # 1: down to label27
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
	br_if   	0, $pop3        # 0: up to label28
.LBB14_3:                               # %for.end
	end_loop
	end_block                       # label27:
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
	block   	
	loop    	                # label30:
	i64.shr_u	$push1=, $0, $2
	i64.const	$push7=, 1
	i64.and 	$push2=, $pop1, $pop7
	i64.ne  	$push3=, $pop2, $1
	br_if   	1, $pop3        # 1: down to label29
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
	br_if   	0, $pop4        # 0: up to label30
.LBB15_3:                               # %for.end
	end_loop
	end_block                       # label29:
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
	loop    	                # label31:
	i64.const	$push9=, 1
	i64.shl 	$push0=, $pop9, $1
	i64.and 	$push1=, $pop0, $0
	i64.const	$push8=, 0
	i64.ne  	$push2=, $pop1, $pop8
	i32.add 	$2=, $2, $pop2
	i64.const	$push7=, 1
	i64.add 	$push6=, $1, $pop7
	tee_local	$push5=, $1=, $pop6
	i64.const	$push4=, 64
	i64.ne  	$push3=, $pop5, $pop4
	br_if   	0, $pop3        # 0: up to label31
# BB#2:                                 # %for.end
	end_loop
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
	loop    	                # label32:
	i64.const	$push11=, 1
	i64.shl 	$push0=, $pop11, $1
	i64.and 	$push1=, $pop0, $0
	i64.const	$push10=, 0
	i64.ne  	$push2=, $pop1, $pop10
	i32.add 	$2=, $2, $pop2
	i64.const	$push9=, 1
	i64.add 	$push8=, $1, $pop9
	tee_local	$push7=, $1=, $pop8
	i64.const	$push6=, 64
	i64.ne  	$push3=, $pop7, $pop6
	br_if   	0, $pop3        # 0: up to label32
# BB#2:                                 # %for.end
	end_loop
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
	loop    	                # label34:
	i32.const	$push210=, 2
	i32.shl 	$push0=, $0, $pop210
	i32.const	$push209=, ints
	i32.add 	$push208=, $pop0, $pop209
	tee_local	$push207=, $6=, $pop208
	i32.load	$push206=, 0($pop207)
	tee_local	$push205=, $10=, $pop206
	i32.ctz 	$push204=, $pop205
	tee_local	$push203=, $2=, $pop204
	i32.const	$push202=, 1
	i32.add 	$push1=, $pop203, $pop202
	i32.const	$push201=, 0
	i32.select	$5=, $pop1, $pop201, $10
	i32.const	$3=, 0
	block   	
	i32.eqz 	$push411=, $10
	br_if   	0, $pop411      # 0: down to label35
# BB#2:                                 # %for.body.i.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$3=, 0
.LBB18_3:                               # %for.body.i
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label37:
	i32.const	$push211=, 1
	i32.shl 	$push2=, $pop211, $3
	i32.and 	$push3=, $pop2, $10
	br_if   	1, $pop3        # 1: down to label36
# BB#4:                                 # %for.inc.i
                                        #   in Loop: Header=BB18_3 Depth=2
	i32.const	$push215=, 1
	i32.add 	$push214=, $3, $pop215
	tee_local	$push213=, $3=, $pop214
	i32.const	$push212=, 32
	i32.lt_u	$push4=, $pop213, $pop212
	br_if   	0, $pop4        # 0: up to label37
.LBB18_5:                               # %for.end.i
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	end_block                       # label36:
	i32.const	$push216=, 1
	i32.add 	$3=, $3, $pop216
.LBB18_6:                               # %my_ffs.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label35:
	i32.ne  	$push5=, $5, $3
	br_if   	1, $pop5        # 1: down to label33
# BB#7:                                 # %if.end
                                        #   in Loop: Header=BB18_1 Depth=1
	block   	
	i32.eqz 	$push412=, $10
	br_if   	0, $pop412      # 0: down to label38
# BB#8:                                 # %land.lhs.true
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.clz 	$1=, $10
	i32.const	$5=, 0
	i32.const	$3=, 31
.LBB18_9:                               # %for.body.i822
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label40:
	i32.const	$push217=, 1
	i32.shl 	$push6=, $pop217, $3
	i32.and 	$push7=, $pop6, $10
	br_if   	1, $pop7        # 1: down to label39
# BB#10:                                # %for.inc.i825
                                        #   in Loop: Header=BB18_9 Depth=2
	i32.const	$push222=, -1
	i32.add 	$3=, $3, $pop222
	i32.const	$push221=, 1
	i32.add 	$push220=, $5, $pop221
	tee_local	$push219=, $5=, $pop220
	i32.const	$push218=, 32
	i32.lt_u	$push8=, $pop219, $pop218
	br_if   	0, $pop8        # 0: up to label40
.LBB18_11:                              # %my_clz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	end_block                       # label39:
	i32.ne  	$push9=, $1, $5
	br_if   	2, $pop9        # 2: down to label33
# BB#12:                                # %land.lhs.true13
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$3=, 0
.LBB18_13:                              # %for.body.i888
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label42:
	i32.const	$push223=, 1
	i32.shl 	$push10=, $pop223, $3
	i32.and 	$push11=, $pop10, $10
	br_if   	1, $pop11       # 1: down to label41
# BB#14:                                # %for.inc.i891
                                        #   in Loop: Header=BB18_13 Depth=2
	i32.const	$push227=, 1
	i32.add 	$push226=, $3, $pop227
	tee_local	$push225=, $3=, $pop226
	i32.const	$push224=, 32
	i32.lt_u	$push12=, $pop225, $pop224
	br_if   	0, $pop12       # 0: up to label42
.LBB18_15:                              # %my_ctz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	end_block                       # label41:
	i32.ne  	$push13=, $2, $3
	br_if   	2, $pop13       # 2: down to label33
.LBB18_16:                              # %if.end19
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label38:
	i32.call	$2=, __builtin_clrsb@FUNCTION, $10
	i32.load	$push230=, 0($6)
	tee_local	$push229=, $3=, $pop230
	i32.const	$push228=, 31
	i32.shr_u	$6=, $pop229, $pop228
	i32.const	$5=, 1
	i32.const	$10=, 30
.LBB18_17:                              # %for.body.i972
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label44:
	i32.shr_u	$push14=, $3, $10
	i32.const	$push231=, 1
	i32.and 	$push15=, $pop14, $pop231
	i32.ne  	$push16=, $pop15, $6
	br_if   	1, $pop16       # 1: down to label43
# BB#18:                                # %for.inc.i975
                                        #   in Loop: Header=BB18_17 Depth=2
	i32.const	$push236=, -1
	i32.add 	$10=, $10, $pop236
	i32.const	$push235=, 1
	i32.add 	$push234=, $5, $pop235
	tee_local	$push233=, $5=, $pop234
	i32.const	$push232=, 32
	i32.lt_u	$push17=, $pop233, $pop232
	br_if   	0, $pop17       # 0: up to label44
.LBB18_19:                              # %my_clrsb.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	end_block                       # label43:
	i32.const	$push237=, -1
	i32.add 	$push18=, $5, $pop237
	i32.ne  	$push19=, $2, $pop18
	br_if   	1, $pop19       # 1: down to label33
# BB#20:                                # %for.body.i1065.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$5=, 0
	i32.const	$10=, 0
.LBB18_21:                              # %for.body.i1065
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label45:
	i32.const	$push243=, 1
	i32.shl 	$push20=, $pop243, $10
	i32.and 	$push21=, $pop20, $3
	i32.const	$push242=, 0
	i32.ne  	$push22=, $pop21, $pop242
	i32.add 	$5=, $5, $pop22
	i32.const	$push241=, 1
	i32.add 	$push240=, $10, $pop241
	tee_local	$push239=, $10=, $pop240
	i32.const	$push238=, 32
	i32.ne  	$push23=, $pop239, $pop238
	br_if   	0, $pop23       # 0: up to label45
# BB#22:                                # %my_popcount.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	i32.popcnt	$push24=, $3
	i32.ne  	$push25=, $pop24, $5
	br_if   	1, $pop25       # 1: down to label33
# BB#23:                                # %for.body.i1155.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$6=, 0
	i32.const	$10=, 0
.LBB18_24:                              # %for.body.i1155
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label46:
	i32.const	$push249=, 1
	i32.shl 	$push26=, $pop249, $10
	i32.and 	$push27=, $pop26, $3
	i32.const	$push248=, 0
	i32.ne  	$push28=, $pop27, $pop248
	i32.add 	$6=, $6, $pop28
	i32.const	$push247=, 1
	i32.add 	$push246=, $10, $pop247
	tee_local	$push245=, $10=, $pop246
	i32.const	$push244=, 32
	i32.ne  	$push29=, $pop245, $pop244
	br_if   	0, $pop29       # 0: up to label46
# BB#25:                                # %my_parity.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	i32.xor 	$push30=, $6, $5
	i32.const	$push250=, 1
	i32.and 	$push31=, $pop30, $pop250
	br_if   	1, $pop31       # 1: down to label33
# BB#26:                                # %for.cond
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$push254=, 1
	i32.add 	$push253=, $0, $pop254
	tee_local	$push252=, $0=, $pop253
	i32.const	$push251=, 13
	i32.lt_u	$push32=, $pop252, $pop251
	br_if   	0, $pop32       # 0: up to label34
# BB#27:                                # %for.body41.preheader
	end_loop
	i32.const	$0=, 0
.LBB18_28:                              # %for.body41
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_30 Depth 2
                                        #     Child Loop BB18_36 Depth 2
                                        #     Child Loop BB18_40 Depth 2
                                        #     Child Loop BB18_44 Depth 2
                                        #     Child Loop BB18_48 Depth 2
                                        #     Child Loop BB18_51 Depth 2
	loop    	                # label47:
	i32.const	$push264=, 2
	i32.shl 	$push33=, $0, $pop264
	i32.const	$push263=, longs
	i32.add 	$push262=, $pop33, $pop263
	tee_local	$push261=, $6=, $pop262
	i32.load	$push260=, 0($pop261)
	tee_local	$push259=, $10=, $pop260
	i32.ctz 	$push258=, $pop259
	tee_local	$push257=, $2=, $pop258
	i32.const	$push256=, 1
	i32.add 	$push34=, $pop257, $pop256
	i32.const	$push255=, 0
	i32.select	$5=, $pop34, $pop255, $10
	i32.const	$3=, 0
	block   	
	i32.eqz 	$push413=, $10
	br_if   	0, $pop413      # 0: down to label48
# BB#29:                                # %for.body.i1243.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$3=, 0
.LBB18_30:                              # %for.body.i1243
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label50:
	i32.const	$push265=, 1
	i32.shl 	$push35=, $pop265, $3
	i32.and 	$push36=, $pop35, $10
	br_if   	1, $pop36       # 1: down to label49
# BB#31:                                # %for.inc.i1246
                                        #   in Loop: Header=BB18_30 Depth=2
	i32.const	$push269=, 1
	i32.add 	$push268=, $3, $pop269
	tee_local	$push267=, $3=, $pop268
	i32.const	$push266=, 32
	i32.lt_u	$push37=, $pop267, $pop266
	br_if   	0, $pop37       # 0: up to label50
.LBB18_32:                              # %for.end.i1249
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop
	end_block                       # label49:
	i32.const	$push270=, 1
	i32.add 	$3=, $3, $pop270
.LBB18_33:                              # %my_ffsl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_block                       # label48:
	i32.ne  	$push38=, $5, $3
	br_if   	1, $pop38       # 1: down to label33
# BB#34:                                # %if.end49
                                        #   in Loop: Header=BB18_28 Depth=1
	block   	
	i32.eqz 	$push414=, $10
	br_if   	0, $pop414      # 0: down to label51
# BB#35:                                # %land.lhs.true52
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.clz 	$1=, $10
	i32.const	$5=, 0
	i32.const	$3=, 31
.LBB18_36:                              # %for.body.i1336
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label53:
	i32.const	$push271=, 1
	i32.shl 	$push39=, $pop271, $3
	i32.and 	$push40=, $pop39, $10
	br_if   	1, $pop40       # 1: down to label52
# BB#37:                                # %for.inc.i1339
                                        #   in Loop: Header=BB18_36 Depth=2
	i32.const	$push276=, -1
	i32.add 	$3=, $3, $pop276
	i32.const	$push275=, 1
	i32.add 	$push274=, $5, $pop275
	tee_local	$push273=, $5=, $pop274
	i32.const	$push272=, 32
	i32.lt_u	$push41=, $pop273, $pop272
	br_if   	0, $pop41       # 0: up to label53
.LBB18_38:                              # %my_clzl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop
	end_block                       # label52:
	i32.ne  	$push42=, $1, $5
	br_if   	2, $pop42       # 2: down to label33
# BB#39:                                # %land.lhs.true61
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$3=, 0
.LBB18_40:                              # %for.body.i1426
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label55:
	i32.const	$push277=, 1
	i32.shl 	$push43=, $pop277, $3
	i32.and 	$push44=, $pop43, $10
	br_if   	1, $pop44       # 1: down to label54
# BB#41:                                # %for.inc.i1429
                                        #   in Loop: Header=BB18_40 Depth=2
	i32.const	$push281=, 1
	i32.add 	$push280=, $3, $pop281
	tee_local	$push279=, $3=, $pop280
	i32.const	$push278=, 32
	i32.lt_u	$push45=, $pop279, $pop278
	br_if   	0, $pop45       # 0: up to label55
.LBB18_42:                              # %my_ctzl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop
	end_block                       # label54:
	i32.ne  	$push46=, $2, $3
	br_if   	2, $pop46       # 2: down to label33
.LBB18_43:                              # %if.end67
                                        #   in Loop: Header=BB18_28 Depth=1
	end_block                       # label51:
	i32.call	$2=, __builtin_clrsbl@FUNCTION, $10
	i32.load	$push284=, 0($6)
	tee_local	$push283=, $3=, $pop284
	i32.const	$push282=, 31
	i32.shr_u	$6=, $pop283, $pop282
	i32.const	$5=, 1
	i32.const	$10=, 30
.LBB18_44:                              # %for.body.i1518
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label57:
	i32.shr_u	$push47=, $3, $10
	i32.const	$push285=, 1
	i32.and 	$push48=, $pop47, $pop285
	i32.ne  	$push49=, $pop48, $6
	br_if   	1, $pop49       # 1: down to label56
# BB#45:                                # %for.inc.i1521
                                        #   in Loop: Header=BB18_44 Depth=2
	i32.const	$push290=, -1
	i32.add 	$10=, $10, $pop290
	i32.const	$push289=, 1
	i32.add 	$push288=, $5, $pop289
	tee_local	$push287=, $5=, $pop288
	i32.const	$push286=, 32
	i32.lt_u	$push50=, $pop287, $pop286
	br_if   	0, $pop50       # 0: up to label57
.LBB18_46:                              # %my_clrsbl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop
	end_block                       # label56:
	i32.const	$push291=, -1
	i32.add 	$push51=, $5, $pop291
	i32.ne  	$push52=, $2, $pop51
	br_if   	1, $pop52       # 1: down to label33
# BB#47:                                # %for.body.i1614.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$5=, 0
	i32.const	$10=, 0
.LBB18_48:                              # %for.body.i1614
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label58:
	i32.const	$push297=, 1
	i32.shl 	$push53=, $pop297, $10
	i32.and 	$push54=, $pop53, $3
	i32.const	$push296=, 0
	i32.ne  	$push55=, $pop54, $pop296
	i32.add 	$5=, $5, $pop55
	i32.const	$push295=, 1
	i32.add 	$push294=, $10, $pop295
	tee_local	$push293=, $10=, $pop294
	i32.const	$push292=, 32
	i32.ne  	$push56=, $pop293, $pop292
	br_if   	0, $pop56       # 0: up to label58
# BB#49:                                # %my_popcountl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop
	i32.popcnt	$push57=, $3
	i32.ne  	$push58=, $pop57, $5
	br_if   	1, $pop58       # 1: down to label33
# BB#50:                                # %for.body.i1705.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$6=, 0
	i32.const	$10=, 0
.LBB18_51:                              # %for.body.i1705
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label59:
	i32.const	$push303=, 1
	i32.shl 	$push59=, $pop303, $10
	i32.and 	$push60=, $pop59, $3
	i32.const	$push302=, 0
	i32.ne  	$push61=, $pop60, $pop302
	i32.add 	$6=, $6, $pop61
	i32.const	$push301=, 1
	i32.add 	$push300=, $10, $pop301
	tee_local	$push299=, $10=, $pop300
	i32.const	$push298=, 32
	i32.ne  	$push62=, $pop299, $pop298
	br_if   	0, $pop62       # 0: up to label59
# BB#52:                                # %my_parityl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop
	i32.xor 	$push63=, $6, $5
	i32.const	$push304=, 1
	i32.and 	$push64=, $pop63, $pop304
	br_if   	1, $pop64       # 1: down to label33
# BB#53:                                # %for.cond39
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$push308=, 1
	i32.add 	$push307=, $0, $pop308
	tee_local	$push306=, $0=, $pop307
	i32.const	$push305=, 13
	i32.lt_u	$push65=, $pop306, $pop305
	br_if   	0, $pop65       # 0: up to label47
# BB#54:                                # %for.body92.preheader
	end_loop
	i32.const	$5=, 0
.LBB18_55:                              # %for.body92
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_57 Depth 2
                                        #     Child Loop BB18_63 Depth 2
                                        #     Child Loop BB18_67 Depth 2
                                        #     Child Loop BB18_71 Depth 2
                                        #     Child Loop BB18_75 Depth 2
                                        #     Child Loop BB18_78 Depth 2
	loop    	                # label60:
	i32.const	$push320=, 0
	i32.const	$push319=, 3
	i32.shl 	$push66=, $5, $pop319
	i32.const	$push318=, longlongs
	i32.add 	$push317=, $pop66, $pop318
	tee_local	$push316=, $6=, $pop317
	i64.load	$push315=, 0($pop316)
	tee_local	$push314=, $8=, $pop315
	i64.ctz 	$push313=, $pop314
	tee_local	$push312=, $4=, $pop313
	i64.const	$push311=, 1
	i64.add 	$push67=, $pop312, $pop311
	i32.wrap/i64	$push68=, $pop67
	i64.eqz 	$push310=, $8
	tee_local	$push309=, $3=, $pop310
	i32.select	$0=, $pop320, $pop68, $pop309
	i32.const	$10=, 0
	block   	
	br_if   	0, $3           # 0: down to label61
# BB#56:                                # %for.body.i1794.preheader
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.const	$10=, 0
	i64.const	$9=, 0
.LBB18_57:                              # %for.body.i1794
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label63:
	i64.const	$push322=, 1
	i64.shl 	$push69=, $pop322, $9
	i64.and 	$push70=, $pop69, $8
	i64.const	$push321=, 0
	i64.ne  	$push71=, $pop70, $pop321
	br_if   	1, $pop71       # 1: down to label62
# BB#58:                                # %for.inc.i1798
                                        #   in Loop: Header=BB18_57 Depth=2
	i32.const	$push327=, 1
	i32.add 	$10=, $10, $pop327
	i64.const	$push326=, 1
	i64.add 	$push325=, $9, $pop326
	tee_local	$push324=, $9=, $pop325
	i64.const	$push323=, 64
	i64.lt_u	$push72=, $pop324, $pop323
	br_if   	0, $pop72       # 0: up to label63
.LBB18_59:                              # %for.end.i1801
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop
	end_block                       # label62:
	i32.const	$push328=, 1
	i32.add 	$10=, $10, $pop328
.LBB18_60:                              # %my_ffsll.exit1803
                                        #   in Loop: Header=BB18_55 Depth=1
	end_block                       # label61:
	i32.ne  	$push73=, $0, $10
	br_if   	1, $pop73       # 1: down to label33
# BB#61:                                # %if.end100
                                        #   in Loop: Header=BB18_55 Depth=1
	block   	
	br_if   	0, $3           # 0: down to label64
# BB#62:                                # %land.lhs.true103
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.clz 	$push74=, $8
	i32.wrap/i64	$3=, $pop74
	i32.const	$10=, 0
	i64.const	$7=, 0
	i64.const	$9=, 63
.LBB18_63:                              # %for.body.i1878
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label66:
	i64.const	$push330=, 1
	i64.shl 	$push75=, $pop330, $9
	i64.and 	$push76=, $pop75, $8
	i64.const	$push329=, 0
	i64.ne  	$push77=, $pop76, $pop329
	br_if   	1, $pop77       # 1: down to label65
# BB#64:                                # %for.inc.i1882
                                        #   in Loop: Header=BB18_63 Depth=2
	i64.const	$push336=, -1
	i64.add 	$9=, $9, $pop336
	i32.const	$push335=, 1
	i32.add 	$10=, $10, $pop335
	i64.const	$push334=, 1
	i64.add 	$push333=, $7, $pop334
	tee_local	$push332=, $7=, $pop333
	i64.const	$push331=, 64
	i64.lt_u	$push78=, $pop332, $pop331
	br_if   	0, $pop78       # 0: up to label66
.LBB18_65:                              # %my_clzll.exit1885
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop
	end_block                       # label65:
	i32.ne  	$push79=, $10, $3
	br_if   	2, $pop79       # 2: down to label33
# BB#66:                                # %land.lhs.true113
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.wrap/i64	$3=, $4
	i32.const	$10=, 0
	i64.const	$9=, 0
.LBB18_67:                              # %for.body.i1924
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label68:
	i64.const	$push338=, 1
	i64.shl 	$push80=, $pop338, $9
	i64.and 	$push81=, $pop80, $8
	i64.const	$push337=, 0
	i64.ne  	$push82=, $pop81, $pop337
	br_if   	1, $pop82       # 1: down to label67
# BB#68:                                # %for.inc.i1928
                                        #   in Loop: Header=BB18_67 Depth=2
	i32.const	$push343=, 1
	i32.add 	$10=, $10, $pop343
	i64.const	$push342=, 1
	i64.add 	$push341=, $9, $pop342
	tee_local	$push340=, $9=, $pop341
	i64.const	$push339=, 64
	i64.lt_u	$push83=, $pop340, $pop339
	br_if   	0, $pop83       # 0: up to label68
.LBB18_69:                              # %my_ctzll.exit1931
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop
	end_block                       # label67:
	i32.ne  	$push84=, $10, $3
	br_if   	2, $pop84       # 2: down to label33
.LBB18_70:                              # %if.end120
                                        #   in Loop: Header=BB18_55 Depth=1
	end_block                       # label64:
	i32.call	$3=, __builtin_clrsbll@FUNCTION, $8
	i64.load	$push346=, 0($6)
	tee_local	$push345=, $9=, $pop346
	i64.const	$push344=, 63
	i64.shr_u	$4=, $pop345, $pop344
	i32.const	$10=, 1
	i64.const	$7=, 1
	i64.const	$8=, 62
.LBB18_71:                              # %for.body.i1994
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label70:
	i64.shr_u	$push85=, $9, $8
	i64.const	$push347=, 1
	i64.and 	$push86=, $pop85, $pop347
	i64.ne  	$push87=, $pop86, $4
	br_if   	1, $pop87       # 1: down to label69
# BB#72:                                # %for.inc.i1998
                                        #   in Loop: Header=BB18_71 Depth=2
	i64.const	$push353=, -1
	i64.add 	$8=, $8, $pop353
	i32.const	$push352=, 1
	i32.add 	$10=, $10, $pop352
	i64.const	$push351=, 1
	i64.add 	$push350=, $7, $pop351
	tee_local	$push349=, $7=, $pop350
	i64.const	$push348=, 64
	i64.lt_u	$push88=, $pop349, $pop348
	br_if   	0, $pop88       # 0: up to label70
.LBB18_73:                              # %my_clrsbll.exit2002
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop
	end_block                       # label69:
	i32.const	$push354=, -1
	i32.add 	$push89=, $10, $pop354
	i32.ne  	$push90=, $3, $pop89
	br_if   	1, $pop90       # 1: down to label33
# BB#74:                                # %if.end127
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.popcnt	$7=, $9
	i32.const	$10=, 0
	i64.const	$8=, 0
.LBB18_75:                              # %for.body.i2086
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label71:
	i64.const	$push360=, 1
	i64.shl 	$push91=, $pop360, $8
	i64.and 	$push92=, $pop91, $9
	i64.const	$push359=, 0
	i64.ne  	$push93=, $pop92, $pop359
	i32.add 	$10=, $10, $pop93
	i64.const	$push358=, 1
	i64.add 	$push357=, $8, $pop358
	tee_local	$push356=, $8=, $pop357
	i64.const	$push355=, 64
	i64.ne  	$push94=, $pop356, $pop355
	br_if   	0, $pop94       # 0: up to label71
# BB#76:                                # %my_popcountll.exit2088
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop
	i32.wrap/i64	$push95=, $7
	i32.ne  	$push96=, $10, $pop95
	br_if   	1, $pop96       # 1: down to label33
# BB#77:                                # %for.body.i2172.preheader
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.const	$3=, 0
	i64.const	$8=, 0
.LBB18_78:                              # %for.body.i2172
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label72:
	i64.const	$push366=, 1
	i64.shl 	$push97=, $pop366, $8
	i64.and 	$push98=, $pop97, $9
	i64.const	$push365=, 0
	i64.ne  	$push99=, $pop98, $pop365
	i32.add 	$3=, $3, $pop99
	i64.const	$push364=, 1
	i64.add 	$push363=, $8, $pop364
	tee_local	$push362=, $8=, $pop363
	i64.const	$push361=, 64
	i64.ne  	$push100=, $pop362, $pop361
	br_if   	0, $pop100      # 0: up to label72
# BB#79:                                # %my_parityll.exit2175
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop
	i32.xor 	$push101=, $3, $10
	i32.const	$push367=, 1
	i32.and 	$push102=, $pop101, $pop367
	br_if   	1, $pop102      # 1: down to label33
# BB#80:                                # %for.cond90
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.const	$push371=, 1
	i32.add 	$push370=, $5, $pop371
	tee_local	$push369=, $5=, $pop370
	i32.const	$push368=, 12
	i32.le_u	$push103=, $pop369, $pop368
	br_if   	0, $pop103      # 0: up to label60
# BB#81:                                # %if.end148
	end_loop
	i32.const	$push104=, 0
	i32.call	$push105=, __builtin_clrsb@FUNCTION, $pop104
	i32.const	$push106=, 31
	i32.ne  	$push107=, $pop105, $pop106
	br_if   	0, $pop107      # 0: down to label33
# BB#82:                                # %my_clrsb.exit2746
	i32.const	$push108=, 1
	i32.call	$push109=, __builtin_clrsb@FUNCTION, $pop108
	i32.const	$push110=, 30
	i32.ne  	$push111=, $pop109, $pop110
	br_if   	0, $pop111      # 0: down to label33
# BB#83:                                # %if.end198
	i32.const	$push112=, -2147483648
	i32.call	$push113=, __builtin_clrsb@FUNCTION, $pop112
	br_if   	0, $pop113      # 0: down to label33
# BB#84:                                # %my_clrsb.exit2573
	i32.const	$push114=, 1073741824
	i32.call	$push115=, __builtin_clrsb@FUNCTION, $pop114
	br_if   	0, $pop115      # 0: down to label33
# BB#85:                                # %my_clrsb.exit2490
	i32.const	$push116=, 65536
	i32.call	$push117=, __builtin_clrsb@FUNCTION, $pop116
	i32.const	$push118=, 14
	i32.ne  	$push119=, $pop117, $pop118
	br_if   	0, $pop119      # 0: down to label33
# BB#86:                                # %my_clrsb.exit2408
	i32.const	$push120=, 32768
	i32.call	$push121=, __builtin_clrsb@FUNCTION, $pop120
	i32.const	$push122=, 15
	i32.ne  	$push123=, $pop121, $pop122
	br_if   	0, $pop123      # 0: down to label33
# BB#87:                                # %my_clrsb.exit2324
	i32.const	$push124=, -1515870811
	i32.call	$push125=, __builtin_clrsb@FUNCTION, $pop124
	br_if   	0, $pop125      # 0: down to label33
# BB#88:                                # %my_clrsb.exit2249
	i32.const	$push126=, 1515870810
	i32.call	$push127=, __builtin_clrsb@FUNCTION, $pop126
	br_if   	0, $pop127      # 0: down to label33
# BB#89:                                # %for.body.i2155
	i32.const	$push128=, -889323520
	i32.call	$push129=, __builtin_clrsb@FUNCTION, $pop128
	i32.const	$push130=, 1
	i32.ne  	$push131=, $pop129, $pop130
	br_if   	0, $pop131      # 0: down to label33
# BB#90:                                # %for.body.i2069
	i32.const	$push132=, 13303296
	i32.call	$push133=, __builtin_clrsb@FUNCTION, $pop132
	i32.const	$push134=, 7
	i32.ne  	$push135=, $pop133, $pop134
	br_if   	0, $pop135      # 0: down to label33
# BB#91:                                # %for.body.i1980
	i32.const	$push136=, 51966
	i32.call	$push137=, __builtin_clrsb@FUNCTION, $pop136
	i32.const	$push138=, 15
	i32.ne  	$push139=, $pop137, $pop138
	br_if   	0, $pop139      # 0: down to label33
# BB#92:                                # %if.end423
	i32.const	$push372=, -1
	i32.call	$5=, __builtin_clrsb@FUNCTION, $pop372
	i32.const	$10=, 30
	i32.const	$3=, 1
.LBB18_93:                              # %for.body.i1911
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label74:
	i32.const	$push374=, -1
	i32.shr_u	$push140=, $pop374, $10
	i32.const	$push373=, 1
	i32.and 	$push141=, $pop140, $pop373
	i32.eqz 	$push415=, $pop141
	br_if   	1, $pop415      # 1: down to label73
# BB#94:                                # %for.inc.i1914
                                        #   in Loop: Header=BB18_93 Depth=1
	i32.const	$push379=, -1
	i32.add 	$10=, $10, $pop379
	i32.const	$push378=, 1
	i32.add 	$push377=, $3, $pop378
	tee_local	$push376=, $3=, $pop377
	i32.const	$push375=, 32
	i32.lt_u	$push142=, $pop376, $pop375
	br_if   	0, $pop142      # 0: up to label74
.LBB18_95:                              # %my_clrsb.exit1918
	end_loop
	end_block                       # label73:
	i32.const	$push143=, -1
	i32.add 	$push144=, $3, $pop143
	i32.ne  	$push145=, $5, $pop144
	br_if   	0, $pop145      # 0: down to label33
# BB#96:                                # %if.end440
	i64.const	$8=, 0
	i64.const	$push380=, 0
	i32.call	$push146=, __builtin_clrsbll@FUNCTION, $pop380
	i32.const	$push147=, 63
	i32.ne  	$push148=, $pop146, $pop147
	br_if   	0, $pop148      # 0: down to label33
# BB#97:                                # %for.body.i1822.preheader
.LBB18_98:                              # %for.body.i1822
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label76:
	i64.const	$push381=, 63
	i64.eq  	$push149=, $8, $pop381
	br_if   	1, $pop149      # 1: down to label75
# BB#99:                                # %for.inc.i1826
                                        #   in Loop: Header=BB18_98 Depth=1
	i64.const	$push385=, 1
	i64.add 	$push384=, $8, $pop385
	tee_local	$push383=, $8=, $pop384
	i64.const	$push382=, 64
	i64.lt_u	$push150=, $pop383, $pop382
	br_if   	0, $pop150      # 0: up to label76
	br      	2               # 2: down to label33
.LBB18_100:                             # %if.end465
	end_loop
	end_block                       # label75:
	i64.const	$push386=, 1
	i32.call	$10=, __builtin_clrsbll@FUNCTION, $pop386
	i64.const	$8=, 1
.LBB18_101:                             # %for.body.i1779
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	loop    	                # label79:
	i64.const	$push387=, 63
	i64.eq  	$push151=, $8, $pop387
	br_if   	1, $pop151      # 1: down to label78
# BB#102:                               # %for.inc.i1783
                                        #   in Loop: Header=BB18_101 Depth=1
	i64.const	$push391=, 1
	i64.add 	$push390=, $8, $pop391
	tee_local	$push389=, $8=, $pop390
	i64.const	$push388=, 64
	i64.lt_u	$push152=, $pop389, $pop388
	br_if   	0, $pop152      # 0: up to label79
# BB#103:
	end_loop
	i32.const	$push199=, 63
	i32.eq  	$push154=, $10, $pop199
	br_if   	1, $pop154      # 1: down to label77
	br      	2               # 2: down to label33
.LBB18_104:
	end_block                       # label78:
	i32.const	$push200=, 62
	i32.ne  	$push153=, $10, $pop200
	br_if   	1, $pop153      # 1: down to label33
.LBB18_105:                             # %for.body.i1739.preheader
	end_block                       # label77:
	i64.const	$8=, 0
.LBB18_106:                             # %for.body.i1739
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label81:
	i64.const	$push392=, 63
	i64.eq  	$push155=, $8, $pop392
	br_if   	1, $pop155      # 1: down to label80
# BB#107:                               # %for.inc.i1743
                                        #   in Loop: Header=BB18_106 Depth=1
	i64.const	$push396=, 1
	i64.add 	$push395=, $8, $pop396
	tee_local	$push394=, $8=, $pop395
	i64.const	$push393=, 64
	i64.lt_u	$push156=, $pop394, $pop393
	br_if   	0, $pop156      # 0: up to label81
	br      	2               # 2: down to label33
.LBB18_108:                             # %for.body.i1713.preheader
	end_loop
	end_block                       # label80:
	i64.const	$8=, 0
.LBB18_109:                             # %for.body.i1713
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label83:
	i64.const	$push397=, 63
	i64.eq  	$push157=, $8, $pop397
	br_if   	1, $pop157      # 1: down to label82
# BB#110:                               # %for.inc.i1717
                                        #   in Loop: Header=BB18_109 Depth=1
	i64.const	$push401=, 1
	i64.add 	$push400=, $8, $pop401
	tee_local	$push399=, $8=, $pop400
	i64.const	$push398=, 64
	i64.lt_u	$push158=, $pop399, $pop398
	br_if   	0, $pop158      # 0: up to label83
	br      	2               # 2: down to label33
.LBB18_111:                             # %if.end490
	end_loop
	end_block                       # label82:
	i64.const	$push159=, -9223372036854775808
	i32.call	$push160=, __builtin_clrsbll@FUNCTION, $pop159
	br_if   	0, $pop160      # 0: down to label33
# BB#112:                               # %for.body.i1596
	i64.const	$push161=, 2
	i32.call	$push162=, __builtin_clrsbll@FUNCTION, $pop161
	i32.const	$push163=, 61
	i32.ne  	$push164=, $pop162, $pop163
	br_if   	0, $pop164      # 0: down to label33
# BB#113:                               # %my_clrsbll.exit1511
	i64.const	$push165=, 4611686018427387904
	i32.call	$push166=, __builtin_clrsbll@FUNCTION, $pop165
	br_if   	0, $pop166      # 0: down to label33
# BB#114:                               # %for.body.i1413
	i64.const	$push167=, 4294967296
	i32.call	$push168=, __builtin_clrsbll@FUNCTION, $pop167
	i32.const	$push169=, 30
	i32.ne  	$push170=, $pop168, $pop169
	br_if   	0, $pop170      # 0: down to label33
# BB#115:                               # %for.body.i1322
	i64.const	$push171=, 2147483648
	i32.call	$push172=, __builtin_clrsbll@FUNCTION, $pop171
	i32.const	$push173=, 31
	i32.ne  	$push174=, $pop172, $pop173
	br_if   	0, $pop174      # 0: down to label33
# BB#116:                               # %my_clrsbll.exit1237
	i64.const	$push175=, -6510615555426900571
	i32.call	$push176=, __builtin_clrsbll@FUNCTION, $pop175
	br_if   	0, $pop176      # 0: down to label33
# BB#117:                               # %my_clrsbll.exit1146
	i64.const	$push177=, 6510615555426900570
	i32.call	$push178=, __builtin_clrsbll@FUNCTION, $pop177
	br_if   	0, $pop178      # 0: down to label33
# BB#118:                               # %for.body.i1049
	i64.const	$push179=, -3819392241693097984
	i32.call	$push180=, __builtin_clrsbll@FUNCTION, $pop179
	i32.const	$push181=, 1
	i32.ne  	$push182=, $pop180, $pop181
	br_if   	0, $pop182      # 0: down to label33
# BB#119:                               # %for.body.i962
	i64.const	$push183=, 223195676147712
	i32.call	$push184=, __builtin_clrsbll@FUNCTION, $pop183
	i32.const	$push185=, 15
	i32.ne  	$push186=, $pop184, $pop185
	br_if   	0, $pop186      # 0: down to label33
# BB#120:                               # %for.body.i876
	i64.const	$push187=, 3405695742
	i32.call	$push188=, __builtin_clrsbll@FUNCTION, $pop187
	i32.const	$push189=, 31
	i32.ne  	$push190=, $pop188, $pop189
	br_if   	0, $pop190      # 0: down to label33
# BB#121:                               # %if.end740
	i64.const	$push402=, -1
	i32.call	$3=, __builtin_clrsbll@FUNCTION, $pop402
	i64.const	$8=, 62
	i64.const	$9=, 1
	i32.const	$10=, 1
.LBB18_122:                             # %for.body.i812
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label85:
	i64.const	$push404=, -1
	i64.shr_u	$push191=, $pop404, $8
	i64.const	$push403=, 1
	i64.and 	$push192=, $pop191, $pop403
	i64.eqz 	$push193=, $pop192
	br_if   	1, $pop193      # 1: down to label84
# BB#123:                               # %for.inc.i816
                                        #   in Loop: Header=BB18_122 Depth=1
	i64.const	$push410=, -1
	i64.add 	$8=, $8, $pop410
	i32.const	$push409=, 1
	i32.add 	$10=, $10, $pop409
	i64.const	$push408=, 1
	i64.add 	$push407=, $9, $pop408
	tee_local	$push406=, $9=, $pop407
	i64.const	$push405=, 64
	i64.lt_u	$push194=, $pop406, $pop405
	br_if   	0, $pop194      # 0: up to label85
.LBB18_124:                             # %my_clrsbll.exit
	end_loop
	end_block                       # label84:
	i32.const	$push195=, -1
	i32.add 	$push196=, $10, $pop195
	i32.ne  	$push197=, $3, $pop196
	br_if   	0, $pop197      # 0: down to label33
# BB#125:                               # %if.end753
	i32.const	$push198=, 0
	call    	exit@FUNCTION, $pop198
	unreachable
.LBB18_126:                             # %if.then
	end_block                       # label33:
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	__builtin_clrsb, i32
	.functype	__builtin_clrsbl, i32
	.functype	__builtin_clrsbll, i32
	.functype	exit, void, i32
