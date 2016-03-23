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
	i32.store	$discard=, bar_arg($pop0), $0
	return
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
	i32.const	$push10=, __stack_pointer
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 16
	i32.sub 	$3=, $pop11, $pop12
	i32.store	$discard=, 12($3), $1
	block
	i32.const	$push4=, 1
	i32.lt_s	$push1=, $0, $pop4
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push5=, 1
	i32.add 	$0=, $0, $pop5
	i32.load	$1=, 12($3)
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push9=, 4
	i32.add 	$push0=, $1, $pop9
	i32.store	$2=, 12($3), $pop0
	i32.const	$push8=, 0
	i32.load	$push2=, 0($1)
	i32.store	$discard=, x($pop8), $pop2
	i32.const	$push7=, -1
	i32.add 	$0=, $0, $pop7
	copy_local	$1=, $2
	i32.const	$push6=, 1
	i32.gt_s	$push3=, $0, $pop6
	br_if   	0, $pop3        # 0: up to label1
.LBB1_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	return
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
	i32.const	$push14=, __stack_pointer
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, 16
	i32.sub 	$2=, $pop15, $pop16
	i32.store	$discard=, 12($2), $1
	block
	i32.const	$push4=, 1
	i32.lt_s	$push0=, $0, $pop4
	br_if   	0, $pop0        # 0: down to label3
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push5=, 1
	i32.add 	$0=, $0, $pop5
	i32.load	$1=, 12($2)
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push13=, 0
	i32.const	$push12=, 7
	i32.add 	$push1=, $1, $pop12
	i32.const	$push11=, -8
	i32.and 	$push10=, $pop1, $pop11
	tee_local	$push9=, $1=, $pop10
	i64.load	$push2=, 0($pop9)
	i64.store	$discard=, d($pop13), $pop2
	i32.const	$push8=, 8
	i32.add 	$1=, $1, $pop8
	i32.const	$push7=, -1
	i32.add 	$0=, $0, $pop7
	i32.const	$push6=, 1
	i32.gt_s	$push3=, $0, $pop6
	br_if   	0, $pop3        # 0: up to label4
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label5:
	i32.store	$discard=, 12($2), $1
.LBB2_4:                                # %while.end
	end_block                       # label3:
	return
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
	i32.const	$push11=, __stack_pointer
	i32.load	$push12=, 0($pop11)
	i32.const	$push13=, 16
	i32.sub 	$4=, $pop12, $pop13
	block
	i32.const	$push5=, 1
	i32.lt_s	$push0=, $0, $pop5
	br_if   	0, $pop0        # 0: down to label6
# BB#1:                                 # %while.body.preheader
	i32.const	$push6=, 1
	i32.add 	$0=, $0, $pop6
	i32.const	$push1=, 4
	i32.add 	$3=, $1, $pop1
.LBB3_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.store	$2=, 12($4), $1
	i32.store	$discard=, 12($4), $3
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.load	$push2=, 0($2)
	i32.store	$push3=, x($pop9), $pop2
	i32.store	$discard=, bar_arg($pop10), $pop3
	i32.const	$push8=, -1
	i32.add 	$0=, $0, $pop8
	i32.const	$push7=, 1
	i32.gt_s	$push4=, $0, $pop7
	br_if   	0, $pop4        # 0: up to label7
.LBB3_3:                                # %while.end
	end_loop                        # label8:
	end_block                       # label6:
	return
	.endfunc
.Lfunc_end3:
	.size	f3, .Lfunc_end3-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	i32, f64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, __stack_pointer
	i32.load	$push20=, 0($pop19)
	i32.const	$push21=, 16
	i32.sub 	$5=, $pop20, $pop21
	block
	i32.const	$push9=, 1
	i32.lt_s	$push0=, $0, $pop9
	br_if   	0, $pop0        # 0: down to label9
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push12=, 1
	i32.add 	$0=, $0, $pop12
	i32.const	$push1=, 7
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, -8
	i32.and 	$push11=, $pop2, $pop3
	tee_local	$push10=, $4=, $pop11
	i32.const	$push4=, 8
	i32.add 	$2=, $pop10, $pop4
.LBB4_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.const	$push18=, 0
	i64.load	$push5=, 0($4)
	i64.store	$discard=, d($pop18), $pop5
	i32.const	$push17=, 0
	f64.load	$3=, d($pop17)
	i32.store	$discard=, 12($5), $1
	i32.store	$discard=, 12($5), $2
	i32.const	$push16=, 0
	f64.const	$push15=, 0x1p2
	f64.add 	$push6=, $3, $pop15
	i32.trunc_s/f64	$push7=, $pop6
	i32.store	$discard=, bar_arg($pop16), $pop7
	i32.const	$push14=, -1
	i32.add 	$0=, $0, $pop14
	i32.const	$push13=, 1
	i32.gt_s	$push8=, $0, $pop13
	br_if   	0, $pop8        # 0: up to label10
.LBB4_3:                                # %while.end
	end_loop                        # label11:
	end_block                       # label9:
	return
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
	i32.const	$push26=, __stack_pointer
	i32.load	$push27=, 0($pop26)
	i32.const	$push28=, 16
	i32.sub 	$2=, $pop27, $pop28
	i32.store	$discard=, 12($2), $1
	block
	i32.const	$push10=, 1
	i32.lt_s	$push0=, $0, $pop10
	br_if   	0, $pop0        # 0: down to label12
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push11=, 1
	i32.add 	$1=, $0, $pop11
	i32.load	$0=, 12($2)
.LBB5_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label13:
	i32.const	$push25=, 0
	i32.const	$push24=, 7
	i32.add 	$push1=, $0, $pop24
	i32.const	$push23=, -8
	i32.and 	$push22=, $pop1, $pop23
	tee_local	$push21=, $0=, $pop22
	i64.load	$push2=, 0($pop21)
	i64.store	$discard=, s1($pop25), $pop2
	i32.const	$push20=, 0
	i32.const	$push19=, 24
	i32.add 	$push3=, $0, $pop19
	i64.load	$push4=, 0($pop3)
	i64.store	$discard=, s1+24($pop20), $pop4
	i32.const	$push18=, 0
	i32.const	$push17=, 16
	i32.add 	$push5=, $0, $pop17
	i64.load	$push6=, 0($pop5)
	i64.store	$discard=, s1+16($pop18), $pop6
	i32.const	$push16=, 0
	i32.const	$push15=, 8
	i32.add 	$push7=, $0, $pop15
	i64.load	$push8=, 0($pop7)
	i64.store	$discard=, s1+8($pop16), $pop8
	i32.const	$push14=, 32
	i32.add 	$0=, $0, $pop14
	i32.const	$push13=, -1
	i32.add 	$1=, $1, $pop13
	i32.const	$push12=, 1
	i32.gt_s	$push9=, $1, $pop12
	br_if   	0, $pop9        # 0: up to label13
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label14:
	i32.store	$discard=, 12($2), $0
.LBB5_4:                                # %while.end
	end_block                       # label12:
	return
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
	i32.const	$push18=, __stack_pointer
	i32.load	$push19=, 0($pop18)
	i32.const	$push20=, 16
	i32.sub 	$2=, $pop19, $pop20
	i32.store	$discard=, 12($2), $1
	block
	i32.const	$push6=, 1
	i32.lt_s	$push0=, $0, $pop6
	br_if   	0, $pop0        # 0: down to label15
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push7=, 1
	i32.add 	$0=, $0, $pop7
	i32.load	$1=, 12($2)
.LBB6_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	i32.const	$push17=, 0
	i32.const	$push16=, 7
	i32.add 	$push1=, $1, $pop16
	i32.const	$push15=, -8
	i32.and 	$push14=, $pop1, $pop15
	tee_local	$push13=, $1=, $pop14
	i64.load	$push2=, 0($pop13)
	i64.store	$discard=, s2($pop17), $pop2
	i32.const	$push12=, 0
	i32.const	$push11=, 8
	i32.add 	$push3=, $1, $pop11
	i64.load	$push4=, 0($pop3)
	i64.store	$discard=, s2+8($pop12), $pop4
	i32.const	$push10=, 16
	i32.add 	$1=, $1, $pop10
	i32.const	$push9=, -1
	i32.add 	$0=, $0, $pop9
	i32.const	$push8=, 1
	i32.gt_s	$push5=, $0, $pop8
	br_if   	0, $pop5        # 0: up to label16
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label17:
	i32.store	$discard=, 12($2), $1
.LBB6_4:                                # %while.end
	end_block                       # label15:
	return
	.endfunc
.Lfunc_end6:
	.size	f6, .Lfunc_end6-f6

	.section	.text.f7,"ax",@progbits
	.hidden	f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push29=, __stack_pointer
	i32.load	$push30=, 0($pop29)
	i32.const	$push31=, 16
	i32.sub 	$8=, $pop30, $pop31
	block
	i32.const	$push16=, 1
	i32.lt_s	$push0=, $0, $pop16
	br_if   	0, $pop0        # 0: down to label18
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push19=, 1
	i32.add 	$0=, $0, $pop19
	i32.const	$push1=, 7
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, -8
	i32.and 	$push18=, $pop2, $pop3
	tee_local	$push17=, $7=, $pop18
	i32.const	$push4=, 32
	i32.add 	$2=, $pop17, $pop4
	i32.const	$push5=, 28
	i32.add 	$3=, $7, $pop5
	i32.const	$push7=, 24
	i32.add 	$4=, $7, $pop7
	i32.const	$push9=, 16
	i32.add 	$5=, $7, $pop9
	i32.const	$push11=, 8
	i32.add 	$6=, $7, $pop11
.LBB7_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	i32.const	$push28=, 0
	i32.load	$push6=, 0($3)
	i32.store	$discard=, s1+28($pop28), $pop6
	i32.const	$push27=, 0
	i32.load	$push8=, 0($4):p2align=3
	i32.store	$discard=, s1+24($pop27):p2align=3, $pop8
	i32.const	$push26=, 0
	i64.load	$push10=, 0($5)
	i64.store	$discard=, s1+16($pop26), $pop10
	i32.const	$push25=, 0
	i64.load	$push12=, 0($6)
	i64.store	$discard=, s1+8($pop25), $pop12
	i32.const	$push24=, 0
	i64.load	$push13=, 0($7)
	i64.store	$discard=, s1($pop24), $pop13
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.load	$push14=, s1($pop22):p2align=3
	i32.store	$discard=, bar_arg($pop23), $pop14
	i32.store	$discard=, 12($8), $1
	i32.store	$discard=, 12($8), $2
	i32.const	$push21=, -1
	i32.add 	$0=, $0, $pop21
	i32.const	$push20=, 1
	i32.gt_s	$push15=, $0, $pop20
	br_if   	0, $pop15       # 0: up to label19
.LBB7_3:                                # %while.end
	end_loop                        # label20:
	end_block                       # label18:
	return
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
	i32.const	$push24=, __stack_pointer
	i32.load	$push25=, 0($pop24)
	i32.const	$push26=, 16
	i32.sub 	$7=, $pop25, $pop26
	block
	i32.const	$push12=, 1
	i32.lt_s	$push0=, $0, $pop12
	br_if   	0, $pop0        # 0: down to label21
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push15=, 1
	i32.add 	$0=, $0, $pop15
	i32.const	$push1=, 7
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, -8
	i32.and 	$push14=, $pop2, $pop3
	tee_local	$push13=, $6=, $pop14
	i32.const	$push5=, 12
	i32.add 	$2=, $pop13, $pop5
	i32.const	$push7=, 8
	i32.add 	$3=, $6, $pop7
	i32.const	$push9=, 20
	i32.add 	$4=, $6, $pop9
.LBB8_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label22:
	i32.const	$push23=, 0
	i64.load	$push4=, 0($6)
	i64.store	$discard=, s2($pop23), $pop4
	i32.const	$push22=, 0
	i32.load	$push6=, 0($2)
	i32.store	$discard=, s2+12($pop22), $pop6
	i32.const	$push21=, 0
	i32.load	$push8=, 0($3):p2align=3
	i32.store	$discard=, s2+8($pop21):p2align=3, $pop8
	i32.store	$discard=, 12($7), $1
	i32.store	$discard=, 12($7), $4
	i32.const	$push20=, 0
	i32.load	$5=, s2+8($pop20):p2align=3
	i32.const	$push19=, 0
	i32.load	$push10=, 16($6):p2align=3
	i32.store	$discard=, y($pop19), $pop10
	i32.const	$push18=, 0
	i32.store	$discard=, bar_arg($pop18), $5
	i32.const	$push17=, -1
	i32.add 	$0=, $0, $pop17
	i32.const	$push16=, 1
	i32.gt_s	$push11=, $0, $pop16
	br_if   	0, $pop11       # 0: up to label22
.LBB8_3:                                # %while.end
	end_loop                        # label23:
	end_block                       # label21:
	return
	.endfunc
.Lfunc_end8:
	.size	f8, .Lfunc_end8-f8

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push329=, __stack_pointer
	i32.load	$push330=, 0($pop329)
	i32.const	$push331=, 752
	i32.sub 	$5=, $pop330, $pop331
	i32.const	$push332=, __stack_pointer
	i32.store	$discard=, 0($pop332), $5
	i32.const	$push336=, 624
	i32.add 	$push337=, $5, $pop336
	i32.const	$push236=, 24
	i32.add 	$push0=, $pop337, $pop236
	i64.const	$push1=, 55834574859
	i64.store	$discard=, 0($pop0), $pop1
	i32.const	$push338=, 624
	i32.add 	$push339=, $5, $pop338
	i32.const	$push235=, 16
	i32.add 	$push2=, $pop339, $pop235
	i64.const	$push3=, 38654705671
	i64.store	$discard=, 0($pop2):p2align=4, $pop3
	i64.const	$push4=, 21474836483
	i64.store	$discard=, 632($5), $pop4
	i64.const	$push5=, 8589934593
	i64.store	$discard=, 624($5):p2align=4, $pop5
	i32.const	$push6=, 7
	i32.const	$push340=, 624
	i32.add 	$push341=, $5, $pop340
	call    	f1@FUNCTION, $pop6, $pop341
	block
	i32.const	$push234=, 0
	i32.load	$push7=, x($pop234)
	i32.const	$push8=, 11
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label24
# BB#1:                                 # %if.end
	i32.const	$push342=, 560
	i32.add 	$push343=, $5, $pop342
	i32.const	$push10=, 48
	i32.add 	$push11=, $pop343, $pop10
	i64.const	$push12=, 4634204016564240384
	i64.store	$discard=, 0($pop11):p2align=4, $pop12
	i32.const	$push344=, 560
	i32.add 	$push345=, $5, $pop344
	i32.const	$push13=, 40
	i32.add 	$push14=, $pop345, $pop13
	i64.const	$push15=, 4629700416936869888
	i64.store	$discard=, 0($pop14), $pop15
	i32.const	$push346=, 560
	i32.add 	$push347=, $5, $pop346
	i32.const	$push16=, 32
	i32.add 	$push17=, $pop347, $pop16
	i64.const	$push18=, 4625196817309499392
	i64.store	$discard=, 0($pop17):p2align=4, $pop18
	i32.const	$push348=, 560
	i32.add 	$push349=, $5, $pop348
	i32.const	$push239=, 24
	i32.add 	$push19=, $pop349, $pop239
	i64.const	$push20=, 4620693217682128896
	i64.store	$discard=, 0($pop19), $pop20
	i32.const	$push350=, 560
	i32.add 	$push351=, $5, $pop350
	i32.const	$push238=, 16
	i32.add 	$push21=, $pop351, $pop238
	i64.const	$push22=, 4616189618054758400
	i64.store	$discard=, 0($pop21):p2align=4, $pop22
	i64.const	$push23=, 4611686018427387904
	i64.store	$discard=, 568($5), $pop23
	i64.const	$push24=, 4607182418800017408
	i64.store	$discard=, 560($5):p2align=4, $pop24
	i32.const	$push25=, 6
	i32.const	$push352=, 560
	i32.add 	$push353=, $5, $pop352
	call    	f2@FUNCTION, $pop25, $pop353
	i32.const	$push237=, 0
	f64.load	$push26=, d($pop237)
	f64.const	$push27=, 0x1p5
	f64.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label24
# BB#2:                                 # %if.end3
	i64.const	$push30=, 12884901889
	i64.store	$discard=, 544($5):p2align=4, $pop30
	i32.const	$push31=, 2
	i32.const	$push354=, 544
	i32.add 	$push355=, $5, $pop354
	call    	f3@FUNCTION, $pop31, $pop355
	i32.const	$push241=, 0
	i32.load	$push32=, bar_arg($pop241)
	i32.const	$push240=, 1
	i32.ne  	$push33=, $pop32, $pop240
	br_if   	0, $pop33       # 0: down to label24
# BB#3:                                 # %if.end3
	i32.const	$push243=, 0
	i32.load	$push29=, x($pop243)
	i32.const	$push242=, 1
	i32.ne  	$push34=, $pop29, $pop242
	br_if   	0, $pop34       # 0: down to label24
# BB#4:                                 # %if.end7
	i64.const	$push36=, 4626041242239631360
	i64.store	$discard=, 536($5), $pop36
	i64.const	$push37=, 4625478292286210048
	i64.store	$discard=, 528($5):p2align=4, $pop37
	i32.const	$push38=, 2
	i32.const	$push356=, 528
	i32.add 	$push357=, $5, $pop356
	call    	f4@FUNCTION, $pop38, $pop357
	i32.const	$push244=, 0
	i32.load	$push39=, bar_arg($pop244)
	i32.const	$push40=, 21
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label24
# BB#5:                                 # %if.end7
	i32.const	$push245=, 0
	f64.load	$push35=, d($pop245)
	f64.const	$push42=, 0x1.1p4
	f64.ne  	$push43=, $pop35, $pop42
	br_if   	0, $pop43       # 0: down to label24
# BB#6:                                 # %if.end12
	i32.const	$push48=, 251
	i32.store	$discard=, 736($5):p2align=3, $pop48
	i64.const	$push49=, 4624633867356078080
	i64.store	$discard=, 728($5), $pop49
	i32.const	$push47=, 131
	i32.store	$0=, 720($5):p2align=3, $pop47
	i32.load	$1=, 736($5):p2align=3
	i32.const	$push358=, 688
	i32.add 	$push359=, $5, $pop358
	i32.const	$push51=, 20
	i32.add 	$push52=, $pop359, $pop51
	i32.const	$push360=, 720
	i32.add 	$push361=, $5, $pop360
	i32.const	$push259=, 20
	i32.add 	$push53=, $pop361, $pop259
	i32.load	$push54=, 0($pop53)
	i32.store	$discard=, 0($pop52), $pop54
	i32.const	$push362=, 688
	i32.add 	$push363=, $5, $pop362
	i32.const	$push55=, 16
	i32.add 	$push258=, $pop363, $pop55
	tee_local	$push257=, $4=, $pop258
	i32.store	$discard=, 0($pop257):p2align=3, $1
	i64.const	$push50=, 4640924231633207296
	i64.store	$discard=, 744($5), $pop50
	i64.load	$2=, 720($5)
	i32.const	$push364=, 688
	i32.add 	$push365=, $5, $pop364
	i32.const	$push56=, 8
	i32.add 	$push256=, $pop365, $pop56
	tee_local	$push255=, $1=, $pop256
	i64.load	$push57=, 728($5)
	i64.store	$discard=, 0($pop255), $pop57
	i64.store	$discard=, 688($5), $2
	i64.const	$push59=, 4640466834796052480
	i64.store	$discard=, 712($5), $pop59
	i32.const	$push58=, 254
	i32.store	$3=, 0($4):p2align=3, $pop58
	i32.const	$push366=, 496
	i32.add 	$push367=, $5, $pop366
	i32.const	$push254=, 16
	i32.add 	$push60=, $pop367, $pop254
	i64.load	$push61=, 736($5)
	i64.store	$discard=, 0($pop60), $pop61
	i32.const	$push368=, 496
	i32.add 	$push369=, $5, $pop368
	i32.const	$push62=, 24
	i32.add 	$push63=, $pop369, $pop62
	i64.load	$push64=, 744($5)
	i64.store	$discard=, 0($pop63), $pop64
	i32.const	$push370=, 496
	i32.add 	$push371=, $5, $pop370
	i32.const	$push253=, 8
	i32.add 	$push65=, $pop371, $pop253
	i64.load	$push66=, 728($5)
	i64.store	$discard=, 0($pop65), $pop66
	i64.load	$push67=, 720($5)
	i64.store	$discard=, 496($5), $pop67
	i32.const	$push372=, 464
	i32.add 	$push373=, $5, $pop372
	i32.const	$push252=, 24
	i32.add 	$push68=, $pop373, $pop252
	i64.load	$push69=, 712($5)
	i64.store	$discard=, 0($pop68), $pop69
	i32.const	$push374=, 464
	i32.add 	$push375=, $5, $pop374
	i32.const	$push251=, 16
	i32.add 	$push70=, $pop375, $pop251
	i64.load	$push71=, 0($4)
	i64.store	$discard=, 0($pop70), $pop71
	i32.const	$push376=, 464
	i32.add 	$push377=, $5, $pop376
	i32.const	$push250=, 8
	i32.add 	$push72=, $pop377, $pop250
	i64.load	$push73=, 0($1)
	i64.store	$discard=, 0($pop72), $pop73
	i64.load	$push74=, 688($5)
	i64.store	$discard=, 464($5), $pop74
	i32.const	$push378=, 432
	i32.add 	$push379=, $5, $pop378
	i32.const	$push249=, 24
	i32.add 	$push75=, $pop379, $pop249
	i64.load	$push76=, 744($5)
	i64.store	$discard=, 0($pop75), $pop76
	i32.const	$push380=, 432
	i32.add 	$push381=, $5, $pop380
	i32.const	$push248=, 16
	i32.add 	$push77=, $pop381, $pop248
	i64.load	$push78=, 736($5)
	i64.store	$discard=, 0($pop77), $pop78
	i32.const	$push382=, 432
	i32.add 	$push383=, $5, $pop382
	i32.const	$push247=, 8
	i32.add 	$push79=, $pop383, $pop247
	i64.load	$push80=, 728($5)
	i64.store	$discard=, 0($pop79), $pop80
	i64.load	$push81=, 720($5)
	i64.store	$discard=, 432($5), $pop81
	i32.const	$push384=, 432
	i32.add 	$push385=, $5, $pop384
	i32.store	$discard=, 424($5):p2align=3, $pop385
	i32.const	$push386=, 464
	i32.add 	$push387=, $5, $pop386
	i32.store	$discard=, 420($5), $pop387
	i32.const	$push388=, 496
	i32.add 	$push389=, $5, $pop388
	i32.store	$discard=, 416($5):p2align=4, $pop389
	i32.const	$push82=, 2
	i32.const	$push390=, 416
	i32.add 	$push391=, $5, $pop390
	call    	f5@FUNCTION, $pop82, $pop391
	i32.const	$push246=, 0
	i32.load	$push83=, s1($pop246):p2align=3
	i32.ne  	$push84=, $0, $pop83
	br_if   	0, $pop84       # 0: down to label24
# BB#7:                                 # %if.end12
	i32.const	$push260=, 0
	i32.load	$push44=, s1+16($pop260):p2align=3
	i32.ne  	$push85=, $pop44, $3
	br_if   	0, $pop85       # 0: down to label24
# BB#8:                                 # %if.end12
	i32.const	$push261=, 0
	f64.load	$push45=, s1+8($pop261)
	f64.const	$push86=, 0x1.ep3
	f64.ne  	$push87=, $pop45, $pop86
	br_if   	0, $pop87       # 0: down to label24
# BB#9:                                 # %if.end12
	i32.const	$push262=, 0
	f64.load	$push46=, s1+24($pop262)
	f64.const	$push88=, 0x1.64p7
	f64.ne  	$push89=, $pop46, $pop88
	br_if   	0, $pop89       # 0: down to label24
# BB#10:                                # %if.end23
	i32.const	$push392=, 384
	i32.add 	$push393=, $5, $pop392
	i32.const	$push93=, 24
	i32.add 	$push94=, $pop393, $pop93
	i32.const	$push394=, 720
	i32.add 	$push395=, $5, $pop394
	i32.const	$push281=, 24
	i32.add 	$push280=, $pop395, $pop281
	tee_local	$push279=, $4=, $pop280
	i64.load	$push95=, 0($pop279)
	i64.store	$discard=, 0($pop94), $pop95
	i32.const	$push396=, 384
	i32.add 	$push397=, $5, $pop396
	i32.const	$push96=, 16
	i32.add 	$push97=, $pop397, $pop96
	i32.const	$push398=, 720
	i32.add 	$push399=, $5, $pop398
	i32.const	$push278=, 16
	i32.add 	$push277=, $pop399, $pop278
	tee_local	$push276=, $0=, $pop277
	i64.load	$push98=, 0($pop276)
	i64.store	$discard=, 0($pop97), $pop98
	i32.const	$push400=, 384
	i32.add 	$push401=, $5, $pop400
	i32.const	$push99=, 8
	i32.add 	$push100=, $pop401, $pop99
	i32.const	$push402=, 720
	i32.add 	$push403=, $5, $pop402
	i32.const	$push275=, 8
	i32.add 	$push274=, $pop403, $pop275
	tee_local	$push273=, $1=, $pop274
	i64.load	$push101=, 0($pop273)
	i64.store	$discard=, 0($pop100), $pop101
	i64.load	$push102=, 720($5)
	i64.store	$discard=, 384($5), $pop102
	i32.const	$push404=, 352
	i32.add 	$push405=, $5, $pop404
	i32.const	$push272=, 24
	i32.add 	$push103=, $pop405, $pop272
	i32.const	$push406=, 688
	i32.add 	$push407=, $5, $pop406
	i32.const	$push271=, 24
	i32.add 	$push104=, $pop407, $pop271
	i64.load	$push105=, 0($pop104)
	i64.store	$discard=, 0($pop103), $pop105
	i32.const	$push408=, 352
	i32.add 	$push409=, $5, $pop408
	i32.const	$push270=, 16
	i32.add 	$push106=, $pop409, $pop270
	i32.const	$push410=, 688
	i32.add 	$push411=, $5, $pop410
	i32.const	$push269=, 16
	i32.add 	$push107=, $pop411, $pop269
	i64.load	$push108=, 0($pop107)
	i64.store	$discard=, 0($pop106), $pop108
	i32.const	$push412=, 352
	i32.add 	$push413=, $5, $pop412
	i32.const	$push268=, 8
	i32.add 	$push109=, $pop413, $pop268
	i32.const	$push414=, 688
	i32.add 	$push415=, $5, $pop414
	i32.const	$push267=, 8
	i32.add 	$push110=, $pop415, $pop267
	i64.load	$push111=, 0($pop110)
	i64.store	$discard=, 0($pop109), $pop111
	i64.load	$push112=, 688($5)
	i64.store	$discard=, 352($5), $pop112
	i32.const	$push416=, 320
	i32.add 	$push417=, $5, $pop416
	i32.const	$push266=, 24
	i32.add 	$push113=, $pop417, $pop266
	i64.load	$push114=, 0($4)
	i64.store	$discard=, 0($pop113), $pop114
	i32.const	$push418=, 320
	i32.add 	$push419=, $5, $pop418
	i32.const	$push265=, 16
	i32.add 	$push115=, $pop419, $pop265
	i64.load	$push116=, 0($0)
	i64.store	$discard=, 0($pop115), $pop116
	i32.const	$push420=, 320
	i32.add 	$push421=, $5, $pop420
	i32.const	$push264=, 8
	i32.add 	$push117=, $pop421, $pop264
	i64.load	$push118=, 0($1)
	i64.store	$discard=, 0($pop117), $pop118
	i64.load	$push119=, 720($5)
	i64.store	$discard=, 320($5), $pop119
	i32.const	$push422=, 320
	i32.add 	$push423=, $5, $pop422
	i32.store	$discard=, 312($5):p2align=3, $pop423
	i32.const	$push424=, 352
	i32.add 	$push425=, $5, $pop424
	i32.store	$discard=, 308($5), $pop425
	i32.const	$push426=, 384
	i32.add 	$push427=, $5, $pop426
	i32.store	$discard=, 304($5):p2align=4, $pop427
	i32.const	$push120=, 3
	i32.const	$push428=, 304
	i32.add 	$push429=, $5, $pop428
	call    	f5@FUNCTION, $pop120, $pop429
	i32.const	$push263=, 0
	i32.load	$push121=, s1($pop263):p2align=3
	i32.const	$push122=, 131
	i32.ne  	$push123=, $pop121, $pop122
	br_if   	0, $pop123      # 0: down to label24
# BB#11:                                # %if.end23
	i32.const	$push282=, 0
	i32.load	$push90=, s1+16($pop282):p2align=3
	i32.const	$push124=, 251
	i32.ne  	$push125=, $pop90, $pop124
	br_if   	0, $pop125      # 0: down to label24
# BB#12:                                # %if.end23
	i32.const	$push283=, 0
	f64.load	$push91=, s1+8($pop283)
	f64.const	$push126=, 0x1.ep3
	f64.ne  	$push127=, $pop91, $pop126
	br_if   	0, $pop127      # 0: down to label24
# BB#13:                                # %if.end23
	i32.const	$push284=, 0
	f64.load	$push92=, s1+24($pop284)
	f64.const	$push128=, 0x1.7ep7
	f64.ne  	$push129=, $pop92, $pop128
	br_if   	0, $pop129      # 0: down to label24
# BB#14:                                # %if.end32
	i32.const	$push131=, 138
	i32.store	$discard=, 680($5):p2align=3, $pop131
	i64.const	$push132=, 4625196817309499392
	i64.store	$discard=, 672($5), $pop132
	i64.const	$push134=, 4640396466051874816
	i64.store	$discard=, 656($5), $pop134
	i32.const	$push133=, 257
	i32.store	$4=, 664($5):p2align=3, $pop133
	i32.const	$push430=, 288
	i32.add 	$push431=, $5, $pop430
	i32.const	$push135=, 12
	i32.add 	$push136=, $pop431, $pop135
	i32.const	$push432=, 672
	i32.add 	$push433=, $5, $pop432
	i32.const	$push288=, 12
	i32.add 	$push137=, $pop433, $pop288
	i32.load	$push138=, 0($pop137)
	i32.store	$discard=, 0($pop136), $pop138
	i32.const	$push434=, 288
	i32.add 	$push435=, $5, $pop434
	i32.const	$push139=, 8
	i32.add 	$push140=, $pop435, $pop139
	i32.load	$push141=, 680($5):p2align=3
	i32.store	$discard=, 0($pop140):p2align=3, $pop141
	i64.load	$push142=, 672($5)
	i64.store	$discard=, 288($5), $pop142
	i32.const	$push436=, 272
	i32.add 	$push437=, $5, $pop436
	i32.const	$push287=, 8
	i32.add 	$push143=, $pop437, $pop287
	i64.load	$push144=, 664($5)
	i64.store	$discard=, 0($pop143), $pop144
	i64.load	$push145=, 656($5)
	i64.store	$discard=, 272($5), $pop145
	i32.const	$push438=, 256
	i32.add 	$push439=, $5, $pop438
	i32.const	$push286=, 8
	i32.add 	$push146=, $pop439, $pop286
	i64.load	$push147=, 680($5)
	i64.store	$discard=, 0($pop146), $pop147
	i64.load	$push148=, 672($5)
	i64.store	$discard=, 256($5), $pop148
	i32.const	$push440=, 256
	i32.add 	$push441=, $5, $pop440
	i32.store	$discard=, 248($5):p2align=3, $pop441
	i32.const	$push442=, 272
	i32.add 	$push443=, $5, $pop442
	i32.store	$discard=, 244($5), $pop443
	i32.const	$push444=, 288
	i32.add 	$push445=, $5, $pop444
	i32.store	$discard=, 240($5):p2align=4, $pop445
	i32.const	$push149=, 2
	i32.const	$push446=, 240
	i32.add 	$push447=, $5, $pop446
	call    	f6@FUNCTION, $pop149, $pop447
	i32.const	$push285=, 0
	i32.load	$push150=, s2+8($pop285):p2align=3
	i32.ne  	$push151=, $4, $pop150
	br_if   	0, $pop151      # 0: down to label24
# BB#15:                                # %if.end32
	i32.const	$push289=, 0
	f64.load	$push130=, s2($pop289)
	f64.const	$push152=, 0x1.6p7
	f64.ne  	$push153=, $pop130, $pop152
	br_if   	0, $pop153      # 0: down to label24
# BB#16:                                # %if.end41
	i32.const	$push448=, 224
	i32.add 	$push449=, $5, $pop448
	i32.const	$push155=, 8
	i32.add 	$push156=, $pop449, $pop155
	i32.const	$push450=, 672
	i32.add 	$push451=, $5, $pop450
	i32.const	$push296=, 8
	i32.add 	$push295=, $pop451, $pop296
	tee_local	$push294=, $4=, $pop295
	i64.load	$push157=, 0($pop294)
	i64.store	$discard=, 0($pop156), $pop157
	i64.load	$push158=, 672($5)
	i64.store	$discard=, 224($5), $pop158
	i32.const	$push452=, 208
	i32.add 	$push453=, $5, $pop452
	i32.const	$push293=, 8
	i32.add 	$push159=, $pop453, $pop293
	i32.const	$push454=, 656
	i32.add 	$push455=, $5, $pop454
	i32.const	$push292=, 8
	i32.add 	$push160=, $pop455, $pop292
	i64.load	$push161=, 0($pop160)
	i64.store	$discard=, 0($pop159), $pop161
	i64.load	$push162=, 656($5)
	i64.store	$discard=, 208($5), $pop162
	i32.const	$push456=, 192
	i32.add 	$push457=, $5, $pop456
	i32.const	$push291=, 8
	i32.add 	$push163=, $pop457, $pop291
	i64.load	$push164=, 0($4)
	i64.store	$discard=, 0($pop163), $pop164
	i64.load	$push165=, 672($5)
	i64.store	$discard=, 192($5), $pop165
	i32.const	$push458=, 192
	i32.add 	$push459=, $5, $pop458
	i32.store	$discard=, 184($5):p2align=3, $pop459
	i32.const	$push460=, 208
	i32.add 	$push461=, $5, $pop460
	i32.store	$discard=, 180($5), $pop461
	i32.const	$push462=, 224
	i32.add 	$push463=, $5, $pop462
	i32.store	$discard=, 176($5):p2align=4, $pop463
	i32.const	$push166=, 3
	i32.const	$push464=, 176
	i32.add 	$push465=, $5, $pop464
	call    	f6@FUNCTION, $pop166, $pop465
	i32.const	$push290=, 0
	i32.load	$push167=, s2+8($pop290):p2align=3
	i32.const	$push168=, 138
	i32.ne  	$push169=, $pop167, $pop168
	br_if   	0, $pop169      # 0: down to label24
# BB#17:                                # %if.end41
	i32.const	$push297=, 0
	f64.load	$push154=, s2($pop297)
	f64.const	$push170=, 0x1p4
	f64.ne  	$push171=, $pop154, $pop170
	br_if   	0, $pop171      # 0: down to label24
# BB#18:                                # %if.end46
	i32.const	$push466=, 144
	i32.add 	$push467=, $5, $pop466
	i32.const	$push175=, 24
	i32.add 	$push176=, $pop467, $pop175
	i32.const	$push468=, 688
	i32.add 	$push469=, $5, $pop468
	i32.const	$push316=, 24
	i32.add 	$push177=, $pop469, $pop316
	i64.load	$push178=, 0($pop177)
	i64.store	$discard=, 0($pop176), $pop178
	i32.const	$push470=, 144
	i32.add 	$push471=, $5, $pop470
	i32.const	$push179=, 16
	i32.add 	$push180=, $pop471, $pop179
	i32.const	$push472=, 688
	i32.add 	$push473=, $5, $pop472
	i32.const	$push315=, 16
	i32.add 	$push181=, $pop473, $pop315
	i64.load	$push182=, 0($pop181)
	i64.store	$discard=, 0($pop180), $pop182
	i32.const	$push474=, 144
	i32.add 	$push475=, $5, $pop474
	i32.const	$push183=, 8
	i32.add 	$push184=, $pop475, $pop183
	i32.const	$push476=, 688
	i32.add 	$push477=, $5, $pop476
	i32.const	$push314=, 8
	i32.add 	$push185=, $pop477, $pop314
	i64.load	$push186=, 0($pop185)
	i64.store	$discard=, 0($pop184), $pop186
	i64.load	$push187=, 688($5)
	i64.store	$discard=, 144($5), $pop187
	i32.const	$push478=, 112
	i32.add 	$push479=, $5, $pop478
	i32.const	$push313=, 24
	i32.add 	$push188=, $pop479, $pop313
	i32.const	$push480=, 720
	i32.add 	$push481=, $5, $pop480
	i32.const	$push312=, 24
	i32.add 	$push311=, $pop481, $pop312
	tee_local	$push310=, $4=, $pop311
	i64.load	$push189=, 0($pop310)
	i64.store	$discard=, 0($pop188), $pop189
	i32.const	$push482=, 112
	i32.add 	$push483=, $5, $pop482
	i32.const	$push309=, 16
	i32.add 	$push190=, $pop483, $pop309
	i32.const	$push484=, 720
	i32.add 	$push485=, $5, $pop484
	i32.const	$push308=, 16
	i32.add 	$push307=, $pop485, $pop308
	tee_local	$push306=, $0=, $pop307
	i64.load	$push191=, 0($pop306)
	i64.store	$discard=, 0($pop190), $pop191
	i32.const	$push486=, 112
	i32.add 	$push487=, $5, $pop486
	i32.const	$push305=, 8
	i32.add 	$push192=, $pop487, $pop305
	i32.const	$push488=, 720
	i32.add 	$push489=, $5, $pop488
	i32.const	$push304=, 8
	i32.add 	$push303=, $pop489, $pop304
	tee_local	$push302=, $1=, $pop303
	i64.load	$push193=, 0($pop302)
	i64.store	$discard=, 0($pop192), $pop193
	i64.load	$push194=, 720($5)
	i64.store	$discard=, 112($5), $pop194
	i32.const	$push490=, 80
	i32.add 	$push491=, $5, $pop490
	i32.const	$push301=, 24
	i32.add 	$push195=, $pop491, $pop301
	i64.load	$push196=, 0($4)
	i64.store	$discard=, 0($pop195), $pop196
	i32.const	$push492=, 80
	i32.add 	$push493=, $5, $pop492
	i32.const	$push300=, 16
	i32.add 	$push197=, $pop493, $pop300
	i64.load	$push198=, 0($0)
	i64.store	$discard=, 0($pop197), $pop198
	i32.const	$push494=, 80
	i32.add 	$push495=, $5, $pop494
	i32.const	$push299=, 8
	i32.add 	$push199=, $pop495, $pop299
	i64.load	$push200=, 0($1)
	i64.store	$discard=, 0($pop199), $pop200
	i64.load	$push201=, 720($5)
	i64.store	$discard=, 80($5), $pop201
	i32.const	$push496=, 80
	i32.add 	$push497=, $5, $pop496
	i32.store	$discard=, 72($5):p2align=3, $pop497
	i32.const	$push498=, 112
	i32.add 	$push499=, $5, $pop498
	i32.store	$discard=, 68($5), $pop499
	i32.const	$push500=, 144
	i32.add 	$push501=, $5, $pop500
	i32.store	$discard=, 64($5):p2align=4, $pop501
	i32.const	$push202=, 2
	i32.const	$push502=, 64
	i32.add 	$push503=, $5, $pop502
	call    	f7@FUNCTION, $pop202, $pop503
	i32.const	$push298=, 0
	i32.load	$push203=, s1($pop298):p2align=3
	i32.const	$push204=, 131
	i32.ne  	$push205=, $pop203, $pop204
	br_if   	0, $pop205      # 0: down to label24
# BB#19:                                # %if.end46
	i32.const	$push317=, 0
	i32.load	$push172=, s1+16($pop317):p2align=3
	i32.const	$push206=, 254
	i32.ne  	$push207=, $pop172, $pop206
	br_if   	0, $pop207      # 0: down to label24
# BB#20:                                # %if.end46
	i32.const	$push318=, 0
	f64.load	$push173=, s1+8($pop318)
	f64.const	$push208=, 0x1.ep3
	f64.ne  	$push209=, $pop173, $pop208
	br_if   	0, $pop209      # 0: down to label24
# BB#21:                                # %if.end46
	i32.const	$push319=, 0
	f64.load	$push174=, s1+24($pop319)
	f64.const	$push210=, 0x1.64p7
	f64.ne  	$push211=, $pop174, $pop210
	br_if   	0, $pop211      # 0: down to label24
# BB#22:                                # %if.end55
	i32.const	$push320=, 0
	i32.load	$push212=, bar_arg($pop320)
	i32.const	$push213=, 131
	i32.ne  	$push214=, $pop212, $pop213
	br_if   	0, $pop214      # 0: down to label24
# BB#23:                                # %if.end58
	i32.const	$push504=, 48
	i32.add 	$push505=, $5, $pop504
	i32.const	$push216=, 8
	i32.add 	$push217=, $pop505, $pop216
	i32.const	$push506=, 656
	i32.add 	$push507=, $5, $pop506
	i32.const	$push327=, 8
	i32.add 	$push218=, $pop507, $pop327
	i64.load	$push219=, 0($pop218)
	i64.store	$discard=, 0($pop217), $pop219
	i64.load	$push220=, 656($5)
	i64.store	$discard=, 48($5), $pop220
	i32.const	$push508=, 32
	i32.add 	$push509=, $5, $pop508
	i32.const	$push326=, 8
	i32.add 	$push221=, $pop509, $pop326
	i32.const	$push510=, 672
	i32.add 	$push511=, $5, $pop510
	i32.const	$push325=, 8
	i32.add 	$push324=, $pop511, $pop325
	tee_local	$push323=, $4=, $pop324
	i64.load	$push222=, 0($pop323)
	i64.store	$discard=, 0($pop221), $pop222
	i64.load	$push223=, 672($5)
	i64.store	$discard=, 32($5), $pop223
	i32.const	$push512=, 16
	i32.add 	$push513=, $5, $pop512
	i32.const	$push322=, 8
	i32.add 	$push224=, $pop513, $pop322
	i64.load	$push225=, 0($4)
	i64.store	$discard=, 0($pop224), $pop225
	i64.load	$push226=, 672($5)
	i64.store	$discard=, 16($5), $pop226
	i32.const	$push514=, 16
	i32.add 	$push515=, $5, $pop514
	i32.store	$discard=, 8($5):p2align=3, $pop515
	i32.const	$push516=, 32
	i32.add 	$push517=, $5, $pop516
	i32.store	$discard=, 4($5), $pop517
	i32.const	$push518=, 48
	i32.add 	$push519=, $5, $pop518
	i32.store	$discard=, 0($5):p2align=4, $pop519
	i32.const	$push227=, 3
	call    	f8@FUNCTION, $pop227, $5
	i32.const	$push321=, 0
	i32.load	$push228=, s2+8($pop321):p2align=3
	i32.const	$push229=, 257
	i32.ne  	$push230=, $pop228, $pop229
	br_if   	0, $pop230      # 0: down to label24
# BB#24:                                # %if.end58
	i32.const	$push328=, 0
	f64.load	$push215=, s2($pop328)
	f64.const	$push231=, 0x1.6p7
	f64.ne  	$push232=, $pop215, $pop231
	br_if   	0, $pop232      # 0: down to label24
# BB#25:                                # %if.end63
	i32.const	$push233=, 0
	i32.const	$push335=, __stack_pointer
	i32.const	$push333=, 752
	i32.add 	$push334=, $5, $pop333
	i32.store	$discard=, 0($pop335), $pop334
	return  	$pop233
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
