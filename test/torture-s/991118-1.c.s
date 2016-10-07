	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991118-1.c"
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
	i64.store	0($0), $pop2
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
	i64.store	0($0), $pop2
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
	i64.store	0($0), $pop2
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
	i64.store	0($0), $pop2
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
	i32.const	$push1=, 0
	i32.const	$push51=, 0
	i64.load	$push50=, tmp($pop51)
	tee_local	$push49=, $2=, $pop50
	i64.const	$push2=, -8690468286197432320
	i64.xor 	$push48=, $pop49, $pop2
	tee_local	$push47=, $3=, $pop48
	i64.store	tmp($pop1), $pop47
	i32.const	$push46=, 0
	i32.const	$push45=, 0
	i64.load	$push44=, tmp2($pop45)
	tee_local	$push43=, $0=, $pop44
	i64.const	$push3=, 2381903268435576
	i64.xor 	$push42=, $pop43, $pop3
	tee_local	$push41=, $1=, $pop42
	i64.store	tmp2($pop46), $pop41
	block   	
	i64.const	$push4=, -4096
	i64.and 	$push5=, $3, $pop4
	i64.const	$push6=, -7687337405579571200
	i64.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %entry
	i64.const	$push8=, 52
	i64.shl 	$push9=, $2, $pop8
	i64.const	$push53=, 52
	i64.shr_s	$push10=, $pop9, $pop53
	i32.wrap/i64	$push0=, $pop10
	i32.const	$push52=, 291
	i32.ne  	$push11=, $pop0, $pop52
	br_if   	0, $pop11       # 0: down to label0
# BB#2:                                 # %if.end
	i64.const	$push14=, 52
	i64.shr_s	$push15=, $0, $pop14
	i32.wrap/i64	$push16=, $pop15
	i32.const	$push54=, 291
	i32.ne  	$push17=, $pop16, $pop54
	br_if   	0, $pop17       # 0: down to label0
# BB#3:                                 # %if.end
	i64.const	$push13=, 4503599627370495
	i64.and 	$push12=, $1, $pop13
	i64.const	$push18=, 2626808268586421
	i64.ne  	$push19=, $pop12, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#4:                                 # %if.end19
	i32.const	$push21=, 0
	i32.const	$push65=, 0
	i64.load	$push64=, tmp3($pop65)
	tee_local	$push63=, $2=, $pop64
	i64.const	$push22=, -4345234143098716160
	i64.xor 	$push62=, $pop63, $pop22
	tee_local	$push61=, $3=, $pop62
	i64.store	tmp3($pop21), $pop61
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	i64.load	$push58=, tmp4($pop59)
	tee_local	$push57=, $0=, $pop58
	i64.const	$push23=, 6885502895806072
	i64.xor 	$push56=, $pop57, $pop23
	tee_local	$push55=, $1=, $pop56
	i64.store	tmp4($pop60), $pop55
	i64.const	$push24=, -2048
	i64.and 	$push25=, $3, $pop24
	i64.const	$push26=, -3725223934242340864
	i64.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#5:                                 # %if.end19
	i64.const	$push28=, 53
	i64.shl 	$push29=, $2, $pop28
	i64.const	$push67=, 53
	i64.shr_s	$push30=, $pop29, $pop67
	i32.wrap/i64	$push20=, $pop30
	i32.const	$push66=, 291
	i32.ne  	$push31=, $pop20, $pop66
	br_if   	0, $pop31       # 0: down to label0
# BB#6:                                 # %if.end34
	i64.const	$push34=, 53
	i64.shr_s	$push35=, $0, $pop34
	i32.wrap/i64	$push36=, $pop35
	i32.const	$push68=, 291
	i32.ne  	$push37=, $pop36, $pop68
	br_if   	0, $pop37       # 0: down to label0
# BB#7:                                 # %if.end34
	i64.const	$push33=, 9007199254740991
	i64.and 	$push32=, $1, $pop33
	i64.const	$push38=, 7188242255599224
	i64.ne  	$push39=, $pop32, $pop38
	br_if   	0, $pop39       # 0: down to label0
# BB#8:                                 # %if.end47
	i32.const	$push40=, 0
	call    	exit@FUNCTION, $pop40
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
