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
	i64.store	$discard=, 0($0), $pop2
	return
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
	i64.store	$discard=, 0($0), $pop2
	return
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
	i64.store	$discard=, 0($0), $pop2
	return
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
	i64.store	$discard=, 0($0), $pop2
	return
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
	i64.load	$0=, tmp2($pop3)
	i32.const	$push50=, 0
	i32.const	$push49=, 0
	i64.load	$push4=, tmp($pop49)
	tee_local	$push48=, $3=, $pop4
	i64.const	$push5=, -8690468286197432320
	i64.xor 	$push6=, $pop48, $pop5
	i64.store	$1=, tmp($pop50), $pop6
	i32.const	$push47=, 0
	i64.const	$push7=, 2381903268435576
	i64.xor 	$push0=, $0, $pop7
	i64.store	$2=, tmp2($pop47), $pop0
	block
	i64.const	$push11=, -4096
	i64.and 	$push12=, $1, $pop11
	i64.const	$push13=, -7687337405579571200
	i64.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#1:                                 # %entry
	i64.const	$push8=, 52
	i64.shl 	$push9=, $3, $pop8
	i64.const	$push52=, 52
	i64.shr_s	$push10=, $pop9, $pop52
	i32.wrap/i64	$push2=, $pop10
	i32.const	$push51=, 291
	i32.ne  	$push15=, $pop2, $pop51
	br_if   	0, $pop15       # 0: down to label0
# BB#2:                                 # %if.end
	block
	i64.const	$push17=, 52
	i64.shr_s	$push18=, $0, $pop17
	i32.wrap/i64	$push19=, $pop18
	i32.const	$push53=, 291
	i32.ne  	$push21=, $pop19, $pop53
	br_if   	0, $pop21       # 0: down to label1
# BB#3:                                 # %if.end
	i64.const	$push20=, 4503599627370495
	i64.and 	$push16=, $2, $pop20
	i64.const	$push22=, 2626808268586421
	i64.ne  	$push23=, $pop16, $pop22
	br_if   	0, $pop23       # 0: down to label1
# BB#4:                                 # %if.end19
	i32.const	$push25=, 0
	i64.load	$0=, tmp4($pop25)
	i32.const	$push57=, 0
	i32.const	$push56=, 0
	i64.load	$push26=, tmp3($pop56)
	tee_local	$push55=, $3=, $pop26
	i64.const	$push27=, -4345234143098716160
	i64.xor 	$push28=, $pop55, $pop27
	i64.store	$1=, tmp3($pop57), $pop28
	i32.const	$push54=, 0
	i64.const	$push29=, 6885502895806072
	i64.xor 	$push1=, $0, $pop29
	i64.store	$2=, tmp4($pop54), $pop1
	block
	i64.const	$push33=, -2048
	i64.and 	$push34=, $1, $pop33
	i64.const	$push35=, -3725223934242340864
	i64.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label2
# BB#5:                                 # %if.end19
	i64.const	$push30=, 53
	i64.shl 	$push31=, $3, $pop30
	i64.const	$push59=, 53
	i64.shr_s	$push32=, $pop31, $pop59
	i32.wrap/i64	$push24=, $pop32
	i32.const	$push58=, 291
	i32.ne  	$push37=, $pop24, $pop58
	br_if   	0, $pop37       # 0: down to label2
# BB#6:                                 # %if.end34
	block
	i64.const	$push39=, 53
	i64.shr_s	$push40=, $0, $pop39
	i32.wrap/i64	$push41=, $pop40
	i32.const	$push60=, 291
	i32.ne  	$push43=, $pop41, $pop60
	br_if   	0, $pop43       # 0: down to label3
# BB#7:                                 # %if.end34
	i64.const	$push42=, 9007199254740991
	i64.and 	$push38=, $2, $pop42
	i64.const	$push44=, 7188242255599224
	i64.ne  	$push45=, $pop38, $pop44
	br_if   	0, $pop45       # 0: down to label3
# BB#8:                                 # %if.end47
	i32.const	$push46=, 0
	call    	exit@FUNCTION, $pop46
	unreachable
.LBB4_9:                                # %if.then46
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB4_10:                               # %if.then33
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB4_11:                               # %if.then18
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB4_12:                               # %if.then
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
