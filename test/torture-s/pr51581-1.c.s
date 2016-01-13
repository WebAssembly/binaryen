	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr51581-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, -16384
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$0=, 16384
	i32.const	$push0=, a
	i32.add 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $0
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 3
	i32.div_s	$1=, $pop3, $pop4
	i32.const	$push5=, c
	i32.add 	$push6=, $pop5, $2
	i32.add 	$push7=, $pop6, $0
	i32.store	$discard=, 0($pop7), $1
	i32.const	$push8=, 4
	i32.add 	$2=, $2, $pop8
	br_if   	$2, 0           # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	return
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, -16384
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$0=, 16384
	i32.const	$push0=, b
	i32.add 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $0
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 3
	i32.div_u	$1=, $pop3, $pop4
	i32.const	$push5=, d
	i32.add 	$push6=, $pop5, $2
	i32.add 	$push7=, $pop6, $0
	i32.store	$discard=, 0($pop7), $1
	i32.const	$push8=, 4
	i32.add 	$2=, $2, $pop8
	br_if   	$2, 0           # 0: up to label2
# BB#2:                                 # %for.end
	end_loop                        # label3:
	return
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, -16384
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$0=, 16384
	i32.const	$push0=, a
	i32.add 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $0
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 18
	i32.div_s	$1=, $pop3, $pop4
	i32.const	$push5=, c
	i32.add 	$push6=, $pop5, $2
	i32.add 	$push7=, $pop6, $0
	i32.store	$discard=, 0($pop7), $1
	i32.const	$push8=, 4
	i32.add 	$2=, $2, $pop8
	br_if   	$2, 0           # 0: up to label4
# BB#2:                                 # %for.end
	end_loop                        # label5:
	return
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, -16384
.LBB3_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$0=, 16384
	i32.const	$push0=, b
	i32.add 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $0
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 18
	i32.div_u	$1=, $pop3, $pop4
	i32.const	$push5=, d
	i32.add 	$push6=, $pop5, $2
	i32.add 	$push7=, $pop6, $0
	i32.store	$discard=, 0($pop7), $1
	i32.const	$push8=, 4
	i32.add 	$2=, $2, $pop8
	br_if   	$2, 0           # 0: up to label6
# BB#2:                                 # %for.end
	end_loop                        # label7:
	return
.Lfunc_end3:
	.size	f4, .Lfunc_end3-f4

	.section	.text.f5,"ax",@progbits
	.hidden	f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, -16384
.LBB4_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	i32.const	$0=, 16384
	i32.const	$push0=, a
	i32.add 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $0
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 19
	i32.div_s	$1=, $pop3, $pop4
	i32.const	$push5=, c
	i32.add 	$push6=, $pop5, $2
	i32.add 	$push7=, $pop6, $0
	i32.store	$discard=, 0($pop7), $1
	i32.const	$push8=, 4
	i32.add 	$2=, $2, $pop8
	br_if   	$2, 0           # 0: up to label8
# BB#2:                                 # %for.end
	end_loop                        # label9:
	return
.Lfunc_end4:
	.size	f5, .Lfunc_end4-f5

	.section	.text.f6,"ax",@progbits
	.hidden	f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, -16384
.LBB5_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.const	$0=, 16384
	i32.const	$push0=, b
	i32.add 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $0
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 19
	i32.div_u	$1=, $pop3, $pop4
	i32.const	$push5=, d
	i32.add 	$push6=, $pop5, $2
	i32.add 	$push7=, $pop6, $0
	i32.store	$discard=, 0($pop7), $1
	i32.const	$push8=, 4
	i32.add 	$2=, $2, $pop8
	br_if   	$2, 0           # 0: up to label10
# BB#2:                                 # %for.end
	end_loop                        # label11:
	return
.Lfunc_end5:
	.size	f6, .Lfunc_end5-f6

	.section	.text.f7,"ax",@progbits
	.hidden	f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.local  	i32, i32, i64, i32
# BB#0:                                 # %entry
	i64.const	$2=, 1431655766
	i32.const	$3=, -16384
.LBB6_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label12:
	i32.const	$0=, 16384
	i32.const	$push0=, a
	i32.add 	$push1=, $pop0, $3
	i32.add 	$push2=, $pop1, $0
	i32.load	$1=, 0($pop2)
	i32.const	$push11=, c
	i32.add 	$push12=, $pop11, $3
	i32.add 	$push13=, $pop12, $0
	i64.extend_s/i32	$push3=, $1
	i64.mul 	$push4=, $pop3, $2
	i64.const	$push5=, 32
	i64.shr_u	$push6=, $pop4, $pop5
	i32.wrap/i64	$push7=, $pop6
	i32.const	$push8=, 31
	i32.shr_s	$push9=, $1, $pop8
	i32.sub 	$push10=, $pop7, $pop9
	i32.store	$discard=, 0($pop13), $pop10
	i32.const	$push14=, 4
	i32.add 	$3=, $3, $pop14
	br_if   	$3, 0           # 0: up to label12
# BB#2:                                 # %for.end
	end_loop                        # label13:
	return
.Lfunc_end6:
	.size	f7, .Lfunc_end6-f7

	.section	.text.f8,"ax",@progbits
	.hidden	f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.local  	i32, i64, i32
# BB#0:                                 # %entry
	i64.const	$1=, 2863311531
	i32.const	$2=, -16384
.LBB7_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label14:
	i32.const	$0=, 16384
	i32.const	$push7=, d
	i32.add 	$push8=, $pop7, $2
	i32.add 	$push9=, $pop8, $0
	i32.const	$push0=, b
	i32.add 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $0
	i64.load32_u	$push3=, 0($pop2)
	i64.mul 	$push4=, $pop3, $1
	i64.const	$push5=, 33
	i64.shr_u	$push6=, $pop4, $pop5
	i64.store32	$discard=, 0($pop9), $pop6
	i32.const	$push10=, 4
	i32.add 	$2=, $2, $pop10
	br_if   	$2, 0           # 0: up to label14
# BB#2:                                 # %for.end
	end_loop                        # label15:
	return
.Lfunc_end7:
	.size	f8, .Lfunc_end7-f8

	.section	.text.f9,"ax",@progbits
	.hidden	f9
	.globl	f9
	.type	f9,@function
f9:                                     # @f9
	.local  	i32, i32, i64, i32
# BB#0:                                 # %entry
	i64.const	$2=, 954437177
	i32.const	$3=, -16384
.LBB8_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	i32.const	$0=, 16384
	i32.const	$push0=, a
	i32.add 	$push1=, $pop0, $3
	i32.add 	$push2=, $pop1, $0
	i32.load	$1=, 0($pop2)
	i32.const	$push11=, c
	i32.add 	$push12=, $pop11, $3
	i32.add 	$push13=, $pop12, $0
	i64.extend_s/i32	$push3=, $1
	i64.mul 	$push4=, $pop3, $2
	i64.const	$push5=, 34
	i64.shr_s	$push6=, $pop4, $pop5
	i32.wrap/i64	$push7=, $pop6
	i32.const	$push8=, 31
	i32.shr_s	$push9=, $1, $pop8
	i32.sub 	$push10=, $pop7, $pop9
	i32.store	$discard=, 0($pop13), $pop10
	i32.const	$push14=, 4
	i32.add 	$3=, $3, $pop14
	br_if   	$3, 0           # 0: up to label16
# BB#2:                                 # %for.end
	end_loop                        # label17:
	return
.Lfunc_end8:
	.size	f9, .Lfunc_end8-f9

	.section	.text.f10,"ax",@progbits
	.hidden	f10
	.globl	f10
	.type	f10,@function
f10:                                    # @f10
	.local  	i32, i64, i32
# BB#0:                                 # %entry
	i64.const	$1=, 954437177
	i32.const	$2=, -16384
.LBB9_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label18:
	i32.const	$0=, 16384
	i32.const	$push7=, d
	i32.add 	$push8=, $pop7, $2
	i32.add 	$push9=, $pop8, $0
	i32.const	$push0=, b
	i32.add 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $0
	i64.load32_u	$push3=, 0($pop2)
	i64.mul 	$push4=, $pop3, $1
	i64.const	$push5=, 34
	i64.shr_u	$push6=, $pop4, $pop5
	i64.store32	$discard=, 0($pop9), $pop6
	i32.const	$push10=, 4
	i32.add 	$2=, $2, $pop10
	br_if   	$2, 0           # 0: up to label18
# BB#2:                                 # %for.end
	end_loop                        # label19:
	return
.Lfunc_end9:
	.size	f10, .Lfunc_end9-f10

	.section	.text.f11,"ax",@progbits
	.hidden	f11
	.globl	f11
	.type	f11,@function
f11:                                    # @f11
	.local  	i32, i32, i64, i32
# BB#0:                                 # %entry
	i64.const	$2=, 1808407283
	i32.const	$3=, -16384
.LBB10_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label20:
	i32.const	$0=, 16384
	i32.const	$push0=, a
	i32.add 	$push1=, $pop0, $3
	i32.add 	$push2=, $pop1, $0
	i32.load	$1=, 0($pop2)
	i32.const	$push11=, c
	i32.add 	$push12=, $pop11, $3
	i32.add 	$push13=, $pop12, $0
	i64.extend_s/i32	$push3=, $1
	i64.mul 	$push4=, $pop3, $2
	i64.const	$push5=, 35
	i64.shr_s	$push6=, $pop4, $pop5
	i32.wrap/i64	$push7=, $pop6
	i32.const	$push8=, 31
	i32.shr_s	$push9=, $1, $pop8
	i32.sub 	$push10=, $pop7, $pop9
	i32.store	$discard=, 0($pop13), $pop10
	i32.const	$push14=, 4
	i32.add 	$3=, $3, $pop14
	br_if   	$3, 0           # 0: up to label20
# BB#2:                                 # %for.end
	end_loop                        # label21:
	return
.Lfunc_end10:
	.size	f11, .Lfunc_end10-f11

	.section	.text.f12,"ax",@progbits
	.hidden	f12
	.globl	f12
	.type	f12,@function
f12:                                    # @f12
	.local  	i32, i32, i64, i32, i32, i32
# BB#0:                                 # %entry
	i64.const	$2=, 2938661835
	i32.const	$5=, -16384
.LBB11_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label22:
	i32.const	$0=, 16384
	i32.const	$push0=, b
	i32.add 	$push1=, $pop0, $5
	i32.add 	$push2=, $pop1, $0
	i32.load	$1=, 0($pop2)
	i64.extend_u/i32	$push3=, $1
	i64.mul 	$push4=, $pop3, $2
	i64.const	$push5=, 32
	i64.shr_u	$push6=, $pop4, $pop5
	i32.wrap/i64	$3=, $pop6
	i32.const	$4=, 4
	i32.const	$push12=, d
	i32.add 	$push13=, $pop12, $5
	i32.add 	$push14=, $pop13, $0
	i32.sub 	$push7=, $1, $3
	i32.const	$push8=, 1
	i32.shr_u	$push9=, $pop7, $pop8
	i32.add 	$push10=, $pop9, $3
	i32.shr_u	$push11=, $pop10, $4
	i32.store	$discard=, 0($pop14), $pop11
	i32.add 	$5=, $5, $4
	br_if   	$5, 0           # 0: up to label22
# BB#2:                                 # %for.end
	end_loop                        # label23:
	return
.Lfunc_end11:
	.size	f12, .Lfunc_end11-f12

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
	i32.const	$4=, -16384
.LBB12_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label24:
	#APP
	#NO_APP
	i32.const	$0=, a
	i32.const	$2=, 16384
	i32.add 	$push2=, $0, $4
	i32.add 	$push3=, $pop2, $2
	i32.const	$push0=, -2048
	i32.add 	$push1=, $6, $pop0
	i32.store	$discard=, 0($pop3), $pop1
	i32.const	$1=, b
	i32.add 	$push4=, $1, $4
	i32.add 	$push5=, $pop4, $2
	i32.store	$3=, 0($pop5), $6
	i32.const	$2=, 1
	i32.add 	$6=, $3, $2
	i32.const	$3=, 4
	i32.add 	$4=, $4, $3
	br_if   	$4, 0           # 0: up to label24
# BB#2:                                 # %for.end
	end_loop                        # label25:
	i32.const	$10=, 0
	i32.const	$push6=, -2147483648
	i32.store	$discard=, a($10), $pop6
	i32.const	$push7=, -2147483647
	i32.store	$discard=, a+4($10), $pop7
	i32.const	$push8=, 2147483647
	i32.store	$discard=, a+16380($10), $pop8
	i32.const	$push9=, -1
	i32.store	$discard=, b+16380($10), $pop9
	call    	f1@FUNCTION
	call    	f2@FUNCTION
	copy_local	$8=, $10
.LBB12_3:                               # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label27:
	i32.const	$4=, c
	i32.const	$5=, 3
	i32.add 	$push10=, $4, $10
	i32.load	$push11=, 0($pop10)
	i32.add 	$push12=, $0, $10
	i32.load	$push13=, 0($pop12)
	i32.div_s	$push14=, $pop13, $5
	i32.ne  	$push15=, $pop11, $pop14
	br_if   	$pop15, 2       # 2: down to label26
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB12_3 Depth=1
	i32.const	$6=, d
	i32.add 	$push16=, $6, $10
	i32.load	$push17=, 0($pop16)
	i32.add 	$push18=, $1, $10
	i32.load	$push19=, 0($pop18)
	i32.div_u	$push20=, $pop19, $5
	i32.ne  	$push21=, $pop17, $pop20
	br_if   	$pop21, 2       # 2: down to label26
# BB#5:                                 # %for.cond2
                                        #   in Loop: Header=BB12_3 Depth=1
	i32.add 	$8=, $8, $2
	i32.add 	$10=, $10, $3
	i32.const	$7=, 4095
	i32.le_s	$push22=, $8, $7
	br_if   	$pop22, 0       # 0: up to label27
# BB#6:                                 # %for.end14
	end_loop                        # label28:
	call    	f3@FUNCTION
	call    	f4@FUNCTION
	i32.const	$10=, 0
	copy_local	$9=, $10
.LBB12_7:                               # %for.body17
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label30:
	i32.const	$8=, 18
	i32.add 	$push23=, $4, $10
	i32.load	$push24=, 0($pop23)
	i32.add 	$push25=, $0, $10
	i32.load	$push26=, 0($pop25)
	i32.div_s	$push27=, $pop26, $8
	i32.ne  	$push28=, $pop24, $pop27
	br_if   	$pop28, 2       # 2: down to label29
# BB#8:                                 # %lor.lhs.false22
                                        #   in Loop: Header=BB12_7 Depth=1
	i32.add 	$push29=, $6, $10
	i32.load	$push30=, 0($pop29)
	i32.add 	$push31=, $1, $10
	i32.load	$push32=, 0($pop31)
	i32.div_u	$push33=, $pop32, $8
	i32.ne  	$push34=, $pop30, $pop33
	br_if   	$pop34, 2       # 2: down to label29
# BB#9:                                 # %for.cond15
                                        #   in Loop: Header=BB12_7 Depth=1
	i32.add 	$9=, $9, $2
	i32.add 	$10=, $10, $3
	i32.le_s	$push35=, $9, $7
	br_if   	$pop35, 0       # 0: up to label30
# BB#10:                                # %for.end31
	end_loop                        # label31:
	call    	f5@FUNCTION
	call    	f6@FUNCTION
	i32.const	$10=, 0
	copy_local	$11=, $10
.LBB12_11:                              # %for.body34
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label33:
	i32.const	$9=, 19
	i32.add 	$push36=, $4, $10
	i32.load	$push37=, 0($pop36)
	i32.add 	$push38=, $0, $10
	i32.load	$push39=, 0($pop38)
	i32.div_s	$push40=, $pop39, $9
	i32.ne  	$push41=, $pop37, $pop40
	br_if   	$pop41, 2       # 2: down to label32
# BB#12:                                # %lor.lhs.false39
                                        #   in Loop: Header=BB12_11 Depth=1
	i32.add 	$push42=, $6, $10
	i32.load	$push43=, 0($pop42)
	i32.add 	$push44=, $1, $10
	i32.load	$push45=, 0($pop44)
	i32.div_u	$push46=, $pop45, $9
	i32.ne  	$push47=, $pop43, $pop46
	br_if   	$pop47, 2       # 2: down to label32
# BB#13:                                # %for.cond32
                                        #   in Loop: Header=BB12_11 Depth=1
	i32.add 	$11=, $11, $2
	i32.add 	$10=, $10, $3
	i32.le_s	$push48=, $11, $7
	br_if   	$pop48, 0       # 0: up to label33
# BB#14:                                # %for.end48
	end_loop                        # label34:
	call    	f7@FUNCTION
	call    	f8@FUNCTION
	i32.const	$10=, 0
	copy_local	$11=, $10
.LBB12_15:                              # %for.body51
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label36:
	i32.add 	$push49=, $4, $10
	i32.load	$push50=, 0($pop49)
	i32.add 	$push51=, $0, $10
	i32.load	$push52=, 0($pop51)
	i32.div_s	$push53=, $pop52, $5
	i32.ne  	$push54=, $pop50, $pop53
	br_if   	$pop54, 2       # 2: down to label35
# BB#16:                                # %lor.lhs.false56
                                        #   in Loop: Header=BB12_15 Depth=1
	i32.add 	$push55=, $6, $10
	i32.load	$push56=, 0($pop55)
	i32.add 	$push57=, $1, $10
	i32.load	$push58=, 0($pop57)
	i32.div_u	$push59=, $pop58, $5
	i32.ne  	$push60=, $pop56, $pop59
	br_if   	$pop60, 2       # 2: down to label35
# BB#17:                                # %for.cond49
                                        #   in Loop: Header=BB12_15 Depth=1
	i32.add 	$11=, $11, $2
	i32.add 	$10=, $10, $3
	i32.le_s	$push61=, $11, $7
	br_if   	$pop61, 0       # 0: up to label36
# BB#18:                                # %for.end65
	end_loop                        # label37:
	call    	f9@FUNCTION
	call    	f10@FUNCTION
	i32.const	$10=, 0
	copy_local	$5=, $10
.LBB12_19:                              # %for.body68
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label39:
	i32.add 	$push62=, $4, $10
	i32.load	$push63=, 0($pop62)
	i32.add 	$push64=, $0, $10
	i32.load	$push65=, 0($pop64)
	i32.div_s	$push66=, $pop65, $8
	i32.ne  	$push67=, $pop63, $pop66
	br_if   	$pop67, 2       # 2: down to label38
# BB#20:                                # %lor.lhs.false73
                                        #   in Loop: Header=BB12_19 Depth=1
	i32.add 	$push68=, $6, $10
	i32.load	$push69=, 0($pop68)
	i32.add 	$push70=, $1, $10
	i32.load	$push71=, 0($pop70)
	i32.div_u	$push72=, $pop71, $8
	i32.ne  	$push73=, $pop69, $pop72
	br_if   	$pop73, 2       # 2: down to label38
# BB#21:                                # %for.cond66
                                        #   in Loop: Header=BB12_19 Depth=1
	i32.add 	$5=, $5, $2
	i32.add 	$10=, $10, $3
	i32.le_s	$push74=, $5, $7
	br_if   	$pop74, 0       # 0: up to label39
# BB#22:                                # %for.end82
	end_loop                        # label40:
	call    	f11@FUNCTION
	call    	f12@FUNCTION
	i32.const	$10=, 0
	copy_local	$5=, $10
.LBB12_23:                              # %for.body85
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label42:
	i32.add 	$push75=, $4, $10
	i32.load	$push76=, 0($pop75)
	i32.add 	$push77=, $0, $10
	i32.load	$push78=, 0($pop77)
	i32.div_s	$push79=, $pop78, $9
	i32.ne  	$push80=, $pop76, $pop79
	br_if   	$pop80, 2       # 2: down to label41
# BB#24:                                # %lor.lhs.false90
                                        #   in Loop: Header=BB12_23 Depth=1
	i32.add 	$push81=, $6, $10
	i32.load	$push82=, 0($pop81)
	i32.add 	$push83=, $1, $10
	i32.load	$push84=, 0($pop83)
	i32.div_u	$push85=, $pop84, $9
	i32.ne  	$push86=, $pop82, $pop85
	br_if   	$pop86, 2       # 2: down to label41
# BB#25:                                # %for.cond83
                                        #   in Loop: Header=BB12_23 Depth=1
	i32.add 	$5=, $5, $2
	i32.add 	$10=, $10, $3
	i32.le_s	$push87=, $5, $7
	br_if   	$pop87, 0       # 0: up to label42
# BB#26:                                # %for.end99
	end_loop                        # label43:
	i32.const	$push88=, 0
	return  	$pop88
.LBB12_27:                              # %if.then95
	end_block                       # label41:
	call    	abort@FUNCTION
	unreachable
.LBB12_28:                              # %if.then78
	end_block                       # label38:
	call    	abort@FUNCTION
	unreachable
.LBB12_29:                              # %if.then61
	end_block                       # label35:
	call    	abort@FUNCTION
	unreachable
.LBB12_30:                              # %if.then44
	end_block                       # label32:
	call    	abort@FUNCTION
	unreachable
.LBB12_31:                              # %if.then27
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB12_32:                              # %if.then
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end12:
	.size	main, .Lfunc_end12-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	4
a:
	.skip	16384
	.size	a, 16384

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.align	4
c:
	.skip	16384
	.size	c, 16384

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	4
b:
	.skip	16384
	.size	b, 16384

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.align	4
d:
	.skip	16384
	.size	d, 16384


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
