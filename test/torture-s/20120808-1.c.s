	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120808-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push43=, 0
	i32.const	$push40=, 0
	i32.load	$push41=, __stack_pointer($pop40)
	i32.const	$push42=, 32
	i32.sub 	$push44=, $pop41, $pop42
	i32.store	$push47=, __stack_pointer($pop43), $pop44
	tee_local	$push46=, $0=, $pop47
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.const	$push3=, 24
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 0
	i64.store	$push0=, 0($pop4), $pop5
	i64.store	$push1=, 0($pop7), $pop0
	i64.store	$push2=, 8($0), $pop1
	i64.store	$drop=, 0($pop46), $pop2
	i32.const	$push45=, 0
	i32.load	$push8=, i($pop45)
	i32.const	$push9=, d+1
	i32.add 	$1=, $pop8, $pop9
	i32.const	$5=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$push50=, $1, $5
	tee_local	$push49=, $2=, $pop50
	i32.load8_u	$3=, 0($pop49)
	block
	block
	block
	i32.const	$push48=, 25
	i32.eq  	$push10=, $5, $pop48
	br_if   	0, $pop10       # 0: down to label4
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push51=, 2
	i32.eq  	$push11=, $5, $pop51
	br_if   	1, $pop11       # 1: down to label3
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$6=, 255
	i32.const	$push52=, 1
	i32.ne  	$push12=, $5, $pop52
	br_if   	2, $pop12       # 2: down to label2
# BB#4:                                 # %sw.bb
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$6=, 253
	br      	2               # 2: down to label2
.LBB0_5:                                # %sw.bb3
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.const	$6=, 254
	br      	1               # 1: down to label2
.LBB0_6:                                # %sw.bb1
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$6=, 251
.LBB0_7:                                # %sw.epilog
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push57=, 0
	i32.store	$drop=, cp($pop57), $2
	i32.add 	$push14=, $0, $5
	i32.or  	$push13=, $6, $3
	i32.store8	$drop=, 0($pop14), $pop13
	i32.const	$push56=, 1
	i32.add 	$push55=, $5, $pop56
	tee_local	$push54=, $5=, $pop55
	i32.const	$push53=, 30
	i32.ne  	$push15=, $pop54, $pop53
	br_if   	0, $pop15       # 0: up to label0
# BB#8:                                 # %for.end
	end_loop                        # label1:
	block
	i64.load	$push59=, 0($0)
	tee_local	$push58=, $4=, $pop59
	i64.const	$push22=, 65535
	i64.and 	$push23=, $pop58, $pop22
	i64.const	$push24=, 65023
	i64.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label5
# BB#9:                                 # %for.end
	i32.wrap/i64	$push20=, $4
	i32.const	$push21=, 16
	i32.shr_u	$push16=, $pop20, $pop21
	i32.const	$push26=, 255
	i32.and 	$push27=, $pop16, $pop26
	i32.const	$push28=, 251
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label5
# BB#10:                                # %for.end
	i32.load	$push17=, 0($0)
	i32.const	$push30=, -16777216
	i32.lt_u	$push31=, $pop17, $pop30
	br_if   	0, $pop31       # 0: down to label5
# BB#11:                                # %for.end
	i64.const	$push19=, 1095216660480
	i64.and 	$push18=, $4, $pop19
	i64.const	$push32=, 1095216660480
	i64.ne  	$push33=, $pop18, $pop32
	br_if   	0, $pop33       # 0: down to label5
# BB#12:                                # %lor.lhs.false29
	i32.load8_u	$push35=, 25($0)
	i32.const	$push34=, 254
	i32.ne  	$push36=, $pop35, $pop34
	br_if   	0, $pop36       # 0: down to label5
# BB#13:                                # %lor.lhs.false34
	i32.const	$push60=, 0
	i32.load	$push37=, cp($pop60)
	i32.const	$push38=, d+30
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label5
# BB#14:                                # %if.end
	i32.const	$push61=, 0
	call    	exit@FUNCTION, $pop61
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
	.functype	abort, void
	.functype	exit, void, i32
