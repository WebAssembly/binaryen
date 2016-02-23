	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120808-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	i32.const	$push53=, __stack_pointer
	i32.load	$push54=, 0($pop53)
	i32.const	$push55=, 32
	i32.sub 	$6=, $pop54, $pop55
	i32.const	$push56=, __stack_pointer
	i32.store	$discard=, 0($pop56), $6
	i32.const	$push4=, 16
	i32.add 	$push5=, $6, $pop4
	i32.const	$push0=, 24
	i32.add 	$push1=, $6, $pop0
	i64.const	$push2=, 0
	i64.store	$push3=, 0($pop1), $pop2
	i64.store	$push6=, 0($pop5):p2align=4, $pop3
	i64.store	$push7=, 8($6), $pop6
	i64.store	$discard=, 0($6):p2align=4, $pop7
	i32.const	$push40=, 0
	i32.load	$push8=, i($pop40)
	i32.const	$push9=, d+1
	i32.add 	$0=, $pop8, $pop9
	i32.const	$2=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$push43=, $0, $2
	tee_local	$push42=, $4=, $pop43
	i32.load8_u	$1=, 0($pop42)
	block
	block
	block
	i32.const	$push41=, 25
	i32.eq  	$push10=, $2, $pop41
	br_if   	0, $pop10       # 0: down to label4
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push44=, 2
	i32.eq  	$push11=, $2, $pop44
	br_if   	1, $pop11       # 1: down to label3
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$3=, 255
	i32.const	$push45=, 1
	i32.ne  	$push12=, $2, $pop45
	br_if   	2, $pop12       # 2: down to label2
# BB#4:                                 # %sw.bb
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$3=, 253
	br      	2               # 2: down to label2
.LBB0_5:                                # %sw.bb3
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.const	$3=, 254
	br      	1               # 1: down to label2
.LBB0_6:                                # %sw.bb1
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$3=, 251
.LBB0_7:                                # %sw.epilog
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.add 	$push14=, $6, $2
	i32.or  	$push13=, $3, $1
	i32.store8	$discard=, 0($pop14), $pop13
	i32.const	$push48=, 0
	i32.store	$discard=, cp($pop48), $4
	i32.const	$push47=, 1
	i32.add 	$2=, $2, $pop47
	i32.const	$push46=, 30
	i32.ne  	$push15=, $2, $pop46
	br_if   	0, $pop15       # 0: up to label0
# BB#8:                                 # %for.end
	end_loop                        # label1:
	block
	i64.load	$push50=, 0($6):p2align=4
	tee_local	$push49=, $5=, $pop50
	i64.const	$push21=, 65535
	i64.and 	$push22=, $pop49, $pop21
	i64.const	$push24=, 65023
	i64.ne  	$push25=, $pop22, $pop24
	br_if   	0, $pop25       # 0: down to label5
# BB#9:                                 # %for.end
	i32.wrap/i64	$push19=, $5
	i32.const	$push20=, 16
	i32.shr_u	$push16=, $pop19, $pop20
	i32.const	$push26=, 255
	i32.and 	$push27=, $pop16, $pop26
	i32.const	$push28=, 251
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label5
# BB#10:                                # %for.end
	i32.load	$push17=, 0($6):p2align=4
	i32.const	$push30=, -16777216
	i32.lt_u	$push31=, $pop17, $pop30
	br_if   	0, $pop31       # 0: down to label5
# BB#11:                                # %for.end
	i64.const	$push23=, 1095216660480
	i64.and 	$push18=, $5, $pop23
	i64.const	$push32=, 1095216660480
	i64.ne  	$push33=, $pop18, $pop32
	br_if   	0, $pop33       # 0: down to label5
# BB#12:                                # %lor.lhs.false29
	i32.load8_u	$push34=, 25($6)
	i32.const	$push35=, 254
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label5
# BB#13:                                # %lor.lhs.false34
	i32.const	$push51=, 0
	i32.load	$push37=, cp($pop51)
	i32.const	$push38=, d+30
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label5
# BB#14:                                # %if.end
	i32.const	$push52=, 0
	call    	exit@FUNCTION, $pop52
	unreachable
.LBB0_15:                               # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	4
d:
	.skip	32
	.size	d, 32

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	cp                      # @cp
	.type	cp,@object
	.section	.bss.cp,"aw",@nobits
	.globl	cp
	.p2align	2
cp:
	.int32	0
	.size	cp, 4


	.ident	"clang version 3.9.0 "
