	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/cmpsf-1.c"
	.globl	feq
	.type	feq,@function
feq:                                    # @feq
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.eq  	$push0=, $0, $1
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end0:
	.size	feq, func_end0-feq

	.globl	fne
	.type	fne,@function
fne:                                    # @fne
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.ne  	$push0=, $0, $1
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end1:
	.size	fne, func_end1-fne

	.globl	flt
	.type	flt,@function
flt:                                    # @flt
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.lt  	$push0=, $0, $1
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end2:
	.size	flt, func_end2-flt

	.globl	fge
	.type	fge,@function
fge:                                    # @fge
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.lt  	$push0=, $0, $1
	f32.ne  	$push2=, $0, $0
	f32.ne  	$push1=, $1, $1
	i32.or  	$push3=, $pop2, $pop1
	i32.or  	$push4=, $pop0, $pop3
	i32.const	$push6=, 140
	i32.const	$push5=, 13
	i32.select	$push7=, $pop4, $pop6, $pop5
	return  	$pop7
func_end3:
	.size	fge, func_end3-fge

	.globl	fgt
	.type	fgt,@function
fgt:                                    # @fgt
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.gt  	$push0=, $0, $1
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end4:
	.size	fgt, func_end4-fgt

	.globl	fle
	.type	fle,@function
fle:                                    # @fle
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	f32.gt  	$push0=, $0, $1
	f32.ne  	$push2=, $0, $0
	f32.ne  	$push1=, $1, $1
	i32.or  	$push3=, $pop2, $pop1
	i32.or  	$push4=, $pop0, $pop3
	i32.const	$push6=, 140
	i32.const	$push5=, 13
	i32.select	$push7=, $pop4, $pop6, $pop5
	return  	$pop7
func_end5:
	.size	fle, func_end5-fle

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f32, i32, i32, i32, f32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
	i32.const	$4=, correct_results
	copy_local	$0=, $6
BB6_1:                                  # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_2 Depth 2
	block   	BB6_16
	block   	BB6_15
	block   	BB6_14
	block   	BB6_13
	block   	BB6_12
	block   	BB6_11
	loop    	BB6_10
	i32.const	$2=, args
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push2=, $2, $pop1
	f32.load	$1=, 0($pop2)
	copy_local	$3=, $6
BB6_2:                                  # %for.body3
                                        #   Parent Loop BB6_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB6_9
	f32.load	$5=, 0($2)
	i32.const	$7=, 140
	i32.const	$8=, 13
	f32.eq  	$push3=, $1, $5
	i32.select	$push4=, $pop3, $8, $7
	i32.load	$push5=, 0($4)
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, BB6_16
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB6_2 Depth=2
	i32.const	$9=, 4
	f32.ne  	$push7=, $1, $5
	i32.select	$push8=, $pop7, $8, $7
	i32.add 	$push9=, $4, $9
	i32.load	$push10=, 0($pop9)
	i32.ne  	$push11=, $pop8, $pop10
	br_if   	$pop11, BB6_15
# BB#4:                                 # %if.end10
                                        #   in Loop: Header=BB6_2 Depth=2
	i32.const	$11=, 8
	f32.lt  	$10=, $1, $5
	i32.select	$push12=, $10, $8, $7
	i32.add 	$push13=, $4, $11
	i32.load	$push14=, 0($pop13)
	i32.ne  	$push15=, $pop12, $pop14
	br_if   	$pop15, BB6_14
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB6_2 Depth=2
	f32.ne  	$push17=, $1, $1
	f32.ne  	$push16=, $5, $5
	i32.or  	$12=, $pop17, $pop16
	i32.or  	$push18=, $10, $12
	i32.select	$push19=, $pop18, $7, $8
	i32.const	$push20=, 12
	i32.add 	$push21=, $4, $pop20
	i32.load	$push22=, 0($pop21)
	i32.ne  	$push23=, $pop19, $pop22
	br_if   	$pop23, BB6_13
# BB#6:                                 # %if.end20
                                        #   in Loop: Header=BB6_2 Depth=2
	f32.gt  	$10=, $1, $5
	i32.select	$push24=, $10, $8, $7
	i32.const	$push25=, 16
	i32.add 	$push26=, $4, $pop25
	i32.load	$push27=, 0($pop26)
	i32.ne  	$push28=, $pop24, $pop27
	br_if   	$pop28, BB6_12
# BB#7:                                 # %if.end25
                                        #   in Loop: Header=BB6_2 Depth=2
	i32.or  	$push29=, $10, $12
	i32.select	$push30=, $pop29, $7, $8
	i32.const	$push31=, 20
	i32.add 	$push32=, $4, $pop31
	i32.load	$push33=, 0($pop32)
	i32.ne  	$push34=, $pop30, $pop33
	br_if   	$pop34, BB6_11
# BB#8:                                 # %if.end30
                                        #   in Loop: Header=BB6_2 Depth=2
	i32.const	$push35=, 24
	i32.add 	$4=, $4, $pop35
	i32.add 	$2=, $2, $9
	i32.const	$7=, 1
	i32.add 	$3=, $3, $7
	i32.lt_s	$push36=, $3, $11
	br_if   	$pop36, BB6_2
BB6_9:                                  # %for.end
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.add 	$0=, $0, $7
	i32.lt_s	$push37=, $0, $11
	br_if   	$pop37, BB6_1
BB6_10:                                 # %for.end33
	i32.const	$push38=, 0
	call    	exit, $pop38
	unreachable
BB6_11:                                 # %if.then29
	call    	abort
	unreachable
BB6_12:                                 # %if.then24
	call    	abort
	unreachable
BB6_13:                                 # %if.then19
	call    	abort
	unreachable
BB6_14:                                 # %if.then14
	call    	abort
	unreachable
BB6_15:                                 # %if.then9
	call    	abort
	unreachable
BB6_16:                                 # %if.then
	call    	abort
	unreachable
func_end6:
	.size	main, func_end6-main

	.type	args,@object            # @args
	.data
	.globl	args
	.align	4
args:
	.int32	0                       # float 0
	.int32	1065353216              # float 1
	.int32	3212836864              # float -1
	.int32	2139095039              # float 3.40282347E+38
	.int32	8388608                 # float 1.17549435E-38
	.int32	702623251               # float 9.99999982E-14
	.int32	1290500515              # float 123456792
	.int32	3463149987              # float -987654336
	.size	args, 32

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
	.size	correct_results, 1536


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
