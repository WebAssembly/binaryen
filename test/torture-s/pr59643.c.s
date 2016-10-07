	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59643.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, f64, f64, i32
	.local  	i32, i32, f64, f64
# BB#0:                                 # %entry
	block   	
	i32.const	$push13=, -1
	i32.add 	$push0=, $5, $pop13
	i32.const	$push1=, 2
	i32.lt_s	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push3=, 16
	i32.add 	$6=, $0, $pop3
	i32.const	$push4=, -2
	i32.add 	$7=, $5, $pop4
	i32.const	$push15=, 8
	i32.add 	$5=, $2, $pop15
	i32.const	$push14=, 8
	i32.add 	$1=, $1, $pop14
	f64.load	$8=, 8($0)
	f64.load	$9=, 0($0)
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push26=, -8
	i32.add 	$push12=, $6, $pop26
	f64.mul 	$push5=, $8, $4
	f64.load	$push7=, 0($1)
	f64.load	$push6=, 0($5)
	f64.add 	$push8=, $pop7, $pop6
	f64.add 	$push9=, $pop8, $9
	f64.load	$push25=, 0($6)
	tee_local	$push24=, $8=, $pop25
	f64.add 	$push10=, $pop9, $pop24
	f64.mul 	$push11=, $pop10, $3
	f64.add 	$push23=, $pop5, $pop11
	tee_local	$push22=, $9=, $pop23
	f64.store	0($pop12), $pop22
	i32.const	$push21=, 8
	i32.add 	$6=, $6, $pop21
	i32.const	$push20=, 8
	i32.add 	$5=, $5, $pop20
	i32.const	$push19=, 8
	i32.add 	$1=, $1, $pop19
	i32.const	$push18=, -1
	i32.add 	$push17=, $7, $pop18
	tee_local	$push16=, $7=, $pop17
	br_if   	0, $pop16       # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.const	$push16=, 0
	i32.load	$push17=, __stack_pointer($pop16)
	i32.const	$push18=, 768
	i32.sub 	$push34=, $pop17, $pop18
	tee_local	$push33=, $6=, $pop34
	i32.store	__stack_pointer($pop19), $pop33
	i32.const	$5=, 0
	i32.const	$push23=, 512
	i32.add 	$push24=, $6, $pop23
	copy_local	$4=, $pop24
	i32.const	$push25=, 256
	i32.add 	$push26=, $6, $pop25
	copy_local	$3=, $pop26
	copy_local	$2=, $6
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push48=, 7
	i32.and 	$push47=, $5, $pop48
	tee_local	$push46=, $0=, $pop47
	f64.convert_s/i32	$push0=, $pop46
	f64.store	0($2), $pop0
	i32.const	$push45=, -4
	i32.add 	$push1=, $0, $pop45
	f64.convert_s/i32	$push2=, $pop1
	f64.store	0($3), $pop2
	i32.const	$push44=, 3
	i32.and 	$push3=, $5, $pop44
	f64.convert_s/i32	$push43=, $pop3
	tee_local	$push42=, $1=, $pop43
	f64.add 	$push4=, $pop42, $1
	f64.store	0($4), $pop4
	i32.const	$push41=, 8
	i32.add 	$2=, $2, $pop41
	i32.const	$push40=, 8
	i32.add 	$3=, $3, $pop40
	i32.const	$push39=, 8
	i32.add 	$4=, $4, $pop39
	i32.const	$push38=, 1
	i32.add 	$push37=, $5, $pop38
	tee_local	$push36=, $5=, $pop37
	i32.const	$push35=, 32
	i32.ne  	$push5=, $pop36, $pop35
	br_if   	0, $pop5        # 0: up to label2
# BB#2:                                 # %for.end
	end_loop
	i32.const	$push27=, 512
	i32.add 	$push28=, $6, $pop27
	i32.const	$push29=, 256
	i32.add 	$push30=, $6, $pop29
	f64.const	$push8=, 0x1p1
	f64.const	$push7=, 0x1.8p1
	i32.const	$push6=, 32
	call    	foo@FUNCTION, $pop28, $pop30, $6, $pop8, $pop7, $pop6
	i32.const	$5=, 0
	i32.const	$4=, 0
.LBB1_3:                                # %for.body12
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	i32.const	$push31=, 512
	i32.add 	$push32=, $6, $pop31
	i32.add 	$push11=, $pop32, $5
	f64.load	$push12=, 0($pop11)
	i32.const	$push49=, expected
	i32.add 	$push9=, $5, $pop49
	f64.load	$push10=, 0($pop9)
	f64.ne  	$push13=, $pop12, $pop10
	br_if   	1, $pop13       # 1: down to label3
# BB#4:                                 # %for.cond9
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push54=, 8
	i32.add 	$5=, $5, $pop54
	i32.const	$push53=, 1
	i32.add 	$push52=, $4, $pop53
	tee_local	$push51=, $4=, $pop52
	i32.const	$push50=, 31
	i32.le_s	$push14=, $pop51, $pop50
	br_if   	0, $pop14       # 0: up to label4
# BB#5:                                 # %for.end19
	end_loop
	i32.const	$push22=, 0
	i32.const	$push20=, 768
	i32.add 	$push21=, $6, $pop20
	i32.store	__stack_pointer($pop22), $pop21
	i32.const	$push15=, 0
	return  	$pop15
.LBB1_6:                                # %if.then
	end_block                       # label3:
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
