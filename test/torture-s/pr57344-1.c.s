	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57344-1.c"
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
	i32.const	$push23=, 0
	i32.load	$0=, i($pop23)
	i32.const	$push22=, 0
	i64.const	$push0=, 8583460864
	i64.store	$discard=, s+8($pop22), $pop0
	block
	i32.const	$push21=, 0
	i32.gt_s	$push1=, $0, $pop21
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$push2=, -3161
	call    	foo@FUNCTION, $pop2
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.load	$push26=, i($pop27)
	tee_local	$push25=, $0=, $pop26
	i32.const	$push24=, 1
	i32.add 	$push3=, $pop25, $pop24
	i32.store	$discard=, i($pop28), $pop3
	i32.const	$push4=, -1
	i32.gt_s	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label1
.LBB1_2:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push6=, 0
	i64.load32_u	$push10=, s+8($pop6):p2align=3
	i32.const	$push35=, 0
	i64.load8_u	$push7=, s+12($pop35):p2align=2
	i64.const	$push8=, 32
	i64.shl 	$push9=, $pop7, $pop8
	i64.or  	$push11=, $pop10, $pop9
	i64.const	$push12=, 31
	i64.shl 	$push13=, $pop11, $pop12
	i64.const	$push14=, 24
	i64.shr_s	$push15=, $pop13, $pop14
	i64.const	$push16=, 18
	i64.shr_u	$push17=, $pop15, $pop16
	i32.wrap/i64	$push18=, $pop17
	call    	foo@FUNCTION, $pop18
	i32.const	$push34=, 0
	i32.const	$push33=, 0
	i32.load	$push32=, i($pop33)
	tee_local	$push31=, $0=, $pop32
	i32.const	$push30=, 1
	i32.add 	$push19=, $pop31, $pop30
	i32.store	$discard=, i($pop34), $pop19
	i32.const	$push29=, 0
	i32.lt_s	$push20=, $0, $pop29
	br_if   	0, $pop20       # 0: up to label2
.LBB1_3:                                # %for.end
	end_loop                        # label3:
	end_block                       # label1:
	i32.const	$push36=, 0
	return  	$pop36
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


	.ident	"clang version 3.9.0 "
