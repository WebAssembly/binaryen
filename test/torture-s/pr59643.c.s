	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59643.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, f64, f64, i32
	.local  	i32, f64, f64, f64
# BB#0:                                 # %entry
	block
	i32.const	$push13=, -1
	i32.add 	$push0=, $5, $pop13
	i32.const	$push1=, 2
	i32.lt_s	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push3=, -2
	i32.add 	$6=, $5, $pop3
	f64.load	$8=, 0($0)
	i32.const	$push4=, 16
	i32.add 	$5=, $0, $pop4
	f64.load	$7=, 8($0)
	i32.const	$push15=, 8
	i32.add 	$0=, $1, $pop15
	i32.const	$push14=, 8
	i32.add 	$1=, $2, $pop14
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push24=, -8
	i32.add 	$push12=, $5, $pop24
	f64.load	$push5=, 0($0)
	f64.load	$push6=, 0($1)
	f64.add 	$push7=, $pop5, $pop6
	f64.add 	$push8=, $pop7, $8
	f64.load	$push23=, 0($5)
	tee_local	$push22=, $9=, $pop23
	f64.add 	$push9=, $pop8, $pop22
	f64.mul 	$push10=, $pop9, $3
	f64.mul 	$push11=, $7, $4
	f64.add 	$push21=, $pop10, $pop11
	tee_local	$push20=, $8=, $pop21
	f64.store	$drop=, 0($pop12), $pop20
	i32.const	$push19=, 8
	i32.add 	$0=, $0, $pop19
	i32.const	$push18=, 8
	i32.add 	$1=, $1, $pop18
	i32.const	$push17=, -1
	i32.add 	$6=, $6, $pop17
	i32.const	$push16=, 8
	i32.add 	$5=, $5, $pop16
	copy_local	$7=, $9
	br_if   	0, $6           # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, f64
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$push18=, __stack_pointer
	i32.const	$push15=, __stack_pointer
	i32.load	$push16=, 0($pop15)
	i32.const	$push17=, 768
	i32.sub 	$push32=, $pop16, $pop17
	i32.store	$push34=, 0($pop18), $pop32
	tee_local	$push33=, $4=, $pop34
	i32.const	$push22=, 512
	i32.add 	$push23=, $pop33, $pop22
	copy_local	$2=, $pop23
	i32.const	$push24=, 256
	i32.add 	$push25=, $4, $pop24
	copy_local	$1=, $pop25
	copy_local	$0=, $4
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push46=, 3
	i32.and 	$push0=, $3, $pop46
	f64.convert_s/i32	$push45=, $pop0
	tee_local	$push44=, $6=, $pop45
	f64.add 	$push1=, $pop44, $6
	f64.store	$drop=, 0($2), $pop1
	i32.const	$push43=, 7
	i32.and 	$push42=, $3, $pop43
	tee_local	$push41=, $5=, $pop42
	i32.const	$push40=, -4
	i32.add 	$push2=, $pop41, $pop40
	f64.convert_s/i32	$push3=, $pop2
	f64.store	$drop=, 0($1), $pop3
	f64.convert_s/i32	$push4=, $5
	f64.store	$drop=, 0($0), $pop4
	i32.const	$push39=, 1
	i32.add 	$3=, $3, $pop39
	i32.const	$push38=, 8
	i32.add 	$2=, $2, $pop38
	i32.const	$push37=, 8
	i32.add 	$1=, $1, $pop37
	i32.const	$push36=, 8
	i32.add 	$0=, $0, $pop36
	i32.const	$push35=, 32
	i32.ne  	$push5=, $3, $pop35
	br_if   	0, $pop5        # 0: up to label3
# BB#2:                                 # %for.end
	end_loop                        # label4:
	i32.const	$push26=, 512
	i32.add 	$push27=, $4, $pop26
	i32.const	$push28=, 256
	i32.add 	$push29=, $4, $pop28
	f64.const	$push8=, 0x1p1
	f64.const	$push7=, 0x1.8p1
	i32.const	$push6=, 32
	call    	foo@FUNCTION, $pop27, $pop29, $4, $pop8, $pop7, $pop6
	i32.const	$3=, 0
	i32.const	$2=, 0
.LBB1_3:                                # %for.body12
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label6:
	i32.const	$push30=, 512
	i32.add 	$push31=, $4, $pop30
	i32.add 	$push9=, $pop31, $3
	f64.load	$push10=, 0($pop9)
	f64.load	$push11=, expected($3)
	f64.ne  	$push12=, $pop10, $pop11
	br_if   	2, $pop12       # 2: down to label5
# BB#4:                                 # %for.cond9
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push49=, 1
	i32.add 	$2=, $2, $pop49
	i32.const	$push48=, 8
	i32.add 	$3=, $3, $pop48
	i32.const	$push47=, 31
	i32.le_s	$push13=, $2, $pop47
	br_if   	0, $pop13       # 0: up to label6
# BB#5:                                 # %for.end19
	end_loop                        # label7:
	i32.const	$push21=, __stack_pointer
	i32.const	$push19=, 768
	i32.add 	$push20=, $4, $pop19
	i32.store	$drop=, 0($pop21), $pop20
	i32.const	$push14=, 0
	return  	$pop14
.LBB1_6:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	expected                # @expected
	.type	expected,@object
	.section	.data.expected,"aw",@progbits
	.globl	expected
	.p2align	4
expected:
	.int64	0                       # double 0
	.int64	4621819117588971520     # double 10
	.int64	4631389266797133824     # double 44
	.int64	4637440978796412928     # double 110
	.int64	4642366790888849408     # double 232
	.int64	4647327787353374720     # double 490
	.int64	4652183230701633536     # double 1020
	.int64	4656787985398759424     # double 2078
	.int64	4661287186979618816     # double 4152
	.int64	4665796284165128192     # double 8314
	.int64	4670306480862265344     # double 16652
	.int64	4674813104146612224     # double 33326
	.int64	4679317528407703552     # double 66664
	.int64	4683822021388271616     # double 133354
	.int64	4688326308210409472     # double 266748
	.int64	4692830234255294464     # double 533534
	.int64	4697333816702795776     # double 1067064
	.int64	4701837437805002752     # double 2134138
	.int64	4706341063202177024     # double 4268300
	.int64	4710844674640707584     # double 8536622
	.int64	4715348277489303552     # double 17073256
	.int64	4719851880606334976     # double 34146538
	.int64	4724355482918060032     # double 68293116
	.int64	4728859083820498944     # double 136586270
	.int64	4733362683380760576     # double 273172536
	.int64	4737866283092017152     # double 546345082
	.int64	4742369882820050944     # double 1092690188
	.int64	4746873482493558784     # double 2185380398
	.int64	4751377082133512192     # double 4370760808
	.int64	4755880681774514176     # double 8741521642
	.int64	4760384281412370432     # double 17483043324
	.int64	4618441417868443648     # double 6
	.size	expected, 256


	.ident	"clang version 3.9.0 "
