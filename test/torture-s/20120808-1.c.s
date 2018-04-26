	.text
	.file	"20120808-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push33=, 0
	i32.load	$push32=, __stack_pointer($pop33)
	i32.const	$push34=, 32
	i32.sub 	$6=, $pop32, $pop34
	i32.const	$push35=, 0
	i32.store	__stack_pointer($pop35), $6
	i32.const	$push0=, 24
	i32.add 	$push1=, $6, $pop0
	i64.const	$push2=, 0
	i64.store	0($pop1), $pop2
	i32.const	$push3=, 16
	i32.add 	$push4=, $6, $pop3
	i64.const	$push39=, 0
	i64.store	0($pop4), $pop39
	i64.const	$push38=, 0
	i64.store	8($6), $pop38
	i64.const	$push37=, 0
	i64.store	0($6), $pop37
	i32.const	$push36=, 0
	i32.load	$push5=, i($pop36)
	i32.const	$push6=, d+1
	i32.add 	$0=, $pop5, $pop6
	i32.const	$4=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push41=, 2147483647
	i32.and 	$3=, $4, $pop41
	i32.add 	$1=, $0, $4
	i32.load8_u	$2=, 0($1)
	block   	
	block   	
	i32.const	$push40=, 25
	i32.eq  	$push7=, $3, $pop40
	br_if   	0, $pop7        # 0: down to label2
# %bb.2:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	block   	
	i32.const	$push42=, 2
	i32.eq  	$push8=, $3, $pop42
	br_if   	0, $pop8        # 0: down to label3
# %bb.3:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$5=, 255
	i32.const	$push43=, 1
	i32.ne  	$push9=, $3, $pop43
	br_if   	2, $pop9        # 2: down to label1
# %bb.4:                                # %sw.bb
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$5=, 253
	br      	2               # 2: down to label1
.LBB0_5:                                # %sw.bb1
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$5=, 251
	br      	1               # 1: down to label1
.LBB0_6:                                # %sw.bb3
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$5=, 254
.LBB0_7:                                # %sw.epilog
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label1:
	i32.const	$push46=, 0
	i32.store	cp($pop46), $1
	i32.add 	$push11=, $6, $4
	i32.or  	$push10=, $5, $2
	i32.store8	0($pop11), $pop10
	i32.const	$push45=, 1
	i32.add 	$4=, $4, $pop45
	i32.const	$push44=, 30
	i32.ne  	$push12=, $4, $pop44
	br_if   	0, $pop12       # 0: up to label0
# %bb.8:                                # %for.end
	end_loop
	block   	
	i32.load8_u	$push14=, 0($6)
	i32.const	$push13=, 255
	i32.ne  	$push15=, $pop14, $pop13
	br_if   	0, $pop15       # 0: down to label4
# %bb.9:                                # %lor.lhs.false
	i32.load8_u	$push17=, 1($6)
	i32.const	$push16=, 253
	i32.ne  	$push18=, $pop17, $pop16
	br_if   	0, $pop18       # 0: down to label4
# %bb.10:                               # %lor.lhs.false14
	i32.load8_u	$push20=, 2($6)
	i32.const	$push19=, 251
	i32.ne  	$push21=, $pop20, $pop19
	br_if   	0, $pop21       # 0: down to label4
# %bb.11:                               # %lor.lhs.false19
	i32.load8_u	$push22=, 3($6)
	i32.const	$push47=, 255
	i32.ne  	$push23=, $pop22, $pop47
	br_if   	0, $pop23       # 0: down to label4
# %bb.12:                               # %lor.lhs.false24
	i32.load8_u	$push24=, 4($6)
	i32.const	$push48=, 255
	i32.ne  	$push25=, $pop24, $pop48
	br_if   	0, $pop25       # 0: down to label4
# %bb.13:                               # %lor.lhs.false29
	i32.load8_u	$push27=, 25($6)
	i32.const	$push26=, 254
	i32.ne  	$push28=, $pop27, $pop26
	br_if   	0, $pop28       # 0: down to label4
# %bb.14:                               # %lor.lhs.false34
	i32.const	$push49=, 0
	i32.load	$push29=, cp($pop49)
	i32.const	$push30=, d+30
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label4
# %bb.15:                               # %if.end
	i32.const	$push50=, 0
	call    	exit@FUNCTION, $pop50
	unreachable
.LBB0_16:                               # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
