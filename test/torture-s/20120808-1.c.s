	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120808-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i64
# BB#0:                                 # %entry
	i32.const	$push43=, __stack_pointer
	i32.const	$push40=, __stack_pointer
	i32.load	$push41=, 0($pop40)
	i32.const	$push42=, 32
	i32.sub 	$push44=, $pop41, $pop42
	i32.store	$0=, 0($pop43), $pop44
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.const	$push3=, 24
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 0
	i64.store	$push0=, 0($pop4), $pop5
	i64.store	$push1=, 0($pop7), $pop0
	i64.store	$push2=, 8($0), $pop1
	i64.store	$discard=, 0($0), $pop2
	i32.const	$push45=, 0
	i32.load	$push8=, i($pop45)
	i32.const	$push9=, d+1
	i32.add 	$1=, $pop8, $pop9
	i32.const	$3=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$push48=, $1, $3
	tee_local	$push47=, $5=, $pop48
	i32.load8_u	$2=, 0($pop47)
	block
	block
	block
	i32.const	$push46=, 25
	i32.eq  	$push10=, $3, $pop46
	br_if   	0, $pop10       # 0: down to label4
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push49=, 2
	i32.eq  	$push11=, $3, $pop49
	br_if   	1, $pop11       # 1: down to label3
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$4=, 255
	i32.const	$push50=, 1
	i32.ne  	$push12=, $3, $pop50
	br_if   	2, $pop12       # 2: down to label2
# BB#4:                                 # %sw.bb
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$4=, 253
	br      	2               # 2: down to label2
.LBB0_5:                                # %sw.bb3
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.const	$4=, 254
	br      	1               # 1: down to label2
.LBB0_6:                                # %sw.bb1
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$4=, 251
.LBB0_7:                                # %sw.epilog
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.add 	$push14=, $0, $3
	i32.or  	$push13=, $4, $2
	i32.store8	$discard=, 0($pop14), $pop13
	i32.const	$push53=, 0
	i32.store	$discard=, cp($pop53), $5
	i32.const	$push52=, 1
	i32.add 	$3=, $3, $pop52
	i32.const	$push51=, 30
	i32.ne  	$push15=, $3, $pop51
	br_if   	0, $pop15       # 0: up to label0
# BB#8:                                 # %for.end
	end_loop                        # label1:
	block
	i64.load	$push55=, 0($0)
	tee_local	$push54=, $6=, $pop55
	i64.const	$push21=, 65535
	i64.and 	$push22=, $pop54, $pop21
	i64.const	$push24=, 65023
	i64.ne  	$push25=, $pop22, $pop24
	br_if   	0, $pop25       # 0: down to label5
# BB#9:                                 # %for.end
	i32.wrap/i64	$push19=, $6
	i32.const	$push20=, 16
	i32.shr_u	$push16=, $pop19, $pop20
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
	i64.const	$push23=, 1095216660480
	i64.and 	$push18=, $6, $pop23
	i64.const	$push32=, 1095216660480
	i64.ne  	$push33=, $pop18, $pop32
	br_if   	0, $pop33       # 0: down to label5
# BB#12:                                # %lor.lhs.false29
	i32.load8_u	$push34=, 25($0)
	i32.const	$push35=, 254
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label5
# BB#13:                                # %lor.lhs.false34
	i32.const	$push56=, 0
	i32.load	$push37=, cp($pop56)
	i32.const	$push38=, d+30
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label5
# BB#14:                                # %if.end
	i32.const	$push57=, 0
	call    	exit@FUNCTION, $pop57
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
