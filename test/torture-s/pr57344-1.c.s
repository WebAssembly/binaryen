	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57344-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, -3161
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
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

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i64.const	$push0=, 8583460864
	i64.store	s+8($pop19), $pop0
	block   	
	i32.const	$push18=, 0
	i32.load	$push1=, i($pop18)
	i32.const	$push17=, 0
	i32.gt_s	$push2=, $pop1, $pop17
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$push3=, -3161
	call    	foo@FUNCTION, $pop3
	i32.const	$push24=, 0
	i32.const	$push23=, 0
	i32.load	$push22=, i($pop23)
	tee_local	$push21=, $0=, $pop22
	i32.const	$push20=, 1
	i32.add 	$push4=, $pop21, $pop20
	i32.store	i($pop24), $pop4
	i32.const	$push5=, -1
	i32.gt_s	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label1
# BB#2:                                 # %for.body.for.body_crit_edge.preheader
.LBB1_3:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push36=, 0
	i64.load32_u	$push9=, s+8($pop36)
	i32.const	$push35=, 0
	i64.load8_u	$push7=, s+12($pop35)
	i64.const	$push34=, 32
	i64.shl 	$push8=, $pop7, $pop34
	i64.or  	$push10=, $pop9, $pop8
	i64.const	$push33=, 31
	i64.shl 	$push11=, $pop10, $pop33
	i64.const	$push32=, 24
	i64.shr_s	$push12=, $pop11, $pop32
	i64.const	$push31=, 18
	i64.shr_u	$push13=, $pop12, $pop31
	i32.wrap/i64	$push14=, $pop13
	call    	foo@FUNCTION, $pop14
	i32.const	$push30=, 0
	i32.const	$push29=, 0
	i32.load	$push28=, i($pop29)
	tee_local	$push27=, $0=, $pop28
	i32.const	$push26=, 1
	i32.add 	$push15=, $pop27, $pop26
	i32.store	i($pop30), $pop15
	i32.const	$push25=, 0
	i32.lt_s	$push16=, $0, $pop25
	br_if   	0, $pop16       # 0: up to label2
.LBB1_4:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.const	$push37=, 0
                                        # fallthrough-return: $pop37
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
