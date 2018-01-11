	.text
	.file	"pr51581-2.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$0=, -16384
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push7=, c+16384
	i32.add 	$push0=, $0, $pop7
	i32.const	$push6=, a+16384
	i32.add 	$push1=, $0, $pop6
	i32.load	$push2=, 0($pop1)
	i32.const	$push5=, 3
	i32.rem_s	$push3=, $pop2, $pop5
	i32.store	0($pop0), $pop3
	i32.const	$push4=, 4
	i32.add 	$0=, $0, $pop4
	br_if   	0, $0           # 0: up to label0
# %bb.2:                                # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$0=, -16384
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push7=, d+16384
	i32.add 	$push0=, $0, $pop7
	i32.const	$push6=, b+16384
	i32.add 	$push1=, $0, $pop6
	i32.load	$push2=, 0($pop1)
	i32.const	$push5=, 3
	i32.rem_u	$push3=, $pop2, $pop5
	i32.store	0($pop0), $pop3
	i32.const	$push4=, 4
	i32.add 	$0=, $0, $pop4
	br_if   	0, $0           # 0: up to label1
# %bb.2:                                # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$0=, -16384
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push7=, c+16384
	i32.add 	$push0=, $0, $pop7
	i32.const	$push6=, a+16384
	i32.add 	$push1=, $0, $pop6
	i32.load	$push2=, 0($pop1)
	i32.const	$push5=, 18
	i32.rem_s	$push3=, $pop2, $pop5
	i32.store	0($pop0), $pop3
	i32.const	$push4=, 4
	i32.add 	$0=, $0, $pop4
	br_if   	0, $0           # 0: up to label2
# %bb.2:                                # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3
                                        # -- End function
	.section	.text.f4,"ax",@progbits
	.hidden	f4                      # -- Begin function f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$0=, -16384
.LBB3_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push7=, d+16384
	i32.add 	$push0=, $0, $pop7
	i32.const	$push6=, b+16384
	i32.add 	$push1=, $0, $pop6
	i32.load	$push2=, 0($pop1)
	i32.const	$push5=, 18
	i32.rem_u	$push3=, $pop2, $pop5
	i32.store	0($pop0), $pop3
	i32.const	$push4=, 4
	i32.add 	$0=, $0, $pop4
	br_if   	0, $0           # 0: up to label3
# %bb.2:                                # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	f4, .Lfunc_end3-f4
                                        # -- End function
	.section	.text.f5,"ax",@progbits
	.hidden	f5                      # -- Begin function f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$0=, -16384
.LBB4_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	i32.const	$push7=, c+16384
	i32.add 	$push0=, $0, $pop7
	i32.const	$push6=, a+16384
	i32.add 	$push1=, $0, $pop6
	i32.load	$push2=, 0($pop1)
	i32.const	$push5=, 19
	i32.rem_s	$push3=, $pop2, $pop5
	i32.store	0($pop0), $pop3
	i32.const	$push4=, 4
	i32.add 	$0=, $0, $pop4
	br_if   	0, $0           # 0: up to label4
# %bb.2:                                # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	f5, .Lfunc_end4-f5
                                        # -- End function
	.section	.text.f6,"ax",@progbits
	.hidden	f6                      # -- Begin function f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$0=, -16384
.LBB5_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.const	$push7=, d+16384
	i32.add 	$push0=, $0, $pop7
	i32.const	$push6=, b+16384
	i32.add 	$push1=, $0, $pop6
	i32.load	$push2=, 0($pop1)
	i32.const	$push5=, 19
	i32.rem_u	$push3=, $pop2, $pop5
	i32.store	0($pop0), $pop3
	i32.const	$push4=, 4
	i32.add 	$0=, $0, $pop4
	br_if   	0, $0           # 0: up to label5
# %bb.2:                                # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	f6, .Lfunc_end5-f6
                                        # -- End function
	.section	.text.f7,"ax",@progbits
	.hidden	f7                      # -- Begin function f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$1=, -16384
.LBB6_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i32.const	$push16=, a+16384
	i32.add 	$push0=, $1, $pop16
	i32.load	$0=, 0($pop0)
	i32.const	$push15=, c+16384
	i32.add 	$push9=, $1, $pop15
	i64.extend_s/i32	$push2=, $0
	i64.const	$push14=, 1431655766
	i64.mul 	$push3=, $pop2, $pop14
	i64.const	$push13=, 32
	i64.shr_u	$push4=, $pop3, $pop13
	i32.wrap/i64	$push5=, $pop4
	i32.const	$push12=, 31
	i32.shr_s	$push1=, $0, $pop12
	i32.sub 	$push6=, $pop5, $pop1
	i32.const	$push11=, -3
	i32.mul 	$push7=, $pop6, $pop11
	i32.add 	$push8=, $pop7, $0
	i32.store	0($pop9), $pop8
	i32.const	$push10=, 4
	i32.add 	$1=, $1, $pop10
	br_if   	0, $1           # 0: up to label6
# %bb.2:                                # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end6:
	.size	f7, .Lfunc_end6-f7
                                        # -- End function
	.section	.text.f8,"ax",@progbits
	.hidden	f8                      # -- Begin function f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$1=, -16384
.LBB7_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label7:
	i32.const	$push13=, b+16384
	i32.add 	$push0=, $1, $pop13
	i32.load	$0=, 0($pop0)
	i32.const	$push12=, d+16384
	i32.add 	$push7=, $1, $pop12
	i64.extend_u/i32	$push1=, $0
	i64.const	$push11=, 2863311531
	i64.mul 	$push2=, $pop1, $pop11
	i64.const	$push10=, 33
	i64.shr_u	$push3=, $pop2, $pop10
	i32.wrap/i64	$push4=, $pop3
	i32.const	$push9=, -3
	i32.mul 	$push5=, $pop4, $pop9
	i32.add 	$push6=, $pop5, $0
	i32.store	0($pop7), $pop6
	i32.const	$push8=, 4
	i32.add 	$1=, $1, $pop8
	br_if   	0, $1           # 0: up to label7
# %bb.2:                                # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end7:
	.size	f8, .Lfunc_end7-f8
                                        # -- End function
	.section	.text.f9,"ax",@progbits
	.hidden	f9                      # -- Begin function f9
	.globl	f9
	.type	f9,@function
f9:                                     # @f9
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$1=, -16384
.LBB8_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	i32.const	$push16=, a+16384
	i32.add 	$push0=, $1, $pop16
	i32.load	$0=, 0($pop0)
	i32.const	$push15=, c+16384
	i32.add 	$push9=, $1, $pop15
	i64.extend_s/i32	$push2=, $0
	i64.const	$push14=, 954437177
	i64.mul 	$push3=, $pop2, $pop14
	i64.const	$push13=, 34
	i64.shr_s	$push4=, $pop3, $pop13
	i32.wrap/i64	$push5=, $pop4
	i32.const	$push12=, 31
	i32.shr_s	$push1=, $0, $pop12
	i32.sub 	$push6=, $pop5, $pop1
	i32.const	$push11=, -18
	i32.mul 	$push7=, $pop6, $pop11
	i32.add 	$push8=, $pop7, $0
	i32.store	0($pop9), $pop8
	i32.const	$push10=, 4
	i32.add 	$1=, $1, $pop10
	br_if   	0, $1           # 0: up to label8
# %bb.2:                                # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end8:
	.size	f9, .Lfunc_end8-f9
                                        # -- End function
	.section	.text.f10,"ax",@progbits
	.hidden	f10                     # -- Begin function f10
	.globl	f10
	.type	f10,@function
f10:                                    # @f10
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$1=, -16384
.LBB9_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label9:
	i32.const	$push13=, b+16384
	i32.add 	$push0=, $1, $pop13
	i32.load	$0=, 0($pop0)
	i32.const	$push12=, d+16384
	i32.add 	$push7=, $1, $pop12
	i64.extend_u/i32	$push1=, $0
	i64.const	$push11=, 954437177
	i64.mul 	$push2=, $pop1, $pop11
	i64.const	$push10=, 34
	i64.shr_u	$push3=, $pop2, $pop10
	i32.wrap/i64	$push4=, $pop3
	i32.const	$push9=, -18
	i32.mul 	$push5=, $pop4, $pop9
	i32.add 	$push6=, $pop5, $0
	i32.store	0($pop7), $pop6
	i32.const	$push8=, 4
	i32.add 	$1=, $1, $pop8
	br_if   	0, $1           # 0: up to label9
# %bb.2:                                # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end9:
	.size	f10, .Lfunc_end9-f10
                                        # -- End function
	.section	.text.f11,"ax",@progbits
	.hidden	f11                     # -- Begin function f11
	.globl	f11
	.type	f11,@function
f11:                                    # @f11
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$1=, -16384
.LBB10_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label10:
	i32.const	$push16=, a+16384
	i32.add 	$push0=, $1, $pop16
	i32.load	$0=, 0($pop0)
	i32.const	$push15=, c+16384
	i32.add 	$push9=, $1, $pop15
	i64.extend_s/i32	$push2=, $0
	i64.const	$push14=, 1808407283
	i64.mul 	$push3=, $pop2, $pop14
	i64.const	$push13=, 35
	i64.shr_s	$push4=, $pop3, $pop13
	i32.wrap/i64	$push5=, $pop4
	i32.const	$push12=, 31
	i32.shr_s	$push1=, $0, $pop12
	i32.sub 	$push6=, $pop5, $pop1
	i32.const	$push11=, -19
	i32.mul 	$push7=, $pop6, $pop11
	i32.add 	$push8=, $pop7, $0
	i32.store	0($pop9), $pop8
	i32.const	$push10=, 4
	i32.add 	$1=, $1, $pop10
	br_if   	0, $1           # 0: up to label10
# %bb.2:                                # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end10:
	.size	f11, .Lfunc_end10-f11
                                        # -- End function
	.section	.text.f12,"ax",@progbits
	.hidden	f12                     # -- Begin function f12
	.globl	f12
	.type	f12,@function
f12:                                    # @f12
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$2=, -16384
.LBB11_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label11:
	i32.const	$push18=, b+16384
	i32.add 	$push0=, $2, $pop18
	i32.load	$0=, 0($pop0)
	i64.extend_u/i32	$push1=, $0
	i64.const	$push17=, 2938661835
	i64.mul 	$push2=, $pop1, $pop17
	i64.const	$push16=, 32
	i64.shr_u	$push3=, $pop2, $pop16
	i32.wrap/i64	$1=, $pop3
	i32.const	$push15=, d+16384
	i32.add 	$push10=, $2, $pop15
	i32.sub 	$push4=, $0, $1
	i32.const	$push14=, 1
	i32.shr_u	$push5=, $pop4, $pop14
	i32.add 	$push6=, $pop5, $1
	i32.const	$push13=, 4
	i32.shr_u	$push7=, $pop6, $pop13
	i32.const	$push12=, -19
	i32.mul 	$push8=, $pop7, $pop12
	i32.add 	$push9=, $pop8, $0
	i32.store	0($pop10), $pop9
	i32.const	$push11=, 4
	i32.add 	$2=, $2, $pop11
	br_if   	0, $2           # 0: up to label11
# %bb.2:                                # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end11:
	.size	f12, .Lfunc_end11-f12
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$0=, 0
	i32.const	$1=, -16384
.LBB12_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label12:
	#APP
	#NO_APP
	i32.const	$push89=, b+16384
	i32.add 	$push0=, $1, $pop89
	i32.store	0($pop0), $0
	i32.const	$push88=, a+16384
	i32.add 	$push2=, $1, $pop88
	i32.const	$push87=, -2048
	i32.add 	$push1=, $0, $pop87
	i32.store	0($pop2), $pop1
	i32.const	$push86=, 4
	i32.add 	$1=, $1, $pop86
	i32.const	$push85=, 1
	i32.add 	$0=, $0, $pop85
	br_if   	0, $1           # 0: up to label12
# %bb.2:                                # %for.end
	end_loop
	i32.const	$1=, 0
	i32.const	$push92=, 0
	i32.const	$push3=, 2147483647
	i32.store	a+16380($pop92), $pop3
	i32.const	$push91=, 0
	i64.const	$push4=, -9223372030412324864
	i64.store	a($pop91), $pop4
	i32.const	$push90=, 0
	i32.const	$push5=, -1
	i32.store	b+16380($pop90), $pop5
	call    	f1@FUNCTION
	call    	f2@FUNCTION
	i32.const	$0=, 0
.LBB12_3:                               # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label14:
	i32.const	$push95=, c
	i32.add 	$push9=, $1, $pop95
	i32.load	$push10=, 0($pop9)
	i32.const	$push94=, a
	i32.add 	$push6=, $1, $pop94
	i32.load	$push7=, 0($pop6)
	i32.const	$push93=, 3
	i32.rem_s	$push8=, $pop7, $pop93
	i32.ne  	$push11=, $pop10, $pop8
	br_if   	1, $pop11       # 1: down to label13
# %bb.4:                                # %lor.lhs.false
                                        #   in Loop: Header=BB12_3 Depth=1
	i32.const	$push98=, d
	i32.add 	$push15=, $1, $pop98
	i32.load	$push16=, 0($pop15)
	i32.const	$push97=, b
	i32.add 	$push12=, $1, $pop97
	i32.load	$push13=, 0($pop12)
	i32.const	$push96=, 3
	i32.rem_u	$push14=, $pop13, $pop96
	i32.ne  	$push17=, $pop16, $pop14
	br_if   	1, $pop17       # 1: down to label13
# %bb.5:                                # %for.cond2
                                        #   in Loop: Header=BB12_3 Depth=1
	i32.const	$push101=, 1
	i32.add 	$0=, $0, $pop101
	i32.const	$push100=, 4
	i32.add 	$1=, $1, $pop100
	i32.const	$push99=, 4095
	i32.le_u	$push18=, $0, $pop99
	br_if   	0, $pop18       # 0: up to label14
# %bb.6:                                # %for.end14
	end_loop
	call    	f3@FUNCTION
	call    	f4@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_7:                               # %for.body17
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label15:
	i32.const	$push104=, c
	i32.add 	$push22=, $1, $pop104
	i32.load	$push23=, 0($pop22)
	i32.const	$push103=, a
	i32.add 	$push19=, $1, $pop103
	i32.load	$push20=, 0($pop19)
	i32.const	$push102=, 18
	i32.rem_s	$push21=, $pop20, $pop102
	i32.ne  	$push24=, $pop23, $pop21
	br_if   	1, $pop24       # 1: down to label13
# %bb.8:                                # %lor.lhs.false22
                                        #   in Loop: Header=BB12_7 Depth=1
	i32.const	$push107=, d
	i32.add 	$push28=, $1, $pop107
	i32.load	$push29=, 0($pop28)
	i32.const	$push106=, b
	i32.add 	$push25=, $1, $pop106
	i32.load	$push26=, 0($pop25)
	i32.const	$push105=, 18
	i32.rem_u	$push27=, $pop26, $pop105
	i32.ne  	$push30=, $pop29, $pop27
	br_if   	1, $pop30       # 1: down to label13
# %bb.9:                                # %for.cond15
                                        #   in Loop: Header=BB12_7 Depth=1
	i32.const	$push110=, 1
	i32.add 	$0=, $0, $pop110
	i32.const	$push109=, 4
	i32.add 	$1=, $1, $pop109
	i32.const	$push108=, 4095
	i32.le_u	$push31=, $0, $pop108
	br_if   	0, $pop31       # 0: up to label15
# %bb.10:                               # %for.end31
	end_loop
	call    	f5@FUNCTION
	call    	f6@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_11:                              # %for.body34
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label16:
	i32.const	$push113=, c
	i32.add 	$push35=, $1, $pop113
	i32.load	$push36=, 0($pop35)
	i32.const	$push112=, a
	i32.add 	$push32=, $1, $pop112
	i32.load	$push33=, 0($pop32)
	i32.const	$push111=, 19
	i32.rem_s	$push34=, $pop33, $pop111
	i32.ne  	$push37=, $pop36, $pop34
	br_if   	1, $pop37       # 1: down to label13
# %bb.12:                               # %lor.lhs.false39
                                        #   in Loop: Header=BB12_11 Depth=1
	i32.const	$push116=, d
	i32.add 	$push41=, $1, $pop116
	i32.load	$push42=, 0($pop41)
	i32.const	$push115=, b
	i32.add 	$push38=, $1, $pop115
	i32.load	$push39=, 0($pop38)
	i32.const	$push114=, 19
	i32.rem_u	$push40=, $pop39, $pop114
	i32.ne  	$push43=, $pop42, $pop40
	br_if   	1, $pop43       # 1: down to label13
# %bb.13:                               # %for.cond32
                                        #   in Loop: Header=BB12_11 Depth=1
	i32.const	$push119=, 1
	i32.add 	$0=, $0, $pop119
	i32.const	$push118=, 4
	i32.add 	$1=, $1, $pop118
	i32.const	$push117=, 4095
	i32.le_u	$push44=, $0, $pop117
	br_if   	0, $pop44       # 0: up to label16
# %bb.14:                               # %for.end48
	end_loop
	call    	f7@FUNCTION
	call    	f8@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_15:                              # %for.body51
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label17:
	i32.const	$push122=, c
	i32.add 	$push48=, $1, $pop122
	i32.load	$push49=, 0($pop48)
	i32.const	$push121=, a
	i32.add 	$push45=, $1, $pop121
	i32.load	$push46=, 0($pop45)
	i32.const	$push120=, 3
	i32.rem_s	$push47=, $pop46, $pop120
	i32.ne  	$push50=, $pop49, $pop47
	br_if   	1, $pop50       # 1: down to label13
# %bb.16:                               # %lor.lhs.false56
                                        #   in Loop: Header=BB12_15 Depth=1
	i32.const	$push125=, d
	i32.add 	$push54=, $1, $pop125
	i32.load	$push55=, 0($pop54)
	i32.const	$push124=, b
	i32.add 	$push51=, $1, $pop124
	i32.load	$push52=, 0($pop51)
	i32.const	$push123=, 3
	i32.rem_u	$push53=, $pop52, $pop123
	i32.ne  	$push56=, $pop55, $pop53
	br_if   	1, $pop56       # 1: down to label13
# %bb.17:                               # %for.cond49
                                        #   in Loop: Header=BB12_15 Depth=1
	i32.const	$push128=, 1
	i32.add 	$0=, $0, $pop128
	i32.const	$push127=, 4
	i32.add 	$1=, $1, $pop127
	i32.const	$push126=, 4095
	i32.le_u	$push57=, $0, $pop126
	br_if   	0, $pop57       # 0: up to label17
# %bb.18:                               # %for.end65
	end_loop
	call    	f9@FUNCTION
	call    	f10@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_19:                              # %for.body68
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label18:
	i32.const	$push131=, c
	i32.add 	$push61=, $1, $pop131
	i32.load	$push62=, 0($pop61)
	i32.const	$push130=, a
	i32.add 	$push58=, $1, $pop130
	i32.load	$push59=, 0($pop58)
	i32.const	$push129=, 18
	i32.rem_s	$push60=, $pop59, $pop129
	i32.ne  	$push63=, $pop62, $pop60
	br_if   	1, $pop63       # 1: down to label13
# %bb.20:                               # %lor.lhs.false73
                                        #   in Loop: Header=BB12_19 Depth=1
	i32.const	$push134=, d
	i32.add 	$push67=, $1, $pop134
	i32.load	$push68=, 0($pop67)
	i32.const	$push133=, b
	i32.add 	$push64=, $1, $pop133
	i32.load	$push65=, 0($pop64)
	i32.const	$push132=, 18
	i32.rem_u	$push66=, $pop65, $pop132
	i32.ne  	$push69=, $pop68, $pop66
	br_if   	1, $pop69       # 1: down to label13
# %bb.21:                               # %for.cond66
                                        #   in Loop: Header=BB12_19 Depth=1
	i32.const	$push137=, 1
	i32.add 	$0=, $0, $pop137
	i32.const	$push136=, 4
	i32.add 	$1=, $1, $pop136
	i32.const	$push135=, 4095
	i32.le_u	$push70=, $0, $pop135
	br_if   	0, $pop70       # 0: up to label18
# %bb.22:                               # %for.end82
	end_loop
	call    	f11@FUNCTION
	call    	f12@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_23:                              # %for.body85
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label19:
	i32.const	$push140=, c
	i32.add 	$push74=, $1, $pop140
	i32.load	$push75=, 0($pop74)
	i32.const	$push139=, a
	i32.add 	$push71=, $1, $pop139
	i32.load	$push72=, 0($pop71)
	i32.const	$push138=, 19
	i32.rem_s	$push73=, $pop72, $pop138
	i32.ne  	$push76=, $pop75, $pop73
	br_if   	1, $pop76       # 1: down to label13
# %bb.24:                               # %lor.lhs.false90
                                        #   in Loop: Header=BB12_23 Depth=1
	i32.const	$push143=, d
	i32.add 	$push80=, $1, $pop143
	i32.load	$push81=, 0($pop80)
	i32.const	$push142=, b
	i32.add 	$push77=, $1, $pop142
	i32.load	$push78=, 0($pop77)
	i32.const	$push141=, 19
	i32.rem_u	$push79=, $pop78, $pop141
	i32.ne  	$push82=, $pop81, $pop79
	br_if   	1, $pop82       # 1: down to label13
# %bb.25:                               # %for.cond83
                                        #   in Loop: Header=BB12_23 Depth=1
	i32.const	$push146=, 1
	i32.add 	$0=, $0, $pop146
	i32.const	$push145=, 4
	i32.add 	$1=, $1, $pop145
	i32.const	$push144=, 4095
	i32.le_u	$push83=, $0, $pop144
	br_if   	0, $pop83       # 0: up to label19
# %bb.26:                               # %for.end99
	end_loop
	i32.const	$push84=, 0
	return  	$pop84
.LBB12_27:                              # %if.then
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end12:
	.size	main, .Lfunc_end12-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	16384
	.size	a, 16384

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	4
c:
	.skip	16384
	.size	c, 16384

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	4
b:
	.skip	16384
	.size	b, 16384

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	4
d:
	.skip	16384
	.size	d, 16384


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
