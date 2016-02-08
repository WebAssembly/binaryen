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
	i32.const	$push8=, 8
	i32.or  	$push9=, $8, $pop8
	i32.const	$push5=, 16
	i32.add 	$push6=, $8, $pop5
	i32.const	$push1=, 24
	i32.add 	$push2=, $8, $pop1
	i64.const	$push3=, 0
	i64.store	$push4=, 0($pop2), $pop3
	i64.store	$push7=, 0($pop6):p2align=4, $pop4
	i64.store	$push10=, 0($pop9), $pop7
	i64.store	$discard=, 0($8):p2align=4, $pop10
	i32.const	$push44=, 0
	i32.load	$push11=, i($pop44)
	i32.const	$push12=, d+1
	i32.add 	$0=, $pop11, $pop12
	i32.const	$2=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$push0=, $0, $2
	tee_local	$push46=, $4=, $pop0
	i32.load8_u	$1=, 0($pop46)
	block
	block
	i32.const	$push45=, 25
	i32.eq  	$push13=, $2, $pop45
	br_if   	0, $pop13       # 0: down to label3
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	block
	i32.const	$push47=, 2
	i32.eq  	$push14=, $2, $pop47
	br_if   	0, $pop14       # 0: down to label4
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$3=, 255
	i32.const	$push48=, 1
	i32.ne  	$push15=, $2, $pop48
	br_if   	2, $pop15       # 2: down to label2
# BB#4:                                 # %sw.bb
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$3=, 253
	br      	2               # 2: down to label2
.LBB0_5:                                # %sw.bb1
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.const	$3=, 251
	br      	1               # 1: down to label2
.LBB0_6:                                # %sw.bb3
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$3=, 254
.LBB0_7:                                # %sw.epilog
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.add 	$push17=, $8, $2
	i32.or  	$push16=, $3, $1
	i32.store8	$discard=, 0($pop17), $pop16
	i32.const	$push51=, 0
	i32.store	$discard=, cp($pop51), $4
	i32.const	$push50=, 1
	i32.add 	$2=, $2, $pop50
	i32.const	$push49=, 30
	i32.ne  	$push18=, $2, $pop49
	br_if   	0, $pop18       # 0: up to label0
# BB#8:                                 # %for.end
	end_loop                        # label1:
	block
	i64.load	$push22=, 0($8):p2align=4
	tee_local	$push52=, $5=, $pop22
	i64.const	$push25=, 65535
	i64.and 	$push26=, $pop52, $pop25
	i64.const	$push28=, 65023
	i64.ne  	$push29=, $pop26, $pop28
	br_if   	0, $pop29       # 0: down to label5
# BB#9:                                 # %for.end
	i32.wrap/i64	$push23=, $5
	i32.const	$push24=, 16
	i32.shr_u	$push19=, $pop23, $pop24
	i32.const	$push30=, 255
	i32.and 	$push31=, $pop19, $pop30
	i32.const	$push32=, 251
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label5
# BB#10:                                # %for.end
	i32.load	$push20=, 0($8):p2align=4
	i32.const	$push34=, -16777216
	i32.lt_u	$push35=, $pop20, $pop34
	br_if   	0, $pop35       # 0: down to label5
# BB#11:                                # %for.end
	i64.const	$push27=, 1095216660480
	i64.and 	$push21=, $5, $pop27
	i64.const	$push36=, 1095216660480
	i64.ne  	$push37=, $pop21, $pop36
	br_if   	0, $pop37       # 0: down to label5
# BB#12:                                # %lor.lhs.false29
	i32.load8_u	$push38=, 25($8)
	i32.const	$push39=, 254
	i32.ne  	$push40=, $pop38, $pop39
	br_if   	0, $pop40       # 0: down to label5
# BB#13:                                # %lor.lhs.false34
	i32.const	$push53=, 0
	i32.load	$push41=, cp($pop53)
	i32.const	$push42=, d+30
	i32.ne  	$push43=, $pop41, $pop42
	br_if   	0, $pop43       # 0: down to label5
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
