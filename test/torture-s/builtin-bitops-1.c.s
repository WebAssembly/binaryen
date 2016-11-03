	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-bitops-1.c"
	.section	.text.my_ffs,"ax",@progbits
	.hidden	my_ffs
	.globl	my_ffs
	.type	my_ffs,@function
my_ffs:                                 # @my_ffs
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push12=, $0
	br_if   	0, $pop12       # 0: down to label0
# BB#1:                                 # %for.cond.preheader
	i32.const	$2=, 1
.LBB0_2:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	copy_local	$push9=, $2
	tee_local	$push8=, $3=, $pop9
	i32.const	$push7=, -1
	i32.add 	$push6=, $pop8, $pop7
	tee_local	$push5=, $1=, $pop6
	i32.const	$push4=, 31
	i32.gt_u	$push0=, $pop5, $pop4
	br_if   	1, $pop0        # 1: down to label1
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push11=, 1
	i32.add 	$2=, $3, $pop11
	i32.const	$push10=, 1
	i32.shl 	$push1=, $pop10, $1
	i32.and 	$push2=, $pop1, $0
	i32.eqz 	$push13=, $pop2
	br_if   	0, $pop13       # 0: up to label2
.LBB0_4:                                # %cleanup
	end_loop
	end_block                       # label1:
	return  	$3
.LBB0_5:
	end_block                       # label0:
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
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
	i32.add 	$1=, $pop2, $1
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
	i32.add 	$1=, $pop2, $1
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push12=, $0
	br_if   	0, $pop12       # 0: down to label11
# BB#1:                                 # %for.cond.preheader
	i32.const	$2=, 1
.LBB6_2:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label13:
	copy_local	$push9=, $2
	tee_local	$push8=, $3=, $pop9
	i32.const	$push7=, -1
	i32.add 	$push6=, $pop8, $pop7
	tee_local	$push5=, $1=, $pop6
	i32.const	$push4=, 31
	i32.gt_u	$push0=, $pop5, $pop4
	br_if   	1, $pop0        # 1: down to label12
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB6_2 Depth=1
	i32.const	$push11=, 1
	i32.add 	$2=, $3, $pop11
	i32.const	$push10=, 1
	i32.shl 	$push1=, $pop10, $1
	i32.and 	$push2=, $pop1, $0
	i32.eqz 	$push13=, $pop2
	br_if   	0, $pop13       # 0: up to label13
.LBB6_4:                                # %cleanup
	end_loop
	end_block                       # label12:
	return  	$3
.LBB6_5:
	end_block                       # label11:
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
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
	i32.add 	$1=, $pop2, $1
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
	i32.add 	$1=, $pop2, $1
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
	.local  	i64, i32, i64, i32
# BB#0:                                 # %entry
	block   	
	i64.eqz 	$push1=, $0
	br_if   	0, $pop1        # 0: down to label22
# BB#1:                                 # %for.cond.preheader
	i64.const	$3=, 0
	i32.const	$2=, 1
.LBB12_2:                               # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label24:
	copy_local	$4=, $2
	i64.const	$push6=, 63
	i64.gt_u	$push2=, $3, $pop6
	br_if   	1, $pop2        # 1: down to label23
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB12_2 Depth=1
	i32.const	$push9=, 1
	i32.add 	$2=, $4, $pop9
	i64.const	$push8=, 1
	i64.shl 	$1=, $pop8, $3
	i64.const	$push7=, 1
	i64.add 	$push0=, $3, $pop7
	copy_local	$3=, $pop0
	i64.and 	$push3=, $1, $0
	i64.eqz 	$push4=, $pop3
	br_if   	0, $pop4        # 0: up to label24
.LBB12_4:                               # %cleanup
	end_loop
	end_block                       # label23:
	return  	$4
.LBB12_5:
	end_block                       # label22:
	i32.const	$push5=, 0
                                        # fallthrough-return: $pop5
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
	i32.add 	$2=, $pop2, $2
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
	i32.add 	$2=, $pop2, $2
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
	block   	
	loop    	                # label35:
	i32.const	$push208=, 2
	i32.shl 	$push1=, $0, $pop208
	i32.const	$push207=, ints
	i32.add 	$push206=, $pop1, $pop207
	tee_local	$push205=, $1=, $pop206
	i32.load	$push204=, 0($pop205)
	tee_local	$push203=, $10=, $pop204
	i32.ctz 	$push202=, $pop203
	tee_local	$push201=, $2=, $pop202
	i32.const	$push200=, 1
	i32.add 	$push2=, $pop201, $pop200
	i32.const	$push199=, 0
	i32.select	$6=, $pop2, $pop199, $10
	i32.const	$3=, 0
	block   	
	i32.eqz 	$push400=, $10
	br_if   	0, $pop400      # 0: down to label36
# BB#2:                                 # %for.cond.i.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$5=, 0
.LBB18_3:                               # %for.cond.i
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label38:
	copy_local	$push211=, $5
	tee_local	$push210=, $3=, $pop211
	i32.const	$push209=, 31
	i32.gt_u	$push3=, $pop210, $pop209
	br_if   	1, $pop3        # 1: down to label37
# BB#4:                                 # %for.body.i
                                        #   in Loop: Header=BB18_3 Depth=2
	i32.const	$push213=, 1
	i32.add 	$5=, $3, $pop213
	i32.const	$push212=, 1
	i32.shl 	$push4=, $pop212, $3
	i32.and 	$push5=, $pop4, $10
	i32.eqz 	$push401=, $pop5
	br_if   	0, $pop401      # 0: up to label38
.LBB18_5:                               # %my_ffs.exit.loopexit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	end_block                       # label37:
	i32.const	$push214=, 1
	i32.add 	$3=, $3, $pop214
.LBB18_6:                               # %my_ffs.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label36:
	i32.ne  	$push6=, $6, $3
	br_if   	1, $pop6        # 1: down to label34
# BB#7:                                 # %if.end
                                        #   in Loop: Header=BB18_1 Depth=1
	block   	
	i32.eqz 	$push402=, $10
	br_if   	0, $pop402      # 0: down to label39
# BB#8:                                 # %land.lhs.true
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.clz 	$6=, $10
	i32.const	$5=, 0
	i32.const	$3=, 31
.LBB18_9:                               # %for.body.i816
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label41:
	i32.const	$push215=, 1
	i32.shl 	$push7=, $pop215, $3
	i32.and 	$push8=, $pop7, $10
	br_if   	1, $pop8        # 1: down to label40
# BB#10:                                # %for.inc.i819
                                        #   in Loop: Header=BB18_9 Depth=2
	i32.const	$push220=, -1
	i32.add 	$3=, $3, $pop220
	i32.const	$push219=, 1
	i32.add 	$push218=, $5, $pop219
	tee_local	$push217=, $5=, $pop218
	i32.const	$push216=, 32
	i32.lt_u	$push9=, $pop217, $pop216
	br_if   	0, $pop9        # 0: up to label41
.LBB18_11:                              # %my_clz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	end_block                       # label40:
	i32.ne  	$push10=, $6, $5
	br_if   	2, $pop10       # 2: down to label34
# BB#12:                                # %land.lhs.true13
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$3=, 0
.LBB18_13:                              # %for.body.i875
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label43:
	i32.const	$push221=, 1
	i32.shl 	$push11=, $pop221, $3
	i32.and 	$push12=, $pop11, $10
	br_if   	1, $pop12       # 1: down to label42
# BB#14:                                # %for.inc.i878
                                        #   in Loop: Header=BB18_13 Depth=2
	i32.const	$push225=, 1
	i32.add 	$push224=, $3, $pop225
	tee_local	$push223=, $3=, $pop224
	i32.const	$push222=, 32
	i32.lt_u	$push13=, $pop223, $pop222
	br_if   	0, $pop13       # 0: up to label43
.LBB18_15:                              # %my_ctz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	end_block                       # label42:
	i32.ne  	$push14=, $2, $3
	br_if   	2, $pop14       # 2: down to label34
.LBB18_16:                              # %if.end19
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label39:
	i32.call	$2=, __builtin_clrsb@FUNCTION, $10
	i32.load	$push228=, 0($1)
	tee_local	$push227=, $3=, $pop228
	i32.const	$push226=, 31
	i32.shr_u	$6=, $pop227, $pop226
	i32.const	$5=, 1
	i32.const	$10=, 30
.LBB18_17:                              # %for.body.i948
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label45:
	i32.shr_u	$push15=, $3, $10
	i32.const	$push229=, 1
	i32.and 	$push16=, $pop15, $pop229
	i32.ne  	$push17=, $pop16, $6
	br_if   	1, $pop17       # 1: down to label44
# BB#18:                                # %for.inc.i951
                                        #   in Loop: Header=BB18_17 Depth=2
	i32.const	$push234=, -1
	i32.add 	$10=, $10, $pop234
	i32.const	$push233=, 1
	i32.add 	$push232=, $5, $pop233
	tee_local	$push231=, $5=, $pop232
	i32.const	$push230=, 32
	i32.lt_u	$push18=, $pop231, $pop230
	br_if   	0, $pop18       # 0: up to label45
.LBB18_19:                              # %my_clrsb.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	end_block                       # label44:
	i32.const	$push235=, -1
	i32.add 	$push19=, $5, $pop235
	i32.ne  	$push20=, $2, $pop19
	br_if   	1, $pop20       # 1: down to label34
# BB#20:                                # %for.body.i1030.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$5=, 0
	i32.const	$10=, 0
.LBB18_21:                              # %for.body.i1030
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label46:
	i32.const	$push241=, 1
	i32.shl 	$push21=, $pop241, $10
	i32.and 	$push22=, $pop21, $3
	i32.const	$push240=, 0
	i32.ne  	$push23=, $pop22, $pop240
	i32.add 	$5=, $pop23, $5
	i32.const	$push239=, 1
	i32.add 	$push238=, $10, $pop239
	tee_local	$push237=, $10=, $pop238
	i32.const	$push236=, 32
	i32.ne  	$push24=, $pop237, $pop236
	br_if   	0, $pop24       # 0: up to label46
# BB#22:                                # %my_popcount.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	i32.popcnt	$push25=, $3
	i32.ne  	$push26=, $pop25, $5
	br_if   	1, $pop26       # 1: down to label34
# BB#23:                                # %for.body.i1109.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$6=, 0
	i32.const	$10=, 0
.LBB18_24:                              # %for.body.i1109
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label47:
	i32.const	$push247=, 1
	i32.shl 	$push27=, $pop247, $10
	i32.and 	$push28=, $pop27, $3
	i32.const	$push246=, 0
	i32.ne  	$push29=, $pop28, $pop246
	i32.add 	$6=, $pop29, $6
	i32.const	$push245=, 1
	i32.add 	$push244=, $10, $pop245
	tee_local	$push243=, $10=, $pop244
	i32.const	$push242=, 32
	i32.ne  	$push30=, $pop243, $pop242
	br_if   	0, $pop30       # 0: up to label47
# BB#25:                                # %my_parity.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	i32.xor 	$push31=, $6, $5
	i32.const	$push248=, 1
	i32.and 	$push32=, $pop31, $pop248
	br_if   	1, $pop32       # 1: down to label34
# BB#26:                                # %for.cond
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$push252=, 1
	i32.add 	$push251=, $0, $pop252
	tee_local	$push250=, $0=, $pop251
	i32.const	$push249=, 13
	i32.lt_u	$push33=, $pop250, $pop249
	br_if   	0, $pop33       # 0: up to label35
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
	loop    	                # label48:
	i32.const	$push262=, 2
	i32.shl 	$push34=, $0, $pop262
	i32.const	$push261=, longs
	i32.add 	$push260=, $pop34, $pop261
	tee_local	$push259=, $1=, $pop260
	i32.load	$push258=, 0($pop259)
	tee_local	$push257=, $10=, $pop258
	i32.ctz 	$push256=, $pop257
	tee_local	$push255=, $2=, $pop256
	i32.const	$push254=, 1
	i32.add 	$push35=, $pop255, $pop254
	i32.const	$push253=, 0
	i32.select	$6=, $pop35, $pop253, $10
	i32.const	$3=, 0
	block   	
	i32.eqz 	$push403=, $10
	br_if   	0, $pop403      # 0: down to label49
# BB#29:                                # %for.cond.i1185.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$5=, 0
.LBB18_30:                              # %for.cond.i1185
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label51:
	copy_local	$push265=, $5
	tee_local	$push264=, $3=, $pop265
	i32.const	$push263=, 31
	i32.gt_u	$push36=, $pop264, $pop263
	br_if   	1, $pop36       # 1: down to label50
# BB#31:                                # %for.body.i1189
                                        #   in Loop: Header=BB18_30 Depth=2
	i32.const	$push267=, 1
	i32.add 	$5=, $3, $pop267
	i32.const	$push266=, 1
	i32.shl 	$push37=, $pop266, $3
	i32.and 	$push38=, $pop37, $10
	i32.eqz 	$push404=, $pop38
	br_if   	0, $pop404      # 0: up to label51
.LBB18_32:                              # %my_ffsl.exit.loopexit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop
	end_block                       # label50:
	i32.const	$push268=, 1
	i32.add 	$3=, $3, $pop268
.LBB18_33:                              # %my_ffsl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_block                       # label49:
	i32.ne  	$push39=, $6, $3
	br_if   	1, $pop39       # 1: down to label34
# BB#34:                                # %if.end49
                                        #   in Loop: Header=BB18_28 Depth=1
	block   	
	i32.eqz 	$push405=, $10
	br_if   	0, $pop405      # 0: down to label52
# BB#35:                                # %land.lhs.true52
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.clz 	$6=, $10
	i32.const	$5=, 0
	i32.const	$3=, 31
.LBB18_36:                              # %for.body.i1266
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label54:
	i32.const	$push269=, 1
	i32.shl 	$push40=, $pop269, $3
	i32.and 	$push41=, $pop40, $10
	br_if   	1, $pop41       # 1: down to label53
# BB#37:                                # %for.inc.i1269
                                        #   in Loop: Header=BB18_36 Depth=2
	i32.const	$push274=, -1
	i32.add 	$3=, $3, $pop274
	i32.const	$push273=, 1
	i32.add 	$push272=, $5, $pop273
	tee_local	$push271=, $5=, $pop272
	i32.const	$push270=, 32
	i32.lt_u	$push42=, $pop271, $pop270
	br_if   	0, $pop42       # 0: up to label54
.LBB18_38:                              # %my_clzl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop
	end_block                       # label53:
	i32.ne  	$push43=, $6, $5
	br_if   	2, $pop43       # 2: down to label34
# BB#39:                                # %land.lhs.true61
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$3=, 0
.LBB18_40:                              # %for.body.i1345
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label56:
	i32.const	$push275=, 1
	i32.shl 	$push44=, $pop275, $3
	i32.and 	$push45=, $pop44, $10
	br_if   	1, $pop45       # 1: down to label55
# BB#41:                                # %for.inc.i1348
                                        #   in Loop: Header=BB18_40 Depth=2
	i32.const	$push279=, 1
	i32.add 	$push278=, $3, $pop279
	tee_local	$push277=, $3=, $pop278
	i32.const	$push276=, 32
	i32.lt_u	$push46=, $pop277, $pop276
	br_if   	0, $pop46       # 0: up to label56
.LBB18_42:                              # %my_ctzl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop
	end_block                       # label55:
	i32.ne  	$push47=, $2, $3
	br_if   	2, $pop47       # 2: down to label34
.LBB18_43:                              # %if.end67
                                        #   in Loop: Header=BB18_28 Depth=1
	end_block                       # label52:
	i32.call	$2=, __builtin_clrsbl@FUNCTION, $10
	i32.load	$push282=, 0($1)
	tee_local	$push281=, $3=, $pop282
	i32.const	$push280=, 31
	i32.shr_u	$6=, $pop281, $pop280
	i32.const	$5=, 1
	i32.const	$10=, 30
.LBB18_44:                              # %for.body.i1426
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label58:
	i32.shr_u	$push48=, $3, $10
	i32.const	$push283=, 1
	i32.and 	$push49=, $pop48, $pop283
	i32.ne  	$push50=, $pop49, $6
	br_if   	1, $pop50       # 1: down to label57
# BB#45:                                # %for.inc.i1429
                                        #   in Loop: Header=BB18_44 Depth=2
	i32.const	$push288=, -1
	i32.add 	$10=, $10, $pop288
	i32.const	$push287=, 1
	i32.add 	$push286=, $5, $pop287
	tee_local	$push285=, $5=, $pop286
	i32.const	$push284=, 32
	i32.lt_u	$push51=, $pop285, $pop284
	br_if   	0, $pop51       # 0: up to label58
.LBB18_46:                              # %my_clrsbl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop
	end_block                       # label57:
	i32.const	$push289=, -1
	i32.add 	$push52=, $5, $pop289
	i32.ne  	$push53=, $2, $pop52
	br_if   	1, $pop53       # 1: down to label34
# BB#47:                                # %for.body.i1511.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$5=, 0
	i32.const	$10=, 0
.LBB18_48:                              # %for.body.i1511
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label59:
	i32.const	$push295=, 1
	i32.shl 	$push54=, $pop295, $10
	i32.and 	$push55=, $pop54, $3
	i32.const	$push294=, 0
	i32.ne  	$push56=, $pop55, $pop294
	i32.add 	$5=, $pop56, $5
	i32.const	$push293=, 1
	i32.add 	$push292=, $10, $pop293
	tee_local	$push291=, $10=, $pop292
	i32.const	$push290=, 32
	i32.ne  	$push57=, $pop291, $pop290
	br_if   	0, $pop57       # 0: up to label59
# BB#49:                                # %my_popcountl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop
	i32.popcnt	$push58=, $3
	i32.ne  	$push59=, $pop58, $5
	br_if   	1, $pop59       # 1: down to label34
# BB#50:                                # %for.body.i1591.preheader
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$6=, 0
	i32.const	$10=, 0
.LBB18_51:                              # %for.body.i1591
                                        #   Parent Loop BB18_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label60:
	i32.const	$push301=, 1
	i32.shl 	$push60=, $pop301, $10
	i32.and 	$push61=, $pop60, $3
	i32.const	$push300=, 0
	i32.ne  	$push62=, $pop61, $pop300
	i32.add 	$6=, $pop62, $6
	i32.const	$push299=, 1
	i32.add 	$push298=, $10, $pop299
	tee_local	$push297=, $10=, $pop298
	i32.const	$push296=, 32
	i32.ne  	$push63=, $pop297, $pop296
	br_if   	0, $pop63       # 0: up to label60
# BB#52:                                # %my_parityl.exit
                                        #   in Loop: Header=BB18_28 Depth=1
	end_loop
	i32.xor 	$push64=, $6, $5
	i32.const	$push302=, 1
	i32.and 	$push65=, $pop64, $pop302
	br_if   	1, $pop65       # 1: down to label34
# BB#53:                                # %for.cond39
                                        #   in Loop: Header=BB18_28 Depth=1
	i32.const	$push306=, 1
	i32.add 	$push305=, $0, $pop306
	tee_local	$push304=, $0=, $pop305
	i32.const	$push303=, 13
	i32.lt_u	$push66=, $pop304, $pop303
	br_if   	0, $pop66       # 0: up to label48
# BB#54:                                # %for.body92.preheader
	end_loop
	i32.const	$5=, 0
.LBB18_55:                              # %for.body92
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_57 Depth 2
                                        #     Child Loop BB18_62 Depth 2
                                        #     Child Loop BB18_66 Depth 2
                                        #     Child Loop BB18_70 Depth 2
                                        #     Child Loop BB18_74 Depth 2
                                        #     Child Loop BB18_77 Depth 2
	loop    	                # label61:
	i32.const	$push318=, 0
	i32.const	$push317=, 3
	i32.shl 	$push67=, $5, $pop317
	i32.const	$push316=, longlongs
	i32.add 	$push315=, $pop67, $pop316
	tee_local	$push314=, $1=, $pop315
	i64.load	$push313=, 0($pop314)
	tee_local	$push312=, $9=, $pop313
	i64.ctz 	$push311=, $pop312
	tee_local	$push310=, $4=, $pop311
	i64.const	$push309=, 1
	i64.add 	$push68=, $pop310, $pop309
	i32.wrap/i64	$push69=, $pop68
	i64.eqz 	$push308=, $9
	tee_local	$push307=, $6=, $pop308
	i32.select	$0=, $pop318, $pop69, $pop307
	i32.const	$10=, 0
	block   	
	br_if   	0, $6           # 0: down to label62
# BB#56:                                # %for.cond.i1667.preheader
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.const	$8=, 0
	i32.const	$3=, 1
.LBB18_57:                              # %for.cond.i1667
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label63:
	copy_local	$10=, $3
	i64.const	$push319=, 63
	i64.gt_u	$push70=, $8, $pop319
	br_if   	1, $pop70       # 1: down to label62
# BB#58:                                # %for.body.i1671
                                        #   in Loop: Header=BB18_57 Depth=2
	i32.const	$push322=, 1
	i32.add 	$3=, $10, $pop322
	i64.const	$push321=, 1
	i64.shl 	$7=, $pop321, $8
	i64.const	$push320=, 1
	i64.add 	$push0=, $8, $pop320
	copy_local	$8=, $pop0
	i64.and 	$push71=, $7, $9
	i64.eqz 	$push72=, $pop71
	br_if   	0, $pop72       # 0: up to label63
.LBB18_59:                              # %my_ffsll.exit1673
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop
	end_block                       # label62:
	i32.ne  	$push73=, $0, $10
	br_if   	1, $pop73       # 1: down to label34
# BB#60:                                # %if.end100
                                        #   in Loop: Header=BB18_55 Depth=1
	block   	
	br_if   	0, $6           # 0: down to label64
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
	block   	
	loop    	                # label66:
	i64.const	$push324=, 1
	i64.shl 	$push75=, $pop324, $8
	i64.and 	$push76=, $pop75, $9
	i64.const	$push323=, 0
	i64.ne  	$push77=, $pop76, $pop323
	br_if   	1, $pop77       # 1: down to label65
# BB#63:                                # %for.inc.i1743
                                        #   in Loop: Header=BB18_62 Depth=2
	i64.const	$push330=, -1
	i64.add 	$8=, $8, $pop330
	i32.const	$push329=, 1
	i32.add 	$10=, $10, $pop329
	i64.const	$push328=, 1
	i64.add 	$push327=, $7, $pop328
	tee_local	$push326=, $7=, $pop327
	i64.const	$push325=, 64
	i64.lt_u	$push78=, $pop326, $pop325
	br_if   	0, $pop78       # 0: up to label66
.LBB18_64:                              # %my_clzll.exit1745
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop
	end_block                       # label65:
	i32.ne  	$push79=, $3, $10
	br_if   	2, $pop79       # 2: down to label34
# BB#65:                                # %land.lhs.true113
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.wrap/i64	$3=, $4
	i32.const	$10=, 0
	i64.const	$8=, 0
.LBB18_66:                              # %for.body.i1781
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label68:
	i64.const	$push332=, 1
	i64.shl 	$push80=, $pop332, $8
	i64.and 	$push81=, $pop80, $9
	i64.const	$push331=, 0
	i64.ne  	$push82=, $pop81, $pop331
	br_if   	1, $pop82       # 1: down to label67
# BB#67:                                # %for.inc.i1785
                                        #   in Loop: Header=BB18_66 Depth=2
	i32.const	$push337=, 1
	i32.add 	$10=, $10, $pop337
	i64.const	$push336=, 1
	i64.add 	$push335=, $8, $pop336
	tee_local	$push334=, $8=, $pop335
	i64.const	$push333=, 64
	i64.lt_u	$push83=, $pop334, $pop333
	br_if   	0, $pop83       # 0: up to label68
.LBB18_68:                              # %my_ctzll.exit1787
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop
	end_block                       # label67:
	i32.ne  	$push84=, $3, $10
	br_if   	2, $pop84       # 2: down to label34
.LBB18_69:                              # %if.end120
                                        #   in Loop: Header=BB18_55 Depth=1
	end_block                       # label64:
	i32.call	$3=, __builtin_clrsbll@FUNCTION, $9
	i64.load	$push340=, 0($1)
	tee_local	$push339=, $9=, $pop340
	i64.const	$push338=, 63
	i64.shr_u	$4=, $pop339, $pop338
	i32.const	$10=, 1
	i64.const	$7=, 1
	i64.const	$8=, 62
.LBB18_70:                              # %for.body.i1845
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label70:
	i64.shr_u	$push85=, $9, $8
	i64.const	$push341=, 1
	i64.and 	$push86=, $pop85, $pop341
	i64.ne  	$push87=, $pop86, $4
	br_if   	1, $pop87       # 1: down to label69
# BB#71:                                # %for.inc.i1849
                                        #   in Loop: Header=BB18_70 Depth=2
	i64.const	$push347=, -1
	i64.add 	$8=, $8, $pop347
	i32.const	$push346=, 1
	i32.add 	$10=, $10, $pop346
	i64.const	$push345=, 1
	i64.add 	$push344=, $7, $pop345
	tee_local	$push343=, $7=, $pop344
	i64.const	$push342=, 64
	i64.lt_u	$push88=, $pop343, $pop342
	br_if   	0, $pop88       # 0: up to label70
.LBB18_72:                              # %my_clrsbll.exit1852
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop
	end_block                       # label69:
	i32.const	$push348=, -1
	i32.add 	$push89=, $10, $pop348
	i32.ne  	$push90=, $3, $pop89
	br_if   	1, $pop90       # 1: down to label34
# BB#73:                                # %if.end127
                                        #   in Loop: Header=BB18_55 Depth=1
	i64.popcnt	$7=, $9
	i32.const	$10=, 0
	i64.const	$8=, 0
.LBB18_74:                              # %for.body.i1928
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label71:
	i64.const	$push354=, 1
	i64.shl 	$push91=, $pop354, $8
	i64.and 	$push92=, $pop91, $9
	i64.const	$push353=, 0
	i64.ne  	$push93=, $pop92, $pop353
	i32.add 	$10=, $pop93, $10
	i64.const	$push352=, 1
	i64.add 	$push351=, $8, $pop352
	tee_local	$push350=, $8=, $pop351
	i64.const	$push349=, 64
	i64.ne  	$push94=, $pop350, $pop349
	br_if   	0, $pop94       # 0: up to label71
# BB#75:                                # %my_popcountll.exit1929
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop
	i32.wrap/i64	$push95=, $7
	i32.ne  	$push96=, $pop95, $10
	br_if   	1, $pop96       # 1: down to label34
# BB#76:                                # %for.body.i2005.preheader
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.const	$3=, 0
	i64.const	$8=, 0
.LBB18_77:                              # %for.body.i2005
                                        #   Parent Loop BB18_55 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label72:
	i64.const	$push360=, 1
	i64.shl 	$push97=, $pop360, $8
	i64.and 	$push98=, $pop97, $9
	i64.const	$push359=, 0
	i64.ne  	$push99=, $pop98, $pop359
	i32.add 	$3=, $pop99, $3
	i64.const	$push358=, 1
	i64.add 	$push357=, $8, $pop358
	tee_local	$push356=, $8=, $pop357
	i64.const	$push355=, 64
	i64.ne  	$push100=, $pop356, $pop355
	br_if   	0, $pop100      # 0: up to label72
# BB#78:                                # %my_parityll.exit2007
                                        #   in Loop: Header=BB18_55 Depth=1
	end_loop
	i32.xor 	$push101=, $3, $10
	i32.const	$push361=, 1
	i32.and 	$push102=, $pop101, $pop361
	br_if   	2, $pop102      # 2: down to label33
# BB#79:                                # %for.cond90
                                        #   in Loop: Header=BB18_55 Depth=1
	i32.const	$push365=, 1
	i32.add 	$push364=, $5, $pop365
	tee_local	$push363=, $5=, $pop364
	i32.const	$push362=, 12
	i32.le_u	$push103=, $pop363, $pop362
	br_if   	0, $pop103      # 0: up to label61
# BB#80:                                # %if.end148
	end_loop
	i32.const	$push104=, 0
	i32.call	$push105=, __builtin_clrsb@FUNCTION, $pop104
	i32.const	$push106=, 31
	i32.ne  	$push107=, $pop105, $pop106
	br_if   	0, $pop107      # 0: down to label34
# BB#81:                                # %my_clrsb.exit2515
	i32.const	$push108=, 1
	i32.call	$push109=, __builtin_clrsb@FUNCTION, $pop108
	i32.const	$push110=, 30
	i32.ne  	$push111=, $pop109, $pop110
	br_if   	0, $pop111      # 0: down to label34
# BB#82:                                # %if.end198
	i32.const	$push112=, -2147483648
	i32.call	$push113=, __builtin_clrsb@FUNCTION, $pop112
	br_if   	0, $pop113      # 0: down to label34
# BB#83:                                # %my_clrsb.exit2362
	i32.const	$push114=, 1073741824
	i32.call	$push115=, __builtin_clrsb@FUNCTION, $pop114
	br_if   	0, $pop115      # 0: down to label34
# BB#84:                                # %my_clrsb.exit2288
	i32.const	$push116=, 65536
	i32.call	$push117=, __builtin_clrsb@FUNCTION, $pop116
	i32.const	$push118=, 14
	i32.ne  	$push119=, $pop117, $pop118
	br_if   	0, $pop119      # 0: down to label34
# BB#85:                                # %my_clrsb.exit2215
	i32.const	$push120=, 32768
	i32.call	$push121=, __builtin_clrsb@FUNCTION, $pop120
	i32.const	$push122=, 15
	i32.ne  	$push123=, $pop121, $pop122
	br_if   	0, $pop123      # 0: down to label34
# BB#86:                                # %my_clrsb.exit2140
	i32.const	$push124=, -1515870811
	i32.call	$push125=, __builtin_clrsb@FUNCTION, $pop124
	br_if   	0, $pop125      # 0: down to label34
# BB#87:                                # %my_clrsb.exit2073
	i32.const	$push126=, 1515870810
	i32.call	$push127=, __builtin_clrsb@FUNCTION, $pop126
	br_if   	0, $pop127      # 0: down to label34
# BB#88:                                # %for.body.i1989
	i32.const	$push128=, -889323520
	i32.call	$push129=, __builtin_clrsb@FUNCTION, $pop128
	i32.const	$push130=, 1
	i32.ne  	$push131=, $pop129, $pop130
	br_if   	0, $pop131      # 0: down to label34
# BB#89:                                # %for.body.i1912
	i32.const	$push132=, 13303296
	i32.call	$push133=, __builtin_clrsb@FUNCTION, $pop132
	i32.const	$push134=, 7
	i32.ne  	$push135=, $pop133, $pop134
	br_if   	0, $pop135      # 0: down to label34
# BB#90:                                # %for.body.i1832
	i32.const	$push136=, 51966
	i32.call	$push137=, __builtin_clrsb@FUNCTION, $pop136
	i32.const	$push138=, 15
	i32.ne  	$push139=, $pop137, $pop138
	br_if   	0, $pop139      # 0: down to label34
# BB#91:                                # %if.end423
	i32.const	$push366=, -1
	i32.call	$5=, __builtin_clrsb@FUNCTION, $pop366
	i32.const	$10=, 30
	i32.const	$3=, 1
.LBB18_92:                              # %for.body.i1769
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label74:
	i32.const	$push368=, -1
	i32.shr_u	$push140=, $pop368, $10
	i32.const	$push367=, 1
	i32.and 	$push141=, $pop140, $pop367
	i32.eqz 	$push406=, $pop141
	br_if   	1, $pop406      # 1: down to label73
# BB#93:                                # %for.inc.i1772
                                        #   in Loop: Header=BB18_92 Depth=1
	i32.const	$push373=, -1
	i32.add 	$10=, $10, $pop373
	i32.const	$push372=, 1
	i32.add 	$push371=, $3, $pop372
	tee_local	$push370=, $3=, $pop371
	i32.const	$push369=, 32
	i32.lt_u	$push142=, $pop370, $pop369
	br_if   	0, $pop142      # 0: up to label74
.LBB18_94:                              # %my_clrsb.exit1775
	end_loop
	end_block                       # label73:
	i32.const	$push143=, -1
	i32.add 	$push144=, $3, $pop143
	i32.ne  	$push145=, $5, $pop144
	br_if   	0, $pop145      # 0: down to label34
# BB#95:                                # %if.end440
	i64.const	$8=, 0
	i64.const	$push374=, 0
	i32.call	$push146=, __builtin_clrsbll@FUNCTION, $pop374
	i32.const	$push147=, 63
	i32.ne  	$push148=, $pop146, $pop147
	br_if   	0, $pop148      # 0: down to label34
# BB#96:                                # %for.body.i1691.preheader
.LBB18_97:                              # %for.body.i1691
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label76:
	i64.const	$push375=, 63
	i64.eq  	$push149=, $8, $pop375
	br_if   	1, $pop149      # 1: down to label75
# BB#98:                                # %for.inc.i1695
                                        #   in Loop: Header=BB18_97 Depth=1
	i64.const	$push379=, 1
	i64.add 	$push378=, $8, $pop379
	tee_local	$push377=, $8=, $pop378
	i64.const	$push376=, 64
	i64.lt_u	$push150=, $pop377, $pop376
	br_if   	0, $pop150      # 0: up to label76
# BB#99:                                # %if.then460
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB18_100:                             # %if.end465
	end_block                       # label75:
	i64.const	$push380=, 1
	i32.call	$10=, __builtin_clrsbll@FUNCTION, $pop380
	i64.const	$8=, 1
.LBB18_101:                             # %for.body.i1655
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	loop    	                # label79:
	i64.const	$push381=, 63
	i64.eq  	$push151=, $8, $pop381
	br_if   	1, $pop151      # 1: down to label78
# BB#102:                               # %for.inc.i1659
                                        #   in Loop: Header=BB18_101 Depth=1
	i64.const	$push385=, 1
	i64.add 	$push384=, $8, $pop385
	tee_local	$push383=, $8=, $pop384
	i64.const	$push382=, 64
	i64.lt_u	$push152=, $pop383, $pop382
	br_if   	0, $pop152      # 0: up to label79
# BB#103:
	end_loop
	i32.const	$push197=, 63
	i32.eq  	$push153=, $10, $pop197
	br_if   	1, $pop153      # 1: down to label77
	br      	2               # 2: down to label34
.LBB18_104:
	end_block                       # label78:
	i32.const	$push198=, 62
	i32.ne  	$push154=, $10, $pop198
	br_if   	1, $pop154      # 1: down to label34
.LBB18_105:                             # %for.body.i1598.preheader
	end_block                       # label77:
	i64.const	$8=, 0
.LBB18_106:                             # %for.body.i1598
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label81:
	i64.const	$push386=, 63
	i64.eq  	$push155=, $8, $pop386
	br_if   	1, $pop155      # 1: down to label80
# BB#107:                               # %for.inc.i1602
                                        #   in Loop: Header=BB18_106 Depth=1
	i64.const	$push390=, 1
	i64.add 	$push389=, $8, $pop390
	tee_local	$push388=, $8=, $pop389
	i64.const	$push387=, 64
	i64.lt_u	$push156=, $pop388, $pop387
	br_if   	0, $pop156      # 0: up to label81
# BB#108:                               # %if.then489
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB18_109:                             # %if.end490
	end_block                       # label80:
	i64.const	$push157=, -9223372036854775808
	i32.call	$push158=, __builtin_clrsbll@FUNCTION, $pop157
	br_if   	0, $pop158      # 0: down to label34
# BB#110:                               # %for.body.i1494
	i64.const	$push159=, 2
	i32.call	$push160=, __builtin_clrsbll@FUNCTION, $pop159
	i32.const	$push161=, 61
	i32.ne  	$push162=, $pop160, $pop161
	br_if   	0, $pop162      # 0: down to label34
# BB#111:                               # %my_clrsbll.exit1419
	i64.const	$push163=, 4611686018427387904
	i32.call	$push164=, __builtin_clrsbll@FUNCTION, $pop163
	br_if   	0, $pop164      # 0: down to label34
# BB#112:                               # %for.body.i1333
	i64.const	$push165=, 4294967296
	i32.call	$push166=, __builtin_clrsbll@FUNCTION, $pop165
	i32.const	$push167=, 30
	i32.ne  	$push168=, $pop166, $pop167
	br_if   	0, $pop168      # 0: down to label34
# BB#113:                               # %for.body.i1253
	i64.const	$push169=, 2147483648
	i32.call	$push170=, __builtin_clrsbll@FUNCTION, $pop169
	i32.const	$push171=, 31
	i32.ne  	$push172=, $pop170, $pop171
	br_if   	0, $pop172      # 0: down to label34
# BB#114:                               # %my_clrsbll.exit1180
	i64.const	$push173=, -6510615555426900571
	i32.call	$push174=, __builtin_clrsbll@FUNCTION, $pop173
	br_if   	0, $pop174      # 0: down to label34
# BB#115:                               # %my_clrsbll.exit1100
	i64.const	$push175=, 6510615555426900570
	i32.call	$push176=, __builtin_clrsbll@FUNCTION, $pop175
	br_if   	0, $pop176      # 0: down to label34
# BB#116:                               # %for.body.i1015
	i64.const	$push177=, -3819392241693097984
	i32.call	$push178=, __builtin_clrsbll@FUNCTION, $pop177
	i32.const	$push179=, 1
	i32.ne  	$push180=, $pop178, $pop179
	br_if   	0, $pop180      # 0: down to label34
# BB#117:                               # %for.body.i939
	i64.const	$push181=, 223195676147712
	i32.call	$push182=, __builtin_clrsbll@FUNCTION, $pop181
	i32.const	$push183=, 15
	i32.ne  	$push184=, $pop182, $pop183
	br_if   	0, $pop184      # 0: down to label34
# BB#118:                               # %for.body.i864
	i64.const	$push185=, 3405695742
	i32.call	$push186=, __builtin_clrsbll@FUNCTION, $pop185
	i32.const	$push187=, 31
	i32.ne  	$push188=, $pop186, $pop187
	br_if   	0, $pop188      # 0: down to label34
# BB#119:                               # %if.end740
	i64.const	$push391=, -1
	i32.call	$3=, __builtin_clrsbll@FUNCTION, $pop391
	i64.const	$8=, 62
	i64.const	$9=, 1
	i32.const	$10=, 1
.LBB18_120:                             # %for.body.i810
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label83:
	i64.const	$push393=, -1
	i64.shr_u	$push189=, $pop393, $8
	i64.const	$push392=, 1
	i64.and 	$push190=, $pop189, $pop392
	i64.eqz 	$push191=, $pop190
	br_if   	1, $pop191      # 1: down to label82
# BB#121:                               # %for.inc.i
                                        #   in Loop: Header=BB18_120 Depth=1
	i64.const	$push399=, -1
	i64.add 	$8=, $8, $pop399
	i32.const	$push398=, 1
	i32.add 	$10=, $10, $pop398
	i64.const	$push397=, 1
	i64.add 	$push396=, $9, $pop397
	tee_local	$push395=, $9=, $pop396
	i64.const	$push394=, 64
	i64.lt_u	$push192=, $pop395, $pop394
	br_if   	0, $pop192      # 0: up to label83
.LBB18_122:                             # %my_clrsbll.exit
	end_loop
	end_block                       # label82:
	i32.const	$push193=, -1
	i32.add 	$push194=, $10, $pop193
	i32.ne  	$push195=, $3, $pop194
	br_if   	0, $pop195      # 0: down to label34
# BB#123:                               # %if.end753
	i32.const	$push196=, 0
	call    	exit@FUNCTION, $pop196
	unreachable
.LBB18_124:                             # %if.then37
	end_block                       # label34:
	call    	abort@FUNCTION
	unreachable
.LBB18_125:                             # %if.then140
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	__builtin_clrsb, i32
	.functype	__builtin_clrsbl, i32
	.functype	__builtin_clrsbll, i32
	.functype	exit, void, i32
