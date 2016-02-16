	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/cmpdi-1.c"
	.section	.text.feq,"ax",@progbits
	.hidden	feq
	.globl	feq
	.type	feq,@function
feq:                                    # @feq
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i64.eq  	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
	return  	$pop3
	.endfunc
.Lfunc_end0:
	.size	feq, .Lfunc_end0-feq

	.section	.text.fne,"ax",@progbits
	.hidden	fne
	.globl	fne
	.type	fne,@function
fne:                                    # @fne
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i64.eq  	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	fne, .Lfunc_end1-fne

	.section	.text.flt,"ax",@progbits
	.hidden	flt
	.globl	flt
	.type	flt,@function
flt:                                    # @flt
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i64.lt_s	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
	return  	$pop3
	.endfunc
.Lfunc_end2:
	.size	flt, .Lfunc_end2-flt

	.section	.text.fge,"ax",@progbits
	.hidden	fge
	.globl	fge
	.type	fge,@function
fge:                                    # @fge
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i64.lt_s	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
	return  	$pop3
	.endfunc
.Lfunc_end3:
	.size	fge, .Lfunc_end3-fge

	.section	.text.fgt,"ax",@progbits
	.hidden	fgt
	.globl	fgt
	.type	fgt,@function
fgt:                                    # @fgt
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i64.gt_s	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
	return  	$pop3
	.endfunc
.Lfunc_end4:
	.size	fgt, .Lfunc_end4-fgt

	.section	.text.fle,"ax",@progbits
	.hidden	fle
	.globl	fle
	.type	fle,@function
fle:                                    # @fle
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i64.gt_s	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
	return  	$pop3
	.endfunc
.Lfunc_end5:
	.size	fle, .Lfunc_end5-fle

	.section	.text.fltu,"ax",@progbits
	.hidden	fltu
	.globl	fltu
	.type	fltu,@function
fltu:                                   # @fltu
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i64.lt_u	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
	return  	$pop3
	.endfunc
.Lfunc_end6:
	.size	fltu, .Lfunc_end6-fltu

	.section	.text.fgeu,"ax",@progbits
	.hidden	fgeu
	.globl	fgeu
	.type	fgeu,@function
fgeu:                                   # @fgeu
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i64.lt_u	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
	return  	$pop3
	.endfunc
.Lfunc_end7:
	.size	fgeu, .Lfunc_end7-fgeu

	.section	.text.fgtu,"ax",@progbits
	.hidden	fgtu
	.globl	fgtu
	.type	fgtu,@function
fgtu:                                   # @fgtu
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i64.gt_u	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
	return  	$pop3
	.endfunc
.Lfunc_end8:
	.size	fgtu, .Lfunc_end8-fgtu

	.section	.text.fleu,"ax",@progbits
	.hidden	fleu
	.globl	fleu
	.type	fleu,@function
fleu:                                   # @fleu
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i64.gt_u	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
	return  	$pop3
	.endfunc
.Lfunc_end9:
	.size	fleu, .Lfunc_end9-fleu

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i32, i32, i32, i32, i64
# BB#0:                                 # %entry
	i32.const	$4=, correct_results
	i32.const	$0=, 0
.LBB10_1:                               # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB10_2 Depth 2
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	loop                            # label10:
	i32.const	$push43=, 3
	i32.shl 	$push0=, $0, $pop43
	i64.load	$1=, args($pop0)
	i32.const	$2=, args
	i32.const	$3=, 0
.LBB10_2:                               # %for.body3
                                        #   Parent Loop BB10_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label12:
	i32.const	$push49=, 13
	i32.const	$push48=, 140
	i64.load	$push47=, 0($2)
	tee_local	$push46=, $6=, $pop47
	i64.eq  	$push45=, $1, $pop46
	tee_local	$push44=, $5=, $pop45
	i32.select	$push1=, $pop49, $pop48, $pop44
	i32.load	$push2=, 0($4)
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	4, $pop3        # 4: down to label9
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push52=, 140
	i32.const	$push51=, 13
	i32.select	$push4=, $pop52, $pop51, $5
	i32.const	$push50=, 4
	i32.add 	$push5=, $4, $pop50
	i32.load	$push6=, 0($pop5)
	i32.ne  	$push7=, $pop4, $pop6
	br_if   	5, $pop7        # 5: down to label8
# BB#4:                                 # %if.end10
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push57=, 13
	i32.const	$push56=, 140
	i64.lt_s	$push55=, $1, $6
	tee_local	$push54=, $5=, $pop55
	i32.select	$push8=, $pop57, $pop56, $pop54
	i32.const	$push53=, 8
	i32.add 	$push9=, $4, $pop53
	i32.load	$push10=, 0($pop9)
	i32.ne  	$push11=, $pop8, $pop10
	br_if   	6, $pop11       # 6: down to label7
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push60=, 140
	i32.const	$push59=, 13
	i32.select	$push12=, $pop60, $pop59, $5
	i32.const	$push58=, 12
	i32.add 	$push13=, $4, $pop58
	i32.load	$push14=, 0($pop13)
	i32.ne  	$push15=, $pop12, $pop14
	br_if   	7, $pop15       # 7: down to label6
# BB#6:                                 # %if.end20
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push65=, 13
	i32.const	$push64=, 140
	i64.gt_s	$push63=, $1, $6
	tee_local	$push62=, $5=, $pop63
	i32.select	$push16=, $pop65, $pop64, $pop62
	i32.const	$push61=, 16
	i32.add 	$push17=, $4, $pop61
	i32.load	$push18=, 0($pop17)
	i32.ne  	$push19=, $pop16, $pop18
	br_if   	8, $pop19       # 8: down to label5
# BB#7:                                 # %if.end25
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push68=, 140
	i32.const	$push67=, 13
	i32.select	$push20=, $pop68, $pop67, $5
	i32.const	$push66=, 20
	i32.add 	$push21=, $4, $pop66
	i32.load	$push22=, 0($pop21)
	i32.ne  	$push23=, $pop20, $pop22
	br_if   	9, $pop23       # 9: down to label4
# BB#8:                                 # %if.end30
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push73=, 13
	i32.const	$push72=, 140
	i64.lt_u	$push71=, $1, $6
	tee_local	$push70=, $5=, $pop71
	i32.select	$push24=, $pop73, $pop72, $pop70
	i32.const	$push69=, 24
	i32.add 	$push25=, $4, $pop69
	i32.load	$push26=, 0($pop25)
	i32.ne  	$push27=, $pop24, $pop26
	br_if   	10, $pop27      # 10: down to label3
# BB#9:                                 # %if.end35
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push76=, 140
	i32.const	$push75=, 13
	i32.select	$push28=, $pop76, $pop75, $5
	i32.const	$push74=, 28
	i32.add 	$push29=, $4, $pop74
	i32.load	$push30=, 0($pop29)
	i32.ne  	$push31=, $pop28, $pop30
	br_if   	11, $pop31      # 11: down to label2
# BB#10:                                # %if.end40
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push81=, 13
	i32.const	$push80=, 140
	i64.gt_u	$push79=, $1, $6
	tee_local	$push78=, $5=, $pop79
	i32.select	$push32=, $pop81, $pop80, $pop78
	i32.const	$push77=, 32
	i32.add 	$push33=, $4, $pop77
	i32.load	$push34=, 0($pop33)
	i32.ne  	$push35=, $pop32, $pop34
	br_if   	12, $pop35      # 12: down to label1
# BB#11:                                # %if.end45
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push84=, 140
	i32.const	$push83=, 13
	i32.select	$push36=, $pop84, $pop83, $5
	i32.const	$push82=, 36
	i32.add 	$push37=, $4, $pop82
	i32.load	$push38=, 0($pop37)
	i32.ne  	$push39=, $pop36, $pop38
	br_if   	13, $pop39      # 13: down to label0
# BB#12:                                # %if.end50
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push88=, 40
	i32.add 	$4=, $4, $pop88
	i32.const	$push87=, 1
	i32.add 	$3=, $3, $pop87
	i32.const	$push86=, 8
	i32.add 	$2=, $2, $pop86
	i32.const	$push85=, 8
	i32.lt_s	$push40=, $3, $pop85
	br_if   	0, $pop40       # 0: up to label12
# BB#13:                                # %for.end
                                        #   in Loop: Header=BB10_1 Depth=1
	end_loop                        # label13:
	i32.const	$push90=, 1
	i32.add 	$0=, $0, $pop90
	i32.const	$push89=, 8
	i32.lt_s	$push41=, $0, $pop89
	br_if   	0, $pop41       # 0: up to label10
# BB#14:                                # %for.end53
	end_loop                        # label11:
	i32.const	$push42=, 0
	call    	exit@FUNCTION, $pop42
	unreachable
.LBB10_15:                              # %if.then
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB10_16:                              # %if.then9
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB10_17:                              # %if.then14
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB10_18:                              # %if.then19
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB10_19:                              # %if.then24
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB10_20:                              # %if.then29
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB10_21:                              # %if.then34
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB10_22:                              # %if.then39
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB10_23:                              # %if.then44
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB10_24:                              # %if.then49
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end10:
	.size	main, .Lfunc_end10-main

	.hidden	args                    # @args
	.type	args,@object
	.section	.data.args,"aw",@progbits
	.globl	args
	.p2align	4
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

	.hidden	correct_results         # @correct_results
	.type	correct_results,@object
	.section	.data.correct_results,"aw",@progbits
	.globl	correct_results
	.p2align	4
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


	.ident	"clang version 3.9.0 "
