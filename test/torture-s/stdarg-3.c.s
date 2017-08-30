	.text
	.file	"stdarg-3.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
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
                                        # -- End function
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
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
# BB#1:                                 # %while.body.lr.ph
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
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
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
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
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
                                        # -- End function
	.section	.text.f4,"ax",@progbits
	.hidden	f4                      # -- Begin function f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.load	$push10=, __stack_pointer($pop11)
	i32.const	$push12=, 16
	i32.sub 	$3=, $pop10, $pop12
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
	tee_local	$push14=, $1=, $pop15
	i32.const	$push8=, 8
	i32.add 	$2=, $pop14, $pop8
.LBB4_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label7:
	i32.const	$push24=, 0
	i64.load	$push4=, 0($1)
	i64.store	d($pop24), $pop4
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	f64.load	$push5=, d($pop22)
	f64.const	$push21=, 0x1p2
	f64.add 	$push6=, $pop5, $pop21
	i32.trunc_s/f64	$push7=, $pop6
	i32.store	bar_arg($pop23), $pop7
	i32.store	12($3), $2
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
                                        # -- End function
	.section	.text.f5,"ax",@progbits
	.hidden	f5                      # -- Begin function f5
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
                                        # -- End function
	.section	.text.f6,"ax",@progbits
	.hidden	f6                      # -- Begin function f6
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
                                        # -- End function
	.section	.text.f7,"ax",@progbits
	.hidden	f7                      # -- Begin function f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.load	$push14=, __stack_pointer($pop15)
	i32.const	$push16=, 16
	i32.sub 	$6=, $pop14, $pop16
	block   	
	i32.const	$push17=, 1
	i32.lt_s	$push0=, $0, $pop17
	br_if   	0, $pop0        # 0: down to label12
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push20=, 1
	i32.add 	$0=, $0, $pop20
	i32.const	$push1=, 7
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, -8
	i32.and 	$push19=, $pop2, $pop3
	tee_local	$push18=, $1=, $pop19
	i32.const	$push5=, 8
	i32.add 	$2=, $pop18, $pop5
	i32.const	$push7=, 16
	i32.add 	$3=, $1, $pop7
	i32.const	$push9=, 24
	i32.add 	$4=, $1, $pop9
	i32.const	$push12=, 32
	i32.add 	$5=, $1, $pop12
.LBB7_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label13:
	i32.const	$push30=, 0
	i64.load	$push4=, 0($1)
	i64.store	s1($pop30), $pop4
	i32.const	$push29=, 0
	i64.load	$push6=, 0($2)
	i64.store	s1+8($pop29), $pop6
	i32.const	$push28=, 0
	i64.load	$push8=, 0($3)
	i64.store	s1+16($pop28), $pop8
	i32.const	$push27=, 0
	i64.load	$push10=, 0($4)
	i64.store	s1+24($pop27), $pop10
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.load	$push11=, s1($pop25)
	i32.store	bar_arg($pop26), $pop11
	i32.store	12($6), $5
	i32.const	$push24=, -1
	i32.add 	$push23=, $0, $pop24
	tee_local	$push22=, $0=, $pop23
	i32.const	$push21=, 1
	i32.gt_s	$push13=, $pop22, $pop21
	br_if   	0, $pop13       # 0: up to label13
.LBB7_3:                                # %while.end
	end_loop
	end_block                       # label12:
                                        # fallthrough-return
	.endfunc
.Lfunc_end7:
	.size	f7, .Lfunc_end7-f7
                                        # -- End function
	.section	.text.f8,"ax",@progbits
	.hidden	f8                      # -- Begin function f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.load	$push11=, __stack_pointer($pop12)
	i32.const	$push13=, 16
	i32.sub 	$4=, $pop11, $pop13
	block   	
	i32.const	$push14=, 1
	i32.lt_s	$push0=, $0, $pop14
	br_if   	0, $pop0        # 0: down to label14
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push17=, 1
	i32.add 	$3=, $0, $pop17
	i32.const	$push1=, 7
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, -8
	i32.and 	$push16=, $pop2, $pop3
	tee_local	$push15=, $0=, $pop16
	i32.const	$push4=, 8
	i32.add 	$1=, $pop15, $pop4
	i32.const	$push9=, 20
	i32.add 	$2=, $0, $pop9
.LBB8_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label15:
	i32.const	$push26=, 0
	i64.load	$push5=, 0($1)
	i64.store	s2+8($pop26), $pop5
	i32.const	$push25=, 0
	i64.load	$push6=, 0($0)
	i64.store	s2($pop25), $pop6
	i32.const	$push24=, 0
	i32.load	$push7=, 16($0)
	i32.store	y($pop24), $pop7
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.load	$push8=, s2+8($pop22)
	i32.store	bar_arg($pop23), $pop8
	i32.store	12($4), $2
	i32.const	$push21=, -1
	i32.add 	$push20=, $3, $pop21
	tee_local	$push19=, $3=, $pop20
	i32.const	$push18=, 1
	i32.gt_s	$push10=, $pop19, $pop18
	br_if   	0, $pop10       # 0: up to label15
.LBB8_3:                                # %while.end
	end_loop
	end_block                       # label14:
                                        # fallthrough-return
	.endfunc
.Lfunc_end8:
	.size	f8, .Lfunc_end8-f8
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push200=, 0
	i32.const	$push198=, 0
	i32.load	$push197=, __stack_pointer($pop198)
	i32.const	$push199=, 752
	i32.sub 	$push378=, $pop197, $pop199
	tee_local	$push377=, $4=, $pop378
	i32.store	__stack_pointer($pop200), $pop377
	i32.const	$push204=, 624
	i32.add 	$push205=, $4, $pop204
	i32.const	$push376=, 24
	i32.add 	$push0=, $pop205, $pop376
	i64.const	$push1=, 55834574859
	i64.store	0($pop0), $pop1
	i32.const	$push206=, 624
	i32.add 	$push207=, $4, $pop206
	i32.const	$push375=, 16
	i32.add 	$push2=, $pop207, $pop375
	i64.const	$push3=, 38654705671
	i64.store	0($pop2), $pop3
	i64.const	$push4=, 21474836483
	i64.store	632($4), $pop4
	i64.const	$push5=, 8589934593
	i64.store	624($4), $pop5
	i32.const	$push6=, 7
	i32.const	$push208=, 624
	i32.add 	$push209=, $4, $pop208
	call    	f1@FUNCTION, $pop6, $pop209
	block   	
	i32.const	$push374=, 0
	i32.load	$push7=, x($pop374)
	i32.const	$push8=, 11
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label16
# BB#1:                                 # %if.end
	i32.const	$push10=, 608
	i32.add 	$push11=, $4, $pop10
	i64.const	$push12=, 4634204016564240384
	i64.store	0($pop11), $pop12
	i32.const	$push13=, 600
	i32.add 	$push14=, $4, $pop13
	i64.const	$push15=, 4629700416936869888
	i64.store	0($pop14), $pop15
	i32.const	$push16=, 592
	i32.add 	$push17=, $4, $pop16
	i64.const	$push18=, 4625196817309499392
	i64.store	0($pop17), $pop18
	i32.const	$push210=, 560
	i32.add 	$push211=, $4, $pop210
	i32.const	$push381=, 24
	i32.add 	$push19=, $pop211, $pop381
	i64.const	$push20=, 4620693217682128896
	i64.store	0($pop19), $pop20
	i32.const	$push212=, 560
	i32.add 	$push213=, $4, $pop212
	i32.const	$push380=, 16
	i32.add 	$push21=, $pop213, $pop380
	i64.const	$push22=, 4616189618054758400
	i64.store	0($pop21), $pop22
	i64.const	$push23=, 4611686018427387904
	i64.store	568($4), $pop23
	i64.const	$push24=, 4607182418800017408
	i64.store	560($4), $pop24
	i32.const	$push25=, 6
	i32.const	$push214=, 560
	i32.add 	$push215=, $4, $pop214
	call    	f2@FUNCTION, $pop25, $pop215
	i32.const	$push379=, 0
	f64.load	$push26=, d($pop379)
	f64.const	$push27=, 0x1p5
	f64.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label16
# BB#2:                                 # %if.end3
	i64.const	$push30=, 12884901889
	i64.store	544($4), $pop30
	i32.const	$push31=, 2
	i32.const	$push216=, 544
	i32.add 	$push217=, $4, $pop216
	call    	f3@FUNCTION, $pop31, $pop217
	i32.const	$push383=, 0
	i32.load	$push32=, bar_arg($pop383)
	i32.const	$push382=, 1
	i32.ne  	$push33=, $pop32, $pop382
	br_if   	0, $pop33       # 0: down to label16
# BB#3:                                 # %if.end3
	i32.const	$push385=, 0
	i32.load	$push29=, x($pop385)
	i32.const	$push384=, 1
	i32.ne  	$push34=, $pop29, $pop384
	br_if   	0, $pop34       # 0: down to label16
# BB#4:                                 # %if.end7
	i64.const	$push36=, 4626041242239631360
	i64.store	536($4), $pop36
	i64.const	$push37=, 4625478292286210048
	i64.store	528($4), $pop37
	i32.const	$push38=, 2
	i32.const	$push218=, 528
	i32.add 	$push219=, $4, $pop218
	call    	f4@FUNCTION, $pop38, $pop219
	i32.const	$push386=, 0
	i32.load	$push39=, bar_arg($pop386)
	i32.const	$push40=, 21
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label16
# BB#5:                                 # %if.end7
	i32.const	$push387=, 0
	f64.load	$push35=, d($pop387)
	f64.const	$push42=, 0x1.1p4
	f64.ne  	$push43=, $pop35, $pop42
	br_if   	0, $pop43       # 0: down to label16
# BB#6:                                 # %if.end12
	i32.const	$push47=, 251
	i32.store	736($4), $pop47
	i32.const	$push220=, 688
	i32.add 	$push221=, $4, $pop220
	i32.const	$push48=, 16
	i32.add 	$push409=, $pop221, $pop48
	tee_local	$push408=, $0=, $pop409
	i64.load	$push407=, 736($4)
	tee_local	$push406=, $1=, $pop407
	i64.store	0($pop408), $pop406
	i32.const	$push405=, 254
	i32.store	0($0), $pop405
	i32.const	$push222=, 688
	i32.add 	$push223=, $4, $pop222
	i32.const	$push49=, 8
	i32.add 	$push50=, $pop223, $pop49
	i64.const	$push51=, 4624633867356078080
	i64.store	0($pop50), $pop51
	i32.const	$push224=, 496
	i32.add 	$push225=, $4, $pop224
	i32.const	$push404=, 8
	i32.add 	$push52=, $pop225, $pop404
	i64.const	$push403=, 4624633867356078080
	i64.store	0($pop52), $pop403
	i32.const	$push226=, 496
	i32.add 	$push227=, $4, $pop226
	i32.const	$push53=, 24
	i32.add 	$push54=, $pop227, $pop53
	i64.const	$push55=, 4640924231633207296
	i64.store	0($pop54), $pop55
	i32.const	$push228=, 464
	i32.add 	$push229=, $4, $pop228
	i32.const	$push402=, 24
	i32.add 	$push56=, $pop229, $pop402
	i64.const	$push57=, 4640466834796052480
	i64.store	0($pop56), $pop57
	i32.const	$push230=, 464
	i32.add 	$push231=, $4, $pop230
	i32.const	$push401=, 8
	i32.add 	$push58=, $pop231, $pop401
	i64.const	$push400=, 4624633867356078080
	i64.store	0($pop58), $pop400
	i32.const	$push232=, 496
	i32.add 	$push233=, $4, $pop232
	i32.const	$push399=, 16
	i32.add 	$push59=, $pop233, $pop399
	i64.store	0($pop59), $1
	i32.const	$push234=, 464
	i32.add 	$push235=, $4, $pop234
	i32.const	$push398=, 16
	i32.add 	$push60=, $pop235, $pop398
	i64.load	$push61=, 0($0)
	i64.store	0($pop60), $pop61
	i64.const	$push397=, 4624633867356078080
	i64.store	728($4), $pop397
	i64.const	$push396=, 4640924231633207296
	i64.store	744($4), $pop396
	i64.const	$push395=, 4640466834796052480
	i64.store	712($4), $pop395
	i32.const	$push62=, 131
	i32.store	720($4), $pop62
	i64.load	$push394=, 720($4)
	tee_local	$push393=, $1=, $pop394
	i64.store	496($4), $pop393
	i64.store	464($4), $1
	i64.store	688($4), $1
	i32.const	$push236=, 432
	i32.add 	$push237=, $4, $pop236
	i32.const	$push392=, 24
	i32.add 	$push63=, $pop237, $pop392
	i64.load	$push64=, 744($4)
	i64.store	0($pop63), $pop64
	i32.const	$push238=, 432
	i32.add 	$push239=, $4, $pop238
	i32.const	$push391=, 16
	i32.add 	$push65=, $pop239, $pop391
	i64.load	$push66=, 736($4)
	i64.store	0($pop65), $pop66
	i32.const	$push240=, 432
	i32.add 	$push241=, $4, $pop240
	i32.const	$push390=, 8
	i32.add 	$push67=, $pop241, $pop390
	i64.load	$push68=, 728($4)
	i64.store	0($pop67), $pop68
	i64.load	$push69=, 720($4)
	i64.store	432($4), $pop69
	i32.const	$push242=, 432
	i32.add 	$push243=, $4, $pop242
	i32.store	424($4), $pop243
	i32.const	$push244=, 464
	i32.add 	$push245=, $4, $pop244
	i32.store	420($4), $pop245
	i32.const	$push246=, 496
	i32.add 	$push247=, $4, $pop246
	i32.store	416($4), $pop247
	i32.const	$push70=, 2
	i32.const	$push248=, 416
	i32.add 	$push249=, $4, $pop248
	call    	f5@FUNCTION, $pop70, $pop249
	i32.const	$push389=, 0
	i32.load	$push71=, s1($pop389)
	i32.const	$push388=, 131
	i32.ne  	$push72=, $pop71, $pop388
	br_if   	0, $pop72       # 0: down to label16
# BB#7:                                 # %if.end12
	i32.const	$push411=, 0
	i32.load	$push44=, s1+16($pop411)
	i32.const	$push410=, 254
	i32.ne  	$push73=, $pop44, $pop410
	br_if   	0, $pop73       # 0: down to label16
# BB#8:                                 # %if.end12
	i32.const	$push412=, 0
	f64.load	$push45=, s1+8($pop412)
	f64.const	$push74=, 0x1.ep3
	f64.ne  	$push75=, $pop45, $pop74
	br_if   	0, $pop75       # 0: down to label16
# BB#9:                                 # %if.end12
	i32.const	$push413=, 0
	f64.load	$push46=, s1+24($pop413)
	f64.const	$push76=, 0x1.64p7
	f64.ne  	$push77=, $pop46, $pop76
	br_if   	0, $pop77       # 0: down to label16
# BB#10:                                # %if.end23
	i32.const	$push250=, 384
	i32.add 	$push251=, $4, $pop250
	i32.const	$push81=, 24
	i32.add 	$push82=, $pop251, $pop81
	i32.const	$push252=, 720
	i32.add 	$push253=, $4, $pop252
	i32.const	$push434=, 24
	i32.add 	$push83=, $pop253, $pop434
	i64.load	$push433=, 0($pop83)
	tee_local	$push432=, $1=, $pop433
	i64.store	0($pop82), $pop432
	i32.const	$push254=, 384
	i32.add 	$push255=, $4, $pop254
	i32.const	$push84=, 16
	i32.add 	$push85=, $pop255, $pop84
	i32.const	$push256=, 720
	i32.add 	$push257=, $4, $pop256
	i32.const	$push431=, 16
	i32.add 	$push86=, $pop257, $pop431
	i64.load	$push430=, 0($pop86)
	tee_local	$push429=, $2=, $pop430
	i64.store	0($pop85), $pop429
	i32.const	$push258=, 384
	i32.add 	$push259=, $4, $pop258
	i32.const	$push87=, 8
	i32.add 	$push88=, $pop259, $pop87
	i32.const	$push260=, 720
	i32.add 	$push261=, $4, $pop260
	i32.const	$push428=, 8
	i32.add 	$push89=, $pop261, $pop428
	i64.load	$push427=, 0($pop89)
	tee_local	$push426=, $3=, $pop427
	i64.store	0($pop88), $pop426
	i32.const	$push262=, 352
	i32.add 	$push263=, $4, $pop262
	i32.const	$push425=, 8
	i32.add 	$push90=, $pop263, $pop425
	i32.const	$push264=, 688
	i32.add 	$push265=, $4, $pop264
	i32.const	$push424=, 8
	i32.add 	$push91=, $pop265, $pop424
	i64.load	$push92=, 0($pop91)
	i64.store	0($pop90), $pop92
	i32.const	$push266=, 352
	i32.add 	$push267=, $4, $pop266
	i32.const	$push423=, 16
	i32.add 	$push93=, $pop267, $pop423
	i32.const	$push268=, 688
	i32.add 	$push269=, $4, $pop268
	i32.const	$push422=, 16
	i32.add 	$push94=, $pop269, $pop422
	i64.load	$push95=, 0($pop94)
	i64.store	0($pop93), $pop95
	i32.const	$push270=, 352
	i32.add 	$push271=, $4, $pop270
	i32.const	$push421=, 24
	i32.add 	$push96=, $pop271, $pop421
	i32.const	$push272=, 688
	i32.add 	$push273=, $4, $pop272
	i32.const	$push420=, 24
	i32.add 	$push97=, $pop273, $pop420
	i64.load	$push98=, 0($pop97)
	i64.store	0($pop96), $pop98
	i32.const	$push274=, 320
	i32.add 	$push275=, $4, $pop274
	i32.const	$push419=, 8
	i32.add 	$push99=, $pop275, $pop419
	i64.store	0($pop99), $3
	i32.const	$push276=, 320
	i32.add 	$push277=, $4, $pop276
	i32.const	$push418=, 16
	i32.add 	$push100=, $pop277, $pop418
	i64.store	0($pop100), $2
	i32.const	$push278=, 320
	i32.add 	$push279=, $4, $pop278
	i32.const	$push417=, 24
	i32.add 	$push101=, $pop279, $pop417
	i64.store	0($pop101), $1
	i64.load	$push416=, 720($4)
	tee_local	$push415=, $1=, $pop416
	i64.store	384($4), $pop415
	i64.load	$push102=, 688($4)
	i64.store	352($4), $pop102
	i64.store	320($4), $1
	i32.const	$push280=, 320
	i32.add 	$push281=, $4, $pop280
	i32.store	312($4), $pop281
	i32.const	$push282=, 352
	i32.add 	$push283=, $4, $pop282
	i32.store	308($4), $pop283
	i32.const	$push284=, 384
	i32.add 	$push285=, $4, $pop284
	i32.store	304($4), $pop285
	i32.const	$push103=, 3
	i32.const	$push286=, 304
	i32.add 	$push287=, $4, $pop286
	call    	f5@FUNCTION, $pop103, $pop287
	i32.const	$push414=, 0
	i32.load	$push104=, s1($pop414)
	i32.const	$push105=, 131
	i32.ne  	$push106=, $pop104, $pop105
	br_if   	0, $pop106      # 0: down to label16
# BB#11:                                # %if.end23
	i32.const	$push435=, 0
	i32.load	$push78=, s1+16($pop435)
	i32.const	$push107=, 251
	i32.ne  	$push108=, $pop78, $pop107
	br_if   	0, $pop108      # 0: down to label16
# BB#12:                                # %if.end23
	i32.const	$push436=, 0
	f64.load	$push79=, s1+8($pop436)
	f64.const	$push109=, 0x1.ep3
	f64.ne  	$push110=, $pop79, $pop109
	br_if   	0, $pop110      # 0: down to label16
# BB#13:                                # %if.end23
	i32.const	$push437=, 0
	f64.load	$push80=, s1+24($pop437)
	f64.const	$push111=, 0x1.7ep7
	f64.ne  	$push112=, $pop80, $pop111
	br_if   	0, $pop112      # 0: down to label16
# BB#14:                                # %if.end32
	i32.const	$push114=, 138
	i32.store	680($4), $pop114
	i32.const	$push288=, 288
	i32.add 	$push289=, $4, $pop288
	i32.const	$push115=, 8
	i32.add 	$push116=, $pop289, $pop115
	i64.load	$push446=, 680($4)
	tee_local	$push445=, $1=, $pop446
	i64.store	0($pop116), $pop445
	i32.const	$push117=, 257
	i32.store	664($4), $pop117
	i32.const	$push290=, 272
	i32.add 	$push291=, $4, $pop290
	i32.const	$push444=, 8
	i32.add 	$push118=, $pop291, $pop444
	i64.load	$push119=, 664($4)
	i64.store	0($pop118), $pop119
	i32.const	$push292=, 256
	i32.add 	$push293=, $4, $pop292
	i32.const	$push443=, 8
	i32.add 	$push120=, $pop293, $pop443
	i64.store	0($pop120), $1
	i64.const	$push121=, 4625196817309499392
	i64.store	672($4), $pop121
	i64.const	$push122=, 4640396466051874816
	i64.store	656($4), $pop122
	i64.const	$push442=, 4625196817309499392
	i64.store	288($4), $pop442
	i64.const	$push441=, 4640396466051874816
	i64.store	272($4), $pop441
	i64.const	$push440=, 4625196817309499392
	i64.store	256($4), $pop440
	i32.const	$push294=, 256
	i32.add 	$push295=, $4, $pop294
	i32.store	248($4), $pop295
	i32.const	$push296=, 272
	i32.add 	$push297=, $4, $pop296
	i32.store	244($4), $pop297
	i32.const	$push298=, 288
	i32.add 	$push299=, $4, $pop298
	i32.store	240($4), $pop299
	i32.const	$push123=, 2
	i32.const	$push300=, 240
	i32.add 	$push301=, $4, $pop300
	call    	f6@FUNCTION, $pop123, $pop301
	i32.const	$push439=, 0
	i32.load	$push124=, s2+8($pop439)
	i32.const	$push438=, 257
	i32.ne  	$push125=, $pop124, $pop438
	br_if   	0, $pop125      # 0: down to label16
# BB#15:                                # %if.end32
	i32.const	$push447=, 0
	f64.load	$push113=, s2($pop447)
	f64.const	$push126=, 0x1.6p7
	f64.ne  	$push127=, $pop113, $pop126
	br_if   	0, $pop127      # 0: down to label16
# BB#16:                                # %if.end41
	i32.const	$push302=, 224
	i32.add 	$push303=, $4, $pop302
	i32.const	$push129=, 8
	i32.add 	$push130=, $pop303, $pop129
	i32.const	$push304=, 672
	i32.add 	$push305=, $4, $pop304
	i32.const	$push456=, 8
	i32.add 	$push131=, $pop305, $pop456
	i64.load	$push455=, 0($pop131)
	tee_local	$push454=, $1=, $pop455
	i64.store	0($pop130), $pop454
	i32.const	$push306=, 208
	i32.add 	$push307=, $4, $pop306
	i32.const	$push453=, 8
	i32.add 	$push132=, $pop307, $pop453
	i32.const	$push308=, 656
	i32.add 	$push309=, $4, $pop308
	i32.const	$push452=, 8
	i32.add 	$push133=, $pop309, $pop452
	i64.load	$push134=, 0($pop133)
	i64.store	0($pop132), $pop134
	i32.const	$push310=, 192
	i32.add 	$push311=, $4, $pop310
	i32.const	$push451=, 8
	i32.add 	$push135=, $pop311, $pop451
	i64.store	0($pop135), $1
	i64.load	$push450=, 672($4)
	tee_local	$push449=, $1=, $pop450
	i64.store	224($4), $pop449
	i64.load	$push136=, 656($4)
	i64.store	208($4), $pop136
	i64.store	192($4), $1
	i32.const	$push312=, 192
	i32.add 	$push313=, $4, $pop312
	i32.store	184($4), $pop313
	i32.const	$push314=, 208
	i32.add 	$push315=, $4, $pop314
	i32.store	180($4), $pop315
	i32.const	$push316=, 224
	i32.add 	$push317=, $4, $pop316
	i32.store	176($4), $pop317
	i32.const	$push137=, 3
	i32.const	$push318=, 176
	i32.add 	$push319=, $4, $pop318
	call    	f6@FUNCTION, $pop137, $pop319
	i32.const	$push448=, 0
	i32.load	$push138=, s2+8($pop448)
	i32.const	$push139=, 138
	i32.ne  	$push140=, $pop138, $pop139
	br_if   	0, $pop140      # 0: down to label16
# BB#17:                                # %if.end41
	i32.const	$push457=, 0
	f64.load	$push128=, s2($pop457)
	f64.const	$push141=, 0x1p4
	f64.ne  	$push142=, $pop128, $pop141
	br_if   	0, $pop142      # 0: down to label16
# BB#18:                                # %if.end46
	i32.const	$push320=, 144
	i32.add 	$push321=, $4, $pop320
	i32.const	$push146=, 24
	i32.add 	$push147=, $pop321, $pop146
	i32.const	$push322=, 688
	i32.add 	$push323=, $4, $pop322
	i32.const	$push478=, 24
	i32.add 	$push148=, $pop323, $pop478
	i64.load	$push149=, 0($pop148)
	i64.store	0($pop147), $pop149
	i32.const	$push324=, 144
	i32.add 	$push325=, $4, $pop324
	i32.const	$push150=, 16
	i32.add 	$push151=, $pop325, $pop150
	i32.const	$push326=, 688
	i32.add 	$push327=, $4, $pop326
	i32.const	$push477=, 16
	i32.add 	$push152=, $pop327, $pop477
	i64.load	$push153=, 0($pop152)
	i64.store	0($pop151), $pop153
	i32.const	$push328=, 144
	i32.add 	$push329=, $4, $pop328
	i32.const	$push154=, 8
	i32.add 	$push155=, $pop329, $pop154
	i32.const	$push330=, 688
	i32.add 	$push331=, $4, $pop330
	i32.const	$push476=, 8
	i32.add 	$push156=, $pop331, $pop476
	i64.load	$push157=, 0($pop156)
	i64.store	0($pop155), $pop157
	i32.const	$push332=, 112
	i32.add 	$push333=, $4, $pop332
	i32.const	$push475=, 8
	i32.add 	$push158=, $pop333, $pop475
	i32.const	$push334=, 720
	i32.add 	$push335=, $4, $pop334
	i32.const	$push474=, 8
	i32.add 	$push159=, $pop335, $pop474
	i64.load	$push473=, 0($pop159)
	tee_local	$push472=, $1=, $pop473
	i64.store	0($pop158), $pop472
	i32.const	$push336=, 112
	i32.add 	$push337=, $4, $pop336
	i32.const	$push471=, 16
	i32.add 	$push160=, $pop337, $pop471
	i32.const	$push338=, 720
	i32.add 	$push339=, $4, $pop338
	i32.const	$push470=, 16
	i32.add 	$push161=, $pop339, $pop470
	i64.load	$push469=, 0($pop161)
	tee_local	$push468=, $2=, $pop469
	i64.store	0($pop160), $pop468
	i32.const	$push340=, 112
	i32.add 	$push341=, $4, $pop340
	i32.const	$push467=, 24
	i32.add 	$push162=, $pop341, $pop467
	i32.const	$push342=, 720
	i32.add 	$push343=, $4, $pop342
	i32.const	$push466=, 24
	i32.add 	$push163=, $pop343, $pop466
	i64.load	$push465=, 0($pop163)
	tee_local	$push464=, $3=, $pop465
	i64.store	0($pop162), $pop464
	i32.const	$push344=, 80
	i32.add 	$push345=, $4, $pop344
	i32.const	$push463=, 8
	i32.add 	$push164=, $pop345, $pop463
	i64.store	0($pop164), $1
	i32.const	$push346=, 80
	i32.add 	$push347=, $4, $pop346
	i32.const	$push462=, 16
	i32.add 	$push165=, $pop347, $pop462
	i64.store	0($pop165), $2
	i32.const	$push348=, 80
	i32.add 	$push349=, $4, $pop348
	i32.const	$push461=, 24
	i32.add 	$push166=, $pop349, $pop461
	i64.store	0($pop166), $3
	i64.load	$push167=, 688($4)
	i64.store	144($4), $pop167
	i64.load	$push460=, 720($4)
	tee_local	$push459=, $1=, $pop460
	i64.store	112($4), $pop459
	i64.store	80($4), $1
	i32.const	$push350=, 80
	i32.add 	$push351=, $4, $pop350
	i32.store	72($4), $pop351
	i32.const	$push352=, 112
	i32.add 	$push353=, $4, $pop352
	i32.store	68($4), $pop353
	i32.const	$push354=, 144
	i32.add 	$push355=, $4, $pop354
	i32.store	64($4), $pop355
	i32.const	$push168=, 2
	i32.const	$push356=, 64
	i32.add 	$push357=, $4, $pop356
	call    	f7@FUNCTION, $pop168, $pop357
	i32.const	$push458=, 0
	i32.load	$push169=, s1($pop458)
	i32.const	$push170=, 131
	i32.ne  	$push171=, $pop169, $pop170
	br_if   	0, $pop171      # 0: down to label16
# BB#19:                                # %if.end46
	i32.const	$push479=, 0
	i32.load	$push143=, s1+16($pop479)
	i32.const	$push172=, 254
	i32.ne  	$push173=, $pop143, $pop172
	br_if   	0, $pop173      # 0: down to label16
# BB#20:                                # %if.end46
	i32.const	$push480=, 0
	f64.load	$push144=, s1+8($pop480)
	f64.const	$push174=, 0x1.ep3
	f64.ne  	$push175=, $pop144, $pop174
	br_if   	0, $pop175      # 0: down to label16
# BB#21:                                # %if.end46
	i32.const	$push481=, 0
	f64.load	$push145=, s1+24($pop481)
	f64.const	$push176=, 0x1.64p7
	f64.ne  	$push177=, $pop145, $pop176
	br_if   	0, $pop177      # 0: down to label16
# BB#22:                                # %if.end55
	i32.const	$push482=, 0
	i32.load	$push178=, bar_arg($pop482)
	i32.const	$push179=, 131
	i32.ne  	$push180=, $pop178, $pop179
	br_if   	0, $pop180      # 0: down to label16
# BB#23:                                # %if.end58
	i32.const	$push358=, 48
	i32.add 	$push359=, $4, $pop358
	i32.const	$push182=, 8
	i32.add 	$push183=, $pop359, $pop182
	i32.const	$push360=, 656
	i32.add 	$push361=, $4, $pop360
	i32.const	$push491=, 8
	i32.add 	$push184=, $pop361, $pop491
	i64.load	$push185=, 0($pop184)
	i64.store	0($pop183), $pop185
	i32.const	$push362=, 32
	i32.add 	$push363=, $4, $pop362
	i32.const	$push490=, 8
	i32.add 	$push186=, $pop363, $pop490
	i32.const	$push364=, 672
	i32.add 	$push365=, $4, $pop364
	i32.const	$push489=, 8
	i32.add 	$push187=, $pop365, $pop489
	i64.load	$push488=, 0($pop187)
	tee_local	$push487=, $1=, $pop488
	i64.store	0($pop186), $pop487
	i32.const	$push366=, 16
	i32.add 	$push367=, $4, $pop366
	i32.const	$push486=, 8
	i32.add 	$push188=, $pop367, $pop486
	i64.store	0($pop188), $1
	i64.load	$push189=, 656($4)
	i64.store	48($4), $pop189
	i64.load	$push485=, 672($4)
	tee_local	$push484=, $1=, $pop485
	i64.store	32($4), $pop484
	i64.store	16($4), $1
	i32.const	$push368=, 16
	i32.add 	$push369=, $4, $pop368
	i32.store	8($4), $pop369
	i32.const	$push370=, 32
	i32.add 	$push371=, $4, $pop370
	i32.store	4($4), $pop371
	i32.const	$push372=, 48
	i32.add 	$push373=, $4, $pop372
	i32.store	0($4), $pop373
	i32.const	$push190=, 3
	call    	f8@FUNCTION, $pop190, $4
	i32.const	$push483=, 0
	i32.load	$push191=, s2+8($pop483)
	i32.const	$push192=, 257
	i32.ne  	$push193=, $pop191, $pop192
	br_if   	0, $pop193      # 0: down to label16
# BB#24:                                # %if.end58
	i32.const	$push492=, 0
	f64.load	$push181=, s2($pop492)
	f64.const	$push194=, 0x1.6p7
	f64.ne  	$push195=, $pop181, $pop194
	br_if   	0, $pop195      # 0: down to label16
# BB#25:                                # %if.end63
	i32.const	$push203=, 0
	i32.const	$push201=, 752
	i32.add 	$push202=, $4, $pop201
	i32.store	__stack_pointer($pop203), $pop202
	i32.const	$push196=, 0
	return  	$pop196
.LBB9_26:                               # %if.then
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end9:
	.size	main, .Lfunc_end9-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
