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
	i32.const	$push5=, 3
	i32.div_s	$push1=, $pop0, $pop5
	i32.store	$drop=, c+16384($0), $pop1
	i32.const	$push4=, 4
	i32.add 	$push3=, $0, $pop4
	tee_local	$push2=, $0=, $pop3
	br_if   	0, $pop2        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
                                        # fallthrough-return
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
	i32.const	$push5=, 3
	i32.div_u	$push1=, $pop0, $pop5
	i32.store	$drop=, d+16384($0), $pop1
	i32.const	$push4=, 4
	i32.add 	$push3=, $0, $pop4
	tee_local	$push2=, $0=, $pop3
	br_if   	0, $pop2        # 0: up to label2
# BB#2:                                 # %for.end
	end_loop                        # label3:
                                        # fallthrough-return
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
	i32.const	$push5=, 18
	i32.div_s	$push1=, $pop0, $pop5
	i32.store	$drop=, c+16384($0), $pop1
	i32.const	$push4=, 4
	i32.add 	$push3=, $0, $pop4
	tee_local	$push2=, $0=, $pop3
	br_if   	0, $pop2        # 0: up to label4
# BB#2:                                 # %for.end
	end_loop                        # label5:
                                        # fallthrough-return
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
	i32.const	$push5=, 18
	i32.div_u	$push1=, $pop0, $pop5
	i32.store	$drop=, d+16384($0), $pop1
	i32.const	$push4=, 4
	i32.add 	$push3=, $0, $pop4
	tee_local	$push2=, $0=, $pop3
	br_if   	0, $pop2        # 0: up to label6
# BB#2:                                 # %for.end
	end_loop                        # label7:
                                        # fallthrough-return
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
	i32.const	$push5=, 19
	i32.div_s	$push1=, $pop0, $pop5
	i32.store	$drop=, c+16384($0), $pop1
	i32.const	$push4=, 4
	i32.add 	$push3=, $0, $pop4
	tee_local	$push2=, $0=, $pop3
	br_if   	0, $pop2        # 0: up to label8
# BB#2:                                 # %for.end
	end_loop                        # label9:
                                        # fallthrough-return
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
	i32.const	$push5=, 19
	i32.div_u	$push1=, $pop0, $pop5
	i32.store	$drop=, d+16384($0), $pop1
	i32.const	$push4=, 4
	i32.add 	$push3=, $0, $pop4
	tee_local	$push2=, $0=, $pop3
	br_if   	0, $pop2        # 0: up to label10
# BB#2:                                 # %for.end
	end_loop                        # label11:
                                        # fallthrough-return
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
	i32.const	$1=, -16384
.LBB6_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label12:
	i32.load	$push13=, a+16384($1)
	tee_local	$push12=, $0=, $pop13
	i64.extend_s/i32	$push1=, $pop12
	i64.const	$push11=, 1431655766
	i64.mul 	$push2=, $pop1, $pop11
	i64.const	$push10=, 32
	i64.shr_u	$push3=, $pop2, $pop10
	i32.wrap/i64	$push4=, $pop3
	i32.const	$push9=, 31
	i32.shr_s	$push0=, $0, $pop9
	i32.sub 	$push5=, $pop4, $pop0
	i32.store	$drop=, c+16384($1), $pop5
	i32.const	$push8=, 4
	i32.add 	$push7=, $1, $pop8
	tee_local	$push6=, $1=, $pop7
	br_if   	0, $pop6        # 0: up to label12
# BB#2:                                 # %for.end
	end_loop                        # label13:
                                        # fallthrough-return
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
	i64.const	$push7=, 2863311531
	i64.mul 	$push1=, $pop0, $pop7
	i64.const	$push6=, 33
	i64.shr_u	$push2=, $pop1, $pop6
	i64.store32	$drop=, d+16384($0), $pop2
	i32.const	$push5=, 4
	i32.add 	$push4=, $0, $pop5
	tee_local	$push3=, $0=, $pop4
	br_if   	0, $pop3        # 0: up to label14
# BB#2:                                 # %for.end
	end_loop                        # label15:
                                        # fallthrough-return
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
	i32.const	$1=, -16384
.LBB8_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	i32.load	$push13=, a+16384($1)
	tee_local	$push12=, $0=, $pop13
	i64.extend_s/i32	$push1=, $pop12
	i64.const	$push11=, 954437177
	i64.mul 	$push2=, $pop1, $pop11
	i64.const	$push10=, 34
	i64.shr_s	$push3=, $pop2, $pop10
	i32.wrap/i64	$push4=, $pop3
	i32.const	$push9=, 31
	i32.shr_s	$push0=, $0, $pop9
	i32.sub 	$push5=, $pop4, $pop0
	i32.store	$drop=, c+16384($1), $pop5
	i32.const	$push8=, 4
	i32.add 	$push7=, $1, $pop8
	tee_local	$push6=, $1=, $pop7
	br_if   	0, $pop6        # 0: up to label16
# BB#2:                                 # %for.end
	end_loop                        # label17:
                                        # fallthrough-return
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
	i64.const	$push7=, 954437177
	i64.mul 	$push1=, $pop0, $pop7
	i64.const	$push6=, 34
	i64.shr_u	$push2=, $pop1, $pop6
	i64.store32	$drop=, d+16384($0), $pop2
	i32.const	$push5=, 4
	i32.add 	$push4=, $0, $pop5
	tee_local	$push3=, $0=, $pop4
	br_if   	0, $pop3        # 0: up to label18
# BB#2:                                 # %for.end
	end_loop                        # label19:
                                        # fallthrough-return
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
	i32.const	$1=, -16384
.LBB10_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label20:
	i32.load	$push13=, a+16384($1)
	tee_local	$push12=, $0=, $pop13
	i64.extend_s/i32	$push1=, $pop12
	i64.const	$push11=, 1808407283
	i64.mul 	$push2=, $pop1, $pop11
	i64.const	$push10=, 35
	i64.shr_s	$push3=, $pop2, $pop10
	i32.wrap/i64	$push4=, $pop3
	i32.const	$push9=, 31
	i32.shr_s	$push0=, $0, $pop9
	i32.sub 	$push5=, $pop4, $pop0
	i32.store	$drop=, c+16384($1), $pop5
	i32.const	$push8=, 4
	i32.add 	$push7=, $1, $pop8
	tee_local	$push6=, $1=, $pop7
	br_if   	0, $pop6        # 0: up to label20
# BB#2:                                 # %for.end
	end_loop                        # label21:
                                        # fallthrough-return
	.endfunc
.Lfunc_end10:
	.size	f11, .Lfunc_end10-f11

	.section	.text.f12,"ax",@progbits
	.hidden	f12
	.globl	f12
	.type	f12,@function
f12:                                    # @f12
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -16384
.LBB11_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label22:
	i32.load	$push17=, b+16384($1)
	tee_local	$push16=, $0=, $pop17
	i64.extend_u/i32	$push0=, $0
	i64.const	$push15=, 2938661835
	i64.mul 	$push1=, $pop0, $pop15
	i64.const	$push14=, 32
	i64.shr_u	$push2=, $pop1, $pop14
	i32.wrap/i64	$push13=, $pop2
	tee_local	$push12=, $0=, $pop13
	i32.sub 	$push3=, $pop16, $pop12
	i32.const	$push11=, 1
	i32.shr_u	$push4=, $pop3, $pop11
	i32.add 	$push5=, $pop4, $0
	i32.const	$push10=, 4
	i32.shr_u	$push6=, $pop5, $pop10
	i32.store	$drop=, d+16384($1), $pop6
	i32.const	$push9=, 4
	i32.add 	$push8=, $1, $pop9
	tee_local	$push7=, $1=, $pop8
	br_if   	0, $pop7        # 0: up to label22
# BB#2:                                 # %for.end
	end_loop                        # label23:
                                        # fallthrough-return
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
	i32.store	$push65=, b+16384($1), $0
	tee_local	$push64=, $0=, $pop65
	i32.const	$push63=, -2048
	i32.add 	$push0=, $pop64, $pop63
	i32.store	$drop=, a+16384($1), $pop0
	i32.const	$push62=, 1
	i32.add 	$0=, $0, $pop62
	i32.const	$push61=, 4
	i32.add 	$push60=, $1, $pop61
	tee_local	$push59=, $1=, $pop60
	br_if   	0, $pop59       # 0: up to label24
# BB#2:                                 # %for.end
	end_loop                        # label25:
	i32.const	$1=, 0
	i32.const	$push68=, 0
	i32.const	$push1=, 2147483647
	i32.store	$drop=, a+16380($pop68), $pop1
	i32.const	$push67=, 0
	i64.const	$push2=, -9223372030412324864
	i64.store	$drop=, a($pop67), $pop2
	i32.const	$push66=, 0
	i32.const	$push3=, -1
	i32.store	$drop=, b+16380($pop66), $pop3
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
	i32.load	$push4=, a($1)
	i32.const	$push69=, 3
	i32.div_s	$push5=, $pop4, $pop69
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	2, $pop7        # 2: down to label31
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB12_3 Depth=1
	i32.load	$push10=, d($1)
	i32.load	$push8=, b($1)
	i32.const	$push70=, 3
	i32.div_u	$push9=, $pop8, $pop70
	i32.ne  	$push11=, $pop10, $pop9
	br_if   	2, $pop11       # 2: down to label31
# BB#5:                                 # %for.cond2
                                        #   in Loop: Header=BB12_3 Depth=1
	i32.const	$push75=, 4
	i32.add 	$1=, $1, $pop75
	i32.const	$push74=, 1
	i32.add 	$push73=, $0, $pop74
	tee_local	$push72=, $0=, $pop73
	i32.const	$push71=, 4095
	i32.le_s	$push12=, $pop72, $pop71
	br_if   	0, $pop12       # 0: up to label32
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
	i32.load	$push13=, a($1)
	i32.const	$push76=, 18
	i32.div_s	$push14=, $pop13, $pop76
	i32.ne  	$push16=, $pop15, $pop14
	br_if   	3, $pop16       # 3: down to label30
# BB#8:                                 # %lor.lhs.false22
                                        #   in Loop: Header=BB12_7 Depth=1
	i32.load	$push19=, d($1)
	i32.load	$push17=, b($1)
	i32.const	$push77=, 18
	i32.div_u	$push18=, $pop17, $pop77
	i32.ne  	$push20=, $pop19, $pop18
	br_if   	3, $pop20       # 3: down to label30
# BB#9:                                 # %for.cond15
                                        #   in Loop: Header=BB12_7 Depth=1
	i32.const	$push82=, 4
	i32.add 	$1=, $1, $pop82
	i32.const	$push81=, 1
	i32.add 	$push80=, $0, $pop81
	tee_local	$push79=, $0=, $pop80
	i32.const	$push78=, 4095
	i32.le_s	$push21=, $pop79, $pop78
	br_if   	0, $pop21       # 0: up to label34
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
	i32.load	$push22=, a($1)
	i32.const	$push83=, 19
	i32.div_s	$push23=, $pop22, $pop83
	i32.ne  	$push25=, $pop24, $pop23
	br_if   	4, $pop25       # 4: down to label29
# BB#12:                                # %lor.lhs.false39
                                        #   in Loop: Header=BB12_11 Depth=1
	i32.load	$push28=, d($1)
	i32.load	$push26=, b($1)
	i32.const	$push84=, 19
	i32.div_u	$push27=, $pop26, $pop84
	i32.ne  	$push29=, $pop28, $pop27
	br_if   	4, $pop29       # 4: down to label29
# BB#13:                                # %for.cond32
                                        #   in Loop: Header=BB12_11 Depth=1
	i32.const	$push89=, 4
	i32.add 	$1=, $1, $pop89
	i32.const	$push88=, 1
	i32.add 	$push87=, $0, $pop88
	tee_local	$push86=, $0=, $pop87
	i32.const	$push85=, 4095
	i32.le_s	$push30=, $pop86, $pop85
	br_if   	0, $pop30       # 0: up to label36
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
	i32.load	$push31=, a($1)
	i32.const	$push90=, 3
	i32.div_s	$push32=, $pop31, $pop90
	i32.ne  	$push34=, $pop33, $pop32
	br_if   	5, $pop34       # 5: down to label28
# BB#16:                                # %lor.lhs.false56
                                        #   in Loop: Header=BB12_15 Depth=1
	i32.load	$push37=, d($1)
	i32.load	$push35=, b($1)
	i32.const	$push91=, 3
	i32.div_u	$push36=, $pop35, $pop91
	i32.ne  	$push38=, $pop37, $pop36
	br_if   	5, $pop38       # 5: down to label28
# BB#17:                                # %for.cond49
                                        #   in Loop: Header=BB12_15 Depth=1
	i32.const	$push96=, 4
	i32.add 	$1=, $1, $pop96
	i32.const	$push95=, 1
	i32.add 	$push94=, $0, $pop95
	tee_local	$push93=, $0=, $pop94
	i32.const	$push92=, 4095
	i32.le_s	$push39=, $pop93, $pop92
	br_if   	0, $pop39       # 0: up to label38
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
	i32.load	$push40=, a($1)
	i32.const	$push97=, 18
	i32.div_s	$push41=, $pop40, $pop97
	i32.ne  	$push43=, $pop42, $pop41
	br_if   	6, $pop43       # 6: down to label27
# BB#20:                                # %lor.lhs.false73
                                        #   in Loop: Header=BB12_19 Depth=1
	i32.load	$push46=, d($1)
	i32.load	$push44=, b($1)
	i32.const	$push98=, 18
	i32.div_u	$push45=, $pop44, $pop98
	i32.ne  	$push47=, $pop46, $pop45
	br_if   	6, $pop47       # 6: down to label27
# BB#21:                                # %for.cond66
                                        #   in Loop: Header=BB12_19 Depth=1
	i32.const	$push103=, 4
	i32.add 	$1=, $1, $pop103
	i32.const	$push102=, 1
	i32.add 	$push101=, $0, $pop102
	tee_local	$push100=, $0=, $pop101
	i32.const	$push99=, 4095
	i32.le_s	$push48=, $pop100, $pop99
	br_if   	0, $pop48       # 0: up to label40
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
	i32.load	$push49=, a($1)
	i32.const	$push104=, 19
	i32.div_s	$push50=, $pop49, $pop104
	i32.ne  	$push52=, $pop51, $pop50
	br_if   	7, $pop52       # 7: down to label26
# BB#24:                                # %lor.lhs.false90
                                        #   in Loop: Header=BB12_23 Depth=1
	i32.load	$push55=, d($1)
	i32.load	$push53=, b($1)
	i32.const	$push105=, 19
	i32.div_u	$push54=, $pop53, $pop105
	i32.ne  	$push56=, $pop55, $pop54
	br_if   	7, $pop56       # 7: down to label26
# BB#25:                                # %for.cond83
                                        #   in Loop: Header=BB12_23 Depth=1
	i32.const	$push110=, 4
	i32.add 	$1=, $1, $pop110
	i32.const	$push109=, 1
	i32.add 	$push108=, $0, $pop109
	tee_local	$push107=, $0=, $pop108
	i32.const	$push106=, 4095
	i32.le_s	$push57=, $pop107, $pop106
	br_if   	0, $pop57       # 0: up to label42
# BB#26:                                # %for.end99
	end_loop                        # label43:
	i32.const	$push58=, 0
	return  	$pop58
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
	.functype	abort, void
