	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120808-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push35=, 0
	i32.const	$push32=, 0
	i32.load	$push33=, __stack_pointer($pop32)
	i32.const	$push34=, 32
	i32.sub 	$push41=, $pop33, $pop34
	tee_local	$push40=, $5=, $pop41
	i32.store	__stack_pointer($pop35), $pop40
	i32.const	$push0=, 24
	i32.add 	$push1=, $5, $pop0
	i64.const	$push2=, 0
	i64.store	0($pop1), $pop2
	i32.const	$push3=, 16
	i32.add 	$push4=, $5, $pop3
	i64.const	$push39=, 0
	i64.store	0($pop4), $pop39
	i64.const	$push38=, 0
	i64.store	8($5), $pop38
	i64.const	$push37=, 0
	i64.store	0($5), $pop37
	i32.const	$push36=, 0
	i32.load	$push5=, i($pop36)
	i32.const	$push6=, d+1
	i32.add 	$0=, $pop5, $pop6
	i32.const	$3=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.add 	$push44=, $0, $3
	tee_local	$push43=, $1=, $pop44
	i32.load8_u	$2=, 0($pop43)
	block   	
	block   	
	i32.const	$push42=, 25
	i32.eq  	$push7=, $3, $pop42
	br_if   	0, $pop7        # 0: down to label2
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	block   	
	i32.const	$push45=, 2
	i32.eq  	$push8=, $3, $pop45
	br_if   	0, $pop8        # 0: down to label3
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$4=, 255
	i32.const	$push46=, 1
	i32.ne  	$push9=, $3, $pop46
	br_if   	2, $pop9        # 2: down to label1
# BB#4:                                 # %sw.bb
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$4=, 253
	br      	2               # 2: down to label1
.LBB0_5:                                # %sw.bb1
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$4=, 251
	br      	1               # 1: down to label1
.LBB0_6:                                # %sw.bb3
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$4=, 254
.LBB0_7:                                # %sw.epilog
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label1:
	i32.const	$push51=, 0
	i32.store	cp($pop51), $1
	i32.add 	$push11=, $5, $3
	i32.or  	$push10=, $4, $2
	i32.store8	0($pop11), $pop10
	i32.const	$push50=, 1
	i32.add 	$push49=, $3, $pop50
	tee_local	$push48=, $3=, $pop49
	i32.const	$push47=, 30
	i32.ne  	$push12=, $pop48, $pop47
	br_if   	0, $pop12       # 0: up to label0
# BB#8:                                 # %for.end
	end_loop
	block   	
	i32.load8_u	$push14=, 0($5)
	i32.const	$push13=, 255
	i32.ne  	$push15=, $pop14, $pop13
	br_if   	0, $pop15       # 0: down to label4
# BB#9:                                 # %lor.lhs.false
	i32.load8_u	$push17=, 1($5)
	i32.const	$push16=, 253
	i32.ne  	$push18=, $pop17, $pop16
	br_if   	0, $pop18       # 0: down to label4
# BB#10:                                # %lor.lhs.false14
	i32.load8_u	$push20=, 2($5)
	i32.const	$push19=, 251
	i32.ne  	$push21=, $pop20, $pop19
	br_if   	0, $pop21       # 0: down to label4
# BB#11:                                # %lor.lhs.false19
	i32.load8_u	$push22=, 3($5)
	i32.const	$push52=, 255
	i32.ne  	$push23=, $pop22, $pop52
	br_if   	0, $pop23       # 0: down to label4
# BB#12:                                # %lor.lhs.false24
	i32.load8_u	$push24=, 4($5)
	i32.const	$push53=, 255
	i32.ne  	$push25=, $pop24, $pop53
	br_if   	0, $pop25       # 0: down to label4
# BB#13:                                # %lor.lhs.false29
	i32.load8_u	$push27=, 25($5)
	i32.const	$push26=, 254
	i32.ne  	$push28=, $pop27, $pop26
	br_if   	0, $pop28       # 0: down to label4
# BB#14:                                # %lor.lhs.false34
	i32.const	$push54=, 0
	i32.load	$push29=, cp($pop54)
	i32.const	$push30=, d+30
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label4
# BB#15:                                # %if.end
	i32.const	$push55=, 0
	call    	exit@FUNCTION, $pop55
	unreachable
.LBB0_16:                               # %if.then
	end_block                       # label4:
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
