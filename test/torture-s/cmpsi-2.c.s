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
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.eq  	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
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
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.ne  	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
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
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.lt_s	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
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
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.ge_s	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
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
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.gt_s	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
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
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.le_s	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
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
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.lt_u	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
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
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.ge_u	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
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
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.gt_u	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
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
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i32.le_u	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end9:
	.size	fleu, .Lfunc_end9-fleu

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, correct_results
	i32.const	$0=, 0
.LBB10_1:                               # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB10_2 Depth 2
	block
	loop                            # label1:
	i32.const	$2=, args
	i32.const	$push55=, 2
	i32.shl 	$push0=, $0, $pop55
	i32.const	$push54=, args
	i32.add 	$push1=, $pop0, $pop54
	i32.load	$1=, 0($pop1)
	i32.const	$3=, 0
.LBB10_2:                               # %for.body3
                                        #   Parent Loop BB10_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label3:
	i32.const	$push59=, 13
	i32.const	$push58=, 140
	i32.load	$push57=, 0($2)
	tee_local	$push56=, $5=, $pop57
	i32.eq  	$push2=, $1, $pop56
	i32.select	$push3=, $pop59, $pop58, $pop2
	i32.load	$push4=, 0($4)
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	4, $pop5        # 4: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push62=, 13
	i32.const	$push61=, 140
	i32.ne  	$push6=, $1, $5
	i32.select	$push7=, $pop62, $pop61, $pop6
	i32.const	$push60=, 4
	i32.add 	$push8=, $4, $pop60
	i32.load	$push9=, 0($pop8)
	i32.ne  	$push10=, $pop7, $pop9
	br_if   	4, $pop10       # 4: down to label0
# BB#4:                                 # %if.end10
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push65=, 13
	i32.const	$push64=, 140
	i32.lt_s	$push11=, $1, $5
	i32.select	$push12=, $pop65, $pop64, $pop11
	i32.const	$push63=, 8
	i32.add 	$push13=, $4, $pop63
	i32.load	$push14=, 0($pop13)
	i32.ne  	$push15=, $pop12, $pop14
	br_if   	4, $pop15       # 4: down to label0
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push68=, 13
	i32.const	$push67=, 140
	i32.ge_s	$push16=, $1, $5
	i32.select	$push17=, $pop68, $pop67, $pop16
	i32.const	$push66=, 12
	i32.add 	$push18=, $4, $pop66
	i32.load	$push19=, 0($pop18)
	i32.ne  	$push20=, $pop17, $pop19
	br_if   	4, $pop20       # 4: down to label0
# BB#6:                                 # %if.end20
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push71=, 13
	i32.const	$push70=, 140
	i32.gt_s	$push21=, $1, $5
	i32.select	$push22=, $pop71, $pop70, $pop21
	i32.const	$push69=, 16
	i32.add 	$push23=, $4, $pop69
	i32.load	$push24=, 0($pop23)
	i32.ne  	$push25=, $pop22, $pop24
	br_if   	4, $pop25       # 4: down to label0
# BB#7:                                 # %if.end25
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push74=, 13
	i32.const	$push73=, 140
	i32.le_s	$push26=, $1, $5
	i32.select	$push27=, $pop74, $pop73, $pop26
	i32.const	$push72=, 20
	i32.add 	$push28=, $4, $pop72
	i32.load	$push29=, 0($pop28)
	i32.ne  	$push30=, $pop27, $pop29
	br_if   	4, $pop30       # 4: down to label0
# BB#8:                                 # %if.end30
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push77=, 13
	i32.const	$push76=, 140
	i32.lt_u	$push31=, $1, $5
	i32.select	$push32=, $pop77, $pop76, $pop31
	i32.const	$push75=, 24
	i32.add 	$push33=, $4, $pop75
	i32.load	$push34=, 0($pop33)
	i32.ne  	$push35=, $pop32, $pop34
	br_if   	4, $pop35       # 4: down to label0
# BB#9:                                 # %if.end35
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push80=, 13
	i32.const	$push79=, 140
	i32.ge_u	$push36=, $1, $5
	i32.select	$push37=, $pop80, $pop79, $pop36
	i32.const	$push78=, 28
	i32.add 	$push38=, $4, $pop78
	i32.load	$push39=, 0($pop38)
	i32.ne  	$push40=, $pop37, $pop39
	br_if   	4, $pop40       # 4: down to label0
# BB#10:                                # %if.end40
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push83=, 13
	i32.const	$push82=, 140
	i32.gt_u	$push41=, $1, $5
	i32.select	$push42=, $pop83, $pop82, $pop41
	i32.const	$push81=, 32
	i32.add 	$push43=, $4, $pop81
	i32.load	$push44=, 0($pop43)
	i32.ne  	$push45=, $pop42, $pop44
	br_if   	4, $pop45       # 4: down to label0
# BB#11:                                # %if.end45
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push86=, 13
	i32.const	$push85=, 140
	i32.le_u	$push46=, $1, $5
	i32.select	$push47=, $pop86, $pop85, $pop46
	i32.const	$push84=, 36
	i32.add 	$push48=, $4, $pop84
	i32.load	$push49=, 0($pop48)
	i32.ne  	$push50=, $pop47, $pop49
	br_if   	4, $pop50       # 4: down to label0
# BB#12:                                # %if.end50
                                        #   in Loop: Header=BB10_2 Depth=2
	i32.const	$push92=, 40
	i32.add 	$4=, $4, $pop92
	i32.const	$push91=, 4
	i32.add 	$2=, $2, $pop91
	i32.const	$push90=, 1
	i32.add 	$push89=, $3, $pop90
	tee_local	$push88=, $3=, $pop89
	i32.const	$push87=, 8
	i32.lt_s	$push51=, $pop88, $pop87
	br_if   	0, $pop51       # 0: up to label3
# BB#13:                                # %for.end
                                        #   in Loop: Header=BB10_1 Depth=1
	end_loop                        # label4:
	i32.const	$push96=, 1
	i32.add 	$push95=, $0, $pop96
	tee_local	$push94=, $0=, $pop95
	i32.const	$push93=, 8
	i32.lt_s	$push52=, $pop94, $pop93
	br_if   	0, $pop52       # 0: up to label1
# BB#14:                                # %for.end53
	end_loop                        # label2:
	i32.const	$push53=, 0
	call    	exit@FUNCTION, $pop53
	unreachable
.LBB10_15:                              # %if.then49
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
