	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991118-1.c"
	.section	.text.sub,"ax",@progbits
	.hidden	sub
	.globl	sub
	.type	sub,@function
sub:                                    # @sub
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.const	$push1=, -8690468286197432320
	i64.xor 	$push2=, $pop0, $pop1
	i64.store	$drop=, 0($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	sub, .Lfunc_end0-sub

	.section	.text.sub2,"ax",@progbits
	.hidden	sub2
	.globl	sub2
	.type	sub2,@function
sub2:                                   # @sub2
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.const	$push1=, 2381903268435576
	i64.xor 	$push2=, $pop0, $pop1
	i64.store	$drop=, 0($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	sub2, .Lfunc_end1-sub2

	.section	.text.sub3,"ax",@progbits
	.hidden	sub3
	.globl	sub3
	.type	sub3,@function
sub3:                                   # @sub3
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.const	$push1=, -4345234143098716160
	i64.xor 	$push2=, $pop0, $pop1
	i64.store	$drop=, 0($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	sub3, .Lfunc_end2-sub3

	.section	.text.sub4,"ax",@progbits
	.hidden	sub4
	.globl	sub4
	.type	sub4,@function
sub4:                                   # @sub4
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.const	$push1=, 6885502895806072
	i64.xor 	$push2=, $pop0, $pop1
	i64.store	$drop=, 0($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	sub4, .Lfunc_end3-sub4

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.const	$push51=, 0
	i64.load	$push50=, tmp($pop51)
	tee_local	$push49=, $3=, $pop50
	i64.const	$push4=, -8690468286197432320
	i64.xor 	$push5=, $pop49, $pop4
	i64.store	$0=, tmp($pop3), $pop5
	i32.const	$push48=, 0
	i32.const	$push47=, 0
	i64.load	$push46=, tmp2($pop47)
	tee_local	$push45=, $2=, $pop46
	i64.const	$push6=, 2381903268435576
	i64.xor 	$push0=, $pop45, $pop6
	i64.store	$1=, tmp2($pop48), $pop0
	block
	i64.const	$push7=, -4096
	i64.and 	$push8=, $0, $pop7
	i64.const	$push9=, -7687337405579571200
	i64.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#1:                                 # %entry
	i64.const	$push11=, 52
	i64.shl 	$push12=, $3, $pop11
	i64.const	$push53=, 52
	i64.shr_s	$push13=, $pop12, $pop53
	i32.wrap/i64	$push2=, $pop13
	i32.const	$push52=, 291
	i32.ne  	$push14=, $pop2, $pop52
	br_if   	0, $pop14       # 0: down to label0
# BB#2:                                 # %if.end
	i64.const	$push17=, 52
	i64.shr_s	$push18=, $2, $pop17
	i32.wrap/i64	$push19=, $pop18
	i32.const	$push54=, 291
	i32.ne  	$push20=, $pop19, $pop54
	br_if   	0, $pop20       # 0: down to label0
# BB#3:                                 # %if.end
	i64.const	$push16=, 4503599627370495
	i64.and 	$push15=, $1, $pop16
	i64.const	$push21=, 2626808268586421
	i64.ne  	$push22=, $pop15, $pop21
	br_if   	0, $pop22       # 0: down to label0
# BB#4:                                 # %if.end19
	i32.const	$push24=, 0
	i32.const	$push61=, 0
	i64.load	$push60=, tmp3($pop61)
	tee_local	$push59=, $3=, $pop60
	i64.const	$push25=, -4345234143098716160
	i64.xor 	$push26=, $pop59, $pop25
	i64.store	$0=, tmp3($pop24), $pop26
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i64.load	$push56=, tmp4($pop57)
	tee_local	$push55=, $2=, $pop56
	i64.const	$push27=, 6885502895806072
	i64.xor 	$push1=, $pop55, $pop27
	i64.store	$1=, tmp4($pop58), $pop1
	i64.const	$push28=, -2048
	i64.and 	$push29=, $0, $pop28
	i64.const	$push30=, -3725223934242340864
	i64.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#5:                                 # %if.end19
	i64.const	$push32=, 53
	i64.shl 	$push33=, $3, $pop32
	i64.const	$push63=, 53
	i64.shr_s	$push34=, $pop33, $pop63
	i32.wrap/i64	$push23=, $pop34
	i32.const	$push62=, 291
	i32.ne  	$push35=, $pop23, $pop62
	br_if   	0, $pop35       # 0: down to label0
# BB#6:                                 # %if.end34
	i64.const	$push38=, 53
	i64.shr_s	$push39=, $2, $pop38
	i32.wrap/i64	$push40=, $pop39
	i32.const	$push64=, 291
	i32.ne  	$push41=, $pop40, $pop64
	br_if   	0, $pop41       # 0: down to label0
# BB#7:                                 # %if.end34
	i64.const	$push37=, 9007199254740991
	i64.and 	$push36=, $1, $pop37
	i64.const	$push42=, 7188242255599224
	i64.ne  	$push43=, $pop36, $pop42
	br_if   	0, $pop43       # 0: down to label0
# BB#8:                                 # %if.end47
	i32.const	$push44=, 0
	call    	exit@FUNCTION, $pop44
	unreachable
.LBB4_9:                                # %if.then46
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.hidden	tmp                     # @tmp
	.type	tmp,@object
	.section	.data.tmp,"aw",@progbits
	.globl	tmp
	.p2align	3
tmp:
	.int8	35                      # 0x23
	.int8	209                     # 0xd1
	.int8	188                     # 0xbc
	.int8	154                     # 0x9a
	.int8	120                     # 0x78
	.int8	86                      # 0x56
	.int8	52                      # 0x34
	.int8	18                      # 0x12
	.size	tmp, 8

	.hidden	tmp2                    # @tmp2
	.type	tmp2,@object
	.section	.data.tmp2,"aw",@progbits
	.globl	tmp2
	.p2align	3
tmp2:
	.int8	205                     # 0xcd
	.int8	171                     # 0xab
	.int8	137                     # 0x89
	.int8	103                     # 0x67
	.int8	69                      # 0x45
	.int8	35                      # 0x23
	.int8	49                      # 0x31
	.int8	18                      # 0x12
	.size	tmp2, 8

	.hidden	tmp3                    # @tmp3
	.type	tmp3,@object
	.section	.data.tmp3,"aw",@progbits
	.globl	tmp3
	.p2align	3
tmp3:
	.int8	35                      # 0x23
	.int8	1                       # 0x1
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	248                     # 0xf8
	.int8	255                     # 0xff
	.int8	15                      # 0xf
	.size	tmp3, 8

	.hidden	tmp4                    # @tmp4
	.type	tmp4,@object
	.section	.data.tmp4,"aw",@progbits
	.globl	tmp4
	.p2align	3
tmp4:
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	255                     # 0xff
	.int8	255                     # 0xff
	.int8	97                      # 0x61
	.int8	36                      # 0x24
	.size	tmp4, 8


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
