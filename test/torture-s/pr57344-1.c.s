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
	i32.const	$push18=, 0
	i32.load	$0=, i($pop18)
	i32.const	$push17=, 0
	i64.const	$push0=, 8583460864
	i64.store	$discard=, s+8($pop17), $pop0
	block
	i32.const	$push16=, 0
	i32.gt_s	$push1=, $0, $pop16
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$push2=, -3161
	call    	foo@FUNCTION, $pop2
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.load	$push21=, i($pop22)
	tee_local	$push20=, $0=, $pop21
	i32.const	$push19=, 1
	i32.add 	$push3=, $pop20, $pop19
	i32.store	$discard=, i($pop23), $pop3
	i32.const	$push4=, -1
	i32.gt_s	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label1
.LBB1_2:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push35=, 0
	i64.load32_u	$push8=, s+8($pop35)
	i32.const	$push34=, 0
	i64.load8_u	$push6=, s+12($pop34)
	i64.const	$push33=, 32
	i64.shl 	$push7=, $pop6, $pop33
	i64.or  	$push9=, $pop8, $pop7
	i64.const	$push32=, 31
	i64.shl 	$push10=, $pop9, $pop32
	i64.const	$push31=, 24
	i64.shr_s	$push11=, $pop10, $pop31
	i64.const	$push30=, 18
	i64.shr_u	$push12=, $pop11, $pop30
	i32.wrap/i64	$push13=, $pop12
	call    	foo@FUNCTION, $pop13
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.load	$push27=, i($pop28)
	tee_local	$push26=, $0=, $pop27
	i32.const	$push25=, 1
	i32.add 	$push14=, $pop26, $pop25
	i32.store	$discard=, i($pop29), $pop14
	i32.const	$push24=, 0
	i32.lt_s	$push15=, $0, $pop24
	br_if   	0, $pop15       # 0: up to label2
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
