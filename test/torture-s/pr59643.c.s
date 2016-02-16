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
	i32.const	$push14=, -1
	i32.add 	$push1=, $5, $pop14
	i32.const	$push2=, 2
	i32.lt_s	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push4=, -2
	i32.add 	$6=, $5, $pop4
	f64.load	$8=, 0($0)
	i32.const	$push5=, 16
	i32.add 	$5=, $0, $pop5
	f64.load	$7=, 8($0)
	i32.const	$push16=, 8
	i32.add 	$0=, $1, $pop16
	i32.const	$push15=, 8
	i32.add 	$2=, $2, $pop15
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push23=, -8
	i32.add 	$push13=, $5, $pop23
	f64.load	$push6=, 0($0)
	f64.load	$push7=, 0($2)
	f64.add 	$push8=, $pop6, $pop7
	f64.add 	$push9=, $pop8, $8
	f64.load	$push22=, 0($5)
	tee_local	$push21=, $9=, $pop22
	f64.add 	$push10=, $pop9, $pop21
	f64.mul 	$push11=, $pop10, $3
	f64.mul 	$push12=, $7, $4
	f64.add 	$push0=, $pop11, $pop12
	f64.store	$8=, 0($pop13), $pop0
	i32.const	$push20=, 8
	i32.add 	$0=, $0, $pop20
	i32.const	$push19=, 8
	i32.add 	$2=, $2, $pop19
	i32.const	$push18=, -1
	i32.add 	$6=, $6, $pop18
	i32.const	$push17=, 8
	i32.add 	$5=, $5, $pop17
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
	.local  	i32, i32, i32, i32, i32, f64, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 768
	i32.sub 	$14=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$14=, 0($7), $14
	i32.const	$3=, 0
	i32.const	$9=, 512
	i32.add 	$9=, $14, $9
	copy_local	$2=, $9
	i32.const	$10=, 256
	i32.add 	$10=, $14, $10
	copy_local	$1=, $10
	copy_local	$0=, $14
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push26=, 3
	i32.and 	$push0=, $3, $pop26
	f64.convert_s/i32	$push25=, $pop0
	tee_local	$push24=, $5=, $pop25
	f64.add 	$push1=, $pop24, $5
	f64.store	$discard=, 0($2), $pop1
	i32.const	$push23=, 7
	i32.and 	$push22=, $3, $pop23
	tee_local	$push21=, $4=, $pop22
	i32.const	$push20=, -4
	i32.add 	$push2=, $pop21, $pop20
	f64.convert_s/i32	$push3=, $pop2
	f64.store	$discard=, 0($1), $pop3
	f64.convert_s/i32	$push4=, $4
	f64.store	$discard=, 0($0), $pop4
	i32.const	$push19=, 1
	i32.add 	$3=, $3, $pop19
	i32.const	$push18=, 8
	i32.add 	$2=, $2, $pop18
	i32.const	$push17=, 8
	i32.add 	$1=, $1, $pop17
	i32.const	$push16=, 8
	i32.add 	$0=, $0, $pop16
	i32.const	$push15=, 32
	i32.ne  	$push5=, $3, $pop15
	br_if   	0, $pop5        # 0: up to label3
# BB#2:                                 # %for.end
	end_loop                        # label4:
	f64.const	$push8=, 0x1p1
	f64.const	$push7=, 0x1.8p1
	i32.const	$push6=, 32
	i32.const	$11=, 512
	i32.add 	$11=, $14, $11
	i32.const	$12=, 256
	i32.add 	$12=, $14, $12
	call    	foo@FUNCTION, $11, $12, $14, $pop8, $pop7, $pop6
	i32.const	$3=, 0
	i32.const	$2=, 0
.LBB1_3:                                # %for.body12
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label6:
	i32.const	$13=, 512
	i32.add 	$13=, $14, $13
	i32.add 	$push9=, $13, $3
	f64.load	$push10=, 0($pop9)
	f64.load	$push11=, expected($3)
	f64.ne  	$push12=, $pop10, $pop11
	br_if   	2, $pop12       # 2: down to label5
# BB#4:                                 # %for.cond9
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push29=, 1
	i32.add 	$2=, $2, $pop29
	i32.const	$push28=, 8
	i32.add 	$3=, $3, $pop28
	i32.const	$push27=, 31
	i32.le_s	$push13=, $2, $pop27
	br_if   	0, $pop13       # 0: up to label6
# BB#5:                                 # %for.end19
	end_loop                        # label7:
	i32.const	$push14=, 0
	i32.const	$8=, 768
	i32.add 	$14=, $14, $8
	i32.const	$8=, __stack_pointer
	i32.store	$14=, 0($8), $14
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
