	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/stdarg-3.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$drop=, bar_arg($pop0), $0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push9=, $pop5, $pop6
	tee_local	$push8=, $3=, $pop9
	i32.store	$drop=, 12($pop8), $1
	block
	i32.const	$push7=, 1
	i32.lt_s	$push1=, $0, $pop7
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push10=, 1
	i32.add 	$1=, $0, $pop10
	i32.load	$0=, 12($3)
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push16=, 4
	i32.add 	$push0=, $0, $pop16
	i32.store	$2=, 12($3), $pop0
	i32.const	$push15=, 0
	i32.load	$push2=, 0($0)
	i32.store	$drop=, x($pop15), $pop2
	copy_local	$0=, $2
	i32.const	$push14=, -1
	i32.add 	$push13=, $1, $pop14
	tee_local	$push12=, $1=, $pop13
	i32.const	$push11=, 1
	i32.gt_s	$push3=, $pop12, $pop11
	br_if   	0, $pop3        # 0: up to label1
.LBB1_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push9=, $pop5, $pop6
	tee_local	$push8=, $2=, $pop9
	i32.store	$drop=, 12($pop8), $1
	block
	i32.const	$push7=, 1
	i32.lt_s	$push0=, $0, $pop7
	br_if   	0, $pop0        # 0: down to label3
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push10=, 1
	i32.add 	$1=, $0, $pop10
	i32.load	$0=, 12($2)
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push20=, 0
	i32.const	$push19=, 7
	i32.add 	$push1=, $0, $pop19
	i32.const	$push18=, -8
	i32.and 	$push17=, $pop1, $pop18
	tee_local	$push16=, $0=, $pop17
	i64.load	$push2=, 0($pop16)
	i64.store	$drop=, d($pop20), $pop2
	i32.const	$push15=, 8
	i32.add 	$0=, $0, $pop15
	i32.const	$push14=, -1
	i32.add 	$push13=, $1, $pop14
	tee_local	$push12=, $1=, $pop13
	i32.const	$push11=, 1
	i32.gt_s	$push3=, $pop12, $pop11
	br_if   	0, $pop3        # 0: up to label4
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label5:
	i32.store	$drop=, 12($2), $0
.LBB2_4:                                # %while.end
	end_block                       # label3:
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	f2, .Lfunc_end2-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$4=, $pop6, $pop7
	block
	i32.const	$push8=, 1
	i32.lt_s	$push1=, $0, $pop8
	br_if   	0, $pop1        # 0: down to label6
# BB#1:                                 # %while.body.preheader
	i32.const	$push9=, 1
	i32.add 	$0=, $0, $pop9
	i32.const	$push2=, 4
	i32.add 	$3=, $1, $pop2
.LBB3_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.store	$2=, 12($4), $1
	i32.store	$drop=, 12($4), $3
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i32.load	$push3=, 0($2)
	i32.store	$push0=, bar_arg($pop14), $pop3
	i32.store	$drop=, x($pop15), $pop0
	i32.const	$push13=, -1
	i32.add 	$push12=, $0, $pop13
	tee_local	$push11=, $0=, $pop12
	i32.const	$push10=, 1
	i32.gt_s	$push4=, $pop11, $pop10
	br_if   	0, $pop4        # 0: up to label7
.LBB3_3:                                # %while.end
	end_loop                        # label8:
	end_block                       # label6:
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	f3, .Lfunc_end3-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 16
	i32.sub 	$4=, $pop11, $pop12
	block
	i32.const	$push13=, 1
	i32.lt_s	$push0=, $0, $pop13
	br_if   	0, $pop0        # 0: down to label9
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push16=, 1
	i32.add 	$0=, $0, $pop16
	i32.const	$push1=, 7
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, -8
	i32.and 	$push15=, $pop2, $pop3
	tee_local	$push14=, $2=, $pop15
	i32.const	$push8=, 8
	i32.add 	$3=, $pop14, $pop8
.LBB4_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.store	$drop=, 12($4), $1
	i32.const	$push24=, 0
	i64.load	$push4=, 0($2)
	i64.store	$drop=, d($pop24), $pop4
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	f64.load	$push5=, d($pop22)
	f64.const	$push21=, 0x1p2
	f64.add 	$push6=, $pop5, $pop21
	i32.trunc_s/f64	$push7=, $pop6
	i32.store	$drop=, bar_arg($pop23), $pop7
	i32.store	$drop=, 12($4), $3
	i32.const	$push20=, -1
	i32.add 	$push19=, $0, $pop20
	tee_local	$push18=, $0=, $pop19
	i32.const	$push17=, 1
	i32.gt_s	$push9=, $pop18, $pop17
	br_if   	0, $pop9        # 0: up to label10
.LBB4_3:                                # %while.end
	end_loop                        # label11:
	end_block                       # label9:
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	f4, .Lfunc_end4-f4

	.section	.text.f5,"ax",@progbits
	.hidden	f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 16
	i32.sub 	$push15=, $pop11, $pop12
	tee_local	$push14=, $2=, $pop15
	i32.store	$drop=, 12($pop14), $1
	block
	i32.const	$push13=, 1
	i32.lt_s	$push0=, $0, $pop13
	br_if   	0, $pop0        # 0: down to label12
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push16=, 1
	i32.add 	$1=, $0, $pop16
	i32.load	$0=, 12($2)
.LBB5_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label13:
	i32.const	$push32=, 0
	i32.const	$push31=, 7
	i32.add 	$push1=, $0, $pop31
	i32.const	$push30=, -8
	i32.and 	$push29=, $pop1, $pop30
	tee_local	$push28=, $0=, $pop29
	i64.load	$push2=, 0($pop28)
	i64.store	$drop=, s1($pop32), $pop2
	i32.const	$push27=, 0
	i32.const	$push26=, 24
	i32.add 	$push3=, $0, $pop26
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, s1+24($pop27), $pop4
	i32.const	$push25=, 0
	i32.const	$push24=, 16
	i32.add 	$push5=, $0, $pop24
	i64.load	$push6=, 0($pop5)
	i64.store	$drop=, s1+16($pop25), $pop6
	i32.const	$push23=, 0
	i32.const	$push22=, 8
	i32.add 	$push7=, $0, $pop22
	i64.load	$push8=, 0($pop7)
	i64.store	$drop=, s1+8($pop23), $pop8
	i32.const	$push21=, 32
	i32.add 	$0=, $0, $pop21
	i32.const	$push20=, -1
	i32.add 	$push19=, $1, $pop20
	tee_local	$push18=, $1=, $pop19
	i32.const	$push17=, 1
	i32.gt_s	$push9=, $pop18, $pop17
	br_if   	0, $pop9        # 0: up to label13
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label14:
	i32.store	$drop=, 12($2), $0
.LBB5_4:                                # %while.end
	end_block                       # label12:
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	f5, .Lfunc_end5-f5

	.section	.text.f6,"ax",@progbits
	.hidden	f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push11=, $pop7, $pop8
	tee_local	$push10=, $2=, $pop11
	i32.store	$drop=, 12($pop10), $1
	block
	i32.const	$push9=, 1
	i32.lt_s	$push0=, $0, $pop9
	br_if   	0, $pop0        # 0: down to label15
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push12=, 1
	i32.add 	$1=, $0, $pop12
	i32.load	$0=, 12($2)
.LBB6_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	i32.const	$push24=, 0
	i32.const	$push23=, 7
	i32.add 	$push1=, $0, $pop23
	i32.const	$push22=, -8
	i32.and 	$push21=, $pop1, $pop22
	tee_local	$push20=, $0=, $pop21
	i64.load	$push2=, 0($pop20)
	i64.store	$drop=, s2($pop24), $pop2
	i32.const	$push19=, 0
	i32.const	$push18=, 8
	i32.add 	$push3=, $0, $pop18
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, s2+8($pop19), $pop4
	i32.const	$push17=, 16
	i32.add 	$0=, $0, $pop17
	i32.const	$push16=, -1
	i32.add 	$push15=, $1, $pop16
	tee_local	$push14=, $1=, $pop15
	i32.const	$push13=, 1
	i32.gt_s	$push5=, $pop14, $pop13
	br_if   	0, $pop5        # 0: up to label16
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label17:
	i32.store	$drop=, 12($2), $0
.LBB6_4:                                # %while.end
	end_block                       # label15:
                                        # fallthrough-return
	.endfunc
.Lfunc_end6:
	.size	f6, .Lfunc_end6-f6

	.section	.text.f7,"ax",@progbits
	.hidden	f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push21=, 0
	i32.load	$push22=, __stack_pointer($pop21)
	i32.const	$push23=, 16
	i32.sub 	$10=, $pop22, $pop23
	block
	i32.const	$push24=, 1
	i32.lt_s	$push0=, $0, $pop24
	br_if   	0, $pop0        # 0: down to label18
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push27=, 1
	i32.add 	$9=, $0, $pop27
	i32.const	$push1=, 7
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, -8
	i32.and 	$push26=, $pop2, $pop3
	tee_local	$push25=, $0=, $pop26
	i32.const	$push5=, 28
	i32.add 	$2=, $pop25, $pop5
	i32.const	$push7=, 24
	i32.add 	$3=, $0, $pop7
	i32.const	$push9=, 20
	i32.add 	$4=, $0, $pop9
	i32.const	$push11=, 16
	i32.add 	$5=, $0, $pop11
	i32.const	$push13=, 12
	i32.add 	$6=, $0, $pop13
	i32.const	$push15=, 8
	i32.add 	$7=, $0, $pop15
	i32.const	$push17=, 32
	i32.add 	$8=, $0, $pop17
.LBB7_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	i32.store	$drop=, 12($10), $1
	i32.const	$push41=, 0
	i32.load	$push4=, 4($0)
	i32.store	$drop=, s1+4($pop41), $pop4
	i32.const	$push40=, 0
	i32.load	$push6=, 0($2)
	i32.store	$drop=, s1+28($pop40), $pop6
	i32.const	$push39=, 0
	i32.load	$push8=, 0($3)
	i32.store	$drop=, s1+24($pop39), $pop8
	i32.const	$push38=, 0
	i32.load	$push10=, 0($4)
	i32.store	$drop=, s1+20($pop38), $pop10
	i32.const	$push37=, 0
	i32.load	$push12=, 0($5)
	i32.store	$drop=, s1+16($pop37), $pop12
	i32.const	$push36=, 0
	i32.load	$push14=, 0($6)
	i32.store	$drop=, s1+12($pop36), $pop14
	i32.const	$push35=, 0
	i32.load	$push16=, 0($7)
	i32.store	$drop=, s1+8($pop35), $pop16
	i32.store	$drop=, 12($10), $8
	i32.const	$push34=, 0
	i32.load	$push18=, 0($0)
	i32.store	$drop=, s1($pop34), $pop18
	i32.const	$push33=, 0
	i32.const	$push32=, 0
	i32.load	$push19=, s1($pop32)
	i32.store	$drop=, bar_arg($pop33), $pop19
	i32.const	$push31=, -1
	i32.add 	$push30=, $9, $pop31
	tee_local	$push29=, $9=, $pop30
	i32.const	$push28=, 1
	i32.gt_s	$push20=, $pop29, $pop28
	br_if   	0, $pop20       # 0: up to label19
.LBB7_3:                                # %while.end
	end_loop                        # label20:
	end_block                       # label18:
                                        # fallthrough-return
	.endfunc
.Lfunc_end7:
	.size	f7, .Lfunc_end7-f7

	.section	.text.f8,"ax",@progbits
	.hidden	f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 16
	i32.sub 	$6=, $pop15, $pop16
	block
	i32.const	$push17=, 1
	i32.lt_s	$push0=, $0, $pop17
	br_if   	0, $pop0        # 0: down to label21
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push20=, 1
	i32.add 	$5=, $0, $pop20
	i32.const	$push1=, 7
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, -8
	i32.and 	$push19=, $pop2, $pop3
	tee_local	$push18=, $0=, $pop19
	i32.const	$push6=, 12
	i32.add 	$2=, $pop18, $pop6
	i32.const	$push8=, 8
	i32.add 	$3=, $0, $pop8
	i32.const	$push10=, 20
	i32.add 	$4=, $0, $pop10
.LBB8_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label22:
	i32.store	$drop=, 12($6), $1
	i32.const	$push31=, 0
	i32.load	$push4=, 4($0)
	i32.store	$drop=, s2+4($pop31), $pop4
	i32.const	$push30=, 0
	i32.load	$push5=, 0($0)
	i32.store	$drop=, s2($pop30), $pop5
	i32.const	$push29=, 0
	i32.load	$push7=, 0($2)
	i32.store	$drop=, s2+12($pop29), $pop7
	i32.const	$push28=, 0
	i32.load	$push9=, 0($3)
	i32.store	$drop=, s2+8($pop28), $pop9
	i32.store	$drop=, 12($6), $4
	i32.const	$push27=, 0
	i32.load	$push11=, 16($0)
	i32.store	$drop=, y($pop27), $pop11
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.load	$push12=, s2+8($pop25)
	i32.store	$drop=, bar_arg($pop26), $pop12
	i32.const	$push24=, -1
	i32.add 	$push23=, $5, $pop24
	tee_local	$push22=, $5=, $pop23
	i32.const	$push21=, 1
	i32.gt_s	$push13=, $pop22, $pop21
	br_if   	0, $pop13       # 0: up to label22
.LBB8_3:                                # %while.end
	end_loop                        # label23:
	end_block                       # label21:
                                        # fallthrough-return
	.endfunc
.Lfunc_end8:
	.size	f8, .Lfunc_end8-f8

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push240=, 0
	i32.const	$push237=, 0
	i32.load	$push238=, __stack_pointer($pop237)
	i32.const	$push239=, 752
	i32.sub 	$push422=, $pop238, $pop239
	i32.store	$push427=, __stack_pointer($pop240), $pop422
	tee_local	$push426=, $2=, $pop427
	i32.const	$push244=, 624
	i32.add 	$push245=, $pop426, $pop244
	i32.const	$push425=, 24
	i32.add 	$push2=, $pop245, $pop425
	i64.const	$push3=, 55834574859
	i64.store	$drop=, 0($pop2), $pop3
	i32.const	$push246=, 624
	i32.add 	$push247=, $2, $pop246
	i32.const	$push424=, 16
	i32.add 	$push4=, $pop247, $pop424
	i64.const	$push5=, 38654705671
	i64.store	$drop=, 0($pop4), $pop5
	i64.const	$push6=, 21474836483
	i64.store	$drop=, 632($2), $pop6
	i64.const	$push7=, 8589934593
	i64.store	$drop=, 624($2), $pop7
	i32.const	$push8=, 7
	i32.const	$push248=, 624
	i32.add 	$push249=, $2, $pop248
	call    	f1@FUNCTION, $pop8, $pop249
	block
	i32.const	$push423=, 0
	i32.load	$push9=, x($pop423)
	i32.const	$push10=, 11
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label24
# BB#1:                                 # %if.end
	i32.const	$push12=, 608
	i32.add 	$push13=, $2, $pop12
	i64.const	$push14=, 4634204016564240384
	i64.store	$drop=, 0($pop13), $pop14
	i32.const	$push15=, 600
	i32.add 	$push16=, $2, $pop15
	i64.const	$push17=, 4629700416936869888
	i64.store	$drop=, 0($pop16), $pop17
	i32.const	$push18=, 592
	i32.add 	$push19=, $2, $pop18
	i64.const	$push20=, 4625196817309499392
	i64.store	$drop=, 0($pop19), $pop20
	i32.const	$push250=, 560
	i32.add 	$push251=, $2, $pop250
	i32.const	$push430=, 24
	i32.add 	$push21=, $pop251, $pop430
	i64.const	$push22=, 4620693217682128896
	i64.store	$drop=, 0($pop21), $pop22
	i32.const	$push252=, 560
	i32.add 	$push253=, $2, $pop252
	i32.const	$push429=, 16
	i32.add 	$push23=, $pop253, $pop429
	i64.const	$push24=, 4616189618054758400
	i64.store	$drop=, 0($pop23), $pop24
	i64.const	$push25=, 4611686018427387904
	i64.store	$drop=, 568($2), $pop25
	i64.const	$push26=, 4607182418800017408
	i64.store	$drop=, 560($2), $pop26
	i32.const	$push27=, 6
	i32.const	$push254=, 560
	i32.add 	$push255=, $2, $pop254
	call    	f2@FUNCTION, $pop27, $pop255
	i32.const	$push428=, 0
	f64.load	$push28=, d($pop428)
	f64.const	$push29=, 0x1p5
	f64.ne  	$push30=, $pop28, $pop29
	br_if   	0, $pop30       # 0: down to label24
# BB#2:                                 # %if.end3
	i64.const	$push32=, 12884901889
	i64.store	$drop=, 544($2), $pop32
	i32.const	$push33=, 2
	i32.const	$push256=, 544
	i32.add 	$push257=, $2, $pop256
	call    	f3@FUNCTION, $pop33, $pop257
	i32.const	$push432=, 0
	i32.load	$push34=, bar_arg($pop432)
	i32.const	$push431=, 1
	i32.ne  	$push35=, $pop34, $pop431
	br_if   	0, $pop35       # 0: down to label24
# BB#3:                                 # %if.end3
	i32.const	$push434=, 0
	i32.load	$push31=, x($pop434)
	i32.const	$push433=, 1
	i32.ne  	$push36=, $pop31, $pop433
	br_if   	0, $pop36       # 0: down to label24
# BB#4:                                 # %if.end7
	i64.const	$push38=, 4626041242239631360
	i64.store	$drop=, 536($2), $pop38
	i64.const	$push39=, 4625478292286210048
	i64.store	$drop=, 528($2), $pop39
	i32.const	$push40=, 2
	i32.const	$push258=, 528
	i32.add 	$push259=, $2, $pop258
	call    	f4@FUNCTION, $pop40, $pop259
	i32.const	$push435=, 0
	i32.load	$push41=, bar_arg($pop435)
	i32.const	$push42=, 21
	i32.ne  	$push43=, $pop41, $pop42
	br_if   	0, $pop43       # 0: down to label24
# BB#5:                                 # %if.end7
	i32.const	$push436=, 0
	f64.load	$push37=, d($pop436)
	f64.const	$push44=, 0x1.1p4
	f64.ne  	$push45=, $pop37, $pop44
	br_if   	0, $pop45       # 0: down to label24
# BB#6:                                 # %if.end12
	i32.const	$push260=, 688
	i32.add 	$push261=, $2, $pop260
	i32.const	$push50=, 16
	i32.add 	$push450=, $pop261, $pop50
	tee_local	$push449=, $3=, $pop450
	i32.const	$push49=, 251
	i32.store	$push0=, 736($2), $pop49
	i32.store	$drop=, 0($pop449), $pop0
	i32.const	$push262=, 688
	i32.add 	$push263=, $2, $pop262
	i32.const	$push52=, 8
	i32.add 	$push448=, $pop263, $pop52
	tee_local	$push447=, $4=, $pop448
	i64.const	$push51=, 4624633867356078080
	i64.store	$push1=, 728($2), $pop51
	i64.store	$drop=, 0($pop447), $pop1
	i32.const	$push264=, 688
	i32.add 	$push265=, $2, $pop264
	i32.const	$push53=, 20
	i32.add 	$push54=, $pop265, $pop53
	i32.const	$push266=, 720
	i32.add 	$push267=, $2, $pop266
	i32.const	$push446=, 20
	i32.add 	$push55=, $pop267, $pop446
	i32.load	$push56=, 0($pop55)
	i32.store	$drop=, 0($pop54), $pop56
	i64.const	$push57=, 4640924231633207296
	i64.store	$drop=, 744($2), $pop57
	i32.const	$push58=, 131
	i32.store	$0=, 720($2), $pop58
	i64.load	$push59=, 720($2)
	i64.store	$drop=, 688($2), $pop59
	i32.const	$push60=, 254
	i32.store	$1=, 0($3), $pop60
	i32.const	$push268=, 496
	i32.add 	$push269=, $2, $pop268
	i32.const	$push445=, 16
	i32.add 	$push61=, $pop269, $pop445
	i64.load	$push62=, 736($2)
	i64.store	$drop=, 0($pop61), $pop62
	i64.const	$push63=, 4640466834796052480
	i64.store	$drop=, 712($2), $pop63
	i32.const	$push270=, 496
	i32.add 	$push271=, $2, $pop270
	i32.const	$push64=, 24
	i32.add 	$push65=, $pop271, $pop64
	i64.load	$push66=, 744($2)
	i64.store	$drop=, 0($pop65), $pop66
	i32.const	$push272=, 496
	i32.add 	$push273=, $2, $pop272
	i32.const	$push444=, 8
	i32.add 	$push67=, $pop273, $pop444
	i64.load	$push68=, 728($2)
	i64.store	$drop=, 0($pop67), $pop68
	i64.load	$push69=, 720($2)
	i64.store	$drop=, 496($2), $pop69
	i32.const	$push274=, 464
	i32.add 	$push275=, $2, $pop274
	i32.const	$push443=, 24
	i32.add 	$push70=, $pop275, $pop443
	i64.load	$push71=, 712($2)
	i64.store	$drop=, 0($pop70), $pop71
	i32.const	$push276=, 464
	i32.add 	$push277=, $2, $pop276
	i32.const	$push442=, 16
	i32.add 	$push72=, $pop277, $pop442
	i64.load	$push73=, 0($3)
	i64.store	$drop=, 0($pop72), $pop73
	i32.const	$push278=, 464
	i32.add 	$push279=, $2, $pop278
	i32.const	$push441=, 8
	i32.add 	$push74=, $pop279, $pop441
	i64.load	$push75=, 0($4)
	i64.store	$drop=, 0($pop74), $pop75
	i64.load	$push76=, 688($2)
	i64.store	$drop=, 464($2), $pop76
	i32.const	$push280=, 432
	i32.add 	$push281=, $2, $pop280
	i32.const	$push440=, 24
	i32.add 	$push77=, $pop281, $pop440
	i64.load	$push78=, 744($2)
	i64.store	$drop=, 0($pop77), $pop78
	i32.const	$push282=, 432
	i32.add 	$push283=, $2, $pop282
	i32.const	$push439=, 16
	i32.add 	$push79=, $pop283, $pop439
	i64.load	$push80=, 736($2)
	i64.store	$drop=, 0($pop79), $pop80
	i32.const	$push284=, 432
	i32.add 	$push285=, $2, $pop284
	i32.const	$push438=, 8
	i32.add 	$push81=, $pop285, $pop438
	i64.load	$push82=, 728($2)
	i64.store	$drop=, 0($pop81), $pop82
	i64.load	$push83=, 720($2)
	i64.store	$drop=, 432($2), $pop83
	i32.const	$push286=, 432
	i32.add 	$push287=, $2, $pop286
	i32.store	$drop=, 424($2), $pop287
	i32.const	$push288=, 464
	i32.add 	$push289=, $2, $pop288
	i32.store	$drop=, 420($2), $pop289
	i32.const	$push290=, 496
	i32.add 	$push291=, $2, $pop290
	i32.store	$drop=, 416($2), $pop291
	i32.const	$push84=, 2
	i32.const	$push292=, 416
	i32.add 	$push293=, $2, $pop292
	call    	f5@FUNCTION, $pop84, $pop293
	i32.const	$push437=, 0
	i32.load	$push85=, s1($pop437)
	i32.ne  	$push86=, $0, $pop85
	br_if   	0, $pop86       # 0: down to label24
# BB#7:                                 # %if.end12
	i32.const	$push451=, 0
	i32.load	$push46=, s1+16($pop451)
	i32.ne  	$push87=, $pop46, $1
	br_if   	0, $pop87       # 0: down to label24
# BB#8:                                 # %if.end12
	i32.const	$push452=, 0
	f64.load	$push47=, s1+8($pop452)
	f64.const	$push88=, 0x1.ep3
	f64.ne  	$push89=, $pop47, $pop88
	br_if   	0, $pop89       # 0: down to label24
# BB#9:                                 # %if.end12
	i32.const	$push453=, 0
	f64.load	$push48=, s1+24($pop453)
	f64.const	$push90=, 0x1.64p7
	f64.ne  	$push91=, $pop48, $pop90
	br_if   	0, $pop91       # 0: down to label24
# BB#10:                                # %if.end23
	i32.const	$push294=, 384
	i32.add 	$push295=, $2, $pop294
	i32.const	$push95=, 24
	i32.add 	$push96=, $pop295, $pop95
	i32.const	$push296=, 720
	i32.add 	$push297=, $2, $pop296
	i32.const	$push472=, 24
	i32.add 	$push471=, $pop297, $pop472
	tee_local	$push470=, $3=, $pop471
	i64.load	$push97=, 0($pop470)
	i64.store	$drop=, 0($pop96), $pop97
	i32.const	$push298=, 384
	i32.add 	$push299=, $2, $pop298
	i32.const	$push98=, 16
	i32.add 	$push99=, $pop299, $pop98
	i32.const	$push300=, 720
	i32.add 	$push301=, $2, $pop300
	i32.const	$push469=, 16
	i32.add 	$push468=, $pop301, $pop469
	tee_local	$push467=, $4=, $pop468
	i64.load	$push100=, 0($pop467)
	i64.store	$drop=, 0($pop99), $pop100
	i32.const	$push302=, 384
	i32.add 	$push303=, $2, $pop302
	i32.const	$push101=, 8
	i32.add 	$push102=, $pop303, $pop101
	i32.const	$push304=, 720
	i32.add 	$push305=, $2, $pop304
	i32.const	$push466=, 8
	i32.add 	$push465=, $pop305, $pop466
	tee_local	$push464=, $0=, $pop465
	i64.load	$push103=, 0($pop464)
	i64.store	$drop=, 0($pop102), $pop103
	i64.load	$push104=, 720($2)
	i64.store	$drop=, 384($2), $pop104
	i32.const	$push306=, 352
	i32.add 	$push307=, $2, $pop306
	i32.const	$push463=, 24
	i32.add 	$push105=, $pop307, $pop463
	i32.const	$push308=, 688
	i32.add 	$push309=, $2, $pop308
	i32.const	$push462=, 24
	i32.add 	$push106=, $pop309, $pop462
	i64.load	$push107=, 0($pop106)
	i64.store	$drop=, 0($pop105), $pop107
	i32.const	$push310=, 352
	i32.add 	$push311=, $2, $pop310
	i32.const	$push461=, 16
	i32.add 	$push108=, $pop311, $pop461
	i32.const	$push312=, 688
	i32.add 	$push313=, $2, $pop312
	i32.const	$push460=, 16
	i32.add 	$push109=, $pop313, $pop460
	i64.load	$push110=, 0($pop109)
	i64.store	$drop=, 0($pop108), $pop110
	i32.const	$push314=, 352
	i32.add 	$push315=, $2, $pop314
	i32.const	$push459=, 8
	i32.add 	$push111=, $pop315, $pop459
	i32.const	$push316=, 688
	i32.add 	$push317=, $2, $pop316
	i32.const	$push458=, 8
	i32.add 	$push112=, $pop317, $pop458
	i64.load	$push113=, 0($pop112)
	i64.store	$drop=, 0($pop111), $pop113
	i64.load	$push114=, 688($2)
	i64.store	$drop=, 352($2), $pop114
	i32.const	$push318=, 320
	i32.add 	$push319=, $2, $pop318
	i32.const	$push457=, 24
	i32.add 	$push115=, $pop319, $pop457
	i64.load	$push116=, 0($3)
	i64.store	$drop=, 0($pop115), $pop116
	i32.const	$push320=, 320
	i32.add 	$push321=, $2, $pop320
	i32.const	$push456=, 16
	i32.add 	$push117=, $pop321, $pop456
	i64.load	$push118=, 0($4)
	i64.store	$drop=, 0($pop117), $pop118
	i32.const	$push322=, 320
	i32.add 	$push323=, $2, $pop322
	i32.const	$push455=, 8
	i32.add 	$push119=, $pop323, $pop455
	i64.load	$push120=, 0($0)
	i64.store	$drop=, 0($pop119), $pop120
	i64.load	$push121=, 720($2)
	i64.store	$drop=, 320($2), $pop121
	i32.const	$push324=, 320
	i32.add 	$push325=, $2, $pop324
	i32.store	$drop=, 312($2), $pop325
	i32.const	$push326=, 352
	i32.add 	$push327=, $2, $pop326
	i32.store	$drop=, 308($2), $pop327
	i32.const	$push328=, 384
	i32.add 	$push329=, $2, $pop328
	i32.store	$drop=, 304($2), $pop329
	i32.const	$push122=, 3
	i32.const	$push330=, 304
	i32.add 	$push331=, $2, $pop330
	call    	f5@FUNCTION, $pop122, $pop331
	i32.const	$push454=, 0
	i32.load	$push123=, s1($pop454)
	i32.const	$push124=, 131
	i32.ne  	$push125=, $pop123, $pop124
	br_if   	0, $pop125      # 0: down to label24
# BB#11:                                # %if.end23
	i32.const	$push473=, 0
	i32.load	$push92=, s1+16($pop473)
	i32.const	$push126=, 251
	i32.ne  	$push127=, $pop92, $pop126
	br_if   	0, $pop127      # 0: down to label24
# BB#12:                                # %if.end23
	i32.const	$push474=, 0
	f64.load	$push93=, s1+8($pop474)
	f64.const	$push128=, 0x1.ep3
	f64.ne  	$push129=, $pop93, $pop128
	br_if   	0, $pop129      # 0: down to label24
# BB#13:                                # %if.end23
	i32.const	$push475=, 0
	f64.load	$push94=, s1+24($pop475)
	f64.const	$push130=, 0x1.7ep7
	f64.ne  	$push131=, $pop94, $pop130
	br_if   	0, $pop131      # 0: down to label24
# BB#14:                                # %if.end32
	i32.const	$push332=, 288
	i32.add 	$push333=, $2, $pop332
	i32.const	$push133=, 12
	i32.add 	$push134=, $pop333, $pop133
	i32.const	$push334=, 672
	i32.add 	$push335=, $2, $pop334
	i32.const	$push479=, 12
	i32.add 	$push135=, $pop335, $pop479
	i32.load	$push136=, 0($pop135)
	i32.store	$drop=, 0($pop134), $pop136
	i32.const	$push137=, 138
	i32.store	$drop=, 680($2), $pop137
	i32.const	$push138=, 257
	i32.store	$3=, 664($2), $pop138
	i32.const	$push336=, 288
	i32.add 	$push337=, $2, $pop336
	i32.const	$push139=, 8
	i32.add 	$push140=, $pop337, $pop139
	i32.load	$push141=, 680($2)
	i32.store	$drop=, 0($pop140), $pop141
	i64.const	$push142=, 4625196817309499392
	i64.store	$drop=, 672($2), $pop142
	i64.const	$push143=, 4640396466051874816
	i64.store	$drop=, 656($2), $pop143
	i32.load	$push144=, 676($2)
	i32.store	$drop=, 292($2), $pop144
	i32.load	$push145=, 672($2)
	i32.store	$drop=, 288($2), $pop145
	i32.const	$push338=, 272
	i32.add 	$push339=, $2, $pop338
	i32.const	$push478=, 8
	i32.add 	$push146=, $pop339, $pop478
	i64.load	$push147=, 664($2)
	i64.store	$drop=, 0($pop146), $pop147
	i64.load	$push148=, 656($2)
	i64.store	$drop=, 272($2), $pop148
	i32.const	$push340=, 256
	i32.add 	$push341=, $2, $pop340
	i32.const	$push477=, 8
	i32.add 	$push149=, $pop341, $pop477
	i64.load	$push150=, 680($2)
	i64.store	$drop=, 0($pop149), $pop150
	i64.load	$push151=, 672($2)
	i64.store	$drop=, 256($2), $pop151
	i32.const	$push342=, 256
	i32.add 	$push343=, $2, $pop342
	i32.store	$drop=, 248($2), $pop343
	i32.const	$push344=, 272
	i32.add 	$push345=, $2, $pop344
	i32.store	$drop=, 244($2), $pop345
	i32.const	$push346=, 288
	i32.add 	$push347=, $2, $pop346
	i32.store	$drop=, 240($2), $pop347
	i32.const	$push152=, 2
	i32.const	$push348=, 240
	i32.add 	$push349=, $2, $pop348
	call    	f6@FUNCTION, $pop152, $pop349
	i32.const	$push476=, 0
	i32.load	$push153=, s2+8($pop476)
	i32.ne  	$push154=, $3, $pop153
	br_if   	0, $pop154      # 0: down to label24
# BB#15:                                # %if.end32
	i32.const	$push480=, 0
	f64.load	$push132=, s2($pop480)
	f64.const	$push155=, 0x1.6p7
	f64.ne  	$push156=, $pop132, $pop155
	br_if   	0, $pop156      # 0: down to label24
# BB#16:                                # %if.end41
	i32.const	$push350=, 224
	i32.add 	$push351=, $2, $pop350
	i32.const	$push158=, 8
	i32.add 	$push159=, $pop351, $pop158
	i32.const	$push352=, 672
	i32.add 	$push353=, $2, $pop352
	i32.const	$push487=, 8
	i32.add 	$push486=, $pop353, $pop487
	tee_local	$push485=, $3=, $pop486
	i64.load	$push160=, 0($pop485)
	i64.store	$drop=, 0($pop159), $pop160
	i32.const	$push354=, 208
	i32.add 	$push355=, $2, $pop354
	i32.const	$push484=, 8
	i32.add 	$push161=, $pop355, $pop484
	i32.const	$push356=, 656
	i32.add 	$push357=, $2, $pop356
	i32.const	$push483=, 8
	i32.add 	$push162=, $pop357, $pop483
	i64.load	$push163=, 0($pop162)
	i64.store	$drop=, 0($pop161), $pop163
	i64.load	$push164=, 672($2)
	i64.store	$drop=, 224($2), $pop164
	i64.load	$push165=, 656($2)
	i64.store	$drop=, 208($2), $pop165
	i32.const	$push358=, 192
	i32.add 	$push359=, $2, $pop358
	i32.const	$push482=, 8
	i32.add 	$push166=, $pop359, $pop482
	i64.load	$push167=, 0($3)
	i64.store	$drop=, 0($pop166), $pop167
	i64.load	$push168=, 672($2)
	i64.store	$drop=, 192($2), $pop168
	i32.const	$push360=, 192
	i32.add 	$push361=, $2, $pop360
	i32.store	$drop=, 184($2), $pop361
	i32.const	$push362=, 208
	i32.add 	$push363=, $2, $pop362
	i32.store	$drop=, 180($2), $pop363
	i32.const	$push364=, 224
	i32.add 	$push365=, $2, $pop364
	i32.store	$drop=, 176($2), $pop365
	i32.const	$push169=, 3
	i32.const	$push366=, 176
	i32.add 	$push367=, $2, $pop366
	call    	f6@FUNCTION, $pop169, $pop367
	i32.const	$push481=, 0
	i32.load	$push170=, s2+8($pop481)
	i32.const	$push171=, 138
	i32.ne  	$push172=, $pop170, $pop171
	br_if   	0, $pop172      # 0: down to label24
# BB#17:                                # %if.end41
	i32.const	$push488=, 0
	f64.load	$push157=, s2($pop488)
	f64.const	$push173=, 0x1p4
	f64.ne  	$push174=, $pop157, $pop173
	br_if   	0, $pop174      # 0: down to label24
# BB#18:                                # %if.end46
	i32.const	$push368=, 144
	i32.add 	$push369=, $2, $pop368
	i32.const	$push178=, 24
	i32.add 	$push179=, $pop369, $pop178
	i32.const	$push370=, 688
	i32.add 	$push371=, $2, $pop370
	i32.const	$push507=, 24
	i32.add 	$push180=, $pop371, $pop507
	i64.load	$push181=, 0($pop180)
	i64.store	$drop=, 0($pop179), $pop181
	i32.const	$push372=, 144
	i32.add 	$push373=, $2, $pop372
	i32.const	$push182=, 16
	i32.add 	$push183=, $pop373, $pop182
	i32.const	$push374=, 688
	i32.add 	$push375=, $2, $pop374
	i32.const	$push506=, 16
	i32.add 	$push184=, $pop375, $pop506
	i64.load	$push185=, 0($pop184)
	i64.store	$drop=, 0($pop183), $pop185
	i32.const	$push376=, 144
	i32.add 	$push377=, $2, $pop376
	i32.const	$push186=, 8
	i32.add 	$push187=, $pop377, $pop186
	i32.const	$push378=, 688
	i32.add 	$push379=, $2, $pop378
	i32.const	$push505=, 8
	i32.add 	$push188=, $pop379, $pop505
	i64.load	$push189=, 0($pop188)
	i64.store	$drop=, 0($pop187), $pop189
	i64.load	$push190=, 688($2)
	i64.store	$drop=, 144($2), $pop190
	i32.const	$push380=, 112
	i32.add 	$push381=, $2, $pop380
	i32.const	$push504=, 24
	i32.add 	$push191=, $pop381, $pop504
	i32.const	$push382=, 720
	i32.add 	$push383=, $2, $pop382
	i32.const	$push503=, 24
	i32.add 	$push502=, $pop383, $pop503
	tee_local	$push501=, $3=, $pop502
	i64.load	$push192=, 0($pop501)
	i64.store	$drop=, 0($pop191), $pop192
	i32.const	$push384=, 112
	i32.add 	$push385=, $2, $pop384
	i32.const	$push500=, 16
	i32.add 	$push193=, $pop385, $pop500
	i32.const	$push386=, 720
	i32.add 	$push387=, $2, $pop386
	i32.const	$push499=, 16
	i32.add 	$push498=, $pop387, $pop499
	tee_local	$push497=, $4=, $pop498
	i64.load	$push194=, 0($pop497)
	i64.store	$drop=, 0($pop193), $pop194
	i32.const	$push388=, 112
	i32.add 	$push389=, $2, $pop388
	i32.const	$push496=, 8
	i32.add 	$push195=, $pop389, $pop496
	i32.const	$push390=, 720
	i32.add 	$push391=, $2, $pop390
	i32.const	$push495=, 8
	i32.add 	$push494=, $pop391, $pop495
	tee_local	$push493=, $0=, $pop494
	i64.load	$push196=, 0($pop493)
	i64.store	$drop=, 0($pop195), $pop196
	i64.load	$push197=, 720($2)
	i64.store	$drop=, 112($2), $pop197
	i32.const	$push392=, 80
	i32.add 	$push393=, $2, $pop392
	i32.const	$push492=, 24
	i32.add 	$push198=, $pop393, $pop492
	i64.load	$push199=, 0($3)
	i64.store	$drop=, 0($pop198), $pop199
	i32.const	$push394=, 80
	i32.add 	$push395=, $2, $pop394
	i32.const	$push491=, 16
	i32.add 	$push200=, $pop395, $pop491
	i64.load	$push201=, 0($4)
	i64.store	$drop=, 0($pop200), $pop201
	i32.const	$push396=, 80
	i32.add 	$push397=, $2, $pop396
	i32.const	$push490=, 8
	i32.add 	$push202=, $pop397, $pop490
	i64.load	$push203=, 0($0)
	i64.store	$drop=, 0($pop202), $pop203
	i64.load	$push204=, 720($2)
	i64.store	$drop=, 80($2), $pop204
	i32.const	$push398=, 80
	i32.add 	$push399=, $2, $pop398
	i32.store	$drop=, 72($2), $pop399
	i32.const	$push400=, 112
	i32.add 	$push401=, $2, $pop400
	i32.store	$drop=, 68($2), $pop401
	i32.const	$push402=, 144
	i32.add 	$push403=, $2, $pop402
	i32.store	$drop=, 64($2), $pop403
	i32.const	$push205=, 2
	i32.const	$push404=, 64
	i32.add 	$push405=, $2, $pop404
	call    	f7@FUNCTION, $pop205, $pop405
	i32.const	$push489=, 0
	i32.load	$push206=, s1($pop489)
	i32.const	$push207=, 131
	i32.ne  	$push208=, $pop206, $pop207
	br_if   	0, $pop208      # 0: down to label24
# BB#19:                                # %if.end46
	i32.const	$push508=, 0
	i32.load	$push175=, s1+16($pop508)
	i32.const	$push209=, 254
	i32.ne  	$push210=, $pop175, $pop209
	br_if   	0, $pop210      # 0: down to label24
# BB#20:                                # %if.end46
	i32.const	$push509=, 0
	f64.load	$push176=, s1+8($pop509)
	f64.const	$push211=, 0x1.ep3
	f64.ne  	$push212=, $pop176, $pop211
	br_if   	0, $pop212      # 0: down to label24
# BB#21:                                # %if.end46
	i32.const	$push510=, 0
	f64.load	$push177=, s1+24($pop510)
	f64.const	$push213=, 0x1.64p7
	f64.ne  	$push214=, $pop177, $pop213
	br_if   	0, $pop214      # 0: down to label24
# BB#22:                                # %if.end55
	i32.const	$push511=, 0
	i32.load	$push215=, bar_arg($pop511)
	i32.const	$push216=, 131
	i32.ne  	$push217=, $pop215, $pop216
	br_if   	0, $pop217      # 0: down to label24
# BB#23:                                # %if.end58
	i32.const	$push406=, 48
	i32.add 	$push407=, $2, $pop406
	i32.const	$push219=, 8
	i32.add 	$push220=, $pop407, $pop219
	i32.const	$push408=, 656
	i32.add 	$push409=, $2, $pop408
	i32.const	$push518=, 8
	i32.add 	$push221=, $pop409, $pop518
	i64.load	$push222=, 0($pop221)
	i64.store	$drop=, 0($pop220), $pop222
	i32.const	$push410=, 32
	i32.add 	$push411=, $2, $pop410
	i32.const	$push517=, 8
	i32.add 	$push223=, $pop411, $pop517
	i32.const	$push412=, 672
	i32.add 	$push413=, $2, $pop412
	i32.const	$push516=, 8
	i32.add 	$push515=, $pop413, $pop516
	tee_local	$push514=, $3=, $pop515
	i64.load	$push224=, 0($pop514)
	i64.store	$drop=, 0($pop223), $pop224
	i64.load	$push225=, 656($2)
	i64.store	$drop=, 48($2), $pop225
	i64.load	$push226=, 672($2)
	i64.store	$drop=, 32($2), $pop226
	i32.const	$push414=, 16
	i32.add 	$push415=, $2, $pop414
	i32.const	$push513=, 8
	i32.add 	$push227=, $pop415, $pop513
	i64.load	$push228=, 0($3)
	i64.store	$drop=, 0($pop227), $pop228
	i64.load	$push229=, 672($2)
	i64.store	$drop=, 16($2), $pop229
	i32.const	$push416=, 16
	i32.add 	$push417=, $2, $pop416
	i32.store	$drop=, 8($2), $pop417
	i32.const	$push418=, 32
	i32.add 	$push419=, $2, $pop418
	i32.store	$drop=, 4($2), $pop419
	i32.const	$push420=, 48
	i32.add 	$push421=, $2, $pop420
	i32.store	$drop=, 0($2), $pop421
	i32.const	$push230=, 3
	call    	f8@FUNCTION, $pop230, $2
	i32.const	$push512=, 0
	i32.load	$push231=, s2+8($pop512)
	i32.const	$push232=, 257
	i32.ne  	$push233=, $pop231, $pop232
	br_if   	0, $pop233      # 0: down to label24
# BB#24:                                # %if.end58
	i32.const	$push519=, 0
	f64.load	$push218=, s2($pop519)
	f64.const	$push234=, 0x1.6p7
	f64.ne  	$push235=, $pop218, $pop234
	br_if   	0, $pop235      # 0: down to label24
# BB#25:                                # %if.end63
	i32.const	$push243=, 0
	i32.const	$push241=, 752
	i32.add 	$push242=, $2, $pop241
	i32.store	$drop=, __stack_pointer($pop243), $pop242
	i32.const	$push236=, 0
	return  	$pop236
.LBB9_26:                               # %if.then62
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end9:
	.size	main, .Lfunc_end9-main

	.hidden	bar_arg                 # @bar_arg
	.type	bar_arg,@object
	.section	.bss.bar_arg,"aw",@nobits
	.globl	bar_arg
	.p2align	2
bar_arg:
	.int32	0                       # 0x0
	.size	bar_arg, 4

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.int32	0                       # 0x0
	.size	x, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	3
d:
	.int64	0                       # double 0
	.size	d, 8

	.hidden	s1                      # @s1
	.type	s1,@object
	.section	.bss.s1,"aw",@nobits
	.globl	s1
	.p2align	3
s1:
	.skip	32
	.size	s1, 32

	.hidden	s2                      # @s2
	.type	s2,@object
	.section	.bss.s2,"aw",@nobits
	.globl	s2
	.p2align	3
s2:
	.skip	16
	.size	s2, 16

	.hidden	y                       # @y
	.type	y,@object
	.section	.bss.y,"aw",@nobits
	.globl	y
	.p2align	2
y:
	.int32	0                       # 0x0
	.size	y, 4

	.hidden	foo_arg                 # @foo_arg
	.type	foo_arg,@object
	.section	.bss.foo_arg,"aw",@nobits
	.globl	foo_arg
	.p2align	2
foo_arg:
	.int32	0                       # 0x0
	.size	foo_arg, 4

	.hidden	gap                     # @gap
	.type	gap,@object
	.section	.bss.gap,"aw",@nobits
	.globl	gap
	.p2align	2
gap:
	.int32	0
	.size	gap, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
