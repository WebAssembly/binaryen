	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-bitops-1.c"
	.section	.text.my_ffs,"ax",@progbits
	.hidden	my_ffs
	.globl	my_ffs
	.type	my_ffs,@function
my_ffs:                                 # @my_ffs
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block   	.LBB0_4
	i32.const	$push4=, 0
	i32.eq  	$push5=, $0, $pop4
	br_if   	$pop5, .LBB0_4
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_3
	i32.const	$1=, 1
	i32.shl 	$push0=, $1, $2
	i32.and 	$push1=, $pop0, $0
	br_if   	$pop1, .LBB0_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$2=, $2, $1
	i32.const	$push2=, 32
	i32.lt_u	$push3=, $2, $pop2
	br_if   	$pop3, .LBB0_1
.LBB0_3:                                # %for.end
	i32.add 	$2=, $2, $1
.LBB0_4:                                # %cleanup
	return  	$2
.Lfunc_end0:
	.size	my_ffs, .Lfunc_end0-my_ffs

	.section	.text.my_ctz,"ax",@progbits
	.hidden	my_ctz
	.globl	my_ctz
	.type	my_ctz,@function
my_ctz:                                 # @my_ctz
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_3
	i32.const	$1=, 1
	i32.shl 	$push0=, $1, $2
	i32.and 	$push1=, $pop0, $0
	br_if   	$pop1, .LBB1_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$2=, $2, $1
	i32.const	$push2=, 32
	i32.lt_u	$push3=, $2, $pop2
	br_if   	$pop3, .LBB1_1
.LBB1_3:                                # %for.end
	return  	$2
.Lfunc_end1:
	.size	my_ctz, .Lfunc_end1-my_ctz

	.section	.text.my_clz,"ax",@progbits
	.hidden	my_clz
	.globl	my_clz
	.type	my_clz,@function
my_clz:                                 # @my_clz
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$2=, 31
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_3
	i32.const	$1=, 1
	i32.shl 	$push0=, $1, $2
	i32.and 	$push1=, $pop0, $0
	br_if   	$pop1, .LBB2_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$3=, $3, $1
	i32.const	$push2=, -1
	i32.add 	$2=, $2, $pop2
	i32.const	$push3=, 32
	i32.lt_u	$push4=, $3, $pop3
	br_if   	$pop4, .LBB2_1
.LBB2_3:                                # %for.end
	return  	$3
.Lfunc_end2:
	.size	my_clz, .Lfunc_end2-my_clz

	.section	.text.my_clrsb,"ax",@progbits
	.hidden	my_clrsb
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
.LBB3_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB3_3
	i32.shr_u	$push1=, $0, $3
	i32.and 	$push2=, $pop1, $2
	i32.ne  	$push3=, $pop2, $1
	br_if   	$pop3, .LBB3_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$push4=, 1
	i32.add 	$4=, $4, $pop4
	i32.const	$push5=, -1
	i32.add 	$3=, $3, $pop5
	i32.const	$push6=, 32
	i32.lt_u	$push7=, $4, $pop6
	br_if   	$pop7, .LBB3_1
.LBB3_3:                                # %for.end
	i32.const	$push8=, -1
	i32.add 	$push9=, $4, $pop8
	return  	$pop9
.Lfunc_end3:
	.size	my_clrsb, .Lfunc_end3-my_clrsb

	.section	.text.my_popcount,"ax",@progbits
	.hidden	my_popcount
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
.LBB4_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB4_2
	i32.const	$2=, 1
	i32.shl 	$push0=, $2, $4
	i32.and 	$push1=, $pop0, $0
	i32.ne  	$push2=, $pop1, $1
	i32.add 	$3=, $pop2, $3
	i32.add 	$4=, $4, $2
	i32.const	$push3=, 32
	i32.ne  	$push4=, $4, $pop3
	br_if   	$pop4, .LBB4_1
.LBB4_2:                                # %for.end
	return  	$3
.Lfunc_end4:
	.size	my_popcount, .Lfunc_end4-my_popcount

	.section	.text.my_parity,"ax",@progbits
	.hidden	my_parity
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
.LBB5_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB5_2
	i32.const	$2=, 1
	i32.shl 	$push0=, $2, $4
	i32.and 	$push1=, $pop0, $0
	i32.ne  	$push2=, $pop1, $1
	i32.add 	$3=, $pop2, $3
	i32.add 	$4=, $4, $2
	i32.const	$push3=, 32
	i32.ne  	$push4=, $4, $pop3
	br_if   	$pop4, .LBB5_1
.LBB5_2:                                # %for.end
	i32.and 	$push5=, $3, $2
	return  	$pop5
.Lfunc_end5:
	.size	my_parity, .Lfunc_end5-my_parity

	.section	.text.my_ffsl,"ax",@progbits
	.hidden	my_ffsl
	.globl	my_ffsl
	.type	my_ffsl,@function
my_ffsl:                                # @my_ffsl
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block   	.LBB6_4
	i32.const	$push4=, 0
	i32.eq  	$push5=, $0, $pop4
	br_if   	$pop5, .LBB6_4
.LBB6_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB6_3
	i32.const	$1=, 1
	i32.shl 	$push0=, $1, $2
	i32.and 	$push1=, $pop0, $0
	br_if   	$pop1, .LBB6_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.add 	$2=, $2, $1
	i32.const	$push2=, 32
	i32.lt_u	$push3=, $2, $pop2
	br_if   	$pop3, .LBB6_1
.LBB6_3:                                # %for.end
	i32.add 	$2=, $2, $1
.LBB6_4:                                # %cleanup
	return  	$2
.Lfunc_end6:
	.size	my_ffsl, .Lfunc_end6-my_ffsl

	.section	.text.my_ctzl,"ax",@progbits
	.hidden	my_ctzl
	.globl	my_ctzl
	.type	my_ctzl,@function
my_ctzl:                                # @my_ctzl
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
.LBB7_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB7_3
	i32.const	$1=, 1
	i32.shl 	$push0=, $1, $2
	i32.and 	$push1=, $pop0, $0
	br_if   	$pop1, .LBB7_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.add 	$2=, $2, $1
	i32.const	$push2=, 32
	i32.lt_u	$push3=, $2, $pop2
	br_if   	$pop3, .LBB7_1
.LBB7_3:                                # %for.end
	return  	$2
.Lfunc_end7:
	.size	my_ctzl, .Lfunc_end7-my_ctzl

	.section	.text.my_clzl,"ax",@progbits
	.hidden	my_clzl
	.globl	my_clzl
	.type	my_clzl,@function
my_clzl:                                # @my_clzl
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$2=, 31
.LBB8_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB8_3
	i32.const	$1=, 1
	i32.shl 	$push0=, $1, $2
	i32.and 	$push1=, $pop0, $0
	br_if   	$pop1, .LBB8_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.add 	$3=, $3, $1
	i32.const	$push2=, -1
	i32.add 	$2=, $2, $pop2
	i32.const	$push3=, 32
	i32.lt_u	$push4=, $3, $pop3
	br_if   	$pop4, .LBB8_1
.LBB8_3:                                # %for.end
	return  	$3
.Lfunc_end8:
	.size	my_clzl, .Lfunc_end8-my_clzl

	.section	.text.my_clrsbl,"ax",@progbits
	.hidden	my_clrsbl
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
.LBB9_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB9_3
	i32.shr_u	$push1=, $0, $3
	i32.and 	$push2=, $pop1, $2
	i32.ne  	$push3=, $pop2, $1
	br_if   	$pop3, .LBB9_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.const	$push4=, 1
	i32.add 	$4=, $4, $pop4
	i32.const	$push5=, -1
	i32.add 	$3=, $3, $pop5
	i32.const	$push6=, 32
	i32.lt_u	$push7=, $4, $pop6
	br_if   	$pop7, .LBB9_1
.LBB9_3:                                # %for.end
	i32.const	$push8=, -1
	i32.add 	$push9=, $4, $pop8
	return  	$pop9
.Lfunc_end9:
	.size	my_clrsbl, .Lfunc_end9-my_clrsbl

	.section	.text.my_popcountl,"ax",@progbits
	.hidden	my_popcountl
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
.LBB10_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB10_2
	i32.const	$2=, 1
	i32.shl 	$push0=, $2, $4
	i32.and 	$push1=, $pop0, $0
	i32.ne  	$push2=, $pop1, $1
	i32.add 	$3=, $pop2, $3
	i32.add 	$4=, $4, $2
	i32.const	$push3=, 32
	i32.ne  	$push4=, $4, $pop3
	br_if   	$pop4, .LBB10_1
.LBB10_2:                               # %for.end
	return  	$3
.Lfunc_end10:
	.size	my_popcountl, .Lfunc_end10-my_popcountl

	.section	.text.my_parityl,"ax",@progbits
	.hidden	my_parityl
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
.LBB11_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB11_2
	i32.const	$2=, 1
	i32.shl 	$push0=, $2, $4
	i32.and 	$push1=, $pop0, $0
	i32.ne  	$push2=, $pop1, $1
	i32.add 	$3=, $pop2, $3
	i32.add 	$4=, $4, $2
	i32.const	$push3=, 32
	i32.ne  	$push4=, $4, $pop3
	br_if   	$pop4, .LBB11_1
.LBB11_2:                               # %for.end
	i32.and 	$push5=, $3, $2
	return  	$pop5
.Lfunc_end11:
	.size	my_parityl, .Lfunc_end11-my_parityl

	.section	.text.my_ffsll,"ax",@progbits
	.hidden	my_ffsll
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
	block   	.LBB12_4
	i64.eq  	$push0=, $0, $1
	br_if   	$pop0, .LBB12_4
.LBB12_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB12_3
	i64.const	$2=, 1
	i64.shl 	$push1=, $2, $3
	i64.and 	$push2=, $pop1, $0
	i64.ne  	$push3=, $pop2, $1
	br_if   	$pop3, .LBB12_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB12_1 Depth=1
	i32.const	$push4=, 1
	i32.add 	$4=, $4, $pop4
	i64.add 	$3=, $3, $2
	i64.const	$push5=, 64
	i64.lt_u	$push6=, $3, $pop5
	br_if   	$pop6, .LBB12_1
.LBB12_3:                               # %for.end
	i32.const	$push7=, 1
	i32.add 	$4=, $4, $pop7
.LBB12_4:                               # %cleanup
	return  	$4
.Lfunc_end12:
	.size	my_ffsll, .Lfunc_end12-my_ffsll

	.section	.text.my_ctzll,"ax",@progbits
	.hidden	my_ctzll
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
.LBB13_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB13_3
	i64.const	$2=, 1
	i64.shl 	$push0=, $2, $3
	i64.and 	$push1=, $pop0, $0
	i64.ne  	$push2=, $pop1, $1
	br_if   	$pop2, .LBB13_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB13_1 Depth=1
	i32.const	$push3=, 1
	i32.add 	$4=, $4, $pop3
	i64.add 	$3=, $3, $2
	i64.const	$push4=, 64
	i64.lt_u	$push5=, $3, $pop4
	br_if   	$pop5, .LBB13_1
.LBB13_3:                               # %for.end
	return  	$4
.Lfunc_end13:
	.size	my_ctzll, .Lfunc_end13-my_ctzll

	.section	.text.my_clzll,"ax",@progbits
	.hidden	my_clzll
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
.LBB14_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB14_3
	i64.const	$2=, 1
	i64.const	$push0=, 4294967295
	i64.and 	$push1=, $3, $pop0
	i64.shl 	$push2=, $2, $pop1
	i64.and 	$push3=, $pop2, $0
	i64.ne  	$push4=, $pop3, $1
	br_if   	$pop4, .LBB14_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB14_1 Depth=1
	i32.const	$push5=, 1
	i32.add 	$5=, $5, $pop5
	i64.add 	$4=, $4, $2
	i64.const	$push6=, -1
	i64.add 	$3=, $3, $pop6
	i64.const	$push7=, 64
	i64.lt_u	$push8=, $4, $pop7
	br_if   	$pop8, .LBB14_1
.LBB14_3:                               # %for.end
	return  	$5
.Lfunc_end14:
	.size	my_clzll, .Lfunc_end14-my_clzll

	.section	.text.my_clrsbll,"ax",@progbits
	.hidden	my_clrsbll
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
.LBB15_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB15_3
	i64.shr_u	$push1=, $0, $3
	i64.and 	$push2=, $pop1, $2
	i64.ne  	$push3=, $pop2, $1
	br_if   	$pop3, .LBB15_3
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
	br_if   	$pop8, .LBB15_1
.LBB15_3:                               # %for.end
	i32.const	$push9=, -1
	i32.add 	$push10=, $5, $pop9
	return  	$pop10
.Lfunc_end15:
	.size	my_clrsbll, .Lfunc_end15-my_clrsbll

	.section	.text.my_popcountll,"ax",@progbits
	.hidden	my_popcountll
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
.LBB16_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB16_2
	i64.const	$2=, 1
	i64.shl 	$push0=, $2, $3
	i64.and 	$push1=, $pop0, $0
	i64.ne  	$push2=, $pop1, $1
	i32.add 	$4=, $pop2, $4
	i64.add 	$3=, $3, $2
	i64.const	$push3=, 64
	i64.ne  	$push4=, $3, $pop3
	br_if   	$pop4, .LBB16_1
.LBB16_2:                               # %for.end
	return  	$4
.Lfunc_end16:
	.size	my_popcountll, .Lfunc_end16-my_popcountll

	.section	.text.my_parityll,"ax",@progbits
	.hidden	my_parityll
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
.LBB17_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB17_2
	i64.const	$2=, 1
	i64.shl 	$push0=, $2, $3
	i64.and 	$push1=, $pop0, $0
	i64.ne  	$push2=, $pop1, $1
	i32.add 	$4=, $pop2, $4
	i64.add 	$3=, $3, $2
	i64.const	$push3=, 64
	i64.ne  	$push4=, $3, $pop3
	br_if   	$pop4, .LBB17_1
.LBB17_2:                               # %for.end
	i32.const	$push5=, 1
	i32.and 	$push6=, $4, $pop5
	return  	$pop6
.Lfunc_end17:
	.size	my_parityll, .Lfunc_end17-my_parityll

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i64, i32, i64, i64, i64, i32, i32, i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$3=, 0
	copy_local	$11=, $3
.LBB18_1:                               # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_2 Depth 2
                                        #     Child Loop BB18_8 Depth 2
                                        #     Child Loop BB18_12 Depth 2
                                        #     Child Loop BB18_18 Depth 2
                                        #     Child Loop BB18_21 Depth 2
                                        #     Child Loop BB18_23 Depth 2
	block   	.LBB18_166
	block   	.LBB18_165
	block   	.LBB18_164
	block   	.LBB18_163
	loop    	.LBB18_26
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
	block   	.LBB18_5
	i32.const	$push222=, 0
	i32.eq  	$push223=, $10, $pop222
	br_if   	$pop223, .LBB18_5
.LBB18_2:                               # %for.body.i
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_4
	i32.shl 	$push3=, $14, $7
	i32.and 	$push4=, $pop3, $10
	br_if   	$pop4, .LBB18_4
# BB#3:                                 # %for.inc.i
                                        #   in Loop: Header=BB18_2 Depth=2
	i32.add 	$7=, $7, $14
	i32.const	$push5=, 32
	i32.lt_u	$push6=, $7, $pop5
	br_if   	$pop6, .LBB18_2
.LBB18_4:                               # %for.end.i
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.add 	$19=, $7, $14
.LBB18_5:                               # %my_ffs.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.ne  	$push7=, $20, $19
	br_if   	$pop7, .LBB18_166
# BB#6:                                 # %if.end
                                        #   in Loop: Header=BB18_1 Depth=1
	block   	.LBB18_17
	i32.const	$push224=, 0
	i32.eq  	$push225=, $10, $pop224
	br_if   	$pop225, .LBB18_17
# BB#7:                                 # %land.lhs.true
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.clz 	$20=, $10
	i32.const	$7=, 0
	i32.const	$19=, 31
.LBB18_8:                               # %for.body.i822
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_10
	i32.shl 	$push8=, $14, $19
	i32.and 	$push9=, $pop8, $10
	br_if   	$pop9, .LBB18_10
# BB#9:                                 # %for.inc.i825
                                        #   in Loop: Header=BB18_8 Depth=2
	i32.const	$push10=, -1
	i32.add 	$19=, $19, $pop10
	i32.add 	$7=, $7, $14
	i32.const	$push11=, 32
	i32.lt_u	$push12=, $7, $pop11
	br_if   	$pop12, .LBB18_8
.LBB18_10:                              # %my_clz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	block   	.LBB18_16
	i32.ne  	$push13=, $20, $7
	br_if   	$pop13, .LBB18_16
# BB#11:                                # %land.lhs.true13
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$7=, 0
.LBB18_12:                              # %for.body.i889
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_14
	i32.shl 	$push14=, $14, $7
	i32.and 	$push15=, $pop14, $10
	br_if   	$pop15, .LBB18_14
# BB#13:                                # %for.inc.i892
                                        #   in Loop: Header=BB18_12 Depth=2
	i32.add 	$7=, $7, $14
	i32.const	$push16=, 32
	i32.lt_u	$push17=, $7, $pop16
	br_if   	$pop17, .LBB18_12
.LBB18_14:                              # %my_ctz.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.eq  	$push18=, $18, $7
	br_if   	$pop18, .LBB18_17
# BB#15:                                # %if.then18
	call    	abort
	unreachable
.LBB18_16:                              # %if.then9
	call    	abort
	unreachable
.LBB18_17:                              # %if.end19
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.call	$20=, __builtin_clrsb, $10
	i32.load	$19=, 0($1)
	i32.const	$5=, 31
	i32.shr_u	$1=, $19, $5
	i32.const	$10=, 30
	copy_local	$7=, $14
.LBB18_18:                              # %for.body.i974
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_20
	i32.shr_u	$push19=, $19, $10
	i32.and 	$push20=, $pop19, $14
	i32.ne  	$push21=, $pop20, $1
	br_if   	$pop21, .LBB18_20
# BB#19:                                # %for.inc.i977
                                        #   in Loop: Header=BB18_18 Depth=2
	i32.const	$push22=, 1
	i32.add 	$7=, $7, $pop22
	i32.const	$push23=, -1
	i32.add 	$10=, $10, $pop23
	i32.const	$push24=, 32
	i32.lt_u	$push25=, $7, $pop24
	br_if   	$pop25, .LBB18_18
.LBB18_20:                              # %my_clrsb.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$6=, -1
	i32.const	$18=, 0
	copy_local	$1=, $18
	copy_local	$10=, $18
	i32.add 	$push26=, $7, $6
	i32.ne  	$push27=, $20, $pop26
	br_if   	$pop27, .LBB18_165
.LBB18_21:                              # %for.body.i1069
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_22
	i32.const	$14=, 1
	i32.shl 	$push28=, $14, $10
	i32.and 	$push29=, $pop28, $19
	i32.ne  	$push30=, $pop29, $18
	i32.add 	$1=, $pop30, $1
	i32.add 	$10=, $10, $14
	i32.const	$7=, 32
	i32.ne  	$push31=, $10, $7
	br_if   	$pop31, .LBB18_21
.LBB18_22:                              # %my_popcount.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.const	$20=, 0
	copy_local	$18=, $20
	copy_local	$10=, $20
	i32.popcnt	$push32=, $19
	i32.ne  	$push33=, $pop32, $1
	br_if   	$pop33, .LBB18_164
.LBB18_23:                              # %for.body.i1161
                                        #   Parent Loop BB18_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_24
	i32.shl 	$push34=, $14, $10
	i32.and 	$push35=, $pop34, $19
	i32.ne  	$push36=, $pop35, $20
	i32.add 	$18=, $pop36, $18
	i32.add 	$10=, $10, $14
	i32.ne  	$push37=, $10, $7
	br_if   	$pop37, .LBB18_23
.LBB18_24:                              # %my_parity.exit
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.xor 	$push38=, $18, $1
	i32.and 	$push39=, $pop38, $14
	br_if   	$pop39, .LBB18_163
# BB#25:                                # %for.cond
                                        #   in Loop: Header=BB18_1 Depth=1
	i32.add 	$11=, $11, $14
	i32.const	$8=, 0
	i32.const	$9=, 12
	copy_local	$0=, $8
	i32.le_u	$push40=, $11, $9
	br_if   	$pop40, .LBB18_1
.LBB18_26:                              # %for.body41
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_27 Depth 2
                                        #     Child Loop BB18_33 Depth 2
                                        #     Child Loop BB18_37 Depth 2
                                        #     Child Loop BB18_43 Depth 2
                                        #     Child Loop BB18_46 Depth 2
                                        #     Child Loop BB18_48 Depth 2
	block   	.LBB18_162
	block   	.LBB18_161
	block   	.LBB18_160
	block   	.LBB18_159
	loop    	.LBB18_51
	i32.const	$push42=, longs
	i32.shl 	$push41=, $0, $4
	i32.add 	$18=, $pop42, $pop41
	i32.load	$19=, 0($18)
	i32.ctz 	$20=, $19
	i32.add 	$push43=, $20, $14
	i32.select	$11=, $19, $pop43, $8
	copy_local	$10=, $8
	copy_local	$1=, $8
	block   	.LBB18_30
	i32.const	$push226=, 0
	i32.eq  	$push227=, $19, $pop226
	br_if   	$pop227, .LBB18_30
.LBB18_27:                              # %for.body.i1251
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_29
	i32.shl 	$push44=, $14, $10
	i32.and 	$push45=, $pop44, $19
	br_if   	$pop45, .LBB18_29
# BB#28:                                # %for.inc.i1254
                                        #   in Loop: Header=BB18_27 Depth=2
	i32.add 	$10=, $10, $14
	i32.lt_u	$push46=, $10, $7
	br_if   	$pop46, .LBB18_27
.LBB18_29:                              # %for.end.i1257
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.add 	$1=, $10, $14
.LBB18_30:                              # %my_ffsl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.ne  	$push47=, $11, $1
	br_if   	$pop47, .LBB18_162
# BB#31:                                # %if.end49
                                        #   in Loop: Header=BB18_26 Depth=1
	block   	.LBB18_42
	i32.const	$push228=, 0
	i32.eq  	$push229=, $19, $pop228
	br_if   	$pop229, .LBB18_42
# BB#32:                                # %land.lhs.true52
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.clz 	$11=, $19
	i32.const	$10=, 0
	copy_local	$1=, $5
.LBB18_33:                              # %for.body.i1346
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_35
	i32.shl 	$push48=, $14, $1
	i32.and 	$push49=, $pop48, $19
	br_if   	$pop49, .LBB18_35
# BB#34:                                # %for.inc.i1349
                                        #   in Loop: Header=BB18_33 Depth=2
	i32.add 	$10=, $10, $14
	i32.add 	$1=, $1, $6
	i32.lt_u	$push50=, $10, $7
	br_if   	$pop50, .LBB18_33
.LBB18_35:                              # %my_clzl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	block   	.LBB18_41
	i32.ne  	$push51=, $11, $10
	br_if   	$pop51, .LBB18_41
# BB#36:                                # %land.lhs.true61
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.const	$10=, 0
.LBB18_37:                              # %for.body.i1438
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_39
	i32.shl 	$push52=, $14, $10
	i32.and 	$push53=, $pop52, $19
	br_if   	$pop53, .LBB18_39
# BB#38:                                # %for.inc.i1441
                                        #   in Loop: Header=BB18_37 Depth=2
	i32.add 	$10=, $10, $14
	i32.lt_u	$push54=, $10, $7
	br_if   	$pop54, .LBB18_37
.LBB18_39:                              # %my_ctzl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.eq  	$push55=, $20, $10
	br_if   	$pop55, .LBB18_42
# BB#40:                                # %if.then66
	call    	abort
	unreachable
.LBB18_41:                              # %if.then57
	call    	abort
	unreachable
.LBB18_42:                              # %if.end67
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.call	$11=, __builtin_clrsbl, $19
	i32.load	$1=, 0($18)
	i32.const	$3=, 31
	i32.shr_u	$18=, $1, $3
	i32.const	$19=, 30
	copy_local	$10=, $14
.LBB18_43:                              # %for.body.i1532
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_45
	i32.shr_u	$push56=, $1, $19
	i32.and 	$push57=, $pop56, $14
	i32.ne  	$push58=, $pop57, $18
	br_if   	$pop58, .LBB18_45
# BB#44:                                # %for.inc.i1535
                                        #   in Loop: Header=BB18_43 Depth=2
	i32.const	$push59=, 1
	i32.add 	$10=, $10, $pop59
	i32.add 	$19=, $19, $6
	i32.lt_u	$push60=, $10, $7
	br_if   	$pop60, .LBB18_43
.LBB18_45:                              # %my_clrsbl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.const	$20=, 0
	copy_local	$18=, $20
	copy_local	$19=, $20
	i32.add 	$push61=, $10, $6
	i32.ne  	$push62=, $11, $pop61
	br_if   	$pop62, .LBB18_161
.LBB18_46:                              # %for.body.i1630
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_47
	i32.const	$10=, 1
	i32.shl 	$push63=, $10, $19
	i32.and 	$push64=, $pop63, $1
	i32.ne  	$push65=, $pop64, $20
	i32.add 	$18=, $pop65, $18
	i32.add 	$19=, $19, $10
	i32.ne  	$push66=, $19, $7
	br_if   	$pop66, .LBB18_46
.LBB18_47:                              # %my_popcountl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.const	$11=, 0
	copy_local	$20=, $11
	copy_local	$19=, $11
	i32.popcnt	$push67=, $1
	i32.ne  	$push68=, $pop67, $18
	br_if   	$pop68, .LBB18_160
.LBB18_48:                              # %for.body.i1723
                                        #   Parent Loop BB18_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_49
	i32.shl 	$push69=, $10, $19
	i32.and 	$push70=, $pop69, $1
	i32.ne  	$push71=, $pop70, $11
	i32.add 	$20=, $pop71, $20
	i32.add 	$19=, $19, $10
	i32.ne  	$push72=, $19, $7
	br_if   	$pop72, .LBB18_48
.LBB18_49:                              # %my_parityl.exit
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.xor 	$push73=, $20, $18
	i32.and 	$push74=, $pop73, $10
	br_if   	$pop74, .LBB18_159
# BB#50:                                # %for.cond39
                                        #   in Loop: Header=BB18_26 Depth=1
	i32.add 	$0=, $0, $10
	i32.const	$1=, 0
	copy_local	$18=, $1
	i32.le_u	$push75=, $0, $9
	br_if   	$pop75, .LBB18_26
.LBB18_51:                              # %for.body92
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB18_52 Depth 2
                                        #     Child Loop BB18_58 Depth 2
                                        #     Child Loop BB18_62 Depth 2
                                        #     Child Loop BB18_68 Depth 2
                                        #     Child Loop BB18_72 Depth 2
                                        #     Child Loop BB18_74 Depth 2
	block   	.LBB18_158
	block   	.LBB18_157
	block   	.LBB18_156
	block   	.LBB18_155
	loop    	.LBB18_77
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
	block   	.LBB18_55
	br_if   	$19, .LBB18_55
.LBB18_52:                              # %for.body.i1814
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_54
	i64.shl 	$push81=, $21, $22
	i64.and 	$push82=, $pop81, $17
	i64.ne  	$push83=, $pop82, $12
	br_if   	$pop83, .LBB18_54
# BB#53:                                # %for.inc.i1818
                                        #   in Loop: Header=BB18_52 Depth=2
	i64.add 	$22=, $22, $21
	i32.add 	$14=, $14, $10
	i64.const	$push84=, 64
	i64.lt_u	$push85=, $22, $pop84
	br_if   	$pop85, .LBB18_52
.LBB18_54:                              # %for.end.i1821
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.add 	$11=, $14, $10
.LBB18_55:                              # %my_ffsll.exit1823
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.ne  	$push86=, $8, $11
	br_if   	$pop86, .LBB18_158
# BB#56:                                # %if.end100
                                        #   in Loop: Header=BB18_51 Depth=1
	i64.const	$13=, 0
	block   	.LBB18_67
	i64.eq  	$push87=, $17, $13
	br_if   	$pop87, .LBB18_67
# BB#57:                                # %land.lhs.true103
                                        #   in Loop: Header=BB18_51 Depth=1
	i64.const	$22=, 63
	copy_local	$12=, $13
	i64.clz 	$push88=, $17
	i32.wrap/i64	$19=, $pop88
	i32.const	$14=, 0
.LBB18_58:                              # %for.body.i1902
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_60
	i64.const	$push89=, 4294967295
	i64.and 	$push90=, $22, $pop89
	i64.shl 	$push91=, $21, $pop90
	i64.and 	$push92=, $pop91, $17
	i64.ne  	$push93=, $pop92, $13
	br_if   	$pop93, .LBB18_60
# BB#59:                                # %for.inc.i1906
                                        #   in Loop: Header=BB18_58 Depth=2
	i64.const	$push94=, -1
	i64.add 	$22=, $22, $pop94
	i64.add 	$12=, $12, $21
	i32.add 	$14=, $14, $10
	i64.const	$push95=, 64
	i64.lt_u	$push96=, $12, $pop95
	br_if   	$pop96, .LBB18_58
.LBB18_60:                              # %my_clzll.exit1909
                                        #   in Loop: Header=BB18_51 Depth=1
	block   	.LBB18_66
	i32.ne  	$push97=, $19, $14
	br_if   	$pop97, .LBB18_66
# BB#61:                                # %land.lhs.true113
                                        #   in Loop: Header=BB18_51 Depth=1
	i64.const	$12=, 0
	copy_local	$22=, $12
	i32.wrap/i64	$19=, $16
	i32.const	$14=, 0
.LBB18_62:                              # %for.body.i1948
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_64
	i64.shl 	$push98=, $21, $22
	i64.and 	$push99=, $pop98, $17
	i64.ne  	$push100=, $pop99, $12
	br_if   	$pop100, .LBB18_64
# BB#63:                                # %for.inc.i1952
                                        #   in Loop: Header=BB18_62 Depth=2
	i64.add 	$22=, $22, $21
	i32.add 	$14=, $14, $10
	i64.const	$push101=, 64
	i64.lt_u	$push102=, $22, $pop101
	br_if   	$pop102, .LBB18_62
.LBB18_64:                              # %my_ctzll.exit1955
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.eq  	$push103=, $19, $14
	br_if   	$pop103, .LBB18_67
# BB#65:                                # %if.then119
	call    	abort
	unreachable
.LBB18_66:                              # %if.then109
	call    	abort
	unreachable
.LBB18_67:                              # %if.end120
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.call	$19=, __builtin_clrsbll, $17
	i64.load	$17=, 0($20)
	i64.const	$16=, 63
	i64.shr_u	$13=, $17, $16
	i64.const	$22=, 62
	copy_local	$12=, $21
	copy_local	$14=, $10
.LBB18_68:                              # %for.body.i2018
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_70
	i64.shr_u	$push104=, $17, $22
	i64.and 	$push105=, $pop104, $21
	i64.ne  	$push106=, $pop105, $13
	br_if   	$pop106, .LBB18_70
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
	br_if   	$pop111, .LBB18_68
.LBB18_70:                              # %my_clrsbll.exit2026
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.add 	$push112=, $14, $6
	i32.ne  	$push113=, $19, $pop112
	br_if   	$pop113, .LBB18_157
# BB#71:                                # %if.end127
                                        #   in Loop: Header=BB18_51 Depth=1
	i64.const	$13=, 0
	i64.popcnt	$2=, $17
	copy_local	$22=, $13
	i32.const	$14=, 0
.LBB18_72:                              # %for.body.i2110
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_73
	i64.const	$21=, 1
	i64.shl 	$push114=, $21, $22
	i64.and 	$push115=, $pop114, $17
	i64.ne  	$push116=, $pop115, $13
	i32.add 	$14=, $pop116, $14
	i64.add 	$22=, $22, $21
	i64.const	$12=, 64
	i64.ne  	$push117=, $22, $12
	br_if   	$pop117, .LBB18_72
.LBB18_73:                              # %my_popcountll.exit2112
                                        #   in Loop: Header=BB18_51 Depth=1
	i64.const	$13=, 0
	copy_local	$22=, $13
	i32.const	$19=, 0
	i32.wrap/i64	$push118=, $2
	i32.ne  	$push119=, $pop118, $14
	br_if   	$pop119, .LBB18_156
.LBB18_74:                              # %for.body.i2196
                                        #   Parent Loop BB18_51 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB18_75
	i64.shl 	$push120=, $21, $22
	i64.and 	$push121=, $pop120, $17
	i64.ne  	$push122=, $pop121, $13
	i32.add 	$19=, $pop122, $19
	i64.add 	$22=, $22, $21
	i64.ne  	$push123=, $22, $12
	br_if   	$pop123, .LBB18_74
.LBB18_75:                              # %my_parityll.exit2199
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.const	$20=, 1
	i32.xor 	$push124=, $19, $14
	i32.and 	$push125=, $pop124, $20
	br_if   	$pop125, .LBB18_155
# BB#76:                                # %for.cond90
                                        #   in Loop: Header=BB18_51 Depth=1
	i32.add 	$18=, $18, $20
	i32.le_u	$push126=, $18, $9
	br_if   	$pop126, .LBB18_51
.LBB18_77:                              # %if.end148
	i32.const	$19=, 0
	block   	.LBB18_154
	i32.call	$push127=, __builtin_clrsb, $19
	i32.ne  	$push128=, $pop127, $3
	br_if   	$pop128, .LBB18_154
# BB#78:                                # %my_clrsb.exit2770
	i32.call	$10=, __builtin_clrsb, $20
	i32.const	$14=, 30
	block   	.LBB18_153
	i32.ne  	$push129=, $10, $14
	br_if   	$pop129, .LBB18_153
# BB#79:                                # %if.end198
	block   	.LBB18_152
	i32.const	$push130=, -2147483648
	i32.call	$push131=, __builtin_clrsb, $pop130
	br_if   	$pop131, .LBB18_152
# BB#80:                                # %my_clrsb.exit2597
	block   	.LBB18_151
	i32.const	$push132=, 1073741824
	i32.call	$push133=, __builtin_clrsb, $pop132
	br_if   	$pop133, .LBB18_151
# BB#81:                                # %my_clrsb.exit2514
	block   	.LBB18_150
	i32.const	$push134=, 65536
	i32.call	$push135=, __builtin_clrsb, $pop134
	i32.const	$push136=, 14
	i32.ne  	$push137=, $pop135, $pop136
	br_if   	$pop137, .LBB18_150
# BB#82:                                # %my_clrsb.exit2432
	i32.const	$push138=, 32768
	i32.call	$10=, __builtin_clrsb, $pop138
	i32.const	$1=, 15
	block   	.LBB18_149
	i32.ne  	$push139=, $10, $1
	br_if   	$pop139, .LBB18_149
# BB#83:                                # %my_clrsb.exit2348
	block   	.LBB18_148
	i32.const	$push140=, -1515870811
	i32.call	$push141=, __builtin_clrsb, $pop140
	br_if   	$pop141, .LBB18_148
# BB#84:                                # %my_clrsb.exit2273
	block   	.LBB18_147
	i32.const	$push142=, 1515870810
	i32.call	$push143=, __builtin_clrsb, $pop142
	br_if   	$pop143, .LBB18_147
# BB#85:                                # %for.body.i2179
	block   	.LBB18_146
	i32.const	$push144=, -889323520
	i32.call	$push145=, __builtin_clrsb, $pop144
	i32.ne  	$push146=, $pop145, $20
	br_if   	$pop146, .LBB18_146
# BB#86:                                # %for.body.i2093
	block   	.LBB18_145
	i32.const	$push147=, 13303296
	i32.call	$push148=, __builtin_clrsb, $pop147
	i32.const	$push149=, 7
	i32.ne  	$push150=, $pop148, $pop149
	br_if   	$pop150, .LBB18_145
# BB#87:                                # %for.body.i2004
	block   	.LBB18_144
	i32.const	$push151=, 51966
	i32.call	$push152=, __builtin_clrsb, $pop151
	i32.ne  	$push153=, $pop152, $1
	br_if   	$pop153, .LBB18_144
# BB#88:                                # %if.end423
	i32.call	$18=, __builtin_clrsb, $6
	copy_local	$10=, $20
.LBB18_89:                              # %for.body.i1935
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB18_91
	i32.shr_u	$push154=, $6, $14
	i32.and 	$push155=, $pop154, $20
	i32.const	$push230=, 0
	i32.eq  	$push231=, $pop155, $pop230
	br_if   	$pop231, .LBB18_91
# BB#90:                                # %for.inc.i1938
                                        #   in Loop: Header=BB18_89 Depth=1
	i32.const	$push156=, 1
	i32.add 	$10=, $10, $pop156
	i32.add 	$14=, $14, $6
	i32.lt_u	$push157=, $10, $7
	br_if   	$pop157, .LBB18_89
.LBB18_91:                              # %my_clrsb.exit1942
	block   	.LBB18_143
	i32.add 	$push158=, $10, $6
	i32.ne  	$push159=, $18, $pop158
	br_if   	$pop159, .LBB18_143
# BB#92:                                # %if.end440
	i64.const	$22=, 0
	i32.call	$14=, __builtin_clrsbll, $22
	i32.const	$10=, 63
	block   	.LBB18_142
	i32.ne  	$push160=, $14, $10
	br_if   	$pop160, .LBB18_142
.LBB18_93:                              # %for.body.i1844
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB18_95
	i32.wrap/i64	$push161=, $16
	i32.const	$push232=, 0
	i32.eq  	$push233=, $pop161, $pop232
	br_if   	$pop233, .LBB18_95
# BB#94:                                # %for.inc.i1848
                                        #   in Loop: Header=BB18_93 Depth=1
	i32.const	$push162=, 1
	i32.add 	$19=, $19, $pop162
	i64.const	$push163=, -1
	i64.add 	$16=, $16, $pop163
	i64.add 	$22=, $22, $21
	i64.lt_u	$push164=, $22, $12
	br_if   	$pop164, .LBB18_93
.LBB18_95:                              # %my_clzll.exit1851
	block   	.LBB18_141
	i32.ne  	$push165=, $19, $10
	br_if   	$pop165, .LBB18_141
# BB#96:                                # %if.end465
	i32.call	$19=, __builtin_clrsbll, $21
.LBB18_97:                              # %for.body.i1799
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB18_99
	i64.const	$22=, 63
	i32.const	$14=, 62
	i64.eq  	$push166=, $21, $22
	br_if   	$pop166, .LBB18_99
# BB#98:                                # %for.inc.i1803
                                        #   in Loop: Header=BB18_97 Depth=1
	i64.const	$push167=, 1
	i64.add 	$21=, $21, $pop167
	copy_local	$14=, $10
	i64.lt_u	$push168=, $21, $12
	br_if   	$pop168, .LBB18_97
.LBB18_99:                              # %my_clrsbll.exit1807
	i64.const	$21=, 0
	copy_local	$17=, $21
	block   	.LBB18_140
	i32.ne  	$push169=, $19, $14
	br_if   	$pop169, .LBB18_140
.LBB18_100:                             # %for.body.i1759
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB18_103
	loop    	.LBB18_102
	i64.eq  	$push170=, $17, $22
	br_if   	$pop170, .LBB18_103
# BB#101:                               # %for.inc.i1763
                                        #   in Loop: Header=BB18_100 Depth=1
	i64.const	$push171=, 1
	i64.add 	$17=, $17, $pop171
	i64.lt_u	$push172=, $17, $12
	br_if   	$pop172, .LBB18_100
.LBB18_102:                             # %if.then481
	call    	abort
	unreachable
.LBB18_103:                             # %for.body.i1731
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB18_106
	loop    	.LBB18_105
	i64.eq  	$push173=, $21, $22
	br_if   	$pop173, .LBB18_106
# BB#104:                               # %for.inc.i1735
                                        #   in Loop: Header=BB18_103 Depth=1
	i64.const	$push174=, 1
	i64.add 	$21=, $21, $pop174
	i64.lt_u	$push175=, $21, $12
	br_if   	$pop175, .LBB18_103
.LBB18_105:                             # %if.then489
	call    	abort
	unreachable
.LBB18_106:                             # %if.end490
	block   	.LBB18_139
	i64.const	$push176=, -9223372036854775808
	i32.call	$push177=, __builtin_clrsbll, $pop176
	br_if   	$pop177, .LBB18_139
# BB#107:                               # %for.body.i1665
	i64.const	$16=, -1
	copy_local	$21=, $16
	i32.const	$14=, 1
.LBB18_108:                             # %for.body.i1652
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB18_109
	i64.const	$13=, 1
	i64.add 	$21=, $21, $13
	i64.add 	$17=, $22, $16
	i32.wrap/i64	$10=, $22
	copy_local	$22=, $17
	i32.ne  	$push178=, $10, $14
	br_if   	$pop178, .LBB18_108
.LBB18_109:                             # %my_clzll.exit1659
	block   	.LBB18_138
	i32.wrap/i64	$push179=, $21
	i32.const	$push180=, 62
	i32.ne  	$push181=, $pop179, $pop180
	br_if   	$pop181, .LBB18_138
# BB#110:                               # %for.body.i1612
	block   	.LBB18_137
	i64.const	$push182=, 2
	i32.call	$push183=, __builtin_clrsbll, $pop182
	i32.const	$push184=, 61
	i32.ne  	$push185=, $pop183, $pop184
	br_if   	$pop185, .LBB18_137
# BB#111:                               # %my_clrsbll.exit1525
	block   	.LBB18_136
	i64.const	$push186=, 4611686018427387904
	i32.call	$push187=, __builtin_clrsbll, $pop186
	br_if   	$pop187, .LBB18_136
# BB#112:                               # %for.body.i1425
	block   	.LBB18_135
	i64.const	$push188=, 4294967296
	i32.call	$push189=, __builtin_clrsbll, $pop188
	i32.const	$push190=, 30
	i32.ne  	$push191=, $pop189, $pop190
	br_if   	$pop191, .LBB18_135
# BB#113:                               # %for.body.i1332
	block   	.LBB18_134
	i64.const	$push192=, 2147483648
	i32.call	$push193=, __builtin_clrsbll, $pop192
	i32.ne  	$push194=, $pop193, $3
	br_if   	$pop194, .LBB18_134
# BB#114:                               # %my_clrsbll.exit1245
	block   	.LBB18_133
	i64.const	$push195=, -6510615555426900571
	i32.call	$push196=, __builtin_clrsbll, $pop195
	br_if   	$pop196, .LBB18_133
# BB#115:                               # %my_clrsbll.exit1152
	block   	.LBB18_132
	i64.const	$push197=, 6510615555426900570
	i32.call	$push198=, __builtin_clrsbll, $pop197
	br_if   	$pop198, .LBB18_132
# BB#116:                               # %for.body.i1053
	block   	.LBB18_131
	i64.const	$push199=, -3819392241693097984
	i32.call	$push200=, __builtin_clrsbll, $pop199
	i32.ne  	$push201=, $pop200, $14
	br_if   	$pop201, .LBB18_131
# BB#117:                               # %for.body.i964
	block   	.LBB18_130
	i64.const	$push202=, 223195676147712
	i32.call	$push203=, __builtin_clrsbll, $pop202
	i32.ne  	$push204=, $pop203, $1
	br_if   	$pop204, .LBB18_130
# BB#118:                               # %for.body.i925
	i64.const	$15=, -1
	i64.const	$21=, 63
	copy_local	$22=, $15
.LBB18_119:                             # %for.body.i913
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB18_120
	i64.const	$push205=, 4294967295
	i64.and 	$2=, $21, $pop205
	i64.const	$17=, 3405695742
	i64.add 	$22=, $22, $13
	i64.add 	$21=, $21, $15
	i64.const	$16=, 0
	i64.shl 	$push206=, $13, $2
	i64.and 	$push207=, $pop206, $17
	i64.eq  	$push208=, $pop207, $16
	br_if   	$pop208, .LBB18_119
.LBB18_120:                             # %my_clzll.exit
	block   	.LBB18_129
	i32.wrap/i64	$push209=, $22
	i32.ne  	$push210=, $pop209, $7
	br_if   	$pop210, .LBB18_129
# BB#121:                               # %for.body.i877
	block   	.LBB18_128
	i32.call	$push211=, __builtin_clrsbll, $17
	i32.ne  	$push212=, $pop211, $3
	br_if   	$pop212, .LBB18_128
# BB#122:                               # %if.end740
	i64.const	$17=, -1
	i32.call	$7=, __builtin_clrsbll, $17
	i64.const	$21=, 62
	copy_local	$22=, $13
.LBB18_123:                             # %for.body.i812
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB18_125
	i64.shr_u	$push213=, $17, $21
	i64.and 	$push214=, $pop213, $13
	i64.eq  	$push215=, $pop214, $16
	br_if   	$pop215, .LBB18_125
# BB#124:                               # %for.inc.i816
                                        #   in Loop: Header=BB18_123 Depth=1
	i32.const	$push217=, 1
	i32.add 	$14=, $14, $pop217
	i64.const	$push216=, 1
	i64.add 	$22=, $22, $pop216
	i64.add 	$21=, $21, $17
	i64.lt_u	$push218=, $22, $12
	br_if   	$pop218, .LBB18_123
.LBB18_125:                             # %my_clrsbll.exit
	block   	.LBB18_127
	i32.add 	$push219=, $14, $6
	i32.ne  	$push220=, $7, $pop219
	br_if   	$pop220, .LBB18_127
# BB#126:                               # %if.end753
	i32.const	$push221=, 0
	call    	exit, $pop221
	unreachable
.LBB18_127:                             # %if.then744
	call    	abort
	unreachable
.LBB18_128:                             # %if.then719
	call    	abort
	unreachable
.LBB18_129:                             # %if.then710
	call    	abort
	unreachable
.LBB18_130:                             # %if.then694
	call    	abort
	unreachable
.LBB18_131:                             # %if.then669
	call    	abort
	unreachable
.LBB18_132:                             # %if.then644
	call    	abort
	unreachable
.LBB18_133:                             # %if.then619
	call    	abort
	unreachable
.LBB18_134:                             # %if.then594
	call    	abort
	unreachable
.LBB18_135:                             # %if.then569
	call    	abort
	unreachable
.LBB18_136:                             # %if.then544
	call    	abort
	unreachable
.LBB18_137:                             # %if.then519
	call    	abort
	unreachable
.LBB18_138:                             # %if.then510
	call    	abort
	unreachable
.LBB18_139:                             # %if.then494
	call    	abort
	unreachable
.LBB18_140:                             # %if.then469
	call    	abort
	unreachable
.LBB18_141:                             # %if.then460
	call    	abort
	unreachable
.LBB18_142:                             # %if.then444
	call    	abort
	unreachable
.LBB18_143:                             # %if.then427
	call    	abort
	unreachable
.LBB18_144:                             # %if.then402
	call    	abort
	unreachable
.LBB18_145:                             # %if.then377
	call    	abort
	unreachable
.LBB18_146:                             # %if.then352
	call    	abort
	unreachable
.LBB18_147:                             # %if.then327
	call    	abort
	unreachable
.LBB18_148:                             # %if.then302
	call    	abort
	unreachable
.LBB18_149:                             # %if.then277
	call    	abort
	unreachable
.LBB18_150:                             # %if.then252
	call    	abort
	unreachable
.LBB18_151:                             # %if.then227
	call    	abort
	unreachable
.LBB18_152:                             # %if.then202
	call    	abort
	unreachable
.LBB18_153:                             # %if.then177
	call    	abort
	unreachable
.LBB18_154:                             # %if.then152
	call    	abort
	unreachable
.LBB18_155:                             # %if.then140
	call    	abort
	unreachable
.LBB18_156:                             # %if.then133
	call    	abort
	unreachable
.LBB18_157:                             # %if.then126
	call    	abort
	unreachable
.LBB18_158:                             # %if.then99
	call    	abort
	unreachable
.LBB18_159:                             # %if.then85
	call    	abort
	unreachable
.LBB18_160:                             # %if.then79
	call    	abort
	unreachable
.LBB18_161:                             # %if.then73
	call    	abort
	unreachable
.LBB18_162:                             # %if.then48
	call    	abort
	unreachable
.LBB18_163:                             # %if.then37
	call    	abort
	unreachable
.LBB18_164:                             # %if.then31
	call    	abort
	unreachable
.LBB18_165:                             # %if.then25
	call    	abort
	unreachable
.LBB18_166:                             # %if.then
	call    	abort
	unreachable
.Lfunc_end18:
	.size	main, .Lfunc_end18-main

	.hidden	ints                    # @ints
	.type	ints,@object
	.section	.data.ints,"aw",@progbits
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

	.hidden	longs                   # @longs
	.type	longs,@object
	.section	.data.longs,"aw",@progbits
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

	.hidden	longlongs               # @longlongs
	.type	longlongs,@object
	.section	.data.longlongs,"aw",@progbits
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
