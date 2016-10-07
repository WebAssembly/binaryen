	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57344-2.c"
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
	i32.const	$push21=, 0
	i64.const	$push0=, 562525691183104
	i64.store	s+8($pop21), $pop0
	block   	
	i32.const	$push20=, 0
	i32.load	$push1=, i($pop20)
	i32.const	$push19=, 0
	i32.gt_s	$push2=, $pop1, $pop19
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$push3=, -3161
	call    	foo@FUNCTION, $pop3
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.load	$push24=, i($pop25)
	tee_local	$push23=, $0=, $pop24
	i32.const	$push22=, 1
	i32.add 	$push4=, $pop23, $pop22
	i32.store	i($pop26), $pop4
	i32.const	$push5=, -1
	i32.gt_s	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label1
# BB#2:                                 # %for.body.for.body_crit_edge.preheader
.LBB1_3:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push39=, 0
	i64.load32_u	$push12=, s+8($pop39)
	i32.const	$push38=, 0
	i64.load16_u	$push9=, s+12($pop38)
	i32.const	$push37=, 0
	i64.load8_u	$push7=, s+14($pop37)
	i64.const	$push36=, 16
	i64.shl 	$push8=, $pop7, $pop36
	i64.or  	$push10=, $pop9, $pop8
	i64.const	$push35=, 32
	i64.shl 	$push11=, $pop10, $pop35
	i64.or  	$push13=, $pop12, $pop11
	i64.const	$push34=, 15
	i64.shl 	$push14=, $pop13, $pop34
	i64.const	$push33=, 42
	i64.shr_s	$push15=, $pop14, $pop33
	i32.wrap/i64	$push16=, $pop15
	call    	foo@FUNCTION, $pop16
	i32.const	$push32=, 0
	i32.const	$push31=, 0
	i32.load	$push30=, i($pop31)
	tee_local	$push29=, $0=, $pop30
	i32.const	$push28=, 1
	i32.add 	$push17=, $pop29, $pop28
	i32.store	i($pop32), $pop17
	i32.const	$push27=, 0
	i32.lt_s	$push18=, $0, $pop27
	br_if   	0, $pop18       # 0: up to label2
.LBB1_4:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.const	$push40=, 0
                                        # fallthrough-return: $pop40
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
