	.text
	.file	"builtin-bitops-1.c"
	.section	.text.my_ffs,"ax",@progbits
	.hidden	my_ffs                  # -- Begin function my_ffs
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
                                        # -- End function
	.section	.text.my_ctz,"ax",@progbits
	.hidden	my_ctz                  # -- Begin function my_ctz
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
	i32.const	$push4=, 1
	i32.shl 	$push0=, $pop4, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push8=, 1
	i32.add 	$push7=, $1, $pop8
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, 32
	i32.lt_u	$push2=, $pop6, $pop5
	br_if   	0, $pop2        # 0: up to label4
# BB#3:                                 # %for.end
	end_loop
	i32.const	$push9=, 32
	return  	$pop9
.LBB1_4:
	end_block                       # label3:
	copy_local	$push3=, $1
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	my_ctz, .Lfunc_end1-my_ctz
                                        # -- End function
	.section	.text.my_clz,"ax",@progbits
	.hidden	my_clz                  # -- Begin function my_clz
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
	i32.const	$push4=, 1
	i32.shl 	$push0=, $pop4, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label5
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push9=, -1
	i32.add 	$1=, $1, $pop9
	i32.const	$push8=, 1
	i32.add 	$push7=, $2, $pop8
	tee_local	$push6=, $2=, $pop7
	i32.const	$push5=, 32
	i32.lt_u	$push2=, $pop6, $pop5
	br_if   	0, $pop2        # 0: up to label6
# BB#3:                                 # %for.end
	end_loop
	i32.const	$push10=, 32
	return  	$pop10
.LBB2_4:
	end_block                       # label5:
	copy_local	$push3=, $2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end2:
	.size	my_clz, .Lfunc_end2-my_clz
                                        # -- End function
	.section	.text.my_clrsb,"ax",@progbits
	.hidden	my_clrsb                # -- Begin function my_clrsb
	.globl	my_clrsb
	.type	my_clrsb,@function
my_clrsb:                               # @my_clrsb
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.shr_u	$1=, $0, $pop0
	i32.const	$2=, 30
	i32.const	$3=, 1
.LBB3_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	loop    	                # label9:
	i32.shr_u	$push1=, $0, $2
	i32.const	$push7=, 1
	i32.and 	$push2=, $pop1, $pop7
	i32.ne  	$push3=, $pop2, $1
	br_if   	1, $pop3        # 1: down to label8
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$push12=, -1
	i32.add 	$2=, $2, $pop12
	i32.const	$4=, 32
	i32.const	$push11=, 1
	i32.add 	$push10=, $3, $pop11
	tee_local	$push9=, $3=, $pop10
	i32.const	$push8=, 32
	i32.lt_u	$push4=, $pop9, $pop8
	br_if   	0, $pop4        # 0: up to label9
	br      	2               # 2: down to label7
.LBB3_3:
	end_loop
	end_block                       # label8:
	copy_local	$4=, $3
.LBB3_4:                                # %for.end
	end_block                       # label7:
	i32.const	$push5=, -1
	i32.add 	$push6=, $4, $pop5
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end3:
	.size	my_clrsb, .Lfunc_end3-my_clrsb
                                        # -- End function
	.section	.text.my_popcount,"ax",@progbits
	.hidden	my_popcount             # -- Begin function my_popcount
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
	loop    	                # label10:
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
	br_if   	0, $pop3        # 0: up to label10
# BB#2:                                 # %for.end
	end_loop
	copy_local	$push10=, $1
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end4:
	.size	my_popcount, .Lfunc_end4-my_popcount
                                        # -- End function
	.section	.text.my_parity,"ax",@progbits
	.hidden	my_parity               # -- Begin function my_parity
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
	loop    	                # label11:
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
	br_if   	0, $pop3        # 0: up to label11
# BB#2:                                 # %for.end
	end_loop
	i32.const	$push4=, 1
	i32.and 	$push5=, $1, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end5:
	.size	my_parity, .Lfunc_end5-my_parity
                                        # -- End function
	.section	.text.my_ffsl,"ax",@progbits
	.hidden	my_ffsl                 # -- Begin function my_ffsl
	.globl	my_ffsl
	.type	my_ffsl,@function
my_ffsl:                                # @my_ffsl
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push11=, $0
	br_if   	0, $pop11       # 0: down to label12
# BB#1:                                 # %for.body.preheader
	i32.const	$1=, 0
.LBB6_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label14:
	i32.const	$push6=, 1
	i32.shl 	$push0=, $pop6, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label13
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB6_2 Depth=1
	i32.const	$push10=, 1
	i32.add 	$push9=, $1, $pop10
	tee_local	$push8=, $1=, $pop9
	i32.const	$push7=, 32
	i32.lt_u	$push2=, $pop8, $pop7
	br_if   	0, $pop2        # 0: up to label14
.LBB6_4:                                # %for.end
	end_loop
	end_block                       # label13:
	i32.const	$push3=, 1
	i32.add 	$push5=, $1, $pop3
	return  	$pop5
.LBB6_5:
	end_block                       # label12:
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end6:
	.size	my_ffsl, .Lfunc_end6-my_ffsl
                                        # -- End function
	.section	.text.my_ctzl,"ax",@progbits
	.hidden	my_ctzl                 # -- Begin function my_ctzl
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
	loop    	                # label16:
	i32.const	$push4=, 1
	i32.shl 	$push0=, $pop4, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label15
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.const	$push8=, 1
	i32.add 	$push7=, $1, $pop8
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, 32
	i32.lt_u	$push2=, $pop6, $pop5
	br_if   	0, $pop2        # 0: up to label16
# BB#3:                                 # %for.end
	end_loop
	i32.const	$push9=, 32
	return  	$pop9
.LBB7_4:
	end_block                       # label15:
	copy_local	$push3=, $1
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end7:
	.size	my_ctzl, .Lfunc_end7-my_ctzl
                                        # -- End function
	.section	.text.my_clzl,"ax",@progbits
	.hidden	my_clzl                 # -- Begin function my_clzl
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
	loop    	                # label18:
	i32.const	$push4=, 1
	i32.shl 	$push0=, $pop4, $1
	i32.and 	$push1=, $pop0, $0
	br_if   	1, $pop1        # 1: down to label17
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.const	$push9=, -1
	i32.add 	$1=, $1, $pop9
	i32.const	$push8=, 1
	i32.add 	$push7=, $2, $pop8
	tee_local	$push6=, $2=, $pop7
	i32.const	$push5=, 32
	i32.lt_u	$push2=, $pop6, $pop5
	br_if   	0, $pop2        # 0: up to label18
# BB#3:                                 # %for.end
	end_loop
	i32.const	$push10=, 32
	return  	$pop10
.LBB8_4:
	end_block                       # label17:
	copy_local	$push3=, $2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end8:
	.size	my_clzl, .Lfunc_end8-my_clzl
                                        # -- End function
	.section	.text.my_clrsbl,"ax",@progbits
	.hidden	my_clrsbl               # -- Begin function my_clrsbl
	.globl	my_clrsbl
	.type	my_clrsbl,@function
my_clrsbl:                              # @my_clrsbl
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.shr_u	$1=, $0, $pop0
	i32.const	$2=, 30
	i32.const	$3=, 1
.LBB9_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	loop    	                # label21:
	i32.shr_u	$push1=, $0, $2
	i32.const	$push7=, 1
	i32.and 	$push2=, $pop1, $pop7
	i32.ne  	$push3=, $pop2, $1
	br_if   	1, $pop3        # 1: down to label20
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.const	$push12=, -1
	i32.add 	$2=, $2, $pop12
	i32.const	$4=, 32
	i32.const	$push11=, 1
	i32.add 	$push10=, $3, $pop11
	tee_local	$push9=, $3=, $pop10
	i32.const	$push8=, 32
	i32.lt_u	$push4=, $pop9, $pop8
	br_if   	0, $pop4        # 0: up to label21
	br      	2               # 2: down to label19
.LBB9_3:
	end_loop
	end_block                       # label20:
	copy_local	$4=, $3
.LBB9_4:                                # %for.end
	end_block                       # label19:
	i32.const	$push5=, -1
	i32.add 	$push6=, $4, $pop5
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end9:
	.size	my_clrsbl, .Lfunc_end9-my_clrsbl
                                        # -- End function
	.section	.text.my_popcountl,"ax",@progbits
	.hidden	my_popcountl            # -- Begin function my_popcountl
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
	loop    	                # label22:
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
	br_if   	0, $pop3        # 0: up to label22
# BB#2:                                 # %for.end
	end_loop
	copy_local	$push10=, $1
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end10:
	.size	my_popcountl, .Lfunc_end10-my_popcountl
                                        # -- End function
	.section	.text.my_parityl,"ax",@progbits
	.hidden	my_parityl              # -- Begin function my_parityl
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
	loop    	                # label23:
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
	br_if   	0, $pop3        # 0: up to label23
# BB#2:                                 # %for.end
	end_loop
	i32.const	$push4=, 1
	i32.and 	$push5=, $1, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end11:
	.size	my_parityl, .Lfunc_end11-my_parityl
                                        # -- End function
	.section	.text.my_ffsll,"ax",@progbits
	.hidden	my_ffsll                # -- Begin function my_ffsll
	.globl	my_ffsll
	.type	my_ffsll,@function
my_ffsll:                               # @my_ffsll
	.param  	i64
	.result 	i32
	.local  	i64, i32
# BB#0:                                 # %entry
	block   	
	i64.eqz 	$push0=, $0
	br_if   	0, $pop0        # 0: down to label24
# BB#1:                                 # %for.body.preheader
	i32.const	$2=, 0
	i64.const	$1=, 0
.LBB12_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label26:
	i64.const	$push9=, 1
	i64.shl 	$push1=, $pop9, $1
	i64.and 	$push2=, $pop1, $0
	i64.const	$push8=, 0
	i64.ne  	$push3=, $pop2, $pop8
	br_if   	1, $pop3        # 1: down to label25
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB12_2 Depth=1
	i32.const	$push14=, 1
	i32.add 	$2=, $2, $pop14
	i64.const	$push13=, 1
	i64.add 	$push12=, $1, $pop13
	tee_local	$push11=, $1=, $pop12
	i64.const	$push10=, 64
	i64.lt_u	$push4=, $pop11, $pop10
	br_if   	0, $pop4        # 0: up to label26
.LBB12_4:                               # %for.end
	end_loop
	end_block                       # label25:
	i32.const	$push5=, 1
	i32.add 	$push7=, $2, $pop5
	return  	$pop7
.LBB12_5:
	end_block                       # label24:
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end12:
	.size	my_ffsll, .Lfunc_end12-my_ffsll
                                        # -- End function
	.section	.text.my_ctzll,"ax",@progbits
	.hidden	my_ctzll                # -- Begin function my_ctzll
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
	loop    	                # label28:
	i64.const	$push5=, 1
	i64.shl 	$push0=, $pop5, $1
	i64.and 	$push1=, $pop0, $0
	i64.const	$push4=, 0
	i64.ne  	$push2=, $pop1, $pop4
	br_if   	1, $pop2        # 1: down to label27
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB13_1 Depth=1
	i32.const	$push10=, 1
	i32.add 	$2=, $2, $pop10
	i64.const	$push9=, 1
	i64.add 	$push8=, $1, $pop9
	tee_local	$push7=, $1=, $pop8
	i64.const	$push6=, 64
	i64.lt_u	$push3=, $pop7, $pop6
	br_if   	0, $pop3        # 0: up to label28
.LBB13_3:                               # %for.end
	end_loop
	end_block                       # label27:
	copy_local	$push11=, $2
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end13:
	.size	my_ctzll, .Lfunc_end13-my_ctzll
                                        # -- End function
	.section	.text.my_clzll,"ax",@progbits
	.hidden	my_clzll                # -- Begin function my_clzll
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
	loop    	                # label30:
	i64.const	$push5=, 1
	i64.shl 	$push0=, $pop5, $1
	i64.and 	$push1=, $pop0, $0
	i64.const	$push4=, 0
	i64.ne  	$push2=, $pop1, $pop4
	br_if   	1, $pop2        # 1: down to label29
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
	br_if   	0, $pop3        # 0: up to label30
.LBB14_3:                               # %for.end
	end_loop
	end_block                       # label29:
	copy_local	$push12=, $3
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end14:
	.size	my_clzll, .Lfunc_end14-my_clzll
                                        # -- End function
	.section	.text.my_clrsbll,"ax",@progbits
	.hidden	my_clrsbll              # -- Begin function my_clrsbll
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
	loop    	                # label32:
	i64.shr_u	$push1=, $0, $2
	i64.const	$push7=, 1
	i64.and 	$push2=, $pop1, $pop7
	i64.ne  	$push3=, $pop2, $1
	br_if   	1, $pop3        # 1: down to label31
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
	br_if   	0, $pop4        # 0: up to label32
.LBB15_3:                               # %for.end
	end_loop
	end_block                       # label31:
	i32.const	$push5=, -1
	i32.add 	$push6=, $4, $pop5
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end15:
	.size	my_clrsbll, .Lfunc_end15-my_clrsbll
                                        # -- End function
	.section	.text.my_popcountll,"ax",@progbits
	.hidden	my_popcountll           # -- Begin function my_popcountll
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
	loop    	                # label33:
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
	br_if   	0, $pop3        # 0: up to label33
# BB#2:                                 # %for.end
	end_loop
	copy_local	$push10=, $2
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end16:
	.size	my_popcountll, .Lfunc_end16-my_popcountll
                                        # -- End function
	.section	.text.my_parityll,"ax",@progbits
	.hidden	my_parityll             # -- Begin function my_parityll
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
	loop    	                # label34:
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
	br_if   	0, $pop3        # 0: up to label34
# BB#2:                                 # %for.end
	end_loop
	i32.const	$push4=, 1
	i32.and 	$push5=, $2, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end17:
	.size	my_parityll, .Lfunc_end17-my_parityll
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i64, i32, i32, i32, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB18_1:                               # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_3 Depth 2
                                        #     Child Loop BB18_9 Depth 2
                                        #     Child Loop BB18_14 Depth 2
                                        #     Child Loop BB18_19 Depth 2
                                        #     Child Loop BB18_24 Depth 2
                                        #     Child Loop BB18_27 Depth 2
	block   	
	loop    	                # label36:
	i32.const	$push203=, 2
	i32.shl 	$push0=, $0, $pop203
	i32.const	$push202=, ints
	i32.add 	$push201=, $pop0, $pop202
	tee_local	$push200=, $5=, $pop201
	i32.load	$push199=, 0($pop200)
	tee_local	$push198=, $11=, $pop199
	i32.ctz 	$push197=, $pop198
	tee_local	$push196=, $2=, $pop197
	i32.const	$push195=, 1
	i32.add 	$push1=, $pop196, $pop195
	i32.const	$push194=, 0
	i32.select	$6=, $pop1, $pop194, $11
	i32.const	$3=, 0
	block   	
	i32.eqz 	$push382=, $11
	br_if   	0, $pop382      # 0: down to label37
# BB#2:                                 # %for.body.i.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$3=, 0
.LBB18_3:                               # %for.body.i
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label39:
	i32.const	$push204=, 1
	i32.shl 	$push2=, $pop204, $3
	i32.and 	$push3=, $pop2, $11
	br_if   	1, $pop3        # 1: down to label38
# BB#4:                                 # %for.inc.i
                                        #   in Loop: Header=BB18_3 Depth=2
	i32.const	$push208=, 1
	i32.add 	$push207=, $3, $pop208
	tee_local	$push206=, $3=, $pop207
	i32.const	$push205=, 32
	i32.lt_u	$push4=, $pop206, $pop205
	br_if   	0, $pop4        # 0: up to label39
.LBB18_5:                               # %for.end.i
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	end_block                       # label38:
	i32.const	$push209=, 1
	i32.add 	$3=, $3, $pop209
.LBB18_6:                               # %my_ffs.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label37:
	i32.ne  	$push5=, $6, $3
	br_if   	1, $pop5        # 1: down to label35
# BB#7:                                 # %if.end
                                        #   in Loop: Header=BB18_1 Depth=1
	block   	
	i32.eqz 	$push383=, $11
	br_if   	0, $pop383      # 0: down to label40
# BB#8:                                 # %land.lhs.true
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.clz 	$1=, $11
	i32.const	$6=, 0
	i32.const	$3=, 31
.LBB18_9:                               # %for.body.i822
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	block   	
	loop    	                # label43:
	i32.const	$push210=, 1
	i32.shl 	$push6=, $pop210, $3
	i32.and 	$push7=, $pop6, $11
	br_if   	1, $pop7        # 1: down to label42
# BB#10:                                # %for.inc.i825
                                        #   in Loop: Header=BB18_9 Depth=2
	i32.const	$push215=, -1
	i32.add 	$3=, $3, $pop215
	i32.const	$7=, 32
	i32.const	$push214=, 1
	i32.add 	$push213=, $6, $pop214
	tee_local	$push212=, $6=, $pop213
	i32.const	$push211=, 32
	i32.lt_u	$push8=, $pop212, $pop211
	br_if   	0, $pop8        # 0: up to label43
	br      	2               # 2: down to label41
.LBB18_11:                              #   in Loop: Header=BB18_1 Depth=1
	end_loop
	end_block                       # label42:
	copy_local	$7=, $6
.LBB18_12:                              # %my_clz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label41:
	i32.ne  	$push9=, $1, $7
	br_if   	2, $pop9        # 2: down to label35
# BB#13:                                # %land.lhs.true13
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$3=, 0
.LBB18_14:                              # %for.body.i890
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	block   	
	loop    	                # label46:
	i32.const	$push216=, 1
	i32.shl 	$push10=, $pop216, $3
	i32.and 	$push11=, $pop10, $11
	br_if   	1, $pop11       # 1: down to label45
# BB#15:                                # %for.inc.i893
                                        #   in Loop: Header=BB18_14 Depth=2
	i32.const	$6=, 32
	i32.const	$push220=, 1
	i32.add 	$push219=, $3, $pop220
	tee_local	$push218=, $3=, $pop219
	i32.const	$push217=, 32
	i32.lt_u	$push12=, $pop218, $pop217
	br_if   	0, $pop12       # 0: up to label46
	br      	2               # 2: down to label44
.LBB18_16:                              #   in Loop: Header=BB18_1 Depth=1
	end_loop
	end_block                       # label45:
	copy_local	$6=, $3
.LBB18_17:                              # %my_ctz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label44:
	i32.ne  	$push13=, $2, $6
	br_if   	2, $pop13       # 2: down to label35
.LBB18_18:                              # %if.end19
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label40:
	i32.call	$2=, __builtin_clrsb@FUNCTION, $11
	i32.load	$push223=, 0($5)
	tee_local	$push222=, $3=, $pop223
	i32.const	$push221=, 31
	i32.shr_u	$7=, $pop222, $pop221
	i32.const	$6=, 1
	i32.const	$11=, 30
.LBB18_19:                              # %for.body.i975
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	block   	
	loop    	                # label49:
	i32.shr_u	$push14=, $3, $11
	i32.const	$push224=, 1
	i32.and 	$push15=, $pop14, $pop224
	i32.ne  	$push16=, $pop15, $7
	br_if   	1, $pop16       # 1: down to label48
# BB#20:                                # %for.inc.i978
                                        #   in Loop: Header=BB18_19 Depth=2
	i32.const	$push229=, -1
	i32.add 	$11=, $11, $pop229
	i32.const	$5=, 32
	i32.const	$push228=, 1
	i32.add 	$push227=, $6, $pop228
	tee_local	$push226=, $6=, $pop227
	i32.const	$push225=, 32
	i32.lt_u	$push17=, $pop226, $pop225
	br_if   	0, $pop17       # 0: up to label49
	br      	2               # 2: down to label47
.LBB18_21:                              #   in Loop: Header=BB18_1 Depth=1
	end_loop
	end_block                       # label48:
	copy_local	$5=, $6
.LBB18_22:                              # %my_clrsb.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_block                       # label47:
	i32.const	$push230=, -1
	i32.add 	$push18=, $5, $pop230
	i32.ne  	$push19=, $2, $pop18
	br_if   	1, $pop19       # 1: down to label35
# BB#23:                                # %for.body.i1069.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$6=, 0
	i32.const	$11=, 0
.LBB18_24:                              # %for.body.i1069
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label50:
	i32.const	$push236=, 1
	i32.shl 	$push20=, $pop236, $11
	i32.and 	$push21=, $pop20, $3
	i32.const	$push235=, 0
	i32.ne  	$push22=, $pop21, $pop235
	i32.add 	$6=, $6, $pop22
	i32.const	$push234=, 1
	i32.add 	$push233=, $11, $pop234
	tee_local	$push232=, $11=, $pop233
	i32.const	$push231=, 32
	i32.ne  	$push23=, $pop232, $pop231
	br_if   	0, $pop23       # 0: up to label50
# BB#25:                                # %my_popcount.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	i32.popcnt	$push24=, $3
	i32.ne  	$push25=, $pop24, $6
	br_if   	1, $pop25       # 1: down to label35
# BB#26:                                # %for.body.i1160.preheader
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$7=, 0
	i32.const	$11=, 0
.LBB18_27:                              # %for.body.i1160
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label51:
	i32.const	$push242=, 1
	i32.shl 	$push26=, $pop242, $11
	i32.and 	$push27=, $pop26, $3
	i32.const	$push241=, 0
	i32.ne  	$push28=, $pop27, $pop241
	i32.add 	$7=, $7, $pop28
	i32.const	$push240=, 1
	i32.add 	$push239=, $11, $pop240
	tee_local	$push238=, $11=, $pop239
	i32.const	$push237=, 32
	i32.ne  	$push29=, $pop238, $pop237
	br_if   	0, $pop29       # 0: up to label51
# BB#28:                                # %my_parity.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	end_loop
	i32.xor 	$push30=, $7, $6
	i32.const	$push243=, 1
	i32.and 	$push31=, $pop30, $pop243
	br_if   	1, $pop31       # 1: down to label35
# BB#29:                                # %for.cond
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$push247=, 1
	i32.add 	$push246=, $0, $pop247
	tee_local	$push245=, $0=, $pop246
	i32.const	$push244=, 13
	i32.lt_u	$push32=, $pop245, $pop244
	br_if   	0, $pop32       # 0: up to label36
# BB#30:                                # %for.body41.preheader
	end_loop
	i32.const	$0=, 0
.LBB18_31:                              # %for.body41
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_33 Depth 2
                                        #     Child Loop BB18_39 Depth 2
                                        #     Child Loop BB18_44 Depth 2
                                        #     Child Loop BB18_49 Depth 2
                                        #     Child Loop BB18_54 Depth 2
                                        #     Child Loop BB18_57 Depth 2
	loop    	                # label52:
	i32.const	$push257=, 2
	i32.shl 	$push33=, $0, $pop257
	i32.const	$push256=, longs
	i32.add 	$push255=, $pop33, $pop256
	tee_local	$push254=, $5=, $pop255
	i32.load	$push253=, 0($pop254)
	tee_local	$push252=, $11=, $pop253
	i32.ctz 	$push251=, $pop252
	tee_local	$push250=, $2=, $pop251
	i32.const	$push249=, 1
	i32.add 	$push34=, $pop250, $pop249
	i32.const	$push248=, 0
	i32.select	$6=, $pop34, $pop248, $11
	i32.const	$3=, 0
	block   	
	i32.eqz 	$push384=, $11
	br_if   	0, $pop384      # 0: down to label53
# BB#32:                                # %for.body.i1250.preheader
                                        #   in Loop: Header=BB18_31 Depth=1
	i32.const	$3=, 0
.LBB18_33:                              # %for.body.i1250
                                        #   Parent Loop BB18_31 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label55:
	i32.const	$push258=, 1
	i32.shl 	$push35=, $pop258, $3
	i32.and 	$push36=, $pop35, $11
	br_if   	1, $pop36       # 1: down to label54
# BB#34:                                # %for.inc.i1253
                                        #   in Loop: Header=BB18_33 Depth=2
	i32.const	$push262=, 1
	i32.add 	$push261=, $3, $pop262
	tee_local	$push260=, $3=, $pop261
	i32.const	$push259=, 32
	i32.lt_u	$push37=, $pop260, $pop259
	br_if   	0, $pop37       # 0: up to label55
.LBB18_35:                              # %for.end.i1256
                                        #   in Loop: Header=BB18_31 Depth=1
	end_loop
	end_block                       # label54:
	i32.const	$push263=, 1
	i32.add 	$3=, $3, $pop263
.LBB18_36:                              # %my_ffsl.exit
                                        #   in Loop: Header=BB18_31 Depth=1
	end_block                       # label53:
	i32.ne  	$push38=, $6, $3
	br_if   	1, $pop38       # 1: down to label35
# BB#37:                                # %if.end49
                                        #   in Loop: Header=BB18_31 Depth=1
	block   	
	i32.eqz 	$push385=, $11
	br_if   	0, $pop385      # 0: down to label56
# BB#38:                                # %land.lhs.true52
                                        #   in Loop: Header=BB18_31 Depth=1
	i32.clz 	$1=, $11
	i32.const	$6=, 0
	i32.const	$3=, 31
.LBB18_39:                              # %for.body.i1344
                                        #   Parent Loop BB18_31 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	block   	
	loop    	                # label59:
	i32.const	$push264=, 1
	i32.shl 	$push39=, $pop264, $3
	i32.and 	$push40=, $pop39, $11
	br_if   	1, $pop40       # 1: down to label58
# BB#40:                                # %for.inc.i1347
                                        #   in Loop: Header=BB18_39 Depth=2
	i32.const	$push269=, -1
	i32.add 	$3=, $3, $pop269
	i32.const	$7=, 32
	i32.const	$push268=, 1
	i32.add 	$push267=, $6, $pop268
	tee_local	$push266=, $6=, $pop267
	i32.const	$push265=, 32
	i32.lt_u	$push41=, $pop266, $pop265
	br_if   	0, $pop41       # 0: up to label59
	br      	2               # 2: down to label57
.LBB18_41:                              #   in Loop: Header=BB18_31 Depth=1
	end_loop
	end_block                       # label58:
	copy_local	$7=, $6
.LBB18_42:                              # %my_clzl.exit
                                        #   in Loop: Header=BB18_31 Depth=1
	end_block                       # label57:
	i32.ne  	$push42=, $1, $7
	br_if   	2, $pop42       # 2: down to label35
# BB#43:                                # %land.lhs.true61
                                        #   in Loop: Header=BB18_31 Depth=1
	i32.const	$3=, 0
.LBB18_44:                              # %for.body.i1435
                                        #   Parent Loop BB18_31 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	block   	
	loop    	                # label62:
	i32.const	$push270=, 1
	i32.shl 	$push43=, $pop270, $3
	i32.and 	$push44=, $pop43, $11
	br_if   	1, $pop44       # 1: down to label61
# BB#45:                                # %for.inc.i1438
                                        #   in Loop: Header=BB18_44 Depth=2
	i32.const	$6=, 32
	i32.const	$push274=, 1
	i32.add 	$push273=, $3, $pop274
	tee_local	$push272=, $3=, $pop273
	i32.const	$push271=, 32
	i32.lt_u	$push45=, $pop272, $pop271
	br_if   	0, $pop45       # 0: up to label62
	br      	2               # 2: down to label60
.LBB18_46:                              #   in Loop: Header=BB18_31 Depth=1
	end_loop
	end_block                       # label61:
	copy_local	$6=, $3
.LBB18_47:                              # %my_ctzl.exit
                                        #   in Loop: Header=BB18_31 Depth=1
	end_block                       # label60:
	i32.ne  	$push46=, $2, $6
	br_if   	2, $pop46       # 2: down to label35
.LBB18_48:                              # %if.end67
                                        #   in Loop: Header=BB18_31 Depth=1
	end_block                       # label56:
	i32.call	$2=, __builtin_clrsbl@FUNCTION, $11
	i32.load	$push277=, 0($5)
	tee_local	$push276=, $3=, $pop277
	i32.const	$push275=, 31
	i32.shr_u	$7=, $pop276, $pop275
	i32.const	$6=, 1
	i32.const	$11=, 30
.LBB18_49:                              # %for.body.i1528
                                        #   Parent Loop BB18_31 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	block   	
	loop    	                # label65:
	i32.shr_u	$push47=, $3, $11
	i32.const	$push278=, 1
	i32.and 	$push48=, $pop47, $pop278
	i32.ne  	$push49=, $pop48, $7
	br_if   	1, $pop49       # 1: down to label64
# BB#50:                                # %for.inc.i1531
                                        #   in Loop: Header=BB18_49 Depth=2
	i32.const	$push283=, -1
	i32.add 	$11=, $11, $pop283
	i32.const	$5=, 32
	i32.const	$push282=, 1
	i32.add 	$push281=, $6, $pop282
	tee_local	$push280=, $6=, $pop281
	i32.const	$push279=, 32
	i32.lt_u	$push50=, $pop280, $pop279
	br_if   	0, $pop50       # 0: up to label65
	br      	2               # 2: down to label63
.LBB18_51:                              #   in Loop: Header=BB18_31 Depth=1
	end_loop
	end_block                       # label64:
	copy_local	$5=, $6
.LBB18_52:                              # %my_clrsbl.exit
                                        #   in Loop: Header=BB18_31 Depth=1
	end_block                       # label63:
	i32.const	$push284=, -1
	i32.add 	$push51=, $5, $pop284
	i32.ne  	$push52=, $2, $pop51
	br_if   	1, $pop52       # 1: down to label35
# BB#53:                                # %for.body.i1625.preheader
                                        #   in Loop: Header=BB18_31 Depth=1
	i32.const	$6=, 0
	i32.const	$11=, 0
.LBB18_54:                              # %for.body.i1625
                                        #   Parent Loop BB18_31 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label66:
	i32.const	$push290=, 1
	i32.shl 	$push53=, $pop290, $11
	i32.and 	$push54=, $pop53, $3
	i32.const	$push289=, 0
	i32.ne  	$push55=, $pop54, $pop289
	i32.add 	$6=, $6, $pop55
	i32.const	$push288=, 1
	i32.add 	$push287=, $11, $pop288
	tee_local	$push286=, $11=, $pop287
	i32.const	$push285=, 32
	i32.ne  	$push56=, $pop286, $pop285
	br_if   	0, $pop56       # 0: up to label66
# BB#55:                                # %my_popcountl.exit
                                        #   in Loop: Header=BB18_31 Depth=1
	end_loop
	i32.popcnt	$push57=, $3
	i32.ne  	$push58=, $pop57, $6
	br_if   	1, $pop58       # 1: down to label35
# BB#56:                                # %for.body.i1717.preheader
                                        #   in Loop: Header=BB18_31 Depth=1
	i32.const	$7=, 0
	i32.const	$11=, 0
.LBB18_57:                              # %for.body.i1717
                                        #   Parent Loop BB18_31 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label67:
	i32.const	$push296=, 1
	i32.shl 	$push59=, $pop296, $11
	i32.and 	$push60=, $pop59, $3
	i32.const	$push295=, 0
	i32.ne  	$push61=, $pop60, $pop295
	i32.add 	$7=, $7, $pop61
	i32.const	$push294=, 1
	i32.add 	$push293=, $11, $pop294
	tee_local	$push292=, $11=, $pop293
	i32.const	$push291=, 32
	i32.ne  	$push62=, $pop292, $pop291
	br_if   	0, $pop62       # 0: up to label67
# BB#58:                                # %my_parityl.exit
                                        #   in Loop: Header=BB18_31 Depth=1
	end_loop
	i32.xor 	$push63=, $7, $6
	i32.const	$push297=, 1
	i32.and 	$push64=, $pop63, $pop297
	br_if   	1, $pop64       # 1: down to label35
# BB#59:                                # %for.cond39
                                        #   in Loop: Header=BB18_31 Depth=1
	i32.const	$push301=, 1
	i32.add 	$push300=, $0, $pop301
	tee_local	$push299=, $0=, $pop300
	i32.const	$push298=, 13
	i32.lt_u	$push65=, $pop299, $pop298
	br_if   	0, $pop65       # 0: up to label52
# BB#60:                                # %for.body92.preheader
	end_loop
	i32.const	$6=, 0
.LBB18_61:                              # %for.body92
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_63 Depth 2
                                        #     Child Loop BB18_69 Depth 2
                                        #     Child Loop BB18_73 Depth 2
                                        #     Child Loop BB18_77 Depth 2
                                        #     Child Loop BB18_81 Depth 2
                                        #     Child Loop BB18_84 Depth 2
	loop    	                # label68:
	i32.const	$push313=, 0
	i32.const	$push312=, 3
	i32.shl 	$push66=, $6, $pop312
	i32.const	$push311=, longlongs
	i32.add 	$push310=, $pop66, $pop311
	tee_local	$push309=, $7=, $pop310
	i64.load	$push308=, 0($pop309)
	tee_local	$push307=, $9=, $pop308
	i64.ctz 	$push67=, $pop307
	i32.wrap/i64	$push306=, $pop67
	tee_local	$push305=, $0=, $pop306
	i32.const	$push304=, 1
	i32.add 	$push68=, $pop305, $pop304
	i64.eqz 	$push303=, $9
	tee_local	$push302=, $3=, $pop303
	i32.select	$5=, $pop313, $pop68, $pop302
	i32.const	$11=, 0
	block   	
	br_if   	0, $3           # 0: down to label69
# BB#62:                                # %for.body.i1808.preheader
                                        #   in Loop: Header=BB18_61 Depth=1
	i32.const	$11=, 0
	i64.const	$10=, 0
.LBB18_63:                              # %for.body.i1808
                                        #   Parent Loop BB18_61 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label71:
	i64.const	$push315=, 1
	i64.shl 	$push69=, $pop315, $10
	i64.and 	$push70=, $pop69, $9
	i64.const	$push314=, 0
	i64.ne  	$push71=, $pop70, $pop314
	br_if   	1, $pop71       # 1: down to label70
# BB#64:                                # %for.inc.i1812
                                        #   in Loop: Header=BB18_63 Depth=2
	i32.const	$push320=, 1
	i32.add 	$11=, $11, $pop320
	i64.const	$push319=, 1
	i64.add 	$push318=, $10, $pop319
	tee_local	$push317=, $10=, $pop318
	i64.const	$push316=, 64
	i64.lt_u	$push72=, $pop317, $pop316
	br_if   	0, $pop72       # 0: up to label71
.LBB18_65:                              # %for.end.i1815
                                        #   in Loop: Header=BB18_61 Depth=1
	end_loop
	end_block                       # label70:
	i32.const	$push321=, 1
	i32.add 	$11=, $11, $pop321
.LBB18_66:                              # %my_ffsll.exit1817
                                        #   in Loop: Header=BB18_61 Depth=1
	end_block                       # label69:
	i32.ne  	$push73=, $5, $11
	br_if   	1, $pop73       # 1: down to label35
# BB#67:                                # %if.end100
                                        #   in Loop: Header=BB18_61 Depth=1
	block   	
	br_if   	0, $3           # 0: down to label72
# BB#68:                                # %land.lhs.true103
                                        #   in Loop: Header=BB18_61 Depth=1
	i64.clz 	$push74=, $9
	i32.wrap/i64	$3=, $pop74
	i32.const	$11=, 0
	i64.const	$8=, 0
	i64.const	$10=, 63
.LBB18_69:                              # %for.body.i1893
                                        #   Parent Loop BB18_61 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label74:
	i64.const	$push323=, 1
	i64.shl 	$push75=, $pop323, $10
	i64.and 	$push76=, $pop75, $9
	i64.const	$push322=, 0
	i64.ne  	$push77=, $pop76, $pop322
	br_if   	1, $pop77       # 1: down to label73
# BB#70:                                # %for.inc.i1897
                                        #   in Loop: Header=BB18_69 Depth=2
	i64.const	$push329=, -1
	i64.add 	$10=, $10, $pop329
	i32.const	$push328=, 1
	i32.add 	$11=, $11, $pop328
	i64.const	$push327=, 1
	i64.add 	$push326=, $8, $pop327
	tee_local	$push325=, $8=, $pop326
	i64.const	$push324=, 64
	i64.lt_u	$push78=, $pop325, $pop324
	br_if   	0, $pop78       # 0: up to label74
.LBB18_71:                              # %my_clzll.exit1900
                                        #   in Loop: Header=BB18_61 Depth=1
	end_loop
	end_block                       # label73:
	i32.ne  	$push79=, $11, $3
	br_if   	2, $pop79       # 2: down to label35
# BB#72:                                # %land.lhs.true113
                                        #   in Loop: Header=BB18_61 Depth=1
	i32.const	$11=, 0
	i64.const	$10=, 0
.LBB18_73:                              # %for.body.i1939
                                        #   Parent Loop BB18_61 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label76:
	i64.const	$push331=, 1
	i64.shl 	$push80=, $pop331, $10
	i64.and 	$push81=, $pop80, $9
	i64.const	$push330=, 0
	i64.ne  	$push82=, $pop81, $pop330
	br_if   	1, $pop82       # 1: down to label75
# BB#74:                                # %for.inc.i1943
                                        #   in Loop: Header=BB18_73 Depth=2
	i32.const	$push336=, 1
	i32.add 	$11=, $11, $pop336
	i64.const	$push335=, 1
	i64.add 	$push334=, $10, $pop335
	tee_local	$push333=, $10=, $pop334
	i64.const	$push332=, 64
	i64.lt_u	$push83=, $pop333, $pop332
	br_if   	0, $pop83       # 0: up to label76
.LBB18_75:                              # %my_ctzll.exit1946
                                        #   in Loop: Header=BB18_61 Depth=1
	end_loop
	end_block                       # label75:
	i32.ne  	$push84=, $11, $0
	br_if   	2, $pop84       # 2: down to label35
.LBB18_76:                              # %if.end120
                                        #   in Loop: Header=BB18_61 Depth=1
	end_block                       # label72:
	i32.call	$3=, __builtin_clrsbll@FUNCTION, $9
	i64.load	$push339=, 0($7)
	tee_local	$push338=, $10=, $pop339
	i64.const	$push337=, 63
	i64.shr_u	$4=, $pop338, $pop337
	i32.const	$11=, 1
	i64.const	$8=, 1
	i64.const	$9=, 62
.LBB18_77:                              # %for.body.i2010
                                        #   Parent Loop BB18_61 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label78:
	i64.shr_u	$push85=, $10, $9
	i64.const	$push340=, 1
	i64.and 	$push86=, $pop85, $pop340
	i64.ne  	$push87=, $pop86, $4
	br_if   	1, $pop87       # 1: down to label77
# BB#78:                                # %for.inc.i2014
                                        #   in Loop: Header=BB18_77 Depth=2
	i64.const	$push346=, -1
	i64.add 	$9=, $9, $pop346
	i32.const	$push345=, 1
	i32.add 	$11=, $11, $pop345
	i64.const	$push344=, 1
	i64.add 	$push343=, $8, $pop344
	tee_local	$push342=, $8=, $pop343
	i64.const	$push341=, 64
	i64.lt_u	$push88=, $pop342, $pop341
	br_if   	0, $pop88       # 0: up to label78
.LBB18_79:                              # %my_clrsbll.exit2018
                                        #   in Loop: Header=BB18_61 Depth=1
	end_loop
	end_block                       # label77:
	i32.const	$push347=, -1
	i32.add 	$push89=, $11, $pop347
	i32.ne  	$push90=, $3, $pop89
	br_if   	1, $pop90       # 1: down to label35
# BB#80:                                # %if.end127
                                        #   in Loop: Header=BB18_61 Depth=1
	i64.popcnt	$8=, $10
	i32.const	$11=, 0
	i64.const	$9=, 0
.LBB18_81:                              # %for.body.i2103
                                        #   Parent Loop BB18_61 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label79:
	i64.const	$push353=, 1
	i64.shl 	$push91=, $pop353, $9
	i64.and 	$push92=, $pop91, $10
	i64.const	$push352=, 0
	i64.ne  	$push93=, $pop92, $pop352
	i32.add 	$11=, $11, $pop93
	i64.const	$push351=, 1
	i64.add 	$push350=, $9, $pop351
	tee_local	$push349=, $9=, $pop350
	i64.const	$push348=, 64
	i64.ne  	$push94=, $pop349, $pop348
	br_if   	0, $pop94       # 0: up to label79
# BB#82:                                # %my_popcountll.exit2105
                                        #   in Loop: Header=BB18_61 Depth=1
	end_loop
	i32.wrap/i64	$push95=, $8
	i32.ne  	$push96=, $11, $pop95
	br_if   	1, $pop96       # 1: down to label35
# BB#83:                                # %for.body.i2190.preheader
                                        #   in Loop: Header=BB18_61 Depth=1
	i32.const	$3=, 0
	i64.const	$9=, 0
.LBB18_84:                              # %for.body.i2190
                                        #   Parent Loop BB18_61 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label80:
	i64.const	$push359=, 1
	i64.shl 	$push97=, $pop359, $9
	i64.and 	$push98=, $pop97, $10
	i64.const	$push358=, 0
	i64.ne  	$push99=, $pop98, $pop358
	i32.add 	$3=, $3, $pop99
	i64.const	$push357=, 1
	i64.add 	$push356=, $9, $pop357
	tee_local	$push355=, $9=, $pop356
	i64.const	$push354=, 64
	i64.ne  	$push100=, $pop355, $pop354
	br_if   	0, $pop100      # 0: up to label80
# BB#85:                                # %my_parityll.exit2193
                                        #   in Loop: Header=BB18_61 Depth=1
	end_loop
	i32.xor 	$push101=, $3, $11
	i32.const	$push360=, 1
	i32.and 	$push102=, $pop101, $pop360
	br_if   	1, $pop102      # 1: down to label35
# BB#86:                                # %for.cond90
                                        #   in Loop: Header=BB18_61 Depth=1
	i32.const	$push364=, 1
	i32.add 	$push363=, $6, $pop364
	tee_local	$push362=, $6=, $pop363
	i32.const	$push361=, 12
	i32.le_u	$push103=, $pop362, $pop361
	br_if   	0, $pop103      # 0: up to label68
# BB#87:                                # %if.end148
	end_loop
	i32.const	$push104=, 0
	i32.call	$push105=, __builtin_clrsb@FUNCTION, $pop104
	i32.const	$push106=, 31
	i32.ne  	$push107=, $pop105, $pop106
	br_if   	0, $pop107      # 0: down to label35
# BB#88:                                # %my_clrsb.exit2772
	i32.const	$push108=, 1
	i32.call	$push109=, __builtin_clrsb@FUNCTION, $pop108
	i32.const	$push110=, 30
	i32.ne  	$push111=, $pop109, $pop110
	br_if   	0, $pop111      # 0: down to label35
# BB#89:                                # %if.end198
	i32.const	$push112=, -2147483648
	i32.call	$push113=, __builtin_clrsb@FUNCTION, $pop112
	br_if   	0, $pop113      # 0: down to label35
# BB#90:                                # %my_clrsb.exit2596
	i32.const	$push114=, 1073741824
	i32.call	$push115=, __builtin_clrsb@FUNCTION, $pop114
	br_if   	0, $pop115      # 0: down to label35
# BB#91:                                # %my_clrsb.exit2512
	i32.const	$push116=, 65536
	i32.call	$push117=, __builtin_clrsb@FUNCTION, $pop116
	i32.const	$push118=, 14
	i32.ne  	$push119=, $pop117, $pop118
	br_if   	0, $pop119      # 0: down to label35
# BB#92:                                # %my_clrsb.exit2429
	i32.const	$push120=, 32768
	i32.call	$push121=, __builtin_clrsb@FUNCTION, $pop120
	i32.const	$push122=, 15
	i32.ne  	$push123=, $pop121, $pop122
	br_if   	0, $pop123      # 0: down to label35
# BB#93:                                # %my_clrsb.exit2344
	i32.const	$push124=, -1515870811
	i32.call	$push125=, __builtin_clrsb@FUNCTION, $pop124
	br_if   	0, $pop125      # 0: down to label35
# BB#94:                                # %my_clrsb.exit2268
	i32.const	$push126=, 1515870810
	i32.call	$push127=, __builtin_clrsb@FUNCTION, $pop126
	br_if   	0, $pop127      # 0: down to label35
# BB#95:                                # %if.end348
	i32.const	$push128=, -889323520
	i32.call	$push129=, __builtin_clrsb@FUNCTION, $pop128
	i32.const	$push130=, 1
	i32.ne  	$push131=, $pop129, $pop130
	br_if   	0, $pop131      # 0: down to label35
# BB#96:                                # %if.end373
	i32.const	$push132=, 13303296
	i32.call	$push133=, __builtin_clrsb@FUNCTION, $pop132
	i32.const	$push134=, 7
	i32.ne  	$push135=, $pop133, $pop134
	br_if   	0, $pop135      # 0: down to label35
# BB#97:                                # %if.end398
	i32.const	$push136=, 51966
	i32.call	$push137=, __builtin_clrsb@FUNCTION, $pop136
	i32.const	$push138=, 15
	i32.ne  	$push139=, $pop137, $pop138
	br_if   	0, $pop139      # 0: down to label35
# BB#98:                                # %if.end423
	i32.const	$push365=, -1
	i32.call	$7=, __builtin_clrsb@FUNCTION, $pop365
	i32.const	$11=, 30
	i32.const	$3=, 1
.LBB18_99:                              # %for.body.i1926
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	loop    	                # label83:
	i32.const	$push367=, -1
	i32.shr_u	$push140=, $pop367, $11
	i32.const	$push366=, 1
	i32.and 	$push141=, $pop140, $pop366
	i32.eqz 	$push386=, $pop141
	br_if   	1, $pop386      # 1: down to label82
# BB#100:                               # %for.inc.i1929
                                        #   in Loop: Header=BB18_99 Depth=1
	i32.const	$push372=, -1
	i32.add 	$11=, $11, $pop372
	i32.const	$6=, 32
	i32.const	$push371=, 1
	i32.add 	$push370=, $3, $pop371
	tee_local	$push369=, $3=, $pop370
	i32.const	$push368=, 32
	i32.lt_u	$push142=, $pop369, $pop368
	br_if   	0, $pop142      # 0: up to label83
	br      	2               # 2: down to label81
.LBB18_101:
	end_loop
	end_block                       # label82:
	copy_local	$6=, $3
.LBB18_102:                             # %my_clrsb.exit1933
	end_block                       # label81:
	i32.const	$push143=, -1
	i32.add 	$push144=, $6, $pop143
	i32.ne  	$push145=, $7, $pop144
	br_if   	0, $pop145      # 0: down to label35
# BB#103:                               # %if.end440
	i64.const	$push146=, 0
	i32.call	$push147=, __builtin_clrsbll@FUNCTION, $pop146
	i32.const	$push148=, 63
	i32.ne  	$push149=, $pop147, $pop148
	br_if   	0, $pop149      # 0: down to label35
# BB#104:                               # %for.body.i1836
	i64.const	$push150=, 1
	i32.call	$push151=, __builtin_clrsbll@FUNCTION, $pop150
	i32.const	$push152=, 62
	i32.ne  	$push153=, $pop151, $pop152
	br_if   	0, $pop153      # 0: down to label35
# BB#105:                               # %for.body.i1725
	i64.const	$push154=, -9223372036854775808
	i32.call	$push155=, __builtin_clrsbll@FUNCTION, $pop154
	br_if   	0, $pop155      # 0: down to label35
# BB#106:                               # %for.body.i1632
	i64.const	$push156=, 2
	i32.call	$push157=, __builtin_clrsbll@FUNCTION, $pop156
	i32.const	$push158=, 61
	i32.ne  	$push159=, $pop157, $pop158
	br_if   	0, $pop159      # 0: down to label35
# BB#107:                               # %for.body.i1540
	i64.const	$push160=, 4611686018427387904
	i32.call	$push161=, __builtin_clrsbll@FUNCTION, $pop160
	br_if   	0, $pop161      # 0: down to label35
# BB#108:                               # %for.body.i1446
	i64.const	$push162=, 4294967296
	i32.call	$push163=, __builtin_clrsbll@FUNCTION, $pop162
	i32.const	$push164=, 30
	i32.ne  	$push165=, $pop163, $pop164
	br_if   	0, $pop165      # 0: down to label35
# BB#109:                               # %for.body.i1355
	i64.const	$push166=, 2147483648
	i32.call	$push167=, __builtin_clrsbll@FUNCTION, $pop166
	i32.const	$push168=, 31
	i32.ne  	$push169=, $pop167, $pop168
	br_if   	0, $pop169      # 0: down to label35
# BB#110:                               # %my_clrsbll.exit1243
	i64.const	$push170=, -6510615555426900571
	i32.call	$push171=, __builtin_clrsbll@FUNCTION, $pop170
	br_if   	0, $pop171      # 0: down to label35
# BB#111:                               # %my_clrsbll.exit1151
	i64.const	$push172=, 6510615555426900570
	i32.call	$push173=, __builtin_clrsbll@FUNCTION, $pop172
	br_if   	0, $pop173      # 0: down to label35
# BB#112:                               # %if.end665
	i64.const	$push174=, -3819392241693097984
	i32.call	$push175=, __builtin_clrsbll@FUNCTION, $pop174
	i32.const	$push176=, 1
	i32.ne  	$push177=, $pop175, $pop176
	br_if   	0, $pop177      # 0: down to label35
# BB#113:                               # %if.end690
	i64.const	$push178=, 223195676147712
	i32.call	$push179=, __builtin_clrsbll@FUNCTION, $pop178
	i32.const	$push180=, 15
	i32.ne  	$push181=, $pop179, $pop180
	br_if   	0, $pop181      # 0: down to label35
# BB#114:                               # %if.end715
	i64.const	$push182=, 3405695742
	i32.call	$push183=, __builtin_clrsbll@FUNCTION, $pop182
	i32.const	$push184=, 31
	i32.ne  	$push185=, $pop183, $pop184
	br_if   	0, $pop185      # 0: down to label35
# BB#115:                               # %if.end740
	i64.const	$push373=, -1
	i32.call	$3=, __builtin_clrsbll@FUNCTION, $pop373
	i64.const	$9=, 62
	i64.const	$10=, 1
	i32.const	$11=, 1
.LBB18_116:                             # %for.body.i812
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label85:
	i64.const	$push375=, -1
	i64.shr_u	$push186=, $pop375, $9
	i64.const	$push374=, 1
	i64.and 	$push187=, $pop186, $pop374
	i64.eqz 	$push188=, $pop187
	br_if   	1, $pop188      # 1: down to label84
# BB#117:                               # %for.inc.i816
                                        #   in Loop: Header=BB18_116 Depth=1
	i64.const	$push381=, -1
	i64.add 	$9=, $9, $pop381
	i32.const	$push380=, 1
	i32.add 	$11=, $11, $pop380
	i64.const	$push379=, 1
	i64.add 	$push378=, $10, $pop379
	tee_local	$push377=, $10=, $pop378
	i64.const	$push376=, 64
	i64.lt_u	$push189=, $pop377, $pop376
	br_if   	0, $pop189      # 0: up to label85
.LBB18_118:                             # %my_clrsbll.exit
	end_loop
	end_block                       # label84:
	i32.const	$push190=, -1
	i32.add 	$push191=, $11, $pop190
	i32.ne  	$push192=, $3, $pop191
	br_if   	0, $pop192      # 0: down to label35
# BB#119:                               # %if.end753
	i32.const	$push193=, 0
	call    	exit@FUNCTION, $pop193
	unreachable
.LBB18_120:                             # %if.then
	end_block                       # label35:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end18:
	.size	main, .Lfunc_end18-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	__builtin_clrsb, i32
	.functype	__builtin_clrsbl, i32
	.functype	__builtin_clrsbll, i32
	.functype	exit, void, i32
