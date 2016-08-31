	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120808-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push40=, 0
	i32.const	$push37=, 0
	i32.load	$push38=, __stack_pointer($pop37)
	i32.const	$push39=, 32
	i32.sub 	$push46=, $pop38, $pop39
	tee_local	$push45=, $6=, $pop46
	i32.store	$drop=, __stack_pointer($pop40), $pop45
	i32.const	$push0=, 24
	i32.add 	$push1=, $6, $pop0
	i64.const	$push2=, 0
	i64.store	$drop=, 0($pop1), $pop2
	i32.const	$push3=, 16
	i32.add 	$push4=, $6, $pop3
	i64.const	$push44=, 0
	i64.store	$drop=, 0($pop4), $pop44
	i64.const	$push43=, 0
	i64.store	$drop=, 8($6), $pop43
	i64.const	$push42=, 0
	i64.store	$drop=, 0($6), $pop42
	i32.const	$push41=, 0
	i32.load	$push5=, i($pop41)
	i32.const	$push6=, d+1
	i32.add 	$0=, $pop5, $pop6
	i32.const	$4=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$push49=, $0, $4
	tee_local	$push48=, $1=, $pop49
	i32.load8_u	$2=, 0($pop48)
	block
	block
	block
	i32.const	$push47=, 25
	i32.eq  	$push7=, $4, $pop47
	br_if   	0, $pop7        # 0: down to label4
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push50=, 2
	i32.eq  	$push8=, $4, $pop50
	br_if   	1, $pop8        # 1: down to label3
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$5=, 255
	i32.const	$push51=, 1
	i32.ne  	$push9=, $4, $pop51
	br_if   	2, $pop9        # 2: down to label2
# BB#4:                                 # %sw.bb
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$5=, 253
	br      	2               # 2: down to label2
.LBB0_5:                                # %sw.bb3
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.const	$5=, 254
	br      	1               # 1: down to label2
.LBB0_6:                                # %sw.bb1
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$5=, 251
.LBB0_7:                                # %sw.epilog
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push56=, 0
	i32.store	$drop=, cp($pop56), $1
	i32.add 	$push11=, $6, $4
	i32.or  	$push10=, $5, $2
	i32.store8	$drop=, 0($pop11), $pop10
	i32.const	$push55=, 1
	i32.add 	$push54=, $4, $pop55
	tee_local	$push53=, $4=, $pop54
	i32.const	$push52=, 30
	i32.ne  	$push12=, $pop53, $pop52
	br_if   	0, $pop12       # 0: up to label0
# BB#8:                                 # %for.end
	end_loop                        # label1:
	block
	i64.load	$push58=, 0($6)
	tee_local	$push57=, $3=, $pop58
	i64.const	$push19=, 65535
	i64.and 	$push20=, $pop57, $pop19
	i64.const	$push21=, 65023
	i64.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label5
# BB#9:                                 # %for.end
	i32.wrap/i64	$push17=, $3
	i32.const	$push18=, 16
	i32.shr_u	$push13=, $pop17, $pop18
	i32.const	$push23=, 255
	i32.and 	$push24=, $pop13, $pop23
	i32.const	$push25=, 251
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label5
# BB#10:                                # %for.end
	i32.load	$push14=, 0($6)
	i32.const	$push27=, -16777216
	i32.lt_u	$push28=, $pop14, $pop27
	br_if   	0, $pop28       # 0: down to label5
# BB#11:                                # %for.end
	i64.const	$push16=, 1095216660480
	i64.and 	$push15=, $3, $pop16
	i64.const	$push29=, 1095216660480
	i64.ne  	$push30=, $pop15, $pop29
	br_if   	0, $pop30       # 0: down to label5
# BB#12:                                # %lor.lhs.false29
	i32.load8_u	$push32=, 25($6)
	i32.const	$push31=, 254
	i32.ne  	$push33=, $pop32, $pop31
	br_if   	0, $pop33       # 0: down to label5
# BB#13:                                # %lor.lhs.false34
	i32.const	$push59=, 0
	i32.load	$push34=, cp($pop59)
	i32.const	$push35=, d+30
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label5
# BB#14:                                # %if.end
	i32.const	$push60=, 0
	call    	exit@FUNCTION, $pop60
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
