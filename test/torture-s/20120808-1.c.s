	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120808-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 32
	i32.sub 	$8=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	i32.const	$push7=, 8
	i32.or  	$push8=, $8, $pop7
	i32.const	$push4=, 16
	i32.add 	$push5=, $8, $pop4
	i32.const	$push0=, 24
	i32.add 	$push1=, $8, $pop0
	i64.const	$push2=, 0
	i64.store	$push3=, 0($pop1), $pop2
	i64.store	$push6=, 0($pop5):p2align=4, $pop3
	i64.store	$push9=, 0($pop8), $pop6
	i64.store	$discard=, 0($8):p2align=4, $pop9
	i32.const	$push42=, 0
	i32.load	$push10=, i($pop42)
	i32.const	$push11=, d+1
	i32.add 	$0=, $pop10, $pop11
	i32.const	$2=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$push45=, $0, $2
	tee_local	$push44=, $4=, $pop45
	i32.load8_u	$1=, 0($pop44)
	block
	block
	block
	i32.const	$push43=, 25
	i32.eq  	$push12=, $2, $pop43
	br_if   	0, $pop12       # 0: down to label4
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push46=, 2
	i32.eq  	$push13=, $2, $pop46
	br_if   	1, $pop13       # 1: down to label3
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$3=, 255
	i32.const	$push47=, 1
	i32.ne  	$push14=, $2, $pop47
	br_if   	2, $pop14       # 2: down to label2
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
	i32.add 	$push16=, $8, $2
	i32.or  	$push15=, $3, $1
	i32.store8	$discard=, 0($pop16), $pop15
	i32.const	$push50=, 0
	i32.store	$discard=, cp($pop50), $4
	i32.const	$push49=, 1
	i32.add 	$2=, $2, $pop49
	i32.const	$push48=, 30
	i32.ne  	$push17=, $2, $pop48
	br_if   	0, $pop17       # 0: up to label0
# BB#8:                                 # %for.end
	end_loop                        # label1:
	block
	i64.load	$push52=, 0($8):p2align=4
	tee_local	$push51=, $5=, $pop52
	i64.const	$push23=, 65535
	i64.and 	$push24=, $pop51, $pop23
	i64.const	$push26=, 65023
	i64.ne  	$push27=, $pop24, $pop26
	br_if   	0, $pop27       # 0: down to label5
# BB#9:                                 # %for.end
	i32.wrap/i64	$push21=, $5
	i32.const	$push22=, 16
	i32.shr_u	$push18=, $pop21, $pop22
	i32.const	$push28=, 255
	i32.and 	$push29=, $pop18, $pop28
	i32.const	$push30=, 251
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label5
# BB#10:                                # %for.end
	i32.load	$push19=, 0($8):p2align=4
	i32.const	$push32=, -16777216
	i32.lt_u	$push33=, $pop19, $pop32
	br_if   	0, $pop33       # 0: down to label5
# BB#11:                                # %for.end
	i64.const	$push25=, 1095216660480
	i64.and 	$push20=, $5, $pop25
	i64.const	$push34=, 1095216660480
	i64.ne  	$push35=, $pop20, $pop34
	br_if   	0, $pop35       # 0: down to label5
# BB#12:                                # %lor.lhs.false29
	i32.load8_u	$push36=, 25($8)
	i32.const	$push37=, 254
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	0, $pop38       # 0: down to label5
# BB#13:                                # %lor.lhs.false34
	i32.const	$push53=, 0
	i32.load	$push39=, cp($pop53)
	i32.const	$push40=, d+30
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label5
# BB#14:                                # %if.end
	i32.const	$push54=, 0
	call    	exit@FUNCTION, $pop54
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
