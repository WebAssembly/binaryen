	.text
	.file	"pr57344-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, -3161
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.end
	#APP
	#NO_APP
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push19=, 0
	i64.const	$push0=, 8583460864
	i64.store	s+8($pop19), $pop0
	block   	
	i32.const	$push18=, 0
	i32.load	$push1=, i($pop18)
	i32.const	$push17=, 0
	i32.gt_s	$push2=, $pop1, $pop17
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %for.body.lr.ph
	i32.const	$push3=, -3161
	call    	foo@FUNCTION, $pop3
	i32.const	$push22=, 0
	i32.load	$0=, i($pop22)
	i32.const	$push21=, 0
	i32.const	$push20=, 1
	i32.add 	$push4=, $0, $pop20
	i32.store	i($pop21), $pop4
	i32.const	$push5=, -1
	i32.gt_s	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label1
# %bb.2:                                # %for.body.for.body_crit_edge.preheader
.LBB1_3:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push32=, 0
	i64.load32_u	$push9=, s+8($pop32)
	i32.const	$push31=, 0
	i64.load8_u	$push7=, s+12($pop31)
	i64.const	$push30=, 32
	i64.shl 	$push8=, $pop7, $pop30
	i64.or  	$push10=, $pop9, $pop8
	i64.const	$push29=, 31
	i64.shl 	$push11=, $pop10, $pop29
	i64.const	$push28=, 24
	i64.shr_s	$push12=, $pop11, $pop28
	i64.const	$push27=, 18
	i64.shr_u	$push13=, $pop12, $pop27
	i32.wrap/i64	$push14=, $pop13
	call    	foo@FUNCTION, $pop14
	i32.const	$push26=, 0
	i32.load	$0=, i($pop26)
	i32.const	$push25=, 0
	i32.const	$push24=, 1
	i32.add 	$push15=, $0, $pop24
	i32.store	i($pop25), $pop15
	i32.const	$push23=, 0
	i32.lt_s	$push16=, $0, $pop23
	br_if   	0, $pop16       # 0: up to label2
.LBB1_4:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.const	$push33=, 0
                                        # fallthrough-return: $pop33
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	4
s:
	.skip	16
	.size	s, 16

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
