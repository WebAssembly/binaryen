	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/stdarg-3.c"
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
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push8=, $pop4, $pop5
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
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push9=, $pop5, $pop6
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
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$4=, $pop4, $pop5
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
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 16
	i32.sub 	$4=, $pop11, $pop12
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
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 16
	i32.sub 	$push15=, $pop11, $pop12
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
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push11=, $pop7, $pop8
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
	i32.const	$push21=, 0
	i32.load	$push22=, __stack_pointer($pop21)
	i32.const	$push23=, 16
	i32.sub 	$10=, $pop22, $pop23
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
	loop    	                # label13:
	i32.store	12($10), $1
	i32.const	$push41=, 0
	i32.load	$push4=, 4($0)
	i32.store	s1+4($pop41), $pop4
	i32.const	$push40=, 0
	i32.load	$push6=, 0($2)
	i32.store	s1+28($pop40), $pop6
	i32.const	$push39=, 0
	i32.load	$push8=, 0($3)
	i32.store	s1+24($pop39), $pop8
	i32.const	$push38=, 0
	i32.load	$push10=, 0($4)
	i32.store	s1+20($pop38), $pop10
	i32.const	$push37=, 0
	i32.load	$push12=, 0($5)
	i32.store	s1+16($pop37), $pop12
	i32.const	$push36=, 0
	i32.load	$push14=, 0($6)
	i32.store	s1+12($pop36), $pop14
	i32.const	$push35=, 0
	i32.load	$push16=, 0($7)
	i32.store	s1+8($pop35), $pop16
	i32.store	12($10), $8
	i32.const	$push34=, 0
	i32.load	$push18=, 0($0)
	i32.store	s1($pop34), $pop18
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 16
	i32.sub 	$6=, $pop15, $pop16
	block   	
	i32.const	$push17=, 1
	i32.lt_s	$push0=, $0, $pop17
	br_if   	0, $pop0        # 0: down to label14
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
	loop    	                # label15:
	i32.store	12($6), $1
	i32.const	$push31=, 0
	i32.load	$push4=, 4($0)
	i32.store	s2+4($pop31), $pop4
	i32.const	$push30=, 0
	i32.load	$push5=, 0($0)
	i32.store	s2($pop30), $pop5
	i32.const	$push29=, 0
	i32.load	$push7=, 0($2)
	i32.store	s2+12($pop29), $pop7
	i32.const	$push28=, 0
	i32.load	$push9=, 0($3)
	i32.store	s2+8($pop28), $pop9
	i32.store	12($6), $4
	i32.const	$push27=, 0
	i32.load	$push11=, 16($0)
	i32.store	y($pop27), $pop11
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.load	$push12=, s2+8($pop25)
	i32.store	bar_arg($pop26), $pop12
	i32.const	$push24=, -1
	i32.add 	$push23=, $5, $pop24
	tee_local	$push22=, $5=, $pop23
	i32.const	$push21=, 1
	i32.gt_s	$push13=, $pop22, $pop21
	br_if   	0, $pop13       # 0: up to label15
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
	i32.const	$push237=, 0
	i32.const	$push234=, 0
	i32.load	$push235=, __stack_pointer($pop234)
	i32.const	$push236=, 752
	i32.sub 	$push423=, $pop235, $pop236
	tee_local	$push422=, $3=, $pop423
	i32.store	__stack_pointer($pop237), $pop422
	i32.const	$push241=, 624
	i32.add 	$push242=, $3, $pop241
	i32.const	$push421=, 24
	i32.add 	$push0=, $pop242, $pop421
	i64.const	$push1=, 55834574859
	i64.store	0($pop0), $pop1
	i32.const	$push243=, 624
	i32.add 	$push244=, $3, $pop243
	i32.const	$push420=, 16
	i32.add 	$push2=, $pop244, $pop420
	i64.const	$push3=, 38654705671
	i64.store	0($pop2), $pop3
	i64.const	$push4=, 21474836483
	i64.store	632($3), $pop4
	i64.const	$push5=, 8589934593
	i64.store	624($3), $pop5
	i32.const	$push6=, 7
	i32.const	$push245=, 624
	i32.add 	$push246=, $3, $pop245
	call    	f1@FUNCTION, $pop6, $pop246
	block   	
	i32.const	$push419=, 0
	i32.load	$push7=, x($pop419)
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
	i32.const	$push247=, 560
	i32.add 	$push248=, $3, $pop247
	i32.const	$push426=, 24
	i32.add 	$push19=, $pop248, $pop426
	i64.const	$push20=, 4620693217682128896
	i64.store	0($pop19), $pop20
	i32.const	$push249=, 560
	i32.add 	$push250=, $3, $pop249
	i32.const	$push425=, 16
	i32.add 	$push21=, $pop250, $pop425
	i64.const	$push22=, 4616189618054758400
	i64.store	0($pop21), $pop22
	i64.const	$push23=, 4611686018427387904
	i64.store	568($3), $pop23
	i64.const	$push24=, 4607182418800017408
	i64.store	560($3), $pop24
	i32.const	$push25=, 6
	i32.const	$push251=, 560
	i32.add 	$push252=, $3, $pop251
	call    	f2@FUNCTION, $pop25, $pop252
	i32.const	$push424=, 0
	f64.load	$push26=, d($pop424)
	f64.const	$push27=, 0x1p5
	f64.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label16
# BB#2:                                 # %if.end3
	i64.const	$push30=, 12884901889
	i64.store	544($3), $pop30
	i32.const	$push31=, 2
	i32.const	$push253=, 544
	i32.add 	$push254=, $3, $pop253
	call    	f3@FUNCTION, $pop31, $pop254
	i32.const	$push428=, 0
	i32.load	$push32=, bar_arg($pop428)
	i32.const	$push427=, 1
	i32.ne  	$push33=, $pop32, $pop427
	br_if   	0, $pop33       # 0: down to label16
# BB#3:                                 # %if.end3
	i32.const	$push430=, 0
	i32.load	$push29=, x($pop430)
	i32.const	$push429=, 1
	i32.ne  	$push34=, $pop29, $pop429
	br_if   	0, $pop34       # 0: down to label16
# BB#4:                                 # %if.end7
	i64.const	$push36=, 4626041242239631360
	i64.store	536($3), $pop36
	i64.const	$push37=, 4625478292286210048
	i64.store	528($3), $pop37
	i32.const	$push38=, 2
	i32.const	$push255=, 528
	i32.add 	$push256=, $3, $pop255
	call    	f4@FUNCTION, $pop38, $pop256
	i32.const	$push431=, 0
	i32.load	$push39=, bar_arg($pop431)
	i32.const	$push40=, 21
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label16
# BB#5:                                 # %if.end7
	i32.const	$push432=, 0
	f64.load	$push35=, d($pop432)
	f64.const	$push42=, 0x1.1p4
	f64.ne  	$push43=, $pop35, $pop42
	br_if   	0, $pop43       # 0: down to label16
# BB#6:                                 # %if.end12
	i32.const	$push47=, 251
	i32.store	736($3), $pop47
	i32.const	$push257=, 688
	i32.add 	$push258=, $3, $pop257
	i32.const	$push48=, 16
	i32.add 	$push450=, $pop258, $pop48
	tee_local	$push449=, $0=, $pop450
	i32.const	$push448=, 251
	i32.store	0($pop449), $pop448
	i64.const	$push49=, 4624633867356078080
	i64.store	728($3), $pop49
	i32.const	$push259=, 688
	i32.add 	$push260=, $3, $pop259
	i32.const	$push50=, 8
	i32.add 	$push447=, $pop260, $pop50
	tee_local	$push446=, $1=, $pop447
	i64.const	$push445=, 4624633867356078080
	i64.store	0($pop446), $pop445
	i32.const	$push261=, 688
	i32.add 	$push262=, $3, $pop261
	i32.const	$push51=, 20
	i32.add 	$push52=, $pop262, $pop51
	i32.const	$push263=, 720
	i32.add 	$push264=, $3, $pop263
	i32.const	$push444=, 20
	i32.add 	$push53=, $pop264, $pop444
	i32.load	$push54=, 0($pop53)
	i32.store	0($pop52), $pop54
	i64.const	$push55=, 4640924231633207296
	i64.store	744($3), $pop55
	i32.const	$push56=, 131
	i32.store	720($3), $pop56
	i64.load	$push57=, 720($3)
	i64.store	688($3), $pop57
	i32.const	$push443=, 254
	i32.store	0($0), $pop443
	i32.const	$push265=, 496
	i32.add 	$push266=, $3, $pop265
	i32.const	$push442=, 16
	i32.add 	$push58=, $pop266, $pop442
	i64.load	$push59=, 736($3)
	i64.store	0($pop58), $pop59
	i64.const	$push60=, 4640466834796052480
	i64.store	712($3), $pop60
	i32.const	$push267=, 496
	i32.add 	$push268=, $3, $pop267
	i32.const	$push61=, 24
	i32.add 	$push62=, $pop268, $pop61
	i64.load	$push63=, 744($3)
	i64.store	0($pop62), $pop63
	i32.const	$push269=, 496
	i32.add 	$push270=, $3, $pop269
	i32.const	$push441=, 8
	i32.add 	$push64=, $pop270, $pop441
	i64.load	$push65=, 728($3)
	i64.store	0($pop64), $pop65
	i64.load	$push66=, 720($3)
	i64.store	496($3), $pop66
	i32.const	$push271=, 464
	i32.add 	$push272=, $3, $pop271
	i32.const	$push440=, 24
	i32.add 	$push67=, $pop272, $pop440
	i64.load	$push68=, 712($3)
	i64.store	0($pop67), $pop68
	i32.const	$push273=, 464
	i32.add 	$push274=, $3, $pop273
	i32.const	$push439=, 16
	i32.add 	$push69=, $pop274, $pop439
	i64.load	$push70=, 0($0)
	i64.store	0($pop69), $pop70
	i32.const	$push275=, 464
	i32.add 	$push276=, $3, $pop275
	i32.const	$push438=, 8
	i32.add 	$push71=, $pop276, $pop438
	i64.load	$push72=, 0($1)
	i64.store	0($pop71), $pop72
	i64.load	$push73=, 688($3)
	i64.store	464($3), $pop73
	i32.const	$push277=, 432
	i32.add 	$push278=, $3, $pop277
	i32.const	$push437=, 24
	i32.add 	$push74=, $pop278, $pop437
	i64.load	$push75=, 744($3)
	i64.store	0($pop74), $pop75
	i32.const	$push279=, 432
	i32.add 	$push280=, $3, $pop279
	i32.const	$push436=, 16
	i32.add 	$push76=, $pop280, $pop436
	i64.load	$push77=, 736($3)
	i64.store	0($pop76), $pop77
	i32.const	$push281=, 432
	i32.add 	$push282=, $3, $pop281
	i32.const	$push435=, 8
	i32.add 	$push78=, $pop282, $pop435
	i64.load	$push79=, 728($3)
	i64.store	0($pop78), $pop79
	i64.load	$push80=, 720($3)
	i64.store	432($3), $pop80
	i32.const	$push283=, 432
	i32.add 	$push284=, $3, $pop283
	i32.store	424($3), $pop284
	i32.const	$push285=, 464
	i32.add 	$push286=, $3, $pop285
	i32.store	420($3), $pop286
	i32.const	$push287=, 496
	i32.add 	$push288=, $3, $pop287
	i32.store	416($3), $pop288
	i32.const	$push81=, 2
	i32.const	$push289=, 416
	i32.add 	$push290=, $3, $pop289
	call    	f5@FUNCTION, $pop81, $pop290
	i32.const	$push434=, 0
	i32.load	$push82=, s1($pop434)
	i32.const	$push433=, 131
	i32.ne  	$push83=, $pop82, $pop433
	br_if   	0, $pop83       # 0: down to label16
# BB#7:                                 # %if.end12
	i32.const	$push452=, 0
	i32.load	$push44=, s1+16($pop452)
	i32.const	$push451=, 254
	i32.ne  	$push84=, $pop44, $pop451
	br_if   	0, $pop84       # 0: down to label16
# BB#8:                                 # %if.end12
	i32.const	$push453=, 0
	f64.load	$push45=, s1+8($pop453)
	f64.const	$push85=, 0x1.ep3
	f64.ne  	$push86=, $pop45, $pop85
	br_if   	0, $pop86       # 0: down to label16
# BB#9:                                 # %if.end12
	i32.const	$push454=, 0
	f64.load	$push46=, s1+24($pop454)
	f64.const	$push87=, 0x1.64p7
	f64.ne  	$push88=, $pop46, $pop87
	br_if   	0, $pop88       # 0: down to label16
# BB#10:                                # %if.end23
	i32.const	$push291=, 384
	i32.add 	$push292=, $3, $pop291
	i32.const	$push92=, 24
	i32.add 	$push93=, $pop292, $pop92
	i32.const	$push293=, 720
	i32.add 	$push294=, $3, $pop293
	i32.const	$push473=, 24
	i32.add 	$push472=, $pop294, $pop473
	tee_local	$push471=, $0=, $pop472
	i64.load	$push94=, 0($pop471)
	i64.store	0($pop93), $pop94
	i32.const	$push295=, 384
	i32.add 	$push296=, $3, $pop295
	i32.const	$push95=, 16
	i32.add 	$push96=, $pop296, $pop95
	i32.const	$push297=, 720
	i32.add 	$push298=, $3, $pop297
	i32.const	$push470=, 16
	i32.add 	$push469=, $pop298, $pop470
	tee_local	$push468=, $1=, $pop469
	i64.load	$push97=, 0($pop468)
	i64.store	0($pop96), $pop97
	i32.const	$push299=, 384
	i32.add 	$push300=, $3, $pop299
	i32.const	$push98=, 8
	i32.add 	$push99=, $pop300, $pop98
	i32.const	$push301=, 720
	i32.add 	$push302=, $3, $pop301
	i32.const	$push467=, 8
	i32.add 	$push466=, $pop302, $pop467
	tee_local	$push465=, $2=, $pop466
	i64.load	$push100=, 0($pop465)
	i64.store	0($pop99), $pop100
	i64.load	$push101=, 720($3)
	i64.store	384($3), $pop101
	i32.const	$push303=, 352
	i32.add 	$push304=, $3, $pop303
	i32.const	$push464=, 24
	i32.add 	$push102=, $pop304, $pop464
	i32.const	$push305=, 688
	i32.add 	$push306=, $3, $pop305
	i32.const	$push463=, 24
	i32.add 	$push103=, $pop306, $pop463
	i64.load	$push104=, 0($pop103)
	i64.store	0($pop102), $pop104
	i32.const	$push307=, 352
	i32.add 	$push308=, $3, $pop307
	i32.const	$push462=, 16
	i32.add 	$push105=, $pop308, $pop462
	i32.const	$push309=, 688
	i32.add 	$push310=, $3, $pop309
	i32.const	$push461=, 16
	i32.add 	$push106=, $pop310, $pop461
	i64.load	$push107=, 0($pop106)
	i64.store	0($pop105), $pop107
	i32.const	$push311=, 352
	i32.add 	$push312=, $3, $pop311
	i32.const	$push460=, 8
	i32.add 	$push108=, $pop312, $pop460
	i32.const	$push313=, 688
	i32.add 	$push314=, $3, $pop313
	i32.const	$push459=, 8
	i32.add 	$push109=, $pop314, $pop459
	i64.load	$push110=, 0($pop109)
	i64.store	0($pop108), $pop110
	i64.load	$push111=, 688($3)
	i64.store	352($3), $pop111
	i32.const	$push315=, 320
	i32.add 	$push316=, $3, $pop315
	i32.const	$push458=, 24
	i32.add 	$push112=, $pop316, $pop458
	i64.load	$push113=, 0($0)
	i64.store	0($pop112), $pop113
	i32.const	$push317=, 320
	i32.add 	$push318=, $3, $pop317
	i32.const	$push457=, 16
	i32.add 	$push114=, $pop318, $pop457
	i64.load	$push115=, 0($1)
	i64.store	0($pop114), $pop115
	i32.const	$push319=, 320
	i32.add 	$push320=, $3, $pop319
	i32.const	$push456=, 8
	i32.add 	$push116=, $pop320, $pop456
	i64.load	$push117=, 0($2)
	i64.store	0($pop116), $pop117
	i64.load	$push118=, 720($3)
	i64.store	320($3), $pop118
	i32.const	$push321=, 320
	i32.add 	$push322=, $3, $pop321
	i32.store	312($3), $pop322
	i32.const	$push323=, 352
	i32.add 	$push324=, $3, $pop323
	i32.store	308($3), $pop324
	i32.const	$push325=, 384
	i32.add 	$push326=, $3, $pop325
	i32.store	304($3), $pop326
	i32.const	$push119=, 3
	i32.const	$push327=, 304
	i32.add 	$push328=, $3, $pop327
	call    	f5@FUNCTION, $pop119, $pop328
	i32.const	$push455=, 0
	i32.load	$push120=, s1($pop455)
	i32.const	$push121=, 131
	i32.ne  	$push122=, $pop120, $pop121
	br_if   	0, $pop122      # 0: down to label16
# BB#11:                                # %if.end23
	i32.const	$push474=, 0
	i32.load	$push89=, s1+16($pop474)
	i32.const	$push123=, 251
	i32.ne  	$push124=, $pop89, $pop123
	br_if   	0, $pop124      # 0: down to label16
# BB#12:                                # %if.end23
	i32.const	$push475=, 0
	f64.load	$push90=, s1+8($pop475)
	f64.const	$push125=, 0x1.ep3
	f64.ne  	$push126=, $pop90, $pop125
	br_if   	0, $pop126      # 0: down to label16
# BB#13:                                # %if.end23
	i32.const	$push476=, 0
	f64.load	$push91=, s1+24($pop476)
	f64.const	$push127=, 0x1.7ep7
	f64.ne  	$push128=, $pop91, $pop127
	br_if   	0, $pop128      # 0: down to label16
# BB#14:                                # %if.end32
	i64.const	$push130=, 4625196817309499392
	i64.store	672($3), $pop130
	i32.const	$push131=, 138
	i32.store	680($3), $pop131
	i64.const	$push132=, 4640396466051874816
	i64.store	656($3), $pop132
	i32.const	$push133=, 257
	i32.store	664($3), $pop133
	i32.const	$push329=, 288
	i32.add 	$push330=, $3, $pop329
	i32.const	$push134=, 12
	i32.add 	$push135=, $pop330, $pop134
	i32.const	$push331=, 672
	i32.add 	$push332=, $3, $pop331
	i32.const	$push481=, 12
	i32.add 	$push136=, $pop332, $pop481
	i32.load	$push137=, 0($pop136)
	i32.store	0($pop135), $pop137
	i32.const	$push333=, 288
	i32.add 	$push334=, $3, $pop333
	i32.const	$push138=, 8
	i32.add 	$push139=, $pop334, $pop138
	i32.load	$push140=, 680($3)
	i32.store	0($pop139), $pop140
	i32.load	$push141=, 676($3)
	i32.store	292($3), $pop141
	i32.load	$push142=, 672($3)
	i32.store	288($3), $pop142
	i32.const	$push335=, 272
	i32.add 	$push336=, $3, $pop335
	i32.const	$push480=, 8
	i32.add 	$push143=, $pop336, $pop480
	i64.load	$push144=, 664($3)
	i64.store	0($pop143), $pop144
	i64.load	$push145=, 656($3)
	i64.store	272($3), $pop145
	i32.const	$push337=, 256
	i32.add 	$push338=, $3, $pop337
	i32.const	$push479=, 8
	i32.add 	$push146=, $pop338, $pop479
	i64.load	$push147=, 680($3)
	i64.store	0($pop146), $pop147
	i64.load	$push148=, 672($3)
	i64.store	256($3), $pop148
	i32.const	$push339=, 256
	i32.add 	$push340=, $3, $pop339
	i32.store	248($3), $pop340
	i32.const	$push341=, 272
	i32.add 	$push342=, $3, $pop341
	i32.store	244($3), $pop342
	i32.const	$push343=, 288
	i32.add 	$push344=, $3, $pop343
	i32.store	240($3), $pop344
	i32.const	$push149=, 2
	i32.const	$push345=, 240
	i32.add 	$push346=, $3, $pop345
	call    	f6@FUNCTION, $pop149, $pop346
	i32.const	$push478=, 0
	i32.load	$push150=, s2+8($pop478)
	i32.const	$push477=, 257
	i32.ne  	$push151=, $pop150, $pop477
	br_if   	0, $pop151      # 0: down to label16
# BB#15:                                # %if.end32
	i32.const	$push482=, 0
	f64.load	$push129=, s2($pop482)
	f64.const	$push152=, 0x1.6p7
	f64.ne  	$push153=, $pop129, $pop152
	br_if   	0, $pop153      # 0: down to label16
# BB#16:                                # %if.end41
	i32.const	$push347=, 224
	i32.add 	$push348=, $3, $pop347
	i32.const	$push155=, 8
	i32.add 	$push156=, $pop348, $pop155
	i32.const	$push349=, 672
	i32.add 	$push350=, $3, $pop349
	i32.const	$push489=, 8
	i32.add 	$push488=, $pop350, $pop489
	tee_local	$push487=, $0=, $pop488
	i64.load	$push157=, 0($pop487)
	i64.store	0($pop156), $pop157
	i32.const	$push351=, 208
	i32.add 	$push352=, $3, $pop351
	i32.const	$push486=, 8
	i32.add 	$push158=, $pop352, $pop486
	i32.const	$push353=, 656
	i32.add 	$push354=, $3, $pop353
	i32.const	$push485=, 8
	i32.add 	$push159=, $pop354, $pop485
	i64.load	$push160=, 0($pop159)
	i64.store	0($pop158), $pop160
	i64.load	$push161=, 672($3)
	i64.store	224($3), $pop161
	i64.load	$push162=, 656($3)
	i64.store	208($3), $pop162
	i32.const	$push355=, 192
	i32.add 	$push356=, $3, $pop355
	i32.const	$push484=, 8
	i32.add 	$push163=, $pop356, $pop484
	i64.load	$push164=, 0($0)
	i64.store	0($pop163), $pop164
	i64.load	$push165=, 672($3)
	i64.store	192($3), $pop165
	i32.const	$push357=, 192
	i32.add 	$push358=, $3, $pop357
	i32.store	184($3), $pop358
	i32.const	$push359=, 208
	i32.add 	$push360=, $3, $pop359
	i32.store	180($3), $pop360
	i32.const	$push361=, 224
	i32.add 	$push362=, $3, $pop361
	i32.store	176($3), $pop362
	i32.const	$push166=, 3
	i32.const	$push363=, 176
	i32.add 	$push364=, $3, $pop363
	call    	f6@FUNCTION, $pop166, $pop364
	i32.const	$push483=, 0
	i32.load	$push167=, s2+8($pop483)
	i32.const	$push168=, 138
	i32.ne  	$push169=, $pop167, $pop168
	br_if   	0, $pop169      # 0: down to label16
# BB#17:                                # %if.end41
	i32.const	$push490=, 0
	f64.load	$push154=, s2($pop490)
	f64.const	$push170=, 0x1p4
	f64.ne  	$push171=, $pop154, $pop170
	br_if   	0, $pop171      # 0: down to label16
# BB#18:                                # %if.end46
	i32.const	$push365=, 144
	i32.add 	$push366=, $3, $pop365
	i32.const	$push175=, 24
	i32.add 	$push176=, $pop366, $pop175
	i32.const	$push367=, 688
	i32.add 	$push368=, $3, $pop367
	i32.const	$push509=, 24
	i32.add 	$push177=, $pop368, $pop509
	i64.load	$push178=, 0($pop177)
	i64.store	0($pop176), $pop178
	i32.const	$push369=, 144
	i32.add 	$push370=, $3, $pop369
	i32.const	$push179=, 16
	i32.add 	$push180=, $pop370, $pop179
	i32.const	$push371=, 688
	i32.add 	$push372=, $3, $pop371
	i32.const	$push508=, 16
	i32.add 	$push181=, $pop372, $pop508
	i64.load	$push182=, 0($pop181)
	i64.store	0($pop180), $pop182
	i32.const	$push373=, 144
	i32.add 	$push374=, $3, $pop373
	i32.const	$push183=, 8
	i32.add 	$push184=, $pop374, $pop183
	i32.const	$push375=, 688
	i32.add 	$push376=, $3, $pop375
	i32.const	$push507=, 8
	i32.add 	$push185=, $pop376, $pop507
	i64.load	$push186=, 0($pop185)
	i64.store	0($pop184), $pop186
	i64.load	$push187=, 688($3)
	i64.store	144($3), $pop187
	i32.const	$push377=, 112
	i32.add 	$push378=, $3, $pop377
	i32.const	$push506=, 24
	i32.add 	$push188=, $pop378, $pop506
	i32.const	$push379=, 720
	i32.add 	$push380=, $3, $pop379
	i32.const	$push505=, 24
	i32.add 	$push504=, $pop380, $pop505
	tee_local	$push503=, $0=, $pop504
	i64.load	$push189=, 0($pop503)
	i64.store	0($pop188), $pop189
	i32.const	$push381=, 112
	i32.add 	$push382=, $3, $pop381
	i32.const	$push502=, 16
	i32.add 	$push190=, $pop382, $pop502
	i32.const	$push383=, 720
	i32.add 	$push384=, $3, $pop383
	i32.const	$push501=, 16
	i32.add 	$push500=, $pop384, $pop501
	tee_local	$push499=, $1=, $pop500
	i64.load	$push191=, 0($pop499)
	i64.store	0($pop190), $pop191
	i32.const	$push385=, 112
	i32.add 	$push386=, $3, $pop385
	i32.const	$push498=, 8
	i32.add 	$push192=, $pop386, $pop498
	i32.const	$push387=, 720
	i32.add 	$push388=, $3, $pop387
	i32.const	$push497=, 8
	i32.add 	$push496=, $pop388, $pop497
	tee_local	$push495=, $2=, $pop496
	i64.load	$push193=, 0($pop495)
	i64.store	0($pop192), $pop193
	i64.load	$push194=, 720($3)
	i64.store	112($3), $pop194
	i32.const	$push389=, 80
	i32.add 	$push390=, $3, $pop389
	i32.const	$push494=, 24
	i32.add 	$push195=, $pop390, $pop494
	i64.load	$push196=, 0($0)
	i64.store	0($pop195), $pop196
	i32.const	$push391=, 80
	i32.add 	$push392=, $3, $pop391
	i32.const	$push493=, 16
	i32.add 	$push197=, $pop392, $pop493
	i64.load	$push198=, 0($1)
	i64.store	0($pop197), $pop198
	i32.const	$push393=, 80
	i32.add 	$push394=, $3, $pop393
	i32.const	$push492=, 8
	i32.add 	$push199=, $pop394, $pop492
	i64.load	$push200=, 0($2)
	i64.store	0($pop199), $pop200
	i64.load	$push201=, 720($3)
	i64.store	80($3), $pop201
	i32.const	$push395=, 80
	i32.add 	$push396=, $3, $pop395
	i32.store	72($3), $pop396
	i32.const	$push397=, 112
	i32.add 	$push398=, $3, $pop397
	i32.store	68($3), $pop398
	i32.const	$push399=, 144
	i32.add 	$push400=, $3, $pop399
	i32.store	64($3), $pop400
	i32.const	$push202=, 2
	i32.const	$push401=, 64
	i32.add 	$push402=, $3, $pop401
	call    	f7@FUNCTION, $pop202, $pop402
	i32.const	$push491=, 0
	i32.load	$push203=, s1($pop491)
	i32.const	$push204=, 131
	i32.ne  	$push205=, $pop203, $pop204
	br_if   	0, $pop205      # 0: down to label16
# BB#19:                                # %if.end46
	i32.const	$push510=, 0
	i32.load	$push172=, s1+16($pop510)
	i32.const	$push206=, 254
	i32.ne  	$push207=, $pop172, $pop206
	br_if   	0, $pop207      # 0: down to label16
# BB#20:                                # %if.end46
	i32.const	$push511=, 0
	f64.load	$push173=, s1+8($pop511)
	f64.const	$push208=, 0x1.ep3
	f64.ne  	$push209=, $pop173, $pop208
	br_if   	0, $pop209      # 0: down to label16
# BB#21:                                # %if.end46
	i32.const	$push512=, 0
	f64.load	$push174=, s1+24($pop512)
	f64.const	$push210=, 0x1.64p7
	f64.ne  	$push211=, $pop174, $pop210
	br_if   	0, $pop211      # 0: down to label16
# BB#22:                                # %if.end55
	i32.const	$push513=, 0
	i32.load	$push212=, bar_arg($pop513)
	i32.const	$push213=, 131
	i32.ne  	$push214=, $pop212, $pop213
	br_if   	0, $pop214      # 0: down to label16
# BB#23:                                # %if.end58
	i32.const	$push403=, 48
	i32.add 	$push404=, $3, $pop403
	i32.const	$push216=, 8
	i32.add 	$push217=, $pop404, $pop216
	i32.const	$push405=, 656
	i32.add 	$push406=, $3, $pop405
	i32.const	$push520=, 8
	i32.add 	$push218=, $pop406, $pop520
	i64.load	$push219=, 0($pop218)
	i64.store	0($pop217), $pop219
	i32.const	$push407=, 32
	i32.add 	$push408=, $3, $pop407
	i32.const	$push519=, 8
	i32.add 	$push220=, $pop408, $pop519
	i32.const	$push409=, 672
	i32.add 	$push410=, $3, $pop409
	i32.const	$push518=, 8
	i32.add 	$push517=, $pop410, $pop518
	tee_local	$push516=, $0=, $pop517
	i64.load	$push221=, 0($pop516)
	i64.store	0($pop220), $pop221
	i64.load	$push222=, 656($3)
	i64.store	48($3), $pop222
	i64.load	$push223=, 672($3)
	i64.store	32($3), $pop223
	i32.const	$push411=, 16
	i32.add 	$push412=, $3, $pop411
	i32.const	$push515=, 8
	i32.add 	$push224=, $pop412, $pop515
	i64.load	$push225=, 0($0)
	i64.store	0($pop224), $pop225
	i64.load	$push226=, 672($3)
	i64.store	16($3), $pop226
	i32.const	$push413=, 16
	i32.add 	$push414=, $3, $pop413
	i32.store	8($3), $pop414
	i32.const	$push415=, 32
	i32.add 	$push416=, $3, $pop415
	i32.store	4($3), $pop416
	i32.const	$push417=, 48
	i32.add 	$push418=, $3, $pop417
	i32.store	0($3), $pop418
	i32.const	$push227=, 3
	call    	f8@FUNCTION, $pop227, $3
	i32.const	$push514=, 0
	i32.load	$push228=, s2+8($pop514)
	i32.const	$push229=, 257
	i32.ne  	$push230=, $pop228, $pop229
	br_if   	0, $pop230      # 0: down to label16
# BB#24:                                # %if.end58
	i32.const	$push521=, 0
	f64.load	$push215=, s2($pop521)
	f64.const	$push231=, 0x1.6p7
	f64.ne  	$push232=, $pop215, $pop231
	br_if   	0, $pop232      # 0: down to label16
# BB#25:                                # %if.end63
	i32.const	$push240=, 0
	i32.const	$push238=, 752
	i32.add 	$push239=, $3, $pop238
	i32.store	__stack_pointer($pop240), $pop239
	i32.const	$push233=, 0
	return  	$pop233
.LBB9_26:                               # %if.then62
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
