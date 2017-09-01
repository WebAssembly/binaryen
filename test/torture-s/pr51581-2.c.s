	.text
	.file	"pr51581-2.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push9=, c+16384
	i32.add 	$push0=, $0, $pop9
	i32.const	$push8=, a+16384
	i32.add 	$push1=, $0, $pop8
	i32.load	$push2=, 0($pop1)
	i32.const	$push7=, 3
	i32.rem_s	$push3=, $pop2, $pop7
	i32.store	0($pop0), $pop3
	i32.const	$push6=, 4
	i32.add 	$push5=, $0, $pop6
	tee_local	$push4=, $0=, $pop5
	br_if   	0, $pop4        # 0: up to label0
# BB#2:                                 # %for.end
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
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push9=, d+16384
	i32.add 	$push0=, $0, $pop9
	i32.const	$push8=, b+16384
	i32.add 	$push1=, $0, $pop8
	i32.load	$push2=, 0($pop1)
	i32.const	$push7=, 3
	i32.rem_u	$push3=, $pop2, $pop7
	i32.store	0($pop0), $pop3
	i32.const	$push6=, 4
	i32.add 	$push5=, $0, $pop6
	tee_local	$push4=, $0=, $pop5
	br_if   	0, $pop4        # 0: up to label1
# BB#2:                                 # %for.end
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
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push9=, c+16384
	i32.add 	$push0=, $0, $pop9
	i32.const	$push8=, a+16384
	i32.add 	$push1=, $0, $pop8
	i32.load	$push2=, 0($pop1)
	i32.const	$push7=, 18
	i32.rem_s	$push3=, $pop2, $pop7
	i32.store	0($pop0), $pop3
	i32.const	$push6=, 4
	i32.add 	$push5=, $0, $pop6
	tee_local	$push4=, $0=, $pop5
	br_if   	0, $pop4        # 0: up to label2
# BB#2:                                 # %for.end
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
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB3_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push9=, d+16384
	i32.add 	$push0=, $0, $pop9
	i32.const	$push8=, b+16384
	i32.add 	$push1=, $0, $pop8
	i32.load	$push2=, 0($pop1)
	i32.const	$push7=, 18
	i32.rem_u	$push3=, $pop2, $pop7
	i32.store	0($pop0), $pop3
	i32.const	$push6=, 4
	i32.add 	$push5=, $0, $pop6
	tee_local	$push4=, $0=, $pop5
	br_if   	0, $pop4        # 0: up to label3
# BB#2:                                 # %for.end
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
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB4_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	i32.const	$push9=, c+16384
	i32.add 	$push0=, $0, $pop9
	i32.const	$push8=, a+16384
	i32.add 	$push1=, $0, $pop8
	i32.load	$push2=, 0($pop1)
	i32.const	$push7=, 19
	i32.rem_s	$push3=, $pop2, $pop7
	i32.store	0($pop0), $pop3
	i32.const	$push6=, 4
	i32.add 	$push5=, $0, $pop6
	tee_local	$push4=, $0=, $pop5
	br_if   	0, $pop4        # 0: up to label4
# BB#2:                                 # %for.end
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
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB5_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.const	$push9=, d+16384
	i32.add 	$push0=, $0, $pop9
	i32.const	$push8=, b+16384
	i32.add 	$push1=, $0, $pop8
	i32.load	$push2=, 0($pop1)
	i32.const	$push7=, 19
	i32.rem_u	$push3=, $pop2, $pop7
	i32.store	0($pop0), $pop3
	i32.const	$push6=, 4
	i32.add 	$push5=, $0, $pop6
	tee_local	$push4=, $0=, $pop5
	br_if   	0, $pop4        # 0: up to label5
# BB#2:                                 # %for.end
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
# BB#0:                                 # %entry
	i32.const	$1=, -16384
.LBB6_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i32.const	$push20=, c+16384
	i32.add 	$push9=, $1, $pop20
	i32.const	$push19=, a+16384
	i32.add 	$push0=, $1, $pop19
	i32.load	$push18=, 0($pop0)
	tee_local	$push17=, $0=, $pop18
	i64.extend_s/i32	$push2=, $pop17
	i64.const	$push16=, 1431655766
	i64.mul 	$push3=, $pop2, $pop16
	i64.const	$push15=, 32
	i64.shr_u	$push4=, $pop3, $pop15
	i32.wrap/i64	$push5=, $pop4
	i32.const	$push14=, 31
	i32.shr_s	$push1=, $0, $pop14
	i32.sub 	$push6=, $pop5, $pop1
	i32.const	$push13=, -3
	i32.mul 	$push7=, $pop6, $pop13
	i32.add 	$push8=, $pop7, $0
	i32.store	0($pop9), $pop8
	i32.const	$push12=, 4
	i32.add 	$push11=, $1, $pop12
	tee_local	$push10=, $1=, $pop11
	br_if   	0, $pop10       # 0: up to label6
# BB#2:                                 # %for.end
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
# BB#0:                                 # %entry
	i32.const	$1=, -16384
.LBB7_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label7:
	i32.const	$push17=, d+16384
	i32.add 	$push7=, $1, $pop17
	i32.const	$push16=, b+16384
	i32.add 	$push0=, $1, $pop16
	i32.load	$push15=, 0($pop0)
	tee_local	$push14=, $0=, $pop15
	i64.extend_u/i32	$push1=, $pop14
	i64.const	$push13=, 2863311531
	i64.mul 	$push2=, $pop1, $pop13
	i64.const	$push12=, 33
	i64.shr_u	$push3=, $pop2, $pop12
	i32.wrap/i64	$push4=, $pop3
	i32.const	$push11=, -3
	i32.mul 	$push5=, $pop4, $pop11
	i32.add 	$push6=, $pop5, $0
	i32.store	0($pop7), $pop6
	i32.const	$push10=, 4
	i32.add 	$push9=, $1, $pop10
	tee_local	$push8=, $1=, $pop9
	br_if   	0, $pop8        # 0: up to label7
# BB#2:                                 # %for.end
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
# BB#0:                                 # %entry
	i32.const	$1=, -16384
.LBB8_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	i32.const	$push20=, c+16384
	i32.add 	$push9=, $1, $pop20
	i32.const	$push19=, a+16384
	i32.add 	$push0=, $1, $pop19
	i32.load	$push18=, 0($pop0)
	tee_local	$push17=, $0=, $pop18
	i64.extend_s/i32	$push2=, $pop17
	i64.const	$push16=, 954437177
	i64.mul 	$push3=, $pop2, $pop16
	i64.const	$push15=, 34
	i64.shr_s	$push4=, $pop3, $pop15
	i32.wrap/i64	$push5=, $pop4
	i32.const	$push14=, 31
	i32.shr_s	$push1=, $0, $pop14
	i32.sub 	$push6=, $pop5, $pop1
	i32.const	$push13=, -18
	i32.mul 	$push7=, $pop6, $pop13
	i32.add 	$push8=, $pop7, $0
	i32.store	0($pop9), $pop8
	i32.const	$push12=, 4
	i32.add 	$push11=, $1, $pop12
	tee_local	$push10=, $1=, $pop11
	br_if   	0, $pop10       # 0: up to label8
# BB#2:                                 # %for.end
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
# BB#0:                                 # %entry
	i32.const	$1=, -16384
.LBB9_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label9:
	i32.const	$push17=, d+16384
	i32.add 	$push7=, $1, $pop17
	i32.const	$push16=, b+16384
	i32.add 	$push0=, $1, $pop16
	i32.load	$push15=, 0($pop0)
	tee_local	$push14=, $0=, $pop15
	i64.extend_u/i32	$push1=, $pop14
	i64.const	$push13=, 954437177
	i64.mul 	$push2=, $pop1, $pop13
	i64.const	$push12=, 34
	i64.shr_u	$push3=, $pop2, $pop12
	i32.wrap/i64	$push4=, $pop3
	i32.const	$push11=, -18
	i32.mul 	$push5=, $pop4, $pop11
	i32.add 	$push6=, $pop5, $0
	i32.store	0($pop7), $pop6
	i32.const	$push10=, 4
	i32.add 	$push9=, $1, $pop10
	tee_local	$push8=, $1=, $pop9
	br_if   	0, $pop8        # 0: up to label9
# BB#2:                                 # %for.end
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
# BB#0:                                 # %entry
	i32.const	$1=, -16384
.LBB10_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label10:
	i32.const	$push20=, c+16384
	i32.add 	$push9=, $1, $pop20
	i32.const	$push19=, a+16384
	i32.add 	$push0=, $1, $pop19
	i32.load	$push18=, 0($pop0)
	tee_local	$push17=, $0=, $pop18
	i64.extend_s/i32	$push2=, $pop17
	i64.const	$push16=, 1808407283
	i64.mul 	$push3=, $pop2, $pop16
	i64.const	$push15=, 35
	i64.shr_s	$push4=, $pop3, $pop15
	i32.wrap/i64	$push5=, $pop4
	i32.const	$push14=, 31
	i32.shr_s	$push1=, $0, $pop14
	i32.sub 	$push6=, $pop5, $pop1
	i32.const	$push13=, -19
	i32.mul 	$push7=, $pop6, $pop13
	i32.add 	$push8=, $pop7, $0
	i32.store	0($pop9), $pop8
	i32.const	$push12=, 4
	i32.add 	$push11=, $1, $pop12
	tee_local	$push10=, $1=, $pop11
	br_if   	0, $pop10       # 0: up to label10
# BB#2:                                 # %for.end
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
# BB#0:                                 # %entry
	i32.const	$2=, -16384
.LBB11_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label11:
	i32.const	$push24=, d+16384
	i32.add 	$push10=, $2, $pop24
	i32.const	$push23=, b+16384
	i32.add 	$push0=, $2, $pop23
	i32.load	$push22=, 0($pop0)
	tee_local	$push21=, $0=, $pop22
	i64.extend_u/i32	$push1=, $0
	i64.const	$push20=, 2938661835
	i64.mul 	$push2=, $pop1, $pop20
	i64.const	$push19=, 32
	i64.shr_u	$push3=, $pop2, $pop19
	i32.wrap/i64	$push18=, $pop3
	tee_local	$push17=, $1=, $pop18
	i32.sub 	$push4=, $pop21, $pop17
	i32.const	$push16=, 1
	i32.shr_u	$push5=, $pop4, $pop16
	i32.add 	$push6=, $pop5, $1
	i32.const	$push15=, 4
	i32.shr_u	$push7=, $pop6, $pop15
	i32.const	$push14=, -19
	i32.mul 	$push8=, $pop7, $pop14
	i32.add 	$push9=, $pop8, $0
	i32.store	0($pop10), $pop9
	i32.const	$push13=, 4
	i32.add 	$push12=, $2, $pop13
	tee_local	$push11=, $2=, $pop12
	br_if   	0, $pop11       # 0: up to label11
# BB#2:                                 # %for.end
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
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$0=, -16384
.LBB12_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label12:
	#APP
	#NO_APP
	i32.const	$push90=, b+16384
	i32.add 	$push0=, $0, $pop90
	i32.store	0($pop0), $1
	i32.const	$push89=, a+16384
	i32.add 	$push2=, $0, $pop89
	i32.const	$push88=, -2048
	i32.add 	$push1=, $1, $pop88
	i32.store	0($pop2), $pop1
	i32.const	$push87=, 1
	i32.add 	$1=, $1, $pop87
	i32.const	$push86=, 4
	i32.add 	$push85=, $0, $pop86
	tee_local	$push84=, $0=, $pop85
	br_if   	0, $pop84       # 0: up to label12
# BB#2:                                 # %for.end
	end_loop
	i32.const	$1=, 0
	i32.const	$push94=, 0
	i32.const	$push3=, 2147483647
	i32.store	a+16380($pop94), $pop3
	i32.const	$push93=, 0
	i64.const	$push4=, -9223372030412324864
	i64.store	a($pop93), $pop4
	i32.const	$0=, -1
	i32.const	$push92=, 0
	i32.const	$push91=, -1
	i32.store	b+16380($pop92), $pop91
	call    	f1@FUNCTION
	call    	f2@FUNCTION
.LBB12_3:                               # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label14:
	i32.const	$push97=, c
	i32.add 	$push8=, $1, $pop97
	i32.load	$push9=, 0($pop8)
	i32.const	$push96=, a
	i32.add 	$push5=, $1, $pop96
	i32.load	$push6=, 0($pop5)
	i32.const	$push95=, 3
	i32.rem_s	$push7=, $pop6, $pop95
	i32.ne  	$push10=, $pop9, $pop7
	br_if   	1, $pop10       # 1: down to label13
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB12_3 Depth=1
	i32.const	$push100=, d
	i32.add 	$push14=, $1, $pop100
	i32.load	$push15=, 0($pop14)
	i32.const	$push99=, b
	i32.add 	$push11=, $1, $pop99
	i32.load	$push12=, 0($pop11)
	i32.const	$push98=, 3
	i32.rem_u	$push13=, $pop12, $pop98
	i32.ne  	$push16=, $pop15, $pop13
	br_if   	1, $pop16       # 1: down to label13
# BB#5:                                 # %for.cond2
                                        #   in Loop: Header=BB12_3 Depth=1
	i32.const	$push105=, 4
	i32.add 	$1=, $1, $pop105
	i32.const	$push104=, 1
	i32.add 	$push103=, $0, $pop104
	tee_local	$push102=, $0=, $pop103
	i32.const	$push101=, 4094
	i32.le_u	$push17=, $pop102, $pop101
	br_if   	0, $pop17       # 0: up to label14
# BB#6:                                 # %for.end14
	end_loop
	call    	f3@FUNCTION
	call    	f4@FUNCTION
	i32.const	$0=, -1
	i32.const	$1=, 0
.LBB12_7:                               # %for.body17
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label15:
	i32.const	$push108=, c
	i32.add 	$push21=, $1, $pop108
	i32.load	$push22=, 0($pop21)
	i32.const	$push107=, a
	i32.add 	$push18=, $1, $pop107
	i32.load	$push19=, 0($pop18)
	i32.const	$push106=, 18
	i32.rem_s	$push20=, $pop19, $pop106
	i32.ne  	$push23=, $pop22, $pop20
	br_if   	1, $pop23       # 1: down to label13
# BB#8:                                 # %lor.lhs.false22
                                        #   in Loop: Header=BB12_7 Depth=1
	i32.const	$push111=, d
	i32.add 	$push27=, $1, $pop111
	i32.load	$push28=, 0($pop27)
	i32.const	$push110=, b
	i32.add 	$push24=, $1, $pop110
	i32.load	$push25=, 0($pop24)
	i32.const	$push109=, 18
	i32.rem_u	$push26=, $pop25, $pop109
	i32.ne  	$push29=, $pop28, $pop26
	br_if   	1, $pop29       # 1: down to label13
# BB#9:                                 # %for.cond15
                                        #   in Loop: Header=BB12_7 Depth=1
	i32.const	$push116=, 4
	i32.add 	$1=, $1, $pop116
	i32.const	$push115=, 1
	i32.add 	$push114=, $0, $pop115
	tee_local	$push113=, $0=, $pop114
	i32.const	$push112=, 4094
	i32.le_u	$push30=, $pop113, $pop112
	br_if   	0, $pop30       # 0: up to label15
# BB#10:                                # %for.end31
	end_loop
	call    	f5@FUNCTION
	call    	f6@FUNCTION
	i32.const	$0=, -1
	i32.const	$1=, 0
.LBB12_11:                              # %for.body34
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label16:
	i32.const	$push119=, c
	i32.add 	$push34=, $1, $pop119
	i32.load	$push35=, 0($pop34)
	i32.const	$push118=, a
	i32.add 	$push31=, $1, $pop118
	i32.load	$push32=, 0($pop31)
	i32.const	$push117=, 19
	i32.rem_s	$push33=, $pop32, $pop117
	i32.ne  	$push36=, $pop35, $pop33
	br_if   	1, $pop36       # 1: down to label13
# BB#12:                                # %lor.lhs.false39
                                        #   in Loop: Header=BB12_11 Depth=1
	i32.const	$push122=, d
	i32.add 	$push40=, $1, $pop122
	i32.load	$push41=, 0($pop40)
	i32.const	$push121=, b
	i32.add 	$push37=, $1, $pop121
	i32.load	$push38=, 0($pop37)
	i32.const	$push120=, 19
	i32.rem_u	$push39=, $pop38, $pop120
	i32.ne  	$push42=, $pop41, $pop39
	br_if   	1, $pop42       # 1: down to label13
# BB#13:                                # %for.cond32
                                        #   in Loop: Header=BB12_11 Depth=1
	i32.const	$push127=, 4
	i32.add 	$1=, $1, $pop127
	i32.const	$push126=, 1
	i32.add 	$push125=, $0, $pop126
	tee_local	$push124=, $0=, $pop125
	i32.const	$push123=, 4094
	i32.le_u	$push43=, $pop124, $pop123
	br_if   	0, $pop43       # 0: up to label16
# BB#14:                                # %for.end48
	end_loop
	call    	f7@FUNCTION
	call    	f8@FUNCTION
	i32.const	$0=, -1
	i32.const	$1=, 0
.LBB12_15:                              # %for.body51
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label17:
	i32.const	$push130=, c
	i32.add 	$push47=, $1, $pop130
	i32.load	$push48=, 0($pop47)
	i32.const	$push129=, a
	i32.add 	$push44=, $1, $pop129
	i32.load	$push45=, 0($pop44)
	i32.const	$push128=, 3
	i32.rem_s	$push46=, $pop45, $pop128
	i32.ne  	$push49=, $pop48, $pop46
	br_if   	1, $pop49       # 1: down to label13
# BB#16:                                # %lor.lhs.false56
                                        #   in Loop: Header=BB12_15 Depth=1
	i32.const	$push133=, d
	i32.add 	$push53=, $1, $pop133
	i32.load	$push54=, 0($pop53)
	i32.const	$push132=, b
	i32.add 	$push50=, $1, $pop132
	i32.load	$push51=, 0($pop50)
	i32.const	$push131=, 3
	i32.rem_u	$push52=, $pop51, $pop131
	i32.ne  	$push55=, $pop54, $pop52
	br_if   	1, $pop55       # 1: down to label13
# BB#17:                                # %for.cond49
                                        #   in Loop: Header=BB12_15 Depth=1
	i32.const	$push138=, 4
	i32.add 	$1=, $1, $pop138
	i32.const	$push137=, 1
	i32.add 	$push136=, $0, $pop137
	tee_local	$push135=, $0=, $pop136
	i32.const	$push134=, 4094
	i32.le_u	$push56=, $pop135, $pop134
	br_if   	0, $pop56       # 0: up to label17
# BB#18:                                # %for.end65
	end_loop
	call    	f9@FUNCTION
	call    	f10@FUNCTION
	i32.const	$0=, -1
	i32.const	$1=, 0
.LBB12_19:                              # %for.body68
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label18:
	i32.const	$push141=, c
	i32.add 	$push60=, $1, $pop141
	i32.load	$push61=, 0($pop60)
	i32.const	$push140=, a
	i32.add 	$push57=, $1, $pop140
	i32.load	$push58=, 0($pop57)
	i32.const	$push139=, 18
	i32.rem_s	$push59=, $pop58, $pop139
	i32.ne  	$push62=, $pop61, $pop59
	br_if   	1, $pop62       # 1: down to label13
# BB#20:                                # %lor.lhs.false73
                                        #   in Loop: Header=BB12_19 Depth=1
	i32.const	$push144=, d
	i32.add 	$push66=, $1, $pop144
	i32.load	$push67=, 0($pop66)
	i32.const	$push143=, b
	i32.add 	$push63=, $1, $pop143
	i32.load	$push64=, 0($pop63)
	i32.const	$push142=, 18
	i32.rem_u	$push65=, $pop64, $pop142
	i32.ne  	$push68=, $pop67, $pop65
	br_if   	1, $pop68       # 1: down to label13
# BB#21:                                # %for.cond66
                                        #   in Loop: Header=BB12_19 Depth=1
	i32.const	$push149=, 4
	i32.add 	$1=, $1, $pop149
	i32.const	$push148=, 1
	i32.add 	$push147=, $0, $pop148
	tee_local	$push146=, $0=, $pop147
	i32.const	$push145=, 4094
	i32.le_u	$push69=, $pop146, $pop145
	br_if   	0, $pop69       # 0: up to label18
# BB#22:                                # %for.end82
	end_loop
	call    	f11@FUNCTION
	call    	f12@FUNCTION
	i32.const	$0=, -1
	i32.const	$1=, 0
.LBB12_23:                              # %for.body85
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label19:
	i32.const	$push152=, c
	i32.add 	$push73=, $1, $pop152
	i32.load	$push74=, 0($pop73)
	i32.const	$push151=, a
	i32.add 	$push70=, $1, $pop151
	i32.load	$push71=, 0($pop70)
	i32.const	$push150=, 19
	i32.rem_s	$push72=, $pop71, $pop150
	i32.ne  	$push75=, $pop74, $pop72
	br_if   	1, $pop75       # 1: down to label13
# BB#24:                                # %lor.lhs.false90
                                        #   in Loop: Header=BB12_23 Depth=1
	i32.const	$push155=, d
	i32.add 	$push79=, $1, $pop155
	i32.load	$push80=, 0($pop79)
	i32.const	$push154=, b
	i32.add 	$push76=, $1, $pop154
	i32.load	$push77=, 0($pop76)
	i32.const	$push153=, 19
	i32.rem_u	$push78=, $pop77, $pop153
	i32.ne  	$push81=, $pop80, $pop78
	br_if   	1, $pop81       # 1: down to label13
# BB#25:                                # %for.cond83
                                        #   in Loop: Header=BB12_23 Depth=1
	i32.const	$push160=, 4
	i32.add 	$1=, $1, $pop160
	i32.const	$push159=, 1
	i32.add 	$push158=, $0, $pop159
	tee_local	$push157=, $0=, $pop158
	i32.const	$push156=, 4094
	i32.le_u	$push82=, $pop157, $pop156
	br_if   	0, $pop82       # 0: up to label19
# BB#26:                                # %for.end99
	end_loop
	i32.const	$push83=, 0
	return  	$pop83
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
