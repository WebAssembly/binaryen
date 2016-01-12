	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/cmpsi-2.c"
	.section	.text.feq,"ax",@progbits
	.hidden	feq
	.globl	feq
	.type	feq,@function
feq:                                    # @feq
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.eq  	$push0=, $0, $1
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end0:
	.size	feq, .Lfunc_end0-feq

	.section	.text.fne,"ax",@progbits
	.hidden	fne
	.globl	fne
	.type	fne,@function
fne:                                    # @fne
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.eq  	$push0=, $0, $1
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end1:
	.size	fne, .Lfunc_end1-fne

	.section	.text.flt,"ax",@progbits
	.hidden	flt
	.globl	flt
	.type	flt,@function
flt:                                    # @flt
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.lt_s	$push0=, $0, $1
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end2:
	.size	flt, .Lfunc_end2-flt

	.section	.text.fge,"ax",@progbits
	.hidden	fge
	.globl	fge
	.type	fge,@function
fge:                                    # @fge
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.lt_s	$push0=, $0, $1
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end3:
	.size	fge, .Lfunc_end3-fge

	.section	.text.fgt,"ax",@progbits
	.hidden	fgt
	.globl	fgt
	.type	fgt,@function
fgt:                                    # @fgt
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.gt_s	$push0=, $0, $1
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end4:
	.size	fgt, .Lfunc_end4-fgt

	.section	.text.fle,"ax",@progbits
	.hidden	fle
	.globl	fle
	.type	fle,@function
fle:                                    # @fle
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.gt_s	$push0=, $0, $1
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end5:
	.size	fle, .Lfunc_end5-fle

	.section	.text.fltu,"ax",@progbits
	.hidden	fltu
	.globl	fltu
	.type	fltu,@function
fltu:                                   # @fltu
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.lt_u	$push0=, $0, $1
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end6:
	.size	fltu, .Lfunc_end6-fltu

	.section	.text.fgeu,"ax",@progbits
	.hidden	fgeu
	.globl	fgeu
	.type	fgeu,@function
fgeu:                                   # @fgeu
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.lt_u	$push0=, $0, $1
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end7:
	.size	fgeu, .Lfunc_end7-fgeu

	.section	.text.fgtu,"ax",@progbits
	.hidden	fgtu
	.globl	fgtu
	.type	fgtu,@function
fgtu:                                   # @fgtu
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.gt_u	$push0=, $0, $1
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end8:
	.size	fgtu, .Lfunc_end8-fgtu

	.section	.text.fleu,"ax",@progbits
	.hidden	fleu
	.globl	fleu
	.type	fleu,@function
fleu:                                   # @fleu
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.gt_u	$push0=, $0, $1
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
.Lfunc_end9:
	.size	fleu, .Lfunc_end9-fleu

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
	i32.const	$4=, correct_results
	copy_local	$0=, $6
.LBB10_1:                               # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB10_2 Depth 2
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
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push2=, $2, $pop1
	i32.load	$1=, 0($pop2)
	copy_local	$3=, $6
.LBB10_2:                               # %for.body3
                                        #   Parent Loop BB10_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB10_13
	i32.load	$5=, 0($2)
	i32.eq  	$11=, $1, $5
	i32.const	$7=, 140
	i32.const	$8=, 13
	i32.select	$push3=, $11, $8, $7
	i32.load	$push4=, 0($4)
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, .LBB10_24
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$9=, 4
	i32.select	$push6=, $11, $7, $8
	i32.add 	$push7=, $4, $9
	i32.load	$push8=, 0($pop7)
	i32.ne  	$push9=, $pop6, $pop8
	br_if   	$pop9, .LBB10_23
# BB#4:                                 # %if.end10
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$11=, 8
	i32.lt_s	$10=, $1, $5
	i32.select	$push10=, $10, $8, $7
	i32.add 	$push11=, $4, $11
	i32.load	$push12=, 0($pop11)
	i32.ne  	$push13=, $pop10, $pop12
	br_if   	$pop13, .LBB10_22
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.select	$push14=, $10, $7, $8
	i32.const	$push15=, 12
	i32.add 	$push16=, $4, $pop15
	i32.load	$push17=, 0($pop16)
	i32.ne  	$push18=, $pop14, $pop17
	br_if   	$pop18, .LBB10_21
# BB#6:                                 # %if.end20
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.gt_s	$10=, $1, $5
	i32.select	$push19=, $10, $8, $7
	i32.const	$push20=, 16
	i32.add 	$push21=, $4, $pop20
	i32.load	$push22=, 0($pop21)
	i32.ne  	$push23=, $pop19, $pop22
	br_if   	$pop23, .LBB10_20
# BB#7:                                 # %if.end25
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.select	$push24=, $10, $7, $8
	i32.const	$push25=, 20
	i32.add 	$push26=, $4, $pop25
	i32.load	$push27=, 0($pop26)
	i32.ne  	$push28=, $pop24, $pop27
	br_if   	$pop28, .LBB10_19
# BB#8:                                 # %if.end30
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.lt_u	$10=, $1, $5
	i32.select	$push29=, $10, $8, $7
	i32.const	$push30=, 24
	i32.add 	$push31=, $4, $pop30
	i32.load	$push32=, 0($pop31)
	i32.ne  	$push33=, $pop29, $pop32
	br_if   	$pop33, .LBB10_18
# BB#9:                                 # %if.end35
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.select	$push34=, $10, $7, $8
	i32.const	$push35=, 28
	i32.add 	$push36=, $4, $pop35
	i32.load	$push37=, 0($pop36)
	i32.ne  	$push38=, $pop34, $pop37
	br_if   	$pop38, .LBB10_17
# BB#10:                                # %if.end40
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.gt_u	$5=, $1, $5
	i32.select	$push39=, $5, $8, $7
	i32.const	$push40=, 32
	i32.add 	$push41=, $4, $pop40
	i32.load	$push42=, 0($pop41)
	i32.ne  	$push43=, $pop39, $pop42
	br_if   	$pop43, .LBB10_16
# BB#11:                                # %if.end45
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.select	$push44=, $5, $7, $8
	i32.const	$push45=, 36
	i32.add 	$push46=, $4, $pop45
	i32.load	$push47=, 0($pop46)
	i32.ne  	$push48=, $pop44, $pop47
	br_if   	$pop48, .LBB10_15
# BB#12:                                # %if.end50
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push49=, 40
	i32.add 	$4=, $4, $pop49
	i32.add 	$2=, $2, $9
	i32.const	$7=, 1
	i32.add 	$3=, $3, $7
	i32.lt_s	$push50=, $3, $11
	br_if   	$pop50, .LBB10_2
.LBB10_13:                              # %for.end
                                        #   in Loop: Header=BB10_1 Depth=1
	i32.add 	$0=, $0, $7
	i32.lt_s	$push51=, $0, $11
	br_if   	$pop51, .LBB10_1
.LBB10_14:                              # %for.end53
	i32.const	$push52=, 0
	call    	exit@FUNCTION, $pop52
	unreachable
.LBB10_15:                              # %if.then49
	call    	abort@FUNCTION
	unreachable
.LBB10_16:                              # %if.then44
	call    	abort@FUNCTION
	unreachable
.LBB10_17:                              # %if.then39
	call    	abort@FUNCTION
	unreachable
.LBB10_18:                              # %if.then34
	call    	abort@FUNCTION
	unreachable
.LBB10_19:                              # %if.then29
	call    	abort@FUNCTION
	unreachable
.LBB10_20:                              # %if.then24
	call    	abort@FUNCTION
	unreachable
.LBB10_21:                              # %if.then19
	call    	abort@FUNCTION
	unreachable
.LBB10_22:                              # %if.then14
	call    	abort@FUNCTION
	unreachable
.LBB10_23:                              # %if.then9
	call    	abort@FUNCTION
	unreachable
.LBB10_24:                              # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end10:
	.size	main, .Lfunc_end10-main

	.hidden	args                    # @args
	.type	args,@object
	.section	.data.args,"aw",@progbits
	.globl	args
	.align	4
args:
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	4294967295              # 0xffffffff
	.int32	2147483647              # 0x7fffffff
	.int32	2147483648              # 0x80000000
	.int32	2147483649              # 0x80000001
	.int32	440345459               # 0x1a3f2373
	.int32	2474970770              # 0x93850e92
	.size	args, 32

	.hidden	correct_results         # @correct_results
	.type	correct_results,@object
	.section	.data.correct_results,"aw",@progbits
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
