	.text
	.file	"cmpsf-1.c"
	.section	.text.feq,"ax",@progbits
	.hidden	feq                     # -- Begin function feq
	.globl	feq
	.type	feq,@function
feq:                                    # @feq
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	f32.eq  	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	feq, .Lfunc_end0-feq
                                        # -- End function
	.section	.text.fne,"ax",@progbits
	.hidden	fne                     # -- Begin function fne
	.globl	fne
	.type	fne,@function
fne:                                    # @fne
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	f32.ne  	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	fne, .Lfunc_end1-fne
                                        # -- End function
	.section	.text.flt,"ax",@progbits
	.hidden	flt                     # -- Begin function flt
	.globl	flt
	.type	flt,@function
flt:                                    # @flt
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	f32.lt  	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end2:
	.size	flt, .Lfunc_end2-flt
                                        # -- End function
	.section	.text.fge,"ax",@progbits
	.hidden	fge                     # -- Begin function fge
	.globl	fge
	.type	fge,@function
fge:                                    # @fge
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 140
	i32.const	$push5=, 13
	f32.lt  	$push0=, $0, $1
	f32.ne  	$push2=, $0, $0
	f32.ne  	$push1=, $1, $1
	i32.or  	$push3=, $pop2, $pop1
	i32.or  	$push4=, $pop0, $pop3
	i32.select	$push7=, $pop6, $pop5, $pop4
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end3:
	.size	fge, .Lfunc_end3-fge
                                        # -- End function
	.section	.text.fgt,"ax",@progbits
	.hidden	fgt                     # -- Begin function fgt
	.globl	fgt
	.type	fgt,@function
fgt:                                    # @fgt
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	f32.gt  	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end4:
	.size	fgt, .Lfunc_end4-fgt
                                        # -- End function
	.section	.text.fle,"ax",@progbits
	.hidden	fle                     # -- Begin function fle
	.globl	fle
	.type	fle,@function
fle:                                    # @fle
	.param  	f32, f32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 140
	i32.const	$push5=, 13
	f32.gt  	$push0=, $0, $1
	f32.ne  	$push2=, $0, $0
	f32.ne  	$push1=, $1, $1
	i32.or  	$push3=, $pop2, $pop1
	i32.or  	$push4=, $pop0, $pop3
	i32.select	$push7=, $pop6, $pop5, $pop4
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end5:
	.size	fle, .Lfunc_end5-fle
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f32, i32, i32, i32, f32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, correct_results
	i32.const	$0=, 0
.LBB6_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_2 Depth 2
	block   	
	loop    	                # label1:
	i32.const	$2=, args
	i32.const	$push35=, 2
	i32.shl 	$push1=, $0, $pop35
	i32.const	$push34=, args
	i32.add 	$push2=, $pop1, $pop34
	f32.load	$1=, 0($pop2)
	i32.const	$3=, -1
.LBB6_2:                                # %for.body3
                                        #   Parent Loop BB6_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label2:
	i32.const	$push39=, 13
	i32.const	$push38=, 140
	f32.load	$push37=, 0($2)
	tee_local	$push36=, $5=, $pop37
	f32.eq  	$push3=, $1, $pop36
	i32.select	$push4=, $pop39, $pop38, $pop3
	i32.load	$push5=, 0($4)
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	2, $pop6        # 2: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB6_2 Depth=2
	i32.const	$push42=, 13
	i32.const	$push41=, 140
	f32.ne  	$push7=, $1, $5
	i32.select	$push8=, $pop42, $pop41, $pop7
	i32.const	$push40=, 4
	i32.add 	$push9=, $4, $pop40
	i32.load	$push10=, 0($pop9)
	i32.ne  	$push11=, $pop8, $pop10
	br_if   	2, $pop11       # 2: down to label0
# BB#4:                                 # %if.end10
                                        #   in Loop: Header=BB6_2 Depth=2
	i32.const	$push47=, 13
	i32.const	$push46=, 140
	f32.lt  	$push45=, $1, $5
	tee_local	$push44=, $6=, $pop45
	i32.select	$push12=, $pop47, $pop46, $pop44
	i32.const	$push43=, 8
	i32.add 	$push13=, $4, $pop43
	i32.load	$push14=, 0($pop13)
	i32.ne  	$push15=, $pop12, $pop14
	br_if   	2, $pop15       # 2: down to label0
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB6_2 Depth=2
	i32.const	$push52=, 140
	i32.const	$push51=, 13
	f32.ne  	$push17=, $1, $1
	f32.ne  	$push16=, $5, $5
	i32.or  	$push50=, $pop17, $pop16
	tee_local	$push49=, $7=, $pop50
	i32.or  	$push18=, $6, $pop49
	i32.select	$push19=, $pop52, $pop51, $pop18
	i32.const	$push48=, 12
	i32.add 	$push20=, $4, $pop48
	i32.load	$push21=, 0($pop20)
	i32.ne  	$push22=, $pop19, $pop21
	br_if   	2, $pop22       # 2: down to label0
# BB#6:                                 # %if.end20
                                        #   in Loop: Header=BB6_2 Depth=2
	i32.const	$push57=, 13
	i32.const	$push56=, 140
	f32.gt  	$push55=, $1, $5
	tee_local	$push54=, $6=, $pop55
	i32.select	$push23=, $pop57, $pop56, $pop54
	i32.const	$push53=, 16
	i32.add 	$push24=, $4, $pop53
	i32.load	$push25=, 0($pop24)
	i32.ne  	$push26=, $pop23, $pop25
	br_if   	2, $pop26       # 2: down to label0
# BB#7:                                 # %if.end25
                                        #   in Loop: Header=BB6_2 Depth=2
	i32.const	$push60=, 140
	i32.const	$push59=, 13
	i32.or  	$push27=, $6, $7
	i32.select	$push28=, $pop60, $pop59, $pop27
	i32.const	$push58=, 20
	i32.add 	$push29=, $4, $pop58
	i32.load	$push30=, 0($pop29)
	i32.ne  	$push31=, $pop28, $pop30
	br_if   	2, $pop31       # 2: down to label0
# BB#8:                                 # %if.end30
                                        #   in Loop: Header=BB6_2 Depth=2
	i32.const	$push66=, 24
	i32.add 	$4=, $4, $pop66
	i32.const	$push65=, 4
	i32.add 	$2=, $2, $pop65
	i32.const	$push64=, 1
	i32.add 	$push63=, $3, $pop64
	tee_local	$push62=, $3=, $pop63
	i32.const	$push61=, 7
	i32.lt_u	$push32=, $pop62, $pop61
	br_if   	0, $pop32       # 0: up to label2
# BB#9:                                 # %for.end
                                        #   in Loop: Header=BB6_1 Depth=1
	end_loop
	i32.const	$push68=, 7
	i32.lt_u	$2=, $0, $pop68
	i32.const	$push67=, 1
	i32.add 	$push0=, $0, $pop67
	copy_local	$0=, $pop0
	br_if   	0, $2           # 0: up to label1
# BB#10:                                # %for.end33
	end_loop
	i32.const	$push33=, 0
	call    	exit@FUNCTION, $pop33
	unreachable
.LBB6_11:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	main, .Lfunc_end6-main
                                        # -- End function
	.hidden	args                    # @args
	.type	args,@object
	.section	.data.args,"aw",@progbits
	.globl	args
	.p2align	4
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
