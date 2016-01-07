	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/cmpdi-1.c"
	.globl	feq
	.type	feq,@function
feq:                                    # @feq
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i64.eq  	$push0=, $0, $1
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end0:
	.size	feq, .Lfunc_end0-feq

	.globl	fne
	.type	fne,@function
fne:                                    # @fne
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i64.eq  	$push0=, $0, $1
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end1:
	.size	fne, .Lfunc_end1-fne

	.globl	flt
	.type	flt,@function
flt:                                    # @flt
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i64.lt_s	$push0=, $0, $1
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end2:
	.size	flt, .Lfunc_end2-flt

	.globl	fge
	.type	fge,@function
fge:                                    # @fge
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i64.lt_s	$push0=, $0, $1
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end3:
	.size	fge, .Lfunc_end3-fge

	.globl	fgt
	.type	fgt,@function
fgt:                                    # @fgt
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i64.gt_s	$push0=, $0, $1
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end4:
	.size	fgt, .Lfunc_end4-fgt

	.globl	fle
	.type	fle,@function
fle:                                    # @fle
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i64.gt_s	$push0=, $0, $1
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end5:
	.size	fle, .Lfunc_end5-fle

	.globl	fltu
	.type	fltu,@function
fltu:                                   # @fltu
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i64.lt_u	$push0=, $0, $1
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end6:
	.size	fltu, .Lfunc_end6-fltu

	.globl	fgeu
	.type	fgeu,@function
fgeu:                                   # @fgeu
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i64.lt_u	$push0=, $0, $1
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end7:
	.size	fgeu, .Lfunc_end7-fgeu

	.globl	fgtu
	.type	fgtu,@function
fgtu:                                   # @fgtu
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i64.gt_u	$push0=, $0, $1
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end8:
	.size	fgtu, .Lfunc_end8-fgtu

	.globl	fleu
	.type	fleu,@function
fleu:                                   # @fleu
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i64.gt_u	$push0=, $0, $1
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end9:
	.size	fleu, .Lfunc_end9-fleu

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i32, i32, i32, i64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
	i32.const	$4=, correct_results
	copy_local	$0=, $6
.LBB10_1:                                 # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop .LBB10_2 Depth 2
	block   	.LBB10_24
	block   	.LBB10_23
	block   	.LBB10_22
	block   	.LBB10_21
	block   	.LBB10_20
	block   	.LBB10_19
	block   	.LBB10_18
	block   	.LBB10_17
	block   	.LBB10_16
	block   	.LBB10_15
	loop    	.LBB10_14
	i32.const	$2=, args
	i32.const	$push0=, 3
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push2=, $2, $pop1
	i64.load	$1=, 0($pop2)
	copy_local	$3=, $6
.LBB10_2:                                 # %for.body3
                                        #   Parent Loop .LBB10_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB10_13
	i64.load	$5=, 0($2)
	i64.eq  	$10=, $1, $5
	i32.const	$7=, 140
	i32.const	$8=, 13
	i32.select	$push3=, $10, $8, $7
	i32.load	$push4=, 0($4)
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, .LBB10_24
# BB#3:                                 # %if.end
                                        #   in Loop: Header=.LBB10_2 Depth=2
	i32.select	$push6=, $10, $7, $8
	i32.const	$push7=, 4
	i32.add 	$push8=, $4, $pop7
	i32.load	$push9=, 0($pop8)
	i32.ne  	$push10=, $pop6, $pop9
	br_if   	$pop10, .LBB10_23
# BB#4:                                 # %if.end10
                                        #   in Loop: Header=.LBB10_2 Depth=2
	i32.const	$10=, 8
	i64.lt_s	$9=, $1, $5
	i32.select	$push11=, $9, $8, $7
	i32.add 	$push12=, $4, $10
	i32.load	$push13=, 0($pop12)
	i32.ne  	$push14=, $pop11, $pop13
	br_if   	$pop14, .LBB10_22
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=.LBB10_2 Depth=2
	i32.select	$push15=, $9, $7, $8
	i32.const	$push16=, 12
	i32.add 	$push17=, $4, $pop16
	i32.load	$push18=, 0($pop17)
	i32.ne  	$push19=, $pop15, $pop18
	br_if   	$pop19, .LBB10_21
# BB#6:                                 # %if.end20
                                        #   in Loop: Header=.LBB10_2 Depth=2
	i64.gt_s	$9=, $1, $5
	i32.select	$push20=, $9, $8, $7
	i32.const	$push21=, 16
	i32.add 	$push22=, $4, $pop21
	i32.load	$push23=, 0($pop22)
	i32.ne  	$push24=, $pop20, $pop23
	br_if   	$pop24, .LBB10_20
# BB#7:                                 # %if.end25
                                        #   in Loop: Header=.LBB10_2 Depth=2
	i32.select	$push25=, $9, $7, $8
	i32.const	$push26=, 20
	i32.add 	$push27=, $4, $pop26
	i32.load	$push28=, 0($pop27)
	i32.ne  	$push29=, $pop25, $pop28
	br_if   	$pop29, .LBB10_19
# BB#8:                                 # %if.end30
                                        #   in Loop: Header=.LBB10_2 Depth=2
	i64.lt_u	$9=, $1, $5
	i32.select	$push30=, $9, $8, $7
	i32.const	$push31=, 24
	i32.add 	$push32=, $4, $pop31
	i32.load	$push33=, 0($pop32)
	i32.ne  	$push34=, $pop30, $pop33
	br_if   	$pop34, .LBB10_18
# BB#9:                                 # %if.end35
                                        #   in Loop: Header=.LBB10_2 Depth=2
	i32.select	$push35=, $9, $7, $8
	i32.const	$push36=, 28
	i32.add 	$push37=, $4, $pop36
	i32.load	$push38=, 0($pop37)
	i32.ne  	$push39=, $pop35, $pop38
	br_if   	$pop39, .LBB10_17
# BB#10:                                # %if.end40
                                        #   in Loop: Header=.LBB10_2 Depth=2
	i64.gt_u	$9=, $1, $5
	i32.select	$push40=, $9, $8, $7
	i32.const	$push41=, 32
	i32.add 	$push42=, $4, $pop41
	i32.load	$push43=, 0($pop42)
	i32.ne  	$push44=, $pop40, $pop43
	br_if   	$pop44, .LBB10_16
# BB#11:                                # %if.end45
                                        #   in Loop: Header=.LBB10_2 Depth=2
	i32.select	$push45=, $9, $7, $8
	i32.const	$push46=, 36
	i32.add 	$push47=, $4, $pop46
	i32.load	$push48=, 0($pop47)
	i32.ne  	$push49=, $pop45, $pop48
	br_if   	$pop49, .LBB10_15
# BB#12:                                # %if.end50
                                        #   in Loop: Header=.LBB10_2 Depth=2
	i32.const	$push50=, 40
	i32.add 	$4=, $4, $pop50
	i32.const	$7=, 1
	i32.add 	$3=, $3, $7
	i32.add 	$2=, $2, $10
	i32.lt_s	$push51=, $3, $10
	br_if   	$pop51, .LBB10_2
.LBB10_13:                                # %for.end
                                        #   in Loop: Header=.LBB10_1 Depth=1
	i32.add 	$0=, $0, $7
	i32.lt_s	$push52=, $0, $10
	br_if   	$pop52, .LBB10_1
.LBB10_14:                                # %for.end53
	i32.const	$push53=, 0
	call    	exit, $pop53
	unreachable
.LBB10_15:                                # %if.then49
	call    	abort
	unreachable
.LBB10_16:                                # %if.then44
	call    	abort
	unreachable
.LBB10_17:                                # %if.then39
	call    	abort
	unreachable
.LBB10_18:                                # %if.then34
	call    	abort
	unreachable
.LBB10_19:                                # %if.then29
	call    	abort
	unreachable
.LBB10_20:                                # %if.then24
	call    	abort
	unreachable
.LBB10_21:                                # %if.then19
	call    	abort
	unreachable
.LBB10_22:                                # %if.then14
	call    	abort
	unreachable
.LBB10_23:                                # %if.then9
	call    	abort
	unreachable
.LBB10_24:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end10:
	.size	main, .Lfunc_end10-main

	.type	args,@object            # @args
	.data
	.globl	args
	.align	4
args:
	.int64	0                       # 0x0
	.int64	1                       # 0x1
	.int64	-1                      # 0xffffffffffffffff
	.int64	9223372036854775807     # 0x7fffffffffffffff
	.int64	-9223372036854775808    # 0x8000000000000000
	.int64	-9223372036854775807    # 0x8000000000000001
	.int64	1891269347843992664     # 0x1a3f237394d36c58
	.int64	-7816825554603336956    # 0x93850e92caac1b04
	.size	args, 64

	.type	correct_results,@object # @correct_results
	.globl	correct_results
	.align	4
correct_results:
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.int32	140                     # 0x8c
	.int32	13                      # 0xd
	.size	correct_results, 2560


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
