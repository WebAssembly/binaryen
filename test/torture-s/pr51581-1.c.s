	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr51581-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.load	$push0=, a+16384($0)
	i32.const	$push3=, 3
	i32.div_s	$push1=, $pop0, $pop3
	i32.store	$discard=, c+16384($0), $pop1
	i32.const	$push2=, 4
	i32.add 	$0=, $0, $pop2
	br_if   	0, $0           # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	return
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.load	$push0=, b+16384($0)
	i32.const	$push3=, 3
	i32.div_u	$push1=, $pop0, $pop3
	i32.store	$discard=, d+16384($0), $pop1
	i32.const	$push2=, 4
	i32.add 	$0=, $0, $pop2
	br_if   	0, $0           # 0: up to label2
# BB#2:                                 # %for.end
	end_loop                        # label3:
	return
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load	$push0=, a+16384($0)
	i32.const	$push3=, 18
	i32.div_s	$push1=, $pop0, $pop3
	i32.store	$discard=, c+16384($0), $pop1
	i32.const	$push2=, 4
	i32.add 	$0=, $0, $pop2
	br_if   	0, $0           # 0: up to label4
# BB#2:                                 # %for.end
	end_loop                        # label5:
	return
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB3_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.load	$push0=, b+16384($0)
	i32.const	$push3=, 18
	i32.div_u	$push1=, $pop0, $pop3
	i32.store	$discard=, d+16384($0), $pop1
	i32.const	$push2=, 4
	i32.add 	$0=, $0, $pop2
	br_if   	0, $0           # 0: up to label6
# BB#2:                                 # %for.end
	end_loop                        # label7:
	return
	.endfunc
.Lfunc_end3:
	.size	f4, .Lfunc_end3-f4

	.section	.text.f5,"ax",@progbits
	.hidden	f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB4_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	i32.load	$push0=, a+16384($0)
	i32.const	$push3=, 19
	i32.div_s	$push1=, $pop0, $pop3
	i32.store	$discard=, c+16384($0), $pop1
	i32.const	$push2=, 4
	i32.add 	$0=, $0, $pop2
	br_if   	0, $0           # 0: up to label8
# BB#2:                                 # %for.end
	end_loop                        # label9:
	return
	.endfunc
.Lfunc_end4:
	.size	f5, .Lfunc_end4-f5

	.section	.text.f6,"ax",@progbits
	.hidden	f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB5_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.load	$push0=, b+16384($0)
	i32.const	$push3=, 19
	i32.div_u	$push1=, $pop0, $pop3
	i32.store	$discard=, d+16384($0), $pop1
	i32.const	$push2=, 4
	i32.add 	$0=, $0, $pop2
	br_if   	0, $0           # 0: up to label10
# BB#2:                                 # %for.end
	end_loop                        # label11:
	return
	.endfunc
.Lfunc_end5:
	.size	f6, .Lfunc_end5-f6

	.section	.text.f7,"ax",@progbits
	.hidden	f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB6_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label12:
	i32.load	$push11=, a+16384($0)
	tee_local	$push10=, $1=, $pop11
	i64.extend_s/i32	$push0=, $pop10
	i64.const	$push9=, 1431655766
	i64.mul 	$push1=, $pop0, $pop9
	i64.const	$push8=, 32
	i64.shr_u	$push2=, $pop1, $pop8
	i32.wrap/i64	$push3=, $pop2
	i32.const	$push7=, 31
	i32.shr_s	$push4=, $1, $pop7
	i32.sub 	$push5=, $pop3, $pop4
	i32.store	$discard=, c+16384($0), $pop5
	i32.const	$push6=, 4
	i32.add 	$0=, $0, $pop6
	br_if   	0, $0           # 0: up to label12
# BB#2:                                 # %for.end
	end_loop                        # label13:
	return
	.endfunc
.Lfunc_end6:
	.size	f7, .Lfunc_end6-f7

	.section	.text.f8,"ax",@progbits
	.hidden	f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB7_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label14:
	i64.load32_u	$push0=, b+16384($0)
	i64.const	$push5=, 2863311531
	i64.mul 	$push1=, $pop0, $pop5
	i64.const	$push4=, 33
	i64.shr_u	$push2=, $pop1, $pop4
	i64.store32	$discard=, d+16384($0), $pop2
	i32.const	$push3=, 4
	i32.add 	$0=, $0, $pop3
	br_if   	0, $0           # 0: up to label14
# BB#2:                                 # %for.end
	end_loop                        # label15:
	return
	.endfunc
.Lfunc_end7:
	.size	f8, .Lfunc_end7-f8

	.section	.text.f9,"ax",@progbits
	.hidden	f9
	.globl	f9
	.type	f9,@function
f9:                                     # @f9
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB8_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	i32.load	$push11=, a+16384($0)
	tee_local	$push10=, $1=, $pop11
	i64.extend_s/i32	$push0=, $pop10
	i64.const	$push9=, 954437177
	i64.mul 	$push1=, $pop0, $pop9
	i64.const	$push8=, 34
	i64.shr_s	$push2=, $pop1, $pop8
	i32.wrap/i64	$push3=, $pop2
	i32.const	$push7=, 31
	i32.shr_s	$push4=, $1, $pop7
	i32.sub 	$push5=, $pop3, $pop4
	i32.store	$discard=, c+16384($0), $pop5
	i32.const	$push6=, 4
	i32.add 	$0=, $0, $pop6
	br_if   	0, $0           # 0: up to label16
# BB#2:                                 # %for.end
	end_loop                        # label17:
	return
	.endfunc
.Lfunc_end8:
	.size	f9, .Lfunc_end8-f9

	.section	.text.f10,"ax",@progbits
	.hidden	f10
	.globl	f10
	.type	f10,@function
f10:                                    # @f10
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB9_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label18:
	i64.load32_u	$push0=, b+16384($0)
	i64.const	$push5=, 954437177
	i64.mul 	$push1=, $pop0, $pop5
	i64.const	$push4=, 34
	i64.shr_u	$push2=, $pop1, $pop4
	i64.store32	$discard=, d+16384($0), $pop2
	i32.const	$push3=, 4
	i32.add 	$0=, $0, $pop3
	br_if   	0, $0           # 0: up to label18
# BB#2:                                 # %for.end
	end_loop                        # label19:
	return
	.endfunc
.Lfunc_end9:
	.size	f10, .Lfunc_end9-f10

	.section	.text.f11,"ax",@progbits
	.hidden	f11
	.globl	f11
	.type	f11,@function
f11:                                    # @f11
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB10_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label20:
	i32.load	$push11=, a+16384($0)
	tee_local	$push10=, $1=, $pop11
	i64.extend_s/i32	$push0=, $pop10
	i64.const	$push9=, 1808407283
	i64.mul 	$push1=, $pop0, $pop9
	i64.const	$push8=, 35
	i64.shr_s	$push2=, $pop1, $pop8
	i32.wrap/i64	$push3=, $pop2
	i32.const	$push7=, 31
	i32.shr_s	$push4=, $1, $pop7
	i32.sub 	$push5=, $pop3, $pop4
	i32.store	$discard=, c+16384($0), $pop5
	i32.const	$push6=, 4
	i32.add 	$0=, $0, $pop6
	br_if   	0, $0           # 0: up to label20
# BB#2:                                 # %for.end
	end_loop                        # label21:
	return
	.endfunc
.Lfunc_end10:
	.size	f11, .Lfunc_end10-f11

	.section	.text.f12,"ax",@progbits
	.hidden	f12
	.globl	f12
	.type	f12,@function
f12:                                    # @f12
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -16384
.LBB11_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label22:
	i32.load	$0=, b+16384($1)
	i64.extend_u/i32	$push0=, $0
	i64.const	$push13=, 2938661835
	i64.mul 	$push1=, $pop0, $pop13
	i64.const	$push12=, 32
	i64.shr_u	$push2=, $pop1, $pop12
	i32.wrap/i64	$push11=, $pop2
	tee_local	$push10=, $2=, $pop11
	i32.sub 	$push3=, $0, $pop10
	i32.const	$push9=, 1
	i32.shr_u	$push4=, $pop3, $pop9
	i32.add 	$push5=, $pop4, $2
	i32.const	$push8=, 4
	i32.shr_u	$push6=, $pop5, $pop8
	i32.store	$discard=, d+16384($1), $pop6
	i32.const	$push7=, 4
	i32.add 	$1=, $1, $pop7
	br_if   	0, $1           # 0: up to label22
# BB#2:                                 # %for.end
	end_loop                        # label23:
	return
	.endfunc
.Lfunc_end11:
	.size	f12, .Lfunc_end11-f12

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, -16384
.LBB12_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label24:
	#APP
	#NO_APP
	i32.const	$push63=, -2048
	i32.add 	$push0=, $0, $pop63
	i32.store	$discard=, a+16384($1), $pop0
	i32.store	$push1=, b+16384($1), $0
	i32.const	$push62=, 1
	i32.add 	$0=, $pop1, $pop62
	i32.const	$push61=, 4
	i32.add 	$1=, $1, $pop61
	br_if   	0, $1           # 0: up to label24
# BB#2:                                 # %for.end
	end_loop                        # label25:
	i32.const	$1=, 0
	i32.const	$push67=, 0
	i32.const	$push2=, -2147483648
	i32.store	$discard=, a($pop67):p2align=4, $pop2
	i32.const	$push66=, 0
	i32.const	$push3=, -2147483647
	i32.store	$discard=, a+4($pop66), $pop3
	i32.const	$push65=, 0
	i32.const	$push4=, 2147483647
	i32.store	$discard=, a+16380($pop65), $pop4
	i32.const	$push64=, 0
	i32.const	$push5=, -1
	i32.store	$discard=, b+16380($pop64), $pop5
	call    	f1@FUNCTION
	call    	f2@FUNCTION
	i32.const	$0=, 0
.LBB12_3:                               # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	block
	block
	block
	block
	loop                            # label32:
	i32.load	$push6=, c($1)
	i32.load	$push7=, a($1)
	i32.const	$push71=, 3
	i32.div_s	$push8=, $pop7, $pop71
	i32.ne  	$push9=, $pop6, $pop8
	br_if   	2, $pop9        # 2: down to label31
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB12_3 Depth=1
	i32.load	$push10=, d($1)
	i32.load	$push11=, b($1)
	i32.const	$push72=, 3
	i32.div_u	$push12=, $pop11, $pop72
	i32.ne  	$push13=, $pop10, $pop12
	br_if   	2, $pop13       # 2: down to label31
# BB#5:                                 # %for.cond2
                                        #   in Loop: Header=BB12_3 Depth=1
	i32.const	$push70=, 1
	i32.add 	$0=, $0, $pop70
	i32.const	$push69=, 4
	i32.add 	$1=, $1, $pop69
	i32.const	$push68=, 4095
	i32.le_s	$push14=, $0, $pop68
	br_if   	0, $pop14       # 0: up to label32
# BB#6:                                 # %for.end14
	end_loop                        # label33:
	call    	f3@FUNCTION
	call    	f4@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_7:                               # %for.body17
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label34:
	i32.load	$push15=, c($1)
	i32.load	$push16=, a($1)
	i32.const	$push76=, 18
	i32.div_s	$push17=, $pop16, $pop76
	i32.ne  	$push18=, $pop15, $pop17
	br_if   	3, $pop18       # 3: down to label30
# BB#8:                                 # %lor.lhs.false22
                                        #   in Loop: Header=BB12_7 Depth=1
	i32.load	$push19=, d($1)
	i32.load	$push20=, b($1)
	i32.const	$push77=, 18
	i32.div_u	$push21=, $pop20, $pop77
	i32.ne  	$push22=, $pop19, $pop21
	br_if   	3, $pop22       # 3: down to label30
# BB#9:                                 # %for.cond15
                                        #   in Loop: Header=BB12_7 Depth=1
	i32.const	$push75=, 1
	i32.add 	$0=, $0, $pop75
	i32.const	$push74=, 4
	i32.add 	$1=, $1, $pop74
	i32.const	$push73=, 4095
	i32.le_s	$push23=, $0, $pop73
	br_if   	0, $pop23       # 0: up to label34
# BB#10:                                # %for.end31
	end_loop                        # label35:
	call    	f5@FUNCTION
	call    	f6@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_11:                              # %for.body34
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label36:
	i32.load	$push24=, c($1)
	i32.load	$push25=, a($1)
	i32.const	$push81=, 19
	i32.div_s	$push26=, $pop25, $pop81
	i32.ne  	$push27=, $pop24, $pop26
	br_if   	4, $pop27       # 4: down to label29
# BB#12:                                # %lor.lhs.false39
                                        #   in Loop: Header=BB12_11 Depth=1
	i32.load	$push28=, d($1)
	i32.load	$push29=, b($1)
	i32.const	$push82=, 19
	i32.div_u	$push30=, $pop29, $pop82
	i32.ne  	$push31=, $pop28, $pop30
	br_if   	4, $pop31       # 4: down to label29
# BB#13:                                # %for.cond32
                                        #   in Loop: Header=BB12_11 Depth=1
	i32.const	$push80=, 1
	i32.add 	$0=, $0, $pop80
	i32.const	$push79=, 4
	i32.add 	$1=, $1, $pop79
	i32.const	$push78=, 4095
	i32.le_s	$push32=, $0, $pop78
	br_if   	0, $pop32       # 0: up to label36
# BB#14:                                # %for.end48
	end_loop                        # label37:
	call    	f7@FUNCTION
	call    	f8@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_15:                              # %for.body51
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label38:
	i32.load	$push33=, c($1)
	i32.load	$push34=, a($1)
	i32.const	$push86=, 3
	i32.div_s	$push35=, $pop34, $pop86
	i32.ne  	$push36=, $pop33, $pop35
	br_if   	5, $pop36       # 5: down to label28
# BB#16:                                # %lor.lhs.false56
                                        #   in Loop: Header=BB12_15 Depth=1
	i32.load	$push37=, d($1)
	i32.load	$push38=, b($1)
	i32.const	$push87=, 3
	i32.div_u	$push39=, $pop38, $pop87
	i32.ne  	$push40=, $pop37, $pop39
	br_if   	5, $pop40       # 5: down to label28
# BB#17:                                # %for.cond49
                                        #   in Loop: Header=BB12_15 Depth=1
	i32.const	$push85=, 1
	i32.add 	$0=, $0, $pop85
	i32.const	$push84=, 4
	i32.add 	$1=, $1, $pop84
	i32.const	$push83=, 4095
	i32.le_s	$push41=, $0, $pop83
	br_if   	0, $pop41       # 0: up to label38
# BB#18:                                # %for.end65
	end_loop                        # label39:
	call    	f9@FUNCTION
	call    	f10@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_19:                              # %for.body68
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label40:
	i32.load	$push42=, c($1)
	i32.load	$push43=, a($1)
	i32.const	$push91=, 18
	i32.div_s	$push44=, $pop43, $pop91
	i32.ne  	$push45=, $pop42, $pop44
	br_if   	6, $pop45       # 6: down to label27
# BB#20:                                # %lor.lhs.false73
                                        #   in Loop: Header=BB12_19 Depth=1
	i32.load	$push46=, d($1)
	i32.load	$push47=, b($1)
	i32.const	$push92=, 18
	i32.div_u	$push48=, $pop47, $pop92
	i32.ne  	$push49=, $pop46, $pop48
	br_if   	6, $pop49       # 6: down to label27
# BB#21:                                # %for.cond66
                                        #   in Loop: Header=BB12_19 Depth=1
	i32.const	$push90=, 1
	i32.add 	$0=, $0, $pop90
	i32.const	$push89=, 4
	i32.add 	$1=, $1, $pop89
	i32.const	$push88=, 4095
	i32.le_s	$push50=, $0, $pop88
	br_if   	0, $pop50       # 0: up to label40
# BB#22:                                # %for.end82
	end_loop                        # label41:
	call    	f11@FUNCTION
	call    	f12@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_23:                              # %for.body85
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label42:
	i32.load	$push51=, c($1)
	i32.load	$push52=, a($1)
	i32.const	$push96=, 19
	i32.div_s	$push53=, $pop52, $pop96
	i32.ne  	$push54=, $pop51, $pop53
	br_if   	7, $pop54       # 7: down to label26
# BB#24:                                # %lor.lhs.false90
                                        #   in Loop: Header=BB12_23 Depth=1
	i32.load	$push55=, d($1)
	i32.load	$push56=, b($1)
	i32.const	$push97=, 19
	i32.div_u	$push57=, $pop56, $pop97
	i32.ne  	$push58=, $pop55, $pop57
	br_if   	7, $pop58       # 7: down to label26
# BB#25:                                # %for.cond83
                                        #   in Loop: Header=BB12_23 Depth=1
	i32.const	$push95=, 1
	i32.add 	$0=, $0, $pop95
	i32.const	$push94=, 4
	i32.add 	$1=, $1, $pop94
	i32.const	$push93=, 4095
	i32.le_s	$push59=, $0, $pop93
	br_if   	0, $pop59       # 0: up to label42
# BB#26:                                # %for.end99
	end_loop                        # label43:
	i32.const	$push60=, 0
	return  	$pop60
.LBB12_27:                              # %if.then
	end_block                       # label31:
	call    	abort@FUNCTION
	unreachable
.LBB12_28:                              # %if.then27
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
.LBB12_29:                              # %if.then44
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB12_30:                              # %if.then61
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
.LBB12_31:                              # %if.then78
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
.LBB12_32:                              # %if.then95
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end12:
	.size	main, .Lfunc_end12-main

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


	.ident	"clang version 3.9.0 "
