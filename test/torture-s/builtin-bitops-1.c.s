	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-bitops-1.c"
	.globl	my_ffs
	.type	my_ffs,@function
my_ffs:                                 # @my_ffs
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block   	BB0_4
	i32.const	$push4=, 0
	i32.eq  	$push5=, $0, $pop4
	br_if   	$pop5, BB0_4
BB0_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_3
	i32.const	$1=, 1
	i32.shl 	$push0=, $1, $2
	i32.and 	$push1=, $pop0, $0
	br_if   	$pop1, BB0_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$2=, $2, $1
	i32.const	$push2=, 32
	i32.lt_u	$push3=, $2, $pop2
	br_if   	$pop3, BB0_1
BB0_3:                                  # %for.end
	i32.add 	$2=, $2, $1
BB0_4:                                  # %cleanup
	return  	$2
func_end0:
	.size	my_ffs, func_end0-my_ffs

	.globl	my_ctz
	.type	my_ctz,@function
my_ctz:                                 # @my_ctz
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
BB1_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB1_3
	i32.const	$1=, 1
	i32.shl 	$push0=, $1, $2
	i32.and 	$push1=, $pop0, $0
	br_if   	$pop1, BB1_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$2=, $2, $1
	i32.const	$push2=, 32
	i32.lt_u	$push3=, $2, $pop2
	br_if   	$pop3, BB1_1
BB1_3:                                  # %for.end
	return  	$2
func_end1:
	.size	my_ctz, func_end1-my_ctz

	.globl	my_clz
	.type	my_clz,@function
my_clz:                                 # @my_clz
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$2=, 31
BB2_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB2_3
	i32.const	$1=, 1
	i32.shl 	$push0=, $1, $2
	i32.and 	$push1=, $pop0, $0
	br_if   	$pop1, BB2_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$3=, $3, $1
	i32.const	$push2=, -1
	i32.add 	$2=, $2, $pop2
	i32.const	$push3=, 32
	i32.lt_u	$push4=, $3, $pop3
	br_if   	$pop4, BB2_1
BB2_3:                                  # %for.end
	return  	$3
func_end2:
	.size	my_clz, func_end2-my_clz

	.globl	my_clrsb
	.type	my_clrsb,@function
my_clrsb:                               # @my_clrsb
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.shr_u	$1=, $0, $pop0
	i32.const	$2=, 1
	i32.const	$3=, 30
	copy_local	$4=, $2
BB3_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB3_3
	i32.shr_u	$push1=, $0, $3
	i32.and 	$push2=, $pop1, $2
	i32.ne  	$push3=, $pop2, $1
	br_if   	$pop3, BB3_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$push4=, 1
	i32.add 	$4=, $4, $pop4
	i32.const	$push5=, -1
	i32.add 	$3=, $3, $pop5
	i32.const	$push6=, 32
	i32.lt_u	$push7=, $4, $pop6
	br_if   	$pop7, BB3_1
BB3_3:                                  # %for.end
	i32.const	$push8=, -1
	i32.add 	$push9=, $4, $pop8
	return  	$pop9
func_end3:
	.size	my_clrsb, func_end3-my_clrsb

	.globl	my_popcount
	.type	my_popcount,@function
my_popcount:                            # @my_popcount
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	copy_local	$3=, $1
	copy_local	$4=, $1
BB4_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB4_2
	i32.const	$2=, 1
	i32.shl 	$push0=, $2, $4
	i32.and 	$push1=, $pop0, $0
	i32.ne  	$push2=, $pop1, $1
	i32.add 	$3=, $pop2, $3
	i32.add 	$4=, $4, $2
	i32.const	$push3=, 32
	i32.ne  	$push4=, $4, $pop3
	br_if   	$pop4, BB4_1
BB4_2:                                  # %for.end
	return  	$3
func_end4:
	.size	my_popcount, func_end4-my_popcount

	.globl	my_parity
	.type	my_parity,@function
my_parity:                              # @my_parity
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	copy_local	$3=, $1
	copy_local	$4=, $1
BB5_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB5_2
	i32.const	$2=, 1
	i32.shl 	$push0=, $2, $4
	i32.and 	$push1=, $pop0, $0
	i32.ne  	$push2=, $pop1, $1
	i32.add 	$3=, $pop2, $3
	i32.add 	$4=, $4, $2
	i32.const	$push3=, 32
	i32.ne  	$push4=, $4, $pop3
	br_if   	$pop4, BB5_1
BB5_2:                                  # %for.end
	i32.and 	$push5=, $3, $2
	return  	$pop5
func_end5:
	.size	my_parity, func_end5-my_parity

	.globl	my_ffsl
	.type	my_ffsl,@function
my_ffsl:                                # @my_ffsl
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block   	BB6_4
	i32.const	$push4=, 0
	i32.eq  	$push5=, $0, $pop4
	br_if   	$pop5, BB6_4
BB6_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB6_3
	i32.const	$1=, 1
	i32.shl 	$push0=, $1, $2
	i32.and 	$push1=, $pop0, $0
	br_if   	$pop1, BB6_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.add 	$2=, $2, $1
	i32.const	$push2=, 32
	i32.lt_u	$push3=, $2, $pop2
	br_if   	$pop3, BB6_1
BB6_3:                                  # %for.end
	i32.add 	$2=, $2, $1
BB6_4:                                  # %cleanup
	return  	$2
func_end6:
	.size	my_ffsl, func_end6-my_ffsl

	.globl	my_ctzl
	.type	my_ctzl,@function
my_ctzl:                                # @my_ctzl
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
BB7_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB7_3
	i32.const	$1=, 1
	i32.shl 	$push0=, $1, $2
	i32.and 	$push1=, $pop0, $0
	br_if   	$pop1, BB7_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.add 	$2=, $2, $1
	i32.const	$push2=, 32
	i32.lt_u	$push3=, $2, $pop2
	br_if   	$pop3, BB7_1
BB7_3:                                  # %for.end
	return  	$2
func_end7:
	.size	my_ctzl, func_end7-my_ctzl

	.globl	my_clzl
	.type	my_clzl,@function
my_clzl:                                # @my_clzl
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$2=, 31
BB8_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB8_3
	i32.const	$1=, 1
	i32.shl 	$push0=, $1, $2
	i32.and 	$push1=, $pop0, $0
	br_if   	$pop1, BB8_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.add 	$3=, $3, $1
	i32.const	$push2=, -1
	i32.add 	$2=, $2, $pop2
	i32.const	$push3=, 32
	i32.lt_u	$push4=, $3, $pop3
	br_if   	$pop4, BB8_1
BB8_3:                                  # %for.end
	return  	$3
func_end8:
	.size	my_clzl, func_end8-my_clzl

	.globl	my_clrsbl
	.type	my_clrsbl,@function
my_clrsbl:                              # @my_clrsbl
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.shr_u	$1=, $0, $pop0
	i32.const	$2=, 1
	i32.const	$3=, 30
	copy_local	$4=, $2
BB9_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB9_3
	i32.shr_u	$push1=, $0, $3
	i32.and 	$push2=, $pop1, $2
	i32.ne  	$push3=, $pop2, $1
	br_if   	$pop3, BB9_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.const	$push4=, 1
	i32.add 	$4=, $4, $pop4
	i32.const	$push5=, -1
	i32.add 	$3=, $3, $pop5
	i32.const	$push6=, 32
	i32.lt_u	$push7=, $4, $pop6
	br_if   	$pop7, BB9_1
BB9_3:                                  # %for.end
	i32.const	$push8=, -1
	i32.add 	$push9=, $4, $pop8
	return  	$pop9
func_end9:
	.size	my_clrsbl, func_end9-my_clrsbl

	.globl	my_popcountl
	.type	my_popcountl,@function
my_popcountl:                           # @my_popcountl
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	copy_local	$3=, $1
	copy_local	$4=, $1
BB10_1:                                 # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB10_2
	i32.const	$2=, 1
	i32.shl 	$push0=, $2, $4
	i32.and 	$push1=, $pop0, $0
	i32.ne  	$push2=, $pop1, $1
	i32.add 	$3=, $pop2, $3
	i32.add 	$4=, $4, $2
	i32.const	$push3=, 32
	i32.ne  	$push4=, $4, $pop3
	br_if   	$pop4, BB10_1
BB10_2:                                 # %for.end
	return  	$3
func_end10:
	.size	my_popcountl, func_end10-my_popcountl

	.globl	my_parityl
	.type	my_parityl,@function
my_parityl:                             # @my_parityl
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	copy_local	$3=, $1
	copy_local	$4=, $1
BB11_1:                                 # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB11_2
	i32.const	$2=, 1
	i32.shl 	$push0=, $2, $4
	i32.and 	$push1=, $pop0, $0
	i32.ne  	$push2=, $pop1, $1
	i32.add 	$3=, $pop2, $3
	i32.add 	$4=, $4, $2
	i32.const	$push3=, 32
	i32.ne  	$push4=, $4, $pop3
	br_if   	$pop4, BB11_1
BB11_2:                                 # %for.end
	i32.and 	$push5=, $3, $2
	return  	$pop5
func_end11:
	.size	my_parityl, func_end11-my_parityl

	.globl	my_ffsll
	.type	my_ffsll,@function
my_ffsll:                               # @my_ffsll
	.param  	i64
	.result 	i32
	.local  	i64, i64, i64, i32
# BB#0:                                 # %entry
	i64.const	$1=, 0
	copy_local	$3=, $1
	i32.const	$4=, 0
	block   	BB12_4
	i64.eq  	$push0=, $0, $1
	br_if   	$pop0, BB12_4
BB12_1:                                 # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB12_3
	i64.const	$2=, 1
	i64.shl 	$push1=, $2, $3
	i64.and 	$push2=, $pop1, $0
	i64.ne  	$push3=, $pop2, $1
	br_if   	$pop3, BB12_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB12_1 Depth=1
	i32.const	$push4=, 1
	i32.add 	$4=, $4, $pop4
	i64.add 	$3=, $3, $2
	i64.const	$push5=, 64
	i64.lt_u	$push6=, $3, $pop5
	br_if   	$pop6, BB12_1
BB12_3:                                 # %for.end
	i32.const	$push7=, 1
	i32.add 	$4=, $4, $pop7
BB12_4:                                 # %cleanup
	return  	$4
func_end12:
	.size	my_ffsll, func_end12-my_ffsll

	.globl	my_ctzll
	.type	my_ctzll,@function
my_ctzll:                               # @my_ctzll
	.param  	i64
	.result 	i32
	.local  	i64, i64, i64, i32
# BB#0:                                 # %entry
	i64.const	$1=, 0
	copy_local	$3=, $1
	i32.const	$4=, 0
BB13_1:                                 # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB13_3
	i64.const	$2=, 1
	i64.shl 	$push0=, $2, $3
	i64.and 	$push1=, $pop0, $0
	i64.ne  	$push2=, $pop1, $1
	br_if   	$pop2, BB13_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB13_1 Depth=1
	i32.const	$push3=, 1
	i32.add 	$4=, $4, $pop3
	i64.add 	$3=, $3, $2
	i64.const	$push4=, 64
	i64.lt_u	$push5=, $3, $pop4
	br_if   	$pop5, BB13_1
BB13_3:                                 # %for.end
	return  	$4
func_end13:
	.size	my_ctzll, func_end13-my_ctzll

	.globl	my_clzll
	.type	my_clzll,@function
my_clzll:                               # @my_clzll
	.param  	i64
	.result 	i32
	.local  	i64, i64, i64, i64, i32
# BB#0:                                 # %entry
	i64.const	$1=, 0
	i64.const	$3=, 63
	copy_local	$4=, $1
	i32.const	$5=, 0
BB14_1:                                 # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB14_3
	i64.const	$2=, 1
	i64.const	$push0=, 4294967295
	i64.and 	$push1=, $3, $pop0
	i64.shl 	$push2=, $2, $pop1
	i64.and 	$push3=, $pop2, $0
	i64.ne  	$push4=, $pop3, $1
	br_if   	$pop4, BB14_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB14_1 Depth=1
	i32.const	$push5=, 1
	i32.add 	$5=, $5, $pop5
	i64.add 	$4=, $4, $2
	i64.const	$push6=, -1
	i64.add 	$3=, $3, $pop6
	i64.const	$push7=, 64
	i64.lt_u	$push8=, $4, $pop7
	br_if   	$pop8, BB14_1
BB14_3:                                 # %for.end
	return  	$5
func_end14:
	.size	my_clzll, func_end14-my_clzll

	.globl	my_clrsbll
	.type	my_clrsbll,@function
my_clrsbll:                             # @my_clrsbll
	.param  	i64
	.result 	i32
	.local  	i64, i64, i64, i64, i32
# BB#0:                                 # %entry
	i64.const	$push0=, 63
	i64.shr_u	$1=, $0, $pop0
	i64.const	$2=, 1
	i64.const	$3=, 62
	copy_local	$4=, $2
	i32.const	$5=, 1
BB15_1:                                 # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB15_3
	i64.shr_u	$push1=, $0, $3
	i64.and 	$push2=, $pop1, $2
	i64.ne  	$push3=, $pop2, $1
	br_if   	$pop3, BB15_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB15_1 Depth=1
	i32.const	$push5=, 1
	i32.add 	$5=, $5, $pop5
	i64.const	$push4=, 1
	i64.add 	$4=, $4, $pop4
	i64.const	$push6=, -1
	i64.add 	$3=, $3, $pop6
	i64.const	$push7=, 64
	i64.lt_u	$push8=, $4, $pop7
	br_if   	$pop8, BB15_1
BB15_3:                                 # %for.end
	i32.const	$push9=, -1
	i32.add 	$push10=, $5, $pop9
	return  	$pop10
func_end15:
	.size	my_clrsbll, func_end15-my_clrsbll

	.globl	my_popcountll
	.type	my_popcountll,@function
my_popcountll:                          # @my_popcountll
	.param  	i64
	.result 	i32
	.local  	i64, i64, i64, i32
# BB#0:                                 # %entry
	i64.const	$1=, 0
	copy_local	$3=, $1
	i32.const	$4=, 0
BB16_1:                                 # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB16_2
	i64.const	$2=, 1
	i64.shl 	$push0=, $2, $3
	i64.and 	$push1=, $pop0, $0
	i64.ne  	$push2=, $pop1, $1
	i32.add 	$4=, $pop2, $4
	i64.add 	$3=, $3, $2
	i64.const	$push3=, 64
	i64.ne  	$push4=, $3, $pop3
	br_if   	$pop4, BB16_1
BB16_2:                                 # %for.end
	return  	$4
func_end16:
	.size	my_popcountll, func_end16-my_popcountll

	.globl	my_parityll
	.type	my_parityll,@function
my_parityll:                            # @my_parityll
	.param  	i64
	.result 	i32
	.local  	i64, i64, i64, i32
# BB#0:                                 # %entry
	i64.const	$1=, 0
	copy_local	$3=, $1
	i32.const	$4=, 0
BB17_1:                                 # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB17_2
	i64.const	$2=, 1
	i64.shl 	$push0=, $2, $3
	i64.and 	$push1=, $pop0, $0
	i64.ne  	$push2=, $pop1, $1
	i32.add 	$4=, $pop2, $4
	i64.add 	$3=, $3, $2
	i64.const	$push3=, 64
	i64.ne  	$push4=, $3, $pop3
	br_if   	$pop4, BB17_1
BB17_2:                                 # %for.end
	i32.const	$push5=, 1
	i32.and 	$push6=, $4, $pop5
	return  	$pop6
func_end17:
	.size	my_parityll, func_end17-my_parityll

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i64, i32, i64, i64, i64, i32, i32, i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$3=, 0
	copy_local	$11=, $3
BB18_1:                                 # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_2 Depth 2
                                        #     Child Loop BB18_8 Depth 2
                                        #     Child Loop BB18_12 Depth 2
                                        #     Child Loop BB18_18 Depth 2
                                        #     Child Loop BB18_21 Depth 2
                                        #     Child Loop BB18_23 Depth 2
	block   	BB18_166
	block   	BB18_165
	block   	BB18_164
	block   	BB18_163
	loop    	BB18_26
	i32.const	$4=, 2
	i32.const	$push1=, ints
	i32.shl 	$push0=, $11, $4
	i32.add 	$1=, $pop1, $pop0
	i32.load	$10=, 0($1)
	i32.ctz 	$18=, $10
	i32.const	$14=, 1
	i32.add 	$push2=, $18, $14
	i32.select	$20=, $10, $pop2, $3
	copy_local	$7=, $3
	copy_local	$19=, $3
	block   	BB18_5
	i32.const	$push222=, 0
	i32.eq  	$push223=, $10, $pop222
	br_if   	$pop223, BB18_5
BB18_2:                                 # %for.body.i
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_4
	i32.shl 	$push3=, $14, $7
	i32.and 	$push4=, $pop3, $10
	br_if   	$pop4, BB18_4
# BB#3:                                 # %for.inc.i
                                        #   in Loop: Header=BB18_2 Depth=2
	i32.add 	$7=, $7, $14
	i32.const	$push5=, 32
	i32.lt_u	$push6=, $7, $pop5
	br_if   	$pop6, BB18_2
BB18_4:                                 # %for.end.i
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.add 	$19=, $7, $14
BB18_5:                                 # %my_ffs.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.ne  	$push7=, $20, $19
	br_if   	$pop7, BB18_166
# BB#6:                                 # %if.end
                                        #   in Loop: Header=BB18_1 Depth=1
	block   	BB18_17
	i32.const	$push224=, 0
	i32.eq  	$push225=, $10, $pop224
	br_if   	$pop225, BB18_17
# BB#7:                                 # %land.lhs.true
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.clz 	$20=, $10
	i32.const	$7=, 0
	i32.const	$19=, 31
BB18_8:                                 # %for.body.i822
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_10
	i32.shl 	$push8=, $14, $19
	i32.and 	$push9=, $pop8, $10
	br_if   	$pop9, BB18_10
# BB#9:                                 # %for.inc.i825
                                        #   in Loop: Header=BB18_8 Depth=2
	i32.const	$push10=, -1
	i32.add 	$19=, $19, $pop10
	i32.add 	$7=, $7, $14
	i32.const	$push11=, 32
	i32.lt_u	$push12=, $7, $pop11
	br_if   	$pop12, BB18_8
BB18_10:                                # %my_clz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	block   	BB18_16
	i32.ne  	$push13=, $20, $7
	br_if   	$pop13, BB18_16
# BB#11:                                # %land.lhs.true13
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$7=, 0
BB18_12:                                # %for.body.i889
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_14
	i32.shl 	$push14=, $14, $7
	i32.and 	$push15=, $pop14, $10
	br_if   	$pop15, BB18_14
# BB#13:                                # %for.inc.i892
                                        #   in Loop: Header=BB18_12 Depth=2
	i32.add 	$7=, $7, $14
	i32.const	$push16=, 32
	i32.lt_u	$push17=, $7, $pop16
	br_if   	$pop17, BB18_12
BB18_14:                                # %my_ctz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.eq  	$push18=, $18, $7
	br_if   	$pop18, BB18_17
# BB#15:                                # %if.then18
	call    	abort
	unreachable
BB18_16:                                # %if.then9
	call    	abort
	unreachable
BB18_17:                                # %if.end19
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.call	$20=, __builtin_clrsb, $10
	i32.load	$19=, 0($1)
	i32.const	$5=, 31
	i32.shr_u	$1=, $19, $5
	i32.const	$10=, 30
	copy_local	$7=, $14
BB18_18:                                # %for.body.i974
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_20
	i32.shr_u	$push19=, $19, $10
	i32.and 	$push20=, $pop19, $14
	i32.ne  	$push21=, $pop20, $1
	br_if   	$pop21, BB18_20
# BB#19:                                # %for.inc.i977
                                        #   in Loop: Header=BB18_18 Depth=2
	i32.const	$push22=, 1
	i32.add 	$7=, $7, $pop22
	i32.const	$push23=, -1
	i32.add 	$10=, $10, $pop23
	i32.const	$push24=, 32
	i32.lt_u	$push25=, $7, $pop24
	br_if   	$pop25, BB18_18
BB18_20:                                # %my_clrsb.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$6=, -1
	i32.const	$18=, 0
	copy_local	$1=, $18
	copy_local	$10=, $18
	i32.add 	$push26=, $7, $6
	i32.ne  	$push27=, $20, $pop26
	br_if   	$pop27, BB18_165
BB18_21:                                # %for.body.i1069
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_22
	i32.const	$14=, 1
	i32.shl 	$push28=, $14, $10
	i32.and 	$push29=, $pop28, $19
	i32.ne  	$push30=, $pop29, $18
	i32.add 	$1=, $pop30, $1
	i32.add 	$10=, $10, $14
	i32.const	$7=, 32
	i32.ne  	$push31=, $10, $7
	br_if   	$pop31, BB18_21
BB18_22:                                # %my_popcount.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$20=, 0
	copy_local	$18=, $20
	copy_local	$10=, $20
	i32.popcnt	$push32=, $19
	i32.ne  	$push33=, $pop32, $1
	br_if   	$pop33, BB18_164
BB18_23:                                # %for.body.i1161
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_24
	i32.shl 	$push34=, $14, $10
	i32.and 	$push35=, $pop34, $19
	i32.ne  	$push36=, $pop35, $20
	i32.add 	$18=, $pop36, $18
	i32.add 	$10=, $10, $14
	i32.ne  	$push37=, $10, $7
	br_if   	$pop37, BB18_23
BB18_24:                                # %my_parity.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.xor 	$push38=, $18, $1
	i32.and 	$push39=, $pop38, $14
	br_if   	$pop39, BB18_163
# BB#25:                                # %for.cond
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.add 	$11=, $11, $14
	i32.const	$8=, 0
	i32.const	$9=, 12
	copy_local	$0=, $8
	i32.le_u	$push40=, $11, $9
	br_if   	$pop40, BB18_1
BB18_26:                                # %for.body41
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_27 Depth 2
                                        #     Child Loop BB18_33 Depth 2
                                        #     Child Loop BB18_37 Depth 2
                                        #     Child Loop BB18_43 Depth 2
                                        #     Child Loop BB18_46 Depth 2
                                        #     Child Loop BB18_48 Depth 2
	block   	BB18_162
	block   	BB18_161
	block   	BB18_160
	block   	BB18_159
	loop    	BB18_51
	i32.const	$push42=, longs
	i32.shl 	$push41=, $0, $4
	i32.add 	$18=, $pop42, $pop41
	i32.load	$19=, 0($18)
	i32.ctz 	$20=, $19
	i32.add 	$push43=, $20, $14
	i32.select	$11=, $19, $pop43, $8
	copy_local	$10=, $8
	copy_local	$1=, $8
	block   	BB18_30
	i32.const	$push226=, 0
	i32.eq  	$push227=, $19, $pop226
	br_if   	$pop227, BB18_30
BB18_27:                                # %for.body.i1251
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_29
	i32.shl 	$push44=, $14, $10
	i32.and 	$push45=, $pop44, $19
	br_if   	$pop45, BB18_29
# BB#28:                                # %for.inc.i1254
                                        #   in Loop: Header=BB18_27 Depth=2
	i32.add 	$10=, $10, $14
	i32.lt_u	$push46=, $10, $7
	br_if   	$pop46, BB18_27
BB18_29:                                # %for.end.i1257
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.add 	$1=, $10, $14
BB18_30:                                # %my_ffsl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.ne  	$push47=, $11, $1
	br_if   	$pop47, BB18_162
# BB#31:                                # %if.end49
                                        #   in Loop: Header=BB18_26 Depth=1
	block   	BB18_42
	i32.const	$push228=, 0
	i32.eq  	$push229=, $19, $pop228
	br_if   	$pop229, BB18_42
# BB#32:                                # %land.lhs.true52
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.clz 	$11=, $19
	i32.const	$10=, 0
	copy_local	$1=, $5
BB18_33:                                # %for.body.i1346
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_35
	i32.shl 	$push48=, $14, $1
	i32.and 	$push49=, $pop48, $19
	br_if   	$pop49, BB18_35
# BB#34:                                # %for.inc.i1349
                                        #   in Loop: Header=BB18_33 Depth=2
	i32.add 	$10=, $10, $14
	i32.add 	$1=, $1, $6
	i32.lt_u	$push50=, $10, $7
	br_if   	$pop50, BB18_33
BB18_35:                                # %my_clzl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	block   	BB18_41
	i32.ne  	$push51=, $11, $10
	br_if   	$pop51, BB18_41
# BB#36:                                # %land.lhs.true61
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.const	$10=, 0
BB18_37:                                # %for.body.i1438
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_39
	i32.shl 	$push52=, $14, $10
	i32.and 	$push53=, $pop52, $19
	br_if   	$pop53, BB18_39
# BB#38:                                # %for.inc.i1441
                                        #   in Loop: Header=BB18_37 Depth=2
	i32.add 	$10=, $10, $14
	i32.lt_u	$push54=, $10, $7
	br_if   	$pop54, BB18_37
BB18_39:                                # %my_ctzl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.eq  	$push55=, $20, $10
	br_if   	$pop55, BB18_42
# BB#40:                                # %if.then66
	call    	abort
	unreachable
BB18_41:                                # %if.then57
	call    	abort
	unreachable
BB18_42:                                # %if.end67
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.call	$11=, __builtin_clrsbl, $19
	i32.load	$1=, 0($18)
	i32.const	$3=, 31
	i32.shr_u	$18=, $1, $3
	i32.const	$19=, 30
	copy_local	$10=, $14
BB18_43:                                # %for.body.i1532
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_45
	i32.shr_u	$push56=, $1, $19
	i32.and 	$push57=, $pop56, $14
	i32.ne  	$push58=, $pop57, $18
	br_if   	$pop58, BB18_45
# BB#44:                                # %for.inc.i1535
                                        #   in Loop: Header=BB18_43 Depth=2
	i32.const	$push59=, 1
	i32.add 	$10=, $10, $pop59
	i32.add 	$19=, $19, $6
	i32.lt_u	$push60=, $10, $7
	br_if   	$pop60, BB18_43
BB18_45:                                # %my_clrsbl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.const	$20=, 0
	copy_local	$18=, $20
	copy_local	$19=, $20
	i32.add 	$push61=, $10, $6
	i32.ne  	$push62=, $11, $pop61
	br_if   	$pop62, BB18_161
BB18_46:                                # %for.body.i1630
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_47
	i32.const	$10=, 1
	i32.shl 	$push63=, $10, $19
	i32.and 	$push64=, $pop63, $1
	i32.ne  	$push65=, $pop64, $20
	i32.add 	$18=, $pop65, $18
	i32.add 	$19=, $19, $10
	i32.ne  	$push66=, $19, $7
	br_if   	$pop66, BB18_46
BB18_47:                                # %my_popcountl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.const	$11=, 0
	copy_local	$20=, $11
	copy_local	$19=, $11
	i32.popcnt	$push67=, $1
	i32.ne  	$push68=, $pop67, $18
	br_if   	$pop68, BB18_160
BB18_48:                                # %for.body.i1723
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_49
	i32.shl 	$push69=, $10, $19
	i32.and 	$push70=, $pop69, $1
	i32.ne  	$push71=, $pop70, $11
	i32.add 	$20=, $pop71, $20
	i32.add 	$19=, $19, $10
	i32.ne  	$push72=, $19, $7
	br_if   	$pop72, BB18_48
BB18_49:                                # %my_parityl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.xor 	$push73=, $20, $18
	i32.and 	$push74=, $pop73, $10
	br_if   	$pop74, BB18_159
# BB#50:                                # %for.cond39
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.add 	$0=, $0, $10
	i32.const	$1=, 0
	copy_local	$18=, $1
	i32.le_u	$push75=, $0, $9
	br_if   	$pop75, BB18_26
BB18_51:                                # %for.body92
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_52 Depth 2
                                        #     Child Loop BB18_58 Depth 2
                                        #     Child Loop BB18_62 Depth 2
                                        #     Child Loop BB18_68 Depth 2
                                        #     Child Loop BB18_72 Depth 2
                                        #     Child Loop BB18_74 Depth 2
	block   	BB18_158
	block   	BB18_157
	block   	BB18_156
	block   	BB18_155
	loop    	BB18_77
	i32.const	$push78=, longlongs
	i32.const	$push76=, 3
	i32.shl 	$push77=, $18, $pop76
	i32.add 	$20=, $pop78, $pop77
	i64.load	$17=, 0($20)
	i64.ctz 	$16=, $17
	i64.const	$21=, 1
	i64.const	$12=, 0
	i64.eq  	$19=, $17, $12
	i64.add 	$push79=, $16, $21
	i32.wrap/i64	$push80=, $pop79
	i32.select	$8=, $19, $1, $pop80
	copy_local	$22=, $12
	copy_local	$14=, $1
	copy_local	$11=, $1
	block   	BB18_55
	br_if   	$19, BB18_55
BB18_52:                                # %for.body.i1814
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_54
	i64.shl 	$push81=, $21, $22
	i64.and 	$push82=, $pop81, $17
	i64.ne  	$push83=, $pop82, $12
	br_if   	$pop83, BB18_54
# BB#53:                                # %for.inc.i1818
                                        #   in Loop: Header=BB18_52 Depth=2
	i64.add 	$22=, $22, $21
	i32.add 	$14=, $14, $10
	i64.const	$push84=, 64
	i64.lt_u	$push85=, $22, $pop84
	br_if   	$pop85, BB18_52
BB18_54:                                # %for.end.i1821
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.add 	$11=, $14, $10
BB18_55:                                # %my_ffsll.exit1823
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.ne  	$push86=, $8, $11
	br_if   	$pop86, BB18_158
# BB#56:                                # %if.end100
                                        #   in Loop: Header=BB18_51 Depth=1
	i64.const	$13=, 0
	block   	BB18_67
	i64.eq  	$push87=, $17, $13
	br_if   	$pop87, BB18_67
# BB#57:                                # %land.lhs.true103
                                        #   in Loop: Header=BB18_51 Depth=1
	i64.const	$22=, 63
	copy_local	$12=, $13
	i64.clz 	$push88=, $17
	i32.wrap/i64	$19=, $pop88
	i32.const	$14=, 0
BB18_58:                                # %for.body.i1902
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_60
	i64.const	$push89=, 4294967295
	i64.and 	$push90=, $22, $pop89
	i64.shl 	$push91=, $21, $pop90
	i64.and 	$push92=, $pop91, $17
	i64.ne  	$push93=, $pop92, $13
	br_if   	$pop93, BB18_60
# BB#59:                                # %for.inc.i1906
                                        #   in Loop: Header=BB18_58 Depth=2
	i64.const	$push94=, -1
	i64.add 	$22=, $22, $pop94
	i64.add 	$12=, $12, $21
	i32.add 	$14=, $14, $10
	i64.const	$push95=, 64
	i64.lt_u	$push96=, $12, $pop95
	br_if   	$pop96, BB18_58
BB18_60:                                # %my_clzll.exit1909
                                        #   in Loop: Header=BB18_51 Depth=1
	block   	BB18_66
	i32.ne  	$push97=, $19, $14
	br_if   	$pop97, BB18_66
# BB#61:                                # %land.lhs.true113
                                        #   in Loop: Header=BB18_51 Depth=1
	i64.const	$12=, 0
	copy_local	$22=, $12
	i32.wrap/i64	$19=, $16
	i32.const	$14=, 0
BB18_62:                                # %for.body.i1948
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_64
	i64.shl 	$push98=, $21, $22
	i64.and 	$push99=, $pop98, $17
	i64.ne  	$push100=, $pop99, $12
	br_if   	$pop100, BB18_64
# BB#63:                                # %for.inc.i1952
                                        #   in Loop: Header=BB18_62 Depth=2
	i64.add 	$22=, $22, $21
	i32.add 	$14=, $14, $10
	i64.const	$push101=, 64
	i64.lt_u	$push102=, $22, $pop101
	br_if   	$pop102, BB18_62
BB18_64:                                # %my_ctzll.exit1955
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.eq  	$push103=, $19, $14
	br_if   	$pop103, BB18_67
# BB#65:                                # %if.then119
	call    	abort
	unreachable
BB18_66:                                # %if.then109
	call    	abort
	unreachable
BB18_67:                                # %if.end120
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.call	$19=, __builtin_clrsbll, $17
	i64.load	$17=, 0($20)
	i64.const	$16=, 63
	i64.shr_u	$13=, $17, $16
	i64.const	$22=, 62
	copy_local	$12=, $21
	copy_local	$14=, $10
BB18_68:                                # %for.body.i2018
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_70
	i64.shr_u	$push104=, $17, $22
	i64.and 	$push105=, $pop104, $21
	i64.ne  	$push106=, $pop105, $13
	br_if   	$pop106, BB18_70
# BB#69:                                # %for.inc.i2022
                                        #   in Loop: Header=BB18_68 Depth=2
	i32.const	$push108=, 1
	i32.add 	$14=, $14, $pop108
	i64.const	$push107=, 1
	i64.add 	$12=, $12, $pop107
	i64.const	$push109=, -1
	i64.add 	$22=, $22, $pop109
	i64.const	$push110=, 64
	i64.lt_u	$push111=, $12, $pop110
	br_if   	$pop111, BB18_68
BB18_70:                                # %my_clrsbll.exit2026
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.add 	$push112=, $14, $6
	i32.ne  	$push113=, $19, $pop112
	br_if   	$pop113, BB18_157
# BB#71:                                # %if.end127
                                        #   in Loop: Header=BB18_51 Depth=1
	i64.const	$13=, 0
	i64.popcnt	$2=, $17
	copy_local	$22=, $13
	i32.const	$14=, 0
BB18_72:                                # %for.body.i2110
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_73
	i64.const	$21=, 1
	i64.shl 	$push114=, $21, $22
	i64.and 	$push115=, $pop114, $17
	i64.ne  	$push116=, $pop115, $13
	i32.add 	$14=, $pop116, $14
	i64.add 	$22=, $22, $21
	i64.const	$12=, 64
	i64.ne  	$push117=, $22, $12
	br_if   	$pop117, BB18_72
BB18_73:                                # %my_popcountll.exit2112
                                        #   in Loop: Header=BB18_51 Depth=1
	i64.const	$13=, 0
	copy_local	$22=, $13
	i32.const	$19=, 0
	i32.wrap/i64	$push118=, $2
	i32.ne  	$push119=, $pop118, $14
	br_if   	$pop119, BB18_156
BB18_74:                                # %for.body.i2196
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB18_75
	i64.shl 	$push120=, $21, $22
	i64.and 	$push121=, $pop120, $17
	i64.ne  	$push122=, $pop121, $13
	i32.add 	$19=, $pop122, $19
	i64.add 	$22=, $22, $21
	i64.ne  	$push123=, $22, $12
	br_if   	$pop123, BB18_74
BB18_75:                                # %my_parityll.exit2199
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.const	$20=, 1
	i32.xor 	$push124=, $19, $14
	i32.and 	$push125=, $pop124, $20
	br_if   	$pop125, BB18_155
# BB#76:                                # %for.cond90
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.add 	$18=, $18, $20
	i32.le_u	$push126=, $18, $9
	br_if   	$pop126, BB18_51
BB18_77:                                # %if.end148
	i32.const	$19=, 0
	block   	BB18_154
	i32.call	$push127=, __builtin_clrsb, $19
	i32.ne  	$push128=, $pop127, $3
	br_if   	$pop128, BB18_154
# BB#78:                                # %my_clrsb.exit2770
	i32.call	$10=, __builtin_clrsb, $20
	i32.const	$14=, 30
	block   	BB18_153
	i32.ne  	$push129=, $10, $14
	br_if   	$pop129, BB18_153
# BB#79:                                # %if.end198
	block   	BB18_152
	i32.const	$push130=, -2147483648
	i32.call	$push131=, __builtin_clrsb, $pop130
	br_if   	$pop131, BB18_152
# BB#80:                                # %my_clrsb.exit2597
	block   	BB18_151
	i32.const	$push132=, 1073741824
	i32.call	$push133=, __builtin_clrsb, $pop132
	br_if   	$pop133, BB18_151
# BB#81:                                # %my_clrsb.exit2514
	block   	BB18_150
	i32.const	$push134=, 65536
	i32.call	$push135=, __builtin_clrsb, $pop134
	i32.const	$push136=, 14
	i32.ne  	$push137=, $pop135, $pop136
	br_if   	$pop137, BB18_150
# BB#82:                                # %my_clrsb.exit2432
	i32.const	$push138=, 32768
	i32.call	$10=, __builtin_clrsb, $pop138
	i32.const	$1=, 15
	block   	BB18_149
	i32.ne  	$push139=, $10, $1
	br_if   	$pop139, BB18_149
# BB#83:                                # %my_clrsb.exit2348
	block   	BB18_148
	i32.const	$push140=, -1515870811
	i32.call	$push141=, __builtin_clrsb, $pop140
	br_if   	$pop141, BB18_148
# BB#84:                                # %my_clrsb.exit2273
	block   	BB18_147
	i32.const	$push142=, 1515870810
	i32.call	$push143=, __builtin_clrsb, $pop142
	br_if   	$pop143, BB18_147
# BB#85:                                # %for.body.i2179
	block   	BB18_146
	i32.const	$push144=, -889323520
	i32.call	$push145=, __builtin_clrsb, $pop144
	i32.ne  	$push146=, $pop145, $20
	br_if   	$pop146, BB18_146
# BB#86:                                # %for.body.i2093
	block   	BB18_145
	i32.const	$push147=, 13303296
	i32.call	$push148=, __builtin_clrsb, $pop147
	i32.const	$push149=, 7
	i32.ne  	$push150=, $pop148, $pop149
	br_if   	$pop150, BB18_145
# BB#87:                                # %for.body.i2004
	block   	BB18_144
	i32.const	$push151=, 51966
	i32.call	$push152=, __builtin_clrsb, $pop151
	i32.ne  	$push153=, $pop152, $1
	br_if   	$pop153, BB18_144
# BB#88:                                # %if.end423
	i32.call	$18=, __builtin_clrsb, $6
	copy_local	$10=, $20
BB18_89:                                # %for.body.i1935
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB18_91
	i32.shr_u	$push154=, $6, $14
	i32.and 	$push155=, $pop154, $20
	i32.const	$push230=, 0
	i32.eq  	$push231=, $pop155, $pop230
	br_if   	$pop231, BB18_91
# BB#90:                                # %for.inc.i1938
                                        #   in Loop: Header=BB18_89 Depth=1
	i32.const	$push156=, 1
	i32.add 	$10=, $10, $pop156
	i32.add 	$14=, $14, $6
	i32.lt_u	$push157=, $10, $7
	br_if   	$pop157, BB18_89
BB18_91:                                # %my_clrsb.exit1942
	block   	BB18_143
	i32.add 	$push158=, $10, $6
	i32.ne  	$push159=, $18, $pop158
	br_if   	$pop159, BB18_143
# BB#92:                                # %if.end440
	i64.const	$22=, 0
	i32.call	$14=, __builtin_clrsbll, $22
	i32.const	$10=, 63
	block   	BB18_142
	i32.ne  	$push160=, $14, $10
	br_if   	$pop160, BB18_142
BB18_93:                                # %for.body.i1844
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB18_95
	i32.wrap/i64	$push161=, $16
	i32.const	$push232=, 0
	i32.eq  	$push233=, $pop161, $pop232
	br_if   	$pop233, BB18_95
# BB#94:                                # %for.inc.i1848
                                        #   in Loop: Header=BB18_93 Depth=1
	i32.const	$push162=, 1
	i32.add 	$19=, $19, $pop162
	i64.const	$push163=, -1
	i64.add 	$16=, $16, $pop163
	i64.add 	$22=, $22, $21
	i64.lt_u	$push164=, $22, $12
	br_if   	$pop164, BB18_93
BB18_95:                                # %my_clzll.exit1851
	block   	BB18_141
	i32.ne  	$push165=, $19, $10
	br_if   	$pop165, BB18_141
# BB#96:                                # %if.end465
	i32.call	$19=, __builtin_clrsbll, $21
BB18_97:                                # %for.body.i1799
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB18_99
	i64.const	$22=, 63
	i32.const	$14=, 62
	i64.eq  	$push166=, $21, $22
	br_if   	$pop166, BB18_99
# BB#98:                                # %for.inc.i1803
                                        #   in Loop: Header=BB18_97 Depth=1
	i64.const	$push167=, 1
	i64.add 	$21=, $21, $pop167
	copy_local	$14=, $10
	i64.lt_u	$push168=, $21, $12
	br_if   	$pop168, BB18_97
BB18_99:                                # %my_clrsbll.exit1807
	i64.const	$21=, 0
	copy_local	$17=, $21
	block   	BB18_140
	i32.ne  	$push169=, $19, $14
	br_if   	$pop169, BB18_140
BB18_100:                               # %for.body.i1759
                                        # =>This Inner Loop Header: Depth=1
	block   	BB18_103
	loop    	BB18_102
	i64.eq  	$push170=, $17, $22
	br_if   	$pop170, BB18_103
# BB#101:                               # %for.inc.i1763
                                        #   in Loop: Header=BB18_100 Depth=1
	i64.const	$push171=, 1
	i64.add 	$17=, $17, $pop171
	i64.lt_u	$push172=, $17, $12
	br_if   	$pop172, BB18_100
BB18_102:                               # %if.then481
	call    	abort
	unreachable
BB18_103:                               # %for.body.i1731
                                        # =>This Inner Loop Header: Depth=1
	block   	BB18_106
	loop    	BB18_105
	i64.eq  	$push173=, $21, $22
	br_if   	$pop173, BB18_106
# BB#104:                               # %for.inc.i1735
                                        #   in Loop: Header=BB18_103 Depth=1
	i64.const	$push174=, 1
	i64.add 	$21=, $21, $pop174
	i64.lt_u	$push175=, $21, $12
	br_if   	$pop175, BB18_103
BB18_105:                               # %if.then489
	call    	abort
	unreachable
BB18_106:                               # %if.end490
	block   	BB18_139
	i64.const	$push176=, -9223372036854775808
	i32.call	$push177=, __builtin_clrsbll, $pop176
	br_if   	$pop177, BB18_139
# BB#107:                               # %for.body.i1665
	i64.const	$16=, -1
	copy_local	$21=, $16
	i32.const	$14=, 1
BB18_108:                               # %for.body.i1652
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB18_109
	i64.const	$13=, 1
	i64.add 	$21=, $21, $13
	i64.add 	$17=, $22, $16
	i32.wrap/i64	$10=, $22
	copy_local	$22=, $17
	i32.ne  	$push178=, $10, $14
	br_if   	$pop178, BB18_108
BB18_109:                               # %my_clzll.exit1659
	block   	BB18_138
	i32.wrap/i64	$push179=, $21
	i32.const	$push180=, 62
	i32.ne  	$push181=, $pop179, $pop180
	br_if   	$pop181, BB18_138
# BB#110:                               # %for.body.i1612
	block   	BB18_137
	i64.const	$push182=, 2
	i32.call	$push183=, __builtin_clrsbll, $pop182
	i32.const	$push184=, 61
	i32.ne  	$push185=, $pop183, $pop184
	br_if   	$pop185, BB18_137
# BB#111:                               # %my_clrsbll.exit1525
	block   	BB18_136
	i64.const	$push186=, 4611686018427387904
	i32.call	$push187=, __builtin_clrsbll, $pop186
	br_if   	$pop187, BB18_136
# BB#112:                               # %for.body.i1425
	block   	BB18_135
	i64.const	$push188=, 4294967296
	i32.call	$push189=, __builtin_clrsbll, $pop188
	i32.const	$push190=, 30
	i32.ne  	$push191=, $pop189, $pop190
	br_if   	$pop191, BB18_135
# BB#113:                               # %for.body.i1332
	block   	BB18_134
	i64.const	$push192=, 2147483648
	i32.call	$push193=, __builtin_clrsbll, $pop192
	i32.ne  	$push194=, $pop193, $3
	br_if   	$pop194, BB18_134
# BB#114:                               # %my_clrsbll.exit1245
	block   	BB18_133
	i64.const	$push195=, -6510615555426900571
	i32.call	$push196=, __builtin_clrsbll, $pop195
	br_if   	$pop196, BB18_133
# BB#115:                               # %my_clrsbll.exit1152
	block   	BB18_132
	i64.const	$push197=, 6510615555426900570
	i32.call	$push198=, __builtin_clrsbll, $pop197
	br_if   	$pop198, BB18_132
# BB#116:                               # %for.body.i1053
	block   	BB18_131
	i64.const	$push199=, -3819392241693097984
	i32.call	$push200=, __builtin_clrsbll, $pop199
	i32.ne  	$push201=, $pop200, $14
	br_if   	$pop201, BB18_131
# BB#117:                               # %for.body.i964
	block   	BB18_130
	i64.const	$push202=, 223195676147712
	i32.call	$push203=, __builtin_clrsbll, $pop202
	i32.ne  	$push204=, $pop203, $1
	br_if   	$pop204, BB18_130
# BB#118:                               # %for.body.i925
	i64.const	$15=, -1
	i64.const	$21=, 63
	copy_local	$22=, $15
BB18_119:                               # %for.body.i913
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB18_120
	i64.const	$push205=, 4294967295
	i64.and 	$2=, $21, $pop205
	i64.const	$17=, 3405695742
	i64.add 	$22=, $22, $13
	i64.add 	$21=, $21, $15
	i64.const	$16=, 0
	i64.shl 	$push206=, $13, $2
	i64.and 	$push207=, $pop206, $17
	i64.eq  	$push208=, $pop207, $16
	br_if   	$pop208, BB18_119
BB18_120:                               # %my_clzll.exit
	block   	BB18_129
	i32.wrap/i64	$push209=, $22
	i32.ne  	$push210=, $pop209, $7
	br_if   	$pop210, BB18_129
# BB#121:                               # %for.body.i877
	block   	BB18_128
	i32.call	$push211=, __builtin_clrsbll, $17
	i32.ne  	$push212=, $pop211, $3
	br_if   	$pop212, BB18_128
# BB#122:                               # %if.end740
	i64.const	$17=, -1
	i32.call	$7=, __builtin_clrsbll, $17
	i64.const	$21=, 62
	copy_local	$22=, $13
BB18_123:                               # %for.body.i812
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB18_125
	i64.shr_u	$push213=, $17, $21
	i64.and 	$push214=, $pop213, $13
	i64.eq  	$push215=, $pop214, $16
	br_if   	$pop215, BB18_125
# BB#124:                               # %for.inc.i816
                                        #   in Loop: Header=BB18_123 Depth=1
	i32.const	$push217=, 1
	i32.add 	$14=, $14, $pop217
	i64.const	$push216=, 1
	i64.add 	$22=, $22, $pop216
	i64.add 	$21=, $21, $17
	i64.lt_u	$push218=, $22, $12
	br_if   	$pop218, BB18_123
BB18_125:                               # %my_clrsbll.exit
	block   	BB18_127
	i32.add 	$push219=, $14, $6
	i32.ne  	$push220=, $7, $pop219
	br_if   	$pop220, BB18_127
# BB#126:                               # %if.end753
	i32.const	$push221=, 0
	call    	exit, $pop221
	unreachable
BB18_127:                               # %if.then744
	call    	abort
	unreachable
BB18_128:                               # %if.then719
	call    	abort
	unreachable
BB18_129:                               # %if.then710
	call    	abort
	unreachable
BB18_130:                               # %if.then694
	call    	abort
	unreachable
BB18_131:                               # %if.then669
	call    	abort
	unreachable
BB18_132:                               # %if.then644
	call    	abort
	unreachable
BB18_133:                               # %if.then619
	call    	abort
	unreachable
BB18_134:                               # %if.then594
	call    	abort
	unreachable
BB18_135:                               # %if.then569
	call    	abort
	unreachable
BB18_136:                               # %if.then544
	call    	abort
	unreachable
BB18_137:                               # %if.then519
	call    	abort
	unreachable
BB18_138:                               # %if.then510
	call    	abort
	unreachable
BB18_139:                               # %if.then494
	call    	abort
	unreachable
BB18_140:                               # %if.then469
	call    	abort
	unreachable
BB18_141:                               # %if.then460
	call    	abort
	unreachable
BB18_142:                               # %if.then444
	call    	abort
	unreachable
BB18_143:                               # %if.then427
	call    	abort
	unreachable
BB18_144:                               # %if.then402
	call    	abort
	unreachable
BB18_145:                               # %if.then377
	call    	abort
	unreachable
BB18_146:                               # %if.then352
	call    	abort
	unreachable
BB18_147:                               # %if.then327
	call    	abort
	unreachable
BB18_148:                               # %if.then302
	call    	abort
	unreachable
BB18_149:                               # %if.then277
	call    	abort
	unreachable
BB18_150:                               # %if.then252
	call    	abort
	unreachable
BB18_151:                               # %if.then227
	call    	abort
	unreachable
BB18_152:                               # %if.then202
	call    	abort
	unreachable
BB18_153:                               # %if.then177
	call    	abort
	unreachable
BB18_154:                               # %if.then152
	call    	abort
	unreachable
BB18_155:                               # %if.then140
	call    	abort
	unreachable
BB18_156:                               # %if.then133
	call    	abort
	unreachable
BB18_157:                               # %if.then126
	call    	abort
	unreachable
BB18_158:                               # %if.then99
	call    	abort
	unreachable
BB18_159:                               # %if.then85
	call    	abort
	unreachable
BB18_160:                               # %if.then79
	call    	abort
	unreachable
BB18_161:                               # %if.then73
	call    	abort
	unreachable
BB18_162:                               # %if.then48
	call    	abort
	unreachable
BB18_163:                               # %if.then37
	call    	abort
	unreachable
BB18_164:                               # %if.then31
	call    	abort
	unreachable
BB18_165:                               # %if.then25
	call    	abort
	unreachable
BB18_166:                               # %if.then
	call    	abort
	unreachable
func_end18:
	.size	main, func_end18-main

	.type	ints,@object            # @ints
	.data
	.globl	ints
	.align	4
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

	.type	longs,@object           # @longs
	.globl	longs
	.align	4
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

	.type	longlongs,@object       # @longlongs
	.globl	longlongs
	.align	4
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


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
