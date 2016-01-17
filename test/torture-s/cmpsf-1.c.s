	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/cmpsf-1.c"
	.section	.text.feq,"ax",@progbits
	.hidden	feq
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
	.endfunc
.Lfunc_end0:
	.size	feq, .Lfunc_end0-feq

	.section	.text.fne,"ax",@progbits
	.hidden	fne
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
	.endfunc
.Lfunc_end1:
	.size	fne, .Lfunc_end1-fne

	.section	.text.flt,"ax",@progbits
	.hidden	flt
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
	.endfunc
.Lfunc_end2:
	.size	flt, .Lfunc_end2-flt

	.section	.text.fge,"ax",@progbits
	.hidden	fge
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
	.endfunc
.Lfunc_end3:
	.size	fge, .Lfunc_end3-fge

	.section	.text.fgt,"ax",@progbits
	.hidden	fgt
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
	.endfunc
.Lfunc_end4:
	.size	fgt, .Lfunc_end4-fgt

	.section	.text.fle,"ax",@progbits
	.hidden	fle
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
	.endfunc
.Lfunc_end5:
	.size	fle, .Lfunc_end5-fle

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f32, i32, i32, i32, f32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
	i32.const	$4=, correct_results
	copy_local	$0=, $6
.LBB6_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_2 Depth 2
	block
	block
	block
	block
	block
	block
	loop                            # label6:
	i32.const	$2=, args
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push2=, $2, $pop1
	f32.load	$1=, 0($pop2)
	copy_local	$3=, $6
.LBB6_2:                                # %for.body3
                                        #   Parent Loop BB6_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label8:
	f32.load	$5=, 0($2)
	i32.const	$7=, 140
	i32.const	$8=, 13
	f32.eq  	$push3=, $1, $5
	i32.select	$push4=, $pop3, $8, $7
	i32.load	$push5=, 0($4)
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, 9        # 9: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB6_2 Depth=2
	i32.const	$9=, 4
	f32.ne  	$push7=, $1, $5
	i32.select	$push8=, $pop7, $8, $7
	i32.add 	$push9=, $4, $9
	i32.load	$push10=, 0($pop9)
	i32.ne  	$push11=, $pop8, $pop10
	br_if   	$pop11, 8       # 8: down to label1
# BB#4:                                 # %if.end10
                                        #   in Loop: Header=BB6_2 Depth=2
	i32.const	$11=, 8
	f32.lt  	$10=, $1, $5
	i32.select	$push12=, $10, $8, $7
	i32.add 	$push13=, $4, $11
	i32.load	$push14=, 0($pop13)
	i32.ne  	$push15=, $pop12, $pop14
	br_if   	$pop15, 7       # 7: down to label2
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
	br_if   	$pop23, 6       # 6: down to label3
# BB#6:                                 # %if.end20
                                        #   in Loop: Header=BB6_2 Depth=2
	f32.gt  	$10=, $1, $5
	i32.select	$push24=, $10, $8, $7
	i32.const	$push25=, 16
	i32.add 	$push26=, $4, $pop25
	i32.load	$push27=, 0($pop26)
	i32.ne  	$push28=, $pop24, $pop27
	br_if   	$pop28, 5       # 5: down to label4
# BB#7:                                 # %if.end25
                                        #   in Loop: Header=BB6_2 Depth=2
	i32.or  	$push29=, $10, $12
	i32.select	$push30=, $pop29, $7, $8
	i32.const	$push31=, 20
	i32.add 	$push32=, $4, $pop31
	i32.load	$push33=, 0($pop32)
	i32.ne  	$push34=, $pop30, $pop33
	br_if   	$pop34, 4       # 4: down to label5
# BB#8:                                 # %if.end30
                                        #   in Loop: Header=BB6_2 Depth=2
	i32.const	$push35=, 24
	i32.add 	$4=, $4, $pop35
	i32.add 	$2=, $2, $9
	i32.const	$7=, 1
	i32.add 	$3=, $3, $7
	i32.lt_s	$push36=, $3, $11
	br_if   	$pop36, 0       # 0: up to label8
# BB#9:                                 # %for.end
                                        #   in Loop: Header=BB6_1 Depth=1
	end_loop                        # label9:
	i32.add 	$0=, $0, $7
	i32.lt_s	$push37=, $0, $11
	br_if   	$pop37, 0       # 0: up to label6
# BB#10:                                # %for.end33
	end_loop                        # label7:
	i32.const	$push38=, 0
	call    	exit@FUNCTION, $pop38
	unreachable
.LBB6_11:                               # %if.then29
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB6_12:                               # %if.then24
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB6_13:                               # %if.then19
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB6_14:                               # %if.then14
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB6_15:                               # %if.then9
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB6_16:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	main, .Lfunc_end6-main

	.hidden	args                    # @args
	.type	args,@object
	.section	.data.args,"aw",@progbits
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


	.ident	"clang version 3.9.0 "
