	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr51581-2.c"
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
	i32.rem_s	$push1=, $pop0, $pop3
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
	i32.rem_u	$push1=, $pop0, $pop3
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
	i32.rem_s	$push1=, $pop0, $pop3
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
	i32.rem_u	$push1=, $pop0, $pop3
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
	i32.rem_s	$push1=, $pop0, $pop3
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
	i32.rem_u	$push1=, $pop0, $pop3
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
	i32.load	$push14=, a+16384($0)
	tee_local	$push13=, $1=, $pop14
	i64.extend_s/i32	$push0=, $pop13
	i64.const	$push12=, 1431655766
	i64.mul 	$push1=, $pop0, $pop12
	i64.const	$push11=, 32
	i64.shr_u	$push2=, $pop1, $pop11
	i32.wrap/i64	$push3=, $pop2
	i32.const	$push10=, 31
	i32.shr_s	$push4=, $1, $pop10
	i32.sub 	$push5=, $pop3, $pop4
	i32.const	$push9=, -3
	i32.mul 	$push6=, $pop5, $pop9
	i32.add 	$push7=, $pop6, $1
	i32.store	$discard=, c+16384($0), $pop7
	i32.const	$push8=, 4
	i32.add 	$0=, $0, $pop8
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB7_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label14:
	i32.load	$push11=, b+16384($0)
	tee_local	$push10=, $1=, $pop11
	i64.extend_u/i32	$push0=, $pop10
	i64.const	$push9=, 2863311531
	i64.mul 	$push1=, $pop0, $pop9
	i64.const	$push8=, 33
	i64.shr_u	$push2=, $pop1, $pop8
	i32.wrap/i64	$push3=, $pop2
	i32.const	$push7=, -3
	i32.mul 	$push4=, $pop3, $pop7
	i32.add 	$push5=, $pop4, $1
	i32.store	$discard=, d+16384($0), $pop5
	i32.const	$push6=, 4
	i32.add 	$0=, $0, $pop6
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
	i32.load	$push14=, a+16384($0)
	tee_local	$push13=, $1=, $pop14
	i64.extend_s/i32	$push0=, $pop13
	i64.const	$push12=, 954437177
	i64.mul 	$push1=, $pop0, $pop12
	i64.const	$push11=, 34
	i64.shr_s	$push2=, $pop1, $pop11
	i32.wrap/i64	$push3=, $pop2
	i32.const	$push10=, 31
	i32.shr_s	$push4=, $1, $pop10
	i32.sub 	$push5=, $pop3, $pop4
	i32.const	$push9=, -18
	i32.mul 	$push6=, $pop5, $pop9
	i32.add 	$push7=, $pop6, $1
	i32.store	$discard=, c+16384($0), $pop7
	i32.const	$push8=, 4
	i32.add 	$0=, $0, $pop8
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, -16384
.LBB9_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label18:
	i32.load	$push11=, b+16384($0)
	tee_local	$push10=, $1=, $pop11
	i64.extend_u/i32	$push0=, $pop10
	i64.const	$push9=, 954437177
	i64.mul 	$push1=, $pop0, $pop9
	i64.const	$push8=, 34
	i64.shr_u	$push2=, $pop1, $pop8
	i32.wrap/i64	$push3=, $pop2
	i32.const	$push7=, -18
	i32.mul 	$push4=, $pop3, $pop7
	i32.add 	$push5=, $pop4, $1
	i32.store	$discard=, d+16384($0), $pop5
	i32.const	$push6=, 4
	i32.add 	$0=, $0, $pop6
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
	i32.load	$push14=, a+16384($0)
	tee_local	$push13=, $1=, $pop14
	i64.extend_s/i32	$push0=, $pop13
	i64.const	$push12=, 1808407283
	i64.mul 	$push1=, $pop0, $pop12
	i64.const	$push11=, 35
	i64.shr_s	$push2=, $pop1, $pop11
	i32.wrap/i64	$push3=, $pop2
	i32.const	$push10=, 31
	i32.shr_s	$push4=, $1, $pop10
	i32.sub 	$push5=, $pop3, $pop4
	i32.const	$push9=, -19
	i32.mul 	$push6=, $pop5, $pop9
	i32.add 	$push7=, $pop6, $1
	i32.store	$discard=, c+16384($0), $pop7
	i32.const	$push8=, 4
	i32.add 	$0=, $0, $pop8
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
	i64.const	$push16=, 2938661835
	i64.mul 	$push1=, $pop0, $pop16
	i64.const	$push15=, 32
	i64.shr_u	$push2=, $pop1, $pop15
	i32.wrap/i64	$push14=, $pop2
	tee_local	$push13=, $2=, $pop14
	i32.sub 	$push3=, $0, $pop13
	i32.const	$push12=, 1
	i32.shr_u	$push4=, $pop3, $pop12
	i32.add 	$push5=, $pop4, $2
	i32.const	$push11=, 4
	i32.shr_u	$push6=, $pop5, $pop11
	i32.const	$push10=, -19
	i32.mul 	$push7=, $pop6, $pop10
	i32.add 	$push8=, $pop7, $0
	i32.store	$discard=, d+16384($1), $pop8
	i32.const	$push9=, 4
	i32.add 	$1=, $1, $pop9
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
	i32.const	$push62=, -2048
	i32.add 	$push0=, $0, $pop62
	i32.store	$discard=, a+16384($1), $pop0
	i32.store	$push1=, b+16384($1), $0
	i32.const	$push61=, 1
	i32.add 	$0=, $pop1, $pop61
	i32.const	$push60=, 4
	i32.add 	$1=, $1, $pop60
	br_if   	0, $1           # 0: up to label24
# BB#2:                                 # %for.end
	end_loop                        # label25:
	i32.const	$1=, 0
	i32.const	$push65=, 0
	i32.const	$push3=, 2147483647
	i32.store	$discard=, a+16380($pop65), $pop3
	i32.const	$push64=, 0
	i32.const	$push4=, -1
	i32.store	$discard=, b+16380($pop64), $pop4
	i32.const	$push63=, 0
	i64.const	$push2=, -9223372030412324864
	i64.store	$discard=, a($pop63), $pop2
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
	i32.load	$push5=, c($1)
	i32.load	$push6=, a($1)
	i32.const	$push69=, 3
	i32.rem_s	$push7=, $pop6, $pop69
	i32.ne  	$push8=, $pop5, $pop7
	br_if   	2, $pop8        # 2: down to label31
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB12_3 Depth=1
	i32.load	$push9=, d($1)
	i32.load	$push10=, b($1)
	i32.const	$push70=, 3
	i32.rem_u	$push11=, $pop10, $pop70
	i32.ne  	$push12=, $pop9, $pop11
	br_if   	2, $pop12       # 2: down to label31
# BB#5:                                 # %for.cond2
                                        #   in Loop: Header=BB12_3 Depth=1
	i32.const	$push68=, 1
	i32.add 	$0=, $0, $pop68
	i32.const	$push67=, 4
	i32.add 	$1=, $1, $pop67
	i32.const	$push66=, 4095
	i32.le_s	$push13=, $0, $pop66
	br_if   	0, $pop13       # 0: up to label32
# BB#6:                                 # %for.end14
	end_loop                        # label33:
	call    	f3@FUNCTION
	call    	f4@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_7:                               # %for.body17
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label34:
	i32.load	$push14=, c($1)
	i32.load	$push15=, a($1)
	i32.const	$push74=, 18
	i32.rem_s	$push16=, $pop15, $pop74
	i32.ne  	$push17=, $pop14, $pop16
	br_if   	3, $pop17       # 3: down to label30
# BB#8:                                 # %lor.lhs.false22
                                        #   in Loop: Header=BB12_7 Depth=1
	i32.load	$push18=, d($1)
	i32.load	$push19=, b($1)
	i32.const	$push75=, 18
	i32.rem_u	$push20=, $pop19, $pop75
	i32.ne  	$push21=, $pop18, $pop20
	br_if   	3, $pop21       # 3: down to label30
# BB#9:                                 # %for.cond15
                                        #   in Loop: Header=BB12_7 Depth=1
	i32.const	$push73=, 1
	i32.add 	$0=, $0, $pop73
	i32.const	$push72=, 4
	i32.add 	$1=, $1, $pop72
	i32.const	$push71=, 4095
	i32.le_s	$push22=, $0, $pop71
	br_if   	0, $pop22       # 0: up to label34
# BB#10:                                # %for.end31
	end_loop                        # label35:
	call    	f5@FUNCTION
	call    	f6@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_11:                              # %for.body34
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label36:
	i32.load	$push23=, c($1)
	i32.load	$push24=, a($1)
	i32.const	$push79=, 19
	i32.rem_s	$push25=, $pop24, $pop79
	i32.ne  	$push26=, $pop23, $pop25
	br_if   	4, $pop26       # 4: down to label29
# BB#12:                                # %lor.lhs.false39
                                        #   in Loop: Header=BB12_11 Depth=1
	i32.load	$push27=, d($1)
	i32.load	$push28=, b($1)
	i32.const	$push80=, 19
	i32.rem_u	$push29=, $pop28, $pop80
	i32.ne  	$push30=, $pop27, $pop29
	br_if   	4, $pop30       # 4: down to label29
# BB#13:                                # %for.cond32
                                        #   in Loop: Header=BB12_11 Depth=1
	i32.const	$push78=, 1
	i32.add 	$0=, $0, $pop78
	i32.const	$push77=, 4
	i32.add 	$1=, $1, $pop77
	i32.const	$push76=, 4095
	i32.le_s	$push31=, $0, $pop76
	br_if   	0, $pop31       # 0: up to label36
# BB#14:                                # %for.end48
	end_loop                        # label37:
	call    	f7@FUNCTION
	call    	f8@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_15:                              # %for.body51
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label38:
	i32.load	$push32=, c($1)
	i32.load	$push33=, a($1)
	i32.const	$push84=, 3
	i32.rem_s	$push34=, $pop33, $pop84
	i32.ne  	$push35=, $pop32, $pop34
	br_if   	5, $pop35       # 5: down to label28
# BB#16:                                # %lor.lhs.false56
                                        #   in Loop: Header=BB12_15 Depth=1
	i32.load	$push36=, d($1)
	i32.load	$push37=, b($1)
	i32.const	$push85=, 3
	i32.rem_u	$push38=, $pop37, $pop85
	i32.ne  	$push39=, $pop36, $pop38
	br_if   	5, $pop39       # 5: down to label28
# BB#17:                                # %for.cond49
                                        #   in Loop: Header=BB12_15 Depth=1
	i32.const	$push83=, 1
	i32.add 	$0=, $0, $pop83
	i32.const	$push82=, 4
	i32.add 	$1=, $1, $pop82
	i32.const	$push81=, 4095
	i32.le_s	$push40=, $0, $pop81
	br_if   	0, $pop40       # 0: up to label38
# BB#18:                                # %for.end65
	end_loop                        # label39:
	call    	f9@FUNCTION
	call    	f10@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_19:                              # %for.body68
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label40:
	i32.load	$push41=, c($1)
	i32.load	$push42=, a($1)
	i32.const	$push89=, 18
	i32.rem_s	$push43=, $pop42, $pop89
	i32.ne  	$push44=, $pop41, $pop43
	br_if   	6, $pop44       # 6: down to label27
# BB#20:                                # %lor.lhs.false73
                                        #   in Loop: Header=BB12_19 Depth=1
	i32.load	$push45=, d($1)
	i32.load	$push46=, b($1)
	i32.const	$push90=, 18
	i32.rem_u	$push47=, $pop46, $pop90
	i32.ne  	$push48=, $pop45, $pop47
	br_if   	6, $pop48       # 6: down to label27
# BB#21:                                # %for.cond66
                                        #   in Loop: Header=BB12_19 Depth=1
	i32.const	$push88=, 1
	i32.add 	$0=, $0, $pop88
	i32.const	$push87=, 4
	i32.add 	$1=, $1, $pop87
	i32.const	$push86=, 4095
	i32.le_s	$push49=, $0, $pop86
	br_if   	0, $pop49       # 0: up to label40
# BB#22:                                # %for.end82
	end_loop                        # label41:
	call    	f11@FUNCTION
	call    	f12@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, 0
.LBB12_23:                              # %for.body85
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label42:
	i32.load	$push50=, c($1)
	i32.load	$push51=, a($1)
	i32.const	$push94=, 19
	i32.rem_s	$push52=, $pop51, $pop94
	i32.ne  	$push53=, $pop50, $pop52
	br_if   	7, $pop53       # 7: down to label26
# BB#24:                                # %lor.lhs.false90
                                        #   in Loop: Header=BB12_23 Depth=1
	i32.load	$push54=, d($1)
	i32.load	$push55=, b($1)
	i32.const	$push95=, 19
	i32.rem_u	$push56=, $pop55, $pop95
	i32.ne  	$push57=, $pop54, $pop56
	br_if   	7, $pop57       # 7: down to label26
# BB#25:                                # %for.cond83
                                        #   in Loop: Header=BB12_23 Depth=1
	i32.const	$push93=, 1
	i32.add 	$0=, $0, $pop93
	i32.const	$push92=, 4
	i32.add 	$1=, $1, $pop92
	i32.const	$push91=, 4095
	i32.le_s	$push58=, $0, $pop91
	br_if   	0, $pop58       # 0: up to label42
# BB#26:                                # %for.end99
	end_loop                        # label43:
	i32.const	$push59=, 0
	return  	$pop59
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
