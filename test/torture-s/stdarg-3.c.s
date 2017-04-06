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
	i32.store	bar_arg($pop0), $0
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
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$push8=, $pop3, $pop5
	tee_local	$push7=, $3=, $pop8
	i32.store	12($pop7), $1
	block   	
	i32.const	$push6=, 1
	i32.lt_s	$push0=, $0, $pop6
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push9=, 1
	i32.add 	$1=, $0, $pop9
	i32.load	$0=, 12($3)
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push17=, 4
	i32.add 	$push16=, $0, $pop17
	tee_local	$push15=, $2=, $pop16
	i32.store	12($3), $pop15
	i32.const	$push14=, 0
	i32.load	$push1=, 0($0)
	i32.store	x($pop14), $pop1
	copy_local	$0=, $2
	i32.const	$push13=, -1
	i32.add 	$push12=, $1, $pop13
	tee_local	$push11=, $1=, $pop12
	i32.const	$push10=, 1
	i32.gt_s	$push2=, $pop11, $pop10
	br_if   	0, $pop2        # 0: up to label1
.LBB1_3:                                # %while.end
	end_loop
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
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$push9=, $pop4, $pop6
	tee_local	$push8=, $2=, $pop9
	i32.store	12($pop8), $1
	block   	
	i32.const	$push7=, 1
	i32.lt_s	$push0=, $0, $pop7
	br_if   	0, $pop0        # 0: down to label2
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push10=, 1
	i32.add 	$1=, $0, $pop10
	i32.load	$0=, 12($2)
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push20=, 0
	i32.const	$push19=, 7
	i32.add 	$push1=, $0, $pop19
	i32.const	$push18=, -8
	i32.and 	$push17=, $pop1, $pop18
	tee_local	$push16=, $0=, $pop17
	i64.load	$push2=, 0($pop16)
	i64.store	d($pop20), $pop2
	i32.const	$push15=, 8
	i32.add 	$0=, $0, $pop15
	i32.const	$push14=, -1
	i32.add 	$push13=, $1, $pop14
	tee_local	$push12=, $1=, $pop13
	i32.const	$push11=, 1
	i32.gt_s	$push3=, $pop12, $pop11
	br_if   	0, $pop3        # 0: up to label3
# BB#3:                                 # %while.end.loopexit
	end_loop
	i32.store	12($2), $0
.LBB2_4:                                # %while.end
	end_block                       # label2:
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
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$4=, $pop3, $pop5
	block   	
	i32.const	$push6=, 1
	i32.lt_s	$push0=, $0, $pop6
	br_if   	0, $pop0        # 0: down to label4
# BB#1:                                 # %while.body.preheader
	i32.const	$push7=, 1
	i32.add 	$0=, $0, $pop7
	i32.const	$push1=, 4
	i32.add 	$2=, $1, $pop1
.LBB3_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.store	12($4), $1
	i32.store	12($4), $2
	i32.const	$push15=, 0
	i32.load	$push14=, 0($1)
	tee_local	$push13=, $3=, $pop14
	i32.store	bar_arg($pop15), $pop13
	i32.const	$push12=, 0
	i32.store	x($pop12), $3
	i32.const	$push11=, -1
	i32.add 	$push10=, $0, $pop11
	tee_local	$push9=, $0=, $pop10
	i32.const	$push8=, 1
	i32.gt_s	$push2=, $pop9, $pop8
	br_if   	0, $pop2        # 0: up to label5
.LBB3_3:                                # %while.end
	end_loop
	end_block                       # label4:
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
	i32.const	$push11=, 0
	i32.load	$push10=, __stack_pointer($pop11)
	i32.const	$push12=, 16
	i32.sub 	$4=, $pop10, $pop12
	block   	
	i32.const	$push13=, 1
	i32.lt_s	$push0=, $0, $pop13
	br_if   	0, $pop0        # 0: down to label6
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
	loop    	                # label7:
	i32.store	12($4), $1
	i32.const	$push24=, 0
	i64.load	$push4=, 0($2)
	i64.store	d($pop24), $pop4
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	f64.load	$push5=, d($pop22)
	f64.const	$push21=, 0x1p2
	f64.add 	$push6=, $pop5, $pop21
	i32.trunc_s/f64	$push7=, $pop6
	i32.store	bar_arg($pop23), $pop7
	i32.store	12($4), $3
	i32.const	$push20=, -1
	i32.add 	$push19=, $0, $pop20
	tee_local	$push18=, $0=, $pop19
	i32.const	$push17=, 1
	i32.gt_s	$push9=, $pop18, $pop17
	br_if   	0, $pop9        # 0: up to label7
.LBB4_3:                                # %while.end
	end_loop
	end_block                       # label6:
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
	i32.const	$push11=, 0
	i32.load	$push10=, __stack_pointer($pop11)
	i32.const	$push12=, 16
	i32.sub 	$push15=, $pop10, $pop12
	tee_local	$push14=, $2=, $pop15
	i32.store	12($pop14), $1
	block   	
	i32.const	$push13=, 1
	i32.lt_s	$push0=, $0, $pop13
	br_if   	0, $pop0        # 0: down to label8
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push16=, 1
	i32.add 	$1=, $0, $pop16
	i32.load	$0=, 12($2)
.LBB5_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label9:
	i32.const	$push32=, 0
	i32.const	$push31=, 7
	i32.add 	$push1=, $0, $pop31
	i32.const	$push30=, -8
	i32.and 	$push29=, $pop1, $pop30
	tee_local	$push28=, $0=, $pop29
	i64.load	$push2=, 0($pop28)
	i64.store	s1($pop32), $pop2
	i32.const	$push27=, 0
	i32.const	$push26=, 24
	i32.add 	$push3=, $0, $pop26
	i64.load	$push4=, 0($pop3)
	i64.store	s1+24($pop27), $pop4
	i32.const	$push25=, 0
	i32.const	$push24=, 16
	i32.add 	$push5=, $0, $pop24
	i64.load	$push6=, 0($pop5)
	i64.store	s1+16($pop25), $pop6
	i32.const	$push23=, 0
	i32.const	$push22=, 8
	i32.add 	$push7=, $0, $pop22
	i64.load	$push8=, 0($pop7)
	i64.store	s1+8($pop23), $pop8
	i32.const	$push21=, 32
	i32.add 	$0=, $0, $pop21
	i32.const	$push20=, -1
	i32.add 	$push19=, $1, $pop20
	tee_local	$push18=, $1=, $pop19
	i32.const	$push17=, 1
	i32.gt_s	$push9=, $pop18, $pop17
	br_if   	0, $pop9        # 0: up to label9
# BB#3:                                 # %while.end.loopexit
	end_loop
	i32.store	12($2), $0
.LBB5_4:                                # %while.end
	end_block                       # label8:
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
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 16
	i32.sub 	$push11=, $pop6, $pop8
	tee_local	$push10=, $2=, $pop11
	i32.store	12($pop10), $1
	block   	
	i32.const	$push9=, 1
	i32.lt_s	$push0=, $0, $pop9
	br_if   	0, $pop0        # 0: down to label10
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push12=, 1
	i32.add 	$1=, $0, $pop12
	i32.load	$0=, 12($2)
.LBB6_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label11:
	i32.const	$push24=, 0
	i32.const	$push23=, 7
	i32.add 	$push1=, $0, $pop23
	i32.const	$push22=, -8
	i32.and 	$push21=, $pop1, $pop22
	tee_local	$push20=, $0=, $pop21
	i64.load	$push2=, 0($pop20)
	i64.store	s2($pop24), $pop2
	i32.const	$push19=, 0
	i32.const	$push18=, 8
	i32.add 	$push3=, $0, $pop18
	i64.load	$push4=, 0($pop3)
	i64.store	s2+8($pop19), $pop4
	i32.const	$push17=, 16
	i32.add 	$0=, $0, $pop17
	i32.const	$push16=, -1
	i32.add 	$push15=, $1, $pop16
	tee_local	$push14=, $1=, $pop15
	i32.const	$push13=, 1
	i32.gt_s	$push5=, $pop14, $pop13
	br_if   	0, $pop5        # 0: up to label11
# BB#3:                                 # %while.end.loopexit
	end_loop
	i32.store	12($2), $0
.LBB6_4:                                # %while.end
	end_block                       # label10:
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
	i32.const	$push22=, 0
	i32.load	$push21=, __stack_pointer($pop22)
	i32.const	$push23=, 16
	i32.sub 	$10=, $pop21, $pop23
	block   	
	i32.const	$push24=, 1
	i32.lt_s	$push0=, $0, $pop24
	br_if   	0, $pop0        # 0: down to label12
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push27=, 1
	i32.add 	$9=, $0, $pop27
	i32.const	$push1=, 7
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, -8
	i32.and 	$push26=, $pop2, $pop3
	tee_local	$push25=, $0=, $pop26
	i32.const	$push4=, 24
	i32.add 	$2=, $pop25, $pop4
	i32.const	$push6=, 16
	i32.add 	$3=, $0, $pop6
	i32.const	$push8=, 8
	i32.add 	$4=, $0, $pop8
	i32.const	$push10=, 32
	i32.add 	$5=, $0, $pop10
	i32.const	$push13=, 28
	i32.add 	$6=, $0, $pop13
	i32.const	$push15=, 20
	i32.add 	$7=, $0, $pop15
	i32.const	$push17=, 12
	i32.add 	$8=, $0, $pop17
.LBB7_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label13:
	i32.store	12($10), $1
	i32.const	$push41=, 0
	i32.load	$push5=, 0($2)
	i32.store	s1+24($pop41), $pop5
	i32.const	$push40=, 0
	i32.load	$push7=, 0($3)
	i32.store	s1+16($pop40), $pop7
	i32.const	$push39=, 0
	i32.load	$push9=, 0($4)
	i32.store	s1+8($pop39), $pop9
	i32.store	12($10), $5
	i32.const	$push38=, 0
	i32.load	$push11=, 0($0)
	i32.store	s1($pop38), $pop11
	i32.const	$push37=, 0
	i32.load	$push12=, 4($0)
	i32.store	s1+4($pop37), $pop12
	i32.const	$push36=, 0
	i32.load	$push14=, 0($6)
	i32.store	s1+28($pop36), $pop14
	i32.const	$push35=, 0
	i32.load	$push16=, 0($7)
	i32.store	s1+20($pop35), $pop16
	i32.const	$push34=, 0
	i32.load	$push18=, 0($8)
	i32.store	s1+12($pop34), $pop18
	i32.const	$push33=, 0
	i32.const	$push32=, 0
	i32.load	$push19=, s1($pop32)
	i32.store	bar_arg($pop33), $pop19
	i32.const	$push31=, -1
	i32.add 	$push30=, $9, $pop31
	tee_local	$push29=, $9=, $pop30
	i32.const	$push28=, 1
	i32.gt_s	$push20=, $pop29, $pop28
	br_if   	0, $pop20       # 0: up to label13
.LBB7_3:                                # %while.end
	end_loop
	end_block                       # label12:
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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.load	$push12=, __stack_pointer($pop13)
	i32.const	$push14=, 16
	i32.sub 	$7=, $pop12, $pop14
	block   	
	i32.const	$push15=, 1
	i32.lt_s	$push0=, $0, $pop15
	br_if   	0, $pop0        # 0: down to label14
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push18=, 1
	i32.add 	$6=, $0, $pop18
	i32.const	$push1=, 7
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, -8
	i32.and 	$push17=, $pop2, $pop3
	tee_local	$push16=, $0=, $pop17
	i32.const	$push6=, 12
	i32.add 	$2=, $pop16, $pop6
	i32.const	$push8=, 8
	i32.add 	$3=, $0, $pop8
	i32.const	$push10=, 20
	i32.add 	$5=, $0, $pop10
.LBB8_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label15:
	i32.store	12($7), $1
	i32.const	$push30=, 0
	i32.load	$push4=, 4($0)
	i32.store	s2+4($pop30), $pop4
	i32.const	$push29=, 0
	i32.load	$push5=, 0($0)
	i32.store	s2($pop29), $pop5
	i32.const	$push28=, 0
	i32.load	$push7=, 0($2)
	i32.store	s2+12($pop28), $pop7
	i32.const	$push27=, 0
	i32.load	$push26=, 0($3)
	tee_local	$push25=, $4=, $pop26
	i32.store	s2+8($pop27), $pop25
	i32.const	$push24=, 0
	i32.load	$push9=, 16($0)
	i32.store	y($pop24), $pop9
	i32.const	$push23=, 0
	i32.store	bar_arg($pop23), $4
	i32.store	12($7), $5
	i32.const	$push22=, -1
	i32.add 	$push21=, $6, $pop22
	tee_local	$push20=, $6=, $pop21
	i32.const	$push19=, 1
	i32.gt_s	$push11=, $pop20, $pop19
	br_if   	0, $pop11       # 0: up to label15
.LBB8_3:                                # %while.end
	end_loop
	end_block                       # label14:
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push294=, 0
	i32.const	$push292=, 0
	i32.load	$push291=, __stack_pointer($pop292)
	i32.const	$push293=, 752
	i32.sub 	$push532=, $pop291, $pop293
	tee_local	$push531=, $3=, $pop532
	i32.store	__stack_pointer($pop294), $pop531
	i32.const	$push298=, 624
	i32.add 	$push299=, $3, $pop298
	i32.const	$push530=, 24
	i32.add 	$push0=, $pop299, $pop530
	i64.const	$push1=, 55834574859
	i64.store	0($pop0), $pop1
	i32.const	$push300=, 624
	i32.add 	$push301=, $3, $pop300
	i32.const	$push529=, 16
	i32.add 	$push2=, $pop301, $pop529
	i64.const	$push3=, 38654705671
	i64.store	0($pop2), $pop3
	i64.const	$push4=, 21474836483
	i64.store	632($3), $pop4
	i64.const	$push5=, 8589934593
	i64.store	624($3), $pop5
	i32.const	$push6=, 7
	i32.const	$push302=, 624
	i32.add 	$push303=, $3, $pop302
	call    	f1@FUNCTION, $pop6, $pop303
	block   	
	i32.const	$push528=, 0
	i32.load	$push7=, x($pop528)
	i32.const	$push8=, 11
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label16
# BB#1:                                 # %if.end
	i32.const	$push10=, 608
	i32.add 	$push11=, $3, $pop10
	i64.const	$push12=, 4634204016564240384
	i64.store	0($pop11), $pop12
	i32.const	$push13=, 600
	i32.add 	$push14=, $3, $pop13
	i64.const	$push15=, 4629700416936869888
	i64.store	0($pop14), $pop15
	i32.const	$push16=, 592
	i32.add 	$push17=, $3, $pop16
	i64.const	$push18=, 4625196817309499392
	i64.store	0($pop17), $pop18
	i32.const	$push304=, 560
	i32.add 	$push305=, $3, $pop304
	i32.const	$push535=, 24
	i32.add 	$push19=, $pop305, $pop535
	i64.const	$push20=, 4620693217682128896
	i64.store	0($pop19), $pop20
	i32.const	$push306=, 560
	i32.add 	$push307=, $3, $pop306
	i32.const	$push534=, 16
	i32.add 	$push21=, $pop307, $pop534
	i64.const	$push22=, 4616189618054758400
	i64.store	0($pop21), $pop22
	i64.const	$push23=, 4611686018427387904
	i64.store	568($3), $pop23
	i64.const	$push24=, 4607182418800017408
	i64.store	560($3), $pop24
	i32.const	$push25=, 6
	i32.const	$push308=, 560
	i32.add 	$push309=, $3, $pop308
	call    	f2@FUNCTION, $pop25, $pop309
	i32.const	$push533=, 0
	f64.load	$push26=, d($pop533)
	f64.const	$push27=, 0x1p5
	f64.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label16
# BB#2:                                 # %if.end3
	i64.const	$push30=, 12884901889
	i64.store	544($3), $pop30
	i32.const	$push31=, 2
	i32.const	$push310=, 544
	i32.add 	$push311=, $3, $pop310
	call    	f3@FUNCTION, $pop31, $pop311
	i32.const	$push537=, 0
	i32.load	$push32=, bar_arg($pop537)
	i32.const	$push536=, 1
	i32.ne  	$push33=, $pop32, $pop536
	br_if   	0, $pop33       # 0: down to label16
# BB#3:                                 # %if.end3
	i32.const	$push539=, 0
	i32.load	$push29=, x($pop539)
	i32.const	$push538=, 1
	i32.ne  	$push34=, $pop29, $pop538
	br_if   	0, $pop34       # 0: down to label16
# BB#4:                                 # %if.end7
	i64.const	$push36=, 4626041242239631360
	i64.store	536($3), $pop36
	i64.const	$push37=, 4625478292286210048
	i64.store	528($3), $pop37
	i32.const	$push38=, 2
	i32.const	$push312=, 528
	i32.add 	$push313=, $3, $pop312
	call    	f4@FUNCTION, $pop38, $pop313
	i32.const	$push540=, 0
	i32.load	$push39=, bar_arg($pop540)
	i32.const	$push40=, 21
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label16
# BB#5:                                 # %if.end7
	i32.const	$push541=, 0
	f64.load	$push35=, d($pop541)
	f64.const	$push42=, 0x1.1p4
	f64.ne  	$push43=, $pop35, $pop42
	br_if   	0, $pop43       # 0: down to label16
# BB#6:                                 # %if.end12
	i32.const	$push47=, 251
	i32.store	736($3), $pop47
	i32.const	$push314=, 688
	i32.add 	$push315=, $3, $pop314
	i32.const	$push48=, 16
	i32.add 	$push561=, $pop315, $pop48
	tee_local	$push560=, $0=, $pop561
	i32.const	$push559=, 251
	i32.store	0($pop560), $pop559
	i32.const	$push316=, 688
	i32.add 	$push317=, $3, $pop316
	i32.const	$push49=, 20
	i32.add 	$push50=, $pop317, $pop49
	i32.const	$push318=, 720
	i32.add 	$push319=, $3, $pop318
	i32.const	$push558=, 20
	i32.add 	$push51=, $pop319, $pop558
	i32.load	$push52=, 0($pop51)
	i32.store	0($pop50), $pop52
	i32.const	$push557=, 254
	i32.store	0($0), $pop557
	i64.const	$push53=, 4624633867356078080
	i64.store	728($3), $pop53
	i32.const	$push320=, 688
	i32.add 	$push321=, $3, $pop320
	i32.const	$push54=, 12
	i32.add 	$push55=, $pop321, $pop54
	i32.const	$push322=, 720
	i32.add 	$push323=, $3, $pop322
	i32.const	$push556=, 12
	i32.add 	$push56=, $pop323, $pop556
	i32.load	$push57=, 0($pop56)
	i32.store	0($pop55), $pop57
	i32.const	$push324=, 688
	i32.add 	$push325=, $3, $pop324
	i32.const	$push58=, 8
	i32.add 	$push555=, $pop325, $pop58
	tee_local	$push554=, $1=, $pop555
	i32.load	$push59=, 728($3)
	i32.store	0($pop554), $pop59
	i64.const	$push60=, 4640924231633207296
	i64.store	744($3), $pop60
	i64.const	$push61=, 4640466834796052480
	i64.store	712($3), $pop61
	i32.load	$push62=, 724($3)
	i32.store	692($3), $pop62
	i32.const	$push326=, 496
	i32.add 	$push327=, $3, $pop326
	i32.const	$push63=, 24
	i32.add 	$push64=, $pop327, $pop63
	i64.load	$push65=, 744($3)
	i64.store	0($pop64), $pop65
	i32.const	$push328=, 496
	i32.add 	$push329=, $3, $pop328
	i32.const	$push553=, 16
	i32.add 	$push66=, $pop329, $pop553
	i64.load	$push67=, 736($3)
	i64.store	0($pop66), $pop67
	i32.const	$push330=, 496
	i32.add 	$push331=, $3, $pop330
	i32.const	$push552=, 8
	i32.add 	$push68=, $pop331, $pop552
	i64.load	$push69=, 728($3)
	i64.store	0($pop68), $pop69
	i32.const	$push332=, 464
	i32.add 	$push333=, $3, $pop332
	i32.const	$push70=, 28
	i32.add 	$push71=, $pop333, $pop70
	i32.const	$push334=, 688
	i32.add 	$push335=, $3, $pop334
	i32.const	$push551=, 28
	i32.add 	$push72=, $pop335, $pop551
	i32.load	$push73=, 0($pop72)
	i32.store	0($pop71), $pop73
	i32.const	$push336=, 464
	i32.add 	$push337=, $3, $pop336
	i32.const	$push550=, 24
	i32.add 	$push74=, $pop337, $pop550
	i32.load	$push75=, 712($3)
	i32.store	0($pop74), $pop75
	i32.const	$push338=, 464
	i32.add 	$push339=, $3, $pop338
	i32.const	$push549=, 16
	i32.add 	$push76=, $pop339, $pop549
	i64.load	$push77=, 0($0)
	i64.store	0($pop76), $pop77
	i32.const	$push78=, 131
	i32.store	720($3), $pop78
	i32.const	$push548=, 131
	i32.store	688($3), $pop548
	i64.load	$push79=, 720($3)
	i64.store	496($3), $pop79
	i32.const	$push340=, 464
	i32.add 	$push341=, $3, $pop340
	i32.const	$push547=, 8
	i32.add 	$push80=, $pop341, $pop547
	i64.load	$push81=, 0($1)
	i64.store	0($pop80), $pop81
	i64.load	$push82=, 688($3)
	i64.store	464($3), $pop82
	i32.const	$push342=, 432
	i32.add 	$push343=, $3, $pop342
	i32.const	$push546=, 24
	i32.add 	$push83=, $pop343, $pop546
	i64.load	$push84=, 744($3)
	i64.store	0($pop83), $pop84
	i32.const	$push344=, 432
	i32.add 	$push345=, $3, $pop344
	i32.const	$push545=, 16
	i32.add 	$push85=, $pop345, $pop545
	i64.load	$push86=, 736($3)
	i64.store	0($pop85), $pop86
	i32.const	$push346=, 432
	i32.add 	$push347=, $3, $pop346
	i32.const	$push544=, 8
	i32.add 	$push87=, $pop347, $pop544
	i64.load	$push88=, 728($3)
	i64.store	0($pop87), $pop88
	i64.load	$push89=, 720($3)
	i64.store	432($3), $pop89
	i32.const	$push348=, 432
	i32.add 	$push349=, $3, $pop348
	i32.store	424($3), $pop349
	i32.const	$push350=, 464
	i32.add 	$push351=, $3, $pop350
	i32.store	420($3), $pop351
	i32.const	$push352=, 496
	i32.add 	$push353=, $3, $pop352
	i32.store	416($3), $pop353
	i32.const	$push90=, 2
	i32.const	$push354=, 416
	i32.add 	$push355=, $3, $pop354
	call    	f5@FUNCTION, $pop90, $pop355
	i32.const	$push543=, 0
	i32.load	$push91=, s1($pop543)
	i32.const	$push542=, 131
	i32.ne  	$push92=, $pop91, $pop542
	br_if   	0, $pop92       # 0: down to label16
# BB#7:                                 # %if.end12
	i32.const	$push563=, 0
	i32.load	$push44=, s1+16($pop563)
	i32.const	$push562=, 254
	i32.ne  	$push93=, $pop44, $pop562
	br_if   	0, $pop93       # 0: down to label16
# BB#8:                                 # %if.end12
	i32.const	$push564=, 0
	f64.load	$push45=, s1+8($pop564)
	f64.const	$push94=, 0x1.ep3
	f64.ne  	$push95=, $pop45, $pop94
	br_if   	0, $pop95       # 0: down to label16
# BB#9:                                 # %if.end12
	i32.const	$push565=, 0
	f64.load	$push46=, s1+24($pop565)
	f64.const	$push96=, 0x1.64p7
	f64.ne  	$push97=, $pop46, $pop96
	br_if   	0, $pop97       # 0: down to label16
# BB#10:                                # %if.end23
	i32.const	$push356=, 384
	i32.add 	$push357=, $3, $pop356
	i32.const	$push101=, 24
	i32.add 	$push102=, $pop357, $pop101
	i32.const	$push358=, 720
	i32.add 	$push359=, $3, $pop358
	i32.const	$push587=, 24
	i32.add 	$push586=, $pop359, $pop587
	tee_local	$push585=, $0=, $pop586
	i64.load	$push103=, 0($pop585)
	i64.store	0($pop102), $pop103
	i32.const	$push360=, 384
	i32.add 	$push361=, $3, $pop360
	i32.const	$push104=, 16
	i32.add 	$push105=, $pop361, $pop104
	i32.const	$push362=, 720
	i32.add 	$push363=, $3, $pop362
	i32.const	$push584=, 16
	i32.add 	$push583=, $pop363, $pop584
	tee_local	$push582=, $1=, $pop583
	i64.load	$push106=, 0($pop582)
	i64.store	0($pop105), $pop106
	i32.const	$push364=, 384
	i32.add 	$push365=, $3, $pop364
	i32.const	$push107=, 8
	i32.add 	$push108=, $pop365, $pop107
	i32.const	$push366=, 720
	i32.add 	$push367=, $3, $pop366
	i32.const	$push581=, 8
	i32.add 	$push580=, $pop367, $pop581
	tee_local	$push579=, $2=, $pop580
	i64.load	$push109=, 0($pop579)
	i64.store	0($pop108), $pop109
	i32.const	$push368=, 352
	i32.add 	$push369=, $3, $pop368
	i32.const	$push110=, 28
	i32.add 	$push111=, $pop369, $pop110
	i32.const	$push370=, 688
	i32.add 	$push371=, $3, $pop370
	i32.const	$push578=, 28
	i32.add 	$push112=, $pop371, $pop578
	i32.load	$push113=, 0($pop112)
	i32.store	0($pop111), $pop113
	i32.const	$push372=, 352
	i32.add 	$push373=, $3, $pop372
	i32.const	$push577=, 24
	i32.add 	$push114=, $pop373, $pop577
	i32.const	$push374=, 688
	i32.add 	$push375=, $3, $pop374
	i32.const	$push576=, 24
	i32.add 	$push115=, $pop375, $pop576
	i32.load	$push116=, 0($pop115)
	i32.store	0($pop114), $pop116
	i32.const	$push376=, 352
	i32.add 	$push377=, $3, $pop376
	i32.const	$push117=, 20
	i32.add 	$push118=, $pop377, $pop117
	i32.const	$push378=, 688
	i32.add 	$push379=, $3, $pop378
	i32.const	$push575=, 20
	i32.add 	$push119=, $pop379, $pop575
	i32.load	$push120=, 0($pop119)
	i32.store	0($pop118), $pop120
	i32.const	$push380=, 352
	i32.add 	$push381=, $3, $pop380
	i32.const	$push574=, 16
	i32.add 	$push121=, $pop381, $pop574
	i32.const	$push382=, 688
	i32.add 	$push383=, $3, $pop382
	i32.const	$push573=, 16
	i32.add 	$push122=, $pop383, $pop573
	i32.load	$push123=, 0($pop122)
	i32.store	0($pop121), $pop123
	i32.const	$push384=, 352
	i32.add 	$push385=, $3, $pop384
	i32.const	$push124=, 12
	i32.add 	$push125=, $pop385, $pop124
	i32.const	$push386=, 688
	i32.add 	$push387=, $3, $pop386
	i32.const	$push572=, 12
	i32.add 	$push126=, $pop387, $pop572
	i32.load	$push127=, 0($pop126)
	i32.store	0($pop125), $pop127
	i32.const	$push388=, 352
	i32.add 	$push389=, $3, $pop388
	i32.const	$push571=, 8
	i32.add 	$push128=, $pop389, $pop571
	i32.const	$push390=, 688
	i32.add 	$push391=, $3, $pop390
	i32.const	$push570=, 8
	i32.add 	$push129=, $pop391, $pop570
	i32.load	$push130=, 0($pop129)
	i32.store	0($pop128), $pop130
	i64.load	$push131=, 720($3)
	i64.store	384($3), $pop131
	i32.load	$push132=, 692($3)
	i32.store	356($3), $pop132
	i32.load	$push133=, 688($3)
	i32.store	352($3), $pop133
	i32.const	$push392=, 320
	i32.add 	$push393=, $3, $pop392
	i32.const	$push569=, 24
	i32.add 	$push134=, $pop393, $pop569
	i64.load	$push135=, 0($0)
	i64.store	0($pop134), $pop135
	i32.const	$push394=, 320
	i32.add 	$push395=, $3, $pop394
	i32.const	$push568=, 16
	i32.add 	$push136=, $pop395, $pop568
	i64.load	$push137=, 0($1)
	i64.store	0($pop136), $pop137
	i32.const	$push396=, 320
	i32.add 	$push397=, $3, $pop396
	i32.const	$push567=, 8
	i32.add 	$push138=, $pop397, $pop567
	i64.load	$push139=, 0($2)
	i64.store	0($pop138), $pop139
	i64.load	$push140=, 720($3)
	i64.store	320($3), $pop140
	i32.const	$push398=, 384
	i32.add 	$push399=, $3, $pop398
	i32.store	304($3), $pop399
	i32.const	$push400=, 320
	i32.add 	$push401=, $3, $pop400
	i32.store	312($3), $pop401
	i32.const	$push402=, 352
	i32.add 	$push403=, $3, $pop402
	i32.store	308($3), $pop403
	i32.const	$push141=, 3
	i32.const	$push404=, 304
	i32.add 	$push405=, $3, $pop404
	call    	f5@FUNCTION, $pop141, $pop405
	i32.const	$push566=, 0
	i32.load	$push142=, s1($pop566)
	i32.const	$push143=, 131
	i32.ne  	$push144=, $pop142, $pop143
	br_if   	0, $pop144      # 0: down to label16
# BB#11:                                # %if.end23
	i32.const	$push588=, 0
	i32.load	$push98=, s1+16($pop588)
	i32.const	$push145=, 251
	i32.ne  	$push146=, $pop98, $pop145
	br_if   	0, $pop146      # 0: down to label16
# BB#12:                                # %if.end23
	i32.const	$push589=, 0
	f64.load	$push99=, s1+8($pop589)
	f64.const	$push147=, 0x1.ep3
	f64.ne  	$push148=, $pop99, $pop147
	br_if   	0, $pop148      # 0: down to label16
# BB#13:                                # %if.end23
	i32.const	$push590=, 0
	f64.load	$push100=, s1+24($pop590)
	f64.const	$push149=, 0x1.7ep7
	f64.ne  	$push150=, $pop100, $pop149
	br_if   	0, $pop150      # 0: down to label16
# BB#14:                                # %if.end32
	i32.const	$push406=, 288
	i32.add 	$push407=, $3, $pop406
	i32.const	$push152=, 12
	i32.add 	$push153=, $pop407, $pop152
	i32.const	$push408=, 672
	i32.add 	$push409=, $3, $pop408
	i32.const	$push600=, 12
	i32.add 	$push599=, $pop409, $pop600
	tee_local	$push598=, $0=, $pop599
	i32.load	$push154=, 0($pop598)
	i32.store	0($pop153), $pop154
	i32.const	$push155=, 138
	i32.store	680($3), $pop155
	i32.const	$push156=, 257
	i32.store	664($3), $pop156
	i32.const	$push410=, 288
	i32.add 	$push411=, $3, $pop410
	i32.const	$push157=, 8
	i32.add 	$push158=, $pop411, $pop157
	i32.load	$push159=, 680($3)
	i32.store	0($pop158), $pop159
	i32.const	$push412=, 272
	i32.add 	$push413=, $3, $pop412
	i32.const	$push597=, 12
	i32.add 	$push160=, $pop413, $pop597
	i32.const	$push414=, 656
	i32.add 	$push415=, $3, $pop414
	i32.const	$push596=, 12
	i32.add 	$push161=, $pop415, $pop596
	i32.load	$push162=, 0($pop161)
	i32.store	0($pop160), $pop162
	i32.const	$push416=, 272
	i32.add 	$push417=, $3, $pop416
	i32.const	$push595=, 8
	i32.add 	$push163=, $pop417, $pop595
	i32.load	$push164=, 664($3)
	i32.store	0($pop163), $pop164
	i64.const	$push165=, 4625196817309499392
	i64.store	672($3), $pop165
	i64.const	$push166=, 4640396466051874816
	i64.store	656($3), $pop166
	i32.load	$push167=, 676($3)
	i32.store	292($3), $pop167
	i32.load	$push168=, 672($3)
	i32.store	288($3), $pop168
	i32.load	$push169=, 660($3)
	i32.store	276($3), $pop169
	i32.load	$push170=, 656($3)
	i32.store	272($3), $pop170
	i32.const	$push418=, 256
	i32.add 	$push419=, $3, $pop418
	i32.const	$push594=, 12
	i32.add 	$push171=, $pop419, $pop594
	i32.load	$push172=, 0($0)
	i32.store	0($pop171), $pop172
	i32.const	$push420=, 256
	i32.add 	$push421=, $3, $pop420
	i32.const	$push593=, 8
	i32.add 	$push173=, $pop421, $pop593
	i32.load	$push174=, 680($3)
	i32.store	0($pop173), $pop174
	i32.load	$push175=, 676($3)
	i32.store	260($3), $pop175
	i32.load	$push176=, 672($3)
	i32.store	256($3), $pop176
	i32.const	$push422=, 272
	i32.add 	$push423=, $3, $pop422
	i32.store	244($3), $pop423
	i32.const	$push424=, 256
	i32.add 	$push425=, $3, $pop424
	i32.store	248($3), $pop425
	i32.const	$push426=, 288
	i32.add 	$push427=, $3, $pop426
	i32.store	240($3), $pop427
	i32.const	$push177=, 2
	i32.const	$push428=, 240
	i32.add 	$push429=, $3, $pop428
	call    	f6@FUNCTION, $pop177, $pop429
	i32.const	$push592=, 0
	i32.load	$push178=, s2+8($pop592)
	i32.const	$push591=, 257
	i32.ne  	$push179=, $pop178, $pop591
	br_if   	0, $pop179      # 0: down to label16
# BB#15:                                # %if.end32
	i32.const	$push601=, 0
	f64.load	$push151=, s2($pop601)
	f64.const	$push180=, 0x1.6p7
	f64.ne  	$push181=, $pop151, $pop180
	br_if   	0, $pop181      # 0: down to label16
# BB#16:                                # %if.end41
	i32.const	$push430=, 224
	i32.add 	$push431=, $3, $pop430
	i32.const	$push183=, 8
	i32.add 	$push184=, $pop431, $pop183
	i32.const	$push432=, 672
	i32.add 	$push433=, $3, $pop432
	i32.const	$push611=, 8
	i32.add 	$push610=, $pop433, $pop611
	tee_local	$push609=, $0=, $pop610
	i64.load	$push185=, 0($pop609)
	i64.store	0($pop184), $pop185
	i32.const	$push434=, 208
	i32.add 	$push435=, $3, $pop434
	i32.const	$push186=, 12
	i32.add 	$push187=, $pop435, $pop186
	i32.const	$push436=, 656
	i32.add 	$push437=, $3, $pop436
	i32.const	$push608=, 12
	i32.add 	$push188=, $pop437, $pop608
	i32.load	$push189=, 0($pop188)
	i32.store	0($pop187), $pop189
	i32.const	$push438=, 208
	i32.add 	$push439=, $3, $pop438
	i32.const	$push607=, 8
	i32.add 	$push190=, $pop439, $pop607
	i32.const	$push440=, 656
	i32.add 	$push441=, $3, $pop440
	i32.const	$push606=, 8
	i32.add 	$push191=, $pop441, $pop606
	i32.load	$push192=, 0($pop191)
	i32.store	0($pop190), $pop192
	i32.const	$push442=, 192
	i32.add 	$push443=, $3, $pop442
	i32.const	$push605=, 12
	i32.add 	$push193=, $pop443, $pop605
	i32.const	$push444=, 672
	i32.add 	$push445=, $3, $pop444
	i32.const	$push604=, 12
	i32.add 	$push194=, $pop445, $pop604
	i32.load	$push195=, 0($pop194)
	i32.store	0($pop193), $pop195
	i32.const	$push446=, 192
	i32.add 	$push447=, $3, $pop446
	i32.const	$push603=, 8
	i32.add 	$push196=, $pop447, $pop603
	i32.load	$push197=, 0($0)
	i32.store	0($pop196), $pop197
	i64.load	$push198=, 672($3)
	i64.store	224($3), $pop198
	i32.load	$push199=, 656($3)
	i32.store	208($3), $pop199
	i32.load	$push200=, 660($3)
	i32.store	212($3), $pop200
	i32.load	$push201=, 672($3)
	i32.store	192($3), $pop201
	i32.load	$push202=, 676($3)
	i32.store	196($3), $pop202
	i32.const	$push448=, 224
	i32.add 	$push449=, $3, $pop448
	i32.store	176($3), $pop449
	i32.const	$push450=, 208
	i32.add 	$push451=, $3, $pop450
	i32.store	180($3), $pop451
	i32.const	$push452=, 192
	i32.add 	$push453=, $3, $pop452
	i32.store	184($3), $pop453
	i32.const	$push203=, 3
	i32.const	$push454=, 176
	i32.add 	$push455=, $3, $pop454
	call    	f6@FUNCTION, $pop203, $pop455
	i32.const	$push602=, 0
	i32.load	$push204=, s2+8($pop602)
	i32.const	$push205=, 138
	i32.ne  	$push206=, $pop204, $pop205
	br_if   	0, $pop206      # 0: down to label16
# BB#17:                                # %if.end41
	i32.const	$push612=, 0
	f64.load	$push182=, s2($pop612)
	f64.const	$push207=, 0x1p4
	f64.ne  	$push208=, $pop182, $pop207
	br_if   	0, $pop208      # 0: down to label16
# BB#18:                                # %if.end46
	i32.const	$push456=, 144
	i32.add 	$push457=, $3, $pop456
	i32.const	$push212=, 24
	i32.add 	$push213=, $pop457, $pop212
	i32.const	$push458=, 688
	i32.add 	$push459=, $3, $pop458
	i32.const	$push634=, 24
	i32.add 	$push214=, $pop459, $pop634
	i64.load	$push215=, 0($pop214)
	i64.store	0($pop213), $pop215
	i32.const	$push460=, 144
	i32.add 	$push461=, $3, $pop460
	i32.const	$push216=, 16
	i32.add 	$push217=, $pop461, $pop216
	i32.const	$push462=, 688
	i32.add 	$push463=, $3, $pop462
	i32.const	$push633=, 16
	i32.add 	$push218=, $pop463, $pop633
	i64.load	$push219=, 0($pop218)
	i64.store	0($pop217), $pop219
	i32.const	$push464=, 144
	i32.add 	$push465=, $3, $pop464
	i32.const	$push220=, 8
	i32.add 	$push221=, $pop465, $pop220
	i32.const	$push466=, 688
	i32.add 	$push467=, $3, $pop466
	i32.const	$push632=, 8
	i32.add 	$push222=, $pop467, $pop632
	i64.load	$push223=, 0($pop222)
	i64.store	0($pop221), $pop223
	i32.const	$push468=, 112
	i32.add 	$push469=, $3, $pop468
	i32.const	$push224=, 28
	i32.add 	$push225=, $pop469, $pop224
	i32.const	$push470=, 720
	i32.add 	$push471=, $3, $pop470
	i32.const	$push631=, 28
	i32.add 	$push226=, $pop471, $pop631
	i32.load	$push227=, 0($pop226)
	i32.store	0($pop225), $pop227
	i32.const	$push472=, 112
	i32.add 	$push473=, $3, $pop472
	i32.const	$push630=, 24
	i32.add 	$push228=, $pop473, $pop630
	i32.const	$push474=, 720
	i32.add 	$push475=, $3, $pop474
	i32.const	$push629=, 24
	i32.add 	$push628=, $pop475, $pop629
	tee_local	$push627=, $0=, $pop628
	i32.load	$push229=, 0($pop627)
	i32.store	0($pop228), $pop229
	i32.const	$push476=, 112
	i32.add 	$push477=, $3, $pop476
	i32.const	$push230=, 20
	i32.add 	$push231=, $pop477, $pop230
	i32.const	$push478=, 720
	i32.add 	$push479=, $3, $pop478
	i32.const	$push626=, 20
	i32.add 	$push232=, $pop479, $pop626
	i32.load	$push233=, 0($pop232)
	i32.store	0($pop231), $pop233
	i32.const	$push480=, 112
	i32.add 	$push481=, $3, $pop480
	i32.const	$push625=, 16
	i32.add 	$push234=, $pop481, $pop625
	i32.const	$push482=, 720
	i32.add 	$push483=, $3, $pop482
	i32.const	$push624=, 16
	i32.add 	$push623=, $pop483, $pop624
	tee_local	$push622=, $1=, $pop623
	i32.load	$push235=, 0($pop622)
	i32.store	0($pop234), $pop235
	i32.const	$push484=, 112
	i32.add 	$push485=, $3, $pop484
	i32.const	$push236=, 12
	i32.add 	$push237=, $pop485, $pop236
	i32.const	$push486=, 720
	i32.add 	$push487=, $3, $pop486
	i32.const	$push621=, 12
	i32.add 	$push238=, $pop487, $pop621
	i32.load	$push239=, 0($pop238)
	i32.store	0($pop237), $pop239
	i32.const	$push488=, 112
	i32.add 	$push489=, $3, $pop488
	i32.const	$push620=, 8
	i32.add 	$push240=, $pop489, $pop620
	i32.const	$push490=, 720
	i32.add 	$push491=, $3, $pop490
	i32.const	$push619=, 8
	i32.add 	$push618=, $pop491, $pop619
	tee_local	$push617=, $2=, $pop618
	i32.load	$push241=, 0($pop617)
	i32.store	0($pop240), $pop241
	i64.load	$push242=, 688($3)
	i64.store	144($3), $pop242
	i32.load	$push243=, 724($3)
	i32.store	116($3), $pop243
	i32.load	$push244=, 720($3)
	i32.store	112($3), $pop244
	i32.const	$push492=, 80
	i32.add 	$push493=, $3, $pop492
	i32.const	$push616=, 24
	i32.add 	$push245=, $pop493, $pop616
	i64.load	$push246=, 0($0)
	i64.store	0($pop245), $pop246
	i32.const	$push494=, 80
	i32.add 	$push495=, $3, $pop494
	i32.const	$push615=, 16
	i32.add 	$push247=, $pop495, $pop615
	i64.load	$push248=, 0($1)
	i64.store	0($pop247), $pop248
	i32.const	$push496=, 80
	i32.add 	$push497=, $3, $pop496
	i32.const	$push614=, 8
	i32.add 	$push249=, $pop497, $pop614
	i64.load	$push250=, 0($2)
	i64.store	0($pop249), $pop250
	i64.load	$push251=, 720($3)
	i64.store	80($3), $pop251
	i32.const	$push498=, 144
	i32.add 	$push499=, $3, $pop498
	i32.store	64($3), $pop499
	i32.const	$push500=, 80
	i32.add 	$push501=, $3, $pop500
	i32.store	72($3), $pop501
	i32.const	$push502=, 112
	i32.add 	$push503=, $3, $pop502
	i32.store	68($3), $pop503
	i32.const	$push252=, 2
	i32.const	$push504=, 64
	i32.add 	$push505=, $3, $pop504
	call    	f7@FUNCTION, $pop252, $pop505
	i32.const	$push613=, 0
	i32.load	$push253=, s1($pop613)
	i32.const	$push254=, 131
	i32.ne  	$push255=, $pop253, $pop254
	br_if   	0, $pop255      # 0: down to label16
# BB#19:                                # %if.end46
	i32.const	$push635=, 0
	i32.load	$push209=, s1+16($pop635)
	i32.const	$push256=, 254
	i32.ne  	$push257=, $pop209, $pop256
	br_if   	0, $pop257      # 0: down to label16
# BB#20:                                # %if.end46
	i32.const	$push636=, 0
	f64.load	$push210=, s1+8($pop636)
	f64.const	$push258=, 0x1.ep3
	f64.ne  	$push259=, $pop210, $pop258
	br_if   	0, $pop259      # 0: down to label16
# BB#21:                                # %if.end46
	i32.const	$push637=, 0
	f64.load	$push211=, s1+24($pop637)
	f64.const	$push260=, 0x1.64p7
	f64.ne  	$push261=, $pop211, $pop260
	br_if   	0, $pop261      # 0: down to label16
# BB#22:                                # %if.end55
	i32.const	$push638=, 0
	i32.load	$push262=, bar_arg($pop638)
	i32.const	$push263=, 131
	i32.ne  	$push264=, $pop262, $pop263
	br_if   	0, $pop264      # 0: down to label16
# BB#23:                                # %if.end58
	i32.const	$push506=, 48
	i32.add 	$push507=, $3, $pop506
	i32.const	$push266=, 8
	i32.add 	$push267=, $pop507, $pop266
	i32.const	$push508=, 656
	i32.add 	$push509=, $3, $pop508
	i32.const	$push649=, 8
	i32.add 	$push268=, $pop509, $pop649
	i64.load	$push269=, 0($pop268)
	i64.store	0($pop267), $pop269
	i32.const	$push510=, 32
	i32.add 	$push511=, $3, $pop510
	i32.const	$push270=, 12
	i32.add 	$push271=, $pop511, $pop270
	i32.const	$push512=, 672
	i32.add 	$push513=, $3, $pop512
	i32.const	$push648=, 12
	i32.add 	$push647=, $pop513, $pop648
	tee_local	$push646=, $0=, $pop647
	i32.load	$push272=, 0($pop646)
	i32.store	0($pop271), $pop272
	i32.const	$push514=, 32
	i32.add 	$push515=, $3, $pop514
	i32.const	$push645=, 8
	i32.add 	$push273=, $pop515, $pop645
	i32.const	$push516=, 672
	i32.add 	$push517=, $3, $pop516
	i32.const	$push644=, 8
	i32.add 	$push643=, $pop517, $pop644
	tee_local	$push642=, $1=, $pop643
	i32.load	$push274=, 0($pop642)
	i32.store	0($pop273), $pop274
	i32.const	$push518=, 16
	i32.add 	$push519=, $3, $pop518
	i32.const	$push641=, 12
	i32.add 	$push275=, $pop519, $pop641
	i32.load	$push276=, 0($0)
	i32.store	0($pop275), $pop276
	i32.const	$push520=, 16
	i32.add 	$push521=, $3, $pop520
	i32.const	$push640=, 8
	i32.add 	$push277=, $pop521, $pop640
	i32.load	$push278=, 0($1)
	i32.store	0($pop277), $pop278
	i64.load	$push279=, 656($3)
	i64.store	48($3), $pop279
	i32.load	$push280=, 672($3)
	i32.store	32($3), $pop280
	i32.load	$push281=, 676($3)
	i32.store	36($3), $pop281
	i32.load	$push282=, 672($3)
	i32.store	16($3), $pop282
	i32.load	$push283=, 676($3)
	i32.store	20($3), $pop283
	i32.const	$push522=, 48
	i32.add 	$push523=, $3, $pop522
	i32.store	0($3), $pop523
	i32.const	$push524=, 32
	i32.add 	$push525=, $3, $pop524
	i32.store	4($3), $pop525
	i32.const	$push526=, 16
	i32.add 	$push527=, $3, $pop526
	i32.store	8($3), $pop527
	i32.const	$push284=, 3
	call    	f8@FUNCTION, $pop284, $3
	i32.const	$push639=, 0
	i32.load	$push285=, s2+8($pop639)
	i32.const	$push286=, 257
	i32.ne  	$push287=, $pop285, $pop286
	br_if   	0, $pop287      # 0: down to label16
# BB#24:                                # %if.end58
	i32.const	$push650=, 0
	f64.load	$push265=, s2($pop650)
	f64.const	$push288=, 0x1.6p7
	f64.ne  	$push289=, $pop265, $pop288
	br_if   	0, $pop289      # 0: down to label16
# BB#25:                                # %if.end63
	i32.const	$push297=, 0
	i32.const	$push295=, 752
	i32.add 	$push296=, $3, $pop295
	i32.store	__stack_pointer($pop297), $pop296
	i32.const	$push290=, 0
	return  	$pop290
.LBB9_26:                               # %if.then
	end_block                       # label16:
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
